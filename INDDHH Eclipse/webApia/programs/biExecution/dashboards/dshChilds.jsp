<%@page import="com.dogma.vo.*"%><%@page import="com.st.util.XMLUtils"%><%@page import="com.dogma.vo.custom.*"%><%@page import="com.dogma.BIParameters"%><%@include file="../../../components/scripts/server/startInc.jsp"%><jsp:useBean id="wBean" scope="session" class="com.dogma.bean.administration.WidgetBean"></jsp:useBean><%@page import="java.util.Collection"%><%@page import="java.util.Iterator"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp"%><% Integer widId = null;
   Collection widCol = null;

   if (request.getParameter("widId") != null){ //from widgtet of type cube or query
	   widId = new Integer(request.getParameter("widId"));
   }else if (request.getParameter("gaugeID") != null){ //from widget of type kpi
	   widId = new Integer(request.getParameter("gaugeID"));
   }
   widCol = wBean.getWidChilds(widId);
   int cantWidgets = 0;
   if (widCol!=null){
   		cantWidgets = widCol.size();
   }
   
   WidgetVo widFatherVo = wBean.getWidgetVo(widId);
%><title><%=LabelManager.getName(labelSet,"titWidChilds").replace("<TOK1>", " " + widFatherVo.getWidName())+ " "%></title></head><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titWidChilds").replace("<TOK1>", " " + widFatherVo.getWidName())+ " "%></TD><TD></TD></TR></TABLE><div id="divContent"><% if (widCol!=null && widCol.size()>0){
	Iterator widIt = widCol.iterator();
	while (widIt.hasNext()){
		WidgetVo widVo = (WidgetVo) widIt.next();%><iframe id="ifrMain" frameborder="0" allowtransparency="true" width="<%=widVo.getWidWidth()%>" height="<%=widVo.getWidHeight()%>" src="biExecution.DashboardAction.do?action=loadWidget&executeHere=true&widId=<%=widVo.getWidId().intValue()%>&widType=<%=widVo.getWidType().intValue()%>"></iframe><%}%><%}%></div></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD colspan=3 align="right"><button type="button" onclick="window.close()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE><body style="overflow:auto"></body></html><%@include file="../../../components/scripts/server/endInc.jsp"%>

