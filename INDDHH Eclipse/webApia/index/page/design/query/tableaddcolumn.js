function addColumn(bodyShow,prefix,extra,width){

	var tblHeadObj =bodyShow.tHead;
	var h = tblHeadObj.rows[0].cells.length;
	var newTH = new Element('th',{styles:{'width':width}});
	var check = new Element('input',{type:'checkbox','id':('chk'+prefix+h),'colid':h}).inject(new Element('div.divHeader', {html:'&nbsp;'}).inject(newTH));
	newTH.inject(tblHeadObj.rows[0]);

	if(!QRY_FREE_SQL_MODE)
		check.addEvent('change', checkUseFilterVisibility);
	
	var tblBodyObj = bodyShow.tBodies[0];
	for (var i=0; i<tblBodyObj.rows.length; i++) {
		var newCell = tblBodyObj.rows[i].insertCell(-1);
		var div = new Element('div',{styles:{'width':width}});
		if (extra!=null){		
			var aux = extra[i];
				if (aux!=null){
					var domElement = null;
					for (var k=0;k<aux.arr.length;k++){
						var auxRow = aux.arr[k];
						if (auxRow.type=="text"){
							domElement = new Element('input',{type:'text',name:auxRow.name,id:auxRow.id});
							//domElement.setAttribute("value",auxRow.value);
							domElement.set("value",auxRow.value);
						}else if (auxRow.type=="checkbox"){
							domElement = new Element('input',{type:'checkbox',name:auxRow.name,id:auxRow.id,checked:auxRow.checked,value:auxRow.value});							
						}else if (auxRow.type=="hidden"){
							domElement = new Element('input',{type:'hidden',name:auxRow.name,id:auxRow.id});
							//domElement.setAttribute("value",auxRow.value);
							domElement.set("value", auxRow.value);
						}else if (auxRow.type=="span"){
							domElement = new Element('span',{html:auxRow.html});
						}else if (auxRow.type=="combo"){
							domElement = new Element('select',{id:auxRow.id,name:auxRow.name});
							for (var l=0;l<auxRow.options.length;l++){
								var auxOption = auxRow.options[l];
								var optionDOM = new Element('option');
								//optionDOM.setProperty('value',auxOption.value);
								optionDOM.set('value',auxOption.value);
								optionDOM.appendText(auxOption.text);
								if (auxOption.selected){
									//optionDOM.setProperty('selected',"selected");
									optionDOM.set('selected',"selected");
								}
								optionDOM.inject(domElement);
							}
						}else if (auxRow.type=="comboentity" || auxRow.type=="comboentities") {
							domElement = new Element('select',{id:auxRow.id,name:auxRow.name});							
							for (var l=0;l<OPTIONS_BUS_ENTITY_COMBO_ARR.length;l++){
								var auxOption = OPTIONS_BUS_ENTITY_COMBO_ARR[l];
								var optionDOM = new Element('option');
								//optionDOM.setProperty('value',auxOption.value);
								optionDOM.set('value',auxOption.value);
								optionDOM.appendText(auxOption.text);
								if (auxOption.selected){
									//optionDOM.setProperty('selected',"selected");
									optionDOM.set('selected',"selected");
								}
								optionDOM.inject(domElement);
							}
						}
						
						if (domElement.type=="select-one"){
							domElement.setStyle("width","96%");
						} else {
							domElement.setStyle("width","90%");
						}		
						
						if (auxRow.visibility != null){
							domElement.setStyle("visibility",auxRow.visibility);
						}
						
						if(!QRY_FREE_SQL_MODE) {
							if(auxRow.name == "txtShoHeadName") {
								domElement.addEvent('change', function() {
									filterChanger(this, 'input', 'txtUserHeadName');
								});
							} else if(auxRow.name == "txtShoTool") {
								domElement.addEvent('change', function() {
									filterChanger(this, 'input', 'txtUserTool');
								});
							} else if(auxRow.name == "cmbBusEntIdShow") {
								domElement.addEvent('change', function() {
									filterChanger(this, 'select', 'cmbBusEntIdFilter');
								});
							}
						}
						
						domElement.inject(div);
						severalProperties(domElement,auxRow);
					}
				}
		}
		if (aux!=null && aux.display != null){
			newCell.style.display=aux.display;
		}
		div.inject(newCell);		
	}
	
	var hideTDs = bodyShow.getElementsByClassName('hideTD');
	if(hideTDs && hideTDs.length) {
		for(var i = 0; i < hideTDs.length; i++) {
			hideTDs[i].setStyle('display', 'none');
		}
	}
}

