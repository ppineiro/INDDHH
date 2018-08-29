<%@page import="com.dogma.bean.execution.TaskBean"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.UserData"%><%@page import="java.util.ArrayList"%><%@page import="com.dogma.vo.ProcessVo"%><%@page import="com.st.util.StringUtil"%><%@page import="com.dogma.DogmaException"%><%@page import="java.util.Iterator"%><%@page import="java.util.Collection"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.action.portlet.BasePortletAction"%><%

TaskBean dBean = (TaskBean) request.getSession().getAttribute("apiaPortletBean");
UserData userData	= dBean.getUserData(request);
Integer labelSet	= userData.getLabelSetId();
Integer langId		= userData.getLangId();

boolean mustShow	= false;
%><div class="apiaTitle"><b><%=LabelManager.getName(labelSet,langId,"lblMen")%></b></div><div class="apiaDesc"><% if (dBean.getMessageType() != null) {
	
	ArrayList<String> arr = new ArrayList<String>();
	String message = "";
	switch (dBean.getMessageType().intValue()) {
		case TaskBean.MESSAGE_PROCESS_CREATE :
			ProcessVo proc = dBean.getProInstanceBean().getProcess();
			if (proc.getProAction().equals(ProcessVo.PROCESS_ACTION_CREATION)) {
				boolean showMsgEnt = false;
				if (proc.isFlagNull(proc.getProFlags(),ProcessVo.FLAG_MSG_ENTITY_CREATED)) {
					showMsgEnt = true;
				} else {
					if (proc.getFlagValue(ProcessVo.FLAG_MSG_ENTITY_CREATED)){
						showMsgEnt = true;
					}
				}
				if (showMsgEnt){
					ArrayList<String> arr2 = new ArrayList<String>();
					arr2.add(dBean.getEntInstanceBean().getCompleteEntity().getEntityVo().getBusEntTitle());
					arr2.add(dBean.getEntInstanceBean().getCompleteEntity().getEntInstanceVo().getEntityIdentification());
					message = StringUtil.parseMessage(LabelManager.getName(labelSet,langId, DogmaException.EXE_ENTITY_CREATED),arr2) + "<BR><BR>";
				}
			}
			boolean showMsgProc = false;
			if (proc.isFlagNull(proc.getProFlags(),ProcessVo.FLAG_MSG_PROCESS_CREATED)) {
				showMsgProc = true;
			} else {
				if (proc.getFlagValue(ProcessVo.FLAG_MSG_PROCESS_CREATED)){
					showMsgProc = true;
				}
			}
			if (showMsgProc){
				arr.add(proc.getProName());
				arr.add(dBean.getProInstanceBean().getCompleteProcess().getProcInstance().getIdentification());
				message += StringUtil.parseMessage(LabelManager.getName(labelSet,langId, DogmaException.EXE_PROCESS_CREATED),arr) + "<BR><BR>";
			}
			boolean showMsgCustom = false;
			if (proc.getFlagValue(ProcessVo.FLAG_MSG_CUSTOM_CREATED) && (proc.getCustomMsg() != null) && (proc.getCustomMsg().length() > 0)) {
				showMsgCustom = true;
			}
			if (showMsgCustom) {
				message += proc.getCustomMsg();
			}

			//-------AGREGADO MENSAJES
			message += "<BR>";
			if(dBean.getUserMessages(request)!=null){
				for (String msg : (Collection<String>) dBean.getUserMessages(request)) {
					message += "<BR>" + msg;
				}
			}
			dBean.clearUserMessages(request);
			//--------FIN AGREGADO MENSAJES

			%><%= message %><%
			break;
		case TaskBean.MESSAGE_TASK_COMPLETED :
			arr.add(dBean.getCurrentElement().getTskTitle());
			message = StringUtil.parseMessage(LabelManager.getName(labelSet,langId, DogmaException.EXE_TASK_COMPLETED),arr);

			//-------AGREGADO MENSAJES
			message += "<BR>";
			if(dBean.getUserMessages(request)!=null){
				mustShow=true;
				for (String msg : (Collection<String>) dBean.getUserMessages(request)) {
					message += "<BR>" + msg;
				}
			}
			dBean.clearUserMessages(request);
			//--------FIN AGREGADO MENSAJES
			if(!mustShow && Parameters.AUTOCLOSE_TASK_CONFIRM) { 
				message = ""; 
			}
			%><%= message %><%
			break;
		case TaskBean.MESSAGE_TASK_SAVED :
			arr.add(dBean.getCurrentElement().getTskName());
			message = StringUtil.parseMessage(LabelManager.getName(labelSet,langId, DogmaException.EXE_TASK_SAVED),arr);
			if (!mustShow && Parameters.AUTOCLOSE_TASK_CONFIRM) {
				message = "";
			}
			%><%= message %><%
			break;
		case TaskBean.MESSAGE_TASK_ELE_OR_DEL :
			message = LabelManager.getName(labelSet,langId, DogmaException.EXE_TSK_DELEGATED);
			if (!mustShow && Parameters.AUTOCLOSE_TASK_CONFIRM) {
				message = "";
			}
			%><%= message %><%
			break;					
	}
	
	//dBean.clearMessages();	
} %></div><div class="apiaContainer"><a href="ProcessStartAction.portlet?<%= BasePortletAction.getInitialParamsUrl(request) %>">Volver al inicio</a></div>