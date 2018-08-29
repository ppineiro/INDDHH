
function initPage(){
	//getTabContainerController().changeTabState(TAB_ID, false); 
	
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	['orderByName','orderByDesc','orderByType','orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['orderByName','orderByDesc','orderByType','orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['nameFilter','descFilter','regUsrFilter','titleFilter','execFilter'].each(setAdmFilters);
	['regDateFilter'].each(setDateFilters);
	
	$('clearFilters').addEvent("click", function(e) {
		if(e) e.stop();
		['nameFilter','descFilter','typeFilter','regUsrFilter','titleFilter','execFilter'].each(clearFilter);
		['regDateFilter'].each(clearFilterDate);
		$('nameFilter').setFilter();
	}).addEvent('keypress', Generic.enterKeyToClickListener);	
	
	//testear ejecutable
	var btnTest = $('btnTest');
	if (btnTest){
		btnTest.addEvent("click",function(e){
			e.stop();
			
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var id = getSelectedRows($('tableData'))[0].getRowId();
				var request = new Request({
					method: 'post',
					url: CONTEXT + URL_REQUEST_AJAX + '?action=test&isAjax=true&fromList=true&id=' + id + TAB_ID_REQUEST,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); }
				}).send();
			}
		});
	}
		
	initAdminActions();	
	initNavButtons();
		
	callNavigate();
}

function setFilter(){
	callNavigateFilter({
		txtName: $('nameFilter').value,
		txtDesc: $('descFilter').value,
		txtType: $('typeFilter').value,
		txtRegUsr: $('regUsrFilter').value,
		txtRegDte: $('regDateFilter').value,
		txtTitle: $('titleFilter').value,
		txtExec: $('execFilter').value,			
	},null);
}

function processXmlPanelTest(){
	SYS_PANELS.closeAll();
	
	var width = Number.from(frameElement.getParent("body").clientWidth);
	var height = Number.from(frameElement.getParent("body").clientHeight);
	width = (width*50)/100; //50%
	height = (height*50)/100; //50%
	
	var modal = ModalController.openWinModal(CONTEXT + '/page/design/panels/resultTestPanel.jsp?' + TAB_ID_REQUEST, width, height, undefined, undefined, true, true, false);													
}

