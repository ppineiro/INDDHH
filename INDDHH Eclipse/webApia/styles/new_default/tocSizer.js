var tocSizer;
var tocMover;
function setTocSizer(){
	tocSizer=document.createElement("DIV");
	tocSizer.id="tocSizer";
	tocSizer.style.width="7px"
	tocSizer.style.height=document.getElementById("tocArea").clientHeight+"px";
	tocSizer.style.position="relative";
	tocSizer.style.top=document.getElementById("tocArea").clientTop+"px";
	tocSizer.style.left=document.getElementById("tocArea").clientWidth+"px";
	tocSizer.name="tocSizer";
	tocSizer.style.cursor="pointer";
	tocSizer.style.cursor="w-resize";
	tocSizer.frameBorder="no";
	tocSizer.style.zIndex="999999999";
	tocMover=document.createElement("DIV");
	tocMover.style.zIndex="999999995";
	tocMover.style.width="7px"
	//tocMover.style.backgroundColor="red"
	tocMover.style.height=document.getElementById("tocArea").clientHeight+"px";
	tocMover.style.position="relative";
	tocMover.appendChild(tocSizer);
	document.body.appendChild(tocMover);

	tocSizer.onmousedown=function(){
		this.style.height=document.getElementById("tocArea").clientHeight+"px";
		tocMover.style.height=document.getElementById("tocArea").clientHeight+"px";
		var toListen;
		if(navigator.userAgent.indexOf("MSIE")>0){
			this.style.border="1px solid black";
		}else{
			this.style.backgroundColor="grey";
		}
		startMover();
		tocMover.onmousemove=function(aEvent){
			var tempX=0;
			if(navigator.userAgent.indexOf("MSIE")>0){
				aEvent=window.event;
				tempX = aEvent.clientX + document.body.scrollLeft-8;
			}else{
				tempX = aEvent.pageX-8;
			}
			//window.frames["tocArea"].setTocWidth(tempX);
			tocSizer.style.left=(tempX)+"px";
		}
	}
	tocSizer.onmouseup=function(aEvent){
		tocMover.onmousemove=[];
		killMover();
		var tempX=0;
		this.style.border="0px";
		this.style.backgroundColor="transparent";
		if(navigator.userAgent.indexOf("MSIE")>0){
			aEvent=window.event;
			tempX = aEvent.clientX + document.body.scrollLeft;
		}else{
			tempX = aEvent.pageX;
		}
		var theWidth=154;
		if(tempX>154){
			theWidth=tempX;
		}else{
			theWidth=156;
			this.style.left="154px";
		}
		if(navigator.userAgent.indexOf("MSIE")>0){
			setTimeout("window.frames['tocArea'].setTocWidth("+theWidth+")",100);
		}else{
			window.frames["tocArea"].setTocWidth(theWidth);
		}
	}
}


function startMover(){
	tocMover.style.width="700px"
}
function killMover(){
	tocMover.style.width="1px"
}

if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", setTocSizer, false);
}else{
	setTocSizer();
}