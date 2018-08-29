var TO_CALL_ON_TAB_FOCUS = null;
var lastPanelConfIconClicked = null;

function initPage() {
	
	var IN_IFRAME	= window != window.parent && window.parent != null && window.parent.document != null;
	if (!(IS_EXTERNAL=="true") && IN_IFRAME) {
		try {
			if(window.parent.IS_CONTAINER)
				window.parent.document.location = CONTEXT + "/page/login/login.jsp";
		} catch(e) {}
	}
	
	$('bodyController').onTabFocus = fncOnTabFocus;
	
	$(document).addEvent('click', function(evt) {
		if (lastPanelConfIconClicked != null && lastPanelConfIconClicked != this) lastPanelConfIconClicked.fireEvent("click");
	});
	
	var inIframe = window.parent != null && window.parent.document != null;
	TAB_CONTAINER = document.getElementById("tabContainer");
	if (TAB_CONTAINER == null && inIframe) TAB_CONTAINER = window.parent.document.getElementById("tabContainer");
	
	if (TAB_CONTAINER == null) {
		TAB_CONTAINER = new Object();
		TAB_CONTAINER.addNewTab = function(name, url) {
//			showMessage("Sorry can't open " + name + " at " + url);
			showMessage(Generic.formatMsg(ERR_OPEN_URL, name, url));
		}
	}
	
	$$('div.panel').each(function(ele, pos) {
		ele = $(ele);
		ele.addEvent('mouseover', function(evt) { this.addClass('panelOver'); });
		ele.addEvent('mouseleave', function(evt) { this.removeClass('panelOver'); });

		addPanelFocusListener(ele);
	});
	
	$$("div.panelConfigurationIcon").each(function(confIcon){
		var pnlUniqueId = confIcon.get("data-pnlUniqueId");
		var confMenu = $(pnlUniqueId + 'Options');
		confIcon.menu = confMenu;
		if (confMenu) {
			confMenu.icon = confIcon;
			confMenu.isVisible = false;
			
			confMenu.getChildren("div.panelConfigurationOption").each(function(option){
				option.addEvent("mouseover", function() { this.toggleClass("over"); });
				option.addEvent("mouseout", function() { this.toggleClass("over"); });
				
				if (option.hasClass("optionRefresh")) option.addEvent("click", panelConfigurationOpionRefresh);
			});
			
			confIcon.addEvent("click", function(evt) {
				if (lastPanelConfIconClicked != null && lastPanelConfIconClicked != this) lastPanelConfIconClicked.fireEvent("click");
				
				if (this.menu.isVisible) {
					lastPanelConfIconClicked = null;
					this.menu.setStyle('display', 'none');
				} else {
					lastPanelConfIconClicked = this;
					this.menu.setStyle('display', 'block'); 
					this.menu.position({relativeTo: this, position: 'bottomLeft', offset: {y: -1, x: -68} }); 
				}
				this.menu.isVisible = ! this.menu.isVisible;
				
				if (evt) evt.stopPropagation();
			});
		}
	});
	

	$$("div.panelRssIcon").each(function(rssIcon){
		rssIcon.addEvent("click", function(evt) {
			window.open(URL_PORTAL_PANEL_RSS + '&pnlId=' + this.get("data-pnlId") + '&pnlTitle=' + this.getAttribute("pnlTitle") + '&pnlTooltip=' + this.getAttribute("pnlTooltip"), "_blank");
			if (evt) evt.stopPropagation();
		});
	});
	
	$(document.body).addEvent('keydown', function(e) {
		if(e.key == 'tab') {
			document.body.removeClass('no-keyboard-focus');
		}
	}).addEvent('mousedown', function(e) {
		document.body.addClass('no-keyboard-focus');
	});
	
	//Cargar contenido din�mico
	TO_CALL_ON_TAB_FOCUS = $$("div.optionRefreshOnStartup");
	callNextOnTabFocus.delay(200);
}

function panelConfigurationOpionRefresh() {
	if (lastPanelConfIconClicked != null && lastPanelConfIconClicked != this) lastPanelConfIconClicked.fireEvent("click");
	callAjaxRefresh(this.get("data-pnlId"));
}

