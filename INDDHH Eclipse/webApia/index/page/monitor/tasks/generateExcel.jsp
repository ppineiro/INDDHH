<%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><%@page import="biz.statum.apia.web.action.monitor.TasksAction"%><%@page import="biz.statum.apia.web.bean.monitor.TasksBean"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="com.dogma.util.DownloadUtil"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.*"%><%@page import="com.st.util.labels.*"%><%@page import="jxl.*"%><%@page import="jxl.write.*"%><%@page import="javax.activation.*"%><%@page import="java.io.*"%><%@page import="java.util.*"%><%

HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
TasksBean dBean= TasksAction.staticRetrieveBean(http);

if (dBean.getMessages().size()==0){

response.setContentType("application/x-msdownload;charset="+com.dogma.Parameters.APP_ENCODING);
response.setHeader("Content-Disposition", "attachment; filename=\"monitor.xls\"");
out.clear();

try {
	Integer labelSet = Parameters.DEFAULT_LABEL_SET;
	Integer langId = Parameters.DEFAULT_LANG;
	com.dogma.UserData uData = BasicBeanStatic.getUserDataStatic(request);
	if (uData!=null) {
		labelSet = uData.getLabelSetId();
		langId = uData.getLangId();
	}
	
	String fileName = Parameters.TMP_FILE_STORAGE + "/" + session.getId() + ".xls";
	
	WorkbookSettings ws = new WorkbookSettings();
	ws.setLocale(new Locale("en", "EN"));
	WritableWorkbook workbook = Workbook.createWorkbook(new File(fileName), ws);
	
	if (dBean.isFromList()) {
		dBean.generateListExcel(http,workbook);
	} else {
		dBean.generateTasksExcel(http,workbook);
	}
	
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
}
%>