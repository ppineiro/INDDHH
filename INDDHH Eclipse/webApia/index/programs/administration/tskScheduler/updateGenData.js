function btnViewCalendar() {
    calId = document.getElementById("selCal").value;
	if (calId != 0){
		openModal("/programs/modals/calendarView.jsp?calendarId="+calId,600,500);
	}
}

function setNumericFields(){
	setNumericField(document.getElementById("txtActPrev"));
	setNumericField(document.getElementById("txtOvrAsign"));
	setNumericField(document.getElementById("txtXMonth"));
	
	setBrwsReadOnly(document.getElementById("txtWeekSel"))
}

function btnPrevWeek(){
	window.parent.document.getElementById("iframeMessages").showWaitMsg();
	window.parent.document.getElementById("iframeMessages").style.display="block";
	setTimeout(function(){buildGrid("prev");},100);
	document.getElementById("selTemplate").selectedIndex = 0;
}
function btnNextWeek(){
	window.parent.document.getElementById("iframeMessages").showWaitMsg();	
	window.parent.document.getElementById("iframeMessages").style.display="block";
	setTimeout(function(){buildGrid("next");},100);
	document.getElementById("selTemplate").selectedIndex = 0;
}
function reloadGrid(){
	if (document.getElementById("txtOthFracc").value > 0 || document.getElementById("selFracc").value > 0){
		window.parent.document.getElementById("iframeMessages").showWaitMsg();
		window.parent.document.getElementById("iframeMessages").style.display="block";
		setTimeout(function(){buildGrid("refresh");},100);
	}
}

var afterAction=function(){}

function buildGrid(action){
	submitGrid(); //Hacemos submit de la semana actual para no perder los datos (hacemos submit pq son muchos datos para pasar como parametro)
	afterAction=function(){
		var monday = document.getElementById("txtWeekSel").value;
		var ovrAsgn = document.getElementById("txtOvrAsign").value;
		if (monday != null){
			var sXMLSourceUrl = "administration.TaskSchedulerAction.do?action=getGridHTML&fracc=" + document.getElementById("txtHidFracc").value + "&calId=" + document.getElementById("selCal").value + "&monday=" + monday + "&act=" + action + "&ovrAsgn=" + ovrAsgn;
			var xmlLoad=new xmlLoader();
			xmlLoad.onload=function(xml){
				//if (isXMLOk(xml)) {
					var text=this.textLoaded;
					if(text.indexOf("error")>=0){//<error>lalalala</error>
						document.getElementById("gridTsk").innerHTML = "";
						window.parent.document.getElementById("iframeMessages").style.display="none";
						alert(xml.firstChild.nodeValue);
						return;
					}else{
						//1. Generamos la grilla
						document.getElementById("gridTsk").innerHTML=this.textLoaded;
						//2. Cambiamos el lunes actual
						document.getElementById("txtWeekSel").value = document.getElementById("gridTsk").getElementsByTagName("TABLE")[0].getAttribute("thisMonday");
						//3. Seteamos en habilitado/deshabilitado el combo de subdivision horaria
						if ("true"==document.getElementById("gridTsk").getElementsByTagName("TABLE")[0].getAttribute("hasSettings")){
							document.getElementById("selFracc").disabled = true;
						}else{
							document.getElementById("selFracc").disabled = false;
						}
						//4. Seteamos la subdivision horaria
						selFraccTime(document.getElementById("gridTsk").getElementsByTagName("TABLE")[0].getAttribute("fracc"));
						//5. Seteamos la sobreasignación
						document.getElementById("txtOvrAsign").value = document.getElementById("gridTsk").getElementsByTagName("TABLE")[0].getAttribute("ovrAsgn");
						if(!isConfirming){
							window.parent.document.getElementById("iframeMessages").style.display="none";
						}
						enableDisableFrecc();
					}
				//}
			}
			xmlLoad.load(sXMLSourceUrl);
		}
	}
}

function submitGrid(){
	var frm=document.getElementById("frmMain");
	var action=frm.action;
	var target=frm.target;
	frm.action="administration.TaskSchedulerAction.do?action=saveGrid&txtWeekSel="+document.getElementById("txtWeekSel").value;
	frm.target="gridSubmit";
	frm.submit();
	frm.action=action;
	frm.target=target;
}

//Habilita o deshabilita el input para ingresar cantidad de meses
function clickOnRad(optSel){
	document.getElementById("txtOptSelected").value = optSel;
	if (optSel == "xMonth"){
		document.getElementById("txtXMonth").disabled = false;
	}else{
		document.getElementById("txtXMonth").disabled = true;
		document.getElementById("txtXMonth").value = "";
	}
	
}	

