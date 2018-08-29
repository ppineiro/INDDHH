var kpiTypeSelected; //Usada para volver para atras el cambio de tipo de kpi cuando el usuario selecciona balanza 
						// y no desea perder las zonas, cancelando la accion de cambio de kpi

function initGenDataTab(mode) {

	if ($('cmbType')) {
		$('cmbType').addEvent("change", function(e) {
			onChangeType();
		});
	}
	
	//Combo de Tipo de KPI
	var cmbKpiType = $('cmbKpiType');
	if (cmbKpiType) {
		cmbKpiType.addEvent("change", function(e) {
			if (cmbKpiType.get('value') == WIDGET_KPI_TYPE_GAUGE_VELOCIMETER_ID) {//GAUGE VELOCIMETRO
				selectGaugeVelocimeterKPIType();
			}else if (cmbKpiType.get('value') == WIDGET_KPI_TYPE_GAUGE_OXFORD_ID) {//GAUGE OXFORD
				selectGaugeOxfordKPIType();
			}else if (cmbKpiType.get('value') == WIDGET_KPI_TYPE_RING_ID) {//RING
				selectRingKPIType();
			}else if (cmbKpiType.get('value') == WIDGET_KPI_TYPE_COUNTER_ID) {//CONTADOR
				selectCounterKPIType();
			}else if (cmbKpiType.get('value') == WIDGET_KPI_TYPE_TRAFFIC_LIGHT_ID) {//SEMAFORO
				selectTrafficLightKPIType();
			}else if (cmbKpiType.get('value') == WIDGET_KPI_TYPE_THERMOMETER_ID) {//TERMOMETRO
				var count = selectionCount($('gridZones'));
				if ($('gridZones').rows.length < 3){
					showConfirm(MSG_KPI_THERM_THREE_ZONES, GNR_TIT_WARNING, selectThermometerKPIType, "modalWarning");
				}else if ($('gridZones').rows.length > 3){
					showMessage(MSG_KPI_THERM_MOR_THAN_THREE_ZONES, GNR_TIT_WARNING, 'modalWarning');
					//Dejamos seleccionado el tipo de KPI que estaba antes
					 cmbKpiType.set('value', kpiTypeSelected);
				}else{
					selectThermometerKPIType(true);
				} 
			}else if (cmbKpiType.get('value') == WIDGET_KPI_TYPE_SCALE_ID) { //BALANZA
				var count = selectionCount($('gridZones'));
				if ($('gridZones').rows.length > 0){
					showConfirm(MSG_KPI_SCALE_NO_ZONES,GNR_TIT_WARNING, selectScaleKPIType, "modalWarning");
				}else {
					selectScaleKPIType(true);
				} 
			}
			
		});
	}
	
	//if ($('cmbType').get('value') != WIDGET_TYPE_KPI_ID) {
		onChangeType();
	//}
	
	if (mode==INSERT_MODE) {
		$('txtKpiMin').set('value', 0); //minimo por defecto
		$('txtKpiMax').set('value', 100); //maximo por defecto
		$('divKPIDataPersonalized').style.display = 'none';
		$('kpiBackColor').style.backgroundColor = WHITE_RGB;
		$('kpiBackColor').store('BACKG_COLOR', WHITE_RGB);
		$('kpiPointerColor').style.backgroundColor = ORANGE_RGB; 
		$('kpiPointerColor').store('POINTER_COLOR', ORANGE_RGB);
		$('kpiBackColorHex').set('value', WHITE_HEX);
		$('kpiPointerColorHex').set('value', ORANGE_HEX);
		$('txtKpiValueFontSize').set('value', GAUGE_VELOCIMETER_DEFAULT_VALUE_FONT_SIZE);
		$('txtKpiScaleFontSize').set('value', GAUGE_VELOCIMETER_DEFAULT_SCALE_FONT_SIZE);
		$('cmbKpiValueColor').set('value', 'gray');
		$('cmbKpiNoValueColor').set('value', 'white');
		$('kpiValueColorHex').set('value', GRAY_HEX);
		$('kpiNoValueColorHex').set('value', WHITE_HEX);
		$('seeBorder').setStyle('display', 'none');
		$('valueColor').setStyle('display','none');
		$('noValueColor').setStyle('display','none');
		
		$('tabHistoric').setStyle('display', 'none');
		$('tabOthData').setStyle('display', 'none');
		
		$('titIndicatorSample').set('text', LBL_TITLE);
		$('qryImgIndicatorSample').setStyle('display', 'none');
		$('sonImgIndicatorSample').setStyle('display', 'none');
		$('hisImgIndicatorSample').setStyle('display', 'none');
		$('infImgIndicatorSample').setStyle('display', 'none');
		$('comImgIndicatorSample').setStyle('display', 'none');
		$('refImgIndicatorSample').setStyle('display', 'none');
		$('othCbeImgIndicatorSample').setStyle('display', 'none');
		$('selQryViewType').setStyle('display', 'none');
		$('selCbeViewType').setStyle('display', 'none');
		$('chkViewUpdate').set('checked',true);
			//Como queda chequeado el checkbox de actualizar, ponemos visibles los siguientes campos:
			$('refImgIndicatorSample').setStyle('display', '');
			$('refImgSample').setStyle('display', '');
			
		showChart();
	}else {
		loadWidgetProperties();
		loadZones();
	}
	
	var txtKpiMin = $('txtKpiMin'); 
	if (txtKpiMin) {
		
		Numeric.setNumeric(txtKpiMin, "change");
		
		txtKpiMin.addEvent("focus", function() {
			this.store('KPI_MIN_VALUE', this.get('value'));
		});
		txtKpiMin.addEvent("change", function() {
			kpiMinChange();
		});
	}
	
	var txtKpiMax = $('txtKpiMax'); 
	if (txtKpiMax) {
		
		Numeric.setNumeric(txtKpiMax, "change");
		
		txtKpiMax.addEvent("focus", function() {
			this.store('KPI_MAX_VALUE', this.get('value'));
		});
		txtKpiMax.addEvent("change", function() {
			kpiMaxChange();
		});
	}
	
	var txtKpiValueFontSize = $('txtKpiValueFontSize'); 
	if (txtKpiValueFontSize) {
		
		Numeric.setNumeric(txtKpiValueFontSize, "change");
		
		txtKpiValueFontSize.addEvent("focus", function() {
			this.store('KPI_VALUE_FONT_SIZE', this.get('value'));
		});
		txtKpiValueFontSize.addEvent("change", function() {
			kpiValueFontSizeChange();
		});
	}
	
	var txtKpiScaleFontSize = $('txtKpiScaleFontSize'); 
	if (txtKpiScaleFontSize) {
		
		Numeric.setNumeric(txtKpiScaleFontSize, "change");
		
		txtKpiScaleFontSize.addEvent("focus", function() {
			this.store('KPI_SCALE_FONT_SIZE', this.get('value'));
		});
		txtKpiScaleFontSize.addEvent("change", function() {
			kpiScaleFontSizeChange();
		});
	}
	
	var cmbKpiRingAnchorSize = $('cmbKpiRingAnchorSize');
	if (cmbKpiRingAnchorSize) {
		cmbKpiRingAnchorSize.addEvent("focus", function() {
			this.store('KPI_RING_ANCHOR_SIZE', this.get('value'));
		});
		cmbKpiRingAnchorSize.addEvent("change", function() {
			kpiRingAnchorChange();
		});
	}
	
	var backColorPalette = new MooRainbow('kpiBackColorImg', {
		id: 'backColorPalette',
		'startColor': [80, 80, 80],
		'imgPath': CONTEXT + '/js/colorpicker/images/',
		'onChange': function(color) {
			showChart(color.hex);
		},
		'onComplete': function(color) {
			$('kpiBackColorHex').set('value', color.hex);
			$('kpiBackColor').setStyle('background-color', color.hex);
			$('cmbKpiBackgColor').set('value','');
			showChart();
			this.fireEditionEvent();
		},
		'onCancel':function(color) {
			showChart(); //Refrescamos para que se siga viendo el color que estaba antes
			//Dejamos seteado como color inicial el que estaba antes
			var oldColor = $('kpiBackColorHex').value;
			backColorPalette.manualSet(oldColor.substring(1, oldColor.length),'hex');
		}
	});
	
	var pointerColorPalette = new MooRainbow('kpiPointerColorImg', {
		id: 'pointerColorPalette',
		'startColor': [80, 80, 80],
		'imgPath': CONTEXT + '/js/colorpicker/images/',
		'onChange': function(color) {
			showChart(null, color.hex);
		},
		'onComplete': function(color) {
			$('kpiPointerColorHex').set('value', color.hex);
			$('kpiPointerColor').setStyle('background-color', color.hex);
			$('cmbKpiPointerColor').set('value','');
			showChart();
			this.fireEditionEvent();
		},
		'onCancel':function(color) {
			showChart(); //Refrescamos para que se siga viendo el color que estaba antes
			//Dejamos seteado como color inicial el que estaba antes
			var oldColor = $('kpiPointerColorHex').value;
			pointerColorPalette.manualSet(oldColor.substring(1, oldColor.length),'hex');
		}
	});
	
	var valueColorPalette = new MooRainbow('kpiValueColorImg', {
		id: 'valueColorPalette',
		'startColor': [80, 80, 80],
		'imgPath': CONTEXT + '/js/colorpicker/images/',
		'onChange': function(color) {
			showChart(null, null, color.hex);
		},
		'onComplete': function(color) {
			$('kpiValueColorHex').set('value', color.hex);
			$('kpiValueColor').setStyle('background-color', color.hex);
			$('cmbKpiValueColor').set('value','');
			showChart();
			this.fireEditionEvent();
		},
		'onCancel':function(color) {
			showChart(); //Refrescamos para que se siga viendo el color que estaba antes
			//Dejamos seteado como color inicial el que estaba antes
			var oldColor = $('kpiValueColorHex').value;
			valueColorPalette.manualSet(oldColor.substring(1, oldColor.length),'hex');
		}
	});
	
	var noValueColorPalette = new MooRainbow('kpiNoValueColorImg', {
		id: 'noValueColorPalette',
		'startColor': [80, 80, 80],
		'imgPath': CONTEXT + '/js/colorpicker/images/',
		'onChange': function(color) {
			showChart(null, null, null, color.hex);
		},
		'onComplete': function(color) {
			$('kpiNoValueColorHex').set('value', color.hex);
			$('kpiNoValueColor').setStyle('background-color', color.hex);
			$('cmbKpiNoValueColor').set('value','');
			showChart();
			this.fireEditionEvent();
		},
		'onCancel':function(color) {
			showChart(); //Refrescamos para que se siga viendo el color que estaba antes
			//Dejamos seteado como color inicial el que estaba antes
			var oldColor = $('kpiNoValueColorHex').value;
			noValueColorPalette.manualSet(oldColor.substring(1, oldColor.length),'hex');
		}
	});

	var cmbKpiBackgColor = $('cmbKpiBackgColor'); 
	if (cmbKpiBackgColor) {
		cmbKpiBackgColor.addEvent("change", function () {
			var colorHEX = WHITE_HEX;
			var colorRGB = WHITE_RGB;
			
			if (cmbKpiBackgColor.get('value') == 'blue') {
				colorHEX = BLUE_HEX;
				colorRGB = BLUE_RGB;
			}else if (cmbKpiBackgColor.get('value') == 'red') {
				colorHEX = RED_HEX;
				colorRGB = RED_RGB;
			}else if (cmbKpiBackgColor.get('value') == 'gray') {
				colorHEX = GRAY_HEX;
				colorRGB = GRAY_RGB;
			}
			
			$('kpiBackColorHex').set('value', colorHEX);
			$('kpiBackColor').setStyle('background-color', colorHEX);
			$('kpiBackColor').store('BACKG_COLOR', colorRGB);
			backColorPalette.manualSet(colorHEX.substring(1, colorHEX.length),'hex');
			
			showChart();
		});
	}
	
	var cmbKpiPointerColor = $('cmbKpiPointerColor');
	if (cmbKpiPointerColor) {
		cmbKpiPointerColor.addEvent("change", function () {
			var colorHEX = ORANGE_HEX;
			var colorRGB = ORANGE_RGB;
			
			if (cmbKpiPointerColor.get('value') == 'white') {
				colorHEX = WHITE_HEX;
				colorRGB = WHITE_RGB;
			}else if (cmbKpiPointerColor.get('value') == 'gray') {
				colorHEX = GRAY_HEX;
				colorRGB = GRAY_RGB;
			}else if (cmbKpiPointerColor.get('value') == 'black') {
				colorHEX = BLACK_HEX;
				colorRGB = BLACK_RGB;
			}
			
			$('kpiPointerColorHex').set('value', colorHEX);
			$('kpiPointerColor').setStyle('background-color', colorHEX);
			$('kpiPointerColor').store('POINTER_COLOR', colorRGB);
			pointerColorPalette.manualSet(colorHEX.substring(1, colorHEX.length),'hex');
			
			showChart();
		});
	}
	
	var cmbKpiValueColor = $('cmbKpiValueColor');
	if (cmbKpiValueColor) {
		cmbKpiValueColor.addEvent("change", function () {
			var colorHEX = BLACK_HEX;
			var colorRGB = BLACK_RGB;
			
			if (cmbKpiValueColor.get('value') == 'white') {
				colorHEX = WHITE_HEX;
				colorRGB = WHITE_RGB;
			}else if (cmbKpiValueColor.get('value') == 'blue') {
				colorHEX = BLUE_HEX;
				colorRGB = BLUE_RGB;
			}else if (cmbKpiValueColor.get('value') == 'gray') {
				colorHEX = GRAY_HEX;
				colorRGB = GRAY_RGB;
			}else if (cmbKpiValueColor.get('value') == 'red') {
				colorHEX = RED_HEX;
				colorRGB = RED_RGB;
			}
			
			$('kpiValueColorHex').set('value', colorHEX);
			$('kpiValueColor').setStyle('background-color', colorHEX);
			$('kpiValueColor').store('VALUE_COLOR', colorRGB);
			valueColorPalette.manualSet(colorHEX.substring(1, colorHEX.length),'hex');
			
			showChart();
		});
	}
	
	var cmbKpiNoValueColor = $('cmbKpiNoValueColor');
	if (cmbKpiNoValueColor) {
		cmbKpiNoValueColor.addEvent("change", function () {
			var colorHEX = WHITE_HEX;
			var colorRGB = WHITE_RGB;
			
			if (cmbKpiNoValueColor.get('value') == 'black') {
				colorHEX = BLACK_HEX;
				colorRGB = BLACK_RGB;
			}else if (cmbKpiNoValueColor.get('value') == 'blue') {
				colorHEX = BLUE_HEX;
				colorRGB = BLUE_RGB;
			}else if (cmbKpiNoValueColor.get('value') == 'gray') {
				colorHEX = GRAY_HEX;
				colorRGB = GRAY_RGB;
			}else if (cmbKpiNoValueColor.get('value') == 'red') {
				colorHEX = RED_HEX;
				colorRGB = RED_RGB;
			}
			
			$('kpiNoValueColorHex').set('value', colorHEX);
			$('kpiNoValueColor').setStyle('background-color', colorHEX);
			$('kpiNoValueColor').store('VALUE_COLOR', colorRGB);
			valueColorPalette.manualSet(colorHEX.substring(1, colorHEX.length),'hex');
			
			showChart();
		});
	}
	
	var kpiBackColorHex = $('kpiBackColorHex'); 
	if (kpiBackColorHex) {
		kpiBackColorHex.addEvent("change", function () {
			var colorHex = kpiBackColorHex.get('value');
			$('kpiBackColor').setStyle('background-color', colorHex);
			backColorPalette.manualSet(colorHex.substring(1, colorHex.length),'hex');
			cmbKpiBackgColor.set('value', "");
			showChart(colorHex);
		});
	}
	
	var chkOpenOthQry = $('chkOpenOthQry'); 
	if (chkOpenOthQry) {
		chkOpenOthQry.addEvent("click", function () {
			if (chkOpenOthQry.get('checked')) {
				$('divSrcOthUserQry').setStyle('display', '');
				$('othQryImgSample').setStyle('display', '');
			}else {
				$('divSrcOthUserQry').setStyle('display', 'none');
				$('othQryImgSample').setStyle('display', 'none');
			}
		});
	}
	
	var kpiPointerColorHex = $('kpiPointerColorHex'); 
	if (kpiPointerColorHex) {
		kpiPointerColorHex.addEvent("change", function () {
			var colorHex = kpiPointerColorHex.get('value');
			$('kpiPointerColor').setStyle('background-color', colorHex);
			pointerColorPalette.manualSet(colorHex.substring(1, colorHex.length),'hex');
			cmbKpiPointerColor.set('value', "");
			showChart(null, colorHex);
		});
	}		
	
	var chkViewSons = $('chkViewSons'); 
	if (chkViewSons) {
		chkViewSons.addEvent("click", function () {
			if (chkViewSons.get('checked')) {
				$('dshChild').set('disabled', false);
				$('sonImgIndicatorSample').setStyle('display', '');
				$('sonImgSample').setStyle('display', '');
			}else {
				$('dshChild').set('value','');
				$('dshChild').set('disabled', true);
				$('sonImgIndicatorSample').setStyle('display', 'none');
				$('sonImgSample').setStyle('display', 'none');
			}
		});
	}
	
	var chkViewHist = $('chkViewHist'); 
	if (chkViewHist) {
		chkViewHist.addEvent("click", function () {
			if (chkViewHist.get('checked')) {
				$('tabHistoric').setStyle('display', '');
				$('hisImgIndicatorSample').setStyle('display', '');
			}else {
				$('tabHistoric').setStyle('display', 'none');
				$('hisImgIndicatorSample').setStyle('display', 'none');
			}
		});
	}
	
	var chkViewInfo = $('chkViewInfo'); 
	if (chkViewInfo) {
		chkViewInfo.addEvent("click", function () {
			if (chkViewInfo.get('checked')) {
				$('tabOthData').setStyle('display', '');
				$('infImgIndicatorSample').setStyle('display', '');
				$('infImgSample').setStyle('display', '');
			}else {
				$('tabOthData').setStyle('display', 'none');
				$('infImgIndicatorSample').setStyle('display', 'none');
				$('infImgSample').setStyle('display', 'none');
			}
		});
	}
	
	var chkOpenOthCbe = $('chkOpenOthCbe'); 
	if (chkOpenOthCbe) {
		chkOpenOthCbe.addEvent("click", function () {
			if (chkOpenOthCbe.get('checked')) {
				$('divSrcOthCubeView').setStyle('display', '');
				$('othCbeImgSample').setStyle('display', '');
				$('othCbeImgIndicatorSample').setStyle('display', '');
			}else {
				$('divSrcOthCubeView').setStyle('display', 'none');
				$('othCbeImgSample').setStyle('display', 'none');
				$('othCbeImgIndicatorSample').setStyle('display', 'none');
			}
		});
	}
	
	var chkOpenOthQry= $('chkOpenOthQry'); 
	if (chkOpenOthQry) {
		chkOpenOthQry.addEvent("click", function () {
			if (chkOpenOthQry.get('checked')) {
				$('divSrcOthUserQry').setStyle('display', '');
				$('othQryImgSample').setStyle('display', '');
				$('othQryImgIndicatorSample').setStyle('display', '');
			}else {
				$('divSrcOthUserQry').setStyle('display', 'none');
				$('othQryImgSample').setStyle('display', 'none');
				$('othQryImgIndicatorSample').setStyle('display', 'none');
			}
		});
	}
	
	var chkViewComm = $('chkViewComments'); 
	if (chkViewComm) {
		chkViewComm.addEvent("click", function () {
			if (chkViewComm.get('checked')) {				
				$('comImgIndicatorSample').setStyle('display', '');
				$('comImgSample').setStyle('display', '');
			}else {				
				$('comImgIndicatorSample').setStyle('display', 'none');
				$('comImgSample').setStyle('display', 'none');
			}
		});
	}
	
	var chkViewUpd = $('chkViewUpdate'); 
	if (chkViewUpd) {
		chkViewUpd.addEvent("click", function () {
			if (chkViewUpd.get('checked')) {				
				$('refImgIndicatorSample').setStyle('display', '');
				$('refImgSample').setStyle('display', '');
			}else {
				$('refImgIndicatorSample').setStyle('display', 'none');
				$('refImgSample').setStyle('display', 'none');
			}
		});
	}
	
	var chkOpenQry = $('chkOpenQry'); 
	if (chkOpenQry) {
		chkOpenQry.addEvent("click", function () {
			if (chkOpenQry.get('checked')) {
				$('qryImgIndicatorSample').setStyle('display', '');
			}else {
				$('qryImgIndicatorSample').setStyle('display', 'none');
			}
		});
	}
	
	var cmbKpiValueType = $('cmbKpiValueType');
	if (cmbKpiValueType){
		cmbKpiValueType.addEvent("change", function () {
			if (cmbKpiValueType.get('value') == 0) {
				cmbKpiValueDecimals.set('value', 0);
				cmbKpiValueDecimals.set('disabled', true);
				txtKpiMin.set('disabled', false);
				txtKpiMax.set('disabled', false);
			}else {
				cmbKpiValueDecimals.set('disabled', false);
				if (cmbKpiValueType.get('value')==2){ //Si eligio %
					txtKpiMin.set('value', 0);
					txtKpiMin.set('disabled', true);
					txtKpiMax.set('value', 100);
					txtKpiMax.set('disabled', true);
				}else {
					txtKpiMin.set('disabled', false);
					txtKpiMax.set('disabled', false);
				}
			}
			showChart();
		});
	}
	
	var cmbQryViewType = $('cmbQryViewType');
	if (cmbQryViewType) {
		cmbQryViewType.addEvent("change", function() {
			setQrySettings();
		});
	}
	
	var cmbCbeViewType = $('cmbCbeViewType');
	if (cmbCbeViewType) {
		cmbCbeViewType.addEvent("change", function() {
			setCbeSettings();
		});
	}
	
	var cmbKpiValueDecimals = $('cmbKpiValueDecimals');
	if (cmbKpiValueDecimals){
		cmbKpiValueDecimals.addEvent("change", function() {
			showChart();
		});
	}
	
	var chkSeeBorder = $('chkSeeBorder');
	if (chkSeeBorder){
		chkSeeBorder.addEvent("click", function() {
			showChart();
		});
	}
	
	//Seteamos la accion de boton agregar zonas
	var btnAddZone = $('btnAddZone');
	if (btnAddZone){
		btnAddZone.addEvent("click",function(e){
			e.stop();
			fncZoneChanged();
			btnAddZone_click();
		});
	}
	
	//Seteamos la accion de boton eliminar info de la grilla de zonas
	var btnDeleteZone = $('btnDelZone');
	if (btnDeleteZone){
		btnDeleteZone.addEvent("click",function(e){
			e.stop();
			fncZoneChanged();
			var gridZones = $('gridZones');
			var count = selectionCount(gridZones);
			if(count==0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (count>1){
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			}else{
				if ($('cmbKpiType').get('value') == WIDGET_KPI_TYPE_THERMOMETER_ID) {
					showMessage(MSG_KPI_THERM_NEED_THREE_ZONES, GNR_TIT_WARNING, 'modalWarning');
				}else {
					deleteRow('gridZones');
					resetZones(); //reseteamos minimos y maximos de las zonas para que concuerden
					Scroller2 = addScrollTable(gridZones); //Agregamos el scroll de la grilla de zonas
				}
			} 
		});
	}
	
	//Seteamos la accion del boton de subir en la grilla de zonas
	var btnUpZone = $('btnUpZone');
	if (btnUpZone) {
		btnUpZone.addEvent("click", function(e){
			e.stop();
			var row = upRow('gridZones');
			if (row && Scroller2 && Scroller2.v){
				Scroller2.v.showElement(row);
			}
		});
	}
	
	//Seteamos la accion del boton de bajar en la grilla de zonas
	var btnDownZone = $('btnDownZone');
	if (btnDownZone) {
		btnDownZone.addEvent("click", function(e){
			e.stop();
			var row = downRow('gridZones');
			if (row && Scroller2 && Scroller2.v){
				Scroller2.v.showElement(row);
			}
		});
	}
	
	//Inicializamos los colores con los cuales se deben levantar los colorPickers
	if ($('kpiBackColorHex')){
		var backColor = $('kpiBackColorHex').value;
		if (backColor != "") backColorPalette.manualSet(backColor.substring(1, backColor.length),'hex');
	}
	if ($('kpiPointerColorHex')){
		var pointerColor = $('kpiPointerColorHex').value;
		if (pointerColor != "") pointerColorPalette.manualSet(pointerColor.substring(1, pointerColor.length),'hex');
	}
	if ($('kpiValueColorHex')){
		var valueColor = $('kpiValueColorHex').value;
		if (valueColor != "") valueColorPalette.manualSet(valueColor.substring(1, valueColor.length),'hex');
	}
	if ($('kpiNoValueColorHex')){
		var noValueColor = $('kpiNoValueColorHex').value;
		if (noValueColor != "") noValueColorPalette.manualSet(noValueColor.substring(1, noValueColor.length),'hex');
	}
	
	
	kpiTypeSelected = cmbKpiType.get('value');
	
	$('widTitle').addEvent('change', function() {
		$('titIndicatorSample').set('text', this.get('value'));
	});
	
//	setTimeout(showChart, 1000);
}

function selectGaugeVelocimeterKPIType() {
	$('backgroundColor').setStyle('display', '');
	$('pointerColor').setStyle('display', '');
	$('ringAnchorSize').setStyle('display','none');
	$('valueColor').setStyle('display','none');
	$('noValueColor').setStyle('display','none');
	$('fontSizes').setStyle('display','');
	$('scaleFontSize').setStyle('display','');
	$('txtKpiValueFontSize').set('value', GAUGE_VELOCIMETER_DEFAULT_VALUE_FONT_SIZE);
	$('txtKpiScaleFontSize').set('value', GAUGE_VELOCIMETER_DEFAULT_SCALE_FONT_SIZE);
	$('seeBorder').setStyle('display', 'none');
	$('ifrIndicatorSample').setStyle('width', 220);
	kpiTypeSelected = WIDGET_KPI_TYPE_GAUGE_VELOCIMETER_ID;
	enableDisableZonesDiv(true); //Habilitamos DIVS de zonas y acciones
	showChart(); //Es necesario que este aqui, no sacar para afuera
}

function selectGaugeOxfordKPIType() {
	$('backgroundColor').setStyle('display', 'none');
	$('pointerColor').setStyle('display', '');
	$('ringAnchorSize').setStyle('display','none');
	$('valueColor').setStyle('display','none');
	$('noValueColor').setStyle('display','none');
	$('fontSizes').setStyle('display','');
	$('scaleFontSize').setStyle('display','none');
	$('txtKpiValueFontSize').set('value', GAUGE_OXFORD_DEFAULT_VALUE_FONT_SIZE);
	$('seeBorder').setStyle('display', 'none');
	$('ifrIndicatorSample').setStyle('width', 220);
	kpiTypeSelected = WIDGET_KPI_TYPE_GAUGE_OXFORD_ID;
	enableDisableZonesDiv(true); //Habilitamos DIVS de zonas y acciones
	showChart();//Es necesario que este aqui, no sacar para afuera
}

function selectRingKPIType() {
	$('backgroundColor').setStyle('display', 'none');
	$('pointerColor').setStyle('display', 'none');
	$('fontSizes').setStyle('display','');
	$('ringAnchorSize').setStyle('display','');
	$('valueColor').setStyle('display','');
	$('noValueColor').setStyle('display','');
	$('scaleFontSize').setStyle('display','none');
	$('txtKpiValueFontSize').set('value', GAUGE_OXFORD_DEFAULT_VALUE_FONT_SIZE);
	$('seeBorder').setStyle('display', 'none');
	$('ifrIndicatorSample').setStyle('width', 220);
	kpiTypeSelected = WIDGET_KPI_TYPE_RING_ID;
	enableDisableZonesDiv(true); //Habilitamos DIVS de zonas y acciones
	showChart();//Es necesario que este aqui, no sacar para afuera
}

function selectCounterKPIType() {
	$('backgroundColor').setStyle('display', 'none');
	$('pointerColor').setStyle('display', 'none');
	$('valueColor').setStyle('display','none');
	$('noValueColor').setStyle('display','none');
	$('ringAnchorSize').setStyle('display','none');
	$('fontSizes').setStyle('display','');
	$('scaleFontSize').setStyle('display','none');
	$('txtKpiValueFontSize').set('value', COUNTER_DEFAULT_VALUE_FONT_SIZE);
	$('seeBorder').setStyle('display', '');
	$('ifrIndicatorSample').setStyle('width', 220);
	kpiTypeSelected = WIDGET_KPI_TYPE_COUNTER_ID;
	enableDisableZonesDiv(true); //Habilitamos DIVS de zonas y acciones
	showChart();//Es necesario que este aqui, no sacar para afuera
}

function selectTrafficLightKPIType() {
	$('backgroundColor').setStyle('display', 'none');
	$('pointerColor').setStyle('display', 'none');
	$('valueColor').setStyle('display','');
	$('noValueColor').setStyle('display','none');
	$('ringAnchorSize').setStyle('display','none');
	$('fontSizes').setStyle('display','');
	$('scaleFontSize').setStyle('display','none');
	$('txtKpiValueFontSize').set('value', TRAFFIC_LIGHT_DEFAULT_VALUE_FONT_SIZE);
	$('seeBorder').setStyle('display', '');
	$('ifrIndicatorSample').setStyle('width', 220);
	kpiTypeSelected = WIDGET_KPI_TYPE_TRAFFIC_LIGHT_ID;
	enableDisableZonesDiv(true); //Habilitamos DIVS de zonas y acciones
	showChart();//Es necesario que este aqui, no sacar para afuera
}

//Setea la pantalla para las props del kpi de tipo balanza (si result es true)
function selectScaleKPIType(result) {
	if (result) {
		$('backgroundColor').setStyle('display', 'none');
		$('pointerColor').setStyle('display', '');
		$('ringAnchorSize').setStyle('display','none');
		$('valueColor').setStyle('display','none');
		$('noValueColor').setStyle('display','none');
		$('fontSizes').setStyle('display','');
		$('txtKpiValueFontSize').set('value', SCALE_DEFAULT_VALUE_FONT_SIZE);
		$('txtKpiScaleFontSize').set('value', SCALE_DEFAULT_SCALE_FONT_SIZE);
		$('scaleFontSize').setStyle('display','');
		$('seeBorder').setStyle('display', 'none');
		$('ifrIndicatorSample').setStyle('width', 280);
		
		$('gridZones').getElements('TR').destroy(); //Vaciamos la grilla de zonas
		$('gridZoneActions').getElements('TR').destroy(); //Vaciamos la grilla de acciones
		
		enableDisableZonesDiv(false); //Deshabilitamos DIVS de zonas y acciones
		kpiTypeSelected = WIDGET_KPI_TYPE_SCALE_ID;
		showChart();
	 }else {
		 //Dejamos seleccionado el tipo de KPI que estaba antes
		 var cmbKpiType = $('cmbKpiType');
		 cmbKpiType.set('value', kpiTypeSelected);
	 }
}

function selectThermometerKPIType(result) {
	if (result) {
		var gridZones = $('gridZones');
		if (gridZones.rows.length < 3 || gridZones.rows.length > 3){
			fixKPIThermZones();
		}
		
		$('backgroundColor').setStyle('display', 'none');
		$('pointerColor').setStyle('display', 'none');
		$('valueColor').setStyle('display','none');
		$('noValueColor').setStyle('display','none');
		$('ringAnchorSize').setStyle('display','none');
		$('fontSizes').setStyle('display','');
		$('scaleFontSize').setStyle('display','none');
		$('txtKpiValueFontSize').set('value', THERMOMETER_DEFAULT_VALUE_FONT_SIZE);
		$('seeBorder').setStyle('display', 'none');
		$('ifrIndicatorSample').setStyle('width', 220);
		kpiTypeSelected = WIDGET_KPI_TYPE_THERMOMETER_ID;
		enableDisableZonesDiv(true); //Habilitamos DIVS de zonas y acciones
		showChart();//Es necesario que este aqui, no sacar para afuera
	}else {
		 //Dejamos seleccionado el tipo de KPI que estaba antes
		var cmbKpiType = $('cmbKpiType'); 
		cmbKpiType.set('value', kpiTypeSelected);
	}
}

//Hace que hayan exactamente 3 zonas para el kpi de tipo termometro
function fixKPIThermZones() {
	var kpiMin = $('txtKpiMin').get('value');
	var kpiMax = $('txtKpiMax').get('value');
	
	var gridZones = $('gridZones');
	var cantZones = gridZones.rows.length;
	
	if (cantZones < 3){ //Hay menos de 3 zonas
		for (var i= cantZones; i<3; i++){
			fncAddZone();
			resetZones();
		}	
	}else { //Hay mas de 3 zonas
		for (var i= cantZones; i>3; i--){
			var trows= gridZones.rows;
			deleteRow(trows[i]);
			resetZones();
		}
	}
	
	showChart();
}

//Habilita/deshabilita los botones de la grilla de zonas y acciones
function enableDisableZonesDiv(op) {
	if (op) {
		var kpiType = $('cmbKpiType').get('value'); 
		if (kpiType != WIDGET_KPI_TYPE_SCALE_ID){
			$('zonesDIV').setStyle('display', '');
			$('tabActions').setStyle('display', '');
		}
	}else {
		$('zonesDIV').setStyle('display', 'none');
		$('tabActions').setStyle('display', 'none');
	}
}

//recorre las zonas y ajusta los minimos y maximos
function resetZones(){
	var kpiMin = $('txtKpiMin').get('value');
	var kpiMax = $('txtKpiMax').get('value');
	var gridZones = $('gridZones');
	if (gridZones.rows.length > 0){
		var trows= gridZones.rows;
		for (var i=0;i<trows.length;i++) {
			var zneMin = trows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value;
			var zneMax = trows[i].getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[0].value;
			
			if (i==0){//Si estamos en la primer zona 
				//Seteamos el minimo del kpi como minimo de la zona
				trows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value = kpiMin;
			}
			
			if (i+1 == trows.length) {	//Si estamos en la ultima zona 
				//Seteamos el maximo del kpi como maximo de la zona
				trows[i].getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[0].value = kpiMax;
			}else {
				var nextZneMin = trows[i+1].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value;
				var nextZneMax = trows[i+1].getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[0].value;
				
				trows[i+1].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value = zneMax;
			}
		}
	}
}

function kpiMinChange() {
	var txtKpiMin = $('txtKpiMin');
	var txtKpiMax = $('txtKpiMax');
	var minValue = txtKpiMin.get('value');
	var maxValue = txtKpiMax.get('value');
	
	if ('' == minValue) {
		txtKpiMin.set('value', txtKpiMin.retrieve('KPI_MIN_VALUE'));
		var funcAux = function(){
			element.focus();
		}
		setTimeout(funcAux,100);
	} else if (minValue >= maxValue){
		txtKpiMin.set('value', txtKpiMin.retrieve('KPI_MIN_VALUE'));
		var funcAux = function(){
			element.focus();
		}
		setTimeout(funcAux,100);
	} else {
		showChart();		
	}
}

function kpiMaxChange() {
	var txtKpiMin = $('txtKpiMin');
	var txtKpiMax = $('txtKpiMax');
	var minValue = txtKpiMin.get('value');
	var maxValue = txtKpiMax.get('value');
	
	if ('' == txtKpiMax.get('value')) {
		txtKpiMax.set('value', txtKpiMax.retrieve('KPI_MAX_VALUE'));
		var funcAux = function(){
			element.focus();
		}
		setTimeout(funcAux,100);
	} else if (minValue >= maxValue){
		txtKpiMax.set('value', txtKpiMax.retrieve('KPI_MAX_VALUE'));
		var funcAux = function(){
			element.focus();
		}
		setTimeout(funcAux,100);
	} else {	
		showChart();		
	}
}

function kpiValueFontSizeChange() {
	if ('' == $('txtKpiValueFontSize').get('value')) {
		$('txtKpiValueFontSize').set('value', $('txtKpiValueFontSize').retrieve('KPI_VALUE_FONT_SIZE'));
		var funcAux = function(){
			element.focus();
		}
		setTimeout(funcAux,100);
	} else {					
		showChart();		
	}
}

function kpiScaleFontSizeChange() {
	if ('' == $('txtKpiScaleFontSize').get('value')) {
		$('txtKpiScaleFontSize').set('value', $('txtKpiScaleFontSize').retrieve('KPI_SCALE_FONT_SIZE'));
		var funcAux = function(){
			element.focus();
		}
		setTimeout(funcAux,100);
	} else {					
		showChart();		
	}
}

function kpiRingAnchorChange() {
	showChart();		
}

//function getRGBColor(colorHex){
//	var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(colorHex);
//	if (result==null) return "";
//	var rgb = "rgb(" + parseInt(result[1],16) + "," + parseInt(result[2], 16) + "," + parseInt(result[3], 16) + ")";
//	return rgb;
//}


function showChart(backColor, pointerColor, valueColor, noValueColor) {	
	if (backColor==null) backColor = $('kpiBackColorHex').get('value');
	if (pointerColor==null) pointerColor = $('kpiPointerColorHex').get('value');
	if (valueColor==null) valueColor = $('kpiValueColorHex').get('value');
	if (noValueColor==null) noValueColor = $('kpiNoValueColorHex').get('value');
	
	var zones = getZones(); //ejemplo: 0-10-rgb(120,120,120)-100;10-26-rgb(255,255,0)-244
	var value = getValueToShow(); //Segun la zona seleccionada
	var indType = $('cmbKpiType').get('value');
	if (indType == WIDGET_KPI_TYPE_THERMOMETER_ID && $('gridZones').rows.length != 3){
		$('ifrIndicatorSample').set('src', '');
	}else {
		try {
			var formChecker = $('frmData').formChecker;
			var validData = true; 
			
			var mins = $('gridZones').getElements('[name=zneMin');
			var maxs = $('gridZones').getElements('[name=zneMax');
			
			for(var m=0; validData && m<mins.length; m++){
				validData = formChecker.manageError(mins[m],'testonly');
			}
			
			for(var m=0; validData && m<maxs.length; m++){
				validData = formChecker.manageError(maxs[m],'testonly');
			}
			
			if (validData)			
				$('ifrIndicatorSample').set('src', 'page/design/widgets/indicatorSample.jsp?indType=' + indType + '&minValue=' + $('txtKpiMin').get('value') + '&maxValue=' + $('txtKpiMax').get('value') + '&valueFontSize='+ $('txtKpiValueFontSize').get('value')+ '&scaleFontSize=' + $('txtKpiScaleFontSize').get('value') + '&backgColor='+ getRGBColor(backColor) +'&pointerColor='+ getRGBColor(pointerColor) + '&valueColor='+ getRGBColor(valueColor) + '&noValueColor='+ getRGBColor(noValueColor) + '&valueType=' + $('cmbKpiValueType').get('value') +'&valueDecimals=' + $('cmbKpiValueDecimals').get('value') + '&withBorder=' + $('chkSeeBorder').get('checked') + '&zones=' + zones + '&actualValue=' + value + '&ringAnchorSize=' + $('cmbKpiRingAnchorSize').get('value'));
		}catch(e){
			showMessage("ERROR", GNR_TIT_WARNING, 'modalWarning');
		}
	}
}

function getValueToShow() {
	var value = "";
	var gridZones = $('gridZones');
	if (gridZones.rows.length > 0){
		trows= gridZones.rows;
		for (i=0;i<trows.length;i++) {
			var zneMin = trows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value;
			var zneMax = trows[i].getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[0].value;
			var color =  trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].value;
			var checked =  trows[i].getElementsByTagName("TD")[6].getElementsByTagName("INPUT")[0].checked;
			
			if (checked) {
				value = (Number.from(zneMin) + Number.from(zneMax)) / 2;
			} 
		}
	}
	
	return value;
}

