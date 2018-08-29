function initActionsTab(mode) {

	
	if (mode == INSERT_MODE) {
		
	}else {
		loadActionZones();
	}
	
	//Seteamos la acci�n de boton agregar acciones
	var btnAddZoneAction = $('btnAddZoneAction');
	if (btnAddZoneAction){
		btnAddZoneAction.addEvent("click",function(e){
			e.stop();
			btnAddZoneAction_click();
		});
	}
	
	//Seteamos la acci�n de boton eliminar info de la grilla de acciones
	var btnDelZoneAction = $('btnDelZoneAction');
	if (btnDelZoneAction){
		btnDelZoneAction.addEvent("click",function(e){
			e.stop();
			var count = selectionCount($('gridZoneActions'));
			if(count==0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (count>1){
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			}else{
				fncZoneChanged();
				deleteRow('gridZoneActions');
				Scroller1 = addScrollTable($('gridZoneActions')); //Actualizamos el scroll de la grilla de acciones de las zonas
			} 
		});
	}
	
	//Seteamos la accion del boton de subir en la grilla de acciones zonas
	var btnUpZoneAction = $('btnUpZoneAction');
	if (btnUpZoneAction) {
		btnUpZoneAction.addEvent("click", function(e){
			e.stop();
			var row = upRow('gridZoneActions');
			if (row != null && Scroller1 != null && Scroller1.v != null){
				Scroller1.v.showElement(row);
			}
		});
	}
	
	//Seteamos la accion del boton de bajar en la grilla de zonas
	var btnDownZoneAction = $('btnDownZoneAction');
	if (btnDownZoneAction) {
		btnDownZoneAction.addEvent("click", function(e){
			e.stop();
			var row = downRow('gridZoneActions');
			if (row != null && Scroller1 != null && Scroller1.v != null){
				Scroller1.v.showElement(row);
			}
		});
	}
	
	var gbm = $('gridBodyInfoA');
	if(gbm)
		gbm.addEvent('custom_scroll', function(left) {
			$('extraInfoTableA').getElement('div.gridHeader').getElement('table').setStyle('left', left);
		});
	
}

var currentDiv; //Utilizada para guardar el div de las acciones de las zonas

function btnAddZoneAction_click() {
	
	if ($('gridZones').rows.length == 0){ //Si no se definieron zonas
		showMessage(MSG_NO_ZNE_DEFINED, null, 'modalWarning');
		return;
	}
	
	fncAddZoneAction(); //Agregamos una fila vacia
	Scroller1 = addScrollTable($('gridZoneActions')); //Agregamos el scroll de la grilla de acciones de las zonas
	if (Scroller1 != null && Scroller1.v != null){
		var allRows = $('gridZoneActions').getElements("tr");
		if (allRows.length > 0){ Scroller1.v.showElement(allRows[allRows.length-1]); }
	}
}

function loadActionZones() {
	var request = new Request({
		method: 'post',			
		url: CONTEXT + URL_REQUEST_AJAX+'?action=getWidgetActionZones&isAjax=true' + TAB_ID_REQUEST,
		onComplete: function(resText, resXml) {
			loadActionZonesXML(resXml);  
			
			var table = $('gridBodyInfoA'); var footer = $('btnDelZoneAction');
			var notification = new Element('div', {id : 'editionNot'}); 
			footer.grab(notification, "top");
			initAdminModalHandlerOnChangeHighlight(table, false, false, notification);
		}
	}).send();
}

/* <result>
* 	<actions>
*     <action name="zone1" action="1" busClaId="1025" busClaName="CLASE1" params="1001;3;1002;lala" busClaParBndId="3221" repeat="1"/>  //<--- clase de negocio
*     <action name="zone2" action="2" busClaId="1002" busClaName="1001" params="" busClaParBndId="" repeat="2"/>  //<--- proceso
*     <action name="zone3" action="3" busClaId="34" params="" busClaParBndId="" repeat="1"/>  //<--- mail
*     <action name="zone4" action="4" busClaId="35" params="" busClaParBndId="" repeat="5"/>  //<--- notificacion
*     ..
*     <action name="" action="" execute="" repeat=""""/>
*  </actions> 
* </result>
*/
function loadActionZonesXML(ajaxCallXml){
	if (ajaxCallXml != null) {
		var actions = ajaxCallXml.getElementsByTagName("actions");
		if (actions != null && actions.length > 0 && actions.item(0) != null) {
			actions = actions.item(0).getElementsByTagName("action");
			for(var i = 0; i < actions.length; i++) {
				var action = actions.item(i);
				
				var zneName = action.getAttribute("name");
				var zneAction = action.getAttribute("action");
				var busClaId = action.getAttribute("busClaId");
				var busClaName = action.getAttribute("busClaName");
				var params = action.getAttribute("params");
				var busClaParBndId = action.getAttribute("busClaParBndId");
				var repeat = action.getAttribute("repeat");
				
				fncAddZoneAction(zneName, zneAction, busClaId, busClaName, params, busClaParBndId, repeat);
			}
		}
	}
}

//Agrega una acci�n en la grilla de acciones de cada zona
function fncAddZoneAction (zneNameAction, action, busClaId, busClaName, params, busClaParBndId, repeat) {
	
	if (zneNameAction==null) fncZoneChanged(); //Si se agrego una accio marcamos como que hubo un cambio en las zonas
	
	var tdWidths =  getGridHeaderWidths('gridZoneActions');
	
	var oTd0 = new Element("TD"); //Nombre de la zona
	var oTd1 = new Element("TD"); //Accion
	var oTd2 = new Element("TD"); //Clase de negocio o proceso asociado y/o params
	var oTd3 = new Element("TD"); //Repetir 
	
	//-------> Zona
	var div = new Element('div', {styles: {width: tdWidths[0], overflow: 'hidden', 'whiteSpace': 'pre','text-align':'center'}});
	var tdWidth = Number.from(tdWidths[0]) - 5;
	var selector = new Element('select', {name:'selZone'}).setStyle('width', tdWidth);
	selector.addEvent("change",function(e){
		fncZoneChanged()
	});
	
	var trows= $('gridZones').rows;
	for (i=0;i<trows.length;i++) {
		zneName = trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[0].value;
		var optionDOM = new Element('option');
		optionDOM.set('value',zneName);
		if (zneNameAction!=null && zneName == zneNameAction) optionDOM.set('selected', 'selected');
		optionDOM.appendText(zneName);
		optionDOM.inject(selector);
	}
	
	selector.inject(div);
	
	div.inject(oTd0);
	
	//-------> Accion de la zona
	if (action==null) action = WID_KPI_ACTION_BUS_CLASS_EXECUTION;
	
	div = new Element('div', {styles: {width: tdWidths[1], overflow: 'hidden', 'whiteSpace': 'pre','textAlign':'center'}});
	tdWidth = tdWidths[1].substring(0, tdWidths[1].indexOf('px')) - 5;
	selector = new Element('select',{name:'selAction'}).setStyle('width', tdWidth);
	selector.addEvent("change",function(e){
		cmbActZne_change(this); 
		fncZoneChanged()
	});
	
	var optionDOM = new Element('option');
	optionDOM.set('value', WID_KPI_ACTION_BUS_CLASS_EXECUTION);
	optionDOM.appendText(LBL_EXE_BUS_CLASS);
	if (action==WID_KPI_ACTION_BUS_CLASS_EXECUTION) optionDOM.set('selected','selected');
	optionDOM.inject(selector);
	
	optionDOM = new Element('option');
	optionDOM.set('value', WID_KPI_ACTION_START_PROCESS);
	optionDOM.appendText(LBL_START_PROCESS);
	if (action==WID_KPI_ACTION_START_PROCESS) optionDOM.set('selected','selected');
	optionDOM.inject(selector);
	
	optionDOM = new Element('option');
	optionDOM.set('value', WID_KPI_ACTION_SEND_EMAIL);
	optionDOM.appendText(LBL_SEND_EMAIL);
	if (action==WID_KPI_ACTION_SEND_EMAIL) optionDOM.set('selected','selected');
	optionDOM.inject(selector);
	
	optionDOM = new Element('option');
	optionDOM.set('value', WID_KPI_ACTION_SEND_NOTIFICATION);
	optionDOM.appendText(LBL_SEND_NOTIFICATION);
	if (action==WID_KPI_ACTION_SEND_NOTIFICATION) optionDOM.set('selected','selected');
	optionDOM.inject(selector);
	
	selector.inject(div);
	div.inject(oTd1);
	
	//-------> Ejecutar
	if (action==WID_KPI_ACTION_BUS_CLASS_EXECUTION) div = createExeBusClaAction(busClaId, busClaName, params, busClaParBndId);
	if (action==WID_KPI_ACTION_START_PROCESS) div = createInitProcessAction(busClaId, busClaName, params, busClaParBndId);
	if (action==WID_KPI_ACTION_SEND_EMAIL) div = createSendEmailAction(busClaId, params, busClaParBndId);
	if (action==WID_KPI_ACTION_SEND_NOTIFICATION) div = createNotificationAction(busClaId, params, busClaParBndId);
	
	div.inject(oTd2);
	
	//-------> Ejecutar la primera vez y luego de repetirse
	div = new Element('div', {styles: {width: tdWidths[3], overflow: 'hidden', 'whiteSpace': 'pre','textAlign':'left'}});
	var input = new Element('input',{type:'text', name:'zneRepTimes'});
	input.set('class', 'numeric');
	input.addEvent("change",function(e){
		changRepTimes(this);
		fncZoneChanged()
	});
	if (repeat==null) repeat= '1';
	input.set('value', repeat);
	input.setStyle('width',  25);
	input.inject(div);
	var label = new Element('label');
	label.set('text', LBL_TIMES);
	label.inject(div);
	div.inject(oTd3);
	
	var oTr = new Element("TR");
	
	oTd0.inject(oTr);
	oTd1.inject(oTr);
	oTd2.inject(oTr);
	oTd3.inject(oTr);
	
	oTr.addClass("selectableTR");
	oTr.getRowId = function () { return this.getAttribute("rowId"); };
	oTr.setRowId = function (a) { this.set("rowId",a); };
	oTr.set("rowId", $('gridZoneActions').rows.length);
	
	oTr.addEvent("click",function(e){myToggle(this)}); 
	
	if($('gridZoneActions').rows.length%2==0){
		oTr.addClass("trOdd");
	}
	
	oTr.inject($('gridZoneActions'));
	
	return oTr;
}

//Crea el div para la acci�n de Ejecutar clase de negocio
function createExeBusClaAction(busClaId, busClaName, params, busClaParBndId){
	var tdWidths =  getGridHeaderWidths('gridZoneActions');
	var tdWidth = tdWidths[2];
	
	var div = new Element('div', {styles: {width: tdWidth, overflow: 'hidden', 'whiteSpace': 'pre','textAlign':'left'}});
	var input = new Element('input',{type:'text', name:'busClaName'});
	if (busClaName==null) busClaName= '';
	input.set('value', busClaName);
	input.set('disabled', true);
	input.setStyle('width',  Number.from(tdWidth)/2);
	input.inject(div);
	
	var span = new Element('span', {styles:{verticalAlign: 'bottom'}}); 
	var img1 = new Element('img', {styles: {width: 17, height:16, marginLeft: 2, marginRight: 2, cursor: 'pointer'}, src: btnParsBlue}).inject(span);
	img1.addEvent("click",function(e){
		openBusClaModal(this);
		fncZoneChanged();
	});
	img1.set('title', LBL_SEL_BUS_CLASS);
	
	var img2 = new Element('img', {styles: {width: 17, height:16, marginLeft: 2, marginRight: 2, cursor: 'pointer'}, src: btnParsRed}).inject(span);
	img2.addEvent("click",function(e){
		openZneBusClaParModal(this);
		fncZoneChanged();
	});
	img2.set('title', LBL_SEL_BUS_CLASS_PARAMS);
	
	span.inject(div);
	var ele1 = new Element('input',{type:'hidden', name:'hidZneBusClaId'}).inject(div);
	if (busClaId!=null) ele1.set('value', busClaId);
	var ele2 = new Element('input',{type:'hidden', name:'hidZneBusClaParams'}).inject(div);
	if (params!=null) ele2.set('value', params);
	var ele3 = new Element('input',{type:'hidden', name:'hidZneBusClaParBndId'}).inject(div);
	if (busClaParBndId!=null) ele3.set('value', busClaParBndId);
	
	return div;
}

//Crea el div para la acci�n de Iniciar proceso
function createInitProcessAction(busClaId, busClaName, params, busClaParBndId){
	var tdWidths =  getGridHeaderWidths('gridZoneActions');
	var tdWidth = tdWidths[2];
	
	var div = new Element('div', {styles: {width: tdWidth, overflow: 'hidden', 'whiteSpace': 'pre','textAlign':'left'}});
	var input = new Element('input',{type:'text', name:'proName'});
	if (busClaName==null) busClaName= '';
	input.set('value', busClaName);
	input.set('disabled', true);
	input.setStyle('width',  Number.from(tdWidth)/2);
	input.inject(div);
	
	var span = new Element('span', {styles:{verticalAlign: 'bottom'}});
	var img1 = new Element('img', {styles: {width: 17, height:16, marginLeft: 2, marginRight: 2, cursor: 'pointer'}, src: btnParsBlue}).inject(span);
	img1.addEvent("click",function(e){
		openProcessModal(this);
		fncZoneChanged();
	});
	img1.set('title', LBL_SEL_PROCESS);
	
	var img2 = new Element('img', {styles: {width: 17, height:16, marginLeft: 2, marginRight: 2, cursor: 'pointer'}, src: btnParsRed}).inject(span);
	img2.addEvent("click",function(e){
		openAttModal(this,'value');
		fncZoneChanged();
	});
	img2.set('title', LBL_SEL_ATT_WID_VALUE);
	var img3 = new Element('img', {styles: {width: 17, height:16, marginLeft: 2, marginRight: 2, cursor: 'pointer'}, src: btnParsRed}).inject(span);
	img3.addEvent("click",function(e){
		openAttModal(this,'widName');
		fncZoneChanged();
	});
	img3.set('title', LBL_SEL_ATT_WID_NAME);
	var img4 = new Element('img', {styles: {width: 17, height:16, marginLeft: 2, marginRight: 2, cursor: 'pointer'}, src: btnParsRed}).inject(span);
	img4.addEvent("click",function(e){
		openAttModal(this,'widZneName');
		fncZoneChanged();
	});
	img4.set('title', LBL_SEL_ATT_WID_ZNE_NAME);
	
	span.inject(div);
	var ele1 = new Element('input',{type:'hidden', name:'hidZneBusClaId'}).inject(div);
	if (busClaId!=null) ele1.set('value', busClaId);
	var ele2 = new Element('input',{type:'hidden', name:'hidZneBusClaParams'}).inject(div);
	if (params!=null) ele2.set('value', params);
	var ele3 = new Element('input',{type:'hidden', name:'hidZneBusClaParBndId'}).inject(div);
	if (busClaParBndId!=null) ele3.set('value', busClaParBndId);
	
	return div;
}

//Crea el div para la acci�n de enviar email
function createSendEmailAction(busClaId, params, busClaParBndId){
	var tdWidths =  getGridHeaderWidths('gridZoneActions');
	var tdWidth = tdWidths[2];
	
	var div = new Element('div', {styles: {width: tdWidth, overflow: 'hidden', 'whiteSpace': 'pre','textAlign':'left'}});
	
	var span = new Element('span', {styles:{verticalAlign: 'bottom'}});
	var img1 = new Element('img', {styles: {width: 17, height:16, marginLeft: 2, marginRight: 2, cursor: 'pointer'}, src: btnParsBlue}).inject(span);
	img1.addEvent("click",function(e){
		openMessageModal(this,'SUBJECT');
		fncZoneChanged();
	});
	img1.set('title', LBL_SUBJECT);
	var img2 = new Element('img', {styles: {width: 17, height:16, marginLeft: 2, marginRight: 2, cursor: 'pointer', marginTop: 5}, src: btnParsBlue}).inject(span);
	img2.addEvent("click",function(e){
		openMessageModal(this,'MESSAGE');
		fncZoneChanged();
	});
	img2.set('title', LBL_MESSAGE);
	span.inject(div);
	
	//Inputs ocultos con los valores seleccionados
	var ele1 = new Element('input',{type:'hidden', name:'hidZneBusClaId'}).inject(div);
	ele1.setStyle('width',  1);
	ele1.set('value', WID_KPI_BUS_CLA_SEND_EMAIL_ID);
	var ele2 = new Element('input',{type:'hidden', name:'hidZneBusClaParams'}).inject(div);
	ele2.setStyle('width',  1);
	if (params!=null) ele2.set('value', params);
	var ele3 = new Element('input',{type:'hidden', name:'hidZneBusClaParBndId'}).inject(div);
	ele3.setStyle('width',  1);
	if (busClaParBndId!=null) ele3.set('value', busClaParBndId);
	
	//Container con los grupos
	var divContainer = new Element('div', {styles: {marginLeft: 50}});
	divContainer.set('id', 'poolsContainter');
	divContainer.setStyle('margin-top', '-24px');
	divContainer.set('class', 'modalOptionsContainer');
	divContainer.onRemove = function(e){
			//Recuperamos los inputs ocultos de la fila seleccionada
			var inputs = this.getParent().getElementsByTagName("INPUT");
			var divBtns = this.childNodes;
			
			//Removemos el pool seleccionado
			var params = inputs[1].value;
			var msgBody = getValInPos(0, params, "#");
			var msgSubj = getValInPos(1, params, "#");
			
			var i= 0;
			var pools = "";
			while (divBtns && divBtns[i]) {
                var poolId = divBtns[i].get('id');
                var poolName = divBtns[i].innerHTML.substring(0,divBtns[i].innerHTML.indexOf("<input"));
                if (poolId!="zneActAddPool"){
                	if (pools=="") pools = poolId + "," + poolName;
                	else pools = "," + poolId + "," + poolName;
                }
                i++;
			}
			
			inputs[1].set('value', msgBody + "#" + msgSubj + "#" + pools);

	}
	
	if (params){
		var pools = getValInPos(2, params, "#");//2312,AAAAA,3242,BBBBB,3432,CCCC..
		if (pools!=""){ //Agregamos todos los grupos
			var poolsArr = pools.split(',');
			for (var i=0; i<poolsArr.length; i=i+2) {
				var poolId = poolsArr[i];
				var poolName = poolsArr[i+1];
				
				addActionElement(divContainer, poolName, poolId, "hidPool");
			}
		} 
	}
		
	//Boton de agregar
	var divEle = new Element('div');
	divEle.set('id','zneActAddPool');
	divEle.set('title', LBL_POOLS_TOOLTIP);
	divEle.set('class', 'element');
	divEle.set('data-helper', true);
	divEle.addEvent("click", function(e) {
		e.stop();
		//setear variables de configuracion del modal de grupos
		POOLMODAL_SHOWAUTOGENERATED = true;
		POOLMODAL_SHOWNOTAUTOGENERATED = true;
		POOLMODAL_SHOWGLOBAL = true;
		POOLMODAL_SHOWCURRENTENV = true;
		ADDITIONAL_INFO_IN_TABLE_DATA = false;
		currentDiv = this.getParent();//divBtn

		//abrir modal
		showPoolsModal(prmProcessZneActEmailPoolsModalReturn);
	});
	var divBtn = new Element('div');
	divBtn.setStyle('background-color', '#FFFFFF');
	divBtn.set('class', 'option optionAdd');
	var lblAdd = new Element('label');
	lblAdd.set('text', LBL_ADD);
	lblAdd.inject(divBtn);
	divBtn.inject(divEle);
	divEle.inject(divContainer);
	
	divContainer.inject(div);
	
	return div;
}

//Crea el div para la acci�n de enviar notificacion
function createNotificationAction(busClaId, params, busClaParBndId){
	var tdWidths =  getGridHeaderWidths('gridZoneActions');
	var tdWidth = tdWidths[2];
	
	var div = new Element('div', {styles: {width: tdWidth, overflow: 'hidden', 'whiteSpace': 'pre','textAlign':'left'}});
	
	var span = new Element('span', {styles:{verticalAlign: 'bottom'}});
	var img1 = new Element('img', {styles: {width: 17, height:16, marginLeft: 2, marginRight: 2, cursor: 'pointer', marginTop: 5}, src: btnParsBlue}).inject(span);
	img1.addEvent("click",function(e){
		openMessageModal(this,'NOTIFICATION');
		fncZoneChanged();
	});
	img1.set('title', LBL_MESSAGE_NOT);
//	var img2 = new Element('img', {styles: {width: 17, height:16, marginLeft: 2, marginRight: 2, cursor: 'pointer'}, onclick: 'openNotPoolsModal(this,\'widName\');fncZoneChanged()', src: btnParsRed}).inject(span);
//	img2.set('title', LBL_POOLS_TOOLTIP);
	span.inject(div);
	
	//Inputs ocultos con los valores seleccionados
	var ele1 = new Element('input',{type:'hidden', name:'hidZneBusClaId'}).inject(div);
	ele1.set('value', WID_KPI_BUS_CLA_SEND_NOT_ID);
	var ele2 = new Element('input',{type:'hidden', name:'hidZneBusClaParams'}).inject(div);
	if (params!=null) ele2.set('value', params);
	var ele3 = new Element('input',{type:'hidden', name:'hidZneBusClaParBndId'}).inject(div);
	if (busClaParBndId!=null) ele3.set('value', busClaParBndId);
	
	//Container con los grupos
	var divContainer = new Element('div', {styles: {marginLeft: 50}});
	divContainer.set('id', 'poolsContainter');
	divContainer.setStyle('margin-top', '-24px');
	divContainer.set('class', 'modalOptionsContainer');
	divContainer.onRemove = function(e){
			//Recuperamos los inputs ocultos de la fila seleccionada
			var inputs = this.getParent().getElementsByTagName("INPUT");
			var divBtns = this.childNodes;
			
			//Removemos el pool seleccionado
			var params = inputs[1].value;
			var msgBody = getValInPos(0, params, "#");
			
			var i= 0;
			var pools = "";
			while (divBtns && divBtns[i]) {
                var poolId = divBtns[i].get('id');
                var poolName = divBtns[i].innerHTML.substring(0,divBtns[i].innerHTML.indexOf("<input"));
                if (poolId!="zneActAddPool"){
                	if (pools=="") pools = poolId + "," + poolName;
                	else pools = "," + poolId + "," + poolName;
                }
                i++;
			}
			
			inputs[1].set('value', msgBody + "#" + pools);

	}
	
	var pools = "";
	if(params) pools = getValInPos(1, params, "#");//2312,AAAAA,3242,BBBBB,3432,CCCC..
	if (pools!=""){ //Agregamos todos los grupos
		var poolsArr = pools.split(',');
		for (var i=0; i<poolsArr.length; i=i+2) {
			var poolId = poolsArr[i];
			var poolName = poolsArr[i+1];
			
			addActionElement(divContainer, poolName, poolId, "hidPool");
		}
	} 
		
	//Boton de agregar
	var divEle = new Element('div');
	divEle.set('id','zneActAddPool');
	divEle.set('title', LBL_POOLS_TOOLTIP);
	divEle.set('class', 'element');
	divEle.set('data-helper', true);
	divEle.addEvent("click", function(e) {
		e.stop();
		//setear variables de configuracion del modal de grupos
		POOLMODAL_SHOWAUTOGENERATED = true;
		POOLMODAL_SHOWNOTAUTOGENERATED = true;
		POOLMODAL_SHOWGLOBAL = true;
		POOLMODAL_SHOWCURRENTENV = true;
		ADDITIONAL_INFO_IN_TABLE_DATA = false;
		currentDiv = this.getParent();//divBtn

		//abrir modal
		showPoolsModal(prmProcessZneActNotPoolsModalReturn);
	});
	var divBtn = new Element('div');
	divBtn.setStyle('background-color', '#FFFFFF');
	divBtn.set('class', 'option optionAdd');
	var lblAdd = new Element('label');
	lblAdd.set('text', LBL_ADD);
	lblAdd.inject(divBtn);
	divBtn.inject(divEle);
	divEle.inject(divContainer);
	
	divContainer.inject(div);
	
	return div;
}

//Crea el div para la acci�n de enviar mensaje de chat
function createChatMsgAction(execute){
	//TODO
}

//Cuando se modifica la acci�n de la zona
function cmbActZne_change(obj){
	var indx = obj.selectedIndex;
	var selected_act = obj.options[indx].value;
	
	var tr = obj.parentNode;
	while(tr.tagName!="TR"){
		tr=tr.parentNode;
	}
	
	var td3 = tr.getElementsByTagName("TD")[2];
	var div;
	
	if (selected_act == WID_KPI_ACTION_BUS_CLASS_EXECUTION){
		div = createExeBusClaAction();
	}else if (selected_act == WID_KPI_ACTION_START_PROCESS) {
		div = createInitProcessAction();
	}else if (selected_act == WID_KPI_ACTION_SEND_EMAIL) {
		div = createSendEmailAction();
	}else if (selected_act == WID_KPI_ACTION_SEND_NOTIFICATION) {
		div = createNotificationAction();
	}else if (selected_act == WID_KPI_ACTION_SEND_CHAT_MSG) {
		div =  createChatMsgAction();
	}
	
	td3.getChildren()[0].destroy();
	
	div.inject(td3);
	td3.setAttribute("style", "min-width: 316px");
}

var inputs; //variable utilizada para almacenar los inputs de la fila seleccionada en la grilla de acciones de zona
//Modal para seleccionar una clase de negocio a ejecutar como acci�n asociada a una zona
function openBusClaModal(obj) {
	var td = obj.parentNode.parentNode;
	inputs = td.getElementsByTagName("INPUT");//Guardamos los inputs de la zona selecionada
	
	//abrir modal
	showBusClassModal(prmProcessBusClaModalNav);
}

//Procesa la informacion devuelta por el modal para seleccionar clase de negocio
function prmProcessBusClaModalNav(ret) {
	ret.each(function(e){
		var busClaName = e.getRowContent()[0];
		var busClaId = e.getRowId();
		
		inputs[0].value = busClaName;
		if (inputs[1].get('value') != busClaId){ //Si se cambio la clase de negocio
			inputs[2].set('value',""); //Borramos todos los parametros que habian antes
		}
		inputs[1].set('value',busClaId);
		
	});
}

//Modal para ingresar parametros de la clase de negocio y seleccionar cual parametro se desea contenga el valor del widget
function openZneBusClaParModal(obj) {
	var td = obj.parentNode.parentNode;
	inputs = td.getElementsByTagName("INPUT");
	
	if (inputs[1].value == "" || inputs[1].value == "0") {
		showMessage(MSG_MUST_SEL_BUS_CLA_FIRST, GNR_TIT_WARNING, 'modalWarning');
		return;
	}

	var busClaId = inputs[1].get('value');
	var parValues = inputs[2].get('value');

	modal = ModalController.openWinModal(CONTEXT
			+ "/page/design/widgets/modalParams.jsp?for=busclass&forZone=true&id="
			+ busClaId + "&parValues=" + parValues + TAB_ID_REQUEST, 700, 400);

	modal.addEvent("confirm", function(res) {
		inputs[2].set('value', res);
	});
	modal.addEvent("close", function() {

	});
}

//Modal para seleccionar un proceso a ejecutar como acci�n asociada a una zona
function openProcessModal(obj) {
	var td = obj.parentNode.parentNode;
	inputs = td.getElementsByTagName("INPUT"); //Guardamos los inputs de la zona selecionada
	
	//abrir modal
	showProcessModal(prmProcessProModalNav);
}

//Procesa la informacion devuelta por el modal para seleccionar clase de negocio
function prmProcessProModalNav(ret) {
	ret.each(function(e){
		var proName = e.getRowContent()[0];
		var proId = e.getRowId();
		
		var params = inputs[2].get('value');
		if (params=="") params = ", , , ";
		var paramsArr = null;
		if (params!=null) {
			paramsArr = params.split(",");
		}
		inputs[0].value = proName;
		inputs[1].set('value', WID_KPI_ACTION_PROCESS_BUS_CLA_ID);
		
		if (paramsArr!=null && paramsArr.length == 4) {
			inputs[2].set('value', proName + "," + paramsArr[1] + "," + paramsArr[2] + "," + paramsArr[3]); 
		}
		inputs[3].set('value', proId);
		
	});
}

var typeAttModal;  //variable utilizada para almacenar para guardar que valor se desea almacenar en el atributo 
//Modal para seleccionar un atributo a utilizar del proceso
function openAttModal(obj, type) {
	typeAttModal = type; //Guardamos el valor que se desea almacenar en el atributo seleccionado en el modal
	
	var td = obj.parentNode.parentNode;
	inputs = td.getElementsByTagName("INPUT"); //Guardamos los inputs de la zona selecionada
	
	var params = inputs[2].get('value');
	var paramsArr = null;
	var valueSelected = null;
	if (params!=null) {
		paramsArr = params.split(",");
		if (typeAttModal == "value") {
			if (paramsArr[1]!=null) valueSelected = paramsArr[1];
		}else if (typeAttModal == "widName") {
			if (paramsArr[2]!=null) valueSelected = paramsArr[2];
		}else if (typeAttModal == "widZneName") {
			if (paramsArr[3]!=null) valueSelected = paramsArr[3];
		}
	}
	
	if (valueSelected==" ") valueSelected = "";
	//abrir modal
	showAttributesModal(prmProcessAttModalNav,null,valueSelected);
}

//Procesa la informacion devuelta por el modal para seleccionar atributo
function prmProcessAttModalNav(ret) {
	ret.each(function(e){
		var attName = e.getRowContent()[0];
		var attId = e.getRowId();
		
		var params = inputs[2].get('value');
		var paramsArr = null;
		if (params!=null) {
			paramsArr = params.split(",");
		}
		
		if (paramsArr!=null) {
			if (typeAttModal == "value") {
				inputs[2].value = paramsArr[0] + "," + attName + "," + paramsArr[2] + "," + paramsArr[3]; 
			}else if (typeAttModal == "widName") {
				inputs[2].value = paramsArr[0] + "," + paramsArr[1] + "," + attName + "," + paramsArr[3]; 
			}else if (typeAttModal == "widZneName"){
				inputs[2].value = paramsArr[0] + "," + paramsArr[1] + "," + paramsArr[2]  + "," + attName;
			}
		}
		
	});
}

//Devuelve uno de los valores de un string separado por comas
function getValInPos(pos, values, separator) { //values: value1,value2,value3,value4
	if(values) {
		var valArr = values.split(separator);
		return valArr[pos];
	}
	return "";
}

//Modal para definir mensajes
function openMessageModal(obj, type) {
	var td = obj.parentNode.parentNode;
	var inputs = td.getElementsByTagName("INPUT");//Guardamos los inputs de la zona seleccionada
	var params = inputs[1].value;
	var msgBody = getValInPos(0, params, "#");
	var msgSubj;
	var poolsIds;
	if (type!="NOTIFICATION"){
		msgSubj = getValInPos(1, params, "#");
		poolsIds = getValInPos(2, params, "#");//2312,AAAAA,3242,BBBBB,3432,CCCC..
	}else {
		poolsIds = getValInPos(1, params, "#");//2312,AAAAA,3242,BBBBB,3432,CCCC..
	}
	var msgFormat = msgSubj;
	
	if (type=='MESSAGE' || type=='NOTIFICATION'){
		msgFormat = msgBody;
	}
	
	modal = ModalController.openWinModal(CONTEXT
			+ "/page/design/widgets/modalMessages.jsp?forType=" + type + "&msgFormat="+msgFormat, 500, 400);

	modal.addEvent("confirm", function(res) {
		if (type=='MESSAGE'){
			inputs[1].set('value', res + "#" + msgSubj + "#" + poolsIds);	
		}else if (type=='SUBJECT'){
			inputs[1].set('value', msgBody + "#" + res + "#" + poolsIds);
		}else {
			inputs[1].set('value', res + "#" + poolsIds);
		}
	});
	modal.addEvent("close", function() {

	});
}

//Procesa resultado del modal para seleccionar grupos las acciones de emails de las zonas
function prmProcessZneActEmailPoolsModalReturn(ret) {
	ret.each(function(e){
		var poolName = e.getRowContent()[0];
		var poolId = e.getRowId();
		
		//Recuperamos los inputs ocultos de la fila seleccionada
		var inputs = currentDiv.getParent().getElementsByTagName("INPUT");
		
		//Actualizamos los valores de los inputs ocultos con los valores seleccionados en el modal
		var params = inputs[1].value;
		var msgBody = getValInPos(0, params, "#");
		var msgSubj = getValInPos(1, params, "#");
		var pools = getValInPos(2, params, "#");//2312,AAAAA,3242,BBBBB,3432,CCCC..
		if (pools && pools.indexOf(poolId+","+poolName) >= 0) return; //Si ya se habia seleccionado salimos
		
		if (pools && pools!="") {
			if (pools.indexOf(poolId+","+poolName) < 0) pools = pools + "," + poolId + "," + poolName;
		} else pools = poolId + "," + poolName; 
		
		inputs[1].set('value', msgBody + "#" + msgSubj + "#" + pools);
		
		//Agregamos los grupos seleccionados en la fila
		addActionElement(currentDiv, poolName, poolId, "hidPool");
	});
}

//Procesa resultado del modal para seleccionar grupos las acciones de emails de las zonas
function prmProcessZneActNotPoolsModalReturn(ret) {
	ret.each(function(e){
		var poolName = e.getRowContent()[0];
		var poolId = e.getRowId();
		
		//Recuperamos los inputs ocultos de la fila seleccionada
		var inputs = currentDiv.getParent().getElementsByTagName("INPUT");
		
		//Actualizamos los valores de los inputs ocultos con los valores seleccionados en el modal
		var params = inputs[1].value;
		var msgBody = getValInPos(0, params, "#");
		var pools = getValInPos(1, params, "#");//2312,AAAAA,3242,BBBBB,3432,CCCC..
		if (pools.indexOf(poolId+","+poolName) >= 0) return; //Si ya se habia seleccionado salimos
		
		if (pools!="") {
			if (pools.indexOf(poolId+","+poolName) < 0) pools = pools + "," + poolId + "," + poolName;
		} else pools = poolId + "," + poolName; 
		
		inputs[1].set('value', msgBody + "#" + pools);
		
		//Agregamos los grupos seleccionados en la fila
		addActionElement(currentDiv, poolName, poolId, "hidPool");
	});
}

//Copia el valor al input oculto de repetidos
//y si el valor es mayor que 1 setea almacenar 10 como minimo en la bd
function changRepTimes(obj){
	var td = obj.parentNode;
	var inputs = td.getElementsByTagName("INPUT");
	var repValue = inputs[0].value;
	if (isNaN(repValue) || parseInt(repValue) < 1){
		showMessage(MSG_INS_VAL_POSITIVE, GNR_TIT_WARNING, 'modalWarning');
		inputs[0].value = "1";
	}else {
		if (parseInt(repValue) > 1){
			$('cmbStoreLast').set('value', 10);
		}
	}
}
