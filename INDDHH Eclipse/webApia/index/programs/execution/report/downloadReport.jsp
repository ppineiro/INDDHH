<%@page import="com.dogma.bean.administration.ReportBean"%><%@ page import = "com.dogma.vo.*"%><%@ page import	= "com.dogma.bean.*"%><%@ page import	= "com.dogma.util.DownloadUtil"%><%@ page import="com.dogma.Parameters"%><%@ page import = "javax.activation.*"%><%@ page import = "java.io.*"%><%@ page import = "java.util.*"%><%@page import="com.dogma.EnvParameters"%><%@page import="com.st.util.labels.LabelManager"%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><script src="<%=Parameters.ROOT_PATH%>/scripts/common.js"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/events.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/winSizer.js"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/winSizer.js"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/util.js"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/scriptBehaviors.js"<%if(request.getHeader("User-Agent").indexOf("MSIE")>=0){ %> defer="true"<%}%>></script><jsp:useBean id="repBean" scope="session" class="com.dogma.bean.administration.ReportBean"></jsp:useBean><%	
	String labelSet = "0001"+String.valueOf(Parameters.DEFAULT_LABEL_SET);
	String styleDirectory = "default";
	boolean envUsesEntities = false;
	Integer environmentId = null;
	com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
	Exception rootException = null;
	if (uData != null) {
		envUsesEntities = uData.isEnvUsesEntities();
		environmentId = uData.getEnvironmentId();
		labelSet = uData.getStrLabelSetId();
		styleDirectory = EnvParameters.getEnvParameter(environmentId,EnvParameters.ENV_STYLE);
	}
	out.clear();
	if ("true".equals(request.getParameter("error"))){
		
		String stack = ((DogmaAbstractBean) session.getAttribute("repBean")).getMessagesAsHTML(request,"d");
		StringBuffer htmlCode= new StringBuffer();
		String errorMsg = LabelManager.getName("msgErrProReport");// "ERROR PROCESSING THE REPORT";
		if (".html".equals(request.getParameter("format"))){
			//htmlCode.append("<HTML><style type=\"text/css\">body { font-family: verdana; font-size: 10px; }td { font-family: verdana; font-size: 10px; }</style><body>"+ errorMsg + "</body></HTML>");	
			htmlCode.append("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">");
			htmlCode.append("<HTML>"); 
			htmlCode.append("<head>");
			htmlCode.append("<script src=\""+Parameters.ROOT_PATH+"/scripts/common.js\"></script>");
			htmlCode.append("<script src=\""+Parameters.ROOT_PATH+"/scripts/events.js\"></script>");
			htmlCode.append("<script src=\""+Parameters.ROOT_PATH+"/scripts/winSizer.js\"></script>");
			htmlCode.append("<script src=\""+Parameters.ROOT_PATH+"/scripts/util.js\"></script>");
			htmlCode.append("<script src=\""+Parameters.ROOT_PATH+"/scripts/scriptBehaviors.js\""+((request.getHeader("User-Agent").indexOf("MSIE")>=0)?" defer=\"true\"":"")+"></script>");
			htmlCode.append("<link href=\"" + Parameters.ROOT_PATH + "/styles/" + styleDirectory + "/css/workArea.css\" rel=\"styleSheet\" type=\"text/css\" media=\"screen\">");
			htmlCode.append("</head>");
			htmlCode.append("<body style=\"BORDER:2px groove white;\">");
			htmlCode.append("<TABLE class=\"pageTop\">");
			htmlCode.append("<COL class=\"col1\"><COL class=\"col2\">");
			htmlCode.append("<TR>");
			htmlCode.append("<TD>Error</TD>");
			htmlCode.append("<TD></TD>");
			htmlCode.append("</TR>");
			htmlCode.append("</TABLE>");
			htmlCode.append("<div class=\"divContent\" id=\"divContent\">");
			
			htmlCode.append("<table width=\"98%\" class=\"tblFormLayout\">");
			htmlCode.append("<COL class=\"col1\"><COL class=\"col2\"><COL class=\"col3\"><COL class=\"col4\">");
			
			htmlCode.append("<tr><td align=\"left\" colspan=3><b>" + errorMsg + "</b></td>");
//			htmlCode.append("<button type=\"button\" title=\"Ver stack\" onclick='alert(\"" + repBean.fmtStr(stack) + "\")'>Ver Stack</button>");
			htmlCode.append("</tr>");

			htmlCode.append("</table>");
			htmlCode.append("</div>");
			htmlCode.append("<TABLE class=\"pageBottom\">");
			htmlCode.append("<COL class=\"col1\"><COL class=\"col2\">");
			htmlCode.append("<TR>");
			htmlCode.append("		<TD></TD>");
			//htmlCode.append("		<TD align=\"right\"><button type=\"button\" accesskey=\"Sair\" title=\"Sair\" onclick=\"window.close()\">Salir</button></TD>");
			htmlCode.append("	</TR>");
			htmlCode.append("</TABLE>");
			htmlCode.append("</body>");
			htmlCode.append("</html>");
			
		}else{
			htmlCode.append("<HTML><body onload='alert(\"" + errorMsg + "\")'></body></HTML>");
		}
		out.print(htmlCode.toString());
	}else{
		ReportVo repVo = repBean.getReportVo();
		
		ServletOutputStream outs = response.getOutputStream();
	
		response.setContentType("application/x-msdownload"); 
		
		if (repVo == null || repVo.getRepName() == null){
			response.setHeader("Content-Disposition", "attachment; filename=ERROR");
		} else {
			String sourceFile = repVo.getReportOutputPath();
			String fileName = "";
			if (repVo.getRepId().intValue()>1000){
				fileName = repVo.getRepName() + repVo.getFileType();
			}else{
				fileName = LabelManager.getName(repVo.getRepName()) + repVo.getFileType();
			}
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
				if (repVo.getRepId().intValue()>1000){
					File tmpRepFileDesign = new File(repVo.getReportDefinitionPath());
					System.out.println("Reporte no nativo de Apia -> Eliminando el diseño del reporte:" + repVo.getReportDefinitionPath());					
					tmpRepFileDesign.delete();
				}
				//Borramos el reporte del dir temporal
				File tmpReportFile = new File(repVo.getReportOutputPath());
				System.out.println("Eliminando el reporte del dir temporal:" + repVo.getReportOutputPath());				
				tmpReportFile.delete();
				System.out.println("------------------------------------------------------");
			} catch (Throwable e) {
				e.printStackTrace();
				response.setHeader("Content-Disposition", "attachment; filename=ERROR");
			} finally{
				//out.clear(); //<-- Causa error utilizando webLogic y no se genera el reporte
				out = pageContext.pushBody();
			}
		}
	}
%>