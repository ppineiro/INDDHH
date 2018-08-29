<%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="com.dogma.vo.DocumentVo"%><%@page import="biz.statum.apia.web.action.execution.CustMonDocumentAction"%><%@page import="biz.statum.apia.web.bean.execution.CustMonDocumentBean"%><%@page import="biz.statum.sdk.util.FileUtil"%><%@page import="biz.statum.sdk.util.StringUtil"%><%@ page import = "java.io.File"%><%@page import="java.io.FileInputStream"%><%

out.clear();
String fileName = null;
try {
	HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
	CustMonDocumentBean bean = CustMonDocumentAction.staticRetrieveBean(http,false);
	DocumentVo docVo = bean.docDownload(http);
	
	if (docVo == null || docVo.getDocName() == null){
		response.setHeader("Content-Disposition", "attachment; filename=ERROR");
	} else {
		String sourceFile = docVo.getTmpFilePath();
		fileName = docVo.getDocName();
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
	}
} catch (Exception e) {
	e.printStackTrace();
	response.setHeader("Content-Disposition", "attachment; filename=ERROR");
} finally {
	if (StringUtil.notEmpty(fileName)) FileUtil.deleteFile(fileName);
}

%>