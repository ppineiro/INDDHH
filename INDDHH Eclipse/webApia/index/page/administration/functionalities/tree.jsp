<%@include file="../../includes/startInc.jsp" %><html><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" ><script type="text/javascript" src="<system:util show="context" />/page/administration/functionalities/tree.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActionsEdition.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX 	= '/apia.administration.FunctionalitiesAction.run';
		var TT_RECOMMENDED		= '<system:label show="tooltip" label="lblRecommended" forScript="true" />';
		var PRIMARY_SEPARATOR	= new Element('div').set('html', '<system:edit show="constant" from="com.st.util.StringUtil" field="PRIMARY_SEPARATOR"/>').get('text');
	</script><style>
		.modalOptionsContainer .optionFunctionalities ul li {
			display: list-item;
			margin-top: 3px;
		}
		.modalOptionsContainer .optionFunctionalities.forceMaxHeight {
			max-height: none !important;
		}
		.modalOptionsContainer .optionFunctionalities ul {
			list-style: none;
		}
		.showChilds, .hideChilds {
			margin: 2px 6px;
		}
	</style></head><body><div class="header"></div><div class="body" id="bodyDiv"><form id="frmData"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><!-- GLOBAL --><system:edit show="ifValue" from="theBean" field="modeGlobal" value="true"><system:label show="tooltip" label="mnuFun" /></system:edit><!-- ENVIRONMENT --><system:edit show="ifValue" from="theBean" field="modeGlobal" value="false"><system:label show="tooltip" label="mnuAmbFun" /></system:edit><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><!-- GLOBAL --><system:edit show="ifValue" from="theBean" field="modeGlobal" value="true"><div id="fncDescriptionText"><system:label show="text" label="dscFncFncs"/></div></system:edit><!-- ENVIRONMENT --><system:edit show="ifValue" from="theBean" field="modeGlobal" value="false"><div id="fncDescriptionText"><system:label show="text" label="dscFncEnvFncs"/></div></system:edit><div class="clear"></div></div></div><%@include file="../../includes/adminActionsEdition.jsp" %><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="dataContainer"><div class='tabComponent' id="tabComponent"><div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div><div class="aTab"><div class="tab"><system:label show="text" label="sbtStruct" /></div><div class="contentTab"><div class="fieldGroup"><div class="title"><system:label show="text" label="titFncTree" /></div><div class="modalOptionsContainer"><div class="optionFunctionalities forceMaxHeight"><ul id="fncsContainer" class="fncContainer"></ul></div></div><input type="hidden" id="confirmTree" name="confirmTree" value="true"/><input type="hidden" id="fncsTree" name="fncsTree" value="" /></div></div></div></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></form></div><%@include file="../../includes/footer.jsp" %></body></html>

