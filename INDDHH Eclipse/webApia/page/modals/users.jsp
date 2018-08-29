<system:edit show="ifModalNotLoaded" field="users.jsp">
	<system:edit show="markModalAsLoaded" field="users.jsp" />
	<div id="mdlUsersContainer" class="mdlContainer hiddenModal" tabIndex="0">
		<div class="mdlHeader"><system:label show="text" label="titUsu" /></div>
		<div class="mdlBody">
			<div class="gridHeader gridHeaderModal">
				<!-- Cabezal y filtros -->
				<table aria-label="<system:label show="text" label="titUsu" /> modal head" title="<system:label show="text" label="titUsu" />">
					<thead>
						<tr id="usersTrOrderBy" class="header">
							<th id="orderByLoginUsrMdl" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.UserFilterVo" field="ORDER_LOGIN"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.UserFilterVo" field="ORDER_LOGIN"/>" title="<system:label show="text" label="lblUsu" />"><div style="width: 100px"><label for="loginFilterUsrMdl"><system:label show="text" label="lblUsu"/></label></div></th>
							<th id="orderByNameUsrMdl" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.UserFilterVo" field="ORDER_NAME"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.UserFilterVo" field="ORDER_NAME"/>" title="<system:label show="text" label="lblNom" />"><div style="width: 150px"><label for="nameFilterUsrMdl"><system:label show="text" label="lblNom" /></label></div></th>
							<th id="orderByEmailUsrMdl" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.UserFilterVo" field="ORDER_EMAIL"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.UserFilterVo" field="ORDER_EMAIL"/>" title="<system:label show="text" label="lblEma" />"><div style="width: 150px"><label for="emailFilterUsrMdl"><system:label show="text" label="lblEma" /></label></div></th>
						</tr>
						<tr class="filter">
							<th title="<system:label show="tooltip" label="lblUsu" />"><div style="width: 100px"><input id="loginFilterUsrMdl" type="text" value="" maxlength="255" title="<system:label show="text" label="lblUsu" />"></div></th>
							<th title="<system:label show="tooltip" label="lblNom" />"><div style="width: 150px"><input id="nameFilterUsrMdl" type="text" value="" maxlength="255" title="<system:label show="text" label="lblNom" />"></div></th>
							<th title="<system:label show="tooltip" label="lblEma" />"><div style="width: 150px"><input id="emailFilterUsrMdl" type="text" value="" maxlength="255" title="<system:label show="text" label="lblEma" />"></div></th>
						</tr>
					</thead>
					<tbody>
						<tr><td headers="orderByLoginUsrMdl"></td><td headers="orderByNameUsrMdl"></td><td headers="orderByEmailUsrMdl"></td></tr>
					</tbody>
				</table>
			</div>
			<div class="gridBody gridBodyModal">
				<!-- Cuerpo de la tabla -->
				<table aria-label="<system:label show="text" label="titUsu" /> modal body" title="<system:label show="text" label="titUsu" />">
					<thead>
						<tr>
							<th id="uu1" style="width:100px;"></th>
							<th id="uu2" style="width:150px;"></th>
							<th id="uu3" style="width:150px;"></th>
						</tr>
					</thead>
					<tbody class="tableData" id="tableDataUser">
						<tr><td headers="uu1"></td><td headers="uu2"></td><td headers="uu3"></td></tr>
					</tbody>
				</table>
			</div>
	
			<div class="gridFooter">	
				<jsp:include page="/page/includes/navButtons.jsp?prefix=User"/>
			</div>
		</div>
	</div>
</system:edit>