<%@page import="com.dogma.vo.*"%><%@page import="com.st.util.XMLUtils"%><%@page import="com.dogma.vo.custom.*"%><%@page import="com.dogma.BIParameters"%><%@include file="../../../components/scripts/server/startInc.jsp"%><jsp:useBean id="wBean" scope="session" class="com.dogma.bean.administration.WidgetBean"></jsp:useBean><%@page import="java.util.Collection"%><%@page import="java.util.Iterator"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp"%><% Integer widId = null;
   Collection comCol = null;
   WidgetVo widVo = null;
   String lastUpdate = null;
   
   if (request.getParameter("widId") != null){ //from widgtet of type cube or query
	   widId = new Integer(request.getParameter("widId"));
   }else if (request.getParameter("gaugeID") != null){ //from widget of type kpi
	   widId = new Integer(request.getParameter("gaugeID"));
   }
   if (request.getParameter("lastUpdate") != null){
	   lastUpdate = request.getParameter("lastUpdate");
   }
   widVo = wBean.getWidgetVo(widId);
   Collection colInformation = wBean.getColInformation(widId);
%><title><%=LabelManager.getName(labelSet,"titWidInfo").replace("<TOK1>", " '" + widVo.getWidTitle())+ "' "%></title></head><body style="overflow:auto"'><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titWidInfo").replace("<TOK1>", " '" + widVo.getWidTitle())+ "' "%></TD><TD></TD></TR></TABLE><div id="divContent"><div><table><tr><td></td><td></td></tr><tr><td></td><td></td></tr><%if (colInformation!=null && colInformation.size()>0){ 
		Iterator itInformation = colInformation.iterator();
		while (itInformation.hasNext()){
			WidInformationVo widInfoVo = (WidInformationVo) itInformation.next();
			if (WidInformationVo.WID_INFO_LAST_UPDATE.equals(widInfoVo.getWidInfoType()) && widInfoVo.getWidInfoVisible().intValue()==1){%><tr><td align="right" width="150px"><b><%=LabelManager.getName(labelSet,"lblWidLastUpdate")%>:</b></td><td align="left"><%=wBean.getWidLastUpdate(widId, lastUpdate)%></td></tr><%}else if (WidInformationVo.WID_INFO_SOURCE_DATA.equals(widInfoVo.getWidInfoType()) && widInfoVo.getWidInfoVisible().intValue()==1){%><tr><td align="right"><b><%=LabelManager.getToolTip(labelSet,"lblWidSource")%>:</b></td><%if (widVo.getWidType().intValue() == WidgetVo.WIDGET_TYPE_CUSTOM_ID.intValue()){%><td align="left" title="<%=wBean.getWidHtmlCode(widId)%>"><%=wBean.getWidSource(widId)%></td><%}else {%><td align="left"><%=wBean.getWidSource(widId)%></td><%} %></tr><%}else if (widInfoVo.getWidInfoVisible().intValue()==1){%><tr><td align="right"><b><%=widInfoVo.getWidInfoType()%>:</b></td><td align="left"><%=widInfoVo.getWidInfoDesc()%></td></tr><%}
		}
	}%></table></div></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD colspan=3 align="right"><button type="button" onclick="window.close()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp"%>