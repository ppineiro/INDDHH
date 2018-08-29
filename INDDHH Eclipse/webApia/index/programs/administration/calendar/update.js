
window.onload=function() {

}

function ableHour(obj){
 var selIni = document.getElementById("hoursIniSelected").value;
 var selEnd = document.getElementById("hoursEndSelected").value;
 var i = obj.value-1;
 if (obj.checked == true){
     obj.parentNode.nextSibling.disabled=false;
     obj.parentNode.nextSibling.nextSibling.nextSibling.disabled=false;
     var selects=obj.parentNode.parentNode.getElementsByTagName("SELECT");
	 selects[0].disabled=false;
	 selects[1].disabled=false;
 }else {
	 var newSelIni = selIni.substring(0,i) + "0" + selIni.substring(i+1,selIni.length);
	 var newSelEnd = selEnd.substring(0,i) + "0" + selEnd.substring(i+1,selEnd.length);
     document.getElementById("hoursIniSelected").value = newSelIni;
     document.getElementById("hoursEndSelected").value = newSelEnd;
	 obj.parentNode.nextSibling.disabled=true;
	 obj.parentNode.nextSibling.nextSibling.nextSibling.disabled=true;
	 var selects=obj.parentNode.parentNode.getElementsByTagName("SELECT");
	 selects[0].disabled=true;
	 selects[0].selectedIndex = 0;
	 selects[1].disabled=true;
	 selects[1].selectedIndex = 0;
 }
}

function changeIniOthers(pos){
	var hourIni =document.getElementById("selHourIniId"+pos).options[document.getElementById("selHourIniId"+pos).selectedIndex].value;
	var sel = document.getElementById("hoursIniSelected").value;
	if (pos == 1){
		sel = "1" + sel.substring(1,sel.length);
	} else{
		sel = sel.substring(0,pos-1) + "1" + sel.substring(pos,sel.length);
	}
	document.getElementById("hoursIniSelected").value = sel;
	for(i=1;i<8;i++){
	 	if (i!=pos && sel.charAt(i-1)== "0" && (document.getElementById("selHourIniId"+i).parentNode.parentNode.getElementsByTagName("INPUT")[0].checked == true)){
	 		document.getElementById("selHourIniId"+i).selectedIndex = hourIni-1;
	 		if (i == 1){
				sel = "1" + sel.substring(1,sel.length);
			} else{
				sel = sel.substring(0,i-1) + "1" + sel.substring(i,sel.length);
			}
			document.getElementById("hoursIniSelected").value = sel;
	 	}
	}
}

function changeEndOthers(pos){
	var hourEnd =document.getElementById("selHourEndId"+pos).options[document.getElementById("selHourEndId"+pos).selectedIndex].value;
	var sel = document.getElementById("hoursEndSelected").value;
	if (pos == 1){
		sel = "1" + sel.substring(1,sel.length);
	} else{
		sel = sel.substring(0,pos-1) + "1" + sel.substring(pos,sel.length);
	}
	document.getElementById("hoursEndSelected").value = sel;
	for(i=1;i<8;i++){
	 	if (i!=pos && sel.charAt(i-1)== "0" && (document.getElementById("selHourEndId"+i).parentNode.parentNode.getElementsByTagName("INPUT")[0].checked == true)){
	 		document.getElementById("selHourEndId"+i).selectedIndex = hourEnd-1;
	 		if (i == 1){
				sel = "1" + sel.substring(1,sel.length);
			} else{
				sel = sel.substring(0,i-1) + "1" + sel.substring(i,sel.length);
			}
			document.getElementById("hoursEndSelected").value = sel;
	 	}
	}
}

