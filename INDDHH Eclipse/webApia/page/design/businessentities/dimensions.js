function initDimensions(hasCube,ok){
	var btnAddDim = $('btnAddDim');
	if (btnAddDim){
		btnAddDim.addEvent("click",function(e){
			e.stop();
			var request = new Request({
				method: 'post',			
				url: CONTEXT + URL_REQUEST_AJAX+'?action=addAttDimension&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { sp.show(true); },
				onComplete: function(resText, resXml) { processXMLmodalAddAttDimension(resXml); sp.hide(true); addScrollTable($('gridDims'));}
			}).send();
		});
	}
	
	var btnDeleteDim = $('btnDeleteDim');
	if (btnDeleteDim){
		btnDeleteDim.addEvent("click",function(e){
			e.stop();
			var count = selectionCount($('gridDims'));
			if(count==0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (count>1){
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			}else{
				var attId = getSelectedRows($('gridDims'))[0].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value;
				var request = new Request({
					method: 'post',	
					data:{id:attId,'forDimension':true},
					url: CONTEXT + URL_REQUEST_AJAX+'?action=removeEntDwCol&isAjax=true' + TAB_ID_REQUEST,
					onRequest: function() { sp.show(true); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml);sp.hide(true); addScrollTable($('gridDims'));}
				}).send();
			} 
		});
	}
	
	var btnPropDim = $('btnPropDim');
	if (btnPropDim){
		btnPropDim.addEvent("click",function(e){
			e.stop();
			var count = selectionCount($('gridDims'));
			if(count==0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (count>1){
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			}else{
				
				var allMembName = getSelectedRows($('gridDims'))[0].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[5].value;
				var request = new Request({
					method: 'post',			
					data:{'txtAllMembName':allMembName},
					url: CONTEXT + URL_REQUEST_AJAX+'?action=dimProperties&isAjax=true' + TAB_ID_REQUEST,
					onRequest: function() { sp.show(true); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
				}).send();
			}
		});
	}
	
	if (ok=="ok"){
		initEntMdlPage();
		if (hasCube){
			loadDimensions();
		} else {			
			var table = $('gridBodyDimensions');
			var footer = $('gridDimensions').getElements('.listAddDelRight')[0];
			var notification = new Element('div', {id : 'editionNot'}); 
			footer.grab(notification, "top");
			initAdminModalHandlerOnChangeHighlight(table, true, false, notification);
		}
	}
	
	var gbd = $('gridBodyDimensions');
	if(gbd)
		gbd.addEvent('custom_scroll', function(left) {
			$('gridDimensions').getElement('div.gridHeader').getElement('table').setStyle('left', left);
		});
	
	/*addScrollTable($('gridDims'));*/
}


function isValidDimensionName(s){
	var x = reBIAlphanumeric.test(s);
	
	if(!x){
		showMessage(GNR_INVALID_NAME);
		return false;
	}
	return true;
}

function chkDimName(obj){
	var name = obj.value;
	var cant = 0;
	if (isValidDimensionName(name)){
		if (selectionCount($('gridDims')) >= 0){
			trows=$("gridDims").rows;
			for (i=0;i<trows.length;i++) {
				if (trows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value == name) {
					if (cant==1){
						showMessage(MSG_ALR_EXI_DIM, GNR_TIT_WARNING, 'modalWarning');
						trows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value = '';
						trows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].focus();
						return false;
					}else{
						cant++;
					}
				}
			}
			cubeChanged(); //Se deben regenerar las vistas
		}
	}else{
		obj.value = '';
		obj.focus();
		return false;
	}
}

function loadDimensions(){
	loadAtts(true);
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX+'?action=loadDimensions&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { 
			modalProcessXml(resXml); sp.hide(true);
			
			var table = $('gridBodyDimensions');
			var footer = $('gridDimensions').getElements('.listAddDelRight')[0];
			var notification = new Element('div', {id : 'editionNot'}); 
			footer.grab(notification, "top");
			initAdminModalHandlerOnChangeHighlight(table, true, false, notification);
		}
	}).send();
}

function processRemoveDW(){
	var result = new Array();
	var ajaxCallXml = getLastFunctionAjaxCall();
	var res = ajaxCallXml.getElementsByTagName("html").item(0).firstChild.nodeValue;
	if (res=="OK"){
		var selected = new Array(getSelectedRows($('gridDims'))[0]);
		var attId = getSelectedRows($('gridDims'))[0].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value;		
		$("txtHidAttIds").value = remFromString($("txtHidAttIds").value, attId,true);		
		deleteRowsDim(selected,'gridDims');
		
		for (var i=0;i<selBasicDatDim.length;i++){
			if (attId == selBasicDatDim[i]){
				selBasicDatDim.splice(i,1);
				break;
			}
		}
		for (var i=0;i<selAttsDim.length;i++){
			if (attId == selAttsDim[i]){
				selAttsDim.splice(i,1);
				break;
			}
		}
	}
	
}

