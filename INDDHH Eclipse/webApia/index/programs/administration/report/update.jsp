<%@page import="com.dogma.vo.*"%><%@page import="com.st.util.XMLUtils"%><%@page import="com.dogma.vo.custom.*"%><%@include file="../../../components/scripts/server/startInc.jsp"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp"%></head><body onload="setPNumeric()"><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.ReportBean"></jsp:useBean><%
ReportVo repVo = dBean.getReportVo();
String actualUser = dBean.getActualUser(request);
boolean saveChanges = (repVo.getRepId()==null)?true:dBean.hasWritePermission(request, repVo.getRepId(), actualUser);

%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titReports")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST" enctype="multipart/form-data"><div type ="tabElement" id="samplesTab" ontabswitch="tabSwitch()" <%=(request.getParameter("defaultTab")!=null?(" defaultTab='"+request.getParameter("defaultTab").toString()+"'"):"" )%>><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabDatGen")%>" tabText="<%=LabelManager.getName(labelSet,"tabDatGen")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatReport")%></DIV><table class="tblFormLayout"><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td align="left"><input name="repName" p_required="true" maxlength="50" size="30" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>" type="text" <%if(repVo!=null) {%>value="<%=dBean.fmtStr(repVo.getRepName())%>"<%}%>></td><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblTit")%>"><%=LabelManager.getNameWAccess(labelSet,"lblTit")%>:</td><td align="left"><input name="repTitle" p_required="true" maxlength="50" size="30" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTit")%>" type="text" <%if(repVo!=null) {%>value="<%=dBean.fmtStr(repVo.getRepTitle())%>"<%}%>></td></tr><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDes")%>:</td><td colspan=2 align="left"><input name="repDesc" maxlength="255" size="55" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDes")%>" type="text" <%if(repVo!=null) {%>value="<%=dBean.fmtStr(repVo.getRepDesc())%>"<%}%>></td><td></td></tr><%if(repVo!=null && repVo.getRepId()!=null){%><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblReport")%>"><%=LabelManager.getNameWAccess(labelSet,"lblReport")%>:</td><td colspan=2><b><%=dBean.fmtStr(repVo.getFileName())%></b><button type="button" onclick="btnDownload_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDow")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDow")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDow")%></button></td><td></td></tr><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblReport")%>"><%=LabelManager.getNameWAccess(labelSet,"lblModReport")%>:</td><td colspan=2><input type="FILE" length="100" accesskey="<%=LabelManager.getToolTip(labelSet,"lblNueDoc")%>" title="<%=LabelManager.getToolTip(labelSet,"lblModReport")%>" <%if (repVo.getRepId() == null) {%>p_required="true"<%}%> name="fileName" id="fileName" size="45" ></td><td></td></tr><%}else{%><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblReport")%>"><%=LabelManager.getNameWAccess(labelSet,"lblReport")%>:</td><td align="left" colspan=2><input type="FILE" length="100" accesskey="<%=LabelManager.getToolTip(labelSet,"lblNueDoc")%>" title="<%=LabelManager.getToolTip(labelSet,"lblModReport")%>" <%if (repVo.getRepId() == null) {%>p_required="true"<%}%> name="fileName" id="fileName" size="45" ></td><td></td></tr><%}%><tr><td><input name="repId" id="repId" type="hidden" value="<%=(repVo!=null && repVo.getRepId()!=null)?repVo.getRepId():0%>"></td></tr><tr><input type="hidden" name="hidUsrCanWrite" value="<%=saveChanges%>"></tr></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"titRepSource")%></DIV><table class="tblFormLayout"><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblQryDbNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblQryDbNom")%>:</td><td colspan=2 align="left"><select name="dbConId" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblQryDbNom")%>" p_required=true onChange="cmbSource_change()"><option value="-1" <%=(repVo.getDbConId() == null || repVo.getDbConId().equals(new Integer("-1")))?"selected":""%>><%=LabelManager.getName(labelSet,"lblLocalDbNom")%></option><option value="0" <%=(repVo.getDbConId() != null && repVo.getDbConId().equals(new Integer("0")))?"selected":""%>><%=LabelManager.getName(labelSet,"lblConNatReport")%></option><%
	   					if (dBean.getDbConnections() != null) {
		   					Iterator iterator = dBean.getDbConnections().iterator();
		   					DbConnectionVo connection;
			   				while (iterator.hasNext()) {
			   					connection = (DbConnectionVo) iterator.next(); %><option value="<%=dBean.fmtInt(connection.getDbConId())%>" <%=connection.getDbConId().equals(repVo.getDbConId())?"selected":""%>><%=dBean.fmtStr(connection.getDbConName())%></option><%
		   					}
			   			} %></select><button onclick="cmbSource_refresh()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAct")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAct")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAct")%></button><input name="conxSel" id="conxSel" type="hidden" value="<%=(repVo.getDbConId()!=null)?repVo.getDbConId():-1%>"></td></tr><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblQueryName")%>"><%=LabelManager.getNameWAccess(labelSet,"lblQueryName")%>:</td><td align="left"><input name="repQryName" title="<%=LabelManager.getToolTip(labelSet,"lblQueryName")%>" <%=(repVo.getDbConId()==null || (repVo.getDbConId()!=null && repVo.getDbConId().intValue()!=0))?"p_required=\"true\"":""%>  id="repQryName" maxlength="50" size="30" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblQry")%>" type="text" <%if(repVo.getDbConId()!=null && repVo.getDbConId().intValue()!=0 && repVo.getQueryName()!=null) {%>value="<%=dBean.fmtStr(repVo.getQueryName())%>"<%}%>></td><td></td><td></td></tr><tr style="margin-left:25px"><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblRepQuery")%>"><%=LabelManager.getNameWAccess(labelSet, "lblRepQuery")%>:</td><td colspan=2 title="<%=LabelManager.getToolTip(labelSet,"lblRepQuery")%>"><textarea <%=(repVo.getDbConId()==null || (repVo.getDbConId()!=null && repVo.getDbConId().intValue()!=0))?"p_required=\"true\"":""%><%=(repVo.getDbConId()==null || (repVo.getDbConId()!=null && repVo.getDbConId().intValue()!=0))?"":"disabled"%> name="repQuery" id="repQuery" p_maxlength="true" value="<%=(repVo.getDbConId()!=null && repVo.getDbConId().intValue()!=0 && repVo.getRepQuery()!=null)?repVo.getRepQuery():""%>" cols=95 rows=6><%=(repVo.getDbConId()!=null && repVo.getDbConId().intValue()!=0 && repVo.getRepQuery()!=null)?repVo.getRepQuery():""%></textarea></td><td><button id="btnTestSql" onclick="testSqlView()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnTestSql")%>" title="<%=LabelManager.getToolTip(labelSet,"btnTestSql")%>"><%=LabelManager.getNameWAccess(labelSet,"btnTestSql")%></button></td></tr></table><br><br><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRepPar")%></DIV><div class="tableContainerNoHScroll" style="height: 200px;" type="grid" id="tblParam"><table id="tblHead" width="500px" cellpadding="0" cellspacing="0"><thead class="fixedHeader"><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_width="250px" style="width:250px" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th><th min_width="250px" style="width:250px" title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getName(labelSet,"lblDes")%></th><th min_width="50px" style="width:50px" title="<%=LabelManager.getToolTip(labelSet,"lblTipDat")%>"><%=LabelManager.getName(labelSet,"lblTipDat")%></th><th min_width="320px" style="width:320px" title="<%=LabelManager.getToolTip(labelSet,"lblDefValue")%>"><%=LabelManager.getName(labelSet,"lblDefValue")%></th><th min_width="40px" style="width:40px" title="<%=LabelManager.getToolTip(labelSet,"lblReq")%>"><%=LabelManager.getName(labelSet,"lblReq")%></th></tr></thead><tbody id="tblShowBody"><% if (repVo.getRepParams() != null && repVo.getRepParams().size()>0) {
						      int rowIndx=0;
						      Iterator itParams = repVo.getRepParams().iterator();
						      while (itParams.hasNext()){
						      	RepParameterVo paramVo = (RepParameterVo) itParams.next();
						      	boolean chkEnabled = true;
						      	boolean typeEnabled = true;
						      	boolean numeric = false;
						      	if (paramVo.getRepParDefValue()!=null){
						      		if (paramVo.getRepParDefValue().intValue() >= 0){
						      			chkEnabled = false;
							      		if (paramVo.getRepParDefValue().intValue() > 0){
							      			typeEnabled=false;
										}
						      		}
						      	}
						      	if (paramVo.getRepParType()!=null){
						      	  if(paramVo.getRepParType().equals(AttributeVo.TYPE_NUMERIC) || paramVo.getRepParType().equals(AttributeVo.TYPE_INT)){
						      	  	numeric = true;
						      	  }
						      	}
						      %><tr><td style="width:0px;display:none;"><input type="hidden" id="idSel" name="chkSel<%=rowIndx%>"></td><td><input p_required=true id='txtParName' name='txtParName' maxlength='50' size=35 type='text' value="<%=dBean.fmtStr(paramVo.getRepParName())%>" onblur='valName(this)'></td><td><input id='txtParDesc' name='txtParDesc' maxlength='200' size=40 type='text' value="<%=dBean.fmtStr(paramVo.getRepParDesc())%>"></td><td align="center"><select id="cmbParType<%=rowIndx%>" name="cmbParType<%=rowIndx%>" onchange="changeParType(<%=rowIndx%>)" <%=(!typeEnabled)?"disabled":""%>><option value="E" <%if (paramVo.getRepParType()==null) {%> selected <%}%>></option><option value="N" <%if (paramVo.getRepParType()!=null && paramVo.getRepParType().equals(AttributeVo.TYPE_NUMERIC)) {%> selected <%}%>><%=LabelManager.getName(labelSet,"lblNum")%></option><option value="S" <%if (paramVo.getRepParType()!=null && paramVo.getRepParType().equals(AttributeVo.TYPE_STRING)) {%> selected <%}%>><%=LabelManager.getName(labelSet,"lblStr")%></option><option value="D" <%if (paramVo.getRepParType()!=null && paramVo.getRepParType().equals(AttributeVo.TYPE_DATE)) {%> selected <%}%>><%=LabelManager.getName(labelSet,"lblFec")%></option><option value="I" <%if (paramVo.getRepParType()!=null && paramVo.getRepParType().equals(AttributeVo.TYPE_INT)) {%> selected <%}%>><%=LabelManager.getName(labelSet,"lblInt")%></option></select></td><td><% if (numeric){%><input grid="true" colLabel="<%=LabelManager.getToolTip(labelSet,"lblDefValue")%>" id="txtParValue<%=rowIndx%>" name="txtParValue<%=rowIndx%>" title="<%=LabelManager.getName(labelSet,"lblEntDefValue")%>" type="text" maxlength="50" onFocus="changeParValue(<%=rowIndx%>)" size=15 p_numeric=true value="<%=(paramVo.getRepParValue()!=null)?paramVo.getRepParValue():""%>"><%}else{%><input grid="true" colLabel="<%=LabelManager.getToolTip(labelSet,"lblDefValue")%>" id="txtParValue<%=rowIndx%>" name="txtParValue<%=rowIndx%>" title="<%=LabelManager.getName(labelSet,"lblEntDefValue")%>" type="text" maxlength="50" onFocus="changeParValue(<%=rowIndx%>)" size=15 value="<%=(paramVo.getRepParValue()!=null)?paramVo.getRepParValue():""%>"><%}%><select style="margin-left:0px" id="cmbParValue<%=rowIndx%>" name="cmbParValue<%=rowIndx%>" title="<%=LabelManager.getName(labelSet,"lblSelDefValue")%>" onchange="changeDefValue(<%=rowIndx%>)"><option value="<%=RepParameterVo.REP_DEF_VALUE_TYPE_VARIABLE%>" <%if (paramVo.getRepParDefValue()==null || paramVo.getRepParDefValue().intValue() == RepParameterVo.REP_DEF_VALUE_TYPE_VARIABLE) {%> selected <%}%>></option><option value="<%=RepParameterVo.REP_DEF_VALUE_TYPE_FIXED%>" <%if (paramVo.getRepParDefValue()==null || paramVo.getRepParDefValue().intValue() == RepParameterVo.REP_DEF_VALUE_TYPE_FIXED) {%> selected <%}%>>-<%=LabelManager.getName(labelSet,"lblEntDefValue")%>-</option><option value="<%=RepParameterVo.REP_DEF_VALUE_TYPE_USER_ID%>" <%if (paramVo.getRepParDefValue()!=null && paramVo.getRepParDefValue().intValue() == RepParameterVo.REP_DEF_VALUE_TYPE_USER_ID) {%> selected <%}%>><%=LabelManager.getName(labelSet,"lblRepUserId")%></option><option value="<%=RepParameterVo.REP_DEF_VALUE_TYPE_USER_NAME%>" <%if (paramVo.getRepParDefValue()!=null && paramVo.getRepParDefValue().intValue() == RepParameterVo.REP_DEF_VALUE_TYPE_USER_NAME) {%> selected <%}%>><%=LabelManager.getName(labelSet,"lblRepUserName")%></option><option value="<%=RepParameterVo.REP_DEF_VALUE_TYPE_ENV_ID%>" <%if (paramVo.getRepParDefValue()!=null && paramVo.getRepParDefValue().intValue() == RepParameterVo.REP_DEF_VALUE_TYPE_ENV_ID) {%> selected <%}%>><%=LabelManager.getName(labelSet,"lblRepEnvId")%></option><option value="<%=RepParameterVo.REP_DEF_VALUE_TYPE_ENV_NAME%>" <%if (paramVo.getRepParDefValue()!=null && paramVo.getRepParDefValue().intValue() == RepParameterVo.REP_DEF_VALUE_TYPE_ENV_NAME) {%> selected <%}%>><%=LabelManager.getName(labelSet,"lblRepEnvName")%></option></select></td><td><input type="checkbox" id="parReq<%=rowIndx%>" name="parReq<%=rowIndx%>" <%=(!chkEnabled)?"disabled":""%> value="<%=rowIndx%>" <%=(paramVo.getRepParReq().intValue()==1)?"checked":""%>></td></tr><% rowIndx ++;
								}
						 }%></tbody></table></div><table class="navBar"><tr><td align="left"><button type="button" onclick="btnUp_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnUp")%>" title="<%=LabelManager.getToolTip(labelSet,"btnUp")%>"><%=LabelManager.getNameWAccess(labelSet,"btnUp")%></button><button type="button" onclick="btnDown_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDown")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDown")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDown")%></button></td><td></td><td align="right"><button type="button" onclick="btnAdd_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgr")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgr")%></button><button type="button" onclick="btnDel_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button></td></tr></table></div><!--      PERMISOS          --><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabRepPer")%>" tabText="<%=LabelManager.getName(labelSet,"tabRepPer")%>"><%@ include file="permissions.jsp" %></div></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD align="right"><button type="button" onclick="btnConf_click()" <%=(!saveChanges)?"disabled":"" %> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE><iframe id="downloadFrame" name="downloadFrame" style="position:absolute;width:0px;height:0px;top:-30px;"></iframe></body></html><%@include file="../../../components/scripts/server/endInc.jsp"%><script language="javascript" defer="true" src='<%=Parameters.ROOT_PATH%>/programs/administration/report/update.js'></script><SCRIPT language="javascript">
