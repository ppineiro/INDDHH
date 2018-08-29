<%@page import="com.dogma.vo.filter.IQueryFilter"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.*"%><%@page import="com.dogma.business.*"%><%@page import="com.dogma.bean.scheduler.SchedulerBean"%><%@page import="com.dogma.dao.DataBaseDAO"%><%@page import="java.util.*"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.util.QueryUtil"%><%@page import="com.dogma.business.querys.factory.*" %><%@page import="com.dogma.bean.ExternalGenerator" %><%@include file="../../../components/scripts/server/startInc.jsp" %><%@page import="com.dogma.Configuration"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body onLoad="doOnLoad();"><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.query.AdministrationBean"></jsp:useBean><%
QueryVo queryVo = dBean.getQueryVo();
String actualUser = dBean.getActualUser(request);
boolean saveChanges = (queryVo.getQryId()==null)?true:dBean.hasWritePermission(request, queryVo.getQryId(), queryVo.getPrjId(), actualUser);
boolean usePrjPerms1 = "true".equals(request.getParameter("usePrjPerms"));

String qryTypeLabel = "";
try {
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titQry")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><IFRAME id="frmSubmit" name="frmSubmit" style="display:none"></IFRAME><div type="tabElement" id="samplesTab" ontabswitched="tabSwitch()"><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabDatGen")%>" tabText="<%=LabelManager.getName(labelSet,"tabDatGen")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtQryData")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><!-- PROYECTOS --><%Collection colProj = dBean.getProjects(request);
   							boolean hasProject = (queryVo.getPrjId() != null && queryVo.getPrjId().intValue() != 0);%><td title="<%=LabelManager.getToolTip(labelSet,"titPrj")%>"><%=LabelManager.getNameWAccess(labelSet,"titPrj")%>:</td><td colspan=2><input type=hidden name="txtPrj" value=""><select name="selPrj" onchange="cmbProySel()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblPrj")%>"><%if (colProj != null && colProj.size()>0) {
				   					Iterator itPrj = colProj.iterator();
					   					ProjectVo prjVo = null;%><option value="0"></option><%while (itPrj.hasNext()) {
		   								prjVo = (ProjectVo) itPrj.next();%><option value="<%=prjVo.getPrjId()%>"
		   								<% if (hasProject) {
											if (prjVo.getPrjId().equals(queryVo.getPrjId())) {
												out.print ("selected");
											}
										} %>
										><%=prjVo.getPrjName()%></option><%}
		   						} %></select></td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td><input p_required=true name="txtName" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>" type="text" value="<%=dBean.fmtStr(queryVo.getQryName())%>"></td><td title="<%=LabelManager.getToolTip(labelSet,"lblTit")%>"><%=LabelManager.getNameWAccess(labelSet,"lblTit")%>:</td><td><input p_required=true name="txtTitle" maxlength="255" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTit")%>" type="text" value="<%=dBean.fmtStr(queryVo.getQryTitle())%>"></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDes")%>:</td><td colspan="3"><input name="txtDesc" maxlength="255" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDes")%>" type="text" value="<%=dBean.fmtStr(queryVo.getQryDesc())%>" size="80"></td></tr><tr><%
				   			if (QueryVo.SOURCE_BUS_CLASS.equals(queryVo.getSource())) { %><td title="<%=LabelManager.getToolTip(labelSet,"lblBusClass")%>"><%=LabelManager.getName(labelSet,"lblBusClass")%>:</td><%
					   		} else if (QueryVo.SOURCE_CONNECTION.equals(queryVo.getSource())) { %><td title="<%=LabelManager.getToolTip(labelSet,"lblQryView")%>"><%=LabelManager.getName(labelSet,"lblQryView")%>:</td><%
					   		} else { %><td></td><%
					   		} %><td><%
				   				String name = null;
				   				if (QueryVo.SOURCE_BUS_CLASS.equals(queryVo.getSource())) {
				   					name = queryVo.getQryViewName();
				   				} else {
			   						name = queryVo.getQryViewName().toUpperCase(); 
									if (DataBaseService.VIEW_GEN_BUSINESS.equals(queryVo.getQryViewName())) {
			   							name = DataBaseService.VIEW_NAME_GEN_BUSINESS;
			   						} else if (DataBaseService.VIEW_GEN_ENTITY.equals(queryVo.getQryViewName())) {
			   							name = DataBaseService.VIEW_NAME_GEN_ENTITY;
			   						} else if (DataBaseService.VIEW_GEN_PROCESS.equals(queryVo.getQryViewName())) {
			   							name = DataBaseService.VIEW_NAME_GEN_PROCESS;
			   						} else if (DataBaseService.VIEW_GEN_TASK_LIST.equals(queryVo.getQryViewName())) {
			   							name = DataBaseService.VIEW_NAME_GEN_TASK;
			   						} else if (DataBaseService.VIEW_GEN_TSK_LIST_R.equals(queryVo.getQryViewName())) {
			   							name = DataBaseService.VIEW_NAME_GEN_TSK_READY;
			   						} else if (DataBaseService.VIEW_GEN_TSK_LIST_A.equals(queryVo.getQryViewName())) {
			   							name = DataBaseService.VIEW_NAME_GEN_TSK_ACQ;
			   						} else if (DataBaseService.VIEW_GEN_TSK_MON.equals(queryVo.getQryViewName())) {
			   							name = DataBaseService.VIEW_NAME_GEN_TSK_MON;
			   						} else if (DataBaseService.VIEW_GEN_PRO_MON.equals(queryVo.getQryViewName())) {
			   							name = DataBaseService.VIEW_NAME_GEN_PRO_MON;
			   						} else {
			   							name = queryVo.getQryViewName();
			   						} 
			   					} %><%=dBean.fmtHTML(name)%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblQryType")%>"><%=LabelManager.getName(labelSet,"lblQryType")%>:</td><td><% 
			   					boolean showExternalUrl = false;
			   					if (QueryVo.TYPE_ENTITY.equals(queryVo.getQryType())) {
			   						qryTypeLabel = "lblQryTypEnt";
								} else if (QueryVo.TYPE_ENTITY_AUTOMATIC.equals(queryVo.getQryType())) {
									qryTypeLabel = "lblQryTypModAuto";
								} else if (QueryVo.TYPE_MODAL.equals(queryVo.getQryType())) {
									qryTypeLabel = "lblQryTypMod";
								} else if (QueryVo.TYPE_TASK_LIST.equals(queryVo.getQryType())) {
									qryTypeLabel = "lblQryTypTas";
								} else if (QueryVo.TYPE_QUERY.equals(queryVo.getQryType())) {
									qryTypeLabel = "lblQryTypQry";
									showExternalUrl = true;
								} else if (QueryVo.TYPE_OFF_LINE.equals(queryVo.getQryType())) {
									qryTypeLabel = "lblQryTypOff";
								} else if (QueryVo.TYPE_ENTITY_MODAL.equals(queryVo.getQryType())) {
									qryTypeLabel = "lblQryTypEntMod";
								} else if (QueryVo.TYPE_PROCESS_MONITOR.equals(queryVo.getQryType())) {
									qryTypeLabel = "lblQryTypProMon";
								} else if (QueryVo.TYPE_TASK_MONITOR.equals(queryVo.getQryType())) {
									qryTypeLabel = "lblQryTypTskMon";
								} else if (QueryVo.TYPE_PRO_CANCEL.equals(queryVo.getQryType())) {
									qryTypeLabel = "lblQryTypProCancel";
								} else if (QueryVo.TYPE_PRO_ALTER.equals(queryVo.getQryType())){
									qryTypeLabel = "lblQryTypProAlter";

								} else if (QueryVo.TYPE_MON_BUS_ELE_RELATED.equals(queryVo.getQryType())){
									qryTypeLabel = "lblQryTypMonBusEleRel";
								} else if (QueryVo.TYPE_MON_BUS_ELE_PROPERTIES.equals(queryVo.getQryType())){
									qryTypeLabel = "lblQryMonBusElePrp";
								} else if (QueryVo.TYPE_MON_BUS_ELE_DEP_PROPERTIES.equals(queryVo.getQryType())){
									qryTypeLabel = "lblQryMonBusEleDepPrp";
								} else if (QueryVo.TYPE_MON_BUS_ELE_INSTANCES.equals(queryVo.getQryType())){
									qryTypeLabel = "lblQryMonBusEleInstances";
								} else if (QueryVo.TYPE_MON_ENTITY.equals(queryVo.getQryType())){
									qryTypeLabel = "lblQryMonBusEntity";
								}
								out.print(LabelManager.getName(labelSet,qryTypeLabel));
								%><input id="selQryTyp" name="selQryTyp" type="hidden" value="<%=dBean.fmtStr(queryVo.getQryType())%>"></td></tr><% if (showExternalUrl) { %><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblExternalUrlAccess")%>"><%=LabelManager.getNameWAccess(labelSet,"lblExternalUrlAccess")%>:</td><td colspan="3"><%= ExternalGenerator.generateQueryUrl(request, queryVo.getQryId())%></td></tr><% } %><tr><input type="hidden" name="hidUsrCanWrite" value="<%=saveChanges%>"><input type="hidden" name="hidUsePrjPerms" value=""></tr></table><%@include file="updateDataShow.jsp" %></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabQryWhere")%>" tabText="<%=LabelManager.getName(labelSet,"tabQryWhere")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtQryData")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><%
				   			if (QueryVo.SOURCE_BUS_CLASS.equals(queryVo.getSource())) { %><td title="<%=LabelManager.getToolTip(labelSet,"lblBusClass")%>"><%=LabelManager.getName(labelSet,"lblBusClass")%>:</td><%
					   		} else if (QueryVo.SOURCE_CONNECTION.equals(queryVo.getSource())) { %><td title="<%=LabelManager.getToolTip(labelSet,"lblQryView")%>"><%=LabelManager.getName(labelSet,"lblQryView")%>:</td><%
					   		} else { %><td></td><%
					   		} %><td><%=dBean.fmtHTML(name)%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblQryType")%>"><%=LabelManager.getName(labelSet,"lblQryType")%>:</td><td><% out.print(LabelManager.getName(labelSet,qryTypeLabel)); %></td></tr></table><%@include file="updateDataWhere.jsp" %></div><% if (! QueryVo.TYPE_OFF_LINE.equals(queryVo.getQryType())) { %><%@include file="updateDataWhereUser.jsp" %><% } %><%@include file="updateDataScheduler.jsp" %><% if (! QueryVo.TYPE_OFF_LINE.equals(queryVo.getQryType()) && ! QueryVo.TYPE_ENTITY_MODAL.equals(queryVo.getQryType()) && ! QueryVo.TYPE_MODAL.equals(queryVo.getQryType())
						&& ! QueryVo.TYPE_MON_BUS_ELE_RELATED.equals(queryVo.getQryType()) && ! QueryVo.TYPE_MON_BUS_ELE_PROPERTIES.equals(queryVo.getQryType()) 
						&& ! QueryVo.TYPE_MON_BUS_ELE_DEP_PROPERTIES.equals(queryVo.getQryType()) && ! QueryVo.TYPE_MON_BUS_ELE_INSTANCES.equals(queryVo.getQryType()) 
						&& ! QueryVo.TYPE_MON_ENTITY.equals(queryVo.getQryType())) { %><%@include file="updateDataButtons.jsp" %><% } %><%@include file="updateDataActions.jsp" %><%@include file="updateDataEvents.jsp" %><%@include file="updateDataWebService.jsp" %><%@include file="updateDataAttRemaping.jsp" %><% if (QueryVo.TYPE_QUERY.equals(queryVo.getQryType())) { %><%@include file="updateDataCharts.jsp" %><% } %><%@include file="updatePermissions.jsp" %></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><% if (! QueryVo.TYPE_ENTITY_MODAL.equals(queryVo.getQryType())) { %><button type="button" onclick="btnAnt_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAnt")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAnt")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAnt")%></button><% } %><% if (queryVo.isFreeSQL()) { %><button type="button" onclick="btnTest_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnTest")%>" title="<%=LabelManager.getToolTip(labelSet,"btnTest")%>"><%=LabelManager.getNameWAccess(labelSet,"btnTest")%></button><% } %><button type="button" onclick="btnConfData2_click()" <%=(!saveChanges)?"disabled":"" %> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/query/administration/update.js'></script><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/query/administration/updateWhereColumns.js'></script><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/query/administration/updateWhereUserColumns.js'></script><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/query/administration/updateActionQuery.js'></script><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/query/administration/updateCharts.js'></script><script language="javascript" defer>

