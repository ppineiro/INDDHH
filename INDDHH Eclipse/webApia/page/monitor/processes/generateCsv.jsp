<%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><%@page import="biz.statum.sdk.util.FileUtil"%><%@page import="biz.statum.sdk.util.StringUtil"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.action.monitor.ProcessesAction"%><%@page import="biz.statum.apia.web.bean.monitor.ProcessesBean"%><%@page import="com.dogma.util.DownloadUtil"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.*"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="java.util.*"%><%
response.setContentType("application/force-download;charset="+com.dogma.Parameters.APP_ENCODING);
response.setHeader("Content-Disposition", "attachment; filename=\"monitor.csv\"");
out.clear();
try {
HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
ProcessesBean dBean= ProcessesAction.staticRetrieveBean(http);
 
String separator = Parameters.CSV_FIELD_SEPARATOR;
String lineSeparator = DownloadUtil.LINE_SEPARATOR;

Integer labelSet = Parameters.DEFAULT_LABEL_SET;
Integer langId = Parameters.DEFAULT_LANG;
com.dogma.UserData uData = BasicBeanStatic.getUserDataStatic(request);
if (uData!=null) {
	labelSet = uData.getLabelSetId();
	langId = uData.getLangId();
} 


out.print(DownloadUtil.fmtStr(LabelManager.getName(labelSet,langId,"lblMonInstProNroReg")));out.print(separator);
out.print(DownloadUtil.fmtStr(LabelManager.getName(labelSet,langId,"lblTit")));out.print(separator);
out.print(DownloadUtil.fmtStr(LabelManager.getName(labelSet,langId,"lblMonProAct")));out.print(separator);
out.print(DownloadUtil.fmtStr(LabelManager.getName(labelSet,langId,"lblMonInstProSta")));out.print(separator);
out.print(DownloadUtil.fmtStr(LabelManager.getName(labelSet,langId,"lblMonInstProCreUsu")));out.print(separator);
out.print(DownloadUtil.fmtStr(LabelManager.getName(labelSet,langId,"lblMonInstProCreDat")));out.print(separator);
out.print(DownloadUtil.fmtStr(LabelManager.getName(labelSet,langId,"lblMonInstProEndDat")));out.print(separator);
out.print(lineSeparator);

Collection col = dBean.getListToExport(http); 
if (col != null) {
	Iterator it = col.iterator(); 
	MonitorProcessVo mPVo = null;
	String aux = null;
	while (it.hasNext()) { 
		mPVo = (MonitorProcessVo) it.next();
		out.print(DownloadUtil.fmtObject(mPVo.getProcessIdentification(),true));out.print(separator);
		out.print(DownloadUtil.fmtObject(mPVo.getProTitle(),true));out.print(separator);
		
		aux = ProcessVo.PROCESS_ACTION_CREATION.equals(mPVo.getProAction())?LabelManager.getName(labelSet,langId,"lblMonProActCre"):
			ProcessVo.PROCESS_ACTION_ALTERATION.equals(mPVo.getProAction())?LabelManager.getName(labelSet,langId,"lblMonProActAlt"):
			ProcessVo.PROCESS_ACTION_CANCEL.equals(mPVo.getProAction())?LabelManager.getName(labelSet,langId,"lblMonProActCan"):"";
		out.print(DownloadUtil.fmtObject(aux,true));out.print(separator);
		
		aux = ProInstanceVo.PROC_STATUS_RUNNING.equals(mPVo.getProInstStatus())?LabelManager.getName(labelSet,langId,"lblMonInstProStaRun"):
			ProInstanceVo.PROC_STATUS_CANCELLED.equals(mPVo.getProInstStatus())?LabelManager.getName(labelSet,langId,"lblMonInstProStaCan"):
			ProInstanceVo.PROC_STATUS_FINALIZED.equals(mPVo.getProInstStatus())?LabelManager.getName(labelSet,langId,"lblMonInstProStaFin"):
			ProInstanceVo.PROC_STATUS_COMPLETED.equals(mPVo.getProInstStatus())?LabelManager.getName(labelSet,langId,"lblMonInstProStaCom"):"";
		out.print(DownloadUtil.fmtObject(aux,true));out.print(separator);
		
		out.print(DownloadUtil.fmtObject(mPVo.getProUserName(),true));out.print(separator);
		out.print(DownloadUtil.fmtObject(mPVo.getProInstCreateDate(),true));out.print(separator);
		out.print(DownloadUtil.fmtObject(mPVo.getProInstEndDate(),true));
		out.print(lineSeparator);
	}
}

} catch (Exception e) {
	e.printStackTrace();
	response.setHeader("Content-Disposition", "attachment; filename=ERROR");
} finally {
	if (StringUtil.notEmpty("monitor.csv")) FileUtil.deleteFile("monitor.csv");
}
%>