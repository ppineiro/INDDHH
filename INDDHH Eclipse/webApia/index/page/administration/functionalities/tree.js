function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	
	initAdminActionsEdition(setValues);
	initAdminFav();
	
	//Cargar arbol de funcionalidades
	loadTree();	
}

function loadTree(){
	sp.show(true);
	var request = new Request({
		method : 'post',
		url : CONTEXT + URL_REQUEST_AJAX + '?action=loadTreeXml&isAjax=true' + TAB_ID_REQUEST,
		onRequest : function() { SYS_PANELS.showLoading(); },
		onComplete : function(resText, resXml) { SYS_PANELS.closeAll(); processTreeXml(resXml); sp.hide(true); }
	}).send();
}

function processTreeXml(ajaxCallXml){
	if (ajaxCallXml != null) {
		var functionalities = ajaxCallXml.getElementsByTagName("functionalities");
		if (functionalities != null && functionalities.length > 0 && functionalities.item(0) != null) {
			functionalities = functionalities.item(0).getElementsByTagName("functionality");
			
			fncsContainer.getElements("ul").each(function(item){ item.destroy(); });
			fncsContainer.getElements("li").each(function(item){ item.destroy(); });				
			
			for(var i = 0; i < functionalities.length; i++) {
				processFncXml(functionalities[i]);				
			}			
		}
	}
	
	new Sortables($$('.fncContainer'), {
		clone: true,
		revert: true,
		handle: 'div.fncMoveIcon',
		opacity: 0.7		
	});
}

function processFncXml(xmlFnc){
	if (!$("fnc_"+xmlFnc.getAttribute("id"))){
		
		var father = null;
		if (xmlFnc.getAttribute("father") != ""){
			father = $("father_"+xmlFnc.getAttribute("father"));
		} else {
			father = $('fncsContainer');
		}
		
		var elem = new Element('li',{'id': "fnc_"+xmlFnc.getAttribute("id")});
		elem.setAttribute("father",father.getAttribute("id"));
		
		if (xmlFnc.getAttribute("father") != "") { elem.setAttribute("fncFatherId","fnc_"+xmlFnc.getAttribute("father")); }
		elem.setAttribute("fncType",xmlFnc.getAttribute("type"));
		elem.inject(father);
		
		var span = new Element("span",{ html: xmlFnc.getAttribute("title") });
		span.inject(elem);
		
		//Recommended
		if (xmlFnc.getAttribute("type") == "L"){
			var recommended = new Element("div",{'class': toBoolean(xmlFnc.getAttribute("recommended"))?'fncRecommended':'fncNoRecommended'}).inject(span,"before");
			recommended.tooltip(TT_RECOMMENDED, { mode: 'auto', width: 100, hook: 0 });
			recommended.addEvent("click", function(e){
				this.toggleClass('fncRecommended');			
				this.toggleClass('fncNoRecommended');
				e.stopPropagation();
			});
		}
		
		var canMove = toBoolean(xmlFnc.getAttribute("move"));
		if (canMove){
			var panelIcon = new Element("div",{'class': 'fncMoveIcon'}).inject(span,"after");
			panelIcon.addEvent('mouseover', function(evt) { 
				var obj = this.parentNode;
				if (!obj.hasClass("toMove")){
					obj.addClass("toMove");
				}
			});
			panelIcon.addEvent('mouseout', function(evt) { 
				var obj = this.parentNode;
				if (obj.hasClass("toMove")){
					obj.removeClass("toMove");
				} 
			});
		}
		
		if (xmlFnc.getAttribute("type") == "F") {
			var ul = new Element("ul",{'id': "father_"+xmlFnc.getAttribute("id")});
			ul.addClass("fncContainer");
			ul.inject(elem);
			var opclo = new Element("div",{'class': "hideChilds"});
			opclo.setAttribute("childs","father_"+xmlFnc.getAttribute("id"));
			opclo.setAttribute("open","true");
			opclo.addEvent('click', function(evt) { showOrHideChilds(this); evt.stopPropagation(); });
			opclo.inject(span,"before");
		}	
		
	}	
}

function showOrHideChilds(obj){
	if (obj.getAttribute("open") == "true"){
		obj.removeClass("hideChilds");
		obj.addClass("showChilds");
		obj.setAttribute("open","false");
		$(obj.getAttribute("childs")).setStyle("display","none");
	} else {
		obj.removeClass("showChilds");
		obj.addClass("hideChilds");
		obj.setAttribute("open","true");
		$(obj.getAttribute("childs")).setStyle("display","");
	}
}

function setValues(){
	$('confirmTree').value = "true";
	
	var strFncsTree = "";
	
	$('fncsContainer').getElements('li').each(function (li){
		var fncId = li.getAttribute("id").split("fnc_")[1];
		var fncRec = li.getAttribute("fncType") == "L" ? (li.getElements("div")[0].hasClass("fncRecommended") ? "1" : "0") : "0";
		var objFather = li.parentNode;
		var fncFatherId = objFather.getAttribute("id") != "fncsContainer" ? objFather.getAttribute("id").split("father_")[1] : "null";
		
		if (strFncsTree != "") strFncsTree += ";";
		strFncsTree += fncId;
		strFncsTree += PRIMARY_SEPARATOR;
		strFncsTree += fncRec;
		strFncsTree += PRIMARY_SEPARATOR;
		strFncsTree += fncFatherId;
	});
	
	$('fncsTree').value = strFncsTree;
	return true;
}

