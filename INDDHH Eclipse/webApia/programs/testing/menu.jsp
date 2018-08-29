<%@include file="../../components/scripts/server/startInc.jsp" %><jsp:useBean id="bTest"  
			 class="com.dogma.testing.web.controller.TestBean" 
			 scope="session" /><%
	String testpath = pageContext.getServletContext().getInitParameter("PathTestFile"); 
	// If the path is not specified, we use the default temporal storage of APIA
	if (testpath == null) {
		testpath = Parameters.TMP_FILE_STORAGE;
	}
	bTest.setPath(testpath);	

	String dbpath = pageContext.getServletContext().getInitParameter("PathDatabaseFile"); 
	// If the path is not specified, we use the default temporal storage of APIA
	if (dbpath == null) {
		dbpath = Parameters.TMP_FILE_STORAGE;
	}
	bTest.setDatabasePath(dbpath);	
%><HTML><HEAD><%@include file="../../components/scripts/server/headInclude.jsp" %><link href="<%=Parameters.ROOT_PATH%>/styles/<%=styleDirectory%>/css/topFrame.css" rel="styleSheet" type="text/css" media="screen"><link href="<%=Parameters.ROOT_PATH%>/css/topFrame.css" rel="styleSheet" type="text/css" media="screen"><script src="<%=Parameters.ROOT_PATH%>/scripts/events.js" language="Javascript"></script><script language="javascript" defer="true"> 
			// Always enable all the documents (asumes the blocking operation finishes
			enableDocument();
		
			// We clean the message, only if we are not backing up, or restoring
			if (<%=bTest != null && bTest.getTestMessage() == null%>) {
				document.getElementById("txtMsg").value = '';
			} 
			if (<%=bTest != null && bTest.getTestMessage() != null && bTest.getTestMessage().equals("")%>) {
				document.getElementById("txtMsg").value = '';
			}
			if (<%=bTest != null && bTest.getTestMessage() != null && !bTest.getTestMessage().equals("")%>) {
				document.getElementById("txtMsg").value = '<%=bTest.getTestMessage()%>';
			}

			// Enable/Disable the following buttons if we are running the tester
			if (<%=bTest.isSaveRequest()%>) {
				var obj; 
				obj = document.getElementById('btnStart');
				obj.disabled = true;
				obj = document.getElementById('btnStop');
				obj.disabled = false;
				obj = document.getElementById('btnError');
				obj.disabled = true;
				obj = document.getElementById('btnSnap');
				obj.disabled = true;
				//obj = document.getElementById('txtId');
				//obj.disabled = true;
				obj = document.getElementById('txtName');
				obj.disabled = true;
			}

			// Enable/Disable the following buttons if we are not running the tester
			if (<%=!bTest.isSaveRequest()%>) {
				var obj; 
				obj = document.getElementById('btnStart');
				obj.disabled = false;
				obj = document.getElementById('btnStop');
				obj.disabled = true;
				obj = document.getElementById('btnError');
				obj.disabled = false;
				obj = document.getElementById('btnSnap');
				obj.disabled = false;
				//obj = document.getElementById('txtId');
				//obj.disabled = false;
				obj = document.getElementById('txtName');
				obj.disabled = false;
			}

			// At the begining we check if we must show diferences. If so, we show them now
			// Enable/Disable the following buttons if we are running the tester
			if (<%=bTest.getShowDif()%>) {
				diffShow('<%=Parameters.ROOT_PATH%>');
			}

		</script></HEAD><BODY><form name="frmTest" id="frmTest" method="post"><table width="100%" height="100%" border=0 cellpadding=0 cellspacing=0><tr align='left' class="testToolbarLayout"><td>Testing toolbar:</td><td><button type="button" name="btnStart" onclick="saveRequest('<%=Parameters.ROOT_PATH%>')" <% if (bTest.isSaveRequest()){%>disabled="true"<%}%> >Start</button><button type="button" name="btnError" style="display:none" onclick="error('<%=Parameters.ROOT_PATH%>')" >Error</button><button type="button" name="btnStop" onclick="stopRequest('<%=Parameters.ROOT_PATH%>')" <%if (!bTest.isSaveRequest()){%>disabled="true"<%}%> >Stop</button>
						&nbsp;&nbsp;
						<button type="button" name="btnSnap" onclick="snap('<%=Parameters.ROOT_PATH%>')" <%if ( bTest.isSaveRequest()){%>disabled="true"<%}%>  >DB Snap</button></td><td><!--     - Id: <input type="text" name="txtId" size="2" maxlength="3" value="<%=bTest.fmtInt(bTest.getTestId())%>" disabled>          -->
			   			Name: <input type="text" name="txtName" size="20" maxlength="50" value="<%=bTest.fmtStr(bTest.getTestName())%>">
			   			Message: <input type="text" name="txtMsg" size="50" maxlength="100" value="<%=bTest.fmtStr(bTest.getTestMessage())%>" disabled></td><td><button type="button" name="btnLogout" onclick="logout()">Logout</button></td></tr></table></form></BODY></HTML><script language="javascript">

	function saveRequest(path) {
		// We get the text name
		var testName = document.getElementById("txtName").value;
		if (testName == "" || testName == null) {
			alert('Debe ingresar el nombre del test');
			return;
		}

		document.getElementById("txtMsg").value = "";
		var url = path + "/programs/testing/start.jsp";	
		var width = "600";
		var height = "370";
		var paramArr = "status:no; help:no; unadorned:yes; center:yes; dialogWidth:"+width+"px; dialogHeight:"+height+"px;";
		var selected = window.showModalDialog(url,null,paramArr);
		if (selected != null){
			document.getElementById("frmTest").action="TestAction.do?action=confirmStart&sel=" + selected[0] + 
										"&selSession=" + selected[1] + 
										"&selDate=" + selected[2] + 
										"&device=" + selected[3] + 
										"&objCustom=" + selected[4] + 
										"&dateCustom=" + selected[5] +
										"&name=" + testName +
										"&fileName=" + selected[6];

			disableDocument();
			document.getElementById("txtMsg").value = "STARTING TEST";

			document.getElementById("frmTest").submit();
		}
	}

	function stopRequest(path) {
		document.getElementById("txtMsg").value = "";
		document.getElementById("txtMsg").value = "PROCESSING DATABASE";
		var name = document.getElementById("txtName").value;
		//frmTest.action="TestAction.do?action=confirmStop&sel=2&id=" + id + "&name=" + name;
		document.getElementById("frmTest").action="TestAction.do?action=confirmStop&sel=2&name=" + name;
		document.getElementById("frmTest").submit();
	}

	function logout() {
		document.getElementById("frmTest").action="security.LoginAction.do?action=logout";
		document.getElementById("frmTest").submit();
	}

	function save(path) {
		document.getElementById("txtMsg").value = "";
		//var id   = document.getElementById("txtId").value;
		var name = document.getElementById("txtName").value;
		//frmTest.action="TestAction.do?action=save&id=" + id + "&name=" + name;
		document.getElementById("frmTest").action="TestAction.do?action=save&name=" + name;
		document.getElementById("frmTest").submit();
	}	

	function error(path) {
		if (<%=bTest.isSaveRequest()%>){
			document.getElementById("frmTest").action="TestAction.do?action=error";
			document.getElementById("frmTest").submit();
		} else {
			document.getElementById("txtMsg").value = "";
			var url = path + "/programs/testing/error.jsp";	
			var width = "800";
			var height = "600";
			var paramArr = "status:no; help:no; unadorned:yes; center:yes; dialogWidth:"+width+"px; dialogHeight:"+height+"px;";
			var selected = window.showModalDialog(url,null,paramArr);
			if (selected != null){
				fileName = selected[0];
				arr = selected[1];
				resultado = null;
				for (j = 0; j < arr.length; j++) {
					if (resultado == null){
						resultado = arr[j];
					} else {
						resultado = resultado + "·" +arr[j];
					}
				}
				document.getElementById("frmTest").action="TestAction.do?action=error&fileName="+ fileName +"&sel="+ resultado;
				document.getElementById("frmTest").submit();
			}
		}
	}

	function snap(path) {
		var testName = document.getElementById("txtName").value;
		if (testName == "" || testName == null) {
			alert('Debe ingresar el nombre con el cual se salvará la BD');
			return;
		}

		document.getElementById("txtMsg").value = "Saving DB ...";
		document.getElementById("frmTest").action="TestAction.do?action=snap&txtName=" + document.getElementById("txtName").value;
		document.getElementById("frmTest").submit();
	}

	function disableDocument() {
/*		elems = document.frmTest.elements;
		for (i=0; i<elems.length; i++){
			elems[i].disabled = true;
		}
	
		// Now, disable the workArea elements (in the form)
		if (window.parent.workArea.document.forms != null && window.parent.workArea.document.forms.length > 0) {
			elems = window.parent.workArea.document.forms[0].all
			if (elems != null) {
				for (i=0; i<elems.length; i++){
					elems[i].disabled = true;
				}
			}
		}
		
		// Now, disable the workArea elements (outside the form)
		elems = window.parent.workArea.document.getElementsByTagName('button');
		if (elems != null) {
			for (i=0; i<elems.length; i++){
				elems[i].disabled = true;
			}
		}
		
		// Now, disable the toc elements
		if (window.parent.tocArea != null) {
			window.parent.tocArea.location  = '<%=Parameters.ROOT_PATH%>/toc/tocWait.jsp';
		}*/
	}

	function enableDocument() {
/*		elems = document.frmTest.elements;
		for (i=0; i<elems.length; i++){
			elems[i].disabled = false;
		}
		
		// Now, enable the workArea elements (in the form)
		if (window.parent.workArea.document.forms != null && window.parent.workArea.document.forms.length > 0) {
			elems = window.parent.workArea.document.forms[0].all
			if (elems != null) {
				for (i=0; i<elems.length; i++){
					elems[i].disabled = false;
				}
			}
		}
		
		// Now, enable the workArea elements (outside the form)
		elems = window.parent.workArea.document.getElementsByTagName('button');
		if (elems != null) {
			for (i=0; i<elems.length; i++){
				elems[i].disabled = false;
			}
		}
		
		// Now, enable the toc elements
		if (window.parent.tocArea != null) {
			window.parent.tocArea.location = 'FramesAction.do?action=menu';
		}		*/
	}
</script>