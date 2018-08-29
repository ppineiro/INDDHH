var IS_MSIE = navigator.userAgent.indexOf("MSIE") >= 0;
var IN_IFRAME = window.parent != null && window.parent.document != null;

function initPage() {
	window.addEvent('resize', function(){
		adjustIFrameHeights();
	});
	
	adjustIFrameHeights();
	
	var iframeAcquired = $('iframeAcquired');
	var iframeReady = $('iframeReady');
	
	var tabReady = $('tabReady');
	var tabAcquired = $('tabAcquired');
	
	
	if(readyFirst=='true') {
		iframeReady.src = URL_READY;
		iframeReady.contentDirty = false;
		
		iframeAcquired.srcLoaded = false;
		iframeAcquired.contentDirty = true;
		
		
	} else {
		iframeAcquired.src = URL_ACQUIRED; 
		iframeAcquired.contentDirty = false;
		
		iframeReady.srcLoaded = false;
		iframeReady.contentDirty = false;
			
		
	}
	
	
	
	tabReady.addEvent('focus', function(evt) {
		var iframe = $('iframeReady');
		if (! iframe.srcLoaded) {
			iframe.contentDirty = false;
			iframe.srcLoaded = true;
			iframe.src = URL_READY;
		} else if (iframe.contentDirty) {
			iframe.contentDirty = false;

			if (! iframe.contentWindow) return true;
			if (! iframe.contentWindow.document) return true;
			
			var navRefresh = iframe.contentWindow.document.getElementById('navRefresh');
			if (! navRefresh) return;
			navRefresh.click();
		}
	});
	
	tabAcquired.addEvent('focus', function(evt) {
		var iframe = $('iframeAcquired');
		if (! iframe.srcLoaded) {
			iframe.contentDirty = false;
			iframe.srcLoaded = true;
			iframe.src = URL_ACQUIRED;
		} else if (iframe.contentDirty) {
			iframe.contentDirty = false;

			if (! iframe.contentWindow) return true;
			if (! iframe.contentWindow.document) return true;
			
			var navRefresh = iframe.contentWindow.document.getElementById('navRefresh');
			if (! navRefresh) return;
			navRefresh.click();
		}
	});
}

function getStageHeight(){
    if(IS_MSIE){
        var height = document.body.parentElement.clientHeight;
        if(document.body.parentElement.clientHeight == 0){
            height = document.body.clientHeight;
        }
        return height;
    }else{
        return height = getRealWindow().innerHeight;
    }
}

function getRealWindow() {
	if (IN_IFRAME) {
	  return window.parent.window;
	}

	return window;
} 

function adjustIFrameHeights() {
	var newHeight = parseInt(getStageHeight() - $$('.tabHolder')[0].offsetHeight - ( window.MOBILE ? 52 : 80))+"px";
	$$('iframe').each(function(iframe){
		iframe.style.height = newHeight;
		iframe.set('prevStyleHeight', newHeight);
	});
}
