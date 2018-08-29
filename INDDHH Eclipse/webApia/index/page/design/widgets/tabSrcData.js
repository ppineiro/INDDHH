function initSrcDataTab(mode) {

	// Combo de origen de datos
	if ($('cmbSrcType')) {
		loadCmbSrcType(); // Cargamos el combo de Origen, segun el tipo del kpi
		showDivSrc();
		// Acción al modificar combo de origen de datos
		$('cmbSrcType').addEvent("change", function(e) {
			showDivSrc(); // Mostrar el div correspondiente
		});
	}
	
	//Combo de datos
	var widType = $('cmbType').get('value');
	if (widType == WIDGET_TYPE_QUERY_ID) {
		loadCmbSrcQryType(); //Mostramos las consultas según si deben tener grafico o no
	}
	
	$('cmbSrcQry').addEvent("change", function(e) {
		loadCmbQryCharts();
	});

	// Accion al presionar imagen de parametros de clase de negocio
	if ($('imgBusClaParams')) {
		$('imgBusClaParams').addEvent("click", function(e) {
			openBusClaParModal();
		});
	}

	// Acción al modificar combo de cubos
	if ($('cmbSrcCube')) {
		loadCubeViews();
		$('cmbSrcCube').addEvent("change", function(e) {
			loadCubeViews();
		});
	}

	// Accion al presionar imagen de filtros de consultas de usuario
	if ($('imgUsrQryParams')) {
		$('imgUsrQryParams').addEvent("click", function(e) {
			openQryFiltersModal();
		});
	}

	// Accion al presionar imagen de columna a mostrar en consultas de usuario
	if ($('imgUsrQryShowParams')) {
		$('imgUsrQryShowParams').addEvent("click", function(e) {
			openQryShowColParModal();
		});
	}

	if (mode == INSERT_MODE) {
		$('dbConId').set('value', 0);
	}else {
		var hidQryChartId = $('hidQryChartId');
		var cmbSrcQryChart = $('cmbSrcQryChart');
		
		if (cmbSrcQryChart && hidQryChartId.get('value') != '' && hidQryChartId.get('value') != '0') {
			cmbSrcQryChart.set('value', hidQryChartId.get('value'));
		}
		loadCmbQryCharts();
	}

	if ($('btnTest')) {
		$('btnTest').addEvent("click", function(e) {
			testSQL('false');
		});
	}

	if ($('btnDelete')) {
		$('btnDelete').addEvent("click", function(e) {
			btnDelete();
		});
	}

	if ($('chkCustUrl')) {
		$('chkCustUrl').addEvent("click", function(e) {
			chkOnUseUrl();
		});
	}
	
	if ($('chkPersonalize')) {
		$('chkPersonalize').addEvent("click", function(e) {
			chkPersonalize();
		});
	}
}

function testSQL() {
	if ($('cmbType').get('value') == WIDGET_TYPE_KPI_ID) {
		var dbConId = $('dbConId').get('value');
		var sql = $('txtSqlQuery').get('value');
		var extra = {'txtSqlQuery':sql, 'dbConId': dbConId, 'onConfirm':'false'};
		var request = new Request({
			method : 'post',
			data: extra,
			url : CONTEXT + URL_REQUEST_AJAX + '?action=sqlTest&isAjax=true' + TAB_ID_REQUEST,
			onComplete : function(resText, resXml) {processSQLTestResult(resXml); }
		}).send();
	} else { // CUSTOM
		if ($('chkCustUrl').checked) { // URL
			ModalController.openWinModal($('txtCustomSrc').get('value'), 600, 400);			
		} else { // HTML
			var code = $('txtCustomSrc').get('value');
			code = encodeURIComponent(code);
			ModalController.openWinModal(CONTEXT + '/page/design/widgets/testHTML.jsp?htmlCode=' + code + TAB_ID_REQUEST, 600, 400);
		}
	}
}

/*
 * <result>
 *   <sqlResult result="OK-866"></sqlResult>
 * </result>
 */
function processSQLTestResult(ajaxCallXml) {
	if (ajaxCallXml != null) {
		var sqlResult = ajaxCallXml.getElementsByTagName("sqlResult");
		if (sqlResult != null) {
			var result = sqlResult.item(0).getAttribute("result");
			var onConfirm = sqlResult.item(0).getAttribute("onConfirm");
			if(result.indexOf("OK")==0){
				if (onConfirm != 'true'){
					result = result.substring(3,result.length);
					showMessage(result, LBL_RESULT, '');
				}else {
					doSubmit();
				}
			}else{
				showMessage(result, 'modalWarning');
			}
		}
	}
}

