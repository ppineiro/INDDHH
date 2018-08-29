<%@page import="java.io.FileInputStream"%><%@page import="java.io.DataInputStream"%><%@page import="com.dogma.Configuration"%><%@page import="com.dogma.busClass.object.Parameter"%><%@page import="javax.imageio.ImageIO"%><%@page import="java.io.ByteArrayOutputStream"%><%@page import="java.awt.image.BufferedImage"%><%@page import="java.io.File"%><%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%><%
	String tmpPath = Configuration.TMP_FILE_STORAGE + "/"
			+ request.getParameter("tmpPath");

	File file = new File(tmpPath);
	int length = 0;
	ServletOutputStream outStream = response.getOutputStream();
	ServletContext context = getServletConfig().getServletContext();
	String mimetype = context.getMimeType(tmpPath);

	// sets response content type
	if (mimetype == null) {
		mimetype = "application/octet-stream";
	}
	response.setContentType(mimetype);
	response.setContentLength((int) file.length());
	String fileName = file.getName();

	// sets HTTP header
	response.setHeader("Content-Disposition", "attachment; filename=\""
			+ fileName + "\"");

	byte[] byteBuffer = new byte[4096];
	DataInputStream in = new DataInputStream(new FileInputStream(file));

	out.clear();

	// reads the file's bytes and writes them to the response stream
	while ((in != null) && ((length = in.read(byteBuffer)) != -1)) {
		outStream.write(byteBuffer, 0, length);
	}

	in.close();
	outStream.close();
%>