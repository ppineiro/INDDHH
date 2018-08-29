var fromProfCube;
var lastSelectedDimension;
var lastSelectedMeasure;
var dateLbls;
var tdSelected;
var inputNameSelected;

var doFocus;
var panelAddDim;

var openLi;
var mdlDimension;

var isShowing;
var loadFinished;
var forceConfirm;

function initTabAnalyticalQueries(){	
	isShowing = false;
	loadFinished = false;
	
	//eventos para el tab
    $('tabAnalyticalQueries').addEvent("click", function(evt){
    	isShowing = true;
    	var panelOptionsTabAnalyticalQueries = $('panelOptionsTabAnalyticalQueries');
    	if (panelOptionsTabAnalyticalQueries){
    		if (SHOW_CBE_PAGE){
	    		var radLoadConf = $('radLoadConf');
	    		if (radLoadConf.checked){
	    			panelOptionsTabAnalyticalQueries.style.display='';
	    		}
    		}
    	}
    	
    	if (doFocus){
    		
    		if(Browser.ie8) {
    			setTimeout(function() {
    				fixTableCube($('gridMeasures'),false);
    		    	fixTableCube($('gridDims'),false);
    		    	doFocus = false;
    			}, 100);
    		} else {
    			fixTableCube($('gridMeasures'),false);
    	    	fixTableCube($('gridDims'),false);
    	    	doFocus = false;
    		}
	    	
	    	
	    	if (!SHOW_CBE_PAGE){
	    		SYS_PANELS.newPanel();
				var panel = SYS_PANELS.getActive();
				panel.addClass("modalWarning");
				panel.content.innerHTML = MSG_ERR_CBE_PAGE;			
				SYS_PANELS.addClose(panel,true,"showWarnAnalyticalQueries");
				SYS_PANELS.refresh();
	    	}
    	}
    });
    
    //$('tabAnalyticalQueries').addEvent("blur", function(evt){
    $('tabAnalyticalQueries').addEvent("custom_blur", function(evt){
    	isShowing = false;
    	var panelOptionsTabAnalyticalQueries = $('panelOptionsTabAnalyticalQueries');
    	if (panelOptionsTabAnalyticalQueries){ 
    		panelOptionsTabAnalyticalQueries.style.display='none';
    	}    	    	 
    });
    
    //Eventos Tabla Dimensiones
    var btnPropDim = $('btnPropDim');
    if (btnPropDim){
    	btnPropDim.addEvent("click",function (evt){
	    	evt.stop();
	    	if (hasCube){
		    	if (selectionCount($('gridDims')) > 1) {
					showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
				} else if (selectionCount($('gridDims')) == 0) { 
					showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
				} else {
					var tr = getSelectedRows($('gridDims'))[0];
					var td = tr.getElements("td")[0];
					var allMemberName = td.getAttribute("allMemberName");
					
					SYS_PANELS.newPanel();
					var panel = SYS_PANELS.getActive();
					panel.header.innerHTML = LBL_PROPS;
					panel.content.innerHTML = "<label title='"+AGR_NAME+"' class='label'>"+AGR_NAME+":&nbsp;&nbsp;</label>" + "<input type='text' style='width: 150px;' maxlength='50' class='required' value='"+ allMemberName +"'>";
					panel.footer.innerHTML = "<div class='button' onClick=\" if(btnAllMemberNameClickConfirm(this.parentNode.parentNode)) { SYS_PANELS.closeAll(); } \">" + BTN_CONFIRM + "</div>";
					SYS_PANELS.addClose(panel);
					SYS_PANELS.refresh();
				}
	    	}
	    });
    }
    var btnDeleteDim = $('btnDeleteDim');
    if (btnDeleteDim){
    	btnDeleteDim.addEvent("click",function(evt){
			evt.stop();
			if (hasCube){
				if (selectionCount($('gridDims')) == 0) { 
					showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
				} else {			
					var tr = getSelectedRows($('gridDims'))[0];
					if (tr.getRowId() != "null"){ setCubeChanged(); }
					deleteDimension(tr);
					fixTableCube($('gridDims'),false);
				}
			}
	    });
    }
    var btnAddDim = $('btnAddDim');
    if (btnAddDim){
    	btnAddDim.addEvent("click", function(evt){
	    	evt.stop();
	    	if (hasCube){
		    	mdlDimension = true;
		    	var selected = "";
		    	$('gridDims').getElements("tr").each(function (tr){
		    		if (selected != "") selected += ";";
		    		var attId = tr.getElements("td")[0].getAttribute("attId");
		    		selected += attId;
		    	});
		    	
		    	var request = new Request({
					method: 'post',
					url: CONTEXT + URL_REQUEST_AJAX + '?action=startAddDimension&isAjax=true&selected=' + selected + TAB_ID_REQUEST,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { SYS_PANELS.closeActive(); processStartAddDimension(resXml); }
				}).send();
	    	}
	    });
    }
    
    //Eventos Tabla Measures
    var btnDupMea = $('btnDupMea');
    if (btnDupMea){
    	btnDupMea.addEvent("click",function(evt){
	    	evt.stop();
	    	if (hasCube){
		    	if (selectionCount($('gridMeasures')) > 1) {
					showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
				} else if (selectionCount($('gridMeasures')) == 0) { 
					showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
				} else {
					var tr = getSelectedRows($('gridMeasures'))[0];
					duplicateMeasure(tr);			
				}
	    	}
	    });
    }
    var btnDeleteMea = $('btnDeleteMea');
    if (btnDeleteMea){
    	btnDeleteMea.addEvent("click",function(evt){
	    	evt.stop();
	    	if (hasCube){
	    		if (selectionCount($('gridMeasures')) == 0) { 
		    		showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
				} else {			
					var tr = getSelectedRows($('gridMeasures'))[0];
					if (tr.getRowId() != "null") { setCubeChanged(); }
					deleteMeasure(tr);
					fixTableCube($('gridMeasures'),false);
				}
	    	}
		});
    }
    var btnAddMea = $('btnAddMea');
    if (btnAddMea){
    	btnAddMea.addEvent("click",function(evt){
	    	evt.stop();
	    	if (btnAddMea){
		    	mdlDimension = false;
		    	var selected = "";
		    	$('gridMeasures').getElements("tr").each(function (tr){
		    		if (selected != "") selected += ";";
		    		var attId = tr.getElements("td")[0].getElements("div")[0].getElements("input")[0].getAttribute("attId");
		    		selected += attId;
		    	});
		    	
		    	var request = new Request({
					method: 'post',
					url: CONTEXT + URL_REQUEST_AJAX + '?action=startAddDimension&isAjax=true&selected=' + selected + TAB_ID_REQUEST,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { SYS_PANELS.closeActive(); processStartAddDimension(resXml); }
				}).send();
	    	}
	    });
    }
    
    var iniDteLoad = $('iniDteLoad');
	if (iniDteLoad){
		setAdmDatePicker(iniDteLoad);
		registerValidation($("iniDteLoad").getNext(), "validate['required']");
	}
	
    
    //Tiempo Estimado
    var btnEstimateLoad = $('btnEstimateLoad');
    if (btnEstimateLoad){
    	btnEstimateLoad.addEvent("click", function(evt){
	    	evt.stop();
	    	if (hasCube){
	    		if (verifyCubeDataToEstimateTime()){
	    			var str = getAttIdsSelected();
	    			if (str != ""){
				    	var request = new Request({
							method: 'post',
							url: CONTEXT + URL_REQUEST_AJAX + '?action=estimateCubeLoadTime&isAjax=true' + str + TAB_ID_REQUEST,
							onRequest: function() { SYS_PANELS.showLoading(); },
							onComplete: function(resText, resXml) { modalProcessXml(resXml); }
						}).send();
	    			} else {
	    				showMessage("Must complete cube first", GNR_TIT_WARNING, 'modalWarning');	    				
	    			}
	    		}
	    	}
    	});
    	//['btnEstimateLoad'].each(setTooltip);
    }    
    
    var addProfCube = $('addProfCube');
    if (addProfCube){
    	addProfCube.addEvent("click", function(evt){
	    	evt.stop();
	    	if (hasCube){
		    	PROFILEMODAL_SHOWGLOBAL = true;
		    	PROFILEMODAL_FROMENVS = "";
		    	PROFILEMODAL_SELECTONLYONE	= false;
		    	fromProfCube = true;
		    	showProfilesModal(processMdlProfilesReturn);
	    	}
	    });
    }
    
    var addProfPermCube = $('addProfPermCube');
    if (addProfPermCube){
    	addProfPermCube.addEvent("click", function(evt){
	    	evt.stop();
	    	if (hasCube){
	    		PROFILEMODAL_SHOWGLOBAL = true;
		    	PROFILEMODAL_FROMENVS = "";
		    	PROFILEMODAL_SELECTONLYONE	= false;
		    	fromProfCube = false;
		    	showProfilesModal(processMdlProfilesReturn);
	    	}
	    });
    }
    
    var chkCreCube = $('chkCreCube');
    if (chkCreCube){
    	hasCube = chkCreCube.checked;
        onClickChkCreCube(chkCreCube,true);
    }
    
    lastSelectedDimensions = null;
    lastSelectedMeasures = null;
    tdSelected = null;
    inputNameSelected = null;
    dateLbls = new Array(YEAR,SEM,TRIM,MON,WEEDAY,DAY,HOUR,MIN,SEC);
    doFocus = true;
    openLi = null;
    forceConfirm = false;
        
    if (hasCube){
        loadDimensions();
    	loadMeasures();
    	loadProfiles();
    } else {
		var table = $('gridBodyDimensions'); var footer = $('btnDeleteDim');
		if (table){
			var notification = new Element('div', {id : 'editionNot'}); 
			footer.grab(notification, "top");
			initAdminModalHandlerOnChangeHighlight(table, true, false, notification);
		}
		
		table = $('gridBodyMeasures'); var footer = $('btnDeleteMea');
		if (table){
			var notification = new Element('div', {id : 'editionNot'}); 
			footer.grab(notification, "top");
			initAdminModalHandlerOnChangeHighlight(table, true, false, notification);	
			
			initAdminRadioButtonOnChangeHighlight($('radLoadConf').getParent('.fieldGroup'), 'radLoad');
		}
    } 
	disabledAllTabAnalyticalQueries();
	
	loadFinished = true;
	
	var gbd = $('gridBodyDimensions');
	if(gbd)
		gbd.addEvent('custom_scroll', function(left) {
			$('gridDimensions').getElement('div.gridHeader').getElement('table').setStyle('left', left);
		});
	
	var gbm = $('gridBodyMeasures');
	if(gbm)
		gbm.addEvent('custom_scroll', function(left) {
			$('gridMeasuresTable').getElement('div.gridHeader').getElement('table').setStyle('left', left);
		});
	
	
	['iniHrLoad'].each(setHourField);
	registerValidation($("iniHrLoad"), "validate['required','~validateHours']");
}

