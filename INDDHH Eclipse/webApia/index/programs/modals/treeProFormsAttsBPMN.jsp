<%@page import="com.dogma.vo.*"%><%@page import="com.st.util.XMLUtils"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body onload="loadAtts()"><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.BPMNBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titVwProAttsAsoc")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><table id="treeTable"><tr><td nowrap="" valign="top"><ul><li class="clsFolder" title="<%=LabelManager.getToolTip(labelSet,"sbtDatPro")%>"><IMG onclick="doLIAction(this, 'processData')" SRC="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/closed.gif"/><span><%=LabelManager.getName(labelSet,"sbtDatPro")%></span><input type="hidden" name="hidObjId" value="1"></input></li><li class="clsFolder" title="<%=LabelManager.getToolTip(labelSet,"sbtDatEntAsocProc")%>"><IMG onclick="doLIAction(this, 'entityProAtts')" SRC="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/closed.gif"/><span><%=LabelManager.getName(labelSet,"sbtDatEntAsocProc")%></span><input type="hidden" name="hidObjId" value="2"></input></li><li class="clsFolder" title="<%=LabelManager.getToolTip(labelSet,"sbtRedDatPro")%>"><IMG onclick="doLIAction(this, 'proRedAtts')" SRC="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/closed.gif"/><span><%=LabelManager.getName(labelSet,"sbtRedDatPro")%></span><input type="hidden" name="hidObjId" value="3"></input></li><li class="clsFolder" title="<%=LabelManager.getToolTip(labelSet,"sbtTskFrmDatPro")%>"><IMG onclick="doLIAction(this, 'processTasks')" SRC="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/closed.gif"/><span><%=LabelManager.getName(labelSet,"sbtTskFrmDatPro")%></span><% if (dBean.getProcessVo()!=null && dBean.getProcessVo().getProId()!=null){ %><input type="hidden" name="hidObjId" value="<%=dBean.getProcessVo().getProId().intValue()%>"></input><%} else{ %><input type="hidden" name="hidObjId" value="-1"></input><%} %></li></ul></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD align="right"><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script type="text/javascript">
var PRO_LABEL = "<%=LabelManager.getName(labelSet,"lblPro")%>" + ": ";
var SUB_PRO_LABEL = "<%=LabelManager.getName(labelSet,"lblSubPro")%>" + ": ";
var TASK_LABEL = "<%=LabelManager.getName(labelSet,"lblTask")%>" + ": ";
var FORM_LABEL = "<%=LabelManager.getName(labelSet,"lblForm")%>" + ": ";
var ATT_LABEL = "<%=LabelManager.getName(labelSet,"lblAtt")%>" + ": ";
var TYPE_LABEL = "<%=LabelManager.getName(labelSet,"lblTip")%>" + ": ";
var OBLIG_LABEL = "<%=LabelManager.getName(labelSet,"titObligatory")%>" + ": ";
var MAP_ENTITY_LABEL = "<%=LabelManager.getName(labelSet,"lblMapEntity")%>" + ": ";
var DATE_LABEL = "<%=LabelManager.getName(labelSet,"lblDate")%>";
var NUMERIC_LABEL = "<%=LabelManager.getName(labelSet,"lblNum")%>";
var STRING_LABEL = "<%=LabelManager.getName(labelSet,"lblStr")%>";
var PROCESS_ID_LABEL = "<%=LabelManager.getName(labelSet,"lblEjeIdePro").toUpperCase()%>";
var PROCESS_STATUS_LABEL = "<%=LabelManager.getName(labelSet,"lblEjeStaPro").toUpperCase()%>";
var PROCESS_CREATOR_LABEL = "<%=LabelManager.getName(labelSet,"lblEjeUsuCrePro").toUpperCase()%>";
var PROCESS_CRE_DATE_LABEL = "<%=LabelManager.getName(labelSet,"lblEjeFecCrePro").toUpperCase()%>";
var PROCESS_ACTION_LABEL = "<%=LabelManager.getName(labelSet,"lblAccPro").toUpperCase()%>";
var PROCESS_PRIORITY_LABEL = "<%=LabelManager.getName(labelSet,"lblProPriority").toUpperCase()%>";
var PROCESS_END_DATE_LABEL = "<%=LabelManager.getName(labelSet,"lblEjeFecEndPro").toUpperCase()%>";
var ENTITY_ID_LABEL = "<%=LabelManager.getName(labelSet,"lblEjeIdeEnt").toUpperCase()%>";
var ENTITY_STATUS_LABEL = "<%=LabelManager.getName(labelSet,"lblEjeStaEnt").toUpperCase()%>";
var ENTITY_CREATOR_LABEL = "<%=LabelManager.getName(labelSet,"lblEjeUsuCreEnt").toUpperCase()%>";
var ENTITY_CRE_DATE_LABEL = "<%=LabelManager.getName(labelSet,"lblEjeFecCreEnt").toUpperCase()%>";
var ENT_PRO_FORM_LABEL = "<%=LabelManager.getName(labelSet,"lblProEntFor")%>";
var PRO_PRO_FORM_LABEL = "<%=LabelManager.getName(labelSet,"lblProProFor")%>";

var PROCESS_IDENT_ID = "<%=ProcessDwColumnVo.BASIC_PRO_DATA_COL_IDENT%>";
var PROCESS_ID_NAME = "<%=ProcessDwColumnVo.BASIC_PRO_DATA_COL_IDENT_NAME%>";

var PROCESS_STATUS_ID = "<%=ProcessDwColumnVo.BASIC_PRO_DATA_COL_STATUS%>";
var PROCESS_STATUS_NAME = "<%=ProcessDwColumnVo.BASIC_PRO_DATA_COL_STATUS_NAME%>";

var PROCESS_CREATE_USR_ID = "<%=ProcessDwColumnVo.BASIC_PRO_DATA_COL_CREATE_USER%>";
var PROCESS_CREATOR_NAME = "<%=ProcessDwColumnVo.BASIC_PRO_DATA_COL_CREATE_USER_NAME%>";

var PROCESS_CREATE_DATE_ID = "<%=ProcessDwColumnVo.BASIC_PRO_DATA_COL_CREATE_DATE%>";
var PROCESS_CRE_DATE_NAME = "<%=ProcessDwColumnVo.BASIC_PRO_DATA_COL_CREATE_DATE_NAME%>";

var PROCESS_ACTION_ID = "<%=ProcessDwColumnVo.BASIC_PRO_DATA_COL_ACTION%>";
var PROCESS_ACTION_NAME = "<%=ProcessDwColumnVo.BASIC_PRO_DATA_COL_ACTION_NAME%>";

var PROCESS_PRIORITY_ID = "<%=ProcessDwColumnVo.BASIC_PRO_DATA_COL_PRIORITY%>";
var PROCESS_PRIORITY_NAME = "<%=ProcessDwColumnVo.BASIC_PRO_DATA_COL_PRIORITY_NAME%>";

var PROCESS_END_DATE_ID = "<%=ProcessDwColumnVo.BASIC_PRO_DATA_COL_END_DATE%>";
var PROCESS_END_DATE_NAME = "<%=ProcessDwColumnVo.BASIC_PRO_DATA_COL_END_DATE_NAME%>";

