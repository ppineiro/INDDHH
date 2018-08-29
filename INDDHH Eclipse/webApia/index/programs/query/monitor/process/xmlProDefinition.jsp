<%@page import="com.dogma.XMLTags"%><%@page import="com.dogma.bean.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.*"%><%@page import="java.util.*"%><%@page import="com.st.util.StringUtil"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.query.MonitorProcessesBean"><%dBean.addMessage(new DogmaException(DogmaException.USR_NOT_LOGGED));%></jsp:useBean><%
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");
Collection tasks = null;

if (!dBean.hasMessages()) {
	out.clear();
	try {
	    boolean debug = request.getParameter("debug") != null;
	    boolean shuffle = request.getParameter("btnReOrder") != null;;
	    boolean order = request.getParameter("btnOrder") != null || request.getParameter("btnReOrder") != null;
		String x = dBean.getProInstXML(dBean.getEnvironmentId(), dBean.getProInstId(), dBean.getUserData(request).getStrLabelSetId(),dBean.getProInstTasks(), dBean.isVisMonOrder(), dBean.isVisMonShuffle(), dBean.isVisMonDebug());
		out.print(x);
 		System.out.println(x);		
	} catch (Exception e) {
		e.printStackTrace();
	}
} else {
	out.print(dBean.getMessagesAsXml(request));
	dBean.clearMessages();
}
%>