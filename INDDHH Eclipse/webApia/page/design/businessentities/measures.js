function initMeasures(hasCube,ok){
	var btnAddMea = $('btnAddMea');
	if (btnAddMea){
		btnAddMea.addEvent("click",function(e){
			e.stop();
			var request = new Request({
				method: 'post',			
				url: CONTEXT + URL_REQUEST_AJAX+'?action=addAttMeasure&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { sp.show(true); },
				onComplete: function(resText, resXml) { processXMLmodalAddAttMeasure(resXml); sp.hide(true); addScrollTable($('gridMeasures'));}
			}).send();
		});
	}
	
	var btnDeleteMea = $('btnDeleteMea');
	if (btnDeleteMea){
		btnDeleteMea.addEvent("click",function(e){
			e.stop();
			var count = selectionCount($('gridMeasures'));
			if(count==0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (count>1){
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			}else{
				var attId = getSelectedRows($('gridMeasures'))[0].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value;
				var dwName = getSelectedRows($('gridMeasures'))[0].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value;
				var request = new Request({
					method: 'post',	
					data:{id:attId,'forMeasure':true,'dwName':dwName},
					url: CONTEXT + URL_REQUEST_AJAX+'?action=removeEntDwCol&isAjax=true' + TAB_ID_REQUEST,
					onRequest: function() { sp.show(true); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml);sp.hide(true); addScrollTable($('gridMeasures'));}
				}).send();
			} 
		});
	}
	
	var btnDupMea = $('btnDupMea');
	if (btnDupMea){
		btnDupMea.addEvent("click",function(e){
			e.stop();
			var count = selectionCount($('gridMeasures'));
			if(count==0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (count>1){
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			}else{
				btnDupMeasure_click();
			}
		});
	}
	
	if (hasCube&&ok=="ok"){
		loadMeasures();
	} else {
		var table = $('gridBodyMeasures');
		if (table) {
			var footer = $('buttonsMea');
			var notification = new Element('div', {id : 'editionNot'}); 
			footer.grab(notification, "top");
			initAdminModalHandlerOnChangeHighlight(table, true, false, notification);
			
			initAdminRadioButtonOnChangeHighlight($('dataLoad1').getParent('.fieldGroup'), 'dataLoad');
		}
	}
	var gbm = $('gridBodyMeasures');
	if(gbm)
		gbm.addEvent('custom_scroll', function(left) {
			$('gridTableMeasures').getElement('div.gridHeader').getElement('table').setStyle('left', left);
		});
}

function loadMeasures(){
	loadAtts(false);
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX+'?action=loadMeasures&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { 
			modalProcessXml(resXml); sp.hide(true);
			
			var table = $('gridBodyMeasures');
			var footer = $('buttonsMea');
			var notification = new Element('div', {id : 'editionNot'}); 
			footer.grab(notification, "top");
			initAdminModalHandlerOnChangeHighlight(table, true, false, notification);
			
			initAdminRadioButtonOnChangeHighlight($('dataLoad1').getParent('.fieldGroup'), 'dataLoad');
		}
	}).send();
}

function processXMLmodalAddAttMeasure(ajaxCallXml){
	if (ajaxCallXml != null) {		
		var envs = ajaxCallXml.getElementsByTagName("lis");	
		if (envs != null && envs.length > 0 && envs.item(0) != null) {
			
			var  formAction =  URL_REQUEST_AJAX+'?action=getAttsInfo&isAjax=true' + TAB_ID_REQUEST;
			var formMethod = "POST";
			var form = new Element('form',{id:'frmModalPanelAjax',action:formAction,method:formMethod});
			
			
			var result = ajaxCallXml.getElementsByTagName("result");	
			var title = result.item(0).getAttribute("title");
			envs = envs.item(0).getElementsByTagName("li");
			var element;
			if (SYS_PANELS.hasActive()){
				element = SYS_PANELS.getActive();
			}else{
				element = SYS_PANELS.newPanel();
			}
			var div = new Element('div');
			var ul = new Element('ul');
			ul.inject(div);
			for(var i = 0; i < envs.length; i++) {
				var env = envs.item(i);
				var extra = {
						action:env.getAttribute("action"),
						tooltip:env.getAttribute("tooltip"),
						text: env.getAttribute("text"),
						inputs:new Array({type:'hidden',name:"hidEntDataId",id:"hidEntDataId",value:i})
				}
				addAttLi(extra,ul,false);
			}
			
			element.addClass("addClass");
			div.inject(form);			
			if (title && title != "") element.header.innerHTML = title;
			element.footer.innerHTML = "<div onclick=\"setSelectedMeasures();\" class='button'>"+LBL_CON+"</div>";
			SYS_PANELS.addClose(element, true, null); 
			form.inject(element.content);	
		}
	}
}

