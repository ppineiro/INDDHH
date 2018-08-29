<%@ page import = "com.dogma.vo.*"%><%@ page import	= "com.dogma.bean.*"%><%@ page import	= "com.dogma.util.DownloadUtil"%><%@ page import = "javax.activation.*"%><%@ page import = "java.io.*"%><%@ page import = "java.util.*"%><%	

	out.clear();
	DogmaAbstractBean aBean = (DogmaAbstractBean)session.getAttribute("dBean");
	//find bean
	com.dogma.bean.execution.FormBean fBean = aBean.getFormBean(request);
	DocumentVo docVo = null;
	
	
	//if (request.getParameter("version") == null) {
		docVo = fBean.getDocumentDownloadTMP(request);
	//} else {
	//	docVo = fBean.getDocumentVersionDownload(request);
	//}
	ServletOutputStream outs = response.getOutputStream();

	response.setContentType("application/x-msdownload"); 

	if (docVo == null || docVo.getDocName() == null){
		response.setHeader("Content-Disposition", "attachment; filename=ERROR");
	} else {
		String sourceFile = docVo.getTmpFilePath();
		String fileName = docVo.getDocName();
	
		if (sourceFile == null) {
			sourceFile = com.dogma.Parameters.DOCUMENT_STORAGE + java.io.File.separator + docVo.getDocPath();
		}
		
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