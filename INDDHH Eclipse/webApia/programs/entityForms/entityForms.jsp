<%@page import="java.util.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><% boolean canOrderBy = false; %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="xBean" scope="session" class="com.dogma.bean.ViewEntityFormsBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titEnt")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form name="frmMain" method="post"><%
		
		Collection forms = xBean.getFormBeans();
		if (forms!=null){
			Iterator it = forms.iterator();
			while(it.hasNext()){
				com.dogma.bean.execution.FormBean fBean = (com.dogma.bean.execution.FormBean)it.next();
				out.println("<BR>");
				try{
					out.println(fBean.getForm(request));
				} catch (Exception e) {
					out.println("***** ERROR FORM NOT LOADED ****" );
					out.println("<BR>" + e.getMessage() + "<BR>");			
					out.println(" View standard output for more information " );	
					e.printStackTrace();
				}
			}
		}
		String strScript = (String)request.getAttribute("FORM_SCRIPTS");
		if(strScript!=null){
			out.println(strScript);
		}
		%></form></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><%if("true".equals(request.getParameter("showPrint"))){ %><button type="button" onclick="btnPrint_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnStaPri")%>" title="<%=LabelManager.getToolTip(labelSet,"btnStaPri")%>"><%=LabelManager.getNameWAccess(labelSet,"btnStaPri")%></button><%} %><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE><form style="display:none" id="printForm" name="printForm" method="post" action="<%=Parameters.ROOT_PATH%>/frames/print.jsp" target="_blank"><input type="hidden" name="body" id="body"></form></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script src="<%=Parameters.ROOT_PATH%>/scripts/apiaFunctions.js"></script><script language=javascript>
	function btnExit_click() {
		window.returnValue=null;
		window.close();
	}

	function btnPrint_click() {
		try {
			if (!beforePrintFormsData_E()) {
				return;
			}
		} catch (e){}
		try {
			if (!beforePrintFormsData_P()) {
				return;
			}
		} catch (e){}
		
	
	
		var modal=openModal("/frames/blank.jsp", 680,400);
		function submitPrint(){
			document.getElementById("printForm").submit();
		    document.getElementById("printForm").body.value = "";
	    }
	    modal.onload=function(){
	    	submitPrint();
	    }
		var selectedTab = null;
		var divContentHeight = document.getElementById("divContent").style.height;
		//document.getElementById("divContent").style.height = "";
		document.getElementById("printForm").body.value = "";
		document.getElementById("printForm").body.value = processBodyToPrint();
	   //document.getElementById("divContent").style.height = divContentHeight;
	
	    //styleWin.focus();
		document.getElementById("printForm").target=modal.content.name;//"Print";
		
			
		try {
			if (!afterPrintFormsData_E()) {
				return;
			}
		} catch (e){}
		try {
			if (!afterPrintFormsData_P()) {
				return;
			}
		} catch (e){}
	}
</script>