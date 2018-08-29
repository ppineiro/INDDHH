<%@page import="biz.statum.sdk.util.FileUtil"%><%@page import="biz.statum.sdk.util.StringUtil"%><%@ page import = "java.io.File"%><%@page import="java.io.FileInputStream"%><%@page import="biz.statum.apia.web.action.administration.StylesAction"%><%@page import="biz.statum.apia.web.bean.administration.StylesBean"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%

out.clear();
String fileName = null;
try {
	HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
	String styleName = request.getParameter("id");
	StylesBean bean = StylesAction.staticRetrieveBean(http,false);
	fileName = bean.download(http);
	
	if (StringUtil.isEmpty(fileName)){
		response.setHeader("Content-Disposition", "attachment; filename=ERROR");
	} else {
		response.setContentType("application/force-download;charset="+com.dogma.Parameters.APP_ENCODING);
		response.setHeader("Content-Disposition", "attachment; filename=\"" + styleName + ".zip\"");
		
		FileInputStream in = new FileInputStream(fileName);
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
} catch (Exception e) {
	e.printStackTrace();
	response.setHeader("Content-Disposition", "attachment; filename=ERROR");
} 

%>

