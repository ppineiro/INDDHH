<%@page import="biz.statum.apia.web.bean.administration.OrganizationalUnitBean"%><%@page import="biz.statum.apia.web.action.administration.OrganizationalUnitAction"%><%@page import="biz.statum.apia.web.bean.design.AttributesBean"%><%@page import="biz.statum.apia.web.action.design.AttributesAction"%><%@page import="biz.statum.sdk.util.FileUtil"%><%@page import="biz.statum.sdk.util.StringUtil"%><%@page import="java.io.FileInputStream"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%
response.setContentType("application/x-msdownload;charset="+com.dogma.Parameters.APP_ENCODING);
response.setHeader("Content-Disposition", "attachment; filename=\"organizationalUnits.xls\"");
out.clear();

String fileName = null;

try {
	HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
	OrganizationalUnitBean bean= OrganizationalUnitAction.staticRetrieveBean(http);
	fileName = bean.exportOrgUnitsExcel(http);
	ServletOutputStream outs = response.getOutputStream();
	FileInputStream in = new FileInputStream(fileName);
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
} finally {
	if (StringUtil.notEmpty(fileName)) FileUtil.deleteFile(fileName);
}

%>