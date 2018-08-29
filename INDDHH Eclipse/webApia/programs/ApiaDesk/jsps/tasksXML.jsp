<%@page import="com.dogma.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="com.dogma.vo.custom.*"%><%@page import="com.dogma.bean.execution.ListTaskBean"%><%@page import="java.util.*"%><%@page import="com.st.util.*"%><%@page import="com.st.util.labels.LabelManager"%><%
//response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);
response.setCharacterEncoding("utf-8");
response.setContentType("text/xml");%><jsp:useBean id="lBeanReady" scope="session" class="com.dogma.bean.execution.ListTaskBean"></jsp:useBean><jsp:useBean id="lBeanInproc" scope="session" class="com.dogma.bean.execution.ListTaskBean"></jsp:useBean><%

String labelSet = "0001"+String.valueOf(Parameters.DEFAULT_LABEL_SET);
String WORK_MODE = request.getParameter("listType");

String action 	= request.getParameter("action");

if("acquire".equals(action) || "release".equals(action)){
	com.dogma.bean.execution.ListTaskBean bean=null;
	out.clear();
	if (!lBeanInproc.hasMessages() && !lBeanReady.hasMessages()) {
		out.print("<ok />");
		return;
	} else if(lBeanInproc.hasMessages()) {
		out.print(lBeanInproc.getMessagesAsXml(request));
		lBeanInproc.clearMessages();
		return;
	}else if(lBeanReady.hasMessages()){
		out.print(lBeanReady.getMessagesAsXml(request));
		lBeanReady.clearMessages();
		return;
	}
}

TaskListColumnsVo columns = null;
if (WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS)) {
	columns = lBeanInproc.getColumns();
} else {
	columns = lBeanReady.getColumns();
}

String colsStr="";
Iterator iterator = columns.iterator();

