var Scroller_tblWhereBody;
var Scroller_tableBodyUser;
var Scroller_bodyActionQuery;

var colsUsedInCharts = null;

function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	$$('div.fncDescriptionImage').each(function(e){
		var path = 'url(' + e.get('src') + ')'
		e.setStyle('background-image', path);
		e.setStyle('background-repeat', 'no-repeat');
		e.setStyle('width', '64px');
		e.setStyle('height', '64px');
	});

	initAdminFav();
	initPermissions();
	
	$('frmData').formChecker = new FormCheck(
			'frmData',
			{
				submit:false,
				display : {
					keepFocusOnError : 1,
					tipsPosition: 'left',
					tipsOffsetY: 10,
					tipsOffsetX: -10
				}
			}
	);
	
	var btnConf = $('btnConf');
	if (btnConf){
		btnConf.addEvent("click",function(e){
			e.stop();
			if ($("selQryTyp").value == QRY_TYPE_MODAL && $("tblShows").rows.length <= 0) {
				showMessage(MSG_QRR_REQ_COL_SEL_MOD);
			} else {
				var form = $('frmData');
				//Hago la validacion
				if(!form.formChecker.isFormValid()){
					return;
				}
				
				if(!verifyPermissions()){
					return;
				}
				
				btnConfData_click(true);
			}
		});
	}
	 
	var btnBackToList = $('btnBackToList');
	if (btnBackToList){
		btnBackToList.addEvent("click",function(e){
			e.stop();			
			SYS_PANELS.newPanel();
			var panel = SYS_PANELS.getActive();
			panel.addClass("modalWarning");
			panel.content.innerHTML = GNR_PER_DAT_ING;
			panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); goBackList();\">" + BTN_CONFIRM + "</div>";
			SYS_PANELS.addClose(panel);
			SYS_PANELS.refresh();			
		});
	}
	
	var btnAnt = $('btnAnt');
	if (btnAnt){
		btnAnt.addEvent("click",function(e){
			e.stop();
			sp.show(true);
			window.location = CONTEXT + URL_REQUEST_AJAX + '?action=update&back=true' + TAB_ID_REQUEST;
		});
	}
	
	var btnTest = $('btnTest');
	if (btnTest){
		btnTest.addEvent("click",function(e){
			e.stop();
			if ($("selQryTyp").value == QRY_TYPE_MODAL && $("tblShows").rows[0].cells.length <= 1) {
					showMessage(MSG_QRR_REQ_COL_SEL_MOD);
			} else {
					btnConfData_click(false);
			}			
		});
	}

	var btnAddShowAtt = $('btnAddShowAtt');
	if (btnAddShowAtt){
		btnAddShowAtt.addEvent("click",function(e){
			e.stop();
			showAttributesModal(processAttributesModalReturn)
		});
	}
	
	var btnAddShowCol = $('btnAddShowCol');
	if (btnAddShowCol){
		initColMdlPage();
		initAttMdlPage();
		btnAddShowCol.addEvent("click",function(e){
			e.stop();
			if (! QRY_FREE_SQL_MODE) {
				
				if(FLAG_TO_VIEW){
					COLUMNSMODAL_SHOW_PROC_COLS = false;
				} else {
					COLUMNSMODAL_SHOW_PROC_COLS = true;
				}
				
				showColumnsModal(processColumnsModalReturn,null,true);
			}else{
				generateShow('','','','',QRY_DB_TYPE_COL,"");
				addScrollTable($('tblShows'));
			}
		});
	}
	
	
	var btnAgrPar = $('btnAgrPar');
	if(btnAgrPar){
		initBusClaParMdlPage();
		
		
		btnAgrPar.addEvent("click",function(e){
			e.stop();
			BUS_CLA_PARAM_MODAL_BC_ID = BUS_CLA_ID;
			BUS_CLA_PARAM_MODAL_PAR_TYPE = "I";
			showBusClaParModal(processBusClaParModalReturnWhere, null, true);
		});
	}
	
	var btnAgrParUser = $('btnAgrParUser');
	if(btnAgrParUser){
		initBusClaParMdlPage();
		
		btnAgrParUser.addEvent("click",function(e){
			e.stop();
			BUS_CLA_PARAM_MODAL_BC_ID = BUS_CLA_ID;
			BUS_CLA_PARAM_MODAL_PAR_TYPE = "I";
			showBusClaParModal(processBusClaParModalReturnUser, null, true);
		});
	}
	
	var btnAddShow = $('btnAddShow');
	if(btnAddShow){
		initBusClaParMdlPage();
		
		btnAddShow.addEvent("click",function(e){
			e.stop();
			BUS_CLA_PARAM_MODAL_BC_ID = BUS_CLA_ID;
			BUS_CLA_PARAM_MODAL_PAR_TYPE = "O";
			showBusClaParModal(processBusClaParModalReturn, null, true);
		});
	}
	
	var btnDeleteShow = $('btnDeleteShow');
	if (btnDeleteShow){
		btnDeleteShow.addEvent("click",function(e){
			e.stop();
			SYS_PANELS.showLoading();
			var allRows = $('bodyShow').tHead.rows;
			var cells = allRows[0].cells;
			var count="";
			var c = 0;
			for (var i=1;i< cells.length;i++){
				var chk = cells[i].getElementsByTagName("input");
				if (chk.item(0).checked){
					count+=chk.item(0).id+";";
					c++;
				}
			}
			
			var notDeletedColChart = new Array();
			
			if (c==0){
				SYS_PANELS.closeActive();
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			}else{
				var cols = count.split(";");
				
				//chequear cuales de las columnas a eliminar son usadas en graficas
				checkColsUsedInCharts(cols);				
				
				for (var a=0;a<cols.length;a++){
					if (cols[a]!=""){
						
						//se valida que se puede eliminar la columa
						//no se permiten eliminar columnas cuando se la utiliza en una grafica
						var colName = canDelColChart(cols[a]); 
						if (colName != null){
							notDeletedColChart.push(colName);
							continue;
						}											
						
						var chk = $(cols[a]);
						var col = Number(chk.getAttribute("colid"));
						if ($("selQryTyp").value == QRY_TYPE_ENTITY_MODAL) {
							trows = $("tblShows").rows;
							var name=$("selQryColIdModValueName").value;
							for(var i=0;i<trows.length;i++){
								var inputs=trows[i].cells[col].getElementsByTagName("INPUT");
								for(var u=0;u<inputs.length;u++){
									if(inputs[u].id=="hidShoColName" && inputs[u].value==name){
										return;
									}
								}
							}
						}
					
						//////////////CAM_6218: Habilitar check cuando ya no hay atributos en datos a mostrar
						trows = $("tblShows").rows;
						for (i = 0; i < trows.length; i++) {
							if (trows[i].cells[col].childNodes.length > 0) {
								if (trows[i].cells[col].getElementsByTagName("input")[1] && trows[i].cells[col].getElementsByTagName("input")[1].value != "") {
									attInsert --;
								}
							}
						}
						if (QRY_ALLOW_ATT) {
							if (attInsert == 0) {
								$("chkAllAtt").disabled = false;
								if ($("chkAllAtt").checked) {
									$("selAllAttFrom").style.display = '';
								}
							}
						}
						//////////////////////////////
						
						deleteColumn($('bodyShow'),cols[a]);
						checkActions();
						changeHiddenAtts(); 
					}
				}
				addScrollTable($('tblShows'));
				SYS_PANELS.closeActive();
			}
			
			//Se indican las columnas que no fueron eliminadas por ser utilizadas en graficas
			colsUsedInCharts = null;
			if (notDeletedColChart.length > 0){
				var tok = "";
				for (var i = 0; i < notDeletedColChart.length; i++){
					if (tok != "") tok += ", ";
					tok += notDeletedColChart[i];
				}
				showMessage(MSG_CANT_DEL_COL_CHART.replace("<TOK1>",tok), GNR_TIT_WARNING, 'modalWarning');
			}
		});
	}
	
	var btnLeftShow = $('btnLeftShow');
	if (btnLeftShow){
		btnLeftShow.addEvent("click",function(e){
			e.stop();
			//Mueve columna seleccionada 1 posici�n a la izquierda
			moveColumnToLeft(false);

		});
	}
	
	if (btnRightShow){
		$(btnRightShow).addEvent("click", function(e) {
			e.stop();
			//Mueve columna seleccionada 1 posici�n a la derecha
			moveColumnToRight(false);			
		});
	}
	
	var btnFirstShow = $('btnFirstShow');
	if (btnFirstShow){
		$(btnFirstShow).addEvent("click", function(e) {
			e.stop();
			//Mueve columna seleccionada hasta el principio
			moveColumnToLeft(true);
		});
	}
	
	var btnLastShow = $('btnLastShow');
	if (btnLastShow){
		$(btnLastShow).addEvent("click", function(e) {
			e.stop();
			//Mueve columna seleccionada hasta el final
			moveColumnToRight(true);
		});
	}
	
	var btnUpWhere = $('btnUpWhere');
	if (btnUpWhere){
		btnUpWhere.addEvent("click", function(e) {
			e.stop();
			if(selectionCount($("tblWhereBody")) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var pos = getSelectedRows($("tblWhereBody"))[0].rowIndex;
				var row = upRow(parseInt(pos),"tblWhereBody");
				if (row != null && Scroller_tblWhereBody != null && Scroller_tblWhereBody.v != null){
					Scroller_tblWhereBody.v.showElement(row);
				}
			}		
		});
	}
	
	var btnDownWhere = $('btnDownWhere');
	if (btnDownWhere){
		btnDownWhere.addEvent("click", function(e) {
			e.stop();
			if(selectionCount($("tblWhereBody")) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var pos = getSelectedRows($("tblWhereBody"))[0].rowIndex;
				var row = downRow(parseInt(pos),"tblWhereBody");
				if (row != null && Scroller_tblWhereBody != null && Scroller_tblWhereBody.v != null){
					Scroller_tblWhereBody.v.showElement(row);
				}
			}
		});
	}
	
	var btnDeleteWhere = $('btnDeleteWhere');
	if (btnDeleteWhere){
		btnDeleteWhere.addEvent("click",function(e){
			e.stop();
			if(selectionCount($('tblWhereBody')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				SYS_PANELS.showLoading();
				var rows = getSelectedRows($('tblWhereBody'));
				for (var i=0;i<rows.length;i++){
					deleteRow(parseInt(rows[i].rowIndex),'tblWhereBody');
				}
				Scroller_tblWhereBody = addScrollTable($('tblWhereBody'));
				SYS_PANELS.closeActive();
			} 
		});
	}
	
	var btnAgrCol = $('btnAgrCol');
	if (btnAgrCol){
		btnAgrCol.addEvent("click",function(e){
			e.stop();
			
			if(FLAG_TO_VIEW){
				COLUMNSMODAL_SHOW_PROC_PARAMS = false;
			} else {
				COLUMNSMODAL_SHOW_PROC_PARAMS = true;
			}
			
			showColumnsModal(processColumnsModalReturnWhere,null,true);			
		});
	}
	
	var btnPreview = $('btnPreview');
	if (btnPreview){
		btnPreview.addEvent("click",function(e){
			e.stop();
			previewWhereFilter_click();
		});
	}
	
	var btnUpUser = $('btnUpUser');
	if (btnUpUser){
		btnUpUser.addEvent("click", function(e) {
			e.stop();
			if(selectionCount($("tableBodyUser")) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var pos = getSelectedRows($("tableBodyUser"))[0].rowIndex;
				var row = upRow(parseInt(pos),"tableBodyUser");
				if (row != null && Scroller_tableBodyUser != null && Scroller_tableBodyUser.v != null){
					Scroller_tableBodyUser.v.showElement(row);
				}
			}		
		});
	}
	
	var btnDownUser = $('btnDownUser');
	if (btnDownUser){
		btnDownUser.addEvent("click", function(e) {
			e.stop();
			if(selectionCount($("tableBodyUser")) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var pos = getSelectedRows($("tableBodyUser"))[0].rowIndex;
				var row = downRow(parseInt(pos),"tableBodyUser");
				if (row != null && Scroller_tableBodyUser != null && Scroller_tableBodyUser.v != null){
					Scroller_tableBodyUser.v.showElement(row);
				}
			}
		});
	}
	
	var btnDeleteUser = $('btnDeleteUser');
	if (btnDeleteUser){
		btnDeleteUser.addEvent("click",function(e){
			e.stop();
			if(selectionCount($('tableBodyUser')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				SYS_PANELS.showLoading();
				var rows = getSelectedRows($('tableBodyUser'));
				for (var i=0;i<rows.length;i++){
					deleteRow(parseInt(rows[i].rowIndex),'tableBodyUser');
				}
				Scroller_tableBodyUser = addScrollTable($('tableBodyUser'));
				SYS_PANELS.closeActive();
			} 
		});
	}
	
	var btnAgrColUser = $('btnAgrColUser');
	if (btnAgrColUser){
		btnAgrColUser.addEvent("click",function(e){
			e.stop();
			if (!QRY_FREE_SQL_MODE) {
				if(FLAG_TO_VIEW){
					COLUMNSMODAL_SHOW_PROC_PARAMS = false;
				} else {
					COLUMNSMODAL_SHOW_PROC_PARAMS = true;
				}
				showColumnsModal(processColumnsModalReturnUser,null,true);
			}else{
				generateUser('','','','',QRY_DB_TYPE_COL,"");
			}
		});
	}
	
	var btnAddAttRemping = $('btnAddAttRemping');
	if (btnAddAttRemping){
		initAttMdlPage();
		btnAddAttRemping.addEvent("click",function(e){
			e.stop();
			showAttributesModal(processAttributesRemapingModalReturn)
		});
	}
	
	var btnDeleteAttRemping = $('btnDeleteAttRemping');
	if (btnDeleteAttRemping){
		btnDeleteAttRemping.addEvent("click",function(e){
			e.stop();
			if(selectionCount($('bodyAttRemping')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var rows = getSelectedRows($('bodyAttRemping'));
				for (var i=0;i<rows.length;i++){
					deleteRow(parseInt(rows[i].rowIndex),'bodyAttRemping');
				}
				addScrollTable($('bodyAttRemping'));
			} 
		});
	}
	
	var btnAddChart = $('btnAddChart');
	if (btnAddChart){
		initAttMdlPage();
		btnAddChart.addEvent("click",function(e){
			e.stop();
			showGraph(findNewId(),false);
		});
	}
	
	var btnDeleteChart = $('btnDeleteChart');
	if (btnDeleteChart){
		btnDeleteChart.addEvent("click",function(e){
			e.stop();
			if(selectionCount($('bodyChart')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var rows = getSelectedRows($('bodyChart'));
				for (var i=0;i<rows.length;i++){
					deleteRow(parseInt(rows[i].rowIndex),'bodyChart');
				}
				addScrollTable($('bodyChart'));
			} 
		});
	}
	
	var btnResetImg = $('btnResetImg');
	if (btnResetImg){
		btnResetImg.addEvent("click",function(e){
			e.stop();
			var txtImgPath = $('txtImgPath');
			var changeImg = $('changeImg'); 
			changeImg.style.backgroundImage = "url('"+CONTEXT + PATH_IMG + DEFAULT_IMG+"')";
			txtImgPath.value = DEFAULT_IMG;
		});
	}
	
	var btnUseAsFilter = $('btnUseAsFilter');
	if(btnUseAsFilter && !QRY_FREE_SQL_MODE) {
		btnUseAsFilter.addEvent('click', function(e) {
			e.stop();
			
			//Obtener todas las columnas checkeadas y que se pueden poner como filtros (columnas, no atributos)
			var bodyShow =  $('bodyShow');
			var bodyRows = bodyShow.getElements('tr');
			var checks = bodyShow.getElements('th').getElements('input');
			var cols = {};
			var colsName = [];
			var colsType = {};
			var firstTR = $('tblShows').getElement('tr').getElements('td');
			if(checks) {
				checks = checks.flatten();
				for(var i = 0; i < checks.length; i++) {
					if(checks[i].get('checked')) {
						if(firstTR[i+1].getElements('input').some(function(item) {
							return (item.get('name') == 'hidShoAttId' && item.get('value') == ''); 
						})) {
							var colName = firstTR[i + 1].getElement('span').get('html');
							colsName.push(colName);
							var aux_inputs = firstTR[i + 1].getElements('input');
							if(aux_inputs.length >= 7)
								colsType[colName] = firstTR[i + 1].getElements('input')[6].get('value');
							else
								colsType[colName] = firstTR[i + 1].getElements('input')[5].get('value');
							cols[colName] = i + 1;
						}
					} 
				}
			}
			
			//Quitar las columnas que ya est�n como filtros de usuarios
			var filters = $('tableBodyUser').getElements('tr');
			if(filters) {
				filters = filters.getElement('td');
				filters.flatten();
				filters = filters.getElement('span').get('html').flatten();
				
				colsName = colsName.filter(function(item) {
					return (filters.indexOf(item) < 0);
				});
			}
			
			if(colsName.length) {
				var msg = MSG_USE_AS_FILTER_1 + '<ul>';
				colsName.each(function(item) { msg += '<li>' + item + '</li>'; });
				msg += '</ul>';
				//Confirmar que se quieren estableces XY columnas como filtro de usuario
				showConfirm(msg, LBL_USE_AS_FILTER, function(result) {
					
					//Agregar las columnas como filtros de usuario
					if(result) {
						var rows = [];
						colsName.each(function(item) {
							var tr = new Element('tr').set('rowid', item).set('id', item).set('type', colsType[item]);
							tr.setAttribute('type', colsType[item]);
							new Element('span').set('html', item).inject(new Element('div').inject(new Element('td').inject(tr)));
							tr.getRowContent = function() {
								return [this.get('id')];
							}
							rows.push(tr);
						});
						processColumnsModalReturnUser(rows);
						
						//Para cada row, modificar 'Mostrar como' y tooltip
						var tableBodyUserRows = $('tableBodyUser').rows;
						if(tableBodyUserRows) {
							colsName.each(function(col_name) {
								for(var l = 0; l < tableBodyUserRows.length; l++) {
									if(tableBodyUserRows[l].cells[0].getElement('span').get('html') == col_name) {
										
										var new_val = bodyRows[3].getElements('td')[cols[col_name]].getElement('input').get('value');
										changeFilterColumn(tableBodyUserRows[l], 'input', 'txtUserHeadName', new_val);
										
										new_val = bodyRows[4].getElements('td')[cols[col_name]].getElement('input').get('value');
										changeFilterColumn(tableBodyUserRows[l], 'input', 'txtUserTool', new_val);
										
										if(tableBodyUserRows[l].cells[13].getElement('select')) {
											new_val = bodyRows[12].getElements('td')[cols[col_name]].getElement('select').get('value');
											changeFilterColumn(tableBodyUserRows[l], 'select', 'cmbBusEntIdFilter', new_val);
										}
									}	
								}
							});
						}
					}
				});
			} else {
				showMessage(MSG_USE_AS_FILTER_2, LBL_USE_AS_FILTER);
			}
			
			
		});
	}
	
	if ($('tabActions')){
		$('tabActions').addEvent("focus", function(evt){chkActVieQry_click();});
        $('tabActions').addEvent("blur", function(evt){
        	$("btnUpActionQuery").style.visibility = 'hidden';
        	$("btnDownActionQuery").style.visibility = 'hidden';
        	$("btnAddActionQuery").style.visibility = 'hidden';
        	$("btnDeleteActionQuery").style.visibility = 'hidden';
        });
	}
	
	var tabQryWhere = $("tabQryWhere");
	if (tabQryWhere){
		tabQryWhere.addEvent("focus", function(evt){
			Scroller_tblWhereBody = addScrollTable($('tblWhereBody'));
		});
	}
	
	var tabQryWhereUser = $("tabQryWhereUser");
	if (tabQryWhereUser){
		tabQryWhereUser.addEvent("focus", function(evt){
			Scroller_tblWhereBody = addScrollTable($('tableBodyUser'));
		});
	}
	
	var tabActions = $("tabActions");
	if (tabActions){
		tabActions.addEvent("focus", function(evt){
			Scroller_bodyActionQuery = addScrollTable($('bodyActionQuery'));
		});
	}
	
	var tabQryAttRemap = $("tabQryAttRemap");
	if (tabQryAttRemap){
		tabQryAttRemap.addEvent("focus", function(evt){
			addScrollTable($('bodyAttRemping'));
		});
	}
	
	
	initGrid($('tblShows'));	
	loadShowColumns();
	loadWhere();
	loadWhereUser();
	
	if (IS_QUERY_TYPE_OFFLINE){
		paramSave_onChange();
		paramMax_onClick();
		loadSchedulers();
	}
	
	var divQueryButtons = $('divQueryButtons');
	if (divQueryButtons) loadQueryButtons();
	
	if (isQuery){
		initQueryAction();		
		getGraphs();		
	}
	
	if (!IS_QUERY_TYPE_OFFLINE) loadEvents();
	if (TYPE_MON_ENTITY) loadAttRemaping();
	
	var changeImg = $('changeImg');
	if (changeImg){
		changeImg.addEvent("click",function(e){
			e.stop();
			showImagesModal(processImg);
		});
	}
	
	initImgMdlPage();
	
	//Setear listener de scroll para headers de tablas
	$$('*.gridHeader').each(function(gridHeader) {
		var table = gridHeader.getChildren('table');
		if (table) {
			//var gridBody = $('gridBody');
			var gridBody = gridHeader.getParent().getElement('*.gridBody');
			if(!gridBody && console) console.log("updateData.js, no encuentra gridBody");
			
			if(gridBody == gridHeader)
				return;
			
			gridBody.tableHeader = table;
			gridBody.addEvent('scroll', function() {			
				this.tableHeader.setStyle('left', - this.scrollLeft);
			});
			gridBody.addEvent('custom_scroll', function(left) {			
				this.tableHeader.setStyle('left', left);
			});
		}
	});
	
	paramMax_onClick();
	
	initGrid($('qryFixedColumn').getElement('tbody'));
}

function moveColumnToLeft(toLast){
	var allRows = $('bodyShow').tHead.rows;
	var cells = allRows[0].cells;
	var count="";
	var colArray = [];
	var firstTd;
	for (var i=1;i< cells.length;i++){
		var chk = cells[i].getElementsByTagName("input");
		if (chk.item(0).checked){
			colArray.push(Number(chk.item(0).getAttribute("colid")));
			if(!firstTd)
				firstTd = chk[0].getParent('th');
		}
	}
	if (colArray.length) {
		//Ya vienen ordenados
		var j = 1;
		
		if (toLast)
			moveCount = colArray[0] - 1;
		else
			moveCount = 1;
		
		for(i = 0; i < colArray.length; i++, j++) {
			if (colArray[i] > j){
				for(k = 0; k < moveCount; k++){
					swapColumn($('bodyShow'), colArray[i] - k, colArray[i] - k - 1);
				}
			}
		}
		
		dataShowScroll.h.showElement(firstTd);
		
	} else {
		showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
	}	
}

function moveColumnToRight(toLast){
	var allRows = $('bodyShow').tHead.rows;
	var cells = allRows[0].cells;
	var count="";
	var colArray = [];
	var firstTd;
	for (var i=1;i< cells.length;i++){
		var chk = cells[i].getElementsByTagName("input");
		if (chk.item(0).checked){
			colArray.push(Number(chk.item(0).getAttribute("colid")));
			firstTd = chk[0].getParent('th'); //Para quedarme con el ultimo
		}
	}
	if (colArray.length) {
		//Ya vienen ordenados
		var j = cells.length - 1;
		
		if (toLast)
			moveCount = $('bodyShow').rows[0].cells.length - colArray[colArray.length - 1] - 1;
		else
			moveCount = 1;
		
		for(i = colArray.length - 1; i >= 0; i--, j--) {
			if (colArray[i] < j){
				for(k = 0; k < moveCount; k++){							
					swapColumn($('bodyShow'), colArray[i] + k, colArray[i] + k + 1);	
				}
			}
		}
		
		dataShowScroll.h.showElement(firstTd);
	} else {
		showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
	}
}

var dataShowScroll;

function processImg(ret){
	if (ret != null){
		$('changeImg').style.backgroundImage = "url('"+ret.path+"')";
		$('txtImgPath').value=ret.id;
	}
}


var width = "150px";

//---
//--- Funciones generales
//---

function clearValidations(){
	var validations = $('frmData').formChecker.validations;
	var i = validations.length-1;
	while (i>=0){
		disposeValidation(validations[i]);
		i--;
	}
}

function checkValidations(obj,formName){
	
	var validations = $(formName!=null?formName:'frmData').formChecker.validations;
	if (obj!=null){
		for (var i=0;i<validations.length;i++){
			if (obj== validations[i]){
				return false;
			}
		}
		return true;
	}
	return false;
}

function registerValidation(obj,className,formName){
	var ok = checkValidations(obj,formName);
	if (ok){
		if (!className){
			obj.addClass("validate['required']");
		}else{
			obj.addClass(className);
		}		
		$(formName!=null?formName:'frmData').formChecker.register(obj);
	}
}

function disposeValidation(obj,formName){
	if (obj!=null){
		$(formName!=null?formName:'frmData').formChecker.dispose(obj);
	}
}

function btnConfData_click(doConfirm){
	if (validateParentesis() && wsOk()) {		
		processcmbExecOnCha();
		processcmbSorted();
		processCmbUserTime();
		processCmbShow2Column();
		processCmbShoTime();
		processCmbIsHTML();
		processCmbJoinAttValues();
		processCmbDontExport();
		processCmbUseUpper();
		processCmbHidFilSel();
		processCmbFilDontUseAutoFilter();
		processActVieQryToAllowAutoFilter();
		processCmbDontUseAutoFilter();
		processCmbHidChtId();		
		processCmbIsReadOnly();
	
		 var params = getFormParametersToSendQuery($('frmData'));
		 var request = new Request({
		 method: 'post',		 
		 url: CONTEXT + URL_REQUEST_AJAX + '?action='+(doConfirm?"confirm":"test")+'&isAjax=true' + TAB_ID_REQUEST,
		 onRequest: function() { SYS_PANELS.showLoading(); },
		 onComplete: function(resText, resXml) {modalProcessXml(resXml);}, 
		 }).send(params);
	}
}

function wsOk(){	
	if(($("chkPubWs") != null) && $("chkPubWs").checked){
		if($("tblShows").rows.length < 1){
			showMessage(msgWsShowCols);
			return false;
		}
	}
	return true;
}

function downRow(pos,tblName){
	var p = pos-1;
	var table = $(tblName);	
	if (pos==table.rows.length){
		return
	}else{
		table.rows[p].parentNode.insertBefore(table.rows[p+1],table.rows[p]);
		table.rows[p].setRowId(p);
		table.rows[p+1].setRowId(p+1);
		toogleLastTr(tblName);
		
		return table.rows[p+1];
	}
}

function upRow(pos,tblName){
	var p = pos-1;
	var table = $(tblName);
	if (p==0){
		return
	}else{
		table.rows[p].parentNode.insertBefore(table.rows[p],table.rows[p-1]);
		table.rows[p-1].setRowId(p-1);
		table.rows[p].setRowId(p);
		toogleLastTr(tblName);
		
		return table.rows[p-1]; 
	}	
}

function myToggle(oTr){
	if (oTr.getParent().selectOnlyOne) {
		var parent = oTr.getParent();
		if (parent.lastSelected) parent.lastSelected.toggleClass("selectedTR");
		parent.lastSelected = oTr;
	}
	oTr.toggleClass("selectedTR"); 
}

function deleteRow(pos,tblName) {
	var table = $(tblName);
	var row = table.rows[pos-1];
	var nodes = row.childNodes;
	for (var k=0;k<nodes.length;k++){
		if(nodes[k].tagName.toUpperCase() == 'TD') {
			var nodes_els = nodes[k].getElements('*');
			if(nodes_els)
				nodes_els.each(function(item) {disposeValidation(item);});
		} else {
			disposeValidation(nodes[k]);
		}
	}
	
	row.dispose();
	for (var i=0;i<table.rows.length;i++){
		table.rows[i].setRowId(i);
		if (i%2==0){
			table.rows[i].addClass("trOdd");
		}else{
			table.rows[i].removeClass("trOdd");
		}
	}
	
	toogleLastTr(tblName);	
} 

function severalProperties(domElement,auxRow){
	var auxValidation = new Array();
	if (auxRow.width!=null && auxRow.width!=''){
		domElement.style.width=auxRow.width;
	}
	if (auxRow.display!=null && auxRow.display!=""){
		domElement.style.display=auxRow.display;
		//domElement.setAttribute('style','display:'+auxRow.display);
	}
	if (auxRow.disabled!=null && auxRow.disabled){
		domElement.setAttribute('disabled',"true");
	}
	if (auxRow.className!=null){
		domElement.addClass(auxRow.className);
	}
	if (auxRow.validation!=null){
		auxValidation.push(auxRow.validation);
	}
	if (auxRow.required){
		new Element('span',{html:"&nbsp;*"}).inject(domElement,"after");
		auxValidation.push("required");
		domElement.setStyle("width","90%");
	}						
	if (auxValidation.length!=0){
		var strV = ""; 
		for (var hh=0; hh < auxValidation.length; hh++){
			strV+="'"+auxValidation[hh]+"',";
		}
		strV = strV.substring(0,strV.lastIndexOf(","));							
		registerValidation(domElement,"validate["+strV+"]");
	}
	if (auxRow.format!=null){
		domElement.setAttribute("format",auxRow.format);
	} 
	if (auxRow.hasDatePicker!=null && auxRow.hasDatePicker){
		if (auxRow.value!=null&&auxRow.value=="__/__/____"){
			domElement.setAttribute("value","");			
		}
		domElement.setStyle("width","88%");
		setAdmDatePicker(domElement);
	}
	if (auxRow.className!=null){
		domElement.addClass(auxRow.className);
	}
	
	if (auxRow.bgColor!=null){
		domElement.style.backgroundColor=auxRow.bgColor;
	}
	
	if (auxRow.isReadOnly){
		domElement.readOnly=auxRow.isReadOnly;
	}
	
	if (auxRow.onclick!=null){
		domElement.setAttribute("onclick",auxRow.onclick);
	}
	if (auxRow.onkeypress!=null){
		domElement.setAttribute("onkeypress",auxRow.onkeypress);
	}
	
	if (auxRow.onchange && auxRow.id != "cmbWheTip" && auxRow.id != "cmbColFun") {
		domElement.addEvent('change', auxRow.onchange);
	}
}

function processTd(td){
	
	var cells = td.getElementsByTagName("cell");
	var i=0;
	var arrayCell = new Array();
	var arrayTd = new Array();
	while (i<cells.length){
		var cc = cells[i];		
		var ccType = cc.getAttribute("type");	
		
		var display = cc.getAttribute("display");
		var isRequired = toBoolean(cc.getAttribute("required"));
		var validation = cc.getAttribute("validation");
		var isChecked = toBoolean(cc.getAttribute("checked"));
		var isDisabled = toBoolean(cc.getAttribute("disabled"));
		var firstChild = cc.firstChild;		
		var isReadOnly = toBoolean(cc.getAttribute("readonly"));
		
		if (ccType!="text"&&ccType!="colorpicker"){
			var ccName = firstChild.getAttribute("name");
			var ccId = firstChild.getAttribute("id");
		}
		
		if (ccType =="input") {
			var aux = {'type':'text',name:ccName,id:ccId,'required':isRequired,value:firstChild.getAttribute("value"),'display':display,'validation':validation,hasDatePicker:cc.getAttribute("hasDatePicker"),disabled:isDisabled,bgColor:cc.getAttribute("bgColor"),isReadOnly:isReadOnly,'onkeypress':firstChild.getAttribute("onkeypress")};
		}else if (ccType =="checkbox") {
			var aux = {'type':'checkbox',name:ccName,id:ccId,'required':isRequired,'checked':isChecked,'display':display,disabled:isDisabled,'onclick':firstChild.getAttribute("onclick"), value: firstChild.getAttribute("value")};
		}else if (ccType =="hidden") {
			var aux = {'type':'hidden',name:ccName,id:ccId,'required':isRequired,value:firstChild.getAttribute("value"),'display':display,disabled:isDisabled};
		}else if (ccType =="combo") {
			
			var selectedValue = firstChild.getAttribute("value");
			
			var options = firstChild.getElementsByTagName("option");
			var arrayOptions = new Array();
			for (var m = 0; m < options.length; m++) {
				var option = options.item(m);
				
				var optionValue = option.getAttribute("value");
				var optionText = (option.firstChild != null)?option.firstChild.nodeValue:""; 
				
				var selected = false;
				if (selectedValue!="" && selectedValue == optionValue || selectedValue=="" && m==0){
					selected = true;
				}
				
				arrayOptions.push({'value':optionValue,'text':optionText,'selected':selected,validFor:option.getAttribute("validFor")});							
			}
			
			var onChangeFunc = firstChild.getAttribute("onChange");			
			var aux = {'type':'combo',name:ccName,id:ccId,'required':isRequired,'options':arrayOptions,'display':display,disabled:isDisabled,'width':cc.getAttribute("width"),'onchange':onChangeFunc};
		}else if (ccType =="text"){
			var aux = {'type':'span',html:firstChild.nodeValue};
		}else if (ccType=="colorpicker"){
			var aux = {'type':'colorpicker'};
		}
		arrayCell.push(aux);
		i++;
	}
	lCount = i;
	return arrayCell;
}

function populateCombo(firstChild,hasEmpty){
	var id = firstChild.getAttribute("id");
	
	var aux = $(id);
	aux.options.length=0;			
	
	var selectedValue = firstChild.getAttribute("value");
	
	var options = firstChild.getElementsByTagName("option");
	var arrayOptions = new Array();
	
	var optionDOM = new Element('option');
	if (hasEmpty){
		optionDOM.setProperty('value',"");
		optionDOM.appendText("");
	
		if (selectedValue!="" && selectedValue!="null"){
			optionDOM.setProperty('selected',"selected");
		}	
		optionDOM.inject(aux);
	}
	for (var m = 0; m < options.length; m++) {
		var option = options.item(m);
		
		var optionValue = option.getAttribute("value");
		var optionText = (option.firstChild != null)?option.firstChild.nodeValue:""; 
		
		optionDOM = new Element('option');
		optionDOM.setProperty('value',optionValue);
		optionDOM.appendText(optionText);
		if (selectedValue!="" && optionValue==selectedValue){
			optionDOM.setProperty('selected',"selected");
		}		
		if (option.getAttribute("twod")!=null){
			optionDOM.setProperty('twod',option.getAttribute("twod"));
		}
		if (option.getAttribute("threed")!=null){
			optionDOM.setProperty('threed',option.getAttribute("threed"));
		}
		optionDOM.inject(aux);							
	}
}

function getFormParametersToSendQuery(form) { //se realiza el encoding de todos los parametros que se envian: encodeURIComponent
	var params = "";
	if (form.childNodes.length > 0) {
		for (var i = 0; i < form.elements.length; i++) {
			var formElement = form.elements[i];
			
			var formEleName = formElement.name;
			var formEleValue = formElement.value;
			var avoidSend = toBoolean(formElement.getAttribute("avoidSend"));
			
			if (avoidSend) continue;
			if (formEleName == null || formEleName == "") continue;
			
			if (formElement.tagName == "TEXTAREA" && toBoolean(formElement.getAttribute("isEditor"))) {
				var inst = tinyMCE.getInstanceById(formElement.id);
				formEleValue = inst.getContent();
				tinyMCE.execCommand('mceRemoveControl', false, formElement.id);
			}
			
			if (formElement.type == "select-multiple") {
				for ( var j = 0; j < formElement.options.length; j++) {
					if (formElement.options[j].selected) {
						if (params != "") params += "&";
						params += formEleName + "=" + encodeURIComponent(formElement.options[j].value);
					}
				}
			}else if ((formElement.type == "checkbox") || (formElement.type == "radio" && formElement.checked) || (formElement.type != "radio" && formElement.type != "checkbox"))  {
				if(formElement.type == "checkbox"){
					if (!formElement.checked){
						formEleValue="0";
					}
				}
				if (formElement.getAttribute("hasdatepicker")=="true"){
					if (formElement.style.display=='none'){
						formEleValue = formElement.getNext().value;
					}
				}
				if (SITE_ESCAPE_AJAX) formEleValue = escape(formEleValue);
				if (!formElement.disabled||formElement.type == "select-one"){
					if (params != "") params += "&";
					params += formEleName + "=" + encodeURIComponent(formEleValue);
				}
			}
		}
	}
	return params;
}



//---
//--- Funciones para determinar el valor de ser utilizado en un filtro
//---
function cmbWheTip_change(cmb) {
	var cmbFun = cmb.parentNode.getElementsByTagName("SELECT")[1];
	var txtVal = cmb.parentNode.getElementsByTagName("INPUT")[0];
	var useParent = txtVal == null;
	if (useParent) txtVal = cmb.parentNode.parentNode.getElementsByTagName("INPUT")[0];
	
	if (cmb.value==COLUMN_TYPE_FILTER){
		cmbFun.style.display='none';
		txtVal.style.display='';
		if (useParent) txtVal.parentElement.style.display='';
		
		disposeValidation(cmbFun);
		registerValidation(txtVal,"validate['required']");
	}else{
		txtVal.style.display='none';
		if (useParent) txtVal.parentElement.style.display='none';
		cmbFun.style.display='';
		
		disposeValidation(txtVal);
		registerValidation(cmbFun,"validate['required']");
	}
}

//---
//--- Funciones datos a mostrar
//---

function initGrid(tbl){
	if (tbl!=null){
		var c = "";
		for (var i=0;i<tbl.rows.length;i++){
//			var ok = true;
//			var tds = tbl.rows[i].getElementsByTagName("td");
//			for (var j=0;j<tds.length;j++){
//				if (tds[j].style.display=='none'){
//					ok = false;
//					break;
//				}
//			}
			var ok = false;
			var tds = tbl.rows[i].getElementsByTagName("td");
			for (var j=0;j<tds.length;j++){
				if (tds[j].style.display!='none'){
					ok = true;
					break;
				}
			}
			var a_row = $(tbl.rows[i]).erase('class');
			if (ok){
				a_row.addClass(c);
				c = (c == ""?"trOdd":"");
			}
			
		}	
	}
}

function loadShowColumns(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadShowColumns&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { },
		onComplete: function(resText, resXml) {
			modalProcessXml(resXml);
			dataShowScroll = addScrollTable($('tblShows'));
		}
	}).send();
}

function processLoadShow(){
	var resXml = getLastFunctionAjaxCall(); 
	var tableDOM = resXml.getElementsByTagName("table");
	if (tableDOM!=null){
		var rows = tableDOM.item(0).getElementsByTagName("row");
		for (var i=0;i<rows.length;i++){
			var row = rows.item(i);
			
			var cells = row.getElementsByTagName("cell");
			var k = 0;
			var arrayColumn = new Array();
			while (k < cells.length){		
				var cell = cells.item(k);
				var type = cell.getAttribute("type");
				var tdDisplay = cell.getAttribute("display");
				var l = 0;				
				if (type=="row"){
					var arrayRows = new Array();
					var cellsCol = cell.getElementsByTagName("cell");
					while (l < cellsCol.length){	
						var cc = cellsCol.item(l);
						
						var isChecked = toBoolean(cc.getAttribute("checked"));
						var display = cc.getAttribute("display");
						var isRequired = toBoolean(cc.getAttribute("required"));
						var validation = cc.getAttribute("validation");
						var visibility = cc.getAttribute("visibility");
						
						var ccType = cc.getAttribute("type");						
						var firstChild = cc.firstChild;		
						if (ccType!="text"){
							var ccName = firstChild.getAttribute("name");
							var ccId = firstChild.getAttribute("id");
						}
						if (ccType =="input"){
							var aux = {'type':'text',name:ccName,id:ccId,'required':isRequired,value:firstChild.getAttribute("value"),'display':display,'validation':validation};
						}else if (ccType =="checkbox"){
							var aux = {'type':'checkbox',name:ccName,id:ccId,'required':isRequired,'checked':isChecked,'display':display,value:firstChild.getAttribute("value")};
						}else if (ccType =="hidden"){
							var aux = {'type':'hidden',name:ccName,id:ccId,'required':isRequired,value:firstChild.getAttribute("value"),'display':display};
						}else if (ccType =="combo"){
							
							var selectedValue = firstChild.getAttribute("value");
							
							var options = firstChild.getElementsByTagName("option");
							var arrayOptions = new Array();
							for (var m = 0; m < options.length; m++) {
								var option = options.item(m);
								
								var optionValue = option.getAttribute("value");
								var optionText = (option.firstChild != null)?option.firstChild.nodeValue:""; 
								
								var selected = false;
								if (selectedValue!="" && selectedValue == optionValue || selectedValue=="" && m==0){
									selected = true;
								}
								
								arrayOptions.push({'value':optionValue,'text':optionText,'selected':selected});							
							}
							var aux = {'type':'combo',name:ccName,id:ccId,'required':isRequired,'options':arrayOptions,'display':display,width:cc.getAttribute("width")};
						}else if (ccType =="text"){
							var aux = {'type':'span',html:firstChild.nodeValue};
						}				
						
						if (visibility != null){
							aux.visibility = visibility;
						}
						
						arrayRows.push(aux);
						l++;
					}
					arrayColumn.push({'display':tdDisplay,arr:arrayRows}); 
				}				
				k +=l;
				k++;
			}			
			addColumn($('bodyShow'),"Show",arrayColumn,width);
		}
		if (isQuery){
			checkActions();
		}
		
		initGrid($('tblShows'));
	}
}

function processBusClaParModalReturnUser(ret){
	var notAllowAux = new Array();
	var trows = $('tableBodyUser').rows;
	var count = 0;
	for (var j = 0; j < ret.length; j++){
		var e = ret[j];
		var addRet = true;	
		var text = e.getRowContent()[0];
		for (i=0;i<trows.length && addRet;i++) {
			if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[4].value == text) {
				addRet = false;
			}
		}
		if (addRet) {
			if (! inNotAllowed(text)) {
				generateUser('',text,text,e.getAttribute("type"),QRY_DB_TYPE_COL,"");
			} else {
				notAllowAux.push(text);
			}
		}			
	}
	addScrollTable($('tableBodyUser'));
	SYS_PANELS.closeAll();
	
	if (notAllowAux.length == 1){
		showMessage(MSG_COL_NOT_ALLOW.replace("<TOK1>",notAllowAux[0]), GNR_TIT_WARNING, 'modalWarning');
	} else if (notAllowAux.length > 1){
		var tok = "";
		for (var i = 0; i < notAllowAux.length; i++){
			if (tok != "") tok += ", ";
			tok += notAllowAux[i];			
		}
		showMessage(MSG_COL_NOT_ALLOW_S.replace("<TOK1>",tok), GNR_TIT_WARNING, 'modalWarning');
	}
}

