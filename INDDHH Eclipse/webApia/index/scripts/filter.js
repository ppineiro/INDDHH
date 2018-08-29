function setFilter(){
	var filter=document.getElementById("listFilterArea");
	if(filter){
		var title=filter.previousSibling;
		while(title.className!="subTit"){
			title=title.previousSibling;
		}
		title=title.getElementsByTagName("TR")[0].cloneNode(true);
		title.getElementsByTagName("TD")[1].innerHTML="";
		var auxTr=filter.getElementsByTagName("TR")[0].cloneNode(true);
		auxTr.getElementsByTagName("TD")[0].innerHTML=title.getElementsByTagName("TD")[0].innerHTML;
		auxTr.getElementsByTagName("TD")[0].className=title.getElementsByTagName("TD")[0].className;
		auxTr.getElementsByTagName("TD")[0].style.width="25%";
		for(var i=1;i<auxTr.getElementsByTagName("TD").length;i++){
			auxTr.getElementsByTagName("TD")[i].style.width="25%";
			auxTr.getElementsByTagName("TD")[i].innerHTML="";
		}
		title=auxTr;
		var emptyTr=document.createElement("TR");
		var tbody=filter.getElementsByTagName("tbody")[0];
		tbody.parentNode.style.width="90%";
		tbody.insertBefore(title,tbody.firstChild);
		tbody.insertBefore(emptyTr,tbody.firstChild);
		tbody.appendChild(emptyTr.cloneNode(true));
		filter.style.position="absolute";
		if(filter.getAttribute("topSize")){
			filter.style.top=filter.getAttribute("topSize");
		}else{
			filter.style.top="100px";
		}
		filter.style.height="0px";
		filter.style.zIndex=9999;
		var filterClone=filter.cloneNode(true);
		if(MSIE && filter.getAttribute("isQuery")=="true"){
			document.getElementById("divContent").appendChild(filterClone);
		}else{
			document.getElementById("frmMain").appendChild(filterClone);
		}
		//document.getElementById("frmMain").parentNode.style.position="absolute";
		filter.parentNode.removeChild(filter);
		filterClone.filterContent=filterClone.getElementsByTagName("DIV")[0];
		filterClone.filterContent.setAttribute("realHeight",filterClone.filterContent.style.height);
		filterClone.style.position="absolute";
		if(MSIE){
			cloneValues(filter,filterClone)
		}
		document.getElementById("listFilterArea").setAttribute("ready","true");
		if(filter.getAttribute("openWhenReady")=="true"){
			toggleFilterSection();
		}
	}
}


function sizeFilter(){
	var filter=document.getElementById("listFilterArea");
	
	var btn=document.getElementById("toggleFilter");
	if(btn){
		var btnPos=getAbsolutePosition(btn);
		var filterPos=getAbsolutePosition(filter);
		filter.style.position="absolute";
		if(!MSIE){
			filter.style.top=((btnPos.y+btn.offsetHeight)+5)+"px";
		}else{
			filter.style.top=((btnPos.y+btn.offsetHeight)-10)+"px";
		}
	}
	
	filter.style.height=filter.filterContent.getAttribute("realHeight");
	var absPos=getAbsolutePosition(filter.filterContent);
	var height=(absPos.y+filter.offsetHeight);
	var totalHeight=(absPos.y+filter.scrollHeight);
	var maxHeight=document.getElementById("divContent").offsetHeight;//-absPos.y;
	if(height>maxHeight){
		height=((maxHeight-absPos.y)-10);
	}else{
		height=filter.offsetHeight;
	}
	/*if(getStageHeight()<(height+filter.offsetTop)){
		height=(getStageHeight()-filter.offsetTop)-30;
	}*/
	//filter.style.height=height+"px";
	
	filter.style.height=(height+30)+"px";
	filter.filterContent.style.height=(height)+"px";
	//filter.filterContent.style.height=(height+20)+"px";
	//filter.style.height=(height+50)+"px";
	
	var grid=document.getElementById("gridList");
	if(document.getElementById("queryGrid")){
		grid=document.getElementById("queryGrid");
	}
	var w=0;
	if(grid){
		w=grid.offsetWidth;
	}else{
		w=getStageWidth()-10;
	}
	filter.filterContent.getElementsByTagName("TABLE")[0].style.width=(w-40)+"px";
	filter.style.width=(w-15)+"px";
	filter.style.left=((document.getElementById("divContent").offsetWidth-(w-15))/2)+"px";
	var cmds=filter.getElementsByTagName("SELECT");
	for(var i=0;i<cmds.length;i++){
		var cmd=cmds[i];
		try{
			if(parseInt(cmd.offsetWidth)>parseInt(cmd.parentNode.offsetWidth)){
				cmd.style.width=(cmd.parentNode.offsetWidth-10)+"px";
			}
		}catch(e){}
		
	}
}

function cloneValues(els,clonedEls){
	var inputs=els.getElementsByTagName("INPUT");
	var clonedInputs=clonedEls.getElementsByTagName("INPUT");
	for(var i=0;i<inputs.length;i++){
		if(inputs[i].type=="text"){
			clonedInputs[i].value=inputs[i].value;
		}
		if(inputs[i].type=="checkbox"){
			clonedInputs[i].checked=inputs[i].checked;
		}
	}
	var selects=els.getElementsByTagName("SELECT");
	var clonedSelects=clonedEls.getElementsByTagName("SELECT");
	for(var i=0;i<selects.length;i++){
		clonedSelects[i].selectedIndex=selects[i].selectedIndex;
	}	
}