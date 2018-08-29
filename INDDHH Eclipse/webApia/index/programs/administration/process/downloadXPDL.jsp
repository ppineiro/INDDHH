<%@page import="com.dogma.util.DownloadUtil"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.*"%><%@page import="com.st.util.labels.*"%><%@page import="jxl.*"%><%@page import="jxl.write.*"%><%@page import="javax.activation.*"%><%@page import="java.io.*"%><%@page import="java.util.*"%><%@page import="org.wfmc.x2008.xpdl21.PackageDocument"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.BPMNBean"></jsp:useBean><%
response.setContentType("application/x-msdownload;charset="+com.dogma.Parameters.APP_ENCODING);
response.setHeader("Content-Disposition", "attachment; filename=\"XpdlExportResult.xpdl\"");
out.clear();
FileInputStream in = null;
PrintWriter outWriter = null;
InputStreamReader insr = null;

try {
	String pathFile =  Parameters.TMP_FILE_STORAGE + File.separator + request.getSession().getId() + ".xpdl";
	dBean.exportProcessXPDL(request);

	outWriter = new PrintWriter(new OutputStreamWriter(response.getOutputStream(), "UTF-8"));
	
	in = new FileInputStream(pathFile);
	insr = new InputStreamReader(in,"UTF-8");
	// Read and write 8K chars at a time
	char[] buffer = new char[8 * 1024];   // 8Kchar buffer
	int count = 0;
	do {
		outWriter.write(buffer,0,count);
		count = insr.read(buffer, 0, buffer.length);
	} while (count != -1);
	outWriter.flush();
} catch (Exception e) {
	e.printStackTrace();
	response.setHeader("Content-Disposition", "attachment; filename=ERROR");
} finally {
	if (in != null) {
		in.close();
	}
	if (insr != null) {
		insr.close();
	}
	if (outWriter != null) {
		outWriter.close();
	}
}


%>