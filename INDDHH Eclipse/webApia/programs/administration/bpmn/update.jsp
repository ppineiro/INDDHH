<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.ProDefinitionVo"%><%@include file="../../../components/scripts/server/startInc.jsp" %><%@page import="com.dogma.bi.BIEngine"%><%@page import="com.dogma.bean.ExternalGenerator"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.bean.administration.BPMNBean"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body onload="fnOnLoad()"><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.BPMNBean"></jsp:useBean><%
ProDefinitionVo proVo = dBean.getProcessVo();
boolean locked = (proVo.getProLockUser()!=null && !"".equals(proVo.getProLockUser())); //Si no es null y no es "" --> esta bloqueado
boolean lockedByMe = (locked && proVo.getProLockUser().equals(dBean.getActualUser(request)));//false
boolean onCreate = (proVo==null || proVo.getProId()==null);
boolean saveChangesBlock = (onCreate || lockedByMe); //si se esta creando o esta bloqueado por mi podemos guardar
boolean saveChangesRW = (proVo.getProId()==null)?true:dBean.hasWritePermission(request, proVo.getProId(), proVo.getPrjId(), dBean.getActualUser(request));
boolean showExitAlert = (onCreate || lockedByMe);
String attIdsStr = dBean.getSelDimAttIds(); //Devuelve string de attId's seleccionados como dimension (pertenecientes a datos del proc, ent o atts redundantes). Utilizado para las consultas analiticas
String attEntIdsStr = dBean.getSelDimEntAttIds(); //Devuelve string de attId's (pertenecientes a formularios de entidad) seleccionados como dimension. Utilizado para las consultas analiticas
String attProIdsStr = dBean.getSelDimProAttIds(); //Devuelve string de attId's (pertenecientes a formularios de proceso) seleccionados como dimension. Utilizado para las consultas analiticas
String attMsrIdsStr = dBean.getSelMsrAttIds(); //Devuelve string de attId's seleccionados como medidas(pertenecientes a datos del proc, ent o atts redundantes). Utilizado para las consultas analiticas
String attEntMsrIds = dBean.getSelEntMsrAttIds(); //Devuelve string de attId's (pertenecientes a formularios de entidad) seleccionados como medidas. Utilizado para las consultas analiticas
String attProMsrIds = dBean.getSelProMsrAttIds(); //Devuelve string de attId's (pertenecientes a formularios de proceso) seleccionados como medidas. Utilizado para las consultas analiticas
boolean mustRebuild = dBean.isCubeInconsistency(request); //Indica si el cubo contiene una inconsistencia y debe ser eliminado y vuelto a crear
boolean hasProject = (proVo.getPrjId() != null && proVo.getPrjId().intValue() != 0);
boolean saveChanges = false;
if (saveChangesRW){
	saveChanges = saveChangesBlock;
}
HashMap attributes = new HashMap();
if (proVo.getProAttributes() != null) {
	Iterator iterator = proVo.getProAttributes().iterator();
	while (iterator.hasNext()) {
		AttributeVo attribute = (AttributeVo) iterator.next();
		if (attribute != null) {
			attributes.put(attribute.getAttId(),attribute);
		}
	}
}
AttributeVo attribute = null;
boolean envUsesHierarchy = "true".equals(EnvParameters.getEnvParameter(dBean.getEnvId(request), EnvParameters.ENV_USES_HIERARCHY));
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titBPMN")%><%if (dBean.getOperationType() == com.dogma.bean.administration.BPMNBean.OP_TYPE_VIEW_PRO) { %>
				(View Process)
			<%} else if (dBean.getOperationType() == com.dogma.bean.administration.BPMNBean.OP_TYPE_VERSION) { %>
				(View Version)
			<%}%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><div type="tabElement" id="samplesTab" ontabswitch="tabSwitch()" <%=(request.getParameter("defaultTab")!=null?(" defaultTab='"+request.getParameter("defaultTab").toString()+"'"):"" )%>><% if (dBean.getOperationType() == BPMNBean.OP_TYPE_DEBUG_PRO) { %><%@include file="updateGeneric.jsp" %><%@include file="updateDebugger.jsp" %><% } else { %><%@include file="updateGeneric.jsp" %><%@include file="updateAttribute.jsp" %><%@include file="updateMap.jsp" %><%@include file="updateAction.jsp" %><%@include file="updateDocument.jsp" %><%@include file="updateMonitor.jsp" %><%//@include file="updateDocumentation.jsp" %><%@include file="updatePermissions.jsp" %><%@include file="updateBi.jsp" %><% } %></div></FORM></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><% if (dBean.getOperationType() != BPMNBean.OP_TYPE_DEBUG_PRO) { %><%if (dBean.getOperationType() == com.dogma.bean.administration.BPMNBean.OP_TYPE_VERSION) { %><TD align="left"><button type="button" onClick="showFlashInput()">XML Input</button></TD><TD align="right"><button type="button" id="btnBack" onClick="btnBackVer_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><%} else if (dBean.getOperationType() == com.dogma.bean.administration.BPMNBean.OP_TYPE_VIEW_PRO) {%><TD align="left"><button type="button" onClick="showFlashInput()">XML Input</button></TD><TD align="right"><button type="button" id="btnBack" onClick="btnBackPro_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><%} else {%><TD align="left"><!-- 
						<button type="button" onClick="importXPDL()">XML Input</button><button type="button" onClick="exportXPDL()">XML Output</button><button type="button" onClick="actionAfterFlash='validar';getFlashOutput()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVal")%></button>
					--></TD><TD align="right"><!-- <button type="button" id="btnGenDoc" disabled onClick="btnDoc()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnGenProDoc")%>" title="<%=LabelManager.getToolTip(labelSet,"btnGenProDoc")%>"><%=LabelManager.getNameWAccess(labelSet,"btnGenProDoc")%></button>  --><button type="button" <%=(!saveChanges)?"disabled":"" %> onClick="actionAfterFlash='confirmar';getFlashOutput()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onClick="btnBack_click('<%=showExitAlert%>')" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><%}%><% } else {%><TD align="right"><button type="button" onClick="btnBack_click('<%=showExitAlert%>')" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><% } %><button type="button" id="btnRtf" disabled="true" onClick="btnRTF_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnRTF")%>" title="<%=LabelManager.getToolTip(labelSet,"btnRTF")%>"><%=LabelManager.getNameWAccess(labelSet,"btnRTF")%></button><button type="button" id="btnSalir" onClick="btnExit_click('<%=showExitAlert%>')" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><SCRIPT>
