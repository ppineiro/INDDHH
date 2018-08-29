var SynchronizeFields = {};


SynchronizeFields.DIRTY = "data-dirty";
SynchronizeFields.SYNC_FAILED = "data-syncFailed";
SynchronizeFields.SYNC_OBSERVER = "data-sync_observer";

var error_xml_str = '<sysExceptions><exception text="No se pueden sincronizar los datos con el serivdor"/></sysExceptions>';
//Parsear XML
if (window.DOMParser) {
	SynchronizeFields.SYNC_ERROR = (new DOMParser()).parseFromString(error_xml_str,"text/xml");
} else {
	// Internet Explorer
	SynchronizeFields.SYNC_ERROR = new ActiveXObject("Microsoft.XMLDOM");
	SynchronizeFields.SYNC_ERROR.async = false;
	SynchronizeFields.SYNC_ERROR.loadXML(error_xml_str);
}


SynchronizeFields.listeners = [];

SynchronizeFields.toSync = function (container, value) {
	
	//Obligamos a sincronizar aunque ya este dirty. Puede que haya un cambio mientras que la variable estaba en dirty
	//if(!container.get(SynchronizeFields.DIRTY) || container.get(SynchronizeFields.DIRTY) == 'false') {
		
		container.set(SynchronizeFields.DIRTY, 'true');
		container.erase(SynchronizeFields.SYNC_FAILED);
		
		SynchronizeFields.syncAJAX(container, value, 3);
	//}
}

SynchronizeFields.checkBeforeSync = function (container_id) {
	
	var container = $(container_id);
	if(container) {
		var element = container.retrieve(Field.STORE_KEY_FIELD);
		if (element.xml.getAttribute("fieldType") == 'input'){
			var result = element.checkBeforeSync();
			if (!result) return false;
		}

	} else {
		var index = 0;		
		var gridSyncArray = [];
		
		container = $(container_id + '_' + index);
		while(container) {
			var element = container.retrieve(Field.STORE_KEY_FIELD);
			if (element.xml.getAttribute("fieldType") == 'input'){
				var result = element.checkBeforeSync();
				if (!result) return false;
			}
			index++;
			container = $(container_id + '_' + index);
		}
	}

	return true;
}

SynchronizeFields.preJSexec = function (container_id) {
	
	SynchronizeFields.listeners = [];
	
	var container = $(container_id);
	if(container) {
		container.set(SynchronizeFields.DIRTY, 'true');
	} else {
		//Campo de grilla
		var index = 0;
		container = $(container_id + '_' + index);
		while(container) {
			container.set(SynchronizeFields.DIRTY, 'true');
			index++;
			container = $(container_id + '_' + index);
		}
	}
	
	//take screenshot
	$$('.AJAXfield').each(function(ele) {
		
		var eleObs = new ElementValueObserver(ele);
		eleObs.addEvent('change', SynchronizeFields.toSync);
		
		SynchronizeFields.listeners.push(eleObs);
	});
}

SynchronizeFields.posJSexec = function(container_id) {
	//check dirties
	SynchronizeFields.listeners.each(function(listener) {
		listener.check();
		listener.removeEvent('change', SynchronizeFields.toSync);
	});
	
	//SINCRONIZAR POR AJAX
	
	var container = $(container_id);
	if(container) {
		var element = container.retrieve(Field.STORE_KEY_FIELD);
		SynchronizeFields.syncAJAX(container, element.getValue(), 3);
	} else {
		//Campo de grilla, se sincronizan todos los indices
		var index = 0;		
		container = $(container_id + '_' + index);
		while(container) {
			var element = container.retrieve(Field.STORE_KEY_FIELD);
			SynchronizeFields.syncAJAX(container, element.getValue(), 3);
			index++;
			container = $(container_id + '_' + index);
		}
	}
}


/**
 * Invocado solo cuando no se tiene una funcion JS, pero si Java
 */
SynchronizeFields.preJAVAexec = function(container_id) {
	
	var container = $(container_id);
	if(container) {
		container.set(SynchronizeFields.DIRTY, 'true');
		
		var element = container.retrieve(Field.STORE_KEY_FIELD);
		SynchronizeFields.syncAJAX(container, element.getValue(), 3);
	} else {
		//Campo de grilla
		var index = 0;
		container = $(container_id + '_' + index);
		while(container) {
			container.set(SynchronizeFields.DIRTY, 'true');
			index++;
			container = $(container_id + '_' + index);
		}
		
		//Campo de grilla, se sincronizan todos los indices
		index = 0;		
		container = $(container_id + '_' + index);
		while(container) {
			var element = container.retrieve(Field.STORE_KEY_FIELD);
			SynchronizeFields.syncAJAX(container, element.getValue(), 3);
			index++;
			container = $(container_id + '_' + index);
		}
	}
}


