<%@page import="java.util.*"%><%@page import="com.dogma.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><jsp:useBean id="bTest"  
			 class="com.dogma.testing.web.controller.TestBean"      
			 scope="session"/><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD>Configuración Testing</TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false" ><table border=0 align="center" valign="middle" class="tblFormLayout"><thead><tr><td>Diferencias en ejecucion de testing ejecucion</td></tr></thead><tbody><tr><td title="Último Archivo">Archivo de log:</td><td title="Último Archivo"><%=bTest.getDiffFile()%></td></tr></tbody></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRes")%></DIV><table border=0 align="center" valign="middle" class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><%	
					// Construimos un string con las diferencias a mostrar
					Map diffMap = bTest.getDiffMap();
					Iterator itTable = diffMap.keySet().iterator();
					while (itTable.hasNext()) {
						String table = (String)itTable.next();
						Object[] arrRow  = (Object[])diffMap.get(table);
						ArrayList table1 = (ArrayList)arrRow[0];
						ArrayList table2 = (ArrayList)arrRow[1];
						out.println("<tr><td align='left' colspan='4'><b>" + table + "</b></tr></tr>");
						out.println("<tr><td align='left' colspan='4'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(base de referencia)</td></tr>");
						for (int i = 0; i < table1.size(); i++) {
							HashMap row = (HashMap)table1.get(i);

							String rowStr = "[";
							Iterator itkeys = row.keySet().iterator();
							while (itkeys.hasNext()) {	
								String colNam = (String)itkeys.next();
								String colVal = (String)row.get(colNam);
								rowStr = rowStr + colVal + ",";
							}		
							if (rowStr.endsWith(",")) {					
								rowStr = rowStr.substring(0, rowStr.length() - 1);
							}
							rowStr = rowStr + "]";

							out.println("<tr><td></td><td align='left' colspan='3'>" + rowStr + "</td></tr>");
						}

						out.println("<tr><td align='left' colspan='4'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(base de caso de prueba)</td></tr>");
						for (int i = 0; i < table2.size(); i++) {
							HashMap row = (HashMap)table2.get(i);

							String rowStr = "[";
							Iterator itkeys = row.keySet().iterator();
							while (itkeys.hasNext()) {	
								String colNam = (String)itkeys.next();
								String colVal = (String)row.get(colNam);
								rowStr = rowStr + colVal + ",";
							}		
							if (rowStr.endsWith(",")) {					
								rowStr = rowStr.substring(0, rowStr.length() - 1);
							}
							rowStr = rowStr + "]";

							out.println("<tr><td></td><td align='left' colspan='3'>" + rowStr + "</td></tr>");
						}
					}
				%></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><TR><TD>&nbsp;</TD><TD>&nbsp;</TD><TD>&nbsp;</TD><TD align="rigth" width="100%"><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></HTML><%@include file="../../components/scripts/server/endInc.jsp" %><SCRIPT LANGUAGE=javascript>

	function btnExit_click(){
		window.returnValue=null;
		window.close();
	}

</SCRIPT>
