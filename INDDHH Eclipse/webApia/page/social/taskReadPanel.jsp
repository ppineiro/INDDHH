<script type="text/javascript">
	var APIA_SOCIAL_RENDERED		= true;
	var APIA_SOCIAL_REFRESH_TIME 	= 10 * 1000; //10 segundos 
	var LBL_SHARE 					= "<system:label show='tooltip' label='lblShareMsg' forHtml='true'/>";
	var LBL_CHANNELS				= "<system:label show='text' label='lblChannels' forHtml='true'/>";
	var LBL_DEL_MSG					= "<system:label show='text' label='msgDelMsg' forHtml='true'/>";
	var LBL_SHOW_CHANNELS			= "<system:label show='text' label='lblMsgChns' forHtml='true'/>";
	var TT_SHOW_CHANNELS			= "<system:label show='tooltip' label='lblMsgChns' forHtml='true'/>";
	var TT_REFRESH					= "<system:label show='tooltip' label='lblSocMesRef' forHtml='true'/>";
	var OBJ_CHANNEL_ENVIRONMENT		= '<system:edit show="constant" from="com.dogma.vo.SocMesChannelsVo" field="TYPE_ENVIRONMENT"/>';
	var OBJ_CHANNEL_PROCESS			= '<system:edit show="constant" from="com.dogma.vo.SocMesChannelsVo" field="TYPE_PROCESS"/>';
	var OBJ_CHANNEL_TASK			= '<system:edit show="constant" from="com.dogma.vo.SocMesChannelsVo" field="TYPE_TASK"/>';
	var OBJ_CHANNEL_POOL			= '<system:edit show="constant" from="com.dogma.vo.SocMesChannelsVo" field="TYPE_POOL"/>';
	var OBJ_CHANNEL_USER			= '<system:edit show="constant" from="com.dogma.vo.SocMesChannelsVo" field="TYPE_USER"/>';
	var PRIMARY_SEPARATOR		= new Element('div').set('html', '<system:edit show="constant" from="com.st.util.StringUtil" field="PRIMARY_SEPARATOR"/>').get('text');
</script><div class="fncPanel buttons"><div id="apiaSocialShare" class="apiaSocialShare"></div><div class="title" style=""><system:label show='text' label='lblChnSoc'/><div id="btnApiaSocialRefresh" class="btnApiaSocialRefresh"></div></div><div class="content" style="height: 150px;"><div id="apiaSocialExecPanel" class="apiaSocialExecPanel"><div id="apiaSocialNoMessages" class="apiaSocialNoMessages"><system:label show='text' label='msgNoMessages' forHtml='true'/></div></div></div></div>	
