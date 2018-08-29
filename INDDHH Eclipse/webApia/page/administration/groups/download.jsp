<%@page import="biz.statum.apia.web.action.administration.GroupsAction"%><%@page import="biz.statum.apia.web.bean.administration.GroupsBean"%><%@page import="biz.statum.sdk.util.FileUtil"%><%@page import="biz.statum.sdk.util.StringUtil"%><%@page import="java.io.FileInputStream"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%
String filePath = null;
try {
	HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
	GroupsBean bean = GroupsAction.staticRetrieveBean(http);
	filePath = bean.getDownloadFilePath();
	
	String fileName = bean.getFileName(http); 
	response.setContentType("application/force-download;charset="+com.dogma.Parameters.APP_ENCODING);
	response.setHeader("Content-Disposition", "attachment; filename=\""+fileName+"\"");
	out.clear();
	
	ServletOutputStream outs = response.getOutputStream();
	FileInputStream in = new FileInputStream(filePath);
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
} finally {
	if (StringUtil.notEmpty(filePath)) FileUtil.deleteFile(filePath);
}
%>