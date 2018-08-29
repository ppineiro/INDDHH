function initPage(){
	
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	var mode = UPDATE_MODE;
	if (!$('cbeName').get('value')) { //Estamos creando
		mode=INSERT_MODE;
	}
	
	initAdminFieldOnChangeHighlight();
	initAdminActionsEdition(function () { return false;}, false, false); //Acciones de los botones Confirmar, Volver, etc..  => Se comentan pues es necesario agregar los eventos de onConfirm desde este archivo
	initGenDataTab(mode); //en tabGenData.js
	initDataSourceTab(mode); // en tabDataSource.js
	initMeasuresTab(mode); // en tabMeasures.js
	initPermissionsTab(mode); //en tabPerms.js

	initAdminFav();
	initPoolMdlPage();
	
	//Cuando se ingrese al tab de medidas
	$('measureTab').addEvent("focus", function(evt){
    	var radUseView = $("radFactTable2");
    	if (radUseView){
    		if (radUseView.get('value')=="on"){ //Si se esta usando vista
    			$('panelOptions').style.display=''; //Mostramos panel de opciones
    		}else{
    			$('panelOptions').style.display='none';  //Ocultamos panel de opciones 		
    		}
    	}else{
    		$('panelOptions').style.display='none';  //Ocultamos panel de opciones 		  		
    	}
    	
    	addScrollTable($('gridMeasures'));
    	
    });
    
	//Cuando se salga del tab de medidas
    $('measureTab').addEvent("blur", function(evt){
    	$('panelOptions').style.display='none'; //Ocultamos panel de opciones 
    });    
		
	
	/************************************************************************************************
	 * El siguiente c�digo se extrajo de adminActionEdition.jsp, del metodo initAdminActionsEdition()
	 * Ya que se desea testear la sql antes de realizar el submit
	 ************************************************************************************************/
	
	$('frmData').formChecker = new FormCheck(
			'frmData',
			{
				submit:false,
				display : {
					keepFocusOnError : 1,
					tipsPosition: 'left',
					tipsOffsetY: -12,
					tipsOffsetX: -10
				}
			}
		);
	
	$('btnConf').addEvent("click", function(e) {
		e.stop();
		
		var form = $('frmData');
		if(!form.formChecker.isFormValid()){
			return;
		}
		
		if ($('radFactTable2').checked) {
			//testear sql
			testSQL(true,'processXMLTestResult'); //Testeamos la sql, y si esta bien realizamos el submit
		}else {
			doSubmit();
		}
	});

//	$('btnBackToList').addEvent("click", function(e) {
//		e.stop();
//		sp.show(true);
//		window.location = CONTEXT + URL_REQUEST_AJAX + '?action=list' + TAB_ID_REQUEST;
//	});

	/************************************************************************************************
	 * Fin de codigo extraido de adminActionEdition.jsp
	 ************************************************************************************************/
	
	
	$('dimensionTab').addEvent("focus", function(evt){	
		refreshData(); //Refresca los datos en el tab dimensiones
	});
	
	getBodyController().canRemoveTab = function() { return ! AT_LEAST_ON_FIELD_INPUT_CHANGED; };
}

function processXMLTestResult(ajaxCallXml, onConfirm){
	if (ajaxCallXml != null) {
		var result = ajaxCallXml.getElements("test_result");
		var testResult = "";
		
		if (result != null && result.length > 0 && result.item(0) != null) {
			testResult = result.item(0).getAttribute("test_result");
		}else {
			showMessage(MSG_SRV_CONN_LOST, GNR_TIT_WARNING, 'modalWarning');
		}
		
		if (onConfirm==null) onConfirm = true;
		return processTestResult(testResult, onConfirm);
	}else {
	   showMessage(MSG_SRV_CONN_LOST, GNR_TIT_WARNING, 'modalWarning');
       return false;
	}
}

function processTestResult(testResult, onConfirm) {
	if(testResult != "OK"){
		 if (!onConfirm){ //Si no estamos confirmando
			 showMessage("SQL ERROR: " + testResult, GNR_TIT_WARNING, 'modalWarning');
			 return false;
		 }else {
			 showConfirm(MSG_QUERY_WITH_ERRORS,GNR_TIT_WARNING, confirmQueryWithErrors, "modalWarning");
		 }
   } else { //SQL IS OK
       if (!onConfirm){ //Si no estamos confirmando
       	showMessage("SQL OK!", GNR_TITLE_MESSAGES, 'modalWarning');
       	return true;
       } else {
       	//REALIZAMOS SUBMIT
       	doSubmit();
       	return true;
       }
   }
}

