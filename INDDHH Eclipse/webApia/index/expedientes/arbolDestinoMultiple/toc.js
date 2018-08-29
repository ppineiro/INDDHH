/*TOC.JS */
	
var stateMenu=0
function GetChildElem(eSrc,sTagName){
	if(!document.all && eSrc.nextElementSibling && eSrc.nextElementSibling.tagName=="UL"){
		eSrc=eSrc.nextElementSibling;
		return eSrc;
	} 
	var cKids = eSrc.children;
	for (var i=0;i<cKids.length;i++){
		if (sTagName == cKids[i].tagName) return cKids[i];    
	}
	return false;
}
  
//document.onclick=function(evt){	
function treeClick(evt){
	if(window.event){
		evt=window.event;
	}
	evt.cancelBubble=true;
	var eSrc = (window.event)?evt.srcElement:evt.target;
	if ("clsHasKids" == eSrc.className && (eChild = GetChildElem(eSrc,"UL")) ){	  
		
		getValues(eSrc)
    
		eChild.style.display = ("block" == eChild.style.display ? "none" : "block");
      
		//**cambia imagenes de Folder
		
  		estado=eChild.style.display
  			
  		if (eSrc.getAttribute("tp")=='C'){
  			if (estado=="none" || estado==""){
				eSrc.getElementsByTagName("IMG")[0].src="images/folder_closed.gif"					
  			}
  			else{					
  				eSrc.getElementsByTagName("IMG")[0].src="images/folder_open.gif"					
  			}
  		}
  		
  		if (eSrc.getAttribute("tp")=='PN'){
  			if (estado=="none" || estado==""){
				eSrc.getElementsByTagName("IMG")[0].src="images/folder_closed.gif"					
  			}
  			else{					
  				eSrc.getElementsByTagName("IMG")[0].src="images/folder_open.gif"					
  			}
  		}
  		
  				
	}
}

function ShowAll(sTagName){
	var cElems = document.getElementsByTagName(sTagName);
	var iNumElems = cElems.length;
	for (var i=1;i<iNumElems;i++) cElems[i].style.display = "block";
}
  
function HideAll(sTagName){
	var cElems = document.getElementsByTagName(sTagName);
	var iNumElems = cElems.length;
	for (var i=1;i<iNumElems;i++) cElems[i].style.display = "none";
}
 
document.oncontextmenu=function(){	
	//if (window.event.srcElement.tagName=="BODY")
	//{		
	//alert(document.body.innerHTML)
	
	/*
	if (stateMenu==0){
		ShowAll('UL')
		stateMenu=1
	}
	else{
		HideAll('UL')
		stateMenu=0
	}
	*/
	
	//}
	
	//alert(window.event.srcElement.tagName)
	return false
}
	
