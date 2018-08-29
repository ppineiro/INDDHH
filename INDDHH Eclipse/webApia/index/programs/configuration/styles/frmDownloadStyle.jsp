<%@ page import = "com.dogma.vo.*"%><%@ page import	= "com.dogma.bean.configuration.*"%><%@ page import	= "com.dogma.util.DownloadUtil"%><%@ page import = "javax.activation.*"%><%@ page import = "java.io.*"%><%@ page import = "java.util.*"%><%	
	out.clear();
	StylesBean aBean = (StylesBean)session.getAttribute("dBean");
	//find bean
	ServletOutputStream outs = response.getOutputStream();
	
	response.setContentType("application/x-msdownload"); 

	response.setHeader("Content-Disposition", "attachment; filename=ApiaStyle.zip");

	try {
	
	FileInputStream in = new FileInputStream(aBean.download(request));

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
	

%>