executionMode=true; //para que funcione el unsetNumericFields
var MSG_MUST_SEL_PRPT_FILE = "<%=LabelManager.getName(labelSet,"msgMstSelPrptFile")%>";
var LBL_PAR_STRING = "<%=LabelManager.getName(labelSet,"lblStr")%>";
var LBL_PAR_NUMERIC = "<%=LabelManager.getName(labelSet,"lblNum")%>";
var LBL_PAR_DATE = "<%=LabelManager.getName(labelSet,"lblFec")%>";
var LBL_PAR_INT = "<%=LabelManager.getName(labelSet,"lblInt")%>";
var LBL_ENT_DEF_VALUE = "<%=LabelManager.getName(labelSet,"lblEntDefValue")%>";
var LBL_DEF_VALUE = "<%=LabelManager.getToolTip(labelSet,"lblDefValue")%>";
var LBL_SEL_DEF_VALUE = "<%=LabelManager.getName(labelSet,"lblSelDefValue")%>";
var LBL_REP_USER_ID = "<%=LabelManager.getName(labelSet,"lblRepUserId")%>";
var LBL_REP_USER_NAME = "<%=LabelManager.getName(labelSet,"lblRepUserName")%>";
var LBL_REP_ENV_ID = "<%=LabelManager.getName(labelSet,"lblRepEnvId")%>";
var LBL_REP_ENV_NAME = "<%=LabelManager.getName(labelSet,"lblRepEnvName")%>";
var LBL_REP_QRY_TST_PARAMS = "<%=LabelManager.getName(labelSet,"lblRepQryTstParams")%>";
var MSG_MUST_SEL_PAR_FIRST = "<%=LabelManager.getName(labelSet,"msgMstSelOneParFirst")%>";
var MSG_REP_NAME_UNIQUE = "<%=LabelManager.getName(labelSet,"msgRepNameUnique")%>";
var CON_TYPE_APIA_DB = "<%=ReportVo.DB_CON_TYPE_APIA_DB%>";
var CON_TYPE_NATIVE = "<%=ReportVo.DB_CON_TYPE_NAT_REPORT%>";
var MSG_QUERY_WITH_ERRORS = "<%=LabelManager.getName(labelSet,"msgRepQryWithErrors")%>";
var MSG_PAR_WITHOUT_TYPE = "<%=LabelManager.getName(labelSet,"msgRepParWitType")%>";
var MSG_PAR_MISSING_VALUE = "<%=LabelManager.getName(labelSet,"msgRepParMisValue")%>";
var REP_DEF_VALUE_TYPE_VARIABLE = "<%=RepParameterVo.REP_DEF_VALUE_TYPE_VARIABLE%>";
var REP_DEF_VALUE_TYPE_FIXED = "<%=RepParameterVo.REP_DEF_VALUE_TYPE_FIXED%>";
var REP_DEF_VALUE_TYPE_USER_ID = "<%=RepParameterVo.REP_DEF_VALUE_TYPE_USER_ID%>";
var REP_DEF_VALUE_TYPE_USER_NAME = "<%=RepParameterVo.REP_DEF_VALUE_TYPE_USER_NAME%>";
var REP_DEF_VALUE_TYPE_ENV_ID = "<%=RepParameterVo.REP_DEF_VALUE_TYPE_ENV_ID%>";
var REP_DEF_VALUE_TYPE_ENV_NAME = "<%=RepParameterVo.REP_DEF_VALUE_TYPE_ENV_NAME%>";
var MSG_PERMISSIONS_ERROR = "<%=LabelManager.getName(labelSet,"msgPermError")%>";

</script>