SynchronizeFields.fields_to_sync = [];
SynchronizeFields.blocked = false;

SynchronizeFields.syncJAVAexec = function (fnc_java, dontShowLoading) {
	
	//Bloquear pantalla: evitamos que mas campos necesiten sincronizarse
	if(!dontShowLoading)
		SYS_PANELS.showLoading();
	
	SynchronizeFields.fields_to_sync = [];
	
	SynchronizeFields.java_fnc = fnc_java;
	
	SynchronizeFields.blocked = true;
	
	$$('.AJAXfield').each(function(ele) {
		//var container = ele.getParent('div');
		var container = ele;
		if(container.get(SynchronizeFields.DIRTY)) {
			//Se esta sincronizando
			
			SynchronizeFields.fields_to_sync.push(container);
			container.set(SynchronizeFields.SYNC_OBSERVER, 'true');
			
		} else if (container.get(SynchronizeFields.SYNC_FAILED)) {
			//Fallo la sincronizacion
			//container.erase('syncFailed');
			
			SynchronizeFields.fields_to_sync.push(container);
			container.set(SynchronizeFields.SYNC_OBSERVER, 'true');
			
			//SynchronizeFields.toSync(container, ele.get('value'));
			var element = container.retrieve(Field.STORE_KEY_FIELD);
			SynchronizeFields.toSync(container, element.getValue());
		}
	});
	
	if(!SynchronizeFields.fields_to_sync.length)
		fnc_java();
	
	SynchronizeFields.blocked = false;
}

SynchronizeFields.syncJAVAcallback = function(container) {
	
	if(SynchronizeFields.blocked) {
		 setTimeout(function() {
			 SynchronizeFields.syncJAVAcallback(container);
		 },20);
		 return;
	}
	
	SynchronizeFields.blocked = true;
		
	container.erase(SynchronizeFields.SYNC_OBSERVER);
	SynchronizeFields.fields_to_sync.erase(container);
	
	if(!SynchronizeFields.fields_to_sync.length) {
		SynchronizeFields.java_fnc();
	}
	
	SynchronizeFields.blocked = false;
}

SynchronizeFields.sync_counter = 0;

SynchronizeFields.syncAJAX = function(container, value, retries) {
	
	if(!retries) {
		container.erase(SynchronizeFields.DIRTY);
		container.set(SynchronizeFields.SYNC_FAILED, 'true');
		
		if(container.get(SynchronizeFields.SYNC_OBSERVER)) {
			processXmlExceptions(SynchronizeFields.SYNC_ERROR);
		}
		
		return;
	}
	
	var element = container.retrieve(Field.STORE_KEY_FIELD);
	
	if(element.options[Field.PROPERTY_DISABLED] || element.options[Field.PROPERTY_INPUT_AS_TEXT]
		|| element.form.readOnly) {
		
		//Dar como sincronizado aunque no se actualiza el server
		container.erase(SynchronizeFields.DIRTY);
    	
    	if(container.get(SynchronizeFields.SYNC_OBSERVER)) {
    		SynchronizeFields.syncJAVAcallback(container);
    	}
    	return;
	}
	
	var frmParent = element.frmId;
	var frmId = element.frmId;
	var frmStrSplited = frmId.split('_');
	if(frmStrSplited.length > 1) {
		frmParent = frmStrSplited[0];
		frmId = frmStrSplited[1];
		
		if(element.form.isGridEditionForm) {
			frmParent += '&editionMode=true';
		}
		
		if(element.lang_id)
			frmParent += '&langId=' + element.lang_id;
	}
	var attId = element.attId;
	if(!attId) {
		//El campo no tiene atributo, no debe ser sincronizado. Simulamos onSuccess
		container.erase(SynchronizeFields.DIRTY);
    	if(container.get(SynchronizeFields.SYNC_OBSERVER)) {
    		SynchronizeFields.syncJAVAcallback(container);
    	}
    	return;
	}
	
	var timestamp = new Date().getTime();
	
	var val_to_server = '';
	if(typeOf(value) == 'array') {
		
		if(value.length > 5 && value[0].length > 200) {
			//Dividimos el request en partes de a 5 en lugar de mandarlo de forma normal
			SynchronizeFields.syncAJAXMulti(container, frmId, frmParent, attId, value, 0, 3);
			
			return;
		}
		
		value.each(function(val) {
			val_to_server += '&value=' + encodeURIComponent(val);
		});
		
		//Clear de los atributos anteriores
		val_to_server += '&clearValues=true';
	} else {
		val_to_server = '&value=' + encodeURIComponent(value);
	}
	
	var myRequest = new Request({
		url: 'apia.execution.FormAction.run?action=processFieldSubmit&isAjax=true&frmId=' +  frmId + '&frmParent=' + frmParent + '&timestamp=' + timestamp + '&attId=' + attId + '&index=' + (element.index ? element.index : '0') + TAB_ID_REQUEST,
	    
		async: element.force_synchronous ? false : true,
			
		onSuccess: function(responseText, responseXML) {
			var res = responseXML.getElementsByTagName('result');
	    	//AJAX exitoso
	    	//if(responseXML && responseXML.childNodes && responseXML.childNodes.length && responseXML.childNodes[Browser.ie ? 1 : 0].tagName == 'result') {
			if(res && res.length) {
	    		//if(responseXML.childNodes[Browser.ie ? 1 : 0].getAttribute('success')) {
				if(res[0].getAttribute('success')) {
	    			//Sincronizacion exitosa
	    	    	container.erase(SynchronizeFields.DIRTY);
	    	    	
	    	    	if(container.get(SynchronizeFields.SYNC_OBSERVER)) {
	    	    		SynchronizeFields.syncJAVAcallback(container);
	    	    	}
	    		} else {
	    			SynchronizeFields.syncAJAX(container, value, retries - 1);
	    		}
	    	} else {
	    		SynchronizeFields.syncAJAX(container, value, retries - 1);
	    	}
	    },
	    
	    onFailure: function(xhr) {
	    	SynchronizeFields.syncAJAX(container, value, retries - 1);
	    }
	});
	
	//var val_to_server2 = val_to_server.substring(1);
	var val_to_server2;
	if(val_to_server) val_to_server2 = val_to_server.substring(1);
	
	myRequest.send(val_to_server2);
}


