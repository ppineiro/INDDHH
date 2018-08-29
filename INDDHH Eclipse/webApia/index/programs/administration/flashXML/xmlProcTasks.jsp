<%@page import="com.dogma.XMLTags"%><%@page import="com.dogma.bean.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.*"%><%@page import="java.util.*"%><%@page import="com.st.util.StringUtil"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.ProcessBean"><%dBean.addMessage(new DogmaException(DogmaException.USR_NOT_LOGGED));%></jsp:useBean><%
if(request.getHeader("User-Agent").indexOf("Firefox")<0){response.setHeader("Pragma","public no-cache");}else{	response.setHeader("Pragma","no-cache");}
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");
response.setContentType("text/xml");

Collection tasks=dBean.getProcTasks(request);

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
	out.print(dBean.getMessagesAsXml(request));
	dBean.clearMessages();
}
%>