function processBusClaParModalReturnWhere(ret){
	var notAllowAux = new Array();
	for (var i = 0; i < ret.length; i++){
		var e = ret[i];	
		var text = e.getRowContent()[0];
		if (! inNotAllowed(text)) {
			generateWhere('',text,text,e.getAttribute("type"),QRY_DB_TYPE_COL,"",true);
		} else {
			notAllowAux.push(text);
		}
	}
	Scroller_tblWhereBody = addScrollTable($('tblWhereBody'));
	SYS_PANELS.closeAll();
	if (notAllowAux.length == 1){
		showMessage(MSG_COL_NOT_ALLOW.replace("<TOK1>",notAllowAux[0]), GNR_TIT_WARNING, 'modalWarning');
	} else if (notAllowAux.length > 1){
		var tok = "";
		for (var i = 0; i < notAllowAux.length; i++){
			if (tok != "") tok += ", ";
			tok += notAllowAux[i];			
		}
		showMessage(MSG_COL_NOT_ALLOW_S.replace("<TOK1>",tok), GNR_TIT_WARNING, 'modalWarning');
	}	
}

function processBusClaParModalReturn(ret){
	var notAllowAux = new Array();
	var trows = $('tblShows').rows;
	var count = 0;
	for (var j = 0; j < ret.length; j++){
		var e = ret[j];
		var addRet = true;	
		var text = e.getRowContent()[0];
		for (var i=1;i<trows[0].cells.length&&addRet;i++) {
			if (trows[0].getElementsByTagName("TD")[i].getElementsByTagName("INPUT")[4].value.toUpperCase() == text.toUpperCase()) {
				addRet = false;
			}
		}
		if (addRet) {
			if (! inNotAllowed(text)) {
				generateShow('',text,text,e.getAttribute("type"),QRY_DB_TYPE_COL,"");
			} else {
				notAllowAux.push(text);
			}
		}		
		count++;
	}
	if (count!=0){
		checkActions();
		changeHiddenAtts();
	}	
	addScrollTable($('tblShows'));
	SYS_PANELS.closeAll();
	
	if (notAllowAux.length == 1){
		showMessage(MSG_COL_NOT_ALLOW.replace("<TOK1>",notAllowAux[0]), GNR_TIT_WARNING, 'modalWarning');
	} else if (notAllowAux.length > 1){
		var tok = "";
		for (var i = 0; i < notAllowAux.length; i++){
			if (tok != "") tok += ", ";
			tok += notAllowAux[i];			
		}
		showMessage(MSG_COL_NOT_ALLOW_S.replace("<TOK1>",tok), GNR_TIT_WARNING, 'modalWarning');
	}
}

