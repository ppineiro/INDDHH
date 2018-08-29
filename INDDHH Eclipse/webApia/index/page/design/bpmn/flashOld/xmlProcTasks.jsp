<%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.action.design.BPMNProcessAction"%><%@page import="biz.statum.apia.web.bean.design.BPMNProcessBean"%><%@page import="com.dogma.XMLTags"%><%@page import="com.dogma.bean.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.*"%><%@page import="java.util.*"%><%@page import="com.st.util.StringUtil"%><%
BPMNProcessBean dBean = (BPMNProcessBean)BPMNProcessAction.staticRetrieveBean(new HttpServletRequestResponse(request, response));

if(request.getHeader("User-Agent").indexOf("Firefox")<0){response.setHeader("Pragma","public no-cache");}else{	response.setHeader("Pragma","no-cache");}
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");
response.setContentType("text/xml");

Collection tasks=dBean.getProcTasks(request,response);

if (!dBean.hasMessages()) {
	String tasksXML="<?xml version=\"1.0\" encoding=\"UTF-8\"?><ROWSET>";
	if(tasks!=null){
		Iterator it=tasks.iterator();
		while(it.hasNext()){
			ProElementVo t=(ProElementVo)it.next();
			tasksXML+="<TASK id=\""+t.getTskId()+"\"  name=\""+t.getTskName()+"\"  />";
		}
	}
	tasksXML+="</ROWSET>";
	out.clear();
	out.print(tasksXML);
} else {
	out.print(dBean.getMessagesAsXml(new HttpServletRequestResponse(request, response)));
	dBean.clearMessages();
}
%>