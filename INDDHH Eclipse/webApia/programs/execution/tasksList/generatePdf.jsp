<%@page import="com.dogma.util.DownloadUtil"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.*"%><%@page import="com.dogma.util.*"%><%@page import="com.st.util.labels.*"%><%@page import="javax.activation.*"%><%@page import="java.io.*"%><%@page import="java.util.*"%><%@page import="com.dogma.bean.execution.ListTaskBean"%><%@page import="com.dogma.vo.custom.ColumnVo"%><%@page import="com.dogma.vo.ProInstanceVo"%><jsp:useBean id="lBeanReady" scope="session" class="com.dogma.bean.execution.ListTaskBean"></jsp:useBean><jsp:useBean id="lBeanInproc" scope="session" class="com.dogma.bean.execution.ListTaskBean"></jsp:useBean><%

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
out.clear();

try {
	String template = "";
	String sourceFile = null;
	if (WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS)) {
		sourceFile = lBeanInproc.generatePdf(request);
	} else {
		sourceFile = lBeanReady.generatePdf(request);
	}
	
	if (sourceFile != null) {
		
		
		response.setContentType("application/x-msdownload;charset="+com.dogma.Parameters.APP_ENCODING);
		response.setHeader("Expires", "0");
		response.setHeader("Cache-Control", "must-revalidate, post-check=0, pre-check=0");
		response.setHeader("Pragma", "public");
		
		response.setHeader("Content-Disposition", "attachment; filename=\"" + finalFileName + ".pdf\"");	
		
		ServletOutputStream outs = response.getOutputStream();

		FileInputStream in = new FileInputStream(sourceFile);

		byte[] buffer = new byte[8 * 1024];
		int count = 0;
		do {
			outs.write(buffer, 0, count);
			count = in.read(buffer, 0, buffer.length);
		} while (count != -1);

		in.close();
		outs.close();
		
	} else {
		response.setHeader("Content-Disposition", "attachment; filename=ERROR");
	}
} catch (Exception e) {
	e.printStackTrace();
	response.setHeader("Content-Disposition", "attachment; filename=ERROR");
}

%>