<%@ taglib uri='/WEB-INF/regions.tld' prefix='region' %><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.execution.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><%@page import="sun.misc.BASE64Encoder"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.execution.EntInstanceBean"></jsp:useBean><%
	
	boolean isModal = request.getParameter(com.dogma.DogmaConstants.IN_MODAL)!=null && "true".equals(request.getParameter(com.dogma.DogmaConstants.IN_MODAL));
	boolean showPrint = "true".equals(request.getParameter("showPrint")) || dBean.getCanPrint();

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
%><region:render template='<%=template%>'><region:put section='title'><%=LabelManager.getName(labelSet,"titEjeEnt")%> : <%=beVo.getBusEntTitle()%></region:put><region:put section='divHeight'><%=cmp_div_height%></region:put><region:put section='entityMain'><%@include file="../includes/entityMain.jsp" %></region:put><region:put section='entityRelations'><%@include file="../includes/entityRelations.jsp" %></region:put><region:put section='entityDocuments' content="/programs/documents/documents.jsp?docBean=entity"/><region:put section='entityForms' content="/programs/execution/includes/forms.jsp?frmParent=E"/><region:put section='buttons'><% if (dBean.getCanConfirmUpdate()) { %><%if(Parameters.DIGITAL_SIGN_IN_CLIENT && dBean.hasSignableForms()){%><button id="btnSign" onclick="btnSignData_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSign")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSign")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSign")%></button><%}%><button type="button" id="btnConf" name="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><% } %><%if (dBean.isQueryGoBack()) {%><button type="button" id="btnAnt" name="btnAnt" onclick="btnAnt_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAnt")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAnt")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAnt")%></button><% } %><% if (showPrint || (!isModal && !dBean.isQueryGoBack())) {%><button type="button" onclick="btnPrint_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnStaPri")%>" title="<%=LabelManager.getToolTip(labelSet,"btnStaPri")%>"><%=LabelManager.getNameWAccess(labelSet,"btnStaPri")%></button><% } %><% if (!isModal) {%><button type="button" id="btnBack" name="btnBack" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" id="btnExit" name="btnExit" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button><% } else {%><button type="button" id="btnExit" name="btnExit" onclick="parent.closeWindow('')" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button><% } %><form style="display:none" id="printForm" name="printForm" method="post" action="<%=Parameters.ROOT_PATH%>/frames/print.jsp" target="_blank"><input type="hidden" name="body" id="body"></form></region:put></region:render><iframe id="iframeAjax" name="iframeAjax" style="display:none"></iframe><%if("true".equals(request.getParameter("signApplet"))){%><DIV style='display:none;background-color:white;color:black;position:absolute;top:100px;left:200px;z-index:99;border:solid 1px black' id='divDigitalSign'><iframe id="ifrApplet" frameborder="0" style="width: 430px;height: 210px"></iframe></DIV><%}%><%@include file="../../../components/scripts/server/endInc.jsp" %><script src="<%=Parameters.ROOT_PATH%>/programs/execution/entities/entities.js"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/apiaFunctions.js"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/digitalSignature.js"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/grid/grids.js" DEFER></script><%
String strScript = (String)request.getAttribute("FORM_SCRIPTS");
if(strScript!=null){
	out.println(strScript);
}
%><SCRIPT DEFER>

var signedOK = "true";

var firedByStepBack = false;
var firedByStepNext = false;
var firedByConfirm = true;

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
		}<%}	%><%
	if("true".equals(request.getParameter("signApplet"))){ 
		%>
		
		showAppletModal(); 
		signedOK = "false";
		<%
	}
	%>
}

<%if("true".equals(request.getParameter("signApplet"))){%>
function showAppletModal(){
	document.getElementById("divDigitalSign").style.display='block';
	document.getElementById("ifrApplet").src =  "<%=Parameters.ROOT_PATH%>/digitalSignatureApplet/applet.jsp";
}
<%}%>

function tabSwitch(){
}

var QUERY_GO_BACK = <%= dBean.isQueryGoBack() %>;
var QUERY_ADMIN = <%= dBean.isQueryAdministration() %>;
var SPECIFIC_ADMIN = <%=dBean.isGlobalAdministration()%>; 
var IS_MODAL = <%=isModal%>;
var FROM_URL = <%=fromUrl%>;
var CAN_CONFIRMUPDATE = <%=dBean.getCanConfirmUpdate()%>;

var MSG_REQ_SIGNATURE_FORM = "<%=LabelManager.getName(labelSet,"lblReqSigForm")%>";

function appletConfirmer(result){
	signedOK = result;
	document.getElementById("btnConf").click();
}

function appletCloser(result){
	signedOK = result;
	document.getElementById("divDigitalSign").style.display = "none";
}
 
<%if(dBean.getFirstFocus() != null) {%>
	DONT_SET_FOCUS = <%=!dBean.getFirstFocus()%>;
<%} else {%>
	DONT_SET_FOCUS = <%=!Parameters.DO_SCROLL%>;
<%}%>
var currentLanguage = "<%=currentLanguage%>";
</SCRIPT>
