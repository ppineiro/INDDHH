<%@page import="com.dogma.vo.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.bean.administration.TaskSchedulerBean"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body onload="setNumericFields()"><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.TaskSchedulerBean"></jsp:useBean><%
TaskSchedulerVo tskSchVo = dBean.getTskSchVo();
String actualUser = dBean.getActualUser(request);
boolean saveChanges = (tskSchVo.getTskSchId()==null)?true:dBean.checkUserPerm(request, tskSchVo.getTskSchId(), TskSchPrivilegeVo.FLAG_MODIFY);
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titTskScheduler")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><div type ="tabElement" id="samplesTab" ontabswitch="tabSwitch()" <%=(request.getParameter("defaultTab")!=null?(" defaultTab='"+request.getParameter("defaultTab").toString()+"'"):"" )%>><%@include file="updateGenData.jsp" %><%@include file="updateAtts.jsp" %><%@include file="updateProps.jsp" %><%@include file="updatePrivileges.jsp" %></div></FORM></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConf()" <%=(!saveChanges)?"disabled":"" %> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script src="<%=Parameters.ROOT_PATH%>/programs/administration/tskScheduler/update.js"></script><script src="<%=Parameters.ROOT_PATH%>/programs/administration/tskScheduler/updateGenData.js"></script><script src="<%=Parameters.ROOT_PATH%>/programs/administration/tskScheduler/updatePrivileges.js"></script><script src="<%=Parameters.ROOT_PATH%>/programs/administration/tskScheduler/updateAtts.js"></script><script src="<%=Parameters.ROOT_PATH%>/programs/administration/tskScheduler/updateProps.js"></script><SCRIPT>
var MSG_MST_SEL_TEM_TO_ERASE = "<%=LabelManager.getName(labelSet,"msgMstSelTemToErase")%>";
var MSG_DEL_SEL_TEMPLATE = "<%=LabelManager.getName(labelSet,"msgDelTemplate")%>";
var MSG_TEMPLATE_SAVED = "<%=LabelManager.getName(labelSet,"msgTemplateSaved")%>";
var MSG_TEMP_ALR_EXISTS = "<%=LabelManager.getName(labelSet, "msgTempNameAlrExists")%>";
var MSG_LOAD_TEMPLATE = "<%=LabelManager.getName(labelSet, "msgLoadTemplate")%>";
var MSG_SAVE_FOR_ALL_MONTH = "<%=LabelManager.getName(labelSet, "msgSaveForAllMonth")%>";
var MSG_SAVE_FOR_ALL_YEAR = "<%=LabelManager.getName(labelSet, "msgSaveForAllYear")%>";
var MSG_SAVE_FOR_X_MONTH = "<%=LabelManager.getName(labelSet, "msgSaveForXMonths")%>";
var MSG_X_MONTH_MISSING = "<%=LabelManager.getName(labelSet, "msgXMonthMissing")%>";
var MSG_OP_OK = "<%=LabelManager.getName(labelSet, "msgOpOk")%>";
var MSG_DEL_ACTUAL_SCHED = "<%=LabelManager.getName(labelSet, "msgDelActualSched")%>";
var LBL_PERM_READ = "<%=LabelManager.getName(labelSet, "lblPerVer")%>";
var LBL_PERM_UPDATE = "<%=LabelManager.getName(labelSet, "lblPerMod")%>";
var LBL_PERM_QUERY = "<%=LabelManager.getName(labelSet, "lblPerCon")%>";
var LBL_PERM_REGEN = "<%=LabelManager.getName(labelSet, "lblPerReg")%>";
var ATT_TYPE_ENTITY = "<%=TskSchAttributeVo.ATT_TYPE_ENTITY%>";
var ATT_TYPE_PROCESS = "<%=TskSchAttributeVo.ATT_TYPE_PROCESS%>";
var ATT_TYPE_BOTH = "<%=TskSchAttributeVo.ATT_TYPE_BOTH%>";
var LBL_ATT_TYPE_ENTITY = "<%=LabelManager.getName(labelSet,"lblEnt")%>"; 
var LBL_ATT_TYPE_PROCESS = "<%=LabelManager.getName(labelSet,"lblPro")%>";
var LBL_ATT_TYPE_BOTH = "<%=LabelManager.getName(labelSet,"lblAmbos")%>";
var MSG_EMAILS_ERROR = "<%=LabelManager.getName(labelSet,"msgSchEmailsError")%>";
var MSG_SCH_PRIV_ERROR = "<%=LabelManager.getName(labelSet,"msgSchPrivError")%>";
var MSG_SCH_DEF_OVR_ASGN_ERROR = "<%=LabelManager.getName(labelSet,"msgSchDefOvrasgnError")%>"; 
var MSG_PERMISSIONS_ERROR = "<%=LabelManager.getName(labelSet,"msgPermError")%>";
var MSG_USE_PROY_PERMS = "<%=LabelManager.getName(labelSet,"msgUseProyReadModPerms")%>";
var MSG_PERM_WILL_BE_LOST = "<%=LabelManager.getName(labelSet,"msgPermDefWillBeLost")%>";
var MSG_PERM_READ_MOD_WILL_BE_LOST = "<%=LabelManager.getName(labelSet,"msgPermReadModWillBeLost")%>";
var MSG_ACT_PREV_WARNING = "<%=LabelManager.getName(labelSet,"msgTskSchActPrevWarning")%>";
</SCRIPT>
		