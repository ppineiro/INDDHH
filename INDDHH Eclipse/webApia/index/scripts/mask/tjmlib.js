// overly simplistic test for IE
isIE = (document.all ? true : false);
// both IE5 and NS6 are DOM-compliant
isDOM = (document.getElementById ? true : false);

// get the true offset of anything on NS4, IE4/5 & NS6, even if it's in a table!
function getAbsX(elt) { return (elt.x) ? elt.x : getAbsPos(elt,"Left"); }
function getAbsY(elt) { return (elt.y) ? elt.y : getAbsPos(elt,"Top"); }
function getAbsPos(elt,which) {
 iPos = 0;
 //while (elt != null) {
  iPos += elt["offset" + which];
  //elt = elt.offsetParent;
 //}
 return iPos;
}

function getDivStyle(div) {
 var style=div.style;
 return style;
}

function hideElement(aEvent) {
	aEvent=getEventObject(aEvent);
	getCalendar(aEvent).style.visibility = 'hidden';
	getCalendar(aEvent).innerHTML="";
}


function moveBy(elt,deltaX,deltaY) {
 elt.left = parseInt(elt.left) + deltaX;
 elt.top = parseInt(elt.top) + deltaY;
}

function setSelectedDate(doc,div){
	var element=doc;
//	var div=doc.parentNode.getElementsByTagName("DIV")[0];
	var dateText=element.value;
	var valor1;
	var valor2;
	var valor3;
	
	if ('y' == strDateFormat.charAt(0)) {
		valor1=parseInt(dateText.substring(8,10));
		valor2=dateText.substring(5,7);
		if(valor2.charAt(0)==0){
			valor2=parseInt(valor2.charAt(1))-1;
		}else{
			valor2=parseInt(valor2)-1;
		}
		valor3=parseInt(dateText.substring(0,4));
		if(!isNaN(valor2)){
			displayMonth=valor2;
		}else{
			displayMonth=new Date().getMonth();
		}
		if(!isNaN(valor3)){
			displayYear=valor3;
		}else{
			if(MSIE){
				displayYear=new Date().getYear();
			}else{
				displayYear=(new Date().getYear())+1900;
			}
		}
	} else {
		valor1=dateText.substring(0,2);
		valor2=dateText.substring(3,5);
		valor3=parseInt(dateText.substring(6,10));
		if ('d' == strDateFormat.charAt(0)) {
			if(valor2.charAt(0)==0){
				valor2=parseInt(valor2.charAt(1))-1;
			}else{
				valor2=parseInt(valor2)-1;
			}
			if(!isNaN(valor2)){
				displayMonth=valor2;
			}else{
				displayMonth=new Date().getMonth();
			}
		} else {
		 	if(valor1.charAt(0)==0){
				valor1=parseInt(valor1.charAt(1))-1;
			}else{
				valor1=parseInt(valor1)-1;
			}
		 	if(!isNaN(valor1)){
				displayMonth=valor1;
			}else{
				displayMonth=new Date().getMonth();
			}
		}
		if(!isNaN(valor3)){
			displayYear=valor3;
		}else{
			if(MSIE){
				displayYear=new Date().getYear();
			}else{
				displayYear=(new Date().getYear())+1900;
			}
		}
	}
	newCalendar(div,doc);
}

function toggleVisible(div,hide) {
	div.style.visibility = hide;
}
function setPosition(div,x,y) {
	var maxX=document.body.offsetWidth;
	var maxY=window.innerHeight;
	if(MSIE){
		maxY=document.body.parentNode.clientHeight;
	}
	if((x+160)>=maxX){
		x=x-((x+160)-(maxX));
	}
	if((y+200)>=maxY){
		y=y-((y+180)-(maxY));
	}
	divstyle = getDivStyle(div);
	divstyle.left = x+'px';
	divstyle.top = y+'px';
}
/*function setPosition(elt,positionername,isPlacedUnder) {
 var positioner;
	positioner = document.getElementById(positionername);
 elt.left = getAbsX(positioner.getElementsByTagName("IMG")[0]);
// elt.top = getAbsY(positioner) + (isPlacedUnder ? positioner.height : 0);
}*/