var pMask = "<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>";

<% String[] attIdsString = QueryUtil.getAttIdsString(queryVo); %>
var attAdded  = new Array(<%=attIdsString[0]%>);
var attCount  = new Array(<%=attIdsString[1]%>);
var attInsert = <%= queryVo.getAttShowColumns().size() %>;

var notAllowed = new Array(<%= QueryColumns.getInstance().getNotAllowedColumns(queryVo) %>);

var addEntAttOpt = <%= queryVo.getFlagValue(QueryVo.FLAG_ENT_ATTRIBUTES) %> ;
var addProAttOpt = <%= queryVo.getFlagValue(QueryVo.FLAG_PRO_ATTRIBUTES) %>;

MSG_QRY_MAX_ATT 		= "<%=LabelManager.getName(labelSet,"txtQryMaxAtt")%>";
MSG_QRR_REQ_COL_SEL_MOD = "<%= dBean.fmtScriptStr(LabelManager.getName(labelSet,"lblQryModReqColSel")) %>";
MSG_COL_NOT_ALLOW 		= "<%= dBean.fmtScriptStr(LabelManager.getName(labelSet,"lblQryColNotAllow")) %>";
ERR_NOT_VALID_FILTER	= "<%= dBean.fmtScriptStr(LabelManager.getName(labelSet,"lblQryNotValFilter")) %>";

