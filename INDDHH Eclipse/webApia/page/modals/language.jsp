<system:edit show="ifModalNotLoaded" field="language.jsp"><system:edit show="markModalAsLoaded" field="language.jsp" /><div id="mdlLangContainer" class="mdlContainer hiddenModal"><div class="mdlHeader"><system:label show="text" label="titLen" /></div><div class="mdlBody"><div class="gridHeader gridHeaderModal"><!-- Cabezal y filtros --><table><thead><tr id="languageTrOrderBy" class="header"><th id="orderByNameLangMdl" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.LanguageFilterVo" field="ORDER_NAME"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.LanguageFilterVo" field="ORDER_NAME"/>" title="<system:label show="tooltip" label="lblNom" />"><div class="width: 400px"><system:label show="text" label="lblNom" /></div></th></tr><tr class="filter"><th style="width:400px" title="<system:label show="tooltip" label="lblNom" />"><input id="nameFilterLangMdl" type="text" value="" maxlength="255"></th></tr></thead></table></div><div class="gridBody gridBodyModal"><!-- Cuerpo de la tabla --><table><thead><tr><th style="width:400px"></th></tr></thead><tbody class="tableData" id="tableDataLang"></tbody></table></div><div class="gridFooter"><jsp:include page="/page/includes/navButtons.jsp?prefix=Lang"/></div></div></div></system:edit>