// JavaScript Document
var grids=null;
var gridCount=0;
function setGrids(divs){
	var time=(new Date());
	for(var i=0;i<divs.length;i++){
		var div=divs[i];
		if(div.getAttribute("ready")!="true"){
			/*setTimeout(function(){
			setGrid(div);
			div.setOdds();
			div.setAttribute("ready","true");
			if(grids==null){
				grids=new Array();
			}
			grids.push(div);
			},100);*/
			if(div.getAttribute("async")=="true"){
				gridCount++;
				setGrid2(div);
			}else{
				setGrid(div);
				div.setOdds();
				div.setAttribute("ready","true");
				if(grids==null){
					grids=new Array();
				}
				grids.push(div);
			}
		}else if(!isAdded(div)){
			if(grids==null){
				grids=new Array();
			}
			grids.push(div);
		}
	}
	//alert((new Date()).getTime()-time.getTime()+"\n \n grillas:"+grids.length);
	DEBUG_TIME = new Date();
}

function setGrid2(div){
	setTimeout(function(){
			try{
			setGrid(div);
			div.setOdds();
			div.setAttribute("ready","true");
			if(grids==null){
				grids=new Array();
			}
			grids.push(div);
			}catch(e){}
			gridCount--;
			if(gridCount==0){
				sizeGrids(document.getElementById("divContent").offsetWidth-(MSIE?20:15));
				fixGridsHeader();
			}
			},10);
}

function unsetGrids(divs){
	for(var i=0;i<divs.length;i++){
		var div=divs[i];
		if(div.getAttribute("ready")=="true"){
			unsetGrid(div);
		}
	}
}

function isAdded(grid){
	for(var g=0;g<grids.length;g++){
		if(grids[g]==grid){
			return true;
		}
	}
	return false;
}

