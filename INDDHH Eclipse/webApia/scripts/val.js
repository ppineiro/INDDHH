

//retorna la cantidad de checkboxes chequeados
function chksChecked(controlGrid){
	/*var oRows = controlGrid.rows;
	var cantChk = 0;
	for(i=0;i<oRows.length;i++){
		if(oRows[i].getElementsByTagName("INPUT")[0].checked == true && oRows[i].getElementsByTagName("INPUT")[0].style.visibility!="hidden"){
			cantChk++;
		}
	}
	return cantChk;*/
	return controlGrid.selectedItems.length;
}


function isEmpty(s){   
	return ((s == null) || (s.length == 0))
}

//verifica que sea un nombre v?lido
var reAlphanumeric = /^[a-zA-Z0-9_.]*$/;
function isValidName(s){
	var re = new RegExp("^[a-zA-Z0-9_.]*$");
//	var x = reAlphanumeric.test(s);
//	if(!x){
	if (!s.match(re)) {
		alert(GNR_INVALID_NAME);
		return false;
	}
	return true;
}

function isValidLogin(s){
	var re = new RegExp("^[a-zA-Z0-9_.]*$");
	//var x = reAlphanumeric.test(s);
	//if(!x){
	if (!s.match(re)) {
		alert(GNR_INVALID_LOGIN);
		return false;
	}
	return true;

}