function getZones() {
	var zones="";
	var gridZones = $('gridZones');
	if (gridZones.rows.length > 0){
		trows= gridZones.rows;
		for (i=0;i<trows.length;i++) {
			var zneMin = trows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value;
			var zneMax = trows[i].getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[0].value;
			var color =  trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].value;
			var transp =  trows[i].getElementsByTagName("TD")[5].getElementsByTagName("SELECT")[0].value;
			var rgbColor = getRGBColor(color);
			
			if (zones=="") zones = zneMin + "-" + zneMax + "-" + rgbColor + "-" + transp;
			else zones = zones + ";" + zneMin + "-" + zneMax + "-" + rgbColor + "-" + transp; 
		}
	}
	return zones;
}

function onChangeType() {

	loadCmbSrcType(); //Recargamos el combo de origen de la fuente de datos
	
	var cmbType = $('cmbType');
	if (cmbType.get('value') == WIDGET_TYPE_KPI_ID) { //Si se selecciono tipo KPI
		$('cmbSrcType').set('value', WIDGET_SRC_TYPE_BUS_CLASS_ID);

		$('divSrcBusClass').setStyle('display', '');
		$('divKPIData').setStyle('display', '');
		$('divSrcCubeView').setStyle('display', 'none');
		$('divSrcUserQry').setStyle('display', 'none');
		$('divSrcSqlQry').setStyle('display', 'none');
		$('divSrcCustom').setStyle('display', 'none');

		$('imgUsrQryShowParams').setStyle('display', '');
		$('divSrcType').setStyle('display', '');
		$('selQryViewType').setStyle('display', 'none');
		$('selCbeViewType').setStyle('display', 'none');
		
		var chkHistoric = $('chkHistoric'); 
		if (chkHistoric){
			chkHistoric.setStyle('display', ''); //Mostramos checkbox de ver historico
			if (chkHistoric.get('checked')) $('tabHistoric').setStyle('display', ''); //Mostramos tab de historico
			else {
				$('tabHistoric').setStyle('display', 'none');
				//Ocultamos imagen del boton de ver historico
				$('hisImgIndicatorSample').setStyle('display', 'none');
			}
		}
		
		//Si la fuente de datos actual es una consulta
		if ($('cmbSrcType').get('value') == WIDGET_SRC_TYPE_QUERY_ID) {
			//Mostramos checbox de abrir consulta
			var chkQuery = $('chkQuery'); 
			if (chkQuery){
				chkQuery.setStyle('display', ''); 
			}
		}else {
			//Ocultamos checkbox de abrir query
			$('chkOpenQry').set('checked', false);
			$('chkQuery').setStyle('display', 'none');
			//Ocultamos imagen del boton de abrir query
			$('qryImgIndicatorSample').setStyle('display', 'none');
		}
		
		//Si la fuente de datos actual es un cubo
		if ($('cmbSrcType').get('value') == WIDGET_SRC_TYPE_CUBE_VIEW_ID) {
			//Mostramos checbox de abrir cubo
			var chkCube = $('chkCube'); 
			if (chkCube){
				chkCube.setStyle('display', ''); 
			}
		}else {
			//Ocultamos checkbox de abrir cubo
			$('chkOpenCbe').set('checked', false);
			$('chkCube').setStyle('display', 'none');
			//Ocultamos imagen del boton de abrir query
			//$('cbeImgIndicatorSample').setStyle('display', 'none');
		}
		
		enableDisableZonesDiv(true); //Mostramos la grilla de zonas y tab de acciones de zonas
		
		$('dinamicImgDIV').setStyle('display', '');
		$('imgDIV').setStyle('display', 'none');
		
		$('radActAllways').erase('disabled');
		
		$('txtCustomSrc').set('value', '');
		$('chkCustUrl').set('checked', false);
		
		var kpiMin = $('txtKpiMin'); 
		if (kpiMin.get('value') == '') kpiMin.set('value', 0);
		var kpiMax = $('txtKpiMax'); 
		if (kpiMax.get('value') == '') kpiMax.set('value', 100);
		
		showChart();
	} else if (cmbType.get('value') == WIDGET_TYPE_CUBE_ID) {
		$('cmbSrcType').set('value', WIDGET_SRC_TYPE_CUBE_VIEW_ID);

		$('divSrcBusClass').setStyle('display', 'none');
		$('divKPIData').setStyle('display', 'none');
		$('divSrcCubeView').setStyle('display', '');
		$('divSrcUserQry').setStyle('display', 'none');
		$('divSrcSqlQry').setStyle('display', 'none');
		$('divSrcCustom').setStyle('display', 'none');
		$('selQryViewType').setStyle('display', 'none');
		
		$('selCbeViewType').setStyle('display', '');
		
		//$('panelOptions').setStyle('display', 'none');
		$('divSrcType').setStyle('display', '');
		
		$('tabHistoric').setStyle('display', 'none'); //Ocultamos tab de historico
		enableDisableZonesDiv(false); //Ocultamos la grilla de zonas y tab de acciones de zonas
		
		//Ocultamos checkbox de ver historico
		$('chkViewHist').set('checked', false);
		$('chkHistoric').setStyle('display', 'none'); 
		
		//Ocultamos checkbox de abrir query
		$('chkOpenQry').set('checked', false);
		$('chkQuery').setStyle('display', 'none');
		
		//Mostramos checbox de abrir cubo
		var chkCube = $('chkCube'); 
		if (chkCube){
			chkCube.setStyle('display', ''); 
		}
		
		$('dinamicImgDIV').setStyle('display', 'none');
		$('imgDIV').setStyle('display', '');
		//$('widgetImg').set('src', WIDGET_CUBE_SRC_IMAGE);
		
		$('radActAllways').set('disabled','true'); //Deshabilitamos checkbox de siempre activo
		$('radActNoAllways').set('checked',true);  //Chequeamos el checkbos de activo cuando se accede al dashboard
		$('radActAllways').set('checked',false);   //Deschequeamos el checkbox de siempre activo
		$('divActNoAllways').setStyle('display', '');   //Mostramos los datos para seleccionar para el caso de activo cuando se accede al dashboard
		$('divActAllways').setStyle('display', 'none'); //Ocultamos los datos para seleccionar para el caso de siempre activo
		
		$('txtCustomSrc').set('value', '');
		$('chkCustUrl').set('checked', false);
		
		setCbeSettings();
		
	} else if (cmbType.get('value') == WIDGET_TYPE_QUERY_ID) {
		$('cmbSrcType').set('value', WIDGET_SRC_TYPE_QUERY_ID);

		$('divSrcBusClass').setStyle('display', 'none');
		$('divKPIData').setStyle('display', 'none');
		$('divSrcCubeView').setStyle('display', 'none');
		$('divSrcUserQry').setStyle('display', '');
		$('divSrcSqlQry').setStyle('display', 'none');
		$('divSrcCustom').setStyle('display', 'none');
		$('selQryViewType').setStyle('display', '');
		$('selQryViewType').set('value', WIDGET_QRY_VIEW_CHART);
		
		$('selCbeViewType').setStyle('display', 'none');
		
		$('imgUsrQryShowParams').setStyle('display', 'none');
		$('divSrcType').setStyle('display', '');
		
		//Ocultamos checkbox de ver historico
		$('chkViewHist').set('checked', false);
		$('chkHistoric').setStyle('display', 'none'); 
		
		//Ocultamos checkbox de abrir cubo
		$('chkOpenCbe').set('checked', false);
		$('chkCube').setStyle('display', 'none');
		
		//Mostramos checbox de abrir consulta
		var chkQuery = $('chkQuery'); 
		if (chkQuery){
			chkQuery.setStyle('display', ''); 
		}
		
		$('tabHistoric').setStyle('display', 'none'); //Ocultamos tab de historico
		enableDisableZonesDiv(false); //Ocultamos la grilla de zonas y tab de acciones de zonas
		
		$('dinamicImgDIV').setStyle('display', 'none');
		$('imgDIV').setStyle('display', '');
		setQrySettings();
		
		$('radActAllways').set('disabled','true'); //Deshabilitamos checkbox de siempre activo
		$('radActNoAllways').set('checked',true);  //Chequeamos el checkbos de activo cuando se accede al dashboard
		$('radActAllways').set('checked',false);   //Deschequeamos el checkbox de siempre activo
		$('divActNoAllways').setStyle('display', '');   //Mostramos los datos para seleccionar para el caso de activo cuando se accede al dashboard
		$('divActAllways').setStyle('display', 'none'); //Ocultamos los datos para seleccionar para el caso de siempre activo
		
		$('txtCustomSrc').set('value', '');
		$('chkCustUrl').set('checked', false);
		
		$('txtHidUsrQryParValues').set('value', ''); //Borramos los parametros
		
		setQrySettings();
		
	} else if (cmbType.get('value') == WIDGET_TYPE_CUSTOM_ID) {
		$('divSrcBusClass').setStyle('display', 'none');
		$('divKPIData').setStyle('display', 'none');
		$('divSrcCubeView').setStyle('display', 'none');
		$('divSrcUserQry').setStyle('display', 'none');
		$('divSrcSqlQry').setStyle('display', 'none');
		$('divSrcCustom').setStyle('display', '');
		$('selQryViewType').setStyle('display', 'none');
		
		$('divSrcType').setStyle('display', 'none');
		$('selCbeViewType').setStyle('display', 'none');

		//$('panelOptions').setStyle('display', ''); // Hacemos visible el panel de
												// opciones
		$('btnDelete').setStyle('display', ''); // Hacemos visible el boton de
											// borrar
		$('btnTest').set('title', LBL_TST_HTML);
		$('btnDelete').set('title', LBL_DEL_HTML);
		
		$('tabHistoric').setStyle('display', 'none'); //Ocultamos tab de historico
		enableDisableZonesDiv(false); //Ocultamos la grilla de zonas y tab de acciones de zonas
		
		//Ocultamos checkbox de ver historico
		$('chkViewHist').set('checked', false);
		$('chkHistoric').setStyle('display', 'none'); 
		
		//Ocultamos checkbox de abrir query
		$('chkOpenQry').set('checked', false);
		$('chkQuery').setStyle('display', 'none');
		
		//Ocultamos checkbox de abrir cubo
		$('chkOpenCbe').set('checked', false);
		$('chkCube').setStyle('display', 'none');
		
		$('dinamicImgDIV').setStyle('display', 'none');
		$('imgDIV').setStyle('display', 'none');
		
		$('radActAllways').set('disabled','true'); //Deshabilitamos checkbox de siempre activo
		$('radActNoAllways').set('checked',true);  //Chequeamos el checkbos de activo cuando se accede al dashboard
		$('radActAllways').set('checked',false);   //Deschequeamos el checkbox de siempre activo
		$('divActNoAllways').setStyle('display', '');   //Mostramos los datos para seleccionar para el caso de activo cuando se accede al dashboard
		$('divActAllways').setStyle('display', 'none'); //Ocultamos los datos para seleccionar para el caso de siempre activo
	}
}

