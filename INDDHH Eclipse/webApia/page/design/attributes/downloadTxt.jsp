<%@page import="biz.statum.apia.web.bean.design.AttributesBean"%><%@page import="biz.statum.apia.web.action.design.AttributesAction"%><%@page import="biz.statum.sdk.util.FileUtil"%><%@page import="biz.statum.sdk.util.StringUtil"%><%@page import="java.io.FileInputStream"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%
response.setContentType("application/force-download;charset="+com.dogma.Parameters.APP_ENCODING);
response.setHeader("Content-Disposition", "attachment; filename=\"dataDictionary.txt\"");
out.clear();

try {
	HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
	AttributesBean bean = AttributesAction.staticRetrieveBean(http);
	out.print(bean.exportAttributesTxt(http));
} catch (Exception e) {
	e.printStackTrace();
	response.setHeader("Content-Disposition", "attachment; filename=ERROR");
} finally {
}

%>