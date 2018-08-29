<%@page import="com.dogma.vo.TskSchAttributeVo"%><%@include file="../../includes/startInc.jsp" %><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="../../includes/headInclude.jsp" %><script type="text/javascript" src="<system:util show="context" />/page/design/tskScheduler/edit.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActionsEdition.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/attributes.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/pools.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/tskScheduler/tabProps.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/tskScheduler/tabPerms.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/tskScheduler/tabAtts.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/tskScheduler/tabGenData.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript">
		var ADDITIONAL_INFO_IN_TABLE_DATA  = false;
		var URL_REQUEST_AJAX = '/apia.design.TaskSchedulerAction.run';
		var isAllEnvs = "true";
		var isGlobal = "true";
		var LBL_ALL_ENVS = '<system:label show="text" label="lblTodAmb" forScript="true" />';
		var MSG_SEL_ONE_CAL_FIRST = '<system:label show="text" label="msgSelOneCalFirst" forScript="true" />';
		var MSG_USE_PROY_PERMS = '<system:label show="text" label="msgUseProyPerms" forScript="true" />';
		var MSG_PERM_WILL_BE_LOST = '<system:label show="text" label="msgPermDefWillBeLost" forScript="true" />';
		var MSG_SEL_ONE_TEMP_FIRST = '<system:label show="text" label="msgMstSelTemToErase" forScript="true" />';
		var MSG_DEL_SEL_TEMPLATE  = '<system:label show="text" label="msgDelTemplate" forScript="true" />';
		var MSG_TEMPLATE_SAVED = '<system:label show="text" label="msgTemplateSaved" forScript="true" />';
		var MSG_TSK_SCH_USE_PROY_PERMS = '<system:label show="text" label="msgUseProyReadModPerms" forScript="true" />';
		var MSG_TSK_SCH_PERM_WILL_BE_LOST = '<system:label show="text" label="msgPermReadModWillBeLost" forScript="true" />';
		var LBL_ATT_TYPE_ENTITY = '<system:label show="text" label="lblEnt" forScript="true" />'; 
		var LBL_ATT_TYPE_PROCESS = '<system:label show="text" label="lblPro" forScript="true" />'; 
		var ATT_TYPE_ENTITY = "<%=TskSchAttributeVo.ATT_TYPE_ENTITY%>";
		var ATT_TYPE_PROCESS = "<%=TskSchAttributeVo.ATT_TYPE_PROCESS%>";
		var LBL_TYPE = '<system:label show="text" label="lblType" forScript="true" />';
		var LBL_REQ = '<system:label show="text" label="lblReq" forScript="true" />';
		var MSG_FREC_CHANGE_WARNING = '<system:label show="text" label="msgTskSchFrecWarning" forHtml="true" forScript="true" />';
		var MSG_SCH_PRIV_ERROR = '<system:label show="text" label="msgSchPrivError" forScript="true"  />';
		var INSERT_MODE = "insert";
		var UPDATE_MODE = "update";
		var MSG_EMAILS_ERROR = '<system:label show="text" label="msgSchEmailsError" forScript="true" />';
		var MSG_EMAILS_FORMAT_ERROR = '<system:label show="text" label="msgEmailFailed" forScript="true" />';
		var MSG_SCH_DEF_OVR_ASGN_ERROR = '<system:label show="text" label="msgSchDefOvrasgnError" forScript="true" />';
			
		var ACCESS_PERM_0 = "";
		var ACCESS_PERM_1 = '<system:label show="text" label="lblPerVer" forScript="true" />';
		var ACCESS_PERM_2 = '<system:label show="text" label="lblPerVerMod" forScript="true" />';
		
		var SCHED_PERM_0 = "";
		var SCHED_PERM_1 = '<system:label show="text" label="lblPerCon" forScript="true" />';
		var SCHED_PERM_2 = '<system:label show="text" label="lblPerConReg" forScript="true" />';
		var ACTUAL_MONDAY = "<system:edit show="value" from="theBean" field="actualMonday"/>";
		
	</script><script>
	window.addEvent('domready', function() {
		$('inputSbtExclusionDays').addEvent('change', function() {
			
			var value = this.value;
			
			this.getParent().getElements('input.datePicker').each(function(input) {
				input.set('value', '');
			});	
			
			if(value)
				addExcDayToContainer(value, value);
			
			/*
			var actionElement = new Element('div.actionElement');
			var left = new Element('div.left');
			var text = new Element('div.text');
			var fecha = new Element('div');
			
			fecha.set('html', value);
			
			var right = new Element('div');
			var remove = new Element('div.remove');
			remove.set('html', 'x');
			var div = new Element('div');
			fecha.inject(text);
			div.inject(remove);
			remove.inject(right);
			left.inject(actionElement);
			text.inject(actionElement);
			right.inject(actionElement);
			actionElement.inject(this, 'after');
			
			remove.addEvent('click', function() {
				actionElement.dispose();
			});
			*/
		});
	});
		
	</script></head><body><div id="exec-blocker"></div><div class="body" id="bodyDiv"><form id="frmData"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="text" label="mnuTskScheduler" /><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" data-src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncAdmTskSch" /></div><div class="clear"></div></div></div><%@include file="../../includes/adminActionsEdition.jsp" %><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="dataContainer"><div class='tabComponent' id="tabComponent"><div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div><%@include file="tabGenData.jsp" %><!-- TAB DE DATOS GENERALES --><%@include file="tabAtts.jsp" %><!-- TAB DE ATRIBUTOS- --><%@include file="tabProps.jsp" %><!-- TAB DE PROPIEDADES --><%@include file="tabPerms.jsp" %><!-- TAB DE PERMISOS --></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></form></div><%@include file="../../includes/footer.jsp" %><!-- MODALS --><%@include file="../../modals/attributes.jsp" %><%@include file="../../modals/pools.jsp" %></body></html>

