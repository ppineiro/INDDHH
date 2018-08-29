<%	
byte[] pkcs7 = (byte[])session.getAttribute("PKCS7");	
String frmName = (String)session.getAttribute("PKCS7_FORM_NAME");
	if (pkcs7!=null){
		out.clear();
		ServletOutputStream outs = response.getOutputStream();
		response.setContentType("application/x-msdownload"); 
		response.setHeader("Content-Disposition", "attachment; filename=" + frmName + ".pkcs7");
		try {
				outs.write(pkcs7);
		} catch (Exception e) {
			e.printStackTrace();
			response.setHeader("Content-Disposition", "attachment; filename=ERROR");
		}
	}
%>