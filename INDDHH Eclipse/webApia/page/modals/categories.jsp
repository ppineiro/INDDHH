<system:edit show="ifModalNotLoaded" field="categories.jsp"><system:edit show="markModalAsLoaded" field="categories.jsp" /><div id="mdlCatContainer" class="mdlContainer hiddenModal"><div class="mdlHeader"><system:label show="text" label="titEjeCat" /></div><div class="mdlBody"><div class="gridHeader gridHeaderModal"><!-- Cabezal y filtros --><table><thead><tr id="categoriesTrOrderBy" class="header"><th id="orderByNameCatMdl" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.CategoryFilterVo" field="ORDER_NAME"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.CategoryFilterVo" field="ORDER_NAME"/>" title="<system:label show="tooltip" label="lblNom" />"><div class="width: 400px"><system:label show="text" label="lblNom" /></div></th></tr><tr class="filter"><th style="width:400px" title="<system:label show="tooltip" label="lblNom" />"><input id="nameFilterCatMdl" type="text" value="" maxlength="255"></th></tr></thead></table></div><div class="gridBody gridBodyModal"><!-- Cuerpo de la tabla --><table><thead><tr><th style="width:400px"></th></tr></thead><tbody class="tableData" id="tableDataCat"></tbody></table></div><div class="gridFooter"><jsp:include page="/page/includes/navButtons.jsp?prefix=Cat"/></div></div></div></system:edit>