function processColumnsModalReturn(ret){
	var notAllowAux = new Array();
	var trows = $('tblShows').rows;
	var count = 0;
	for (var j = 0; j < ret.length; j++){
		var e = ret[j];
		var addRet = true;	
		var text = e.getRowContent()[0];
		
		for (var i=1;i<trows[0].cells.length&&addRet;i++) {
			if (trows[0].getElementsByTagName("TD")[i].getElementsByTagName("INPUT")[5].value.toUpperCase() == text.toUpperCase()) {
				addRet = false;
			}
		}
		if (addRet) {
			if (! inNotAllowed(text)) {
				generateShow('',text,text,e.getAttribute("type"),QRY_DB_TYPE_COL,"");
			} else {
				notAllowAux.push(text);
			}
			count++;
		}		
		
	}
	if (count!=0){
		checkActions();
		changeHiddenAtts();
	}	
	addScrollTable($('tblShows'));
	SYS_PANELS.closeAll();
	
	if (notAllowAux.length == 1){
		showMessage(MSG_COL_NOT_ALLOW.replace("<TOK1>",notAllowAux[0]), GNR_TIT_WARNING, 'modalWarning');
	} else if (notAllowAux.length > 1){
		var tok = "";
		for (var i = 0; i < notAllowAux.length; i++){
			if (tok != "") tok += ", ";
			tok += notAllowAux[i];			
		}
		showMessage(MSG_COL_NOT_ALLOW_S.replace("<TOK1>",tok), GNR_TIT_WARNING, 'modalWarning');
	}
}