function setCommonFunctions(div){
	div.table=div.getElementsByTagName("TABLE")[0];
	div.thead=getFirstChildOfType(div.table,"THEAD");
	div.tbody=getFirstChildOfType(div.table,"TBODY");
	div.rows=div.tbody.rows;
	div.getRows=function(){
		return this.rows;
	}
	div.isMultiSelected=(div.getAttribute("multiSelect")!="false");
	div.selectedItems=new Array();
	div.clearTable=function(event){
		while(this.rows.length>0){
			this.rows[this.rows.length-1].parentNode.removeChild(this.rows[this.rows.length-1]);
		}
	}
	div.addRows=function(rows){
		for(var i=0;i<rows.length;i++){
			var row=rows[i];
			this.tbody.appendChild(row);
			this.prepareTR(row);
			setScriptBehaviorsToNodes(row);
			this.setHoverEffect(row);
		}
		this.table.className=this.table.className;
		this.setOdds();
		this.style.display="none";
		this.style.display="block";
		if(!MSIE){
			this.fixCellsWidth();
		}
	}
	div.addRow=function(row){
		this.tbody.appendChild(row);
		this.prepareTR(row);
		setScriptBehaviorsToNodes(row);
		this.table.className=this.table.className;
		this.setOdds();
		this.setHoverEffect(row);
		this.style.display="none";
		this.style.display="block";
		if(!MSIE){
			this.fixCellsWidth();
		}
	}
	div.unselectAll=function(){
		var trs=this.rows;
		for(var i=0;i<trs.length;i++){
			var tr=trs[i];
			if(tr.style.display=="none"){continue;}
			tr.id="";
			var input=tr.cells[0].getElementsByTagName("INPUT")[0];
			if(input!=null && input.type=="hidden" && tr.style.display!="none"){
				input.value="off";
			}
		}
		this.selectedItems=new Array();
		try{this.onselect();}catch(e){}
	}
	div.selectAll=function(){
		this.unselectAll();
		var trs=this.tbody.rows;
		for(var i=0;i<trs.length;i++){
			var tr=trs[i];
			this.selectElement(tr);
		}
	}
	div.removeSelected=function(){
		for(var i=0;i<this.selectedItems.length;i++){
			unSetRequiredFieldsToNodes(this.selectedItems[i]);
			this.deleteElement(this.selectedItems[i]);
		}
		if(this.rows[0] && this.rows[0].getAttribute("colSized")!="true"){
			this.prepareTR(this.rows[0]);
		}
		this.setOdds();
		try{this.onselect();}catch(e){}
	}
	div.defaultGridMenu=function(doc,tempX,tempY,aEvent){
		var div=document.createElement("div");
		div.id="contextMenuContainer";
		div.innerHTML='<table id="contextMenu" width="115" border="0px" cellpadding="0"><tr><td style="padding-left:20px;">'+GRID_SELECTALL+'</td></tr><tr><td style="padding-left:20px;">'+GRID_SELECTNONE+'</td></tr></table>';
		
		div.style.position="absolute";
		div.style.width="115px";
		div.style.zIndex="9999999";
		div.callerGrid=this;
		document.onmousedown=function(e){
			e=getEventObject(e);
			setTimeout(hideMenu,200);
			e.cancelBubble = true;
		}
		div.style.border="1px solid black";
		div.style.left=tempX+"px";
		div.style.top=tempY+"px";
		document.body.appendChild(div);

		var tds=div.getElementsByTagName("TD");
		var table=doc;
		if(table.tagName=="DIV"){
			table=doc.getElementsByTagName("TABLE");
			table=table[0];
		}else{
			while(table.tagName!="TABLE"){
				table=table.parentNode;
			}
		}
		if(this.isMultiSelected){
			tds[0].onclick=function(){
				//select All
				var div=this;
				while(div.tagName!="DIV"){
					div=div.parentNode;
				}
				var caller=div.callerGrid;
				caller.selectAll();
			}
		}else{
			tds[0].style.color="#BEBEBE";
		}
		tds[1].onclick=function(){
			//unselect All
			var div=this;
			while(div.tagName!="DIV"){
				div=div.parentNode;
			}
			var caller=div.callerGrid;
			caller.unselectAll();
		}
	}
	div.onmousedown=function(aEvent){
		var doc;
		if(MSIE){
			aEvent=window.event;
			doc=aEvent.srcElement;
		}else{
			doc=aEvent.target;
		}
		if(aEvent.button==2){
			document.oncontextmenu=function(){
				return false;
			}
			if(document.getElementById("contextMenuContainer")){
				document.onmousedown="";
				var toDelete=document.getElementById("contextMenuContainer");
				document.body.removeChild(toDelete);
			}
			var tempY=getMouseY(aEvent);
			var tempX=getMouseX(aEvent);
			aEvent.cancelBubble = true;
			try{
				this.gridMenu(this,doc,tempX,tempY,aEvent);
			}
			catch(e){
				this.defaultGridMenu(doc,tempX,tempY,aEvent);
			}
		}else{
			var table=doc;
			if(table!=null){
				while(table.parentNode && table.tagName!="TABLE"){
					table=table.parentNode;
				}
			}
			
			while(doc && doc.tagName && doc.tagName!="TD" && doc.tagName!="BODY" && doc.getAttribute("type")!="grid"){
				doc = doc.parentNode;
			}			
			
			if(doc.tagName=="TD") {
				if(this.isMultiSelected && aEvent.ctrlKey) {
					if(!this.isSelected(doc.parentNode)) {
						this.selectElement(doc.parentNode);
					} else {
						this.unSelectElement(doc.parentNode);
					}
					if(!MSIE) {
						setTimeout(removeMozCtrlClick,50);
					}
				} else {
					this.unselectAll();
					this.selectElement(doc.parentNode);
				}
			}
		}
		this.updateScroll();
	}
	function removeMozCtrlClick(){
		/*var textarea=document.createElement("textarea");
		textarea.innerHTML="aa";
		document.body.appendChild(textarea);
		textarea.focus();
		textarea.select();
		document.body.removeChild(textarea);*/
	}
	div.selectElement=function(element){
		if(!this.isSelected(element)){
			if(element.getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[0]!=null &&
			element.getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[0].type=="hidden"){
				if(element.getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[0].style.visibility!="hidden" &&
				element.style.display!="none" &&
				element.getAttribute("x_disabled")!="true" &&
				element.getAttribute("x_notselectable")!="true"){
					element.getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[0].value="on";
					this.selectedItems.push(element);
					element.id="selected";
				}
			}else{
				if(element.getAttribute("x_disabled")!="true"){
					this.selectedItems.push(element);
					element.id="selected";
				}
			}
		}
		try{this.onselect();}catch(e){}
	}
	div.unSelectElement=function(element){
		var auxArray=new Array();
		element.id="";
		element.getElementsByTagName("INPUT")[0].value="off";
		for(var i=0;i<this.selectedItems.length;i++){
			if(this.selectedItems[i]!=element){
				this.selectedItems[i].getElementsByTagName("INPUT")[0].value="on";
				auxArray.push(this.selectedItems[i]);
			}
		}
		this.selectedItems=auxArray;
		try{this.onselect();}catch(e){}
	}
	
	div.isSelected=function(element){
		var isSel=false;
		for(var i=0;i<this.selectedItems.length;i++){
			if(this.selectedItems[i]==element){
				isSel=true;
			}
		}
		return isSel;
	}
	
	div.deleteElement=function(element){
		unsetMasksToNodes(element);
		unSetRequiredFieldsToNodes(element);
		element.parentNode.removeChild(element);
		this.style.display="none";
		this.style.display="block";
	}
	
	div.getSelected=function(){
		var ret = "";
		var trs=this.selectedItems;
		cant=trs.length;
		for (var i=trs.length-1;i>=0;i--) {
			if (trs[i]!=null){
				if(ret.length==0){
					ret = (trs[i].rowIndex -1);
				}else{
					ret=ret+"-"+(trs[i].rowIndex -1);
				}
				
				
			}
		}
		return ret;
	}
	
	div.removeSelectedHTMLPagedGrid=function(){
		var cant=0;
		tbody = this.tbody;
		var trs=this.selectedItems;
		cant=trs.length;
		var i=this.selectedItems.length-1;
		while(this.selectedItems.length>0) {
			if (trs[i]!=null && trs[i].getElementsByTagName("TD")[0].childNodes.length>0) {
				var tr=trs[i];
				this.unSelectElement(tr);
				i--;
				if(tr.getAttribute("name") == "firstTr"){
					continue;
				}
				if(tr.getAttribute("name") != "firstTr"){
					this.deleteElement(tr);
				}
			}
		}
		if (this.rows[1]){
			if(this.rows[1].getAttribute("colSized")!="true"){
				this.prepareTR(this.rows[1]);
			}
		}
		this.setOdds();
		this.tbody.style.display="none";
		this.tbody.style.display="block";
		return cant;
	}
	
	div.removeSelectedHTMLGrid=function(){
		var cant=0;
		tbody = this.tbody;
		var trs=this.selectedItems;
		cant=trs.length;
		if(!MSIE && this.rows.length>1){
			var firstVisible=this.rows[0];
			if(firstVisible.getAttribute("name") == "firstTr"){
				firstVisible=this.rows[1];
			}
			if(firstVisible.id=="selected"){
				var nextUndelTr=null;
				for(var i=0;i<this.rows.length;i++){
					if(this.rows[i].getAttribute("name") != "firstTr"){
						if(this.rows[i].id!="selected" && nextUndelTr==null){
							nextUndelTr=this.rows[i];
						}
						if(nextUndelTr && nextUndelTr.getAttribute("cellSizer")=="true"){
							//nextUndelTr=null;
							break;
						}
					}
				}
				if(nextUndelTr && nextUndelTr.getAttribute("cellSizer")!="true"){
					var trHead=this.thead.rows[0];
					nextUndelTr.setAttribute("cellSizer","true");
					for(var i=0;i<trHead.cells.length;i++){
						var th=trHead.cells[i];
						var td=nextUndelTr.cells[i];
						var image=document.createElement("IMG");
						image.src=URL_ROOT_PATH+"/images/cellsizer.gif";
						image.style.width=th.style.width;
						image.style.height="0px";
						image.setAttribute("class", "cellsizer"); //Most browser
						image.setAttribute("className", "cellsizer"); //IE
						var br=document.createElement("BR");
						br.style.fontSize="1px";
						td.appendChild(br);
						td.appendChild(image);
					}
				}else if(nextUndelTr && nextUndelTr.getAttribute("cellSizer")=="true"){
					var trHead=this.thead.rows[0];
					for(var i=0;i<trHead.cells.length;i++){
						var th=trHead.cells[i];
						var td=nextUndelTr.cells[i];
						var imgs=td.getElementsByTagName("IMG");
						for(var u=0;u<imgs.length;u++){
							var image=imgs[u];
							if(image.src.indexOf("cellsizer")>0){
								if(th.getElementsByTagName("IMG").length>0){
									image.style.width=th.getElementsByTagName("IMG")[0].style.width;
								}
							}
						}
					}
				}
			}
		}
		var i=this.selectedItems.length-1;
		while(this.selectedItems.length>0) {
			if (trs[i]!=null && trs[i].getElementsByTagName("TD")[0].childNodes.length>0) {
				var tr=trs[i];
				this.unSelectElement(tr);
				i--;
				if(tr.getAttribute("name") == "firstTr"){
					continue;
				}
				
					this.deleteElement(tr);
			
			}
		}
		this.setOdds();
		this.tbody.style.display="none";
		this.tbody.style.display="block";
		return cant;
	}
	
	div.setOdds=function(){
		var trs=this.rows;
		for(var i=0;i<trs.length;i++){
			var display=trs[i].style.display;
			if(i%2!=0){
				trs[i].className="even";
			}else{
				trs[i].className="";
			}
			trs[i].style.display="none";
			trs[i].style.display=display;
		}
	}
	div.prepareTR=function(oTr){
		if(oTr.style.display=="none"){
			oTr.style.display="block";
		}
		var ths=this.thead.getElementsByTagName("TH");
		var tds=oTr.getElementsByTagName("TD");
		oTr.setAttribute("colSized","true");
		oTr.setAttribute("cellSizer","true");
		if(tds.length==ths.length){
			for(var thNum=0;thNum<ths.length;thNum++){
				var td=tds[thNum];
				var th=ths[thNum];
				td.style.width=th.style.width;
				td.style.display=th.style.display;
				if(th.firstChild && (td.getAttribute("req_desc") == "" || td.getAttribute("req_desc") == null || td.getAttribute("req_desc") == undefined)){
					if(MSIE)
						td.setAttribute("req_desc", th.firstChild.innerHTML);
					else
						td.setAttribute("req_desc", th.firstChild.nodeValue);
				}
				//td.innerHTML=td.innerHTML.split("dtpicker=\"ready\"").join(" ");
				if(MSIE){
					if(td.getElementsByTagName("SPAN")[0] && td.getElementsByTagName("SPAN")[0].getAttribute("type")!="data"){
						//td.innerHTML="<span type=\"data\">"+td.innerHTML+"</span>";
					}
				}else{
					if((td.getElementsByTagName("SPAN")[0] && td.getElementsByTagName("SPAN")[0].getAttribute("type")!="data")||(!td.getElementsByTagName("SPAN")[0])){
						if(th.style.display != "none"){
							//td.innerHTML="<span type=\"data\">"+td.innerHTML+"</span><img style='width:"+th.style.width+";height:0px;' src='"+URL_ROOT_PATH+"/images/cellsizer.gif'>";
							var image=document.createElement("IMG");
							image.src=URL_ROOT_PATH+"/images/cellsizer.gif";
							//image.style.width = th.style.width;
							//image.style.width = getUnPaddedWidth(th);
							
							//image.style.width = getUnPaddedAndUnBorderWidth(th);
							
							image.style.height = "0px";
							image.setAttribute("class", "cellsizer"); //Most browser
							image.setAttribute("className", "cellsizer"); //IE
							var br = document.createElement("BR");
							br.style.fontSize = "1px";
							td.appendChild(br);
							td.appendChild(image);
							
							var marginL = 4; 
							var marginR = 2;
							/*
							if (OPERA){
								marginL = getPxValue(image.style.marginLeft);								
								marginR = getPxValue(image.style.marginRight);								
							}else if (image.currentStyle){		
								marginL = getPxValue(image.currentStyle["margin-left"]);
								marginR = getPxValue(image.currentStyle["margin-right"]);
							}else{		
								marginL = getPxValue(window.getComputedStyle(image,"").getPropertyValue("margin-left"));
								marginR = getPxValue(window.getComputedStyle(image,"").getPropertyValue("margin-right"));
							}	
							*/							
							image.style.width = (getUnPaddedAndUnBorderWidth(th) - parseInt(marginL) - parseInt(marginR))+ "px";
						}else{
							//td.innerHTML="<span type=\"data\">"+td.innerHTML+"</span>";
						}
					}					
				}
			}
		}
	}
	div.setHoverEffect=function(oTr){
		oTr.onmouseover=function(){
			this.className += " ruled"; return false
		}
		oTr.onmouseout=function(){
			this.className = this.className.replace("ruled", ""); return false
		}
	}
	
	div.swapRows=function(pos1,pos2){
		var min=pos1;
		var max=pos2;
		if(min>max){
			max=pos1;
			min=pos2;
		}
		
		var clone1=this.tbody.rows[min].cloneNode(true);
		var clone2=this.tbody.rows[max].cloneNode(true);
		setClonedValues(this.tbody.rows[min],clone1);
		setClonedValues(this.tbody.rows[max],clone2);
		var minSelected=false;
		var maxSelected=false;
		if(this.isRowSelected(this.tbody.rows[min])){
			minSelected=true;
		}
		if(this.isRowSelected(this.tbody.rows[max])){
			maxSelected=true;
		}
		this.tbody.replaceChild(clone2, this.rows[min]);
		this.tbody.replaceChild(clone1, this.rows[max]);
		this.setHoverEffect(clone1);
		this.setHoverEffect(clone2);
		this.unselectAll();
		if(minSelected){
			this.selectElement(clone1);
		}
		if(maxSelected){
			this.selectElement(clone2);
		}
		if(MSIE6){
			for(var i=0;i<this.tbody.rows[min].getElementsByTagName("INPUT").length;i++){
				if(this.tbody.rows[min].getElementsByTagName("INPUT")[i].isChecked){
					this.tbody.rows[min].getElementsByTagName("INPUT")[i].checked=this.tbody.rows[min].getElementsByTagName("INPUT")[i].isChecked;
				}
			}
			for(var i=0;i<this.tbody.rows[max].getElementsByTagName("INPUT").length;i++){
				if(this.tbody.rows[max].getElementsByTagName("INPUT")[i].isChecked){
					this.tbody.rows[max].getElementsByTagName("INPUT")[i].checked=this.tbody.rows[max].getElementsByTagName("INPUT")[i].isChecked;
				}
			}
		}
		this.setOdds();
		
	}
	div.isRowSelected=function(tr){
		if(tr.getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[0]!=null && tr.getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[0].type=="hidden" && tr.style.display!="none"){
			if(tr.getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[0].value==true || tr.getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[0].value=="on"){
				return true;
			}
		}
	}
	if(div.getAttribute("onselect")!=null && div.getAttribute("onselect")!=""){
		var func=new Function(div.getAttribute("onselect"));
		div.onselect=func;
	}
}


