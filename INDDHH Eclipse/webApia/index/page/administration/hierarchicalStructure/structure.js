var nodeSelected;
var ADDITIONAL_INFO_IN_TABLE_DATA = false;

function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	nodeSelected = null;
	
	initAdminFav();
	if (ENABLE){
		initAdminActionsEdition(genereateXml,false,true);
		initPoolMdlPage();
		initMdlInformationPage();
				
		//Carga la escrutura
		loadStructure();
	
		//Botones
		$('btnAddGroup').addEvent('click', function(evt){
			evt.stop();
			if (nodeSelected == null){
				showMessage(MSG_MUST_SEL_ONE, GNR_TIT_WARNING, 'modalWarning');			
			} else if (MODE_GLOBAL && nodeSelected.getAttribute("poolGlobal") == "false"){
				showMessage(MSG_CANT_ADD, GNR_TIT_WARNING, 'modalWarning');
			} else {
				ADDITIONAL_INFO_IN_TABLE_DATA = false
				POOLMODAL_SHOWGLOBAL = MODE_GLOBAL;
				POOLMODAL_FOR_HIERARCHY = true;
				showPoolsModal(processReturnMdlPools);
			}
		});
		$('btnDelGroup').addEvent('click', function(evt){
			evt.stop();
			if (nodeSelected == null){
				showMessage(MSG_MUST_SEL_ONE, GNR_TIT_WARNING, 'modalWarning');			
			} else if (nodeSelected.getAttribute("poolDelete") == "N" || (!MODE_GLOBAL && nodeSelected.getAttribute("poolGlobal") == "true")){
				showMessage(MSG_CANT_DEL_NODE, GNR_TIT_WARNING, 'modalWarning');
			} else if (MODE_GLOBAL && nodeSelected.getAttribute("poolGlobal") == "true"){
				SYS_PANELS.newPanel();
				var panel = SYS_PANELS.getActive();
				panel.addClass("modalWarning");
				panel.header.innerHTML = GNR_TIT_WARNING;
				panel.content.innerHTML = MSG_DEL_GLB_NODE;
				panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); confirmDeleteNode();\">" + BTN_CONFIRM + "</div>";
				SYS_PANELS.addClose(panel);
				SYS_PANELS.refresh();
			} else {
				confirmDeleteNode();
			}
		});
		$('btnDown').addEvent('click', function(evt){
			evt.stop();
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=createModalExport&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send();
		});
		$('btnUp').addEvent('click', function(evt){
			evt.stop();
			hideMessage();
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=ajaxUploadStart&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send();
		});  
		//['btnAddGroup','btnDelGroup','btnDown','btnUp'].each(setTooltip);
	
		$('btnShowUnits').addEvent('change', function(e) {
			var spans = $$('span.unit');
			if (spans) {
				if(e.target.get('checked'))
					spans.addClass('visible');
				else
					spans.removeClass('visible');
			}
		});
		
	} else { //Not enable
		SYS_PANELS.newPanel();
		var panel = SYS_PANELS.getActive();
		panel.addClass("modalWarning");
		panel.content.innerHTML = MSG_NOT_ENABLE;			
		SYS_PANELS.addClose(panel,true,"showWarnNotEnable");
		SYS_PANELS.refresh();
	}
}

function showWarnNotEnable(){
	$('msgNotEnable').style.display = '';
}

function loadStructure(){
	SYS_PANELS.closeAll();
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadStructure&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { processStructureXml(resXml); sp.hide(true); }
	}).send();	
}

function loadStructureKeepPanels(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadStructure&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { processStructureXml(resXml); sp.hide(true); }
	}).send();	
}

function processStructureXml(resXml){
	var structure = resXml.getElementsByTagName("structure");
	
	$('hierarchyDesign').getElement("ol.tree").destroy();
	new Element("ol.tree",{}).inject($('hierarchyDesign'));
	
	if (structure != null && structure.length > 0 && structure.item(0) != null) {
		var pools = structure.item(0).getElementsByTagName("pool");
		
		for (var i = 0; i < pools.length; i++){
			var xmlPool = pools[i];
			var poolId = xmlPool.getAttribute("id");
			var poolIdFather = xmlPool.getAttribute("idFather");
			var poolName = xmlPool.getAttribute("name");
			var envId = xmlPool.getAttribute("envId");
			var poolDelete = xmlPool.getAttribute("delete");
			var poolGlobal = xmlPool.getAttribute("global");
			var poolStyle = xmlPool.getAttribute("style");
			var unit = xmlPool.getAttribute("unit");
			createPool(poolId,poolIdFather,poolName,poolDelete,poolGlobal,poolStyle, envId, unit);
		}
	}
	
	createSorteables();
}

