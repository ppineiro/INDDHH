<%@page import="java.util.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><% boolean canOrderBy = false; %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body onload="sizeMe()"><jsp:useBean id="xBean" scope="session" class="com.dogma.bean.ViewEntityFormsBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titForGri")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id=frmMain method=post><input type=hidden name="rowIndex" value="<%=request.getParameter("rowIndex")%>"><%
		xBean.setXRequest(request);
		xBean.setXSession(session);
		String strScriptLoad = "";
		String strScriptSubmit = "";
		String strAtts = "";
		boolean showConfirm = true;
		Collection forms = xBean.getFormBeans();
		if (forms!=null){
			Iterator it = forms.iterator();
			while(it.hasNext()){
				com.dogma.bean.execution.FormBean fBean = (com.dogma.bean.execution.FormBean)it.next();
				out.println("<BR>");
				try{
					out.println(fBean.getForm(request));

					if(fBean.isHTMLFormReadOnly() || fBean.isFormReadonly()){
						showConfirm = false;
					}
					strAtts = fBean.getAttValsForGridModal();
					
					if(fBean.hasOnload && fBean.firstLoad){
						strScriptLoad +=  fBean.getOnLoadName() + ";\n";
					}
					
					if(fBean.hasOnReload && !fBean.firstLoad){
						strScriptLoad +=  fBean.getOnReloadName() + ";\n";
					}
					
					if(fBean.hasOnSubmit){
						strScriptSubmit += "boolContinue = boolContinue & " + fBean.getOnSubmitName() + ";\n";
					}
					fBean.firstLoad = false;
				} catch (Exception e) {
					out.println("***** ERROR FORM NOT LOADED ****" );
					out.println("<BR>" + e.getMessage() + "<BR>");			
					out.println(" View standard output for more information " );	
					e.printStackTrace();
				}
			}
		}
		
		String strScript = (String)request.getAttribute("FORM_SCRIPTS");
	
		if(strScript==null){
			strScript="";
		}
		
		StringBuffer strBuf = new StringBuffer(strScript);
	
		strBuf.append("\n<script language=\"javascript\" DEFER>\n");
		if("E".equals(request.getParameter("frmParent"))){
			strBuf.append("function frmOnloadE(){\n");
		} else {
			strBuf.append("function frmOnloadP(){\n");
		}
		strBuf.append(strScriptLoad);
		strBuf.append("}\n");
		if("E".equals(request.getParameter("frmParent"))){
			strBuf.append("function submitFormsData_E(){\n");
		} else {
			strBuf.append("function submitFormsData_P(){\n");
		}
		strBuf.append("var boolContinue = true;\n");
		strBuf.append(strScriptSubmit);
		strBuf.append("if(boolContinue){\n");
		strBuf.append("return true;\n");
		strBuf.append("} else {\n");
		strBuf.append("return false;\n");
		strBuf.append("}\n");
		strBuf.append("}\n");
		strBuf.append("</script>\n");

		out.print(strBuf.toString());
		
		
		%></form></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><%if(showConfirm){ %><button id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><%} else {%><button id="btnExit" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button><%} %></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endIncPopGrid.jsp" %><script src="<%=Parameters.ROOT_PATH%>/scripts/apiaFunctions.js"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/digitalSignature.js"></script><script language=javascript>
	

	function btnExit_click() {
		window.parent.returnValue=null;
		window.parent.close();
	}
	
	function btnConf_click(){
		if (verifyRequiredObjects()) {
			try {
				var test=submitFormsData_E();
				if (!test) {
					return;
				}
			} catch (e){
			}
	
			try {
				var test=submitFormsData_P();
				if (!test) {
					return;
				}
			} catch (e){
	
			}
			<%=strAtts%>
			//setTimeout('mdlClose()',1000);
			window.returnValue=arrRet;
			document.getElementById("frmMain").action = "ViewEntityFormsAction.do?action=updateAtts&inModal=True&frmId=<%=request.getParameter("frmId")%>";
			document.getElementById("frmMain").target = "ifrTarget";
			document.getElementById("frmMain").submit();
			return true;	
		}
		return false;
	}
	
 
	function mdlClose(){
		closeingOk = true;
		window.parent.closeWindow(window.returnValue);
	}
	
	var submitPerformed = false;
	
	function submitFormReload(obj) {
		if (submitPerformed ==  true){
			return false;
		}
		try{
			document.getElementById("btnConf").disabled = true;
		} catch(e){}
		try{
			document.getElementById("btnExit").disabled = true;
		} catch(e){}
		obj.target = "";
		closeingOk = true;
		submitPerformed = true;
		submitForm(obj);
	}
	function sizeMe(){
		var frame=window.parent.document.getElementsByTagName("IFRAME")[0];
		frame.style.width="100%";
		var height=window.parent.innerHeight-10;
		if(navigator.userAgent.indexOf("MSIE")>0){
			//window.event.cancelBubble=true;
			height=window.parent.document.documentElement.clientHeight-20;
			frame.style.height=(height+15)+"px";
			document.getElementById("divContent").style.height=(height-45)+"px";
			document.getElementById("divContent").style.width="97%";
			document.getElementById("divContent").style.position="relative";
			frame.style.width="99%";
			window.parent.document.body.style.overflow="hidden";
			sizeGrids(document.getElementById("divContent").clientWidth-10);
		}else{
			document.getElementById("divContent").style.height=(height-60)+"px";
			document.getElementById("divContent").style.width="100%";
			frame.style.height=(height)+"px";
			frame.style.overflow="hidden";
			sizeGrids(document.getElementById("divContent").clientWidth-10);
		}
		
	}

	window.onload=function(){
		try{
			fnStartDocInit();
		} catch(e){}
		if(document.readyState=='complete'){
			try{
				frmOnloadE();
			} catch(e){}
			try{
				frmOnloadP();
			} catch(e){}
		}
	}	
	var canClose = true;
</script>