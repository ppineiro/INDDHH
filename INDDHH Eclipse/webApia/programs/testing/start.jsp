<%@page import="java.util.*"%><%@page import="com.dogma.*"%><%@page import="com.dogma.vo.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><jsp:useBean id="bTest"  
			 class="com.dogma.testing.web.controller.TestBean"      
			 scope="session"/><%String optionBean = pageContext.getServletContext().getInitParameter("optionBean"); %><%String optionDate = pageContext.getServletContext().getInitParameter("optionDate"); %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD>Configuración Testing</TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><DIV class="subTit">Opciones para grabar BD</DIV><table border=0 align="center" valign="middle" class="tblFormLayout"><tr><td colspan="4"><input type="hidden" id="hidChkSel" value="0"><input type="radio" name="chkSel" value="<%=bTest.MODE_SAVE_XML_ALONE%>" onclick="setSel(this)">Crear - Solo crea xml.<br></td></tr><tr style="display:none"><td colspan="4"><input type="radio" name="chkSel" value="<%=bTest.MODE_SAVE_XML_SAVE%>" onclick="setSel(this)">Grabar BD - Backup de Base actual y crea xml para que realice Restore de base actual.<br></td></tr><tr style="display:none"><td colspan="3"><input type="radio" name="chkSel" value="<%=bTest.MODE_SAVE_XML_CUSTOM%>" onclick="setSel(this)">Custom - Restore del device ingresado y crea xml para que realice la misma acción.<br></td><td><input type="text" name="txtDevice" value=""></td></tr><tr><td colspan="2"><input type="radio" name="chkSel" value="<%=bTest.MODE_SAVE_XML_CONTINUE%>" onclick="setSel(this)">Continuar Test - Se continua con el último xml.<br></td><td colspan="2"><select name="txtFileName" id="txtFileName"><%Collection col = bTest.getAllReqFile();
   						if (col != null) {
	   						Iterator it = col.iterator();
	   						String fileName = null;
	   						while (it.hasNext()) {
	   						 	fileName = bTest.fmtStr((String) it.next()); 
	   						 	%><option value="<%=fileName%>"><%=fileName%></option><%	
		   					}
		   				}%></select></td></tr></table><DIV class="subTit" style="visibility:hidden">Opciones para grabar Session</DIV><table border=0 style="visibility:hidden" align="center" valign="middle" class="tblFormLayout"><tbody><tr><td align="left"><input type="radio" name="chkSession" value="<%=bTest.MODE_SAVE_BEAN_CUSTOM%>" onclick="setSession(this)">Objetos - Custom<br><input type="hidden" id="hidChkSession" value="0"></td><td><input type="text" name="txtObjCustom" value="<%=optionBean%>"></td><td align="left"><input type="radio" name="chkDate" value="<%=bTest.MODE_SAVE_DATE_CUSTOM%>" onclick="setDate(this)">Fecha - Custom<br><input type="hidden" id="hidChkDate" value="0"></td><td><input type="text" name="txtDateCustom" value="<%=optionDate%>"></td></tr><tr><td colspan=2 align="left"><input type="radio" name="chkSession" value="<%=bTest.MODE_SAVE_BEAN_ALL%>" onclick="setSession(this)">Objetos - Todos<br></td><td  align="left"><input type="radio" name="chkDate" value="<%=bTest.MODE_SAVE_DATE_NO%>" onclick="setDate(this)">Fecha - Ninguna<br></td></tr><tr><td colspan=2 align="left"></td><td  align="left"><input type="radio" name="chkDate" value="<%=bTest.MODE_SAVE_DATE_ALL%>" onclick="setDate(this)">Fecha - Todas<br></td></tr></tbody></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></HTML><%@include file="../../components/scripts/server/endInc.jsp" %><SCRIPT LANGUAGE=javascript>
window.onload=function(){
	document.getElementById(chkSel[0]).checked = true;
	setSel(document.getElementById(chkSel[0]));
	
	document.getElementById(chkSession[0]).checked = true;
	setSession(document.getElementById(chkSession[0]));
	
	document.getElementById(chkDate[0]).checked = true;
	setDate(document.getElementById(chkDate[0]));
}

function setDate(chk){
	if(chk.checked){
	document.getElementById("frmMain").hidChkDate.value = chk.value;
	}	
}
function setSession(chk){
	if(chk.checked){
	document.getElementById("frmMain").hidChkSession.value = chk.value;
	}	
}
function setSel(rad){
	if(rad.checked){
	document.getElementById("frmMain").hidChkSel.value = rad.value;
	}	
}

function btnConf_click(){

	var result = new Array();
	result[0] = document.getElementById("frmMain").hidChkSel.value;
	result[1] = document.getElementById("frmMain").hidChkSession.value;
	result[2] = document.getElementById("frmMain").hidChkDate.value;
	result[3] = document.getElementById("frmMain").txtDevice.value;
	result[4] = document.getElementById("frmMain").txtObjCustom.value;
	result[5] = document.getElementById("frmMain").txtDateCustom.value;
	result[6] = document.getElementById("frmMain").txtFileName.value;
	window.returnValue=result;
	window.close();
}
function btnExit_click(){
	window.returnValue=null;
	window.close();
}

</SCRIPT>