//Verifica direcciones de mail
function isEMail(event){
	event=getEventObject(event);
	var valor=getEventSource(event);
	if (valor.length > 0) {
		var arroba = 0;
		var server = 0;
		var	pos_arroba = 0;
		var pEl=getEventSource(event);
		while (pEl.parentNode.tagName != "TD"){
			pEl = pEl.parentNode;
		}
		pvntLabel = pEl.parentNode.previousSibling.innerText;
		vLabel = replace(pvntLabel, ":","");
		vLabel = removeHTMLChars(vLabel);
		
		if (valor.length < 7) {
			i = GNR_NOT_EMAIL.indexOf("<TOK1>");
			alert(GNR_NOT_EMAIL.substring(0,i)+ vLabel + GNR_NOT_EMAIL.substring(i+6,GNR_NOT_EMAIL.length));
			pEl.value = "";
			return false;
		} else {
			for (i=0; i < valor.length; i++)
			{	
				caracter = valor.substring(i,i+1);
				if (caracter == "@" && i > 0)  //Si ingres? por lo menos una letra en usuario
				{
					arroba = 1;
					pos_arroba = i;
					if (i < valor.length - 1){
						server = 1;
					}
				}
				if (caracter == "." && (i > pos_arroba + 1) && arroba == 1 && server == 1)
				{
					if (i < valor.length - 1){
						return true;
					}
				}			
			}
		}
		
		i = GNR_NOT_EMAIL.indexOf("<TOK1>");
		alert(GNR_NOT_EMAIL.substring(0,i)+ vLabel + GNR_NOT_EMAIL.substring(i+6,GNR_NOT_EMAIL.length));
		pEl.value = "";
		return false;
	} else {
		return false;
	}
}
function verifyRequiredObjects(){
	if(!checkDates()){return false;}
	pblnRet = true;
//	var formEls = document.forms[0].getElementsByTagName("*");
	var formEls=requiredFields;
	/*if(MSIE){
		formEls=document.getElementsByTagName("*");
	}*/
	for (var indexCampo=0; indexCampo < formEls.length; indexCampo++){
		//si esta disabled no se valida, dado qeu tampoco viaja al server su valor y no calienta que no tenga nada como valor
		if(formEls[indexCampo].disabled  && !formEls[indexCampo].readOnly){
			continue;
		}
		if(((formEls[indexCampo].getAttribute("p_required") == "true") || (formEls[indexCampo].getAttribute("p_required") == true))&& (checkDisplay(formEls[indexCampo]))) {
			if (formEls[indexCampo].tagName == "selbind"){
				pblnRet = validateRequired(formEls[indexCampo /*+ 1*/]);
			}else{
				pblnRet = validateRequired(formEls[indexCampo]);
			}
			if (!(pblnRet)){
				break;
			}
		}
	}
	var firing=firingModalEvent;
	firingModalEvent=false;
	return (pblnRet && !firing);	
}
function checkDisplay(element){
//	if(MSIE){
//		return true;
//	}
	displayNone=true;
	if(!element.parentNode){
		return false;
	}
	
	var isExecution = false;	
	try{
		var wArea_iframe = window.parent.frames["workArea"];
		if(wArea_iframe == undefined || wArea_iframe == null) {
			wArea_iframe = window.parent.parent.frames["workArea"];
		}
		if(wArea_iframe == undefined || wArea_iframe == null) {
			if(window.parent.frames["frameContent2"].afterAutoSave != undefined &&		
					window.parent.frames["frameContent2"].btnExit_click != undefined)
			isExecution = true;
		} else {
			if(wArea_iframe.frames["frameContent2"].afterAutoSave != undefined &&		
					wArea_iframe.frames["frameContent2"].btnExit_click != undefined)
			isExecution = true;
		}
	} catch(e) {
		
		try {
			var wArea_iframe = window.parent.frames["workArea"];
			if(wArea_iframe == undefined || wArea_iframe == null) {
				wArea_iframe = window.parent.parent.frames["workArea"];
			}
			
			if(wArea_iframe == undefined || wArea_iframe == null) {				
				if(window.parent.frames["ifrAutoSave"].parent.btnExit_click != undefined)
					isExecution = true;
			} else {
				if(wArea_iframe.frames["ifrAutoSave"].parent.btnExit_click != undefined)
					isExecution = true;
			}
		} catch(e) {
			var wArea_iframe = window.parent.frames["workArea"];
			if(wArea_iframe == undefined || wArea_iframe == null) {
				wArea_iframe = window.parent.parent.frames["workArea"];
			}
			if(wArea_iframe == undefined || wArea_iframe == null) {
				var printForm = document.getElementById("printForm");
				if(printForm != undefined && printForm != null)
					isExecution = true; //Para manetenimiento de entidades
			} else {
				var printForm = wArea_iframe.document.getElementById("printForm");
				if(printForm != undefined && printForm != null)
					isExecution = true; //Para manetenimiento de entidades
			}
		}
	}
	
	while(element.parentNode && element.tagName!="FORM" && displayNone){
		if(element.parentNode.style && element.parentNode.style.display && element.parentNode.style.display=="none" && element.parentNode.getAttribute("type")!="tab"){
			if(!(element.tagName == "TABLE" && element.className == "tblFormLayout") || !isExecution)
				displayNone=false;
		}
		element=element.parentNode;
	}
	return displayNone;
}
function validateRequired(element) {
 
 	//validar si el elemento esta visible o si el form esta visible. en caso de estar oculto, se asume NO requerido
 	if(element.style.visiblility=="hidden"){
 		return true;
 	}
 	
 	var editor = false;

	if(element.getAttribute("isEditor") == "true"){
		editor = true;
		var editorId = element.nextSibling.id.substring(0,element.nextSibling.id.length-7);
		/*for(var i in tinyMCE.instances){
			if(tinyMCE.instances[i].editorId ==  editorId){
				if(tinyMCE.instances[i].getHTML()!=null && tinyMCE.instances[i].getHTML().length >0 && tinyMCE.instances[i].getHTML()!= ""){
					return true;
				}
			}
		}*/
		if(tinyMCE.getInstanceById(editorId).getContent().length>0){
			return true;
		}
	} else {
	 	if(element.style.display=="none"){
	 		return true;
	 	}
	}
 	if(element.getAttribute("parentFormId")){
 		var els=document.getElementsByName("hidFrm" + element.getAttribute("parentFormId") + "Hidden");
 		if(els.length>0 && els[0].value=="true"){
 			return true;
 		}
 	} 

	


	if (!editor && (element.value != null && element.value.length > 0) &&
		( (!element.mask) || ( element.value!=element.emptyMask ) ) ) {
		return true;
	} else {
	
	
	
	
		var pEl = element;

		
		 
		if(element.getAttribute("req_desc") != null && element.getAttribute("req_desc") != ""){
			pvntLabel = element.getAttribute("req_desc");	
		} else {
			while (pEl.tagName != "TD"){
				pEl = pEl.parentNode;
			}
			if(pEl.getAttribute("req_desc")!="" && pEl.getAttribute("req_desc")!=null){
				pvntLabel = pEl.getAttribute("req_desc");
			}else{
				var labelContainer=pEl.previousSibling;
				while(labelContainer.tagName != "TD"){
					labelContainer=labelContainer.previousSibling;
				}
				if (labelContainer.getElementsByTagName("U").length > 0) {
					//pvntLabel = labelContainer.getElementsByTagName("U")[0].innerHTML + labelContainer.childNodes[1].nodeValue;
					pvntLabel = labelContainer.getElementsByTagName("U")[0].innerHTML;
					if(labelContainer.childNodes[0].nodeName == "SPAN") {
						pvntLabel += labelContainer.childNodes[2].nodeValue;
					} else {
						pvntLabel += labelContainer.childNodes[1].nodeValue;
					}
				} else {
					if (labelContainer.getElementsByTagName("SPAN").length > 0) {
						var req_attribute = null;
						try{
							req_attribute = labelContainer.childNodes[1].getAttribute("required");
						} catch(error) {
							req_attribute = labelContainer.childNodes[1].required;
						}
						if(req_attribute == null || req_attribute == undefined)
							pvntLabel = labelContainer.childNodes[1].nodeValue;
						else
							pvntLabel = labelContainer.childNodes[0].nodeValue;
					} else {
						pvntLabel = labelContainer.innerHTML;
					}					
				}
			}
		}
		
		vLabel = replace(pvntLabel, ":","");
		vLabel = removeHTMLChars(vLabel);
		
		i = GNR_REQUIRED.indexOf("<TOK1>");
		if(MSIE){
			var tr=element.parentNode;
			while(tr.tagName!="TR" && tr.tagName!="BODY"){
				tr=tr.parentNode;
			}
			if(tr.name=="firstTr"){
				return true;
			}
		}
		
		alert(GNR_REQUIRED.substring(0,i)+ vLabel +GNR_REQUIRED.substring(i+6,GNR_REQUIRED.length));
		
		try {
			element.focus();
		} catch (e) {}

		return false;
	}
	
}