function setClonedValues(element,clone){
	for(var i=0;i<element.getElementsByTagName("SELECT").length;i++){
		clone.getElementsByTagName("SELECT")[i].selectedIndex=element.getElementsByTagName("SELECT")[i].selectedIndex;
	}
	for(var i=0;i<element.getElementsByTagName("INPUT").length;i++){
		if(element.getElementsByTagName("INPUT")[i].type=="checkbox"){
			clone.getElementsByTagName("INPUT")[i].checked=element.getElementsByTagName("INPUT")[i].checked;
			if(MSIE6){
				clone.getElementsByTagName("INPUT")[i].isChecked=element.getElementsByTagName("INPUT")[i].checked;
			}
		}
	}
}

function setColSizes(div){
	
	var ths = div.thead.rows[0].cells;
	var headRow = div.thead.rows[0];
	headRow.style.position = "static";
	var haspercent = false;
	for (var i = 0; i < ths.length; i++) {
		if(ths[i].style.width.indexOf("%")>=0){
			ths[i].setAttribute("perWidth",ths[i].style.width);
			haspercent=true;
			div.setAttribute("percentage",true);
			if(CHROME)
				ths[i].style.width = "";
		}else if(ths[i].getAttribute("perWidth")){
			ths[i].style.width=ths[i].getAttribute("perWidth");
			haspercent=true;
		}
	}
	for (var i = 0; i < ths.length; i++) {
		if(!MSIE && !div.getAttribute("percentage") && (parseInt(ths[i].style.width.split("px")[0])<getUnPaddedWidth(ths[i]))){
			ths[i].style.width=getUnPaddedWidth(ths[i])+"px";
		}
		if(MSIE){
			if(ths[i].min_width != undefined && ths[i].min_width != null && ths[i].min_width != "")
				ths[i].innerHTML="<span type=\"data\">"+ths[i].innerHTML+"</span><br /><img class='cellsizer' style='width:"+ths[i].min_width+";height:0px;' src='"+URL_ROOT_PATH+"/images/cellsizer.gif'>";
			else
				ths[i].innerHTML="<span type=\"data\">"+ths[i].innerHTML+"</span><br /><img class='cellsizer' style='width:"+ths[i].style.width+";height:0px;' src='"+URL_ROOT_PATH+"/images/cellsizer.gif'>";
		} else {
			if(ths[i].firstChild && ths[i].firstChild.tagName=="U"){
				ths[i].style.cursor="pointer";
				ths[i].style.cursor="hand";
			}
			if(ths[i].style.display!="none"){
				if(div.tbody.getElementsByTagName("TR").length>0){
					var trSizer=div.tbody.rows[0];
					if(trSizer.style.display=="none" && div.tbody.rows.length>1){
						trSizer=div.tbody.rows[1];
					}
					var tds=trSizer.cells;
					//if(ths[i].style.width.indexOf("%")<0){
						headRow.style.position="absolute";
						if(tds[i].offsetWidth>ths[i].offsetWidth && tds[i].offsetWidth>parseInt(ths[i].style.width.split("px")[0])){
							ths[i].style.width=tds[i].offsetWidth+"px";
						}else if(tds[i].offsetWidth<ths[i].offsetWidth && ths[i].style.width.indexOf("%")>0){
							var offWidth = ths[i].offsetWidth + "px";
							ths[i].style.width = offWidth;
							tds[i].style.width = offWidth;
							haspercent=false;
						}
						headRow.style.position="static";
						if(tds[i].offsetWidth>ths[i].offsetWidth){
							ths[i].style.width=tds[i].offsetWidth+"px";
						}
					//}
					headRow.style.position="static";
					if(tds[i].colSpan && tds[i].colSpan>1){
						i+=tds[i].colSpan;
					}
				}
				if(ths[i]){
					ths[i].innerHTML=/*"<span type=\"data\">"+*/ths[i].innerHTML+/*"</span>*/"<br /><img class='cellsizer' style='width:"+ths[i].style.width+";height:0px;' src='"+URL_ROOT_PATH+"/images/cellsizer.gif'>";
				}
			}
		}
	}
	headRow.style.position = "absolute";
	for (var i = 0; i < div.tbody.rows.length; i++) {
		var tds = div.tbody.rows[i].cells;
		var input = tds[0].getElementsByTagName("INPUT")[0];
		if((input != null && input.type == "hidden" && input.style.visibility == "hidden")
				|| tds[0].parentNode.getAttribute("x_disabled") == "true"){
			tds[0].parentNode.style.color="#CCCCCC";
		}
	}
	if(div.getAttribute("fastGrid")=="true"){
		if(!MSIE){
			fastsizeMozGridBody(div);
		}
		return true;
	}
	
	if(haspercent) {
		if(div.tbody.rows.length>0) {
			var u = 0;
			if(div.tbody.rows[0].style.display == "none" && div.tbody.rows.length > 1) {
				u = 1;
			}
		//for(var u=0;u<div.tbody.getElementsByTagName("TR").length;u++){
			var tds=div.tbody.rows[u].getElementsByTagName("TD");
			for(var i=0;i<ths.length;i++){
				if(tds[i]){
					if(ths[i].firstChild && (tds[i].getAttribute("req_desc")=="" || tds[i].getAttribute("req_desc" || td.getAttribute("req_desc") == undefined)==null)){
						//tds[i].setAttribute("req_desc",ths[i].firstChild.innerHTML);
						if(!ths[i].firstChild.innerHTML == undefined)
							tds[i].setAttribute("req_desc",ths[i].firstChild.innerHTML);
						else
							tds[i].setAttribute("req_desc",ths[i].firstChild.nodeValue);
					}
					tds[i].style.width=ths[i].style.width;
					if(MSIE){
						tds[i].innerHTML="<span type=\"data\">"+tds[i].innerHTML+"</span>";
					}else{
						tds[i].innerHTML=/*"<span type=\"data\">"+*/tds[i].innerHTML+/*" </span>*/"<br /><img class='cellsizer' style='width:"+ths[i].style.width+";height:0px;' src='"+URL_ROOT_PATH+"/images/cellsizer.gif'>";
					}
				}
			}
		//}
		}
		return true;
	}
	if(!MSIE){
		total=div.thead.clientWidth;
		div.table.width=total+"px";
	}
	if(div.tbody.rows.length > 0 && !MSIE){
		//var total=(div.tbody.getElementsByTagName("TR").length>=2 && div.tbody.getElementsByTagName("TR")[0].style.display=="none")?2:1;
		var total = div.tbody.getElementsByTagName("TR").length;
		for(var u = 0; u < total; u++) {
			
			if(div.tbody.getElementsByTagName("TR")[u].style.display=="none")
				continue;
			
			var tds = [];
			if(div.tbody.getElementsByTagName("TR").length>0){
				tds = div.tbody.getElementsByTagName("TR")[u].getElementsByTagName("TD");
			}
			
			div.tbody.getElementsByTagName("TR")[u].setAttribute("colSized","true");
			div.thead.className="";
			div.tbody.className="";
			for (var i = 0; i < ths.length; i++) {
				if (tds.length>0 && tds[i] && ths[i]) {
					tds[i].style.width = ths[i].style.width;
					if(ths[i].firstChild && (tds[i].getAttribute("req_desc")=="" || tds[i].getAttribute("req_desc")==null  || tds[i].getAttribute("req_desc") == undefined)){
						//tds[i].setAttribute("req_desc",ths[i].firstChild.innerHTML);
						//if(!ths[i].firstChild.innerHTML == undefined)
						if (ths[i].firstChild.innerHTML != undefined)
							tds[i].setAttribute("req_desc", ths[i].firstChild.innerHTML);
						else
							tds[i].setAttribute("req_desc", ths[i].firstChild.nodeValue);
					}
					//if (MSIE) {
					//	tds[i].innerHTML="<span type=\"data\">"+tds[i].innerHTML+"</span>";
					//} else {
						if (ths[i].style.display != "none") {
							tds[i].innerHTML="<span type=\"data\" style=\"white-space:normal;\">"+tds[i].innerHTML+" </span><br /><img class='cellsizer' style='width:"+ths[i].style.width+";height:0px;' src='"+URL_ROOT_PATH+"/images/cellsizer.gif'>";
						} else {
							tds[i].innerHTML="<span type=\"data\" style=\"white-space:normal;\">"+tds[i].innerHTML+" </span>";
						}
					//}
				}
				ths[i].style.height = "0px";
				ths[i].valign = "top";
				if (ths[i].style.width.indexOf("%") > 0) {
					div.hasPercentage = true;
				}
			}
		}
	} else if (div.tbody.rows.length > 0) {
		//MSIE
		var total = div.tbody.getElementsByTagName("TR").length;
		for (var u = 0; u < total; u++){
			
			//Agregado gg
			if(div.tbody.getElementsByTagName("TR")[u].style.display=="none")
				continue;
			
			var tds = [];
			if(div.tbody.getElementsByTagName("TR").length>0){
				tds = div.tbody.getElementsByTagName("TR")[u].getElementsByTagName("TD");
			}
			
			for (var i = 0; i < tds.length; i++) {
				if (ths[i].firstChild && (tds[i].getAttribute("req_desc") == "" || tds[i].getAttribute("req_desc") == null  || tds[i].getAttribute("req_desc") == undefined)) {
					//tds[i].setAttribute("req_desc",ths[i].firstChild.innerHTML);	
					if(ths[i].firstChild.innerHTML != undefined) {
						tds[i].setAttribute("req_desc", ths[i].firstChild.innerHTML);
					} else {
						tds[i].setAttribute("req_desc", ths[i].firstChild.nodeValue);
					}
				}
			}
		}
	}
}

