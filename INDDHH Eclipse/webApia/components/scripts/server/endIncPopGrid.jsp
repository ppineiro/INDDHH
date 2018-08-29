<%@page import="com.dogma.DogmaException"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="com.dogma.vo.ErrMessageVo"%><%@page import="com.st.util.StringUtil"%><%@page import="java.util.*"%><%     

	DogmaAbstractBean tmpBean = null;
	StringBuffer buffer = new StringBuffer();
	if (session.getAttribute("dBean") != null) {
		buffer.append(((DogmaAbstractBean) session.getAttribute("dBean")).getMessagesAsHTML(request,"d"));
		if (tmpBean == null) {
			tmpBean = (DogmaAbstractBean) session.getAttribute("dBean");
		}
	}
	
	


	if (session.getAttribute("xBean") != null) {
		buffer.append(((DogmaAbstractBean) session.getAttribute("xBean")).getMessagesAsHTML(request,"x"));
		if (tmpBean == null) {
			tmpBean = (DogmaAbstractBean) session.getAttribute("xBean");
		}
	}

	if (session.getAttribute("gBean") != null) {
		buffer.append(((DogmaAbstractBean) session.getAttribute("gBean")).getMessagesAsHTML(request,"g"));
		if (tmpBean == null) {
			tmpBean = (DogmaAbstractBean) session.getAttribute("gBean");
		}
	}

	if (session.getAttribute("dBeanModal") != null) {
		buffer.append(((DogmaAbstractBean) session.getAttribute("dBeanModal")).getMessagesAsHTML(request,"m"));
		if (tmpBean == null) {
			tmpBean = (DogmaAbstractBean) session.getAttribute("dBeanModal");
		}
	}

	if (session.getAttribute("qBean") != null) {
		buffer.append(((DogmaAbstractBean) session.getAttribute("qBean")).getMessagesAsHTML(request,"q"));
		if (tmpBean == null) {
			tmpBean = (DogmaAbstractBean) session.getAttribute("qBean");
		}
	}

	if (session.getAttribute("lBeanReady") != null) {
		buffer.append(((DogmaAbstractBean) session.getAttribute("lBeanReady")).getMessagesAsHTML(request,"lr"));
		if (tmpBean == null) {
			tmpBean = (DogmaAbstractBean) session.getAttribute("lBeanReady");
		}
	}
	if (session.getAttribute("lBeanInproc") != null) {
		buffer.append(((DogmaAbstractBean) session.getAttribute("lBeanInproc")).getMessagesAsHTML(request,"li"));
		if (tmpBean == null) {
			tmpBean = (DogmaAbstractBean) session.getAttribute("lBeanInproc");
		}
	}


	if (session.getAttribute("qBeanReady") != null) {
		buffer.append(((DogmaAbstractBean) session.getAttribute("qBeanReady")).getMessagesAsHTML(request,"qr"));
		if (tmpBean == null) {
			tmpBean = (DogmaAbstractBean) session.getAttribute("qBeanReady");
		}
	}
	if (session.getAttribute("qBeanInproc") != null) {
		buffer.append(((DogmaAbstractBean) session.getAttribute("qBeanInproc")).getMessagesAsHTML(request,"qi"));
		if (tmpBean == null) {
			tmpBean = (DogmaAbstractBean) session.getAttribute("qBeanInproc");
		}
	}
System.out.println("-----------------"+buffer);
	if (buffer.length() > 0) {
		out.print("<TEXTAREA id=errorText style='display:none'>"+ tmpBean.fmtHTML(buffer.toString()) + "</TEXTAREA>");
		out.print("<SCRIPT language=javascript>");
		out.print("if (document.addEventListener) {    document.addEventListener('DOMContentLoaded', fnStartDocInit, false);}");
		out.print("else{window.document.onreadystatechange=fnStartDocInit;}");
		%>function fnStartDocInit(){
			if (document.readyState=='complete' || !MSIE){
					try {  
						var win=window;
						while(!win.document.getElementById('iframeMessages') && win!=win.parent){
							win=win.parent;
						}
						win.document.getElementById("iframeMessages").showMessage(document.getElementById("errorText").value, document.body);
					} catch (e) {
						str = document.getElementById("errorText").value;
						if (str.indexOf("</PRE>") != null) {
							str = str.substring(5,str.indexOf("</PRE>"));
						}
						alert(str);
					}
				}
			}<%
		out.print("</SCRIPT>");
	}	
%>