function createPool(poolId,poolIdFather,poolName,poolDelete,poolGlobal,poolStyle,envId, unit){
	var li = new Element('li').addClass('hierarchy-tree');
	new Element('div.empty').inject(li).addEvent('click', expandHandler);
	
	//Atributos
	li.setAttribute("poolId",poolId);
	li.setAttribute("poolIdFather",poolIdFather);
	li.setAttribute("poolName",poolName);
	li.setAttribute("poolDelete",poolDelete);
	li.setAttribute("poolGlobal",poolGlobal);
	li.setAttribute("poolStyle",poolStyle);
	li.setAttribute("envId",envId);
	if(unit)
		li.setAttribute("unit",unit);
	
	var span = new Element('span.hierarchyStruct', {html: poolName + (unit ? '<span class="unit">' + unit + '</span>' : '')}).addClass('selectable').inject(li).addEvent('mousedown', function(e) {
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
	if (poolDelete != "N") span.addClass('treeSorteable');
			
	var styleClass = (poolStyle == "B" ? 'bold' : (poolStyle == "I" ? 'italic' : null));
	if (styleClass != null) span.addClass(styleClass);
		
	var divInfoIcon = new Element("div.infoIcon",{}).inject(span);
	divInfoIcon.addEvent('mousedown', function(e){ if (e.rightClick) return; showMdlInfo(this); e.stopPropagation(); });
	
	var sub_tree = new Element('ol.tree').inject(li);
		
	var html_parent = getObjPoolFather(poolIdFather);
	var div_parent = html_parent.parentNode.getElement('div');
	if (div_parent && div_parent.hasClass("empty")) div_parent.removeClass('empty').addClass('expanded');
	
	//Insert ordenado
	var liNext = getObjSort(html_parent, poolName);
	if (liNext == null){
		li.inject(html_parent);
	} else {
		li.inject(liNext,"before");
	}	
}

function getObjPoolFather(poolIdFather){
	var objFather = null;
	if (poolIdFather == "0"){ //Root
		objFather = $('hierarchyDesign').getElement('ol.tree');
	} else if (poolIdFather == "-1"){ //Hijo de Root
		objFather = $('hierarchyDesign').getElement('ol.tree').getElement('li').getElement('ol.tree');
	} else {
		$('hierarchyDesign').getElements("li").each(function (li){
			if (li.getAttribute("poolId") == poolIdFather){
				objFather = li.getElement('ol.tree');
			}
		});
	}
	return objFather;
}

function getObjSort(container,newPoolName){
	var objNext = null;
	newPoolName = newPoolName.toUpperCase();
	container.getChildren("li").each(function (li){
		if (objNext == null && li.getAttribute("poolName").toUpperCase() > newPoolName){
			objNext = li;
		}
	});
	return objNext;
}

function expandHandler() {
	var target = this.getNext('ol.tree');
	
	if(target.get('inTransition'))
		return;
	target.set('inTransition', true);
	
	if(this.hasClass('expanded')) {
		//Colapsar
		this.removeClass('expanded').addClass('collapsed');
		
		var fx = new Fx.Morph(target);
		fx.start({
			opacity: 0
		}).chain(function() {
			target.setStyle('display', 'none');
			target.erase('inTransition');
		});
	} else if(this.hasClass('collapsed')){
		//Expandir
		this.removeClass('collapsed').addClass('expanded');
		
		var fx = new Fx.Morph(target);
		target.setStyle('display', '');
		fx.start({
			opacity: 1
		}).chain(function() {
			target.erase('inTransition', false);
		});
	}
}

function createSorteables(){
	
	$$('.treeSorteable').each(function(ele) {
		ele.addEvent('mousedown', function(e) {			
			if (!e) return;
			if (e.rightClick) return;
			e.stop();
			var f = e.target;
			
			if(f.hasClass('unit'))
				return;
			
			var clone = new Element('span.dragging', {html: f.get('html')}).setStyles(f.getCoordinates()).setStyles({
				position: 'absolute'
			}).inject(document.body);	
			
			var table_field = this.getParent('ol.tree').getPrevious('span').childNodes[0].nodeValue + "." + this.childNodes[0].nodeValue;
			
			var drag = new Drag.Move(clone, {
				droppables: $$('.droppable'),
				onDrop: function(dragging, target) {

					var lvl_name = dragging.get('html');
			        dragging.destroy();

			        if (target != null) {
			          	var parent = target.getNext('ol');
			        	
			        	if (f.parentNode.parentNode.parentNode.getElement('ol.tree').getElements('li').length == (f.parentNode.getElement('ol.tree').getElements("li").length + 1)) {//ultimo hijo
			          		f.parentNode.parentNode.parentNode.getElement('div').removeClass('expanded').removeClass('collapsed').addClass('empty');
			          	}	
			        	
			        	var li_brother = getObjSort(parent, f.parentNode.get('poolName'));
			          	if (!li_brother){ 
			          		f.parentNode.inject(parent);
			          	} else {
			          		f.parentNode.inject(li_brother, 'before');
			          	}
			          	
			          	var arrow = target.getPrevious('div');
			          	
			          	if (arrow.hasClass('empty')){
			          		arrow.addClass('expanded');
			          	} else if (!arrow.hasClass('expanded')){
			          		target.getPrevious('div').fireEvent('click');
			          	}
			          	
			          	if (nodeSelected == null || nodeSelected != f.parentNode){ //marco el nodo como seleccionado
			        		f.fireEvent('mousedown');
			        	}			          	
			          	
			        }
			        
			       $$('.droppable').removeClass('dropHighlight');
			    },
			   	onCancel: function(dragging) {
		        	dragging.destroy();
		        	$$('.droppable').removeClass('dropHighlight');
				},
				onEnter: function(dragging, target) {
					target.addClass('dropHighlight');
				},
				onLeave: function(dragging, target) {
					target.removeClass('dropHighlight');
				}
			});
			
		    drag.start(e);
		});
	});
	
}

function confirmDeleteNode(){
	if (nodeSelected != null){
		if(nodeSelected.parentNode.getElements("li").length == (nodeSelected.getElement('ol.tree').getElements("li").length + 1)) { //ultimo hijo
			nodeSelected.parentNode.parentNode.getElement('div').removeClass('expanded').removeClass('collapsed').addClass('empty');
		}
		nodeSelected.destroy();
		nodeSelected = null;
	}
}

function showMdlInfo(divInfoIcon){
	var span = divInfoIcon.parentNode;
	var li = span.parentNode;
	
	if (nodeSelected == null || nodeSelected != li){ //marco el nodo como seleccionado
		span.fireEvent('mousedown');
	}
	
	var poolId = li.getAttribute("poolId");
	var poolName = li.getAttribute("poolName");
	showMdlInformation(poolId,poolName);	
}

function processReturnMdlPools(ret){
	var exist = "";
	ret.each(function (pool){
		var rowId = pool.getRowId().split(PRIMARY_SEPARATOR); // id·allEnv·cantEnvs --> [id,allEnv,cantEnvs]
		var content = pool.getRowContent();
		if (existPool(rowId[0])){
			if (exist != "") exist += ", ";
			exist += content[0];
		} else {
			var poolId = rowId[0];
			var poolIdFather = nodeSelected.getAttribute("poolId");
			var poolName = content[0];
			if (content[1] != null && content[1] != ""){
				poolName += " - " + content[1];
			}
			var poolDelete = "Y";
			var poolGlobal = "false";
			var poolStyle = "N";
			
			if (rowId[1] == "1"){ //allEnv == 1
				poolStyle = "B";
				poolGlobal = "true";
				envId = "-1";//Global
			} else if (parseInt(rowId[2]) > 1) { //cantEnvs > 1
				poolStyle = "I";
			} 
			
			if (rowId[1] != "1"){ 
				envId = CURRENT_ENVIRONMENT;
			}			
			
			createPool(poolId,poolIdFather,poolName,poolDelete,poolGlobal,poolStyle, envId);
		}
	});
	
	if (exist != ""){ //algunos ya existian en la estructura
		if (exist.indexOf(",") < 0){ //uno solo
			var msg = MSG_NODE_EXIST; 
		} else { //mas de uno
			var msg = MSG_NODES_EXIST;
		}
		msg = msg.replace("<TOK1>",exist);
		showMessage(msg, GNR_TIT_WARNING, 'modalWarning');
	}
}

function existPool(poolId){
	var exist = false;
	$('hierarchyDesign').getElement('ol.tree').getElements("li").each(function (li){
		if (li.getAttribute("poolId") == poolId){
			exist = true;
		}
	});
	return exist;
}

function startDownload(){
	var spinner = new Spinner($('bodyDiv'),{message:WAIT_A_SECOND});
	createDownloadIFrame("",DOWNLOADING,URL_REQUEST_AJAX,"download","","","",null);
}

function setNewFathers(){
	var container = $('hierarchyDesign').getElement('ol.tree');
	var liRoot = container.getElements("li")[0];
	liRoot.getElement("ol.tree").getElements("li").each(function (liNode){
		 var liNodeFather = liNode.parentNode.parentNode;
		 liNode.setAttribute("poolIdFather",liNodeFather.getAttribute("poolId"));
	});	
}

function genereateXml(){
	setNewFathers(); //Establece los nuevos padres por los movimientos
	
	var xml = '<?xml version="1.0" encoding="ISO-8859-1"?>';
	xml += '<ROWSET>';
	$('hierarchyDesign').getElement('ol.tree').getElements("li").each(function (li){
		xml += "<ROW>";
		xml += "<ID>" + li.getAttribute("poolId") + "</ID>";
		xml += "<FATHER>" + li.getAttribute("poolIdFather") + "</FATHER>";
		xml += "<NAME>" + li.getAttribute("poolName") + "</NAME>";
		xml += "<DELETE>" + li.getAttribute("poolDelete") + "</DELETE>";
		xml += "<GLOBAL>" + li.getAttribute("poolGlobal") + "</GLOBAL>";
		xml += "<STYLE>" + li.getAttribute("poolStyle") + "</STYLE>";
		xml += "<ENVID>" + li.getAttribute("envId") + "</ENVID>";
		xml += "</ROW>";
	});
	xml += '</ROWSET>';
	$('xmlTree').value = xml;
	return true;
}

function doReload(){
	showMessage(MSG_OP_COMP_OK);
	
	setTimeout(function() {
		loadStructure();
	}, 1000);
}
