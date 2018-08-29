<%@page import="java.io.FileInputStream"%><%@page import="com.dogma.vo.custom.QryResultFileVo"%><%@page import="biz.statum.apia.web.bean.query.OffLineBean"%><%@page import="biz.statum.apia.web.action.query.OffLineAction"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%

response.setContentType("application/force-download;charset="+com.dogma.Parameters.APP_ENCODING);
response.setHeader("Content-Disposition", "attachment; filename=\"users.xls\"");
out.clear();

HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
OffLineBean bean= OffLineAction.staticRetrieveBean(http);

QryResultFileVo resultVo = bean.getResultFileVo();
ServletOutputStream outs = response.getOutputStream();
response.setContentType("application/force-download"); 

if (resultVo == null || resultVo.getFilePath() == null){
	response.setHeader("Content-Disposition", "attachment; filename=ERROR NO FILE");
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
%>