function chkPersonalize() {
	if ($('chkPersonalize').get('checked')) {
		$('divKPIDataPersonalized').setStyle('display', '');
		if ($('cmbType').get('value') == WIDGET_TYPE_KPI_ID && $('cmbKpiType').get('value') != WIDGET_KPI_TYPE_RING_ID) { //Si se selecciono tipo KPI PERO NO DE TIPO RING
			$('valueColor').setStyle('display', 'none');
			$('noValueColor').setStyle('display', 'none');
		}
		$('divKPIData').setStyle('height','inherit');
		
	}else {
		$('divKPIDataPersonalized').setStyle('display', 'none');
		$('divKPIData').setStyle('height',null);
	}
}

// Click on checkbox de usar Url (como fuente de datos del widget)
function chkOnUseUrl() {
	if ($('chkCustUrl').checked) {

		// 1-Cambiar etiqueta de codigo html por url.
		$('lblCod').set('title', LBL_DIR_URL);
		$('lblCod').set('text', LBL_DIR_URL + ":");

		// 2-Cambiar etiqueta de boton testear html por testear eliminar y
		// testear
		$('btnDelete').set('title', LBL_DEL_URL);
		$('btnTest').set('title', LBL_TST_URL);

		$('txtCustomSrc').set('rows', 1);

		// 3-Borramos contenido del textArea
		$('txtCustomSrc').set('value', "http://");

		// 4-Cambiar tooltipo del textArea
		$('txtCustomSrc').set('title', LBL_ENT_COD_URL);

	} else {

		// 1-Cambiar etiqueta de url por codigo html
		$('lblCod').set('title', LBL_COD_HTML);
		$('lblCod').set('text', LBL_COD_HTML + ":");

		// 2-Cambiar etiqueta de boton testear url por testear html
		$('btnDelete').set('title', LBL_DEL_HTML);
		$('btnTest').set('title', LBL_TST_HTML);

		$('txtCustomSrc').set('rows', 3);

		// 3-Mostramos ejemplo de html
		$('txtCustomSrc').set('value', '');

		// 4-Cambiar tooltipo del textArea
		$('txtCustomSrc').set('title', LBL_ENT_COD_HTML);
	}
}