function btnDelete() {
	$('txtSqlQuery').set('value', '');
	$('txtCustomSrc').set('value', '');
}

// Carga las vistas del cubo seleccionado
function loadCubeViews() {
	cleanCombo('cmbSrcCubeView'); // vaciamos el combo de vistas
	var cbeId = $('cmbSrcCube').get('value');
	if (cbeId > 0) {
		var request = new Request({
			method : 'post',
			data : {
				'cbeId' : cbeId
			},
			url : CONTEXT + URL_REQUEST_AJAX
					+ '?action=getCbeViews&isAjax=true' + TAB_ID_REQUEST,
			onComplete : function(resText, resXml) {
				loadViewsXML(resXml);
			}
		}).send();
	}
}

// Lee el xml resultado de solicitar las vistas de un cubo
function loadViewsXML(ajaxCallXml) {
	if (ajaxCallXml != null) {
		var views = ajaxCallXml.getElementsByTagName("views");
		if (views != null && views.length > 0 && views.item(0) != null) {
			views = views.item(0).getElementsByTagName("view");
			for ( var i = 0; i < views.length; i++) {
				var view = views.item(i);

				var vwId = view.getAttribute("id");
				var vwName = view.getAttribute("name");

				fncAddView(vwId, vwName);
			}
		}
	}
}

// Agrega una vista en el combo de vistas
function fncAddView(vwId, vwName) {
	var views = $('cmbSrcCubeView').getElements('option');

	for ( var i = 0; i < views.length; i++) {
		if (views[i].value == vwName) {
			return;
		}
	}

	// Agregamos la vista al combo
	var option = new Element('option', {
		html : vwName,
		value : vwId
	}).inject($('cmbSrcCubeView'));

	if (vwId == widParId)
		option.selected = true;
}

// vacia el combo pasado por parametro
function cleanCombo(cmbId) {
	if ($(cmbId)) {
		var options = $(cmbId).getElements('option');
		for ( var i = 0; i < options.length; i++) {
			options[i].destroy();
		}
	}
}

function showDivSrc() {
	if ($('cmbSrcType').get('value') == WIDGET_SRC_TYPE_BUS_CLASS_ID) {
		$('divSrcBusClass').setStyle('display', '');
		$('divSrcCubeView').setStyle('display', 'none');
		$('divSrcUserQry').setStyle('display', 'none');
		$('divSrcSqlQry').setStyle('display', 'none');
		$('panelOptions').setStyle('display', 'none');
		
		//Ocultamos checkbox de abrir query
		$('chkOpenQry').set('checked', false);
		$('chkQuery').setStyle('display', 'none');
		
		//Ocultamos checkbox de abrir cube
		$('chkOpenCbe').set('checked', false);
		$('chkCube').setStyle('display', 'none');
	} else if ($('cmbSrcType').get('value') == WIDGET_SRC_TYPE_CUBE_VIEW_ID) {
		$('divSrcBusClass').setStyle('display', 'none');
		$('divSrcCubeView').setStyle('display', '');
		$('divSrcUserQry').setStyle('display', 'none');
		$('divSrcSqlQry').setStyle('display', 'none');
		$('panelOptions').setStyle('display', 'none');
		
		//Ocultamos checkbox de abrir query
		$('chkOpenQry').set('checked', false);
		$('chkQuery').setStyle('display', 'none');
		
		//Mostramos checbox de abrir cubo
		var chkCube = $('chkCube'); 
		if (chkCube){
			chkCube.setStyle('display', ''); 
		}
	} else if ($('cmbSrcType').get('value') == WIDGET_SRC_TYPE_QUERY_ID) {
		$('divSrcBusClass').setStyle('display', 'none');
		$('divSrcCubeView').setStyle('display', 'none');
		$('divSrcUserQry').setStyle('display', '');
		$('divSrcSqlQry').setStyle('display', 'none');
		$('panelOptions').setStyle('display', 'none');
		$('divQryChart').setStyle('display', 'none');
		loadCmbSrcQryType(false);
		
		//Ocultamos checkbox de abrir cube
		$('chkOpenCbe').set('checked', false);
		$('chkCube').setStyle('display', 'none');
		
		//Mostramos checbox de abrir consulta
		var chkQuery = $('chkQuery'); 
		if (chkQuery){
			chkQuery.setStyle('display', ''); 
		}
	} else if ($('cmbSrcType').get('value') == WIDGET_SRC_TYPE_QUERY_SQL_ID) {
		$('divSrcBusClass').setStyle('display', 'none');
		$('divSrcCubeView').setStyle('display', 'none');
		$('divSrcUserQry').setStyle('display', 'none');
		$('divSrcSqlQry').setStyle('display', '');
		$('panelOptions').setStyle('display', ''); // Hacemos visible el panel de opciones
		$('btnDelete').set('title', LBL_DEL_SQL); // Modificamos tooltip del boton de testear
		$('btnTest').set('title', LBL_TST_SQL);
		
		//Ocultamos checkbox de abrir cube
		$('chkOpenCbe').set('checked', false);
		$('chkCube').setStyle('display', 'none');
		
		//Ocultamos checkbox de abrir query
		$('chkOpenQry').set('checked', false);
		$('chkQuery').setStyle('display', 'none');
	}
}

