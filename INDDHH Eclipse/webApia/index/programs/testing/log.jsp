<%@page import="java.util.*"%><%@page import="com.dogma.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><jsp:useBean id="bTest"  
			 class="com.dogma.testing.web.controller.TestBean"      
			 scope="session"/><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD>Configuración Testing</TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false" ><table border=0 align="center" valign="middle" class="tblFormLayout"><thead><tr><td>Opciones para definir errores de testing</td></tr></thead><tbody><tr><td title="Último Archivo">Seleccione Archivo XML:</td><td><select name="txtFileName" id="txtFileName"><%Collection col = bTest.getAllLogFile();
   						if (col != null) {
	   						Iterator it = col.iterator();
	   						String fileName = null;
	   						while (it.hasNext()) {
	   						 	fileName = bTest.fmtStr((String) it.next()); 
	   						 	%><option value="<%=fileName%>"><%=fileName%></option><%	
		   					}
		   				}%></select></td></tr></tbody></TABLE><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRes")%></DIV><div type="grid" id="gridRequest" style="height:350px"><table  width="500px" cellpadding="0" cellspacing="0"><thead><tr><td style="width:10%"  title="Id">Id.Name</td><td style="width:40%"  title="URL">Action</td><td style="width:10%"  title="Property">Property</td><td style="width:40%"  title="Value">Value</td></tr></thead><tbody ></tbody></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD><button type="button" onclick="btnSearch_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnBus")%>" title="<%=LabelManager.getToolTip(labelSet,"btnBus")%>"><%=LabelManager.getNameWAccess(labelSet,"btnBus")%></button></TD><TD align="center" style="width:100%"><div id="moreData" style="display:none"><%=LabelManager.getName("lblMoreData")%></div><div id="noData" style="display:none"><%=LabelManager.getName("lblNoData")%></div></TD><TD align="rigth"><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></HTML><%@include file="../../components/scripts/server/endInc.jsp" %><SCRIPT LANGUAGE=javascript>

	function btnSearch_click(){
		document.getElementById("gridRequest").clearTable();
		doXMLLoad();
	}

	function doXMLLoad(){
		var sXMLSourceUrl = null;
		var fileName = document.getElementById("txtFileName").value;	
		if (fileName==null || fileName==""){
			sXMLSourceUrl = "logXML.jsp";
		} else {
			sXMLSourceUrl = "logXML.jsp?fileName=" + fileName;
		}
	
		var listener=new Object();
		listener.onLoad=function(xml){
			if (isXMLOk(xml)) {
				readDocXML(xml);
			}
		}
		xml.addListener(listener);
		sXmlResult = __readInDOMDocument(sXMLSourceUrl);
	}

	function readDocXML(sXmlResult){
		var xmlRoot=getXMLRoot(sXmlResult);
		document.getElementById("moreData").style.display="none";
		document.getElementById("noData").style.display="none";
		if (xmlRoot.nodeName != "EXCEPTION") {
			if (xmlRoot.childNodes.length == 0) {
				document.getElementById("noData").style.display="block";
			} else {
				var oldid = "";
				var odd = false;
				for(i=0;i<xmlRoot.childNodes.length;i++){
					if (i >= <%=Parameters.MAX_RESULT_MODAL %>) {
						document.getElementById("moreData").style.display="block";
						break;
					} else {				
						xRow = xmlRoot.childNodes[i];
						var oTr = document.createElement("TR");
					
						if (oldid != xRow.childNodes[0].text) {
							odd = !odd;
						}
						if (odd){
							oTr.className="trOdd";
						}
	
						var oTd0 = document.createElement("TD"); 
						var oTd1 = document.createElement("TD"); 
						var oTd2 = document.createElement("TD"); 
						var oTd3 = document.createElement("TD"); 

						oldid = xRow.childNodes[0].text;
						oTd0.innerText = xRow.childNodes[0].text;
						oTd1.innerText = xRow.childNodes[1].text;
						oTd2.innerText = xRow.childNodes[2].text;
						oTd3.innerText = xRow.childNodes[3].text;
			
						oTr.appendChild(oTd0);
						oTr.appendChild(oTd1);
						oTr.appendChild(oTd2);
						oTr.appendChild(oTd3);
		
						document.getElementById("gridRequest").addRow(oTr);
					}
				}
			}
		}else{
			alert("error occurred");
		}
	
		xmlRoot = "";
		sXmlResult = "";
	}		

	function btnExit_click(){
		window.returnValue=null;
		window.close();
	}

</SCRIPT>