QRY_ALLOW_ATT			= <%= queryVo.getFlagValue(QueryVo.FLAG_ALLOW_ATTRIBUTE) %>;
QRY_TO_PROCEDURE		= <%= queryVo.getFlagValue(QueryVo.FLAG_TO_PROCEDURE) %>;	
QRY_TO_VIEW				= <%=queryVo.getFlagValue(QueryVo.FLAG_TO_VIEW)%>;
QRY_TYPE_MODAL			= "<%= QueryVo.TYPE_MODAL %>";
QRY_TYPE_ENTITY_MODAL	= "<%= QueryVo.TYPE_ENTITY_MODAL %>";

ADD_DONT_EXPORT = <%= !(QueryVo.TYPE_MODAL.equals(queryVo.getQryType()) || QueryVo.TYPE_ENTITY_MODAL.equals(queryVo.getQryType()) || QueryVo.TYPE_OFF_LINE.equals(queryVo.getQryType())) %>;
ADD_AVOID_AUTO_FILTER = <%= QueryVo.TYPE_QUERY.equals(queryVo.getQryType()) %>;

QRY_DB_TYPE_PARAM = "<%= QryColumnVo.DB_TYPE_PARAMETER %>";
QRY_DB_TYPE_COL   = "<%=QryColumnVo.DB_TYPE_COLUMN%>";
QRY_DB_TYPE_ATT   = "<%=QryColumnVo.DB_TYPE_ATTRIBUTE%>";
QRT_DB_TYPE_NONE  = "<%=QryColumnVo.DB_TYPE_NONE%>";

