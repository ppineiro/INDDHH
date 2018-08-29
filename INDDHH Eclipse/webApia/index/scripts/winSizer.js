// JavaScript Document
var sizerReady=false;
function initWinSizer(){
	sizeMe();
	if(!sizerReady){
		sizerReady=true;
		window.onresize=function(e){
			e=getEventObject(e);
			e.cancelBubble=true;
			sizeMe();
		}
		if(!FIREFOX1){
			addListener(document,"mouseup",timeoutOverflow);
		}
	}
	if(!MSIE){
		var btns=document.getElementsByTagName("BUTTON");
		for(var i=0;i<btns.length;i++){
			btns[i].type="button";
		}
		setColsStyles();
	} else {
		setColsStylesIE();
	}
}

function timeoutOverflow(){
	var divContent=document.getElementById("divContent");
	if(divContent){
		setTimeout(function(){
			try{setPageOverFlow();}catch(e){}
		},100);
	}
}

function sizeMe(){
	if(MSIE && document.getElementById("divContent")!=null){
		document.getElementById("divContent").style.position="relative";
		var height=document.body.parentNode.clientHeight-10;
		if(document.body.parentNode.clientHeight==0){
			height=document.body.clientHeight-10;
		}
		var width=document.body.parentNode.clientWidth;
		document.getElementById("divContent").style.position="relative";
		if(window.name=="" && !window.parent.document.getElementById("workarea")){
			width-=20;
			height-=5;
		}else if(window.name==""){
			width=width-5;
			height+=2;
		}else if(window.name!="workArea"){
			height+=2;
		}
		if(document.body.className=="listBody" && width!=0){
			height+=5;
			width-=5;
		}
		divContentHeight=height;
		var divContentParent=document.getElementById("divContent").parentNode;
		for(var i=0;i<divContentParent.childNodes.length;i++){
			if(((divContentParent.childNodes[i].tagName=="TABLE")||(divContentParent.childNodes[i].tagName=="DIV")) && (divContentParent.childNodes[i].id!="divContent")){
				divContentHeight=divContentHeight-divContentParent.childNodes[i].clientHeight;
			}
		}
		if(divContentParent!=document.body){
			for(var i=0;i<document.body.childNodes.length;i++){
				if(((document.body.childNodes[i].tagName=="TABLE")||(document.body.childNodes[i].tagName=="DIV")) && (divContentParent.childNodes[i].id!="divContent")){
					divContentHeight=divContentHeight-document.body.childNodes[i].clientHeight;
				}
			}
		}
		if(divContentHeight>0){
			document.getElementById("divContent").style.height=divContentHeight+"px";
			//document.getElementById("divContent").style.width=(width-8)+"px";
			document.getElementById("divContent").style.width="99%";
			sizeTabElements(divContentHeight,width-5);
			sizeGrids(document.getElementById("divContent").offsetWidth-20);
			sizeImageViews(document.getElementById("divContent").offsetWidth-20);
		}
		var tables=document.getElementsByTagName("TABLE");
		for(var i=0;i<tables.length;i++){
			if(tables[i].className=="tblFormLayout" && window.name=="workArea"){
				//tables[i].style.width=(width-35)+"px";
				tables[i].style.width="95%";
			}
			if(tables[i].className=="tblFormLayout" && window.name==""){
				tables[i].style.width=(width-30)+"px";
			}
			if(tables[i].className=="frmSubTit"){
				tables[i].style.width=(width-30)+"px";
				if(MSIE){
					tables[i].style.display="none";
					tables[i].style.display="block";
				}
			}
		}
		if(window.name!="workArea" && width>15){
			document.getElementById("divContent").style.width=(width-15)+"px";
		}
		if(document.body.className!="listBody" && window.name=="workArea"){
			document.body.style.marginLeft="5px";
		}
		if(MSIE && grids){
			for(var i=0;i<grids.length;i++){
				var navBar=grids[i].navBar;
				if(navBar){
					var disp=navBar.style.display;
					navBar.style.display = 'none';
					navBar.style.display = disp;
				}
			}
		}
	}else if(navigator.userAgent.indexOf("MSIE")<0 && document.getElementById("divContent")){
		//mozilla
		var height=window.innerHeight-8;
		var width=(document.body.offsetWidth-10);
		if(document.body.className=="listBody"){
			height+=5;
			width+=5;
		}
		var divContentParent=document.getElementById("divContent").parentNode;
		divContentHeight=height;
		var divContentParent=document.getElementById("divContent").parentNode;
		for(var i=0;i<divContentParent.childNodes.length;i++){
			if(((divContentParent.childNodes[i].tagName=="TABLE")||(divContentParent.childNodes[i].tagName=="DIV")) && (divContentParent.childNodes[i].id!="divContent")){
				divContentHeight=divContentHeight-divContentParent.childNodes[i].clientHeight;
			}
		}
		if(divContentParent!=document.body){
			for(var i=0;i<document.body.childNodes.length;i++){
				if(((document.body.childNodes[i].tagName=="TABLE")||(document.body.childNodes[i].tagName=="DIV")) && (divContentParent.childNodes[i].id!="divContent")){
					divContentHeight=divContentHeight-document.body.childNodes[i].clientHeight;
				}
			}
		}
		if(divContentHeight>0){
			if(document.body.className!="listBody"){
				document.getElementById("divContent").style.height=(divContentHeight-3)+"px";
				var divContentWidth=width;
				if(document.getElementById("divContent").scrollHeight>document.getElementById("divContent").offsetHeight){
					divContentWidth-=10;
				}
				document.getElementById("divContent").style.width=(divContentWidth)+"px";
			}else{
				document.getElementById("divContent").style.height=(divContentHeight)+"px";
				document.getElementById("divContent").style.width=(width)+"px";
			}
			sizeTabElements(divContentHeight,width);
			sizeGrids(document.getElementById("divContent").offsetWidth-15);
			sizeImageViews(document.getElementById("divContent").offsetWidth-15);
		}
		if(document.body.className!="listBody" && window.name=="workArea"){
			document.body.style.marginLeft="5px";
		}
		var tables=document.getElementsByTagName("TABLE");
		if(window.name=="workArea"){
			for(var i=0;i<tables.length;i++){
				if(tables[i].className=="tblFormLayout" && window.name=="workArea"){
					tables[i].style.width="95%";
				}
				if(tables[i].className=="tblFormLayout" && window.name==""){
					tables[i].style.width=(width-35)+"px";
				}
			}
		}
	}
	
	if(window.name!="workArea" && !document.getElementById("divContent")){
		if(document.getElementById("ifrMain")){
			var frame=document.getElementById("ifrMain");
			frame.style.width="100%";
			var height=window.innerHeight-10;
			if(MSIE){
				height=document.documentElement.clientHeight-25;
				frame.style.height=(height+19)+"px";
				frame.style.width="99%";
				window.parent.document.body.style.overflow="hidden";
			}else{
				frame.style.height=(height)+"px";
				frame.style.overflow="hidden";
			}
		}
	}
	var objects=document.getElementsByTagName("OBJECT");
	if(tabElements.length!=0 || objects.length==1){
		if(objects.length>0){
			var object=objects[0];
			if(object.getAttribute("dont_resize") == undefined || object.getAttribute("dont_resize") == null) {
				if(navigator.userAgent.indexOf("MSIE")<0){
					var id=object.getElementsByTagName("EMBED")[0].id;
					var embed=getFlashObject(id);
					if(embed){
						embed.width=(document.getElementById("divContent").offsetWidth)+"px";
						embed.style.height=(document.getElementById("divContent").offsetHeight-20)+"px";
					}
				}else{
					object.width="100%";
					if( (document.getElementById("divContent").offsetHeight-40)>0){
						object.height=(document.getElementById("divContent").offsetHeight-40)+"px";
					}
					object.align="left";
				}
			}
		}
	}
	//try{sizeFilter();}catch(e){}
	setPageOverFlow();
	setGridsScrollToZero();
	fixMozGridsHeader();
}

