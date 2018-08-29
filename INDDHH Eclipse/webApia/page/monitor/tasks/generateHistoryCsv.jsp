<%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.action.monitor.TasksAction"%><%@page import="biz.statum.apia.web.bean.monitor.TasksBean"%><%@page import="com.dogma.util.DownloadUtil"%><%@page import="com.dogma.Parameters"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.vo.MonitorTaskVo"%><%@page import="com.dogma.vo.ProEleInstanceVo"%><%@page import="com.dogma.vo.ProEleInstHistoryVo"%><%@page import="java.util.Collection"%><%@page import="java.util.Iterator"%><%
response.setContentType("application/force-download;charset="+com.dogma.Parameters.APP_ENCODING);
response.setHeader("Content-Disposition", "attachment; filename=\"monitor.csv\"");

HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
TasksBean dBean= TasksAction.staticRetrieveBean(http);

String separator = Parameters.CSV_FIELD_SEPARATOR;
String lineSeparator = DownloadUtil.LINE_SEPARATOR;
out.clear();

Integer labelSet = Parameters.DEFAULT_LABEL_SET;
Integer langId = Parameters.DEFAULT_LANG;
com.dogma.UserData uData = BasicBeanStatic.getUserDataStatic(request);
if (uData!=null) {
	labelSet = uData.getLabelSetId();
	langId = uData.getLangId();
}
 
out.print(DownloadUtil.fmtStr(LabelManager.getName(labelSet,langId,"lblTskTit")));out.print(separator);
out.print(DownloadUtil.fmtStr(LabelManager.getName(labelSet,langId,"lblMonPoolNom")));out.print(separator);
out.print(DownloadUtil.fmtStr(LabelManager.getName(labelSet,langId,"lblMonProEleInstSta")));out.print(separator);
out.print(DownloadUtil.fmtStr(LabelManager.getName(labelSet,langId,"lblMonProEleInstDatRea")));out.print(separator);
out.print(DownloadUtil.fmtStr(LabelManager.getName(labelSet,langId,"lblMonProEleInstDatEnd")));out.print(separator);
out.print(DownloadUtil.fmtStr(LabelManager.getName(labelSet,langId,"lblMonProEleInstHtyEve")));out.print(separator);
out.print(DownloadUtil.fmtStr(LabelManager.getName(labelSet,langId,"lblMonProEleInstHtyDay")));out.print(separator);
out.print(lineSeparator);

Collection col = dBean.getTskDetails();
if (col != null) {
	Iterator it = col.iterator(); 
	MonitorTaskVo mPITVo = null;
	String aux = null;
	while (it.hasNext()) { 
		mPITVo = (MonitorTaskVo) it.next(); 
		
		out.print(DownloadUtil.fmtObject(mPITVo.getTskTitle()));out.print(separator);
		out.print(DownloadUtil.fmtObject(mPITVo.getPoolName()));out.print(separator);
		aux = ProEleInstanceVo.ELE_STATUS_WAITING.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,langId,"lblMonProEleInstStaWai"):
			ProEleInstanceVo.ELE_STATUS_READY.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,langId,"lblMonProEleInstStaRea"):
			ProEleInstanceVo.ELE_STATUS_ACQUIRED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,langId,"lblMonProEleInstStaAcq"):
			ProEleInstanceVo.ELE_STATUS_COMPLETED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,langId,"lblMonProEleInstStaCom"):
			ProEleInstanceVo.ELE_STATUS_UNDO.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,langId,"lblMonProEleInstStaCom"):
			ProEleInstanceVo.ELE_STATUS_CANCELLED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,langId,"lblMonProEleInstStaCan"):
			ProEleInstanceVo.ELE_STATUS_SKIPPED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,langId,"lblMonProEleInstStaSki"):"";
		out.print(DownloadUtil.fmtObject(aux));out.print(separator);
		
		out.print(DownloadUtil.fmtDateAMPM(mPITVo.getProEleInstDateReady()));out.print(separator);
		out.print(DownloadUtil.fmtDateAMPM(mPITVo.getProEleInstDateEnd()));out.print(separator);
		aux = ProEleInstHistoryVo.HTY_EVENT_CREATED.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,langId,"lblMonProEleInstHtyEveCre"):
			ProEleInstHistoryVo.HTY_EVENT_WAITING.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,langId,"lblMonProEleInstHtyEveWai"):
			ProEleInstHistoryVo.HTY_EVENT_READY.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,langId,"lblMonProEleInstHtyEveRea"):
			ProEleInstHistoryVo.HTY_EVENT_ACQUIRED.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,langId,"lblMonProEleInstHtyEveAcq"):
			ProEleInstHistoryVo.HTY_EVENT_COMPLETED.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,langId,"lblMonProEleInstHtyEveCom"):
			ProEleInstHistoryVo.HTY_EVENT_UNDO.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,langId,"lblMonProEleInstHtyEveCom"):
			ProEleInstHistoryVo.HTY_EVENT_CANCELLED.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,langId,"lblMonProEleInstHtyEveCan"):
			ProEleInstHistoryVo.HTY_EVENT_RELEASE.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,langId,"lblMonProEleInstHtyEveRel"):
			ProEleInstHistoryVo.HTY_EVENT_SKIPPED.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,langId,"lblMonProEleInstHtyEveSki"):
			ProEleInstHistoryVo.HTY_EVENT_REASIGNED.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,langId,"lblMonProEleInstHtyEveReg"):
			ProEleInstHistoryVo.HTY_EVENT_ELEVATED.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,langId,"lblMonProEleInstHtyEveEle"):
			ProEleInstHistoryVo.HTY_EVENT_ELEVATED.equals(mPITVo.getHtyEvent())?LabelManager.getName(labelSet,langId,"lblMonProEleInstHtyEveDel"):"";
		out.print(DownloadUtil.fmtObject(aux));out.print(separator);
		
		out.print(DownloadUtil.fmtDateAMPM(mPITVo.getHtyDate()));out.print(separator);
		out.print(lineSeparator);
	}
}

%>