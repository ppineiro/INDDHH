<%@page import="com.dogma.vo.ReportVo"%><%@page import="biz.statum.apia.web.bean.design.ReportBean"%><%@page import="biz.statum.apia.web.action.design.ReportAction"%><%@page import="biz.statum.sdk.util.FileUtil"%><%@page import="biz.statum.sdk.util.StringUtil"%><%@page import="java.io.FileInputStream"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@ page import = "javax.activation.*"%><%@ page import = "java.io.*"%><%@ page import = "java.util.*"%><%
response.setContentType("application/force-download;charset="+com.dogma.Parameters.APP_ENCODING);
response.setHeader("Content-Disposition", "attachment; filename=\"dataDictionary.xls\"");
out.clear();

HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
ReportBean bean= ReportAction.staticRetrieveBean(http);

ServletOutputStream outs = response.getOutputStream();

response.setContentType("application/force-download");

String sourceFile = bean.getReportDefinitionPath();
String fileName = bean.getFileNameStr();

if (fileName == null || sourceFile == null){
	response.setHeader("Content-Disposition", "attachment; filename=ERROR");
} else {
	sourceFile = bean.getReportDefinitionPath();
	fileName = bean.getFileNameStr();
	fileName = fileName.replaceAll(" ","_");

	System.out.println("sourceFile:" + sourceFile + ", fileName:" + fileName);
	response.setHeader("Content-Disposition", "attachment; filename=" + fileName);

	try {
	
		FileInputStream in = new FileInputStream(sourceFile);

		byte[] buffer = new byte[8 * 1024];
		int count = 0;
		do {
			outs.write(buffer, 0, count);
			count = in.read(buffer, 0, buffer.length);
		} while (count != -1);

		in.close();
		outs.close();

		//Borramos el diseño del reporte del dir temporal
		//File tmpRepFileDesign = new File(sourceFile);
		//tmpRepFileDesign.delete();

	} catch (Exception e) {
		e.printStackTrace();
		response.setHeader("Content-Disposition", "attachment; filename=ERROR");
	}
}

%>