function fastsizeMozGridBody(div){
	var ths=div.thead.getElementsByTagName("TH");
	if(div.tbody.rows.length==0){return 0;}
	var tds=div.tbody.rows[0].cells;
	for(var i=0;i<ths.length;i++){
		if(tds.length>0 && tds[i] && ths[i]){
			tds[i].style.width=ths[i].style.width;
			if(ths[i].firstChild && (tds[i].getAttribute("req_desc")=="" || tds[i].getAttribute("req_desc")==null  || td.getAttribute("req_desc") == undefined)){
				if(!ths[i].firstChild.innerHTML == undefined)
					tds[i].setAttribute("req_desc",ths[i].firstChild.innerHTML);
				else
					tds[i].setAttribute("req_desc",ths[i].firstChild.nodeValue);
			}
			if(MSIE){
				tds[i].innerHTML="<span>"+tds[i].innerHTML+"</span>";
			}else{
				if(ths[i].style.display!="none"){
					tds[i].innerHTML="<span>"+tds[i].innerHTML+" </span><br /><img class='cellsizer' style='width:"+ths[i].style.width+";height:0px;' src='"+URL_ROOT_PATH+"/images/cellsizer.gif'>";
				}else{
					tds[i].innerHTML="<span>"+tds[i].innerHTML+" </span>";
				}
			}
		}
	}
}

function getFirstChildOfType(el,type){
	if(el && type){
		for(var i=0;i<el.childNodes.length;i++){
			if(el.childNodes[i].tagName==type){
				return el.childNodes[i];
			}
		}
	}
}

