<%@ page import = "com.dogma.vo.*"%><%@ page import	= "com.dogma.bean.*"%><%@ page import	= "com.dogma.util.DownloadUtil"%><%@ page import = "javax.activation.*"%><%@ page import = "java.io.*"%><%@ page import = "java.util.*"%><%
	DocumentBean dBean = ((DogmaAbstractBean) session.getAttribute("dBean")).getDocumentBean(request);
	out.clear();
	DocumentVo docVo = null;
	if (request.getParameter("version") == null) {
		docVo = dBean.getDocumentDownload(request);
	} else {
		docVo = dBean.getDocumentVersionDownload(request);
	}

	if (docVo == null){
	} else {
		String sourceFile = docVo.getTmpFilePath();
		String fileName = docVo.getDocName();

 	 	OutputStream outs = response.getOutputStream();
		FileInputStream in = new FileInputStream(sourceFile);

		String contentType = DownloadUtil.getContentType(sourceFile);	
	
		response.setContentType(contentType);
	
		int bufferLength = 8 * 1024;
		byte[] buffer = new byte[bufferLength];
		
		File f = new File(sourceFile);
		boolean hasMain = false;
		boolean hasRest = false;
  		long readCounts = 0;
		long rest = 0;
		int count = 0;
		long countTotal = 0;
		
		if (f.length() >= bufferLength) {
			readCounts = (f.length() / bufferLength);
			rest = f.length() % bufferLength;
			hasMain = true;
			hasRest = (rest > 0);
		} else {
			hasMain = false;
			hasRest = true;
			rest = f.length();
		}
	
		f = null;
		if (hasMain) {
			for (int i = 0; i <= readCounts; i++) {
				count = in.read(buffer, 0, buffer.length);
				outs.write(buffer, 0, buffer.length);
				countTotal += count;
			}
		}
		
	
		if (hasRest) {
			// the rest
			buffer = new byte[(int)rest];	
			count = in.read(buffer, 0, buffer.length);
			outs.write(buffer, 0, buffer.length);
			countTotal += count;
		}
		
		in.close();
		outs.flush();
		
	}
%>