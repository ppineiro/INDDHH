 <%@page import="com.dogma.UserData"%><%@page import="com.dogma.controller.ThreadData"%><%@page import="java.io.File"%><%@page import="java.io.FileInputStream"%><%@page import="com.dogma.vo.DocumentVo"%><%

	response.setContentType("application/x-msdownload;charset="+com.dogma.Parameters.APP_ENCODING);
	out.clear();
	
	String docIdStr = request.getParameter("docId");
	String tokenId = request.getParameter("tokenId");
	
	if(docIdStr == null || tokenId == null) {
		response.setHeader("Content-Disposition", "attachment; filename=ERROR");
	}
	
	UserData uData = ThreadData.getUserData();
	
	if(uData == null) {
		response.setHeader("Content-Disposition", "attachment; filename=ERROR");
	}
	
	Integer docId = null;
	
	try {
		docId = Integer.parseInt(docIdStr);
	} catch(NumberFormatException nfe) {
		response.setHeader("Content-Disposition", "attachment; filename=ERROR");
	}
	
	String path = uData.getDocumentPath(docId);

	if(path == null || "".equals(path)) {
		response.setHeader("Content-Disposition", "attachment; filename=ERROR");
	}
 
	ServletOutputStream outs = response.getOutputStream();
	String fileName = new File(path).getName();
	
	if (fileName == null){
		response.setHeader("Content-Disposition", "attachment; filename=ERROR");
	} else {
		fileName = fileName.replaceAll(" ","_");
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
	
		try {
		
			FileInputStream in = new FileInputStream(path);
	
			byte[] buffer = new byte[8 * 1024];
			int count = 0;
			do {
				outs.write(buffer, 0, count);
				count = in.read(buffer, 0, buffer.length);
			} while (count != -1);
	
			in.close();
			outs.close();
	
		} catch (Exception e) {
			response.setHeader("Content-Disposition", "attachment; filename=ERROR");
		}
	}
%>