var ENTITY_IDENT_ID = "<%=ProcessDwColumnVo.BASIC_ENT_DATA_COL_IDENT%>";
var ENTITY_ID_NAME = "<%=ProcessDwColumnVo.BASIC_ENT_DATA_COL_IDENT_NAME%>";

var ENTITY_STATUS_ID = "<%=ProcessDwColumnVo.BASIC_ENT_DATA_COL_STATUS%>";
var ENTITY_STATUS_NAME = "<%=ProcessDwColumnVo.BASIC_ENT_DATA_COL_STATUS_NAME%>";

var ENTITY_CREATOR_ID = "<%=ProcessDwColumnVo.BASIC_ENT_DATA_COL_CREATE_USER%>";
var ENTITY_CREATOR_NAME = "<%=ProcessDwColumnVo.BASIC_ENT_DATA_COL_CREATE_USER_NAME%>";

var ENTITY_CREATE_DATE_ID = "<%=ProcessDwColumnVo.BASIC_ENT_DATA_COL_CREATE_DATE%>";
var ENTITY_CRE_DATE_NAME = "<%=ProcessDwColumnVo.BASIC_ENT_DATA_COL_CREATE_DATE_NAME%>";

var DW_ATT_FROM_ENTITY_BASIC_DATA = "<%=ProcessDwColumnVo.DW_ATT_FROM_ENTITY_BASIC_DATA%>";
var DW_ATT_FROM_PROCESS_BASIC_DATA = "<%=ProcessDwColumnVo.DW_ATT_FROM_PROCESS_BASIC_DATA%>";
var DW_ATT_FROM_ENTITY_FORM = "<%=ProcessDwColumnVo.DW_ATT_FROM_ENTITY_FORM%>";
var DW_ATT_FROM_PROCESS_FORM = "<%=ProcessDwColumnVo.DW_ATT_FROM_PROCESS_FORM%>";
var DW_ATT_FROM_PROCESS = "<%=ProcessDwColumnVo.DW_ATT_FROM_PROCESS%>";

var selBasicDat = new Array(); //para almacenar los atributos seleccionados basicos del proceso o entidad
var selRedundantsAtts = new Array(); //para almacenar los atributos seleccionados redundantes del proceso
var selEntAtts = new Array(); //para almacenar los atributos seleccionados de formularios de entidad
var selProAtts = new Array(); //para almacenar los atributos seleccionados de formularios de proceso
</script><script language="javascript">
function btnConf_click() {
	window.returnValue=getSelected();
	window.close();
}

function doLIAction(aEvent, type){
	var element = aEvent;
	aEvent.cancelBubble = true;
	if(element.tagName=="SPAN"){
		element=element.parentNode;
	}
	if (type=="processData" || type=="entityProAtts" || type=="proRedAtts" || type=="processTasks" || type=="task" || type=="entityForms" || type=="processForms" || type=="entityForm" || type=="processForm"){
		var fldAtt = element.Fldstate;

		if(fldAtt!="open"){//Estaba cerrado --> hay que abrir
			element.Fldstate="open";
			element.src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>"+"/images/open.gif";//show open
		}else{ //Estaba abierto --> hay que cerrar
			element.Fldstate="";
			element.src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>"+"/images/closed.gif";//showCloseds
		}
	}
	if(fldAtt!="open"){
		if (type=="processData"){
			openProBasicData(element);
		}else if (type == "entityProAtts"){
			openEntBasicData(element);
		}else if (type == "task"){
			openTaskForms(element);
		}else{
			openData(element,type);
		}
	}else{
		closeData(element);
	}
}

function closeData(element){
	var ul = element.parentNode.getElementsByTagName("UL");
	while(ul.length >0){
		ul[0].parentNode.removeChild(ul[0]);
	}
}

function loadAtts(){
	var attIds = "<%=request.getParameter("attIds")%>";
	if (attIds.length > 0){
		var sepPos = attIds.indexOf(",");     
		while (sepPos>=0){
			var attId = attIds.substring(0,sepPos);
			if (parseInt(attId)>0){
				selRedundantsAtts[selRedundantsAtts.length] = attId;
			}else{
				selBasicDat[selBasicDat.length] = attId;
			}
			attIds = attIds.substring(sepPos+1,attIds.length);
			sepPos = attIds.indexOf(",");     
		}
		if (parseInt(attIds)>0){
			selRedundantsAtts[selRedundantsAtts.length] = attIds;
		}else{
			selBasicDat[selBasicDat.length] = attIds;
		}
	}
	var attIds = "<%=request.getParameter("attEntIds")%>";
	if (attIds.length > 0){
		var sepPos = attIds.indexOf(",");     
		while (sepPos>=0){
			var attId = attIds.substring(0,sepPos);
			if (parseInt(attId)>0){
				selEntAtts[selEntAtts.length] = attId;
			}
			attIds = attIds.substring(sepPos+1,attIds.length);
			sepPos = attIds.indexOf(",");     
		}
		if (parseInt(attIds)>0){
			selEntAtts[selEntAtts.length] = attIds;
		}
	}
	var attIds = "<%=request.getParameter("attProIds")%>";
	if (attIds.length > 0){
		var sepPos = attIds.indexOf(",");     
		while (sepPos>=0){
			var attId = attIds.substring(0,sepPos);
			if (parseInt(attId)>0){
				selProAtts[selProAtts.length] = attId;
			}
			attIds = attIds.substring(sepPos+1,attIds.length);
			sepPos = attIds.indexOf(",");     
		}
		if (parseInt(attIds)>0){
			selProAtts[selProAtts.length] = attIds;
		}
	}
}

