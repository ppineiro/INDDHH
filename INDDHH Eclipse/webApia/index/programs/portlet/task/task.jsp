
<%@page import="java.util.Collection"%><%@page import="com.dogma.Configuration"%><%@page import="com.dogma.action.portlet.BasePortletAction"%><%@page import="com.dogma.bean.execution.ProInstanceBean"%><%@page import="com.dogma.bean.execution.EntInstanceBean"%><%@page import="com.dogma.bean.execution.InitTaskBean"%><%@page import="com.dogma.bean.execution.TaskBean"%><%@page import="com.dogma.vo.ProInstanceVo"%><%@page import="com.dogma.vo.ProcessVo"%><%@page import="com.dogma.vo.TaskVo"%><%@page import="com.dogma.vo.BusEntityVo"%><%@page import="com.dogma.vo.BusEntInstanceVo"%><%@page import="com.dogma.DogmaException"%><%@page import="com.dogma.EnvParameters"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.UserData"%><%@page import="com.st.util.StringUtil"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.st.util.translator.TranslationManager"%><%

TaskBean dBean = (TaskBean) request.getSession().getAttribute("apiaPortletBean");
boolean isFirstTask = dBean instanceof InitTaskBean;

BusEntInstanceVo beInstVo = dBean.getEntInstanceBean().getEntity();
BusEntityVo beVo = dBean.getEntInstanceBean().getEntityType();
Collection beRelCol = dBean.getEntInstanceBean().getEntityRelations();

TaskVo taskVo = dBean.getTaskVo();
ProcessVo proVo =  dBean.getProInstanceBean().getProcess();
ProInstanceVo proInstVo = dBean.getProInstanceBean().getProcInstance();

EntInstanceBean entityBean = dBean.getEntInstanceBean();
ProInstanceBean processBean = dBean.getProInstanceBean();

boolean fromUrl = false;
dBean.setHasFormsInStep(false);

UserData userData	= dBean.getUserData(request);
String labelSet		= userData.getStrLabelSetId();
Integer envId		= dBean.getEnvId(request);

String sessionId				= request.getSession().getId();
String apiaPortletActionTime	= (String) request.getSession().getAttribute("apiaPortletLastActionExecutedTime");
%><script language="javascript" type="text/javascript"></script><div class="apiaTitle"><b><%=LabelManager.getName(labelSet,"lblEjeNomPro")%>:</b><%=dBean.fmtHTML(TranslationManager.getProcTitle(proVo.getProName(), proVo.getProTitle(), userData.getEnvironmentId(), userData.getLangId()))%></div><form id="frmApia<%= sessionId %>" action="ProcessStartAction.portlet" method="post"><div class="apiaTab"><b><%=LabelManager.getName(labelSet,"tabEjeFor")%></b><jsp:include page="/programs/portlet/task/forms.jsp?frmParent=E"/></div><div class="apiaTab"><b><%=LabelManager.getName(labelSet,"tabEjeForPro")%></b><jsp:include page="/programs/portlet/task/forms.jsp?frmParent=P"/></div><div class="apiaContainer"><input type="hidden" id="actionTime<%= sessionId %>" name="apiaPortletActionTime" value="<%= apiaPortletActionTime %>"><% if (!isFirstTask) { %><input type="button" onclick="btnFree_click('<%= sessionId %>');" id="btnFree" value="<%=LabelManager.getName(labelSet,"btnEjeLib")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEjeLib")%>"><% if (taskVo.getFlagValue(TaskVo.POS_FLAG_DELEGATE) && proVo.getFlagValue(ProcessVo.FLAG_DELEGATE) && "true".equals(EnvParameters.getEnvParameter(dBean.getEnvId(request),EnvParameters.ENV_USES_HIERARCHY))) { %><input type="button" onclick="btnDelegate_click('<%= sessionId %>');"id="btnDelegate" value="<%=LabelManager.getName(labelSet,"lblExeDelegar")%>" title="<%=LabelManager.getToolTip(labelSet,"lblExeDelegar")%>"><% } %><input type="button" onclick="btnSave_click('<%= sessionId %>');"id="btnSave" value="<%=LabelManager.getName(labelSet,"btnGua")%>" title="<%=LabelManager.getToolTip(labelSet,"btnGua")%>"><% } 
		if (dBean.getCurrentStep().intValue() > 1) { %><input type="button" onclick="btnLast_click('<%= sessionId %>');"id="btnLast" value="<%=LabelManager.getName(labelSet,"btnAnt")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAnt")%>"><% }
		if (dBean.getStepQty().intValue() > dBean.getCurrentStep().intValue()) { %><input type="button" onclick="btnNext_click('<%= sessionId %>');"id="btnNext" value="<%=LabelManager.getName(labelSet,"btnSig")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSig")%>"><% } else { %><input type="button" onclick="btnConf_click('<%= sessionId %>');"id="btnConf" value="<%=LabelManager.getName(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><% } %></div></form><div class="apiaContainer"><a href="ProcessStartAction.portlet?<%= BasePortletAction.getInitialParamsUrl(request) %>">Volver al inicio</a></div><script language="javascript" type="text/javascript"><!--
