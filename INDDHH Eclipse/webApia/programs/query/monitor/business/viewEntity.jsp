<%@page import="com.dogma.bean.query.MonitorBusinessBean"%>
<%@ taglib uri='/WEB-INF/regions.tld' prefix='region' %>
<%@page import="com.dogma.vo.*"%>
<%@page import="com.dogma.bean.execution.*"%>
<%@page import="java.util.*"%>

<%@include file="../../../../components/scripts/server/startInc.jsp" %>

<%@page import="sun.misc.BASE64Encoder"%>

<%
	MonitorBusinessBean monBusMonitorBean = (MonitorBusinessBean) session.getAttribute("dBean");
	EntInstanceBean dBean = monBusMonitorBean.getEntInstanceBean(); 

	BusEntInstanceVo beInstVo = dBean.getEntity();
	BusEntityVo beVo = dBean.getEntityType();
	Collection beRelCol = dBean.getEntityRelations();
	
	EntInstanceBean entityBean = dBean;
	String template = beVo.getBusEntExeTemplate();
	if (template == null) {
		template="/templates/entityDefault.jsp";
	}
	boolean fromUrl = false;
	if(request.getParameter("fromUrl")!=null){
		fromUrl = true;
	}
	
	request.getSession().setAttribute("MCE","false");
	
	
	if(dBean.isPageWithTinyMCE()){
		request.getSession().setAttribute("MCE","true");
	}
%>

	<region:render template='<%=template%>'>
		<region:put section='title'><%=LabelManager.getName(labelSet,"titEjeEnt")%> : <%=beVo.getBusEntTitle()%></region:put>
		<region:put section='divHeight'><%=cmp_div_height%></region:put>
				
		<region:put section='entityMain'><%@include file="/programs/execution/includes/entityMain.jsp" %></region:put>
		<region:put section='entityRelations'><%@include file="/programs/execution/includes/entityRelations.jsp" %></region:put>
		<region:put section='entityDocuments' content="/programs/documents/documents.jsp?docBean=entity"/>

		<region:put section='entityForms' content="/programs/execution/includes/forms.jsp?frmParent=E"/>
		
		<region:put section='buttons'>
		</region:put>

	</region:render>
	
<iframe id="iframeAjax" name="iframeAjax" style="display:none"></iframe>