QRY_DB_VIEW_NAME = "<%=dBean.fmtStr(queryVo.getQryViewName())%>";
QRY_FREE_SQL_MODE	= <%= queryVo.isFreeSQL() %>;
BUS_CLA_ID 		 = "<% 
QryEvtBusClassVo eventVo = dBean.getQueryVo().getEvent(new Integer(EventVo.EVENT_QRY_EXECUTE));
if (eventVo != null) {
	out.print(eventVo.getBusClaId());
} %>";

PARAM_IO_IN 	= "<%=BusClaParameterVo.PARAM_IO_IN%>";
PARAM_IO_OUT 	= "<%=BusClaParameterVo.PARAM_IO_OUT%>";
PARAM_IO_IN_OUT = "<%=BusClaParameterVo.PARAM_IO_IN_OUT%>";

LBL_ALL_ATT_ACC = "<%=LabelManager.getAccessKey(labelSet,"lblShowAllAtt")%>";
LBL_ATT_ALL_TOL = "<%=LabelManager.getToolTip(labelSet,"lblShowAllAtt")%>";
LBL_ATT_ALL_NAM = "<%=LabelManager.getNameWAccess(labelSet,"lblShowAllAtt")%>";

COLUMN_ORDER_ASC  = "<%=dBean.fmtStr(QryColumnVo.COLUMN_ORDER_ASC)%>";
COLUMN_ORDER_DESC = "<%=dBean.fmtStr(QryColumnVo.COLUMN_ORDER_DESC)%>";

