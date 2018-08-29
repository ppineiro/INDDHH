<%@page import="com.dogma.XMLTags"%><%@page import="com.dogma.bean.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.*"%><%@page import="java.util.*"%><%@page import="com.st.util.StringUtil"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.action.monitor.ProcessesAction"%><%@page import="biz.statum.apia.web.bean.monitor.ProcessesBean"%><%@page import="com.dogma.UserData"%><%
HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
ProcessesBean dBean= ProcessesAction.staticRetrieveBean(http);
UserData userData = dBean.getUserData(http);
 
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");
Collection tasks = null;

if (dBean.getMessages().size()==0) {
	out.clear();
	try {
	    boolean debug = request.getParameter("debug") != null;
	    boolean shuffle = request.getParameter("btnReOrder") != null;;
	    boolean order = request.getParameter("btnOrder") != null || request.getParameter("btnReOrder") != null; 
		String x = dBean.getProInstXML(userData.getEnvironmentId(), dBean.getProInstId(), userData.getStrLabelSetId(),dBean.getProInstTasks(), dBean.isVisMonOrder(), dBean.isVisMonShuffle(), dBean.isVisMonDebug());
		out.print(x);
 		System.out.println(x);		
	} catch (Exception e) {
		e.printStackTrace(); 
	}
} else {
	out.print(dBean.getMessages());
	dBean.clearMessages();
}
%>