function openBusClaParModal() {
	if ($('cmbSrcBusClass').get('value') == ""
			|| $('cmbSrcBusClass').get('value') == "0") {
		showMessage(MSG_MUST_SEL_BUS_CLA_FIRST, GNR_TIT_WARNING, 'modalWarning');
		return;
	}

	var busClaId = $('cmbSrcBusClass').get('value');
	var parValues = $('txtBusClaHidParValues').get('value');

	var modal = ModalController.openWinModal(CONTEXT
			+ "/page/design/widgets/modalParams.jsp?for=busclass&id="
			+ busClaId + "&parValues=" + parValues + TAB_ID_REQUEST, 750, 420);

	modal.addEvent("confirm", function(res) {
		$('txtBusClaHidParValues').set('value', res);

	});
	modal.addEvent("close", function() {

	});
}

function openQryFiltersModal() {
	if ($('cmbSrcQry').get('value') == "" || $('cmbSrcQry').get('value') == "0") {
		showMessage(MSG_MUST_SEL_QUERY_FIRST, GNR_TIT_WARNING, 'modalWarning');
		return;
	}

	var qryId = $('cmbSrcQry').get('value');
	var parValues = $('txtHidUsrQryParValues').get('value');

	var modal = ModalController.openWinModal(CONTEXT
			+ "/page/design/widgets/modalParams.jsp?for=queryFilters&id="
			+ qryId + "&parValues=" + parValues + TAB_ID_REQUEST, 750, 420);

	modal.addEvent("confirm", function(res) {
		$('txtHidUsrQryParValues').set('value', res);

	});
	modal.addEvent("close", function() {

	});
}

function openQryShowColParModal() {
	if ($('cmbSrcQry').get('value') == "" || $('cmbSrcQry').get('value') == "0") {
		showMessage(MSG_MUST_SEL_QUERY_FIRST, GNR_TIT_WARNING, 'modalWarning');
		return;
	}

	var qryId = $('cmbSrcQry').get('value');
	var parValues = $('txtHidUsrQryColumn').get('value');

	var modal = ModalController.openWinModal(CONTEXT
			+ "/page/design/widgets/modalParams.jsp?for=queryShowCols&id="
			+ qryId + "&parValues=" + parValues + TAB_ID_REQUEST, 750, 420);

	modal.addEvent("confirm", function(res) {
		$('txtHidUsrQryColumn').set('value', res);

	});
	modal.addEvent("close", function() {

	});
}

function loadCmbSrcType() {
	cleanCombo('cmbSrcType');
	
	var widType = $('cmbType').get('value');
	
	if (widType == WIDGET_TYPE_KPI_ID) {
		var ele = new Element('option', {
			html : WIDGET_SRC_TYPE_BUS_CLASS_NAME,
			value : WIDGET_SRC_TYPE_BUS_CLASS_ID
		}).inject($('cmbSrcType'));

		if (widSrcType == WIDGET_SRC_TYPE_BUS_CLASS_ID) {
			ele.set('selected', 'true');
		}
	}

	if (widType == WIDGET_TYPE_KPI_ID || widType == WIDGET_TYPE_CUBE_ID) {
		var ele = new Element('option', {
			html : WIDGET_SRC_TYPE_CUBE_VIEW_NAME,
			value : WIDGET_SRC_TYPE_CUBE_VIEW_ID
		}).inject($('cmbSrcType'));

		if (widSrcType == WIDGET_SRC_TYPE_CUBE_VIEW_ID) {
			ele.set('selected', 'true');
		}
	}

	if (widType == WIDGET_TYPE_KPI_ID || widType == WIDGET_TYPE_QUERY_ID) {
		var ele = new Element('option', {
			html : WIDGET_SRC_TYPE_QUERY_NAME,
			value : WIDGET_SRC_TYPE_QUERY_ID
		}).inject($('cmbSrcType'));

		if (widSrcType == WIDGET_SRC_TYPE_QUERY_ID) {
			ele.set('selected', 'true');
		}
	}

	if (widType == WIDGET_TYPE_KPI_ID) {
		var ele = new Element('option', {
			html : WIDGET_SRC_TYPE_QUERY_SQL_NAME,
			value : WIDGET_SRC_TYPE_QUERY_SQL_ID
		}).inject($('cmbSrcType'));

		if (widSrcType == WIDGET_SRC_TYPE_QUERY_SQL_ID) {
			ele.set('selected', 'true');
		}
	}
}

