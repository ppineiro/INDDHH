var IS_MSIE = navigator.userAgent.indexOf("MSIE") >= 0;
var IS_MSIE6 = IS_MSIE && navigator.userAgent.indexOf("MSIE 6") >= 0;
var IS_MSIE7 = IS_MSIE && navigator.userAgent.indexOf("MSIE 7") >= 0;
var IS_MSIE8 = IS_MSIE && navigator.userAgent.indexOf("MSIE 8") >= 0;
var IS_OPERA = navigator.userAgent.indexOf("Opera") >= 0;
var IS_FIREFOX = navigator.userAgent.indexOf("Firefox") >= 0;
var IS_FIREFOX3 = navigator.userAgent.indexOf("Firefox") >= 0 && navigator.userAgent.indexOf("3.0") >= 0;
var IS_SAFARI = navigator.userAgent.indexOf("Safari") >= 0;
var IS_CHROME = navigator.userAgent.indexOf("Chrome") >= 0;

var IN_IFRAME = window.parent != null && window.parent.document != null;

var BI_PARTIAL_URL	= "BIAction.run";

var TAB_CONTROL_URLS = ['apia.execution.TaskAction.run'];

var documentSpinner = null;

function toBoolean(value) {
	if (value == null) return false;
	if (typeof(value) == "string") return "true" == value || "on" == value || "1" == value || "y" == value;
	if (typeof(value) == "boolean") return value;
	if (typeof(value) == "number") return 1 == value;
	if (typeof(value) == "object") return value != null;

	return false;
}

function removeElement(elementName,event) {
	var divElement = $(elementName);
	if (divElement != null && divElement.parentNode != null) divElement.parentNode.removeChild(divElement);
}

function callAjaxRefreshSplashPage() {
	var tabContainer = $('tabContainer');
	tabContainer.tabHome.changeUrlContent(CONTEXT + '/apia.splash.SplashAction.run?action=refresh' + TAB_ID_REQUEST);
	SYS_PANELS.closeAll.delay(500, SYS_PANELS);
}

function callAjaxRefreshSplashPage2() {
	var tabContainer = $('tabContainer');
	tabContainer.tabHome.changeUrlContent(CONTEXT + '/apia.splash.SplashAction.run?action=refresh' + TAB_ID_REQUEST);
}

