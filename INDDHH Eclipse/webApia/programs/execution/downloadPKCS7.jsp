<%@page import="com.dogma.bean.DogmaAbstractBean"%><%	
	DogmaAbstractBean aBean = (DogmaAbstractBean)session.getAttribute("dBean");
	//find bean
	com.dogma.bean.execution.FormBean fBean = aBean.getFormBean(request);	
	if (fBean.getPcks7()!=null){
		out.clear();
		ServletOutputStream outs = response.getOutputStream();
		response.setContentType("application/x-msdownload"); 
		response.setHeader("Content-Disposition", "attachment; filename=" + fBean.getFormDef().getFrmName() + ".pkcs7");
		try {
				outs.write(fBean.getPcks7());
		} catch (Exception e) {
			e.printStackTrace();
			response.setHeader("Content-Disposition", "attachment; filename=ERROR");
		}
	}
%>