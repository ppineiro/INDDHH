<%@page import="com.dogma.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="com.dogma.vo.custom.*"%><%@page import="com.dogma.bean.query.TaskListBean"%><%@page import="com.dogma.business.querys.factory.QueryColumns"%><%@page import="java.util.*"%><%@include file="../../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../../components/scripts/server/headInclude.jsp" %></head><jsp:useBean id="qBeanReady" scope="session" class="com.dogma.bean.query.TaskListBean"></jsp:useBean><jsp:useBean id="qBeanInproc" scope="session" class="com.dogma.bean.query.TaskListBean"></jsp:useBean><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titEjeColLis")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent" style="width:400px;" ><FORM id="frmMain" name="frmMain" method="POST" target="frmSubmit"><IFRAME id="frmSubmit" name="frmSubmit" style="display:none"></IFRAME><iframe name="iframeMessages" id="iframeMessages" src="<%=Parameters.ROOT_PATH%>/frames/feedBackWin.jsp" style="display:none"  class="feedBackFrame" frameborder="no"></iframe><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtCol")%></DIV><div style="height: 240px;" type="grid" id="oColumnas"><table class="tblDataGrid" id="oColumnas"><thead><tr><th style="width:100%">&nbsp;</th><th style="width:30px"><div align="center"><%=LabelManager.getName(labelSet,"sbtColMos")%></div></th></tr></thead><%
				String WORK_MODE = request.getParameter("workMode");
				com.dogma.bean.query.TaskListBean dBean = null;
				if (WORK_MODE.equals(TaskListBean.WORKING_MODE_INPROCESS)) {
					dBean = qBeanInproc;
				} else {
					dBean = qBeanReady;
				} 
				QueryVo queryVo = dBean.getQueryVo();
				
				ArrayList showColumns = queryVo.getAllShowColumns();
				int[] mustShowColumns = null;
				StringBuffer hiddenHtml = new StringBuffer();
				
				if (showColumns.size() > 0) {
					QryColumnVo columna = null;
					String colName = null;
					String colShow = null;
					mustShowColumns = dBean.getMustShowColumns(showColumns.size());
						
					for (int i = 0; i < mustShowColumns.length; i++) {
						columna = (QryColumnVo) showColumns.get(Math.abs(mustShowColumns[i]) - 1);
						colShow = columna.getQryColHeadName();
						colName = columna.getQryColName(); 
						if (columna.getFlagValue(QryColumnVo.FLAG_IS_HIDDEN)) { 
							hiddenHtml.append("<input type=\"hidden\" name=\"orden\" value=\"" + columna.getQryColId().toString() + "\">");
						} else { %><tr><td><%=colShow%></td><td align="center"><input type="hidden" id="colOrden" name="orden" value="<%=columna.getQryColId().toString()%>"><input type="checkbox" name="<%=columna.getQryColId().toString()%>" value="1" <%=(mustShowColumns[i] >= 0)?"checked":""%>></td></tr><%
						}
					}
				}%></table></div><%= hiddenHtml.toString() %></FORM></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD><button type="button" onclick="up_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnUp")%>" title="<%=LabelManager.getToolTip(labelSet,"btnUp")%>"><%=LabelManager.getNameWAccess(labelSet,"btnUp")%></button><button type="button" onclick="down_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDown")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDown")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDown")%></button></TD><TD><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEjeApl")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEjeApl")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEjeApl")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEjeSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEjeSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEjeSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../../components/scripts/server/endModalInc.jsp" %><script>
var WORK_MODE 		= "<%=WORK_MODE%>";
</script><script src="<%=Parameters.ROOT_PATH%>/programs/query/administration/list/columnModal.js"></script>





