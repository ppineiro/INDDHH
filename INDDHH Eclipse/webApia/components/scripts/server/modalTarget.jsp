<%@page import="com.dogma.DogmaException"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="com.dogma.vo.ErrMessageVo"%><%@page import="com.st.util.StringUtil"%><%@page import="java.util.*"%><%@include file="startInc.jsp" %><script language=javascript>
try {
	window.parent.document.document.getElementById("iframeMessages").hideResultFrame()
} catch (e) {}
	
</script><%  
	int intErrors = 0;
	String errMessage = null;
	if (session.getAttribute("dBean") != null) {
		DogmaAbstractBean tmpBean;
		tmpBean= (DogmaAbstractBean) session.getAttribute("dBean");
		String strMessageShow = "";
		if ((tmpBean.getMessages() != null) && (tmpBean.getMessages().size() > 0)) {
			strMessageShow = "<PRE>";
			Iterator it = tmpBean.getMessages().iterator();
			if (tmpBean.getMessages().size() == 1){
				if (it.hasNext()){
					ErrMessageVo errMsg = (ErrMessageVo) it.next();
					String strAux = LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),errMsg.getMsg());
					strMessageShow += StringUtil.parseMessage(strAux,errMsg.getParams());
				}
			} else{
				while(it.hasNext()){
					ErrMessageVo errMsg = (ErrMessageVo) it.next();
					String strAux = LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),errMsg.getMsg());
					strMessageShow += "(*) " + StringUtil.parseMessage(strAux,errMsg.getParams()) + "\n";
				}
			}
			strMessageShow += "</PRE>";
		} 
		if (tmpBean.getDogmaException() != null) {
			strMessageShow += "<BR><B><A href='#nowhere' onclick=\"document.getElementById('excStack').style.display='block'\">Exception Info</a></b><BR><div id='excStack' style='display:none'><PRE>" + tmpBean.getDogmaException().getCompleteStackTrace() + "</PRE></div>";
			com.dogma.bean.DogmaAbstractBean.logError(request, tmpBean.getDogmaException().getCompleteStackTrace());
		}

		tmpBean.clearMessages();	

			out.print("<TEXTAREA id=errorText style='display:none'>"+ strMessageShow + "</TEXTAREA>");
			out.print("<SCRIPT language=javascript>");
			out.print("if (document.addEventListener) {    document.addEventListener('DOMContentLoaded', fnStartDocInit, false);}");
			out.print("else{window.document.onreadystatechange=fnStartDocInit;}");
			%>function fnStartDocInit(){
				if (document.readyState=='complete' || (window.navigator.appVersion.indexOf("MSIE")<0)){
					<%if (!strMessageShow.equals("")) {%>
						try {
							var win=window;
							while(!win.document.getElementById('iframeMessages') && win!=win.parent){
							win=win.parent;
							}
							win.document.getElementById('iframeMessages').showMessage(document.getElementById("errorText").value, document.body);
						} catch (e) {
							str = document.getElementById("errorText").value;
							if (str.indexOf("</PRE>") != null) {
								str = str.substring(5,str.indexOf("</PRE>"));
							}
							alert(str);
						}
					window.parent.submitError();
					<%} else  {%>
					window.parent.submitOK();
					<%} %>
				}
			}<%
			out.print("</SCRIPT>");
	}
%>