<%@page import="biz.statum.apia.web.action.monitor.BusinessAction"%><%@page import="biz.statum.apia.web.bean.monitor.BusinessBean"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="java.io.FileInputStream"%><%@page import="java.util.*"%><%
HttpServletRequestResponse http = new HttpServletRequestResponse(request, response);
BusinessBean dBean = BusinessAction.staticRetrieveBean(http);

try {
	ServletOutputStream outs = response.getOutputStream();
	FileInputStream in = new FileInputStream(dBean.getExportLocation());
	byte[] buffer = new byte[8 * 1024];
	int count = 0;
	do {
		outs.write(buffer, 0, count);
		count = in.read(buffer, 0, buffer.length);
	} while (count != -1);
	
	in.close();
	outs.close();
} catch (Exception e) {
	e.printStackTrace();
	response.setHeader("Content-Disposition", "attachment; filename=ERROR");
}

%>