function showWarnAnalyticalQueries(){
	$('msgMustConf').style.display = '';
}

function disabledAllTabAnalyticalQueries(fromDelCube){
	if (MODE_DISABLED || fromDelCube){
    	var tabContent = $('contentTabAnalyticalQueries');
    	tabContent.getElements("input").each(function(input){
    		input.disabled = true;
    		input.readOnly = true;
    		input.addClass("readonly");
    	});
    	if(MODE_DISABLED){
    		tabContent.getElements("div.option").each(function(option){
        		option.removeEvents('click');
        	});
    	}
    }
}

function enableAllTabAnalyticalQueries(){
	var tabContent = $('contentTabAnalyticalQueries');
    tabContent.getElements("input").each(function(input){
    	input.disabled = false;
    	input.readOnly = false;
    	input.removeClass("readonly");
    });
    
    var cubeName = $('cubeName');
	var divCubeName = $('divCubeName');
	var cubeTitle = $('cubeTitle');
	var divCubeTitle = $('divCubeTitle');
	if (!divCubeName.hasClass("required")){
		divCubeName.addClass("required");
	}
	if (!divCubeTitle.hasClass("required")){
		divCubeTitle.addClass("required");
	}
	$('frmData').formChecker.register(cubeName);
	$('frmData').formChecker.register(cubeTitle);
}

function validCubeName(el){
	//var re = new RegExp("^[a-zA-Z0-9_.]+[^ ]*$");
	var re = new RegExp("^[a-zA-Z0-9_.]*$");
	if (!el.get("value").match(re)) {
		el.errors.push(MSG_CUBE_NAME_INVALID);
		return false;
	}
	return true;
}

function executeBeforeConfirmTabAnalyticalQueries(){
	if($('cubeChanged') == null) return true; //Mode Create (no hay cubo)
	
	if ($('cubeChanged').value == "true"){ //Hubieron cambios en el cubo
		if (forceConfirm || verifyCubeData()){
			forceConfirm = false;
			var values = "";

			//Guardar dimensiones
			values = getDimensionValuesAsStr();
			$('retDimensions').value = values;
			//Guardar id de dimensiones ya existentes
			values = getAllIdLoaded($('gridDims'));
			$('retDimensionsLoaded').value = values;
			//Guardar id de measures ya existentes
			values = getAllIdLoaded($('gridMeasures'));
			$('retMeasuresLoaded').value = values;
			//Guardar measures
			values = getMeasuresValuesAsStr();
			$('retMeasures').value = values;
						
			values = "";
			$('profilesCubeContainer').getElements("div.option").each(function (prof){
				if (values != "") values += ";";
				if(prof.getAttribute("profId"))
					values += prof.getAttribute("profId");				
			});
			$('txtProfCube').value = values;
			values = "";
			$('profilesCubePermContainer').getElements("div.option").each(function (prof){
				if (values != "") values += ";";
				if(prof.getAttribute("profId")) {
					values += prof.getAttribute("profId");
					values += PRIMARY_SEPARATOR;
					values += prof.getAttribute("profName");
					values += PRIMARY_SEPARATOR;
					values += prof.getAttribute("profDim");
				}
			});
			$('txtProfPermCube').value = values;
			
			return true;
		} else {
			return false;
		}
	} else {
		return true;
	}
}

function onClickChkCreCube(chkCreCube,fromInit){
	if (!chkCreCube.checked){
		if (!fromInit){
			SYS_PANELS.newPanel();
			var panel = SYS_PANELS.getActive();
			panel.addClass("modalWarning");
			panel.content.innerHTML = MSG_DELETE_CUBE;
			panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll();checkDepsCubeOnRemove();\">" + BTN_CONFIRM + "</div>";
			SYS_PANELS.addClose(panel,true,"cancelDeleteCube");
			SYS_PANELS.refresh();
		} else {
			checkDepsCubeOnRemove();
		}
	} else {
		hasCube = true;
		var panelOptionsTabAnalyticalQueries = $('panelOptionsTabAnalyticalQueries');
    	if (panelOptionsTabAnalyticalQueries){
    		var radLoadConf = $('radLoadConf');
    		if (radLoadConf.checked){
    			if (isShowing){
    				panelOptionsTabAnalyticalQueries.style.display='';	
    			}    			
    		}
    	}
    	enableAllTabAnalyticalQueries();
	}
}

function cancelDeleteCube(){
	var chkCreCube = $('chkCreCube');
	chkCreCube.checked = true;
	hasCube = true;
}

function checkDepsCubeOnRemove(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=getCubeDependenciesOnRemove&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { SYS_PANELS.closeActive(); modalProcessXml(resXml); }
	}).send();
}

function processRetXmlCheckDepsCubeOnRemove(isOk,warn){
	if (!isOk){
		showMessage(warn, GNR_TIT_WARNING, 'modalWarning');
		cancelDeleteCube();
	} else {
		confirmDeleteCube();
	}
}

function confirmDeleteCube(){
	hasCube = false;
	$('cubeName').value = "";
	$('cubeTitle').value = "";
	$('cubeDesc').value = "";
	$('gridDims').getElements("tr").each(function (tr){ deleteDimension(tr); })
	$('gridMeasures').getElements("tr").each(function (tr){ deleteMeasure(tr); })
	$('profilesCubeContainer').getElements("div.optionRemove").each(function (option){ option.getParent().destroy(); })
	$('profilesCubePermContainer').getElements("div.optionRemove").each(function (option){ option.getParent().destroy(); })
	$('radLoadConf').checked = true;
	$('iniDteLoad').value = "";
	$('iniDteLoad').getNext().value = "";
	$('iniHrLoad').value = "";
	$('panelOptionsTabAnalyticalQueries').style.display='none';	
	disabledAllTabAnalyticalQueries(true);
	
	var chkCreCube = $('chkCreCube');
	chkCreCube.disabled = false;
	chkCreCube.readOnly = false;
	chkCreCube.removeClass("readonly");		
	
	if (loadFinished){
		setCubeChanged();
	}
	
	var cubeName = $('cubeName');
	var divCubeName = $('divCubeName');
	var cubeTitle = $('cubeTitle');
	var divCubeTitle = $('divCubeTitle');
	if (divCubeName.hasClass("required")){
		divCubeName.removeClass("required");
	}
	if (divCubeTitle.hasClass("required")){
		divCubeTitle.removeClass("required");
	}
	$('frmData').formChecker.dispose(cubeName);
	$('frmData').formChecker.dispose(cubeTitle);
}

function startMdlDimension(prof){
	var cbeName = $('cubeName').value; 
	if (cbeName == ""){ //Para agregar un perfil de acceso restringido, se debe verificar previamente que el cubo tenga nombre
		showMessage(MSG_CBE_NAME_MISS, GNR_TIT_WARNING, 'modalWarning');
		return;
	}	
	
	var allDimensions = "";	
	$('gridDims').getElements("tr").each(function (tr){
		var name = tr.getElements("td")[2].getElements("div")[0].getElements("div")[0].getElements("input")[0].value;
		if (allDimensions != "") allDimensions += ";";
		allDimensions += name;
	});	
	
	if (allDimensions != ""){
		var prfName = prof.getAttribute("profName");
		prof.setAttribute("flagNew","false");
		
		var request = new Request({
			method : 'post',
			url : CONTEXT + URL_REQUEST_AJAX + '?action=startMdlDimensionRestricted&isAjax=true&prfName=' + prfName + '&cbeName=' + cbeName + '&dimNames=' + allDimensions +TAB_ID_REQUEST,
			onRequest : function() { },
			onComplete : function(resText, resXml) { processXmlDimRestricted(resXml); }
		}).send();
	}
}

