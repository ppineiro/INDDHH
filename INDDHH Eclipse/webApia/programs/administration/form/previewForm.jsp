<%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><% boolean canOrderBy = false; %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body onload="sizeMe()"><jsp:useBean id="xBean" scope="session" class="com.dogma.bean.ViewEntityFormsBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titPre")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id=frmMain method=post><%
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
					fBean.setPreview(true);
					out.println(fBean.getForm(request));

					if(fBean.isHTMLFormReadOnly() || fBean.isFormReadonly()){
						showConfirm = false;
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
		
		
			%></form></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><%if(showConfirm){ %><button onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><%} %><button onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endIncPopGrid.jsp" %><script language=javascript>
	function btnExit_click() {
		window.parent.close();
	}
	
	function btnConf_click(){
 		window.parent.close();
	}
	
	function mdlClose(){
		window.parent.close();
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
</script>