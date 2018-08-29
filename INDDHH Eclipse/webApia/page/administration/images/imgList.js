var selectionCount;
function initPage(){
	sp = new Spinner($('imageContainer'),{message:WAIT_A_SECOND});
	
	//Create
	$('btnCreate').addEvent("click", function(e) {
		e.stop();
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=ajaxUploadStart&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send();		
	});
	//Modificar
	$('btnUpdate').addEvent("click", function(e) {
		e.stop();
		var count = getImgSelectedCount();
		if (count > 1) {
			showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else if (count == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			var id = getImgSelectedId();
			if(PRIMARY_SEPARATOR_IN_BODY) {
				new Request({
					method: 'post',
					url: CONTEXT + URL_REQUEST_AJAX + '?action=startUpdate&isAjax=true' + TAB_ID_REQUEST,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); }
				}).send('id=' + id);	
			} else {
				new Request({
					method: 'post',
					url: CONTEXT + URL_REQUEST_AJAX + '?action=startUpdate&isAjax=true&id=' + encodeURIComponent(id) + TAB_ID_REQUEST,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); }
				}).send();	
			}
		}
	});
	//Remove
	$('btnRemove').addEvent("click", function(e) {
		e.stop();
		hideMessage();
		if (selectionCount == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {			
			SYS_PANELS.newPanel();
			var panel = SYS_PANELS.getActive();
			panel.addClass("modalWarning");
			panel.content.innerHTML = CONFIRM_ELEMENT_DELETE;
			panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); btnDeleteClickConfirm();\">" + GNR_NAV_ADM_DELETE + "</div>";
			SYS_PANELS.addClose(panel);
			SYS_PANELS.refresh();
		}		
	});
	//Refresh
	$('btnRefresh').addEvent("click", function(e) {
		e.stop();
		loadImages(false,false);		
	});
	//Dependencias
	var btnDependencies = $('btnDependencies');
	if (btnDependencies) {
		btnDependencies.addEvent("click", function(e) {
			e.stop();
			var count = getImgSelectedCount();
			if (count > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (count == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var id = getImgSelectedId();
				if(PRIMARY_SEPARATOR_IN_BODY) {
					new Request({
						method : 'post',
						url : CONTEXT + URL_REQUEST_AJAX + '?action=loadDeps&isAjax=true' + TAB_ID_REQUEST,
						onRequest : function() { SYS_PANELS.showLoading(); },
						onComplete : function(resText, resXml) { modalProcessXml(resXml); }
					}).send('id=' + id);
				} else {
					new Request({
						method : 'post',
						url : CONTEXT + URL_REQUEST_AJAX + '?action=loadDeps&isAjax=true&id=' + encodeURIComponent(id) + TAB_ID_REQUEST,
						onRequest : function() { SYS_PANELS.showLoading(); },
						onComplete : function(resText, resXml) { modalProcessXml(resXml); }
					}).send();
				}
			}
		});
	}
	//Sort
	$('btnSort').addEvent("click", function(e) {
		e.stop();
		loadImages(true,false);		
	});
	
	$$('div.fncDescriptionImage').each(function(e){
		var path = 'url(' + e.get('data-src') + ')'
		e.setStyle('background-image', path);
		e.setStyle('background-repeat', 'no-repeat');
		e.setStyle('width', '64px');
		e.setStyle('height', '64px');
	});	
	
	var btnCloseTab = $('btnCloseTab');
	if (btnCloseTab) {
		btnCloseTab.addEvent('click', closeCurrentTab);
	}
	
	initAdminFav();
	
	//Cargar Imagenes
	loadImages(false,true);
}

function loadImages(fromSort,fstTime){
	var reverseOrder = "";
	if (fromSort) { reverseOrder = "&reverseOrder=true"; }
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadImages&isAjax=true' + reverseOrder + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { processXMLImages(resXml); sp.hide(true); if (fstTime) { SYS_PANELS.closeAll(); } }		
	}).send();
}

