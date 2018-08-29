<%@page import="biz.statum.apia.web.action.BasicAction"%><%@page import="biz.statum.apia.web.action.BasicListAction"%><%@page import="biz.statum.apia.web.bean.BasicAdminBean"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%
response.setContentType("application/x-msdownload;charset="+com.dogma.Parameters.APP_ENCODING);
response.setHeader("Content-Disposition", "attachment; filename=\"dependencies.txt\"");
out.clear();

try {
	HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
	BasicAdminBean bean = (BasicAdminBean) BasicListAction.staticRetrieveBean(http, BasicAction.BEAN_ADMIN_NAME);
	String content = bean.downloadDeps(http);
	
	out.print(content);
} catch (Exception e) {
	e.printStackTrace();
	response.setHeader("Content-Disposition", "attachment; filename=ERROR");
}

%>