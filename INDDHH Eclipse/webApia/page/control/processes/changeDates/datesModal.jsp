
<script type="text/javascript">
	var lblMonInstProNroReg 	= '<system:label show="text" label="lblMonInstProNroReg"/>';
	var lblMonInstProCreDat 	= '<system:label show="text" label="lblMonInstProCreDat"/>';
	var lblMonInstProWarnDat 	= '<system:label show="text" label="lblMonInstProWarnDat"/>';
	var lblMonInstProOverDat 	= '<system:label show="text" label="lblMonInstProOverDat"/>';
	var msgOpCompList			= '<system:label show="text" label="msgOpCompList"/>';
	var VALID_HR				= '<system:label show="text" label="lblValidHr" forScript="true" />';
</script><system:edit show="ifModalNotLoaded" field="datesModal.jsp"><system:edit show="markModalAsLoaded" field="datesModal.jsp" /><div id="dateModalContainer" class="mdlContainer hiddenModal"><div class="mdlHeader"><system:label show="text" label="lblModDate" /></div><div class="mdlBody" id="mdlBodyDates" style="max-height: 500px; overflow: auto;"></div><div class="mdlFooter"><div class="modalButton" id="btnConDatesModal" title="<system:label show="tooltip" label="btnCon" />"><system:label show="text" label="btnCon" /></div><div class="close" id="closeDatesModal" title="<system:label show="tooltip" label="btnCer" />"><system:label show="text" label="btnCer" /></div></div></div></system:edit>