function isDate(valor,pvntEtiqueta){
	var arrIsDate = new Array;
 
	if(valor==""){
		arrIsDate[0] = true;
		return arrIsDate;
	}

	var sFormattedDate = strDateFormat;
	
	strDateFormat = strDateFormat.replace("/",GNR_DATE_SEPARATOR);
	strDateFormat = strDateFormat.replace("/",GNR_DATE_SEPARATOR);
	var arrPos = strDateFormat.split(GNR_DATE_SEPARATOR);
	
	var d 	= sFormattedDate.replace(/dd/, "##");
	var m 	= d.replace(/MM/, "##");
	var yy 	= m.replace(/yyyy/, "####");
	
	var sFormatMask = yy.replace("/",GNR_DATE_SEPARATOR);				
	sFormatMask = sFormatMask.replace("/",GNR_DATE_SEPARATOR);
	pblnMask = compare(valor,sFormatMask);
    
    	if (pblnMask) {
			arrValoresFecha = valor.split(GNR_DATE_SEPARATOR);		
			if(arrPos[0] == "dd"){
				pvntDia = arrValoresFecha[0];
			}
			if(arrPos[1] == "dd"){
				pvntDia = arrValoresFecha[1];
			}
			if(arrPos[2] == "dd"){
				pvntDia = arrValoresFecha[2];
			}
			if(arrPos[0] == "MM"){
				pvntMes = arrValoresFecha[0];
			}
			if(arrPos[1] == "MM"){
				pvntMes = arrValoresFecha[1];
			}
			if(arrPos[2] == "MM"){
				pvntMes = arrValoresFecha[2];
			}
			if(arrPos[0] == "yyyy"){
				pvntAnio = arrValoresFecha[0];
			}
			if(arrPos[1] == "yyyy"){
				pvntAnio = arrValoresFecha[1];
			}
			if(arrPos[2] == "yyyy"){
				pvntAnio = arrValoresFecha[2];
			}			
//			pvntDia = arrValoresFecha[0];
//			pvntMes = arrValoresFecha[1];
//			pvntAnio= arrValoresFecha[2]; 

			pblnBisiesto = isBisiesto(pvntAnio);	
			pblnIsDiaMes = isDiaMes(pvntDia,pvntMes,pblnBisiesto);				

			if (pvntDia == 0) {
				arrIsDate[0] = false;	
				arrIsDate[1] = GNR_TIE_00_DIA;
			} else if(pvntMes == 0) {
				arrIsDate[0] = false;	
				arrIsDate[1] = GNR_TIE_00_MES;
    		} else if(pvntAnio < 1800){
				arrIsDate[0] = false;	
				arrIsDate[1] = GNR_MIN_FCH;
			} else {
				if (pvntMes <= 12) {
					if (pblnIsDiaMes[0]==false){
						arrIsDate[0] = false;	
						arrIsDate[1] = pblnIsDiaMes[1];
					}else{
						arrIsDate[0] = true;
					}
				}else{
					arrIsDate[0] = false;	
					arrIsDate[1] = GNR_NO_EXI_MES;
				}
			}
				
		}else{
		
			arrIsDate[0] = false;
			arrIsDate[1] = GNR_FOR_FCH;
				
		}	 

	return (arrIsDate);
}