var WARN_USER_NOT_IN_POOLS = "<%=LabelManager.getName(labelSet,"msgWarnUserNotInPools")%>";
var TYPE_NUMERIC = "<%= AttributeVo.TYPE_NUMERIC %>";
var TYPE_DATE = "<%= AttributeVo.TYPE_DATE %>";
var TYPE_STRING = "<%= AttributeVo.TYPE_STRING %>";
var USRCREATION_FORM_ID = "<%= FormVo.USRCREATION_FORM_ID %>";
var VERSION_ON_SAVE = "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"msgProSavVersion"))%>";
var CONFIRM_PRINT = "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"msgProConfPrint"))%>";
var MSG_ALR_EXI_MEAS = "<%=LabelManager.getName(labelSet,"msgAlrExiMeas") %>";
var MSG_ALR_EXI_DIM = "<%=LabelManager.getName(labelSet,"msgAlrExiDim") %>";
var LBL_SEL_ATTRIBUTE = "<%=LabelManager.getName(labelSet,"lblSelAttribute")%>";
var LBL_SEL_PRO_PROPERTY = "<%=LabelManager.getName(labelSet,"lblSelProProperty")%>";
var MSG_MUST_ASOC_ATT_FIRST = "<%=LabelManager.getName(labelSet,"msgProcMustAsocAttFirst") %>";
var envId = "<%=dBean.getEnvId(request)%>";
var LBL_SEL_MAP_ENTITY = "<%=LabelManager.getName(labelSet,"lblCliSelMapEntity")%>";
var MAP_ENTITY = "<%=LabelManager.getName(labelSet,"lblMapEntity")%>";
var MSG_MUST_SEL_MEAS_FIRST = "<%=LabelManager.getName(labelSet,"msgMustSelMeasFirst") %>";
var LBL_DEL_MAP_ENTITY = "<%=LabelManager.getName(labelSet, "lblDelMapEntity")%>";
var LBL_YEAR = "<%=LabelManager.getName(labelSet,"lblYear") %>";
var LBL_SEMESTER = "<%=LabelManager.getName(labelSet,"lblSem") %>";
var LBL_TRIMESTER = "<%=LabelManager.getName(labelSet,"lblTrim") %>";
var LBL_MONTH = "<%=LabelManager.getName(labelSet,"lblMonth") %>";
var MSG_MUST_SEL_DIM_FIRST = "<%=LabelManager.getName(labelSet,"msgMustSelDimFirst") %>";
var LBL_WEEKDAY = "<%=LabelManager.getName(labelSet,"lblWeeDay") %>";
var LBL_DAY = "<%=LabelManager.getName(labelSet,"lblBIDay") %>";
var LBL_HOUR = "<%=LabelManager.getName(labelSet,"lblBIHour") %>";
var LBL_MINUTE = "<%=LabelManager.getName(labelSet,"lblMinute") %>";
var MSG_VWS_WILL_BE_LOST = "<%=LabelManager.getName(labelSet,"msgViewsWillBeLost") %>";
var LBL_SECOND = "<%=LabelManager.getName(labelSet,"lblSecond") %>";
var LBL_MEAS_STANDARD = "<%=LabelManager.getName(labelSet,"lblMeasStandard")%>";
var LBL_MEAS_CALCULATED = "<%=LabelManager.getName(labelSet,"lblMeasCalculated")%>";
var MSG_DELETE_CUBE_CONFIRM = "<%=LabelManager.getName(labelSet,"msgDelCbeConfirm") %>";
var MSG_ATT_IN_USE = "<%=LabelManager.getName(labelSet,"msgAttInUse")%>";
var MSG_CBE_IN_USE_BY_WIDGET = "<%=LabelManager.getName(labelSet,"msgCbeInUseByWidget")%>";
var MSG_CBE_IN_USE_BY_CUBE = "<%=LabelManager.getName(labelSet,"msgCbeInUseByCube")%>";
var PRO_CREATE_DATE = "101";
var PRO_CONSEC_DAYS = "102";
var PRO_END_REMAIN = "103";
var PRO_EST_ALARM_REMAIN = "104";
var PRO_CREATE_GROUP = "105";
var PRO_CREATE_USER = "106";
var PRO_DELAY_STATUS = "107";
var PRO_PRIORITY = "108";
var PRO_STATUS = "109";
var DW_ATT_FROM_ENTITY_BASIC_DATA = "<%=ProcessDwColumnVo.DW_ATT_FROM_ENTITY_BASIC_DATA%>";
var DW_ATT_FROM_PROCESS_BASIC_DATA = "<%=ProcessDwColumnVo.DW_ATT_FROM_PROCESS_BASIC_DATA%>";
var DW_ATT_FROM_ENTITY_FORM = "<%=ProcessDwColumnVo.DW_ATT_FROM_ENTITY_FORM%>";
var DW_ATT_FROM_PROCESS_FORM = "<%=ProcessDwColumnVo.DW_ATT_FROM_PROCESS_FORM%>";
var DW_ATT_FROM_PROCESS = "<%=ProcessDwColumnVo.DW_ATT_FROM_PROCESS%>";
var MSG_MUST_ENT_CBE_NAME = "<%=LabelManager.getName(labelSet,"msgMustEntCbeName")%>";
var MSG_MUST_ENT_ONE_DIM = "<%=LabelManager.getName(labelSet,"msgMustEntOneDimension")%>";
var MSG_MUST_ENTER_FORMULA = "<%=LabelManager.getName(labelSet,"msgMustEntFormula")%>";
var MSG_MIS_DIM_ATT = "<%=LabelManager.getName(labelSet,"msgMisDimAttribute")%>";
var MSG_WRG_DIM_NAME = "<%=LabelManager.getName(labelSet,"msgWrgDimName")%>";
var MSG_AT_LEAST_ONE_DIM_MUST_USE_ATT = "<%=LabelManager.getName(labelSet,"msgAtLeastOneDimMusUseAtt")%>";
var MSG_MUST_ENT_ONE_MEAS = "<%=LabelManager.getName(labelSet,"msgMustEntOneMeasure")%>";
var MSG_WRG_MEA_NAME = "<%=LabelManager.getName(labelSet,"msgWrgMeaName")%>";
var MSG_MIS_MEA_ATT = "<%=LabelManager.getName(labelSet,"msgMisMeaAttribute")%>";
var MSG_ATLEAST_ONE_MEAS_VISIBLE = "<%=LabelManager.getName(labelSet,"msgAtLeastOneMeasVisible")%>";
var MSG_MUST_ENT_ONE_PRF = "<%=LabelManager.getName(labelSet,"msgMustEntOneProfile")%>";
var MSG_DUE_TO_BI_UPD_CBE_MUST_BE_REGEN = "<%=LabelManager.getName(labelSet,"msgDueToBiUpdProCbeMstBeRegen")%>";
var MSG_PRO_LCK_BY_OTH_USER = "<%=LabelManager.getName(labelSet,"msgProLockedByOthUser")%>";
var MSG_PRO_PERMISSIONS_ERROR = "<%=LabelManager.getName(labelSet,"msgProcPermError")%>";
var MSG_DIM_NAME_UNIQUE = "<%=LabelManager.getName(labelSet,"msgDimNameUnique")%>";
var MSG_MEASURE_NAME_UNIQUE = "<%=LabelManager.getName(labelSet,"msgMeasureNameUnique")%>";
var MSG_MEAS_OP1_NAME_INVALID = "<%=LabelManager.getName(labelSet,"msgMeasOp1NameInvalid")%>";
var MSG_MEAS_OP2_NAME_INVALID = "<%=LabelManager.getName(labelSet,"msgMeasOp2NameInvalid")%>";
var MSG_MEAS_NAME_LOOP_INVALID = "<%=LabelManager.getName(labelSet,"msgMeasNameLoopInvalid")%>";
var MSG_CUBE_NAME_ALREADY_EXIST = "<%=LabelManager.getName(labelSet,"msgCubExi")%>";
var MSG_CUBE_NAME_INVALID = "<%=LabelManager.getName(labelSet,"msgCbeNamInv")%>";
var MSG_PERMISSIONS_ERROR = "<%=LabelManager.getName(labelSet,"msgPermError")%>";
var MSG_MUST_SEL_ONE = "<%=LabelManager.getName(labelSet,"msgDebSelUno")%>";
var MSG_PERM_WILL_BE_LOST = "<%=LabelManager.getName(labelSet,"msgPermDefWillBeLost")%>";
var MSG_USE_PROY_PERMS = "<%=LabelManager.getName(labelSet,"msgUseProyPerms")%>";
var LBL_SEL_DIM_TO_DENIE_ACCESS = "<%=LabelManager.getName(labelSet, "lblCliSelDimension")%>";
var MSG_PRF_NO_ACC_DELETED = "<%=LabelManager.getName(labelSet,"msgPrfNoAccDeleted")%>";
var MSG_PRFS_NO_ACC_DELETED = "<%=LabelManager.getName(labelSet,"msgPrfsNoAccDeleted")%>";
var MSG_CBE_NAME_MISS = "<%=LabelManager.getName(labelSet,"msgCbeNameMiss")%>";
var LBL_CLI_TO_PROPS = "<%=LabelManager.getName(labelSet,"lblCliToProps")%>";
var LBL_TOD = "<%=LabelManager.getName(labelSet,"lblTod")%>";
var DO_ACTION_CONFIRM = "<%=dBean.DO_ACTION_CONFIRM%>";
var DO_ACTION_SAVE = "<%=dBean.DO_ACTION_SAVE%>";

