<%@page import="java.net.URLEncoder"%><%@page import="java.io.FileInputStream"%><%@page import="com.dogma.vo.DocumentVo"%><%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%><%

DocumentVo dVo = (DocumentVo)session.getAttribute("docToDownload");
response.setContentType("application/force-download;charset="+com.dogma.Parameters.APP_ENCODING);
out.clear();

if(dVo == null) {
	response.setHeader("Content-Disposition", "attachment; filename=ERROR");
} else {
	ServletOutputStream outs = response.getOutputStream();
	String fileName = dVo.getDocName();

	String sourceFile;
	if (dVo.getWebDavTmpFilePath()!=null){
		sourceFile = dVo.getWebDavTmpFilePath();
	} else {
		sourceFile = dVo.getTmpFilePath();
	}
	
	if (fileName == null || sourceFile == null){
		response.setHeader("Content-Disposition", "attachment; filename=ERROR");
	} else {
		fileName = fileName.replaceAll(" ","_");
	
		byte[] fileNameBytes = fileName.getBytes(com.dogma.Parameters.APP_ENCODING);
    	String dispositionFileName = "";
    	for (byte b: fileNameBytes) dispositionFileName += (char)(b & 0xff);

    	if(request.getHeader("User-Agent").toLowerCase().contains("msie") || request.getHeader("User-Agent").toLowerCase().contains("trident") || request.getHeader("User-Agent").toLowerCase().contains("edge") ) {
    		dispositionFileName = URLEncoder.encode(fileName, com.dogma.Parameters.APP_ENCODING);
    	}
    	
    	String disposition = "attachment; filename=\"" + dispositionFileName + "\"";
    	response.setHeader("Content-disposition", disposition);
		
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
}
%>