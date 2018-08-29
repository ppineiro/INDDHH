<script type="text/javascript">
	var APIA_SOCIAL_REFRESH_TIME_MDL_CHN= 5 * 1000; //5 segundos 
	var MSG_NO_EMPTY_MSG				= '<system:label show="text" label="msgNoMsgEmpty" />';
	var MSG_CHN_PUB_OK					= '<system:label show="text" label="msgPubMsgOk" />';
	var MSG_CHN_PUB_NO_OK				= '<system:label show="text" label="msgPubMsgNoOk" />';
	var MSG_DEL_MSG						= "<system:label show='text' label='msgDelMsg' forHtml='true'/>";
	var MDL_OBJ_CHANNEL_ENVIRONMENT		= '<system:edit show="constant" from="com.dogma.vo.SocMesChannelsVo" field="TYPE_ENVIRONMENT"/>';
	var MDL_OBJ_CHANNEL_PROCESS			= '<system:edit show="constant" from="com.dogma.vo.SocMesChannelsVo" field="TYPE_PROCESS"/>';
	var MDL_OBJ_CHANNEL_TASK			= '<system:edit show="constant" from="com.dogma.vo.SocMesChannelsVo" field="TYPE_TASK"/>';
	var MDL_OBJ_CHANNEL_POOL			= '<system:edit show="constant" from="com.dogma.vo.SocMesChannelsVo" field="TYPE_POOL"/>';
	var MDL_OBJ_CHANNEL_USER			= '<system:edit show="constant" from="com.dogma.vo.SocMesChannelsVo" field="TYPE_USER"/>';
</script><system:edit show="ifModalNotLoaded" field="socialReadChannelMdl.jsp"><system:edit show="markModalAsLoaded" field="socialReadChannelMdl.jsp" /><div id="mdlReadChannelContainer" class="mdlContainer hiddenModal"><div class="mdlHeader" id="mdlReadChannelTitle"><!-- NOMBRE DEL CANAL --></div><div class="mdlBody" id="chnMdlBody"><div class="fieldGroup" id="chnReader" style="max-height: 250px;"><div id="apiaSocialReadChannel" class="apiaSocialReadModal"><div id="apiaSocialNoMessagesReadChannel" class="apiaSocialNoMessages"><system:label show='text' label='msgNoMessages' forHtml='true'/></div></div></div><br><div class="fieldGroup"><div class="title"><system:label show="text" label="lblSocMsg" /></div><textarea id="chnTxtToPub" name="chnTxtToPub" rows="3" maxlength="3000" style="resize:none; width: 99%;"></textarea></div></div><div class="mdlFooter"><div class="modalButton" id="btnPublishMdlReadChannel" title="<system:label show="tooltip" label="btnPub" />"><system:label show="text" label="btnPub" /></div><div class="close" id="closeMdlReadChannel"><system:label show="text" label="btnCer" /></div></div></div></system:edit>