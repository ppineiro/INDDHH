<%@page import="com.st.util.XMLUtils"%><%@page import="java.util.*"%><%@page import="java.io.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML XMLNS:CONTROL><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD>CMP Results</TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><%
		try {
			out.println(XMLUtils.transform(new Integer(1),com.dogma.test.ToolsDBCompare.compareDB(request),"\\tools/compareDB/showDBCmp.xsl"));
		} catch (Throwable t) {
			t.printStackTrace();
		}
		%></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button onclick="Cancel_click()">Cancel</button></TD></TR></TABLE></body></html><script language="javascript" defer=true>

	function Cancel_click() {
		window.close();
	}

</script><%@include file="../../components/scripts/server/endInc.jsp" %>