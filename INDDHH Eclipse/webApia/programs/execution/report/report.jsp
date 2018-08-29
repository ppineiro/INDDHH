<%@page import="com.dogma.vo.*"%><%@page import="com.st.util.XMLUtils"%><%@page import="com.dogma.vo.custom.*"%><%@include file="../../../components/scripts/server/startInc.jsp"%><%@page import="com.dogma.UserData"%><%@page import="com.dogma.util.DogmaUtil"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp"%></head><body onload="setPNumeric()"><jsp:useBean id="repBean" scope="session" class="com.dogma.bean.administration.ReportBean"></jsp:useBean><%
ReportVo repVo = repBean.getReportVo();
String repName = repVo.getRepName();
String repDesc = repVo.getRepDesc();
String repTitle = repVo.getRepTitle();
if (repVo.getRepId().intValue()<1000){
	repName = LabelManager.getName(labelSet,repVo.getRepName());
	repDesc = LabelManager.getToolTip(labelSet,repVo.getRepName());
	repTitle = LabelManager.getName(labelSet,repVo.getRepTitle());
}
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=repTitle%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatReport")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td align="left"><b><%=repBean.fmtStr(repName)%></b></td><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblExport")%>"><%=LabelManager.getNameWAccess(labelSet,"lblExport")%>:</td><td><input type="radio" id="format" name="format" onclick="changeRadFact('.html')" value=".html"><%=LabelManager.getName(labelSet,"lblHtml")%></input></td></tr><tr><%if(repDesc!=null && !"".equals(repDesc)){%><td align="right" align="right" title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDes")%>:</td><td align="left" ><%=repDesc%></td><td></td><%}else{%><td></td><td></td><td></td><%}%><td><input type="radio" checked id="format" name="format" onclick="changeRadFact('.pdf')" value=".pdf"><%=LabelManager.getName(labelSet,"lblPdf")%></input></td></tr><tr><td></td><td></td><td></td><td><input type="radio" id="format" name="format" onclick="changeRadFact('.xls')" value=".xls"><%=LabelManager.getName(labelSet,"lblExcel")%></input></td></tr><tr><td><input name="radSelected" id="radSelected" type="hidden" value=".pdf"></td></tr></table><br><br><% if (repVo.getRepParams() != null && repVo.getRepParams().size()>0) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRepFromPar")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><%
				 if (repVo.getRepParams()!=null && repVo.getRepParams().size()>0){
				 	Iterator itParams = repVo.getRepParams().iterator();
				 	while(itParams.hasNext()){
				   		RepParameterVo paramVo = (RepParameterVo) itParams.next();
				   		String textToShow = paramVo.getRepParName();
				   		if (paramVo.getRepParDesc()!=null && !"".equals(paramVo.getRepParDesc())) textToShow = paramVo.getRepParDesc();
						String tooltip = paramVo.getRepParName();
						if (paramVo.getRepParDesc()!=null && !"".equals(paramVo.getRepParDesc())){
							tooltip = paramVo.getRepParDesc();
						}
						String paramValue = "";
						String paramType = paramVo.getRepParType();
						boolean enabled = true;
						if (paramVo.getRepParDefValue()==null || paramVo.getRepParDefValue().intValue() == RepParameterVo.REP_DEF_VALUE_TYPE_FIXED){
							paramValue = paramVo.getRepParValue();
							enabled = false;
						}else if (paramVo.getRepParDefValue()!=null && paramVo.getRepParDefValue().intValue() == RepParameterVo.REP_DEF_VALUE_TYPE_USER_ID) {
							paramValue = ((UserData)request.getSession().getAttribute(Parameters.SESSION_ATTRIBUTE)).getUserId();
							enabled = false;
						}else if (paramVo.getRepParDefValue()!=null && paramVo.getRepParDefValue().intValue() == RepParameterVo.REP_DEF_VALUE_TYPE_USER_NAME) {
							paramValue = ((UserData)request.getSession().getAttribute(Parameters.SESSION_ATTRIBUTE)).getUserName();
							enabled = false;
						}else if (paramVo.getRepParDefValue()!=null && paramVo.getRepParDefValue().intValue() == RepParameterVo.REP_DEF_VALUE_TYPE_ENV_NAME) {
							paramValue = ((UserData)request.getSession().getAttribute(Parameters.SESSION_ATTRIBUTE)).getEnvironmentName();
							enabled = false;
						}else if (paramVo.getRepParDefValue()!=null && paramVo.getRepParDefValue().intValue() == RepParameterVo.REP_DEF_VALUE_TYPE_ENV_ID) {
							paramValue = ((UserData)request.getSession().getAttribute(Parameters.SESSION_ATTRIBUTE)).getEnvironmentId().toString();
							enabled = false;
						}
						%><tr><%if ("D".equals(paramVo.getRepParType())){ %><td title="<%=repBean.fmtStr(paramVo.getRepParName())%>"><%=repBean.fmtStr(textToShow)%>:</td><td><input name="<%=paramVo.getRepParName()%>" id="<%=paramVo.getRepParName()%>" size="10" p_calendar="true" class="txtDate" p_mask="<%=DogmaUtil.getHTMLDateMask(repBean.getEnvId(request))%>" <%if(paramVo.getRepParReq().intValue() == 1){%>p_required="true"<%}%> maxlength="10" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblFecDes")%>" type="text" value=""></td><%}else{ %><td align="right" title="<%=repBean.fmtStr(paramVo.getRepParName())%>" align="right"><%=repBean.fmtStr(textToShow)%>:</td><td align="left"><input title="<%=repBean.fmtStr(tooltip)%>" name="<%=paramVo.getRepParName()%>" <%if("I".equals(paramType) || "N".equals(paramType)){%>p_numeric="true" <%}%><%if(paramVo.getRepParReq().intValue() == 1){%>p_required="true"<%}%> maxlength="50" size="30" type="text" value="<%=paramValue%>" <%=(enabled)?"":"disabled"%>></td><%} %><td></td><td></td></tr><%}
				  }%></table><%}%></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD align="right"><button type="button" onclick="btnDownload_click('<%=repBean.fmtInt(repVo.getRepId())%>')" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnGenReport")%>" title="<%=LabelManager.getToolTip(labelSet,"btnGenReport")%>"><%=LabelManager.getNameWAccess(labelSet,"btnGenReport")%></button><!--<button type="button" onclick="btnPreview_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnPreview")%>" title="<%=LabelManager.getToolTip(labelSet,"btnPreview")%>"><%=LabelManager.getNameWAccess(labelSet,"btnPreview")%></button>--><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE><iframe id="downloadFrame" name="downloadFrame" style="position:absolute;width:0px;height:0px;top:-30px;"></iframe></body></html><%@include file="../../../components/scripts/server/endInc.jsp"%><script language="javascript" defer="true" src='<%=Parameters.ROOT_PATH%>/programs/execution/report/report.js'></script><script language="javascript"><%
String params="";
if (repVo.getRepParams()!=null && repVo.getRepParams().size()>0){
	Iterator itParams = repVo.getRepParams().iterator();
	while (itParams.hasNext()){
		RepParameterVo paramVo = (RepParameterVo) itParams.next();
		if (params==""){
			params = paramVo.getRepParName();
		}else{
			params = params + "," + paramVo.getRepParName();
		}
	}
}
%>
var PARAMS="<%=params%>";
</script>
