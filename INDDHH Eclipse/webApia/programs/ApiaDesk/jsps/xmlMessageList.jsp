<%@page import="com.st.util.*"%><%@page import="java.util.*"%><%@page import="com.dogma.bean.security.*"%><%@page import="com.dogma.vo.*"%><jsp:useBean id="messagesBean" scope="session" class="com.dogma.bean.security.MessageBean"></jsp:useBean><jsp:useBean id="notificationsBean" scope="session" class="com.dogma.bean.execution.NotificationBean"></jsp:useBean><%
StringBuffer xml=new StringBuffer();
Collection colMessages = messagesBean.getUserMessagesFromBean(request);
Collection colNotifications = notificationsBean.getUserNotifications(request);
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1);
response.setContentType( "application/xml" );
xml.append("<?xml version=\"1.0\" encoding=\"utf-8\"?><messages>");
if("true".equals(request.getParameter("checkCant"))){
	int mSize=0;
	int nSize=0;
	if(colMessages!=null){
		mSize=colMessages.size();
	}
	if(colNotifications!=null){
		nSize=colNotifications.size();
	}
	xml.append("<cant>"+(mSize+nSize)+"</cant>");
}else{
	if(colMessages!=null){
		Iterator itM = colMessages.iterator();
		while (itM.hasNext()) {
			String str = (String)itM.next();
			xml.append("<message text=\""+StringUtil.escapeHTML(StringUtil.escapeStr(str))+"\" type=\"message\" title=\"mensaje 1\" />");
		}
	}
	if(colNotifications!=null){
		Iterator itN = colNotifications.iterator();
		while (itN.hasNext()) {
			NotificationVo notVo = (NotificationVo) itN.next();
			xml.append("<message id=\""+notVo.getNotId()+"\" text=\""+messagesBean.fmtStr(StringUtil.escapeStr(notVo.getNotMessage()))+"\" type=\"notification\" title=\"mensaje 1\" />");
		}
	}
}
xml.append("</messages>");
out.clear();
out.print(xml.toString());
%>