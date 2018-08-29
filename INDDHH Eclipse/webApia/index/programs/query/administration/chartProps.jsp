<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.*"%><%@page import="com.dogma.business.*"%><%@page import="com.dogma.bean.scheduler.SchedulerBean"%><%@page import="com.dogma.dao.DataBaseDAO"%><%@page import="java.util.*"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.business.querys.factory.*" %><%@page import="com.dogma.bean.query.AdministrationBean" %><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %><%!
private String generateCode(AdministrationBean dBean, PropertyVo prpVo, String labelSet) {
	StringBuffer buffer = new StringBuffer();

	//Generación de la etiqueta
	buffer.append("<tr>");
	buffer.append("<td>");
	buffer.append(LabelManager.getName(labelSet,prpVo.getPrpName()));
	buffer.append("</td>");

	//Generación del input
	buffer.append("<td>");
	buffer.append("<input type=\"hidden\" name=\"prpId\" value=\"" + prpVo.getPrpId() + "\">");
	buffer.append("<input type=\"hidden\" name=\"prpType" + prpVo.getPrpId() + "\" value=\"" + prpVo.getPrpType() + "\">");
	String check = "";
	if (dBean.fmtHTMLObject(prpVo.getPrpValue()).equals("on")){
		check = "checked";
	}
	buffer.append("<input type=\"checkbox\" name=\"prpValue" + prpVo.getPrpId() + "\"" + check);
	
	if (PropertyVo.TYPE_DATE.equals(prpVo.getPrpType())) {
		buffer.append(" class=\"txtDate\" size=\"10\" p_mask=\"" + DogmaUtil.getHTMLDateMask(dBean.getEnvironmentId()) + "\" p_calendar=\"true\"");
	} else if (PropertyVo.TYPE_NUMERIC.equals(prpVo.getPrpType())) {
		buffer.append(" p_numeric=\"true\"");
	}
	
	buffer.append(">");

	if (PropertyVo.TYPE_DATE.equals(prpVo.getPrpType())) {
		buffer.append("<img src=\"" + Parameters.ROOT_PATH + "/styles/default/images/btn_cal.gif\" onclick=\"if(this.previousSibling.disabled==false){getCalendar(this.previousSibling)}\">");
	}
	
	buffer.append("</td>");
	buffer.append("</tr>");

	System.out.println(buffer.toString());

	return buffer.toString();
}
%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.query.AdministrationBean"></jsp:useBean></head><body><iframe name="iframeMessages" id="iframeMessage" src="<%=Parameters.ROOT_PATH%>/frames/feedBackWin.jsp" class="feedBackFrame" frameborder="no" style="display:none;" ></iframe><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titProps")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false" target="frmSubmit"><IFRAME id="frmSubmit" name="frmSubmit" style="display:none"></IFRAME><br><div type="grid" id="gridForms" style="height:80px"><table class="tblDataGrid" cellpadding="0" cellspacing="0"><thead><tr><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th><th style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblValue")%>"><%=LabelManager.getName(labelSet,"lblValue")%></th></tr></thead><tbody ><%
			   		if (dBean.getChartProperties() != null) {
				   		for (Iterator it = dBean.getChartProperties().iterator(); it.hasNext(); ) {
				   			PropertyVo prpVo = (PropertyVo) it.next(); 
				   			%><%= generateCode(dBean,prpVo,labelSet) %><%
				   		}
				   	} %></tbody></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD>&nbsp;</TD><TD><button id="btnConf" onclick="btnConfChartProps_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button onclick="btnExitChartProps_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/query/administration/updateCharts.js'></script><script language="javascript"></script>