//Habilita o deshablilita el combo de frecuencias
function enableDisableFrecc(){
	var fracc = document.getElementById("txtHidFracc").value;
	var actHor = 0;
//	Recorremos todos los inputs de la agenda dia x dia, y si hay uno que sea distinto de 0 se deshabilita.
	while (actHor < 2400){
		var actMin = 0;
		while (actMin < 60){
			var hora = parseInt(actHor)  + parseInt(actMin);
			var key = null;
			if (document.getElementById("txtSch1_" + hora)!=null && "0" != document.getElementById("txtSch1_" + hora).value && "" != document.getElementById("txtSch1_" + hora).value){
				document.getElementById("selFracc").disabled = true;
				document.getElementById("txtOthFracc").disabled = true;
				//alert("txtSch1_" + hora + ":" + document.getElementById("txtSch1_" + hora).value);
				return;
			}
			if (document.getElementById("txtSch2_" + hora)!=null && "0" != document.getElementById("txtSch2_" + hora).value && "" != document.getElementById("txtSch2_" + hora).value){
				document.getElementById("selFracc").disabled = true;	
				document.getElementById("txtOthFracc").disabled = true;		
				//alert("txtSch2_" + hora + ":" + document.getElementById("txtSch2_" + hora).value);	
				return;
			}
			if (document.getElementById("txtSch3_" + hora)!=null && "0" != document.getElementById("txtSch3_" + hora).value && "" != document.getElementById("txtSch3_" + hora).value){
				document.getElementById("selFracc").disabled = true;
				document.getElementById("txtOthFracc").disabled = true;
				//alert("txtSch3_" + hora + ":" + document.getElementById("txtSch3_" + hora).value);
				return;
			}
			if (document.getElementById("txtSch4_" + hora)!=null && "0" != document.getElementById("txtSch4_" + hora).value && "" != document.getElementById("txtSch4_" + hora).value){
				document.getElementById("selFracc").disabled = true;	
				document.getElementById("txtOthFracc").disabled = true;		
				//alert("txtSch4_" + hora + ":" + document.getElementById("txtSch4_" + hora).value);	
				return;
			}
			if (document.getElementById("txtSch5_" + hora)!=null && "0" != document.getElementById("txtSch5_" + hora).value && "" != document.getElementById("txtSch5_" + hora).value){
				document.getElementById("selFracc").disabled = true;	
				document.getElementById("txtOthFracc").disabled = true;		
				//alert("txtSch5_" + hora + ":" + document.getElementById("txtSch5_" + hora).value);	
				return;
			}
			if (document.getElementById("txtSch6_" + hora)!=null && "0" != document.getElementById("txtSch6_" + hora).value && "" != document.getElementById("txtSch6_" + hora).value){
				document.getElementById("selFracc").disabled = true;	
				document.getElementById("txtOthFracc").disabled = true;	
				//alert("txtSch6_" + hora + ":" + document.getElementById("txtSch6_" + hora).value);
				return;
			}
			if (document.getElementById("txtSch7_" + hora)!=null && "0" != document.getElementById("txtSch7_" + hora).value && "" != document.getElementById("txtSch7_" + hora).value){
				document.getElementById("selFracc").disabled = true;	
				document.getElementById("txtOthFracc").disabled = true;		
				//alert("txtSch7_" + hora + ":" + document.getElementById("txtSch7_" + hora).value);	
				return;
			}
			actMin = parseInt(actMin) + parseInt(fracc);
		}
		actHor = parseInt(actHor) + 100;
	}
	
	selFraccTime(fracc);
	//document.getElementById("txtOthFracc").disabled = true;	
	document.getElementById("selFracc").disabled = false;
}

function existsTemplateName(templateName){
	var cmbTemplates = document.getElementById("selTemplate");
	for (i = 0; i < cmbTemplates.options.length; i++) {
		if (cmbTemplates.options[i].label == templateName || cmbTemplates.options[i].innerText==templateName) {
			return true;
		}
	}
	return false;
}

//Guarda el template actual
function btnSaveTemplate(){
	//1. Nos fijamos si ya no existe
	if (existsTemplateName(document.getElementById("txtTemplate").value)){
		alert(MSG_TEMP_ALR_EXISTS);
		document.getElementById("txtTemplate").value = "";
		return;
	}
	window.parent.document.getElementById("iframeMessages").showWaitMsg();	
	window.parent.document.getElementById("iframeMessages").style.display="block";
	setTimeout(function(){saveTemplate();},100);
}