<%if (proVo != null && proVo.getCubeId()!=null){%>
CANT_VIEWS = "<%=dBean.getCubeViewsList(proVo.getCubeId()).size()%>";
<%}else{%>
CANT_VIEWS = 0;
<%}%>

var viewsWithError = <%=dBean.isViewsWithErrors()%>;
var errorViews = "<%=dBean.getErrorViews()%>";
var msgVwWithError = "<%=LabelManager.getName(labelSet,"msgVwWillBeDeleted")%>";

</script><script src="<%=Parameters.ROOT_PATH%>/programs/administration/bpmn/process.js"></script><script src="<%=Parameters.ROOT_PATH%>/programs/administration/bpmn/flash.js"></script><script src="<%=Parameters.ROOT_PATH%>/programs/administration/bpmn/cubes.js"></script><script language="javascript">

function fnOnLoad(){
	var mustRebuild = "<%=mustRebuild%>"; //Indicates if the cube must be rebuild
	if ("true" == mustRebuild){
		alert(MSG_DUE_TO_BI_UPD_CBE_MUST_BE_REGEN);
	}
}

function showContent(contentNumber){
	if(document.getElementById("content"+contentNumber).style.display!="block"){
		if(navigator.userAgent.indexOf("MSIE")<0){
			if(contentNumber!=1 && flashLoaded && document.getElementById("content1").style.display=="block"){
				listener.contentNumber=contentNumber;
				hideFlash();
			}else{
				hideAllContents();
				document.getElementById("tab"+contentNumber).parentNode.className="here";
				document.getElementById("content"+contentNumber).style.display="block";
				var container=window.parent.document.getElementById(window.name);
				if(container){
					container.style.display="none";
					container.style.display="block";
				}
			}
		}else{
			hideAllContents();
			document.getElementById("tab"+contentNumber).parentNode.className="here";
			document.getElementById("content"+contentNumber).style.display="block";
		}
	}
}
function hideAllContents(){
	for(var i=0;i<5;i++){
		document.getElementById("tab"+i).parentNode.className="";
		document.getElementById("content"+i).style.display="none";
	}
}
</script><SCRIPT defer="true">

