var Scroller1;
var Scroller2;

function initPage(){
	
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	var mode = UPDATE_MODE;
	if (!$('widName').get('value')) { //Estamos creando
		mode=INSERT_MODE;
	}
	
	initAdminFieldOnChangeHighlight();
	initAdminActionsEdition(executeBeforeConfirm,false,false); //Acciones de los botones Confirmar, Volver, etc..  => Se comentan pues es necesario agregar los eventos de onConfirm desde este archivo
	initGenDataTab(mode); //en tabGenData.js
	initSrcDataTab(mode); //en tabSrcData.js
	initOthDataTab(mode); //en tabOthData.js
	initActionsTab(mode); //en tabActions.js
	initUpdateTab(mode); //en tabUpdate.js
	initHistoricTab(mode); //en tabHistoric.js
	initPermissionsTab(mode); //en tabPerms.js

	//Iniciamos los modals que se pueden abrir en esta funcionalidad
	initBusClaMdlPage();
	initProcMdlPage();
	initAttMdlPage();
	initPoolMdlPage();
	
	BUSCLAMODAL_SELECTONLYONE = true; //No permitimos seleccion multiple en modals de seleccion de clase de negocio
	PROCESSMODAL_SELECTONLYONE = true; //No permitimos seleccion multiple en modals de seleccion de proceso
	ATTRIBUTEMODAL_SELECTONLYONE = true; //No permitimos seleccion multiple en modals de seleccion de atributo
	POOLMODAL_SELECTONLYONE = true; //No permitimos seleccion multiple en modals de seleccion de pooles
	
	
	//Cuando se haga foco en el tab de Datos Generales
	$('tabGenData').addEvent("focus", function(evt) {
		var gridZones = $('gridZones');
		if (gridZones) {
			addScrollTable(gridZones); //Agregamos el scroll de la grilla de zonas
		}
	});
	
	//Cuando se haga foco en el tab de Acciones
	$('tabActions').addEvent("focus", function(evt) {
		var gridZoneActions = $('gridZoneActions');
		if (gridZoneActions) {
			addScrollTable(gridZoneActions); //Agregamos el scroll de la grilla de acciones de las zonas
		}
	});
	
	//Cuando se ingrese al tab de fuente de datos
	$('tabSrcData').addEvent("focus", function(evt){
		//addScrollTable($('tabGenData'));
    	var cmbType = $("cmbType");
    	if (cmbType){
    		if (cmbType.get('value') == WIDGET_TYPE_CUSTOM_ID) {
    			$('panelOptions').style.display=''; //Mostramos panel de opciones
    		}else if (cmbType.get('value') == WIDGET_TYPE_KPI_ID && $('cmbSrcType').get('value') == WIDGET_SRC_TYPE_QUERY_SQL_ID) {
    			$('panelOptions').style.display=''; //Mostramos panel de opciones
    		}else {
    			$('panelOptions').style.display='none';  //Ocultamos panel de opciones 		
    		}
    	}else{
    		$('panelOptions').style.display='none';  //Ocultamos panel de opciones 		  		
    	}
    });
	
	//Cuando se haga foco en el tab de Info.Complementaria
	$('tabOthData').addEvent("focus", function(evt) {
		addScrollTable($('gridInfo')); //Agregamos el scroll de la grilla
	});
    
	//Cuando se salga del tab de fuente de datos
    $('tabSrcData').addEvent("blur", function(evt){
    	$('panelOptions').style.display='none'; //Ocultamos panel de opciones 
    });    

    getBodyController().canRemoveTab = function() { return ! AT_LEAST_ON_FIELD_INPUT_CHANGED; };
    
    if ($('cmbType').value == "3"){ //Consulta
    	enableDisableZonesDiv.delay(1000);    	
    }
}

//Funciones de uso gral (en todos los tabs)

//Devuelve array con los anchos de los encabezados de la tabla pasada por parametro
function getGridHeaderWidths(gridName) {
	var parent = $(gridName).getParent();
	$(gridName).selectOnlyOne = false; 
	var thead = parent.getFirst("thead");
	var theadTr = thead ? thead.getFirst("tr") : null;
	var headers = theadTr ? thead.getElements("th") : null;
	var tdWidths = headers ? new Array(headers.length) : null;
	if (headers) {
		for (var i = 0; i < headers.length; i++) {
			tdWidths[i] = headers[i].getStyle('width');
			if (! tdWidths[i]) tdWidths[i] = headers[i].get('width');
		}
	}
	
	return tdWidths;
}

function executeBeforeConfirm(){
	return true;
}