function openProBasicData(element){
	var oUL = document.createElement("ul");
	var oLI1 = document.createElement("li"); 
	var oLI2 = document.createElement("li");
	var oLI3 = document.createElement("li");
	var oLI4 = document.createElement("li");
	var oLI5 = document.createElement("li");
	var oLI6 = document.createElement("li");
	var oLI7 = document.createElement("li");
	
	//1.Identificador del proceso
	oLI1.title = PROCESS_ID_LABEL;
	if (checkIfSelected(PROCESS_IDENT_ID)){
		oLI1.innerHTML = "<input type='checkbox' checked name='chkAtt' onclick=\"selUnselBasicData(this," + PROCESS_IDENT_ID + ")\"></input>";
	}else{
		oLI1.innerHTML = "<input type='checkbox' name='chkAtt' onclick=\"selUnselBasicData(this," + PROCESS_IDENT_ID + ")\"></input>";
	}
	oLI1.innerHTML = oLI1.innerHTML + "<span>"+PROCESS_ID_LABEL+"</span>";
	oLI1.innerHTML = oLI1.innerHTML + "<input type='hidden' name='hidObjId' value='" + PROCESS_IDENT_ID + "'></input>";
	
	//2.Estado del proceso
	oLI2.title = PROCESS_STATUS_LABEL;
	if (checkIfSelected(PROCESS_STATUS_ID)){
		oLI2.innerHTML = "<input type='checkbox' checked name='chkAtt' onclick=\"selUnselBasicData(this," + PROCESS_STATUS_ID + ")\"></input>";
	}else{
		oLI2.innerHTML = "<input type='checkbox' name='chkAtt' onclick=\"selUnselBasicData(this," + PROCESS_STATUS_ID+ ")\"></input>";
	}
	oLI2.innerHTML = oLI2.innerHTML + "<span>"+PROCESS_STATUS_LABEL+"</span>";
	oLI2.innerHTML = oLI2.innerHTML + "<input type='hidden' name='hidObjId' value='" + PROCESS_STATUS_ID + "'></input>";
	
	//3.Creador del proceso
	oLI3.title = PROCESS_CREATOR_LABEL;
	if (checkIfSelected(PROCESS_CREATE_USR_ID)){
		oLI3.innerHTML = "<input type='checkbox' checked name='chkAtt' onclick=\"selUnselBasicData(this," + PROCESS_CREATE_USR_ID+ ")\"></input>";
	}else{
		oLI3.innerHTML = "<input type='checkbox' name='chkAtt' onclick=\"selUnselBasicData(this," + PROCESS_CREATE_USR_ID + ")\"></input>";
	}
	oLI3.innerHTML = oLI3.innerHTML + "<span>"+PROCESS_CREATOR_LABEL+"</span>";
	oLI3.innerHTML = oLI3.innerHTML + "<input type='hidden' name='hidObjId' value='" + PROCESS_CREATE_USR_ID + "'></input>";
	
	//4.Fecha de creacion del proceso
	oLI4.title = PROCESS_CRE_DATE_LABEL;
	if (checkIfSelected(PROCESS_CREATE_DATE_ID)){
		oLI4.innerHTML = "<input type='checkbox' checked name='chkAtt' onclick=\"selUnselBasicData(this," + PROCESS_CREATE_DATE_ID + ")\"></input>";
	}else{
		oLI4.innerHTML = "<input type='checkbox' name='chkAtt' onclick=\"selUnselBasicData(this," + PROCESS_CREATE_DATE_ID + ")\"></input>";
	}
	oLI4.innerHTML = oLI4.innerHTML + "<span>"+PROCESS_CRE_DATE_LABEL+"</span>";
	oLI4.innerHTML = oLI4.innerHTML + "<input type='hidden' name='hidObjId' value='" + PROCESS_CREATE_DATE_ID + "'></input>";
	
	//5.Accion del proceso
	oLI5.title = PROCESS_ACTION_LABEL;
	if (checkIfSelected(PROCESS_ACTION_ID)){
		oLI5.innerHTML = "<input type='checkbox' checked name='chkAtt' onclick=\"selUnselBasicData(this," + PROCESS_ACTION_ID + ")\"></input>";
	}else{
		oLI5.innerHTML = "<input type='checkbox' name='chkAtt' onclick=\"selUnselBasicData(this," + PROCESS_ACTION_ID + ")\"></input>";
	}
	oLI5.innerHTML = oLI5.innerHTML + "<span>"+PROCESS_ACTION_LABEL+"</span>";
	oLI5.innerHTML = oLI5.innerHTML + "<input type='hidden' name='hidObjId' value='" + PROCESS_ACTION_ID + "'></input>";
	
	//6.Prioridad del proceso
	oLI6.title = PROCESS_PRIORITY_LABEL;
	if (checkIfSelected(PROCESS_PRIORITY_ID)){
		oLI6.innerHTML = "<input type='checkbox' checked name='chkAtt' onclick=\"selUnselBasicData(this," + PROCESS_PRIORITY_ID + ")\"></input>";
	}else{
		oLI6.innerHTML = "<input type='checkbox' name='chkAtt' onclick=\"selUnselBasicData(this," + PROCESS_PRIORITY_ID + ")\"></input>";
	}
	oLI6.innerHTML = oLI6.innerHTML + "<span>"+PROCESS_PRIORITY_LABEL+"</span>";
	oLI6.innerHTML = oLI6.innerHTML + "<input type='hidden' name='hidObjId' value='" + PROCESS_PRIORITY_ID + "'></input>";
	
	//7.Fecha de finalización del proceso
	oLI7.title = PROCESS_END_DATE_LABEL;
	if (checkIfSelected(PROCESS_END_DATE_ID)){
		oLI7.innerHTML = "<input type='checkbox' checked name='chkAtt' onclick=\"selUnselBasicData(this," + PROCESS_END_DATE_ID + ")\"></input>";
	}else{
		oLI7.innerHTML = "<input type='checkbox' name='chkAtt' onclick=\"selUnselBasicData(this," + PROCESS_END_DATE_ID + ")\"></input>";
	}
	oLI7.innerHTML = oLI7.innerHTML + "<span>"+PROCESS_END_DATE_LABEL+"</span>";
	oLI7.innerHTML = oLI7.innerHTML + "<input type='hidden' name='hidObjId' value='" + PROCESS_END_DATE_ID + "'></input>";
	
	oUL.appendChild(oLI1);
	oUL.appendChild(oLI2);
	oUL.appendChild(oLI3);
	oUL.appendChild(oLI4);
	oUL.appendChild(oLI5);
	oUL.appendChild(oLI6);
	oUL.appendChild(oLI7);
	
	element.parentNode.appendChild(oUL);
}

