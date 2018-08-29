var showingWaitCategoryTree = null;
var TREE_VIEW_SELECTED 	= null;
var TREE_VIEW_CONTAINER	= null;
function loadTree(fncId) {
	TREE_VIEW_SELECTED = $("treeViewFncId" + fncId);
	if (! TREE_VIEW_CONTAINER) TREE_VIEW_CONTAINER = $('resultModeTree');
	if (! TREE_VIEW_SELECTED) TREE_VIEW_SELECTED = TREE_VIEW_CONTAINER;
	
	if (TREE_VIEW_SELECTED.innerTreeLoaded) return;
	
	if (showingWaitCategoryTree == null) showingWaitCategoryTree = new Spinner(TREE_VIEW_CONTAINER);
	
	showingWaitCategoryTree.show(true);
	
	new Request({
		method: 'post',
		data: {
			search: this.value
		},
		url: CONTEXT + '/apia.splash.MenuAction.run?action=filterMenu&isAjax=true&fncId=' + fncId + TAB_ID_REQUEST,
		onComplete: function(resText, resXml) { processXmlCategoryTreePopulate(resXml); }
	}).send();
}

function processXmlCategoryTreePopulate(xml,elementSelect) {
	
	
	if(xml==undefined){
		showMessage(ERR_NOTHING_TO_LOAD);
		showingWaitCategoryTree.hide(true);
		return false;
	}
	
	var codes = xml.getElementsByTagName("code");
	if (codes != null && codes.length == 0) codes == null;
	if (codes != null && codes.length > 0) codes = codes[0];
	
	if (codes != null && codes.firstChild && codes.firstChild.nodeValue == "-1") {
		
		document.location = CONTEXT + "/page/invalidSession.jsp";
		return;
	} 
	
	var result = false;
	if (xml != null && xml.getElementsByTagName("childs").length != 0) {
		var toLoad = xml.getElementsByTagName("childs").item(0);
		var xmlRows = toLoad.getElementsByTagName("category");
		
		var htmlUl = new Element('ul', {'class': 'menuFolder menuOpen'}).inject(TREE_VIEW_SELECTED);
		TREE_VIEW_SELECTED.innerTreeLoaded = true;
		TREE_VIEW_SELECTED.innerTreeUl = htmlUl;
		TREE_VIEW_SELECTED = null;
		
		for (var i = 0; xmlRows != null && i < xmlRows.length; i++) {
			var xmlRow = xmlRows.item(i);

			var id			= xmlRow.getAttribute("id");
			var label		= xmlRow.getAttribute("label");
			var url			= xmlRow.getAttribute("url");
			var childs		= xmlRow.getAttribute("childsCount");
			var selected	= toBoolean(xmlRow.getAttribute("selected"));
			var type			= xmlRow.getAttribute("type");
			var htmlLi = new Element('li', {'id': 'treeViewFncId' + id}).inject(htmlUl);
			htmlLi.set('data-fncId',id);
			var htmlSpan = new Element('span', {
				'html': label/*, 
				'id': 'treeViewFncId' + id*/
			}).inject(htmlLi);
			if (type == "L") htmlLi.addClass("menuFunctionality");
			if (childs != "0") {
				htmlLi.addClass("menuClose");
				htmlSpan.addClass("menuClose");
			}
			
			htmlLi.urlNameToShow = label;
			htmlLi.urlToCall = url;
			htmlLi.urlId = id;
			htmlLi.urlSpan = htmlSpan;
			
			htmlSpan.addEvent('mouseover', function(evt) { this.addClass('over'); });
			htmlSpan.addEvent('mouseout', function(evt) { this.removeClass('over'); });
			
			htmlSpan.addEvent('click', function(evt) {
				var li = this.getParent();
				if (li.hasClass('menuFunctionality')) {
					$('tabContainer').addNewTab(li.urlNameToShow, li.urlToCall.replace(/&amp;/g,"&"), li.get('data-fncId'), evt);
				} else {
					if (li.hasClass('menuClose')) {
						li.addClass('menuOpen');
						li.removeClass('menuClose');
						li.urlSpan.addClass('menuOpen');
						li.urlSpan.removeClass('menuClose');
						if (li.innerTreeUl) {
							li.innerTreeUl.addClass('menuOpen');
							li.innerTreeUl.removeClass('menuClose');
						}
						loadTree(li.urlId);
					} else {
						li.removeClass('menuOpen');
						li.addClass('menuClose');
						li.urlSpan.removeClass('menuOpen');
						li.urlSpan.addClass('menuClose');
						if (li.innerTreeUl) {
							li.innerTreeUl.removeClass('menuOpen');
							li.innerTreeUl.addClass('menuClose');
						}
					}
				}
			});
			
		}
		
		result = true;
	}

	if (showingWaitCategoryTree != null ){
		showingWaitCategoryTree.hide();
		showingWaitCategoryTree.destroy();
		showingWaitCategoryTree = null;
	}

	if (result == true) return true;
	
	showMessage(LBL_ERROR);
	return false;
}