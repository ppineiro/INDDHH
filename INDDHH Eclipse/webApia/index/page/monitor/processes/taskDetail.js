function initDetailsPage() {
	$('btnBack').addEvent('click', function(evt){
		SYS_PANELS.showLoading();
		
		if (FROM_TASKS_MONITOR){
			window.location = CONTEXT + URL_REQUEST_AJAX + '?action=initTaskProcess&id=' + LAST_ID + "&fromTaskMonitor=true" + TAB_ID_REQUEST;
		} else {
			document.location = CONTEXT + URL_REQUEST_AJAX + "?action=back"  + TAB_ID_REQUEST;	
		}		
	});
	
	
	var btnPrintFrm = $('btnPrint');
	if(btnPrintFrm){
		btnPrintFrm.addEvent('click', function(e){
			if(this.getElement('button') && this.getElement('button').get('disabled'))
				e.stop();
			else
				printForms();
		});
	}
}