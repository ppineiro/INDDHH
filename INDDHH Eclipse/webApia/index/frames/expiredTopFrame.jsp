	<%@page import="com.dogma.Parameters"%><%@page import="com.dogma.vo.*"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="java.util.*"%><%@include file="../components/scripts/server/startInc.jsp" %><jsp:useBean id="bLogin" class="com.dogma.bean.security.LoginBean" scope="session"/><HTML><HEAD><link href="<%=Parameters.ROOT_PATH%>/styles/default/css/topFrame.css" rel="styleSheet" type="text/css" media="screen"><script src="<%=Parameters.ROOT_PATH%>/scripts/events.js" language="Javascript"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/common.js" language="Javascript"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/util.js" language="Javascript"></script></HEAD><BODY ><form name="frmLogin" method="post"><table width="100%" height="100%" border=0 cellpadding=0 cellspacing=0><col width="5%"><col width="30%"><col width="65%"><tr><td bgcolor="#FFFFFF"><img src="<%=Parameters.ROOT_PATH%>/styles/default/images/apialogo.gif"></td><td class="degree"></td><td align=right class="degree2"><span class="spanLogged" 
				
				></span><span class="spanName"></span><span class="spanMenu"></span><span class="spanLogout"></span></td></tr></table><input id="hidLang" type=hidden value=""></form></BODY></HTML><script language="javascript">
parent.window.location.href = "<%=com.dogma.Parameters.ROOT_PATH%>/programs/login/login.jsp?langId=<%= request.getParameter("langId") %>";	
</script>
