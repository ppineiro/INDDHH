function initPage() {
	var request = new Request({
		method: 'post',			
		data:{'vwId':VIEW_ID},
		url: CONTEXT + "/programs/modals/viewButtonsXML.jsp?isAjax=true" + TAB_ID_REQUEST,
		onComplete: function(resText, resXml) {readVwButtonsXML(resXml);  }
	}).send();
}

function readVwButtonsXML(sXmlResult){
	 var rs = sXmlResult.getElementsByTagName("ROWSET");
	 var rows = rs[0].getElementsByTagName("ROW");
	 if (rows && rows.length>0) {
		 for (i=0; i<rows.length; i++){
			var row = rows[i];
			var btnName = row.firstChild.nodeName;
			var btnVisible = row.firstChild.firstChild.nodeValue;
			if (btnName == "NAV_OLAP" && btnVisible == "true"){
				$('chkNavOlap').set('checked', true);
			}
			if (btnName == "MDX_EDITOR" && btnVisible == "true"){
				$('chkMDX').set('checked', true);
			}
			if (btnName == "CNF_OLAP_TBL" && btnVisible == "true"){
				$('chkCnfOlapTable').set('checked', true);
			}
			if (btnName == "PRNT_MEMBERS" && btnVisible == "true"){
				$('chkShowParents').set('checked', true);
			}
			if (btnName == "HIDE_SPANS" && btnVisible == "true"){
				$('chkHidRepeat').set('checked', true);
			}
			if (btnName == "SUP_EMP_ROWS" && btnVisible == "true"){
				$('chkSupEmpRows').set('checked', true);
			}
			if (btnName == "SWAP_AXES" && btnVisible == "true"){
				$('chkExcAxes').set('checked', true);
			}
			if (btnName == "DRILL_MEMBER" && btnVisible == "true"){
				$('chkMemDatail').set('checked', true);
			}
			if (btnName == "DRILL_POSITION" && btnVisible == "true"){
				$('chkOpeDetail').set('checked', true);
			}
			if (btnName == "DRILL_REPLACE" && btnVisible == "true"){
				$('chkEntDetail').set('checked', true);
			}
			if (btnName == "DRILL_THROUGH" && btnVisible == "true"){
				$('chkShowOriData').set('checked', true);
			}
			if (btnName == "SHOW_CHART" && btnVisible == "true"){
				$('chkShowChart').set('checked', true);
			}
			if (btnName == "CHART_CONFIG" && btnVisible == "true"){
				$('chkConfChart').set('checked', true);
			}
			if (btnName == "PRINT_CONFIG" && btnVisible == "true"){
				$('chkConfPrint').set('checked', true);
			}
			if (btnName == "PRINT_PDF" && btnVisible == "true"){
				$('chkPdfExport').set('checked', true);
			}
			if (btnName == "PRINT_EXCEL" && btnVisible == "true"){
				$('chkExcExport').set('checked', true);
			}
		}
	 }else {
		 $('chkConfChart').set('checked', true);
		 $('chkConfPrint').set('checked', true);
		 $('chkPdfExport').set('checked', true);
		 $('chkExcExport').set('checked', true);
	 }

}	

function closeModal() {
	var button = window.parent.document.body.getElement('div.modalBottomBar').getElement('div.modalBottomBarClose');
	if(button)
		button.fireEvent('click');
}

function getModalReturnValue() {
var btnIds="";
	
	if (document.getElementById("chkNavOlap").checked){
		btnIds += BTN_OLAP_NAVIGATOR + ";";
	}	
	if (document.getElementById("chkMDX").checked){
		btnIds += BTN_SHOW_MDX_EDITOR + ";";
	}
	if (document.getElementById("chkCnfOlapTable").checked){
		btnIds += BTN_CONFIG_OLAP_TABLE + ";";
	}
	if (document.getElementById("chkShowParents").checked){
		btnIds += BTN_SHOW_PARENT_MEMBERS + ";";
	}
	if (document.getElementById("chkHidRepeat").checked){
		btnIds += BTN_HIDE_SPANS + ";";
	}
	if (document.getElementById("chkSupEmpRows").checked){
		btnIds += BTN_SUPRESS_EMPTY_ROWS + ";";
	}
	if (document.getElementById("chkExcAxes").checked){
		btnIds += BTN_SWAP_AXES + ";";
	}
	if (document.getElementById("chkMemDatail").checked){
		btnIds += BTN_DRILL_MEMBER + ";";
	}
	if (document.getElementById("chkOpeDetail").checked){
		btnIds += BTN_DRILL_POSITION + ";";
	}
	if (document.getElementById("chkEntDetail").checked){
		btnIds += BTN_DRILL_REPLACE + ";";
	}
	if (document.getElementById("chkShowOriData").checked){
		btnIds += BTN_DRILL_THROUGH + ";";
	}
	if (document.getElementById("chkShowChart").checked){
		btnIds += BTN_SHOW_CHART + ";";
	}
	if (document.getElementById("chkConfChart").checked){
		btnIds += BTN_CHART_CONFIG + ";";
	}
	if (document.getElementById("chkConfPrint").checked){
		btnIds += BTN_PRINT_CONFIG + ";";
	}
	if (document.getElementById("chkPdfExport").checked){
		btnIds += BTN_PRINT_PDF + ";";
	}
	if (document.getElementById("chkExcExport").checked){
		btnIds += BTN_PRINT_EXCEL + ";";
	}	

	//return result;
	return btnIds;
}

