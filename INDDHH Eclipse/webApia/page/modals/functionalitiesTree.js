var spTreeFncMdl = null;

var FNCTREE_MODAL_HIDE_OVERFLOW	= true;

function initFncTreeMdlPage(){
	var mdlTreeFncsContainer = $('mdlTreeFncsContainer');
	if (mdlTreeFncsContainer.initDone) return;
	mdlTreeFncsContainer.initDone = true;

	mdlTreeFncsContainer.blockerModal = new Mask();
	
	spTreeFncMdl = new Spinner($('mdlTreeFncBody'),{message:WAIT_A_SECOND});
	
	$('closeTreeFncMdl').addEvent("click", function(e) {
		e.stop();
		checkFuncsUpdate();
	});
	
	$('btnConfTreeFncMdl').addEvent("click", function(e) {
		e.stop();
		var mdlTreeFncsContainer = $('mdlTreeFncsContainer');
		var selecteds = getSelectedIds();
		if (mdlTreeFncsContainer.onModalConfirm) jsCaller(mdlTreeFncsContainer.onModalConfirm,selecteds);
		closeTreeFncsModal();
	});
	
	$('btnSelAllTreeFncMdl').addEvent("click", function(e){
		e.stop();
		checkedUncheckedAll(true);
	});
	
	$('btnSelNoneTreeFncMdl').addEvent("click", function(e){
		e.stop();
		checkedUncheckedAll(false);
	});
		
}

function showTreeFncsModal(global,selecteds, envId, retFunction, closeFunction){
	
	if(FNCTREE_MODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
	var mdlTreeFncsContainer = $('mdlTreeFncsContainer');
	mdlTreeFncsContainer.removeClass('hiddenModal');
	mdlTreeFncsContainer.position();
	mdlTreeFncsContainer.blockerModal.show();
	mdlTreeFncsContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlTreeFncsContainer.onModalConfirm = retFunction;
	mdlTreeFncsContainer.onModalClose = closeFunction;
	
	setTree(global,selecteds,envId)
	mdlTreeFncsContainer.position();
	
	resetChangeHighlight(mdlTreeFncsContainer);
	initAdminFieldOnChangeHighlight(false, false, false);
}

function setTree(global,selecteds, envId){
	spTreeFncMdl.show(true);
	
	var fncsContainerTreeMdl = $('fncsContainerTreeMdl');
	fncsContainerTreeMdl.innerHTML = '';
	
	var idsSel = '';
	if (selecteds && selecteds.length > 0){
		for (var i = 0; i < selecteds.length; i++){
			if (idsSel != '') idsSel += ';';
			idsSel += selecteds[i];
		}
	}
		
	var request = new Request({
		method : 'post',
		async: false,
		url : CONTEXT + URL_REQUEST_AJAX_TREE_FNC + '?action=loadFuncsTreeMode&tree=true&global='+global+'&isAjax=true&txtEnvId=' + envId + TAB_ID_REQUEST,
		onRequest : function() { },
		onComplete : function(resText, resXml) { processXmlFncsTree(resXml); }
	}).send('&idsSel='+idsSel);
}

function processXmlFncsTree(resXml){
	var fncs = resXml.getElementsByTagName("result")
	if (fncs != null && fncs.length > 0 && fncs.item(0) != null) {
		fncs = fncs.item(0).getElementsByTagName("functionality");
		
		var fncsContainerTreeMdl = $('fncsContainerTreeMdl');
		
		for (var i = 0; i < fncs.length; i++){
			var xmlFnc = fncs[i];
			
			if (!$("mdl_fnc_"+xmlFnc.getAttribute("id"))){
				var attFather = xmlFnc.getAttribute("father");
				var father = attFather && attFather != "-1" ? $("mdl_father_"+attFather) : fncsContainerTreeMdl;
				var fncId = xmlFnc.getAttribute("id");
				
				var elem = new Element('li.modal',{'id': "mdl_fnc_"+fncId});
				elem.setAttribute("father",father.getAttribute("id"));
				if (xmlFnc.getAttribute("father") != "") { elem.setAttribute("fncFatherId","mdl_fnc_"+attFather); }
				elem.setAttribute("fncType",xmlFnc.getAttribute("type"));
				elem.inject(father);
				
				var span = new Element("span",{ html: xmlFnc.getAttribute("title") });
				span.inject(elem);
					
				if (xmlFnc.getAttribute("type") == "F") {
					elem.addClass("fncTypeFolder");
					var ul = new Element("ul.modal",{'id': "mdl_father_"+fncId });
					ul.inject(elem);					
				} else {
					if (father == fncsContainerTreeMdl) { elem.addClass("noFather"); }
					
					var chk = new Element("input.chkFnc",{'type':'checkbox','id':'chk_'+fncId}).inject(elem);
					chk.setAttribute("fncId",fncId);
					chk.checked = toBoolean(xmlFnc.getAttribute("selected"));
				}
				
				if (CHROME || SAFARI){
					if (elem.hasClass("noFather")){
						elem.removeClass("noFather");
						elem.setStyle("padding-left","20px");
						elem.setStyle("margin-left","-35px");
					} else if (Number.from(elem.getStyle("padding-left")) == 0){
						elem.setStyle("padding-left","11px");
					} 				
					
				}
			}
		}
	}
	
	removeEmptyFolders();
	
	SYS_PANELS.closeActive();
	spTreeFncMdl.hide(true);
}

function removeEmptyFolders(){
	$$('li.fncTypeFolder').each(function(li){
		var ul = li.getElement('ul.modal');
		if (ul && ul.getElements('li.modal').length == 0 && ul.getElements('ul.modal').length == 0){
			li.destroy();
		}
	});
}

function getSelectedIds(){
	var selIds = new Array();
	$$('input.chkFnc').each(function(chk){
		if (chk.checked){ selIds.push(chk.getAttribute("fncId")); }
	});	
	return selIds;
}

function checkFuncsUpdate(){
	var modElements = $('mdlTreeFncsContainer').getElements('*.highlighted');
	if (modElements.length>0){		
		SYS_PANELS.newPanel();
		var panel = SYS_PANELS.getActive();
		panel.addClass("modalWarning");
		panel.content.innerHTML = GNR_PER_DAT_ING;
		panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); closeTreeFncsModal();\">" + BTN_CONFIRM + "</div>";
		SYS_PANELS.addClose(panel);

		SYS_PANELS.refresh();
		return false;
	}
	
	closeTreeFncsModal();
	return true;
}

function closeTreeFncsModal(){
	var mdlTreeFncsContainer = $('mdlTreeFncsContainer');
	
	if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlTreeFncsContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlTreeFncsContainer.addClass('hiddenModal');
			mdlTreeFncsContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlTreeFncsContainer.blockerModal.hide();
			if (mdlTreeFncsContainer.onModalClose) mdlTreeFncsContainer.onModalClose();
			
			if(FNCTREE_MODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlTreeFncsContainer.addClass('hiddenModal');
		
		mdlTreeFncsContainer.blockerModal.hide();
		if (mdlTreeFncsContainer.onModalClose) mdlTreeFncsContainer.onModalClose();
		
		if(FNCTREE_MODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
	
	
}

function checkedUncheckedAll(checked){
	$$('input.chkFnc').each(function(chk){
		chk.checked = checked;
	});
}