function setGrid(div){
	if(FIREFOX){
		try{
			if(div.parentNode.parentNode.parentNode.parentNode.parentNode.style.display=="none"){
				div.parentNode.parentNode.parentNode.parentNode.parentNode.setAttribute("initMinimized","true");
				div.parentNode.parentNode.parentNode.parentNode.parentNode.style.display="block";
			}
		}catch(e){}
	}
	div.table=div.getElementsByTagName("TABLE")[0];
	/*div.thead=div.getElementsByTagName("THEAD")[0];
	div.tbody=div.getElementsByTagName("TBODY")[0];*/
	//div.table=getFirstChildOfType(div,"TABLE");
	div.thead=getFirstChildOfType(div.table,"THEAD");
	div.tbody=getFirstChildOfType(div.table,"TBODY");
	div.table.className="scrolltablestyle style-even";
	setColSizes(div);
	var dataGridHeader=document.createElement("DIV");
	var divHeight=parseInt(div.style.height.split("px")[0]);
	if(!div.style.height || div.style.height==""){
		divHeight=parseInt(div.getAttribute("height"));
	}
	dataGridHeader.setAttribute("ready","true");
	dataGridHeader.style.position="relative";
	dataGridHeader.style.paddingTop="24px";
	dataGridHeader.style.width=div.clientWidth+"px";
	dataGridHeader.style.height=(divHeight-25)+"px";
	dataGridHeader.height=(divHeight-25)+"px";
	dataGridHeader.innerHTML="<div ready='true' height='"+(divHeight-25)+"' style=height:"+(divHeight-25)+"px;width:"+div.clientWidth+";overflow:auto;></div>"
	var dataGridContent=dataGridHeader.getElementsByTagName("DIV")[0];
	dataGridContent.className="dataGridContent";
	dataGridHeader.className="dataGridHeader";
	dataGridContent.innerHTML=div.innerHTML;
	dataGridHeader.appendChild(dataGridContent);
	div.innerHTML="";
	div.dataGridHeader=dataGridHeader;
	div.dataGridContent=dataGridContent;
	div.appendChild(dataGridHeader);
	div.style.overflow="hidden";
	div.style.position="relative";
	div.className="divApiaGrid";
	
	var theTable=dataGridContent.getElementsByTagName("TABLE")[0];
	theTable.className="scrolltablestyle style-even"
	theTable.setAttribute("cellpadding","0px");
	theTable.setAttribute("cellspacing","0px");
	theTable.style.overflow="hidden"
	var ths=div.getElementsByTagName("TH");
	div.setWidth=function(width){
		var ths=this.thead.rows[0].cells;
		var tds=this.tbody.getElementsByTagName("TD");
		if(width>0){
			this.style.width=(width+19)+"px";
			if(this.getAttribute("percentage")){
				this.table.style.width=(width)+"px";
				if(!MSIE){
					var totalFixedWidth=0;
					for(var i=0;i<ths.length;i++){
						if(ths[i].getAttribute("perWidth")){
							if(!CHROME){
								ths[i].style.width=ths[i].getAttribute("perWidth");
							}
						}
						if(!CHROME || (CHROME && !ths[i].getAttribute("perWidth"))){
							if(tds.length>0){
								tds[i].style.width=ths[i].style.width;
								//totalFixedWidth+=getUnPaddedWidth(ths[i]);
								//totalFixedWidth+=ths[i].clientWidth;
							}
							totalFixedWidth+=ths[i].clientWidth;
						}
					}
					if(CHROME) {
						totalFixedWidth+=20;
						for(var i = 0; i < ths.length; i++) {
							if(ths[i].getAttribute("perWidth")) {
								
								var chrPer=ths[i].getAttribute("perWidth");
								chrPer=chrPer.split("%")[0];
								var paddingWidth=ths[i].clientWidth-getUnPaddedWidth(ths[i]);
								var chrWidth=((width-totalFixedWidth)*(parseInt(chrPer)/100))-paddingWidth;
								ths[i].style.width=chrWidth+"px";
								
								var imgs = ths[i].getElementsByTagName("IMG");
								if(imgs[imgs.length-1].src.indexOf("cellsizer.gif") > 0)
									imgs[imgs.length-1].style.width = chrWidth + "px";
								
								var maximum_width = ths[i].clientWidth;
								var extra_width = 0;
								
								try {
									//Padding del header
									var computed_style = document.defaultView.getComputedStyle(ths[i], null);								
									if(computed_style) {									
										var aux_style = computed_style.getPropertyValue("padding-left");
										if(aux_style && aux_style != "")
											extra_width += parseInt(aux_style.split("px")[0]);
										
										aux_style = computed_style.getPropertyValue("padding-right")
										if(aux_style && aux_style != "")
											extra_width += parseInt(aux_style.split("px")[0]);
									}
									//Margen de la imagen
									computed_style = document.defaultView.getComputedStyle(imgs[imgs.length-1], null);
									if(computed_style) {			
										var aux_style = computed_style.getPropertyValue("margin-left")
										if(aux_style && aux_style != "")
											extra_width += parseInt(aux_style.split("px")[0]);
										
										aux_style = computed_style.getPropertyValue("margin-right")
										if(aux_style && aux_style != "")
											extra_width += parseInt(aux_style.split("px")[0]);
									}
								} catch(error) {
									//No se ajusta el padding, las columnas quedan mas grandes
								}
								
								maximum_width -= extra_width;
								
								var trs = this.tbody.getElementsByTagName("TR");
								if(trs.length > 0) {
									for(var j = 0; j < trs.length; j++) {
										var sub_tds = trs[j].getElementsByTagName("TD");
										if(sub_tds.length > i) {
											sub_tds[i].style.width = chrWidth + "px";
											
											
											var imgs = sub_tds[i].getElementsByTagName("IMG");
											if(imgs.length > 0 && imgs[imgs.length-1].src.indexOf("cellsizer.gif") > 0){
												imgs[imgs.length - 1].style.width = chrWidth+"px";
											}
											/*
											if(maximum_width < sub_tds[i].clientWidth - extra_width)
												maximum_width = sub_tds[i].clientWidth - extra_width;
											*/
										}
									}
									
									for(var j = 0; j < trs.length; j++) {
										var sub_tds = trs[j].getElementsByTagName("TD");
										if(sub_tds.length > i) {
											//sub_tds[i].style.width = chrWidth + "px";
											
											if(maximum_width < sub_tds[i].clientWidth - extra_width)
												maximum_width = sub_tds[i].clientWidth - extra_width;
										}
									}
								}
								
								if(maximum_width > chrWidth) {
									imgs = this.getElementsByTagName("TH")[i].getElementsByTagName("IMG");								
									if(imgs.length > 0 && imgs[imgs.length-1].src.indexOf("cellsizer.gif") > 0){
										imgs[imgs.length-1].style.width = maximum_width + "px";
									}
									
									trs = this.tbody.getElementsByTagName("TR");
									if(trs.length > 0) {
										for(var j = 0; j < trs.length; j++) {
											var sub_tds = trs[j].getElementsByTagName("TD");
											if(sub_tds.length > i) {
												sub_tds[i].style.width = maximum_width + "px";
												imgs = sub_tds[i].getElementsByTagName("IMG");
												if(imgs.length > 0 && imgs[imgs.length-1].src.indexOf("cellsizer.gif") > 0)
													imgs[imgs.length - 1].style.width = maximum_width+"px";
											}
										}
									}
								}
							}
						}
					}
					if(this.getElementsByTagName("TH").length==2 && this.getElementsByTagName("TH")[1].style.width=="100%"){
						var imgs=this.getElementsByTagName("TH")[1].getElementsByTagName("IMG");
						if(imgs.length > 0 && imgs[imgs.length-1].src.indexOf("cellsizer.gif") > 0){
							imgs[imgs.length-1].style.width=width+"px";
						}
						this.thead.style.width=this.tbody.clientWidth+"px";
					}else if(this.getElementsByTagName("TH").length==1 && this.getElementsByTagName("TH")[0].style.width=="100%"){
						var imgs=this.getElementsByTagName("TH")[0].getElementsByTagName("IMG");
						if(imgs.length > 0 && imgs[imgs.length-1].src.indexOf("cellsizer.gif") > 0){
							imgs[imgs.length-1].style.width=width+"px";
						}
						this.thead.style.width=this.tbody.clientWidth+"px";
					}
				}
			}else if(!MSIE){
				this.getElementsByTagName("TABLE")[0].style.width=(this.thead.clientWidth-15)+"px";
			}
			var divs=this.getElementsByTagName("DIV");
			divs[0].style.width=(width)+"px";
			divs[1].style.width=(width+19)+"px";
			
			for(var i=0;i<tds.length;i++){
				var td=tds[i];
				td.style.height="0px";
			}
		}
		this.fixHeader();
	}
	dataGridContent.thead=div.getElementsByTagName("THEAD")[0];
	div.fixHeader=function(){
		var headContainer=this.getElementsByTagName("DIV")[0];
		var bodyContainer=this.getElementsByTagName("DIV")[1];
		if(headContainer.getElementsByTagName("TR")[0].offsetHeight<24){
			if(MSIE){
				headContainer.getElementsByTagName("TR")[0].style.height="24px";
			}else{
				try{
				//headContainer.getElementsByTagName("TR")[0].getElementsByTagName("TH")[1].style.height="24px";
				var head_cols = headContainer.getElementsByTagName("TR")[0].getElementsByTagName("TH");
				for(var i = 1; i < head_cols.length; i++) {
					head_cols[i].style.height="24px";
				}
				headContainer.getElementsByTagName("TR")[0].style.height="24px";
				}catch(e){}
			}
		}else{
			headContainer.style.paddingTop=(headContainer.getElementsByTagName("TR")[0].offsetHeight)+"px";
			
			if(MSIE){
				try {
					if(headContainer.getElementsByTagName("TR")[0].getElementsByTagName("TH").length > 1) {
						var current_height = headContainer.getElementsByTagName("TR")[0].getElementsByTagName("TH")[1].style.height;
						headContainer.getElementsByTagName("TR")[0].getElementsByTagName("TH")[1].style.height = "24px";
						headContainer.getElementsByTagName("TR")[0].getElementsByTagName("TH")[1].style.height = current_height;
					} else {
						var current_height = headContainer.getElementsByTagName("TR")[0].getElementsByTagName("TH")[0].style.height;
						headContainer.getElementsByTagName("TR")[0].getElementsByTagName("TH")[0].style.height = "24px";
						headContainer.getElementsByTagName("TR")[0].getElementsByTagName("TH")[0].style.height = current_height;
					}
				} catch(e){}
			}
			bodyContainer.style.height=(parseInt(bodyContainer.parentNode.parentNode.clientHeight)-(headContainer.getElementsByTagName("TR")[0].offsetHeight))+"px";
		}
		if(!MSIE){
			if(div.tbody.rows.length<2){
				var tableWidth=0;
				for(var i=0;i<ths.length;i++){
					tableWidth+=ths[i].offsetWidth;
				}
				div.thead.parentNode.style.width=tableWidth+"px";
			}
		}
	}
	div.onmousedown="";
	dataGridContent.onscroll=function(){
		var thead=this.thead;
		var theTable = this.getElementsByTagName('TABLE');
		if (theTable && theTable.length > 0)
			theTable = theTable[0];
		if(MSIE) {
			var tr=thead.childNodes[0];
			tr.style.position="absolute";
			tr.style.top=0+"px";
			tr.style.left=(-this.scrollLeft)+"px";
		} else if(OPERA || CHROME) {
			var tr=thead.getElementsByTagName("TR")[0];
			tr.style.position="absolute";
			tr.style.left=(-this.scrollLeft)+"px";
			tr.style.top=0+"px";
			/*thead.style.position="relative";
			thead.parentNode.style.position="relative";
			var tr=thead.getElementsByTagName("TR")[0];
			tr.style.top=0+"px";
			var maxOL=(this.scrollWidth-tr.offsetWidth)-2;
			
			//document.getElementsByTagName("TABLE")[0].rows[0].cells[0].innerHTML=this.scrollLeft+" - "+this.scrollWidth+" - "+(this.scrollWidth-this.scrollLeft)+" - "+thead.offsetWidth+" - "+tr.offsetWidth+" - "+this.getElementsByTagName("TABLE")[0].getElementsByTagName("TBODY")[0].offsetWidth;
			tr.style.left=(-this.scrollLeft)+"px";
			//thead.style.left=(-this.scrollLeft)+"px";
			//var scrolled=parseInt(this.scrollLeft+"");;
			//tr.style.left=(-1*Math.round((scrolled*tr.offsetWidth)/maxOL))+"px";
			//document.getElementsByTagName("TABLE")[0].rows[0].cells[0].innerHTML=(-(this.scrollLeft*tr.offsetWidth)/maxOL);
			document.getElementsByTagName("TABLE")[0].rows[0].cells[0].innerHTML=(-this.scrollLeft)+" - "+(Math.round((scrolled*tr.offsetWidth)/maxOL));*/
		}else{
			thead.style.position="relative";
			var tr=thead.getElementsByTagName("TR")[0];
			tr.style.left=(-this.scrollLeft)+"px";
		}
		if(!MSIE && theTable && theTable.getAttribute('execGrid') == "true")
			tr.style.left = (- (this.scrollLeft + 1)) + "px";
	}
	dataGridContent.onmouseup=function(){
		var thead=this.thead;
		if(!MSIE){
			thead.style.left = (- this.scrollLeft) + "px";
		}
	}
	div.onscroll="";
	div.updateScroll=function(){
		
	}
	div.setHeight=function(height){
		this.style.height=height+"px";
		this.dataGridHeader.style.height=(height-25)+"px";
		this.dataGridContent.style.height=(height-25)+"px";
	}
	div.bestColWidth=function(){
		ths=div.getElementsByTagName("TH");
		tds=div.getElementsByTagName("TD");
		imgs=div.getElementsByTagName("IMG");
		for(var i=0;i<imgs.length;i++){
			if(imgs.length > 0 && (imgs[i].src.indexOf("cellsizer.gif") > 0 || imgs[i].src.indexOf("cellSizer")>=0)) {
				imgs[i].style.width="0px";
			}
		}
		for(var i=0;i<tds.length;i++){
			tds[i].style.width="0px";
		}
		for(var i=0;i<ths.length;i++){
			ths[i].style.width="0px";
		}
	}
	div.selectId=function(id){
		for(var i=0;i<this.rows.length;i++){
			var tr=this.rows[i];
			if(tr.getElementsByTagName("INPUT")[1]){
				var input=tr.getElementsByTagName("INPUT")[1];
				if(id==input.value){
					this.selectElement(tr);
				}
			}
		}
	}
	div.fixCellsWidth=function(){
		if(CHROME){
			this.thead.style.position = "absolute";
		}
		if(this.tbody.rows.length == 0) {
			for(var i = 0; i < div.thead.rows[0].cells.length; i++) {
				if(this.thead.rows[0].cells[i].style.width.indexOf("%") < 0 &&
					getUnPaddedWidth(this.thead.rows[0].cells[i]) > parseInt(this.thead.rows[0].cells[i].style.width.split("px")[0])){
					
					this.thead.rows[0].cells[i].style.width = getUnPaddedWidth(this.thead.rows[0].cells[i]) + "px";
					var imgs = this.thead.rows[0].cells[i].getElementsByTagName("IMG");
					if(imgs[imgs.length-1].src.indexOf("cellsizer.jpg") > 0)
						imgs[imgs.length-1].style.width = getUnPaddedWidth(this.thead.rows[0].cells[i]) + "px";
				}
			}
			return;
		}
		var cellNum = 0;
		if(this.tbody.rows[cellNum].style.display == "none" && this.tbody.rows.length == 2) {
			cellNum = 1;
		}
		
		if(this.tbody.rows.length > 0 && this.tbody.rows[cellNum].getAttribute("cellSizer") == "true") {
			for(var i = 0; i < div.thead.rows[0].cells.length; i++) {
				if(this.thead.rows[0].cells[i].clientWidth != this.tbody.rows[cellNum].cells[i].clientWidth
					&& this.tbody.rows[cellNum].cells[i].clientWidth != 0){
					
					if(this.thead.rows[0].cells[i].clientWidth > this.tbody.rows[cellNum].cells[i].clientWidth) {
						
						var imgs = this.tbody.rows[cellNum].cells[i].getElementsByTagName("IMG");
						var imgs2 = this.thead.rows[0].cells[i].getElementsByTagName("IMG");
						if(imgs.length > 0) {
							
							if(imgs[imgs.length-1].src.indexOf("cellsizer.gif") > 0) {								
								imgs[imgs.length-1].style.width = (getUnPaddedAndUnBorderWidth(this.thead.rows[0].cells[i]) - getMargins(imgs[imgs.length-1])) + "px";
							}
							if(imgs2[imgs2.length-1].src.indexOf("cellsizer.gif") > 0) {								
								imgs2[imgs2.length-1].style.width = (getUnPaddedAndUnBorderWidth(this.thead.rows[0].cells[i]) - getMargins(imgs2[imgs2.length-1])) + "px";
							}
						}
					} else {
						
						var imgs = this.thead.rows[0].cells[i].getElementsByTagName("IMG");
						var imgs2 = this.tbody.rows[cellNum].cells[i].getElementsByTagName("IMG");
						if(imgs.length > 0) {
							
							if(imgs[imgs.length-1].src.indexOf("cellsizer.gif") > 0) {
								imgs[imgs.length-1].style.width = (getUnPaddedAndUnBorderWidth(this.tbody.rows[cellNum].cells[i]) - getMargins(imgs[imgs.length-1])) + "px";
							}
							if(imgs2[imgs2.length-1].src.indexOf("cellsizer.gif") > 0) {
								imgs2[imgs2.length-1].style.width = (getUnPaddedAndUnBorderWidth(this.tbody.rows[cellNum].cells[i]) - getMargins(imgs2[imgs2.length-1])) + "px";
							}
						}
					}
				}
			}
		}
		if(CHROME){
			this.thead.style.position = "relative";
		}
	}
	div.fixMozHeaderWidth=function(){
		if(!MSIE && this.getAttribute("percentage") ){
			this.fixCellsWidth();
		}
	}
	div.moveSelectedUp=function(){
		if(this.selectedItems.length==1){
			var index=this.selectedItems[0].rowIndex-1;
			if(this.rows[index-1] && this.rows[index-1].style.display!="none"){
				this.swapRows(index,(index-1));
				this.unselectAll();
				this.selectElement(this.rows[index-1]);
			}
		}
	}
	div.moveSelectedDown=function(){
		if(this.selectedItems.length==1){
			var index=this.selectedItems[0].rowIndex-1;
			if(this.rows[index+1] && this.rows[index+1].style.display!="none"){
				this.swapRows(index,(index+1));
				this.unselectAll();
				this.selectElement(this.rows[index+1]);
			}
		}
	}
	div.setCellInnerHTML=function(cell,html){
		if(cell && cell.getElementsByTagName("SPAN")[0]){
			cell.getElementsByTagName("SPAN")[0].innerHTML=html;
		}
	}
	div.fixTBodyPosition=function(){
		var headContainer=this.getElementsByTagName("DIV")[0];
		var bodyContainer=this.getElementsByTagName("DIV")[1];
		var maxHeight=0;
		var ths=headContainer.getElementsByTagName("TR")[0].cells;
		for(var i=0;i<ths.length;i++){
			if(maxHeight<ths[i].clientHeight){
				maxHeight=ths[i].clientHeight;
			}
		}
		//if(!MSIE){
			headContainer.style.paddingTop=maxHeight+"px";
			bodyContainer.style.height=(parseInt(bodyContainer.parentNode.parentNode.clientHeight)-(maxHeight))+"px";
		//}
		if(CHROME){
			this.thead.position="absolute";
			this.thead.position="relative";		
		}
	}
	setCommonFunctions(div);
	div.fixMozHeaderWidth();
	try{
		if(listGridId){
			div.selectId(listGridId);
		}
	}catch(e){}
	if(FIREFOX){
		try{
			if(div.parentNode.parentNode.parentNode.parentNode.parentNode.getAttribute("initMinimized")=="true"){
				div.parentNode.parentNode.parentNode.parentNode.parentNode.style.display="none";
			}
		}catch(e){}
	}
}


