
function initPage(){
	if(Browser.chrome) {
		$$('.gridContainerWithFilter').each(function(container){
			container.setStyle('padding-top','45px');
		})
	}
	
	$('btnCreAtt').addEvent('click', function(e){
		if (e) e.stop();
		
		var url = "apia.design.AttributesAction.run?action=create";
		var mainDoc = window.parent.document.window.parent.document;
		mainDoc.getElementById('tabContainer').addNewTab(ATT_TAB_TITLE, url, 12);
	})
	
	initAttributes(true /*fromModal*/);
	callNavigateFilterAtt(null,null,true);
}

function getModalReturnValue() {
	var tableData = container.getElementById('tableData');
	
	if (selectionCount(tableData) > 1) {
		showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		return null;
	} else if (selectionCount(tableData) == 0) {
		showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		return null;
	} else {
		var id = getSelectedRows(tableData)[0].getRowId();
		var name = getSelectedRows(tableData)[0].getElements('td')[1].getAttribute('data-textcontent');
		var label= getSelectedRows(tableData)[0].getElements('td')[2].getAttribute('data-textcontent');
		return [id,name,label];
	}
}
