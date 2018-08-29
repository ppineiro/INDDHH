<%@page import="com.dogma.bean.administration.BPMNBean"%><%@ page import = "com.dogma.vo.*"%><%@ page import	= "com.dogma.bean.*"%><%@ page import	= "com.dogma.util.DownloadUtil"%><%@ page import = "javax.activation.*"%><%@ page import = "java.io.*"%><%@ page import = "java.util.*"%><%


BPMNBean dBean = (BPMNBean) session.getAttribute("dBean");
	out.clear();
	
	ServletOutputStream outs = response.getOutputStream();

	response.setContentType("application/x-msdownload"); 
	System.out.println(request.getParameter("filePath"));
	if (request.getParameter("filePath")==null){
		response.setHeader("Content-Disposition", "attachment; filename=ERROR");
	} else {
		String sourceFile = request.getParameter("filePath");
		String fileName = dBean.getProcessVo().getProName() + ".pdf";
	
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