COLUMN_DATA_STRING = "<%=QryColumnVo.COLUMN_DATA_STRING%>";
COLUMN_DATA_NUMBER = "<%=QryColumnVo.COLUMN_DATA_NUMBER%>";
COLUMN_DATA_DATE   = "<%=QryColumnVo.COLUMN_DATA_DATE%>";

COLUMN_FILTER_LESS 		 = "<%=dBean.fmtStr(QryColumnVo.COLUMN_FILTER_LESS)%>";
COLUMN_FILTER_EQUAL 	 = "<%=dBean.fmtStr(QryColumnVo.COLUMN_FILTER_EQUAL)%>";
COLUMN_FILTER_MORE 		 = "<%=dBean.fmtStr(QryColumnVo.COLUMN_FILTER_MORE)%>";
COLUMN_FILTER_DISTINCT   = "<%=dBean.fmtStr(QryColumnVo.COLUMN_FILTER_DISTINCT)%>";
COLUMN_FILTER_NULL 	  	 = "<%=dBean.fmtStr(QryColumnVo.COLUMN_FILTER_NULL)%>";
COLUMN_FILTER_NOT_NULL   = "<%=dBean.fmtStr(QryColumnVo.COLUMN_FILTER_NOT_NULL)%>";
COLUMN_FILTER_LESS_EQUAL = "<%=dBean.fmtStr(QryColumnVo.COLUMN_FILTER_LESS_EQUAL)%>";
COLUMN_FILTER_MORE_EQUAL = "<%=dBean.fmtStr(QryColumnVo.COLUMN_FILTER_MORE_EQUAL)%>";
COLUMN_FILTER_LIKE 		 = "<%=dBean.fmtStr(QryColumnVo.COLUMN_FILTER_LIKE)%>";
COLUMN_FILTER_NOT_LIKE	 = "<%=dBean.fmtStr(QryColumnVo.COLUMN_FILTER_NOT_LIKE)%>";
COLUMN_FILTER_START_WITH = "<%=dBean.fmtStr(QryColumnVo.COLUMN_FILTER_START_WITH)%>";

