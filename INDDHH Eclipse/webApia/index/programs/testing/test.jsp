<%@page import="java.util.*"%><%@page import="com.dogma.*"%><%@page import="com.dogma.vo.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><% 
	String ignoreList = pageContext.getServletContext().getInitParameter("ignoreFields"); 
	if (ignoreList == null) {
		ignoreList = "";
	}
%><jsp:useBean id="bTest"  
			 class="com.dogma.testing.web.controller.TestBean"      
			 scope="session"/><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD>Configuración Testing</TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><table border=0 align="center" valign="middle" class="tblFormLayout"><thead><tr><td>Opciones para ejecutar testing</td></tr></thead><tbody><tr><td title="Último Archivo">Seleccione Archivo XML:</td><td><select name="txtFileName" id="txtFileName"><% 
								Collection col = bTest.getAllReqFile();
		   						if (col != null) {
			   						Iterator it = col.iterator();
	   								String fileName = null;
	   								while (it.hasNext()) {
	   								 	fileName = bTest.fmtStr((String) it.next()); 
   						 	%><option value="<%=fileName%>"><%=fileName%></option><%	
				   					}
		   						}
							%></select></td></tr><tr><td title="Campos a ignorar (CSV)">Lista de campos a ignorar:</td><td><input type="text" name="txtIgnoreList" value="<%=ignoreList%>"></td></tr><tr><td><input type="radio" name="chkSel" value="1" onclick="setVal(this)">Excluir Errores<br><input type="radio" name="chkSel" value="2" onclick="setVal(this)" checked >Total<br><input type="hidden" name="hidChkVal" value="2"></td></tr></tbody></table></form><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></HTML><%@include file="../../components/scripts/server/endInc.jsp" %><SCRIPT LANGUAGE=javascript>
	function setVal(chk){
		if(chk.checked){
			document.getElementById("frmMain").hidChkVal.value = chk.value;
		}
	}

	function btnConf_click(){
		var result = new Array();
		var fileName = document.getElementById("txtFileName").value;	
		var ignrList = document.getElementById("txtIgnoreList").value;	
		if (fileName==null || fileName==""){
			result[0] = "";
			result[1] = "";
		} else {
			result[0] = fileName;
			result[1] = ignrList;
		}	
		result[2] = document.getElementById("frmMain").hidChkVal.value;
		window.returnValue=result;
		window.close();
	}

	function btnExit_click(){
		window.returnValue=null;
		window.close();
	}
</SCRIPT>
