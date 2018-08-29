function initAdminFav()	 {
	var favFncSelection	= $('favFncSelection');
	var hlpFncSelection = $('hlpFncSelection');
	
	if (favFncSelection) {
		if (! favFncSelection.initMethodCall) {
			favFncSelection.initMethodCall = true;
			favFncSelection.addEvent("click", function(e) {
				var request = new Request({
					method: 'post',
					url: CONTEXT + URL_REQUEST_AJAX + '?action=toggleFav&isAjax=true&favFncId=' + this.get("data-favFncId") + TAB_ID_REQUEST,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); }
				}).send();
			});
		}
	}
	
//	if (hlpFncSelection) {
//		if (! hlpFncSelection.initMethodCall) {
//			hlpFncSelection.initMethodCall = true;
//			hlpFncSelection.addEvent("click", function(e){
//				window.open(this.get('helpUrl'));
//			});
//		}
//	}
}

function processToggleFavResult() {
	var ajaxCallXml = getLastFunctionAjaxCall();
	var result = ajaxCallXml.getElementsByTagName("result").item(0).firstChild.nodeValue
	var favFncSelection = $('favFncSelection');
	favFncSelection.removeClass("favIs");
	if (result == "true") favFncSelection.addClass("favIs");
	
	SYS_PANELS.closeAll();
}