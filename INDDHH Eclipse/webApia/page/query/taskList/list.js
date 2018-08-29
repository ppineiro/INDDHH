function initPage(){
	
	TAB_ID_REQUEST = TAB_ID_REQUEST + "&workingMode=" + WORKING_MODE;
	
	$('clearFilters').addEvent('click', function(e) {
		if (e) e.stop;
		$('cmbTskQnt').selectedIndex = 0;
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	
	var btnAcquire = $('btnAcquire');
	var btnRelease = $('btnRelease');
	var btnWork = $('btnWork');
	var btnRefresh = $('btnRefresh');
	var btnColumns = $('btnColumns');
	
	var isAcquireMode = btnAcquire != null;
	
	if (btnAcquire) {
		btnAcquire.addEvent('click', function(evt){
			var id = controllAtLeastOneSelected();
			
			if (id) {
				var theParent = window.parent.document;
				var iframeAcquired = theParent.getElementById('iframeAcquired');
				if (iframeAcquired) iframeAcquired.contentDirty = true;
				
				var request = new Request({
					method: 'post',
					url: CONTEXT + URL_REQUEST_AJAX + "?action=acquire" + TAB_ID_REQUEST,
					onRequest: function() { sp.show(true); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
				}).send(id);
			}
		});
	}
	
	if (btnRelease) {
		btnRelease.addEvent('click', function(evt){
			var id = controllAtLeastOneSelected();
			
			if (id) {
				var theParent = window.parent.document;
				var iframeReady = theParent.getElementById('iframeReady');
				if (iframeReady) iframeReady.contentDirty = true;
				
				var request = new Request({
					method: 'post',
					url: CONTEXT + URL_REQUEST_AJAX + "?action=release" + TAB_ID_REQUEST,
					onRequest: function() { sp.show(true); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
				}).send(id);
			}
		});
	}
	
	if (btnWork) {
		btnWork.addEvent('click', function(evt){
			var id = controllAtLeastOneSelected();
			
			if (id) {
				var theParent = window.parent.document;
				var iframeAcquired = theParent.getElementById('iframeAcquired');
				var iframeReady = theParent.getElementById('iframeReady');
				
				if (iframeAcquired) iframeAcquired.contentDirty = true;
				if (iframeReady) iframeReady.contentDirty = true;
				
				var request = new Request({
					method: 'post',
					url: CONTEXT + URL_REQUEST_AJAX + "?action=work" + TAB_ID_REQUEST,
					onRequest: function() { sp.show(true); },
					onComplete: function(resText, resXml) { processXmlWorkTasks(resXml); sp.hide(true); }
				}).send(id);
			}
		});
	}
	
	if (btnRefresh){
		btnRefresh.addEvent("click",function(e){
			e.stop();
			var navRefresh = $('navRefresh');
			if (navRefresh){
				navRefresh.fireEvent("click");
			}
		});
	}
	
	if (btnColumns){
		btnColumns.addEvent("click",function(e){
			e.stop();
			showQryTskLstColumnsModal(WORKING_MODE,processRetModalColumns);
		});
	}
	
	var btnCloseTab = $('btnCloseTab');
	if (btnCloseTab) {
		btnCloseTab.addEvent('click', function() {
			if(FROM_MINISITE) {
				SYS_PANELS.showLoading();
				window.parent.location = 'apia.security.LoginAction.run?action=gotoMinisiteQueries' + TAB_ID_REQUEST;
			} else {	
				getTabContainerController(true).removeActiveTab();
			}
		});
	}
	
	//*********************   Table Events   **********************	
	$('tableData').getParent().addEvent("dblClic", function(row){
		btnWork.fireEvent('click');
	});
	
	initQueryButtons();
	initAdminFav();
	initNavButtons();
	customizeRefresh();
	initQryTskLstColumnsMdlPage();
	
	callNavigateRefresh();
}

function processXmlWorkTasks(ajaxCallXml){
	if (ajaxCallXml != null) {
		var tasks = ajaxCallXml.getElementsByTagName("tasks");
		if (tasks != null && tasks.length > 0 && tasks.item(0) != null) {
			tasks = tasks.item(0).getElementsByTagName("task");
			
			for(var i = 0; i < tasks.length; i++) {
				var task = tasks[i];
				
				var tabTitle = task.getAttribute("title");
				var tabContainer = window.parent.parent.document.getElementById('tabContainer');
				var url = 'apia.execution.TaskAction.run?action=getTask&proInstId=' + task.getAttribute("proInstId") + '&proEleInstId=' + task.getAttribute("proEleInstId");
				tabContainer.addNewTab(tabTitle,url,null);
			}									
		}
	}
	callNavigateRefresh();
}

function processRetModalColumns(ret){
	if (ret){
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=setModalCookieColumns&isAjax=true&workingMode=' + WORKING_MODE + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send("&columns=" + ret);
	}	
}

function reloadList(){
	SYS_PANELS.closeAll();
	if (sp) sp.show(true);
	window.location = window.location;
}

function setFilter() {
	var tskQnt = $('cmbTskQnt').value;
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + "?action=changeTaskView" + TAB_ID_REQUEST + '&tskQntValue=' + tskQnt,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
	}).send();
}
