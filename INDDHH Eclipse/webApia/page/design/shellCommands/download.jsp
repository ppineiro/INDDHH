<%@page import="biz.statum.apia.web.action.design.ShellCommandsAction"%><%@page import="biz.statum.apia.web.bean.design.ShellCommandsBean"%><%@page import="biz.statum.sdk.util.FileUtil"%><%@page import="biz.statum.sdk.util.StringUtil"%><%@page import="java.io.FileInputStream"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%
response.setContentType("application/force-download;charset="+com.dogma.Parameters.APP_ENCODING);
response.setHeader("Content-Disposition", "attachment; filename=\"ShellCommandsLog.txt\"");
out.clear();

String fileName = null;

try {
	HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
	ShellCommandsBean bean= ShellCommandsAction.staticRetrieveBean(http);
	fileName = bean.downloadLog(http);
	ServletOutputStream outs = response.getOutputStream();
	FileInputStream in = new FileInputStream(fileName);
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