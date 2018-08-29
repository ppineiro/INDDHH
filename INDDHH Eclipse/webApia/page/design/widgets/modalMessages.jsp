<%@include file="../../includes/startInc.jsp" %><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="../../includes/headInclude.jsp" %></head><script type="text/javascript">
	var forType; 
	var mesaggeFormat;
	var defaultMessage;
	
	var URL_REQUEST_AJAX = '/apia.design.WidgetAction.run';
		
	var MSG_WID_NOT_SUBJECT = '<system:label show="text" label="msgWidNotSubject" forHtml="true" forScript="true"/>';
	var MSG_WID_NOT_MESSAGE = '<system:label show="text" label="msgWidNotMessage" forHtml="true" forScript="true"/>'.replace("\"","\\\"");
	
	window.addEvent('domready', function() {
		forType = "<%=request.getParameter("forType")%>";
		mesaggeFormat = "<%=request.getParameter("msgFormat")%>";
		
		var setDefaultMessage = $('setDefaultMessage');
		if (setDefaultMessage){
			setDefaultMessage.addEvent("click",function(e){
				e.stop();
				if (forType == "SUBJECT"){
					$('txtMes').set('value', MSG_WID_NOT_SUBJECT);
				}else {
					$('txtMes').set('value', MSG_WID_NOT_MESSAGE);
				}
			});
		}
	});
	
	var DEFAULT_MESSAGE = "lala";
</script><body><div class="body" id="bodyDiv"><form id="frmParamsDesign" name="frmParamsDesign" style='border: 1px solid #ccc'><div class="dataContainer" style='width:98%; margin-bottom: 0'><div class="fieldGroup"><div class="title"><%if(request.getParameter("forType").equals("SUBJECT")){ %><system:label show="text" label="titMsgSubject" forHtml="true" forScript="true"/><%}else if (request.getParameter("forType").equals("MESSAGE")){ %><system:label show="text" label="titMsgMessage" forHtml="true" forScript="true" /><%}else {%><system:label show="text" label="titMsgNotMessage" forHtml="true" forScript="true" /><%} %></div><div class="fieldGroup"><div class="field extendedSize" style="margin-left: 5px; width:90%;"><%if(request.getParameter("forType").equals("SUBJECT")){ %><label title="<system:label show="tooltip" label="lblTexSubj" />"><system:label show="text" label="lblTexSubj" />:</label><%}else {%><label title="<system:label show="tooltip" label="lblTexMen" />"><system:label show="text" label="lblTexMen" />:</label><%} %><% String mesaggeFormat = request.getParameter("msgFormat");
	  				   if (mesaggeFormat == null || "".equals(mesaggeFormat) || "undefined".equals(mesaggeFormat)){
					   		if ("SUBJECT".equals(request.getParameter("forType"))){%><textarea cols="90" rows="4" name="txtMes" id="txtMes"><system:label show="text" label="msgWidNotSubject" forHtml="true" forScript="true"/></textarea><%}else  {%><textarea cols="90" rows="4" name="txtMes" id="txtMes"><system:label show="text" label="msgWidNotMessage" forHtml="true" forScript="true"/></textarea><%} %><%}else{ %><textarea cols="90" rows="4" name="txtMes" id="txtMes"><%=mesaggeFormat%></textarea><%} %><br><br><%="&lt;WID_NAME>"%><label title="<system:label show="tooltip" label="lblWidName" />"><system:label show="text" label="lblWidName" />:</label><br><%="&lt;WID_ZNE_NAME"%>><label title="<system:label show="tooltip" label="lblWidZneName" />"><system:label show="text" label="lblWidZneName" />:</label><br><%="&lt;WID_VALUE>"%><label title="<system:label show="tooltip" label="lblWidValue" />"><system:label show="text" label="lblWidValue" />:</label><br><br><br><div class="modalOptionsContainer"><div data-helper="true" class="element docAddDocument"><div id="setDefaultMessage" class="option" style="cursor: pointer"><system:label show="text" label="btnDefMes" /></div></div></div></div></div></div></div></form></div></body><script>
//Devuelve los valores ingresados
//Si devuelve null no se cierra el modal
function getModalReturnValue() {
	return $('txtMes').get('value');
}
</script>