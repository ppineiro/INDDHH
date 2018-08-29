function initPage(){
	
	
 
	
	
	var btnGen = $('btnGen');
	if (btnGen){
		btnGen.addEvent("click", function(e) {
			e.stop();
			
			var form = $('frmData');
			if(!form.formChecker.isFormValid()){
				return;
			}
			
			
			
			
			var params = getFormParametersToSend(form);
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=analyze&isAjax=true' + TAB_ID_REQUEST ,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml);}
			}).send(params);	
			
		});
	}
	
	
//	$$('div.fncDescriptionImage').each(function(e){
//		var path = 'url(' + e.get('data-src') + ')'
//		e.setStyle('background-image', path);
//		e.setStyle('background-repeat', 'no-repeat');
//		e.setStyle('width', '64px');
//		e.setStyle('height', '64px');
//	});
	
	
	
//	initAdminFieldOnChangeHighlight();
	initAdminActionsEdition(null,true,true,true);
	//initPermissions();
	initAdminFav();
 
}

function startDownload(){
	SYS_PANELS.closeAll();
	var spinner = new Spinner($('bodyDiv'),{message:WAIT_A_SECOND});
	createDownloadIFrame(TSK_LST,DOWNLOADING,URL_REQUEST_AJAX,"download","","","",null);	
}
