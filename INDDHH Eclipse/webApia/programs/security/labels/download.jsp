<%@page import="com.dogma.util.DownloadUtil"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.business.security.LabelsSetsService"%><%@page import="java.util.*"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.LabelBean"></jsp:useBean><%
response.setContentType("application/x-msdownload;charset="+com.dogma.Parameters.APP_ENCODING);
response.setHeader("Content-Disposition", "attachment; filename=\"labels.csv\"");
String separator = Parameters.CSV_FIELD_SEPARATOR;
String lineSeparator = DownloadUtil.LINE_SEPARATOR;
out.clear();

Integer langId = new Integer(request.getParameter("cmbLan"));
Integer labSetId = new Integer(request.getParameter("cmbLbl"));

Collection col = LabelsSetsService.getInstance().getColLabels(labSetId, langId); 
if (col != null) {
	Iterator it = col.iterator(); 
	LabelsVo lVO = null;
	while (it.hasNext()) { 
		lVO = (LabelsVo) it.next(); 
		out.print(DownloadUtil.fmtStr(lVO.getLblId(),true));out.print(separator);
		out.print(DownloadUtil.fmtStr(lVO.getLblName(),true));out.print(separator);
		out.print(DownloadUtil.fmtStr(lVO.getLblToolTip(),true));out.print(separator);
		out.print(DownloadUtil.fmtStr(lVO.getLblDesc(),true));out.print(separator);
		out.print(DownloadUtil.fmtStr(lVO.getLblAccessKey(),true));
		out.print(lineSeparator);
	}
}

%>