while (iterator.hasNext()) {
	ColumnVo columna = (ColumnVo) iterator.next(); 
	if(columna.getNombre().equals(TaskListColumnsVo.COL_PRIORIDAD ) && columna.isShow()) {
		//ListTaskBean.COL_PRIORIDAD  LabelManager.getToolTip(labelSet,"lblEjePriPro") lblHighPriority lblLowPriority lblNormalPriority lblNotPriority
		colsStr+=LabelManager.getToolTip(labelSet,"lblEjePriPro")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_STATUS ) && columna.isShow()) {
		//LabelManager.getToolTip(labelSet,"lblEjeStaPro") lblEveProOver lblEveProAlert 
		colsStr+=LabelManager.getToolTip(labelSet,"lblEjeStaPro")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_TSK_STATUS ) && columna.isShow()) {
		//LabelManager.getToolTip(labelSet,"lblEjeStaTsk") lblEveTskAla lblEveTskOver
		colsStr+=LabelManager.getToolTip(labelSet,"lblEjeStaTsk")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_TSK_TITLE ) && columna.isShow()) {
		//ListTaskBean.COL_TASK_TITLE LabelManager.getToolTip(labelSet,"lblEjeNomTar")  LabelManager.getName(labelSet,"lblTskTit")
		colsStr+=LabelManager.getToolTip(labelSet,"lblEjeNomTar")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_NUMERO_ENTIDAD) && columna.isShow()) {
		//ListTaskBean.COL_ENT_ID_NUM ListTaskBean.ORDER_ENT_ID_NUM  LabelManager.getToolTip(labelSet,"lblEjeInsEntNum") LabelManager.getName(labelSet,"lblEjeInsEntNum")
		colsStr+=LabelManager.getToolTip(labelSet,"lblEjeInsEntNum")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_NUMERO_PROCESO) && columna.isShow()) {
		//ListTaskBean.COL_PROC_ID_NUM ListTaskBean.ORDER_PROC_ID_NUM LabelManager.getToolTip(labelSet,"lblEjeInsProNum") LabelManager.getName(labelSet,"lblEjeInsProNum")
		colsStr+=LabelManager.getToolTip(labelSet,"lblEjeInsProNum")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_GRUPO) && columna.isShow()) {
		//ListTaskBean.COL_TASK_GROUP  ListTaskBean.ORDER_TASK_GROUP  LabelManager.getToolTip(labelSet,"lblEjeGruTar")   LabelManager.getName(labelSet,"lblEjeGruTar")
		colsStr+=LabelManager.getToolTip(labelSet,"lblEjeGruTar")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_TITLE) && columna.isShow()) {
		//ListTaskBean.COL_PROC_TITLE ListTaskBean.ORDER_PROC_TITLE LabelManager.getToolTip(labelSet,"lblProTit") LabelManager.getName(labelSet,"lblProTit")
		colsStr+=LabelManager.getToolTip(labelSet,"lblProTit")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_TIPO_PROCESO) && columna.isShow()) {
		//ListTaskBean.COL_PROC_TYPE ListTaskBean.ORDER_PROC_TYPE LabelManager.getToolTip(labelSet,"lblEjeTipProTar") LabelManager.getName(labelSet,"lblEjeTipProTar")
		colsStr+=LabelManager.getToolTip(labelSet,"lblEjeTipProTar")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_CREACION_TAREA) && columna.isShow()) {
		//ListTaskBean.COL_TASK_DATE ListTaskBean.ORDER_TASK_DATE LabelManager.getToolTip(labelSet,"lblEjeFecCreTar") LabelManager.getName(labelSet,"lblEjeFecCreTar")
		colsStr+=LabelManager.getToolTip(labelSet,"lblEjeFecCreTar")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_CREACION_PROCESO) && columna.isShow()) {
		//ListTaskBean.COL_PROC_DATE  ListTaskBean.ORDER_PROC_DATE LabelManager.getToolTip(labelSet,"lblEjeFecCreProTar")  LabelManager.getName(labelSet,"lblEjeFecCreProTar")
		colsStr+=LabelManager.getToolTip(labelSet,"lblEjeFecCreProTar")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_CREADOR_PROCESO) && columna.isShow()) {
		//ListTaskBean.COL_PROC_USER  ListTaskBean.ORDER_PROC_USER   LabelManager.getToolTip(labelSet,"lblEjeUsuCreProTar")  LabelManager.getName(labelSet,"lblEjeUsuCreProTar")
		colsStr+=LabelManager.getToolTip(labelSet,"lblEjeUsuCreProTar")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_STATUS) && columna.isShow()) {
		//ListTaskBean.COL_ENT_STATUS  ListTaskBean.ORDER_ENT_STATUS  LabelManager.getToolTip(labelSet,"lblEjeStaEntTar")   LabelManager.getName(labelSet,"lblEjeStaEntTar")
		colsStr+=LabelManager.getToolTip(labelSet,"lblEjeStaEntTar")+";";
	}else if(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !Parameters.SHOW_MY_TASKS){
		if(columna.getNombre().equals(TaskListColumnsVo.COL_USER_LOGIN) && columna.isShow()) {
			//ListTaskBean.COL_USER_LOGIN  ListTaskBean.ORDER_USER_LOGIN   LabelManager.getToolTip(labelSet,"lblEjeUseAdq")  LabelManager.getName(labelSet,"lblEjeUseAdq")
			colsStr+=LabelManager.getToolTip(labelSet,"lblEjeUseAdq")+";";
		}
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_1) && columna.isShow()) {
		//ListTaskBean.COL_PRO_INST_ATT_1 ListTaskBean.ORDER_PRO_INST_ATT_1  LabelManager.getToolTip(labelSet,"lblAtt1Pro")  LabelManager.getName(labelSet,"lblAtt1Pro")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAtt1Pro")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_2) && columna.isShow()) {
		//ListTaskBean.COL_PRO_INST_ATT_2  ListTaskBean.ORDER_PRO_INST_ATT_2  LabelManager.getToolTip(labelSet,"lblAtt2Pro")  LabelManager.getName(labelSet,"lblAtt2Pro")
		colsStr+=LabelManager.getToolTip(labelSet,"lblEjeInsProNum")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_3) && columna.isShow()) {
		//ListTaskBean.COL_PRO_INST_ATT_3  ListTaskBean.ORDER_PRO_INST_ATT_3  LabelManager.getToolTip(labelSet,"lblAtt3Pro")  LabelManager.getName(labelSet,"lblAtt3Pro")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAtt2Pro")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_4) && columna.isShow()) {
		//ListTaskBean.COL_PRO_INST_ATT_4 ListTaskBean.ORDER_PRO_INST_ATT_4  LabelManager.getToolTip(labelSet,"lblAtt4Pro")  LabelManager.getName(labelSet,"lblAtt4Pro")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAtt4Pro")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_5) && columna.isShow()) {
		//ListTaskBean.COL_PRO_INST_ATT_5  ListTaskBean.ORDER_PRO_INST_ATT_5   LabelManager.getToolTip(labelSet,"lblAtt5Pro")  LabelManager.getName(labelSet,"lblAtt5Pro")
		colsStr+=LabelManager.getToolTip(labelSet,"lblEjeInsProNum")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_NUM_1) && columna.isShow()) {
		//ListTaskBean.COL_PRO_INST_ATT_NUM_1  ListTaskBean.ORDER_PRO_INST_ATT_NUM_1   LabelManager.getToolTip(labelSet,"lblAttNum1Pro")  LabelManager.getName(labelSet,"lblAttNum1Pro")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAttNum1Pro")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_NUM_2) && columna.isShow()) {
		//ListTaskBean.COL_PRO_INST_ATT_NUM_2  ListTaskBean.ORDER_PRO_INST_ATT_NUM_2   LabelManager.getToolTip(labelSet,"lblAttNum2Pro")  LabelManager.getName(labelSet,"lblAttNum2Pro")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAttNum2Pro")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_NUM_3) && columna.isShow()) {
		//ListTaskBean.COL_PRO_INST_ATT_NUM_3  ListTaskBean.ORDER_PRO_INST_ATT_NUM_3  LabelManager.getToolTip(labelSet,"lblAttNum3Pro")  LabelManager.getName(labelSet,"lblAttNum3Pro")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAttNum3Pro")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_DTE_1) && columna.isShow()) {
		//ListTaskBean.COL_PRO_INST_ATT_DTE_1   ListTaskBean.ORDER_PRO_INST_ATT_DTE_1    LabelManager.getToolTip(labelSet,"lblAttDte1Pro")  LabelManager.getName(labelSet,"lblAttDte1Pro")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAttDte1Pro")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_DTE_2) && columna.isShow()) {
		//ListTaskBean.COL_PRO_INST_ATT_DTE_2   ListTaskBean.ORDER_PRO_INST_ATT_DTE_2  LabelManager.getToolTip(labelSet,"lblAttDte2Pro")   LabelManager.getName(labelSet,"lblAttDte2Pro")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAttDte2Pro")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_DTE_3) && columna.isShow()) {
		//ListTaskBean.COL_PRO_INST_ATT_DTE_3  ListTaskBean.ORDER_PRO_INST_ATT_DTE_3   LabelManager.getToolTip(labelSet,"lblAttDte3Pro")  LabelManager.getName(labelSet,"lblAttDte3Pro")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAttDte3Pro")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_1) && columna.isShow()) {
		//ListTaskBean.COL_ENT_INST_ATT_1    ListTaskBean.ORDER_ENT_INST_ATT_1   LabelManager.getToolTip(labelSet,"lblAtt1EntNeg")   LabelManager.getName(labelSet,"lblAtt1EntNeg")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAtt1EntNeg")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_2) && columna.isShow()) {
		//ListTaskBean.COL_ENT_INST_ATT_2  ListTaskBean.ORDER_ENT_INST_ATT_2  LabelManager.getToolTip(labelSet,"lblAtt2EntNeg")  LabelManager.getName(labelSet,"lblAtt2EntNeg")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAtt2EntNeg")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_3) && columna.isShow()) {
		//ListTaskBean.COL_ENT_INST_ATT_3  ListTaskBean.ORDER_ENT_INST_ATT_3  LabelManager.getToolTip(labelSet,"lblAtt3EntNeg")  LabelManager.getName(labelSet,"lblAtt3EntNeg")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAtt3EntNeg")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_4) && columna.isShow()) {
		//ListTaskBean.COL_ENT_INST_ATT_4  ListTaskBean.ORDER_ENT_INST_ATT_4  LabelManager.getToolTip(labelSet,"lblAtt4EntNeg")  LabelManager.getName(labelSet,"lblAtt4EntNeg")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAtt4EntNeg")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_5) && columna.isShow()) {
		//ListTaskBean.COL_ENT_INST_ATT_5  ListTaskBean.ORDER_ENT_INST_ATT_5  LabelManager.getToolTip(labelSet,"lblAtt5EntNeg")  LabelManager.getName(labelSet,"lblAtt5EntNeg")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAtt5EntNeg")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_6) && columna.isShow()) {
		//ListTaskBean.COL_ENT_INST_ATT_6    ListTaskBean.ORDER_ENT_INST_ATT_6   LabelManager.getToolTip(labelSet,"lblAtt6EntNeg")   LabelManager.getName(labelSet,"lblAtt6EntNeg")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAtt6EntNeg")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_7) && columna.isShow()) {
		//ListTaskBean.COL_ENT_INST_ATT_7  ListTaskBean.ORDER_ENT_INST_ATT_7  LabelManager.getToolTip(labelSet,"lblAtt7EntNeg")  LabelManager.getName(labelSet,"lblAtt7EntNeg")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAtt7EntNeg")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_8) && columna.isShow()) {
		//ListTaskBean.COL_ENT_INST_ATT_8  ListTaskBean.ORDER_ENT_INST_ATT_8  LabelManager.getToolTip(labelSet,"lblAtt8EntNeg")  LabelManager.getName(labelSet,"lblAtt8EntNeg")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAtt8EntNeg")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_9) && columna.isShow()) {
		//ListTaskBean.COL_ENT_INST_ATT_9  ListTaskBean.ORDER_ENT_INST_ATT_9  LabelManager.getToolTip(labelSet,"lblAtt9EntNeg")  LabelManager.getName(labelSet,"lblAtt9EntNeg")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAtt9EntNeg")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_10) && columna.isShow()) {
		//ListTaskBean.COL_ENT_INST_ATT_10  ListTaskBean.ORDER_ENT_INST_ATT_10  LabelManager.getToolTip(labelSet,"lblAtt10EntNeg")  LabelManager.getName(labelSet,"lblAtt10EntNeg")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAtt10EntNeg")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_1) && columna.isShow()) {
		//ListTaskBean.COL_ENT_INST_ATT_NUM_1  ListTaskBean.ORDER_ENT_INST_ATT_NUM_1  LabelManager.getToolTip(labelSet,"lblAttNum1EntNeg")  LabelManager.getName(labelSet,"lblAttNum1EntNeg")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAttNum1EntNeg")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_2) && columna.isShow()) {
		//ListTaskBean.COL_ENT_INST_ATT_NUM_2  ListTaskBean.ORDER_ENT_INST_ATT_NUM_2  LabelManager.getToolTip(labelSet,"lblAttNum2EntNeg")  LabelManager.getName(labelSet,"lblAttNum2EntNeg")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAttNum2EntNeg")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_3) && columna.isShow()) {
		//ListTaskBean.COL_ENT_INST_ATT_NUM_3  ListTaskBean.ORDER_ENT_INST_ATT_NUM_3  LabelManager.getToolTip(labelSet,"lblAttNum3EntNeg")  LabelManager.getName(labelSet,"lblAttNum3EntNeg")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAttNum3EntNeg")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_4) && columna.isShow()) {
		//ListTaskBean.COL_ENT_INST_ATT_NUM_4  ListTaskBean.ORDER_ENT_INST_ATT_NUM_4  LabelManager.getToolTip(labelSet,"lblAttNum4EntNeg")  LabelManager.getName(labelSet,"lblAttNum1EntNeg")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAttNum4EntNeg")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_5) && columna.isShow()) {
		//ListTaskBean.COL_ENT_INST_ATT_NUM_5  ListTaskBean.ORDER_ENT_INST_ATT_NUM_5  LabelManager.getToolTip(labelSet,"lblAttNum5EntNeg")  LabelManager.getName(labelSet,"lblAttNum5EntNeg")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAttNum5EntNeg")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_6) && columna.isShow()) {
		//ListTaskBean.COL_ENT_INST_ATT_NUM_6  ListTaskBean.ORDER_ENT_INST_ATT_NUM_6  LabelManager.getToolTip(labelSet,"lblAttNum6EntNeg")  LabelManager.getName(labelSet,"lblAttNum6EntNeg")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAttNum6EntNeg")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_7) && columna.isShow()) {
		//ListTaskBean.COL_ENT_INST_ATT_NUM_7  ListTaskBean.ORDER_ENT_INST_ATT_NUM_7  LabelManager.getToolTip(labelSet,"lblAttNum7EntNeg")  LabelManager.getName(labelSet,"lblAttNum7EntNeg")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAttNum7EntNeg")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_8) && columna.isShow()) {
		//ListTaskBean.COL_ENT_INST_ATT_NUM_8  ListTaskBean.ORDER_ENT_INST_ATT_NUM_8  LabelManager.getToolTip(labelSet,"lblAttNum8EntNeg")  LabelManager.getName(labelSet,"lblAttNum8EntNeg")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAttNum8EntNeg")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_1) && columna.isShow()) {
		//ListTaskBean.COL_ENT_INST_ATT_DTE_1  ListTaskBean.ORDER_ENT_INST_ATT_DTE_1  LabelManager.getToolTip(labelSet,"lblAttDte1EntNeg")  LabelManager.getName(labelSet,"lblAttDte1EntNeg")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAttDte1EntNeg")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_2) && columna.isShow()) {
		//ListTaskBean.COL_ENT_INST_ATT_DTE_2  ListTaskBean.ORDER_ENT_INST_ATT_DTE_2  LabelManager.getToolTip(labelSet,"lblAttDte2EntNeg")  LabelManager.getName(labelSet,"lblAttDte2EntNeg")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAttDte2EntNeg")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_3) && columna.isShow()) {
		//ListTaskBean.COL_ENT_INST_ATT_DTE_3  ListTaskBean.ORDER_ENT_INST_ATT_DTE_3   LabelManager.getToolTip(labelSet,"lblAttDte3EntNeg")  LabelManager.getName(labelSet,"lblAttDte3EntNeg")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAttDte3EntNeg")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_4) && columna.isShow()) {
		//ListTaskBean.COL_ENT_INST_ATT_DTE_4  ListTaskBean.ORDER_ENT_INST_ATT_DTE_4  LabelManager.getToolTip(labelSet,"lblAttDte4EntNeg")  LabelManager.getName(labelSet,"lblAttDte4EntNeg")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAttDte4EntNeg")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_5) && columna.isShow()) {
		//ListTaskBean.COL_ENT_INST_ATT_DTE_5  ListTaskBean.ORDER_ENT_INST_ATT_DTE_5  LabelManager.getToolTip(labelSet,"lblAttDte5EntNeg")  LabelManager.getName(labelSet,"lblAttDte5EntNeg")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAttDte5EntNeg")+";";
	}else if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_6) && columna.isShow()) {
		//ListTaskBean.COL_ENT_INST_ATT_DTE_6  ListTaskBean.ORDER_ENT_INST_ATT_DTE_6   LabelManager.getToolTip(labelSet,"lblAttDte6EntNeg")  LabelManager.getName(labelSet,"lblAttDte6EntNeg")
		colsStr+=LabelManager.getToolTip(labelSet,"lblAttDte6EntNeg")+";";
	}else{
		colsStr+="";
	}
}

