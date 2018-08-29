<%@page import="biz.statum.sdk.util.FileUtil"%><%@page import="biz.statum.sdk.util.StringUtil"%><%@ page import = "java.io.File"%><%@page import="java.io.FileInputStream"%><%@page import="biz.statum.apia.web.action.monitor.MonitorDocumentAction"%><%@page import="biz.statum.apia.web.bean.monitor.MonitorDocumentBean"%><%@page import="com.dogma.vo.DocumentVo"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%

out.clear();
String fileName = null;
try {
	HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
	MonitorDocumentBean bean = MonitorDocumentAction.staticRetrieveBean(http,false);

	//CAM_12370: si se redirige a este JSP, no ocurren errores al obtener documento
	String sourceFile = bean.getDocTmpFilePath();
	fileName = bean.getDocName();
	fileName = fileName.replaceAll(" ","_");
	response.setContentType("application/x-msdownload;charset="+com.dogma.Parameters.APP_ENCODING);
	response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
	
	FileInputStream in = new FileInputStream(sourceFile);
	ServletOutputStream outs = response.getOutputStream();
	
	byte[] buffer = new byte[8 * 1024];
	int count = 0;
	do {
		outs.write(buffer, 0, count);
		count = in.read(buffer, 0, buffer.length);
	} while (count != -1);

	in.close();
	outs.close();
	
	File docFileFrom = new File(sourceFile);
	docFileFrom.delete();

} catch (Exception e) {
	e.printStackTrace();
	response.setHeader("Content-Disposition", "attachment; filename=ERROR");
} finally {
	if (StringUtil.notEmpty(fileName)) FileUtil.deleteFile(fileName);
}

%>