<%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.action.monitor.ProcessesAction"%><%@page import="biz.statum.apia.web.bean.monitor.ProcessesBean"%><%
response.setContentType("application/x-msdownload;charset="+com.dogma.Parameters.APP_ENCODING);
out.clear();

try {
	HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
	ProcessesBean dBean= ProcessesAction.staticRetrieveBean(http);
	StringBuffer content = dBean.generateTasksCsv(http);
	response.setHeader("Content-Disposition", "attachment; filename=\"monitor_task.csv\"");
	out.print(content.toString());
	
} catch (Exception e) {
	e.printStackTrace();
	response.setHeader("Content-Disposition", "attachment; filename=ERROR");
}

%>