function processXmlDimRestricted(resXml){
	var result = resXml.getElementsByTagName("result")[0];
	var prfName = result.getAttribute("prfName");
	var cbeName = result.getAttribute("cbeName");
	var dimensions = result.getElementsByTagName("dimension");
		
	var table = "<table style='width: 50%'><thead><tr><td style='width: 80%'>"+LBL_DIM+"</td><td align='center' style='width: 20%'>"+LBL_VIS+"</td></tr></thead><tbody>";
	for(var i = 0; i < dimensions.length; i++){
		var xmlDim = dimensions[i];
		var dimName = xmlDim.getAttribute("name");
		var dimSelected = toBoolean(xmlDim.getAttribute("selected"));
		
		table += "<tr><td style='width: 80%' dimName='" + dimName + "'>" + dimName + "</td><td align='center' style='width: 20%'><input type='checkbox' " + (dimSelected ? "checked" : "") + "></td></tr>";    
	}
	
	table += "</tbody></table>";
	
	var content = "<input type='hidden' class='prf' value='" + prfName + "'> <input type='hidden' class='cbe' value='" + cbeName + "'>" + "<label><b>" + LBL_PERM + "</b></label><br><br>" + table;
	
	SYS_PANELS.newPanel();
	var panel = SYS_PANELS.getActive();
	panel.header.innerHTML = LBL_PERM2;
	panel.content.innerHTML = content;
	panel.footer.innerHTML = "<div class='button' onClick=\"btnMdlDimRestrictedClickConfirm(this.parentNode.parentNode); \">" + BTN_CONFIRM + "</div>";
	SYS_PANELS.addClose(panel);
	SYS_PANELS.refresh();
}

function btnMdlDimRestrictedClickConfirm(panel){
	var content = panel.getElements("div")[1];
	
	var prfName = content.getElements("input.prf")[0].value;
	var cbeName = content.getElements("input.cbe")[0].value;
	
	var table = content.getElements("tbody")[0];
	var result = "";
	table.getElements("tr").each(function (tr){
		var dwName = tr.getElements("td")[0].getAttribute("dimName");
		var selected = tr.getElements("td")[1].getElements("input")[0].checked;
		if (result != "") result += ";";
		result += dwName + PRIMARY_SEPARATOR + (selected ? "T" : "F");		
	});	
	setCubeChanged();
	
	var request = new Request({
		method : 'post',
		url : CONTEXT + URL_REQUEST_AJAX + '?action=saveDimsRestrictions&isAjax=true&prfName=' + prfName + '&cbeName=' + cbeName + '&result=' + result +TAB_ID_REQUEST,
		onRequest : function() { },
		onComplete : function(resText, resXml) { modalProcessXml(resXml); }
	}).send();
}

function onClickRadLoad(radLoad){
	var panelOptionsTabAnalyticalQueries = $('panelOptionsTabAnalyticalQueries');
	var iniDteLoad = $('iniDteLoad');
	var iniHrLoad = $('iniHrLoad');
	if (panelOptionsTabAnalyticalQueries){
		if (radLoad.value == "1"){
			panelOptionsTabAnalyticalQueries.style.display='';
			iniDteLoad.readOnly = true;
			iniDteLoad.disabled = true;
			iniDteLoad.addClass("readonly");
			iniDteLoad.value = "";
			iniDteLoad.getNext().readOnly = true;
			iniDteLoad.getNext().disabled = true;
			iniDteLoad.getNext().addClass("readonly");
			iniDteLoad.getNext().value = "";
			iniHrLoad.readOnly = true;
			iniHrLoad.disabled = true;
			iniHrLoad.addClass("readonly");
			iniHrLoad.value = "";
		} else {
			panelOptionsTabAnalyticalQueries.style.display='none';
			iniDteLoad.readOnly = false;
			iniDteLoad.disabled = false;
			iniDteLoad.removeClass("readonly");
			iniDteLoad.getNext().readOnly = false;
			iniDteLoad.getNext().disabled = false;
			iniDteLoad.getNext().removeClass("readonly");
			iniHrLoad.readOnly = false;
			iniHrLoad.disabled = false;
			iniHrLoad.removeClass("readonly");			
		}
	}
	setCubeChanged();
}

function fixTableCube(table,fromInit){
	if (table){
		var trs = table.getElements("tr"); 
		var total = trs.length;
		var i = 1;
		trs.each(function (tr){
			if (i % 2 == 0){
				tr.addClass("trOdd");
			} else {
				tr.removeClass("trOdd");
			}
			if (i == total){
				tr.addClass("lastTr");
			} else {
				tr.removeClass("lastTr");
			}
			i++;
		});
		
		if (!fromInit) addScrollTable(table);
	}	
}

function selectRowDimensions(row){
	if (lastSelectedDimensions != null){
		$(lastSelectedDimensions).toggleClass("selectedTR");
	}	
	if (lastSelectedDimensions == row){
		lastSelectedDimensions = null;
		return;
	}	
	row.toggleClass("selectedTR");
	lastSelectedDimensions = row;
}

function selectRowMeasures(row){
	if (lastSelectedMeasures != null){
		$(lastSelectedMeasures).toggleClass("selectedTR");
	}	
	if (lastSelectedMeasures == row){
		lastSelectedMeasures = null;
		return;
	}	
	row.toggleClass("selectedTR");
	lastSelectedMeasures = row;
}

function loadDimensions(){
	var request = new Request({
		method : 'post',
		url : CONTEXT + URL_REQUEST_AJAX + '?action=loadDimensions&isAjax=true' + TAB_ID_REQUEST,
		onRequest : function() { },
		onComplete : function(resText, resXml) { 
			processXmlDimensions(resXml,true);
		
			var table = $('gridBodyDimensions'); var footer = $('btnDeleteDim');
			var notification = new Element('div', {id : 'editionNot'}); 
			footer.grab(notification, "top");
			initAdminModalHandlerOnChangeHighlight(table, true, false, notification);
			
			initAdminRadioButtonOnChangeHighlight($('radLoadConf').getParent('.fieldGroup'), 'radLoad');
		}
	}).send();
}

function processXmlDimensions(resXml,fromInit){
	var dimensions = resXml.getElementsByTagName("dimensions")
	if (dimensions != null && dimensions.length > 0 && dimensions.item(0) != null) {
		//dimensions = dimensions.item(0).getElements("dimension");
		dimensions = dimensions.item(0).getElementsByTagName("dimension");
				
		for (var i = 0; i < dimensions.length; i++){
			var xmlDim = dimensions[i];
			var dimProDwColId = xmlDim.getAttribute("dimProDwColId");
			var attId = xmlDim.getAttribute("attId");
			var attType = xmlDim.getAttribute("attType");
			var attName = xmlDim.getAttribute("attName");
			var attFrom = xmlDim.getAttribute("attFrom");
			var dwName = xmlDim.getAttribute("dwName");
			var allMemberName = xmlDim.getAttribute("allMemberName");	
			var date = xmlDim.getAttribute("date");
			var mapEntityId = xmlDim.getAttribute("mapEntityId");
			var mapEntityName = xmlDim.getAttribute("mapEntityName");
			createDimension(dimProDwColId,attId,attType,attName,attFrom,dwName,allMemberName,date,mapEntityId,mapEntityName);			
		}		
	}
	fixTableCube($('gridDims'),fromInit);
}

