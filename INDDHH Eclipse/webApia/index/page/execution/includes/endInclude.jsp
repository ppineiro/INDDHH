<!-- Aca se van a buscar las excepciones que hayan existido en el serverpara mostrarlas en pantalla --><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><textarea id="execErrors" style="display:none"><%
// biz.statum.apia.web.bean.BasicBean basicBean = biz.statum.apia.web.action.BasicAction.staticRetrieveBean(request, response, biz.statum.apia.web.action.BasicAction.BEAN_ADMIN_NAME);
// biz.statum.apia.web.bean.execution.ExecutionBean aBean = null;

// if(basicBean instanceof biz.statum.apia.web.bean.execution.EntInstanceListBean){
// 	aBean = ((biz.statum.apia.web.bean.execution.EntInstanceListBean)basicBean).getEntInstanceBean();
// } else if (basicBean instanceof biz.statum.apia.web.bean.execution.TaskBean){
// 	aBean = (biz.statum.apia.web.bean.execution.TaskBean)basicBean;
// }


biz.statum.apia.web.bean.BasicBean basicBean = null;
boolean isTask = "true".equals(request.getAttribute("isTask"));
boolean isMonitorProcess = "true".equals(request.getAttribute("isMonitorProcess"));
boolean isMonitorTask = "true".equals(request.getAttribute("isMonitorTask"));
if(isTask){
	basicBean = biz.statum.apia.web.action.BasicAction.staticRetrieveBean(request, response, biz.statum.apia.web.action.BasicAction.BEAN_EXEC_NAME);
} else if (isMonitorProcess) {
	basicBean = biz.statum.apia.web.action.BasicAction.staticRetrieveBean(request, response, biz.statum.apia.web.action.BasicAction.BEAN_ADMIN_NAME);
} else if (isMonitorTask) {
	basicBean = biz.statum.apia.web.action.BasicAction.staticRetrieveBean(request, response, biz.statum.apia.web.action.BasicAction.BEAN_MONITOR_TASK);
}else{
	basicBean = biz.statum.apia.web.action.BasicAction.staticRetrieveBean(request, response, biz.statum.apia.web.action.BasicAction.BEAN_ADMIN_NAME);
}

String executionExceptions = null;

HttpServletRequestResponse http = new HttpServletRequestResponse(request, response);

if(basicBean instanceof biz.statum.apia.web.bean.execution.EntInstanceListBean){
	executionExceptions = ((biz.statum.apia.web.bean.execution.EntInstanceListBean)basicBean).getEntInstanceBean().getExecutionExceptions(request,response);
} else if (basicBean instanceof biz.statum.apia.web.bean.execution.TaskBean){
	executionExceptions = ((biz.statum.apia.web.bean.execution.TaskBean)basicBean).getExecutionExceptions(request,response);
} else if (basicBean instanceof biz.statum.apia.web.bean.monitor.ProcessesBean){
	executionExceptions = ((biz.statum.apia.web.bean.monitor.ProcessesBean)basicBean).getExecutionExceptions(http);
} else if (basicBean instanceof biz.statum.apia.web.bean.monitor.TasksBean){
	executionExceptions = ((biz.statum.apia.web.bean.monitor.TasksBean)basicBean).getExecutionExceptions(http);
} else if (basicBean instanceof biz.statum.apia.web.bean.monitor.EntitiesBean){
	executionExceptions = ((biz.statum.apia.web.bean.monitor.EntitiesBean)basicBean).getExecutionExceptions(http);
} else if (basicBean instanceof biz.statum.apia.web.bean.monitor.BusinessBean){
	executionExceptions = ((biz.statum.apia.web.bean.monitor.BusinessBean)basicBean).getExecutionExceptions(http);
}


if(executionExceptions != null)
	out.print(executionExceptions);
%></textarea>