function initPage(){
	
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	initAdminFieldOnChangeHighlight();
	initAdminActionsEdition();	
	
	var tskSchName = $('tskSchName');
	var selFrec = $('selFrec');
	var selCal = $('selCal');
	var selTemplate = $('selTemplate');
	var btnViewCal = $('btnViewCal');
	var btnDelTempl = $('btnDelTemplate');
	var btnSaveTempl = $('btnSaveTemplate');
	var mode = UPDATE_MODE;
	
	if (!tskSchName.get('value')) { //Estamos creando
		selFrec.selectedIndex = 4;
		mode=INSERT_MODE;
	}
	
	initProperties();
	initTskSchPermissions(mode);
	initTskSchAtts(mode);
	
	if (btnViewCal){
		btnViewCal.addEvent("click", function(e){	
		e.stop();
		//verificar que solo un registro esté seleccionado
		if (selCal.selectedIndex == 0) {
			showMessage(MSG_SEL_ONE_CAL_FIRST, GNR_TIT_WARNING, 'modalWarning');
		} else {
			//var id = getSelectedRows($('tableData'))[0].getRowId();			
			//var request = new Request({
			//	method: 'post',
			//	url: CONTEXT + URL_REQUEST_AJAX + '?action=suspend&isAjax=true' + TAB_ID_REQUEST+"&id="+id,
			//	onRequest: function() { SYS_PANELS.showLoading(); },
			//	onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			//	}).send();
			
			if (selCal.value != 0){
				openModal("/programs/modals/calendarView.jsp?calendarId="+selCal.value,600,500);
			}
		}
		});
	}
	
	if (btnDelTempl){
		btnDelTempl.addEvent("click", function(e){	
		e.stop();
		//verificar que solo un registro esté seleccionado
		if (selTemplate.selectedIndex == 0) {
			showMessage(MSG_SEL_ONE_TEMP_FIRST, GNR_TIT_WARNING, 'modalWarning');
		} else {
			showConfirm(MSG_DEL_SEL_TEMPLATE,GNR_TIT_WARNING,deleteTemplate(selTemplate.value),"modalWarning");
		}
		});
	}
	
	if (btnSaveTempl){
		btnSaveTempl.addEvent("click", function(e){	
		e.stop();
		saveTemplate(selTemplate.value);
		});
	}
	
	getBodyController().canRemoveTab = function() { return ! AT_LEAST_ON_FIELD_INPUT_CHANGED; };
}

function changeFrecCmb(){
	var oldFrec = $('txtHidFrec').value;
	var frec = $('selFrec').value;
	if (oldFrec == frec){
		return;
	}
	if (frec == -1){
		frec = 30;
		selFraccTime(frec);
	}else if (frec == 0){ //Selecciono otro
		frec = oldFrec; //por ahora dejamos en el input oculto el valor anterior
	}
	$('txtHidFrec').value = frec;
	if ($('selFrec').value == 0){
		$('txtOthFrec').disabled = false;
	}else{
		$('txtOthFrec').disabled = true;
		$('txtOthFrec').value = "";
	}
}

function reloadGrid(){
	if ($('txtOthFrec').value > 0 || $('selFrec').value.value > 0){
		//window.parent.document.getElementById("iframeMessages").showWaitMsg();
		//window.parent.document.getElementById("iframeMessages").style.display="block";
		//setTimeout(function(){buildGrid("refresh");},100);
	}
}

function changeFrecInput(){
	$('txtHidFrec').value = $('txtOthFrec').value;
	if ($('txtHidFrec').value > 0){
		reloadGrid();
	}
}

//Seleccionamos la subdivision horaria pasada por parametro
function selFraccTime(fracc){
	$('txtHidFrec').value = fracc;
	var cmbFracc = $('selFrec');
	var found = false;
	for (i = 0; i < cmbFracc.options.length; i++) {
		if (cmbFracc.options[i].value == fracc) {
			cmbFracc.selectedIndex = i;
			found = true;
			$('txtOthFrec').value = "";
			return;
		}
	}
	
	//Si llego aqui no se encontro --> es otro valor
	cmbFracc.selectedIndex = cmbFracc.options.length-1;
	$('txtOthFrec').disabled = false;
	$('txtOthFrec').value = fracc;
}

function saveTemplate(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=saveTemplate&isAjax=true' + TAB_ID_REQUEST,
		//onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) {
			alert(MSG_TEMPLATE_SAVED);
		}
	}).send();
}

function deleteTemplate(tempId){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=deleteTemplate&isAjax=true' + TAB_ID_REQUEST,
		//onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) {
			var cmbTemplates = $('selTemplate');
			for (i = 0; i < cmbTemplates.options.length; i++) {
				if (cmbTemplates.options[i].value == tempId) {
					cmbTemplates.removeChild(cmbTemplates.options[i]);
					return;
				}
			}
		}
	}).send("tempId=" + tempId);
}
