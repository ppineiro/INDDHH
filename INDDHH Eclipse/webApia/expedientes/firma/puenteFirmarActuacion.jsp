<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.st.util.labels.LabelManager"%>
<%
//no dejamos que la pagina se cache
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 

String styleDirectory = "default";
Integer labelSet = Parameters.DEFAULT_LABEL_SET;
Integer langId = Parameters.DEFAULT_LANG;
%>
<HTML>
<HEAD>	
	<link href="<%=Parameters.ROOT_PATH%>/styles/Kzes_Next/css/feedBack.css" rel="styleSheet" type="text/css" media="screen">	
	<script  language="javascript">
		function paginaCargada(){			
			frmMain.action = "firmarActuacion.jsp";
			frmMain.submit();
		}		
	</script>	
</HEAD>
<BODY onload=paginaCargada()>
<form id=frmMain>
<div id="divWait" style="height:197px;">
 <table class="tblTitulo" height="100%">
  <tr>
    <td vAlign="top">
      <img id="divTituloWaitStatusImage" src="<%=Parameters.ROOT_PATH%>/styles/Kzes_Next/images/spinner.gif">         
      <%=LabelManager.getName(labelSet,langId,"lblEspUnMom")%>
      <div id="divTituloWaitStatusMessage" style="display:none"></div>
      <div style="border: thin #FFFFFF solid; width: 200px; display:none" id="divTituloWaitStatusImageContainer">
      	<img id="divTituloWaitStatusImage" src="/<%=Parameters.ROOT_PATH%>/images/bar.gif" height="10	px" width="0px">
      </div>
     </td>
    </tr>
  </table>
</div>	
</form>		
</BODY>	
</HTML>