var editDim = null;
function openEntModal(obj){
	ENTITIESMODAL_SHOWGLOBAL = true;		
	ENTITIESMODAL_SELECTONLYONE = true;
	editDim = obj;
	showEntitiesModal(processEntitiesModalReturn);	
}

function btnRemMapEnt_click(obj){
	var r = obj.parentNode;
	while (r.tagName !="TR"){
		r = r.parentNode;
	}
	var cells = r.cells; 
	
	cells[2].getElementsByTagName("INPUT")[1].value = "";
	cells[2].getElementsByTagName("INPUT")[2].value = "";
	
	cubeChanged();
}

function processEntitiesModalReturn(rets){
	 rets.each(function(e){
		
		var r = editDim.parentNode;
		while (r.tagName !="TR"){
				r = r.parentNode;
		}
		
		var cells = r.cells; 
		var text = e.getRowContent()[0];
		
		cells[0].getElementsByTagName("INPUT")[3].value="S";
		cells[1].getElementsByTagName("SPAN")[0].innerHTML = "STRING";
		cells[2].getElementsByTagName("INPUT")[1].value = e.getRowId();
		cells[2].getElementsByTagName("INPUT")[2].value = text;
		
		cubeChanged(); //Marcamos como que el cubo se modifico estructuralmente 		
	});
}