function unsetGrid(div){
	for(var g=0;g<grids.length;g++){
		if(grids[g]===div){
			grids.splice(g,1);
		}
	}
	try{
	div.setAttribute("ready","false");
	//div.innerHTML=div.table.parentNode.innerHTML;
	if(!MISE){
		delete(div.table);
		delete(div.thead);
		delete(div.tbody);
		delete(div.dataGridHeader);
		delete(div.dataGridContent.thead);
		delete(div.dataGridContent.onscroll);
		delete(div.dataGridContent.onmouseup);
		delete(div.dataGridContent);
		delete(div.setWidth);
		delete(div.onscroll);
		delete(div.updateScroll);
		delete(div.setHeight);
		delete(div.bestColWidth);
		delete(div.selectId);
		delete(div.fixCellsWidth);
		delete(div.fixMozHeaderWidth);
		delete(div.moveSelectedUp);
		delete(div.moveSelectedDown);
		delete(div.setCellInnerHTML);
		delete(div.rows);
		delete(div.getRows);
		delete(div.isMultiSelected);
		delete(div.selectedItems);
		delete(div.clearTable);
		delete(div.addRows);
		delete(div.addRow);
		delete(div.unselectAll);
		delete(div.selectAll);
		delete(div.removeSelected);
		delete(div.defaultGridMenu);
		delete(div.onmousedown);
		delete(div.selectElement);
		delete(div.unSelectElement);
		delete(div.isSelected);
		delete(div.deleteElement);
		delete(div.getSelected);
		delete(div.removeSelectedHTMLPagedGrid);
		delete(div.removeSelectedHTMLGrid);
		delete(div.setOdds);
		delete(div.prepareTR);
		delete(div.setHoverEffect);
		delete(div.swapRows);
		delete(div.isRowSelected);
		delete(div.onselect);
		delete(div.fixTBodyPosition);
	}else{
		div.table=null;
		div.thead=null;
		div.tbody=null;
		div.dataGridHeader=null;
		div.dataGridContent.thead=null;
		div.dataGridContent.onscroll=null;
		div.dataGridContent.onmouseup=null;
		div.dataGridContent=null;
		div.setWidth=null;
		div.onscroll=null;
		div.updateScroll=null;
		div.setHeight=null;
		div.bestColWidth=null;
		div.selectId=null;
		div.fixCellsWidth=null;
		div.fixMozHeaderWidth=null;
		div.moveSelectedUp=null;
		div.moveSelectedDown=null;
		div.setCellInnerHTML=null;
		div.rows=null;
		div.getRows=null;
		div.isMultiSelected=null;
		div.selectedItems=null;
		div.clearTable=null;
		div.addRows=null;
		div.addRow=null;
		div.unselectAll=null;
		div.selectAll=null;
		div.removeSelected=null;
		div.defaultGridMenu=null;
		div.onmousedown=null;
		div.selectElement=null;
		div.unSelectElement=null;
		div.isSelected=null;
		div.deleteElement=null;
		div.getSelected=null;
		div.removeSelectedHTMLPagedGrid=null;
		div.removeSelectedHTMLGrid=null;
		div.setOdds=null;
		div.prepareTR=null;
		div.setHoverEffect=null;
		div.swapRows=null;
		div.isRowSelected=null;
		div.onselect=null;
		div.fixTBodyPosition=null;
	}
	}catch(e){
	}
}


