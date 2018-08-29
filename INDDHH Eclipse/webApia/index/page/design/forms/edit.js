/**
 * Funcion invocada por el diseñador flash al finalizar de cargarse
 */
function flashLoaded() {
	setModel($('txtMap').get('value'));
}

/**
 * Funcion para ser invocada antes de confirmar el formulario.
 * Establece el modelo en el textarea
 */
function beforeConfirm() {
	try {
		var model = getModel();
		if(model) {
			model = model.replace(/&amp;/g, '&');
		}
		$('txtMap').set('value', model);
	} catch(e) {
		if($('txtMap').get('value').length == 0)
			$('txtMap').set('value', '<FORM_LAYOUT><EVENTS/></FORM_LAYOUT>');
	}
	
	if(!verifyPermissions()){
		return false;
	}
}

/**
 * Obtiene el objeto flash de diseñador de formularios
 */
function getFlashDesigner() {
	var obj = $('fDesigner');
	if(obj.getModel){
		return obj;
	} else {
		return obj.getChildren('embed')[0];
	}
}

/**
 * Retorna el modelo generado por el diseñador
 * @returns {String} modelo generado
 */
function getModel() {
	return getFlashDesigner().getModel();
}

/**
 * Setea el modelo almacenado al diseñador de flash
 * @param model
 */
function setModel(model) {
	if(model)
		model = model.replace('value="<', 'value="&lt;');
	getFlashDesigner().setModel(model);
}

var spinner;

/**
 * Muestra mensaje waiting sobre el diseñador
 */
function showWaitingMessage() {
	if(!spinner)
		spinner = new Spinner($('fDesignerContainer'));
	spinner.show();
}

/**
 * Oculta mensaje waiting sobre el diseñador
 */
function hideWaitingMessage() {
	spinner.hide();
}

/**
 * Abre un nuevo tab de Diseño->Diccionario de datos
 */	
function openAttributeTab() {
	//var url = "http://localhost:9080/Apia%20Dev/apia.design.AttributesAction.run?favFncId=12" + TAB_ID_REQUEST;
	//var url = "apia.design.AttributesAction.run";
	var url = "apia.design.AttributesAction.run?action=create";
	frameElement.getParent('body').getElementById("tabContainer").addNewTab(ATT_TAB_TITLE, url, 12);
}

function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
		
	$('frmData').formChecker = new FormCheck(
			'frmData',
			{
				submit:false,
				display : {
					keepFocusOnError : 1,
					tipsPosition: 'left',
					tipsOffsetY: 10,
					tipsOffsetX: -10
				}
			}
	);
	
	initPermissions();
	initAdminActionsEdition(beforeConfirm);
	initAdminFav();
	initDocuments();
	initAdminFieldOnChangeHighlight(false, false);
	
	
	var fDesignerContainer = $('fDesignerContainer');
	var bodyDiv = $('bodyDiv');
	
	$('flashTab').addEvent('click', function() {
		//Ocultar campaña
    	$$('div.campaign').setStyle("display", "none");
    	
    	fDesignerContainer.addClass('onscreen').removeClass('offscreen').getParent('div.contentTab').addClass('always-visible');
    	
    	fDesignerContainer.setStyle("width", Number.from(bodyDiv.getWidth()) - 15);
    	
		$('panelGenData').style.display='';
		
		bodyDiv.getElement('div.dataContainer').addClass('dataContainerOffscreen');
	});
	
	//$('flashTab').addEvent('blur', function() {
	$('flashTab').addEvent('custom_blur', function() {
		
		//alert("blur");
		
		if(!this.hasClass('active')) {
			fDesignerContainer
				.addClass('offscreen')
				.removeClass('onscreen');
		}
		$('panelGenData').style.display='none';
		bodyDiv.getElement('div.dataContainer').removeClass('dataContainerOffscreen');
		
		$$('div.campaign').setStyle("display", "block");
	});
	
	$('txtName').addEvent('blur', function(evt) { $('dataGenFrmName').innerHTML = this.value; });
	$('txtTitle').addEvent('blur', function(evt) { $('dataGenFrmTitle').innerHTML = this.value; });
	
	
	//eventos para el tab
    $('flashTab').addEvent("focus", function(evt){
    	$('optionsContainer').addClass('hideSections').getChildren('div').setStyle('margin-bottom', '0px');
    	$('tabComponent').setStyle('margin-right', 'inherit');
    	var panelOptionsTabMap = $('panelOptionsTabMap');
    	if (panelOptionsTabMap){
    		panelOptionsTabMap.style.display='';
    	}	
    });
    //$('flashTab').addEvent("blur", function(evt){
    $('flashTab').addEvent("custom_blur", function(evt) {
    	$('optionsContainer').removeClass('hideSections').getChildren('div').setStyle('margin-bottom', '');
    	$('tabComponent').setStyle('margin-right', '');
    	var panelOptionsTabMap = $('panelOptionsTabMap');
    	if (panelOptionsTabMap){ 
    		panelOptionsTabMap.style.display='none';
    	}
    });
    
    $('optionsContainer').addEvent('mouseover', function(evt) {
		if (this.hasClass('hideSections')) this.addClass('forceShowSections');
	});
	
	$('optionsContainer').addEvent('mouseout', function(evt) {
		if (this.hasClass('hideSections')) this.removeClass('forceShowSections');
	});
}

function checkValidations(obj,formName){
	
	var validations = $(formName!=null?formName:'frmData').formChecker.validations;
	if (obj!=null){
		for (var i=0;i<validations.length;i++){
			if (obj== validations[i]){
				return false;
			}
		}
		return true;
	}
	return false;
}

function registerValidation(obj,className,formName){
	var ok = checkValidations(obj,formName);
	if (ok){
		if (!className){
			obj.addClass("validate['required']");
		}else{
			obj.addClass(className);
		}		
		$(formName!=null?formName:'frmData').formChecker.register(obj);
	}
}

function disposeValidation(obj,formName){
	if (obj!=null){
		$(formName!=null?formName:'frmData').formChecker.dispose(obj);
	}
}