<%@page import="com.dogma.util.DownloadUtil"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.*"%><%@page import="com.dogma.bean.execution.ListTaskBean"%><%@page import="com.dogma.vo.custom.ColumnVo"%><%@page import="com.dogma.vo.ProInstanceVo"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="java.util.*"%><jsp:useBean id="lBeanReady" scope="session" class="com.dogma.bean.execution.ListTaskBean"></jsp:useBean><jsp:useBean id="lBeanInproc" scope="session" class="com.dogma.bean.execution.ListTaskBean"></jsp:useBean><%

Integer labelSet = Parameters.DEFAULT_LABEL_SET;
Integer langId = Parameters.DEFAULT_LANG;
com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
if (uData!=null) {
	labelSet = uData.getLabelSetId();
	langId = uData.getLangId();
}

String WORK_MODE = request.getParameter("WORK_MODE");
String fileName = "";
if(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS)){ 
	fileName =LabelManager.getName(labelSet,langId,"titEjeMisTar");
}else{ 
	fileName =LabelManager.getName(labelSet,langId,"titEjeTarLib");
} 

response.setContentType("application/x-msdownload;charset="+com.dogma.Parameters.APP_ENCODING);
response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + ".csv\"");
String separator = Parameters.CSV_FIELD_SEPARATOR;
String lineSeparator = DownloadUtil.LINE_SEPARATOR;
out.clear();


TaskListColumnsVo columns = null;
if (WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS)) {
	columns = lBeanInproc.getColumns();
} else {
	columns = lBeanReady.getColumns();
}

Iterator iterator = columns.iterator();
while (iterator.hasNext()) {
	ColumnVo columna = (ColumnVo) iterator.next(); 
	if(columna.getNombre().equals(TaskListColumnsVo.COL_PRIORIDAD ) && columna.isShow())		{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjePriPro")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_STATUS ) && columna.isShow())		{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjeStaPro")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_TSK_STATUS ) && columna.isShow())		{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjeStaTsk")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_TSK_TITLE ) && columna.isShow())		{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjeNomTar")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_NUMERO_ENTIDAD) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjeInsEntNum")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_NUMERO_PROCESO) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjeInsProNum")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_GRUPO) && columna.isShow()) 			{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjeGruTar")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_TITLE) && columna.isShow()) 		{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblProTit")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_TIPO_PROCESO) && columna.isShow()) 		{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjeTipProTar")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_CREACION_TAREA) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjeFecCreTar")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_CREACION_PROCESO) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjeFecCreProTar")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_CREADOR_PROCESO) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjeUsuCreProTar")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_STATUS) && columna.isShow()) 			{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjeStaEntTar")));}
	if(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !Parameters.SHOW_MY_TASKS){
		if(columna.getNombre().equals(TaskListColumnsVo.COL_USER_LOGIN) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjeUseAdq")));}
	}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_1) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAtt1Pro")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_2) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAtt2Pro")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_3) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAtt3Pro")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_4) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAtt4Pro")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_5) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAtt5Pro")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_NUM_1) && columna.isShow()) {out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAttNum1Pro")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_NUM_2) && columna.isShow()) {out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAttNum2Pro")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_NUM_3) && columna.isShow()) {out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAttNum3Pro")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_DTE_1) && columna.isShow()) {out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAttDte1Pro")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_DTE_2) && columna.isShow()) {out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAttDte2Pro")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_DTE_3) && columna.isShow()) {out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAttDte3Pro")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_1) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAtt1EntNeg")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_2) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAtt2EntNeg")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_3) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAtt3EntNeg")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_4) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAtt4EntNeg")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_5) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAtt5EntNeg")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_6) && columna.isShow())	{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAtt6EntNeg")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_7) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAtt7EntNeg")));}																					
	if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_8) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAtt8EntNeg")));}																					
	if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_9) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAtt9EntNeg")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_10) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAtt10EntNeg")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_1) && columna.isShow()) {out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAttNum1EntNeg")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_2) && columna.isShow()) {out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAttNum2EntNeg")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_3) && columna.isShow()) {out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAttNum3EntNeg")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_4) && columna.isShow()) {out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAttNum4EntNeg")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_5) && columna.isShow()) {out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAttNum5EntNeg")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_6) && columna.isShow()) {out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAttNum6EntNeg")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_7) && columna.isShow()) {out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAttNum7EntNeg")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_8) && columna.isShow()) {out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAttNum8EntNeg")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_1) && columna.isShow()) {out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAttDte1EntNeg")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_2) && columna.isShow()) {out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAttDte2EntNeg")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_3) && columna.isShow()) {out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAttDte3EntNeg")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_4) && columna.isShow()) {out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAttDte4EntNeg")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_5) && columna.isShow()) {out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAttDte5EntNeg")));}
	if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_6) && columna.isShow()) {out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblAttDte6EntNeg")));}
	out.print(separator);
	
}
out.print(lineSeparator);

Collection col = null;
if(WORK_MODE.equals(com.dogma.bean.execution.ListTaskBean.WORKING_MODE_INPROCESS)){ 
	col = lBeanInproc.exportData(request);
}else{	
	col = lBeanReady.exportData(request);
}

