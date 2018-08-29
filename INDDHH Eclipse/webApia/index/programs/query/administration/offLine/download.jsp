<%@ page import = "com.dogma.vo.*"%><%@ page import="com.dogma.vo.custom.*"%><%@ page import	= "com.dogma.bean.*"%><%@ page import = "javax.activation.*"%><%@ page import = "java.io.*"%><%@ page import = "java.util.*"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.query.OffLineBean"></jsp:useBean><%	
	StringBuffer buffer = new StringBuffer();
	buffer.append(dBean.getMessagesAsHTML(request,"qi"));
	dBean.clearMessages();

	if (buffer.length() > 0) {
		out.print("<TEXTAREA id=errorText style='display:none'>"+ dBean.fmtHTML(buffer.toString()) + "</TEXTAREA>");
		out.print("<SCRIPT language=javascript>");
		
		out.print("window.document.onreadystatechange=fnStartDocInit;");
		out.print("if (document.addEventListener) {    document.addEventListener('DOMContentLoaded', fnStartDocInit, false);}");
		%><html><body></body><script>function fnStartDocInit(){
			if (document.readyState=='complete' || (navigator.userAgent.indexOf("MSIE")<0)){
					try {
						window.parent.document.getElementById("iframeMessages").hideResultFrame();
						window.parent.document.getElementById("iframeResult").hideResultFrame();
						window.parent.document.getElementById("iframeMessages").showMessage(document.getElementById("errorText").value, window.parent.document.getElementById("iframeMessages").getBody());
						
					} catch (e) {
						str = document.getElementById("errorText").value;
						if (str.indexOf("</PRE>") != null) {
							str = str.substring(5,str.indexOf("</PRE>"));
						}
						alert(str);
					}
				}
			}</script></html><%
		out.print("</SCRIPT>");
	} else {
		
		QryResultFileVo resultVo = dBean.getResultFileVo();
		ServletOutputStream outs = response.getOutputStream();
		response.setContentType("application/x-msdownload"); 
		
		if (resultVo == null || resultVo.getFilePath() == null){
			response.setHeader("Content-Disposition", "attachment; filename=ERROR");
		} else {
			response.setHeader("Content-Disposition", "attachment; filename=" + resultVo.getFileNameDownload());
			
			try {
				
				FileInputStream in = new FileInputStream(resultVo.getFilePath());
				
				byte[] bufferByte = new byte[8 * 1024];
				int count = 0;
				do {
					outs.write(bufferByte, 0, count);
					count = in.read(bufferByte, 0, bufferByte.length);
				} while (count != -1);
				
				in.close();
				
			} catch (Exception e) {
				e.printStackTrace();
				response.setHeader("Content-Disposition", "attachment; filename=ERROR");
			}
		}
		outs.close();
	}
%>