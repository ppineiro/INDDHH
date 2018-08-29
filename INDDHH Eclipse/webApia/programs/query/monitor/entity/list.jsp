<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="java.util.*"%><%@page import="com.dogma.bean.execution.EntInstanceBean"%><%@include file="../../../../components/scripts/server/startInc.jsp" %><% boolean canOrderBy = false; %><HTML><head><%@include file="../../../../components/scripts/server/headInclude.jsp" %></head><body onLoad="onLoadHtml();"><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.query.MonitorEntityBean"></jsp:useBean><%
String urlAction = request.getParameter("action");
boolean blnSpecific = ! dBean.getFilter().isGlobal();
boolean showFilter = urlAction != null && urlAction.length() > 0 && "init".equals(urlAction);
boolean blnProcess = false;
boolean blnStatus = false;
 %><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titMonEnt")%><%if (blnSpecific) {%> : <%=dBean.getBusEntityVo().getBusEntTitle()%><%}%></TD><TD></TD></TR></TABLE><DIV id="divContent"  <%=cmp_div_height%> class="divContent"><form id="frmMain" name="frmMain" method="POST"><%@include file="filter.jsp" %><%@include file="result.jsp" %></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><script src="<%=Parameters.ROOT_PATH%>/programs/query/monitor/entity/list.js"></script><script>
	function onLoadHtml() {
	<% if (showFilter) { %>
		toggleFilterSection(<%=Parameters.SCREEN_LIST_SIZE - Parameters.FILTER_LIST_SIZE%>,<%=(Parameters.SCREEN_LIST_SIZE)%>);
	<% } %>
	}

</script><%@include file="../../../../components/scripts/server/endInc.jsp" %>