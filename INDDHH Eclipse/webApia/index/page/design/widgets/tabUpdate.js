function initUpdateTab(mode) {

	if (mode==INSERT_MODE) {
		$('txtRefreshTime').set('value', 60);
		$('radActAllways').set("checked", true);
		$('radActNoAllways').set("checked", false);
		$('txtExeNode').set('value', "");
		$('txtExeNode').set('disabled', true);
	}
	
	if ($('radActNoAllways')) {
		$('radActNoAllways').addEvent("click", function(e) {
			showMessage(MSG_WID_ACT_NO_ALWAYS, GNR_TIT_WARNING, "modalWarning");
			clickOnRefreshRadio(1);
		});
		
		if ($('radActNoAllways').get('checked')) {
			$('divActNoAllways').style.display = '';
			$('divActAllways').style.display = 'none';
		} else {
			$('divActNoAllways').style.display = 'none';
			$('divActAllways').style.display = '';
		}
	}

	if ($('radActAllways')) {
		$('radActAllways').addEvent("click", function(e) {
			clickOnRefreshRadio(2);
		});
	}

	if ($('cmbRefType')) {
		if (refTimeSelected == WIDGET_REF_TIME_SEC) {
			$('cmbRefType').set('value', WIDGET_REF_TIME_SEC);
		} else if (refTimeSelected == WIDGET_REF_TIME_MIN) {
			$('cmbRefType').set('value', WIDGET_REF_TIME_MIN);
		} else if (refTimeSelected == WIDGET_REF_TIME_HOR) {
			$('cmbRefType').set('value', WIDGET_REF_TIME_HOR);
		}
	}

	if ($('cmbRefPeriod')) {
		$('cmbRefPeriod')
				.addEvent(
						"change",
						function(e) {
							if (($('cmbRefPeriod').get('value') == PERIODICITY_EVERY_MINUTE)
									|| ($('cmbRefPeriod').get('value') == PERIODICITY_EVERY_QUARTER)
									|| ($('cmbRefPeriod').get('value') == PERIODICITY_EVERY_HALF_HOUR)
									|| ($('cmbRefPeriod').get('value') == PERIODICITY_EVERY_HOUR)) {
								$('txtHorIni').set('disabled', true);
								$('txtHorIni').value = "";
							} else {
								var horIni = $('txtHorIni'); 
								horIni.set('disabled', false);
								if (horIni.get('value') == "") horIni.set('value', '03:00');
							}
						});

		if (($('cmbRefPeriod').get('value') == PERIODICITY_EVERY_MINUTE)
				|| ($('cmbRefPeriod').get('value') == PERIODICITY_EVERY_QUARTER)
				|| ($('cmbRefPeriod').get('value') == PERIODICITY_EVERY_HALF_HOUR)
				|| ($('cmbRefPeriod').get('value') == PERIODICITY_EVERY_HOUR)) {
			$('txtHorIni').set('disabled', true);
		} else {
			var horIni = $('txtHorIni'); 
			horIni.set('disabled', false);
			if (horIni.get('value') == "") horIni.set('value', '03:00');
		}
	}

	// Seleccionamos el radio button correspondiente segun si hay nombre de nodo o no
	if ($('radExeAnyNode') && $('radExeSpecNode') && nodeName == "") {
		$('radExeAnyNode').set("checked", true);
		$('radExeSpecNode').set("checked", false);
	} else if ($('radExeAnyNode') && $('radExeSpecNode') && $('txtExeNode')){
		$('radExeAnyNode').set("checked", false);
		$('radExeSpecNode').set("checked", true);
		$('txtExeNode').set('value', nodeName);
	}

	// Accion al seleccionar cualquier nodo
	if ($('radExeAnyNode')) {
		$('radExeAnyNode').addEvent("click", function(e) {
			$('radExeAnyNode').set("checked", true);
			$('radExeSpecNode').set("checked", false);
			$('txtExeNode').set('value', "");
			$('txtExeNode').set('disabled', true);
		});
	}

	// Acción al seleccionar Nodo especifico
	if ($('radExeSpecNode')) {
		$('radExeSpecNode').addEvent("click", function(e) {
			$('radExeAnyNode').set("checked", false);
			$('radExeSpecNode').set("checked", true);
			$('txtExeNode').set('disabled', false);
		});
	}
	
	if ($('chkNotify')) {
		$('chkNotify').addEvent("click", function(e) {
			if ($('chkNotify').checked) {
				$('txtEmails').erase('disabled');
			}else {
				$('txtEmails').set('disabled','true');
				$('txtEmails').set('value','');
			}
		});
	}
	
	if (!$('radExeSpecNode').checked){
		$('txtExeNode').value = "";
		$('txtExeNode').disabled = true;
	}
	
	var txtRefreshTime = $('txtRefreshTime');
	if (txtRefreshTime){
		txtRefreshTime.addEvent("change",function(e){
			if (e) e.stop();
			var value = this.value;
			if (value != null && value != ""){
				value = Number.from(value);
				if (!value || value <= 0){
					showMessage(MSG_WID_ACT_TIME, GNR_TIT_WARNING, 'modalWarning');
					this.value = '';
				}
			} 
		});
	}
}

function clickOnRefreshRadio(clicked) {
	if (clicked == 2) {
		$('radActNoAllways').set("checked", false);
		$('divActNoAllways').style.display = 'none';
		$('divActAllways').style.display = '';
		$('txtRefreshTime').set("value","0");
	} else {
		$('radActAllways').set("checked", false);
		$('divActNoAllways').style.display = '';
		$('divActAllways').style.display = 'none';
		$('txtRefreshTime').set("value","5");
	}
}