function processAttributesModalReturn(ret){
	var trows = $('tblShows').rows;
	var count = 0;
	ret.each(function(e){
		var addRet = true;	
		var colName = e.getRowContent()[0];
		var headName = e.getAttribute("headName");
		var type = e.getAttribute("type");
		
		for (var i=1;i<trows[0].cells.length&&addRet;i++) {
			if (trows[0].getElementsByTagName("TD")[i].getElementsByTagName("INPUT")[5].value.toUpperCase() == colName.toUpperCase()) {
				addRet = false;
			}
		}
		if (addRet) {
			if (e.getRowId() != "") {
				attInsert ++;
			} 
			//generateShow("",colName,headName,type,QRT_DB_TYPE_NONE,e.getRowId());
			//ret[0] = busClaParId
			//ret[1] = colName
			//ret[2] = headName
			//ret[3] = type
			generateShow(e.getRowId(),colName,headName,type,QRT_DB_TYPE_NONE,"");
			
			count++;
		}		
		
	});
	if (count!=0){		
		changeHiddenAtts();
	}
	addScrollTable($('tblShows'));
}

//---------------------------------------
//--- Funciones para checkbox de combos
//---------------------------------------

function processcmbExecOnCha() {
	processCheckbox("cmbExecOnCha");
}

function processcmbSorted() {
	processCheckbox("cmbSorted");
}

