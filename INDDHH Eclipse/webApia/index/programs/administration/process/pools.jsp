<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@page import="com.dogma.vo.custom.ProDefinitionVo"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.ProcessBean"></jsp:useBean><%
String event = request.getParameter("event");
%><!--     - USUARIOS A SER NOTIFICADOS          --><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titProNot" + event)%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" target="frmSubmit" onSubmit="return false"><IFRAME id="frmSubmit" name="frmSubmit" style="display:none"></IFRAME><iframe name="iframeMessages" id="iframeMessages" src="<%=Parameters.ROOT_PATH%>/frames/feedBackWin.jsp" style="display:none"  class="feedBackFrame" frameborder="no"  ></iframe><br><div type="grid" id="gridPools" style="height:380px"><table id="tblPools" class="tblDataGrid"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblPoolNot")%>"><%=LabelManager.getName(labelSet,"lblPoolNot")%></th></tr></thead><tbody id="tblPoolBody"><%if (dBean.getProNotPools(event) != null){
				Iterator itPools = dBean.getProNotPools(event).iterator();
				while (itPools.hasNext()) {
					ProNotPoolVo poolVo = (ProNotPoolVo) itPools.next();
					%><tr><td style="width:0px;display:none;"><input type="hidden" name="chkPoolSel"><input type=hidden name="idPool" value="<%=dBean.fmtInt(poolVo.getPoolId())%>"><input type=hidden name="txtPool" value="<%=dBean.fmtStr(poolVo.getPoolName())%>"></td><td><%=dBean.fmtHTML(poolVo.getPoolName())%></td></tr><%
				}
			}%></tbody></table></div><form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><tr><td><button type="button" onclick="btnAddPool_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgr")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgr")%></button><button type="button" onclick="btnDelPool_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button></td><td><button type="button" onclick="btnConfPools_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExitPools_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></td></tr></table></html><SCRIPT>
  TYPE_NUMERIC = "<%= AttributeVo.TYPE_NUMERIC %>";
  TYPE_DATE = "<%= AttributeVo.TYPE_DATE %>";
  TYPE_STRING = "<%= AttributeVo.TYPE_STRING %>";
  EVENT = "<%= event %>";
  ENV_ID = <%= dBean.getEnvId(request) %>;
</script><script src="<%=Parameters.ROOT_PATH%>/programs/administration/process/process.js"></script>