STRING_TYPE_EQUAL			= "<%= IQueryFilter.STRING_TYPE_EQUAL %>";
STRING_TYPE_STARTS_WITH		= "<%= IQueryFilter.STRING_TYPE_STARTS_WITH %>";
STRING_TYPE_ENDS_WITH		= "<%= IQueryFilter.STRING_TYPE_ENDS_WITH %>";
STRING_TYPE_LIKE			= "<%= IQueryFilter.STRING_TYPE_LIKE %>";
STRING_TYPE_NOT_EQUAL		= "<%= IQueryFilter.STRING_TYPE_NOT_EQUAL %>";
STRING_TYPE_NOT_STARTS_WITH	= "<%= IQueryFilter.STRING_TYPE_NOT_STARTS_WITH %>";
STRING_TYPE_NOT_ENDS_WITH	= "<%= IQueryFilter.STRING_TYPE_NOT_ENDS_WITH %>";
STRING_TYPE_NOT_LIKE		= "<%= IQueryFilter.STRING_TYPE_NOT_LIKE %>";

LBL_STRING_TYPE_EQUAL = "<%=LabelManager.getName(labelSet,"lblFilEqu")%>";
LBL_STRING_TYPE_STARTS_WITH = "<%=LabelManager.getName(labelSet,"lblFilLikRig")%>";
LBL_STRING_TYPE_ENDS_WITH = "<%=LabelManager.getName(labelSet,"lblFilLikLef")%>";
LBL_STRING_TYPE_LIKE = "<%=LabelManager.getName(labelSet,"lblFilLik")%>";
LBL_STRING_TYPE_NOT_EQUAL = "<%=LabelManager.getName(labelSet,"lblFilNotEqu")%>";
LBL_STRING_TYPE_NOT_STARTS_WITH = "<%=LabelManager.getName(labelSet,"lblFilNotLikRig")%>";
LBL_STRING_TYPE_NOT_ENDS_WITH = "<%=LabelManager.getName(labelSet,"lblFilNotLikLef")%>";
LBL_STRING_TYPE_NOT_LIKE = "<%=LabelManager.getName(labelSet,"lblFilNotLik")%>";

LBL_DATA_TYPE_STR = "<%=LabelManager.getName(labelSet,"lblStr")%>";
LBL_DATA_TYPE_NUM = "<%=LabelManager.getName(labelSet,"lblNum")%>";
LBL_DATA_TYPE_FEC = "<%=LabelManager.getName(labelSet,"lblFec")%>";

NUMBER_TYPE_EQUAL			= "<%= IQueryFilter.NUMBER_TYPE_EQUAL %>";
NUMBER_TYPE_LESS			= "<%= IQueryFilter.NUMBER_TYPE_LESS %>";
NUMBER_TYPE_MORE			= "<%= IQueryFilter.NUMBER_TYPE_MORE %>";
NUMBER_TYPE_DISTINCT		= "<%= IQueryFilter.NUMBER_TYPE_DISTINCT %>";
NUMBER_TYPE_LESS_OR_EQUAL	= "<%= IQueryFilter.NUMBER_TYPE_LESS_OR_EQUAL %>";
NUMBER_TYPE_MORE_OR_EQUAL	= "<%= IQueryFilter.NUMBER_TYPE_MORE_OR_EQUAL %>";

LBL_NUMBER_TYPE_EQUAL = "<%=LabelManager.getName(labelSet,"lblFilEqu")%>";
LBL_NUMBER_TYPE_LESS = "<%=LabelManager.getName(labelSet,"lblFilLes")%>";
LBL_NUMBER_TYPE_MORE = "<%=LabelManager.getName(labelSet,"lblFilMor")%>";
LBL_NUMBER_TYPE_DISTINCT = "<%=LabelManager.getName(labelSet,"lblFilDis")%>";
LBL_NUMBER_TYPE_LESS_OR_EQUAL = "<%=LabelManager.getName(labelSet,"lblFilLesE")%>";
LBL_NUMBER_TYPE_MORE_OR_EQUAL = "<%=LabelManager.getName(labelSet,"lblFilMorE")%>";

