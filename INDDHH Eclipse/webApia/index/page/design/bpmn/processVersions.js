var table;
var lastSelected;
var spModalProVer;
var recovered;

function initVersionsMdlPage() {
	spModalProVer = new Spinner($('gridBodyModal'),{message:WAIT_A_SECOND});
	var mdlVersionsContainer = $('mdlVersionsContainer');
	if (mdlVersionsContainer.initDone) return;
	mdlVersionsContainer.initDone = true;
	
	mdlVersionsContainer.blockerModal = new Mask();
	
	table = $('versionsModalTableData');
	lastSelected = null;
		
	//Ver	
	$('btnLookVersionsModal').addEvent("click", function(e) {
		e.stop();
		if (lastSelected == null) {
			showMessage(GNR_CHK_AT_LEAST_ONE,GNR_TIT_WARNING,'modalWarning');
		} else {
			var row = getSelectedRows(table)[0];
			var rowContent = row.getRowContent();
			var vId = rowContent[0];			
			
			var mdlVersionsContainer = $('mdlVersionsContainer');
			var tabTitle = mdlVersionsContainer.regName + " (version " + vId + ")";
			var tabContainer = window.parent.document.getElementById('tabContainer');
			//var url = CONTEXT + URL_REQUEST_AJAX + '?action=update&id=' + mdlVersionsContainer.regId + '&verId=' + vId + '&disabled=true';
			var url = CONTEXT + URL_REQUEST_AJAX + '?action=update&id=' + mdlVersionsContainer.regId.split("_")[0] + '_' + vId + '&disabled=true';
			tabContainer.addNewTab(tabTitle,url,null);
		}
	});
	//Recuperar
	$('btnRecoverVersionsModal').addEvent("click", function(e) {
		e.stop();
		if (lastSelected == null) {
			showMessage(GNR_CHK_AT_LEAST_ONE,GNR_TIT_WARNING,'modalWarning');
		} else {
			SYS_PANELS.newPanel();
			var panel = SYS_PANELS.getActive();
			panel.addClass("modalWarning");
			panel.content.innerHTML = MSG_CONFIRM_RECOVER;
			panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); btnRecoverClickConfirm();\">" + BTN_CONFIRM + "</div>";
			SYS_PANELS.addClose(panel);
			SYS_PANELS.refresh();
		}				
	});	
	//Cerrar
	$('btnCloseVersionModal').addEvent("click", function(e) {
		if (e) { e.stop(); }
		mdlVersionsContainer.addClass('hiddenModal');
		mdlVersionsContainer.blockerModal.hide();
		
		if (mdlVersionsContainer.onModalClose != null && recovered){
			jsCaller(mdlVersionsContainer.onModalClose);
		}
	});	
	
	//Tooltips
	//['btnLookVersionsModal','btnRecoverVersionsModal','btnCloseVersionModal'].each(setTooltip);
}


function showVersionsModal(regId,regName,closeFunction){
	spModalProVer = new Spinner($('gridBodyModal'),{message:WAIT_A_SECOND});
	
	mdlVersionsContainer.position();
	mdlVersionsContainer.blockerModal.show();
	mdlVersionsContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlVersionsContainer.removeClass('hiddenModal');	
	mdlVersionsContainer.regId = regId;
	mdlVersionsContainer.regName = regName;
	mdlVersionsContainer.onModalClose = closeFunction;
	
	recovered = false;
	
	var spanTitle = $('mdlTitle');
	spanTitle.innerHTML = TITLE + ' ' + mdlVersionsContainer.regName;
	
	loadTableVersions(false);
}

function loadTableVersions(fixId){
	if (fixId){ fixRegId(); }
	
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadVersions&isAjax=true&id=' + mdlVersionsContainer.regId + TAB_ID_REQUEST,
		onRequest: function() { spModalProVer.show(true); },
		onComplete: function(resText, resXml) { SYS_PANELS.closeAll(); createTable(resXml); spModalProVer.hide(true); }
	}).send();
}

function createTable(ajaxCallXml){
	if (ajaxCallXml != null) {
		var columns = ajaxCallXml.getElementsByTagName("versions");
		if (columns != null && columns.length > 0 && columns.item(0) != null) {
			columns = columns.item(0).getElementsByTagName("version");
			
			table.getElements("tr").each(function(item){ item.destroy(); } );
			lastSelected = null;
						
			for(var i = 0; i < columns.length; i++) {
				var column = columns[i];
				createRow(i,column.getAttribute("id"),column.getAttribute("date"),column.getAttribute("user"),column.getAttribute("comment"),i==(columns.length-1));				
			}			
		}
	}
	
	addScrollTable(table);
}

function createRow(i,vId,date,user,comment,lastTr){
	var rowId = "v"+vId;
	var tr = new Element("tr",{'class': 'selectableTR'}).inject(table);
	if (i % 2 == 0){ tr.addClass("trOdd"); }
	if (lastTr) { tr.addClass("lastTr"); }
	tr.setAttribute("rowId",rowId);
	tr.addEvent("click", function(evt) { selectRow(this); evt.stopPropagation(); });				
									
	var td1 = new Element("td", {'align':'center'}).inject(tr);
	td1.setAttribute("textContent",vId);
	var div1 = new Element('div', {styles: {width: '45px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td1);
	new Element('span', {html: vId}).inject(div1);	
	
	var td2 = new Element("td", {}).inject(tr);
	td2.setAttribute("textContent",date);
	var div2 = new Element('div', {styles: {width: '120px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td2);
	new Element('span', {html: date}).inject(div2);
					
	var td3 = new Element("td", {}).inject(tr);
	td3.setAttribute("textContent",user);
	var div3 = new Element('div', {styles: {width: '100px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td3);
	new Element('span', {html: user}).inject(div3);
	
	var td4 = new Element("td", {}).inject(tr);
	td4.setAttribute("textContent",comment);
	var div4 = new Element('div', {styles: {width: '170px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td4);
	new Element('span', {html: comment}).inject(div4);
						
	tr.getRowContent = function () {
		var ret = new Array();
		ret.push(this.getAttribute("rowId").split("v")[1]);
		this.getElements('td').each(function (td){ ret.push(td.getAttribute("textContent")); });
		return ret;
	};
}

function selectRow(row){
	if (lastSelected != null){
		lastSelected.toggleClass("selectedTR");
	}	
	if (lastSelected == row){
		lastSelected = null;
		return;
	}	
	row.toggleClass("selectedTR");
	lastSelected = row;
}

function btnRecoverClickConfirm(){
	recovered = true;
	var row = getSelectedRows(table)[0];
	var rowContent = row.getRowContent();
	var vId = rowContent[0];
	
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=recoverVersion&isAjax=true&id=' + vId + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send();	
}

function fixRegId(){
	var regId = mdlVersionsContainer.regId.split("_");
	var newRegIdVer = parseInt(regId[1]) + 1;
	mdlVersionsContainer.regId = regId[0] + "_" + newRegIdVer;	
}