function initPage(){
	documentSpinner = new Spinner($(document.body),{message:WAIT_A_SECOND});;
	
	document.ondblclick = function(evt) {
	    if (window.getSelection)
	        window.getSelection().removeAllRanges();
	    else if (document.selection)
	        document.selection.empty();
	}
	
	var tabContainer = $('tabContainer');
	tabContainer.contentContainer = null;
	tabContainer.activeTab = null;
	tabContainer.tabMenu = null;
	tabContainer.tabHome = null;
	tabContainer.tahUser = null;
	tabContainer.tabs = [];
	tabContainer.chats = [];

	//--- Contenedor de tabs
	tabContainer.tabScrollContainer = $('tabScrollContainer');
	tabContainer.tabScrollContainer.container = tabContainer;;
	tabContainer.tabScrollContainer.elemntScrollLeft = $('tabScrolLeft');
	tabContainer.tabScrollContainer.elemntScrollRight = $('tabScrolRight');
	tabContainer.tabScrollContainer.subContainer = $('subTabContainer');
	tabContainer.tabScrollContainer.scrollContainerScroll = $('tabScrollContainerScroll');
	tabContainer.tabScrollContainer.fxScroll = new Fx.Scroll(tabContainer.tabScrollContainer.scrollContainerScroll);
	
	tabContainer.tabScrollContainer.elemntScrollLeft.container = tabContainer.tabScrollContainer;
	tabContainer.tabScrollContainer.elemntScrollRight.container = tabContainer.tabScrollContainer;

	tabContainer.tabScrollContainer.startScroll = function (delta) {
		this.scrollDelta = delta || this.scrollDelta;
		if (! this.scrollDelta) this.scrollDelta = delta;

		var currentScrollX = this.scrollContainerScroll.elemntScrollLeft || this.scrollContainerScroll.scrollX || 0;
		var currentScrollY = this.scrollContainerScroll.scrollTop || this.scrollContainerScroll.scrollY || 0;
		
		this.fxScroll.set(currentScrollX + this.scrollDelta, currentScrollY); 

		//this.scrollDelayId = this.startScroll.delay(100, this);
	}
	
	tabContainer.tabScrollContainer.stopScroll = function (delta) {
		$clear(this.scrollDelayId);
		this.scrollDelta = null;
	}
	
	tabContainer.tabScrollContainer.elemntScrollLeft.addEvent('click', function(evt){ this.container.startScroll(-10); });
//	tabContainer.tabScrollContainer.elemntScrollLeft.addEvent('mousedown', function(evt){ this.container.startScroll(-10); });
//	tabContainer.tabScrollContainer.elemntScrollLeft.addEvent('mouseup', function(evt){ this.container.stopScroll(); });
//	tabContainer.tabScrollContainer.elemntScrollLeft.addEvent('dblclick', function(evt){ this.container.fxScroll.toLeft(); });
//	tabContainer.tabScrollContainer.elemntScrollRight.addEvent('click', function(evt){ this.container.startScroll(10); });
	tabContainer.tabScrollContainer.elemntScrollRight.addEvent('click', function(evt){ this.container.fxScroll.toRight(); });
//	tabContainer.tabScrollContainer.elemntScrollRight.addEvent('mousedown', function(evt){ this.container.startScroll(10); });
//	tabContainer.tabScrollContainer.elemntScrollRight.addEvent('mouseup', function(evt){ this.container.stopScroll(); });
//	tabContainer.tabScrollContainer.elemntScrollRight.addEvent('dblclick', function(evt){ this.container.fxScroll.toRight(); });
	
	//--- Contenedor de chats
	/*
	tabContainer.chatScrollContainer = $('chatScrollContainer');
	tabContainer.chatScrollContainer.container = tabContainer;;
	tabContainer.chatScrollContainer.elemntScrollLeft = $('chatScrolLeft');
	tabContainer.chatScrollContainer.elemntScrollRight = $('chatScrolRight');
	tabContainer.chatScrollContainer.subContainer = $('subchatContainer');
	tabContainer.chatScrollContainer.scrollContainerScroll = $('chatScrollContainerScroll');
	tabContainer.chatScrollContainer.fxScroll = new Fx.Scroll(tabContainer.chatScrollContainer.scrollContainerScroll);
	
	tabContainer.chatScrollContainer.elemntScrollLeft.container = tabContainer.chatScrollContainer;
	tabContainer.chatScrollContainer.elemntScrollRight.container = tabContainer.chatScrollContainer;

	tabContainer.chatScrollContainer.startScroll = function (delta) {
		this.scrollDelta = delta || this.scrollDelta;
		if (! this.scrollDelta) this.scrollDelta = delta;

		var currentScrollX = this.scrollContainerScroll.elemntScrollLeft || this.scrollContainerScroll.scrollX || 0;
		var currentScrollY = this.scrollContainerScroll.scrollTop || this.scrollContainerScroll.scrollY || 0;
		
		this.fxScroll.set(currentScrollX + this.scrollDelta, currentScrollY); 

		this.scrollDelayId = this.startScroll.delay(100, this);
	}
	
	tabContainer.chatScrollContainer.stopScroll = function (delta) {
		$clear(this.scrollDelayId);
		this.scrollDelta = null;
	}
	
	tabContainer.chatScrollContainer.elemntScrollLeft.addEvent('mousedown', function(evt){ this.container.startScroll(-10); });
	tabContainer.chatScrollContainer.elemntScrollLeft.addEvent('mouseup', function(evt){ this.container.stopScroll(); });
	tabContainer.chatScrollContainer.elemntScrollLeft.addEvent('dblclick', function(evt){ this.container.fxScroll.toLeft(); });
	tabContainer.chatScrollContainer.elemntScrollRight.addEvent('mousedown', function(evt){ this.container.startScroll(10); });
	tabContainer.chatScrollContainer.elemntScrollRight.addEvent('mouseup', function(evt){ this.container.stopScroll(); });
	tabContainer.chatScrollContainer.elemntScrollRight.addEvent('dblclick', function(evt){ this.container.fxScroll.toRight(); });
	*/
	//Comportamiento de tabs
	tabContainer.removeActiveTab = function() {
		this.removeTab(this.activeTab);
	};
	
	tabContainer.toogleTab = function(aTab) {
		if (aTab != null) {

			var tabIsMenu = aTab == this.tabMenu;
			var activeClass = tabIsMenu ? "activeMenu" : "active";
			
			if(tabIsMenu && !aTab.hasClass('active')) {
				aTab.toggleClass(activeClass);
				aTab.content.toggleClass("active");
				
				//var resultModeSearch = $('resultModeSearch');
				//resultModeSearch.innerHTML = "";
				
				if (! IS_MSIE) {
					var fx = new Fx.Morph(aTab.content, { duration: 250 });
					
					fx.set({ 'height': 20 });
					
					fx.start({
						'height': 320
					}).chain(function() {
						$('menuSearchInput').doSearch();
					});
				} else {
					aTab.content.setStyle('height', '320');
					$('menuSearchInput').doSearch();
				}
				
			} else {
				aTab.toggleClass(activeClass);
				aTab.content.toggleClass("active");
			}

			aTab.fireEvent(aTab.hasClass(activeClass) ? 'onFocusTab' : 'onBlurTab');
			aTab.content.fireEvent(aTab.hasClass(activeClass) ? 'onFocusTab' : 'onBlurTab');
			
			try {
				if (
					this.canFireEvents && 
					aTab.hasClass(activeClass) &&
					aTab.content && 
					aTab.content.contentWindow && 
					aTab.content.contentWindow.document && 
					aTab.content.contentWindow.document.getElementById('bodyController')) 
				{
					var controller = aTab.content.contentWindow.document.getElementById('bodyController');
					if (controller.onTabFocus) controller.onTabFocus();
				}
			} catch (e) {}
		}
	};
	
	tabContainer.hiddeTab = function(aTab) {
		if (aTab != null) {
			var tabIsMenu = aTab == this.tabMenu;
			var activeClass = tabIsMenu ? "activeMenu" : "active"
				
			aTab.removeClass(activeClass);
			aTab.content.removeClass("active");
			aTab.content.fireEvent('onBlurTab');
		}
	}
	
	tabContainer.switchTab = function(toTab, doScroll, evt) {
		if (window.getSelection)
	        window.getSelection().removeAllRanges();
	    else if (document.selection)
	        document.selection.empty();
		
		if (! toTab.active) return; //si ya est� activa no hacer nada

		var isTabMenu = toTab == this.tabMenu; //determinar si se est� mostrando el men�
		var isTabUser = toTab == this.tabUser; //determinar si se est� mostrando el usuario
		var isTabHome = toTab == this.tabHome; //determinar si se est� mostrando el usuario

		if (isTabHome) toTab.removeClass('tabHighlightedHome');
		
		var currentActive = toTab.hasClass(isTabMenu ? 'activeMenu' : 'active');
		
		if (currentActive && (toTab.isChat || isTabMenu || isTabUser)) {
			this.hiddeTab(toTab);
			return;
		}
		
		if (! evt || ! evt.shift) this.hiddeTab(this.tabMenu);
		this.hiddeTab(this.tabUser);
		
		//this.chats.each(function(aTab){this.hiddeTab(aTab);}, this);
		
		if (! isTabMenu && ! isTabUser && ! toTab.isChat) { //si no es el men� ni el usuario ni es chat, cambiar de tab 
			toTab = $(toTab);
			
			this.toogleTab(this.activeTab);
			
			this.activeTab = $(toTab);

			if ((! evt || ! evt.shift) && this.tabMenu.content.hasClass("active")) this.toogleTab(this.tabMenu); //ocultar el men� si est� activo
			
			if (toTab.avoidContentLoad) {
				toTab.avoidContentLoad = false;
				
				var url = toTab.originalUrl;
				var tabId = toTab.tabId;
				var fncId = toTab.fncId;
				
				toTab.content = new Element('iframe', {
					frameborder: 0, 
					'class': 'tabContent', 
					'src': url + ((url.indexOf("?") == -1) ? "?" : "&") + "tabId=" + tabId + "&favFncId=" + fncId + TAB_ID_REQUEST
				});
				
				toTab.content.inject(this.contentContainer);
			}
			
			adjustIFrameHeight(toTab.content)
		} else {
			
			if (isTabMenu) { //si es el men�, calcular su posici�n
				toTab.content.position( {
					relativeTo: toTab,
					position: 'bottomLeft'
				});
			} else if (isTabUser || toTab.isChat) { //si es el usuario, calcular su posici�n
				toTab.content.position( {
					relativeTo: toTab,
					position: 'bottomRight',
					edge: 'upperRight'
				});
			}
		}

		this.toogleTab((isTabMenu || isTabUser || toTab.isChat) ? toTab : this.activeTab); //mostrar el elemento
		
		if (! isTabMenu && ! isTabUser && ! toTab.isChat && doScroll) this.tabScrollContainer.fxScroll.toElement(toTab);
		
		if (isTabMenu)  {
			try {
				$('menuSearchInput').focus();
				$('menuSearchInput').select();
			} catch(error) {/*Capturar excepcion si menuSearchInput es invisible*/}
		}
		
		//colocar como primero de la lista
		if (!isTabMenu && !isTabUser && !toTab.isChat) {
			var tabs = toTab.isChat ? this.chats : this.tabs;
			tabs.erase(toTab);
			tabs.unshift(toTab);
		}
	};
	
	window.addEvent('resize', function(){
		var tabContainer = $('tabContainer');
		
		if (tabContainer.refreshTimmer) $clear(tabContainer.refreshTimmer);
		tabContainer.refreshTimmer = tabContainer.refreshTabs.delay(100, tabContainer);
	});
	
	tabContainer.refreshTabs = function() {
		 adjustIFrameHeight(this.activeTab.content);

		 //[this.tabScrollContainer, this.chatScrollContainer].each(function(scrollContainer){
		 [this.tabScrollContainer].each(function(scrollContainer){
			 var currentWidthContainer = Number.from(scrollContainer.subContainer.getStyle("width"));
			 var currentWidthScroll = Number.from(scrollContainer.scrollContainerScroll.getDimensions({computeSize: true}).totalWidth);
			 
			 var activateScroll = currentWidthContainer > currentWidthScroll;
			 
			 if (activateScroll) {
				 scrollContainer.elemntScrollLeft.removeClass("dontShow");
				 scrollContainer.elemntScrollRight.removeClass("dontShow");
				 
				 scrollContainer.fxScroll.toElement(this.activeTab);
			 } else {
				 scrollContainer.elemntScrollLeft.addClass("dontShow");
				 scrollContainer.elemntScrollRight.addClass("dontShow");
			 }
		 });
	}
	
	tabContainer.initTab = function(tab) {
		if (! tab.content) tab.content = $(tab.getAttribute("tabId"));
		
		tab.active = true;
		tab.container = this;

		tab.addEvent("mouseover", function () { this.toggleClass("over"); });
		tab.addEvent("mouseout", function () { this.toggleClass("over"); });
		tab.addEvent("click", function() { this.container.switchTab(this, true); });

		if (tab.id == "tabHome") {
			this.tabHome = tab;
			
			this.tabHome.changeUrlContent = function(newUrl) {
				this.content.src = newUrl;
			}
			
		} else if (tab.id == "tabMenu") {
			this.tabMenu = tab;
			
			this.tabMenu.content.addEvent('onFocusTab', function(evt) { this.mask.show(); });
			this.tabMenu.content.addEvent('onBlurTab', function(evt) { this.mask.hide(); });
			
			var tabContentContainer = $('tabContentContainer');
			this.tabMenu.content.mask = new Mask(tabContentContainer);
			this.tabMenu.content.mask.container = this;
			this.tabMenu.content.mask.addEvent('click', function(evt) {
				this.container.hiddeTab(this.container.tabMenu);
			});
			
			this.tabMenu.content.setStyle('zIndex', '11');
			this.tabMenu.setStyle('zIndex', '10');
			
		} else if (tab.id == "tabUser") {
			this.tabUser = tab;
			this.tabUser.userExit = $('userExit');
			this.tabUser.userConfiguration = $('splashConfiguration');
			this.tabUser.userChangeEnv = $('splashChangeEnv');
			this.tabUser.panelUsers = $('chatPanelUsers');
			this.tabUser.panelGroups = $('chatPanelGroups');
			this.tabUser.panelRequests = $('chatPanelRequests');

			this.tabUser.content.addEvent('onFocusTab', function(evt) { this.mask.show(); });
			this.tabUser.content.addEvent('onBlurTab', function(evt) { this.mask.hide(); });
			
			var tabContentContainer = $('tabContentContainer');
			this.tabUser.content.mask = new Mask(tabContentContainer);
			this.tabUser.content.mask.container = this;
			this.tabUser.content.mask.addEvent('click', function(evt) {
				this.container.hiddeTab(this.container.tabUser);
			});
			
			this.tabUser.content.setStyle('zIndex', '11');
			this.tabUser.setStyle('zIndex', '10');

			this.tabUser.open = function() { if (! this.hasClass('active')) this.fireEvent('click'); }
			this.tabUser.close = function() { if (this.hasClass('active')) this.fireEvent('click'); }
			
			
			this.tabUser.addEvent('logoutDone', function() {
				this.panelUsers.content.empty();
				this.panelGroups.content.empty();
				this.panelRequests.content.empty();

				this.panelUsers.addClass("dontShow");
				this.panelGroups.addClass("dontShow");
				this.panelRequests.addClass("dontShow");
				
				$('chatStatusOption').selectedIndex = 1;
			});
			
			this.tabUser.addEvent('serverAutomaticLogoutDone', function() {
				this.addClass('tabUserDisconnected');
			});
			
			this.tabUser.addEvent('loginDone', function() {
				this.panelUsers.removeClass("dontShow");
				this.panelGroups.removeClass("dontShow");
				this.panelRequests.removeClass("dontShow"); 
				
				if (uiChat.automaticReconnect) {
					$('chatStatusOption').selectedIndex = 0;
					$('tabUser').removeClass('tabUserDisconnected');
				}
				
				uiChat.automaticReconnect = false;
			});
			
			this.tabUser.userExit.tabParent = this.tabUser;
			this.tabUser.userExit.addEvent('click', function(evt) {
				this.tabParent.container.hiddeTab(this.tabParent);
//				if (confirm(LABEL_CONFIRM_EXIT)) {
//					documentSpinner.show(true);
//					window.location = CONTEXT + '/apia.security.LoginAction.run?action=logout';
//				}
//				
				showConfirm(LABEL_CONFIRM_EXIT, "Apia", function(ret){  if (ret){documentSpinner.show(true);	window.location = CONTEXT + '/apia.security.LoginAction.run?action=logout' + TAB_ID_REQUEST;} }, "modalWarning")
			}, this.tabUser);
			
			this.tabUser.userConfiguration.tabParent = this.tabUser;
			this.tabUser.userConfiguration.addEvent('click', function(evt){
				this.tabParent.close();
				var configModal = $('configModal');
				configModal.position();
				configModal.blockerModal.show();
				configModal.setStyle('display','block');
			});
			
			this.tabUser.userChangeEnv.tabParent = this.tabUser;
			this.tabUser.userChangeEnv.addEvent('click', function(evt){
				this.tabParent.close();				
				var request = new Request({
					method: 'post',
					url: CONTEXT + '/apia.splash.SplashAction.run?action=splashEditEnv' + '&isAjax=true' + TAB_ID_REQUEST,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); }
				}).send();
			});
			
			[this.tabUser.panelUsers, this.tabUser.panelGroups, this.tabUser.panelRequests].each(function(ele) {
				if (ele == null) return;
				var elements = ele.getElements('div');
				ele.content = elements[1];
				elements[0].content = elements[1];
				elements[0].owner = ele;
				elements[0].addEvent('click', function(evt){
					evt.stop();
					this.owner.toggleClass('closed');
					this.owner.toggleClass('open');
					this.owner.toggleClass('close');
					this.content.toggle();
				});
			});
		}
	};

	tabContainer.removeTab = function(tab, avoidEventRemove) {
		tab.active = false;

		var currentActive = tab.hasClass('active');
		if (currentActive) {
			var tabs = tab.isChat ? this.chats : this.tabs;
			var switchTo = this.tabHome;
			
			if (tabs.length >= 2) {
				var candidates = tabs.filter(function(item, index) {
					return index == 1;
				});
				if (candidates.length == 1) switchTo = candidates[0];
			}
			
			this.switchTab(switchTo, false);
		}
		
		if (tab.content) tab.content.destroy();
		
		if (! tab.isChat) {
			new Request({
				method: 'post',
				data: {
					search: this.value
				},
				url: CONTEXT + '/apia.splash.MenuAction.run?action=removeTab&isAjax=true&tabId=' + tab.tabId + TAB_ID_REQUEST
			}).send();
		}
		
		
		if (tab.isChat) {
			this.chats = this.chats.erase(tab);
			this.computeSizeContainerScroll(this.chats, true, tab.isChat);
		} else {
			this.tabs = this.tabs.erase(tab);
			this.computeSizeContainerScroll(this.tabs, true, tab.isChat);
		}
		if (! avoidEventRemove) tab.fireEvent('remove');
		tab.destroy();
	}
	
	tabContainer.computeSizeContainerScroll = function(tabs, remove, chat) {
		var multiplier = remove ? -1 : 1;
		
		var scrollContainer = chat ? this.chatScrollContainer : this.tabScrollContainer;
		
		var currentWidthContainer = Number.from(scrollContainer.subContainer.getStyle("width"));
		
		var newSize = 0;
		
		for (var i = 0; i < tabs.length; i++) {
			var tab = tabs[i];
			var tabWidth = tab.getDimensions({computeSize: true}).totalWidth;
			var tabMarginRight = Number.from(tab.getStyle("margin-right"));
			var tabMarginLeft = Number.from(tab.getStyle("margin-left"));
			
			newSize += tabMarginRight + tabWidth + tabMarginLeft;
		}
		
		scrollContainer.subContainer.setStyle("width", newSize + "px");
		
		var currentWidthScroll = Number.from(scrollContainer.scrollContainerScroll.getDimensions({computeSize: true}).totalWidth);
		
		var activateScroll = newSize > currentWidthScroll;
		
		if (activateScroll) {
			scrollContainer.elemntScrollLeft.removeClass("dontShow");
			scrollContainer.elemntScrollRight.removeClass("dontShow");
			
			if (! remove) {
				scrollContainer.fxScroll.toElement(tab);
			}
		} else {
			scrollContainer.elemntScrollLeft.addClass("dontShow");
			scrollContainer.elemntScrollRight.addClass("dontShow");
		}
	}

	tabContainer.toggleFavorite = function(fncId) {
		new Request({
			method: 'post',
			url: CONTEXT + '/apia.splash.MenuAction.run?action=toggleFavorite&isAjax=true&favFncId=' + fncId + TAB_ID_REQUEST,
			onComplete: function(resText, resXml) { $('menuSearchInput').doSearch(); }
		}).send();
	}
	
	tabContainer.generateNewTabId = function() { return new Date().getTime(); }
	
	tabContainer.changeTabState = function(tabId, newState) {
		for (var i = 0; i  < this.tabs.length; i++) {
			if (this.tabs[i].tabId == tabId) {
				if (newState) {
					this.tabs[i].addClass('tabHighlighted');
				} else {
					this.tabs[i].removeClass('tabHighlighted');
				}
			}
		}
	}
	
	tabContainer.changeTabTitle = function(tabId, newTitle) {
		for (var i = 0; i  < this.tabs.length; i++) {
			if (this.tabs[i].tabId == tabId) {
				this.tabs[i].spanTitle.innerHTML = newTitle;
				this.computeSizeContainerScroll(this.tabs, false, false);
				return;
			}
		}
	}
	
	tabContainer.findJPivotTabByUrl = function(url) {
		if (url.indexOf(BI_PARTIAL_URL) != -1) { //Si el tab que estan intentando abrir es de JPivot
			for (var i = 0; i  < this.tabs.length; i++) { //Para cada tab abierto 
				//Si ya hay algun tab de JPivot
				if (this.tabs[i].originalUrl && this.tabs[i].originalUrl.indexOf(BI_PARTIAL_URL) != -1) return this.tabs[i];
			}
		}
		
		return null;
	}
	
	tabContainer.findTabByUrl = function(url) {
		for (var i = 0; i  < this.tabs.length; i++) {
			//if (this.tabs[i].originalUrl && this.tabs[i].originalUrl == url) return this.tabs[i];
			if (this.tabs[i].originalUrl && url) {
				
				if(this.tabs[i].originalUrl.replace('&forceAcquire=true', '') == url.replace('&forceAcquire=true', ''))
					return this.tabs[i];
			}
		}
		
		return null;
	}
	
	tabContainer.addNewTabs = function(tabsInfo, avoidTabControll, avoidAmountControll) {
		if (this.tabs != null && (this.tabs.length - 1 + tabsInfo.length) > MAX_AMOUNT_TABS && ! avoidAmountControll) { //se tiene que restar el tab home
			this.hiddeTab(this.tabMenu);
			
//			LBL_NEW_TABS_OPEN
//			LBL_NEW_TABS_OBSERVATION
			
			var modal = SYS_PANELS.newPanel();
			modal.header.innerHTML = TIT_WARNING;
			modal.addClass('modalWarning');
			new Element('p', {html: LBL_NEW_TABS_OPEN + " " + tabsInfo.length + " " + LBL_NEW_TABS_OBSERVATION}).inject(modal.content);
			
			var openNewTab = new Element('div', { 'class': 'button', html: BTN_NEW_TAB});

			openNewTab.tabsInfo = tabsInfo;
			
			openNewTab.addEvent('click', function(evt) {
				SYS_PANELS.closeAll();
				
				tabContainer.addNewTabs(this.tabsInfo, false, true);
			});
			
			openNewTab.inject(modal.footer);
			new Element('span', {html: '&nbsp;&nbsp;&nbsp;'}).inject(modal.footer);
			
			SYS_PANELS.addClose(modal, true, null);
			
			return;
		}
		
		if (tabsInfo != null && ! avoidTabControll) {
			var openTabs = new Array();
			var newTabs = new Array();
			var firstTab = null;
			
			var openTabsHaveTabControlURLS = false;
			
			for (var i = 0; i < tabsInfo.length; i++) {
				var tab = tabsInfo[i];
				var openTab = this.findTabByUrl(tab.url);
				
				if (openTab != null && firstTab == null) firstTab = openTab;
				
				var addTo = openTab != null ? openTabs : newTabs;
				addTo[addTo.length] = tab;
				
				for(var i_tab_control = 0; i_tab_control < TAB_CONTROL_URLS.length; i_tab_control++) {
					if(tab.url.contains(TAB_CONTROL_URLS[i_tab_control])) {
						openTabsHaveTabControlURLS = true
						break;
					}
				}
			}
			
			if (openTabs.length > 0) {
				
				if(openTabsHaveTabControlURLS) {
					if (newTabs.length > 0)
						tabContainer.addNewTabs(newTabs, true, true);
					else
						tabContainer.switchTab(firstTab);
					
					return;
				}
				
				var modal = SYS_PANELS.newPanel();
				modal.header.innerHTML = TIT_WARNING;
				modal.addClass('modalWarning');
				new Element('p', {html: MSG_TAB_IS_OPEN}).inject(modal.content);
				
				var openNewTab = new Element('div', { 'class': 'button', html: BTN_NEW_TAB});

				openNewTab.newTabs = newTabs;
				openNewTab.firstTab = firstTab;
				openNewTab.tabsInfo = tabsInfo;
				
				openNewTab.addEvent('click', function(evt) {
					SYS_PANELS.closeAll();
					
					tabContainer.addNewTabs(this.tabsInfo, true, true);
				});
				
				if (newTabs.length > 0) {
					var showActualTab = new Element('div', { 'class': 'button', html: BTN_CURRENT_TAB});
					showActualTab.tabOpen = openNewTab;
					showActualTab.addEvent('click', function(evt) {
						SYS_PANELS.closeAll();
						
						tabContainer.addNewTabs(this.tabOpen.newTabs, true, true);
					});
				} else {
					var showActualTab = new Element('div', { 'class': 'button', html: BTN_CURRENT_TAB});
					showActualTab.tabOpen = openNewTab;
					showActualTab.addEvent('click', function(evt) {
						SYS_PANELS.closeAll();
						
						tabContainer.switchTab(this.tabOpen.firstTab, false, evt);
					});
				}
				
				openNewTab.inject(modal.footer);
				new Element('span', {html: '&nbsp;&nbsp;&nbsp;'}).inject(modal.footer);
				showActualTab.inject(modal.footer);
				
				SYS_PANELS.addClose(modal, true, null);
				
				return;
			}
		}
		
		if (tabsInfo != null) {
			for (var i = 0; i < tabsInfo.length; i++) {
				var tab = tabsInfo[i];
				this.addNewTab(tab.title, tab.url, tab.fncId, null, true, true, i < tabsInfo.length - 1);
			}
		}
	}
	
	/**
	 * title: Titulo del tab
	 * ulr: URL del tab
	 * tokenId: Si viene, se usa ese, en lugar del de la sesion
	 */
	tabContainer.addNewTab = function(title, url, fncId, evt, avoidTabControll, avoidAmountControll, avoidContentLoad, tokenId) {
		var jpivotTab = this.findJPivotTabByUrl(url);
		
		if (jpivotTab != null) {
			
			var modal = SYS_PANELS.newPanel();
			modal.header.innerHTML = TIT_WARNING;
			modal.addClass('modalWarning');
			new Element('p', {html: LBL_ONLY_ONE_CUBE_OPEN}).inject(modal.content);
			
			SYS_PANELS.addClose(modal, true, null);
			
			return;
		}
		
		var openTab = this.findTabByUrl(url);
		
		var forceSwithTab = false;
		if (openTab != null && ! avoidTabControll && TAB_CONTROL_URLS != null) {
			for(var i_tab_control = 0; i_tab_control < TAB_CONTROL_URLS.length; i_tab_control++) {
				if(url.contains(TAB_CONTROL_URLS[i_tab_control])) {
					forceSwithTab = true
					break;
				}
			}
		}
		
		if (this.tabs.length > MAX_AMOUNT_TABS && ! avoidAmountControll && !forceSwithTab) {
			this.hiddeTab(this.tabMenu);
			
			var modal = SYS_PANELS.newPanel();
			modal.header.innerHTML = TIT_WARNING;
			modal.addClass('modalWarning');
			new Element('p', {html: LBL_NEW_TABS_ONE_TAB}).inject(modal.content);
			
			var openNewTab = new Element('div', { 'class': 'button', html: BTN_NEW_TAB});

			openNewTab.tabTitle = title;
			openNewTab.tabUrl = url;
			openNewTab.tabFncId = fncId;
			
			openNewTab.addEvent('click', function(evt) {
				SYS_PANELS.closeAll();
				
				tabContainer.addNewTab(this.tabTitle, this.tabUrl, this.tabFncId, evt, false, true, avoidContentLoad, tokenId);
			});
			
			openNewTab.inject(modal.footer);
			new Element('span', {html: '&nbsp;&nbsp;&nbsp;'}).inject(modal.footer);
			
			SYS_PANELS.addClose(modal, true, null);
			
			return;
		}
		
		
		
		if (openTab != null && ! avoidTabControll) {
			this.hiddeTab(this.tabMenu);
			
			if(forceSwithTab) {
				tabContainer.switchTab(openTab);
				return;
			}
			
			var modal = SYS_PANELS.newPanel();
			modal.header.innerHTML = TIT_WARNING;
			modal.addClass('modalWarning');
			new Element('p', {html: MSG_TAB_IS_OPEN}).inject(modal.content);
			
			var openNewTab = new Element('div', { 'class': 'button', html: BTN_NEW_TAB});
			var showActualTab = new Element('div', { 'class': 'button', html: BTN_CURRENT_TAB});

			openNewTab.tabTitle = title;
			openNewTab.tabUrl = url;
			openNewTab.tabFncId = fncId;
			
			openNewTab.addEvent('click', function(evt) {
				SYS_PANELS.closeAll();
				
				tabContainer.addNewTab(this.tabTitle, this.tabUrl, this.tabFncId, evt, true, true, avoidContentLoad, tokenId);
			});
			
			showActualTab.tabOpen = openTab;
			showActualTab.addEvent('click', function(evt) {
				SYS_PANELS.closeAll();
				
				tabContainer.switchTab(this.tabOpen, false, evt);
			});
			
			openNewTab.inject(modal.footer);
			new Element('span', {html: '&nbsp;&nbsp;&nbsp;'}).inject(modal.footer);
			showActualTab.inject(modal.footer);
			
			SYS_PANELS.addClose(modal, true, null);
			
			return;
		}
		
		var tabId = this.generateNewTabId();
		if (! fncId) fncId = "";
		
		var post_message_url = "";
		var split = url.split('/');
		if(split.length > 2 && split[1] == '') {
			post_message_url = split[0] + "//" + split[2];
		} else {
			post_message_url = split[0];
		}
		
		var custom_tab_id_request = TAB_ID_REQUEST;
		if(tokenId != null)
			custom_tab_id_request = "&tokenId=" + tokenId;
		
		var content = avoidContentLoad ? null : new IFrame({
			frameborder: 0, 
			'class': 'tabContent',
			'src': url + ((url.indexOf("?") == -1) ? "?" : "&") + "tabId=" + tabId + "&favFncId=" + fncId + custom_tab_id_request,
			events: {
				load: function(e) {
					var split = e.target.get('src').split('/');
					var post_message_url = split[0] + '//' + split[2];
					
					XD.receiveMessage(function(message) {
						XD.receiveMessage(null, post_message_url);
						
						if(message.data == "custom_close_tab") {
							getTabContainerController().removeActiveTab();
						}
					}, post_message_url);
				}
			}
		});
		
		var tab = new Element('div', {'class': "tab"});
		tab.avoidContentLoad = avoidContentLoad;
		tab.content = content;
		tab.tabId = tabId;
		tab.fncId = fncId;
		tab.originalUrl = url;
		tab.isChat = false;
		
		var tabContent = new Element('div', {'class': 'content'});
		tabContent.inject(tab);
		
		tab.spanTitle = new Element('span', {'html': title});
		tab.spanTitle.inject(tabContent)
		
		this.initTab(tab);

		var remover = new Element('span', {'class': 'remover', 'html': 'x', 'title': GNR_NAV_ADM_CLOSE});
		remover.tab = tab;
		remover.canClose = function() {
			try {
				if (! this.tab) return true;
				if (! this.tab.content) return true;
				if (! this.tab.content.contentWindow) return true;
				if (! this.tab.content.contentWindow.document) return true;
				
				var controller = this.tab.content.contentWindow.document.getElementById('bodyController');
				if (! controller) return true;
				if (! controller.canRemoveTab) return true;
				
				return controller.canRemoveTab();
			} catch (e) {
				return true;
			}
		};
		remover.forceClose = function() {
			var whyCantClose = "";
			
			if (
					! this.tab &&
					! this.tab.content &&
					! this.tab.content.contentWindow &&
					! this.tab.content.contentWindow.document) {
			
				var controller = this.tab.content.contentWindow.document.getElementById('bodyController');
				if (! controller && ! controller.cantRemoveTabBecause) whyCantClose = controller.cantRemoveTabBecause();
			}
			
			if (! whyCantClose || whyCantClose == "") whyCantClose = MSG_FORCE_CLOSE;
			
			showConfirm(whyCantClose, TIT_FORCE_CLOSE, function(confirmClose) { if (confirmClose) this.closeTab(); }.bind(this), "modalWarning")
		}
		remover.closeTab = function() { this.tab.container.removeTab(this.tab); };
		remover.addEvent("click", function(evt) { 
			if (this.canClose()) {
				this.closeTab();
			} else {
				this.forceClose();
			}
		});
		remover.inject(tabContent);

		if (! avoidContentLoad) content.inject(this.contentContainer);
		tab.inject(this.tabScrollContainer.subContainer);
		
		this.tabs.push(tab);
		if (! avoidContentLoad) {
			this.switchTab(tab, false, evt);
			this.computeSizeContainerScroll(this.tabs, false, false);
		}
	}
	
	tabContainer.createNewChatTab = function(title, content) {
		var tabId = this.generateNewTabId();
		
		var tab = new Element('div', {'class': "tab"});
		tab.content = content;
		tab.tabId = tabId;
		tab.isChat = true;
		
		tab.open = function() { if (! this.hasClass('active')) this.fireEvent('click'); }
		tab.close = function() { if (this.hasClass('active')) this.fireEvent('click'); }
		tab.closeAndDestroy = function() {
			this.container.removeTab(this, true);
		}
		
		var tabContent = new Element('div', {'class': 'content', 'html': title});
		tabContent.inject(tab);
		
		this.initTab(tab);

		var remover = new Element('span', {'class': 'remover', 'html': 'x', 'title': 'cerrar'});
		remover.tab = tab;
		remover.addEvent("click", function(evt) { this.tab.container.removeTab(this.tab); });
		remover.inject(tabContent);

		content.inject(this.contentContainer);
		tab.inject(this.chatScrollContainer.subContainer);
		
		this.chats.push(tab);
		this.switchTab(tab, false);
		
		this.computeSizeContainerScroll(this.tabs, false, true);
		
		return tab;
	};
	
	tabContainer.chat_window_default = 220;
	tabContainer.max_chat_content_height = 340;
	//tabContainer.max_inner_chat_content_height = 300;
	tabContainer.max_inner_chat_content_height = 297;
	
	/**
	 * Recorre las ventanas de chat, cambiando el tama�o si amerita
	 */
	tabContainer.resizeChatWindows = function() {
		if(this.chats.length) {
			
//			if(frames[0].document.body.scrollWidth > frames[0].document.body.getWidth())
//				hor_scroll = 18;
//			else
//				hor_scroll = 0;
			
			hor_scroll = 13;
			
//			var bottom = 32;
//			if(frames[0].document.body.scrollHeight > frames[0].document.body.getHeight())
//				bottom = 50;
			
			var bottom = 0;
			
			if(this.chats.length == 1) {
				//1 sola ventana
				this.chats[0].setStyles({
					'width': tabContainer.chat_window_default,
					'right': 5 + hor_scroll, 
					'bottom': bottom
				});	
				this.chats[0].getElement('div.chat-title-text').setStyle('width', tabContainer.chat_window_default - 35);
				var chat_content = this.chats[0].getElement('div.chat-content');
				var over_height = chat_content.getHeight() - tabContainer.max_chat_content_height;
				chat_content = chat_content.getElement('div.chatContent');
				if(chat_content) {
					if(over_height > 0) {
//						chat_content.setStyle('height', tabContainer.max_inner_chat_content_height - over_height);
						//var new_height = tabContainer.max_chat_content_height - (chat_content.getPrevious("div.chatParticipants").getHeight() + 20);
						var new_height = tabContainer.max_chat_content_height - (chat_content.getPrevious("div.chatParticipants").getHeight() + 23);
						chat_content.setStyle('height', new_height);
					} else if(over_height < 0) {
//						chat_content.setStyle('height', tabContainer.max_inner_chat_content_height);
//						var new_height = tabContainer.max_chat_content_height - (chat_content.getPrevious("div.chatParticipants").getHeight() + 20);
						var new_height = tabContainer.max_chat_content_height - (chat_content.getPrevious("div.chatParticipants").getHeight() + 23);
						chat_content.setStyle('height', new_height);
					}
				}
			} else {
				//Calcular ancho para otras ventanas
				var current_width = document.body.getWidth() - (tabContainer.chat_window_default + 15) - hor_scroll;
				
				var custom_width = current_width / (this.chats.length - 1);
				
				custom_width -= 15;
				
				if(custom_width > tabContainer.chat_window_default + 15)
					custom_width = tabContainer.chat_window_default;
				
				//Asumir que las ventanas est�n ordenadas
				var right_offset = 5 + hor_scroll;
				
				//Buscar la ventana activa
				$each(this.chats, function(c) {
					c.setStyle('right', right_offset);
					c.setStyle('bottom', bottom);
					if(c.active) {
						c.setStyle('width', tabContainer.chat_window_default);
						c.getElement('div.chat-title-text').setStyle('width', tabContainer.chat_window_default - 35);
						right_offset += tabContainer.chat_window_default + 15;
					} else {
						c.setStyle('width', custom_width);
						c.getElement('div.chat-title-text').setStyle('width', custom_width - 35);
						right_offset += custom_width + 15;
					}
					
					var chat_content = c.getElement('div.chat-content');
					var over_height = chat_content.getHeight() - tabContainer.max_chat_content_height;
					chat_content = chat_content.getElement('div.chatContent');
					if(chat_content) {
						if(over_height > 0) {
//							chat_content.setStyle('height', tabContainer.max_inner_chat_content_height - over_height);
							//var new_height = tabContainer.max_chat_content_height - (chat_content.getPrevious("div.chatParticipants").getHeight() + 20);
							var new_height = tabContainer.max_chat_content_height - (chat_content.getPrevious("div.chatParticipants").getHeight() + 23);
							chat_content.setStyle('height', new_height);
						} else if(over_height < 0) {
//							chat_content.setStyle('height', tabContainer.max_inner_chat_content_height);
							//var new_height = tabContainer.max_chat_content_height - (chat_content.getPrevious("div.chatParticipants").getHeight() + 20);
							var new_height = tabContainer.max_chat_content_height - (chat_content.getPrevious("div.chatParticipants").getHeight() + 23);
							chat_content.setStyle('height', new_height);
						}
					}
				});
			}
		}
	}
	
	window.addEvent('resize', function() {
		setTimeout(function() {
			tabContainer.resizeChatWindows();
		}, 100);
	});
	
	tabContainer.createNewChatWindow = function(title, content) {
		var tabId = this.generateNewTabId();
		
		var win = new Element('div.chat-window', {
			/*content: content,*/
			tabId: tabId,
			isChat: true
		});
		
		win.content = content;
		win.open = function() { if (! this.hasClass('active')) this.fireEvent('click'); };
		//win.close = function() { if (this.hasClass('active')) this.fireEvent('click'); };
		//win.closeAndDestroy = function() { this.container.removeTab(this, true); };
		
		var chats = this.chats;
		
		win.addEvent('click', function() {
			if(!this.active) {
				$each(chats, function(c) {
					c.active = false;
				});
				this.active = true;
				tabContainer.resizeChatWindows();
			}
		});
		
		$each(this.chats, function(c) {
			c.active = false;
		});
		win.active= true;
		
		var title = new Element('div.chat-title.chat-title-bg', {'html': '<div class="chat-title-text" title="' + title + '">' + title + '</div>'});
		title.inject(win);
		
		title.getElement('div.chat-title-text').addEvent('click', function() {
			//var input = this.getParent().getNext().getElement('input');
			var input = this.getParent().getNext().getElement('textarea');
			var l = input.get('value').length;
			input.selectRange(l, l);
		});
		
		//title.getElement('div.chat-title-text').addEvent('dblclick', function() {
		title.getElement('div.chat-title-text').addEvent('click', function() {
			this.getNext().getNext().fireEvent('click');
			//var input = this.getParent().getNext().getElement('input');
			//tinymce.get(this.getParent().getNext().getElement('textarea').get('id')).focus();
			var area_id = this.getParent().getNext().getElement('textarea').get('id');
			setTimeout(function() {
				//var l = input.get('value').length;
				//input.selectRange(l, l);
				tinymce.get(area_id).focus();
			}, 500);
			
		});
		
		title.isOpen = true;
		/*
		new Drag(win, {
			handle: title
		})
		*/
		var remover = new Element('span.remover', {'html': 'x', 'title': LBL_CLOSE_WIN});
		
		remover.addEvent("click", function(evt) {
			
			evt.stopPropagation();
			if(PARAMETER_CHAT_CONFIRM_CLOSE) {
				var _this = this;
				showConfirm(LBL_CHAT_MSG_CONF_CLOSE, LBL_CHAT_TIT_CONF_CLOSE, function(res) {
					if(res) {
						if (win.content) win.content.destroy();
						_this.chats = _this.chats.erase(win);
						win.fireEvent('remove');
						win.destroy();
						
						tabContainer.resizeChatWindows();
					}
				});
			} else {
				if (win.content) win.content.destroy();
				this.chats = this.chats.erase(win);
				win.fireEvent('remove');
				win.destroy();
				
				tabContainer.resizeChatWindows();
			}
			
		}.bind(this));
		
		remover.inject(title);
		
		var minimizer = new Element('span.minimizer', {'html': '-', 'title': LBL_MINIMIZE_WIN});
		minimizer.isOpen = true;
		minimizer.addEvent('click', function() {
			if(this.isOpen) {
				win.content.setStyle('display', 'none');
//				win.setStyle('height', 30);
				win.setStyle('height', 28);
			} else {
				win.content.setStyle('display', 'block');
				win.setStyle('height', '');
			}
			this.isOpen = !this.isOpen;
		});
		
		minimizer.inject(title);
		
		content.inject(win);
		
		this.chats.push(win);
		//this.switchTab(win, false);
		
		//win.inject(this.contentContainer);
		//win.inject($('tabContentContainer'));
		var tabUser = $('tab-2');
		win.inject(tabUser, 'before');
		
		win.setStyle('z-index', tabUser.getStyle('z-index'));
		
		/*
		if(this.chats.length > 1)
			win.setStyle('right', (this.chats.length - 1) * 215);
		else
			win.setStyle('right', 5);
		*/
		
//		if(frames[0].document.body.scrollHeight > frames[0].document.body.getHeight())
//			win.setStyle('bottom', 50); 
//		else
//			win.setStyle('bottom', 32);
		win.setStyle('bottom', 0);
		
		tabContainer.resizeChatWindows();
		
		return win;
	}
	
	$('chatUsersFilter').addEvent('click', function(evt) {
		//Click sobre el elemento
		
		if(this.getParent().getParent().hasClass('open'))
			evt.stopPropagation();
		
		//Agrandar elemento
		new Fx.Morph(this, {duration: 200, wait: false}).start({
			width: 120
		})
		
	}).addEvent('blur', function() {
		if(this.get('value') == '') {
			new Fx.Morph(this, {duration: 200, wait: false}).start({
				width: 0
			})
		}
	});
	
	tabContainer.init = function(tabs, contentContainer) {
		tabs.each(function(tab) {
			this.initTab(tab);
		}, this);

		this.contentContainer = contentContainer;
	};

	$('menuModeSearch').addEvent('click', function(evt) {
//		var menuSearchInput = $('menuSearchInput');
//		menuSearchInput.removeClass('hidden');
//		menuSearchInput.addClass('visble');
//		try {menuSearchInput.focus() } catch(e) {}

		var resultModeSearch = $('resultModeSearch');
		var resultModeTree = $('resultModeTree');
		
		resultModeSearch.removeClass('dontShow');
		resultModeSearch.addClass('doShow');

		resultModeTree.removeClass('doShow');
		resultModeTree.addClass('dontShow');
		resultModeTree.innerHTML = "";
		resultModeTree.innerTreeLoaded = false;
	});
	
	$('menuModeTree').addEvent('click', function(evt) {
//		var menuSearchInput = $('menuSearchInput');
//		menuSearchInput.addClass('hidden');
//		menuSearchInput.removeClass('visble');
		
		var resultModeSearch = $('resultModeSearch');
		var resultModeTree = $('resultModeTree');
		
		resultModeSearch.removeClass('doShow');
		resultModeSearch.addClass('dontShow');
		
		resultModeTree.removeClass('dontShow');
		resultModeTree.addClass('doShow');
		
		loadTree(-1);
	});

	//Establecer comportamiento del input de b�squeda
	$('menuSearchInput').addEvent('keydown', function(evt) {
		if (this.value == LABEL_SEARCH_FUNCTIONALITY) {
			this.removeClass('searchStart');
			this.value = "";
		}
	});
	
	$('menuSearchInput').addEvent('focus', function(evt) {
		evt.stop();
		if (this.value == LABEL_SEARCH_FUNCTIONALITY) {
			this.removeClass('searchStart');
			this.value = "";
		}
	});
	
	$('menuSearchInput').addEvent('blur', function(evt) {
		evt.stop();
		if (this.value == "") {
			this.addClass('searchStart');
			this.value = LABEL_SEARCH_FUNCTIONALITY;
			$('menuModeTree').fireEvent('click');
		}
	});
	
	$('menuSearchInput').doSearch = function() {
		if (this.value.length >= 1 && this.value != LABEL_SEARCH_FUNCTIONALITY) {
			$('menuModeSearch').fireEvent('click');
			
			var resultModeSearch = $('resultModeSearch');
			if (resultModeSearch.doingSearch) return;
			resultModeSearch.doingSearch = true;
			resultModeSearch.doingSearchFor = this.value;

			if (! resultModeSearch.spinner) resultModeSearch.spinner = new Spinner(resultModeSearch);
			//resultModeSearch.spinner.show(true);
			resultModeSearch.innerHTML = "";
			
			resultModeSearch.removeClass('resultModeSearchInfo');
			
			new Request({
				method: 'post',
				data: {
					search: this.value
				},
				url: CONTEXT + '/apia.splash.MenuAction.run?action=filterFunctionality&isAjax=true' + TAB_ID_REQUEST,
				onComplete: function(resText, resXml) { processSearchFunctionalityXml(resXml); }
			}).send();
		} else {
			$('menuModeTree').fireEvent('click');
			var resultModeSearch = $('resultModeSearch');
//			resultModeSearch.innerHTML = LABEL_SEARCH_FUNCTIONALITY_INFO;
			resultModeSearch.addClass('resultModeSearchInfo');
			this.addClass('searchStart');
			this.value = LABEL_SEARCH_FUNCTIONALITY;
		}
	}
	$('menuSearchInput').addEvent("keyup", function(e) {
		if(e) {
			if(e.code == 40) {
				//Modo de seleccion manual
				var menuElements = $$('div.searchElement');
				var tabContainer = $('tabContainer');
				
				if(tabContainer.selectedIndex == null || tabContainer.selectedIndex == undefined)
					tabContainer.selectedIndex = -1;
				
				if(menuElements && menuElements.length && tabContainer.selectedIndex + 1 < menuElements.length) {
					
					tabContainer.selectedIndex++;				
					menuElements[tabContainer.selectedIndex].fireEvent('selected');
				}
				return;
			} else if(e.code == 38) {
				//Modo de seleccion manual
				var menuElements = $$('div.searchElement');
				var tabContainer = $('tabContainer');
				
				if(tabContainer.selectedIndex == null || tabContainer.selectedIndex == undefined)
					return;
				
				if(menuElements && menuElements.length && tabContainer.selectedIndex > 0) {
					
					tabContainer.selectedIndex--;
					menuElements[tabContainer.selectedIndex].fireEvent('selected');
				}
				return;
			} else if(e.code == 13) {
				var tabContainer = $('tabContainer');
				if(tabContainer.selectedOption) {
					tabContainer.selectedOption.fireEvent('click');
					return;
				}
			}
		}
		if (this.timmer) $clear(this.timmer);
		this.timmer = this.doSearch.delay(200, this);
	});
	
	//Establecer par�metros del modo tree view