function hideMenu(){
	var toDelete=document.getElementById("contextMenuContainer");
	document.oncontextmenu="";
	if(toDelete!=null){
		document.body.removeChild(toDelete);
	}
}


function sizeGrids(width){
	if(FIREFOX1){
		width-=10;
	}
	if(grids){
		for(var g=0;g<grids.length;g++){
			grids[g].setWidth(width-40);
			var navBar=grids[g].nextSibling;
			grids[g].navBar=navBar;
			if(!MSIE){
				try{
					if( navBar!=undefined && navBar!=null){
						while(navBar.tagName!="TABLE" && navBar!=undefined && navBar!=null){
							navBar=navBar.nextSibling;
						}
					}
				}catch(e){}
			}
			if(navBar!=null && navBar!=undefined && navBar.className=="navBar" && (width-20)>0){
				navBar.style.width=(width-20)+"px";
			}
		}
	}
}

function fixInnerGrids(el){
	if(!el){
		el=document.getElementById("divContent");
	}
	var divs=el.getElementsByTagName("DIV");
	for(var d=0;d<divs.length;d++){
		if(divs[d].getAttribute("type")=="grid"){
			divs[d].fixHeader();
		}
	}
}

function doGoToPage(evt){
	var input=getEventSource(evt);
	evt=getEventObject(evt);
	input.focus();
	var value=parseInt(input.value);
	if(evt.keyCode == 13){
		if(value && parseInt(input.value)!=0){
			if(value<1 || value>parseInt(document.getElementById("hidCantPages").value)){
				value=document.getElementById("hidCantPages").value;
			}
			setTimeout(function(){
				try{
					var value=parseInt(document.getElementById("goToPage").value);
					goToPage();
				}catch(e){}
			},300);
			
		}
	}else{
		evt.cancelBubble=true;
		var func= function(){
			if( ((input.value*0)!=0) || (input.value<=0) || (input.value==0) || !isNumericBln(input.value)) {
				input.value=document.getElementById("hidActualPage").value;
			}
		}
		setTimeout(func,300);
	}
}