function hourMinute(el){
	if (!el.value.test(/([0-1][0-9]|[2][0-3]):[0-5][0-9]/)) {
        el.errors.push(VALID_HR);
        return false;
    } else {
        return true;
    }
}

function btnAddZone_click() {
	var gridZones = $('gridZones');
	if (incompleteZones()){
		showMessage(MSG_MUST_COMP_MAX_ZNES, GNR_TIT_WARNING, 'modalWarning');
		return;
	}else if (maxReached()){
		showMessage(MSG_CANT_ADD_NEW_ZNE, GNR_TIT_WARNING, 'modalWarning');
		return;
	}else{
		var cmbKpiType = $('cmbKpiType');
		if (cmbKpiType.get('value') == WIDGET_KPI_TYPE_THERMOMETER_ID) {//TERMOMETRO
			if (gridZones.rows.length == 3){
				showMessage(MSG_KPI_MAX_ZONES_REACHED, GNR_TIT_WARNING, 'modalWarning');
				return;
			}
		}
	}
	
	var row = fncAddZone(); //Agregamos una fila vacia
	Scroller2 = addScrollTable(gridZones); //Agregamos el scroll de la grilla de zonas
	if (row && Scroller2 && Scroller2.v){
		Scroller2.v.showElement(row);
	}
	showChart();
}

