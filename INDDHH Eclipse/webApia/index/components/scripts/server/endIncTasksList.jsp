<%@page import="com.dogma.DogmaException"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="com.dogma.vo.ErrMessageVo"%><%@page import="com.st.util.StringUtil"%><%@page import="java.util.*"%><%     
/*	int intErrors = 0;
	String errMessage = null;
	if (session.getAttribute("lBeanReady") != null || session.getAttribute("lBeanInproc") != null ||
	    session.getAttribute("qBeanReady") != null || session.getAttribute("qBeanInproc") != null) {
		DogmaAbstractBean tmpBean;
		DogmaAbstractBean tmpBean2;
		if (session.getAttribute("lBeanReady") != null || session.getAttribute("lBeanInproc") != null) {
			tmpBean= (DogmaAbstractBean) session.getAttribute("lBeanReady");
			tmpBean2= (DogmaAbstractBean) session.getAttribute("lBeanInproc");
		} else {
			tmpBean= (DogmaAbstractBean) session.getAttribute("qBeanReady");
			tmpBean2= (DogmaAbstractBean) session.getAttribute("qBeanInproc");
		}
		String strMessageShow = "";
		if (tmpBean.getMessages() != null || tmpBean2.getMessages() != null) {
			strMessageShow = "<PRE><TABLE>";
			Iterator it = null;
			if (tmpBean.getMessages() != null){
				it = tmpBean.getMessages().iterator();
			}
			if (tmpBean2.getMessages() != null) {
				it = tmpBean2.getMessages().iterator();
			}
			
			while(it.hasNext()){
				ErrMessageVo errMsg = (ErrMessageVo) it.next();
				String strAux = LabelManager.getName(errMsg.getMsg());
				strMessageShow += "<TR><TD vAlign=top><LI></TD><TD>" + StringUtil.parseMessage(strAux,errMsg.getParams()) + "</TD></TR>";
			}				
			strMessageShow += "</TABLE></PRE>";
		} 
		
		if (tmpBean.getDogmaException() != null) {
			if (tmpBean.getDogmaException().getDirectMessage() != null) {
				strMessageShow += "<PRE><TABLE><TR><TD vAlign=top><LI></TD><TD>" + tmpBean.fmtScriptStr(tmpBean.getDogmaException().getDirectMessage()) + "</TD></TR></TABLE></PRE>";
			} else {
				strMessageShow += "<BR><B><A href='#nowhere' onclick=\"document.getElementById('excStack').style.display='block'\">Exception Info</a></b><BR><div id='excStack' style='display:none'><PRE>" + tmpBean.getDogmaException().getCompleteStackTrace() + "</PRE></div>";
				com.dogma.bean.DogmaAbstractBean.logError(request, tmpBean.getDogmaException().getCompleteStackTrace());
			}
		}

		tmpBean.clearMessages();	
		tmpBean2.clearMessages();

		if (!strMessageShow.equals("")) {
			out.print("<TEXTAREA id=errorText style='display:none'>"+ tmpBean.fmtHTML(strMessageShow) + "</TEXTAREA>");
			out.print("<SCRIPT language=javascript>");
			out.print("if (document.addEventListener) {    document.addEventListener('DOMContentLoaded', fnStartDocInit, false);}");
			out.print("else{window.document.onreadystatechange=fnStartDocInit;}");
			%>function fnStartDocInit(){
				if (document.readyState=='complete' || (window.navigator.appVersion.indexOf("MSIE")<0)){
						try {
							var win=window;
							while(!win.document.getElementById('iframeMessages') && win!=win.parent){
								win=win.parent;
							}
							win.document.getElementById('iframeMessages').showMessage(document.getElementById("errorText").value, document.body);
						} catch (e) {
							str =  document.getElementById("errorText").value;
							if (str.indexOf("</PRE>") != null) {
								str = str.substring(5,str.indexOf("</PRE>"));
							}
							alert(str);
						}
					}
				}<%
			out.print("</SCRIPT>");
		}	
	}*/
	
//-------------------------------------------

	DogmaAbstractBean tmpBean = null;
	StringBuffer buffer = new StringBuffer();
	if (session.getAttribute("dBean") != null) {
		buffer.append(((DogmaAbstractBean) session.getAttribute("dBean")).getMessagesAsHTML(request,"d"));
		if (tmpBean == null) {
			tmpBean = (DogmaAbstractBean) session.getAttribute("dBean");
		}
	}

	if (session.getAttribute("qBean") != null) {
		buffer.append(((DogmaAbstractBean) session.getAttribute("qBean")).getMessagesAsHTML(request,"q"));
		if (tmpBean == null) {
			tmpBean = (DogmaAbstractBean) session.getAttribute("qBean");
		}
	}

	if (session.getAttribute("dBeanModal") != null) {
		buffer.append(((DogmaAbstractBean) session.getAttribute("dBeanModal")).getMessagesAsHTML(request,"m"));
		if (tmpBean == null) {
			tmpBean = (DogmaAbstractBean) session.getAttribute("dBeanModal");
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

	if (buffer.length() > 0) {
		out.print("<TEXTAREA id=errorText style='display:none'>"+ tmpBean.fmtHTML(buffer.toString()) + "</TEXTAREA>");
		out.print("<SCRIPT language=javascript>");
		out.print("if (document.addEventListener) {document.addEventListener('DOMContentLoaded', fnStartDocInit, false);}");
		out.print("else{window.document.onreadystatechange=fnStartDocInit;}");
		%>function fnStartDocInit(){
			if (document.readyState=='complete' || (window.navigator.appVersion.indexOf("MSIE")<0)){
					try {
						window.parent.parent.document.getElementById('iframeMessages').showMessage(document.getElementById("errorText").value, document.body);
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