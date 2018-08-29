<%@page import="com.dogma.DogmaException"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="com.dogma.vo.ErrMessageVo"%><%@page import="com.st.util.StringUtil"%><%@page import="java.util.*"%><%
	} catch (Exception e) {
		if (session.getAttribute("dBean") != null) {
			DogmaAbstractBean tmpBean;
			tmpBean= (DogmaAbstractBean) session.getAttribute("dBean");
			tmpBean.addMessage(new DogmaException(e));
		}
	}
%><!-- frmtargetend --><script>
	function submitTargetForm() {
		window.parent.document.getElementById("iframeMessages").showResultFrame(window.parent.document.getElementById("iframeResult").getBody());
		window.parent.document.getElementById("iframeResult").hideResultFrame();
		document.getElementById("frmMain").action=document.getElementById("frmMain").action+windowId
		document.getElementById("frmMain").submit();
	}
</script><%  
	int intErrors = 0;
	String errMessage = null;

	DogmaAbstractBean tmpBean = null;
	StringBuffer buffer = new StringBuffer();
	
	if (session.getAttribute("dBean") != null) {
		buffer.append(((DogmaAbstractBean) session.getAttribute("dBean")).getMessagesAsHTML(request,"qi"));
		if (tmpBean == null) {
			tmpBean = (DogmaAbstractBean) session.getAttribute("dBean");
		}
		tmpBean.clearMessages();
	}	

	out.print("<TEXTAREA id=errorText style='display:none'>"+ tmpBean.fmtHTML(buffer.toString()) + "</TEXTAREA>");
	out.print("<SCRIPT language=javascript>\n");
	out.print("if (document.addEventListener) {\n document.addEventListener('DOMContentLoaded', fnStartDocInit, false);}\n");
	out.print("else { \n window.document.onreadystatechange=fnStartDocInit;  }\n");
	
	if (buffer.length() > 0) {
		
		%>function fnStartDocInit(){
			if (document.readyState=='complete' || (window.navigator.appVersion.indexOf("MSIE")<0)){
					try {
						var win=window;
						while(!win.document.getElementById('iframeMessages') && win!=win.parent){
							win=win.parent;
						}
						win.document.getElementById("iframeResult").hideResultFrame();
						win.document.getElementById("iframeMessages").hideResultFrame();
						var oBody=window.parent.document.getElementById("iframeMessages").getBody();
						var str=document.getElementById("errorText").value;
						win.document.getElementById("iframeMessages").showMessage(str,oBody);
					} catch (e) {
						str = document.getElementById("errorText").value;
						if (str.indexOf("</PRE>") != null) {
							str = str.substring(5,str.indexOf("</PRE>"));
						}
						alert(str);
					}
					try{
						window.parent.hideWaitCursor()
					}catch(e){}
				}
			}<%
		out.print("</SCRIPT>");
	}	else {
		%>
		function fnStartDocInit(){
			  window.parent.document.getElementById("iframeMessages").hideResultFrame();
			  window.parent.document.getElementById("iframeResult").showResultFrame(window.parent.document.getElementById("iframeMessages").getBody());
				if (autoClose && autoClose == "true") {
					if (closeWindow == "true") {
						window.parent.document.getElementById("iframeMessages").showResultFrame(window.parent.document.getElementById("iframeMessages").getBody());
						window.parent.document.getElementById(window.name).submitWindow.location.href="<%=Parameters.ROOT_PATH%>" + nextUrl;
					}
					try{
						window.parent.document.getElementById("iframeResult").hideResultFrame();
					}catch(e){
					}
				}
				try{
					window.parent.hideWaitCursor()
				}catch(e){}
		  }
		  
		<% 
		out.print("</SCRIPT>");			
	}
%>