//verifica si se puede agregar una zona (si a alguna le falta setear el max no se puede)
function incompleteZones(){
	var gridZones = $('gridZones');
	if (gridZones.rows.length > 0){
		trows= gridZones.rows;
		for (i=0;i<trows.length;i++) {
			var zneMax = trows[i].getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[0].value;
			if (zneMax=="") {
				return true;
			}
		}
	 }
	 return false;
}

//verifica si alguna zona ya llego al maximo valor posible para el kpi
function maxReached(){
	var kpiMax = $('txtKpiMax').get('value');
	var gridZones = $('gridZones');
	if (gridZones.rows.length > 0){
		trows = gridZones.rows;
		for (i=0;i<trows.length;i++) {
			var zneMax= trows[i].getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[0].value;
			if (parseInt(zneMax) >= parseInt(kpiMax)) {
				return true;
			}
		}
	 }
	 return false;
}

function fncZoneChanged() {
	$('hidZoneChange').set('value', '1'); //Marcamos que se modificaron las zonas
}

function loadZones() {
	var request = new Request({
		method: 'post',			
		url: CONTEXT + URL_REQUEST_AJAX+'?action=getWidgetZones&isAjax=true' + TAB_ID_REQUEST,
		onComplete: function(resText, resXml) {
			loadZonesXML(resXml);
			
			var table = $('gridZones'); var footer = $('btnDelZone');
			var notification = new Element('div', {id : 'editionNot'}); 
			footer.grab(notification, "top");
			initAdminModalHandlerOnChangeHighlight(table, true, false, notification);
		}
	}).send();
}