function deleteColumn(tblObj,colN){
	var allRows = tblObj.rows;
	if (colN!=""){
		var chk = $(colN);
		//var col = Number(chk.getAttribute("colid"));
		var col = Number(chk.get("colid"));
		for (var i=0; i<allRows.length; i++) {
			if (allRows[i].cells.length > 1) {
				removeValidations(allRows[i].cells[col]);
				allRows[i].deleteCell(col);
				updateColId(tblObj);
			}
		}
	}
	allRows = tblObj.rows;
	if(allRows[0].cells.length == 1) {
		//Se borro el ultimo
		var hideTDs = tblObj.getElementsByClassName('hideTD');
		if(hideTDs && hideTDs.length) {
			for(var i = 0; i < hideTDs.length; i++) {
				if(!hideTDs[i].get('keepHidden'))
					hideTDs[i].setStyle('display', '');
			}
		}
	}
	//if (tblObj != null){ addScrollTable(tblObj.tBodies[0]); }
}

function removeValidations(cell){
	var inputs = cell.getElementsByTagName("input");
	for (var i=0;i<inputs.length;i++){
		if (inputs[i].type=="text"){
			disposeValidation(inputs[i]);
		}
	}
}

function updateColId(tblObj){
	var allRows = tblObj.tHead.rows;
	var cells = allRows[0].cells;
	for (var i = 1; i < cells.length; i++) {
		var chk = cells[i].getElementsByTagName("input");
		//chk.item(0).setAttribute("colid", i);
		chk.item(0).set("colid", i);
	}
}

function swapColumn(table, colIndex1, colIndex2) {
	if (colIndex1 < colIndex2){
        var t = colIndex1;
        colIndex1 = colIndex2;
        colIndex2 = t;
    }

	if (table && table.rows && table.insertBefore && colIndex1 != colIndex2) {
		for (var i = 0; i < table.rows.length; i++) {
			var row = table.rows[i];
			var cell1 = row.cells[colIndex1];
			var cell2 = row.cells[colIndex2];
			var siblingCell1 = row.cells[Number(colIndex1) + 1];
			row.insertBefore(cell1, cell2);
			if(siblingCell1)
				row.insertBefore(cell2, siblingCell1);
			else
				row.appendChild(cell2);
		}
		updateColId(table);
	}
}

function filterChanger(element, filterType, filterName) {
	var parentTD = element.getParent('td');
	var new_val = element.get('value');
	//Averiguar mi indice en la fila 
	var row = parentTD.getParent('tr').childNodes;
	var l;
	for(l = 0; l < row.length; l++) {
		if(row[l] == parentTD)
			break;
	}
	//Obtener el col_name
	var col_name = $('tblShows').rows[0].childNodes[l].getElement('span').get('html');
	var tableBodyUserRows = $('tableBodyUser').rows;
	if(tableBodyUserRows) {
		for(l = 0; l < tableBodyUserRows.length; l++) {
			if(tableBodyUserRows[l].cells[0].getElement('span').get('html') == col_name) {
				showConfirm("Se detectó un filtro de usuario que se corresponde con la columna modificada. ¿Desea reflejar el cambio en el filtro correspondiente?", "Filtro encontrado", function(res) {
					if(res)
						changeFilterColumn(tableBodyUserRows[l], filterType, filterName, new_val);
				});
				return;
			}
		}
	}
}

function changeFilterColumn(row, filterType, filterName, new_val) {
	for(var m = 1; m < row.cells.length; m++) {
		var inps = row.cells[m].getElements(filterType);
		for( var n = 0; n < inps.length; n++) {
			if(inps[n].get('name') == filterName) {
				inps[n].set('value', new_val);
				return;
			}
		}
	}
}

function checkUseFilterVisibility(e) {
	if($('tableBodyUser')) {
		var checks = $('bodyShow').getElements('th').getElements('input');
		
		if(checks) {
			checks = checks.flatten();
			var i;
			for(i = 0; i < checks.length; i++) {
				if(checks[i].get('checked')) {
					$('contentUseAsFilter').setStyle('display', '');
					break;
				}
			}
			if(i == checks.length)
				$('contentUseAsFilter').setStyle('display', 'none');
		}
	}
}