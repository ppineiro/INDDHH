<%@page import="com.dogma.UserData"%><%@ page import = "com.dogma.vo.*"%><%@ page import	= "com.dogma.bean.*"%><%@ page import	= "com.dogma.util.DownloadUtil"%><%@ page import = "javax.activation.*"%><%@ page import = "java.io.*"%><%@ page import = "java.util.*"%><%	
	
	ServletOutputStream outs = response.getOutputStream();

	response.setContentType("application/x-msdownload"); 
	if (request.getParameter("path")==null || "".equals(request.getParameter("path"))){
		response.setHeader("Content-Disposition", "attachment; filename=ERROR");
	} else {
		String sourceFile = request.getParameter("path");
		String fileName = request.getParameter("name") + request.getParameter("type");
		
		System.out.println("fileName:" + fileName + ", sourceFile:" + sourceFile);
		
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
		}finally{
			out.clear();
			out = pageContext.pushBody();
		}
}

%>