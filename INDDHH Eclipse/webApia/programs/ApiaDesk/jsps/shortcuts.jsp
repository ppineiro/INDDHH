<%@page import="com.dogma.*"%><%@page import="com.st.util.*"%><%@page import="com.st.util.labels.*"%><%@page import="com.dogma.*"%><%
Integer labelSet = Parameters.DEFAULT_LABEL_SET;
Integer langId = Parameters.DEFAULT_LANG;
if (request.getParameter("langId") != null && !"null".equals(request.getParameter("langId"))) {
	langId = new Integer(request.getParameter("langId"));
}
response.setContentType("text/xml");

StringBuffer sb=new StringBuffer();
sb.append("<?xml version=\"1.0\" encoding=\"iso-8859-1\"?><shortcuts>");
sb.append("<shortcut img=\"styles/classic/images/desk_icon.png\" text=\""+LabelManager.getName(labelSet,langId,"lblShowDesk")+"\" dblclick=\"winMinimizeAll()\" />");
sb.append("<shortcut img=\"styles/classic/images/envelope_icon.png\" text=\""+LabelManager.getName(labelSet,langId,"lblMessages")+"\" action=\"openMessages()\" onload=\"startMessenger()\" dblclick=\"messenger.openInbox()\" js=\"messenger.js\"><menu><menuItem text=\""+LabelManager.getName(labelSet,langId,"lblOpenInbox")+"\" calledFunction=\"messenger.openInbox()\" /><menuItem text=\""+LabelManager.getName(labelSet,langId,"lblCheckIn")+"\""+" calledFunction=\"\"><menuItem text=\" 5 "+LabelManager.getName(labelSet,langId,"lblTimeMin")+"\" calledFunction=\"messenger.setRefreshRate(600)\" /><menuItem text=\"10  "+LabelManager.getName(labelSet,langId,"lblTimeMin")+"\" calledFunction=\"messenger.setRefreshRate(10)\" /><menuItem text=\"30  "+LabelManager.getName(labelSet,langId,"lblTimeMin")+"\" calledFunction=\"messenger.setRefreshRate(15)\" /></menuItem></menu></shortcut>");
sb.append("<shortcut img=\"styles/classic/images/postit_icon.png\" text=\""+LabelManager.getName(labelSet,langId,"lblPostits")+"\" action=\"openMessages()\" dblclick=\"addPostit()\" js=\"postIts.js\"><menu><menuItem text=\""+LabelManager.getName(labelSet,langId,"lblNewPostit")+"\" calledFunction=\"addPostit()\" /><menuItem text=\""+LabelManager.getName(labelSet,langId,"lblHidePostits")+"\" calledFunction=\"hidePostits()\" /><menuItem text=\""+LabelManager.getName(labelSet,langId,"lblShowPostits")+"\" calledFunction=\"showPostits()\" /><menuItem text=\""+LabelManager.getName(labelSet,langId,"lblPostitsToBack")+"\" calledFunction=\"postitsToBack()\" /><menuItem text=\""+LabelManager.getName(labelSet,langId,"lblSort")+":\" calledFunction=\"\"><menuItem text=\""+LabelManager.getName(labelSet,langId,"lblSortCascade")+"\" calledFunction=\"sortPostits('cascade')\" /><menuItem text=\""+LabelManager.getName(labelSet,langId,"lblSortHorizontal")+"\" calledFunction=\"sortPostits('hotizontally')\" /></menuItem></menu></shortcut>");
if(Parameters.APIACHAT_MODE_CLIENT){
	sb.append("<shortcut img=\"styles/classic/images/apiaCommLogoD.png\" text=\""+LabelManager.getName(labelSet,langId,"lblApiaComm")+"\" action=\"openMessages()\" onload=\"setApiaComm(this.parentNode)\" dblclick=\"this.parentNode.openComm()\" js=\"apiaCommunicator/ApiaComm.js\"><menu><menuItem text=\""+LabelManager.getName(labelSet,langId,"lblConnect")+"\" calledFunction=\"reconnectComm()\" /></menu></shortcut>");
}
sb.append("</shortcuts>");
out.clear();
out.print(sb.toString());
%>