function openEntBasicData(element){
	var oUL = document.createElement("ul");
	var oLI1 = document.createElement("li"); 
	var oLI2 = document.createElement("li");
	var oLI3 = document.createElement("li");
	var oLI4 = document.createElement("li");
	
	//1.Identificador de la entidad
	oLI1.title = ENTITY_ID_LABEL;
	if (checkIfSelected(ENTITY_IDENT_ID)){
		oLI1.innerHTML = "<input type='checkbox' checked name='chkAtt' onclick=\"selUnselBasicData(this," + ENTITY_IDENT_ID + ")\"></input>";
	}else{
		oLI1.innerHTML = "<input type='checkbox' name='chkAtt' onclick=\"selUnselBasicData(this," + ENTITY_IDENT_ID + ")\"></input>";
	}
	oLI1.innerHTML = oLI1.innerHTML + "<span>"+ENTITY_ID_LABEL+"</span>";
	oLI1.innerHTML = oLI1.innerHTML + "<input type='hidden' name='hidObjId' value='" + ENTITY_IDENT_ID + "'></input>";
	
	//2.Estado de la entidad
	oLI2.title = ENTITY_STATUS_LABEL;
	if (checkIfSelected(ENTITY_STATUS_ID)){
		oLI2.innerHTML = "<input type='checkbox' checked name='chkAtt' onclick=\"selUnselBasicData(this," + ENTITY_STATUS_ID + ")\"></input>";
	}else{
		oLI2.innerHTML = "<input type='checkbox' name='chkAtt' onclick=\"selUnselBasicData(this," + ENTITY_STATUS_ID + ")\"></input>";
	}
	oLI2.innerHTML = oLI2.innerHTML + "<span>"+ENTITY_STATUS_LABEL+"</span>";
	oLI2.innerHTML = oLI2.innerHTML + "<input type='hidden' name='hidObjId' value='" + ENTITY_STATUS_ID + "'></input>";
	
	//3.Creador de la entidad
	oLI3.title = ENTITY_CREATOR_LABEL;
	if (checkIfSelected(ENTITY_CREATOR_ID)){
		oLI3.innerHTML = "<input type='checkbox' checked name='chkAtt' onclick=\"selUnselBasicData(this," + ENTITY_CREATOR_ID + ")\"></input>";
	}else{
		oLI3.innerHTML = "<input type='checkbox' name='chkAtt' onclick=\"selUnselBasicData(this," + ENTITY_CREATOR_ID + ")\"></input>";
	}
	oLI3.innerHTML = oLI3.innerHTML + "<span>"+ENTITY_CREATOR_LABEL+"</span>";
	oLI3.innerHTML = oLI3.innerHTML + "<input type='hidden' name='hidObjId' value='" + ENTITY_CREATOR_ID +"'></input>";
	
	//4.Fecha de creacion de la entidad
	oLI4.title = ENTITY_CRE_DATE_LABEL;
	if (checkIfSelected(ENTITY_CREATE_DATE_ID)){
		oLI4.innerHTML = "<input type='checkbox' checked name='chkAtt' onclick=\"selUnselBasicData(this," + ENTITY_CREATE_DATE_ID + ")\"></input>";
	}else{
		oLI4.innerHTML = "<input type='checkbox' name='chkAtt' onclick=\"selUnselBasicData(this," + ENTITY_CREATE_DATE_ID + ")\"></input>";
	}
	oLI4.innerHTML = oLI4.innerHTML + "<span>"+ENTITY_CRE_DATE_LABEL+"</span>";
	oLI4.innerHTML = oLI4.innerHTML + "<input type='hidden' name='hidObjId' value='" + ENTITY_CREATE_DATE_ID + "'></input>";
	
	oUL.appendChild(oLI1);
	oUL.appendChild(oLI2);
	oUL.appendChild(oLI3);
	oUL.appendChild(oLI4);
	
	element.parentNode.appendChild(oUL);
}

function openTaskForms(element){
	obj = element.parentNode;
	var objId = obj.getElementsByTagName("INPUT")[0].value;
	var proEleId = obj.getElementsByTagName("INPUT")[1].value;
	var proId = obj.getElementsByTagName("INPUT")[2].value;
	
	var oUL = document.createElement("ul");
	var oLI1 = document.createElement("li"); 
	var oLI2 = document.createElement("li");
	
	//1.Formularios de entidad
	oLI1.title = ENT_PRO_FORM_LABEL;
	oLI1.innerHTML = "<IMG onclick=\"doLIAction(this, 'entityForms')\" SRC=\"<%=Parameters.ROOT_PATH%>/styles/<%=styleDirectory%>/images/closed.gif\"/>";
	oLI1.innerHTML = oLI1.innerHTML + "<span>" + ENT_PRO_FORM_LABEL +"</span>";
	oLI1.innerHTML = oLI1.innerHTML + "<input type='hidden' name='hidObjId' value='" + objId + "'></input>";
	oLI1.innerHTML = oLI1.innerHTML + "<input type='hidden' name='hidProEleId' value='" + proEleId + "'></input>";
	oLI1.innerHTML = oLI1.innerHTML + "<input type='hidden' name='hidProId' value='" + proId + "'></input>";
	
	//2.Formularios de proceso
	oLI2.title = PRO_PRO_FORM_LABEL;
	oLI2.innerHTML = "<IMG onclick=\"doLIAction(this, 'processForms')\" SRC=\"<%=Parameters.ROOT_PATH%>/styles/<%=styleDirectory%>/images/closed.gif\"/>";
	oLI2.innerHTML = oLI2.innerHTML + "<span>" + PRO_PRO_FORM_LABEL +"</span>";
	oLI2.innerHTML = oLI2.innerHTML + "<input type='hidden' name='hidObjId' value='" + objId + "'></input>";
	oLI2.innerHTML = oLI2.innerHTML + "<input type='hidden' name='hidProEleId' value='" + proEleId + "'></input>";
	oLI2.innerHTML = oLI2.innerHTML + "<input type='hidden' name='hidProId' value='" + proId + "'></input>";
	
	oUL.appendChild(oLI1);
	oUL.appendChild(oLI2);
	
	element.parentNode.appendChild(oUL);
}

function openData(element,type){
	obj = element.parentNode;
	var objId = obj.getElementsByTagName("INPUT")[0].value;

	var sXMLSourceUrl
	if (type=="proRedAtts"){ //Atributos redundantes
		sXMLSourceUrl =  "<%=Parameters.ROOT_PATH%>/administration.BPMNAction.do?action=getTreeXMLForAddAttDim&opt=1" + windowId;
	}else if (type=="processTasks"){ //Tareas y subprocesos utilizados por el proceso (todos en un mismo nivel)
		sXMLSourceUrl =  "<%=Parameters.ROOT_PATH%>/administration.BPMNAction.do?action=getTreeXMLForAddAttDim&opt=2" + "&proId=" + objId + windowId;
	}else if (type=="entityForms"){ //Formularios de entidad
		var proEleId = obj.getElementsByTagName("INPUT")[1].value;
		var proId = obj.getElementsByTagName("INPUT")[2].value;
		sXMLSourceUrl =  "<%=Parameters.ROOT_PATH%>/administration.BPMNAction.do?action=getTreeXMLForAddAttDim&opt=3" + "&proId=" + proId + "&proEleId=" + proEleId + windowId;
	}else if (type=="processForms"){ //Formularios de proceso
		var proEleId = obj.getElementsByTagName("INPUT")[1].value;
		var proId = obj.getElementsByTagName("INPUT")[2].value;
		sXMLSourceUrl =  "<%=Parameters.ROOT_PATH%>/administration.BPMNAction.do?action=getTreeXMLForAddAttDim&opt=4" + "&proId=" + proId + "&proEleId=" + proEleId + windowId;
	}else if (type =="entityForm"){ //Atributos de un formulario de entidad
		sXMLSourceUrl =  "<%=Parameters.ROOT_PATH%>/administration.BPMNAction.do?action=getTreeXMLForAddAttDim&opt=5" + "&frmId=" + objId + windowId;
	}else if (type =="processForm"){ //Atributos de un formulario de proceso
		sXMLSourceUrl =  "<%=Parameters.ROOT_PATH%>/administration.BPMNAction.do?action=getTreeXMLForAddAttDim&opt=6" + "&frmId=" + objId + windowId;
	}
	var listener=new Object();
	listener.onLoad=function(xml){
		if (isXMLOk(xml)) {
			readXML(xml,element,type);
		}
	}
	xml.addListener(listener);
	sXmlResult = __readInDOMDocument(sXMLSourceUrl);
}

