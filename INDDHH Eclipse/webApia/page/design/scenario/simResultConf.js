function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner($('container_data'),{message:WAIT_A_SECOND});
	
	$('frmData').formChecker = new FormCheck(
			'frmData',
			{
				submit:false,
				display : {
					keepFocusOnError : 1,
					tipsPosition: 'left',
					tipsOffsetX: -10
				}
			}
		);
	
	var btnExecute = $('btnExecute');
	if (btnExecute){
		btnExecute.addEvent("click", function(e) {
	
			e.stop();
			
			var form = $('frmData');
			if(!form.formChecker.isFormValid()){
				return;
			}
			
			var params = getFormParametersToSend(form);
			
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=genResult&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send(params);
		
		});
	}
	
	$$('input').each(function(input){
		if (input.getAttribute("type") == "checkbox"){
			input.setStyle("float","left");
		}
	});
	$$('label.label').each(function(lbl){
		lbl.setStyle("display","auto");
	});
	
	initAdminActionsEdition();
}

function sectionChecked(checkbox, otherSectionName) {
	var div = $(checkbox.name + "Section");	
	div.style.display = checkbox.checked ? "block" : "none";
}

function goToPdf(){
	sp.show(true);
	window.location = CONTEXT + URL_REQUEST_AJAX + '?action=goToPdf' + TAB_ID_REQUEST;
}

function generatePdf(){
	createDownloadIFrame("",DOWNLOADING,URL_REQUEST_AJAX,"generatePdf","","","",null);
}

