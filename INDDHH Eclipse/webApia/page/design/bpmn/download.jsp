<%@page import="com.dogma.Parameters"%><%@page import="biz.statum.sdk.util.FileUtil"%><%@page import="biz.statum.sdk.util.StringUtil"%><%@ page import = "java.io.File"%><%@page import="java.io.FileInputStream"%><%@page import="biz.statum.apia.web.action.design.BPMNProcessAction"%><%@page import="biz.statum.apia.web.bean.design.BPMNProcessBean"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%

out.clear();
String tmpFile = null;
try {
	
	//String whatToDo = request.getParameter("do");
	String whatToDo = request.getParameter("do");
	if(whatToDo == null || "".equals(whatToDo)) {
		whatToDo = (String) request.getAttribute("do");
		request.removeAttribute("do");
	}
	
	HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
	BPMNProcessBean bean = BPMNProcessAction.staticRetrieveBean(http,false);
	
	if("download".equals(whatToDo)) {
		
		tmpFile = bean.getFilePathToDownload();
		
		bean.setBuildProcessDocumentation(Boolean.FALSE);
		
		if (tmpFile == null){
			response.setHeader("Content-Disposition", "attachment; filename=ERROR");
		} else {
			
			String fileName = bean.getProcessVo().getProName() + ".pdf";
			
			response.setContentType("application/force-download;charset="+Parameters.APP_ENCODING);
			response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
			
			FileInputStream in = new FileInputStream(tmpFile);
			ServletOutputStream outs = response.getOutputStream();
			
			byte[] buffer = new byte[8 * 1024];
			int count = 0;
			do {
				outs.write(buffer, 0, count);
				count = in.read(buffer, 0, buffer.length);
			} while (count != -1);
	
			in.close();
			outs.close();
		}
	} else if("status".equals(whatToDo)) {
		//System.out.println("Entro en el status");
		Boolean value = bean.buildProcessDocumentation;
		
		if (value == null) value = Boolean.TRUE;
		
		response.setContentType("text/xml");
		String result = "<?xml version=\"1.0\" encoding=\"" + Parameters.APP_ENCODING + "\"?><result>" + value.toString() + "</result>";
		
		//TODO: Ver como obtener el xml de mensajes
		//if (bean.getHasException()) result = bean.getMessagesAsXml(request);
		if(bean.hasMessages()) result = bean.getMessagesAsXml(http);
		
		out.write(result);
	}
} catch (Exception e) {
	e.printStackTrace();
	response.setHeader("Content-Disposition", "attachment; filename=ERROR");
} 

%>