function loadWidgetProperties() {
	$('cmbKpiNoValueColor').set('value', 'white');
	var request = new Request({
		method: 'post',			
		url: CONTEXT + URL_REQUEST_AJAX+'?action=getWidgetProperties&isAjax=true' + TAB_ID_REQUEST,
		onComplete: function(resText, resXml) {loadWidgetPropertiesXML(resXml);  }
	}).send();
}

function loadWidgetPropertiesXML(ajaxCallXml){
	if (ajaxCallXml != null) {
		var props = ajaxCallXml.getElementsByTagName("props");
		if (props != null && props.length > 0 && props.item(0) != null) {
			props = props.item(0).getElementsByTagName("prop");
			for(var i = 0; i < props.length; i++) {
				var prop = props.item(i);
				
				if (prop.getAttribute(WIDGET_PRP_NAME) == "kpiType"){
					var kpiType = prop.getAttribute(WIDGET_PRP_VALUE);
					
					if (kpiType == WIDGET_KPI_TYPE_GAUGE_VELOCIMETER_ID) {//GAUGE VELOCIMETRO
						selectGaugeVelocimeterKPIType();
					}else if (kpiType == WIDGET_KPI_TYPE_GAUGE_OXFORD_ID) {//GAUGE OXFORD
						selectGaugeOxfordKPIType();
					}else if (kpiType == WIDGET_KPI_TYPE_RING_ID) { //RING
						selectRingKPIType();
					}else if (kpiType == WIDGET_KPI_TYPE_COUNTER_ID) {//CONTADOR
						selectCounterKPIType();
					}else if (kpiType == WIDGET_KPI_TYPE_TRAFFIC_LIGHT_ID) {//SEMAFORO
						selectTrafficLightKPIType();
					}else if (kpiType == WIDGET_KPI_TYPE_THERMOMETER_ID) {//TERMOMETRO
						selectThermometerKPIType(true);
					}else if (kpiType == WIDGET_KPI_TYPE_SCALE_ID) { //BALANZA
						selectScaleKPIType(true);
					}
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_BTN_CHILDS){
					$('chkViewSons').set('checked', "1" == prop.getAttribute(WIDGET_PRP_VALUE));
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_BTN_OPEN_OTH_CBE){
					if ("1" == prop.getAttribute(WIDGET_PRP_VALUE)){
						$('chkOpenOthCbe').set('checked', true);
						$('divSrcOthCubeView').setStyle('display', '');
					}
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_BTN_OPEN_OTH_QRY){
					if ("1" == prop.getAttribute(WIDGET_PRP_VALUE)){
						$('chkOpenOthQry').set('checked', true);
						$('divSrcOthUserQry').setStyle('display', '');
					}
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_OTH_QRY_ID){
					$('hidOthQryId').set('value', prop.getAttribute(WIDGET_PRP_VALUE));
					
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_BTN_HIST){
					if ("1" == prop.getAttribute(WIDGET_PRP_VALUE)){
						$('chkViewHist').set('checked', true);
						$('tabHistoric').setStyle('display', '');
						$('hisImgIndicatorSample').setStyle('display', '');
					}else {
						$('chkViewHist').set('checked', false);
						$('tabHistoric').setStyle('display', 'none');
						$('hisImgIndicatorSample').setStyle('display', 'none');
					}
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == "btnInfo"){
					if ("1" == prop.getAttribute(WIDGET_PRP_VALUE)){
						$('chkViewInfo').set('checked', true);
						$('tabOthData').setStyle('display', '');
					}else {
						$('chkViewInfo').set('checked', false);
						$('tabOthData').setStyle('display', 'none');
					}
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_BTN_OPEN_CBE){
					$('chkOpenCbe').set('checked', "1" == prop.getAttribute(WIDGET_PRP_VALUE));
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_BTN_OPEN_QRY){
					$('chkOpenQry').set('checked', "1" == prop.getAttribute(WIDGET_PRP_VALUE));
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_BTN_COMMENTS){
					$('chkViewComments').set('checked', "1" == prop.getAttribute(WIDGET_PRP_VALUE));
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_BTN_UPDATE){
					$('chkViewUpdate').set('checked', "1" == prop.getAttribute(WIDGET_PRP_VALUE));
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_CUSTOMIZED){
					$('chkPersonalize').set('checked', "1" == prop.getAttribute(WIDGET_PRP_VALUE));
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_VAL_FONT_SIZE){
					$('txtKpiValueFontSize').set('value', prop.getAttribute(WIDGET_PRP_VALUE));
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_SCALE_FONT_SIZE){
					$('txtKpiScaleFontSize').set('value', prop.getAttribute(WIDGET_PRP_VALUE));
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_BACKGROUND_COLOR){
					 $('cmbKpiBackgColor').set('value', prop.getAttribute(WIDGET_PRP_VALUE));
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_BACKGROUND_COLOR_HEX){
					 $('kpiBackColorHex').set('value', prop.getAttribute(WIDGET_PRP_VALUE));
					 $('kpiBackColor').setStyle('background-color', prop.getAttribute(WIDGET_PRP_VALUE));
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_POINTER_COLOR){
					$('cmbKpiPointerColor').set('value', prop.getAttribute(WIDGET_PRP_VALUE));
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_POINTER_COLOR_HEX){
					$('kpiPointerColorHex').set('value', prop.getAttribute(WIDGET_PRP_VALUE));
					$('kpiPointerColor').setStyle('background-color', prop.getAttribute(WIDGET_PRP_VALUE));
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_VAL_COLOR){
					$('cmbKpiValueColor').set('value', prop.getAttribute(WIDGET_PRP_VALUE));
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_NO_VAL_COLOR){
					$('cmbKpiNoValueColor').set('value', prop.getAttribute(WIDGET_PRP_VALUE));
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_VAL_RING_ANCHOR){
					$('cmbKpiRingAnchorSize').set('value', prop.getAttribute(WIDGET_PRP_VALUE));
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_VAL_COLOR_HEX){
					$('kpiValueColorHex').set('value', prop.getAttribute(WIDGET_PRP_VALUE));
					$('kpiValueColor').setStyle('background-color', prop.getAttribute(WIDGET_PRP_VALUE));
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_NO_VAL_COLOR_HEX){
					$('kpiNoValueColorHex').set('value', prop.getAttribute(WIDGET_PRP_VALUE));
					$('kpiNoValueColor').setStyle('background-color', prop.getAttribute(WIDGET_PRP_VALUE));
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_VAL_TYPE){
					 $('cmbKpiValueType').set('value', prop.getAttribute(WIDGET_PRP_VALUE));
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_VAL_DECIMALS){
					$('cmbKpiValueDecimals').set('value', prop.getAttribute(WIDGET_PRP_VALUE));
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_BORDER){
					$('chkSeeBorder').set('checked', "1" == prop.getAttribute(WIDGET_PRP_VALUE));
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_QRY_VIEW_TYPE){
					var cmbQryViewType = $('cmbQryViewType');
					if (cmbQryViewType) {
						cmbQryViewType.set('value', prop.getAttribute(WIDGET_PRP_VALUE));
						if ($('cmbType').get('value') == WIDGET_TYPE_QUERY_ID)
							setQrySettings();
					}
				}else if (prop.getAttribute(WIDGET_PRP_NAME) == WIDGET_PRP_QRY_CHART_SELECTED){
					//Almacenamos el id del chart seleccionado en el input oculto para que se seleccione luego que se cargue el combo con todos los charts
					// de la consulta seleccionada
					var hidQryChartId = $('hidQryChartId');
					if (hidQryChartId) hidQryChartId.set('value', prop.getAttribute(WIDGET_PRP_VALUE));
				}
			}
		}
		
		//Segun si el widget esta customizado o no mostramos las propiedades o las ocultamos
		chkPersonalize();
		
		$('titIndicatorSample').set('text', $('widTitle').get('value'));
		$('titImgSample').set('html', $('widTitle').get('value'));
		
		if(!$('chkOpenQry').get('checked'))
			$('qryImgIndicatorSample').setStyle('display', 'none');
		if(!$('chkViewSons').get('checked')){
			$('sonImgIndicatorSample').setStyle('display', 'none');
			$('sonImgSample').setStyle('display', 'none');
		}else {
			$('dshChild').set('disabled', false);
		}
			
		if(!$('chkViewHist').get('checked'))
			$('hisImgIndicatorSample').setStyle('display', 'none');
		if(!$('chkViewInfo').get('checked')){
			$('infImgIndicatorSample').setStyle('display', 'none');
			$('infImgSample').setStyle('display', 'none');
		}
		if(!$('chkViewComments').get('checked')){
			$('comImgIndicatorSample').setStyle('display', 'none');
			$('comImgSample').setStyle('display', 'none');
		}
		if(!$('chkViewUpdate').get('checked')){
			$('refImgIndicatorSample').setStyle('display', 'none');
			$('refImgSample').setStyle('display', 'none');
		}
		if(!$('chkOpenOthCbe').get('checked')) {
			$('othCbeImgSample').setStyle('display', 'none');
			$('othCbeImgIndicatorSample').setStyle('display', 'none');
		}
		showChart();
	}
}