var GNR_JANUARY		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_JANUARY))%>";
var GNR_FEBRUARY	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_FEBRUARY))%>";
var GNR_MARCH		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_MARCH))%>";
var GNR_APRIL		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_APRIL))%>";
var GNR_MAY			= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_MAY))%>";
var GNR_JUNE		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_JUNE))%>";
var GNR_JULY		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_JULY))%>";
var GNR_AUGUST		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_AUGUST))%>";
var GNR_SEPTEMBER	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_SEPTEMBER))%>";
var GNR_OCTOBER		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_OCTOBER))%>";
var GNR_NOVEMBER	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_NOVEMBER))%>";
var GNR_DECEMBER	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_DECEMBER))%>";
var GNR_MONDAY		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"lblLunes"))%>";
var GNR_TUESDAY  	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"lblMartes"))%>";
var GNR_WEDNESDAY	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"lblMiercoles"))%>";
var GNR_THURSDAY	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"lblJueves"))%>";
var GNR_FRIDAY		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"lblViernes"))%>";
var GNR_SATURDAY	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"lblSabado"))%>";
var GNR_SUNDAY		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"lblDomingo"))%>";

var GNR_NO_EXI_MES	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_NO_EXI_MES))%>";
var GNR_FOR_FCH		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_FOR_FCH))%>";
var GNR_MIN_FCH		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_MIN_FCH))%>";
var GNR_EL_MES_DE	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_EL_MES_DE))%>";
var GNR_TIE_28_DIA	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_TIE_28_DIA))%>";
var GNR_TIE_29_DIA	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_TIE_29_DIA))%>";
var GNR_TIE_30_DIA	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_TIE_30_DIA))%>";
var GNR_TIE_31_DIA	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_TIE_31_DIA))%>";
var GNR_TIE_00_DIA	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_TIE_00_DIA))%>";
var GNR_TIE_00_MES	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_TIE_00_MES))%>";


function btnFree_click(sessionId) {
	alert("solicitada liberación de tarea para session " + sessionId);
}

function btnDelegate_click(sessionId) {
	alert("solicitada delegación de tarea para session " + sessionId);
}

function btnSave_click(sessionId) {
	alert("solicitada salvación de tarea para session " + sessionId);
}

function btnLast_click(sessionId) {
	submitForm("lastStep",sessionId);
}

function btnNext_click(sessionId) {
	if (validateRequired(sessionId)) {
		submitForm("nextStep",sessionId);
	}
}

function btnConf_click(sessionId) {
	if (validateRequired(sessionId)) {
		submitForm("confirm",sessionId);
	}
}

function testRegExp(obj){
	var re = new RegExp(obj.getAttribute("sRegExp"));
	var str = obj.value;

	if (str != "") {
		if (re.test(str) != true) {
			if(obj.getAttribute("regExpMessage") && obj.getAttribute("regExpMessage").length >0){
				alert(obj.getAttribute("regExpMessage"));
  			} else {
	   			showMessageOneParam("<%= StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_REG_EXP_FAIL)) %>", getLabelApia(obj));
			}
			obj.value="";
			obj.focus();
		} 
	}
}

function showMessageOneParam(message, tok1) {
	i = message.indexOf("<TOK1>");
	alert(message.substring(0,i)+tok1+message.substring(i+6,message.length));
}

function validateNumber(obj) {
	var isNumber = false; 
	try { 
		isNumber = obj == '' || ! isNaN(parseInt(obj.value,10)); 
	} catch (e) {
	}

	if (! isNumber) { 
		var GNR_NUMERIC = " <%= StringUtil.replaceAll(LabelManager.getName(labelSet,DogmaException.GNR_NUMERIC),"\"","") %>"; 
		var i = GNR_NUMERIC.indexOf('<TOK1>');
		var text = obj.getAttribute("req_desc");
		if (text != null && text.indexOf(":") == (text.length - 1)) text = text.substring(0,text.length - 1); 
		alert(GNR_NUMERIC.substring(0,i) + text + GNR_NUMERIC.substring(i+6,GNR_NUMERIC.length)); 
		obj.value = ''; 
		return false;
	}

	return true;
}