//	InitialiseTreeView("resultModeTree");
//	
//	d = CreateTreeViewItem( treeViewRootCell, 
//			-1,
//			LABEL_OPEN_TREE, 
//			null, 
//			"-1", 
//			false, 
//			1,
//			null );
//
//	treeViewToggle(-1);
	
	//Init container
	tabContainer.canFireEvents = false;
	tabContainer.init($$('div.tab'), $('tabContentContainer'));
	tabContainer.switchTab($('tabHome'));
	tabContainer.canFireEvents = true;
	$('menuModeSearch').fireEvent('click');
	
	//Init chat
	initChatUI();
	
	//inicializar mascara de modal de config.
	$('configModal').blockerModal = new Mask(null, {'class': 'maskConfiguration'});
	
	$('closeConfigModal').addEvent('click', function(evt){
		closeConfigModal();
	});
	
	var btnMoreConf = $('btnMoreConfModal');
	if (btnMoreConf) {
		btnMoreConf.addEvent('click', function (evt){
			closeConfigModal();
			var request = new Request({
				method: 'post',
				url: CONTEXT + '/apia.splash.SplashAction.run?action=splashEdit' + '&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send();
		});
	}
	
	var btnSaveConfModal = $('btnSaveConfModal');
	if (btnSaveConfModal) {
		btnSaveConfModal.addEvent('click', function (evt){
			closeConfigModal();
			var request = new Request({
				method: 'post',
				url: CONTEXT + '/apia.splash.SplashAction.run?action=splashSaveUserHome' + '&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send();
		});
	}
	
	var btnRestConfModal = $('btnRestConfModal');
	if (btnRestConfModal) {
		btnRestConfModal.addEvent('click', function (evt){
			closeConfigModal();
			var request = new Request({
				method: 'post',
				url: CONTEXT + '/apia.splash.SplashAction.run?action=splashResetHome' + '&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send();
		});
	}
	
	var btnPassConfModal = $('btnPassConfModal');
	if (btnPassConfModal) {
		btnPassConfModal.addEvent('click', function (evt){
			closeConfigModal();
			var request = new Request({
				method: 'post',
				url: CONTEXT + '/apia.splash.SplashAction.run?action=splashResetPass' + '&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send();
		});
	}
	
	var btnLangConfModal = $('btnLangConfModal');
	if (btnLangConfModal) {
		btnLangConfModal.addEvent('click', function (evt){
			closeConfigModal();
			var request = new Request({
				method: 'post',
				url: CONTEXT + '/apia.splash.SplashAction.run?action=splashChangeLang' + '&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send();
		});
	}
	
	var btnStyleConfModal = $('btnStyleConfModal');
	if (btnStyleConfModal) {
		btnStyleConfModal.addEvent('click', function (evt){
			closeConfigModal();
			var request = new Request({
				method: 'post',
				url: CONTEXT + '/apia.splash.SplashAction.run?action=splashChangeStyle' + '&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send();
		});
	}
	
	var btnStartConfModal = $('btnStartConfModal');
	if (btnStartConfModal) {
		btnStartConfModal.addEvent('click', function (evt){
			closeConfigModal();
			var request = new Request({
				method: 'post',
				url: CONTEXT + '/apia.splash.SplashAction.run?action=splashStartDash' + '&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send();
		});
	}
	/*
	//Listener para el drag de tareas
	document.body.addEvent('dragtask', function(event) {
		
		event.stop();
		
		document.body.setCapture();
		
		var table = this;

		var clone = new Element('div.drag-task').setStyles({
			top: event.client.y + 47 - 24,
			left: event.client.x - 24,
			opacity: 0.7,
			position: 'absolute'
	    }).inject(document.body);

		
	    var drag = new Drag.Move(clone, {

	      droppables: $$('div.chatContent'),

	      onDrop: function(dragging, cart){

	        dragging.destroy();

	        if (cart != null){
	          console.log("Se drope� en el chat")
	        }
	        
	        document.body.releaseCapture();
	      },
	      onEnter: function(dragging, cart){
	        cart.tween('background-color', '#98B5C1');
	      },
	      onLeave: function(dragging, cart){
	        cart.tween('background-color', '#FFF');
	      },
	      onCancel: function(dragging){
	        dragging.destroy();
	        document.body.releaseCapture();
	      }
	    });
	    drag.start(event);
	});
	*/
	tabContainer.changeHome = function(url, dshId) {
		for (var i = 0; i < this.tabs.length; i++) {
			if (this.tabs[i].id == "tabHome") {
				this.tabs[i].content.src = url + TAB_ID_REQUEST + "&tabId=";
				this.tabs[i].dshId = dshId;
				break;
			}
		}
	}
	
	tabContainer.getCurrentDsh = function() {
		for (var i = 0; i < this.tabs.length; i++) {
			if (this.tabs[i].id == "tabHome") {
				return this.tabs[i].dshId;
			}
		}
	}
	
}

function reloadHome(){
	SYS_PANELS.showLoading();
	window.location.href = 'apia.security.LoginAction.run?action=gotoSplash' + TAB_ID_REQUEST;
}

function changeEnvironment(envName){
	//Actualiza nombre del ambiente
	$('tabUser').innerHTML = $('tabUser').innerHTML.replace(/\|.*\|/,'| ' + envName + ' |');
	
	//Se cierran todas las tabs abiertas
	i=0;
	while (tabContainer.tabs.length > 1){
		tab = tabContainer.tabs[i++];
		if (tab.id!="tabHome"){
			tabContainer.removeTab(tab);
			i=0;
		}
	} 
	
	//Actualizacion de funcionalidad del nuevo ambiente
	$('menuModeSearch').fireEvent('click');	
	$('menuModeTree').fireEvent('click');
}

function closeConfigModal() {
	configModal.blockerModal.hide();
	configModal.setStyle('display','none');
}

function initChatUI() {
	if (! CHAT_ENVIRONMENT_ENABLED) {
		$('chatContainerInformation').addClass('dontShow');
	}
	
	var chatStatusOption = $('chatStatusOption');
	chatStatusOption.addEvent('change', function(evt){
		if (this.selectedIndex == 0) {
			//Recordar que est� logeado
			Cookie.write('chatLogged', 'true');
			$('tabUser').removeClass('tabUserDisconnected');
			if (! uiChat.automaticReconnect) {
				uiChat.automaticDisconnect = false;
				uiChat.automaticReconnectCount = 0;
				$clear(uiChat.automaticReconnectDelay);
				uiChat.doLogin();
			}
		} else {
			uiChat.automaticDisconnect = false;
			uiChat.doLogout();
			//Recordar que no est� logeado
			Cookie.write('chatLogged', 'false');
		}
	});
	
	uiChat = new ApiaChatUI({
		hasLogin: false,
		url: 'server.chat',
		urlDownload: 'server.chat',
		loginTitle: CHAT_TIT_LOGIN,
		mainTitle: CHAT_LBL_CONVERSATION,
		openMainOnLogged: false,
		onCloseMainDisconect: false,
		mainDialog: tabContainer.tabUser
	});
	
	uiChat.addEvent('errorConnection', function() { 
		$('tabUser').addClass('tabUserDisconnected');
		uiChat.automaticDisconnect = true;
		uiChat.automaticDisconnectAlert = showMessage(MSG_SRV_CONNECTION_LOST, "Apia", "modalWarning");
		uiChat.doLogout(true);
		$('chatStatusOption').selectedIndex = 1;
		
		if (uiChat.automaticReconnectCount == null) uiChat.automaticReconnectCount = 1;
		uiChat.automaticReconnectCount = uiChat.automaticReconnectCount + 1;
		if (uiChat.automaticReconnectCount <= AMOUNT_TRY_RECONNECT) uiChat.automaticReconnectDelay = doReconnect.delay((uiChat.automaticReconnectCount - 1) * (DELAY_UNIT_RECONNECT * 1000));
	});
	
	if(CHAT_ENVIRONMENT_ENABLED) {
		if(Cookie.read('chatLogged') != 'false') {
			uiChat.automaticReconnect = false;
			uiChat.automaticReconnectCount = 0;
			uiChat.doLogin();
		} else {
			$('chatStatusOption').selectedIndex = 1;
			uiChat.automaticDisconnect = false;
			uiChat.doLogout();
			$('tabUser').fireEvent('logoutDone');
		}
	}
}

var AMOUNT_TRY_RECONNECT = 100;
var DELAY_UNIT_RECONNECT = 1;

function doReconnect() {
	if (uiChat.automaticDisconnectAlert) {
		try { uiChat.automaticDisconnectAlert.closeButton.fireEvent('click'); } catch (e) {}
		uiChat.automaticDisconnectAlert = null;
	}
	uiChat.automaticReconnect = true;
	uiChat.doLogin();
}

function getRealWindow() {
	if (IN_IFRAME) {
	  return window.parent.window;
	}

	return window;
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

function adjustIFrameHeight(iframe) {
	iframe.setStyle('height', parseInt(getStageHeight() - $('tabContainer').offsetHeight - 10));
	$('tabContentContainer').setStyle('height', iframe.getStyle('height'));
}

function processSearchFunctionalityXml(ajaxCallXml){
	var result = $('resultModeSearch');

	result.innerHTML = "";
	
	var code = ajaxCallXml.getElementsByTagName("code");
	
	if (code != null && code.item(0) != null && "0" != code.item(0).firstChild.nodeValue) {
		processAjaxExceptions(ajaxCallXml);
	} else {
		var fncs = (ajaxCallXml != null) ? ajaxCallXml.getElementsByTagName("functionality") : null;
		if (fncs != null && fncs.length > 0) {
			for (var i = 0; i < fncs.length; i++) {
				var fnc = fncs[i];
				
				var element = {
					fncId: fnc.attributes.getNamedItem("fncId").value, 
					isFav: fnc.attributes.getNamedItem("isFav").value,
					show: fnc.attributes.getNamedItem("show").value, 
					title: fnc.attributes.getNamedItem("title").value, 
					url: fnc.attributes.getNamedItem("url").value
				};
				
				if (element.url.indexOf("redirect.jsp?link=") == 0) element.url = element.url.substring("redirect.jsp?link=".length);
				
				var menuElement = new Element("div", {'class': 'menuElement' });
				
				var div = new Element("div", {html: element.show, 'class': 'searchElement left' });
				div.tabTitle = element.title;
				div.tabUrl = replaceAll(element.url,"&amp;","&");
				div.fncId = element.fncId;
				div.addEvent("click", function(evt) { $('tabContainer').addNewTab(this.tabTitle, this.tabUrl, this.fncId); });
				div.addEvent('mouseover', function(evt) { this.addClass("searchElementOver"); });
				div.addEvent('mouseout', function(evt) { this.removeClass("searchElementOver"); });
				div.addEvent('selected', function() {	
					var tabContainer = $('tabContainer');
					if(tabContainer.selectedOption)
						tabContainer.selectedOption.fireEvent('mouseout');
					tabContainer.selectedOption = this;
					this.fireEvent('mouseover');
				});
				div.inject(menuElement);
				
				
				menuElement.addEvent('mouseover', function(evt) { this.addClass("searchElementOver"); });
				menuElement.addEvent('mouseout', function(evt) { this.removeClass("searchElementOver"); });
				menuElement.inject(result);

				if (element.fncId) {
					var favDiv = new Element("div");
					favDiv.addClass("favSelection");
					
					
					
					if (element.isFav == "true") favDiv.addClass("favIs");
					favDiv.fncId = element.fncId;
					favDiv.addEvent("click", function(evt) { evt.stop(); $('tabContainer').toggleFavorite(this.fncId);});
					favDiv.inject(menuElement);
				}
				
			}
		}
	}
	
	$('tabContainer').selectedIndex = null;
	
	if (result.spinner) {
		result.spinner.hide();
		//result.spinner.destroy();
		//result.spinner = null;
	}

	result.doingSearch = false;
	if (result.doingSearchFor != $('menuSearchInput').value) $('menuSearchInput').fireEvent("keyup");
}

function jsCaller(fnc, data) {
	fnc(data);
}

function forceLogout() {
	try{
		try{
			
			var request = new Request({
				method: 'post',
				url: CONTEXT + '/apia.security.LoginAction.run?action=logout' + TAB_ID_REQUEST
			}).send();
		}catch(e){}
		return 1;
	} catch (e){}
}