/**
 * Funcion invocada por el dise�ador flash al finalizar de cargarse
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
		if (IS_HTML_VERSION){
			var captchas = gridSchema.filter(function(ele){ 
				if (ele.field.fieldType == TYPE_CAPTCHA) return ele; 
			});
			if (captchas.length>1){
				showMessage(MSG_FORM_ONLY_ONE_CAPTCHA);
				return false;
			}

			var model = getModelLayout();
			$('txtMap').set('value', model);
			
		} else {
			//FLASH
			var model = getModel();
			if(model) {
				model = model.replace(/&amp;lt;/g, '&lt;');
				model = model.replace(/&amp;gt;/g, '&gt;');
			}
			$('txtMap').set('value', model);
		}
	} catch(e) {
		if($('txtMap').get('value').length == 0)
			$('txtMap').set('value', '<FORM_LAYOUT><EVENTS/></FORM_LAYOUT>');
	}
	
	if(!verifyPermissions()){
		return false;
	}
}

/**
 * Obtiene el objeto flash de dise�ador de formularios
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
 * Retorna el modelo generado por el dise�ador
 * @returns {String} modelo generado
 */
function getModel() {
	return getFlashDesigner().getModel();
}

/**
 * Setea el modelo almacenado al dise�ador de flash
 * @param model
 */
function setModel(model) {
	if(model)
		model = model.replace('value="<', 'value="&lt;');
	getFlashDesigner().setModel(model);
}

var spinner;

/**
 * Muestra mensaje waiting sobre el dise�ador
 */
function showWaitingMessage() {
	if(!spinner)
		spinner = new Spinner($('fDesignerContainer'));
	spinner.show();
}

/**
 * Oculta mensaje waiting sobre el dise�ador
 */
function hideWaitingMessage() {
	spinner.hide();
}

/**
 * Abre un nuevo tab de Dise�o->Diccionario de datos
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
	
	//var fDesignerContainer = $('fDesignerContainer');
	var bodyDiv = $('bodyDiv');
	
	$('txtName').addEvent('blur', function(evt) { $('dataGenFrmName').innerHTML = this.value; });
	$('txtTitle').addEvent('blur', function(evt) { $('dataGenFrmTitle').innerHTML = this.value; });
	
	
	//eventos para el tab
	var formsTab = ['designerTab'];
	
	formsTab.each(function(t){ 
		var fDesignerContainer = $(t+'Container');
		
		$(t).addEvents({
			"click" : function (evt){
				//Ocultar campa�a
		    	$$('div.campaign').setStyle("display", "none");
		    	
		    	fDesignerContainer.addClass('onscreen').removeClass('offscreen').getParent('div.contentTab').addClass('always-visible');
		    	
		    	fDesignerContainer.setStyle("width", Number.from(bodyDiv.getWidth()) - 15);
		    	
				$('panelGenData').style.display='';
				
				bodyDiv.getElement('div.dataContainer').addClass('dataContainerOffscreen');
				
				if (IS_HTML_VERSION){
					initDesigner(); 
				}
			},
			
			"focus" : function(evt){
		    	$('optionsContainer').addClass('hideSections').getChildren('div').setStyle('margin-bottom', '0px');
		    	$('tabComponent').setStyle('margin-right', 'inherit');
		    	var panelOptionsTabMap = $('panelOptionsTabMap');
		    	if (panelOptionsTabMap){
		    		panelOptionsTabMap.style.display='';
		    	}
		    	
		    	var currentTab = fDesignerContainer.getParent('.aTab'); 
		    	if (currentTab){
		    		currentTab.addClass('flashContainer');
		    		currentTab.setStyle('height', '99%');
		    	}
		    },
		    "custom_blur" : function(evt) {
		    	
		    	if(!this.hasClass('active')) {
					fDesignerContainer
						.addClass('offscreen')
						.removeClass('onscreen');
				}
				$('panelGenData').style.display='none';
				bodyDiv.getElement('div.dataContainer').removeClass('dataContainerOffscreen');
				
				$$('div.campaign').setStyle("display", "block");
		    	
		    	
		    	$('optionsContainer').removeClass('hideSections').getChildren('div').setStyle('margin-bottom', '');
		    	$('tabComponent').setStyle('margin-right', '');
		    	var panelOptionsTabMap = $('panelOptionsTabMap');
		    	if (panelOptionsTabMap){ 
		    		panelOptionsTabMap.style.display='none';
		    	}
		    	
		    	var currentTab = fDesignerContainer.getParent('.aTab'); 
		    	if (currentTab){
		    		currentTab.removeClass('flashContainer');
		    		currentTab.setStyle('height', null);
		    	}
		    }
		})
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