function isDate(obj) {
	var GNR_DATE_SEPARATOR		= "<%=Parameters.DATE_SEPARATOR%>";
	var strDateFormat			= "<%=EnvParameters.getEnvParameter(envId,EnvParameters.FMT_DATE)%>";
	var arrIsDate = new Array;
 
	if(obj.value==""){
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
	pblnMask = compare(obj.value,sFormatMask);
    
    	if (pblnMask) {
			arrValoresFecha = obj.value.split(GNR_DATE_SEPARATOR);		
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

	if (! arrIsDate[0]) {
		alert(arrIsDate[1]);
		obj.value = "";
	}
    	
	return (arrIsDate);
}

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

	if ((pvntMes == 1) || (pvntMes == 3) ||(pvntMes == 5) || (pvntMes == 7) || (pvntMes == 8) ||(pvntMes == 10) || (pvntMes == 12)) {
		if 	(pvntDia >	31) {
			arrDiaMes[0] = false;				
			// O m?s de tem 
			arrDiaMes[1] = " " + GNR_EL_MES_DE + " " + arrNombreMes[pvntMes-1] + " " + GNR_TIE_31_DIA +  " ";	
		}else{
			arrDiaMes[0] = true;				
		}
	
	} else if ((pvntMes == 4) || (pvntMes == 6) || (pvntMes == 9) || (pvntMes == 11)){
		if 	(pvntDia >	30) {
			arrDiaMes[0] = false;				
			arrDiaMes[1] = " " + GNR_EL_MES_DE + " " + arrNombreMes[pvntMes-1] + " " + GNR_TIE_30_DIA +  " ";	
		} else {
			arrDiaMes[1] = true;				
		}
	
	} else if ((pvntMes == 2) && (pblnBisiesto)){
		if 	(pvntDia >	29) {
			arrDiaMes[0] = false;				
			arrDiaMes[1] = " " + GNR_EL_MES_DE + " " + arrNombreMes[pvntMes-1] + " " + GNR_TIE_29_DIA +  " ";		
		} else {
			arrDiaMes[1] = true;				
		}
	
	} else if ((pvntMes == 2) && (pblnBisiesto==false)){
		if 	(pvntDia >	28) {
			arrDiaMes[0] = false;				
			arrDiaMes[1] = " " + GNR_EL_MES_DE + " " + arrNombreMes[pvntMes-1] + " " + GNR_TIE_28_DIA +  " ";
		} else {
			arrDiaMes[1] = true;				
		}
	}
	return(arrDiaMes);	
}

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

function compare(value, mask) {
	/* hace el matching de value contra la mascara */
			
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

function validateRequiredObject(obj) {
	if (obj == null) return true;

	if (obj.tagName.toLowerCase() == "input" && obj.type.toLowerCase() == "text" && obj.value != "") return true;
	if (obj.tagName.toLowerCase() == "input" && obj.type.toLowerCase() == "hidden" && obj.value != "") return true;
	if (obj.tagName.toLowerCase() == "input" && obj.type.toLowerCase() == "password" && obj.value != "") return true;
	if (obj.tagName.toLowerCase() == "select" && obj.selectedIndex != null && obj.selectedIndex != -1 && obj.options.length > obj.selectedIndex && obj.options[obj.selectedIndex].value != "") return true;

	return false;
}

function validateRequired(sessionId) {
	var form = document.getElementById("frmApia" + sessionId);
	for (var i = 0; i < form.elements.length; i++) {
		var element = form.elements[i];
		var attRequired = element.getAttribute("p_required");
		if (attRequired != null && attRequired == "true") {
			if (! validateRequiredObject(element)) {
				var frmName = element.getAttribute("formname");
				if (frmName == null) frmName = "";
				if (frmName != "") frmName += ".";
				
				var attName = element.getAttribute("req_desc");
				if (attName.indexOf(":") == (attName.length - 1)) attName = attName.substring(0,attName.length - 1);
				alert("Required value for: " + frmName + attName);
				return false;
			}
		}
	}
	return true;
}

function submitForm(action,sessionId) {
	var form = document.getElementById("frmApia" + sessionId);

	if (action != null) {
		var paramName = "action";
		var inputHidden = document.getElementById(paramName + sessionId);
		if (inputHidden == null) { /* Crear el input hidden para poder enviar el valor */
			inputHidden = document.createElement("input");
			inputHidden.type = "hidden";
			inputHidden.name = paramName;

			form.appendChild(inputHidden);
		}
		inputHidden.value = action;
	}

	/* Scar todos los parámetros que hay de más en la url y colocarlos en inputs hidden. con el portlet bridge no se puede mezclar. */
	var formAction = form.getAttribute("action");

	if (formAction.indexOf("?") != -1) {
		var urlParams = formAction.substring(formAction.indexOf("?") + 1);
		form.setAttribute("action",formAction.substring(0,formAction.indexOf("?")));

		var params = urlParams.split("&");
		if (params != null) {
			for (var i = 0; i < params.length; i++) {
				var nameValue = params[i].split("=");
				var paramName = nameValue[0];
				var paramValue = nameValue[1];

				var inputHidden = document.getElementById(paramName + sessionId);
				if (inputHidden == null) { /* Crear el input hidden para poder enviar el valor */
					inputHidden = document.createElement("input");
					inputHidden.type = "hidden";
					inputHidden.name = paramName;

					form.appendChild(inputHidden);
				}
				
				inputHidden.value = paramValue;
			}
		}
	}

	form.submit();
}

</script><%
String strScript = (String)request.getAttribute("FORM_SCRIPTS");
if(strScript!=null){
	out.println(strScript);
}
%>