String [] cols=colsStr.split(";");
StringBuffer xml=new StringBuffer();
if(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS)){
	xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?><tasks hidTotalRecords=\""+lBeanInproc.getTotalRows()+"\" cantPages=\""+lBeanInproc.getTotalPages()+"\" page=\""+lBeanInproc.getPageNumber()+"\">");
} else {
	xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?><tasks hidTotalRecords=\""+lBeanReady.getTotalRows()+"\" cantPages=\""+lBeanReady.getTotalPages()+"\" page=\""+lBeanReady.getPageNumber()+"\">");
}
Collection col = null;
if(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS)){
	col = lBeanInproc.getList();
} else {
	col = lBeanReady.getList();
}
try{
if (col != null) {
	Iterator it = col.iterator();
	TasksListVo aVO = null;
	while (it.hasNext()) {
		aVO = (TasksListVo) it.next();
		iterator = columns.iterator(); 
		/*String tskImage="_images_uploaded_"+( (aVO.getTskImage()==null  )?"taskicon.png":aVO.getTskImage()  );
		String prcImage="_images_uploaded_"+( (aVO.getProImage()==null  )?"procicon.png":aVO.getProImage()  );
		String tskStatImage="_styles_default_images_tskStatus"+aVO.getTskStatus()+".gif";
		String proStatImage="_styles_default_images_proStatus"+aVO.getProStatus()+".gif";
		tskImage="/administration.ImagesAction.do%3Faction=addHF%26image="+tskImage+"%26footerA="+prcImage+"%26headerA="+tskStatImage+"%26footerB="+proStatImage;
		tskImage+="\" proInstId=\""+ProInstanceVo.getEntityIdentification(aVO.getProcInstIdPre(),aVO.getProcInstIdNum(),aVO.getProcInstIdPos());*/
		String tskImage="/ApiaDeskAction.do%3Faction=taskImage%26proId="+aVO.getProcInstId()+"%26taskId="+aVO.getTaskInstId(); 
		String owner=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool())?"false":"true");
		String task="<task id=\""+com.st.util.StringUtil.escapeXML(aVO.getQueryString())+"\" name=\""+com.st.util.StringUtil.escapeXML(aVO.getTaskTitle())+"\" owner=\""+owner+"\" icon=\""+tskImage+"\" >";
		int i=0;
		while (iterator.hasNext() && i<cols.length) {
			String colvalue="";
			String colname=cols[i];
			ColumnVo columna = (ColumnVo) iterator.next();
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRIORIDAD ) && columna.isShow()) {
				if(aVO.getPriority().intValue()==0){
					colvalue=LabelManager.getName(labelSet,"lblNotPriority");
				}else if(aVO.getPriority().intValue()==1){
					colvalue=LabelManager.getName(labelSet,"lblLowPriority");
				}else if(aVO.getPriority().intValue()==2){
					colvalue=LabelManager.getName(labelSet,"lblNormalPriority");
				}else if(aVO.getPriority().intValue()==3){
					colvalue=LabelManager.getName(labelSet,"lblHighPriority");
				}else{
					colvalue=LabelManager.getName(labelSet,"lblEjePriProUrg");
				}
			}
		
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_STATUS ) && columna.isShow()) {
				if(aVO.getProStatus()==1){
					colvalue=LabelManager.getName(labelSet,"lblEveProAlert");
				}else if(aVO.getProStatus()==2){
					colvalue=LabelManager.getName(labelSet,"lblEveProOver");
				}else{
					colvalue="-";
				}
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_TSK_STATUS ) && columna.isShow()) {
				if(aVO.getTskStatus()==1){
					colvalue=LabelManager.getName(labelSet,"lblEveTskAla");
				}else if(aVO.getTskStatus()==2){
					colvalue=LabelManager.getName(labelSet,"lblEveTskOver");
				}else{
					colvalue="-";
				}
			}
			
			if(columna.getNombre().equals(TaskListColumnsVo.COL_TSK_TITLE ) && columna.isShow()) {
				colvalue=lBeanReady.fmtStr(aVO.getTaskTitle())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_NUMERO_ENTIDAD) && columna.isShow()) {
				colvalue=lBeanReady.fmtStr(BusEntInstanceVo.getEntityIdentification(aVO.getEntInstIdPre(),aVO.getEntInstIdNum(),aVO.getEntInstIdPos()))+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_NUMERO_PROCESO) && columna.isShow()) {
				colvalue=lBeanReady.fmtStr(ProInstanceVo.getEntityIdentification(aVO.getProcInstIdPre(),aVO.getProcInstIdNum(),aVO.getProcInstIdPos()))+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_GRUPO) && columna.isShow()) {
				colvalue=lBeanReady.fmtStr(aVO.getGroupName())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_TITLE) && columna.isShow()) {
				colvalue=lBeanReady.fmtStr(aVO.getProcessTitle())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_TIPO_PROCESO) && columna.isShow()) {
				if(ProcessVo.PROCESS_ACTION_CREATION.equals(aVO.getProcessType())){
					colvalue=LabelManager.getName(labelSet,"lblEjeActCre")+"";
				}
				if(ProcessVo.PROCESS_ACTION_ALTERATION.equals(aVO.getProcessType())){
					colvalue=LabelManager.getName(labelSet,"lblEjeActAlt")+"";
				}
				if(ProcessVo.PROCESS_ACTION_CANCEL.equals(aVO.getProcessType())){
					colvalue=LabelManager.getName(labelSet,"lblEjeActCan")+"";
				}
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_CREACION_TAREA) && columna.isShow()) {
				colvalue=lBeanReady.fmtDateAMPM(aVO.getTaskCreationDate())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_CREACION_PROCESO) && columna.isShow()) {
				colvalue=lBeanReady.fmtDateAMPM(aVO.getProcCreationDate())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_CREADOR_PROCESO) && columna.isShow()) {
				colvalue=lBeanReady.fmtStr(aVO.getProcCreateUser())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_STATUS) && columna.isShow()) {
				colvalue=lBeanReady.fmtStr(aVO.getEntStatus())+"";
			}
			if (WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !Parameters.SHOW_MY_TASKS){
				if(columna.getNombre().equals(TaskListColumnsVo.COL_USER_LOGIN) && columna.isShow()) {
					colvalue=lBeanReady.fmtStr(aVO.getUserLogin())+"";
				}
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_1) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getProInstAtt1Value())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_2) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getProInstAtt2Value())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_3) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getProInstAtt3Value())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_4) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getProInstAtt4Value())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_5) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getProInstAtt5Value())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_NUM_1) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getProInstAtt1ValueNum())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_NUM_2) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getProInstAtt2ValueNum())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_NUM_3) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getProInstAtt3ValueNum())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_DTE_1) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getProInstAtt1ValueDte())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_DTE_2) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getProInstAtt2ValueDte())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_DTE_3) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getProInstAtt3ValueDte())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_1) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getEntInstAtt1Value())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_2) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getEntInstAtt2Value())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_3) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getEntInstAtt3Value())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_4) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getEntInstAtt4Value())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_5) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getEntInstAtt5Value())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_6) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getEntInstAtt6Value())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_7) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getEntInstAtt7Value())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_8) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getEntInstAtt8Value())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_9) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getEntInstAtt9Value())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_10) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getEntInstAtt10Value())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_1) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getEntInstAtt1ValueNum())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_2) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getEntInstAtt2ValueNum())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_3) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getEntInstAtt3ValueNum())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_4) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getEntInstAtt4ValueNum())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_5) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getEntInstAtt5ValueNum())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_6) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getEntInstAtt6ValueNum())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_7) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getEntInstAtt7ValueNum())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_8) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getEntInstAtt8ValueNum())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_1) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getEntInstAtt1ValueDte())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_2) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getEntInstAtt2ValueDte())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_3) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getEntInstAtt3ValueDte())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_4) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getEntInstAtt4ValueDte())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_5) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getEntInstAtt5ValueDte())+"";
			}
			if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_6) && columna.isShow()) {
				colvalue=lBeanReady.fmtHTMLObject(aVO.getEntInstAtt6ValueDte())+"";
			}
			if(!"".equals(colname) && !"".equals(colvalue)){
				task+="<data colname=\""+colname+"\" colvalue=\""+ StringUtil.escapeXML(colvalue)+"\" />";
				i++;
			}
		}
		task+="</task>";
		xml.append(task);
	}
}

}

catch(Throwable e){
	e.printStackTrace();
}
xml.append("</tasks>");
out.clear();
out.print(xml.toString());
%>