//-----------------------------------------------------------------


function isDiaMes(pvntDia,pvntMes,pblnBisiesto){

		var arrNombreMes = new Array;
		
		arrNombreMes[0] = GNR_JANUARY; //"enero"
		arrNombreMes[1] = GNR_FEBRUARY; //"febrero"
		arrNombreMes[2] = GNR_MARCH; //"marzo"
		arrNombreMes[3] = GNR_APRIL; //"abril"
		arrNombreMes[4] = GNR_MAY; //"mayo"
		arrNombreMes[5] = GNR_JUNE; //"junio"
		arrNombreMes[6] = GNR_JULY; //"julio"
		arrNombreMes[7] = GNR_AUGUST; //"agosto"
		arrNombreMes[8] = GNR_SEPTEMBER; //"setiembre"
		arrNombreMes[9] = GNR_OCTOBER; //"octubre"
		arrNombreMes[10] = GNR_NOVEMBER; //"noviembre"
		arrNombreMes[11] = GNR_DECEMBER; //"diciembre"
		
		var arrDiaMes = new Array;

		if ((pvntMes == 1) || (pvntMes == 3) ||(pvntMes == 5)
			|| (pvntMes == 7) || (pvntMes == 8) ||(pvntMes == 10)
				 || (pvntMes == 12)) {
			
				if 	(pvntDia >	31) {
					arrDiaMes[0] = false;				
					// O m?s de tem 
					arrDiaMes[1] = " " + GNR_EL_MES_DE + " " + arrNombreMes[pvntMes-1] + " " + GNR_TIE_31_DIA +  " ";	
				}else{
					arrDiaMes[0] = true;				
								
				}
		
		}
		else if ((pvntMes == 4) || (pvntMes == 6) || (pvntMes == 9) || (pvntMes == 11)){
			
			if 	(pvntDia >	30) {
				arrDiaMes[0] = false;				
				arrDiaMes[1] = " " + GNR_EL_MES_DE + " " + arrNombreMes[pvntMes-1] + " " + GNR_TIE_30_DIA +  " ";	
			}else{
				arrDiaMes[1] = true;				
			}
		
		}
		
		else if ((pvntMes == 2) && (pblnBisiesto)){
			
			if 	(pvntDia >	29) {
					arrDiaMes[0] = false;				
					arrDiaMes[1] = " " + GNR_EL_MES_DE + " " + arrNombreMes[pvntMes-1] + " " + GNR_TIE_29_DIA +  " ";		
				}else{
					arrDiaMes[1] = true;				
								
				}
		
		}
		
		
		else if ((pvntMes == 2) && (pblnBisiesto==false)){
				
				if 	(pvntDia >	28) {
					arrDiaMes[0] = false;				
					arrDiaMes[1] = " " + GNR_EL_MES_DE + " " + arrNombreMes[pvntMes-1] + " " + GNR_TIE_28_DIA +  " ";
				}else{
					arrDiaMes[1] = true;				
								
				}
		
		}

	
	return(arrDiaMes);	


}