function loadCmbSrcQryType(onlyWithCharts) {
	if (onlyWithCharts==null){
		onlyWithCharts = false;
		var cmbQryViewType = $('cmbQryViewType');
		if (cmbQryViewType.get('value') == WIDGET_QRY_VIEW_CHART || cmbQryViewType.get('value') == WIDGET_QRY_VIEW_BOTH) {
			onlyWithCharts=true;//MOSTRAR SOLO CONSULTAS CON GRAFICOS DEFINIDOS
		}
	}
	
	cleanCombo('cmbSrcQry');
	var request = new Request({
		method: 'post',		
		data:{'onlyWithCharts':onlyWithCharts},
		url: CONTEXT + URL_REQUEST_AJAX+'?action=getQuerys&isAjax=true' + TAB_ID_REQUEST,
		onComplete: function(resText, resXml) {loadQuerysXML(resXml);  }
	}).send();
}

function loadQuerysXML(ajaxCallXml) {
	/*
	 * <result>
	 * 	<querys>
	 *     <query qryId="1011" qryName="AAAA"/>
	 *     ..
	 *     <query qryId="1012" qryName="Ab"/>
	 *  </querys> 
	 * </result>
	 */
	
	var selectedQryId = $('hidQryId').get('value');
	
	if (ajaxCallXml != null) {
		var querys = ajaxCallXml.getElementsByTagName("querys");
		if (querys != null && querys.length > 0 && querys.item(0) != null) {
			querys = querys.item(0).getElementsByTagName("query");
			for(var i = 0; i < querys.length; i++) {
				var query = querys.item(i);
				
				var ele = new Element('option', {
					html : query.getAttribute('qryName'),
					value : query.getAttribute('qryId')
				}).inject($('cmbSrcQry'))
				
				if (selectedQryId==query.getAttribute('qryId')) ele.set('selected', true);
			}
		}
	}
	
	loadCmbQryCharts();//Mostramos los graficos correspondientes a la consulta seleccionada
}


function loadCmbQryCharts() {
	var cmbSrcQry = $('cmbSrcQry');
	var qryId = cmbSrcQry.get('value');
	
	var request = new Request({
		method: 'post',		
		data:{'qryId':qryId},
		url: CONTEXT + URL_REQUEST_AJAX+'?action=getQueryCharts&isAjax=true' + TAB_ID_REQUEST,
		onComplete: function(resText, resXml) {loadQueryChartsXML(resXml);  }
	}).send();
}

function loadQueryChartsXML(ajaxCallXml) {
	/*
	 * <result>
	 * 	<charts>
	 *     <chart chtId="1011" chtTitle="AAAA"/>
	 *     ..
	 *     <chart chtId="1012" chtTitle="Ab"/>
	 *  </charts> 
	 * </result>
	 */
	
	var selectedChtId = $('hidQryChartId').get('value');
	cleanCombo('cmbSrcQryChart');
	
	if (ajaxCallXml != null) {
		var charts = ajaxCallXml.getElementsByTagName("charts");
		if (charts != null && charts.length > 0 && charts.item(0) != null) {
			charts = charts.item(0).getElementsByTagName("chart");
			for(var i = 0; i < charts.length; i++) {
				var chart = charts.item(i);
				
				var ele = new Element('option', {
					html : chart.getAttribute('chtTitle'),
					value : chart.getAttribute('chtId')
				}).inject($('cmbSrcQryChart'))
				
				if (selectedChtId==chart.getAttribute('chtId')) ele.set('selected', true);
			}
		}
	}
}