function processCmbUserTime() {
	processCheckbox("cmbUserTime");
}

function processCmbShow2Column() {
	processCheckbox("cmbShow2Column");
}

function processCmbShoTime() {
	processCheckbox("cmbShoTime");
}

function processCmbIsHTML(){
	processCheckbox("cmbIsHTML");
}

function processCmbJoinAttValues(){
	processCheckbox("cmbJoinAttValues");
}

function processCmbDontExport() {
	processCheckbox("cmbDontExport");
}

function processCmbUseUpper() {
	processCheckbox("cmbUseUpper");
}

function processCmbHidFilSel() {
	processCheckbox("cmbHidFilSel");
}

function processCmbFilDontUseAutoFilter() {
	processCheckbox("cmbFilDontUseAutoFilter");
}

function processActVieQryToAllowAutoFilter() {
	processCheckbox("actVieQryToAllowAutoFilter");
}

function processCmbDontUseAutoFilter() {
	processCheckbox("cmbDontUseAutoFilter");
}

function processCmbHidChtId(){
	processInput("hidChtId");
}

function processCmbIsReadOnly() {
	processReadOnly();
	processCheckbox("cmbIsReadOnly");
}

function processReadOnly() {
	var elements = $("cmbIsReadOnly");
	if (elements != null) {
		for (i = 0; i < elements.length; i++) {
			var tr=elements[i].parentNode;
			while(tr.tagName!="TR"){
				tr=tr.parentNode;
			}
			var elems=tr.getElementsByTagName("INPUT");
			for(var u=0;u<elems.length;u++){
				elems[u].disabled=false;
			}
			elems=tr.getElementsByTagName("SELECT");
			for(var u=0;u<elems.length;u++){
				elems[u].disabled=false;
			}
		}
	}
}

function processCheckbox(chk) {
	var elements = $(chk);
	if (elements != null) {		
		if (elements.type.toUpperCase()=="CHECKBOX" && !elements.checked) {
			elements.value = "0";			
		} else if(elements.type.toUpperCase()=="HIDDEN" && elements.value=="") {
			elements.value=0;
		}		
	}
}

function processInput(chk) {
	var elements = $(chk);
	if (elements != null) {
		if (elements.value == 'on') {
			elements.value = "-2";
		}		
	}

}

function validateEntRelations(chk) {
	var chkForceDelRelation = $("chkForceDelRelation");
	var chkDontDelOnRelation = $("chkDontDelOnRelation");

	if (chkForceDelRelation == chk && chk.checked) chkDontDelOnRelation.checked = false;
	if (chkDontDelOnRelation == chk && chk.checked) chkForceDelRelation.checked = false;
}

function changeHiddenAtts(){
	var valorAMostrar=$("selQryColIdModText");
	var shown="";
	if (valorAMostrar.selectedIndex >= 0) {
		if (valorAMostrar.options[valorAMostrar.selectedIndex].text != null && valorAMostrar.options[valorAMostrar.selectedIndex].text != "") {
			shown=valorAMostrar.options[valorAMostrar.selectedIndex].text;
		} else if (valorAMostrar.options[valorAMostrar.selectedIndex].label != null && valorAMostrar.options[valorAMostrar.selectedIndex].label != "") {
			shown=valorAMostrar.options[valorAMostrar.selectedIndex].label;
		}
	}
	
	var valorAlmacenar=$("selQryColIdModValue");
	var stored="";

	if ($("selQryTyp").value == QRY_TYPE_MODAL) {
		if (valorAlmacenar.selectedIndex >= 0) {
			if (valorAlmacenar.options[valorAlmacenar.selectedIndex].text != null && valorAlmacenar.options[valorAlmacenar.selectedIndex].text != "") {
				stored=valorAlmacenar.options[valorAlmacenar.selectedIndex].text;
			} else if (valorAlmacenar.options[valorAlmacenar.selectedIndex].label != null && valorAlmacenar.options[valorAlmacenar.selectedIndex].label != "") {
				stored=valorAlmacenar.options[valorAlmacenar.selectedIndex].label;
			}
		}
	}

	var selQryColIdModValueName = $("selQryColIdModValueName").value;
	var rows=$("tblShows").rows;
	
	while(valorAMostrar.options.length!=0) {
		valorAMostrar.removeChild(valorAMostrar.options[0]);
	}
	
	if ($("selQryTyp").value == QRY_TYPE_MODAL && valorAlmacenar != null) {
		while(valorAlmacenar.options.length!=0) {
			valorAlmacenar.removeChild(valorAlmacenar.options[0]);
		}
	}	 

	var selOkShown=false;
	var selOkStored=false;
	var cantCol = rows[0].cells.length;
	
	for (var i=1;i<cantCol;i++){
		var nameValorAlmacenar="";
		var nameValorMostrar="";
		var cmbOculto;
		for(var u=0; u<rows.length; u++){
			row=rows[u];
			var td = row.cells[i];
			
			//Me fijo que no tenga el cmbShoHid
			var cmbs=td.getElementsByTagName("SELECT");
			for(var j=0; j<cmbs.length; j++){
				if(cmbs[j].name=="cmbShoHid"){
					cmbOculto=cmbs[j];
				}
			}
			var inputs=td.getElementsByTagName("INPUT");
			
			for(var j=0; j<inputs.length; j++){
				//si tengo hidShoColName
				if(inputs[j].name=="hidShoColName"){					
					nameValorAlmacenar=inputs[j].value;
					nameValorMostrar=inputs[j].value;
					if(valorAlmacenar.tagName=="INPUT"){
						if(selQryColIdModValueName==name){
							valorAlmacenar.value=i;
						}
					}
				}
			}
			if (cmbOculto!=null){
				var index=cmbOculto.selectedIndex;
				if(index==1){  //No ocultar
					//Si la columna no se va a ocultar hay que agregarla dentro de los posibles valores a mostrar.
					var opt=document.createElement("OPTION");
					opt.value=i;
					opt.text=nameValorMostrar;
					opt.label=nameValorMostrar;
					if(nameValorMostrar==shown){
						opt.selected=true;
						selOkShown=true;
					}
					if (nameValorMostrar!=""){
						valorAMostrar.appendChild(opt);
						cmbOculto=null;
					}
					
				}  //Si en el combo "Ocultar" est� seleccionado "Si" directamente no lo agrega al combo de valorAMostrar.
			}
					  
			if ($("selQryTyp").value == QRY_TYPE_MODAL) {
				//Si el Valor a Almacenar es un Combo, entonces agregar todas las opciones existentes.
				var opt=document.createElement("OPTION");
				opt.value=i;
				opt.text=nameValorAlmacenar;
				opt.label=nameValorAlmacenar;
				if(nameValorAlmacenar==stored){
					opt.selected=true;
					selOkStored=true;
				}
				if (nameValorAlmacenar!=""){
					valorAlmacenar.appendChild(opt);
					nameValorAlmacenar="";
				}
				
			}
		}
	}
	if(!selOkShown && valorAMostrar.options.length>0){
		valorAMostrar.options[0].selected=true;
	}
	
	if ($("selQryTyp").value == QRY_TYPE_MODAL){
		if(!selOkStored && valorAlmacenar.options.length>0){
			valorAlmacenar.options[0].selected=true;
		}
	}
}

