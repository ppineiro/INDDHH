var spModal;
function initExportMdlPage() {
	spModal = new Spinner($('frmModalExport'),{message:WAIT_A_SECOND});
	
	var mdlExportContainer = $('mdlExportContainer');
	if (mdlExportContainer.initDone) return;
	mdlExportContainer.initDone = true;
	
	mdlExportContainer.blockerModal = new Mask();
	
	var mdlExportAddAtt = $('mdlExportAddAtt');
	var btnCloseExportModal = $('btnCloseExportModal');
	var btnConfirmExportModal = $('btnConfirmExportModal');
	
	if (mdlExportAddAtt) {
		mdlExportAddAtt.addEvent("click", function(e) {
			e.stop();
			ATTRIBUTEMODAL_SELECTONLYONE = false;
			ADDITIONAL_INFO_IN_TABLE_DATA  = false;
			showAttributesModal(processAttsModalReturn,addInfoTrue);
		});
	}
	
	if (btnCloseExportModal) {
		btnCloseExportModal.addEvent("click", closeExportModal);
	}
	
	if (btnConfirmExportModal) {
		btnConfirmExportModal.addEvent('click', function(evt){
			evt.stop();
			
			var forms = getFormsToExport();
			var atts = getAttsToExport();
			
			var isOk = forms != "" || atts != "";
			
			if (!isOk){
				showMessage(MSG_NOT_CONFIRM, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var exportType;
				if ($('type1').checked){
					exportType = "1";
				} else if ($('type2').checked){
					exportType = "2";
				} else {
					exportType = "3";
				}
				
				var request = new Request({
					method: 'post',
					url: CONTEXT + URL_REQUEST_AJAX + '?action=doExport&exportType=' + exportType + '&forms=' + forms + '&atts=' + atts + "&selectedLanguage=" + $('selectedLanguage').value + TAB_ID_REQUEST,
					onRequest: function() { },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); }
				}).send();
			}
		});
	}
	
	initAttMdlPage();
}

function showExportModal(entId){
	if (entId == null || entId == "") return;
	
	$('type1').checked = true;
	$('type2').checked = false;
	$('type3').checked = false;
	$('mdlExportFormsContainer').getElements("div").each(function (item){ item.destroy(); });
	$('mdlExportAttContainer').getElements("div").each(function (item){ item.destroy(); });
		
	var mdlExportContainer = $('mdlExportContainer');
	mdlExportContainer.position();
	mdlExportContainer.blockerModal.show();
	mdlExportContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlExportContainer.removeClass('hiddenModal');
	
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=getFormsForExport&id=' + entId + TAB_ID_REQUEST,
		onRequest: function() { spModal.show(true); },
		onComplete: function(resText, resXml) { processXmlForms(resXml); spModal.hide(true); }
	}).send();
}


function processXmlForms(ajaxCallXml){
	if (ajaxCallXml != null) {		
		var forms = ajaxCallXml.getElementsByTagName("forms");
		if (forms != null && forms.length > 0 && forms.item(0) != null) {		
			forms = forms.item(0).getElementsByTagName("form");
			
			var container = $('mdlExportFormsContainer');
			for(var i = 0; i < forms.length; i++) {
				var form = forms.item(i);
				var text = form.getAttribute("text");
				var id = form.getAttribute("id");
				
				var div = new Element("div",{'class': 'option optionWidthAll', 'id': "form_"+id, html: text});
				div.setAttribute("formId",id);
				var chk = new Element("input",{'type': 'checkbox', 'id': "chk_"+id}).inject(div);
				chk.tooltip(TT_FORMS, { mode: 'auto', width: 110, hook: false });				
				
				div.inject(container);				
			}
		}
	}	
}

function closeExportModal(){
	var mdlExportContainer = $('mdlExportContainer');
	mdlExportContainer.addClass('hiddenModal');
	mdlExportContainer.blockerModal.hide();
}

function processAttsModalReturn(ret){
	var btnAdd = $('mdlExportAddAtt');
	ret.each(function(e){
		if (!$("att_"+e.getRowId())){
			var div = new Element("div",{'class': 'option optionMiddleModal optionRemove', 'id': "att_"+e.getRowId(), html: e.getRowContent()[0]});
			div.setAttribute("attId",e.getRowId());
			div.addEvent("click",function(evt){ this.destroy(); });
			div.inject(btnAdd,"before");
		}
	});	
	
	addInfoTrue();
}

function addInfoTrue(){
	ADDITIONAL_INFO_IN_TABLE_DATA  = true;
}

function getFormsToExport(){
	var forms = "";
	$('mdlExportFormsContainer').getElements("div").each(function (item){
		var id = item.getAttribute("formId");
		var chk = $("chk_"+id);
		if (chk.checked){
			if (forms != "") { forms += ";"; }
			forms += id;
		}
	});
	return forms;
}

function getAttsToExport(){
	var atts = "";
	$('mdlExportAttContainer').getElements("div").each(function (item){
		if (atts != "") { atts += ";"; }
		atts += item.getAttribute("attId");
	});
	return atts;
}

function startDownload(){
	createDownloadIFrame("",DOWNLOADING,URL_REQUEST_AJAX,"download","","closeExportModal","true",closeExportModal);
}

