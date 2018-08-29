<%@page import="com.dogma.util.DownloadUtil"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.*"%><%@page import="com.st.util.labels.*"%><%@page import="jxl.*"%><%@page import="jxl.write.*"%><%@page import="javax.activation.*"%><%@page import="java.io.*"%><%@page import="java.util.*"%><%@page import="com.dogma.*"%><%@page import="com.dogma.bean.execution.ListTaskBean"%><%@page import="com.dogma.vo.custom.ColumnVo"%><%@page import="com.dogma.vo.ProInstanceVo"%><jsp:useBean id="lBeanReady" scope="session" class="com.dogma.bean.execution.ListTaskBean"></jsp:useBean><jsp:useBean id="lBeanInproc" scope="session" class="com.dogma.bean.execution.ListTaskBean"></jsp:useBean><%

Integer labelSet = Parameters.DEFAULT_LABEL_SET;
Integer langId = Parameters.DEFAULT_LANG;
com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
if (uData!=null) {
	labelSet = uData.getLabelSetId();
	langId = uData.getLangId();
}

String WORK_MODE = request.getParameter("WORK_MODE");
String finalFileName = "";
if(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS)){ 
	finalFileName =LabelManager.getName(labelSet,langId,"titEjeMisTar");
}else{ 
	finalFileName =LabelManager.getName(labelSet,langId,"titEjeTarLib");
} 
response.setContentType("application/x-msdownload;charset="+com.dogma.Parameters.APP_ENCODING);
response.setHeader("Content-Disposition", "attachment; filename=\"" + finalFileName + ".xls\"");
out.clear();

try {
	

	String fileName = Parameters.TMP_FILE_STORAGE + "/" + session.getId() + ".xls";
	File objFile = new File(Parameters.TMP_FILE_STORAGE);
	if (!objFile.exists()) {
		objFile.mkdirs();
	}
	
	File newFile = new File(fileName);
	if (!newFile.exists()) {
		newFile.createNewFile();
	}
	
	WorkbookSettings ws = new WorkbookSettings();
	ws.setLocale(new Locale("en", "EN"));
	WritableWorkbook workbook = Workbook.createWorkbook(newFile, ws);
	WritableSheet sheet = workbook.createSheet(finalFileName,0);
	
	if (WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS)) {
		lBeanInproc.generateExcel(request,sheet);
	} else {
		lBeanReady.generateExcel(request,sheet);
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

%>