<%@page import="java.util.HashMap"%><%@page import="com.dogma.Configuration"%><%@page import="java.util.Iterator"%><%@page import="com.dogma.vo.DocumentVo"%><%@include file="../includes/startInc.jsp" %><%
 
biz.statum.apia.web.bean.BasicBean basicBean = null;
biz.statum.apia.web.bean.execution.ExecutionBean aBean = null;
biz.statum.apia.web.bean.execution.TaskBean tBean = null;
biz.statum.apia.web.bean.execution.EntInstanceBean eBean = null;
biz.statum.apia.web.bean.monitor.ProcessesBean pBean = null;

boolean isProcessMonitor = "true".equals(request.getParameter("isProcessMonitor"));
boolean isTaskMonitor = "true".equals(request.getParameter("isTaskMonitor"));
boolean isTask = "true".equals(request.getParameter("isTask"));

if(isProcessMonitor){
	basicBean = biz.statum.apia.web.action.BasicAction.staticRetrieveBean(request, response, biz.statum.apia.web.action.BasicAction.BEAN_ADMIN_NAME);
}else if(isTaskMonitor){
	basicBean = biz.statum.apia.web.action.BasicAction.staticRetrieveBean(request, response, biz.statum.apia.web.action.BasicAction.BEAN_ADMIN_NAME);
}else if(isTask){
	basicBean = biz.statum.apia.web.action.BasicAction.staticRetrieveBean(request, response, biz.statum.apia.web.action.BasicAction.BEAN_EXEC_NAME);
	if(basicBean==null){ //esto es por si esta en el monitor
		basicBean = biz.statum.apia.web.action.BasicAction.staticRetrieveBean(request, response, biz.statum.apia.web.action.BasicAction.BEAN_ADMIN_NAME);
	}
}else{
	basicBean = biz.statum.apia.web.action.BasicAction.staticRetrieveBean(request, response, biz.statum.apia.web.action.BasicAction.BEAN_ADMIN_NAME);
}

if(basicBean instanceof biz.statum.apia.web.bean.execution.EntInstanceListBean){
	aBean = ((biz.statum.apia.web.bean.execution.EntInstanceListBean)basicBean).getEntInstanceBean();
	eBean =  ((biz.statum.apia.web.bean.execution.EntInstanceListBean)basicBean).getEntInstanceBean();
} else if (basicBean instanceof biz.statum.apia.web.bean.execution.TaskBean){
	aBean = (biz.statum.apia.web.bean.execution.TaskBean)basicBean;
} else if (basicBean instanceof biz.statum.apia.web.bean.monitor.EntitiesBean){
	aBean = (biz.statum.apia.web.bean.monitor.EntitiesBean)basicBean;
} else if (basicBean instanceof biz.statum.apia.web.bean.monitor.ProcessesBean){
	eBean = ((biz.statum.apia.web.bean.monitor.ProcessesBean)basicBean).getEntInstanceBean();
} else if (basicBean instanceof biz.statum.apia.web.bean.monitor.TasksBean){
	eBean = ((biz.statum.apia.web.bean.monitor.TasksBean)basicBean).getEntInstanceBean();
}

if (aBean instanceof biz.statum.apia.web.bean.execution.TaskBean) {
	tBean = (biz.statum.apia.web.bean.execution.TaskBean) aBean;
} else if (basicBean instanceof biz.statum.apia.web.bean.monitor.ProcessesBean) {
	pBean = (biz.statum.apia.web.bean.monitor.ProcessesBean) basicBean;
}

 
if (tBean != null) {
	eBean = tBean.getEntInstanceBean();
}

Collection docst = null;
Collection docse = null;
Collection docsEnv = null;
boolean areDocs = false;

//--help (htmls)
String processName="";
String processTitle="";
String entityName="";
String entityTitle="";
String taskName="";
String taskTitle="";
Collection<String> formNames=new ArrayList<String>();
HashMap<String,String> formData = new HashMap<String,String>();

