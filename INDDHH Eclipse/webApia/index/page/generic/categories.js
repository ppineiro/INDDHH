

function initCategories() {	
	loadCategories();
}

function loadCategories(){
	SYS_PANELS.closeAll();
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadCategories&isAjax=true' + TAB_ID_REQUEST,		
		onComplete: function(resText, resXml) { 
			processCategoriesXml(resXml); 
		}
	}).send();	
}

function processCategoriesXml(resXml){
	var structure = resXml.getElementsByTagName("structure");
	
	$('categoryDesign').getElement("ol.tree").destroy();
	new Element("ol.tree",{}).inject($('categoryDesign'));
	
	if (structure != null && structure.length > 0 && structure.item(0) != null) {
		var cats = structure.item(0).getElementsByTagName("category");
		
		for (var i = 0; i < cats.length; i++){
			var xmlCategory = cats[i];
			var categoryId = xmlCategory.getAttribute("id");
			var categoryIdFather = xmlCategory.getAttribute("idFather");
			var categoryName = xmlCategory.getAttribute("name");
			var envId = xmlCategory.getAttribute("envId");
			var categoryChecked = xmlCategory.getAttribute("checked");
			createcategory(categoryId,categoryIdFather,categoryName,categoryChecked,envId);
		}
	}
}

function createcategory(categoryId,categoryIdFather,categoryName,categoryChecked,envId){
	var li = new Element('li').addClass('hierarchy-tree');
	
	li.setAttribute("categoryId",categoryId);
	li.setAttribute("categoryIdFather",categoryIdFather);
	li.setAttribute("categoryName",categoryName);
	li.setAttribute("categoryChecked",categoryChecked);
	li.setAttribute("envId",envId);
	
	var chkbox = new Element("input");
	chkbox.checked=categoryChecked=="true";
	chkbox.type="checkbox";
    chkbox.addClass('chkCat');
	if (IS_READONLY){
		chkbox.disabled = true;
    }
    chkbox.name="chkCat_" + categoryId;
    chkbox.id="chkCat_" + categoryId;
    chkbox.inject(li);
    
    var inputId = new Element("input");
    inputId.type='hidden';
    inputId.name="catId";
    inputId.id="catId";
    inputId.value=categoryId;
    inputId.inject(li);
		
	var span = new Element('span.CategoryStruct', {html: categoryName }).addClass('selectable').inject(li).addEvent('mousedown', function(e) {
		if (e && e.rightClick) return;			
		
		if (this.hasClass('selectedNode')){
			this.removeClass('selectedNode');
			nodeSelected = null;
		} else{
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
	if (categoryIdFather == "-1"){//En raíz
		objFather = $('categoryDesign').getElement('ol.tree');
	} else {
		$('categoryDesign').getElements("li").each(function (li){
			if (li.getAttribute("categoryId") == categoryIdFather){
				objFather = li.getElement('ol.tree');
			}
		});
	}
	return objFather;
}

function getObjSort(container,newCategoryName){
	var objNext = null;
	newCategoryName = newCategoryName.toUpperCase();
	container.getChildren("li").each(function (li){
		if (objNext == null && li.getAttribute("categoryName").toUpperCase() > newCategoryName){
			objNext = li;
		}
	});
	return objNext;
}


