<%@page import="biz.statum.apia.web.action.administration.LabelsAction"%><%@page import="biz.statum.apia.web.bean.administration.LabelsBean"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%

out.clear();
try {
	HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
	LabelsBean bean = LabelsAction.staticRetrieveBean(http,false);
	
	response.setContentType("application/force-download;charset="+com.dogma.Parameters.APP_ENCODING);
	response.setHeader("Content-Disposition", "attachment; filename=\"language.txt\"");
		
	out.print(bean.exportLangTxt(http));
	
} catch (Exception e) {
	e.printStackTrace();	
} 

%>