<script type="text/javascript">
	var TIT_ASI = '<system:label show="text" label="titProNotC" forScript="true" />';
	var TIT_COM = '<system:label show="text" label="titProNotE" forScript="true" />';
	var TIT_ACQ = '<system:label show="text" label="titTskNotQ" forScript="true" />';
	var TIT_REL = '<system:label show="text" label="titTskNotR" forScript="true" />';
	var TIT_ALE = '<system:label show="text" label="titTskNotA" forScript="true" />';
	var TIT_OVE = '<system:label show="text" label="titTskNotO" forScript="true" />';
	var TIT_REA = '<system:label show="text" label="titTskNotS" forScript="true" />';
	var TIT_ELE = '<system:label show="text" label="titTskNotV" forScript="true" />';
	var TIT_DEL = '<system:label show="text" label="titTskNotD" forScript="true" />';
	
	var DEFAULT_MSG_ASI = '<system:edit show="value" from="theEdition" field="proNotDefaultMessageAsign" />';
	var DEFAULT_MSG_COM = '<system:edit show="value" from="theEdition" field="proNotDefaultMessageCompleat" />';
	var DEFAULT_MSG_ACQ = '<system:edit show="value" from="theEdition" field="proNotDefaultMessageAcquired" />';
	var DEFAULT_MSG_REL = '<system:edit show="value" from="theEdition" field="proNotDefaultMessageRelease" />';
	var DEFAULT_MSG_ALE = '<system:edit show="value" from="theEdition" field="proNotDefaultMessageAlert" />';
	var DEFAULT_MSG_OVE = '<system:edit show="value" from="theEdition" field="proNotDefaultMessageOverdue" />';
	var DEFAULT_MSG_REA = '<system:edit show="value" from="theEdition" field="proNotDefaultMessageReasign" />';
	var DEFAULT_MSG_ELE = '<system:edit show="value" from="theEdition" field="proNotDefaultMessageElevate" />';
	var DEFAULT_MSG_DEL = '<system:edit show="value" from="theEdition" field="proNotDefaultMessageDelegate" />';
	
	var DEFAULT_SUB_ASI = '<system:edit show="value" from="theEdition" field="tskNotDefaultSubjectAsign" />';
	var DEFAULT_SUB_COM = '<system:edit show="value" from="theEdition" field="tskNotDefaultSubjectCompleat" />';
	var DEFAULT_SUB_ACQ = '<system:edit show="value" from="theEdition" field="tskNotDefaultSubjectAcquired" />';
	var DEFAULT_SUB_REL = '<system:edit show="value" from="theEdition" field="tskNotDefaultSubjectRelease" />';
	var DEFAULT_SUB_ALE = '<system:edit show="value" from="theEdition" field="tskNotDefaultSubjectAlert" />';
	var DEFAULT_SUB_OVE = '<system:edit show="value" from="theEdition" field="tskNotDefaultSubjectOverdue" />';
	var DEFAULT_SUB_REA = '<system:edit show="value" from="theEdition" field="tskNotDefaultSubjectReasign" />';
	var DEFAULT_SUB_ELE = '<system:edit show="value" from="theEdition" field="tskNotDefaultSubjectElevate" />';
	var DEFAULT_SUB_DEL = '<system:edit show="value" from="theEdition" field="tskNotDefaultSubjectDelegate" />';
</script><system:edit show="ifModalNotLoaded" field="msgNotifications.jsp"><system:edit show="markModalAsLoaded" field="msgNotifications.jsp" /><div id="mdlMsgNotificationsContainer" class="mdlContainer hiddenModal"><div class="mdlHeader"><span id="mdlTitle"></span></div><div class="mdlBody" id="mdlBodyMsg"><div class="fieldGroup"><div class="fieldModal"><label title="<system:label show="tooltip" label="lblSubMen" />"><system:label show="text" label="lblSubMen" />:</label><textarea rows="2" cols="90" id="msgSubject"></textarea></div><div class="fieldModal"><label title="<system:label show="tooltip" label="lblTexMen" />"><system:label show="text" label="lblTexMen" />:</label><textarea rows="4" cols="90" id="msgText"></textarea></div></div><div class="fieldGroup"><div class="field extendedSize" style="margin-left: 5px;"><span><system:label show="text" label="lblTskMenTok1" /></span><span><system:label show="text" label="lblTskMenTok3" /></span><span><system:label show="text" label="lblTskMenTok2" /></span></div></div></div><div class="mdlFooter"><div class="modalButton" id="btnConfirmMsgNotificationsModal" title="<system:label show="text" label="btnCon" />"><system:label show="text" label="btnCon" /></div><div class="modalButtonSecundary" id="btnDefaultMsgNotificationsModal" title="<system:label show="text" label="btnDefMes" />"><system:label show="text" label="btnDefMes" /></div><div class="close" id="closeModalMsgNotifications" title="<system:label show="text" label="btnCer" />"><system:label show="text" label="btnCer" /></div></div></div></system:edit>