SynchronizeFields.syncAJAXMulti = function(container, frmId, frmParent, attId, value, id, retries) {
	if(!retries) {
		container.erase(SynchronizeFields.DIRTY);
		container.set(SynchronizeFields.SYNC_FAILED, 'true');
		
		if(container.get(SynchronizeFields.SYNC_OBSERVER)) {
			processXmlExceptions(SynchronizeFields.SYNC_ERROR);
		}
		
		return;
	}
	
	var val_to_server = '';
	
	if(id == 0)
		val_to_server += '&clearValues=true';
	
	for(var i = id; i < id + 5 && i < value.length; i++) {
		val_to_server += '&value=' + encodeURIComponent(value[i]);
	}

	var last = false;
	if(i == value.length) {
		//No quedan mas valores para mandar, esta es la ultima iteracion
		last = true;
	}
	
	var myRequest = new Request({	    
		url: 'apia.execution.FormAction.run?action=processFieldSubmit&isAjax=true&frmId=' +  frmId + '&frmParent=' + frmParent + '&timestamp=' + (new Date().getTime()) + '&attId=' + attId + /*val_to_server +*/ '&index=' + id + TAB_ID_REQUEST,
	    
		onSuccess: function(responseText, responseXML) {
			var res = responseXML.getElementsByTagName('result');
	    	//AJAX exitoso
	    	//if(responseXML && responseXML.childNodes && responseXML.childNodes.length && responseXML.childNodes[Browser.ie ? 1 : 0].tagName == 'result') {
			if(res && res.length) {
	    		//if(responseXML.childNodes[Browser.ie ? 1 : 0].getAttribute('success')) {
				if(res[0].getAttribute('success')) {
	    			//Sincronizacion exitosa	    			
	    			if(last) {	    			
		    	    	container.erase(SynchronizeFields.DIRTY);
		    	    	
		    	    	if(container.get(SynchronizeFields.SYNC_OBSERVER)) {
		    	    		SynchronizeFields.syncJAVAcallback(container);
		    	    	}
	    			} else {
	    				//Llamar recursivamente
	    				SynchronizeFields.syncAJAXMulti(container, frmId, frmParent, attId, value, id + 5, 3);
	    			}
	    		} else {
	    			//SynchronizeFields.syncAJAX(container, value, retries - 1);
	    			SynchronizeFields.syncAJAXMulti(container, frmId, frmParent, attId, value, id, retries - 1);
	    		}
	    	} else {
	    		//SynchronizeFields.syncAJAX(container, value, retries - 1);
	    		SynchronizeFields.syncAJAXMulti(container, frmId, frmParent, attId, value, id, retries - 1);
	    	}
	    },
	    
	    onFailure: function(xhr) {
	    	//SynchronizeFields.syncAJAX(container, value, retries - 1);
	    	SynchronizeFields.syncAJAXMulti(container, frmId, frmParent, attId, value, id, retries - 1);
	    }
	});
	
	//myRequest.send();
	var val_to_server2;
	if(val_to_server) val_to_server2 = val_to_server.substring(1);
	
	myRequest.send(val_to_server2);
}

