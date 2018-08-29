<%@page import="java.net.URLEncoder"%><%@page import="biz.statum.apia.utils.AES"%><%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><%@page import="com.dogma.document.DocumentsUtil"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.UserData"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.action.execution.FormAction"%><%@page import="biz.statum.apia.web.bean.execution.ExecutionBean"%><%@page import="biz.statum.apia.web.bean.execution.FormBean"%><%@page import="java.io.FileInputStream"%><%@page import="biz.statum.sdk.util.StringUtil"%><%@page import="biz.statum.sdk.util.FileUtil"%><%@page import="com.dogma.vo.DocumentVo"%><%
response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);
response.setContentType("application/force-download;charset=" + com.dogma.Parameters.APP_ENCODING);

out.clear();

String fileName = null;
Boolean deleteFile = false;

try {
	HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
	ExecutionBean eBean= FormAction.staticRetrieveBean(http);
	DocumentVo dVo = null;
	
	if(eBean==null){
		UserData uData = BasicBeanStatic.getUserDataStatic(request);
		
		
		
		dVo = new DocumentsUtil().getDocumentDownload(uData.getEnvironmentId(), Integer.valueOf(AES.decrypt(request.getParameter("docId"), uData.getTokenId())), uData);
		fileName = dVo.getTmpFilePath();
	} else {
		FormBean fBean = eBean.getFormBean(request);
		dVo = fBean.getDocumentDownload(http);
		
		if (dVo.getWebDavTmpFilePath()!=null){
			fileName = dVo.getWebDavTmpFilePath();
		} else {
			deleteFile = dVo.getDocId() != null && dVo.getDocId() >= 1000 && 
					StringUtil.notEmpty(fileName) && !dVo.isNewVersion();
			fileName = dVo.getTmpFilePath();
		}
	}
	
	
	String docName = dVo.getDocName().replaceAll(" ","_");
	
	byte[] fileNameBytes = docName.getBytes(com.dogma.Parameters.APP_ENCODING);
	String dispositionFileName = "";
	for (byte b: fileNameBytes) dispositionFileName += (char)(b & 0xff);

	if(request.getHeader("User-Agent").toLowerCase().contains("msie") || request.getHeader("User-Agent").toLowerCase().contains("trident") || request.getHeader("User-Agent").toLowerCase().contains("edge") ) {
		dispositionFileName = URLEncoder.encode(docName, com.dogma.Parameters.APP_ENCODING);
	}

	
	response.setHeader("Content-Disposition", "attachment; filename=\"" + dispositionFileName + "\"");
	response.setHeader("Content-Type", "application/force-download; name=\"" + dispositionFileName + "\"");

	
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
	if (deleteFile) FileUtil.deleteFile(fileName);
} catch (Exception e) {
	e.printStackTrace();
	response.setHeader("Content-Disposition", "attachment; filename=ERROR");
}
%>