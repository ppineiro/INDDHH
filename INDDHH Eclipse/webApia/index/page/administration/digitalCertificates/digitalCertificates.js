function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	//Confirmar
	$('btnConf').addEvent('click', function(e){
		e.stop();
		
		var form = $('frmData');
		if(!form.formChecker.isFormValid()){
			return;
		}
		
		 
		var params = getFormParametersToSend(form);
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=confirm&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml);}
		}).send(params);		
	});
	
 
	$('frmData').formChecker = new FormCheck(
			'frmData',
			{
				submit:false,
				display : {
					keepFocusOnError : 1,
					tipsPosition: 'left',
					tipsOffsetY: -12,
					tipsOffsetX: -10
				}
			}
		);
	

}

function updateStatus(){
	SYS_PANELS.closeAll();
	SYS_PANELS.showLoading(); 
	location.href = CONTEXT + URL_REQUEST_AJAX;
}