<%@page import="java.io.ByteArrayOutputStream"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.bean.design.ScenarioBean"%><%@page import="biz.statum.apia.web.action.design.ScenarioAction"%><%@page import="java.io.ByteArrayOutputStream"%><%
out.clear();
try {
	HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
	ScenarioBean bean = ScenarioAction.staticRetrieveBean(http);
	ByteArrayOutputStream baosPDF = bean.simulateResultGenerateBinary(http);
	if (baosPDF != null){
		response.setContentType("application/x-msdownload;charset="+com.dogma.Parameters.APP_ENCODING);
		response.setContentLength(baosPDF.size());
		response.setHeader("Expires", "0");
		response.setHeader("Cache-Control", "must-revalidate, post-check=0, pre-check=0");
		response.setHeader("Pragma", "public");		
		response.setHeader("Content-Disposition", "attachment; filename=\"simulation.pdf\"");	
		
		ServletOutputStream output = response.getOutputStream();
		baosPDF.writeTo(output);	
	} else {
		response.setHeader("Content-Disposition", "attachment; filename=ERROR");
	}
} catch (Exception e) {
	e.printStackTrace();
	response.setHeader("Content-Disposition", "attachment; filename=ERROR");
}

%>