<%
StringBuffer strApplet = new StringBuffer();
if("true".equals(request.getParameter("signApplet"))){
	HashMap<String,String> data = (HashMap<String,String>)request.getSession().getAttribute("HASH_TO_SIGN"); 
	if(data!=null && data.size() >0){ 
		
		
		 
		strApplet.append("<applet code='com.apia.sign.Sign.class' codebase='" + Parameters.ROOT_PATH + "/digitalSignatureApplet' archive='signedAppletFirma.jar' name='Firma Digital' width='400px' height='180px' >");
		
		BASE64Encoder base64encoder = new BASE64Encoder(); ;
		int i=0;
		Iterator it = data.keySet().iterator();
		while(it.hasNext()){
			String key = (String)it.next();
			String value = (String)data.get(key);
			
			
				try{
					value = base64encoder.encodeBuffer(value.getBytes());
					
				}catch(Exception e){System.out.println(e.getMessage());}
			 	
			
			value = value.replace("\n","");
			value = value.replace("\r","");
																
								
			strApplet.append("<param name='obj_id_" + i + "' value='" + key + "'>");
			strApplet.append("<param name='hash_data_" + i + "' value='" + value + "'>");
			i++;
		}
		
		
		UserData ud = (UserData)request.getSession().getAttribute(Parameters.SESSION_ATTRIBUTE);
		
		strApplet.append("<param name='campoClave' value='"+Parameters.SIGN_SEARCH_ATTRIBUTES+"'>");
		strApplet.append("<param name='rootCAs' value='"+Parameters.SIGN_ROOT_CAs+"'>");
		if(Parameters.SIGN_CHECK_REVOKED){
			strApplet.append("<param name='revListURL' value='/digitalSignatureApplet/checkRevList.jsp'>");
		}
		strApplet.append("<param name='checkCertDate' value='"+Parameters.SIGN_CHECK_DATE+"'>");
		strApplet.append("<param name='certificateId' value='" + ud.getDigitalCertificateUserKey() + "'>");
		strApplet.append("<param name='apiaServer' value='"+Parameters.ROOT_PATH+"'>");
		strApplet.append("<param name='dataReceptor'  value='digitalSignatureApplet/saveSignature.jsp'>");
		strApplet.append("<param name='timeURL' value='/digitalSignatureApplet/getServerTime.jsp'>");
		strApplet.append("<param name='lblAppletSignOK'  value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletSignOK"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletSignErr'  value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletSignErr"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCantSign'  value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletCantSign"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertNotCA'  value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletCertNotCA"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertNotFound'  value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletCertNotFound"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletSigning'  value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletSigning"));strApplet.append("'>");
		strApplet.append("<param name='lblCompTask'  value='");strApplet.append(LabelManager.getName(labelSet,"btnCon"));strApplet.append("'>");
		strApplet.append("<param name='lblExit'  value='");strApplet.append(LabelManager.getName(labelSet,"btnCer"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletPrepareSign' value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletPrepareSign"));strApplet.append("'>");
		strApplet.append("<param name='lblContinue' value='");strApplet.append(LabelManager.getName(labelSet,"btnCont"));strApplet.append("'>");
		strApplet.append("<param name='lblCertPwd' value='");strApplet.append(LabelManager.getName(labelSet,"lblCertPwd"));strApplet.append("'>");
		strApplet.append("<param name='lblTitle' value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletTitle"));strApplet.append("'>");
		strApplet.append("<param name='lblSelectCerts' value='");strApplet.append(LabelManager.getName(labelSet,"lblSelectCerts"));strApplet.append("'>");

		strApplet.append("<param name='lblAppletCertExpired' value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletCertExpired"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertNotYetValid' value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletCertNotYetValid"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertInvPwd' value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletCertInvPwd"));strApplet.append("'>");
		
		strApplet.append("<param name='lblNoCerts' value='");strApplet.append(LabelManager.getName(labelSet,"lblNoCerts"));strApplet.append("'>");
		
		strApplet.append("</applet>");	

		%> 
			<DIV style='background-color:white;color:black;position:absolute;top:100px;left:200px;z-index:99;border:solid 1px black' id='divDigitalSign'>
				
			</DIV>
		<% 		
	}
}	
	%>


<%@include file="../../../../components/scripts/server/endInc.jsp" %>

<script src="<%=Parameters.ROOT_PATH%>/programs/execution/entities/entities.js"></script>
<script src="<%=Parameters.ROOT_PATH%>/scripts/apiaFunctions.js"></script>
<script src="<%=Parameters.ROOT_PATH%>/scripts/digitalSignature.js"></script>
<script src="<%=Parameters.ROOT_PATH%>/scripts/grid/grids.js" DEFER></script>

<%
String strScript = (String)request.getAttribute("FORM_SCRIPTS");
if(strScript!=null){
	out.println(strScript);
}
%>
<SCRIPT DEFER>

var signedOK = "false";

var currentClassE = "";
var currentClassP = "";
internalDivType = "<%=com.dogma.DogmaConstants.SESSION_CMP_HEIGHT%>";
window.onload= function(){
		try{
			frmOnloadE();
		} catch(e){
			if(currentClassE!=""){
				alert("Error in business class '" + currentClassE + "', contact system administrator");
			}
		}
		try{
			frmOnloadP();
		} catch(e){
			if(currentClassP!=""){
				alert("Error in business class " + currentClassP + "', contact system administrator");
			}
		}
	
		<%if("true".equals(request.getParameter("ajax"))){%>
		window.parent.reload("<%=request.getParameter("frmName")%>");
		<%} else if (buffer.length() > 0) {out.print("if (document.addEventListener) {    document.addEventListener('DOMContentLoaded', fnStartDocInit, false);}else{window.document.onreadystatechange=fnStartDocInit;}");
		//modificacion realizada por mleiva para corregir error del tester cam_2026
		%>function fnStartDocInit(){
			if (document.readyState=='complete' || (!MSIE)){
				try {  
					var win=window;
					while(!win.document.getElementById('iframeMessages') && win!=win.parent){
						win=win.parent;
					}
 					if (win.document.getElementById('iframeMessages')) {
						win.document.getElementById('iframeMessages').showMessage(document.getElementById("errorText").value, document.body);
					}else{
						str = document.getElementById("errorText").value;
						if (str.indexOf("</PRE>") != null) {
							str = str.substring(5,str.indexOf("</PRE>"));
						}
						alert(str);
					}
				} catch (e) {
					str = document.getElementById("errorText").value;
					if (str.indexOf("</PRE>") != null) {
						str = str.substring(5,str.indexOf("</PRE>"));
					}
					alert(str);
				}
			}
		}<%}	%>
		
		
		
			<%
	if("true".equals(request.getParameter("signApplet"))){ 
		%>
		
		showAppletModal(); 
		
		<%
	}
	%>
}

<%if("true".equals(request.getParameter("signApplet"))){%>
function showAppletModal(){
	var div = document.getElementById("divDigitalSign").innerHTML = "<%=strApplet%>";
}
<%}%>

function tabSwitch(){
}

var MSG_REQ_SIGNATURE_FORM = "<%=LabelManager.getName(labelSet,"lblReqSigForm")%>";

function appletConfirm(result){
	signedOK = result;
	document.getElementById("btnConf").click();
}

function appletClose(result){
	signedOK = result;
	document.getElementById("divDigitalSign").innerHTML = "";
	document.getElementById("divDigitalSign").style.display = "none";
}

</SCRIPT>