//---
//--- Funciones para trabajar con atributos
//---



function insideAtt(value) {
	var inside = false;
	for (var i = 0; i < attAdded.length && ! inside; i++) {
		if (attAdded[i] == value) {
			inside = true;
		}
	}
	return inside;
}

function inNotAllowed(value) {
	var inside = false;
	value = value.toUpperCase();
	for (var i = 0; i < notAllowed.length && ! inside; i++) {
		if (notAllowed[i] == value) {
			inside = true;
		}
	}
	return inside;
}

function chkAllAtt_click() {
	if ($("chkAllAtt").checked) {
		$('selAllAttFrom').setStyle("display","");
	} else {
		$('selAllAttFrom').setStyle("display","none");
	}
}

function generateShow(val0, val1, val2, val3,val4,val5) {
	//val0;hidShoAttId
	//val1;hidShoColName
	//val3;hidShoDatType
	//val4;hidShoDbType

	if (QRY_ALLOW_ATT) {
		if (attInsert > 0) {
			$("chkAllAtt").disabled = true;
			$("selAllAttFrom").style.display = 'none';
		}
	}
	
	var arrayColumn = new Array();
	var arrayRows = new Array();
	
	//Fila
	arrayRows.push({'type':'hidden',name:'chkShowSel',id:'chkShowSel'});
	arrayRows.push({'type':'hidden',name:'hidShoColId',id:'hidShoColId',value:''});
	arrayRows.push({'type':'hidden',name:'hidShoAttId',id:'hidShoAttId',value:val0});
	arrayRows.push({'type':'hidden',name:'hidShoDbType',id:'hidShoDbType',value:val4});
	arrayRows.push({'type':'hidden',name:'hidShoParId',id:'hidShoParId',value:val5});
	
	if (!QRY_FREE_SQL_MODE){
		arrayRows.push({'type':'hidden',name:'hidShoColName',id:'hidShoColName',value:val1});
		arrayRows.push({'type':'hidden',name:'hidShoDatType',id:'hidShoDatType',value:val3});
	}	
	
	//nombre de la columna
	if (QRY_FREE_SQL_MODE){
		arrayRows.push({'type':'text',name:'hidShoColName',id:'hidShoColName','required':true,'onchange': function() {checkActions();changeHiddenAtts(); },value:''});
	}else{
		arrayRows.push({'type':'span',html:val1});
	}

	arrayColumn.push({'display':'',arr:arrayRows});
	
	//Fila
	arrayRows = new Array();
	if (QRY_FREE_SQL_MODE) {	
		var arrayOptions = new Array();
		
		arrayOptions.push({'value':COLUMN_DATA_STRING,'text':LBL_DATA_TYPE_STR,'selected':false});	
		arrayOptions.push({'value':COLUMN_DATA_NUMBER,'text':LBL_DATA_TYPE_NUM,'selected':false});
		arrayOptions.push({'value':COLUMN_DATA_DATE,'text':LBL_DATA_TYPE_FEC,'selected':false});
		
		var aux = {'type':'combo',name:'hidShoDatType',id:'hidShoDatType','required':false,'options':arrayOptions,display:''};
		
		arrayRows.push(aux);
		arrayColumn.push({'display':'',arr:arrayRows});		
	}
	
	//Fila
	arrayRows = new Array();
	arrayRows.push({'type':'span',html:val1});
	arrayColumn.push({'display':'none',arr:arrayRows});
	
	//Fila
	arrayRows = new Array();
	arrayRows.push({'type':'text',name:'txtShoHeadName',id:'txtShoHeadName','required':false,value:val2,display:''});
	arrayColumn.push({'display':'',arr:arrayRows});	
	
	//Fila
	arrayRows = new Array();
	arrayRows.push({'type':'text',name:'txtShoTool',id:'txtShoTool','required':false,value:'',display:''});
	arrayColumn.push({'display':'',arr:arrayRows});
	
	//Fila	
	arrayRows = new Array();

	var arrayOptions = new Array();
	
	arrayOptions.push({'value':'','text':'','selected':true});	
	arrayOptions.push({'value':COLUMN_ORDER_ASC,'text':lblQryColOrdAsc,'selected':false});	
	arrayOptions.push({'value':COLUMN_ORDER_DESC,'text':lblQryColOrdDesc,'selected':false});
	
	var aux = {'type':'combo',name:'cmbShoSort',id:'cmbShoSort','required':false,'options':arrayOptions,display:val0 != null && val0 != ""?'none':''};
	arrayRows.push(aux);
	arrayColumn.push({'display':QRY_TO_PROCEDURE || ! QRY_TO_VIEW?'none':'',arr:arrayRows});
	
	//Fila
	arrayRows = new Array();
	arrayRows.push({'type':'text',name:'txtShowHeadWidth',id:'txtShowHeadWidth','required':true,value:'100',display:'','validation':'number'});
	arrayColumn.push({'display':'',arr:arrayRows});
	
	//Fila
	arrayRows = new Array();		
	var arrayOptions = new Array();
		
	arrayOptions.push({'value':'1','text':lblYes,'selected':false});	
	arrayOptions.push({'value':'0','text':lblNo,'selected':true});
	
	var aux = {'type':'combo',name:'cmbShoHid',id:'cmbShoHid','required':false,'options':arrayOptions,display:val0 != null && val0 != ""?'none':'',change:'changeHiddenAtts()'};
	arrayRows.push(aux);
	arrayColumn.push({'display':cmbShoHid,arr:arrayRows});
	
	//Fila
	arrayRows = new Array();
	
	var arrayOptions = new Array();
	
	if (addEntAttOpt){
		arrayOptions.push({'value':'1','text':lblQryAttFromEnt,'selected':false});
	}
	if (addProAttOpt){
		arrayOptions.push({'value':'0','text':lblQryAttFromPro,'selected':false});
	}
	if (!(addEntAttOpt || addProAttOpt)) {
		arrayOptions.push({'value':'-1','text':'','selected':false});
	}
	var aux = {'type':'combo',name:'cmbShoAttFrom',id:'cmbShoAttFrom','required':false,'options':arrayOptions,display:val0 == null || val0 == "" || ! (addEntAttOpt && addProAttOpt)?'none':''};
	arrayRows.push(aux);	
	arrayColumn.push({'display':!(addEntAttOpt && addProAttOpt)?'none':'',arr:arrayRows});
	
	//Fila
	arrayRows = new Array();
	var aux = {'type':'checkbox',name:'cmbShoTime',id:'cmbShoTime','required':false,'checked':false,'display':val3 != COLUMN_DATA_DATE && ! QRY_FREE_SQL_MODE?"none":"",value:1};
	arrayRows.push(aux);	
	arrayColumn.push({'display':'',arr:arrayRows});
	
	//Fila
	arrayRows = new Array();
	var aux = {'type':'checkbox',name:'cmbIsHTML',id:'cmbIsHTML','required':false,'checked':false,value:1};
	arrayRows.push(aux);
	arrayColumn.push({'display':'',arr:arrayRows});
	
	//Fila
	arrayRows = new Array();
	if (ADD_DONT_EXPORT){	
		var aux = {'type':'checkbox',name:'cmbDontExport',id:'cmbDontExport','required':false,'checked':false,value:1};
		arrayRows.push(aux);
		arrayColumn.push({'display':'',arr:arrayRows});
	}	
	
	//Fila
	arrayRows = new Array();
	if (val3 == COLUMN_DATA_DATE) {
		var aux = {'type':'hidden',name:'cmbBusEntIdShow',id:'cmbBusEntIdShow','required':false,value:''};	
	}else{
		var aux = {'type':'comboentities',name:'cmbBusEntIdShow',id:'cmbBusEntIdShow','width':'90%'};
	}
	arrayRows.push(aux);
	arrayColumn.push({'display':'',arr:arrayRows});
	
	//Fila
	arrayRows = new Array();
	if (ADD_AVOID_AUTO_FILTER){
		var aux = {'type':'checkbox',name:'cmbDontUseAutoFilter',id:'cmbDontUseAutoFilter','required':false,'checked':false,value:1};
		arrayRows.push(aux);
		arrayColumn.push({'display':'',arr:arrayRows});
	}
	
	//Fila
	arrayRows = new Array();
	
	var aux = {'type':'checkbox',name:'cmbJoinAttValues',id:'cmbJoinAttValues','required':false,'checked':false,display:val0 == null || val0 == ""?"none":"",value:1};
	arrayRows.push(aux);
	arrayColumn.push({'display':! (addEntAttOpt || addProAttOpt) && val4 != 'S'?"none":"",arr:arrayRows});			

	//Fila
	if (!IS_QUERY_TYPE_OFFLINE){
		arrayRows = new Array();
		var aux = {'type':'checkbox', name:'chkShowAsMoreInfo', id:'chkShowAsMoreInfo', 'required':false, 'checked':false, value:1};
		arrayRows.push(aux);
		arrayColumn.push({'display':'', arr:arrayRows});
	}

	//Fila
	arrayRows = new Array();
	var aux = {'type':'checkbox', name:'chkShowAsInt', id:'chkShowAsInt', 'required':false, 'checked':false, value:1, 'visibility': COLUMN_DATA_NUMBER != val3 ? "hidden" : ""};
	arrayRows.push(aux);
	arrayColumn.push({'display':'', arr:arrayRows});
	
	//Fila
	arrayRows = new Array();
	var aux = {'type':'checkbox', name:'chkIsDocument', id:'chkIsDocument', 'required':false, 'checked':false, value:1, 'visibility': COLUMN_DATA_DATE == val3 ? "hidden" : "", display:val0 != null && val0 != ""?'none':''};
	arrayRows.push(aux);
	arrayColumn.push({'display':'', arr:arrayRows});
	
	addColumn($('bodyShow'),"Show",arrayColumn,width);
}

//---
//--- Funciones para tab scheduler
//---

function loadSchedulers(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadComboSchedulers&isAjax=true' + TAB_ID_REQUEST,	
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); SYS_PANELS.closeAll(); }
	}).send();
}

function showOtherNode(cmb, show){
	$("radSelected").value = cmb.value;
	
	var input = $('txtExeNode');
	var container = $('divSchNodeName');
	input.value = "";
	if (cmb.value == "1"){
		container.setStyle("display","");
		if (!input.hasClass("validate['required']")){
			input.addClass("validate['required']");
			$('frmData').formChecker.register(input);
		}
	} else {
		container.setStyle("display","none");
		if (input.hasClass("validate['required']")){
			input.removeClass("validate['required']");
			$('frmData').formChecker.dispose(input);
		}
	}		
}

