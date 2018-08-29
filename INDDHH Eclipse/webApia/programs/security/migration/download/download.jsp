<%@page import="com.dogma.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.migration.*"%><%@page import="java.io.*"%><%@page import="java.util.*"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.MigrationBean"/><%
	if (dBean.isDownloadNow()) {
		// Get the filename and the data
		String fileName = Parameters.TMP_FILE_STORAGE + java.io.File.separator + dBean.getExportFileName() + ".zip";
		
		FileInputStream fileInput = new FileInputStream(fileName);
		int numOfBytes = fileInput.available();
		byte byteArray[] = new byte[numOfBytes];
		int nextByte = fileInput.read(byteArray);
		fileInput.close();
	
		// Write the information to the output
		response.setContentType("application/zip");
		response.setHeader("Content-Disposition","attachment;filename=" + dBean.getExportFileName() + ".zip"); 
		
		OutputStream outStream = response.getOutputStream();
		outStream.write(byteArray); 
		outStream.close();	
	}
%>