function setColsStyles(){
	var tables=document.getElementsByTagName("TABLE");
	for(var i=0;i<tables.length;i++){
		var table=tables[i];
		var cols=table.getElementsByTagName("COL");//getElementsByTagName("COL");
		if(table.className=="pageTop"  || table.className=="pageBottom"){
			if(table.rows[0] && table.rows[0].cells[1]) {
				table.rows[0].cells[1].style.textAlign="right";
				table.rows[0].cells[1].align="right";
			}
		}
		if(table.getElementsByTagName("TBODY")[0] && cols.length>0 && cols.length<5){
			var trs=table.getElementsByTagName("TBODY")[0].rows;
			for(var u=0;u<trs.length;u++){
				var tr=trs[u];
				var tds=tr.cells;
				if(table.className=="tblFormLayout"){
					if(tds.length>1){

						var td0=null;
						var td2=null;
						if(tds[0]){
							td0=tds[0];
							if(td0.getAttribute("colspan")=="2"){
								td2=tds[1];
								if(!td0.getAttribute("text_align"))
									td0=null;
							}
						}else if(cols[0]){
							cols[0].parentNode.removeChild(cols[0]);
						}
						if(!tds[1] && cols[1]){
							cols[1].parentNode.removeChild(cols[1]);
						}
						if(tds[2] && !td2){
							td2=tds[2];
						}else if(cols[2]){
							cols[2].parentNode.removeChild(cols[2]);
						}
						if(!tds[3] && cols[3]){
							cols[3].parentNode.removeChild(cols[3]);
						}
						if(td0){
							var align = "right";
							if(td0.getAttribute("text_align"))
								align = td0.getAttribute("text_align");
							td0.style.textAlign = align;
							td0.align = align;
						}
						if(td2){
							var align = "right";
							if(td2.getAttribute("text_align"))
								align = td2.getAttribute("text_align");
							td2.style.textAlign = align;
							td2.align = align;
						}
					} else if(tds.length==1 && tds[0].getAttribute("text_align")) {
						var align = tds[0].getAttribute("text_align");
						tds[0].style.textAlign = align;
						tds[0].align = align;
					}
				}
				if(table.className=="navBar"){
					if(cols[1] && cols[1].className!="colM"){
						if(tds[0]){
						tds[0].style.width="40%";
						}
						if(tds[1]){
							tds[1].style.width="60%";
							tds[1].align="right";
							tds[1].style.textAlign="right";
						}
					}else if(cols[1]){
						if(tds[1]){
							tds[1].style.width="100%";
							tds[1].align="center";
						}
					}else if(cols[0] && cols[0].className=="col1"){
						if(tds[0]){
							tds[0].style.width="100%";
							tds[0].align="right";
							tds[0].style.textAlign="right";
						}
					}
				}
			}
		}
	}
}


