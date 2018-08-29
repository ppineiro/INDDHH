<%@page import="com.dogma.UserData"%><%@page import="java.util.*"%><%@include file="../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../components/scripts/server/headInclude.jsp" %><script type="text/javascript">
		function continueLogin(){
			document.getElementById("frmMain").action="apia.splash.MenuAction.run";
			document.getElementById("frmMain").submit();
		}
		
		function appletResponse(result, message){
			
			if("true"==result){
				continueLogin();
			}else{
				alert(message);
				document.getElementById("frmMain").action="security.LoginAction.do?action=logout";
				document.getElementById("frmMain").submit();
			}
		}
		</script></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD>Proceso de Inicialización</TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><%
				StringBuffer strApplet = new StringBuffer();
				strApplet.append("<applet code='com.apia.sign.Main.class' codebase='" + Parameters.ROOT_PATH + "/digitalSignatureApplet' archive='signedAppletVerify.jar' name='Firma Digital' width='400px' height='180px' >");
				UserData ud = (UserData)request.getSession().getAttribute(Parameters.SESSION_ATTRIBUTE);
				
				strApplet.append("<param name='campoClave' value='"+Parameters.SIGN_SEARCH_ATTRIBUTES+"'>");
				strApplet.append("<param name='rootCAs' value='"+Parameters.SIGN_ROOT_CAs+"'>");
				if(Parameters.SIGN_CHECK_REVOKED){
					strApplet.append("<param name='revListURL' value='/digitalSignatureApplet/checkRevList.jsp'>");
				}
				strApplet.append("<param name='checkCertDate' value='"+Parameters.SIGN_CHECK_DATE+"'>");
				strApplet.append("<param name='certificateId' value='" + ud.getDigitalCertificateUserKey() + "'>");
				strApplet.append("<param name='userId' value='" + ud.getUserId() + "'>");
				strApplet.append("<param name='apiaServer' value='"+Parameters.ROOT_PATH+"'>");
				strApplet.append("<param name='timeURL' value='/digitalSignatureApplet/getServerTime.jsp'>");
				strApplet.append("<param name='lblAppletCertExpired' value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletCertExpired"));strApplet.append("'>");
				strApplet.append("<param name='lblAppletCertNotYetValid' value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletCertNotYetValid"));strApplet.append("'>");
				strApplet.append("<param name='lblAppletCertNotCA'  value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletCertNotCA"));strApplet.append("'>");
				strApplet.append("<param name='lblAppletCertNotFound'  value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletCertNotFound"));strApplet.append("'>");
				strApplet.append("</applet>");
				out.print(strApplet);
				%></FORM></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="continueLogin()" accesskey="C" title="Continuar">Continuar</button></TD></TR></TABLE></body></html><%@include file="../components/scripts/server/endInc.jsp" %>