//Setea la imagen correspondiente, muestra o no el combo de grafico y carga el combo con las consultas
function setQrySettings() {
	if ($('cmbQryViewType').get('value') == WIDGET_QRY_VIEW_TABLE){
		$('widgetImg').set('src', WIDGET_QUERY_TABLE_SRC_IMAGE);
		$('divQryChart').setStyle('display', 'none');
	}else {
		$('widgetImg').set('src', WIDGET_QUERY_CHART_SRC_IMAGE);
		$('divQryChart').setStyle('display', '');
	}
	loadCmbSrcQryType();
}

//Setea la imagen correspondiente
function setCbeSettings() {
	if ($('cmbCbeViewType').get('value') == WIDGET_CBE_VIEW_TABLE){
		$('widgetImg').set('src', WIDGET_CUBE_TABLE_SRC_IMAGE);
	}else {
		$('widgetImg').set('src', WIDGET_CUBE_SRC_IMAGE);
	}
}

function loadZonesXML(ajaxCallXml){
	if (ajaxCallXml != null) {
		var zones = ajaxCallXml.getElementsByTagName("zones");
		if (zones != null && zones.length > 0 && zones.item(0) != null) {
			zones = zones.item(0).getElementsByTagName("zone");
			
			if(zones.length)
				fncClearZones();
			
			for(var i = 0; i < zones.length; i++) {
				var zone = zones.item(i);
				
				var name = zone.getAttribute("name");
				var desc = zone.getAttribute("desc");
				var min	 = zone.getAttribute("min");
				var max	 = zone.getAttribute("max");
				var color = zone.getAttribute("color");
				var alpha = zone.getAttribute("alpha");
				
				fncAddZone(name, desc, min, max, color, alpha);
			}
		}
	}
	showChart();
}

