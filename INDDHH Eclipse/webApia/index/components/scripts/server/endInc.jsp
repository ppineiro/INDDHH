<%@page import="com.dogma.DogmaException"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="com.dogma.vo.ErrMessageVo"%><%@page import="com.st.util.StringUtil"%><%@page import="java.util.*"%><%     

	DogmaAbstractBean tmpBean = null;
	StringBuffer buffer = new StringBuffer();
	if (session.getAttribute("dBean") != null) {
		buffer.append(((DogmaAbstractBean) session.getAttribute("dBean")).getMessagesAsHTML(request,"d"));
		if (tmpBean == null) {
			tmpBean = (DogmaAbstractBean) session.getAttribute("dBean");
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
	
	if (tmpBean!=null && tmpBean.getUserMessages(request) != null && tmpBean.getUserMessages(request).size() != 0) {		
		buffer.append("<BR>");
		Iterator it = tmpBean.getUserMessages(request).iterator();
		while(it.hasNext()){
			buffer.append("<BR>" + (String)it.next());
		}
		
		tmpBean.clearUserMessages(request);
	}
	
	if (buffer.length() > 0) {
		out.print("<DIV style='position:relative;overflow:hidden;width:0px;height:0px'><TEXTAREA id='errorText'>"+ tmpBean.fmtHTML(buffer.toString()) + "</TEXTAREA></DIV>");
		out.print("<SCRIPT language='javascript' defer='true'>");
 		out.print("if (document.addEventListener) {    document.addEventListener('DOMContentLoaded', fnStartDocInit, false);}else{window.document.onreadystatechange=fnStartDocInit;}");
		%>function fnStartDocInit(){
			if (document.readyState=='complete' || (!MSIE)){
				try {  
					var win=window;
					while(!win.document.getElementById('iframeMessages') && win!=win.parent){
						win=win.parent;
					}
 					if (win.document.getElementById('iframeMessages')) {
						win.document.getElementById('iframeMessages').showMessage(document.getElementById("errorText").value, document.body);
					}else{
						str = document.getElementById("errorText").value;
						if (str.indexOf("</PRE>") != null) {
							str = str.substring(5,str.indexOf("</PRE>"));
						}
						alert(str);
					}
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