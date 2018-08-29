<%@page import="biz.statum.sdk.util.StringUtil"%><%@page import="com.dogma.util.DownloadUtil"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.*"%><%@page import="com.st.util.labels.*"%><%@page import="jxl.*"%><%@page import="jxl.write.*"%><%@page import="javax.activation.*"%><%@page import="java.io.*"%><%@page import="java.util.*"%><jsp:useBean id="qBean" scope="session" class="com.dogma.bean.query.QryProAlterBean"></jsp:useBean><%
com.dogma.bean.query.QryProAlterBean dBean = qBean;
String fileName = StringUtil.replaceAll(qBean.getQueryVo().getQryTitle(), StringUtil.SPACE_STRING, StringUtil.UNDERBAR_SEPARATOR);
response.setContentType("application/x-msdownload;charset=ISO-8859-1");
response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + ".xls\"");
out.clear();

try {
	Integer labelSet = Parameters.DEFAULT_LABEL_SET;
	Integer langId = Parameters.DEFAULT_LANG;
	com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
	if (uData!=null) {
		labelSet = uData.getLabelSetId();
		langId = uData.getLangId();
	}
	String tmpFileName = Parameters.TMP_FILE_STORAGE + "/" + session.getId() + ".xls";
	WorkbookSettings ws = new WorkbookSettings();
	ws.setLocale(new Locale("en", "EN")); //TODO PF Ver de cambiar
	WritableWorkbook workbook = Workbook.createWorkbook(new File(tmpFileName), ws);
	dBean.generateQueryExcel(request,workbook);
	workbook.write();
	workbook.close();
	
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