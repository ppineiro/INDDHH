<%@page import="biz.statum.sdk.util.FileUtil"%><%@page import="biz.statum.sdk.util.StringUtil"%><%@ page import = "java.io.File"%><%@page import="java.io.FileInputStream"%><%@page import="biz.statum.apia.web.action.design.DocumentationAction"%><%@page import="biz.statum.apia.web.bean.design.DocumentationBean"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%

out.clear();
String tmpFile = null;
try {
	HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
	DocumentationBean bean = DocumentationAction.staticRetrieveBean(http,false);
	tmpFile = bean.getTmpFile();
	
	if (tmpFile == null){
		response.setHeader("Content-Disposition", "attachment; filename=ERROR");
	} else {
		response.setContentType("application/x-msdownload;charset="+com.dogma.Parameters.APP_ENCODING);
		response.setHeader("Content-Disposition", "attachment; filename=\"documentation.rtf\"");
		
		FileInputStream in = new FileInputStream(tmpFile);
		ServletOutputStream outs = response.getOutputStream();
		
		byte[] buffer = new byte[8 * 1024];
		int count = 0;
		do {
			outs.write(buffer, 0, count);
			count = in.read(buffer, 0, buffer.length);
		} while (count != -1);

		in.close();
		outs.close();
	}
} catch (Exception e) {
	e.printStackTrace();
	response.setHeader("Content-Disposition", "attachment; filename=ERROR");
} 

%>