if(tBean!=null){
	processName = tBean.getProInstanceBean().getProcess().getProName();
	processTitle = tBean.getProInstanceBean().getProcess().getProTitle();
	taskName = tBean.getTaskVo().getTskName();
	taskTitle = tBean.getTaskVo().getTskTitle();
	formData.putAll(tBean.getFormNames(request));
} else if (pBean != null) {
	processName = pBean.getProInstanceBean().getProcess().getProName();
	processTitle = pBean.getProInstanceBean().getProcess().getProTitle();
	if(pBean.getCurrentElement()!=null){
		taskName = pBean.getCurrentElement().getTskName();
		taskTitle = pBean.getCurrentElement().getTskTitle();
	}
	formData.putAll(pBean.getFormNames(request));
}
if(eBean!=null){
	entityName = eBean.getEntityType().getBusEntName();
	entityTitle = eBean.getEntityType().getBusEntTitle();
	formData.putAll(eBean.getFormNames(request));
}
formNames.addAll(formData.keySet());
%><%! 
private String processCollection(Collection docs) {
	if (docs != null) {
		Iterator iterator = docs.iterator();
		StringBuffer buffer = new StringBuffer();
		while (iterator.hasNext()) {
			DocumentVo docVo = (DocumentVo) iterator.next();
			buffer.append("<li>");
			buffer.append("<A href='#nowhere' onclick=\"downloadDocument('" + docVo.getDocId().toString() + "')\">" + docVo.getDocName() + "</a>");
			buffer.append("</li>");
		}
		return buffer.toString();
	} else {
		return "";
	}
}
%><html><head><%@include file="../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" ><script type="text/javascript">
	function  initPage(){
		
	}
	function downloadDocument(docId) {
		<%if (basicBean instanceof biz.statum.apia.web.bean.execution.TaskBean){%>
			$('docFrame').src = CONTEXT + "/apia.execution.TaskAction.run?action=downloadDocument&docId=" +  docId + "<system:util show="tabIdRequest"  />";
		<%} else if(basicBean instanceof biz.statum.apia.web.bean.execution.EntInstanceListBean){%>
			$('docFrame').src = CONTEXT + "/apia.execution.EntInstanceListAction.run?action=downloadDocument&docId=" +  docId + "<system:util show="tabIdRequest"  />";
		<%} else if(basicBean instanceof biz.statum.apia.web.bean.monitor.ProcessesBean){%>
			$('docFrame').src = CONTEXT + "/apia.monitor.ProcessesAction.run?action=downloadDocument&docId=" +  docId + "<system:util show="tabIdRequest"  />";
		<%} else if(basicBean instanceof biz.statum.apia.web.bean.monitor.TasksBean){%>
			$('docFrame').src = CONTEXT + "/apia.monitor.TasksAction.run?action=downloadDocument&docId=" +  docId + "<system:util show="tabIdRequest"  />";
		<%} else {%>
			alert("ver que bean esta uando para agregar el link");
		<%}%>
	}
	
	</script></head><body><iframe id="docFrame" style="display:none"></iframe><div class="header"></div><div class="body" id="bodyDiv"><div class="optionsContainer"></div><div class="dataContainer"><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtEjeDoc" /></div></div><% if (tBean != null || pBean!=null) {
			if(tBean!=null){
				docst = tBean.getProcessDocuments(request);
			} else if (pBean!=null){
				docst = pBean.getProcessDocuments(request);
			}
			if (docst != null && docst.size() > 0) { %><div class="fieldGroup"><DIV class="subtitle"><system:label show="text" label="sbtEjeDocPro" /></DIV><ul class="listContainer"><%= processCollection(docst)%></ul></div><%
				areDocs = true;
			}
			if(tBean!=null){
				docst = tBean.getTaskDocuments(request);
			} else if (pBean!=null){
				docst = pBean.getTaskDocuments(request);
			}
			if (docst != null && docst.size() > 0) { %><div class="fieldGroup"><DIV class="subtitle"><system:label show="text" label="sbtEjeDocTar" /></DIV><ul class="listContainer"><%= processCollection(docst)%></ul></div><%
				areDocs = true;
			}
		}
		
		if (tBean != null || eBean != null) { 
			docst = null;
			docse = null;
			docsEnv = null;
			if (tBean != null) {
				docst = tBean.getEntityDocuments(request);
				docsEnv = tBean.getEnvDocuments(request);
			} else if (eBean != null) {
				docse = eBean.getEntityDocuments(request);
				docsEnv = eBean.getEnvDocuments(request);
			}
			if ((docst != null && docst.size() > 0) || (docse != null && docse.size() > 0)) { %><div class="fieldGroup"><DIV class="subtitle"><system:label show="text" label="sbtEjeDocEnt" /></DIV><ul class="listContainer"><%= (docst != null && docst.size() > 0)?processCollection(docst):""%><%= (docse != null && docse.size() > 0)?processCollection(docse):""%><%
				areDocs = true;
				%></ul></div><%
			}
			
			
			if ((docsEnv != null && docsEnv.size() > 0)) { %><div class="fieldGroup"><DIV class="subtitle"><system:label show="text" label="sbtEjeDocEnv" /></DIV><ul class="listContainer"><%= (docsEnv != null && docsEnv.size() > 0)?processCollection(docsEnv):""%><%
			areDocs = true;
			%></ul></div><%
		}

			docst = null;
			docse = null;
			if (tBean != null) {
				docst = tBean.getFormDocuments(request);
			}
			if (eBean != null) {
				docse = eBean.getFormDocuments(request);
			}
			if (pBean != null){
				docst = pBean.getFormDocuments(request);
			}
			if ((docst != null && docst.size() > 0) || (docse != null && docse.size() > 0)) { %><div class="fieldGroup"><DIV class="subtitle"><system:label show="text" label="sbtEjeDocFor" /></DIV><ul class="listContainer"><%= (docst != null && docst.size() > 0)?processCollection(docst):""%><%= (docse != null && docse.size() > 0)?processCollection(docse):""%><%
				areDocs = true;
				%></ul></div><%
			}
		} 
		
		if (! areDocs) { %><system:label show="text" label="sbtNoDocs" /><% } %><%
		boolean existHelp = false;
		boolean hasForms = false;
		Configuration.initHelp();
		if(Configuration.helpFiles.contains("proc_"+processName.toLowerCase()+".html") || Configuration.helpFiles.contains("ent_"+entityName.toLowerCase()+".html") || Configuration.helpFiles.contains("task_"+taskName.toLowerCase()+".html")){
			existHelp = true;
		}
		if(formNames!=null){
			for(String s : formNames){
				if(Configuration.helpFiles.contains("form_"+s.toLowerCase()+".html")){
					existHelp = true;
					hasForms = true;
				}
			}
		}
		if(existHelp){ %><div class="fieldGroup"><div class="title"><system:label show="text" label="titDocumen" /></div></div><%
		if(Configuration.helpFiles.contains("proc_"+processName.toLowerCase()+".html")){
			%><div class="fieldGroup"><DIV class="subtitle"><system:label show="text" label="sbtDocPro" /></DIV><ul class="listContainer"><li><A href='#nowhere' onclick="window.open('<system:util show="context" />/helpHTML/<%="proc_"+processName.toLowerCase()+".html" %>')"><%=processTitle%></a></li></ul></div><%
		}
		if(Configuration.helpFiles.contains("ent_"+entityName.toLowerCase()+".html")){
			%><div class="fieldGroup"><DIV class="subtitle"><system:label show="text" label="sbtDocEnt" /></DIV><ul class="listContainer"><li><A href='#nowhere' onclick="window.open('<system:util show="context" />/helpHTML/<%="ent_"+entityName.toLowerCase()+".html" %>')"><%=entityTitle%></a></li></ul></div><%
		}
		if(Configuration.helpFiles.contains("task_"+taskName.toLowerCase()+".html")){
			%><div class="fieldGroup"><DIV class="subtitle"><system:label show="text" label="sbtDocTar" /></DIV><ul class="listContainer"><li><A href='#nowhere' onclick="window.open('<system:util show="context" />/helpHTML/<%="task_"+taskName.toLowerCase()+".html" %>')"><%=taskTitle%></a></li></ul></div><%
		}
		if(hasForms){
			//poner titulo primero
			%><div class="fieldGroup"><DIV class="subtitle"><system:label show="text" label="sbtDocFor" /></DIV><ul class="listContainer"><%
			//poner links
			for(String s : formNames){
				if(Configuration.helpFiles.contains("form_"+s.toLowerCase()+".html")){
					%><li><A href='#nowhere' onclick="window.open('<system:util show="context" />/helpHTML/<%="form_"+ s.toLowerCase() +".html" %>')"><%=formData.get(s)%></a></li><%	
				}
			}
			%></ul></div><%
		}
		%><% } %></div></div></body></html>
 
 