//------------------------------------------------------------------
function isBisiesto(anio){
	if ((anio % 4)== 0){
		if (anio.substring(2,4) == "00"){
			if ((anio % 400)== 0){
				return(true);
			}else{
				return(false);
			}
		}else{
			return(true);
		}
	
	}else{
		return(false);
	}	
}

function compare(value, mask)
{
	// hace el matching de value contra la mascara
			
	var len_value = value.length;
	var len_mask = mask.length;
	
	if (len_value != len_mask)
		return(false);
		
	for (i = 0; i <= len_mask  ; i++) {
		car_value = value.substring(i,i+1);
		car_mask = mask.substring(i,i+1);

		if ((car_mask != "#") && (car_mask != "$")) {
			if (car_value != car_mask)
				return(false);
		} else {
			if (car_mask == "#") {
				if (isNumericBln(car_value) != true)
					return(false); 
			} else if (car_mask == "$") {
				if (car_value == "")
					return(false);
			}
		}
	}
		
	return(true);
}
function isNumericBln(valor){

	for (z=0; z < valor.length; z++) {
		caracter = valor.substr(z,1);
		if ((caracter != "0") && (caracter != "1") &&
			(caracter != "2") && (caracter != "3") &&
			(caracter != "4") && (caracter != "5") &&
			(caracter != "6") && (caracter != "7") &&
			(caracter != "8") && (caracter != "9")) {
				return(false);
		}
	}
	return(true);
}


function testRegExp(obj){
   var re = new RegExp(obj.getAttribute("sRegExp"));
   var str = obj.value;

   if(obj.emptyMask) {
	   if(obj.emptyMask == str) {
		   str = "";
	   } else if(obj.unMaskedText) {
		   str = obj.unMaskedText;
	   }
   }
   
   if (str != "") {
	   if (re.test(str) != true) {
		   	if(obj.getAttribute("regExpMessage") && obj.getAttribute("regExpMessage").length >0){
	 			alert(obj.getAttribute("regExpMessage"));
	   		}else{
			   	showMessageOneParam(GNR_REG_EXP_FAIL, getLabelApia(obj));
			}
		   	
		   	obj.value = "";
		   	if(obj.unMaskedText) {
		   		obj.unMaskedText = "";
		   	}
		   	obj.focus();
	   } 
  }
}

function testRegExpPassword(obj){
	var re = new RegExp(obj.getAttribute("sRegExp"));
	var str = obj.value;
 
	if (re.test(str) != true) {
		
		if(obj.getAttribute("regExpMessage") && obj.getAttribute("regExpMessage").length >0){
			var msg = obj.getAttribute("regExpMessage");
			alert(msg + "");
		}else{
			showMessageOneParam(GNR_REG_EXP_FAIL, getLabelApia(obj));
		}
		obj.value="";
		obj.focus();
		return false;
	} 
	return true;
}

function isValidDecimal(strValue)  {
  if (strValue == "")
  	return true;
  return objNumRegExp.test( strValue );
}

function isValidInteger( strValue ) {
  if (strValue == "")
  	return true;
 // var objRegExp  = /(^-?\d\d*$)/;
  //return objRegExp.test(strValue);
  
  var re = new RegExp("(^-?\d\d*$)");
	return strValue.match(re);
}


function showMessageOneParam(message, tok1) {
	i = message.indexOf("<TOK1>");
	alert(message.substring(0,i)+tok1+message.substring(i+6,message.length));
}