function setSelectedMeasures(){
	var str = "&forMeasures=true&forDimensions=null";
	if (selAttsMea.length > 0){
		for (i = 0; i < selAttsMea.length; i++) {
			if (selAttsMea[i]!=null){
				if (str==""){
					str = "&attId=" + selAttsMea[i];
				}else{
					str = str + "&attId=" + selAttsMea[i];
				}
			}
		}
	}
	if (selBasicDatMea.length >0){
		for (i = 0; i < selBasicDatMea.length; i++) {
			if (selBasicDatMea[i]!=null){
				if (str==""){
					str = "&attId=" + selBasicDatMea[i];
				}else{
					str = str + "&attId=" + selBasicDatMea[i];
				}
			}
		}
	}
	
	var request = new Request({
		method: 'post',			
		url: CONTEXT + URL_REQUEST_AJAX+'?action=getAttsInfo&isAjax=true' + TAB_ID_REQUEST,	
		onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
	}).send(str);
	
}

function drawMeasure(){
	var result = new Array();
	var ajaxCallXml = getLastFunctionAjaxCall();
	var attsInfo = ajaxCallXml.getElementsByTagName("html").item(0).firstChild.nodeValue;
	
	if (attsInfo == "NOK"){return;}
    var i=0;
    
    //1.Agregamos los atributos seleccionados
	while (attsInfo.indexOf(",")>-1){
		var attId = attsInfo.substring(0,attsInfo.indexOf(","));
		attsInfo = attsInfo.substring(attsInfo.indexOf(",")+1,attsInfo.length);
		var attNom;
		if (attsInfo.indexOf(",")<0){
			attNom = attsInfo;					
		}else{
			attNom = attsInfo.substring(0,attsInfo.indexOf(","));
		}
		attsInfo = attsInfo.substring(attsInfo.indexOf(",")+1,attsInfo.length);
		arr = new Array();
		if (attId != "skip"){
			var attLbl = attsInfo.substring(0,attsInfo.indexOf(","));
			attsInfo = attsInfo.substring(attsInfo.indexOf(",")+1,attsInfo.length);
			var attType = attsInfo.substring(0,attsInfo.indexOf(","));
			attsInfo = attsInfo.substring(attsInfo.indexOf(",")+1,attsInfo.length);
			var attIdMap = attsInfo.substring(0,attsInfo.indexOf(","));
			attsInfo = attsInfo.substring(attsInfo.indexOf(",")+1,attsInfo.length);
			var attNamMap = "null";
			if (attsInfo.indexOf(",")<0){
				attNamMap = attsInfo;
			}else{
				attNamMap = attsInfo.substring(0,attsInfo.indexOf(","));
			}
			attsInfo = attsInfo.substring(attsInfo.indexOf(",")+1,attsInfo.length);
			arr[0] = attId;
			arr[1] = attNom;
			arr[2] = attLbl;
			arr[3] = attType;
			arr[4] = attIdMap;
			arr[5] = attNamMap;
			
			
		}else{
			arr[0] = attId; //Ponemos la palabra que indica que se debe hacer skip
			arr[1] = attNom; //si se debe hacer skip, en attNom tenemos el attId (hecho asi por si existe un att llamado skip)
		}
		result[i] = arr;		
		i++;
	}
	processResult(result);	
	SYS_PANELS.closeAll();
}

