<%@page import="com.dogma.XMLTags"%><%@page import="com.dogma.bean.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.*"%><%@page import="java.util.*"%><%@page import="com.st.util.StringUtil"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.ProcessBean"><%dBean.addMessage(new DogmaException(DogmaException.USR_NOT_LOGGED));%></jsp:useBean><%
if(request.getHeader("User-Agent").indexOf("Firefox")<0){response.setHeader("Pragma","public no-cache");}else{	response.setHeader("Pragma","no-cache");}
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");
response.setContentType("text/xml");

Collection schedulers=dBean.getTaskSchedulers(request);

if (!dBean.hasMessages()) {
	String schedulersXML="<?xml version=\"1.0\" encoding=\"UTF-8\"?><ROWSET><TYPE id=\"M\"  name=\"Manual\" />";
	if(schedulers!=null){
		Iterator it=schedulers.iterator();
		while(it.hasNext()){
			TaskSchedulerVo ts=(TaskSchedulerVo)it.next();
			schedulersXML+="<CALENDAR id=\""+ts.getTskSchId()+"\"  name=\""+ts.getTskSchName()+"\"  />";
		}
	}
	schedulersXML+="</ROWSET>";
	out.clear();
	out.print(schedulersXML);
} else {
	out.print(dBean.getMessagesAsXml(request));
	dBean.clearMessages();
}
%>