function showMessageTwoParam(message, tok1, tok2) {
	i = message.indexOf("<TOK1>");
	message = message.substring(0,i)+tok1+message.substring(i+6,message.length);
	i = message.indexOf("<TOK2>");
	message = message.substring(0,i)+tok2+message.substring(i+6,message.length);
	alert(message);
}

//----- Returns the object Label. ---------------------------//
/*function getLabelApia(obj){
	var pEl = obj;
	while (pEl.parentNode.tagName != "TD"){
		pEl = pEl.parentNode;
	}
	pvntLabel = pEl.parentNode.previousSibling.innerText;
	pvntLabel = removeHTMLChars(pvntLabel);
	return replace(pvntLabel, ":","");
}
*/
function getLabelApia(obj){
	var pEl = obj;
	var pvntLabel="";
	if(pEl.getAttribute("req_desc") != null && pEl.getAttribute("req_desc") != ""){
		pvntLabel = pEl.getAttribute("req_desc");	
	} else {
		while (pEl.parentNode.tagName != "TD"){
			pEl = pEl.parentNode;
		}
		pEl=pEl.parentNode;
		while(pEl.previousSibling.tagName != "TD"){
			pEl = pEl.previousSibling;
		}
		pvntLabel = pEl.previousSibling.innerHTML;
 	}
 	
	pvntLabel = removeHTMLChars(pvntLabel);
	return replace(pvntLabel, ":","");
}




function stringToDate(strValue) {
	var intDay = 0;
	var intMonth = 0;
  	if (strValue.substring(strDateFormat.indexOf("dd"),strDateFormat.indexOf("dd")+1) == "0"){
		intDay = parseInt(strValue.substring(strDateFormat.indexOf("dd")+1,strDateFormat.indexOf("dd")+2)); 
  	}else{
		intDay = parseInt(strValue.substring(strDateFormat.indexOf("dd"),strDateFormat.indexOf("dd")+2)); 
  	}
  	if (strValue.substring(strDateFormat.indexOf("MM"),strDateFormat.indexOf("MM")+1) == "0"){
		intMonth = parseInt(strValue.substring(strDateFormat.indexOf("MM")+1,strDateFormat.indexOf("MM")+2)); 
	}else{
	  	intMonth = parseInt(strValue.substring(strDateFormat.indexOf("MM"),strDateFormat.indexOf("MM")+2)); 
  	}
	var intYear = parseInt(strValue.substring(strDateFormat.indexOf("yyyy"),strDateFormat.indexOf("yyyy")+4));
	return new Date(intYear, intMonth, intDay);
}

function validateValues(){
	var elements=document.forms[0].getElementsByTagName("*");
	for(var i=0;i<elements.length;i++){
		if(elements[i].tagName=="INPUT" || elements[i].tagName=="SELECT" || elements[i].tagName=="TEXTAREA"){
			if(!validateValue(elements[i])){
				return false;
			}
		}
	}
	return true;
}

function validateValue(input){
	if(input.getAttribute("p_numeric")=="true"){
		if(!validateNumber(input)){
			return false;
		}
	}
	if(input.getAttribute("p_calendar") && input.emptyMask!=input.value && input.value!=""){
		valDate = isDate(input.value,"");
		if(valDate[0]==false){
			alert(valDate[1]);
			return false;
		}
	}
	return true;
}

function validateRequiredInGrid(gridId){
	var grid=document.getElementById(gridId);
	var trs=grid.rows;
	for(var i=1;i<trs.length;i++){
		var elements=trs[i].getElementsByTagName("*");
		for(var u=0;u<elements.length;u++){
			if(elements[u].tagName=="INPUT" || elements[u].tagName=="SELECT" || elements[u].tagName=="TEXTAREA" ){
				if(elements[u].getAttribute("p_required")!="true"){
					continue;
				}
				var pblnRet = validateRequired(elements[u]);
				if (!(pblnRet)){
					return pblnRet;
				}
			}
		}
	}
	return true;
}