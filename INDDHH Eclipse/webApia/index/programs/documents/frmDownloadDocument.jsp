<%@ page import = "com.dogma.vo.*"%><%@ page import	= "com.dogma.bean.*"%><%@ page import	= "com.dogma.util.DownloadUtil"%><%@ page import = "javax.activation.*"%><%@ page import = "java.io.*"%><%@ page import = "java.util.*"%><%	
	DogmaAbstractBean aBean = (DogmaAbstractBean)session.getAttribute("dBean");
	//find bean

	com.dogma.bean.execution.FormBean fBean = null;
	
	//si es del monitor
	if(aBean instanceof MonitorProcessesBean){
		Collection forms;
		if("E".equals(request.getParameter("frmParent"))){
			forms = ((MonitorProcessesBean)aBean).getEntInstanceBean().getForms(request);
		} else {
			forms = ((MonitorProcessesBean)aBean).getProInstanceBean().getForms(request);
		}
		if(forms!=null){
			Integer frmId = new Integer(request.getParameter("frmId"));
			Iterator it = forms.iterator();
			while(it.hasNext()){
				FormBean formBean = (FormBean)it.next();
				if(formBean.getFormId().equals(frmId)){
					formBean.clearMessages();
					formBean.clearException();
					fBean = formBean;
				}
			}
		}
	} else {
		fBean = aBean.getFormBean(request);	
	}
	
	DocumentVo docVo = null;
	if (request.getParameter("version") == null) {
		docVo = fBean.getDocumentDownload(request);
	} else {
		docVo = fBean.getDocumentVersionDownload(request);
	}
	if (docVo == null || docVo.getDocName() == null){
	 %><%@include file="../../components/scripts/server/startInc.jsp" %><%@page import="com.dogma.bean.query.MonitorProcessesBean"%><%@page import="com.dogma.bean.execution.FormBean"%><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body></body></html><%@include file="../../components/scripts/server/endDocDowInc.jsp" %><SCRIPT language='javascript' defer='true'> 
				//if (document.readyState=='complete' || (!MSIE)){
					try {  
						var win=window;
						while(!win.document.getElementById('iframeMessages') && win!=win.parent){
							win=win.parent;
						}
						if (win.document.getElementById('iframeMessages')) {
							win.document.getElementById('iframeMessages').showMessage(document.getElementById("errorText").value, document.body);
						}else{
							str = document.getElementById("errorText").value;
							if (str.indexOf("</PRE>") != null) {
								str = str.substring(5,str.indexOf("</PRE>"));
							}
							alert(str);
						}
					} catch (e) {
						str = document.getElementById("errorText").value;
						if (str.indexOf("</PRE>") != null) {
							str = str.substring(5,str.indexOf("</PRE>"));
						}
						alert(str);
					}
				//}
			 </SCRIPT><%
	} else {
		out.clear();
		ServletOutputStream outs = response.getOutputStream();
		response.setContentType("application/x-msdownload"); 
		if (docVo == null || docVo.getDocName() == null){
			 //response.setHeader("Content-Disposition", "attachment; filename=ERROR");
		} else {
			String sourceFile = docVo.getTmpFilePath();
			String fileName = docVo.getDocName();
			fileName = fileName.replaceAll(" ","_");
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
	}
%>