if (col != null) {
	Iterator it = col.iterator();
	int i = 0;
	TasksListVo aVO = null;
	while (it.hasNext()) {
		aVO = (TasksListVo) it.next();
		iterator = columns.iterator(); 
		
		while (iterator.hasNext()) {
			ColumnVo columna = (ColumnVo) iterator.next();
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRIORIDAD ) && columna.isShow()) {
				if(aVO.getPriority().intValue() == ProInstanceVo.PRO_PRIORITY_NORMAL) {out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjePriProNor")));}
				if(aVO.getPriority().intValue() == ProInstanceVo.PRO_PRIORITY_LOW) {out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjePriProBaj")));}
				if(aVO.getPriority().intValue() == ProInstanceVo.PRO_PRIORITY_HIGH) {out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjePriProAlt")));}
				if(aVO.getPriority().intValue() == ProInstanceVo.PRO_PRIORITY_URGENT) {out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjePriProUrg")));}
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_STATUS ) && columna.isShow()) {
				if(aVO.getProStatus()==1){
					out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjeProAtrAle")));
				} else if (aVO.getProStatus()==2) {
					out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjeProAtrOve")));
				} else {
					out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjeProAtrNone")));
				}
			}
			
			if(columna.getNombre().equals(TaskListColumnsVo.COL_TSK_STATUS ) && columna.isShow()) {
				if(aVO.getProStatus()==1){
					out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjeTskAtrAle")));
				} else if (aVO.getProStatus()==2) {
					out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjeTskAtrOve")));
				} else {
					out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjeTskAtrNone")));
				}
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_TSK_TITLE ) && columna.isShow()) 		{out.print(DownloadUtil.fmtStr(aVO.getTaskTitle()));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_NUMERO_ENTIDAD) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(BusEntInstanceVo.getEntityIdentification(aVO.getEntInstIdPre(),aVO.getEntInstIdNum(),aVO.getEntInstIdPos())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_NUMERO_PROCESO) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(ProInstanceVo.getEntityIdentification(aVO.getProcInstIdPre(),aVO.getProcInstIdNum(),aVO.getProcInstIdPos())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_GRUPO) && columna.isShow()) 			{out.print(DownloadUtil.fmtStr(aVO.getGroupName()));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_TITLE) && columna.isShow()) 		{out.print(DownloadUtil.fmtStr(aVO.getProcessTitle()));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_TIPO_PROCESO) && columna.isShow()) 		{
				 if(ProcessVo.PROCESS_ACTION_CREATION.equals(aVO.getProcessType())){ 
					out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjeActCre")));
				 } 
				 if(ProcessVo.PROCESS_ACTION_ALTERATION.equals(aVO.getProcessType())){ 
					out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjeActAlt"))); 
				 } 
				 if(ProcessVo.PROCESS_ACTION_CANCEL.equals(aVO.getProcessType())){ 
					 out.print(DownloadUtil.fmtStr(LabelManager.getToolTip(labelSet,langId,"lblEjeActCan"))); 
				 } 
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_CREACION_TAREA) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(lBeanReady.fmtDateAMPM(aVO.getTaskCreationDate())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_CREACION_PROCESO) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(lBeanReady.fmtDateAMPM(aVO.getProcCreationDate())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_CREADOR_PROCESO) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(aVO.getProcCreateUser()));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_STATUS) && columna.isShow()) 			{out.print(DownloadUtil.fmtStr(aVO.getEntStatus()));}
			if (WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !Parameters.SHOW_MY_TASKS){
				if(columna.getNombre().equals(TaskListColumnsVo.COL_USER_LOGIN) && columna.isShow())	{out.print(DownloadUtil.fmtStr(aVO.getUserLogin()));}
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_1) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getProInstAtt1Value())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_2) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getProInstAtt2Value())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_3) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getProInstAtt3Value())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_4) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getProInstAtt4Value())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_5) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getProInstAtt5Value())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_NUM_1) && columna.isShow()) {out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getProInstAtt1ValueNum())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_NUM_2) && columna.isShow()) {out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getProInstAtt2ValueNum())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_NUM_3) && columna.isShow()) {out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getProInstAtt3ValueNum())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_DTE_1) && columna.isShow()) {out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getProInstAtt1ValueDte())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_DTE_2) && columna.isShow()) {out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getProInstAtt2ValueDte())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_DTE_3) && columna.isShow()) {out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getProInstAtt3ValueDte())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_1) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt1Value())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_2) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt2Value())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_3) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt3Value())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_4) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt4Value())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_5) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt5Value())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_6) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt6Value())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_7) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt7Value())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_8) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt8Value())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_9) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt9Value())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_10) && columna.isShow()) 	{out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt10Value())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_1) && columna.isShow()) {out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt1ValueNum())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_2) && columna.isShow()) {out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt2ValueNum())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_3) && columna.isShow()) {out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt3ValueNum())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_4) && columna.isShow()) {out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt4ValueNum())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_5) && columna.isShow()) {out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt5ValueNum())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_6) && columna.isShow()) {out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt6ValueNum())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_7) && columna.isShow()) {out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt7ValueNum())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_8) && columna.isShow()) {out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt8ValueNum())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_1) && columna.isShow()) {out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt1ValueDte())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_2) && columna.isShow()) {out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt2ValueDte())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_3) && columna.isShow()) {out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt3ValueDte())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_4) && columna.isShow()) {out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt4ValueDte())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_5) && columna.isShow()) {out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt5ValueDte())));}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_6) && columna.isShow()) {out.print(DownloadUtil.fmtStr(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt6ValueDte())));}
			out.print(separator);
		}
		out.print(lineSeparator);
	}
}

%>