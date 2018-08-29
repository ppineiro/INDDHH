<%@include file="../includes/startInc.jsp" %><html><head><%@include file="../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" /><script type="text/javascript" src="<system:util show="context" />/page/taskslist/list.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript" src="<system:util show="context" />/page/taskslist/tskListColumns.js"></script><script type="text/javascript">
			var URL_REQUEST_AJAX = '/apia.taskslist.TasksListAction.run';
			var ADDITIONAL_INFO_IN_TABLE_DATA  = true;
			var TSK_LST	= '<system:label show="tooltip" label="lblQryTypTas" forScript="true" />';
			var LBL_DROP_TASK = '<system:label show="text" label="lblDropTask" forScript="true" />';
			var FORBID_TSK_TRANSFER = <%="0".equals(Parameters.APIACHAT_TRANSFER_TASK)%>;
			var ERR_TSK_TRANSFER_NOT_IN_CHAT = '<system:label show="text" label="msgTskTransNotInChat" forScript="true" />';
			var PRIMARY_SEPARATOR	= new Element('div').set('html', '<system:edit show="constant" from="com.st.util.StringUtil" field="PRIMARY_SEPARATOR"/>').get('text');
			
			
			var LBL_MUST_SEL_FREE_TSK = '<system:label show="text" label="msgMustSelFreeTsk" forScript="true" />';
			var LBL_MUST_SEL_ACQ_TSK = '<system:label show="text" label="msgMustSeAcqTsk" forScript="true" />';
			
		</script></head><body id="bodyController"><div class="header"></div><div class="body" id="bodyDiv"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="tooltip" label="mnuLisTar" /><%@include file="../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncTskLst"/></div><div class="clear"></div></div></div><div class="fncPanel options"><div class="title"><system:label show="text" label="titActions" /></div><div class="content"><div id="btnWrk" class="button suggestedAction" title="<system:label show="tooltip" label="btnEjeTra" />"><system:label show="text" label="btnEjeTra" /></div><div id="btnCap" class="button" title="<system:label show="tooltip" label="btnAdquireTsk" />"><system:label show="text" label="btnAdquireTsk" /></div><div id="btnRel" class="button" title="<system:label show="tooltip" label="btnEjeLib" />"><system:label show="text" label="btnEjeLib" /></div></div></div><div class="fncPanel options"><div class="title"><system:label show="tooltip" label="mnuOpc" /></div><div class="content"><div id="btnCol" class="button" title="<system:label show="tooltip" label="btnEjeCol" />"><system:label show="text" label="btnEjeCol" /></div><div id="btnExp" class="button" title="<system:label show="text" label="btnExport" />"><system:label show="text" label="btnExport" /></div><!--div id="btnTransfer" class="button" title="<system:label show="text" label="btnTransfer" />"><system:label show="text" label="btnTransfer" /></div--></div></div><!-- CARGAR: FILTROS ADICIONALES --><system:edit show="ifValue" from="theBean" field="hasAdditionallFilters" value="true"><div class="fncPanel options lastOptions"><div class="title" title="<system:label show="tooltip" label="titAdmAdtFilter"/>"><system:label show="text" label="titAdmAdtFilter"/></div><div class="content"><system:edit show="iteration" from="theBean" field="additionalFiltersToShow" saveOn="column"><div class="filter"><span><system:edit show="value" from="column" field="colLabelComplete"/>:</span><system:edit show="value" from="column" field="htmlFilter" avoidHtmlConvert="true"/></div></system:edit></div></div></system:edit><!-- CARGAR: FILTROS OCULTOS --><system:edit show="iteration" from="theBean" field="hiddenFilters" saveOn="column"><system:edit show="value" from="column" field="htmlHiddenFilter" avoidHtmlConvert="true"/></system:edit><!-- FILTROS NO VISIBLES --><div id="noVisibleFiltersPanel" class="fncPanel options" style="display:none"><div class="title"><div id="delAllNVF" class="removeFilter"><system:label show="tooltip" label="lblEjeFilApl" /></div></div><div class="content" id="noVisibleFilters"></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="gridContainer"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /><div class="gridHeader" id="gridHeader"><!-- Cabezal y filtros --><table cellpadding="0" cellspacing="0"><thead><tr id="trOrderBy" class="header"><!-- CARGAR: ORDENAR POR --><system:edit show="iteration" from="theBean" field="columnsToShow" saveOn="column"><th id="<system:edit show="value" from="column" field="colOrderByName"/>" 
											class="allowSort sort<system:edit show="value" from="column" field="sortStyle"/>" 
											sortBy="<system:edit show="value" from="column" field="colOrder"/>" 
											title="<system:edit show="value" from="column" field="colLabelComplete"/>"><div style="width: <system:edit show="value" from="column" field="colWidth"/>"><system:edit show="value" from="column" field="colLabelTitle"/></div></th></system:edit></tr><tr class="filter"><!-- CARGAR: FILTROS --><system:edit show="iteration" from="theBean" field="columnsToShow" saveOn="column"><th title="<system:edit show="value" from="column" field="colLabelComplete"/>"><div style="width: <system:edit show="value" from="column" field="colWidth"/>"><system:edit show="ifValue" from="column" field="colFilterList" value="true"><system:edit show="value" from="column" field="htmlFilter" avoidHtmlConvert="true"/></system:edit></div></th></system:edit></tr></thead></table></div><div class="gridBody" id="gridBody"><!-- Cuerpo de la tabla --><table cellpadding="0" cellspacing="0"><thead><tr><!-- CARGAR: ANCHO COLUMNAS --><system:edit show="iteration" from="theBean" field="columnsToShow" saveOn="column"><th width="<system:edit show="value" from="column" field="colWidth"/>"></th></system:edit></tr></thead><tbody class="tableData" id="tableData"></tbody></table></div><div class="gridFooter"><%@include file="../includes/navButtons.jsp" %></div><!-- MESSAGES --><div class="message hidden" id="messageContainer"></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></div><%@include file="../includes/footer.jsp" %><!-- MODALS --><%@include file="tskListColumns.jsp" %></body></html>
