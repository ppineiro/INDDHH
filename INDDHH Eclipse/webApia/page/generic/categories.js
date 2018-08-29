function initCategories() {	
	if(!kb) {
		loadCategories();
	}
}

function loadCategories() {
	SYS_PANELS.closeAll();
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadCategories&isAjax=true' + TAB_ID_REQUEST,		
		onComplete: function(resText, resXml) { 
			processCategoriesXml(resXml); 
		}
	}).send();	
}

function processCategoriesXml(resXml) {
	var categoryDesign = $('categoryDesign');
	if (!categoryDesign) return;
	
	var structure = resXml.getElementsByTagName("structure");
	
	var oldTree = categoryDesign.getElement("ol.tree");
	if(oldTree)
		oldTree.destroy();
	
	if (structure != null && structure.length > 0 && structure.item(0) != null) {
		var cats = structure.item(0).getElementsByTagName("category");
		
		if(cats.length)
			new Element("ol.tree",{}).inject(categoryDesign);
		
		for (var i = 0; i < cats.length; i++){
			var xmlCategory = cats[i];
			var categoryId = xmlCategory.getAttribute("id");
			var categoryIdFather = xmlCategory.getAttribute("idFather");
			var categoryName = xmlCategory.getAttribute("name");
			var envId = xmlCategory.getAttribute("envId");
			var categoryChecked = xmlCategory.getAttribute("checked");
			createcategory(categoryId, categoryIdFather, categoryName, categoryChecked, envId);
		}
	}
}

function createcategory(categoryId,categoryIdFather,categoryName,categoryChecked,envId){
	var li = new Element('li.hierarchy-tree');
	
	li.set("data-categoryId", categoryId);
	li.set("data-categoryIdFather", categoryIdFather);
	li.set("data-categoryName", categoryName);
	li.set("data-categoryChecked", categoryChecked);
	li.set("data-envId", envId);
	
	var chkbox = new Element("input.chkCat");
	chkbox.checked = (categoryChecked == "true");
	chkbox.type = "checkbox";
	
	if (IS_READONLY){
		chkbox.disabled = true;
    }
	
    chkbox.name = "chkCat_" + categoryId;
    chkbox.id = "chkCat_" + categoryId;
    chkbox.set('title',categoryName);
    chkbox.inject(li);
    
    var inputId = new Element("input");
    inputId.type = 'hidden';
    inputId.name = "catId";
    inputId.id = "catId-" + categoryId;
    inputId.set('title',categoryName);
    inputId.value = categoryId;
    inputId.inject(li);
		
	var span = new Element('span.CategoryStruct.selectable', {html: categoryName }).inject(li).addEvent('mousedown', function(e) {
		if (e && e.rightClick) return;			
		
		if (this.hasClass('selectedNode')) {
			this.removeClass('selectedNode');
			nodeSelected = null;
		} else {
			$$('ol.tree span.selectable').removeClass('selectedNode');
			this.addClass('selectedNode');
			nodeSelected = this.parentNode; //li
		}			
	});
	span.addClass('droppable');
	
	var sub_tree = new Element('ol.tree').inject(li);
		
	var html_parent = getObjcategoryFather(categoryIdFather);
	var div_parent = html_parent.parentNode.getElement('div');
	if (div_parent && div_parent.hasClass("empty")) div_parent.removeClass('empty').addClass('expanded');
	
	//Insert ordenado
	var liNext = getObjSort(html_parent, categoryName);
	if (liNext == null){
		li.inject(html_parent);
	} else {
		li.inject(liNext,"before");
	}	
}

function getObjcategoryFather(categoryIdFather){
	var objFather = null;
	if (categoryIdFather == "-1"){//En ra�z
		objFather = $('categoryDesign').getElement('ol.tree');
	} else {
		$('categoryDesign').getElements("li").each(function (li) {
			if (li.get("data-categoryId") == categoryIdFather)
				objFather = li.getElement('ol.tree');
		});
	}
	return objFather;
}

function getObjSort(container,newCategoryName){
	var objNext = null;
	newCategoryName = newCategoryName.toUpperCase();
	container.getChildren("li").each(function (li){
		if (objNext == null && li.get("data-categoryName").toUpperCase() > newCategoryName)
			objNext = li;
	});
	return objNext;
}