var TAB_CONTAINER;

function campaignClick(cmpTitle, cmpId, target) {
	var urlToCall = CONTEXT + '/apia.administration.CampaignsAction.run?action=click&id=' + cmpId + TAB_ID_REQUEST;
	
	if (! TAB_CONTAINER) {
		var inIframe = window.parent != null && window.parent.document != null;
		TAB_CONTAINER = document.getElementById("tabContainer");
		if (TAB_CONTAINER == null && inIframe) TAB_CONTAINER = window.parent.document.getElementById("tabContainer");
		
		if (TAB_CONTAINER == null) {
			TAB_CONTAINER = new Object();
			TAB_CONTAINER.addNewTab = function(name, url) {
				showMessage(Generic.formatMsg(ERR_OPEN_URL, name, url));
			}
		}
	}
	
	if (target == 0) {
		TAB_CONTAINER.addNewTab(cmpTitle, urlToCall, null);
	} else if (target == 1) {
		window.location.href =  urlToCall;
	} else if (target == 2) {
		window.open (urlToCall,"apiaCampaign" + cmpId);
	}
	
	return false;
}