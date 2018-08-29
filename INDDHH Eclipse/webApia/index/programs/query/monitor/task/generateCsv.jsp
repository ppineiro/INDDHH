<%@page import="com.dogma.util.DownloadUtil"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.*"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="java.util.*"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.query.MonitorTasksBean"></jsp:useBean><%
response.setContentType("application/x-msdownload;charset="+com.dogma.Parameters.APP_ENCODING);
response.setHeader("Content-Disposition", "attachment; filename=\"monitor.csv\"");
String separator = Parameters.CSV_FIELD_SEPARATOR;
String lineSeparator = DownloadUtil.LINE_SEPARATOR;
out.clear();

Integer labelSet = Parameters.DEFAULT_LABEL_SET;
Integer langId = Parameters.DEFAULT_LANG;
com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
if (uData!=null) {
	labelSet = uData.getLabelSetId();
	langId = uData.getLangId();
}


out.print(DownloadUtil.fmtStr(LabelManager.getName(labelSet,langId,"lblTskTit")));out.print(separator);
out.print(DownloadUtil.fmtStr(LabelManager.getName(labelSet,langId,"lblProTit")));out.print(separator);
out.print(DownloadUtil.fmtStr(LabelManager.getName(labelSet,langId,"lblMonInstProNroReg")));out.print(separator);
out.print(DownloadUtil.fmtStr(LabelManager.getName(labelSet,langId,"lblMonProEleInstSta")));out.print(separator);
out.print(DownloadUtil.fmtStr(LabelManager.getName(labelSet,langId,"lblMonProEleInstDatRea")));out.print(separator);
out.print(DownloadUtil.fmtStr(LabelManager.getName(labelSet,langId,"lblMonProEleInstDatEnd")));out.print(separator);
out.print(DownloadUtil.fmtStr(LabelManager.getName(labelSet,langId,"lblMonInstProSta")));out.print(separator);
out.print(DownloadUtil.fmtStr(LabelManager.getName(labelSet,langId,"lblMonInstProCreUsu")));out.print(separator);
out.print(DownloadUtil.fmtStr(LabelManager.getName(labelSet,langId,"lblMonInstProCreDat")));out.print(separator);
out.print(DownloadUtil.fmtStr(LabelManager.getName(labelSet,langId,"lblMonInstProEndDat")));out.print(separator);

out.print(lineSeparator);

Collection col = dBean.getListToExport();
if (col != null) {
	Iterator it = col.iterator(); 
	MonitorTaskVo mTVo = null;
	String aux = null;
	while (it.hasNext()) { 
		mTVo = (MonitorTaskVo) it.next();
		
		out.print(DownloadUtil.fmtObject(mTVo.getTskTitle()));out.print(separator);
		out.print(DownloadUtil.fmtObject(mTVo.getProTitle()));out.print(separator);
		out.print(DownloadUtil.fmtObject(mTVo.getProInstIdentification()));out.print(separator);
		aux = ProEleInstanceVo.ELE_STATUS_WAITING.equals(mTVo.getProEleInstStatus())?LabelManager.getName(labelSet,langId,"lblMonProEleInstStaWai"):
				ProEleInstanceVo.ELE_STATUS_READY.equals(mTVo.getProEleInstStatus())?LabelManager.getName(labelSet,langId,"lblMonProEleInstStaRea"):
				ProEleInstanceVo.ELE_STATUS_ACQUIRED.equals(mTVo.getProEleInstStatus())?LabelManager.getName(labelSet,langId,"lblMonProEleInstStaAcq"):
				ProEleInstanceVo.ELE_STATUS_COMPLETED.equals(mTVo.getProEleInstStatus())?LabelManager.getName(labelSet,langId,"lblMonProEleInstStaCom"):
				ProEleInstanceVo.ELE_STATUS_CANCELLED.equals(mTVo.getProEleInstStatus())?LabelManager.getName(labelSet,langId,"lblMonProEleInstStaCan"):
				ProEleInstanceVo.ELE_STATUS_SKIPPED.equals(mTVo.getProEleInstStatus())?LabelManager.getName(labelSet,langId,"lblMonProEleInstStaSki"):"";
		out.print(DownloadUtil.fmtObject(aux));out.print(separator);
		
		out.print(DownloadUtil.fmtObject(mTVo.getProEleInstDateReady(),false,true));out.print(separator);
		out.print(DownloadUtil.fmtObject(mTVo.getProEleInstDateEnd(),false,true));out.print(separator);
		
		aux = ProInstanceVo.PROC_STATUS_RUNNING.equals(mTVo.getProInstStatus())?LabelManager.getName(labelSet,langId,"lblMonInstProStaRun"):
			ProInstanceVo.PROC_STATUS_CANCELLED.equals(mTVo.getProInstStatus())?LabelManager.getName(labelSet,langId,"lblMonInstProStaCan"):
			ProInstanceVo.PROC_STATUS_FINALIZED.equals(mTVo.getProInstStatus())?LabelManager.getName(labelSet,langId,"lblMonInstProStaFin"):
			ProInstanceVo.PROC_STATUS_COMPLETED.equals(mTVo.getProInstStatus())?LabelManager.getName(labelSet,langId,"lblMonInstProStaCom"):
			ProInstanceVo.PROC_STATUS_SUSPENDED.equals(mTVo.getProInstStatus())?LabelManager.getName(labelSet,langId,"lblMonInstProStaSus"):"";
		out.print(DownloadUtil.fmtObject(aux));out.print(separator);
		
		out.print(DownloadUtil.fmtObject(mTVo.getProUserName()));out.print(separator);
		out.print(DownloadUtil.fmtObject(mTVo.getProInstCreateDate(),false,true));out.print(separator);
		out.print(DownloadUtil.fmtObject(mTVo.getProInstEndDate(),false,true));out.print(separator);
		
		out.print(lineSeparator);
	}
}

%>