function readXML(XmlResult,element,type){
	var xmlRoot=getXMLRoot(XmlResult);
	var nextType;
	var prefix;
	var nextType2;
	var prefix2;
	
	if (type=="proRedAtts"){ // Si hizo click en un atributo redundante
		nextType = "attribute"; // Debo mostrar atributos
		prefix = ATT_LABEL;
	}else if (type=="processTasks"){ //Si hizo click en un subproceso
		nextType = "processTasks"; //Debo mostrar subprocesos
		prefix = SUB_PRO_LABEL;
		nextType2="task"; //Y debo mostrar tareas
		prefix2= TASK_LABEL;
	}else if (type=="entityForms"){ //Si hizo click en la opcion formularios de entidad
		nextType = "entityForm"; // Debo mostrar formularios de entidad
		prefix = FORM_LABEL;
	}else if (type=="processForms"){//Si hizo click en la opcion formularios de procesos
		nextType = "processForm"; //Debo mostrar formularios de proceso
		prefix = FORM_LABEL;
	}else if (type=="entityForm"){
		nextType = "entityAtt";
		prefix = ATT_LABEL;
	}else if (type=="processForm"){
		nextType = "processAtt";
		prefix = ATT_LABEL;
	}
	if (xmlRoot.nodeName != "EXCEPTION") {
		if (xmlRoot.childNodes.length == 0) {
			//document.getElementById("noData").style.display="block";
		} else {
			xRow = xmlRoot.childNodes[0];
			for(i=0;i<xmlRoot.childNodes.length;i++){
				xRow = xmlRoot.childNodes[i];

				//Identificador
				var objId = xRow.childNodes[0].firstChild.nodeValue;

				var objName = "";;
				//Nombre
				if (type=="proRedAtts" || type == "entityForm" || type == "processForm"){
					objName = prefix + xRow.childNodes[1].firstChild.nodeValue + " (" + xRow.childNodes[3].firstChild.nodeValue;
					if (xRow.childNodes[2].firstChild != null){ //Si tiene descripcion la mostramos
						objName = objName + " - " + xRow.childNodes[2].firstChild.nodeValue + ")";
					}else{
						objName = objName + ")";
					}
				}else if (type=="processTasks") { 
					if (xRow.childNodes[4]!=null && 'true'==xRow.childNodes[4].firstChild.nodeValue){ // es subproceso
						objName = prefix + xRow.childNodes[1].firstChild.nodeValue + " (" + xRow.childNodes[3].firstChild.nodeValue;
						if (xRow.childNodes[2].firstChild != null){ //Si tiene descripcion la mostramos
							objName = objName + " - " + xRow.childNodes[2].firstChild.nodeValue + ")";
						}else{
							objName = objName + ")";
						}
					}else{ //es tarea
						objName = prefix2 + xRow.childNodes[1].firstChild.nodeValue + " (" + xRow.childNodes[3].firstChild.nodeValue;
						if (xRow.childNodes[2].firstChild != null){ //Si tiene descripcion la mostramos
							objName = objName + " - " + xRow.childNodes[2].firstChild.nodeValue + ")";
						}else{
							objName = objName + ")";
						}
					}
				}else{
					objName = prefix + xRow.childNodes[1].firstChild.nodeValue + " (" + xRow.childNodes[3].firstChild.nodeValue;
					if (xRow.childNodes[2].firstChild != null){ //Si tiene descripcion la mostramos
						objName = objName + " - " + xRow.childNodes[2].firstChild.nodeValue + ")";
					}else{
						objName = objName + ")";
					}
				}
				
				//ToolTip (solo para atributos de formularios)
				var objTitle = "";
				if (type == "entityForm" || type=="processForm"){
					if (xRow.childNodes[4].firstChild != null){
						var attType = xRow.childNodes[4].firstChild.nodeValue;
						if (attType == "D"){
							objTitle = "(" + TYPE_LABEL + DATE_LABEL;
						}else if (attType == "S"){
							objTitle = "(" + TYPE_LABEL + STRING_LABEL;						
						}else{
							objTitle = "(" + TYPE_LABEL + NUMERIC_LABEL;
						}
					}
					if (xRow.childNodes[5].firstChild != null){
						var oblig = xRow.childNodes[5].firstChild.nodeValue;
						objTitle = objTitle + ", " + OBLIG_LABEL + oblig;
					}
					if (xRow.childNodes[6].firstChild != null){
						var entity = xRow.childNodes[6].firstChild.nodeValue;
						objTitle = objTitle + ", " + MAP_ENTITY_LABEL + entity + ")";
					}else{
						objTitle = objTitle + ")";
					}
				}
				var oUL = document.createElement("ul");
				var oLI = document.createElement("li"); 
			
				oLI.title = objTitle;
				var isTask = false;
				if (type!="entityForm" && type!="processForm" && type!="proRedAtts"){
					if (type=="processTasks"){ //Si es subproceso
						if (xRow.childNodes[4]!=null && 'true'==xRow.childNodes[4].firstChild.nodeValue){//es subproceso
							oLI.innerHTML = "<IMG onclick=\"doLIAction(this,'"+nextType+"')\" SRC='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/closed.gif'/>";							
						}else{//es tarea
							isTask = true;
							oLI.innerHTML = "<IMG onclick=\"doLIAction(this,'"+nextType2+"')\" SRC='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/closed.gif'/>";
						}
					}else{
						oLI.innerHTML = "<IMG onclick=\"doLIAction(this,'"+nextType+"')\" SRC='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/closed.gif'/>";
					}
				}else if (type=="proRedAtts"){
					if (checkIfSelected(objId)){
						oLI.innerHTML = "<input type='checkbox' checked name='chkAtt' onclick=\"selUnselRedAttribute(this,"+objId+")\"></input>";
					}else{
						oLI.innerHTML = "<input type='checkbox' name='chkAtt' onclick=\"selUnselRedAttribute(this,"+objId+")\"></input>";
					}
				}else if (type=="entityForm"){
					if (checkIfSelected(objId)){
						oLI.innerHTML = "<input type='checkbox' checked name='chkAtt' onclick=\"selUnselEntAttribute(this,"+objId+")\"></input>";
					}else{
						oLI.innerHTML = "<input type='checkbox' name='chkAtt' onclick=\"selUnselEntAttribute(this,"+objId+")\"></input>";
					}
				}else if (type=="processForm"){
					if (checkIfSelected(objId)){
						oLI.innerHTML = "<input type='checkbox' checked name='chkAtt' onclick=\"selUnselProAttribute(this,"+objId+")\"></input>";
					}else{
						oLI.innerHTML = "<input type='checkbox' name='chkAtt' onclick=\"selUnselProAttribute(this,"+objId+")\"></input>";
					}
				}
				oLI.innerHTML = oLI.innerHTML + "<span>"+objName+"</span>";
				oLI.innerHTML = oLI.innerHTML + "<input type='hidden' name='hidObjId' value='"+objId+"'></input>";
				
				if (isTask){ //Si se van a mostrar tareas -> guardamos el proEleId de la tarea
					oLI.innerHTML = oLI.innerHTML + "<input type='hidden' name='hidProEleId' value='"+xRow.childNodes[4].firstChild.nodeValue+"'></input>";
					oLI.innerHTML = oLI.innerHTML + "<input type='hidden' name='hidProId' value='"+xRow.childNodes[5].firstChild.nodeValue+"'></input>";
				}else{
					oLI.innerHTML = oLI.innerHTML + "<input type='hidden' name='hidProEleId' value='-1'></input>";
					oLI.innerHTML = oLI.innerHTML + "<input type='hidden' name='hidProId' value='-1'></input>";
				}
				
				if (type=="entityForm"){
					oLI.innerHTML = oLI.innerHTML + "<input type='hidden' name='hidAttFrom' value='entityAtt'></input>";
				}else if (type=="processForm"){
					oLI.innerHTML = oLI.innerHTML + "<input type='hidden' name='hidAttFrom' value='processAtt'></input>";
				}else{
					oLI.innerHTML = oLI.innerHTML + "<input type='hidden' name='hidAttFrom' value=''></input>";
				}
				
				oUL.appendChild(oLI);
				element.parentNode.appendChild(oUL);
			}
		}
	}else{
		alert("error occurred");
	}
	
	xmlRoot = "";
	sXmlResult = "";
}