lblQryColOrdAsc  = "<%=LabelManager.getName(labelSet,"lblQryColOrdAsc")%>";
lblQryColOrdDesc = "<%=LabelManager.getName(labelSet,"lblQryColOrdDesc")%>";
lblQryFilLess 	 = "<%=LabelManager.getName(labelSet,"lblQryFilLess")%>";
lblYes 			 = "<%=LabelManager.getName(labelSet,"lblYes")%>";
lblNo 			 = "<%=LabelManager.getName(labelSet,"lblNo")%>";
lblQryFilNotNull = "<%=LabelManager.getName(labelSet,"lblQryFilNotNull")%>";
lblQryFilNull 	 = "<%=LabelManager.getName(labelSet,"lblQryFilNull")%>";
lblQryFilLike 	 = "<%=LabelManager.getName(labelSet,"lblQryFilLike")%>";
lblQryFilNotLike = "<%=LabelManager.getName(labelSet,"lblQryFilNotLike")%>";
lblQryFilStartWith = "<%=LabelManager.getName(labelSet,"lblQryFilStartWith")%>";
lblQryFilMoreE 	 = "<%=LabelManager.getName(labelSet,"lblQryFilMoreE")%>";
lblQryFilLessE 	 = "<%=LabelManager.getName(labelSet,"lblQryFilLessE")%>";
lblQryFilDis 	 = "<%=LabelManager.getName(labelSet,"lblQryFilDis")%>";
lblQryFilEqual 	 = "<%=LabelManager.getName(labelSet,"lblQryFilEqual")%>";
lblQryFilMore 	 = "<%=LabelManager.getName(labelSet,"lblQryFilMore")%>";

lblQryAttFromEnt = "<%=LabelManager.getNameWAccess(labelSet,"lblQryAttFromEnt")%>";
lblQryAttFromPro = "<%=LabelManager.getNameWAccess(labelSet,"lblQryAttFromPro")%>";

lblQryFunDteEqu  = "<%=LabelManager.getName(labelSet,"lblQryFunDteEqu")%>";
lblQryFunDteGre  = "<%=LabelManager.getName(labelSet,"lblQryFunDteGre")%>";
lblQryFunDteLes  = "<%=LabelManager.getName(labelSet,"lblQryFunDteLes")%>";
lblQryFunEnvId 	 = "<%=LabelManager.getName(labelSet,"lblQryFunEnvId")%>";
lblQryFunEnvName = "<%=LabelManager.getName(labelSet,"lblQryFunEnvName")%>";
lblQryFunUser	 = "<%=LabelManager.getName(labelSet,"lblQryFunUser")%>";

lblQryVal  = "<%=LabelManager.getName(labelSet,"lblQryValue")%>";
lblQryFunc = "<%=LabelManager.getName(labelSet,"lblQryFunc")%>";

FUNCTION_NONE		= "<%= QryColumnVo.FUNCTION_NONE %>";
FUNCTION_DATE_EQUAL = "<%= QryColumnVo.FUNCTION_CURRENT_DATE %>";
FUNCTION_ENV_ID		= "<%= QryColumnVo.FUNCTION_ENV_ID%>";
FUNCTION_ENV_NAME	= "<%= QryColumnVo.FUNCTION_ENV_NAME%>";
FUNCTION_USER 		= "<%= QryColumnVo.FUNCTION_USER%>";

var MSG_PERMISSIONS_ERROR = "<%=LabelManager.getName(labelSet,"msgPermError")%>";
var MSG_MUST_SEL_ONE = "<%=LabelManager.getName(labelSet,"msgDebSelUno")%>";
var MSG_PERM_WILL_BE_LOST = "<%=LabelManager.getName(labelSet,"msgPermDefWillBeLost")%>";
var MSG_USE_PROY_PERMS = "<%=LabelManager.getName(labelSet,"msgUseProyPerms")%>";

