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
			</TD>
		</TR>
	</TABLE>
	<div id="divContent" <region:render section='divHeight'/>>
	
	<form id="frmMain" name="frmMain" target="iframeResult" method="POST">

	<div type="tabElement" id="samplesTab" ontabswitched="tabSwitch()" <%if (request.getParameter("selTab") != null) {%> defaultTab="<%=request.getParameter("selTab")%>"<%}%>>
		
			<region:render section='entityForms'/>
			
		</div>	
	
	</div>
	</FORM>
	

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