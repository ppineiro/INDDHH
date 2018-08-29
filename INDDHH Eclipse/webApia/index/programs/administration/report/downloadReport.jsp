<%@page import="com.dogma.bean.administration.ReportBean"%><%@ page import = "com.dogma.vo.*"%><%@ page import	= "com.dogma.bean.*"%><%@ page import	= "com.dogma.util.DownloadUtil"%><%@ page import = "javax.activation.*"%><%@ page import = "java.io.*"%><%@ page import = "java.util.*"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.ReportBean"></jsp:useBean><%	
	out.clear();
	
	ReportVo repVo = dBean.getReportVo();
	
	ServletOutputStream outs = response.getOutputStream();

	response.setContentType("application/x-msdownload"); 

	if (repVo == null || repVo.getRepName() == null){
		response.setHeader("Content-Disposition", "attachment; filename=ERROR");
	} else {
		String sourceFile = repVo.getReportDefinitionPath();
		String fileName = repVo.getFileName();
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
	
			//Borramos el diseño del reporte del dir temporal
			File tmpRepFileDesign = new File(repVo.getReportDefinitionPath());
			tmpRepFileDesign.delete();
	
		} catch (Exception e) {
			e.printStackTrace();
			response.setHeader("Content-Disposition", "attachment; filename=ERROR");
		}
	}
%>