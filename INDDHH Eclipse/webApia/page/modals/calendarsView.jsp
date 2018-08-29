<script type="text/javascript">
	var URL_REQUEST_AJAX_CALENDAR = '/apia.modals.CalendarViewAction.run';
	var SUNDAY 		= '<system:label show="text" label="lblDomingo" forScript="true" />';
	var MONDAY 		= '<system:label show="text" label="lblLunes" forScript="true" />';
	var TUESDAY 	= '<system:label show="text" label="lblMartes" forScript="true" />';
	var WEDNESDAY 	= '<system:label show="text" label="lblMiercoles" forScript="true" />';
	var THURSDAY 	= '<system:label show="text" label="lblJueves" forScript="true" />';
	var FRIDAY 		= '<system:label show="text" label="lblViernes" forScript="true" />';
	var SATURDAY 	= '<system:label show="text" label="lblSabado" forScript="true" />';
	var LBL_A		= '<system:label show="text" label="lblA" forScript="true" />';
	var LBL_ALL_DAY	= '<system:label show="text" label="lblAllDay" forScript="true" />';
</script>

<system:edit show="ifModalNotLoaded" field="calendars.jsp">
	<system:edit show="markModalAsLoaded" field="calendars.jsp" />
	<div id="mdlCalendarViewContainer" class="mdlContainer hiddenModal">
		
		<div class="mdlHeader">
			<system:label show="text" label="titCal" />
		</div>
	
		<div class="mdlBody" id="mdlBodyCalendar">
			<div class="fieldGroup">
				<div class="title"><system:label show="text" label="txtAnaGenData" /></div>
				
				<div class="field" id="calName">
					<span class="monitor-lbl" title="<system:label show="tooltip" label="lblNom" />"><system:label show="text" label="lblNom" />:</span>
				</div>
				
				<div class="field extendedSize" id="calDesc">
					<span class="monitor-lbl" title="<system:label show="tooltip" label="lblDes" />"><system:label show="text" label="lblDes" />:</span>					
				</div>
			</div>
			
			
			<div class="fieldGroup">
				<div class="title"><system:label show="text" label="sbtDatDayLab" /></div>
			</div>
			
			<div class="gridHeader gridHeaderModal">
				<!-- Cabezal y filtros -->
				<table aria-label="Calendario" title="<system:label show="text" label="sbtDatDayLab" />">
					<thead>
						<tr id="calendarsViewTrOrderBy" class="header">
							<th id="cal1" title="<system:label show="tooltip" label="lblBIDay" />"><div style="width:40%"><system:label show="text" label="lblBIDay" /></div></th>
							<th id="cal2" title="<system:label show="tooltip" label="lblHorario" />"><div style="width:60%"><system:label show="text" label="lblHorario" /></div></th>
						</tr>						
					</thead>
					<tbody>
						<tr><td headers="cal1"></td><td headers="cal2"></td></tr>
					</tbody>
				</table>
			</div>
			<div class="gridBody gridBodyModal" style="overflow-x: hidden !important; height: 150px;">
				<!-- Cuerpo de la tabla -->
				<table aria-label="CalendarioCuerpo" title="<system:label show="text" label="sbtDatDayLab" />">
					<thead>
						<tr>
							<th id="calmdl1" style="width:40%"></th>
							<th id="calmdl2" style="width:60%"></th>
						</tr>
					</thead>
					<tbody class="tableData" id="tableDataDays">
						<tr><td headers="calmdl1"></td><td headers="calmdl2"></td></tr>
					</tbody>
				</table>
			</div>			
			
			<div class="fieldGroup">
				<div class="title"><system:label show="text" label="lblFerDay" /></div>
				
				<div class="field" style="width:100%">										
					<div class="modalOptionsContainer" id="freeDaysContainter">
																						
					</div>
				</div>
			</div>
				
		</div>
			
		<div class="gridFooter">
			<div class="navButtonsOptions">
				<div class="navButton" id="closeModalCalView" style="width: 40px"><system:label show="text" label="lblCloseWindow" /></div>
			</div>
		</div>
	</div>
</system:edit>