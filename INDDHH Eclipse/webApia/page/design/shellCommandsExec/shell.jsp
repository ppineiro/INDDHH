<%@include file="../../includes/startInc.jsp" %><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/js/codemirror/lib/codemirror.css" rel="stylesheet"><link href="<system:util show="context" />/js/codemirror/addon/dialog/dialog.css" rel="stylesheet"><link href="<system:util show="context" />/js/codemirror/addon/hint/show-hint.css" rel="stylesheet"><link href="<system:util show="context" />/js/codemirror/addon/tern/tern.css" rel="stylesheet"><link href="<system:util show="context" />/js/codemirror/theme/eclipse.css" rel="stylesheet"><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/shellCommandsExec/shell.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/API/apiaShellCommands.js"></script><script type="text/javascript" src="<system:util show="context" />/js/codemirror/lib/codemirror.js"></script><script type="text/javascript" src="<system:util show="context" />/js/codemirror/addon/edit/matchbrackets.js"></script><script type="text/javascript" src="<system:util show="context" />/js/codemirror/addon/comment/continuecomment.js"></script><script type="text/javascript" src="<system:util show="context" />/js/codemirror/addon/comment/comment.js"></script><script type="text/javascript" src="<system:util show="context" />/js/codemirror/addon/hint/show-hint.js"></script><script type="text/javascript" src="<system:util show="context" />/js/codemirror/addon/hint/apia-hint.js"></script><script type="text/javascript" src="<system:util show="context" />/js/codemirror/addon/dialog/dialog.js"></script><script type="text/javascript" src="<system:util show="context" />/js/codemirror/addon/search/searchcursor.js"></script><script type="text/javascript" src="<system:util show="context" />/js/codemirror/addon/search/search.js"></script><script type="text/javascript" src="<system:util show="context" />/js/codemirror/addon/tern/tern.js"></script><script type="text/javascript" src="<system:util show="context" />/js/codemirror/mode/javascript/javascript.js"></script><script type="text/javascript" src="<system:util show="context" />/js/tern/acorn/acorn.js"></script><script type="text/javascript" src="<system:util show="context" />/js/tern/acorn/acorn_loose.js"></script><script type="text/javascript" src="<system:util show="context" />/js/tern/acorn/util/walk.js"></script><script type="text/javascript" src="<system:util show="context" />/js/tern/lib/signal.js"></script><script type="text/javascript" src="<system:util show="context" />/js/tern/lib/tern.js"></script><script type="text/javascript" src="<system:util show="context" />/js/tern/lib/def.js"></script><script type="text/javascript" src="<system:util show="context" />/js/tern/lib/comment.js"></script><script type="text/javascript" src="<system:util show="context" />/js/tern/lib/infer.js"></script><script type="text/javascript" src="<system:util show="context" />/js/tern/plugin/doc_comment.js"></script><script type="text/javascript">
			var URL_REQUEST_AJAX 				= '/apia.design.ShellCommandsAction.run';
			var ADDITIONAL_INFO_IN_TABLE_DATA  	= false;
			
			var MSG_EMPTY_COMMAND				= '<system:label show="text" label="msgEmptyComm" />';
			
			var ECMA_FILE_NAME					= 'shellCommEcma5.json';
			var ECMA_URL 						= '<system:util show="context" />/js/codemirror/addon/tern/' + ECMA_FILE_NAME + '?' + TAB_ID_REQUEST;
		</script></head><body><div id="exec-blocker"></div><div class="body" id="bodyDiv"><form id="frmData"><div class="optionsContainer"><div class="fncPanel info"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="title"><system:label show="text" label="mnuExecShellCommands" /><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" data-src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncExecShellComms" /></div><div class="clear"></div></div></div><div class="fncPanel buttons"><div class="title"><system:label show="text" label="mnuOpc" /></div><div class="content"><div id="btnExecute" class="button extendedSize" title="<system:label show="tooltip" label="btnExecute" />"><system:label show="text" label="btnExecute" /></div><div id="btnCleanResults" class="button extendedSize" title="<system:label show="tooltip" label="lblCleanResults" />"><system:label show="text" label="lblCleanResults" /></div><div id="btnCloseTab" class="button extendedSize"  title="<system:label show="tooltip" label="btnClose" />"><system:label show="text" label="btnClose" /></div></div></div><div class="fncPanel options" id="panelShortcuts" style="margin-top: -25px;"><div class="title"><system:label show="text" label="lblShortcuts" /></div><div class="content"><div class="filter"><span class="infoGenData"><b>Ctrl + Enter: </b></span><system:label show="text" label="btnExecute" /><br><span class="infoGenData"><b>Ctrl + <system:label show="text" label="lblSpace" />: </b></span><system:label show="text" label="lblCodeCompletition" /><br><span class="infoGenData"><b>Ctrl + F: </b></span><system:label show="text" label="lblSearch" /><br><span class="infoGenData"><b>Ctrl + G: </b></span><system:label show="text" label="lblSearchNext" /><br><span class="infoGenData"><b>Ctrl + Shift + G: </b></span><system:label show="text" label="lblSearchPrevious" /><br><span class="infoGenData"><b>Ctrl + Shift + F: </b></span><system:label show="text" label="lblReplace" /><br><span class="infoGenData"><b>Ctrl + Shift + R: </b></span><system:label show="text" label="lblNoAskReplace" /><br><span class="infoGenData"><b>Ctrl + Z: </b></span><system:label show="text" label="lblUndo" /><br><span class="infoGenData"><b>Ctrl + Y: </b></span><system:label show="text" label="lblRedo" /><br><span class="infoGenData"><b>Ctrl + I: </b></span><system:label show="text" label="lblVarType" /><br><span class="infoGenData"><b>Alt + .: </b></span><system:label show="text" label="lblVarDef" /><br><span class="infoGenData"><b>Alt + ,: </b></span><system:label show="text" label="lblPrevPos" /><br></div></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="dataContainer"><div class='tabComponent' id="tabComponent"><div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div><!-- DATOS GENERALES --><div class="aTab"><div class="tab" id="tabGenData"><system:label show="text" label="tabDatGen" /></div><div class="contentTab" id="contentTabGenData"><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtDatShellComm" /></div><div class="field fieldFull" id="divShellCommCommand"><label title="<system:label show="tooltip" label="lblCode" />"><system:label show="text" label="lblCode" />:&nbsp;</label><textarea id="shellCommCommand" name="shellCommCommand" maxlength="500" rows="8" class="validate['target:divShellCommCommand']"></textarea></div><div class="field fieldFull" id="divShellCommCommandResults"><label title="<system:label show="tooltip" label="sbtRes" />"><system:label show="text" label="sbtRes" />:</label><div id="shellCommCommandResults" style='width: 100%; height: 330px; overflow-x: hidden; overflow-y: auto; border: 0.5px solid #999999; padding-left: 3px; word-wrap: break-word;'></div></div></div></div></div></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></form></div><!-- MODALS --><%@include file="../../includes/footer.jsp" %></body></html>