function confirmQueryWithErrors(msg) {
	if (msg) {
	 	//REALIZAMOS SUBMIT
    	doSubmit();  
    	return true;
 }else{
	    return false;
 }
}

function doSubmit(){
	SYS_PANELS.closeActive();
	$('xmlDims').set('value', getXML());
	
	if (verifyData()){
		var params = getFormParametersToSend($('frmData'));
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=confirm&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send(params);
	}
	
}

function verifyData() {
	
	if ($('radFactTable1').checked) {
		//Verificamos haya seleccionado una tabla
		if ($('selFactTable').get('value') == 0){
			showMessage(MSG_FACT_TABLE_NOT_FOUND, GNR_TIT_WARNING, 'modalWarning');
			return false;
		}
	}else {
		//Verificamos caracteres invalidos en la vista
		if ($('txtFactTableView').get('value').indexOf("\"")>0){
			showMessage(MSG_ERROR_IN_SQL_VIEW_WITH_COMS, GNR_TIT_WARNING, 'modalWarning');
			return false;
		}
		
		if ($('txtFactTableView').get('value').indexOf("<")>0){
			showMessage(MSG_ERROR_IN_SQL_VIEW_WITH_MINOR_CHAR, GNR_TIT_WARNING, 'modalWarning');
			return false;
		}
		
		if ($('txtFactTableView').get('value').indexOf("ORDER BY")>0){
			showMessage(MSG_ERROR_IN_SQL_VIEW_WITH_ORDER_BY, GNR_TIT_WARNING, 'modalWarning');
			return false;
		}
	}
	
	//Verificamos si agrego alguna medida
	if ($('gridMeasures').rows.length <= 0){
		showMessage(MSG_MUST_ENT_ONE_MEAS, GNR_TIT_WARNING, 'modalWarning');
		return false;
	}
	
	//Verificamos medidas
	var meaRows= $('gridMeasures').rows;
	var visible = false;
	var meaNames = [];
	for(var i=0;i<meaRows.length;i++){
		var meaName= meaRows[i].getElements("TD")[1].getElements("INPUT")[0].get('value');
		if (measureNameInUse(meaNames, meaName)) {
			showMessage(MSG_CANT_BE_TWO_MEAS_WITH_SAME_NAME, GNR_TIT_WARNING, 'modalWarning');
			return false;
		}
		meaNames[meaNames.length] = meaName;
		var meaCaption = meaRows[i].getElements("TD")[2].getElements("INPUT")[0].get('value');
		
		if (meaName == ""){//Verificamos que los nombres de las medidas no sean nulos
			showMessage(MSG_WRG_MEA_NAME, GNR_TIT_WARNING, 'modalWarning');
			return false;
		}
		if (!isValidMeasureName(meaName)){
			showMessage(MSG_MEAS_INV_NAME, GNR_TIT_WARNING, 'modalWarning');
			return false;
		}
		
		if (!isValidMeasureCaption(meaCaption)){
			showMessage(MSG_MEAS_INV_CAP, GNR_TIT_WARNING, 'modalWarning');
			return false;
		}
		
		var cmb=meaRows[i].cells[3].getElements("SELECT")[0];
		var measType = (cmb.options[cmb.selectedIndex].get('value'));
		if (measType == 1){//Si es medida calculada verificamos la formula
			var measFormula = meaRows[i].getElements("TD")[6].getElements("INPUT")[0];
			if (!chkFormula(meaName, measFormula)){
				return false;
			}
		}else{
			var attName = meaRows[i].getElements("TD")[0].getElements("SELECT")[0].get('value');
			if (attName == ""){
				showMessage(MSG_MIS_MEA_ATT, GNR_TIT_WARNING, 'modalWarning');
				return false;
			}
			if (meaCaption == ""){//Verificamos que los caption de las medidas no sean nulos
				showMessage(MSG_WRG_MEA_CAP, GNR_TIT_WARNING, 'modalWarning');
				return false;
			}
		}
		if (meaRows[i].getElements("TD")[7].getElements("INPUT")[0].checked){
			visible = true;
		}
	}
	
	//Almenos una medida debe ser visible	
	if (!visible){
		showMessage(MSG_ATLEAST_ONE_MEAS_VISIBLE, GNR_TIT_WARNING, 'modalWarning');
		return false;
	}
	
	return true;
}

