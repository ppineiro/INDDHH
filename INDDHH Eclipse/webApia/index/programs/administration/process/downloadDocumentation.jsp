<%@page import="com.dogma.Parameters"%><%@page import="com.dogma.bean.administration.ProcessBean"%><%@ page import = "com.dogma.vo.*"%><%@ page import	= "com.dogma.bean.*"%><%@ page import	= "com.dogma.util.DownloadUtil"%><%@ page import = "javax.activation.*"%><%@ page import = "java.io.*"%><%@ page import = "java.util.*"%><%

	ProcessBean dBean = (ProcessBean) session.getAttribute("dBean");
	out.clear();

	String whatToDo = request.getParameter("do");
	
	if ("download".equals(whatToDo)) {
		ServletOutputStream outs = response.getOutputStream();
	
		dBean.setBuildProcessDocumentation(Boolean.FALSE);
		
		response.setContentType("application/x-msdownload"); 
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
		
	} else if ("status".equals(whatToDo)) {
		Boolean value = dBean.isBuildProcessDocumentation();
		if (value == null) value = Boolean.TRUE;
		
		response.setContentType("text/xml");
		String result = "<?xml version=\"1.0\" encoding=\"" + Parameters.APP_ENCODING + "\"?><result>" + value.toString() + "</result>";
		
		if (dBean.getHasException()) result = dBean.getMessagesAsXml(request);

		out.write(result);
	}
%>