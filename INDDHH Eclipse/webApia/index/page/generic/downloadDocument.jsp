<%@page import="java.io.FileInputStream"%><%@page import="com.dogma.vo.DocumentVo"%><%
DocumentVo dVo = (DocumentVo)session.getAttribute("docToDownload");
response.setContentType("application/x-msdownload;charset="+com.dogma.Parameters.APP_ENCODING);
out.clear();

ServletOutputStream outs = response.getOutputStream();
String sourceFile = dVo.getTmpFilePath();
String fileName = dVo.getDocName();

if (fileName == null || sourceFile == null){
	response.setHeader("Content-Disposition", "attachment; filename=ERROR");
} else {
	fileName = fileName.replaceAll(" ","_");

	System.out.println("sourceFile:" + sourceFile + ", fileName:" + fileName);
	response.setHeader("Content-Disposition", "attachment; filename=" + fileName);

	try {
	
		FileInputStream in = new FileInputStream(sourceFile);

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