COLUMN_TYPE_FILTER 	 = "<%= QryColumnVo.COLUMN_TYPE_FILTER %>";
COLUMN_TYPE_FUNCTION = "<%= QryColumnVo.COLUMN_TYPE_FUNCTION %>";

BUS_ENT_INST_NAME_NUM	= "<%= QueryColumns.COLUMN_BUS_ENT_INST_NAME_NUM %>";

showHiddenTd = <%= QueryVo.TYPE_QUERY.equals(queryVo.getQryType()) || QueryVo.TYPE_MODAL.equals(queryVo.getQryType()) || QueryVo.TYPE_ENTITY_MODAL.equals(queryVo.getQryType()) %>;
showAttFrom  = <%= (queryVo.getFlagValue(QueryVo.FLAG_ENT_ATTRIBUTES) && queryVo.getFlagValue(QueryVo.FLAG_PRO_ATTRIBUTES)) %>;
isQuery 	 = <%= QueryVo.TYPE_QUERY.equals(queryVo.getQryType()) %>;

lblNo			= "<%=LabelManager.getName(labelSet,"lblNo")%>";
lblYes			= "<%=LabelManager.getName(labelSet,"lblYes")%>";
lblListbox		= "<%=LabelManager.getName(labelSet,"lblListbox")%>";
msgWsShowCols   = "<%=LabelManager.getName(labelSet,"msgWsShowCols")%>";

var requiereActVieEntCol = [<%= QueryColumns.getInstance().getRequiereActionColumns(QueryVo.ACTION_VIEW_ENTITY) %>];
var requiereActVieProCol = [<%= QueryColumns.getInstance().getRequiereActionColumns(QueryVo.ACTION_VIEW_PROCESS) %>];
var requiereActVieTasCol = [<%= QueryColumns.getInstance().getRequiereActionColumns(QueryVo.ACTION_VIEW_TASK) %>];
var requiereActWorEntCol = [<%= QueryColumns.getInstance().getRequiereActionColumns(QueryVo.ACTION_WORK_ENTITY) %>];
var requiereActWorTasCol = [<%= QueryColumns.getInstance().getRequiereActionColumns(QueryVo.ACTION_WORK_TASK) %>];
var requiereActAcqTasCol = [<%= QueryColumns.getInstance().getRequiereActionColumns(QueryVo.ACTION_ACQUIRE_TASK) %>];
var requiereActComTasCol = [<%= QueryColumns.getInstance().getRequiereActionColumns(QueryVo.ACTION_COMPLETE_TASK) %>];

SOURCE_CONNECTION = <%= QueryVo.SOURCE_CONNECTION.equals(queryVo.getSource()) %>;

var OPTIONS_BUS_ENTITY_COMBO_STR = "<option value=''><% if (dBean.getBusEntities() != null) { for (Iterator it = dBean.getBusEntities().iterator(); it.hasNext(); ) { BusEntityVo busEntVo = (BusEntityVo) it.next(); %><option value='<%= busEntVo.getBusEntId() %>'><%= busEntVo.getBusEntName() %></option><% } } %>";
var perAfterSch = "<%= SchBusClaActivityVo.PERIODICITY_AFTER_SCHEDULER %>";


var LBL_COLUMN = "<%=LabelManager.getName(labelSet,"lblQryColName")%>";
var LBL_SHOWAS = "<%=LabelManager.getName(labelSet,"lblQryColHeadName")%>"; 
//-------------------

function doOnLoad() {
<% if (QueryVo.TYPE_OFF_LINE.equals(queryVo.getQryType())) { %>
	paramSave_onChange();
	paramMax_onClick();
<% } %>
//	previewWhereFilter_click(); 
//	cmbWheTip_changeAll();
<% if (QueryVo.TYPE_QUERY.equals(queryVo.getQryType())) { %>
	chkActVieQry_click();
<% } %>

	checkCmbWheFilter();
	checkWhereUserFilterFreeSql();
	
	checkActions();
}

//----------------------------

</script><% } catch (Exception e) { e.printStackTrace(); } %>