function saveTemplate(){
	var frm=document.getElementById("frmMain");
	var action=frm.action;
	var target=frm.target;
	frm.action="administration.TaskSchedulerAction.do?action=saveTemplate&msgComplete=" + MSG_TEMPLATE_SAVED;
	frm.target="gridSubmit";
	frm.submit();
	frm.action=action;
	frm.target=target;
}

function btnRemTemplate_click(){
	var tempId = document.getElementById("selTemplate").value;
	if (tempId==0){
		alert(MSG_MST_SEL_TEM_TO_ERASE);
		return;
	}
	var msg = confirm(MSG_DEL_SEL_TEMPLATE);
	if (msg) {
		deleteTemplate(tempId);
	}
}

function deleteTemplate(tempId){
	var sXMLSourceUrl = "administration.TaskSchedulerAction.do?action=deleteTemplate&tempId=" + tempId;
	var xmlLoad=new xmlLoader();
	xmlLoad.onload=function(xml){
		//borramos el template del combo
		var cmbTemplates = document.getElementById("selTemplate");
		for (i = 0; i < cmbTemplates.options.length; i++) {
			if (cmbTemplates.options[i].value == tempId) {
				cmbTemplates.removeChild(cmbTemplates.options[i]);
				return;
			}
		}
	}
	xmlLoad.load(sXMLSourceUrl);
}

function selTemplateChange(){
	var tempId = document.getElementById("selTemplate").value;
	if (tempId != 0){
		var msg = confirm(MSG_LOAD_TEMPLATE);
		if (msg){
			loadTemplate(tempId);
		}
	}
}

function loadTemplate(tempId){
	var sXMLSourceUrl = "administration.TaskSchedulerAction.do?action=loadTemplate&tempId=" + tempId + "&calId=" + document.getElementById("selCal").value + "&txtWeekSel=" + document.getElementById("txtWeekSel").value;
	var xmlLoad=new xmlLoader();
	xmlLoad.onload=function(xml){
		//1. Generamos la grilla
		document.getElementById("gridTsk").innerHTML=this.textLoaded;
		//2. Seteamos la subdivision horaria
		selFraccTime(document.getElementById("gridTsk").getElementsByTagName("TABLE")[0].getAttribute("fracc"));
		//3. Seteamos en deshabilitado el combo de subdivision horaria
		document.getElementById("selFracc").disabled = true;
		document.getElementById("txtOthFracc").disabled = true;
	}
	xmlLoad.load(sXMLSourceUrl);
}

//Seleccionamos la subdivision horaria pasada por parametro
function selFraccTime(fracc){
	document.getElementById("txtHidFracc").value = fracc;
	var cmbFracc = document.getElementById("selFracc");
	var found = false;
	for (i = 0; i < cmbFracc.options.length; i++) {
		if (cmbFracc.options[i].value == fracc) {
			cmbFracc.selectedIndex = i;
			found = true;
			document.getElementById("txtOthFracc").value = "";
			return;
		}
	}
	
	//Si llego aqui no se encontro --> es otro valor
	cmbFracc.selectedIndex = cmbFracc.options.length-1;
	document.getElementById("txtOthFracc").disabled = false;
	document.getElementById("txtOthFracc").value = fracc;
}

function changeFraccCmb(){
	var oldFracc = document.getElementById("txtHidFracc").value;
	var fracc = document.getElementById("selFracc").value;
	if (oldFracc == fracc){
		return;
	}
	if (fracc == -1){
		fracc = 30;
		selFraccTime(fracc);
	}else if (fracc == 0){ //Selecciono otro
		fracc = oldFracc; //por ahora dejamos en el input oculto el valor anterior
	}
	document.getElementById("txtHidFracc").value = fracc;
	if (document.getElementById("selFracc").value == 0){
		document.getElementById("txtOthFracc").disabled = false;
	}else{
		document.getElementById("txtOthFracc").disabled = true;
		document.getElementById("txtOthFracc").value = "";
	}
}

//Verifica si el valor pasado por parametro esta en el combo pasado por parametro
function getIndexCombo(combo, value){
	var found = false;
	for (i = 0; i < combo.options.length; i++) {
		if (combo.options[i].value == value) {
			return i;
		}
	}
	return -1;
}

function changeFraccInput(){
	document.getElementById("txtHidFracc").value = document.getElementById("txtOthFracc").value;
	if (document.getElementById("txtHidFracc").value > 0){
		reloadGrid();
	}
}

