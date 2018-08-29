
var TOC_AREA_DEFAULT_WIDTH = 151;


///////////////////////////////////////////
//	tocArea functions
//////////////////////////////////////////

function stretchWorkArea(){
	document.getElementById("workArea").style.posLeft = WORK_AREA_MAX;
	var width=document.body.clientWidth-10;
	document.getElementById("workArea").style.width=(width)+"px";
}

function shrinkWorkArea(){
	document.getElementById("workArea").style.posLeft = WORK_AREA_MIN;
	var width=document.body.clientWidth-10;
	document.getElementById("workArea").style.width=(width-155)+"px";
}

function resizeTocArea(newSize){
	//--------Update tocAreas Width
	//alert("resizeTocArea in frames.js:" + newSize);
	if(tocArea!=null){
		var titleToc = document.getElementById("tocBar");
		if(titleToc!=null){
			document.getElementById("tocArea").style.posWidth = newSize;
			titleToc.style.backgroundColor="gainsboro";
			titleToc.style.color="dimgray";
		}
	}
}
