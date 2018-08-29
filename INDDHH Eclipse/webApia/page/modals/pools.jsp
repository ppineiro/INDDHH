<system:edit show="ifModalNotLoaded" field="pools.jsp">
	<system:edit show="markModalAsLoaded" field="pools.jsp" />
	<div id="mdlPoolContainer" class="mdlContainer hiddenModal" tabIndex="0">
		<div class="mdlHeader"><system:label show="text" label="titGru" /></div>
	
		<div class="mdlBody">
			<div class="gridHeader gridHeaderModal">
				<!-- Cabezal y filtros -->
				<table aria-label="<system:label show="text" label="titGru" /> modal head" title="<system:label show="text" label="titGru" />">
					<thead>
						<tr id="poolsTrOrderBy" class="header">
							<th id="orderByNamePoolMdl" class="allowSort sort<system:filter show="sortStyle" from="biz.statum.apia.vo.filter.PoolFilterVo" field="ORDER_NAME"/>" data-sortBy="<system:edit show="constant" from="biz.statum.apia.vo.filter.PoolFilterVo" field="ORDER_NAME"/>" title="<system:label show="tooltip" label="lblNom" />"><div style="width:180px"><label for="nameFilterPoolMdl"><system:label show="text" label="lblNom" /></label></div></th>
							<th id="orderByDescPoolMdl" class="allowSort sort<system:filter show="sortStyle" from="biz.statum.apia.vo.filter.PoolFilterVo" field="ORDER_EMAIL"/>" data-sortBy="<system:edit show="constant" from="biz.statum.apia.vo.filter.PoolFilterVo" field="ORDER_DESC"/>" title="<system:label show="tooltip" label="lblEma" />"><div style="width:180px"><label for="descFilterPoolMdl"><system:label show="text" label="lblDesc" /></label></div></th>
						</tr>
						<tr class="filter">
							<th><input title="<system:label show="tooltip" label="lblNom" />" id="nameFilterPoolMdl" type="text" value="" maxlength="255"></th>
							<th><input title="<system:label show="tooltip" label="lblDesc" />" id="descFilterPoolMdl" type="text" value="" maxlength="255"></th>
						</tr>
						
					</thead>
					<tbody>							
						<tr><td headers="orderByNamePoolMdl"></td><td headers="orderByDescPoolMdl"></td></tr>														
					</tbody>
				</table>
			</div>
			<div class="gridBody gridBodyModal">
				<!-- Cuerpo de la tabla -->
				<table aria-label="<system:label show="text" label="titGru" /> modal body" title="<system:label show="text" label="titGru" />">
					<thead>
						<tr>
							<th id="gg1" style="width:180px"></th>
							<th id="gg2" style="width:180px"></th>
						</tr>
					</thead>
					<tbody class="tableData" id="tableDataPool">
						<tr><td headers="gg1"></td><td headers="gg2"></td></tr>
					</tbody>
				</table>
			</div>
			<div class="gridFooter">	
				<jsp:include page="/page/includes/navButtons.jsp?prefix=Pool"/>
			</div>
		</div>
	</div>
</system:edit>