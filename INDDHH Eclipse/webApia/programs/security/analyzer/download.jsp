<%@ page import = "com.dogma.vo.*"%><%@ page import	= "com.dogma.bean.*"%><%@ page import	= "com.dogma.util.DownloadUtil"%><%@ page import = "javax.activation.*"%><%@ page import = "java.io.*"%><%@ page import = "java.util.*"%><%	
	com.dogma.bean.security.AnalyzerBean dBean = (com.dogma.bean.security.AnalyzerBean) session.getAttribute("dBean");
	out.clear();
	
	ServletOutputStream outs = response.getOutputStream();

	response.setContentType("application/x-msdownload"); 

	if (! dBean.isReportGenerated()){
		response.setHeader("Content-Disposition", "attachment; filename=ERROR");
	} else {
		try {
			String sourceFile = dBean.getFileLocation();
			String fileName = "execution_analyzer_" + com.st.util.DateUtil.dateToString(new Date(),"yyyyMMdd") + ".xls";
		
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
		
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