function processLoadComboSchedulers(){
	var resXml = getLastFunctionAjaxCall(); 
	var comboDOM = resXml.getElementsByTagName("element");
	if (comboDOM!=null && comboDOM.length!=0){
		var aux = $('cmbSchAfterSchId');
		aux.options.length=0;
		
		var firstChild = comboDOM[0];
		var selectedValue = firstChild.getAttribute("value");
		
		var options = firstChild.getElementsByTagName("option");
		var arrayOptions = new Array();
		
		var optionDOM = new Element('option');
		
		optionDOM.setProperty('value',"");
		optionDOM.appendText("");
		if (selectedValue!="" && selectedValue!="null"){
			optionDOM.setProperty('selected',"selected");
		}
		optionDOM.inject(aux);
		
		for (var m = 0; m < options.length; m++) {
			var option = options.item(m);
			
			var optionValue = option.getAttribute("value");
			var optionText = (option.firstChild != null)?option.firstChild.nodeValue:""; 
			
			optionDOM = new Element('option');
			optionDOM.setProperty('value',optionValue);
			optionDOM.appendText(optionText);
			if (selectedValue!="" && optionValue==selectedValue){
				optionDOM.setProperty('selected',"selected");
			}		
			optionDOM.inject(aux);							
		}
	}	
}

function paramSave_onChange() {
	if ($("paramSave").value != "H"){
		$("paramPag").disabled = true;
		$("paramPagNum").disabled = true;
		$("paramPagNum").value = "";
		$("paramPag").checked = false;
	} else {
		$("paramPag").disabled = false;
		$("paramPagNum").disabled = false;
	}
	paramPag_onClick();
} 

function paramPag_onClick() {
	if (!$("paramPag").disabled) {
		if (!$("paramPag").checked){
			$("paramPagNum").disabled = true;
			$("paramPagNum").value = "";
			$('divParamPagNum').removeClass("required");
		} else {
			$("paramPagNum").disabled = false;
			$('divParamPagNum').addClass("required");
		}		 
	}
}

function paramMax_onClick() {
	if ($("paramMax")){
		if (!$("paramMax").checked){
			$("paramMaxNum").disabled = true;
			$("paramMaxNum").value = "";
			$('divParamMaxNum').removeClass("required");
		} else {
			$("paramMaxNum").disabled = false;
			$('divParamMaxNum').addClass("required");
		}
	}
} 

//---
//--- Funciones para tab botones
//---

function loadQueryButtons(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadQueryButtons&isAjax=true' + TAB_ID_REQUEST,	
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); SYS_PANELS.closeAll(); }
	}).send();
}

function processLoadQueryButtons(){
	var resXml = getLastFunctionAjaxCall(); 
	var cells = resXml.getElementsByTagName("cell");
	if (cells.length!=0){
		var aux = $('divQueryButtons');
		for (var i=0;i<cells.length;i++){
			var cell = cells[i];
			var title = cell.getAttribute("title");
			var type = cell.getAttribute("type");
			var isChecked = toBoolean(cell.getAttribute("checked"));
			var isHidden = toBoolean(cell.getAttribute("hidden"));
			var firstChild = cell.firstChild;
			
			if (type=="text"){				
				var div = new Element('div',{'class':'subtitle title',html:cell.firstChild.textContent});				
			}else{
				var div = new Element("div",{'class':'field fieldOneThird'});
				var label = new Element('label',{'for':firstChild.getAttribute("id"),'class':'label',html:title + ':'});
				label.inject(div);
				var domElement = new Element('input',{type:'checkbox',name:firstChild.getAttribute("name"),id:firstChild.getAttribute("id")});
				if (isChecked)
					domElement.setAttribute("checked","true");
				
				domElement.inject(div);
				
				if (isHidden)
					div.setStyle("display","none");
			}
			div.inject(aux);			
		}
	}	
}

//---
//--- Funciones para tab acciones
//---

function checkActions() {
	if (isQuery && SOURCE_CONNECTION) {
		if ($("chkActVieEnt")) $("chkActVieEnt").disabled = ! hasActColumns(requiereActVieEntCol);
		if ($("chkActViePro")) $("chkActViePro").disabled = ! hasActColumns(requiereActVieProCol);
		if ($("chkActViwTas")) $("chkActViwTas").disabled = ! hasActColumns(requiereActVieTasCol);
		if ($("chkActWorEnt")) $("chkActWorEnt").disabled = ! hasActColumns(requiereActWorEntCol);
		if ($("chkActWorTas")) $("chkActWorTas").disabled = ! hasActColumns(requiereActWorTasCol);
		if ($("chkActAcqTas")) $("chkActAcqTas").disabled = ! hasActColumns(requiereActAcqTasCol);
		if ($("chkActComTas")) $("chkActComTas").disabled = ! hasActColumns(requiereActComTasCol);
	}
}

function hasActColumns(requiere) {
	trows = $("bodyShow").rows;
	var continue1 = false;
	for (j = 0; j < requiere.length && ! continue1; j++) {
		continue1 = true;
		for (var i=1;i<trows[0].cells.length&&continue1;i++){
			if (trows[1].cells[i].style.display!="none"){
				if (QRY_FREE_SQL_MODE) {
					if (requiere[j].toLowerCase() == trows[1].cells[i].getElementsByTagName("INPUT")[0].value.toLowerCase()) {
						continue1 = false;
					}
				} else if (requiere[j].toLowerCase() == trows[1].cells[i].getElementsByTagName("INPUT")[4].value.toLowerCase() || requiere[j].toLowerCase() == trows[1].cells[i].getElementsByTagName("INPUT")[5].value.toLowerCase()) {
					//en este if se pone que sea igual a la 4 o a la 5 porque no es igual la creacion que la modificacion
					continue1 = false;
				}
			}
		}
	}
	return ! continue1;
} 

//---
//--- Funciones para tab eventos
//---

function loadEvents(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadEvents&isAjax=true' + TAB_ID_REQUEST,	
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); SYS_PANELS.closeAll(); }
	}).send();
}

function processLoadEvents(){
	var resXml = getLastFunctionAjaxCall(); 
	var comboDOM = resXml.getElementsByTagName("element");
	if (comboDOM!=null && comboDOM.length!=0){
		for (var i=0;i<comboDOM.length;i++){
			populateCombo(comboDOM[i],true);
		}
	}
}

//---
//--- Funciones para tab Web Services
//---

function chkPubWs_change(){
	if($("chkPubWs").checked){
		$("txtWsName").disabled = false;
		registerValidation($("txtWsName"),"validate['required','~validName']");	
		if (!$('divWsName').hasClass("required")){
			$('divWsName').addClass("required");
		}
	}else{
		$("txtWsName").disabled = true;
		$("txtWsName").value ="";
		disposeValidation($("txtWsName"));
		$("txtWsName").className="";
		if ($('divWsName').hasClass("required")){
			$('divWsName').removeClass("required");
		}
	}
} 

//---
//--- Funciones para tab Mapeo de atributos
//---

function processAttributesRemapingModalReturn(ret){
	var trows = $('bodyAttRemping').rows;
	var count = 0;
	ret.each(function(e){
		var addRet = true;	
		var text = e.getRowContent()[0];
		var id = e.getRowId();
		var attLabel = e.getAttribute("attlabel");
		var type = e.getAttribute("type");
		
		for (i=0;i<trows.length && addRet;i++) {
			if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[2].value == ret[0]) {
				addRet = false;
			}
		}

		if (addRet) {
			
			var arrayTd = new Array();
			var arrayCell = new Array();
		
			var aux = {'type':'hidden',name:'checkRemapSel',value:'1'};
			arrayCell.push(aux);
			
			aux = {'type':'hidden',name:'hidRempColId',value:'true'};
			arrayCell.push(aux);
			
			aux = {'type':'hidden',name:'hidRempAttId',value:id};
			arrayCell.push(aux);
			
			aux = {'type':'hidden',name:'hidRempAttName',value:text};
			arrayCell.push(aux);
			
			aux = {'type':'hidden',name:'hidRempAttType',value:type};
			arrayCell.push(aux);
			
			aux = {'type':'span',html:text};
			arrayCell.push(aux);
			
			arrayTd.push({'display':'','type':'td',arr:arrayCell});				
			
			arrayCell = new Array();
			
			aux = {'type':'comboentity',name:'cmbRemapBusEntIdShow',id:'cmbRemapBusEntIdShow','required':true,'width':'90%'};		
			arrayCell.push(aux);
			
			arrayTd.push({'display':'','type':'td',arr:arrayCell});			
			
			addRowAttRemap($('bodyAttRemping'),arrayTd);
		}	
		count++;
	});
	if (count!=0){		
		changeHiddenAtts();
	}
}

function addRowAttRemap(table,arrTable){
	var parent = table.getParent();
	table.selectOnlyOne = false;
	var thead = parent.getFirst("thead");
	var theadTr = thead ? thead.getFirst("tr") : null;
	var headers = theadTr ? thead.getElements("th") : null;
	var tdWidths = headers ? new Array(headers.length) : null;
	if (headers) {
		for (var i = 0; i < headers.length; i++) {
			tdWidths[i] = headers[i].style.width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].getAttribute("width");
		}
	}

	var rowDOM = new Element('tr');
	for (var j=0;j<arrTable.length;j++){
		var td = arrTable[j];
		var div = new Element('div',{styles:{'width':tdWidths[j]}});
		d = addRowAttRemapTd(td,div);
			
		var tdDOM = new Element('td',{styles:{'display':td.display}});
		d.inject(tdDOM);
		tdDOM.inject(rowDOM);				
	}
	
	rowDOM.addClass("selectableTR");
	rowDOM.addEvent("click",function(e){myToggle(this)});
	rowDOM.getRowId = function () { return this.getAttribute("rowId"); };
	rowDOM.setRowId = function (a) { this.setAttribute("rowId",a); };
	rowDOM.setAttribute("rowId", table.rows.length);
	
	if(table.rows.length%2==0){
		rowDOM.addClass("trOdd");
	}
	
	rowDOM.inject(table);
	
	addScrollTable(table);
}

function addRowAttRemapTd(temp,div){
	var td = temp.arr;
	for (var i=0;i<td.length;i++){
		var aux = td[i];
		
		if (aux.type=="span"){
			domElement = new Element('span',{html:aux.html});
		}else if (aux.type=="hidden"){
			domElement = new Element('input',{type:'hidden',name:aux.name,id:aux.id});
			domElement.setAttribute("value",aux.value);
		}else if (aux.type=="comboentity"){
			domElement = new Element('select',{id:aux.id,name:aux.name});							
			for (var l=0;l<OPTIONS_BUS_ENTITY_COMBO_ARR.length;l++){
				var auxOption = OPTIONS_BUS_ENTITY_COMBO_ARR[l];
				var optionDOM = new Element('option');
				optionDOM.setProperty('value',auxOption.value);
				optionDOM.appendText(auxOption.text);
				if (auxOption.selected){
					optionDOM.setProperty('selected',"selected");
				}
				optionDOM.inject(domElement);
			}
		}else if (aux.type=="combo"){
			domElement = new Element('select',{id:aux.id,name:aux.name});
			for (var l=0;l<aux.options.length;l++){
				var auxOption = aux.options[l];
				var optionDOM = new Element('option');
				optionDOM.setProperty('value',auxOption.value);
				optionDOM.appendText(auxOption.text);
				if (auxOption.selected){
					optionDOM.setProperty('selected',"selected");
				}
				optionDOM.inject(domElement);
			}			
		}
		
		domElement.inject(div);		
		severalProperties(domElement,aux);
	}
	return div;
}