//Verifica si ya no se encuentra en los arrays donde se almacenana los seleccionados
function notInSelAtts(attId){
	for (var i=0; i<selBasicDat.length; i++){
		if (selBasicDat[i] == attId){
			return false;
		}
	}
	for (var i=0; i<selRedundantsAtts.length; i++){
		if (selRedundantsAtts[i] == attId){
			return false;
		}
	}
	for (var i=0; i<selEntAtts.length; i++){
		if (selEntAtts[i] == attId){
			return false;
		}
	}
	for (var i=0; i<selProAtts.length; i++){
		if (selProAtts[i] == attId){
			return false;
		}
	}
	return true;
}

function selUnselEntAttribute(obj,attId){
	var li = obj.parentNode;
	if(li.getElementsByTagName("INPUT")[0].checked){
		if (notInSelAtts(attId)){
			selEntAtts[selEntAtts.length] = attId;
		}
	}else{
		for (var i=0; i<selEntAtts.length; i++){
			if (selEntAtts[i] == attId) {	
				selEntAtts[i] = null;
				return;
			}
		}
	}
}

function selUnselProAttribute(obj,attId){
	var li = obj.parentNode;
	if(li.getElementsByTagName("INPUT")[0].checked){
		if (notInSelAtts(attId)){
			selProAtts[selProAtts.length] = attId;
		}
	}else{
		for (var i=0; i<selEntAtts.length; i++){
			if (selProAtts[i] == attId) {	
				selProAtts[i] = null;
				return;
			}
		}
	}
}

function selUnselRedAttribute(obj,attId){
	var li = obj.parentNode;
	if(li.getElementsByTagName("INPUT")[0].checked){
		if (notInSelAtts(attId)){
			selRedundantsAtts[selRedundantsAtts.length] = attId;
		}
	}else{
		for (var i=0; i<selRedundantsAtts.length; i++){
			if (selRedundantsAtts[i] == attId) {	
				selRedundantsAtts[i] = null;
				return;
			}
		}
	}
}

function selUnselBasicData(obj,datId){
	var li = obj.parentNode;
	if(li.getElementsByTagName("INPUT")[0].checked){
		if (notInSelAtts(datId)){
			selBasicDat[selBasicDat.length] = datId;
		}
	}else{
		for (var i=0; i<selBasicDat.length; i++){
			if (selBasicDat[i] == datId) {	
				selBasicDat[i] = null;
				return;
			}
		}
	}
}

function checkIfSelected(attId){
	for (var i=0; i<selBasicDat.length; i++){
		if (selBasicDat[i] == attId){
			return true;
		}
	}
	for (var i=0; i<selRedundantsAtts.length; i++){
		if (selRedundantsAtts[i] == attId){
			return true;
		}
	}
	for (var i=0; i<selEntAtts.length; i++){
		if (selEntAtts[i] == attId){
			return true;
		}
	}
	for (var i=0; i<selProAtts.length; i++){
		if (selProAtts[i] == attId){
			return true;
		}
	}
	return false;
}

//Funcion para usar con Ajax
function getXMLHttpRequest(){
	var http_request = null;
	if (window.XMLHttpRequest) {
		// browser has native support for XMLHttpRequest object
		http_request = new XMLHttpRequest();
	} else if (window.ActiveXObject) {
		// try XMLHTTP ActiveX (Internet Explorer) version
		try {
			http_request = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e1) {
			try {
				http_request = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e2) {
				http_request = null;
			}
		}
	}
	return http_request;
}

