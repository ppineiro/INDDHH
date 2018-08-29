<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="com.dogma.*"%><%@page import="java.util.*"%><%@page import="java.io.*"%><%@include file="../../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.query.OffLineBean"></jsp:useBean><%
QueryVo queryVo = dBean.getQueryVo();
QryResultFileVo resultVo = dBean.getResultFileVo(); %><TABLE class="pageTop"><COL class="col1" /><COL class="col2" /><TR><TD><%=LabelManager.getName(labelSet,"titQry")%>: <%= dBean.fmtStr(queryVo.getQryTitle()) %> (<%= LabelManager.getName(labelSet,"lblPage") %><%= dBean.fmtHTML(resultVo.getPage()) %>)</TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><%

			File file = new File(resultVo.getFilePath());
		    FileReader fr = new FileReader(file);
		    BufferedReader br = new BufferedReader(fr);
		    String linea = null;
		    while((linea = br.readLine()) != null) {
    			out.println(linea);
			}
			
			br.close();
			fr.close(); %></body></HTML><%@include file="../../../../components/scripts/server/endInc.jsp" %><script>
var PAGE = <%= resultVo.getPage() %>;
var QUERY_ID = <%= queryVo.getQryId() %>;
</script><script language='javascript' src='<%=Parameters.ROOT_PATH%>/programs/query/administration/offLine/open.js'></script>

