<%@page import="java.util.*"%><%@page import="com.dogma.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><jsp:useBean id="bTest"  
			 class="com.dogma.testing.web.controller.TestBean"      
			 scope="session"/><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD>Visualizacion de diferencias</TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false" ><table border=0 align="center" valign="middle" class="tblFormLayout"><thead><tr><td>&nbsp</td></tr></thead><tbody><tr><td title="Último Archivo">Seleccione Archivo XML de log:</td><td><select name="txtFileName" id="txtFileName"><%Collection col = bTest.getAllLogFile();
   						if (col != null) {
	   						Iterator it = col.iterator();
	   						String fileName = null;
	   						while (it.hasNext()) {
	   						 	fileName = bTest.fmtStr((String) it.next()); 
	   						 	%><option value="<%=fileName%>"><%=fileName%></option><%	
		   					}
		   				}%></select></td></tr></tbody></TABLE></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD align="left"><button type="button" onclick="btnSearch_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnBus")%>" title="<%=LabelManager.getToolTip(labelSet,"btnBus")%>"><%=LabelManager.getNameWAccess(labelSet,"btnBus")%></button></TD><TD align="rigth"><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></HTML><%@include file="../../components/scripts/server/endInc.jsp" %><SCRIPT LANGUAGE=javascript>

	function btnSearch_click(){
		var result = new Array();
		var fileName = document.getElementById("txtFileName").value;	
		if (fileName==null || fileName==""){
			result[0] = "";
		} else {
			result[0] = fileName;
		}	
		window.returnValue=result;
		window.close();
	}

	function btnExit_click(){
		window.returnValue=null;
		window.close();
	}

</SCRIPT>
