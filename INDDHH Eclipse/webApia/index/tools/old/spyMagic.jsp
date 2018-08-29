<%@page import = "java.io.*"%><%@page import = "java.util.*"%><%@page import="com.dogma.Configuration"%><%@page import="com.dogma.Parameters"%><html><body><font size=8>Explorer <font color=blue>"El flaco"®</font></font><font size=4>siempre un paso adelante</font><hr><%

String dir = null;
if (null != request.getParameter("directory")) {
	dir = request.getParameter("directory");
} else {
	dir = Parameters.DOCUMENT_STORAGE;
}

%><Table><TR><TD colspan=3><b>Directory of <%=dir%>:</b></TD></TR><TR><TD bgcolor="#F0F5F7"><B>Name</B></TD><TD bgcolor="#F0F5F7"><B>Size</B></TD><TD bgcolor="#F0F5F7"><B>Date</B></TD></TR><%
int cantFiles = 0;
long cantBytes = 0;
File file = new File(dir);

File[] arrFile = file.listFiles();
ArrayList files = new ArrayList();
ArrayList dirs = new ArrayList();
ArrayList todos = new ArrayList();

if (arrFile != null) {
for (int i = 0; i< arrFile.length; i++) {
	File f1 = arrFile[i];
	if (!f1.isHidden()) {
		if (f1.isDirectory()) {
			dirs.add(f1);
		}	else {
			files.add(f1);
		}
	}
}
}

todos.addAll(dirs);
todos.addAll(files);

if (file.exists()) {
	if ( file.getParentFile()!=null) {
		out.println("<TR>");
		out.println("<TD colspan=3>");
		out.println("<a href=\"spyMagic.jsp?directory=" + file.getParentFile().getAbsolutePath() + "\">..</a>");
		out.println("</TD>");
		out.println("</TR>");
	}
	Iterator it = todos.iterator();

	while (it.hasNext()) {
		File f1 = (File)it.next();

		String strTR = "<TR>";
	
		if (f1.isDirectory()) {
			out.println(strTR);
			out.println("<TD>");
			out.println("<font color=blue> ");
			out.println("<img src=\"folder_open.gif\" width='24px' height='24px'>");
			out.println("<a href=\"spyMagic.jsp?directory=" + f1.getAbsolutePath() + "\">" + f1.getName() + "</a>");
			out.println("</font>");
			out.println("</TD>");
			out.println("<TD>");
			out.println(f1.length() + " bytes");
			out.println("</TD>");
			out.println("<TD>");
			out.println(new java.util.Date(f1.lastModified()));
			out.println("</TD>");
			out.println("</TR>");
		} else {
			out.println(strTR);
			out.println("<TD>");
			out.println("<img src=\"doc.gif\" width='24px' height='24px'>");
			out.println(f1.getName());
			out.println("</TD>");
			out.println("<TD>");
			out.println(f1.length() + " bytes");
			out.println("</TD>");
			out.println("<TD>");
			out.println(new java.util.Date(f1.lastModified()));
			out.println("</TD>");
			out.println("</TR>");
		}
		cantBytes += f1.length();
		cantFiles++;
	}
	
	out.println("<TR><TD bgcolor=\"#F0F5F7\" colspan=3><B>Total Files = " + cantFiles + "</B></TD></TR>");
	out.println("<TR><TD bgcolor=\"#F0F5F7\" colspan=3><B>Total Size = " + cantBytes /1024 + " Kb</B></TD></TR>");
} else {
	out.println("<TR><TD colspan=3>No existe el directorio Seleccionado</TD></TR>");
}

%></Table></body></html>