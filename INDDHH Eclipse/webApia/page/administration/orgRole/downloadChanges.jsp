<%@page import="com.dogma.Parameters"%><%@page import="java.io.FileInputStream"%><%@page import="java.io.File"%><%
out.clear();

response.setContentType("application/force-download");
response.setHeader("Content-Disposition", "attachment;filename=OrganizationalRoleChanges.xls");

File file = new File(Parameters.TMP_FILE_STORAGE + File.separator + request.getParameter("path"));
FileInputStream fileIn = new FileInputStream(file);
ServletOutputStream sos = response.getOutputStream();

byte[] outputByte = new byte[4096];
//copy binary contect to output stream
while(fileIn.read(outputByte, 0, 4096) != -1) {
	sos.write(outputByte, 0, 4096);
}
fileIn.close();
sos.flush();
sos.close();

%>