function processResult(rets){
	var parent = $('gridMeasures').getParent();
	$('gridMeasures').selectOnlyOne = false; 
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
	if (rets != null) {
		if (rets!="NOK"){
			if (rets.length>0){
				var strAttIds = "";
				for (j = 0; j < rets.length; j++) {
					var ret = rets[j];
					if (ret[0] != "skip"){
						var attId = ret[0];
						var attName = ret[1];
						var attLbl = ret[2];
						var attType = ret[3];
						var attMapEntId = ret[4];
						var attMapEntName = ret[5];
						var addMea = true;
						
						//Guardamos el attId que se selecciono en el string attIds
						if (strAttIds == ""){
							strAttIds = attId;
						}else{
							strAttIds = strAttIds + "," + attId;
						}
						
						if (attMapEntId == null || attMapEntId == "null"){
							attMapEntId = "";
						}
						if (attMapEntName == null || attMapEntName == "null"){
							attMapEntName = "";
						}
						
						//2- Nos fijamos si ya no se habia agregado la Measure
						var trows=$("gridMeasures").rows;
						for (i=0;i<trows.length && addMea;i++) {
							if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == attId) {
								addMea = false;
							}
						}
						
						var row = trows.length;
						
						//3- Si no se habia agregado, agregamos el atributo seleccionado como Measure
						if (addMea) {
							
							/*
							Agregado de medidas: Hay dos tipos de medidas: Medidas comunes que utilizan una columna de la tabla de hechos y medidas calculadas que utilzan otras medidas
							*/
							
							// agregamos como tipo Measure por defecto
							
							var oTd1 = new Element("TD"); //atributo
							var oTd2 = new Element("TD"); //nombre de la medida
							var oTd3 = new Element("TD"); //tipos de medida
							var oTd4 = new Element("TD"); //agregadores
							var oTd5 = new Element("TD"); //formato
							var oTd6 = new Element("TD"); //formula
							var oTd7 = new Element("TD",{styles:{'border-right':'none'}}); //visible
							
							var measureName = "MEASURE" + ($("gridMeasures").rows.length + 1);
							
							div = new Element('div', {styles: {width: tdWidths[0], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
							
							//Atributo							
							input = new Element('input',{type:'text',name:'attMeaName',id:'attMeaName',title:attName});
							input.setAttribute('value',attName);
							input.inject(div);
							
							input = new Element('input',{type:'hidden',name:'hidAttMeasId'});
							input.setAttribute('value',attId);
							input.inject(div);
							
							input = new Element('input',{type:'hidden',name:'hidAttMeasName'});
							input.setAttribute('value',attName);
							input.inject(div);
							
							input = new Element('input',{type:'hidden',name:'hidAttMeasType'});
							input.setAttribute('value',attType);
							input.inject(div);
							
							input = new Element('input',{type:'hidden',name:'hidMeasEntDwColId'});
							input.setAttribute('value',0);
							input.inject(div);
							
							div.inject(oTd1);
							
							//Nombre a mostrar
							div = new Element('div', {styles: {width: tdWidths[1], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
							
							input = new Element('input',{type:'text',name:'dispName','onchange':'chkMeasName(this)'});
							input.setAttribute('value',measureName);
							input.inject(div);
							
							div.inject(oTd2);
							
							//Tipo de medida
							div = new Element('div', {styles: {width: tdWidths[2], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
							
							var selector = new Element('select',{name:'selTypeMeasure','onchange':'changeMeasureType(this)'});
							
							var optionDOM = new Element('option');
							optionDOM.setAttribute('value',0);
							optionDOM.appendText(LBL_MEAS_STANDARD);
							optionDOM.setAttribute('selected','selected');
							optionDOM.inject(selector);
							
							optionDOM = new Element('option');
							optionDOM.setAttribute('value',1);
							optionDOM.appendText(LBL_MEAS_CALCULATED);							
							optionDOM.inject(selector);
							
							selector.inject(div);
							div.inject(oTd3);
							
							//Opciones de agregador
							div = new Element('div', {styles: {width: tdWidths[3], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
							
							var selector = new Element('select',{name:'selAgregator'});
							if (attType == "S" || attType == "D"){
								optionDOM = new Element('option');
								optionDOM.setAttribute('value',2);
								optionDOM.appendText('COUNT');							
								optionDOM.inject(selector);
								
								optionDOM = new Element('option');
								optionDOM.setAttribute('value',5);
								optionDOM.appendText('DIST. COUNT');							
								optionDOM.inject(selector);
								
							}else{
								optionDOM = new Element('option');
								optionDOM.setAttribute('value',0);
								optionDOM.appendText('SUM');							
								optionDOM.inject(selector);
								
								optionDOM = new Element('option');
								optionDOM.setAttribute('value',1);
								optionDOM.appendText('AVG');							
								optionDOM.inject(selector);
								
								optionDOM = new Element('option');
								optionDOM.setAttribute('value',2);
								optionDOM.appendText('COUNT');							
								optionDOM.inject(selector);
								
								optionDOM = new Element('option');
								optionDOM.setAttribute('value',3);
								optionDOM.appendText('MIN');							
								optionDOM.inject(selector);
								
								optionDOM = new Element('option');
								optionDOM.setAttribute('value',4);
								optionDOM.appendText('MAX');							
								optionDOM.inject(selector);
								
								optionDOM = new Element('option');
								optionDOM.setAttribute('value',5);
								optionDOM.appendText('DIST. COUNT');							
								optionDOM.inject(selector);
							}
							selector.inject(div);
							
							div.inject(oTd4);
							//Formato
							div = new Element('div', {styles: {width: tdWidths[4], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
							
							input = new Element('input',{type:'text',name:'format'});
							input.setAttribute('value','#,###.0');
							input.inject(div);
							div.inject(oTd5);
							//Formula
							div = new Element('div', {styles: {width: tdWidths[5], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
							
							input = new Element('input',{type:'text',name:'formula',title:'[Measure1] [+,-,*,/] [Measure2 or Number] Ej: TotalCompras - TotalGastos','onchange':'chkFormula(this,null)',styles:{'display':'none'}});
							input.inject(div);
							div.inject(oTd6);
							
							var oTr = new Element("TR");
							
							oTd1.inject(oTr);
							oTd2.inject(oTr);//Se inserta este vacio para poner luego de seleccionado un atributo el tipo
							oTd3.inject(oTr);
							oTd4.inject(oTr);
							oTd5.inject(oTr);
							oTd6.inject(oTr);
							oTd7.inject(oTr);
							
							//Visible
							div = new Element('div', {styles: {width: tdWidths[6], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
							
							//--> Agregamos el checkbox visible
							input = new Element('input',{type:'checkbox',name:'visible',checked:true});							
							input.inject(div);
							div.inject(oTd7);
							
							oTr.addClass("selectableTR");
							oTr.getRowId = function () { return this.getAttribute("rowId"); };
							oTr.setRowId = function (a) { this.setAttribute("rowId",a); };
							oTr.setAttribute("rowId", $('gridMeasures').rows.length);
							
							oTr.addEvent("click",function(e){myToggle(this)}); 
							
							if($('gridMeasures').rows.length%2==0){
								oTr.addClass("trOdd");
							}
							
							oTr.inject($('gridMeasures'));		
							
							var rowIndx = oTr.rowIndex - 1;
							input.setAttribute('value',rowIndx);
							
							cubeChanged();//Marcamos como que el cubo se modifico estructuralmente
						}else{
							//Guardamos el attId que se selecciono en el string attIds
							if (strAttIds == ""){
								strAttIds = ret[1]; //Si el attId es skip, el attId viene en la posicion 1
							}else{
								strAttIds = strAttIds + "," + ret[1];
							}
						}
					}
				}
				$("txtHidAttMeasureIds").value = strAttIds;
			}
		}
	}
}	

function deleteRowsMea(selection,tblName) {
	var table = $(tblName);
	for (var i=0;i<selection.length;i++){
		selection[i].dispose();	
	}
	
	for (var i=0;i<table.rows.length;i++){
		table.rows[i].setRowId(i);
		if (i%2==0){
			table.rows[i].addClass("trOdd");
		}else{
			table.rows[i].removeClass("trOdd");
		}
	}
} 

function processLoadMeasure(){
	var ajaxCallXml = getLastFunctionAjaxCall();
	
	var table = ajaxCallXml.getElementsByTagName('table').item(0);
	var tableDOM = $('gridMeasures');
	var parent = tableDOM.getParent();
	tableDOM.selectOnlyOne = false; 
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
	
	if (table != null) {
		var rows = table.getElementsByTagName("row"); 
		for(var i = 0; i < rows.length; i++) {
			 var row = rows.item(i);
			 var rowDOM = new Element('tr');
			 var countTD = 0;
			 var cells = row.getElementsByTagName("cell");
			 var j = 0;
			 while (j < cells.length) { 
				 var cell = cells.item(j);				 
				 var type = cell.getAttribute("type");
				 j++;
				 
				 var td = new Element('td');
				 div = new Element('div', {styles: {width: tdWidths[countTD], overflow: 'hidden', 'white-space': 'pre','text-align':(type=="tdD"||type=="tdSN"?'left':'center')}});					 
				 var c = cell.getElementsByTagName("cell");
				
				 if (type=="td"){
					 //si length es 0 es un combo
					 if (c.length==0){
						 selector = getSelect(cell);
						 selector.inject(div);						
					 }else{
						 for (var k=0;k<c.length;k++){
							 var cc = c.item(k);
							 var ccType = cc.getAttribute("type");
							 var ccIsDisabled = toBoolean(cc.getAttribute("disabled"));
							 var ccIsHidden = toBoolean(cc.getAttribute("hidden"));
							 var ccIsChecked = toBoolean(cc.getAttribute("checked"));
							 var ccStyle = cc.getAttribute("style");
							 
							 var firstElement = cc.firstChild;
							 var name = firstElement.getAttribute("name");
							 var id = firstElement.getAttribute("id");
							 var value = firstElement.getAttribute("value");
							 var onChange = firstElement.getAttribute("onchange"); 
							 
							 var input = new Element('input',{'name':name,'id':id,type:(ccIsHidden?'hidden':ccType=='input'?'text':'checkbox'),'onchange':onChange,disabled:ccIsDisabled,checked:ccIsChecked});
							 input.setAttribute('value',value);
							 if (ccStyle){
								 input.setAttribute("style",ccStyle);
							 }
							 
							 input.inject(div);
							 
							 j++;
						 }
					 }
					 div.inject(td);
				 	 countTD++;
				 }
				 td.inject(rowDOM);					 
			 }
			 if(tableDOM.rows.length%2==0){
				rowDOM.addClass("trOdd");
			 }
			 rowDOM.addClass("selectableTR");
			 rowDOM.addEvent("click",function(e){myToggle(this)});	
			 rowDOM.getRowId = function () { return this.getAttribute("rowId"); };
			 rowDOM.setRowId = function (a) { this.setAttribute("rowId",a); };
			 rowDOM.setAttribute("rowId", tableDOM.rows.length);
			 rowDOM.inject(tableDOM);
			 rowDOM.inject(tableDOM);
		}		
	}	
}

function getSelect(cell){
	var elements = cell.getElementsByTagName("element");
	if (elements.length==1){
		var elem = elements.item(0);
	}else{
		var elem = elements.item(1);
	}
	var opts = elem.firstChild;
	var selectedValue = elem.getAttribute("value");
	var onChange = elem.getAttribute("onChange");
	var disabled  = toBoolean(elem.getAttribute("disabled"));
	var selector = new Element('select');
	selector.setAttribute('id',elem.getAttribute("id"));
	selector.setAttribute('name',elem.getAttribute("id"));
	if (disabled){
		selector.setAttribute('disabled',disabled);	
	}
	if (onChange){
		selector.setAttribute('onchange',onChange);
	}
	var options = opts.getElementsByTagName("option");
	for (var l = 0; l < options.length; l++) {
		var optionDOM = new Element('option');
		var option = options.item(l);
		
		var value = option.getAttribute("value");
		var text = (option.firstChild != null)?option.firstChild.nodeValue:""; 
		
		optionDOM.setAttribute('value',value);
		optionDOM.appendText(text);
		
		if (selectedValue!="" && selectedValue == value || selectedValue=="" && l==0){
			optionDOM.setAttribute('selected','selected');
		}
		optionDOM.inject(selector);
	
	}
	
	return selector;
}

function processRemoveMW(){
	var result = new Array();
	var ajaxCallXml = getLastFunctionAjaxCall();
	var res = ajaxCallXml.getElementsByTagName("html").item(0).firstChild.nodeValue;
	if (res=="OK"){
		var selected = new Array(getSelectedRows($('gridMeasures'))[0]);
		var attId = getSelectedRows($('gridMeasures'))[0].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value;		
		$("txtHidAttMeasureIds").value = remFromString($("txtHidAttMeasureIds").value, attId,false);		
		deleteRowsMea(selected,'gridMeasures');
		for (var i=0;i<selBasicDatMea.length;i++){
			if (attId == selBasicDatMea[i]){
				selBasicDatMea.splice(i,1);
				break;
			}
		}
		for (var i=0;i<selAttsMea.length;i++){
			if (attId == selAttsMea[i]){
				selAttsMea.splice(i,1);
				break;
			}
		}
	}	
}

function btnDupMeasure_click() {
	var tableDOM = $('gridMeasures');
	var parent = tableDOM.getParent();
	tableDOM.selectOnlyOne = false; 
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
	
	var trows = getSelectedRows($('gridMeasures'))[0];
	var cmbMeasType = trows.getElementsByTagName("TD")[2].getElementsByTagName("SELECT")[0];
	var measType = cmbMeasType.options[cmbMeasType.selectedIndex].value;
	var attId = "";
	var attName = "";
	var attLbl = "";
	var attType = "";
	var attMapEntId = "";
	if (measType == "0"){ //Si es una medida estandard
		attId = trows.getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value;
		attName = trows.getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[2].value;
		attLbl = trows.getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[2].value;
		attType = trows.getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[3].value;
		attMapEntId = trows.getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[4].value;
	}
	var measureName = trows.getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value;
	var cmbMeasFunc = trows.getElementsByTagName("TD")[3].getElementsByTagName("SELECT")[0];
	var measFunc = cmbMeasFunc.options[cmbMeasFunc.selectedIndex].value;
	var measFormat = trows.getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].value;
	var measFormul = trows.getElementsByTagName("TD")[5].getElementsByTagName("INPUT")[0].value;
	var measVis = trows.getElementsByTagName("TD")[6].getElementsByTagName("INPUT")[0].checked;
	
	var oTd1 = new Element("TD"); //atributo
	var oTd2 = new Element("TD"); //nombre de la medida
	var oTd3 = new Element("TD"); //tipos de medida
	var oTd4 = new Element("TD"); //agregadores
	var oTd5 = new Element("TD"); //formato
	var oTd6 = new Element("TD"); //formula
	var oTd7 = new Element("TD"); //visible
	
	div = new Element('div', {styles: {width: tdWidths[0], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	
	//Atributo							
	input = new Element('input',{type:'text',name:'attMeaName',id:'attMeaName',title:(measType == "0"?attName:"")});
	input.setAttribute('value',(measType == "0"?attName:""));
	input.inject(div);
	
	input = new Element('input',{type:'hidden',name:'hidAttMeasId'});
	input.setAttribute('value',(measType == "0"?attId:""));
	input.inject(div);
	
	input = new Element('input',{type:'hidden',name:'hidAttMeasName'});
	input.setAttribute('value',(measType == "0"?attName:""));
	input.inject(div);
	
	input = new Element('input',{type:'hidden',name:'hidAttMeasType'});
	input.setAttribute('value',(measType == "0"?attType:""));
	input.inject(div);
	
	input = new Element('input',{type:'hidden',name:'hidMeasEntDwColId'});
	input.setAttribute('value',0);
	input.inject(div);
	
	div.inject(oTd1);	
	
			
	//Nombre a mostrar
	var measureName = "MEASURE" + ($("gridMeasures").rows.length + 1);
	
	div = new Element('div', {styles: {width: tdWidths[1], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	
	input = new Element('input',{type:'text',name:'dispName','onchange':'chkMeasName(this)'});
	input.setAttribute('value',measureName);
	input.inject(div);
	
	div.inject(oTd2);	
		
	var oSelectMed = "";
	//Tipo de medida
	div = new Element('div', {styles: {width: tdWidths[2], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	
	var selector = new Element('select',{name:'selTypeMeasure','onchange':'changeMeasureType(this)'});
	
	var optionDOM = new Element('option');
	if (measType == "0"){
		optionDOM.setAttribute('value',0);
		optionDOM.appendText(LBL_MEAS_STANDARD);
		optionDOM.setAttribute('selected','selected');
		optionDOM.inject(selector);
	}
	optionDOM = new Element('option');
	optionDOM.setAttribute('value',1);
	optionDOM.appendText(LBL_MEAS_CALCULATED);							
	optionDOM.inject(selector);
	
	selector.inject(div);
	div.inject(oTd3);
	
	//Opciones de agregador
	var oSelect = "";
	div = new Element('div', {styles: {width: tdWidths[3], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	
	if (measType == "0"){
		var selector = new Element('select',{name:'selAgregator'});		
		
		optionDOM = new Element('option');
		optionDOM.setAttribute('value',0);
		optionDOM.appendText('SUM');							
		optionDOM.inject(selector);
		
		optionDOM = new Element('option');
		optionDOM.setAttribute('value',1);
		optionDOM.appendText('AVG');							
		optionDOM.inject(selector);
		
		optionDOM = new Element('option');
		optionDOM.setAttribute('value',2);
		optionDOM.appendText('COUNT');							
		optionDOM.inject(selector);
		
		optionDOM = new Element('option');
		optionDOM.setAttribute('value',3);
		optionDOM.appendText('MIN');							
		optionDOM.inject(selector);
		
		optionDOM = new Element('option');
		optionDOM.setAttribute('value',4);
		optionDOM.appendText('MAX');							
		optionDOM.inject(selector);
		
		optionDOM = new Element('option');
		optionDOM.setAttribute('value',5);
		optionDOM.appendText('DIST. COUNT');							
		optionDOM.inject(selector);
		
		selector.inject(div);
	}
	div.inject(oTd4);
	
	//Formato
	div = new Element('div', {styles: {width: tdWidths[4], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	
	input = new Element('input',{type:'text',name:'format'});
	input.setAttribute('value',measFormat);
	if (measType != "0"){
		input.setAttribute('style','display:none');
	}
	input.inject(div);
	div.inject(oTd5);
	
	//Formula
	div = new Element('div', {styles: {width: tdWidths[5], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	
	input = new Element('input',{type:'text',name:'formula',title:'[Measure1] [+,-,*,/] [Measure2 or Number] Ej: TotalCompras - TotalGastos','onchange':'chkFormula(this,null)',styles:{'display':'none'}});
	if (measType == "0"){
		input.setAttribute('style','display:none');
	}
	input.inject(div);
	div.inject(oTd6);	
	
	var oTr = new Element("TR");
	
	oTd1.inject(oTr);
	oTd2.inject(oTr);//Se inserta este vacio para poner luego de seleccionado un atributo el tipo
	oTd3.inject(oTr);
	oTd4.inject(oTr);
	oTd5.inject(oTr);
	oTd6.inject(oTr);
	oTd7.inject(oTr);
	
	//Visible
	div = new Element('div', {styles: {width: tdWidths[6], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	
	var rowIndx = oTr.rowIndex - 1;
	
	//--> Agregamos el checkbox visible
	input = new Element('input',{type:'checkbox',name:'visible',checked:measVis?true:false});	
	input.setAttribute('value',rowIndx);
	input.inject(div);
	div.inject(oTd7);
	
	oTr.addClass("selectableTR");
	oTr.getRowId = function () { return this.getAttribute("rowId"); };
	oTr.setRowId = function (a) { this.setAttribute("rowId",a); };
	oTr.setAttribute("rowId", $('gridMeasures').rows.length);
	
	oTr.addEvent("click",function(e){myToggle(this)}); 
	
	if($('gridMeasures').rows.length%2==0){
		oTr.addClass("trOdd");
	}
	
	oTr.inject($('gridMeasures'));		
	
	cubeChanged();//Marcamos como que el cubo se modifico estructuralmente
	
}

//Funcion llamada cuando se cambia el tipo de una medida
function changeMeasureType(obj){
	var val = obj.value;
	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	if (val == 0){ //Measure
		var cells=father.cells;
		cells[5].getElementsByTagName("INPUT")[0].style.display='none'; //ocultamos formula
		cells[0].getElementsByTagName("INPUT")[0].style.visibility='visible'; //mostramos column
		cells[3].getElementsByTagName("SELECT")[0].style.display='block'; //mostramos aggregator
		cells[4].getElementsByTagName("INPUT")[0].style.display='block'; //mostramos formato
		
	}else { //Calculated Member
		var cells=father.cells;
		cells[5].getElementsByTagName("INPUT")[0].style.display='block'; //mostramos formula
		cells[0].getElementsByTagName("INPUT")[0].style.visibility='hidden'; //mostramos column
		cells[3].getElementsByTagName("SELECT")[0].style.display='none'; //ocultamos aggregator
		cells[4].getElementsByTagName("INPUT")[0].style.display='none'; //ocultamos formato
	}
}