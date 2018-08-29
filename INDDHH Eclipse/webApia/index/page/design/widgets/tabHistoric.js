function initHistoricTab(mode) {

	if (histColNumber=="") histColNumber = HIST_COL_DEFAULT;
	if (metaColNumber=="") metaColNumber = META_COL_DEFAULT;
	
	if (mode == INSERT_MODE) {
		$('histColNumber').set('value', HIST_COL_DEFAULT);
		$('histColColor').setStyle('background-color', HIST_COL_DEFAULT);
		$('historyLine1').setStyle('background-color', HIST_COL_DEFAULT);
		$('metaColNumber').set('value', META_COL_DEFAULT);
		$('metaColColor').setStyle('background-color', META_COL_DEFAULT);
		
		$('divMetaValues').style.display = 'none';
		$('widMetaMultiplier').set('value',1);
	}else {
		$('histColNumber').set('value', histColNumber);
		$('histColColor').setStyle('background-color', histColNumber);
		$('metaColNumber').set('value', metaColNumber);
		$('metaColColor').setStyle('background-color', metaColNumber);
		$('historyLine1').setStyle('background-color', histColNumber);
		if (viewMeta == '1') {
			$('divMetaValues').style.display = ''; //Mostramos valores para la meta
			$('chkSeeMeta').set('checked', true);
			if (isMetaByYear == 'true') $('chkMetaByYear').set('checked', true);
			if (isMetaByMonth == 'true') $('chkMetaByMonth').set('checked', true);
			if (isMetaByDay == 'true') $('chkMetaByDay').set('checked', true);
			$('historyLine2').setStyle('background-color', histColNumber);
			$('metaLine').setStyle('background-color', metaColNumber);
		}else {
			$('divMetaValues').style.display = 'none'; //Ocultamos valores para la meta
		}
	}
	
	if ($('chkSeeMeta')){
		$('chkSeeMeta').addEvent("click", function(e) {
			if ($('chkSeeMeta').checked) {
				$('divMetaValues').style.display = '';
				if ($('widMetaMultiplier').get('value') == '') {
					$('widMetaMultiplier').set('value',1);
				}
				$('historyLine2').setStyle('background-color', $('histColNumber').get('value'));
			}else {
				$('divMetaValues').style.display = 'none';
			}
		});
	}
	
	var histColorPalette = new MooRainbow('histColImg', {
		id: 'histColorPalette',
		'startColor': [80, 80, 80],
		'imgPath': CONTEXT + '/js/colorpicker/images/',
		'onChange': function(color) {
			$('historyLine1').setStyle('background-color', color.hex);
			$('historyLine2').setStyle('background-color', color.hex);
		},
		'onComplete': function(color) {
			$('histColNumber').set('value', color.hex);
			$('histColColor').setStyle('background-color', color.hex);
			$('historyLine1').setStyle('background-color', color.hex);
			$('historyLine2').setStyle('background-color', color.hex);
		},
		'onCancel':function(color) {
			//Dejamos seteado como color inicial el que estaba antes
			var oldColor = $('histColNumber').get('value');
			histColorPalette.manualSet(oldColor.substring(1, oldColor.length),'hex');
			$('historyLine1').setStyle('background-color', oldColor);
			$('historyLine2').setStyle('background-color', oldColor);
		}
	});
	
	var metaColorPalette = new MooRainbow('metaColImg', {
		id: 'metaColorPalette',
		'startColor': [80, 80, 80],
		'imgPath': CONTEXT + '/js/colorpicker/images/',
		'onChange': function(color) {
			$('metaLine').setStyle('background-color', color.hex);
		},
		'onComplete': function(color) {
			$('metaColNumber').set('value', color.hex);
			$('metaColColor').setStyle('background-color', color.hex);
			$('metaLine').setStyle('background-color', color.hex);
		},
		'onCancel':function(color) {
			//Dejamos seteado como color inicial el que estaba antes
			var oldColor = $('metaColNumber').get('value');
			metaColorPalette.manualSet(oldColor.substring(1, oldColor.length),'hex');
			$('metaLine').setStyle('background-color', oldColor);
		}
	});
}

