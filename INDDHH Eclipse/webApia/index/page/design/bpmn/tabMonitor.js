
function initTabMonitor(){	
	
	//Agregar
	$('addMonitorForm').addEvent("click", function(evt){
    	evt.stop();
    	FORMSMODAL_SHOWGLOBAL = true;
    	FORMSMODAL_SELECTONLYONE = false;
    	showFormModal(processFormsModalReturn);
    });
	
	loadMonitorForms();
}

function disabledAllTabMonitor(){
	if (MODE_DISABLED){
    	var tabContent = $('contentTabMonitor');
    	tabContent.getElements("div.option").each(function(option){
    		option.removeEvents('click');
    	});
    	$('addMonitorForm').removeEvents('click');    	
    } else {
    	createSorteable();
    }
}


function loadMonitorForms(){
	var request = new Request({
		method : 'post',
		url : CONTEXT + URL_REQUEST_AJAX + '?action=loadMonitorForms&isAjax=true' + TAB_ID_REQUEST,
		onRequest : function() { },
		onComplete : function(resText, resXml) { processMonitorFormsXml(resXml); }
	}).send();
}

function processMonitorFormsXml(resXml){
	var monitorForms = resXml.getElementsByTagName("monitorForms")
	if (monitorForms != null && monitorForms.length > 0 && monitorForms.item(0) != null) {
		//monitorForms = monitorForms.item(0).getElements("form");		
		monitorForms = monitorForms.item(0).getElementsByTagName("form");
		
		for (var i = 0; i < monitorForms.length; i++){
			var xmlForm = monitorForms[i];
			createMonitorForm(xmlForm.getAttribute("id"),xmlForm.getAttribute("name"));						
		}		
	}	
	
	disabledAllTabMonitor();
}

function createSorteable(){
	new Sortables($$('.optionFormsContainer'), {
		clone: true,
		revert: true,
		handle: 'div.formMoveIcon',
		opacity: 0.7		
	});
}

function createMonitorForm(id,name){
	if (!($("form_"+id))){		
		var container = $('monitorFormsContainer');
		var form = new Element("div",{'id': "form_"+id, html: name, 'class': 'option optionWidthAll optionRemove'}).inject(container);
		form.setAttribute("numId",id);
		form.setAttribute("formName",name);
		form.addEvent("click",function(evt){ this.destroy(); evt.stopPropagation(); });		
		var panelIcon = new Element("div",{'class': 'formMoveIcon moveIcon'}).inject(form);
		panelIcon.addEvent("click",function(evt){ evt.stopPropagation(); });
	}
}

function processFormsModalReturn(ret){
	ret.each(function(form){
		createMonitorForm(form.getRowId(),form.getRowContent()[0]);		
	});
	createSorteable();
}

function executeBeforeConfirmTabMonitor(){
	var txtFormsId = $('txtFormsId');
	var monitorFormsContainer = $('monitorFormsContainer');
	var values = "";
	monitorFormsContainer.getElements("div.option").each(function (form){
		if (values != "") values += ";";
		values += form.getAttribute("numId");
		values += PRIMARY_SEPARATOR;
		values += form.getAttribute("formName");
	});
	txtFormsId.value = values;
	return true;
}


