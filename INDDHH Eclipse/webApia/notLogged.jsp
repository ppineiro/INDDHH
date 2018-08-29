<%@page import="java.util.*"%><%@include file="components/scripts/server/startInc.jsp" %><HTML><head><%@include file="components/scripts/server/headInclude.jsp" %></head><body <% if (request.getParameter("mdlTarget") != null) {%>style="BORDER:2px groove white;"<%}%> onload="isNotParent()"><div align="center"><table class="usuMsg" border=0 align="center" valign="middle"><thead><tr id="tit_es" style="display:none" align="center"><th><%=LabelManager.getName(Parameters.DEFAULT_LABEL_SET ,new Integer(1),"lblMenUsu")%></th></tr><tr id="tit_pg" style="display:none" align="center"><th><%=LabelManager.getName(Parameters.DEFAULT_LABEL_SET ,new Integer(2),"lblMenUsu")%></th></tr><tr id="tit_en" style="display:none" align="center"><th><%=LabelManager.getName(Parameters.DEFAULT_LABEL_SET ,new Integer(3),"lblMenUsu")%></th></tr></thead><tr id="tr_es" style="display:none;"><td align=center><li><%=	LabelManager.getName(Parameters.DEFAULT_LABEL_SET ,new Integer(1),"lblNotLogged")%></td></tr><tr id="tr_pg" style="display:none;"><td align=center><li><%=	LabelManager.getName(Parameters.DEFAULT_LABEL_SET ,new Integer(2),"lblNotLogged")%></td></tr><tr id="tr_en" style="display:none;"><td align=center><li><%=	LabelManager.getName(Parameters.DEFAULT_LABEL_SET ,new Integer(3),"lblNotLogged")%></td></tr><tr><td align=center><a href="#nowhere" onclick="gotoLogin()">login</a></td></tr><tr id="tr_exit" style="display:none;"><td align="right"><table style="width:100%;"><tr><td style="width:100%;">
	  					&nbsp;
	  				</td><td><button type="button" type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></td></tr></table></td></tr></table></div></body></HTML><% if (request.getParameter("mdlTarget") == null) {%><%@include file="components/scripts/server/endInc.jsp" %><%}%><script language="javascript" defer="true">
var classic=<%=(request.getParameter("classic")!=null)?"true":"false"%>;

function showMsg(){
		try{
			if (window.parent.frames["topFrame"].document.getElementById("hidLang").value == "1"){
				document.getElementById("tit_es").style.display="block";
				document.getElementById("tr_es").style.display="block";
			}else if (window.parent.frames["topFrame"].document.getElementById("hidLang").value == "2") {
				document.getElementById("tit_pg").style.display="block";
				document.getElementById("tr_pg").style.display="block";
			}else if (window.parent.frames["topFrame"].document.getElementById("hidLang").value == "3") {
				document.getElementById("tit_en").style.display="block";
				document.getElementById("tr_en").style.display="block";
			}
		}catch(e){
				document.getElementById("tit_es").style.display="block";
				document.getElementById("tr_es").style.display="block";
		}
		try{
			if(window.name.indexOf("modal")>=0){
				document.getElementById("tr_exit").style.display="block";
			}
		}catch(e){}
}
if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", showMsg, false);
}else{
	showMsg();
}

<% if (request.getParameter("mdlTarget") != null) {%>
	window.parent.document.getElementById("iframeMessages").hideResulFrame();
    window.parent.documentdocument.getElementById("iframeResult").showResultFrame(window.parent.document.getElementById("iframeMessages").getBody());
<%}%>

function gotoLogin(){
	var isDesk = isApiaDesk();
	
	if(window.dialogWidth == undefined){
		if(parent.window.location.href == parent.parent.window.location.href){
			if(isDesk && !classic){
				parent.window.location.href = "<%=com.dogma.Parameters.ROOT_PATH%>/programs/ApiaDesk/deskLogin.jsp";
			} else {
				parent.window.location.href = "<%=com.dogma.Parameters.ROOT_PATH%>/programs/login/login.jsp";
			}
		} else {
			if(isDesk && !classic){
				parent.parent.window.location.href = "<%=com.dogma.Parameters.ROOT_PATH%>/programs/ApiaDesk/deskLogin.jsp";
			} else {
				parent.parent.window.location.href = "<%=com.dogma.Parameters.ROOT_PATH%>/programs/login/login.jsp";
			}
		}	
	}
}

function isNotParent(){
	if(window.name=="workArea" || window.name=="iframeResult"){
		window.parent.location.href="<%=com.dogma.Parameters.ROOT_PATH%>/notLogged.jsp?classic=true";
	}
}

function btnExit_click(){
	gotoLogin();
}
</script>