function processXMLImages(ajaxCallXml){	
	if (ajaxCallXml != null) {
		var images = ajaxCallXml.getElementsByTagName("images");
		if (images != null && images.length > 0 && images.item(0) != null) {
			images = images.item(0).getElementsByTagName("image");
			var imageViewer = $('imageViewer');
			imageViewer.empty();
			selectionCount = 0;
			
			for(var i = 0; i < images.length; i++) {
				var image = images.item(i);
				
				var name = image.getAttribute("name");
				var id = image.getAttribute("id");
				var path = image.getAttribute("path");
				var description = image.getAttribute("description");
				
				var element = new Element("div", {'class': 'elementImage'});
				element.setStyle("cursor","auto");
				var imgCont = new Element("div", {'class': 'imgContainer'});
				imgCont.setStyle("cursor","pointer");
				imgCont.setStyle('background-image', 'url("' + path + '")');
				imgCont.setStyle('filter', 'progid:DXImageTransform.Microsoft.AlphaImageLoader(src=\'' + path + '\', sizingMethod=\'scale\')');
				imgCont.setAttribute("id",id);
				imgCont.addEvent('click', function(evt) { showFullSize(this.getAttribute("id")); evt.stopPropagation(); });
				imgCont.inject(element);
				new Element('div', {'html': name, 'class': 'imgName text-truncated', title: name}).inject(element);
				new Element('div', {'html': description, 'class': 'imgDescription text-truncated', title: description}).inject(element);
				new Element('div', {'html': path, 'class': 'imgPath text-truncated', title: path}).inject(element);

				element.adtData = { name : name, id : id, path : path, description : description, selected : "false" };
				
				element.addEvent('click', imageSelected);
				element.inject(imageViewer);
			}			
		}
	}	
}

function processResult(showOk,notDeleted){
	SYS_PANELS.closeAll();
	if (showOk){ showMessage(COMPLETE_OK); }
	else {showMessage(NOT_DELETED + " " + notDeleted, GNR_TIT_WARNING, 'modalWarning');}
	loadImages(false,false);
}

function btnDeleteClickConfirm() {
	var selected = getImgSelectedId();
	if(PRIMARY_SEPARATOR_IN_BODY) {
		new Request({
			method : 'post',
			url : CONTEXT + URL_REQUEST_AJAX + '?action=deleteImages&isAjax=true' + TAB_ID_REQUEST,
			onRequest : function() { sp.show(true); },
			onComplete : function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
		}).send('id=' + selected);
	} else {
		new Request({
			method : 'post',
			url : CONTEXT + URL_REQUEST_AJAX + '?action=deleteImages&isAjax=true&id=' + encodeURIComponent(selected) + TAB_ID_REQUEST,
			onRequest : function() { sp.show(true); },
			onComplete : function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
		}).send();
	}
}

function imageSelected(evt) {
	if (this.adtData.selected == "true"){ //selected
		this.adtData.selected = "false";
		selectionCount--;
	} else { //no selected
		this.adtData.selected = "true";
		selectionCount++;
	}
	this.toggleClass("elementImageSelected");
}

function getImgSelectedId(){
	var selected = "";
	$('imageViewer').getElements("div").each(function(item){
		if (item.adtData != null && item.adtData.selected == "true"){
			if (selected != "") { selected += ";"; }
			selected += item.adtData.id + PRIMARY_SEPARATOR + item.adtData.name;
		}				
	});
	return selected;
}
function getImgSelectedCount(){
	var count = 0;
	$('imageViewer').getElements("div").each(function(item){
		if (item.adtData != null && item.adtData.selected == "true"){
			count++;
		}				
	});
	return count;
}

function showFullSize(selected){
	hideMessage();
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=showImage&isAjax=true&id=' + (selected) + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send();	
}

function downloadElementDependencies(id) {
	createDownloadIFrame("",DOWNLOADING,URL_REQUEST_AJAX,"downloadDeps","&id="+id,"","",null);
}

function closeCurrentTab() {
	getTabContainerController().removeActiveTab();
}