function btnDoAction(){
	var msg = "";
	if (document.getElementById("txtOptSelected").value == "allMonth"){
		msg = confirm(MSG_SAVE_FOR_ALL_MONTH);
	}else if (document.getElementById("txtOptSelected").value == "allYear"){
		msg = confirm(MSG_SAVE_FOR_ALL_YEAR);
	}else if (document.getElementById("txtOptSelected").value == "xMonth"){
		if (document.getElementById("txtXMonth").value==""){
			alert(MSG_X_MONTH_MISSING);
			return;
		}else {
			var lbl = MSG_SAVE_FOR_X_MONTH.replace("<TOK1>", document.getElementById("txtXMonth").value);
			msg = confirm(lbl);
		}
	}
	if (msg){
		window.parent.document.getElementById("iframeMessages").showWaitMsg();
		window.parent.document.getElementById("iframeMessages").style.display="block";
		setTimeout(function(){applyActualWeek(document.getElementById("txtOptSelected").value);},100);
	}
}

function applyActualWeek(applyFor){
	var frm=document.getElementById("frmMain");
	var action=frm.action;
	var target=frm.target;
	frm.action="administration.TaskSchedulerAction.do?action=applyWeek&applyFor=" + applyFor + "&calId=" + document.getElementById("selCal").value + "&txtWeekSel=" + document.getElementById("txtWeekSel").value;
	frm.target="gridSubmit";
	frm.submit();
	frm.action=action;
	frm.target=target;
	
	document.getElementById("txtXMonth").value = "";
}

function showMessageComplete(){
	window.parent.document.getElementById("iframeMessages").style.display="none";
	alert(MSG_OP_OK);
}

function btnRemActualWeek_click(){
	var msg = confirm(MSG_DEL_ACTUAL_SCHED);
	if (msg){
		var sXMLSourceUrl = "administration.TaskSchedulerAction.do?action=deleteActualWeek&fracc=" + document.getElementById("txtHidFracc").value + "&calId=" + document.getElementById("selCal").value + "&monday=" + document.getElementById("txtWeekSel").value;
		var xmlLoad=new xmlLoader();
		xmlLoad.onload=function(xml){
			//1. Generamos la grilla vacia
			document.getElementById("gridTsk").innerHTML=this.textLoaded;
			//2. Seteamos en habilitado el combo de subdivision horaria
			document.getElementById("selFracc").disabled = false;
			if (document.getElementById("selFracc").value <= 0){
				//3. Seteamos en deshabilitado el input de subdivision horaria
				document.getElementById("txtOthFracc").disabled = false;
				//document.getElementById("txtOthFracc").value = "";
			}else{
				document.getElementById("txtOthFracc").value = "";
				document.getElementById("txtOthFracc").disabled = true;
			}
		}
		xmlLoad.load(sXMLSourceUrl);
	}
}

function addExclusionDay_click(){
	var date=document.getElementById("txtFch").value;
	var oOpt = document.createElement("OPTION");
	oOpt.innerHTML = date;
	oOpt.value = date;
	if(notIn(date) && !(date==(document.getElementById("txtFch").emptyMask))){
		document.getElementById("txtExcDays").appendChild(oOpt);
	}
}

function delExclusionDay_click(){
	if (document.getElementById("txtExcDays").selectedIndex >= 0){
		var opt=document.getElementById("txtExcDays").options[document.getElementById("txtExcDays").selectedIndex];
		if(opt){
			opt.parentNode.removeChild(opt);
		}
	}
}

function notIn(value){
	var notIn=true;
	var arrPos1 = value.split(GNR_DATE_SEPARATOR);
	for(var i=0;i<document.getElementById("txtExcDays").options.length;i++){
		var arrPos2 = (document.getElementById("txtExcDays").options[i].text).split(GNR_DATE_SEPARATOR);
		if((arrPos1[0] == arrPos2[0]) && (arrPos1[1] == arrPos2[1]) && (arrPos1[2] == arrPos2[2])){
			return false;
		}
	}
	return notIn;
}

function fillHiddenInput(){
	var excDays = "";
	if (document.getElementById("txtExcDays").options.length > 0) {
		excDays = document.getElementById("txtExcDays").options[0].text;
		for (var i=1; i<document.getElementById("txtExcDays").options.length; i++){
			excDays = excDays + "-" + document.getElementById("txtExcDays").options[i].text;
		}
		document.getElementById("hidExcDays").value = excDays;
	}
}

function checkModActPrev(oldValue){
	var msg = confirm(MSG_ACT_PREV_WARNING);
	if (!msg){
		document.getElementById("txtActPrev").value = oldValue;
	}
}
