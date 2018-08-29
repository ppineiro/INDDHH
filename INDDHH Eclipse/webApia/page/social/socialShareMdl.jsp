<script type="text/javascript">
	var MSG_NO_EMPTY_MSG		= '<system:label show="text" label="msgNoMsgEmpty" />';
	var MSG_MARK_CHANNEL		= '<system:label show="text" label="msgMarkChannel" />';
	var MSG_PUB_OK				= '<system:label show="text" label="msgPubMsgOk" />';
	var MSG_PUB_NO_OK			= '<system:label show="text" label="msgPubMsgNoOk" />';
</script>

<system:edit show="ifModalNotLoaded" field="socialShareMdl.jsp">
	<system:edit show="markModalAsLoaded" field="socialShareMdl.jsp" />
	<div id="mdlSocialShareContainer" class="mdlContainer hiddenModal" tabIndex="0">
		
		<div class="mdlHeader">
			<system:label show="text" label="lblShareMsg" />
		</div>
	
		<div class="mdlBody" id="mdlBodyChn">
			<div class="fieldGroup" id="channels">
				<div class="title"><system:label show="text" label="lblChannels" /></div>								
								
				
			</div>
			
			<div class="fieldGroup">
				<div class="title"><label for="txtToPub"><system:label show="text" label="lblSocMsg" /></label></div>
				<textarea title="<system:label show="text" label="lblSocMsg" />" id="txtToPub" name="txtToPub" rows="4" maxlength="3000" style="resize:none; width: 99%;"></textarea>
			</div>	
		</div>
			
		<div class="mdlFooter footer">
			<div class="modalButton" id="btnPublishMdlSocialShare" tabIndex="0" title="<system:label show="tooltip" label="btnPub" />"><system:label show="text" label="btnPub" /></div>
			<div class="close" id="closeMdlSocialShare" tabIndex="0"><system:label show="text" label="btnCer" /></div>
		</div>
	</div>
</system:edit>