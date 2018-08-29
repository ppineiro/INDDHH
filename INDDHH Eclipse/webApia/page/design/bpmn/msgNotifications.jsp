<script type="text/javascript">
	var TIT_C = '<system:label show="text" label="titProNotC" forScript="true" />';
	var TIT_E = '<system:label show="text" label="titProNotE" forScript="true" />';
	var TIT_A = '<system:label show="text" label="titProNotA" forScript="true" />';
	var TIT_O = '<system:label show="text" label="titProNotO" forScript="true" />';
	var DEFAULT_MSG_C = '<system:edit show="value" from="theEdition" field="proNotDefaultMessageCreate" />';
	var DEFAULT_MSG_E = '<system:edit show="value" from="theEdition" field="proNotDefaultMessageEnd" />';
	var DEFAULT_MSG_A = '<system:edit show="value" from="theEdition" field="proNotDefaultMessageAlert" />';
	var DEFAULT_MSG_O = '<system:edit show="value" from="theEdition" field="proNotDefaultMessageOverdue" />';
	
	var DEFAULT_SUB_C = '<system:edit show="value" from="theEdition" field="proNotDefaultSubjectCreate" />';
	var DEFAULT_SUB_E = '<system:edit show="value" from="theEdition" field="proNotDefaultSubjectEnd" />';
	var DEFAULT_SUB_A = '<system:edit show="value" from="theEdition" field="proNotDefaultSubjectAlert" />';
	var DEFAULT_SUB_O = '<system:edit show="value" from="theEdition" field="proNotDefaultSubjectOverdue" />';
</script><system:edit show="ifModalNotLoaded" field="msgNotifications.jsp"><system:edit show="markModalAsLoaded" field="msgNotifications.jsp" /><div id="mdlMsgNotificationsContainer" class="mdlContainer hiddenModal"><div class="mdlHeader"><span id="mdlTitle"></span></div><div class="mdlBody" id="mdlBodyNotif"><div class="fieldGroup"><div class="fieldModal"><label title="<system:label show="tooltip" label="lblSubMen" />"><system:label show="text" label="lblSubMen" />:</label><textarea rows="2" cols="90" id="msgSubject"></textarea></div><div class="fieldModal"><label title="<system:label show="tooltip" label="lblTexMen" />"><system:label show="text" label="lblTexMen" />:</label><textarea rows="4" cols="90" id="msgText"></textarea></div></div><div class="fieldGroup"><div class="field extendedSize" style="margin-left: 5px;"><span><system:label show="text" label="lblProMenTok1" /></span><span><system:label show="text" label="lblTskMenTok3" /></span><span><system:label show="text" label="lblProMenTok2" /></span></div></div></div><div class="mdlFooter"><div class="modalButton" id="btnConfirmMsgNotificationsModal" title="<system:label show="text" label="btnCon" />"><system:label show="text" label="btnCon" /></div><div class="modalButtonSecundary" id="btnDefaultMsgNotificationsModal" title="<system:label show="text" label="btnDefMes" />"><system:label show="text" label="btnDefMes" /></div><div class="close" id="closeModalMsgNotifications" title="<system:label show="text" label="btnCer" />"><system:label show="text" label="btnCer" /></div></div></div></system:edit>