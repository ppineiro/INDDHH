<%@page import="com.dogma.vo.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body onload="tryReload()"><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.LanguageBean"></jsp:useBean><%
LanguageVo langVo = dBean.getLanguageVo();
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titLen")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatLen")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td><select name="selLangId" id="selLangId"><%
						Collection languages = dBean.getEnvLanguages(request);
						if (languages != null) {
							LanguageVo lang = null;
							Iterator iterator = languages.iterator();
							while (iterator.hasNext()) {
								lang = (LanguageVo) iterator.next(); %><option value="<%= lang.getLangId() %>" <%= lang.getLangId().equals(uData.getLangId())?"selected":"" %>><%= dBean.fmtHTML(lang.getLangName())%></option><%
							}
						} %></select></td><td></td><td></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript">
var RELOAD_LANGUAGE = <%= dBean.isReloadLanguage() %>;
<% dBean.setReloadLanguage(false); %>

function tryReload(){
	if (RELOAD_LANGUAGE && windowId=="") {
		//window.parent.frames[0].window.location = "FramesAction.do?action=top"; //header
		//
		window.parent.frames[2].window.location.reload(); //menu
		setTimeout(function(){window.parent.frames[2].window.sizeToc();splash();},1000);
		
		//window.parent.frames[3].window.location.reload(); //result
		//window.parent.frames[4].window.location.reload(); //hidden frame
	}else if (RELOAD_LANGUAGE && windowId!=""){
		window.parent.logout();
	}
}

</script><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/security/languages/change.js'></script>

