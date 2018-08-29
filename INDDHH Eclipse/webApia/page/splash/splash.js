var TO_CALL_ON_TAB_FOCUS = null;
var lastPanelConfIconClicked = null;

function panelConfigurationOpionEdit() {
	if (lastPanelConfIconClicked != null && lastPanelConfIconClicked != this) lastPanelConfIconClicked.fireEvent("click");
	var request = new Request({
		method: 'post',
		url: URL_SPLASH_PANEL_EDIT + '&isAjax=true&pnlId=' + this.get("data-pnlId"),
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send();
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
		url: URL_SPLASH_PANEL_REFRESH + '&isAjax=true&pnlId=' + pnlId,
		onRequest: function() { panelRefreshWaitShow(pnlId); removePanelErrorColor(pnlId); /* SYS_PANELS.showLoading(); */ },
		onComplete: function(resText, resXml) { 
			var result = modalProcessXml(resXml,null,false);
			panelRefreshWaitHide(pnlId);
			if(!result) {
				setPanelErrorColor(pnlId);
			}
		}
	}).send();
}

function setPanelErrorColor(pnlId){
	var ele = $(pnlId + "ErrorIcon");
	ele.getParent().addClass('errorIcon');
	ele.getParent().removeClass('sticky');
	ele.set('html','&nbsp;<font style="color:red; font-weight:bolder; font-size:14px">!</font>');
	ele.set('title','Error loading panel');
}

function removePanelErrorColor(pnlId){
	var ele = $(pnlId + "ErrorIcon");
	ele.getParent().removeClass('errorIcon');
	ele.getParent().addClass('sticky');
	ele.set('html','');
	ele.set('title','');
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
	
	var request = new Request({
		method: 'post',
		url: CONTEXT + "/" + url,
		onRequest: function() { errorOnCallAjaxPanelWithMethod = false; },
		onComplete: function(resText, resXml) { 
			if (! this.errorOnCallAjaxPanelWithMethod && xmlMethod) 
				xmlMethod(resXml); 
		},
		onError: function(text, error) { this.errorOnCallAjaxPanelWithMethod = true; }
	})
	request.errorOnCallAjaxPanelWithMethod = false;
	request.send(strParams ? strParams : '');
}

function callAjaxElementMoved(element, sortObject) {
	var pnlId = element.get('data-pnlId');
	var containerId = element.getParent().get('data-locationId');
	//if (!containerId) containerId = element.getParent().get('locationId');
	var count = 0;
	var elements = element.getParent().getElements('div.panel');

	elements.each( function(ele, pos) {
		if (! ele.hasClass('ghostElement')) count ++;
		if (ele.get('data-pnlId') == element.get('data-pnlId') && ! ele.hasClass('ghostElement')) {
			element.set('data-newPosition', count); 
		}
	});
	
	var newPosition = element.get('data-newPosition');
	var request = new Request({
		method: 'post',
		url: URL_SPLASH_PANEL_MOVE + '&isAjax=true&pnlId=' + pnlId + '&containerId=' + containerId + "&newPosition=" + newPosition,
		onRequest: function() { },
		onComplete: function(resText, resXml) { 
			modalProcessXml(resXml);
			
			if (resXml.getElementsByTagName("sysExceptions").length != 0) {
				sortObject.restore();			
			}
		}
	}).send();
}

var loadingPanels = false;

function fncOnTabFocus() {
	if(loadingPanels == false) {
		TO_CALL_ON_TAB_FOCUS = $$("div.optionRefreshOnTabFocus");
		loadingPanels = true;
		callNextOnTabFocus();
	}
}


function callNextOnTabFocus() {
	if (! XML_RESULT_LOGGED) return;
	
	if (TO_CALL_ON_TAB_FOCUS.length == 0) {
		loadingPanels = false;
		return;
	}
	
	var toCall = TO_CALL_ON_TAB_FOCUS[0];
	TO_CALL_ON_TAB_FOCUS.erase(toCall);
	
	var pnlId = toCall.get("data-pnlId");
	
	var request = new Request({
		method: 'post',
		url: URL_SPLASH_PANEL_REFRESH + '&isAjax=true&pnlId=' + pnlId,
		
		onRequest: function() { panelRefreshWaitShow(pnlId); /* SYS_PANELS.showLoading(); */ },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); panelRefreshWaitHide(pnlId); callNextOnTabFocus.delay(200); }
		
	}).send();
}

function initPage() {
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
				
				if (option.hasClass("optionEdit")) option.addEvent("click", panelConfigurationOpionEdit);
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
	
	var middrag;
	var dragging = false;
	
	new Sortables($$('div.planelContainer'), {
		clone: true,
		revert: true,
		handle: 'div.panelMoveIcon',
		opacity: 0.7,
		onStart: function(el, clone) {
            this.restore = (function() {
                var prevParent = el.getParent(),
                    prevItems  = prevParent.getChildren();    
                return function() {
                    prevParent.adopt(prevItems);
                }
            })();
        },
		onComplete: function(element, droppable, evt) {
			callAjaxElementMoved(element, this); 
		}
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

function resizeImages() {
	$$('img.resizableOnResize').each(function(p){
		p.setStyle('width', 'auto');
		p.setStyle('height', 'auto');
		
		if (p.offsetWidth > p.getParent().offsetWidth) p.setStyle('width', p.getParent().offsetWidth + 'px');
	});
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