//Limpiar la grilla de zonas
function fncClearZones() {
	var trs = $('gridZones').getChildren('tr');
	for(var i = 0; i < trs.length; i++) {
		trs[i].destroy();
	}
}

//Agrega una zona en la grilla de zonas
function fncAddZone (name, desc, min, max, color, transp) {
	
	if (name==null) fncZoneChanged(); //Si se agrego una zona, marcamos como que hubo un cambio en las zonas
	
	var tdWidths =  getGridHeaderWidths('gridZones');
	
	var oTd0 = new Element("TD"); //Nombre
	var oTd1 = new Element("TD"); //Descripcion
	var oTd2 = new Element("TD"); //Minimo
	var oTd3 = new Element("TD"); //Maximo
	var oTd4 = new Element("TD"); //Color
	var oTd5 = new Element("TD"); //Transparencia
	var oTd6 = new Element("TD"); //Ver valor
	
	//Nombre
	var div = new Element('div', {styles: {width: tdWidths[0], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	var input = new Element('input',{type:'text',name:'zneName'});
	if (name==null) name = "ZONE" + ($('gridZones').rows.length + 1);
	input.addEvent("change",function(e){
		fncZoneChanged();
	});
	input.set('value', name);
	input.setStyle('width',  Number.from(tdWidths[0]) - 5);
	input.inject(div);
	div.inject(oTd0);
	
	//Descripcion
	div = new Element('div', {styles: {width: tdWidths[1], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	var input = new Element('input',{type:'text',name:'zneDesc'});
	if (desc==null) desc= '';
	input.addEvent("change",function(e){
		fncZoneChanged();
	});
	input.set('value', desc);
	input.setStyle('width',  Number.from(tdWidths[1]) - 5);
	input.inject(div);
	div.inject(oTd1);

	//Minimo
	var zneMin = getNextZneMin();
	
	div = new Element('div', {styles: {width: tdWidths[2], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	var input = new Element('input',{type:'text', name:'zneMin', 'class':"validate['required','number']"});
	$('frmData').formChecker.register(input);
	
	if (min==null) min= getNextZneMin();
	input.set('value', min);
	input.addEvent("change",function(e){
		fncZoneChanged();
		zneMinBeenChange(this);
		if (this.get('value')!="") showChart();
	});
	
	input.setStyle('width',  Number.from(tdWidths[2]) - 5);
	input.inject(div);
	div.inject(oTd2);
	
	//Maximo
	div = new Element('div', {styles: {width: tdWidths[3], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	var input = new Element('input',{type:'text', name:'zneMax', 'class':"validate['required','number']"});
	$('frmData').formChecker.register(input);
	
	var kpiMax = $('txtKpiMax');
	if (max==null && kpiMax && kpiMax.get('value') != null) max= kpiMax.get('value');
	input.set('value', max);
	input.addEvent("change",function(e){
		fncZoneChanged();
		zneMaxBeenChange(this);
		if (this.get('value')!="") showChart();
	});
	input.setStyle('width',  Number.from(tdWidths[3]) - 5);
	input.inject(div);
	div.inject(oTd3);
	
	//Color
	div = new Element('div', {styles: {width: tdWidths[4], overflow: 'hidden', 'white-space': 'nowrap','text-align':'center'}});
	
	var inputColorHexId = 'zneColorHex' + $('gridZones').getElements('tr').length;
	var inputHex = new Element('input',{type:'text', name:inputColorHexId, id:inputColorHexId});
	if (color==null) {
		var cmbKpiType = $('cmbKpiType');
		if (cmbKpiType.get('value') == WIDGET_KPI_TYPE_RING_ID) {//ANILLO
			color = YELLOW_HEX;
		}else color= DEFAULT_COLOR;
	}
	inputHex.set('value', color);
	inputHex.setStyle('width',  Number.from(tdWidths[4]) / 2 - 5);
	inputHex.inject(div);
	
	var imgId = 'img' + $('gridZones').getElements('tr').length;
	
	var img = new Element('img', {id:imgId, styles: {width: 15, height:13, marginLeft: 2, marginRight: 2}, src: PALETTE}).inject(div);
	img.addEvent("click",function(e){
		fncZoneChanged();
	});
	
	var inputColorId = 'zneColor' + $('gridZones').getElements('tr').length;
	var inputColor = new Element('input',{type:'text', name:inputColorId, id:inputColorId});
	inputColor.disabled = true;
	inputColor.setStyle('background-color', color);
	inputColor.setStyle('width',  Number.from(tdWidths[4]) / 2 - 5);
	inputColor.setStyle('display', 'inline-block');
	inputColor.inject(div);
	
	div.inject(oTd4);
	
	//Transparencia
	div = new Element('div', {styles: {width: tdWidths[5], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	var selector = new Element('select',{name:'selTransp', id:'selTransp'}).setStyle('width', Number.from(tdWidths[5]) - 5);
	
	selector.addEvent("change",function(e){
		showChart();
		fncZoneChanged();
	});
	
	var  val=255;
	for (i=0;i<=100;i=i+10){
		var optionDOM = new Element('option');
		optionDOM.set('value',val);
		optionDOM.appendText(i + "%");
		if (transp==val) optionDOM.set('selected','selected');
		optionDOM.inject(selector);
		if (val==30) val = 0;
		else val = val - 25;
	}
	selector.inject(div);
	
	div.inject(oTd5);
	
	//Ver valor
	div = new Element('div', {styles: {width: tdWidths[6], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	input = new Element('input',{type:'radio',  id:'seeValue', name:'seeValue','onclick':'showChart()', checked:true});							
	input.inject(div);
	div.inject(oTd6);
	
	var oTr = new Element("TR");
	
	oTd0.inject(oTr);
	oTd1.inject(oTr);
	oTd2.inject(oTr);
	oTd3.inject(oTr);
	oTd4.inject(oTr);
	oTd5.inject(oTr);
	oTd6.inject(oTr);
	
	oTr.addClass("selectableTR");
	oTr.getRowId = function () { return this.getAttribute("rowId"); };
	oTr.setRowId = function (a) { this.set("rowId",a); };
	oTr.set("rowId", $('gridZones').rows.length);
	
	oTr.addEvent("click",function(e){myToggle(this)}); 
	
	if($('gridZones').rows.length%2==0){
		oTr.addClass("trOdd");
	}
	
	oTr.inject($('gridZones'));
	
	//Creamos el objeto colorPicker asociado a la imagen
	createZneColorPalette(inputColorHexId, imgId, inputColorId);
	
	inputHex.addEvent("change",function(e){
		fncZoneChanged();
		inputColor.setStyle('background-color', this.get('value'));
		if (this.get('value')!="") showChart();
	});
	
	
//	showChart();
	initAdminFieldOnChangeHighlight(false, false, false, oTr);
	
	return oTr;
}

//llamado al insertar en el input de maximo de zona
function zneMaxBeenChange(obj){
	var tr = getParentRow(obj);
	var value = obj.value;
	var nextTr = tr.parentNode.rows[tr.rowIndex];
	if (nextTr != null){ //si no es la ultima fila
		//Actualizamos el minimo de la siguiente fila
		nextTr.getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value = value;
	}
}

//llamado al insertar en el input de minimo de zona
function zneMinBeenChange(obj){
	var tr = getParentRow(obj);
	var value = obj.value;
	
	if (tr.rowIndex>1){ //Si no es la primer zona
		var prevTr = tr.parentNode.rows[tr.rowIndex-2];
		if (prevTr != null){ 
			//Actualizamos el maximo de la anterior fila
			prevTr.getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[0].value = value;
		}
	}
}

function getParentRow(element){
	while(element.tagName!="TR"){
		element=element.parentNode;
	}
	return element;
}

var palettes = new Array();

function createZneColorPalette(inputHexId, imgId, inputId){
	var old_picker = $(imgId + "picker");
	if(old_picker)
		old_picker.destroy();
	var zneColorPalette = new MooRainbow(imgId, {
		id: imgId + "picker", //Asignar un id diferente si hay muchas paletas
		'startColor': [80, 80, 80],
		'imgPath': CONTEXT + '/js/colorpicker/images/',
		'onChange': function(color) {
			//showChart();
		},
		'onComplete': function(color) {
			//Sin confirma guardo los colores y refreso chart
			$(inputHexId).value = color.hex;
			$(inputId).setStyle('background-color', color.hex);
			showChart();
			this.fireEditionEvent();
		},
		'onCancel':function(color) {
			//showChart(); //No es necesario pq no se esta actualizando el color de la zona a medida que modifica color
			var oldColor = $(inputHexId).value;
			zneColorPalette.manualSet(oldColor.substring(1, oldColor.length),'hex');
		}		
	});
  palettes.push(zneColorPalette);
}

function getNextZneMin(){
	 var zneMin = $('txtKpiMin').get('value');
	 if ($('gridZones').rows.length > 0){
		trows=$('gridZones').rows;
		for (i=0;i<trows.length;i++) {
			var zneMax = trows[i].getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[0].value;
			if (parseInt(zneMax) > parseInt(zneMin)) {
				zneMin = zneMax;
			}
		}
	 }
	 return zneMin;
}