/**
 * Observar cambios en el los valores de los campos luego de ejecutar una clase JS
 */
var ElementValueObserver = new Class({

	Implements: [Events],

	initialize: function(element) {			    
		this.container = $(element);
		this.element = this.container.retrieve(Field.STORE_KEY_FIELD);
		this.val = this.element.getValue();
	},
	
	check: function() {
		var newValue = this.element.getValue();
		if(typeOf(newValue) == 'array') {
			if(this.val.length == newValue.length) {
				var i;
				for(i = 0; i < this.val.length; i++) {
					if(this.val[i] != newValue[i])
						break;
				}
				if(i < this.val.length) {
					this.fireEvent('change', [this.container, newValue]); //container, newValue
				}
			} else {
				this.fireEvent('change', [this.container, newValue]); //container, newValue
			}
		} else {
			if(this.val != newValue)
				this.fireEvent('change', [this.container, newValue]); //container, newValue
		}
	}
});


/**
 * Actualizar valores cambiados por clases de negocio ejecutadas por ajax
 */
SynchronizeFields.updateClientValues = function (response) {
	for(var i1 = 0; i1 < response.childNodes.length; i1++) {
		var form = response.childNodes[i1];
		var i;
		
		if(form.tagName == "data") {
			//Mensajes de excepcion
			if(form.childNodes && form.childNodes.length)
				modalProcessXml(form);
			continue;
		}
		
		if(form.tagName == "z") {
			fldId_focus = form.getAttribute("id");
			var idx = form.getAttribute("idx");
			if($(fldId_focus)){
				if($(fldId_focus).getElements("input") && $(fldId_focus).getElements("input").length >0){
					$(fldId_focus).getElements("input")[0].focus();
				}
				if($(fldId_focus).getElements("select") && $(fldId_focus).getElements("select").length >0){
					$(fldId_focus).getElements("select")[0].focus();
				}
			} else {
				
				if($(fldId_focus+"_"+idx)){
					if($(fldId_focus+"_"+idx).getElements("input") && $(fldId_focus+"_"+idx).getElements("input").lenght>0){
						$(fldId_focus+"_"+idx).getElements("input")[0].focus();
					}
					if($(fldId_focus+"_"+idx).getElements("select") && $(fldId_focus+"_"+idx).getElements("select").length>0){
						$(fldId_focus+"_"+idx).getElements("select")[0].focus();
					}
				}
				
			}
			continue;
		}
		
		if(form.tagName == "p") {
			//Datos de proceso
			var cmbProPri = $('cmbProPri');
			//var selCal = $('selCal');
			if(cmbProPri) cmbProPri.set('value', form.getAttribute("p"));
			//if(selCal) selCal.set('value', form.getAttribute("c"));
			
			if(form.childNodes && form.childNodes.length) {
				var tbody = $('tblComment').getElement('tbody');
				
				for(i = 0; i < form.childNodes.length; i++) {
					var obs = form.childNodes[i];
					var comm_id = obs.getAttribute("i");
					var reg_date = obs.getAttribute("d");
					var user = obs.getAttribute("u");
					var reguser = obs.getAttribute("r");
					var group = obs.getAttribute("g");
					var task = obs.getAttribute("t");
					var checked = obs.getAttribute("c") == "true";
					var comment = obs.childNodes[0].textContent;
					
					if(reguser == CURRENT_USER_LOGIN)
						replaceComment(comment);
					else
						appendComment(comm_id, checked, reg_date, user, group, task, comment);
				}
			}
			
			continue;
		}
		if(form.tagName == "e") {
			//Datos de entidad
			var busEntSta = $('busEntSta');
			if(busEntSta) busEntSta.set('value', form.getAttribute("s"));
			continue;
		}
		
		var form_id = form.getAttribute("i");
		var frm_src = null;
		if(form_id.substring(0, 1) == "E")
			for(i = 0; i < executionEntForms.length; i++) {
				if(executionEntForms[i].id == form_id) {
					frm_src = executionEntForms[i];
					break;
				}
			}
		else			
			for(i = 0; i < executionProForms.length; i++) {
				if(executionProForms[i].id == form_id) {
					frm_src = executionProForms[i];
					break;
				}
			}
		
		
		if(!frm_src) {
			//El formulario no esta en pantalla
			continue;
		}
		
		//Formulario invisible
		if(form.getAttribute("v") == "t" && frm_src.options[Form.PROPERTY_FORM_HIDDEN] != "true") {
			frm_src.hideForm();
		} else if (form.getAttribute("v") == "f" && frm_src.options[Form.PROPERTY_FORM_HIDDEN] == "true"){
			frm_src.showForm();
		}
			
		//Formulario cerrado
		if(form.getAttribute("c") == "t" && frm_src.options[Form.PROPERTY_FORM_CLOSED] != "true") {
			frm_src.expandIconClick(true);
		} else if (form.getAttribute("c") == "f" && frm_src.options[Form.PROPERTY_FORM_CLOSED] == "true") {
			frm_src.expandIconClick(true);
		}
		
		//Tengo el formulario. Recorrer los <b> y encontrar para el formulario el campo
		for(i = 0; i < form.childNodes.length; i++) {
			if(frm_src.fields) {
				var fldId = form.childNodes[i].getAttribute("i");
				var fld_src = null;
				//TODO: Esto no itera en los campos de las grillas
				for(var i2 = 0; i2 < frm_src.fields.length; i2++) {
					if(frm_src.fields[i2].fldId == fldId) {
						fld_src = frm_src.fields[i2];
						break;
					}
				}
				
				if(!fld_src) {
					//TODO: ERROR el campo no esta en pantalla
					continue;
				}
				
				if(form.childNodes[i].getAttribute("r")) {
					//Recargar campo
					if(!fld_src.dontReload)
						fld_src.forceAjaxReload(form.childNodes[i]);
					continue;
				}
				
				var values = form.childNodes[i].childNodes[0];
				var prps = form.childNodes[i].childNodes[1];
				var posVals = form.childNodes[i].childNodes[2];
				
				var src_values = [];
				
				if(values.childNodes.length > 1)
					for(i2 = 0; i2 < values.childNodes.length; i2++) {
						src_values.push(values.childNodes[i2].getAttribute("v"));
					}
				else if(values.childNodes.length == 1)
					src_values = values.childNodes[0].getAttribute("v");
				else
					src_values = null;
				
				if(posVals) {
					if(fld_src.apijs_clearOptions && fld_src.apijs_addOption) {
						
						var js_values = null;
						//Mantener el valor seleccionado
						if(src_values == null && values.getAttribute("k") == "t")
							js_values = fld_src.apijs_getFieldValue();
						
						
						fld_src.apijs_clearOptions();
						
						for(i2 = 0; i2 < posVals.childNodes.length; i2++) {
							fld_src.apijs_addOption(posVals.childNodes[i2].getAttribute("v"), posVals.childNodes[i2].getAttribute("t"));
						}
						
						if(js_values)
							fld_src.apijs_setFieldValue(js_values);
						
					} else {
						//TODO: ERROR el campo no acepta cambio de valores posibles
					}
				}
				
				if(src_values == null) {
					//if(fld_src.apijs_clearValue && fld_src.xml.getAttribute("fieldType") != "label" && fld_src.xml.getAttribute("fieldType") != "title") {
					if(fld_src.apijs_clearValue && values.getAttribute("k") != "t") {
						fld_src.apijs_clearValue();
					} else {
						//TODO: ERROR el campo no permite limpiar el valor
					}
				} else {
					if(fld_src.apijs_setFieldValue) {
						if(frm_src.isGridEditionForm) {
							if(Array.isArray(src_values)){
								fld_src.apijs_setFieldValue(src_values[fld_src.index]);	
							} else {
								fld_src.apijs_setFieldValue(src_values);	
							}
						} else { 
							fld_src.apijs_setFieldValue(src_values);
						}
					} else {
						//TODO: ERROR el campo no permite setearle el valor
					}
				}
				
				if(fld_src.apijs_setProperty) {
					for(i2 = 0; i2 < prps.childNodes.length; i2++) {
						fld_src.apijs_setProperty(prps.childNodes[i2].getAttribute("i"), prps.childNodes[i2].getAttribute("v"));
					}
				} else {
					//TODO: ERROR el campo no acepta el seteo de propieades
				}
			}
		}		
	}
}