function panelRefreshWaitShow(pnlId) {
	var content = $(pnlId + 'Content');
	if (! content.spinner) content.spinner = new Spinner(content,{message:' '})
	content.spinner.show(true);
}

function panelRefreshWaitHide(pnlId) {
	var content = $(pnlId + 'Content');
	if (content.spinner) content.spinner.hide(true);
}

function callAjaxRefresh(pnlId) {
	var request = new Request({
		method: 'post',
		url: fix_URL_PORTAL_PANEL_REFRESH() + '&isAjax=true&pnlId=' + pnlId,
		onRequest: function() { panelRefreshWaitShow(pnlId); /* SYS_PANELS.showLoading(); */ },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); panelRefreshWaitHide(pnlId); }
	}).send();
}

function callAjaxRedrawPanel() {
	var ajaxCallXml = getLastFunctionAjaxCall();
	var panel = ajaxCallXml.getAttribute("panel");
	var pnlId = ajaxCallXml.getAttribute("pnlId");
	var callRefresh = ajaxCallXml.getAttribute("callRefresh");
	var html = getTagContent(ajaxCallXml.getElementsByTagName("html").item(0)); //ajaxCallXml.getElementsByTagName("html").item(0).firstChild.nodeValue;
	document.getElementById(panel + "Content").innerHTML = html;
	
	SYS_PANELS.closeAll();
	
	if (callRefresh == "true") callAjaxRefresh(pnlId);
}

function callAjaxActionPanelWithParams(url,strParams){
	callAjaxActionPanelWithMethod(url,modalProcessXml,strParams);
}

function callAjaxActionPanel(url, src) {
	callAjaxActionPanelWithMethod(url, modalProcessXml);
}

function callAjaxActionPanelWithMethod(url, xmlMethod, strParams) {
	
	if(url.indexOf("?") > -1){
		url = url + '&isAjax=true';
	}else{
		url = url + '?isAjax=true';
	}
	
	url=url+"&t=" + new Date().getTime();
	
	var request = new Request({
		method: 'post',
		url: CONTEXT + "/" + url,
		onRequest: function() { errorOnCallAjaxPanelWithMethod = false; },
		onComplete: function(resText, resXml) { if (! this.errorOnCallAjaxPanelWithMethod && xmlMethod) xmlMethod(resXml); },
		onError: function(text, error) { this.errorOnCallAjaxPanelWithMethod = true; }
	})
	request.errorOnCallAjaxPanelWithMethod = false;
	request.send(strParams ? strParams : '');
}

function fncOnTabFocus() {
	TO_CALL_ON_TAB_FOCUS = $$("div.optionRefreshOnTabFocus");
	callNextOnTabFocus();
}

function callNextOnTabFocus() {
	if (! XML_RESULT_LOGGED) return;
	
	if (TO_CALL_ON_TAB_FOCUS.length == 0) {
		return;
	}
	
	var toCall = TO_CALL_ON_TAB_FOCUS[0];
	TO_CALL_ON_TAB_FOCUS.erase(toCall);
	
	var pnlId = toCall.get("data-pnlId");
	
	var request = new Request({
		method: 'post',
		url: fix_URL_PORTAL_PANEL_REFRESH() + '&isAjax=true&pnlId=' + pnlId,
		
		onRequest: function() { panelRefreshWaitShow(pnlId); /* SYS_PANELS.showLoading(); */ },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); panelRefreshWaitHide(pnlId); callNextOnTabFocus.delay(200); }
		
	}).send();
}

function resizeImages() {
	$$('img.resizableOnResize').each(function(p){
		p.setStyle('width', 'auto');
		p.setStyle('height', 'auto');
		
		if (p.offsetWidth > p.getParent().offsetWidth) p.setStyle('width', p.getParent().offsetWidth + 'px');
	});
}