document.onselectstart=function(){
	return false
}
  
  
function getValues(oEl){
//alert(oEl.innerText)
//  parent.nodoSel.value=oEl.de
//  parent.nodoCod.value=oEl.id
//  parent.nodoActivo.value=oEl.ac
//  parent.nodoTipo.value=oEl.tp
 
	switch (oEl.getAttribute("tp")){
		case "0": //nodo igual a carpeta
			break
		
		case "1": //nodo igual a Funcionalidad
			if (oEl.firstChild.checked==false){				
				oEl.firstChild.checked=true				
				chkMeBox(oEl.firstChild)
			}
			else{				
				oEl.firstChild.checked=false				
				chkMeBox(oEl.firstChild)
			}
		
			//parent.frames(2).location.href = "../" + oEl.address
			break	
	}
  
	switch (oEl.getAttribute("ac")){ 
		case "0": // nodo borrado
			break
		case "1": //nodo ACTIVO
			break
	}
}
function hover(oEl) {
	if(oEl.tp!=0){
		oEl.style.color = "lightyellow";
	}
}
function unhover(oEl) {
	if(oEl.tp!=0){
		oEl.style.color = "black"
	}
}
//funciones de checkeo de checkboxes
function chkMeBox(obj){		
	var z;
	var objLi;
	var nroHijos;
	allChildrenOff=0;	
	objLi=obj.parentNode;	
	
	//-------------------------checkear todos los hijos	si es un padre (y checkear los padres si tiene)
	if (objLi.tp=='C'){
		nroHijos=objLi.children(2).childNodes.length
		for (z=0; z < nroHijos; z++){
			if (obj.checked!=true){
				objLi.children(2).childNodes[z].childNodes[0].checked=false;
			}
			else{
				objLi.children(2).childNodes[z].childNodes[0].checked=true;
			}
			if (objLi.children(2).childNodes[z].childNodes[0].parentNode.tp == 'C'){
				chkMeBox(objLi.children(2).childNodes[z].childNodes[0]);
			}
		}
		
		
		objFather=obj.parentNode.parentNode.parentNode
		if (objFather.children(2)!=null){
			nroHijos=objFather.children(2).childNodes.length
		}
		else{
			nroHijos=0
		}
				
		if (obj.checked==true){			
			objFather.childNodes[0].checked=true;
			checkFathersTrue(objFather);
		}
		else{
			for (var x=0; x < nroHijos; x++){
				if(objFather.children(2).childNodes[x].childNodes[0].checked!=true){
					allChildrenOff++
				}
			}
			if (allChildrenOff==nroHijos){
				objFather.childNodes[0].checked=false;
				checkFathersFalse(objFather);
			}
		}		
		
		
		
	}
	//-------------------------checkear todos los padres si se chk un hijo	
	else{		
		objFather=obj.parentNode.parentNode.parentNode
		if (objFather.children(2)!=null){
			nroHijos=objFather.children(2).childNodes.length
		}
		else{
			nroHijos=0
		}
				
		if (obj.checked==true){			
			objFather.childNodes[0].checked=true;
			checkFathersTrue(objFather);
		}
		else{
			for (var x=0; x < nroHijos; x++){
				if(objFather.children(2).childNodes[x].childNodes[0].checked!=true){
					allChildrenOff++
				}
			}
			if (allChildrenOff==nroHijos){
				objFather.childNodes[0].checked=false;
				checkFathersFalse(objFather);
			}
		}
	}
}
function checkFathersTrue(obj){
	if (obj.parentNode.parentNode.childNodes[0] != null){
		if (obj.parentNode.parentNode.childNodes[0].type == "checkbox"){	
			obj.parentNode.parentNode.childNodes[0].checked=true;
			checkFathersTrue(obj.parentNode.parentNode);
		}
	}
}
function checkFathersFalse(obj){
	var allChildrenOfff;
	var x1;
	allChildrenOfff=0;
	objFather = obj.parentNode.parentNode
	if (objFather.children(2)!=null){
		nroHijos=objFather.children(2).childNodes.length
	}
	else{
		nroHijos=0
	}
	
	for (x1=0; x1 < nroHijos; x1++){
		if(objFather.children(2).childNodes[x1].childNodes[0].checked!=true){
			allChildrenOfff++
		}
	}
	if (allChildrenOfff==nroHijos){
		if (objFather.childNodes[0].type == "checkbox"){	
			objFather.childNodes[0].checked=false;
			checkFathersFalse(objFather);
		}
	}
}
//NUEVO
function desChequearTodos(ele, flag){
	var sep2 = document.getElementById("textSeparador2").value;
	var sep1 = document.getElementById("textSeparador1").value;
	var tmpId = document.getElementById("textIdOficinaDestino").value;
	var tmpCod = document.getElementById("textCodOficinaDestino").value;
	var tmpName = document.getElementById("textNameOficinaDestino").value;
	
	if (ele.checked){				
		tmpId = tmpId + sep2 + ele.value + sep2;  			
		tmpCod = tmpCod + sep2 + ele.name + sep2;
		tmpName = tmpName + sep2 + ele.parentNode.title + sep2;		
	}else{		
		tmpId = replaceSubstring(tmpId, sep2 + ele.value + sep2, sep2);				
		tmpCod = replaceSubstring(tmpCod, sep2 + ele.name + sep2, sep2);
		tmpName = replaceSubstring(tmpName, sep2 + ele.parentNode.title + sep2, sep2);
	}
	
	tmpId = replaceSubstring(tmpId, sep2 + sep2, sep2);
	tmpCod = replaceSubstring(tmpCod, sep2 + sep2, sep2);
	tmpName = replaceSubstring(tmpName, sep2 + sep2, sep2);
	
	document.getElementById("textIdOficinaDestino").value = tmpId;
	document.getElementById("textCodOficinaDestino").value = tmpCod;
	document.getElementById("textNameOficinaDestino").value = tmpName;		
}
//NUEVO
function desChequearUsuarios(ele){	
	var sep2 = document.getElementById("textSeparador2").value;	
	var tmp = document.getElementById("textLstUsuarioDestino").value;
	
	if (ele.checked){		
		document.getElementById("textUsuarioDestino").value=ele.value;
		tmp = tmp + sep2 + ele.value + sep2;  	
		cargarFOTO(ele.value);			
	}else{		
		tmp = replaceSubstring(tmp, sep2 + ele.value + sep2, sep2);	
		cargarFOTO("");			
	}
		
	tmp = replaceSubstring(tmp, sep2 + sep2, sep2);
	
	/*
	//sacamos el primer caracter si es un separador
	if (tmp.indexOf(sep2)==0){
		alert(tmp.length);
		alert(1 + " - " + (tmp.length));
		tmp = tmp.substring(1, (tmp.length))
	}
	
	//sacamos el ultimo caracter si es un separador
	if (tmp.lastIndexOf(sep2)== (tmp.length - 1)){		
		tmp = tmp.substring(0, (tmp.length - 1))
	}
	alert(tmp);
	*/
	document.getElementById("textLstUsuarioDestino").value = tmp;	
}
//NUEVO
function ajustarIMG(ele){
	
	/*
	alert("ajustarIMG(" + ele.src + ")");			
  	alert("height: " + ele.height);
  	alert("width: " + ele.width);
  	
  	if (ele.height > 100){
  		ele.height 
  	}
  	*/
}