function createDimension(dimProDwColId,attId,attType,attName,attFrom,dwName,allMemberName,date,mapEntityId,mapEntityName){
	var tr = new Element("tr",{'class': 'selectableTR'}).inject($('gridDims'));
	tr.setAttribute("rowId",dimProDwColId != null && dimProDwColId != "" ? dimProDwColId : "null");
	tr.addEvent("click", function(evt) { selectRowDimensions(this); evt.stopPropagation(); });				
									
	var td1 = new Element("td", {'align':'center'}).inject(tr);
	td1.setAttribute("attId",attId);
	td1.setAttribute("attType",attType);
	td1.setAttribute("attName",attName);
	td1.setAttribute("attFrom",attFrom);
	td1.setAttribute("allMemberName",allMemberName);
	var div1 = new Element('div', {styles: {width: '130px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td1);
	var input1 = new Element('input',{'type': 'text', 'value': attName, 'class': 'readonly validate["~checkNotEmpty"]'}).inject(div1);
	input1.disabled = true;
	input1.readOnly = true;
	input1.setAttribute("errType","0");
	$('frmData').formChecker.register(input1);	
		
	var td2 = new Element("td", {}).inject(tr);
	var div2 = new Element('div', {styles: {width: '50px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td2);
	var attTypeLbl = attType == "S" ? "STRING" : (attType == "D" ? "DATE" : "NUMERIC");  
	new Element('span', {html: attTypeLbl}).inject(div2);
	
	var td3 = new Element("td", {}).inject(tr);
	var div3 = new Element('div', {styles: {width: '700px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td3);
	
	var div31 = new Element("div",{styles:{'width':'20%','display':'inline','float':'left'}}).inject(div3);
	var div32 = new Element("div",{styles:{'width':'80%','display':'inline','float':'right'}}).inject(div3);
	
	var input3 = new Element('input',{'type': 'text', 'value': dwName, 'class': "validate['~validName','~checkNotEmpty']", styles: {'width': '135px', 'margin-top': '2px'}}).inject(div31);
	input3.addEvent("change", function (evt) { setCubeChanged(); evt.stopPropagation(); });
	input3.setAttribute("errType","1");
	$('frmData').formChecker.register(input3);
	
	
	if (attType == "D"){ // Date
		var arrDate = date.split(PRIMARY_SEPARATOR);
		for(var i = 0; i < arrDate.length; i++){
			new Element('span', {html: "| " + dateLbls[i] + ": "}).inject(div32);
			var auxSpan = new Element('span', {}).inject(div32); 
			var chk = new Element('input',{'type':'checkbox', 'checked': arrDate[i] == "T"}).inject(auxSpan);
			chk.addEvent("change", function (evt) { setCubeChanged(); });
		}
		
		td3.setAttribute("mapEntityId","");
	} else { //String o Numeric
		td3.setAttribute("mapEntityId",mapEntityId);
		if (attId > 1000){
			div3.addClass("modalOptionsContainerTable");
			var divOption = new Element("div",{'class': 'option optionRemove', styles: {'width': '180px'}}).inject(div32);
			divOption.addEvent('click',function (evt){ this.parentNode.parentNode.parentNode.setAttribute("mapEntityId",""); this.getElements("input")[0].value=""; setCubeChanged(); evt.stopPropagation(); })
			input3 = new Element('input',{'type': 'text', 'value': mapEntityName, 'class': 'readonly'}).inject(divOption);
			var divIcon = new Element("div",{'class': 'optionIcon optionModify',styles:{'display':'inline'}}).inject(divOption);
			divIcon.addEvent('click',function(evt){ showModal(this.parentNode.parentNode.parentNode.parentNode,this.parentNode.getElements("input")[0]); evt.stopPropagation(); })
			input3.disabled = true;
			input3.readOnly = true;
		}
	}
	
	tr.getRowId = function () { return this.getAttribute("rowId"); }
	tr.getContentStr = function() { //format: dwColId�attId�attType�attName�attFrom�allMemberName�mapEntId�mapEntName�dwName�date
		var tds = this.getElements("td");
		
		var dwColId = this.getRowId();
		var attId = tds[0].getAttribute("attId");
		var attType = tds[0].getAttribute("attType");
		var attName = tds[0].getAttribute("attName");
		var attFrom = tds[0].getAttribute("attFrom");
		var allMemberName = tds[0].getAttribute("allMemberName");
		var mapEntId = tds[2].getAttribute("mapEntityId") != "" ? tds[2].getAttribute("mapEntityId") : "null";
		var mapEntName = "null";
		var dwName = tds[2].getElements("div")[0].getElements("div")[0].getElements("input")[0].value; 
		var date = "null"
		
		if (attType == "D"){
			//cargar date
			date = "";
			var chks = tds[2].getElements("div")[0].getElements("div")[1].getElements("input");
			for(var i = 0; i < 9; i++){
				date += chks[i].checked ? "T" : "F";
			}
		} else if (attId > 1000){
			//cargar mapEntName
			var name = tds[2].getElements("div")[0].getElements("div")[1].getElements("div")[0].getElements("input")[0].value;
			if (name != ""){
				mapEntName = name;
			}
		}
		
		//armar string de valores para la dimension
		var dimStr = dwColId + PRIMARY_SEPARATOR + attId + PRIMARY_SEPARATOR + attType + PRIMARY_SEPARATOR + attName + PRIMARY_SEPARATOR + attFrom + PRIMARY_SEPARATOR + allMemberName + PRIMARY_SEPARATOR + mapEntId + PRIMARY_SEPARATOR + mapEntName + PRIMARY_SEPARATOR + dwName + PRIMARY_SEPARATOR + date;
		return dimStr;
	}		
	
}

function showModal(td,inputName){
	tdSelected = td;
	inputNameSelected = inputName;
	ENTITIESMODAL_SHOWGLOBAL = true;
	ENTITIESMODAL_SELECTONLYONE	= true;
	showEntitiesModal(processModalEntRet);
}

function processModalEntRet(ret){
	ret.each(function (pro){
		tdSelected.setAttribute("mapEntityId",pro.getRowId());
		inputNameSelected.value = pro.getRowContent()[0];
		setCubeChanged();
	});
}

function processStartAddDimension(resXml){
	var result = resXml.getElementsByTagName("result");
	if (result != null && result.length > 0 && result.item(0) != null){
		result = result.item(0);
		var selected = result.getAttribute("selected");
		//result = result.getElements("title");	
		result = result.getElementsByTagName("title");
		
		SYS_PANELS.newPanel();
		panelAddDim = SYS_PANELS.getActive();
		panelAddDim.header.innerHTML = LBL_MDL_ADD;
		panelAddDim.content.innerHTML = "";
		panelAddDim.footer.innerHTML = "<div class='button' onClick=\"btnMdlAddDimClickConfirm(); SYS_PANELS.closeAll(); \">" + BTN_CONFIRM + "</div>";
		SYS_PANELS.addClose(panelAddDim);
		SYS_PANELS.refresh();
				
		panelAddDim.content.addClass("modalOptionsContainer").addClass("maxHeightOptionsContainer");
		new Element("input",{'type':'hidden', 'value':selected}).inject(panelAddDim.content);
		var div = new Element("div",{'class': 'optionCubeModal'}).inject(panelAddDim.content);
		var ulContent = new Element("ul",{'class':'ulFather'}).inject(div);		
		
		for(var i = 0; i < result.length; i++){
			var title = result[i];
			var id = title.getAttribute("id");
			var name = title.getAttribute("name");
			var tooltip = title.getAttribute("tooltip");
			var action = title.getAttribute("action");
			
			var li = new Element("li",{}).inject(ulContent);
			li.setAttribute("action",action);
			li.setAttribute("objId",id);
			li.setAttribute("wasOpened","false");
			
			var span = new Element("span", {html: name,'title': tooltip}).setStyle('cursor', 'pointer').inject(li);
			
			var ul = new Element("ul",{}).inject(li);
			ul.setAttribute("father",id);
			ul.style.display = 'none';
			
//			var opclo = new Element("div",{'class': "showChilds"}).inject(span);
//			opclo.setStyle("margin-top","6px");
//			opclo.addEvent('click', function(evt) { showOrHideChilds(this.parentNode.parentNode,this); evt.stopPropagation(); });
			var opclo = new Element("div",{'class': "showChilds"}).inject(span);
			opclo.setStyle("margin-top","6px");
			span.addEvent('click', function(evt) { 
				showOrHideChilds(this.getParent(), this.getElement('div'));
				evt.stopPropagation();
			});
		}
		
		SYS_PANELS.adjustVisual();
	}
}

function btnMdlAddDimClickConfirm(){
	var content = panelAddDim.getElements("div")[1];
	
	var oldSelected = content.getElements("input")[0].value;
	if (oldSelected == null || oldSelected == ""){
		oldSelected = new Array();
	} else {
		oldSelected = oldSelected.split(";");
	}
		
	var table = mdlDimension ? $('gridDims') : $('gridMeasures');
	var ulFather = content.getElements("div")[0];
	
	var newBasicData = "";
	var newRedAttribute = "";
	var newEntAttribute = "";
	var newProAttribute = "";
	
	//BasicData
	ulFather.getElements("input.basicData").each(function (chk){
		var li = chk.parentNode.parentNode;
		if (chk.checked && !arrayContain(oldSelected,li.getAttribute("objId"))){
			var attId = li.getAttribute("objId");
			if (newBasicData != "") newBasicData += ";";
			newBasicData += attId;
		}
	});
	//Atts Redundantes
	ulFather.getElements("input.redAttribute").each(function (chk){
		var li = chk.parentNode.parentNode;
		if (chk.checked && !arrayContain(oldSelected,li.getAttribute("objId"))){
			var attId = li.getAttribute("objId");
			if (newRedAttribute != "") newRedAttribute += ";";
			newRedAttribute += attId;
		}
	});
	//Atts Entidad
	ulFather.getElements("input.entAttribute").each(function (chk){
		var li = chk.parentNode.parentNode;
		if (chk.checked && !arrayContain(oldSelected,li.getAttribute("objId"))){
			var attId = li.getAttribute("objId");
			if (newEntAttribute != "") newEntAttribute += ";";
			newEntAttribute += attId;
		}
	});	
	//Atts Proceso
	ulFather.getElements("input.proAttribute").each(function (chk){
		var li = chk.parentNode.parentNode;
		if (chk.checked && !arrayContain(oldSelected,li.getAttribute("objId"))){
			var attId = li.getAttribute("objId");
			if (newProAttribute != "") newProAttribute += ";";
			newProAttribute += attId;
		}
	});
	

	if (newBasicData != "" || newRedAttribute != "" || newEntAttribute != "" || newProAttribute != ""){
		newBasicData = '&basicData=' + newBasicData; 
		newRedAttribute = '&redAttribute=' + newRedAttribute;
		newEntAttribute = '&entAttribute=' + newEntAttribute;
		newProAttribute = '&proAttribute=' + newProAttribute;		
		
		var nextName = '&nextName=' + getNewName(table); 
		
		var request = new Request({
			method : 'post',
			url : CONTEXT + URL_REQUEST_AJAX + '?action=endAddDimension&isAjax=true' + newBasicData + newRedAttribute + newEntAttribute + newProAttribute + nextName + TAB_ID_REQUEST,
			onRequest : function() { },
			onComplete : function(resText, resXml) { processEndAddDimensions(resXml); }
		}).send();
		
		setCubeChanged();
	}		
}

function processEndAddDimensions(resXml){
	var result = resXml.getElementsByTagName("result");
	if (result != null && result.length > 0 && result.item(0) != null){
		result = result.item(0);
		var from = result.getAttribute("attFrom");
		var table = null;
		
		if (from == "addDimension"){
			table = $('gridDims');
			var dimensions = result.getElementsByTagName("dimension");
			for (var i = 0; i < dimensions.length; i++){
				var xmlDim = dimensions[i];
				var dimProDwColId = xmlDim.getAttribute("dimProDwColId");
				var attId = xmlDim.getAttribute("attId");
				var attType = xmlDim.getAttribute("attType");
				var attName = xmlDim.getAttribute("attName");
				var attFrom = xmlDim.getAttribute("attFrom");
				var dwName = xmlDim.getAttribute("dwName");
				var allMemberName = xmlDim.getAttribute("allMemberName");	
				var date = xmlDim.getAttribute("date");
				var mapEntityId = xmlDim.getAttribute("mapEntityId");
				var mapEntityName = xmlDim.getAttribute("mapEntityName");
				createDimension(dimProDwColId, attId, attType, attName, attFrom, dwName, allMemberName, date, mapEntityId, mapEntityName)
			}			
		} else {
			table = $('gridMeasures');
			var measures = result.getElementsByTagName("measure");
			for (var i = 0; i < measures.length; i++){
				var xmlMeasure = measures[i];
				var type = xmlMeasure.getAttribute("type");
				var attId = xmlMeasure.getAttribute("attId");
				var attName = xmlMeasure.getAttribute("attName");
				var attFrom = xmlMeasure.getAttribute("attFrom");
				var attType = xmlMeasure.getAttribute("attType");
				var dwColId = xmlMeasure.getAttribute("dimProDwColId");
				var dwName = xmlMeasure.getAttribute("dwName");
				var agregator = xmlMeasure.getAttribute("agregator");
				var format = xmlMeasure.getAttribute("format");
				var formula = xmlMeasure.getAttribute("formula");
				var visibility = xmlMeasure.getAttribute("visibility");
				createMeasure(type,attId,attName,attFrom,attType,dwColId,dwName,agregator,format,formula,visibility,false,true);			
			}
		}
		
		fixTableCube(table, false);
	}
}

function getNewName(from){
	var count = from.getElements("tr").length + 1;
	if (from == $('gridDims')){
		return "DIMENSION" + count;
	} else {
		return "MEASURE" + count;
	}
}

function arrayContain(array,element){
	var contain = false;
	if (array != null && array.length > 0){
		var i = 0;
		while (i < array.length && !contain){
			contain = (array[i] == element);
			i++;
		}
	}
	return contain;	
}

function showOrHideChilds(li, opClo) {
	var ul = li.getElements("ul")[0];
	if (opClo.hasClass("showChilds")){
		ul.style.display = '';
		opClo.removeClass("showChilds");
		opClo.addClass("hideChilds");
		if (li.getAttribute("wasOpened") == "false"){
			loadInfoModal(li);
			openLi = li;
		}		
		li.setAttribute("wasOpened","true");
	} else {
		ul.style.display = 'none';
		opClo.removeClass("hideChilds");
		opClo.addClass("showChilds");		
	}	
}

function loadInfoModal(li){
	var objId = li.getAttribute("objId");
	var action = li.getAttribute("action");
	
	var proId = "";
	var proEleId = "";
	if (action == "tasks" || action == "entityForms" || action == "processForms"){
		proId = "&proId=" + li.getAttribute("proId");
		proEleId = "&proEleId=" + li.getAttribute("proEleId");
	}
	
	var request = new Request({
		method : 'post',
		url : CONTEXT + URL_REQUEST_AJAX + '?action=getInfoModal&isAjax=true&objId=' + objId + '&info=' + action + proId + proEleId + TAB_ID_REQUEST,
		onRequest : function() { },
		onComplete : function(resText, resXml) { processXmlAddInfoModal(resXml,true); }
	}).send();
}

function processXmlAddInfoModal(resXml){
	var result = resXml.getElementsByTagName("result");
	if (result != null && result.length > 0 && result.item(0) != null){
		result = result.item(0);
		var from = result.getAttribute("attFrom");
		var arrLi = panelAddDim.getElements("ul.ulFather")[0].getElements("li");
		var i = 0;
		var objLi = openLi;
		
		var objUl = objLi.getElements("ul")[0];
		var lis = result.getElementsByTagName("li");
		for (i = 0; i < lis.length; i++){
			var xmlLi = lis[i];
			var label = xmlLi.getAttribute("label");
			var id = xmlLi.getAttribute("id");
			var name = xmlLi.getAttribute("name");
			var isTitle = toBoolean(xmlLi.getAttribute("isTitle"));
			var action = xmlLi.getAttribute("action");
			var tooltip = xmlLi.getAttribute("tooltip");
			var hasTooltip = tooltip != null && tooltip != "";
			
			var newLi = new Element("li",{styles:{'line-height':'20px'}}).inject(objUl);
			newLi.setAttribute("objId",id);
			newLi.setAttribute("objName",name);
			if (isTitle) {
				newLi.setAttribute("action",action);
				newLi.setAttribute("wasOpened","false");
			}			
			
			var span = new Element("span",{
				html: label,
				'title': hasTooltip ? tooltip : label
			}).setStyle('cursor', 'pointer').inject(newLi);
			
			if (isTitle){
				var ul = new Element("ul",{}).inject(newLi);
				ul.setAttribute("father",id);
				ul.style.display = 'none';
				
//				var opclo = new Element("div",{'class': "showChilds"}).inject(span);
//				opclo.setStyle("margin-top","6px");
//				opclo.addEvent('click', function(evt) { showOrHideChilds(this.parentNode.parentNode,this); evt.stopPropagation(); });
				
				var opclo = new Element("div",{'class': "showChilds"}).inject(span);
				opclo.setStyle("margin-top","6px");
				span.addEvent('click', function(evt) { 
					showOrHideChilds(this.getParent(), this.getElement('div'));
					evt.stopPropagation();
				});
				
			} else {
				var checked = toBoolean(xmlLi.getAttribute("selected"));
				var chk = new Element("input",{'type':'checkbox', 'checked': checked ? 'true' : '', styles: {'float':'left'}}).inject(span);
				
				if (from == "processData" || from == "entityProAtts"){
					chk.addClass("basicData");
				} else if (from == "proRedAtts"){
					chk.addClass("redAttribute");
				} else if (from == "entityForm"){
					chk.addClass("entAttribute");
				} else if (from == "processForm"){
					chk.addClass("proAttribute");
				}
				
				span.addEvent('click', function(evt) { 
					if(evt.target.tagName != 'INPUT')
						this.getElement('input').click();
				});
			}
			
			if (action == "tasks" || action == "entityForms" || action == "processForms"){
				var proId = xmlLi.getAttribute("proId");
				var proEleId = xmlLi.getAttribute("proEleId");
				newLi.setAttribute("proId",proId);
				newLi.setAttribute("proEleId",proEleId);
			}			
		}
	}
}

function loadMeasures(){
	var request = new Request({
		method : 'post',
		url : CONTEXT + URL_REQUEST_AJAX + '?action=loadMeasures&isAjax=true' + TAB_ID_REQUEST,
		onRequest : function() { },
		onComplete : function(resText, resXml) { 
			processXmlMeasures(resXml,true); 
			
			var table = $('gridBodyMeasures'); var footer = $('btnDeleteMea');
			var notification = new Element('div', {id : 'editionNot'}); 
			footer.grab(notification, "top");
			initAdminModalHandlerOnChangeHighlight(table, true, false, notification);
		}
	}).send();
}

function processXmlMeasures(resXml,fromInit){
	var measures = resXml.getElementsByTagName("measures");
	if (measures != null && measures.length > 0 && measures.item(0) != null){
		measures = measures.item(0).getElementsByTagName("measure");
		
		for(var i = 0; i < measures.length; i++){
			var xmlMeasure = measures[i];
			var type = xmlMeasure.getAttribute("type");
			var attId = xmlMeasure.getAttribute("attId");
			var attName = xmlMeasure.getAttribute("attName");
			var attFrom = xmlMeasure.getAttribute("attFrom");
			var attType = xmlMeasure.getAttribute("attType");
			var dwColId = xmlMeasure.getAttribute("dimProDwColId");
			var dwName = xmlMeasure.getAttribute("dwName");
			var agregator = xmlMeasure.getAttribute("agregator");
			var format = xmlMeasure.getAttribute("format");
			var formula = xmlMeasure.getAttribute("formula");
			var visibility = xmlMeasure.getAttribute("visibility");
			createMeasure(type,attId,attName,attFrom,attType,dwColId,dwName,agregator,format,formula,visibility,false,false);
		}
	}
	fixTableCube($('gridMeasures'),fromInit);	
}

function createMeasure(type,attId,attName,attFrom,attType,dwColId,dwName,agregator,format,formula,visibility,fromDuplicate,fromAdd){
	
	var tr = new Element("tr",{'class': 'selectableTR'}).inject($('gridMeasures'));
	tr.setAttribute("rowId",dwColId != null && dwColId != "" ? dwColId : "null");
	tr.addEvent("click", function(evt) { selectRowMeasures(this); evt.stopPropagation(); });
	
	//td1 ATRIBUTO
	var td1 = new Element("td", {'align':'center'}).inject(tr);
	var div1 = new Element('div', {styles: {width: '130px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td1);
	div1.style.visibility = type == "MC" ? 'hidden' : '';
	var inputAtt = new Element('input',{'type':'text','class':'readonly validate["~checkNotEmpty"]','value':attName}).inject(div1);
	inputAtt.disabled = true;
	inputAtt.readOnly = true;
	inputAtt.setAttribute("attId",attId);
	inputAtt.setAttribute("attFrom",attFrom);
	inputAtt.setAttribute("attType",attType);
	inputAtt.setAttribute("errType","3");
	$('frmData').formChecker.register(inputAtt);
	
	//td2 NOMBRE A MOSTRAR
	var td2 = new Element("td", {'align':'center'}).inject(tr);
	var div2 = new Element('div', {styles: {width: '140px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td2);
	var inputName = new Element('input',{'type':'text','value':dwName, 'class':'validate["~validName","~checkNotEmpty"]'}).inject(div2);
	inputName.addEvent("change", function (evt) { setCubeChanged(); evt.stopPropagation(); });
	inputName.setAttribute("errType","2");
	$('frmData').formChecker.register(inputName);	
	
	//td3 TIPO DE MEDIDA
	var td3 = new Element("td", {'align':'center'}).inject(tr);
	var div3 = new Element('div', {styles: {width: '120px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td3);
	var selectType = new Element("select",{}).inject(div3);
	new Element('option', {'value': 'MS', html: MSLBL }).inject(selectType);
	new Element('option', {'value': 'MC', html: MCLBL }).inject(selectType);
	selectType.value = type;
	selectType.addEvent('click', function(evt){ evt.stopPropagation(); });
	selectType.addEvent('change', function(evt){ changeType(this); evt.stopPropagation(); });
	
	//td4 FUNCION
	var td4 = new Element("td", {'align':'center'}).inject(tr);
	var div4 = new Element('div', {styles: {width: '100px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td4);
	div4.style.visibility = type == "MC" ? 'hidden' : '';
	var selectFnc = new Element('select',{}).inject(div4);
	if (fromDuplicate){
		if (attType == "N" || agregator == "0") new Element('option',{'value':'0',html: 'SUM'}).inject(selectFnc);
		if (attType == "N" || agregator == "1") new Element('option',{'value':'1',html: 'AVG'}).inject(selectFnc);
		new Element('option',{'value':'2',html: 'COUNT'}).inject(selectFnc);
		if (attType == "N" || agregator == "3") new Element('option',{'value':'3',html: 'MIN'}).inject(selectFnc);
		if (attType == "N" || agregator == "4") new Element('option',{'value':'4',html: 'MAX'}).inject(selectFnc);
		new Element('option',{'value':'5',html: 'DIST. COUNT'}).inject(selectFnc);
	} else if (fromAdd){
		new Element('option',{'value':'2',html: 'COUNT'}).inject(selectFnc);
		new Element('option',{'value':'5',html: 'DIST. COUNT'}).inject(selectFnc);
	} else {
		new Element('option',{'value':'0',html: 'SUM'}).inject(selectFnc);
		new Element('option',{'value':'1',html: 'AVG'}).inject(selectFnc);
		new Element('option',{'value':'2',html: 'COUNT'}).inject(selectFnc);
		new Element('option',{'value':'3',html: 'MIN'}).inject(selectFnc);
		new Element('option',{'value':'4',html: 'MAX'}).inject(selectFnc);
		new Element('option',{'value':'5',html: 'DIST. COUNT'}).inject(selectFnc);
	}
	selectFnc.value = traslateAgregator(agregator);
	selectFnc.addEvent('click', function(evt){ evt.stopPropagation(); });	
	selectFnc.addEvent("change", function (evt) { setCubeChanged(); evt.stopPropagation(); });

	//td5 FORMATO
	var td5 = new Element("td", {'align':'center'}).inject(tr);
	var div5 = new Element('div', {styles: {width: '130px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td5);
	div5.style.visibility = type == "MC" ? 'hidden' : '';
	var inputFormat = new Element('input',{'type':'text','value':format}).inject(div5);
	inputFormat.addEvent("change", function (evt) { setCubeChanged(); evt.stopPropagation(); });
	
	//td6 FORMULA
	var td6 = new Element("td", {'align':'center'}).inject(tr);
	var div6 = new Element('div', {styles: {width: '150px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td6);
	div6.style.visibility = type == "MS" ? 'hidden' : '';
	var inputFormula = new Element('input',{'type':'text','class':'validate["~checkFormula"]', 'value':formula,'title':'[Measure1] [+,-,*,/] [Measure2 or Number] Ej: TotalCompras - TotalGastos"'}).inject(div6);
	inputFormula.addEvent("change", function (evt) { setCubeChanged(); evt.stopPropagation(); });
	inputFormula.style.width = '145px';
	$('frmData').formChecker.register(inputFormula);	
	
	//td7 VISIBLE
	var td7 = new Element("td", {'align':'center'}).inject(tr);
	var div7 = new Element('div', {styles: {width: '50px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td7);
	var checkVis = new Element('input',{'type':'checkbox'}).inject(div7);
	checkVis.addEvent("change", function (evt) { setCubeChanged(); });
	checkVis.checked = visibility == "1";	
	
	tr.getRowId = function () { return this.getAttribute("rowId"); }	
	tr.getContentStr = function (){ //format: dwColId�attId�attType�attName�attFrom�dwName�type�agregator�format�formula�visibility
		var tds = tr.getElements("div");
		
		var dwColId = this.getRowId();
		var attId = tds[0].getElements("input")[0].getAttribute("attId");
		var attType = tds[0].getElements("input")[0].getAttribute("attType");
		var attName = tds[0].getElements("input")[0].value;
		var attFrom = tds[0].getElements("input")[0].getAttribute("attFrom");
		var dwName = tds[1].getElements("input")[0].value;
		var type = tds[2].getElements("select")[0].value;
		var agregator = tds[3].getElements("select")[0].value;
		var format = tds[4].getElements("input")[0].value;
		var formula = tds[5].getElements("input")[0].value;
		var visibility = tds[6].getElements("input")[0].checked ? "1" : "0";
		
		if (type == "MS"){ //standart
			formula = "null";
		} else { //calculada
			attId = "null";
			attType = "null";
			attName = "null";
			attFrom = "null";
			agregator = "null";
			format = "null";
		}
		
		var meaStr = "";
		meaStr = dwColId + PRIMARY_SEPARATOR + attId + PRIMARY_SEPARATOR + attType + PRIMARY_SEPARATOR + attName + PRIMARY_SEPARATOR + attFrom + PRIMARY_SEPARATOR + dwName + PRIMARY_SEPARATOR + type + PRIMARY_SEPARATOR + agregator + PRIMARY_SEPARATOR + format + PRIMARY_SEPARATOR + formula + PRIMARY_SEPARATOR + visibility; 
				
		return meaStr;
	}
}

function traslateAgregator(agregatorStr){
	var value = "";
	if (agregatorStr == 'SUM'){
		value = '0';
	} else if (agregatorStr == 'AVG'){
		value = '1';
	} else if (agregatorStr == 'COUNT'){
		value = '2';
	} else if (agregatorStr == 'MIN'){
		value = '3';
	} else if (agregatorStr == 'MAX'){
		value = '4';
	} else if (agregatorStr == 'DIST. COUNT' || agregatorStr == 'DISTINCT COUNT'){
		value = '5';
	}
	return value;
}

function changeType(select){
	var tr = select.parentNode.parentNode.parentNode;
	var tds = tr.getElements("td"); //[atributo,nombre,tipo medida,funcion,formato,formula,visible]
	var MS = select.value == "MS"; //Measure Standart
	tds[0].getElements("div")[0].style.visibility = MS ? '' : 'hidden'; 
	tds[3].getElements("div")[0].style.visibility = MS ? '' : 'hidden';
	tds[4].getElements("div")[0].style.visibility = MS ? '' : 'hidden';
	tds[5].getElements("div")[0].style.visibility = MS ? 'hidden' : '';	
	
	setCubeChanged();
}

function loadProfiles(){
	var request = new Request({
		method : 'post',
		url : CONTEXT + URL_REQUEST_AJAX + '?action=loadProfiles&isAjax=true' + TAB_ID_REQUEST,
		onRequest : function() { },
		onComplete : function(resText, resXml) { 
			processXmlProfiles(resXml); 
			
			initAdminModalHandlerOnChangeHighlight($('profilesCubeContainer'));	
			initAdminModalHandlerOnChangeHighlight($('profilesCubePermContainer'));
		}
	}).send();
}

function processXmlProfiles(resXml){
	var profiles = resXml.getElementsByTagName("profiles")
	if (profiles != null && profiles.length > 0 && profiles.item(0) != null) {
		profiles = profiles.item(0);
		
		var navegador = profiles.getElementsByTagName("navegador");
		if (navegador != null && navegador.length > 0 && navegador.item(0) != null){
			//navegador = navegador.item(0).getElements("profile");
			navegador = navegador.item(0).getElementsByTagName("profile");
			
			fromProfCube = true;
			for (var i = 0; i < navegador.length; i++){
				var xmlProf = navegador[i];
				var profId = xmlProf.getAttribute("id");
				var profName = xmlProf.getAttribute("name");
				var profDesc = xmlProf.getAttribute("description");
				var allEnv = toBoolean(xmlProf.getAttribute("allEnv"));
				createProfile(profId, profName, profDesc, null, allEnv);
			}
		}
		
		var restricted = profiles.getElementsByTagName("restricted");
		if (restricted != null && restricted.length > 0 && restricted.item(0) != null){
			//restricted = restricted.item(0).getElements("profile");
			restricted = restricted.item(0).getElementsByTagName("profile");
			
			fromProfCube = false;
			for (var i = 0; i < restricted.length; i++){
				var xmlProf = restricted[i];
				var profId = xmlProf.getAttribute("id");
				var profName = xmlProf.getAttribute("name");
				var profDesc = xmlProf.getAttribute("description");
				var profDimensions = xmlProf.getAttribute("dimensions");
				var allEnv = toBoolean(xmlProf.getAttribute("allEnv"));
				createProfile(profId, profName, profDesc, profDimensions, allEnv, false);
			}
		}				
	}	
}

function createProfile(profId,profName,profDesc,allEnv,fromModal){
	var before = $('addProfCube');
	var container = $('profilesCubeContainer');
	var prefix = "profCube_";
	if (!fromProfCube){
		before = $('addProfPermCube');
		container = $('profilesCubePermContainer');
		prefix = "profPermCube_";
		profId = profName;
	}
	if (!$(prefix+profId)){
		var prof = new Element("div",{'class': 'option optionTextOverflow optionWidth40', html: (allEnv?"<br>":"")+profName+(allEnv?"</br>":""), 'id': prefix+profId}).inject(before,"before");
		prof.setAttribute("profId",profId);
		prof.setAttribute("profName",profName);
		prof.setAttribute("profDesc",profDesc);
//		prof.addEvent("click",function(evt){ deleteProfile(this); });
		
		new Element('div.optionRemove').addEvent("click", function(evt) { deleteProfile(this.getParent()); }).inject(prof);
		
		if (!fromProfCube){
			var profDim = new Element("div", {'id': "profDim_"+profId, 'class': 'optionIcon optionModify'}).inject(prof);
			profDim.set('title', RESTRIC);
			profDim.addEvent('click', function(evt) { startMdlDimension(this.parentNode); evt.stopPropagation(); });
			prof.setAttribute("flagNew",fromModal ? "true" : "false");
		}
		return true;
	} else {
		return false;
	}	
}

function deleteProfile(prof){
	if (prof.getAttribute("id").indexOf("profPermCube_") == 0){ //Cubo de Restricciones
		var prfName = prof.getAttribute("profName");
		var request = new Request({
			method : 'post',
			url : CONTEXT + URL_REQUEST_AJAX + '?action=removeNoAccProfile&isAjax=true&prfName=' + prfName + TAB_ID_REQUEST,
			onRequest : function() { },
			onComplete : function(resText, resXml) { modalProcessXml(resXml) }
		}).send();
	}	
	prof.destroy();
	setCubeChanged();
}

function processMdlProfilesReturn(ret){
	var newPrf = 0;
	ret.each(function (prof){
		var content = prof.getRowContent();
		var profId = prof.getRowId();
		var profName = content[0];
		var profDesc = content[1];
		if (createProfile(profId,profName,profDesc,false,true)){
			newPrf++;
		}		
	});	
	if (newPrf > 0) { setCubeChanged(); }
}

function btnAllMemberNameClickConfirm(div){
	var newName = div.getElements("div")[1].getElements("input")[0].value;
	var re = new RegExp("^[a-z A-Z0-9_./]*$");
	
	if (newName != null && newName != "" && newName.match(re)){
		var tr = getSelectedRows($('gridDims'))[0];
		var td = tr.getElements("td")[0];
		td.setAttribute("allMemberName",newName);
		
		setCubeChanged();
		return true;
	} else {
		showMessage(GNR_INVALID_NAME, GNR_TIT_WARNING, 'modalWarning');
		return false;
	}
}

function duplicateMeasure(tr){
	var table = $('gridMeasures');
	var tds = tr.getElements("td");
	var div1 = tds[0].getElements("div")[0];
	var div2 = tds[1].getElements("div")[0];
	var div3 = tds[2].getElements("div")[0];
	var div4 = tds[3].getElements("div")[0];
	var div5 = tds[4].getElements("div")[0];
	var div6 = tds[5].getElements("div")[0];
	var div7 = tds[6].getElements("div")[0];
	
	var aux = div3.getElements("select")[0];
	var type = aux.value;
	
	aux = div1.getElements("input")[0];
	var attId = aux.getAttribute("attId");
	var attName = aux.value;
	var attFrom = aux.getAttribute("attFrom");
	var attType = aux.getAttribute("attType");
	
	var dwColId = null;
	
	var dwName = getNewName(table);
	
	aux = div4.getElements("select")[0];
	var agregator = aux.value;
	
	aux = div5.getElements("input")[0];
	var format = aux.value;
	
	aux = div6.getElements("input")[0];
	var formula = aux.value;	
	
	aux = div7.getElements("input")[0]
	var visibility = aux.checked ? "1" : "0";
	
	createMeasure(type,attId,attName,attFrom,attType,dwColId,dwName,agregator,format,formula,visibility,true,false);
	fixTableCube($('gridMeasures'),false);
	
	setCubeChanged();
}


function verifyCubeData(){
	if ($('chkCreCube').checked){
		
		//Verificamos si el nombre del cubo es �nico
		/*if (checkExistCubeName(document.getElementById("txtCbeName").value)){ //TODO: pendiente
			showMessage(MSG_CUBE_NAME_ALREADY_EXIST, GNR_TIT_WARNING, 'modalWarning');
			return false;
		}*/
		
		//Verificamos si ingreso al menos una dimension
		var dimensions = $('gridDims').getElements("tr");
		if (dimensions.length == 0){
			showMessage(MSG_MUST_ENT_ONE_DIM, GNR_TIT_WARNING, 'modalWarning');
			return false;
		}
		
		//Verificamos todas las dimensiones se llamen distinto
		var array = new Array();
		for(var i = 0; i < dimensions.length; i++){
			var newName = dimensions[i].getElements("td")[2].getElements("div")[0].getElements("div")[0].getElements("input")[0].value;
			if (arrayContain(array, newName)){
				showMessage(MSG_DIM_NAME_UNIQUE, GNR_TIT_WARNING, 'modalWarning');
				return false;
			}
			array[array.length] = newName;			
		}
		
		//Verificamos dimensiones
		var someAttNoBasic = false;
		for(var i = 0; i < dimensions.length; i++){
			var dimName = dimensions[i].getElements("td")[2].getElements("div")[0].getElements("div")[0].getElements("input")[0].value;
			var attName = dimensions[i].getElements("td")[0].getAttribute("attName");
			var attId = dimensions[i].getElements("td")[0].getAttribute("attId");
			
			/*if (attName == ""){ //Verificamos que los nombres de los atributos no sean nulos
				showMessage(MSG_MIS_DIM_ATT, GNR_TIT_WARNING, 'modalWarning');
				return false;
			}*/
			/*if (dimName == ""){ //Verificamos que los nombres de las dimensiones no sean nulos
				showMessage(MSG_WRG_DIM_NAME, GNR_TIT_WARNING, 'modalWarning');
				return false;
			}
			if ( attId > 0){
				someAttNoBasic = true;
			}*/
		}
		
		//Verificamos si ingreso al menos una medida
		var measures = $('gridMeasures').getElements("tr");
		if (measures.length == 0){
			showMessage(MSG_MUST_ENT_ONE_MEAS, GNR_TIT_WARNING, 'modalWarning');
			return false;
		}
		
		//Verificamos todas las medidas se llamen distinto
		array = new Array();
		for(var i = 0; i < measures.length; i++){
			var newName = measures[i].getElements("td")[1].getElements("div")[0].getElements("input")[0].value;
			if (arrayContain(array, newName)){
				showMessage(MSG_MEASURE_NAME_UNIQUE, GNR_TIT_WARNING, 'modalWarning');
				return false;
			}
			array[array.length] = newName;			
		}
		
		
		//Verificamos medidas
		var visible = false;
		for(var i = 0; i < measures.length; i++){
			var meaName = measures[i].getElements("td")[1].getElements("div")[0].getElements("input")[0].value;
			/*if (meaName == ""){//Verificamos que los nombres de las medidas no sean nulos
				showMessage(MSG_WRG_MEA_NAME, GNR_TIT_WARNING, 'modalWarning');
				return false;
			}*/
			
			var measType = measures[i].getElements("td")[2].getElements("div")[0].getElements("select")[0].value;
			if (measType == "MC"){//Si es medida calculada verificamos la formula
				/*var measFormula = measures[i].getElements("td")[5].getElements("div")[0].getElements("input")[0].value;
				if (!chkFormula(measFormula,meaName)){
					return false;
				}*/
			}else{ //Si es medida estandart
				var attName = measures[i].getElements("td")[0].getElements("div")[0].getElements("input")[0].value;
				/*if (attName == ""){
					showMessage(MSG_WRG_MEA_NAME, GNR_TIT_WARNING, 'modalWarning');
					return false;
				}*/
			}
			if (measures[i].getElements("td")[6].getElements("div")[0].getElements("input")[0].checked){
				visible = true;
			}
		}		
		if (!visible){
			showMessage(MSG_ATLEAST_ONE_MEAS_VISIBLE, GNR_TIT_WARNING, 'modalWarning');
			return false;
		}
				
		
		//Verificamos que si se agrego algun perfil para restringir sus dimensiones, se haya restringido alguna
		var prfs = "";
		$('profilesCubePermContainer').getElements("div.optionRemove").each(function (prf){
			if (toBoolean(prf.getAttribute("flagNew"))){
				if (prfs != "") prfs += ";";
				prfs += prf.getAttribute("profName");
			}
		});
		if (prfs != ""){
			var msg = prfs.indexOf(";") < 0 ? MSG_PRF_NO_ACC_DELETED : MSG_PRFS_NO_ACC_DELETED;
			SYS_PANELS.newPanel();
			var panel = SYS_PANELS.getActive();
			panel.addClass("modalWarning");
			panel.content.innerHTML = msg.replace("<TOK1>",prfs);
			panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); btnPrfRestClickConfirm();\">" + BTN_CONFIRM + "</div>";
			SYS_PANELS.addClose(panel);
			SYS_PANELS.refresh();
			
			return false;
		}
		
	}	
	return true;
}

function btnPrfRestClickConfirm(){
	forceConfirm = true;
	$('btnConf').fireEvent('click', {
	    target: $('btnConf'),
	    type: 'click',
	    stop: Function.from
	});
}


function checkNotEmpty(el){
	var showing = (el.parentNode.style.display == '');
	var value = el.value;
    if ((value == null || value == "") && showing) {
    	var error = getErrMsg(el);
        el.errors.push(error);
        return false;
    } else {
        return true;
    }
}

//Verifica si es valido el nombre de una dimension o medida
function validName(name){
	var reBIAlphanumeric = /^[a-zA-Z0-9_]*$/;
	var valid = reBIAlphanumeric.test(name.value); 
	if (!valid){
		name.errors.push(GNR_INVALID_NAME);
		return false;
	} else {
		return true;
	}
}

//Verifica si la formula es correcta
//formatos posibles: Measure op Measure, Measure op NUMBER
function checkFormula(obj){
	var showing = (obj.parentNode.style.visibility == '');
	if (showing){
		var measName = obj.parentNode.parentNode.parentNode.getElements("td")[1].getElements("div")[0].getElements("input")[0].value;
		
		//1. Hallamos la medida 1, el operarador y la medida2 (o number)
		var formula = obj.value;
		if (formula == ""){
			obj.errors.push(MSG_MUST_ENTER_FORMULA);
			return false;
		}
		var esp1 = formula.indexOf(" ");
		var formula2 = formula.substring(esp1+1, formula.length);
		var meas1 = formula.substring(0,esp1);
		var op = formula2.substring(0,1);
		var meas2 = formula2.substring(2, formula2.length);
		
		//2. Verificamos la medida1 exista
		if (!chkMeasExist(meas1)){
			if (esp1 < 0){
				obj.errors.push(formula + ": " + MSG_MEAS_OP1_NAME_INVALID);
			}else {
				obj.errors.push(meas1 + ": " + MSG_MEAS_OP1_NAME_INVALID);
			}
			return false;
		}
		
		//3. Verificamos el operador sea valido
		if (op != '/' && op != '-' && op != '+' && op != '*'){
			obj.errors.push(op + ": " + MSG_OP_INVALID);
			return false;
		}
		
		//4. Verificamos la medida2 exista
		if (!chkMeasExist(meas2)){//Si no existe como medida talvez sea un numero
			if (isNaN(meas2)){
				obj.errors.push(meas2 + ": " + MSG_MEAS_OP2_NAME_INVALID);
				return false;
			}
		}
		
		//5. Verificamos no se utilice el nombre de la propia medida como un operando de la formula.
		if (measName == meas1 || measName == meas2){
			obj.errors.push(measName + ": " + MSG_MEAS_NAME_LOOP_INVALID);
			return false;
		}		
	} 
	
    return true;
}

//Verifica si la medida usada en una formula es valida
function chkMeasExist(measure){
	var measures = $('gridMeasures').getElements("tr");
	for(var i = 0; i < measures.length; i++){
		var name = measures[i].getElements("td")[1].getElements("div")[0].getElements("input")[0].value;
		if (name == measure){
			return true;
		}
	}
	return false;
}

function getErrMsg(obj){
	var errType = obj.getAttribute("errType");
	if (errType == "0"){
		return MSG_MIS_DIM_ATT;
	} else if (errType == "1"){
		return MSG_WRG_DIM_NAME;
	} else if (errType == "2"){
		return MSG_WRG_MEA_NAME;
	} else if (errType == "3"){
		return MSG_MIS_MEA_ATT;
	}
}

function setCubeChanged(){
	$('cubeChanged').value = "true";
}

function getDimensionValuesAsStr(){
	var ret = "";
	$('gridDims').getElements("tr").each(function (tr){
		var dimStr = tr.getContentStr();
		if (ret != "") ret += ";";
		ret += dimStr;
	});
	return ret;
}

function getMeasuresValuesAsStr(){
	var ret = "";
	$('gridMeasures').getElements("tr").each(function (tr){
		var dimMea = tr.getContentStr();
		if (ret != "") ret += ";";
		ret += dimMea;
	});
	return ret;
}

function getAllIdLoaded(table){ //format: id1;id2;id3...
	var ids = "";
	table.getElements("tr").each(function (tr){
		var id = tr.getRowId();
		if (id != null && id != "null" && id != ""){
			if (ids != "") ids += ";";
			ids += id;
		}
	});
	return ids;
}

function verifyCubeDataToEstimateTime(){	
	//Verificamos si ingreso al menos dos dimensiones
	var dimRows = $('gridDims').getElements("tr");
	if (dimRows.length < 1){
		showMessage(MSG_MUST_ENT_ONE_DIM, GNR_TIT_WARNING, 'modalWarning');
		return false;
	}
	
	//Verificamos dimensiones
	for(var i = 0; i < dimRows.length; i++){
		var dimName = dimRows[i].getElements("td")[2].getElements("div")[0].getElements("div")[0].getElements("input")[0].value;
		var attName = dimRows[i].getElements("td")[0].getAttribute("attName");
		if(attName == ""){ //Verificamos que los nombres de los atributos no sean nulos
			showMessage(MSG_MIS_DIM_ATT, GNR_TIT_WARNING, 'modalWarning');
			return false;
		}
		if (dimName == ""){//Verificamos que los nombres de las dimensiones no sean nulos
			showMessage(MSG_WRG_DIM_NAME, GNR_TIT_WARNING, 'modalWarning');
			return false;
		}
	}
			
	//Verificamos si ingreso al menos una medida
	var meaRows = $('gridMeasures').getElements("tr");
	if (meaRows.length < 1){
		showMessage(MSG_MUST_ENT_ONE_MEAS, GNR_TIT_WARNING, 'modalWarning');
		return false;
	}
	
	//Verificamos medidas
	for(var i = 0; i < meaRows.length;i++){
		//Verificamos haya seleccionado atributos en las medidas estandard			
		var measType = meaRows[i].getElements("td")[2].getElements("div")[0].getElements("select")[0].value;
		if (measType == "MS"){
			var attName = meaRows[i].getElements("td")[0].getElements("input")[0].value;
			if(attName == ""){//Verificamos que los nombres de los atributos no sean nulos
				showMessage(MSG_MIS_MEA_ATT, GNR_TIT_WARNING, 'modalWarning');
				return false;
			}
		}
	}
	return true;
}

function getAttIdsSelected(){
  	var str = "";
  	var mapAtts = 0;
  	var dimensions = $('gridDims');
  	var measures = $('gridMeasures');
  	if (dimensions != null && measures != null){
  		var strArr = new Array();		
		
  		//Dimensions
		var dimRows = dimensions.getElements("tr");
		for(var i = 0; i < dimRows.length; i++){
			var attId = dimRows[i].getElements("td")[0].getAttribute("attId");
			if (!arrayContain(strArr, attId)){
				strArr[strArr.length] = attId;
			}			
	  		
			var mapEntId = dimRows[i].getElements("td")[2].getAttribute("mapEntityId");
			
			if (mapEntId != null && mapEntId != "" && mapEntId != "null"){
	  			mapAtts++;
		  	}
		}
		
		//Measures
		var dimMeas = measures.getElements("tr");
		for(var i = 0; i < dimMeas.length; i++){
			var attId = dimMeas[i].getElements("td")[0].getElements("div")[0].getElements("input")[0].getAttribute("attId"); 
			if (!arrayContain(strArr, attId)){
				strArr[strArr.length] = attId;
			}
		}
		
		for(var i = 0; i < strArr.length; i++){
			if (str != "") str += ";";
			str += strArr[i];
		}		
		str = "&attId=" + str + "&mapAtts=" + mapAtts;
	}
	return str;
}

function deleteDimension(trDim){
	if (trDim){
		var inputAttName = trDim.getElements("td")[0].getElements("div")[0].getElements("input")[0]; 
		var inputDwName = trDim.getElements("td")[2].getElements("div")[0].getElements("div")[0].getElements("input")[0];
		$('frmData').formChecker.dispose(inputAttName);
		$('frmData').formChecker.dispose(inputDwName);
		trDim.destroy();
	}
}

function deleteMeasure(trMea){
	if (trMea){
		var inputAttName = trMea.getElements("td")[0].getElements("div")[0].getElements("input")[0];
		var inputDwName = trMea.getElements("td")[1].getElements("div")[0].getElements("input")[0];
		var inputFormula = trMea.getElements("td")[5].getElements("div")[0].getElements("input")[0];
		$('frmData').formChecker.dispose(inputAttName);
		$('frmData').formChecker.dispose(inputDwName);
		$('frmData').formChecker.dispose(inputFormula);
		trMea.destroy();
	}
}

function validateHours(obj){
   if (obj.value == "") return true;	
	
   var RegEx = /^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/;
   if(!obj.value.match(RegEx)){
	  obj.errors.push("Invalid format "+TIME_FORMAT);
      return false;
   }   
   return true;
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