function fix_URL_PORTAL_PANEL_REFRESH(){
	var fixedUrl = URL_PORTAL_PANEL_REFRESH;
	if (CURRENT_PORTAL_TOKEN_ID != null){
		var position = fixedUrl.indexOf('tokenId=');
		fixedUrl = fixedUrl.substring(0, position) + 'tokenId=' + CURRENT_PORTAL_TOKEN_ID;
	}
	return fixedUrl;
}

function set_TOKEN_ID(TOKEN_ID){
	CURRENT_PORTAL_TOKEN_ID = TOKEN_ID;
}


//var currentMouseTarget = null;

function addPanelFocusListener(panel) {
	
//	panel.addEvent('mousedown', function(e) {
//		document.body.addClass('no-keyboard-focus');
//	});
	
	panel.addEvent('keydown', function(e) {
		
		if(e.key == 'down' && e.target == panel) {
			//Pasar el foco al primer 
			
			if(panel.focusableItems) {
				for(var i = 0; i < panel.focusableItems.length; i++) {
					if(panel.focusableItems[i])
						panel.focusableItems.removeEvent('blur');
				}
			}
			
			//Recargar los elemenos focusables, porque pueden haber cambiado
			panel.focusableItems = panel.getElements('.focusable');
			
			if(panel.focusableItems && panel.focusableItems.length) {
				e.preventDefault();
				
				var idx = -1;
				for(var i = 0; i < panel.focusableItems.length; i++) {
					if(panel.focusableItems[i]) {
						panel.focusableItems.addEvent('blur', pnlBlurListener);
						
						if(idx == -1 && panel.focusableItems[i].isVisible()) {
							idx = i;
						}
					}
				}
				if(idx != -1) {
					panel.focusableItemsIdx = idx;
					panel.focusableItems[idx].set('tabIndex', '').set('tabbed', 'true').addEvent('keydown', pnlItemFocusListener).focus();
				}
			} 
		}
	}).addEvent('blur', pnlBlurListener);
}

function pnlBlurListener(e) {
	var panel;
	if(e.target.hasClass('panel'))
		panel = e.target;
	else
		panel = e.target.getParent('div.panel');
	
	if(panel.focusableItems) {
		for(var i = 0; i < panel.focusableItems.length; i++) {
			if(panel.focusableItems[i].get('tabbed'))
				panel.focusableItems[i].removeAttribute('tabbed');
			else
				panel.focusableItems[i].removeAttribute('tabIndex');
		}
	}
}

function pnlItemFocusListener(e) {
	if(e.key == 'down') {
		e.preventDefault();
		
		//Ir al siguiente elemento
		var panel = e.target.getParent('div.panel');
		
		var next_idx = panel.focusableItemsIdx + 1;
		
		while(next_idx < panel.focusableItems.length && !panel.focusableItems[next_idx].isVisible()) {
			next_idx++;
		}
		
		if(next_idx < panel.focusableItems.length) {
			
			e.target.removeEvent('keydown');
//			e.target.removeAttribute('tabIndex');
			e.target.removeAttribute('tabbed');
			
			panel.focusableItemsIdx = next_idx;
			panel.focusableItems[panel.focusableItemsIdx].set('tabIndex', '').set('tabbed', 'true').addEvent('keydown', pnlItemFocusListener).focus();
		}
	} else if(e.key == 'up') {
		//Ir al elemento anterior
		e.preventDefault();
		
		//Ir al siguiente elemento
		var panel = e.target.getParent('div.panel');
		
		
		var next_idx = panel.focusableItemsIdx - 1;
		
		while(next_idx >= 0 && !panel.focusableItems[next_idx].isVisible()) {
			next_idx--;
		}
		
		if(next_idx >= 0) {
			
			e.target.removeEvent('keydown');
//			e.target.removeAttribute('tabIndex');
			e.target.removeAttribute('tabbed');
			
			panel.focusableItemsIdx = next_idx;
			panel.focusableItems[panel.focusableItemsIdx].set('tabIndex', '').set('tabbed', 'true').addEvent('keydown', pnlItemFocusListener).focus();
			

		}
	} else if(e.key == 'enter') {
		if(e.target.get('onclick'))
			e.target.click();
		else
			e.target.fireEvent('click');
//		e.target.click();
	}
}