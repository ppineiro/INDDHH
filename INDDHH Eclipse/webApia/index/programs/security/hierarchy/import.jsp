<%@page import="com.dogma.vo.custom.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.Parameters"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><%@page import="com.st.util.labels.LabelManager"%><html><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><iframe style="display:none" name="ifrTarget" id="ifrTarget" src="" ></iframe><body onload="fnStartDocInit()"><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.GroupHierarchyBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titHierUpl")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form target="ifrTarget" id="frmMain" name="frmMain" method="POST" onSubmit="return false" enctype="multipart/form-data"><div id="loadFromFile"><table class="tblFormLayout"><br><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDelHierarchy")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDelHierarchy")%>:</td><td><input type="checkbox" name="chkDelHierarchy" accessKey="<%=LabelManager.getAccessKey(labelSet,"lblDelHierarchy")%>" checked></td></td></tr><br><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblHierFile")%>"><%=LabelManager.getNameWAccess(labelSet,"lblHierFile")%>:</td><td colspan="3"><input type="FILE" p_required="true" length="150" name="txtUpload" size="70" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDicDat")%>" title="<%=LabelManager.getToolTip(labelSet,"lblBrowse")%>"></td></tr></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><TR><TD align="right"><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><% StringBuffer buffer = new StringBuffer();
	Collection messages = dBean.getMessages();
	buffer.append(dBean.getMessagesAsHTML(request,"d"));
	out.print("<TEXTAREA id='errorText' style='display:none'>"+ dBean.fmtHTML(buffer.toString()) + "</TEXTAREA>");
	out.print("<SCRIPT language='javascript' defer='true'>");
	%>function fnStartDocInit(){
			var win=window;
			while(!win.document.getElementById("iframeMessages")){
				win=win.parent;
			}
			win.document.getElementById("iframeMessages").hideResultFrame();
			
			try {
				var win=window;
				while(!win.document.getElementById('iframeMessages') && win!=win.parent){
					win=win.parent;
				}
				if(document.getElementById("errorText").value != null && document.getElementById("errorText").value != ""){
					win.document.getElementById('iframeMessages').showMessage(document.getElementById("errorText").value, document.body);
				}
			} catch (e) {
				var str = document.getElementById("errorText").value;
				if (str.indexOf("</PRE>") != null) {
					str = str.substring(5,str.indexOf("</PRE>"));
				}
				alert(str);
			}			
			<%if("true".equals(request.getParameter("close"))){%>
				//window.parent.btnExit_click(true);
				btnExit_click(true);
			<%}%>
		}<%
	out.print("</SCRIPT>");%><script>
function btnExit_click(afterConfirm) {
	window.returnValue=afterConfirm;
	window.close();
}

function btnConf_click() {
document.getElementById("frmMain").target="_self";
	document.getElementById("frmMain").action = "security.GroupHierarchyAction.do?action=doUpload&deleteActual=" + document.getElementById("chkDelHierarchy").checked;
	submitForm(document.getElementById("frmMain"));
}	

</script>