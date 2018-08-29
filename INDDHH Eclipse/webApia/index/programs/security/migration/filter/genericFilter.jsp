<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.security.*"%><%@include file="../../../../components/scripts/server/startInc.jsp" %><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.MigrationBean"/><HTML><head><%@include file="../../../../components/scripts/server/headInclude.jsp" %><% boolean onlyOne = request.getParameter("onlyOne") != null; %></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD id="tdTitle"><%=LabelManager.getName(labelSet,"sbtFil")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtFil")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td><input name="txtNom" id="txtNom" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>"></td></tr></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRes")%></DIV><div type="grid" id="gridObjects" style="height:80px"><table width="100%" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th></tr></thead><tbody ></tbody></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD><button type="button" onclick="btnSearch_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnBus")%>" title="<%=LabelManager.getToolTip(labelSet,"btnBus")%>"><%=LabelManager.getNameWAccess(labelSet,"btnBus")%></button></TD><TD align="center" style="width:100%"><div id="moreData" style="display:none"><%=LabelManager.getName(labelSet,"lblMoreData")%></div><div id="noData" style="display:none"><%=LabelManager.getName(labelSet,"lblNoData")%></div></TD><TD align="rigth"><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../../components/scripts/server/endInc.jsp" %><script language="javascript">
	function btnConf_click() {
		window.returnValue=getSelected();

		// Store in the parent the seleccion
		//dialogArguments.selectedData = objectSelection;
		window.returnValue=objectSelection;

		window.close();
	}	
	
	function btnSearch_click(){
		document.getElementById("gridObjects").clearTable();
		doXMLLoad();
	}
	
	function doXMLLoad(){
		var envId = '<%=dBean.getEnvVo().getEnvId().intValue()%>';
		var objectId = '<%= request.getParameter("objectId") %>';
		var sXMLSourceUrl = "genericFilterXML.jsp?envId=" + envId + "&object=" + objectId + "&name=" + escape(document.getElementById("txtNom").value);
	
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
				for(i=0;i<xmlRoot.childNodes.length;i++){
					if (i >= <%=Parameters.MAX_RESULT_MODAL %>) {
						document.getElementById("moreData").style.display="block";
						break;
					} else {
						xRow = xmlRoot.childNodes[i];
						if(xRow.childNodes.length>0){
							var oTr = document.createElement("TR");
	
							if (i%2==0) {
								oTr.className="trOdd";
							}
		
							var oTd0 = document.createElement("TD"); 
							var oTd1 = document.createElement("TD"); 
						
							// If the element is selected, check it here
							if (objectSelection != null && (objectSelection.indexOf(xRow.childNodes[0].text) != -1)) {
								oTd0.innerHTML = "<input type='checkbox' name='chk' checked <% if (onlyOne) { %>onclick='selectOneChk(this)'<% } %>>";
							} else {
								oTd0.innerHTML = "<input type='checkbox' name='chk' <% if (onlyOne) { %>onclick='selectOneChk(this)'<% } %>>";
							}
							oTd0.objectId = xRow.childNodes[0].firstChild.nodeValue;
							oTd0.objectName = xRow.childNodes[1].firstChild.nodeValue;
					
							oTd1.innerHTML = xRow.childNodes[1].firstChild.nodeValue;
				
							oTr.appendChild(oTd0);
							oTr.appendChild(oTd1);
		
							document.getElementById("gridObjects").addRow(oTr);
						}
					}
				}
			}
		}else{
			alert("error occurred");
		}
		
		xmlRoot = "";
		sXmlResult = "";
	}		
	
	
	function getSelected(){
		objectSelection = '';
	
		var oRows = document.getElementById("gridObjects").selectedItems;
		if (oRows != null) {
			var result = new Array();
			for (i = 0; i < oRows.length; i++) {
				var oRow = oRows[i];
				
				var oTd = oRow.cells[0];
				arr = new Array();
				arr[0] = oTd.objectId;
				arr[1] = oTd.objectName;
			
				result[i] = arr;
				
				objectSelection = objectSelection + oTd.objectId + '<%=MigrationBean.SEPARATOR_IDDES%>' + oTd.objectName + '<%=MigrationBean.SEPARATOR_ELEMS%>' ;
			}
			return result;
		} else {
			return null;
		}
	}
	
	function btnExit_click() {
		window.returnValue=null;
		window.close();
	}
</script><script language="javascript">
	var objectName;
	var objectSelection ;
	function init(){
    // Object we are working with
	objectName = dialogArguments.selectedObject;

	// Selected elements 
	objectSelection = dialogArguments.selectedData;
	
	// Set the title
	document.getElementById("tdTitle").innerText = objectName;
	}
	
</script>		
