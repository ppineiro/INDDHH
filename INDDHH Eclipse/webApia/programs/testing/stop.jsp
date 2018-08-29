<%@page import="java.util.*"%><%@page import="com.dogma.*"%><%@page import="com.dogma.vo.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD>Configuración Testing</TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><table border=0 align="center" valign="middle" class="tblFormLayout"><thead><tr><td>Opciones para finalizar testing</td></tr></thead><tbody><tr><td><input type="radio" name="chkSel" value="1" onclick="setVal(this)">Grabando Base<br><input type="radio" name="chkSel" value="2" onclick="setVal(this)" checked >Sin Grabar Base<br><input type="hidden" name="hidChkVal" value="2"></td></tr></tbody></table></form><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></HTML><%@include file="../../components/scripts/server/endInc.jsp" %><SCRIPT LANGUAGE=javascript>
function setVal(chk){
	if(chk.checked){
	document.getElementById("frmMain").hidChkVal.value = chk.value;
	}
	
}

function btnConf_click(){
	window.returnValue=document.getElementById("frmMain").hidChkVal.value;
	window.close();
}
function btnExit_click(){
	window.returnValue=null;
	window.close();
}

</SCRIPT>