function btnConf_click() {
	if (verifyRequiredObjects()){
		if(isValidName(document.getElementById("txtName").value)){
			var result = checkHor();
			if (result == 0){
				if (checkLaboralDays() == true){
					fillHiddenInput();
					document.getElementById("frmMain").action = "administration.CalendarAction.do?action=confirm";
					submitForm(document.getElementById("frmMain"));
				} else {
					alert(MSG_MUST_SEL_DAY);
				}
			} else {
				switch (result){
					case 1: alert(MSG_WRNG_INTERVAL + ": " + MSG_SUN); break;
					case 2: alert(MSG_WRNG_INTERVAL + ": " + MSG_MON); break;
					case 3: alert(MSG_WRNG_INTERVAL + ": " + MSG_TUE); break;
					case 4: alert(MSG_WRNG_INTERVAL + ": " + MSG_WED); break;
					case 5: alert(MSG_WRNG_INTERVAL + ": " + MSG_THU); break;
					case 6: alert(MSG_WRNG_INTERVAL + ": " + MSG_FRI); break;
					case 7: alert(MSG_WRNG_INTERVAL + ": " + MSG_SAT);
				}		
			}
		}
	}
}

function btnBack_click() {
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		document.getElementById("frmMain").action = "administration.CalendarAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnExit_click(){
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {	
		splash();
	}
}

function addHoliday_click(){
	var date=document.getElementById("txtFch").value;
	var oOpt = document.createElement("OPTION");
	oOpt.innerHTML = date;
	oOpt.value = date;
	if(notIn(date) && !(date==(document.getElementById("txtFch").emptyMask))){
		document.getElementById("txtHolidays").appendChild(oOpt);
		if (inHiddenInput(date)==false){
			if ("" == document.getElementById("hidDateAllYear").value){
				document.getElementById("hidDateAllYear").value = date;
			}else{
				document.getElementById("hidDateAllYear").value = document.getElementById("hidDateAllYear").value + ";" + date;
			}
		}
	}
}

function fillHiddenInput(){
	var holidays = "";
	if (document.getElementById("txtHolidays").options.length > 0) {
		holidays = document.getElementById("txtHolidays").options[0].text;
		for (var i=1; i<document.getElementById("txtHolidays").options.length; i++){
			holidays = holidays + "-" + document.getElementById("txtHolidays").options[i].text;
		}
		document.getElementById("hidHolidays").value = holidays;
	}
}

function delHoliday_click(){
	if (document.getElementById("txtHolidays").selectedIndex >= 0){
		var opt=document.getElementById("txtHolidays").options[document.getElementById("txtHolidays").selectedIndex];
		if(opt){
			opt.parentNode.removeChild(opt);
		}
	}
}

function notIn(value){
	var notIn=true;
	var arrPos1 = value.split(GNR_DATE_SEPARATOR);
	for(var i=0;i<document.getElementById("txtHolidays").options.length;i++){
		var arrPos2 = (document.getElementById("txtHolidays").options[i].text).split(GNR_DATE_SEPARATOR);
		if((arrPos1[0] == arrPos2[0]) && (arrPos1[1] == arrPos2[1]) && (arrPos1[2] == arrPos2[2])){
			return false;
		}
	}
	return notIn;
}

function inHiddenInput(date){
	var arrDate = date.split(GNR_DATE_SEPARATOR);
	if (arrDate.length<3){
		return true; //retorno true asi no se agrega
	}
	
	var strDates = document.getElementById("hidDateAllYear").value;
	var posSep = strDates.indexOf(";");
	while (posSep > 0){
		var actDate = strDates.substring(0,posSep);
		if (date == actDate.substring(0,5)){
			return true;
		}
		strDates = strDates.substring(posSep + 1, strDates.length);
		posSep = strDates.indexOf(";");			
	}
	if (date == strDates){
		return true;
	}
	return false;
}

function checkLaboralDays(){
 	for (var i=1;i<8;i++){
 		if (document.getElementById("chkLabDays"+i).checked==true){
			return true;
		}
	}
	return false;
}

function checkHor(){

	for(i=1;i<8;i++){
 		if (document.getElementById("chkLabDays"+i).checked == true){
 			var end = document.getElementById("selHourEndId"+i).value;
 			var ini = document.getElementById("selHourIniId"+i).value;
 			if (parseInt(end) <= parseInt(ini)){
				return i;
			} 
		}
 	}
 	return 0;
}

function allYears(){
	for(var i=0;i<document.getElementById("txtHolidays").options.length;i++){
		if (document.getElementById("txtHolidays").options[i].selected){
			allYearFnc(i);	
		}
	}
}