function setScriptBehaviorsToNodes(node){
	var inputs=node.getElementsByTagName("INPUT");
	for(var i=0;i<inputs.length;i++){
		if((inputs[i].name!="" && inputs[i].name!=undefined) && (inputs[i].id=="" || inputs[i].id==undefined)){
			inputs[i].id=inputs[i].name;
		}
		if(inputs[i].getAttribute("p_required")=="true"){
			setRequiredField(inputs[i]);
		}
		if(inputs[i].getAttribute("onpropertychange")!=null && (!MSIE)){
			setPropertyChanged(inputs[i]);
		}
		if(inputs[i].getAttribute("p_calendar")=='true'){
			setMask(inputs[i],inputs[i].getAttribute("p_mask"));
			setDTPicker(inputs[i]);
		}else if(inputs[i].getAttribute("p_mask")!=null){
			setMask(inputs[i],inputs[i].getAttribute("p_mask"));
		}
		if(inputs[i].getAttribute("p_email")=="true"){
			addListener(inputs[i],"blur",isEMail)
		}
		if(inputs[i].getAttribute("p_numeric")=="true"){
			setNumeric(inputs[i]);
		}
		if(inputs[i].getAttribute("readOnly")==true || inputs[i].getAttribute("readOnly")=="true" || inputs[i].getAttribute("readOnly")=="readonly"){
			setBrwsReadOnly(inputs[i]);
		}
	}
	var textAreas=node.getElementsByTagName("TEXTAREA");
	for(var i=0;i<textAreas.length;i++){
		if((textAreas[i].name!="" && textAreas[i].name!=undefined) && (textAreas[i].id=="" || textAreas[i].id==undefined)){
			textAreas[i].id=textAreas[i].name;
		}
		if(textAreas[i].getAttribute("p_maxlength")!=null){
			setMaxLength(textAreas[i]);
		}
		if(textAreas[i].getAttribute("p_numeric")!=null){
			setNumeric(textAreas[i]);
		}
		if(textAreas[i].getAttribute("readOnly")==true || textAreas[i].getAttribute("readOnly")=="true" || textAreas[i].getAttribute("readOnly")=="readonly"){
			setBrwsReadOnly(textAreas[i]);
		}
	}
	var selects=node.getElementsByTagName("SELECT");
	for(var i=0;i<selects.length;i++){
		if((selects[i].name!="" && selects[i].name!=undefined) && (selects[i].id=="" || selects[i].id==undefined)){
			selects[i].id=selects[i].name;
		}
		if(selects[i].getAttribute("p_required")=="true"){
			setRequiredField(selects[i]);
		}
		if(selects[i].getAttribute("readOnly")==true || selects[i].getAttribute("readOnly")=="true" || selects[i].getAttribute("readOnly")=="readonly"){
			setBrwsReadOnly(selects[i]);
		}
	}
}

function inFirstTr(input){
	var father=input.parentNode;
	while(father.tagName!="BODY"){
		if(father.tagName=="TR" && father.getAttribute("name")=="firstTr"){
			return true;
		}
		father=father.parentNode;
	}
	return false;
}

function setGridsScrollToZero(){
	if(grids){
		for(var i=0;i<grids.length;i++){
			var thead=grids[i].thead;
			if(grids[i].getElementsByTagName("DIV").length>=1){
				grids[i].getElementsByTagName("DIV")[1].scrollLeft=0;
				if(MSIE){
					this.scrollLeft=0;
				}else if(OPERA){
					var tr=thead.getElementsByTagName("TR")[0];
					tr.style.position="absolute";
					tr.style.left=(-this.scrollLeft*0.9)+"px";
					tr.style.top=0+"px";
				}else{
					thead.style.position="relative";
					var tr=thead.getElementsByTagName("TR")[0];
					
					var theTable = grids[i].getElementsByTagName('TABLE');
					if (theTable && theTable.length > 0)
						theTable = theTable[0];
						
					if(theTable && theTable.getAttribute('execGrid') == "true")
						tr.style.left = "-1px";
					else
						tr.style.left="0px";
				}
			}
		}
	}
}

function getCellInnerHTML(cell){
	if(cell.getElementsByTagName("SPAN")[0] && cell.getElementsByTagName("SPAN")[0].getAttribute("type")=="data"){
		return cell.getElementsByTagName("SPAN")[0].innerHTML;
	}else{
		var indexOfBr=cell.innerHTML.indexOf("<br");
		if(indexOfBr==-1){
			indexOfBr=cell.innerHTML.indexOf("<BR");
		}
		if(indexOfBr==-1){
			indexOfBr=cell.innerHTML.length;
		}
		return cell.innerHTML.substring(0,indexOfBr);
	}
}

function fixMozGridsHeader(){
	if(!MSIE && grids){
		for(var i=0;i<grids.length;i++){
			grids[i].fixTBodyPosition();
		}
	}
}

function fixGridsHeader(){
	if(grids){
		for(var i=0;i<grids.length;i++){
			grids[i].fixTBodyPosition();
		}
	}
}