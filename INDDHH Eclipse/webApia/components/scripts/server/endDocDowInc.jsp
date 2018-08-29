<%@page import="com.dogma.DogmaException"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="com.dogma.vo.ErrMessageVo"%><%@page import="com.st.util.StringUtil"%><%@page import="java.util.*"%><%     

	DogmaAbstractBean tmpBean = null;
	StringBuffer buffer = new StringBuffer();
	if (session.getAttribute("dBean") != null) {
		buffer.append(((DogmaAbstractBean) session.getAttribute("dBean")).getMessagesAsHTML(request,"d"));
		if (tmpBean == null) {
			tmpBean = (DogmaAbstractBean) session.getAttribute("dBean");
		}
	}

	tmpBean.clearUserMessages(request);
	
	if (buffer.length() > 0) {
		out.print("<TEXTAREA id='errorText' style='display:none'>"+ tmpBean.fmtHTML(buffer.toString()) + "</TEXTAREA>");
		
	}	
%>