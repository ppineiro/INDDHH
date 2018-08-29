<%@page import="com.dogma.bean.GenericBean"%><%@page import="com.dogma.Parameters"%><jsp:useBean id="cBean" scope="session" class="com.dogma.bean.administration.CubeBean"></jsp:useBean><%
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
Integer dbConId=(!"null".equals(request.getParameter("dbConId"))?new Integer(request.getParameter("dbConId")):null);
Integer pageNum=(null != request.getParameter("pageNum") && !"null".equals(request.getParameter("pageNum"))?new Integer(request.getParameter("pageNum")):null);
boolean update=(null != request.getParameter("update") && "true".equals(request.getParameter("update"))?true:false);
String xml;
if (pageNum == null){
	cBean.loadTablesCol(request,dbConId);
	xml = cBean.getTablesXML(request,dbConId,new Integer(1));
}else{
	if (cBean.getDbConTables()==null || cBean.getDbConTables().size() == 0 || update){
		cBean.loadTablesCol(request,dbConId);
	}
	xml = cBean.getTablesXML(request,dbConId,pageNum);
}
out.clear();
out.print(xml);
%>