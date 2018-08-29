var viewsBrowser;
function init(){
	viewsBrowser=document.getElementById("viewsBrowser");
	if(!viewsBrowser){return;}
	if(document.getElementById("browserBlock")){
		//viewsBrowser.setStyle('z-index', document.getElementById("browserBlock").getStyle('z-index') + 1);
		document.getElementById("browserBlock").setStyle('z-index', SYS_PANELS.getNewZIndex());
		viewsBrowser.setStyle('z-index', SYS_PANELS.getNewZIndex());
	} else {
		viewsBrowser.setStyle('z-index', SYS_PANELS.getNewZIndex());
	}
	$('mdlPrfContainer').setStyle('z-index', SYS_PANELS.getNewZIndex());
	
	document.getElementById("viewsLabel").innerHTML=viewsLabel;
	document.getElementById("profilesLabel").innerHTML=profilesLabel;
	//addListener(document,"keypress",function(evt){
	document.addEvent("keypress", function(evt) {
		evt = getEventObject(evt);
		//viewsBrowser.saveButton.style.visibility="visible";
	    var charCode = (evt.charCode) ? evt.charCode : ((evt.which) ? evt.which : evt.keyCode);
	    if (charCode == 13) {
	    	if(!MSIE){
	    		evt.preventDefault();
	    	}else{
	    		evt.keyCode=0;
	    	}
	        return false;
	    } else {
	        return true;
	    }
	});

	if(!viewsBrowser){
		return null;
	}
	var els=new Array();
	for(var i=0;i<viewsBrowser.childNodes.length;i++){
		if(viewsBrowser.childNodes[i].tagName=="DIV"){
			els.push(viewsBrowser.childNodes[i]);
		}
	}
	viewsBrowser.titleBar=els[0];
	viewsBrowser.gridsBar=els[1];
	viewsBrowser.controlBar=els[2];
	viewsBrowser.style.left=((getStageWidth()-viewsBrowser.offsetWidth)/2)+"px";
	viewsBrowser.style.top=((getStageHeight()-viewsBrowser.offsetHeight)/2)+"px";
	els=viewsBrowser.gridsBar.getElementsByTagName("DIV");
	viewsBrowser.viewsList=els[0];
	//viewsBrowser.viewsList.setAttribute("multiSelected","true");
	viewsBrowser.profilesList=els[1];
	viewsBrowser.profilesList.setAttribute("multiSelected","true");
	setList(viewsBrowser.viewsList);
	setList(viewsBrowser.profilesList);
	els=viewsBrowser.viewsList.parentNode.getElementsByTagName("IMG");
	viewsBrowser.viewsList.addViewButton=els[0];
	viewsBrowser.viewsList.addFolderButton=els[1];
	viewsBrowser.viewsList.removeButton=els[2];
	viewsBrowser.viewsList.upFolderButton=els[3];
	
	viewsBrowser.actualPath=viewsBrowser.viewsList.parentNode.getElementsByTagName("INPUT")[0];
	
	els=viewsBrowser.profilesList.parentNode.getElementsByTagName("IMG");
	viewsBrowser.profilesList.addViewerButton=els[0];
	viewsBrowser.profilesList.removeProfileButton=els[1];
	
	els=viewsBrowser.controlBar.getElementsByTagName("INPUT");
	viewsBrowser.viewName=els[0];
	//addListener(viewsBrowser.viewName,"keyup", checkName)
	$(viewsBrowser.viewName).addEvent("keyup", checkName);
	viewsBrowser.viewDescription=els[1];
	viewsBrowser.mainView=els[2];
	viewsBrowser.nameLabel=document.getElementById("nameLabel");
	viewsBrowser.nameLabel.innerHTML=nameLabel;
	viewsBrowser.descriptionLabel=document.getElementById("descriptionLabel");
	viewsBrowser.descriptionLabel.innerHTML=descriptionLabel;
	viewsBrowser.mainLabel=document.getElementById("mainLabel");
	viewsBrowser.mainLabel.innerHTML=mainLabel;
	
	
	els=viewsBrowser.controlBar.getElementsByTagName("IMG");
	viewsBrowser.saveButton=els[0];
	viewsBrowser.loadButton=els[1];
	viewsBrowser.cancelButton=els[2];
	
	viewsBrowser.path="";
	viewsBrowser.parent=null;
	var action=document.getElementById("browserAction").value;
	
	viewsBrowser.nameLabel.style.visibility="hidden";
	viewsBrowser.descriptionLabel.style.visibility="hidden";
	viewsBrowser.mainView.style.visibility="hidden";
	
	viewsBrowser.viewName.style.visibility="hidden";
	viewsBrowser.viewDescription.style.visibility="hidden";
	viewsBrowser.mainLabel.style.visibility="hidden";
	
	//Falta ocultar labels de 'Name:', 'Description:' y 'Main view:'

	document.getElementById("hiddenMDX").value=document.getElementById("textMDX").getAttribute("value");
	
	var loader=new xmlLoader();
	
	viewsBrowser.viewsList.upFolderButton=function(){
		viewsBrowser.upLevel();
		viewsBrowser.clean();
	}
	
	viewsBrowser.clean=function(){
		viewsBrowser.saveButton.style.visibility="hidden";
		viewsBrowser.viewName.value="";
		viewsBrowser.viewDescription.value="";
		viewsBrowser.mainView.checked=false;
		viewsBrowser.profilesList.clear();	
	}
	
	viewsBrowser.viewsList.onElementDoubleClicked=function(el){
		if(el.data.type=="folder"){
			viewsBrowser.parent=el;
			if(el.text.innerHTML==".."){
				viewsBrowser.upLevel();
				viewsBrowser.clean();
				return;
			}else if(el.text.innerHTML.charAt(el.text.innerHTML.length-1)!="/"){
				viewsBrowser.path+=el.text.innerHTML+"/";
			}
			document.getElementById("path").value=viewsBrowser.path;
			viewsBrowser.actualPath.value=viewsBrowser.path;
			viewsBrowser.updateViewsList();
		}else{
			viewsBrowser.loadView(el.data);
		}
	}
	
	viewsBrowser.viewsList.onItemSelected=function(el){
		viewsBrowser.profilesList.clear();
		viewsBrowser.viewName.style.visibility="visible";
		viewsBrowser.nameLabel.style.visibility="visible";
		viewsBrowser.saveButton.style.visibility="visible";
		viewsBrowser.mainView.disabled=false;
		if(el.data.type=="view" && viewsBrowser.viewsList.selectedItems.length>0){//selecciono una vista
			viewsBrowser.loadSelectedView(el);
			viewsBrowser.descriptionLabel.style.visibility="visible";
			viewsBrowser.viewDescription.style.visibility="visible";
			viewsBrowser.mainView.style.visibility="visible";
			viewsBrowser.mainLabel.style.visibility="visible";
			//falta hacer que se muestren los labels: 'Description:' y 'Main View:'
		}else{//selecciono una carpeta
			viewsBrowser.clean();
			viewsBrowser.viewName.value=el.data.name;
			viewsBrowser.viewDescription.style.visibility="hidden";
			viewsBrowser.descriptionLabel.style.visibility="hidden";
			viewsBrowser.mainView.style.visibility="hidden";
			viewsBrowser.mainLabel.style.visibility="hidden";
			//falta hacer que se oculten los labels: 'Description:' y 'Main View:'
		}
	}

	viewsBrowser.updateViewsList=function(){
		viewsBrowser.profilesList.clear();
		var node=getNode(this.model,this.path);
		for(var i=0;i<viewsBrowser.viewsList.elements.length;i++){
			var el=viewsBrowser.viewsList.elements[i];
			if(el.getAttribute("view")=="true"){
				//removeListener(el,"mousedown",startDrag);
				$(el).removeEvent("mousedown", startDrag);
			}else if(el.getAttribute("folder")=="false"){
				//removeListener(el,"mouseover",dropOver);
				//removeListener(el,"mouseout",dropOut);
				$(el).removeEvent("mouseover", dropOver).removeEvent("mouseout", dropOut);
			}
		}
		this.viewsList.clear();
		if(this.path!="" && node.id){
			var parentFolder={name:"..",id:((node.parent)?node.parent.id:null),parent:((node.parent)?node.parent.parent:null),icon:"../images/jpivot/folder_icon.png",type:"folder"}
			var el=this.viewsList.addElement(parentFolder);
			el.setAttribute("folder","true");
			//addListener(el,"mouseover",dropOver);
			//addListener(el,"mouseout",dropOut);
			$(el).addEvent("mouseover", dropOver).addEvent("mouseout", dropOut);
		}
		for(var i=0;i<node.elements.length;i++){
			if(node.elements[i]){
				var el=this.viewsList.addElement(node.elements[i]);
				makeUnselectable(el);
				if(node.elements[i].type=="view"){
					el.setAttribute("view","true");
					//addListener(el,"mousedown",startDrag);
					$(el).addEvent("mousedown", startDrag);
				}else if(node.elements[i].type=="folder"){
					el.setAttribute("folder","true");
					//addListener(el,"mouseover",dropOver);
					//addListener(el,"mouseout",dropOut);
					$(el).addEvent("mouseover", dropOver).addEvent("mouseout", dropOut);
				}
			}
		}
	}
	
	function startDrag(e){
		e=getEventObject(e);
		var el=getEventSource(e);
		while(el.getAttribute("view")!="true"){
			el=el.parentNode;
		}
		viewsBrowser.viewsList.unSelectAll();
		viewsBrowser.viewsList.selectElement(el);
		var clone=el.cloneNode(true);
		viewsBrowser.dummy=clone;
		viewsBrowser.dummy.original=el;
		if(MSIE){
			viewsBrowser.style.display="none";
			document.recalc();
			viewsBrowser.style.display="block";
			document.recalc();
		}
		//addListener(document,"mousemove",movedummy);
		//addListener(document,"mouseup",dropdummy);
		$(document).addEvent("mousemove", movedummy).addEvent("mouseup", dropdummy);
	}
	
	function movedummy(evt){
		if(viewsBrowser.dummy && !viewsBrowser.dummy.canDrop){
			var clone=viewsBrowser.dummy;
			clone.style.position="absolute";
			clone.style.zIndex="99999999";
			var canDrop=document.createElement("DIV");
			canDrop.innerHTML="OK";
			canDrop.style.fontFamily="Tahoma";
			canDrop.style.fontSize="10px";
			clone.appendChild(canDrop);
			clone.canDrop=canDrop;
			//clone.canDrop.style.display="none";
			document.body.appendChild(clone);
		}
		if(MSIE){
			viewsBrowser.style.display="none";
			document.recalc();
			viewsBrowser.style.display="block";
			document.recalc();
		}
		evt=getEventObject(evt);
		if(viewsBrowser.dummy){
			viewsBrowser.dummy.style.top=(getMouseY(evt)+5)+"px";
			viewsBrowser.dummy.style.left=(getMouseX(evt)+5)+"px";
			viewsBrowser.dragging=true;
			//viewsBrowser.dummy.canDrop.style.display="none";
		}
	}
	
	function dropdummy(evt){
		//removeListener(document,"mousemove",movedummy);
		//removeListener(document,"mouseup",dropdummy);
		$(document).removeEvent("mousemove", movedummy).removeEvent("mouseup", dropdummy);
		if(viewsBrowser.dummy && !viewsBrowser.dummy.canDrop){
			viewsBrowser.viewsList.selectElement(viewsBrowser.dummy.original);
		}else{
			if(viewsBrowser.drop){
				viewsBrowser.moveView(viewsBrowser.dummy.original,viewsBrowser.drop);
			}
		}
		if(viewsBrowser.dummy){
			evt=getEventObject(evt);
			if (viewsBrowser.dummy.parentNode) viewsBrowser.dummy.parentNode.removeChild(viewsBrowser.dummy);
			viewsBrowser.dummy=null;
			if(MSIE){
				viewsBrowser.style.display="none";
				document.recalc();
				viewsBrowser.style.display="block";
				document.recalc();
			}
		}
	}
	
	function dropOver(e){
		e=getEventObject(e);
		var el=getEventSource(e);
		while(el.getAttribute("folder")!="true"){
			el=el.parentNode;
		}
		if(viewsBrowser.dragging && viewsBrowser.dummy){
			viewsBrowser.drop=el;
			viewsBrowser.dummy.canDrop.style.display="block";
		}
	}
	
	function dropOut(e){
		if(viewsBrowser.dragging && viewsBrowser.dummy){
			viewsBrowser.drop=null;
			viewsBrowser.dummy.canDrop.style.display="none";
		}
	}
	
	viewsBrowser.updateProfilesList=function(viewId){
		var profilesLoader=new xmlLoader();
		profilesLoader.onload=function(root){
			viewsBrowser.profilesList.clear();
			if (root){
				for(var i=0;i<root.childNodes.length;i++){
					if(root.childNodes[i].nodeName.toUpperCase()=="PROFILE"){
						var image="../images/jpivot/"+((root.childNodes[i].getAttribute("TYPE")=="NAVIGATOR")?"navigatorIcon.png":"viewerIcon.png");
						var el=viewsBrowser.profilesList.addElement({
							name:root.childNodes[i].getAttribute("NAME"),
							id:root.childNodes[i].getAttribute("ID"),
							icon:image,
							type:root.childNodes[i].getAttribute("TYPE")
						});
						el.style.visibility="visible";
						el.style.display="block";
					}
				}
			}
		}
		profilesLoader.load(URL_ROOT_PATH+"/Views?action=getViewProfiles&cubeId="+cubeId+"&userId="+userId+"&viewId="+viewId+"&envId="+envId);
		
	}
	
	viewsBrowser.loadSelectedView=function(el){
		this.addingView=false;
		viewsBrowser.viewName.value=el.data.name;
		viewsBrowser.viewDescription.value=el.data.description;
		viewsBrowser.mainView.checked=el.data.mainView;
		viewsBrowser.mainView.disabled=el.data.mainView;
		viewsBrowser.updateProfilesList(el.data.id);	
	}
	
	viewsBrowser.newView=function(){
	
		viewsBrowser.viewsList.addViewButton.disabled=true;
		viewsBrowser.viewsList.removeButton.disabled=false;
		
		//Falta hacer que se muestren los labels: 'Name:', 'Description:' y 'Main View'
		viewsBrowser.viewName.value="";
		viewsBrowser.viewDescription.value="";
		viewsBrowser.mainView.checked=false;
		viewsBrowser.viewName.style.visibility="visible";
		viewsBrowser.viewDescription.style.visibility="visible";
		viewsBrowser.mainView.style.visibility="visible";
		viewsBrowser.nameLabel.style.visibility="visible";
		viewsBrowser.descriptionLabel.style.visibility="visible";
		viewsBrowser.mainLabel.style.visibility="visible";
		viewsBrowser.viewName.disabled=false;
		viewsBrowser.viewDescription.disabled=false;
		viewsBrowser.mainView.disabled=false;

		viewsBrowser.profilesList.addViewerButton.disabled=false;
		viewsBrowser.profilesList.removeProfileButton.disabled=false;

		viewsBrowser.saveButton.style.visibility="visible";
		viewsBrowser.loadButton.style.visibility="visible";

		viewsBrowser.viewsList.unSelectAll();
		viewsBrowser.profilesList.unSelectAll();

		this.addingView=true;
		this.profiles="";
		
		viewsBrowser.viewName.focus();
	}
	
	viewsBrowser.updateViewProps=function(){
		if(this.addingView || viewsBrowser.viewsList.selectedItems == 0){return;}
		if(viewsBrowser.viewsList.selectedItems[0].data.type=="view"){
			var view=viewsBrowser.viewsList.selectedItems[0];
			var viewName=document.getElementById("viewName").value;
			var viewDesc=document.getElementById("viewDesc").value;
			var view=this.viewsList.selectedItems[0];
			var viewId=view.data.id;
			view.data.name=viewName;
			view.data.description=viewDesc;
			var vars="userId="+userId+"&viewId="+viewId+"&envId="+envId+"&cubeId="+cubeId+"&viewName="+viewName+"&viewDesc="+viewDesc;
			var url=URL_ROOT_PATH+"/Views?action=updateViewProps";
			sendVars(url,vars);
			viewsBrowser.updateViewsList();
		}else if(viewsBrowser.viewsList.selectedItems[0].data.type=="folder"){
			var folder=viewsBrowser.viewsList.selectedItems[0];
			var folderName=document.getElementById("viewName").value;
			var folderId=folder.data.id;
			folder.data.name=folderName;
			var vars="userId="+userId+"&folderId="+folderId+"&envId="+envId+"&cubeId="+cubeId+"&folderName="+folderName;
			var url=URL_ROOT_PATH+"/Views?action=updateFolderProps";
			sendVars(url,vars);
			viewsBrowser.updateViewsList();
		}
	}
	
	viewsBrowser.moveView=function(view,to){
		if(this.addingView){return;}
		if(view.data.type=="view"){
			var viewName=view.data.name;
			var viewDesc=view.data.description;
			var viewId=view.data.id;
			view.data.name=viewName;
			view.data.description=viewDesc;
			var vars="userId="+userId+"&viewId="+viewId+"&envId="+envId+"&cubeId="+cubeId+"&viewName="+viewName+"&viewDesc="+viewDesc+"&parentId="+to.data.id;
			var url=URL_ROOT_PATH+"/Views?action=updateViewProps";
			sendVars(url,vars);
			
			var el;
			var folder=getNode(this.model,this.path);
			for(var i=0;i<folder.elements.length;i++){
				if(folder.elements[i].id==viewId){
					el=folder.elements[i];
					folder.elements.splice(i,1);
				}
			}
			folder=getNode(this.model,this.path+to.data.name+"/");
			if(to.data.name==".."){
				var fold=this.path.substring(0,this.path.substring(0,this.path.length-1).lastIndexOf("/"));
				fold+=(fold!="")?"/":"";
				folder=getNode(this.model,fold);
			}
			folder.elements.push(el);
			viewsBrowser.updateViewsList();
		}else if(viewsBrowser.viewsList.selectedItems[0].data.type=="folder"){
			var folder=viewsBrowser.viewsList.selectedItems[0];
			var folderName=folder.data.name;
			var folderId=folder.data.id;
			folder.data.name=folderName;
			var vars="userId="+userId+"&folderId="+folderId+"&envId="+envId+"&cubeId="+cubeId+"&folderName="+folderName;
			var url=URL_ROOT_PATH+"/Views?action=updateFolderProps";
			sendVars(url,vars);
			viewsBrowser.updateViewsList();
		}
	}
	
	viewsBrowser.addProfiles=function(type) {
		
		var els=viewsBrowser.viewsList.selectedItems;
		if (els.length > 0 || this.addingView){
			
			var doLoad = function(rets) {
				var ids = "";
				if (rets != null) {
					
					rets.each(function(e){
						var text = e.getRowContent()[0];
						var image="../images/jpivot/"+type+"Icon.png";
						if(!viewsBrowser.profilesList.containsName(text)){
							viewsBrowser.profilesList.addElement({
								id: e.getRowId(),
								name: text,
								type: type,
								icon: image
							});
							ids += e.getRowId() + ";";
						}
						
					});
					
					if(!viewsBrowser.addingView){
						viewsBrowser.uploadProfiles(ids,type);
					}else{
						var els=viewsBrowser.profilesList.elements;
						var profs="";
						for(var i=0;i<els.length;i++){
							viewsBrowser.profiles+=els[i].data.id+";"+els[i].data.type+";";
						}
					}
				}
			}
			
			showProfilesModal(doLoad);
			
//			rets.onclose=function(){
//				doLoad(rets.returnValue);
//			}
		}else{
			showMessage(msgMusSelVwFirst);
		}
	}
	
	viewsBrowser.addFilter2 = function(type){
		var els=viewsBrowser.viewsList.selectedItems;
		if (els.length > 0){
			var els=viewsBrowser.profilesList.selectedItems;
			if(viewsBrowser.viewsList.selectedItems[0].data.type=="view"){
				var view=viewsBrowser.viewsList.selectedItems[0];
				var view=this.viewsList.selectedItems[0];
				var viewId=view.data.id;
				
				var modal = ModalController.openWinModal(CONTEXT + "/page/modals/jpivotViewFilters.jsp?viewId="+viewId+"&userId="+userId + TAB_ID_REQUEST, 600, 300);
				
				modal.addEvent('confirm', function(rets) {
					
					var claName = rets[0];
					var inpPar1 = rets[1];
					var inpPar2 = rets[2];
					//var vars="&after=afterConfirm&className=" + claName + "&inpPar1=" + inpPar1 + "&inpPar2=" + inpPar2 + "&viewId="+viewId + "&userId=" + userId;
					var vars = "after=afterConfirm&className=" + claName + "&inpPar1=" + inpPar1 + "&inpPar2=" + inpPar2 + "&viewId="+viewId + "&userId=" + userId;
					
					new Request({
						method: 'POST',
						url: CONTEXT + "/Views?action=confirmViewFilterClass",
						onComplete: function(resText, resXml) {
							console.log(resText);
							if(resText == 'NOK')
								alert("Error al establecer los filtros de la vista");
						}
					}).send(vars);
					
				});
				/*
				var rets  = openModal("/programs/modals/viewFilters.jsp?viewId="+viewId+"&userId="+userId,600,300);
				var doLoad=function(rets){
					var visibleButtons="";
					if (rets != null) {
						var loader=new xmlLoader();
						var xml=loader.loadString(rets);
						if(xml.firstChild.firstChild.nodeValue!="OK"){
							alert("An error ocurred");
						}
					}
				}
				rets.onclose=function(){
					doLoad(rets.returnValue);
				}
				
				*/
			}
		}else{
			alert(msgMusSelVwFirst);
		}
	}
	
	viewsBrowser.setToolbarPerms=function(){
		var els=viewsBrowser.viewsList.selectedItems;
		if (els.length > 0){
			var els = viewsBrowser.profilesList.selectedItems;
			if(viewsBrowser.viewsList.selectedItems[0].data.type == "view") {
				//var view = viewsBrowser.viewsList.selectedItems[0];
				var view = this.viewsList.selectedItems[0];
				var viewId = view.data.id;
				//var rets  = openModal("/programs/modals/setToolbarPerms.jsp?viewId="+viewId+"&userId="+userId,800,300);
				var rets = ModalController.openWinModal(CONTEXT + "/page/modals/jpivotToolbarPerms.jsp?viewId="+viewId+"&userId="+userId+TAB_ID_REQUEST,800,320);
				
				rets.addEvent('confirm', function(rets) {
					var visibleButtons = "";
					if (rets != null) {
						viewsBrowser.uploadViewButtons(rets);
					}
				})
			}
		} else {
			showMessage(msgMusSelVwFirst);
		}
	}
	
	viewsBrowser.removeProfiles=function(){
	
		var vws=viewsBrowser.viewsList.selectedItems;
		if (vws.length > 0){
			var els=viewsBrowser.profilesList.selectedItems;
			var profs="";
			for(var i=0;i<els.length;i++){
				if(els[i].data){
					profs+=els[i].data.id+";"+els[i].data.type+";";
					viewsBrowser.profilesList.deleteElement(els[i]);
				}
			}
			viewsBrowser.deleteProfiles(profs);
		}else{
			showMessage(msgMusSelPrfFirst);
		}
	}
	
	viewsBrowser.uploadViewButtons=function(ids) {
		var viewId=this.viewsList.selectedItems[0].data.id;
		var vars="btnIds="+ids+"&userId="+userId+"&viewId="+viewId+"&envId="+envId+"&cubeId="+cubeId;
		var url=URL_ROOT_PATH+"/Views?action=uploadViewButtons";
		sendVars(url,vars);
	}
	
	viewsBrowser.uploadProfiles=function(ids,type){
		var viewId=this.viewsList.selectedItems[0].data.id;
		var vars="type="+type+"&profileIds="+ids+"&userId="+userId+"&viewId="+viewId+"&envId="+envId+"&cubeId="+cubeId;
		var url=URL_ROOT_PATH+"/Views?action=uploadViewProfiles";
		sendVars(url,vars);
	}
	
	viewsBrowser.deleteProfiles=function(ids){
		var viewId=this.viewsList.selectedItems[0].data.id;
		var vars="profileIds="+ids+"&userId="+userId+"&viewId="+viewId+"&envId="+envId+"&cubeId="+cubeId;
		var url=URL_ROOT_PATH+"/Views?action=deleteViewProfiles";
		sendVars(url,vars);
	}
	

	viewsBrowser.doAction=function(){
		var action=document.getElementById("browserAction").value;
		var el=this.selectedItems[0];
		if(el && el.getAttribute("type")=="folder"){
			if(el.text.innerHTML.charAt(el.text.innerHTML.length-1)!="/"){
				viewsBrowser.path+=el.text.innerHTML+"/";
			}
			viewsBrowser.parent=el;
			document.getElementById("path").value=viewsBrowser.path;
			this.updateViewsList();
		}
		if(action=="save"){
			this.saveView();
		}else{
			this.loadView();
		}
	}
		
	loader.onload=function(root){
		viewsBrowser.model=new Object();
		viewsBrowser.model.elements=parseViews(root);
		viewsBrowser.updateViewsList();
	}
	
	viewsBrowser.repeatedInFolder=function(itemName){
		var els=getNode(this.model,this.path).elements;
		for(var i=0;i<els.length;i++){
			if(itemName.toLowerCase()==els[i].name.toLowerCase()){
				return true;
			}
		}
		return false;
	}
	
	viewsBrowser.saveView=function(){
		if(!checkNameFnc(document.getElementById("viewName"))){
			showMessage(MSG_WRNG_VW_NAME);	
			return;
		}
		var viewName=document.getElementById("viewName").value; //nombre ingresado
		var selViewName = null;
		if (this.viewsList.selectedItems.length == 1){
			selViewName = this.viewsList.selectedItems[0].data.name; //nombre de la vista seleccionada
		}
		if (viewName == ""){
			showMessage(msgVwNamIsMandatory);
		}else {
			if (viewName != selViewName && viewsBrowser.repeatedInFolder(viewName)){
				showMessage(msgAlrExVwName);
			}else {
				var mdx=document.getElementById("hiddenMDX");
				if(mdx.value==""){
					mdx.value=document.getElementById("textMDX").value;
				}
				if(MSIE){
					var emedeequis=document.getElementById("textMDX").cloneNode(true);
					emedeequis.style.display="block";
					var strMdxInput="";
					strMdxInput+=document.getElementById("textMDX").outerHTML+"";
					strMdxInput="<div "+strMdxInput.substring(strMdxInput.indexOf(" "),strMdxInput.length) ;
					strMdxInput=strMdxInput.substring(0,strMdxInput.indexOf("/TEXTAREA"))+"/div>";
					var div=document.createElement("DIV");
					div.innerHTML=strMdxInput;
					mdx.value=div.firstChild.getAttribute("value");
				}
				var frmMain=document.getElementById("frmMain");
				var parentId=(viewsBrowser.parent)?viewsBrowser.parent.data.id:"null";
				if(viewsBrowser.profiles!=null){
					var profilesInput=document.createElement("INPUT");
					profilesInput.type="hidden";
					profilesInput.name="profiles";
					profilesInput.value=viewsBrowser.profiles;
					frmMain.appendChild(profilesInput);
				}
				if (this.viewsList.selectedItems.length == 1){
					if (confirm(msgConfRewVw)) {
						var viewId=this.viewsList.selectedItems[0].data.id;
						frmMain.action=URL_ROOT_PATH+"/Views?action=save&schemaId="+schemaId+"&cubeId="+cubeId+"&viewId="+viewId+"&parentId="+parentId+"&userId="+userId+"&envId="+envId+"&mainView="+viewsBrowser.mainView.checked+"&update="+!this.addingView;
					}
				}else{
					frmMain.action=URL_ROOT_PATH+"/Views?action=save&schemaId="+schemaId+"&cubeId="+cubeId+"&parentId="+parentId+"&userId="+userId+"&envId="+envId+"&mainView="+viewsBrowser.mainView.checked+"&update="+!this.addingView;
				}
					frmMain.submit();
			}
		}
	}
	
	viewsBrowser.setInitial=function(to){
		if (!this.addingView){
			var viewId=null;
			viewsBrowser.unsetMainViews(this.model.elements);
			viewId=this.viewsList.selectedItems[0].data.id;
			this.viewsList.selectedItems[0].data.mainView=to;
			if(to){
				var url=URL_ROOT_PATH+"/Views?action=setMainView";			
			}else{
				var url=URL_ROOT_PATH+"/Views?action=unSetMainView";
			}
			var vars="viewId="+viewId+"&cubeId="+cubeId;
			viewsBrowser.mainView.disabled=true;
			viewsBrowser.profilesList.style.display="none";
			viewsBrowser.profilesList.style.display="block";
			sendVars(url,vars);
		}
	}
	
	viewsBrowser.unsetMainViews=function(els){
		for(var i=0;i<els.length;i++){
			els[i].mainView=false;
			if(els[i].elements && els[i].elements.length>0){
				viewsBrowser.unsetMainViews(els[i].elements);
			}
		}
	}
	
	viewsBrowser.loadView=function(){
		var els=viewsBrowser.viewsList.selectedItems;
		if (els.length > 0){
			var view=viewsBrowser.viewsList.selectedItems[0];
			viewsBrowser.checkView(view.data.id);
		}else{
			showMessage(msgMusSelVwFirst);
		}
	}
	
	viewsBrowser.checkView=function(vwId){
		var loader=new xmlLoader();
		loader.onload=function(root){
			if(root.firstChild.nodeValue=="NOK"){
				showMessage(msgWrngView);
			}else{
				
				if(window.REFRESH_PARENT) {
					var parentIframe = window.parent.frameElement;
					var parentSrc = parentIframe.get('src');
					var splitSrc = parentSrc.split('viewId=');
					
					parentSrc = splitSrc[0] +  "&viewId=" +  vwId;
					
					if(splitSrc.length > 1) {
					
						var srcAmpIndex = splitSrc[1].indexOf('&');
						
						if(srcAmpIndex > -1) {
							parentSrc = parentSrc + splitSrc[1].substring(srcAmpIndex);
						}
					}
					
					parentIframe.set('src', parentSrc);
				} else {
					var frmMain=document.getElementById("frmMain");
					var input=document.createElement("INPUT");
					input.type="hidden";
					input.name="viewId";
					input.value=vwId;
					frmMain.appendChild(input);
					var input2=document.createElement("INPUT");
					input2.type="hidden";
					input2.name="justLoaded";
					input2.value="true";
					frmMain.appendChild(input2);
					frmMain.submit();					
				}
				
			}
		}
		loader.load(URL_ROOT_PATH+"/Views?action=checkView&cubeId="+cubeId+"&viewId="+vwId);
	}
	
	viewsBrowser.cancel=function(){
		var frmMain=document.getElementById("frmMain");
		//frmMain.action=URL_ROOT_PATH+"/Views?action=cancel";
		var input=document.createElement("INPUT");
		input.type="hidden";
		input.name="justSaved";
		input.value="true";
		frmMain.appendChild(input);
		frmMain.submit();
	}
	
	viewsBrowser.upLevel=function(){
		viewsBrowser.path=viewsBrowser.path.substring(0,viewsBrowser.path.length-1);
		viewsBrowser.parent=((viewsBrowser.parent!=null)?viewsBrowser.parent.parent:null);
		if(viewsBrowser.path.lastIndexOf("/")>0){
			viewsBrowser.path=viewsBrowser.path.substring(0,viewsBrowser.path.lastIndexOf("/"))+"/";
		}else if(viewsBrowser.path.lastIndexOf("/")<0){
			viewsBrowser.path="";
		}
		document.getElementById("path").value=viewsBrowser.path;
		viewsBrowser.actualPath.value=viewsBrowser.path;
		this.updateViewsList();
	}
	
	viewsBrowser.deleteElement=function(){
		var els=viewsBrowser.viewsList.selectedItems;
		if (els.length > 0){
			if (confirm(msgConfDelVw)) {
				var folder=getNode(this.model,this.path);
				var element=this.viewsList.selectedItems[0];
				
				if (element.data.id >= 1000 && !element.data.mainView){
					var name=element.data.name;
					for(var i=0;i<folder.elements.length;i++){
						if(folder.elements[i].name==name){
							folder.elements.splice(i,1);
						}
					}
										
					//---------------Verificamos si la vista no se esta utilizando en un widget
					var loader=new xmlLoader();
					loader.onload=function(root){
						var widName=root.firstChild.nodeValue;
						
						if (widName == null || widName=="null" || widName ==""){ //No se esta usando en un widget
							//Eliminamos la vista
							viewsBrowser.updateViewsList();
							var vars="type="+element.data.type+"&id="+element.data.id+"&userId="+userId;
							var url=URL_ROOT_PATH+"/Views?action=deleteElement";
							sendVars(url,vars);
						}else{
							showMessage(msgViewInUseByWidget.replace("<TOK1>", widName));
						}
					}
					loader.load(URL_ROOT_PATH+"/Views?action=checkWidgetViews"+windowId+"&vwId=" + element.data.id);
					//----------------------------------
					
				}else if(element.data.mainView){
					showMessage(msgErrDelMainView);
				}else{
					showMessage(msgCantDelVwFolder);
				}
			}
		}else{
			showMessage(msgMusSelVwFolFirst);
		}
		viewsBrowser.clean();
	}
	
	//Funcion para usar con Ajax
    viewsBrowser.getXMLHttpRequest=function(){
		var http_request = null;
		if (window.XMLHttpRequest) {
			// browser has native support for XMLHttpRequest object
			http_request = new XMLHttpRequest();
		} else if (window.ActiveXObject) {
			// try XMLHTTP ActiveX (Internet Explorer) version
			try {
				http_request = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (e1) {
				try {
					http_request = new ActiveXObject("Microsoft.XMLHTTP");
				} catch (e2) {
					http_request = null;
				}
			}
		}
		return http_request;
	}
	
	viewsBrowser.verifyWidgetViews=function(type,vwId){
		var loader=new xmlLoader();
		
		loader.onload=function(root){
			var widName=root.firstChild.nodeValue;
			
			if (widName == null || widName=="null" || widName ==""){
				viewsBrowser.updateViewsList();
				var vars="type="+type+"&id="+vwId+"&userId="+userId;
				var url=URL_ROOT_PATH+"/Views?action=deleteElement";
				sendVars(url,vars);
			}else{
				showMessage(msgViewInUseByWidget.replace("<TOK1>", widName));
			}
			
		}
		loader.load(URL_ROOT_PATH+"/Views?action=checkWidgetViews"+windowId+"&vwId=" + vwId);
	}
	
	viewsBrowser.updatePath=function(evt){
		evt=getEventObject(evt);
		var txt=getEventSource(evt);
		var code=evt.keyCode;
		if(evt.which){
			code=evt.which;
		}
		if(code==13){
			try{
				getNode(this.model,txt.value);
				viewsBrowser.path=txt.value;
				if(txt.value!=""){
					txt.value+="/";
				}
				viewsBrowser.updateViewsList();
			}catch(e){
				showMessage(msgWrngPath);
			}
			return false;
		}
		evt.cancelBubble=true;
	}
	
	viewsBrowser.createFolder=function(){
		this.creating=true;
		viewsBrowser.profilesList.clear();
		viewsBrowser.viewName.style.visibility="hidden";
		viewsBrowser.viewDescription.style.visibility="hidden";
		viewsBrowser.mainView.style.visibility="hidden";
		viewsBrowser.nameLabel.style.visibility="hidden";
		viewsBrowser.descriptionLabel.style.visibility="hidden";
		viewsBrowser.mainView.style.visibility="hidden";
		viewsBrowser.mainView.disabled=false;
		var div=this.viewsList.addElement({elements:new Array(),name:"",icon:"../images/jpivot/folder_icon.png",type:"folder"});
		var td=div.getElementsByTagName("TD")[1];
		var input=document.createElement("INPUT");
		td.appendChild(input);
		input.style.border="0px";
		input.style.background="transparent";
		input.onkeypress=function(evt){
			evt=getEventObject(evt);
			if(evt.keyCode==13){
				fireElementEvent(this,"blur");
			}
		}
		input.onblur=function(){
			if(!viewsBrowser.repeatedInFolder(this.value)){
				viewsBrowser.creating=false;
				var name=this.value;
				this.parentNode.innerHTML=name;
				var parentId=(viewsBrowser.parent)?viewsBrowser.parent.data.id:"null";
				var vars="parentId="+parentId+"&name="+name+"&cubeId="+cubeId+"&userId="+userId;
				var url=URL_ROOT_PATH+"/Views?action=createFolder";
				sendVars(url,vars);
				var folder=getNode(viewsBrowser.model,viewsBrowser.path);
				folder.elements.push({name:name,elements:new Array(),icon:"../images/jpivot/folder_icon.png",type:"folder"});
				setTimeout(function(){loader.load(URL_ROOT_PATH+"/Views?action=getViews&cubeId="+cubeId+"&userId="+userId);},200);
			}else{
				this.focus();
			}
			//viewsBrowser.updateContent();
		}
		input.focus();
	}
	
	viewsBrowser.profiles=null;
	viewsBrowser.clean();
	loader.load(URL_ROOT_PATH+"/Views?action=getViews&cubeId="+cubeId+"&userId="+userId);
}

function parseViews(nodes){
	var model=new Array();
	if(nodes && nodes.childNodes){
		for(var i=0;i<nodes.childNodes.length;i++){
			if(nodes.childNodes[i]){
				if(nodes.childNodes[i].nodeName.toUpperCase()=="FOLDER"){
					model.push(parseFolder(nodes.childNodes[i]));
				}
				if(nodes.childNodes[i].nodeName.toUpperCase()=="VIEW"){
					model.push(parseView(nodes.childNodes[i]));
				}
			}
		}
	}
	return model;
}

function parseFolder(folderNode,parent){
	var folder={name:folderNode.getAttribute("name"),id:folderNode.getAttribute("id"),parent:parent,icon:"../images/jpivot/folder_icon.png",type:"folder"};
	folder.elements=new Array();
	for(var i=0;i<folderNode.childNodes.length;i++){
		if(folderNode.childNodes[i].nodeName.toUpperCase()=="FOLDER"){
			folder.elements.push(parseFolder(folderNode.childNodes[i],folder));
		}
		if(folderNode.childNodes[i].nodeName.toUpperCase()=="VIEW"){
			folder.elements.push(parseView(folderNode.childNodes[i]));
		}
	}
	return folder;
}

function parseView(viewNode){
	var view={name:viewNode.getAttribute("name"),description:viewNode.getAttribute("description"),mainView:(viewNode.getAttribute("mainView")=="true"),id:viewNode.getAttribute("id"),icon:"../images/jpivot/view_icon.png",type:"view"};
	return view;
}

function getNode(node,path){
	if(path==""){
		return node;
	}
	var parsedPath=path.split("/");
	var firstPath=parsedPath[0];
	var lastPath=firstPath;
	if(parsedPath.length>2){
		lastPath=parsedPath[(parsedPath.length-2)];
	}
	if(lastPath==firstPath && firstPath==node.name){
		return node;
	}else if(lastPath==firstPath){
		for(var i=0;i<node.elements.length;i++){
			if(node.elements[i].name==firstPath){
				return node.elements[i];
			}
		}
	}
	for(var i=0;i<node.elements.length;i++){
		if(node.elements[i].name==firstPath){
			var subPath=path.split(firstPath)[1];
			subPath=subPath.substring(1,subPath.length)
			return getNode(node.elements[i],subPath);
		}
	}
	return null;
}

function cmbVisibilityChange(cmb){
	if(cmb.options[cmb.selectedIndex].value==3){
		openProfilesModal();
	}else{
		viewsBrowser.profiles=null;
	}
}

function checkName(e){
	e=getEventObject(e);
	var input=getEventSource(e);
	checkNameFnc(input);
}

function checkNameFnc(input){
	var regExp =/%|\$|&|<|>/
	//var regExp = /[a-zA-Z]*\d\s_/
	if(regExp.test(input.value)){
		return false;
	}
	return true;
}

if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", init, false);
}else{
	init();
}