//verifica que sea un nombre de dimension valido (letras,numeros,_ y espacio)
function isValidDimensionName(s){
	var reAlphanumerico = /^[a-z_A-Z0-9 ]*$/;
	var x = reAlphanumerico.test(s);
	if(!x){
		return false;
	}
	return true;
}

//verifica que sea un nombre de medida valido
function isValidMeasureName(s){
	var reAlphanumerico = /^[a-z_A-Z0-9 ]*$/;
	var x = reAlphanumerico.test(s);
	if(!x){
		return false;
	}
	return true;
}

//verifica que sea un caption de medida valido
function isValidMeasureCaption(s){
	var reAlphanumerico = /^[a-z_A-Z0-9]*$/;
	var x = reAlphanumerico.test(s);
	if(!x){
		return false;
	}
	return true;
}

//Verifica si la formula es correcta
//formatos posibles: Measure op Measure, Measure op NUMBER
function chkFormula(meaName, obj){
	
	//1. Hallamos la medida 1, el operarador y la medida2 (o number)
	var formula = obj.get('value');
	if (formula == ""){
		showMessage(MSG_MUST_ENTER_FORMULA, GNR_TIT_WARNING, 'modalWarning');
		return false;
	}
	var opPos = formula.indexOf("*");
	if (opPos<0){
		opPos = formula.indexOf("/");
	}
	if (opPos<0){
		opPos = formula.indexOf("-");
	}
	if (opPos<0){
		opPos = formula.indexOf("+");
	}
	
	var formula2 = formula.substring(opPos, formula.length);
	var meas1 = formula.substring(0,opPos-1);
	var op = formula2.substring(0,1);
	var meas2 = formula2;
	if (formula2.length>1){
		meas2 = formula2.substring(2, formula2.length);
	}
	
	//1.5 Verificamos que ninguna de las medidas utilizadas en la formula se llamen como la medida actual
	if (meaName == meas1 || meaName == meas2){
		showMessage(MSG_MEAS_CANT_AUTOREF + " " + meaName, GNR_TIT_WARNING, 'modalWarning');
		return false;
	}
	
	//2. Verificamos la medida1 exista
	if (!chkMeasExist(meas1)){
		if (opPos < 0){
			showMessage(formula + ": " + MSG_MEAS_OP1_NAME_INVALID, GNR_TIT_WARNING, 'modalWarning');
		}else {
			showMessage(meas1 + ": " + MSG_MEAS_OP1_NAME_INVALID, GNR_TIT_WARNING, 'modalWarning');
		}
		obj.focus();		
		return false;
	}
	
	//3. Verificamos el operador sea valido
	if (op != '/' && op != '-' && op != '+' && op != '*'){
		showMessage(op + ": " + MSG_OP_INVALID, GNR_TIT_WARNING, 'modalWarning');
		obj.focus();
		return false;
	}
	
	//4. Verificamos la medida2 exista o sea un n�mero
	if (!chkMeasExist(meas2)){//Si no existe como medida talvez sea un numero
		if (isNaN(meas2)){
			showMessage(meas2 + ": " + MSG_MEAS_OP2_NAME_INVALID, GNR_TIT_WARNING, 'modalWarning');
			obj.focus();
			return false;
		}
	}
	return true;
}

//Verifica si la medida usada en una formula es valida
function chkMeasExist(measure){
//	if ($('gridMeasures').selectedItems.length) {
		var trows=$('gridMeasures').rows;
		for (i = 0; i < trows.length; i++) {
			if (trows[i].getElements("TD")[1].getElements("INPUT")[0].get('value') == measure) {
				return true;
			}
		}
	/*}else{
		return false;		
	}*/

	return false;
}

function measureNameInUse(meaNames, meaName) {
	if (meaNames.length==0) return false;
	for (i=0; i< meaNames.length; i++) {
		if (meaNames[i] == meaName) return true;
	}
	return false;
}