function loadAttRemaping(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadAttRemaping&isAjax=true' + TAB_ID_REQUEST,	
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); addScrollTable($('tblShows')); SYS_PANELS.closeAll(); }
	}).send();
}

function processLoadAttRemap(){
	var resXml = getLastFunctionAjaxCall(); 
	var tableDOM = resXml.getElementsByTagName("table");
	if (tableDOM!=null){
		var rows = tableDOM.item(0).getElementsByTagName("row");
		var arrayRow = new Array();
		for (var i=0;i<rows.length;i++){
			var row = rows.item(i);
			var arrayTd = new Array();
			var cells = row.getElementsByTagName("cell");
			var k = 0;			
			while (k < cells.length){		
				var cell = cells.item(k);
				var type = cell.getAttribute("type");
				var tdDisplay = cell.getAttribute("display");
				lCount = 0;	
				
				auxTd = processTd(cell);
				arrayTd.push({'display':tdDisplay,'type':'td',arr:auxTd});				
							
				k +=lCount;
				k++;
			}
			addRowAttRemap($('bodyAttRemping'),arrayTd);			
		}		
	}
}

//---
//--- Funciones para tab Graficas
//---

/*
 * Abre el modal de edici�n de un gr�fico
 */
function openChartDesignModal(html,id,isInDB){
//	$('graphDesignContainer').innerHTML=html;
	
//	$('chartId').value=id;
//	$('chartIsInDB').value=isInDB;
	
	var modal = ModalController.openWinModal(CONTEXT
			+ "/page/design/query/chartDesignModal.jsp?id="+id+"&isInDB=" + isInDB + TAB_ID_REQUEST, 900, 670); //ancho,alto

	modal.addEvent("confirm", function(res) {
		//res= "chartId;isInDB;chartTitle
		var resArr = res.split(";");
		var id = resArr[0];
		var title = resArr[2];
		
		var container = $("graphsContainer");
		container.getElements("DIV").each(function(item,index){
			if (item.childNodes.length > 0) {
				if (item.getElementsByTagName("INPUT").length>0){
					var chartId = parseFloat(item.getElementsByTagName("INPUT")[1].value);
					if (chartId	== id) {
						item.firstChild.textContent = title;
					}
				}
			}		
		});
	});
	modal.addEvent("close", function() {
		getGraphs();
	});
	
	//initChart();
}

var lastNewId = -1;
function findNewId() {
	var newId = lastNewId;
	var container = $("graphsContainer");
	
	var repeated = false;
	//primero verificar que no exista
	container.getElements("DIV").each(function(item,index){
		if (item.childNodes.length > 0) {
			if (item.getElementsByTagName("INPUT").length>0){
				var chartId = parseFloat(item.getElementsByTagName("INPUT")[1].value);
				if (chartId	< newId) {
					newId = chartId;
				}
			}
		}		
	});
	
	lastNewId = newId - 1;
	return lastNewId;
}

function getGraphs(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=getGraphs&isAjax=true' + TAB_ID_REQUEST,	
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { processXMLGraphs(resXml);SYS_PANELS.closeAll();}
	}).send();
}

function processXMLGraphs(ajaxCallXml){
	if (ajaxCallXml != null) {		
		var graphs = ajaxCallXml.getElementsByTagName("graphs");
		if (graphs != null && graphs.length > 0 && graphs.item(0) != null) {
			graphs = graphs.item(0).getElementsByTagName("graph");
			for(var i = 0; i < graphs.length; i++) {
				var g = graphs.item(i);
				var text	= g.getAttribute("text");
				var id = g.getAttribute("id");			
				var isDB	= toBoolean(g.getAttribute("graph_in_db"));
				var isPrincipal = g.getAttribute("graph_principal");
				addActionElementGraph($('graphsContainer'),text,id,"true",isDB, isPrincipal);
			}
		}
	}
}

function addActionElementGraph(container, text, id,helper,isInDB, isPrincipal){
	var repeated = false;
	//primero verificar que no exista
	container.getElements("DIV").each(function(item,index){
		if(item.getAttribute("id")==id){
			repeated = true;
			//actualizo el nombre si es necesario
			var t = item.firstChild.textContent;
			if (t!=text){
				item.firstChild.textContent=text;
			}
		}
	});
	if(repeated){
		return;
	}
	
	var elemDiv = new Element("div", {'id': id,'class': 'option optionMiddle'});
	var span = new Element("span", {html: text});
	span.inject(elemDiv);
	
	elemDiv.addClass("optionRemove");
	/*
	elemDiv.addEvent('remove', function() {
		if(confirm()) {
			deleteGraph(this,id,isInDB);
			return true;
		}
		return false;
	})
	*/
	elemDiv.addEvent('click', function(evt) { deleteGraph(this,id,isInDB); });
	
	
	var fncDiv = new Element("div", {'class': 'optionIcon optionModify','title':LBL_DESIGN});	
	fncDiv.addEvent('click', function(evt) { showGraph(id,isInDB); if (evt) { evt.stopPropagation(); } });
	fncDiv.inject(elemDiv);
		
	new Element('input',{ type:'hidden','name':'chkCharts','value':''}).inject(elemDiv);
	new Element('input',{ type:'hidden','name':'hidChtId','value':id}).inject(elemDiv);
	new Element('input',{ type:'hidden','name':'hidChtInDb','value':isInDB}).inject(elemDiv);
	
	elemDiv.inject($('btnAddChart'),"before");
	
	addChartInCombo(id, text, isPrincipal);
}

function addChartInCombo(id, name, isPrincipal) {
	var ele = new Element('option', {html : name, value : id}).inject($('chtPrincipal'));
	
	if ("true" == isPrincipal) {
		ele.set('selected', true);
	}
}

function removeChartFromCombo(id) {
	var selCharts = $('chtPrincipal');
	var i=0;
	while(i<selCharts.options.length){
		if (selCharts.options[i].get('value')==id){
			selCharts.removeChild(selCharts.options[i]);
			return;
		}
		i++;
	}
}

function showGraph(id,isInDB){
	//1. Cargamos la info del chart seleccionado en el bean
	var params = getFormParametersToSendQuery($('frmData'));
	var request = new Request({
		method: 'post',
		data: {'chartId':id, 'chtInDb': isInDB},
		url: CONTEXT + URL_REQUEST_AJAX + '?action=addChart&isAjax=true' + TAB_ID_REQUEST,	
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { openChartDesignModal(resText,id,isInDB); SYS_PANELS.closeAll(); }
	}).send(params+"&chartId="+id+"&chtInDb="+isInDB);
	//2. Una vez cargada la info, el bean invoca el metodo openChartDesignModal
}

function deleteGraph(obj,id){	
	obj.destroy();
	removeChartFromCombo(id);
	if ($('chartId') && $('chartId').value==id){
		disposeValidation($('chtTitle'),'frmChartDesign');
		disposeValidation($('chtColX'),'frmChartDesign');
		$('graphDesignContainer').innerHTML="";
	}
	var request = new Request({
		method: 'post',
		data: {chartId:id},
		url: CONTEXT + URL_REQUEST_AJAX + '?action=deleteGraph&isAjax=true' + TAB_ID_REQUEST,	
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) {SYS_PANELS.closeAll();}
	}).send();
}

function showGraphProperties(id,isInDB){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=openChartProps&isAjax=true' + TAB_ID_REQUEST,	
		data:{chartId:id,'isInDB':isInDB},
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send();
}

function afterConfGraph(){
	disposeValidation($('chtTitle'),'frmChartDesign');
	disposeValidation($('chtColX'),'frmChartDesign');
	$('graphDesignContainer').innerHTML="";
	$('confGraph').style.visibility='hidden';
	$('btnCancel').style.visibility='hidden';
	//getGraphs();
	SYS_PANELS.closeAll();
	getGraphs();
}

function goBackList(){
	sp.show(true);
	window.location = CONTEXT + URL_REQUEST_AJAX + '?action=list' + TAB_ID_REQUEST;
}

function toogleLastTr(tbody){
	tbody = $(tbody);
	if (tbody){
		var tr = tbody.getElements("tr");
		for (var i = 0; i < tr.length; i++){
			tr[i].removeClass("lastTr");
		}
		if (tr.length > 0){
			tr[tr.length-1].addClass("lastTr");
		}
	}
}

function onChangeCmbPeri(cmbPeri){
	var divAfterSchId = $('divAfterSchId');
	var cmbSchAfterSchId = $('cmbSchAfterSchId');
	
	if (cmbPeri.value == "after_scheduler"){
		divAfterSchId.setStyle("display","");
		$('frmData').formChecker.register(cmbSchAfterSchId);
	} else {
		divAfterSchId.setStyle("display","none");
		$('frmData').formChecker.dispose(cmbSchAfterSchId);
		cmbSchAfterSchId.value = "";
	}
}

function hourMinute(el){
	if (el.value == null || el.value == "") return true;
	
	var valueSplit = el.value.split(HOUR_SEPARATOR);
	if (valueSplit != null && valueSplit.length == 2){
		var hour = valueSplit[0]; 
		var min = valueSplit[1];
		if (!hour.test(/([0-1][0-9]|[2][0-3])/) || !min.test(/[0-5][0-9]/)){
			el.errors.push(VALID_HR);
	        return false;
		}
	} else {
		el.errors.push(VALID_HR);
        return false;
	}
	
	return true;
}

function checkColsUsedInCharts(cols){
	var strCols = "";
	if (cols && cols.length > 0){
		var trows = $("tblShows").rows;
		for (var i = 0; i < cols.length; i++){			
			if (cols[i] != ""){
				var chk = $(cols[i]);
				var col = Number(chk.getAttribute("colid"));
				
				var inputs = trows[0].cells[col].getElementsByTagName("input");
				for (var j = 0; j < inputs.length; j++){
					if (inputs[j].getAttribute("name") == "hidShoColName"){
						if (strCols != "") strCols += ";";
						strCols += cols[i] + PRIMARY_SEPARATOR + inputs[j].value; 
						break;
					}
				}				
			}
		}
		
		if(PRIMARY_SEPARATOR_IN_BODY) {
			new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=getColsUsedInChart&isAjax=true' + TAB_ID_REQUEST,
				async: false,
				onRequest: function() { },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send('cols=' + strCols);
		} else {
			new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=getColsUsedInChart&isAjax=true&cols=' + strCols + TAB_ID_REQUEST,
				async: false,
				onRequest: function() { },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send();
		}
	}	
}

function setColUsedInChart(cols){
	colsUsedInCharts = new Array();
	if (cols != null && cols != ""){
		var arrCols = cols.split(";");
		for (var i = 0; i < arrCols.length; i++){
			var colInfo = arrCols[i].split(PRIMARY_SEPARATOR);
			colsUsedInCharts.push({'id':colInfo[0],'name':colInfo[1]});
		}
	}
}

function canDelColChart(id){
	if (colsUsedInCharts != null && colsUsedInCharts.length > 0){
		for (var i = 0; i < colsUsedInCharts.length; i++){
			if (colsUsedInCharts[i].id == id){
				return colsUsedInCharts[i].name;
			}
		}
	}
	return null;
}
