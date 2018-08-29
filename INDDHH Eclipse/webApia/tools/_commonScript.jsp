function isIE() { return isIEOld() || isIE11(); }
function isIEOld() { return !!(navigator.userAgent.match("/MSIE/")); }
function isIE11() { return navigator.userAgent.indexOf("Trident") != -1 && navigator.userAgent.indexOf("rv:11") != -1; }


<% if (! _logged) { %>
	var IN_IFRAME	= window != window.parent && window.parent != null && window.parent.document != null;
	
	if (IN_IFRAME) {
		var url = document.URL;
		if (url.indexOf("?") != -1) {
			url = url.substring(0, url.indexOf("?"));
			window.parent.document.location = url;
		}
	}
	
<% } %>

	window.addEvent('load', function() {
		var ieWarning = $('ieWarning'); 
		if (! isIE() && ieWarning) ieWarning.destroy();
		
		var help = $('help');
		if (help) help.addEvent('click', function() {
			var helpWindow = $('helpWindow');
			var helpWindowContent = $('helpWindowContent');
			if (helpWindow) helpWindow.removeClass('hidden');
			if (helpWindowContent) helpWindowContent.position('center');
			return false;
		});
		
		var helpWindowHide = $('helpWindowHide');
		if (helpWindowHide) helpWindowHide.addEvent('click', function() { 
			$('helpWindow').addClass('hidden'); 
		});
		 
	});