function getSelected(){
	result = new Array();
	var str = "";
	if (selBasicDat.length > 0) {//Agregamos los datos basicos de la entidad seleccionados
		  for (var w=0; w<selBasicDat.length; w++){
			if (selBasicDat[w] != null && selBasicDat[w] != 'null') {	
				arr = new Array();
				if (selBasicDat[w] == PROCESS_IDENT_ID){ //Identificador del proceso
					arr[0] = PROCESS_IDENT_ID;
					arr[1] = PROCESS_ID_NAME;
					arr[2] = PROCESS_ID_NAME;
					arr[3] = "S";
					arr[4] = "0";
					arr[5] = "null";
					arr[6] = DW_ATT_FROM_PROCESS_BASIC_DATA; //De donde proviente el atributo (-2:Dato basico Entidad, -1:Dato basico Proceso, 1:Formulario de entidad, 2:Formulario de proceso, 3: Redundante)
				}else if (selBasicDat[w] == PROCESS_STATUS_ID){ //Estado del proceso
					arr[0] = PROCESS_STATUS_ID;
					arr[1] = PROCESS_STATUS_NAME;
					arr[2] = PROCESS_STATUS_NAME;
					arr[3] = "S";
					arr[4] = "0";
					arr[5] = "null";
					arr[6] = DW_ATT_FROM_PROCESS_BASIC_DATA;
				}else if (selBasicDat[w] == PROCESS_CREATE_USR_ID){ //Creador del proceso
					arr[0] = PROCESS_CREATE_USR_ID;
					arr[1] = PROCESS_CREATOR_NAME;
					arr[2] = PROCESS_CREATOR_NAME;
					arr[3] = "S";
					arr[4] = "0";
					arr[5] = "null";
					arr[6] = DW_ATT_FROM_PROCESS_BASIC_DATA;
				}else if (selBasicDat[w] == PROCESS_CREATE_DATE_ID){ //Fecha de creacion del proceso
					arr[0] = PROCESS_CREATE_DATE_ID;
					arr[1] = PROCESS_CRE_DATE_NAME;
					arr[2] = PROCESS_CRE_DATE_NAME;
					arr[3] = "D";
					arr[4] = "0";
					arr[5] = "null";
					arr[6] = DW_ATT_FROM_PROCESS_BASIC_DATA;
				}else if (selBasicDat[w] == PROCESS_ACTION_ID){ //Acción del proceso
					arr[0] = PROCESS_ACTION_ID;
					arr[1] = PROCESS_ACTION_NAME;
					arr[2] = PROCESS_ACTION_NAME;
					arr[3] = "S";
					arr[4] = "0";
					arr[5] = "null";
					arr[6] = DW_ATT_FROM_PROCESS_BASIC_DATA;
				}else if (selBasicDat[w] == PROCESS_PRIORITY_ID){ //Prioridad del proceso
					arr[0] = PROCESS_PRIORITY_ID;
					arr[1] = PROCESS_PRIORITY_NAME;
					arr[2] = PROCESS_PRIORITY_NAME;
					arr[3] = "S";
					arr[4] = "0";
					arr[5] = "null";
					arr[6] = DW_ATT_FROM_PROCESS_BASIC_DATA;
				}else if (selBasicDat[w] == PROCESS_END_DATE_ID){ //Fecha de finalizacion del proceso
					arr[0] = PROCESS_END_DATE_ID;
					arr[1] = PROCESS_END_DATE_NAME;
					arr[2] = PROCESS_END_DATE_NAME;
					arr[3] = "D";
					arr[4] = "0";
					arr[5] = "null";
					arr[6] = DW_ATT_FROM_PROCESS_BASIC_DATA;
				}else if (selBasicDat[w] == ENTITY_IDENT_ID){ //Identificador de la entidad
					arr[0] = ENTITY_IDENT_ID;
					arr[1] = ENTITY_ID_NAME;
					arr[2] = ENTITY_ID_NAME;
					arr[3] = "S";
					arr[4] = "0";
					arr[5] = "null";
					arr[6] = DW_ATT_FROM_ENTITY_BASIC_DATA;
				}else if (selBasicDat[w] == ENTITY_STATUS_ID){ //Estado de la entidad
					arr[0] = ENTITY_STATUS_ID;
					arr[1] = ENTITY_STATUS_NAME;
					arr[2] = ENTITY_STATUS_NAME;
					arr[3] = "S";
					arr[4] = "0";
					arr[5] = "null";
					arr[6] = DW_ATT_FROM_ENTITY_BASIC_DATA;
				}else if (selBasicDat[w] == ENTITY_CREATOR_ID){ //Creador de la entidad
					arr[0] = ENTITY_CREATOR_ID;
					arr[1] = ENTITY_CREATOR_NAME;
					arr[2] = ENTITY_CREATOR_NAME;
					arr[3] = "S";
					arr[4] = "0";
					arr[5] = "null";
					arr[6] = DW_ATT_FROM_ENTITY_BASIC_DATA;
				}else if (selBasicDat[w] == ENTITY_CREATE_DATE_ID){ //Fecha de creacion de la entidad
					arr[0] = ENTITY_CREATE_DATE_ID;
					arr[1] = ENTITY_CRE_DATE_NAME;
					arr[2] = ENTITY_CRE_DATE_NAME;
					arr[3] = "D";
					arr[4] = "0";
					arr[5] = "null";
					arr[6] = DW_ATT_FROM_ENTITY_BASIC_DATA;
				}
				result[result.length] = arr;
			}
		  }
	}
	if (selRedundantsAtts.length > 0){
		var str = "";
		for (i = 0; i < selRedundantsAtts.length; i++) {
			if (selRedundantsAtts[i]!=null){
				if (str==""){
					str = "&attId=" + selRedundantsAtts[i];
				}else{
					str = str + "&attId=" + selRedundantsAtts[i];
				}
			}
		}
		if (str != ""){
			var	http_request = getXMLHttpRequest();
			//Recuperamos del bean la info de los attId's seleccionados
			http_request.open('POST', "administration.BPMNAction.do?action=getAttsInfo"+windowId, false);
			http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");

			http_request.send(str);
			if (http_request.readyState == 4) {
		   	   if (http_request.status == 200) {
		           if(http_request.responseText != "NOK"){
		              var attsInfo = http_request.responseText; //El formato de la respuesta es: 'id-nom-desc-tipo-idMapEnt-nameMapEnt-id-nom-desc-tipo-idMapEnt-nameMapEnt-..'
		              if (attsInfo == "NOK"){return;}
		              
		              //1.Agregamos los atributos seleccionados
					  while (attsInfo.indexOf("-")>-1){
						var attId = attsInfo.substring(0,attsInfo.indexOf("-"));
						attsInfo = attsInfo.substring(attsInfo.indexOf("-")+1,attsInfo.length);
						var attNom;
						if (attsInfo.indexOf("-")<0){
							attNom = attsInfo;					
						}else{
							attNom = attsInfo.substring(0,attsInfo.indexOf("-"));
						}
						attsInfo = attsInfo.substring(attsInfo.indexOf("-")+1,attsInfo.length);
						arr = new Array();
						if (attId != "skip"){
							var attLbl = attsInfo.substring(0,attsInfo.indexOf("-"));
							attsInfo = attsInfo.substring(attsInfo.indexOf("-")+1,attsInfo.length);
							var attType = attsInfo.substring(0,attsInfo.indexOf("-"));
							attsInfo = attsInfo.substring(attsInfo.indexOf("-")+1,attsInfo.length);
							var attIdMap = attsInfo.substring(0,attsInfo.indexOf("-"));
							attsInfo = attsInfo.substring(attsInfo.indexOf("-")+1,attsInfo.length);
							var attNamMap = "null";
							if (attsInfo.indexOf("-")<0){
								attNamMap = attsInfo;
							}else{
								attNamMap = attsInfo.substring(0,attsInfo.indexOf("-"));
							}
							attsInfo = attsInfo.substring(attsInfo.indexOf("-")+1,attsInfo.length);
							arr[0] = attId;
							arr[1] = attNom;
							arr[2] = attLbl;
							arr[3] = attType;
							arr[4] = attIdMap;
							arr[5] = attNamMap;
							arr[6] = DW_ATT_FROM_PROCESS; //De donde proviente el atributo (-2:Dato basico Entidad, -1:Dato basico Proceso, 1:Formulario de entidad, 2:Formulario de proceso o Redundante)
							
							//alert("attId:"+attId+", attName:" + attNom + ", attLbl:"+ attLbl+", attType:"+attType+", attMapEntId:"+attIdMap+", attMapEntName:"+attNamMap);
						}else{
							arr[0] = attId; //Ponemos la palabra que indica que se debe hacer skip
							arr[1] = attNom; //si se debe hacer skip, en attNom tenemos el attId (hecho asi por si existe un att llamado skip)
						}						
						result[result.length] = arr;
					  }
					}
			  }else {
		         return "NOK";
		      }
			}else{
		          return "Could not contact the server.";  
			}
		}
	}
	if (selEntAtts.length > 0){
		var str = "";
		for (i = 0; i < selEntAtts.length; i++) {
			if (selEntAtts[i]!=null){
				if (str==""){
					str = "&attId=" + selEntAtts[i];
				}else{
					str = str + "&attId=" + selEntAtts[i];
				}
			}
		}
		if (str != ""){
			var	http_request = getXMLHttpRequest();
			//Recuperamos del bean la info de los attId's seleccionados
			http_request.open('POST', "administration.BPMNAction.do?action=getAttsInfo"+windowId, false);
			http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");

			http_request.send(str);
			if (http_request.readyState == 4) {
		   	   if (http_request.status == 200) {
		           if(http_request.responseText != "NOK"){
		              var attsInfo = http_request.responseText; //El formato de la respuesta es: 'id-nom-desc-tipo-idMapEnt-nameMapEnt-id-nom-desc-tipo-idMapEnt-nameMapEnt-..'
		              if (attsInfo == "NOK"){return;}
		              
		              //1.Agregamos los atributos seleccionados
					  while (attsInfo.indexOf("-")>-1){
						var attId = attsInfo.substring(0,attsInfo.indexOf("-"));
						attsInfo = attsInfo.substring(attsInfo.indexOf("-")+1,attsInfo.length);
						var attNom;
						if (attsInfo.indexOf("-")<0){
							attNom = attsInfo;					
						}else{
							attNom = attsInfo.substring(0,attsInfo.indexOf("-"));
						}
						attsInfo = attsInfo.substring(attsInfo.indexOf("-")+1,attsInfo.length);
						arr = new Array();
						if (attId != "skip"){
							var attLbl = attsInfo.substring(0,attsInfo.indexOf("-"));
							attsInfo = attsInfo.substring(attsInfo.indexOf("-")+1,attsInfo.length);
							var attType = attsInfo.substring(0,attsInfo.indexOf("-"));
							attsInfo = attsInfo.substring(attsInfo.indexOf("-")+1,attsInfo.length);
							var attIdMap = attsInfo.substring(0,attsInfo.indexOf("-"));
							attsInfo = attsInfo.substring(attsInfo.indexOf("-")+1,attsInfo.length);
							var attNamMap = "null";
							if (attsInfo.indexOf("-")<0){
								attNamMap = attsInfo;
							}else{
								attNamMap = attsInfo.substring(0,attsInfo.indexOf("-"));
							}
							attsInfo = attsInfo.substring(attsInfo.indexOf("-")+1,attsInfo.length);
							arr = new Array();
							arr[0] = attId;
							arr[1] = attNom;
							arr[2] = attLbl;
							///if (attIdMap!=null && attIdMap!="" && attIdMap!="undefined" && attIdMap!="null"){ //Si tiene una entidad de mapeo 
							//	arr[3] = "S"; //el tipo es string
							//}else{
								arr[3] = attType;
							//}
							arr[4] = attIdMap;
							arr[5] = attNamMap;
							arr[6] = DW_ATT_FROM_ENTITY_FORM; //De donde proviente el atributo (-2:Dato basico Entidad, -1:Dato basico Proceso, 1:Formulario de entidad, 2:Formulario de proceso o Redundante)
							
							//alert("attId:"+attId+", attName:" + attNom + ", attLbl:"+ attLbl+", attType:"+attType+", attMapEntId:"+attIdMap+", attMapEntName:"+attNamMap);
						}else{
							arr[0] = attId; //Ponemos la palabra que indica que se debe hacer skip
							arr[1] = attNom; //si se debe hacer skip, en attNom tenemos el attId (hecho asi por si existe un att llamado skip)
						}
						result[result.length] = arr;
					  }
					}
			  }else {
		         return "NOK";
		      }
			}else{
		          return "Could not contact the server.";  
			}
		}
	} 
	if (selProAtts.length > 0){
		var str = "";
		for (i = 0; i < selProAtts.length; i++) {
			if (selProAtts[i]!=null){
				if (str==""){
					str = "&attId=" + selProAtts[i];
				}else{
					str = str + "&attId=" + selProAtts[i];
				}
			}
		}
		if (str != ""){
			var	http_request = getXMLHttpRequest();
			//Recuperamos del bean la info de los attId's seleccionados
			http_request.open('POST', "administration.BPMNAction.do?action=getAttsInfo"+windowId, false);
			http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");

			http_request.send(str);
			if (http_request.readyState == 4) {
		   	   if (http_request.status == 200) {
		           if(http_request.responseText != "NOK"){
		              var attsInfo = http_request.responseText; //El formato de la respuesta es: 'id-nom-desc-tipo-idMapEnt-nameMapEnt-id-nom-desc-tipo-idMapEnt-nameMapEnt-..'
		              if (attsInfo == "NOK"){return;}
		              
		              //1.Agregamos los atributos seleccionados
					  while (attsInfo.indexOf("-")>-1){
						var attId = attsInfo.substring(0,attsInfo.indexOf("-"));
						attsInfo = attsInfo.substring(attsInfo.indexOf("-")+1,attsInfo.length);
						var attNom;
						if (attsInfo.indexOf("-")<0){
							attNom = attsInfo;					
						}else{
							attNom = attsInfo.substring(0,attsInfo.indexOf("-"));
						}
						attsInfo = attsInfo.substring(attsInfo.indexOf("-")+1,attsInfo.length);
						arr = new Array();
						if (attId != "skip"){
							var attLbl = attsInfo.substring(0,attsInfo.indexOf("-"));
							attsInfo = attsInfo.substring(attsInfo.indexOf("-")+1,attsInfo.length);
							var attType = attsInfo.substring(0,attsInfo.indexOf("-"));
							attsInfo = attsInfo.substring(attsInfo.indexOf("-")+1,attsInfo.length);
							var attIdMap = attsInfo.substring(0,attsInfo.indexOf("-"));
							attsInfo = attsInfo.substring(attsInfo.indexOf("-")+1,attsInfo.length);
							var attNamMap = "null";
							if (attsInfo.indexOf("-")<0){
								attNamMap = attsInfo;
							}else{
								attNamMap = attsInfo.substring(0,attsInfo.indexOf("-"));
							}
							attsInfo = attsInfo.substring(attsInfo.indexOf("-")+1,attsInfo.length);
							arr = new Array();
							arr[0] = attId;
							arr[1] = attNom;
							arr[2] = attLbl;
							//if (attIdMap!=null && attIdMap!="" && attIdMap!="undefined" && attIdMap!="null"){ //Si tiene una entidad de mapeo 
							//	arr[3] = "S"; //el tipo es string
							//}else{
								arr[3] = attType;
							//}
							arr[4] = attIdMap;
							arr[5] = attNamMap;
							arr[6] = DW_ATT_FROM_PROCESS_FORM; //De donde proviente el atributo (-2:Dato basico Entidad, -1:Dato basico Proceso, 1:Formulario de entidad, 2:Formulario de proceso o Redundante)
							
							//alert("attId:"+attId+", attName:" + attNom + ", attLbl:"+ attLbl+", attType:"+attType+", attMapEntId:"+attIdMap+", attMapEntName:"+attNamMap);
						}else{
							arr[0] = attId; //Ponemos la palabra que indica que se debe hacer skip
							arr[1] = attNom; //si se debe hacer skip, en attNom tenemos el attId (hecho asi por si existe un att llamado skip)
						}						
						result[result.length] = arr;
					  }
					  
					}
			  }else {
		         return "NOK";
		      }
			}else{
		          return "Could not contact the server.";  
			}
		}
	} 
	return result;
}

function enableConfirm() {
	var oRows = document.getElementById("gridForms").selectedItems;
	document.getElementById("btnConf").disabled = (oRows == null) || (oRows.length == 0);
}

function btnExit_click() {
	window.returnValue=null;
	window.close();
}

</script>