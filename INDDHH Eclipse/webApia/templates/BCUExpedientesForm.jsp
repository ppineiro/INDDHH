<%@ taglib uri='regions' prefix='region' %>
<%@page import="com.dogma.vo.*"%>
<%@page import="com.dogma.bean.execution.*"%>
<%@page import="java.util.*"%>

<%@include file="../components/scripts/server/startInc.jsp" %>
<HTML XMLNS:CONTROL> 
<head>
<%@include file="../components/scripts/server/headInclude.jsp" %>

</head>
<body>
	<TABLE class="pageTop">
		<COL class="col1"><COL class="col2">
		<TR>
			<TD><region:render section='title'/></TD>
			<TD align="right">
				<button onclick="showDocs_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"sbtEjeDoc")%>" title="<%=LabelManager.getToolTip(labelSet,"sbtEjeDoc")%>"><%=LabelManager.getNameWAccess(labelSet,"sbtEjeDoc")%></button>
			</TD>
		</TR>
	</TABLE>
	<div id="divContent" <region:render section='divHeight'/>>
		
		<form id="frmMain" name="frmMain" target="iframeResult" method="POST">
	
	     <div type="tabElement" id="samplesTab" ontabswitched="tabSwitch()" <%if (request.getParameter("selTab") != null) {%> defaultTab="<%=request.getParameter("selTab")%>"<%}%>>
	
	            <div type="tab" style="visibility:hidden" tabTitle="<%=""%>" tabText="<%=""%>">	            
		                  
	                  <region:render section='entityForms'/>	                  
	
	            </div>      
	    
				<div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabEjeObs")%>" tabText="<%=LabelManager.getName(labelSet,"tabEjeObs")%>">
					<region:render section='taskComments' />
				</div>
	
	      </div>
	
		</form>
		
	</div>
	<TABLE class="pageBottom">
		<COL class="col1"><COL class="col2">
			<TR>
				<TD></TD>
				<TD>
				<region:render section='buttons'/>
				</TD>
			</TR>
		</TABLE>	
</body>
</html>
<script>
function showDocs_click() {
	openModal("/programs/documents/docExecutionModal.jsp",500,300);
}

function doRedirect() {
	var parent = window;
	 while(parent != null && parent != parent.parent)
		 parent = parent.parent;
	 
	 if(parent != null) {
		 var redirect = parent.location.href.split('programs');
		 parent.location.href = redirect[0] + 'programs/login/login.jsp';
		 //window.top.location.href = redirect[0] + 'programs/login/login.jsp';
	 }
	
}
<%if("true".equals(request.getSession().getAttribute("desloguealo"))) {%>;
	 doRedirect();
<%
	request.getSession().setAttribute("desloguealo", "false");
}%>
</script>

