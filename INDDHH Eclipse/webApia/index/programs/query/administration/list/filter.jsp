<%@page import="com.dogma.bean.query.TaskListBean"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="java.util.*"%><%@include file="../../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="qBeanReady" scope="session" class="com.dogma.bean.query.TaskListBean"></jsp:useBean><jsp:useBean id="qBeanInproc" scope="session" class="com.dogma.bean.query.TaskListBean"></jsp:useBean><%

String WORK_MODE = request.getParameter("workMode");
com.dogma.bean.query.TaskListBean dBean = null;
	if (WORK_MODE.equals(TaskListBean.WORKING_MODE_INPROCESS)) {
		dBean = qBeanInproc;
	} else {
		dBean = qBeanReady;
	} 
QueryVo queryVo = dBean.getQueryVo();
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titEjeFilLis")%></TD><TD></TD></TR></TABLE><div id="divContent"><FORM id="frmMain" name="frmMain" method="POST"><IFRAME id="frmSubmit" name="frmSubmit" style="display:none"></IFRAME><iframe name="iframeMessages" id="iframeMessages" src="<%=Parameters.ROOT_PATH%>/frames/feedBackWin.jsp" style="display:none"  class="feedBackFrame" frameborder="no" ></iframe><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtFil")%></DIV><table class="tblFormLayout"><%
				boolean addedNewLine = false;
				boolean addedEndLine = true;
				for (java.util.Iterator iterator = queryVo.getFilters().iterator(); iterator.hasNext(); ) {
					com.dogma.vo.filter.QryColumnFilterVo filter = (com.dogma.vo.filter.QryColumnFilterVo) iterator.next();
					if (com.dogma.vo.QryColumnVo.FUNCTION_NONE == filter.getFunction() && ! filter.isHidden()) {
						if (addedEndLine || filter.is2Column()) {
							if (filter.is2Column() && ! addedEndLine) {
								out.print("</tr>");
								addedEndLine = true;
							}
							out.print("<tr>");
							addedNewLine = true; 
						} else {
							addedNewLine = false; 
						} 
						out.print("<td align=\"right\" title=\"");
						out.print(dBean.fmtHTML(filter.getQryColumnVo().getQryColTooltip()));
						out.print("\">");
						out.print(dBean.fmtHTML(filter.getQryColumnVo().getQryColHeadName()));
						out.print(":</td>");
						out.print("<td ");
						out.print((filter.is2Column())?"colspan='3'":"");
						out.print(">");
						out.print(filter.getHTML(styleDirectory,queryVo.getFlagValue(QueryVo.FLAG_TO_PROCEDURE)));
						out.print("</td>");
						if (filter.is2Column()) {
							out.print("</tr>");
							addedEndLine = true;
							addedNewLine = false;
						} else if (! addedNewLine) {
							out.print("</tr>");
							addedEndLine = true;
						} else {
							addedEndLine = false;
						}
					}
				}
				if (! addedEndLine) {
					out.print("</tr>");
				} %></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEjeApl")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEjeApl")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEjeApl")%></button><button type="button" onclick="window.parent.returnValue=null;	window.parent.close();" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEjeSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEjeSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEjeSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../../components/scripts/server/endInc.jsp" %><script>
var WORK_MODE 		= "<%=WORK_MODE%>";
function stringType(field) {
	var rets = openModal("/programs/query/administration/filter/string.jsp?type=" + document.getElementById(field).value,500,200);
	var doAfter=function(rets){
		if (rets != null) {
			document.getElementById(field).value = rets;
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function numberType(field) {
	var rets = openModal("/programs/query/administration/filter/number.jsp?type=" + document.getElementById(field).value,500,220);
	var doAfter=function(rets){
		if (rets != null) {
			document.getElementById(field).value = rets;
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}
</script><script language='javascript' src='<%=Parameters.ROOT_PATH%>/programs/query/administration/list/filter.js'></script>