function changeIdePos(val) {
	document.getElementById("txtIdePos").disabled = val; 
	if (val) {
		unsetRequiredField(document.getElementById("txtIdePos"));
		//document.getElementById("txtIdePos").p_required = 'false';
	} else {
		setRequiredField(document.getElementById("txtIdePos"));
		//document.getElementById("txtIdePos").p_required = 'true';
	}
}

function changeIdePre(val) {
	document.getElementById("txtIdePre").disabled = val; 
	if (val) {
		unsetRequiredField(document.getElementById("txtIdePre"));
		//document.getElementById("txtIdePre").p_required = 'false';
	} else {
		setRequiredField(document.getElementById("txtIdePre"));
		//document.getElementById("txtIdePre").p_required = 'true';
	}
}

<%if (dBean.getOperationType() == com.dogma.bean.administration.BPMNBean.OP_TYPE_VERSION ||
	  dBean.getOperationType() == com.dogma.bean.administration.BPMNBean.OP_TYPE_VIEW_PRO) { %>
	function disableAll(){
		var ele;
		for (i=0;i<document.getElementsByTagName("*").length;i++) {
			ele = document.getElementsByTagName("*")[i];
			if (ele.tagName == "INPUT" || ele.tagName == "SELECT" || ele.tagName == "TEXTAREA" || ele.tagName == "BUTTON") {
				if (ele.tagName == "TEXTAREA" || ele.tagName == "SELECT" || (ele.tagName == "INPUT" && ele.type=="text")) {
					ele.style.backgroundColor="gainsboro";
				}
				if (ele.id != "btnBack" && ele.id != "btnSalir") {
					ele.disabled="true";	
				}
			}
		}
	}
	if (document.addEventListener) {
  	  document.addEventListener("DOMContentLoaded", disableAll, false);
	}else{
		disableAll();
	}
<%}%></SCRIPT><script language="javascript">

var IS_BPMN=<%=(request.getParameter("bpmn")!=null)?request.getParameter("bpmn"):"false"%>;
function chkReaGruFun(){
	if (document.getElementById("reaGroups").disabled){
		document.getElementById("reaGroups").disabled = false;
	}else{
		document.getElementById("reaGroups").disabled = true;
	}
}
var dependencies=false; //usado para que al presionar volver o salir pregunte si desea perder los datos ingresados (si no estamos en dependencies debe preguntar)
var newProcess = <%=proVo.getProId()==null%>;

function tabSwitch(){
	var btnRtf=document.getElementById("btnRtf");
	var shownIndex=document.getElementById("samplesTab").shownIndex;
	if(btnRtf){
		if(shownIndex==2){
			btnRtf.disabled=false;
		}else{
			btnRtf.disabled=true;
		}
	}
}
</script>

		