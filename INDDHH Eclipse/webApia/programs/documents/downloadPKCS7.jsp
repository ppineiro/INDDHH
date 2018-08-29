
<%@page import="com.dogma.bean.DocumentBean"%><%@page import="com.dogma.bean.execution.FormBean"%><%@page import="java.util.Iterator"%><%@page import="java.util.Collection"%><%@page import="com.dogma.bean.query.MonitorProcessesBean"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%	
DogmaAbstractBean aBean = (DogmaAbstractBean)session.getAttribute("dBean");


DocumentBean bean = aBean.getDocumentBean(request);
	
	if (bean.getPcks7()!=null){
		out.clear();
		ServletOutputStream outs = response.getOutputStream();
		response.setContentType("application/x-msdownload"); 
		response.setHeader("Content-Disposition", "attachment; filename=documentSign.pkcs7");
		try {
				outs.write(bean.getPcks7());
		} catch (Exception e) {
			e.printStackTrace();
			response.setHeader("Content-Disposition", "attachment; filename=ERROR");
		}
	}
%>