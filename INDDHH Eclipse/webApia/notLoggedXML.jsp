<%@page import="com.dogma.XMLTags"%><%@page import="com.dogma.bean.*"%><%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@page import="com.st.util.StringUtil"%><%@page import="com.st.util.labels.LabelManager"%><%
out.clear();

out.print(XMLTags.XML_HEAD);
out.print(XMLTags.EXCEPTION_START);
out.print(LabelManager.getName(new Integer(1),new Integer(1),"lblNotLogged"));
out.print(XMLTags.EXCEPTION_END);
%>