var newSchId = "";
var hasChange = "false";
var mondayStr = "";
var day = "";
var hor = "";

function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	//Botones
	$('btnConf').addEvent("click",function(e){
		e.stop();
		var strParams = '&newSchId=' + newSchId + '&hasChange=' + hasChange + '&mondayStr=' + mondayStr + '&day=' + day + '&hor=' + hor; 
		
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=confirmReschedule&isAjax=true' + strParams + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send();
	});
	$('btnBack').addEvent("click",function(e){
		e.stop();
		sp.show(true);
		window.location = CONTEXT + URL_REQUEST_AJAX + '?action=goBack' + TAB_ID_REQUEST;		
	});
	$('btnCloseTab').addEvent("click",function(e){ getTabContainerController().removeActiveTab(); });
	//['btnConf','btnBack','btnCloseTab'].each(setTooltip);
	
	initAdminFav();	
	getBodyController().canRemoveTab = function() { return ! AT_LEAST_ON_FIELD_INPUT_CHANGED; };
	
	TskScheduler.loadSchedExec('schedContainer', SCH_ID, PRO_ID, PRO_VER_ID, TSK_ID, SHOW_DISPONIBILITY);
}