function setDimProperties(){
	var aux = $('txtAllMembName');
	var f=aux.parentNode;
	while(f.tagName!="FORM"){
		 f=f.parentNode;
	}
	
	
	f.formChecker = new FormCheck(
			f.id,
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
	
	if(!f.formChecker.isFormValid()){
		return;
	}
	
	
	getSelectedRows($('gridDims'))[0].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[5].value = aux.value;
	SYS_PANELS.closeAll();
	
}

function deleteRowsDim(selection,tblName) {
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

function processLoadDimension(){
	var ajaxCallXml = getLastFunctionAjaxCall();
	
	var table = ajaxCallXml.getElementsByTagName('table').item(0);
	var tableDOM = $('gridDims');
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
				
				 if (type=="tdD"){
					 td.setAttribute("style","border-right:none");
					 for (var k=0;k<c.length;k++){
						 var cc = c.item(k);
						 var ccType = cc.getAttribute("type");
						 var firstChild = cc.firstChild;
						 var ccId = firstChild.getAttribute("id");
						 var ccName = firstChild.getAttribute("name");
						 var ccValue = firstChild.getAttribute("value");
						 var onClick = firstChild.getAttribute("onclick");
						 var label = firstChild.getAttribute("label");
						 var isChecked = toBoolean(cc.getAttribute("checked"));
						
						 var input = new Element('input',{name:ccName,id:ccId,type:(ccType=="input"?'text':'checkbox')});
						 input.setAttribute('value',ccValue);
						 if (onClick!=null){
						     input.setAttribute("onclick",onClick);
						 }
						 if (ccType=="checkbox"){
							 label = new Element('label',{'for':ccId,'class':'label',html:label});
							 if (isChecked){
								 input.setAttribute("checked",isChecked);
							 }
							 input.inject(label);
							 label.inject(div);			
						 }else{
							 input.inject(div);	 
						 }
						 if (k+1<c.length){
							 span = new Element('span',{html:' | '});
						     span.inject(div);
						 }
						 j++;
					 }
					 div.inject(td);
				 	 countTD++;
				 }else if (type=="tdSN"){	
					 td.setAttribute("style","border-right:none");
					 for (var k=0;k<c.length;k++){
						 var cc = c.item(k);
						 var ccType = cc.getAttribute("type");
						 var firstChild = cc.firstChild;
						 var ccName = firstChild.getAttribute("name");
						 var ccValue = firstChild.getAttribute("value");
						 var ccIsHidden = toBoolean(cc.getAttribute("hidden"));
						 var ccIsDisabled = toBoolean(cc.getAttribute("disabled"));
						 var onClick = firstChild.getAttribute("onclick");
						 
						 if (ccType=="input"){
							 var input = new Element('input',{name:ccName,type:ccIsHidden?'hidden':'text',disabled:ccIsDisabled});
							 input.setAttribute('value',ccValue);
							 if (onClick!=null){
							 	input.setAttribute("onclick",onClick);
						 	 }
							 input.inject(div);
							 new Element('span',{html:'&nbsp;'}).inject(div);
						 }else if (ccType == "img"){
							 var src = firstChild.getAttribute("src");
							 if (src=="modifier"){								 
								 var img = new Element('img',{title:LBL_SEL_MAP_ENTITY,width:'15',height:'15','onclick':'openEntModal(this)',styles:{cursor:'pointer','vertical-align':'text-bottom'},src:IMG_MODIFY});								 
							 }else{
								 var img = new Element('img',{title:LBL_DEL_MAP_ENTITY,width:'15',height:'15','onclick':'btnRemMapEnt_click(this)',styles:{cursor:'pointer','vertical-align':'text-bottom'},src:IMG_ERASER}); 
							 }
							 img.inject(div);
						 }else if (ccType=="span"){
							 new Element('span',{html:'&nbsp;'}).inject(div);
						 }
						
						 j++;
					 }
				 	 div.inject(td);
				 	 countTD++;
				 }else if (type=="tdS"){
					 for (var k=0;k<c.length;k++){
						 var cc = c.item(k);
						 var ccValue = cc.getAttribute("value");
					 	 span = new Element('span',{html:ccValue});
						 span.inject(div);
						 
						 j++;
					 }
					 div.inject(td);
				 	 countTD++;
			 	 }else{					
					 for (var k=0;k<c.length;k++){
						 var cc = c.item(k);
						 var ccIsHidden = toBoolean(cc.getAttribute("hidden"));
						 var ccIsDisabled = toBoolean(cc.getAttribute("disabled"));
						 var ccType = cc.getAttribute("type");
						 var firstChild = cc.firstChild;
						 
						 var ccId = firstChild.getAttribute("id");
						 var ccName = firstChild.getAttribute("name");
						 var ccValue = firstChild.getAttribute("value");
							 
						
						 var input = new Element('input',{name:ccName,id:ccId,disabled:ccIsDisabled,type:ccIsHidden?'hidden':'text'});
						 input.setAttribute('value',ccValue);
						 input.inject(div);						 	 
							
						 j++;
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
		}		
	}	
}

function drawDimension(){
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
	processResultDimensions(result);	
	SYS_PANELS.closeAll();
}

function processResultDimensions(rets){
	var parent = $('gridDims').getParent();
	$('gridDims').selectOnlyOne = false; 
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
						var addDim = true;
						
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
						
						//2- Nos fijamos si ya no se habia agregado la dimension
						var trows=$("gridDims").rows;
						for (i=0;i<trows.length && addDim;i++) {
							if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == attId) {
								addDim = false;
							}
						}
						
						var row = trows.length;
						
						//3- Si no se habia agregado, agregamos el atributo seleccionado como dimension
						if (addDim) {
						
							var oTd1 = new Element("TD"); //atributo
							var oTd2 = new Element("TD"); //tipo							
							var oTd3 = new Element("TD",{styles:{'border-right':'none'}}); //Entidad Mapeo o levels de dimension tipo fecha
							
							var dimName = "DIMENSION" + ($("gridDims").rows.length + 1);						
							var input;
							var span;
							var img;
							//Atributo
							div = new Element('div', {styles: {width: tdWidths[0], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
							
							input = new Element('input',{type:'text',name:'attDimName',id:'attDimName',disabled:true,title:attName});
							input.setAttribute('value',attName);
							input.inject(div);

							input = new Element('input',{type:'hidden',name:'hidAttId'});
							input.setAttribute('value',attId);
							input.inject(div);
							
							input = new Element('input',{type:'hidden',name:'hidAttName'});
							input.setAttribute('value',attName);
							input.inject(div);
							
							input = new Element('input',{type:'hidden',name:'hidAttType'});
							input.setAttribute('value',attType);
							input.inject(div);
							
							input = new Element('input',{type:'hidden',name:'hidDimEntDwColId'});
							input.setAttribute('value',0);
							input.inject(div);
							
							input = new Element('input',{type:'hidden',name:'hidAllMembName'});
							input.setAttribute('value','Total');
							input.inject(div);
							
							div.inject(oTd1);
							
							div = new Element('div', {styles: {width: tdWidths[2], overflow: 'hidden', 'white-space': 'pre','text-align':'left'}});
							input = new Element('input',{type:'text',name:'txtDimName','onchange':'chkDimName(this)'});
							input.setAttribute('value',dimName);
							input.inject(div);
							
							//Nombre de la dimension
							if (attType=='S'||attType=='N'){
								input = new Element('input',{type:'hidden',name:'txtMapEntityId',id:'txtMapEntityId'});
								input.setAttribute('value',attMapEntId);
								input.inject(div);
								new Element('span',{html:'&nbsp;'}).inject(div);
								if (attId > 0){
									input = new Element('input',{type:'text',name:'txtMapEntityName',id:'txtMapEntityName',disabled:true,title:MAP_ENTITY+": "+attMapEntName});
									input.setAttribute('value',attMapEntName);
									input.inject(div);
									new Element('span',{html:'&nbsp;'}).inject(div);
									span = new Element('span',{styles:{'vertical-align':'bottom'}});
									
									img = new Element('img',{title:LBL_SEL_MAP_ENTITY,width:'15',height:'15','onclick':'openEntModal(this)',styles:{cursor:'pointer','vertical-align':'text-bottom'},src:IMG_MODIFY});
									img.inject(span);
									
									new Element('span',{html:'&nbsp;'}).inject(span);
									
									img = new Element('img',{title:LBL_DEL_MAP_ENTITY,width:'15',height:'15','onclick':'btnRemMapEnt_click(this)',styles:{cursor:'pointer','vertical-align':'text-bottom'},src:IMG_ERASER});
									img.inject(span);
									
									input = new Element('input',{type:'hidden',name:'hidAttTypeOriginal',id:'hidAttTypeOriginal'});
									input.setAttribute('value','STRING');
									input.inject(span);
									
									span.inject(div);
								}
							}else if (attType == 'D'){
								
								span = new Element('span',{html:' | '});
								span.inject(div);
								input = new Element('input',{type:'checkbox',name:'chkYear',id:'chkYear'+j,checked:true,'onclick':'cubeChanged()'});
								input.setAttribute('value',row);
								label = new Element('label',{'for':'chkYear'+j,'class':'label',html:LBL_YEAR});
								input.inject(label);
								label.inject(div);								
								
								span = new Element('span',{html:' | '});
								span.inject(div);
								input = new Element('input',{type:'checkbox',name:'chkSem',id:'chkSem'+j,checked:true,'onclick':'cubeChanged()'});
								input.setAttribute('value',row);
								label = new Element('label',{'for':'chkSem'+j,'class':'label',html:LBL_SEMESTER});
								input.inject(label);
								label.inject(div);								
								
								span = new Element('span',{html:' | '});
								span.inject(div);
								input = new Element('input',{type:'checkbox',name:'chkTrim',id:'chkTrim'+j,checked:false,'onclick':'cubeChanged()'});
								input.setAttribute('value',row);
								label = new Element('label',{'for':'chkTrim'+j,'class':'label',html:LBL_TRIMESTER});
								input.inject(label);
								label.inject(div);
								
								span = new Element('span',{html:' | '});
								span.inject(div);
								input = new Element('input',{type:'checkbox',name:'chkMonth',id:'chkMonth'+j,checked:true,'onclick':'cubeChanged()'});
								input.setAttribute('value',row);
								label = new Element('label',{'for':'chkMonth'+j,'class':'label',html:LBL_MONTH});
								input.inject(label);
								label.inject(div);								
								
								span = new Element('span',{html:' | '});
								span.inject(div);
								input = new Element('input',{type:'checkbox',name:'chkWeekDay',id:'chkWeekDay'+j,checked:false,'onclick':'cubeChanged()'});
								input.setAttribute('value',row);
								label = new Element('label',{'for':'chkWeekDay'+j,'class':'label',html:LBL_WEEKDAY});
								input.inject(label);
								label.inject(div);		
								
								span = new Element('span',{html:' | '});
								span.inject(div);
								input = new Element('input',{type:'checkbox',name:'chkDay',id:'chkDay'+j,checked:false,'onclick':'cubeChanged()'});
								input.setAttribute('value',row);
								label = new Element('label',{'for':'chkDay'+j,'class':'label',html:LBL_DAY});
								input.inject(label);
								label.inject(div);
								
								span = new Element('span',{html:' | '});
								span.inject(div);
								input = new Element('input',{type:'checkbox',name:'chkHour',id:'chkHour'+j,checked:false,'onclick':'cubeChanged()'});
								input.setAttribute('value',row);
								label = new Element('label',{'for':'chkHour'+j,'class':'label',html:LBL_HOUR});
								input.inject(label);
								label.inject(div);
								
								span = new Element('span',{html:' | '});
								span.inject(div);
								input = new Element('input',{type:'checkbox',name:'chkMin',id:'chkMin'+j,checked:false,'onclick':'cubeChanged()'});
								input.setAttribute('value',row);
								label = new Element('label',{'for':'chkMin'+j,'class':'label',html:LBL_MINUTE});
								input.inject(label);
								label.inject(div);
								
								span = new Element('span',{html:' | '});
								span.inject(div);
								input = new Element('input',{type:'checkbox',name:'chkSec',id:'chkSec'+j,checked:false,'onclick':'cubeChanged()'});
								input.setAttribute('value',row);
								label = new Element('label',{'for':'chkSec'+j,'class':'label',html:LBL_SECOND});
								input.inject(label);
								label.inject(div);
								
								input = new Element('input',{type:'hidden',name:'txtMapEntityId',id:'txtMapEntityId'});
								input.setAttribute('value',attMapEntId);
								input.inject(div);
								
								
							}
							div.inject(oTd3);
							
							//Tipo
							div = new Element('div', {styles: {width: tdWidths[1], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
							span = new Element('span',{html:(attType=='S'?'STRING':attType=='N'?'NUMERIC':'DATE')});
							span.inject(div);
							div.inject(oTd2);
							
							
							var oTr = new Element("TR");
								
							oTd1.inject(oTr);
							oTd2.inject(oTr);//Se inserta este vacio para poner luego de seleccionado un atributo el tipo
							oTd3.inject(oTr);
							
							oTr.addClass("selectableTR");
							oTr.getRowId = function () { return this.getAttribute("rowId"); };
							oTr.setRowId = function (a) { this.setAttribute("rowId",a); };
							oTr.setAttribute("rowId", $('gridDims').rows.length);
							
							oTr.addEvent("click",function(e){myToggle(this)}); 
							
							if($('gridDims').rows.length%2==0){
								oTr.addClass("trOdd");
							}
							
							oTr.inject($('gridDims'));						
							
							cubeChanged();//Marcamos como que el cubo se modifico estructuralmente
						}
						
					}else{
						//Guardamos el attId que se selecciono en el string attIds
						if (strAttIds == ""){
							strAttIds = ret[1]; //Si el attId es skip, el attId viene en la posicion 1
						}else{
							strAttIds = strAttIds + "," + ret[1];
						}
					}
				}				
			}else{//Debemos borrar todas las filas
				trows=$("gridDims").rows;
				var i = 0;
				while (i<trows.length) {
					deleteRow(i,"gridDims");
					//$("gridDims").deleteElement(trows[i]);
				}
			}
		}
		if (strAttIds!=""){
			//Verificamos si se des-selecciono algun atributo que antes era dimension
			trows=$("gridDims").rows;
			var i = 0;
			while (i<trows.length) {
				var attId = trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value;
				if (!inAttIds(strAttIds+"",attId)){ //se le agrega "" por si es un  valor solo, para transformarlo a string
					deleteRow(i,"gridDims")
					//$("gridDims").deleteElement(trows[i]);
				}else{
					i++;
				}
			}
		}else{//Debemos borrar todas las filas
			trows=$("gridDims").rows;
			var i = 0;
			while (i<trows.length) {
				deleteRow(i,"gridDims")
				//$("gridDims").deleteElement(trows[i]);
			}
		}
		$("txtHidAttIds").value = strAttIds;
	}
}

function setSelectedDimensions(){
	var str = "&forDimensions=true&forMeasures=null";
	if (selAttsDim.length > 0){
		for (i = 0; i < selAttsDim.length; i++) {
			if (selAttsDim[i]!=null){
				if (str==""){
					str = "&attId=" + selAttsDim[i];
				}else{
					str = str + "&attId=" + selAttsDim[i];
				}
			}
		}
	}
	if (selBasicDatDim.length >0){
		for (i = 0; i < selBasicDatDim.length; i++) {
			if (selBasicDatDim[i]!=null){
				if (str==""){
					str = "&attId=" + selBasicDatDim[i];
				}else{
					str = str + "&attId=" + selBasicDatDim[i];
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

function processXMLmodalAddAttDimension(ajaxCallXml){
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
				addAttLi(extra,ul,true);
			}
			
			element.addClass("addClass");
			div.inject(form);			
			if (title && title != "") element.header.innerHTML = title;
			element.footer.innerHTML = "<div onclick=\"setSelectedDimensions();\" class='button'>"+LBL_CON+"</div>";
			SYS_PANELS.addClose(element, true, null); 
			form.inject(element.content);	
		}
	}
}