function allYearFnc(selDayId){
	if (selDayId >= 0){
		var selDay = document.getElementById("txtHolidays").options[selDayId].text;
		var formatDay = getFormat(selDay);
		inHiddenInput(selDay);
		if (selDay.length == 10){ //se selecciono una fecha con año: 01/05/2009 y ese dia/mes ya no esta
			if (formatDay == "xx/xx/yyyy"){
				if (notIn(selDay.substring(0,5))){
					document.getElementById("txtHolidays").options[selDayId].text = selDay.substring(0,5);
				}else{
					var cmb=document.getElementById("txtHolidays");
					var opt=cmb.options[selDayId];
					cmb.removeChild(opt);
				}
			}else if (formatDay == "yyyy/xx/xx"){
				if (notIn(selDay.substring(5,10))){
					document.getElementById("txtHolidays").options[selDayId].text = selDay.substring(5,10);
				}else{
					var cmb=document.getElementById("txtHolidays");
					var opt=cmb.options[selDayId];
					cmb.removeChild(opt);
				}
			}else if (formatDay == "xx/yyyy/xx"){
				if (notIn(selDay.substring(0,3) + selDay.substring(8,10))){
					document.getElementById("txtHolidays").options[selDayId].text = selDay.substring(0,3) + selDay.substring(8,10);
				}else{
					var cmb=document.getElementById("txtHolidays");
					var opt=cmb.options[selDayId];
					cmb.removeChild(opt);
				}
			}
		}else if (selDay.length == 5){ //se selecciono una fecha sin año: 01/05
			//Recuperamos la fecha con año del input oculto
			var strDates = document.getElementById("hidDateAllYear").value;
			var posSep = strDates.indexOf(";");
			while (posSep > 0){
				var actDate = strDates.substring(0,posSep);
				if (selDay == actDate.substring(0,5)){
					document.getElementById("txtHolidays").options[selDayId].text = actDate;
					return;
				}
				strDates = strDates.substring(posSep + 1, strDates.length);
				posSep = strDates.indexOf(";");			
			}
			var actDate = strDates;
			if (selDay == actDate.substring(0,5)){
				document.getElementById("txtHolidays").options[selDayId].text = actDate;
				return;
			}
			//si llego aquí es pq no se encontro --> le concatenamos el año actual
			var thisYear = 1900 + new Date().getYear();
			if (formatDay == "xx/xx/yyyy"){
				document.getElementById("txtHolidays").options[selDayId].text = selDay + "/" + thisYear;
			}else if (formatDay == "yyyy/xx/xx"){
				document.getElementById("txtHolidays").options[selDayId].text = thisYear + "/" + selDay;
			}else if (formatDay == "xx/yyyy/xx"){
				document.getElementById("txtHolidays").options[selDayId].text = selDay.substring(0,3) + thisYear + selDay.substring(7,10);
			}
		}
	}
}

function getFormat(selDay){
	if (selDay.length == 10){
		if (selDay.charAt(2) == '/' && selDay.charAt(5) == '/'){ //formato xx/xx/yyyy
			return "xx/xx/yyyy";
		}else if (selDay.charAt(4) == '/' && selDay.charAt(7) == '/'){ //formato yyyy/xx/xx
			return "yyyy/xx/xx";
		}else if (selDay.charAt(2) == '/' && selDay.charAt(7) == '/'){ // formato xx/yyyy/xx
			return "xx/yyyy/xx";
		}
	}else{
		var selDay = document.getElementById("txtFch").getAttribute("p_mask");
		if (selDay.charAt(3) == '/' && selDay.charAt(8) == '/'){ //formato nn'/'nn'/'nnnn
			return "xx/xx/yyyy";
		}else if (selDay.charAt(5) == '/' && selDay.charAt(10) == '/'){ //formato nnnn'/'nn'/'nn
			return "yyyy/xx/xx";
		}else if (selDay.charAt(3) == '/' && selDay.charAt(19) == '/'){ // formato nn'/'nnnn'/'nn
			return "xx/yyyy/xx";
		}
	}
}