function replaceSubstring(inputString, fromString, toString) {
   // Goes through the inputString and replaces every occurrence of fromString with toString
   var temp = inputString;
   if (fromString == "") {
      return inputString;
   }
   if (toString.indexOf(fromString) == -1) { // If the string being replaced is not a part of the replacement string (normal situation)
      while (temp.indexOf(fromString) != -1) {
         var toTheLeft = temp.substring(0, temp.indexOf(fromString));
         var toTheRight = temp.substring(temp.indexOf(fromString)+fromString.length, temp.length);
         temp = toTheLeft + toString + toTheRight;
      }
   } else { // String being replaced is part of replacement string (like "+" being replaced with "++") - prevent an infinite loop
      var midStrings = new Array("~", "`", "_", "^", "#");
      var midStringLen = 1;
      var midString = "";
      // Find a string that doesn't exist in the inputString to be used
      // as an "inbetween" string
      while (midString == "") {
         for (var i=0; i < midStrings.length; i++) {
            var tempMidString = "";
            for (var j=0; j < midStringLen; j++) { tempMidString += midStrings[i]; }
            if (fromString.indexOf(tempMidString) == -1) {
               midString = tempMidString;
               i = midStrings.length + 1;
            }
         }
      } // Keep on going until we build an "inbetween" string that doesn't exist
      // Now go through and do two replaces - first, replace the "fromString" with the "inbetween" string
      while (temp.indexOf(fromString) != -1) {
         var toTheLeft = temp.substring(0, temp.indexOf(fromString));
         var toTheRight = temp.substring(temp.indexOf(fromString)+fromString.length, temp.length);
         temp = toTheLeft + midString + toTheRight;
      }
      // Next, replace the "inbetween" string with the "toString"
      while (temp.indexOf(midString) != -1) {
         var toTheLeft = temp.substring(0, temp.indexOf(midString));
         var toTheRight = temp.substring(temp.indexOf(midString)+midString.length, temp.length);
         temp = toTheLeft + toString + toTheRight;
      }
   } // Ends the check to see if the string being replaced is part of the replacement string or not
   return temp; // Send the updated string back to the user
} // Ends the "replaceSubstring" function
//---