function setColsStylesIE() {
	var tables=document.getElementsByTagName("TABLE");
	for(var i = 0; i<tables.length; i++){
		var table=tables[i];
		var cols=table.getElementsByTagName("COL");//getElementsByTagName("COL");
		if(table.getElementsByTagName("TBODY")[0] && cols.length>0 && cols.length<5){
			var trs = table.getElementsByTagName("TBODY")[0].rows;
			for(var u = 0; u < trs.length; u++){
				var tr=trs[u];
				var tds=tr.cells;
				if(table.className=="tblFormLayout"){
					for(var j = 0; j < tds.length; j++) {
						if(tds[j].getAttribute("text_align")) {
							var align = tds[j].getAttribute("text_align");
							tds[j].style.textAlign = align;
							tds[j].align = align;
						}
					}
				}
			}
		}
	}	
}


function setPageOverFlow(){
	if(document.body.className!="listBody"){
	if(document.getElementById("divContent") && document.getElementById("divContent").scrollHeight>document.getElementById("divContent").clientHeight){
		if(!MSIE && !CHROME && document.getElementById("divContent").getAttribute("force_overflow") == null){
			var scrollTop=0;
			if(FIREFOX1){
				scrollTop=document.getElementById("divContent").scrollTop;
			}
			
			var divContent = document.getElementById("divContent");
			var win_resize = divContent.getAttribute("win_resize");
			if(win_resize == undefined || win_resize == null || win_resize == "true") {
				divContent.style.overflow = "hidden";
				divContent.style.overflow = "-moz-scrollbars-vertical";
			} else {
				divContent.style.overflow = "auto";
			}
			
			//document.getElementById("divContent").style.overflow="hidden";
			//document.getElementById("divContent").style.overflow="-moz-scrollbars-vertical";
			
			if(FIREFOX1){
				document.getElementById("divContent").scrollTop=scrollTop;
			}
		}else{
			document.getElementById("divContent").style.overflowY="scroll";
			document.getElementById("divContent").style.overflowX="auto";
		}
	}else if(document.getElementById("divContent")){
		document.getElementById("divContent").style.overflow="hidden";
		if(MSIE){
			document.getElementById("divContent").style.overflowY="hidden";
		}
	}
	}
}