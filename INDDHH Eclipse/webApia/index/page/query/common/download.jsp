<%@page import="biz.statum.apia.web.action.query.QueryExecutionAction"%><%@page import="java.io.FileInputStream"%><%@page import="java.io.File"%><%@page import="jxl.Workbook"%><%@page import="jxl.write.WritableWorkbook"%><%@page import="java.util.Locale"%><%@page import="jxl.WorkbookSettings"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.UserData"%><%@page import="java.io.ByteArrayOutputStream"%><%@page import="biz.statum.apia.web.bean.query.QueryExecutionBean"%><%@page import="biz.statum.sdk.util.StringUtil"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%
out.clear();

HttpServletRequestResponse http = new HttpServletRequestResponse(request, response);
QueryExecutionBean aBean = QueryExecutionAction.staticRetrieveQueryExecutionBean(http);

response.setContentType("application/x-msdownload;charset="+com.dogma.Parameters.APP_ENCODING);
response.setHeader("Expires", "0");
response.setHeader("Cache-Control", "must-revalidate, post-check=0, pre-check=0");
response.setHeader("Pragma", "public");

String fileName = StringUtil.replaceAll(aBean.getQueryVo().getQryTitle(), StringUtil.SPACE_STRING, StringUtil.UNDERBAR_SEPARATOR);

if (QueryExecutionBean.EXPORT_FORMAT_CVS.equals(aBean.getExportFormat())) {
	response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + ".csv\"");

	out.print(aBean.generateQueryCsv(http));
	
} else if (QueryExecutionBean.EXPORT_FORMAT_EXCEL.equals(aBean.getExportFormat())) {
	response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + ".xls\"");
	
	Integer labelSet = Parameters.DEFAULT_LABEL_SET;
	Integer langId = Parameters.DEFAULT_LANG;
	
	UserData uData = aBean.getUserData(http);
	if (uData!=null) {
		labelSet = uData.getLabelSetId();
		langId = uData.getLangId();
	}
	
	String tmpFileName = Parameters.TMP_FILE_STORAGE + "/" + session.getId() + ".xls";
	WorkbookSettings ws = new WorkbookSettings();
	ws.setLocale(new Locale("en", "EN")); //TODO PF Ver de cambiar
	WritableWorkbook workbook = Workbook.createWorkbook(new File(tmpFileName), ws);
	aBean.generateQueryExcel(http,workbook);
	workbook.write();
	workbook.close();
	
	ServletOutputStream outs = response.getOutputStream();
	FileInputStream in = new FileInputStream(tmpFileName);
	byte[] buffer = new byte[8 * 1024];
	int count = 0;
	do {
		outs.write(buffer, 0, count);
		count = in.read(buffer, 0, buffer.length);
	} while (count != -1);
	
	in.close();
	outs.close();
	
} else if (QueryExecutionBean.EXPORT_FORMAT_HTML.equals(aBean.getExportFormat())) {
	response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + ".html\"");

	out.print(aBean.generateQueryHtml(http));

	
} else if (QueryExecutionBean.EXPORT_FORMAT_PDF.equals(aBean.getExportFormat())) {
	ByteArrayOutputStream baosPDF = aBean.generateQueryPdf(http);
	
	response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + ".pdf\"");	
	response.setContentLength(baosPDF.size());
	
	ServletOutputStream output = response.getOutputStream();
	baosPDF.writeTo(output);	
	
} else if (QueryExecutionBean.EXPORT_FORMAT_TXT.equals(aBean.getExportFormat())) {
	response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + ".txt\"");

	out.print(aBean.generateQueryCsv(http));

}

%>