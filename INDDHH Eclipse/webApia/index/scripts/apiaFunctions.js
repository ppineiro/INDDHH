function getRootPath() {
	//- Defined in messages.jsp
	return rootPath;
}

function getCurrentStep() {
	//- Defined in task.jsp
	return apiaCurrentStep;
}

function getFieldByIndex(formName, fieldName, index) {
	var id=(formName + "_" + fieldName).toUpperCase();
	var elementId = document.getElementById(id);
	if(index==0 && elementId){
		return elementId;
	}
	var el=null;
	
	if (elementId != null) {
		var inputs2 = document.getElementsByTagName(elementId.tagName);
		var inputs3 = new Array();
		if(elementId.id && elementId.getAttribute("name")){
			for (var ppp = 0; ppp < inputs2.length; ppp++) {
				var added=false;
				if(inputs2[ppp].id && inputs2[ppp].getAttribute("name") ){
					if ((inputs2[ppp].id == elementId.id
					|| ((inputs2[ppp].getAttribute("name") && elementId.getAttribute("name")) && (inputs2[ppp].getAttribute("name") == elementId.getAttribute("name")) && (inputs2[ppp].id.indexOf("_hidden")<0) && elementId.getAttribute("name")!="dummy_")
					//|| (inputs2[ppp].id==(elementId.id+"_hidden"))) 
					&& inputs2[ppp].tagName == elementId.tagName )) {
						if(inputs2[ppp].tagName!="INPUT" || ((inputs2[ppp].tagName=="INPUT" && elementId.type==inputs2[ppp].type))){
							added=true;
							inputs3.push(inputs2[ppp]);
						}
					}
				}
				if(!MSIE && inputs2[ppp].id == elementId.id && elementId.tagName=="TD" && (inputs2[ppp].className.indexOf("readOnly")>=0)){
					if(!added){
						inputs3.push(inputs2[ppp]);
					}
				}
			}
		}
		if(elementId.type != "radio") {
			if (inputs3 != null) {
				if (inputs3.length > index) {
					el = inputs3[index];
				} else if (inputs3.length == 0) {
					el = elementId;
				} else if (inputs3.length == 1) {
					el = inputs3[0];
				}
			}
		}else{
			if (inputs3 != null) {
				if (inputs3.length > index) {
					el = inputs3[index];
				} else if (inputs3.length == 0) {
					el = elementId;
				}
			}
		}
	}
	/*if(!el){
		try{
			var msg1=MSG_FIELD_NOT_FOUND.split("*")[0];
			var msg2=MSG_FIELD_NOT_FOUND.split("*")[1];
			var msg3=MSG_FIELD_NOT_FOUND.split("*")[2];
			alert(msg1+fieldName+msg2+formName+msg3);
		}catch(e){}
	}*/
	return el;
}

function getRadios(formName, fieldName, index) {
	var id=(formName + "_" + fieldName).toUpperCase();
	var elementId = document.getElementById(id);
	var el=null;
	var radios;
	if (elementId != null && elementId.type == "radio") {
		radios = new Array();
		var inputs2 = document.getElementsByTagName(elementId.tagName);
		for (var ppp = 0; ppp < inputs2.length; ppp++) {
			if(inputs2[ppp].id && elementId.id && inputs2[ppp].name && elementId.name){
				if ((inputs2[ppp].id == elementId.id || inputs2[ppp].name == elementId.name) && inputs2[ppp].tagName == elementId.tagName) {
					radios.push(inputs2[ppp]);
				}
			}
		}
	}
	
	return radios;
}

function getFieldColumn(formName, fieldName) {
	var elementId = document.getElementById(formName + "_" + fieldName);
	if (elementId != null) {
		var inputs2 = getForm(formName).getElementsByTagName(elementId.tagName);
		var inputs3 = new Array();
		for (var ppp = 0; ppp < inputs2.length; ppp++) {
			if ((inputs2[ppp].id == elementId.id
					|| ((inputs2[ppp].name && elementId.name) && (inputs2[ppp].name == elementId.name) && (inputs2[ppp].id.indexOf("_hidden")<0) && elementId.name!="dummy_")
					//|| (inputs2[ppp].id==(elementId.id+"_hidden"))) 
					&& inputs2[ppp].tagName == elementId.tagName )) {
				inputs3.push(inputs2[ppp]);
			}
		}
		if (inputs3 != null) {
				return inputs3;
		}
	}
	
	return null;
}

function getGrid(formName, fieldName){
	//return document.getElementsByName(formName + "_" + fieldName);
	var colTables = document.getElementsByTagName("TABLE");
	var gridName = formName + "_" + fieldName;
	for(i=0;i<colTables.length;i++){
		if (colTables[i].getAttribute("name") != null){
			if(colTables[i].getAttribute("name").toUpperCase() == gridName.toUpperCase()){
				var grid=colTables[i].parentNode;
				while(grid.getAttribute("type")!="grid"){
					grid=grid.parentNode
				}
				return grid;
			}
		}
	}
	return null;
}

function hideGrid(formName, fieldName){
	var grid=getGrid(formName, fieldName);
	if(grid){
		grid.parentNode.style.display="none";
	}
}

function showGrid(formName, fieldName){
	var grid = getGrid(formName, fieldName);
	if(grid){
		if(MSIE && !MSIE6) {
			setTimeout(function(){
				grid.style.position = "absolute";
				
				grid.parentNode.style.display="block";
				
				setTimeout(function(){
					grid.style.position = "relative";
				}, 10);
			}, 10);
		} else {
			grid.parentNode.style.display="block";
		}
	}
}

function getGridWithParent(formName, fieldName, parent){
	var colTables = document.getElementsByTagName("TABLE");
	var gridName = formName + "_" + fieldName;	
	for(i=0;i<colTables.length;i++){
		if (colTables[i].getAttribute("name") != null){
			if(colTables[i].getAttribute("frmParent").toUpperCase() == parent.toUpperCase()){
				if(colTables[i].getAttribute("name").toUpperCase() == gridName.toUpperCase()){
					return colTables[i];
				}
			}
		}
	}
	return null;
}

function getFieldWithParent(formName, fieldName, parent) {
	var id=(formName + "_" + fieldName).toUpperCase();
	var elementsId = document.getElementsByTagName("*");
	var elementId;
	for(i=0;i<elementsId.length;i++){
		if(elementsId[i].id == id){
			if(elementsId[i].getAttribute("frmParent").toUpperCase() == parent.toUpperCase()){
				elementId = elementsId[i];
			}
		}
	}
	if (elementId != null) {
		var inputs2 = document.getElementsByTagName(elementId.tagName);
		var inputs3 = new Array();
		for (var ppp = 0; ppp < inputs2.length; ppp++) {
			if ((inputs2[ppp].id == elementId.id || inputs2[ppp].name == elementId.name) && inputs2[ppp].tagName == elementId.tagName) {
				if(inputs2[ppp].frmParent!=null && inputs2[ppp].frmParent==elementId.frmParent){
					inputs3.push(inputs2[ppp]);
				}
			}
		}
		
		if (inputs3 != null) {
			if (inputs3.length > 0) {
				return inputs3[0];
			} else if (inputs3.length == 0) {
				return elementId;
			}
		}
	}
	
	return null;
}

function getField(formName, fieldName) {
	return getFieldByIndex(formName, fieldName, 0);
}

function getButton(formName, fieldName) {
	return getFieldByIndex("btn_" + formName, fieldName, 0);
}

function getButtonWithParent(formName, fieldName, parent) {
	return getFieldWithParent("btn_" + formName, fieldName, parent);
}

function hideForm(formName) {
	var form= document.getElementById("divTitFrm" + formName);
	form.style.display="none";
	var form2= document.getElementById("divFrm" + formName);
	form2.parentNode.style.display="none";
	var hidden = document.getElementById("hidFrm" + formName + "Hidden");
	hidden.value = "true";
	closeForm(formName);
}

function showForm(formName) {
	var form= document.getElementById("divTitFrm" + formName);
	form.style.display="block";
	var form2= document.getElementById("divFrm" + formName);
	form2.parentNode.style.display="block";
	var hidden = document.getElementById("hidFrm" + formName + "Hidden");
	hidden.value = "false";
	openForm(formName);
	
	var els = form2.getElementsByTagName("DIV");
	var initGrids = true;
	
	for (var i = 0; i < els.length; i++) {
		if (els[i].id.indexOf("gridListfrm_") == 0) {			
			
			if(initGrids) {
				initWinSizer();
				initGrids = false;
			}
			
			if (!MSIE && window.getComputedStyle) {
				//Fix mozilla grid header width
				var thead = els[i].getElementsByTagName("thead")[0];
				var tbody = els[i].getElementsByTagName("tbody")[0];
				
				var ths = thead.childNodes[1].childNodes;				
				if (tbody.childNodes[2] != undefined && tbody.childNodes[2] != null) {
					var tds = tbody.childNodes[2].childNodes;
					
					var th_iter = 0;;
					for (var j = 0; j < tds.length; j++) {
						if(tds[j].tagName == "TD") {
							var width = tds[j].offsetWidth - 1;
							
							var padLeft = document.defaultView.getComputedStyle(tds[j],null).getPropertyValue("padding-left"); 
							width -= parseInt(padLeft);
							
							var padRight = document.defaultView.getComputedStyle(tds[j],null).getPropertyValue("padding-right");
							width -= parseInt(padRight);
							
							if (width < 0) width = 0;
							
							ths[th_iter].style.width = width + "px"; 
							
							th_iter++;
						}
					}
				}
			}				
		}
	}
}

//--- This method is used to set read only a field
function setReadonly(formName, fieldName){
	var field = getField(formName, fieldName);
	if(MSIE6 && field.type == "hidden" && field.getAttribute("ie6TextArea")=="true") {
		setIE6AreaRO(field);
	}
	field.readOnly = true;
	if (field.type == "checkbox") field.disabled = true;
	setBrwsReadOnly(field);
	if(field.className.indexOf("txtReadOnly")<0) {
		field.className = field.className+" txtReadOnly";
	}
}
//--- This method removes the property read only from a field
function removeReadonly(formName, fieldName){
	var field = getField(formName, fieldName);
	if(MSIE6 && field.type == "hidden" && field.getAttribute("ie6TextArea")=="true") {
		unsetIE6AreaRO(field);
	}
	field.readOnly = false;
	if (field.type == "checkbox") field.disabled = false;
	unsetBrwsReadOnly(field);
	if(field.className.indexOf("txtReadOnly")>=0) {
		var className=field.className.split("txtReadOnly");
		field.className = className[0]+className[1];
	}
}

//--- This method returns the rowIndex of an eventSource of an event. Returns -1 is the rowIndex is not valid
function getEvtSourceRowIndex(source) {
	var tr=source.parentNode;
	while(tr.tagName!="TR" && tr.tagName!="BODY"){
		tr=tr.parentNode;
	}
	if (tr != null && tr.tagName=="TR") {
		return tr.rowIndex - 2;
	}
	return -1;
}

//--- This method is used to set read only a grid's fild
function setReadonlyByIndex(formName, fieldName, index){
	var field = getFieldByIndex(formName, fieldName,index);
	field.readOnly = true;
	if (field.type == "checkbox") field.disabled = true;
	setBrwsReadOnly(field);
	if(field.tagName.toUpperCase() == "INPUT" && field.type.toUpperCase() == "CHECKBOX") {
		field.disabled = true;
	}
	if(field.className.indexOf("txtReadOnly")<0) {
		field.className = field.className+" txtReadOnly";
	}
}

//--- This method is used to remove the property read only
function removeReadonlyByIndex(formName, fieldName, index){
	var field = getFieldByIndex(formName, fieldName,index);
	field.readOnly = false;
	if (field.type == "checkbox") field.disabled = false;
	unsetBrwsReadOnly(field);
	if(field.tagName.toUpperCase() == "INPUT" && field.type.toUpperCase() == "CHECKBOX") {
		field.disabled = false;
	}
	if(field.className.indexOf("txtReadOnly")>=0) {
		var className=field.className.split("txtReadOnly");
		field.className = className[0]+className[1];
	}
}

//--- This method is used to set disabled a field
function setDisabled(formName, fieldName){
	var field = getField(formName, fieldName);
	var type = field.type;
	if (type.indexOf("radio") >= 0) {
		var td=field.parentNode;
		while(td.tagName!="TD"){
			td=td.parentNode;
		}
		var fields=td.getElementsByTagName("INPUT");
		for(var i=0;i<fields.length;i++){
			type = fields[i].type;
			if(type.indexOf("radio") >= 0){
				fields[i].disabled = true;
				fields[i].setAttribute("x_deshabilitado","true");
			}
		}
	} else {
		field.disabled = true;
		field.setAttribute("x_deshabilitado","true");
	}
}
//--- This method removes the property disabled from a field
function removeDisabled(formName, fieldName){

	var field = getField(formName, fieldName);
	var type = field.type;
	if (type.indexOf("radio") >= 0) {
		var td=field.parentNode;
		while(td.tagName!="TD"){
			td=td.parentNode;
		}
		var fields=td.getElementsByTagName("INPUT");
		for(var i=0;i<fields.length;i++){
			type = fields[i].type;
			if(type.indexOf("radio") >= 0){
				fields[i].disabled = false;
				fields[i].setAttribute("x_deshabilitado","false");
			}
		}
	} else {
		field.disabled = false;
		field.setAttribute("x_deshabilitado","false");
	}
}

//--- This method is used to set read only a grid's fild
function setDisabledByIndex(formName, fieldName, index){
	var field = getFieldByIndex(formName, fieldName,index);
	if(field!=null){
		field = getElementFromHidden(field);
		field.disabled = true;
		field.setAttribute("x_deshabilitado","false");
	} else {
		alert("ELEMENT " + formName + " - " + fieldName + " DOES NOT EXIST");
	}
}

//--- This method is used to remove the property read only
function removeDisabledByIndex(formName, fieldName, index){
	var field = getFieldByIndex(formName, fieldName,index);
	if(field!=null){
		field = getElementFromHidden(field);
		field.disabled = false;
		field.setAttribute("x_deshabilitado","false");
	} else {
		alert("ELEMENT " + formName + " - " + fieldName + " DOES NOT EXIST");
	}
}

//--- This method converts an Apia formatted number into a java script number
function toJSNumber(pValue){
	var	aux = pValue.replace(charThousSeparator,"");
	aux = aux.replace(charDecimalSeparator,".");
	return parseFloat(aux);
}

//--- This method converts a number in an Apia formatted number
function toApiaNumber(pValue){
	try {pValue = pValue.toFixed(amountDecimalSeparator)} catch(e1) {}
	var s = new String(pValue);
	if(s.indexOf(".")==-1){
		if(addThousandSeparator){
			s=addThousSeparator(s);
		}
	} else {
		if(addThousandSeparator){
			s=addThousSeparator(s.replace(".",charDecimalSeparator));
		}else{
			s=s.replace(".",charDecimalSeparator);
		}
		var int=s.split(charDecimalSeparator)[0];
		var decimals=s.split(charDecimalSeparator)[1];
		var decCount=decimals.length-1;
		while(decCount>=amountDecimalZeros && decimals.charAt(decCount)=="0"){
			decimals=decimals.substring(0,decCount);
			decCount--;
		}
	}
	return int+charDecimalSeparator+decimals;
}

//--checks if a field is an apia number by index
function isApiaNumberByIndex(formName, fieldName, index){
	var field = getFieldByIndex(formName, fieldName, index);
	return validateNumber(field);
}
//--checks if a field is an apia number
function isApiaNumber(formName, fieldName){
	var field = getFieldByIndex(formName, fieldName, 0);
	return validateNumber(field);

}

var lastModalReturn;

//-- This method opens a pop-up and allows the administration of an entity instance.
//-- The entity type name must be supplied.  If a value is supplied as the entity instance number,
//-- then the pop-up will allow the modification of that entitie's data.  If no number is supplied, 
//-- and entity instance creation pop-up will be shown.  Parameters can be passed in the following
//-- format : param1=value1;param2=value2;.  This function will return the entity number if the
//-- action is confirmed, and a "" value if the pop-up is closed without confirming the action.

function admEntity(entName, entNum, parameters) {
	var paramArr = "status:no; help:no; unadorned:yes; center:yes; dialogWidth:640px; dialogHeight:480px;";
	var url = "/programs/execution/modalView.jsp?entName=" + entName
	if (entNum != undefined) {
		url += "&busEntId="+ entNum;
	}
	if (parameters != undefined) {
		url += "&params=" + escape(parameters);
	}
	if (windowId != undefined && windowId != "") {
		url +=windowId;
	}
	return openModal((url),parameters,paramArr);
}

function viewAdmEntity(entName, entNum) {
	var paramArr = "status:no; help:no; unadorned:yes; center:yes; dialogWidth:800px; dialogHeight:600px;";
	var url = "/programs/execution/modalView.jsp?entName=" + entName + "&readOnly=true";

	if (entNum != undefined) {
		url += "&busEntId="+ entNum;
	}
	if (windowId != undefined && windowId != "") {
		url +=windowId;
	}

	return window.showModalDialog(URL_ROOT_PATH + url,parameters,paramArr);
}

//--this method removes the data in the inputs of a grid
function clearGridData(formName, fieldName){
	var grd = getGrid(formName, fieldName);
	if (grd != null) {
			
		tbody = grd.getElementsByTagName("TBODY")[0];
		if (tbody.getElementsByTagName("TR").length == 0 && grd.parentNode != null) {
			grd = grd.parentNode.nextSibling;
			if (grd.tagName.toUpperCase() == "GRID" && grd.childNodes[0] != null) {
				if (grd.childNodes[0].tagName.toUpperCase() == "TABLE" && grd.childNodes[0].getAttribute("name").toUpperCase() == (formName + "_" + fieldName).toUpperCase()) {
					tbody = grd.childNodes[0].childNodes[1];
				}
			}
		}
		if(grd.getAttribute("hasFiles").toUpperCase() == "TRUE"){
			var cant = tbody.getElementsByTagName("TR").length;		
			var indexToClear = "";
			if(grd.getAttribute("isPaged").toUpperCase() == "TRUE"){
				var currentPage = parseInt(grd.getAttribute("currentPage"));
				var recordsPerPage = parseInt(grd.getAttribute("recordsPerPage"));
				var aux;
				for (i=cant-1;i!=1;i--) {
					aux = ((currentPage-1)*recordsPerPage)+i;
					indexToClear = "-" + aux.toString() + indexToClear;
				}
				aux = ((currentPage-1)*recordsPerPage) + 1;
				indexToClear = aux.toString() + indexToClear;
			}else{
				for (i=cant-1;i!=1;i--) {
					indexToClear = "-" + i.toString() + indexToClear;
				}
				indexToClear = "1" + indexToClear;
			}
			
			if(grd.getAttribute("isPaged").toUpperCase() != "TRUE"){
				document.getElementById("frmMain").action = "execution.FormAction.do?action=clearGridData&toClear=" + indexToClear + "&fldId=" + grd.getAttribute("fldId") + "&frmId=" + grd.getAttribute("frmId") + "&frmParent=" + grd.getAttribute("frmParent");		
				submitFormReload(document.getElementById("frmMain"));	
			}else{
				document.getElementById("frmMain").action = "execution.FormAction.do?action=clearGridRows&toClear=" + indexToClear + "&fldId=" + grd.getAttribute("fldId") + "&frmId=" + grd.getAttribute("frmId") + "&frmParent=" + grd.getAttribute("frmParent") + "&isPaged=" + grd.getAttribute("isPaged");		
				submitFormReload(document.getElementById("frmMain"));
			}
			
		}else{		
			for (i = 0; i < tbody.getElementsByTagName("TR").length; i++) {
				for(h=0; h < tbody.getElementsByTagName("TR")[i].cells.length; h++){
					var el=tbody.getElementsByTagName("TR")[i].cells[h].childNodes[0].childNodes[0];
					if(!el){
						try{
							tbody.getElementsByTagName("TR")[i].cells[h].childNodes[0].innerHTML= "";
						}catch(e){
							tbody.getElementsByTagName("TR")[i].cells[h].childNodes[0].value= "";
						}
					} else {
						clearGridFieldData(el);
					}
				}
			}
		}	
	}	
}

function clearGridDataWithParent(formName, fieldName, parent){
	var grd = getGrid(formName, fieldName, parent);
	if (grd != null) {
			
		tbody = grd.getElementsByTagName("TBODY")[0];
		if (tbody.getElementsByTagName("TR").length == 0 && grd.parentNode != null) {
			grd = grd.parentNode.nextSibling;
			if (grd.tagName.toUpperCase() == "GRID" && grd.childNodes[0] != null) {
				if (grd.childNodes[0].tagName.toUpperCase() == "TABLE" && grd.childNodes[0].getAttribute("name").toUpperCase() == (formName + "_" + fieldName).toUpperCase()) {
					tbody = grd.childNodes[0].childNodes[1];
				}
			}
		}
		if(grd.getAttribute("hasFiles").toUpperCase() == "TRUE"){
			var cant = tbody.getElementsByTagName("TR").length;		
			var indexToClear = "";
			if(grd.getAttribute("isPaged").toUpperCase() == "TRUE"){
				var currentPage = parseInt(grd.getAttribute("currentPage"));
				var recordsPerPage = parseInt(grd.getAttribute("recordsPerPage"));
				var aux;
				for (i=cant-1;i!=1;i--) {
					aux = ((currentPage-1)*recordsPerPage)+i;
					indexToClear = "-" + aux.toString() + indexToClear;
				}
				aux = ((currentPage-1)*recordsPerPage) + 1;
				indexToClear = aux.toString() + indexToClear;
			}else{
				for (i=cant-1;i!=1;i--) {
					indexToClear = "-" + i.toString() + indexToClear;
				}
				indexToClear = "1" + indexToClear;
			}
			
			if(grd.getAttribute("isPaged").toUpperCase() != "TRUE"){
				document.getElementById("frmMain").action = "execution.FormAction.do?action=clearGridData&toClear=" + indexToClear + "&fldId=" + grd.getAttribute("fldId") + "&frmId=" + grd.getAttribute("frmId") + "&frmParent=" + grd.getAttribute("frmParent");		
				submitFormReload(document.getElementById("frmMain"));	
			}else{
				document.getElementById("frmMain").action = "execution.FormAction.do?action=clearGridRows&toClear=" + indexToClear + "&fldId=" + grd.getAttribute("fldId") + "&frmId=" + grd.getAttribute("frmId") + "&frmParent=" + grd.getAttribute("frmParent") + "&isPaged=" + grd.getAttribute("isPaged");		
				submitFormReload(document.getElementById("frmMain"));
			}
			
		}else{		
			for (i = 0; i < tbody.getElementsByTagName("TR").length; i++) {
				for(h=0; h < tbody.getElementsByTagName("TR")[i].cells.length; h++){
					var el=tbody.getElementsByTagName("TR")[i].cells[h].childNodes[0].childNodes[0];
					if(el==null){
						tbody.getElementsByTagName("TR")[i].cells[h].childNodes[0].innerHTML= "";
					} else {
						clearGridFieldData(el);
					}
				}
			}
		}	
	}	
}

function clearGridFieldData(el){
	if(el.type == "text"){
		el.value = "";
	} else if(el.type == "password"){
		el.value = "";
	} else if(el.type == "checkbox"){
		el.checked = false;
		//esto es porque el primer check de la tabla no tiene dos elementos
		try{
			el.value = "false";
		} catch(e){}
	} else if (el.type == "select"){
		el.value="";
	}
}

function clearGridRows(formName, fieldName){
	var grd = getGrid(formName, fieldName);
	if (grd != null) {
		
		tbody = grd.getElementsByTagName("TBODY")[0];
		if (tbody.getElementsByTagName("TR").length == 0 && grd.parentNode != null) {
			grd = grd.parentNode.nextSibling;
			if (grd.tagName.toUpperCase() == "GRID" && grd.childNodes[0] != null) {
				if (grd.childNodes[0].tagName.toUpperCase() == "TABLE" && grd.childNodes[0].getAttribute("name").toUpperCase() == (formName + "_" + fieldName).toUpperCase()) {
					tbody = grd.childNodes[0].childNodes[1];
				}
			}
		}
		
		var cant = tbody.getElementsByTagName("TR").length;		
		var indexToClear = "";
		if(grd.getAttribute("isPaged").toUpperCase() == "TRUE"){
			var currentPage = parseInt(grd.getAttribute("currentPage"));
			var recordsPerPage = parseInt(grd.getAttribute("recordsPerPage"));
			var aux;
			for (i=cant-1;i!=1;i--) {
				aux = ((currentPage-1)*recordsPerPage)+i;
				indexToClear = "-" + aux.toString() + indexToClear;
			}
			aux = ((currentPage-1)*recordsPerPage) + 1;
			indexToClear = aux.toString() + indexToClear;
		}else{
			for (i=cant-1;i!=1;i--) {
				indexToClear = "-" + i.toString() + indexToClear;
			}
			indexToClear = "1" + indexToClear;
		}
		if(grd.getAttribute("hasFiles").toUpperCase() == "TRUE"){
			document.getElementById("frmMain").action = "execution.FormAction.do?action=clearGridRows&toClear=" + indexToClear + "&fldId=" + grd.getAttribute("fldId") + "&frmId=" + grd.getAttribute("frmId") + "&frmParent=" + grd.getAttribute("frmParent") + "&isPaged=" + grd.getAttribute("isPaged");		
			submitFormReload(document.getElementById("frmMain"));
		}else{
			for (i=cant-1;i!=0;i--) {
				tbody.getElementsByTagName("TR")[i].parentNode.removeChild(tbody.getElementsByTagName("TR")[i]);
			}
		}
		
	}
}

function clearGridRowsWithParent(formName, fieldName, parent){
	var grd = getGrid(formName, fieldName, parent);
	if (grd != null) {
		
		tbody = grd.getElementsByTagName("TBODY")[0];
		if (tbody.getElementsByTagName("TR").length == 0 && grd.parentNode != null) {
			grd = grd.parentNode.nextSibling;
			if (grd.tagName.toUpperCase() == "GRID" && grd.childNodes[0] != null) {
				if (grd.childNodes[0].tagName.toUpperCase() == "TABLE" && grd.childNodes[0].getAttribute("name").toUpperCase() == (formName + "_" + fieldName).toUpperCase()) {
					tbody = grd.childNodes[0].childNodes[1];
				}
			}
		}
		
		var cant = tbody.getElementsByTagName("TR").length;		
		var indexToClear = "";
		if(grd.getAttribute("isPaged").toUpperCase() == "TRUE"){
			var currentPage = parseInt(grd.getAttribute("currentPage"));
			var recordsPerPage = parseInt(grd.getAttribute("recordsPerPage"));
			var aux;
			for (i=cant-1;i!=1;i--) {
				aux = ((currentPage-1)*recordsPerPage)+i;
				indexToClear = "-" + aux.toString() + indexToClear;
			}
			aux = ((currentPage-1)*recordsPerPage) + 1;
			indexToClear = aux.toString() + indexToClear;
		}else{
			for (i=cant-1;i!=1;i--) {
				indexToClear = "-" + i.toString() + indexToClear;
			}
			indexToClear = "1" + indexToClear;
		}
		if(grd.getAttribute("hasFiles").toUpperCase() == "TRUE"){
			document.getElementById("frmMain").action = "execution.FormAction.do?action=clearGridRows&toClear=" + indexToClear + "&fldId=" + grd.getAttribute("fldId") + "&frmId=" + grd.getAttribute("frmId") + "&frmParent=" + grd.getAttribute("frmParent") + "&isPaged=" + grd.getAttribute("isPaged");		
			submitFormReload(document.getElementById("frmMain"));
		}else{
			for (i=cant-1;i!=1;i--) {
				tbody.getElementsByTagName("TR")[i].parentNode.removeChild(tbody.getElementsByTagName("TR")[i]);
			}
		}
		
	}
}

function clearGridRowsByIndex(formName, gridName, index) {
	var grd=getGrid(formName,gridName);
	if (grd!=null) {
		tbody=grd.rows;
		var cant=tbody.length;
		/*
		for (i=cant-1; i!=0; i--) {
			if (i==index) {
				clearGridRow(grd,tbody[i]);
				break;
			}
		}
		*/
		if(index + 1 < cant) {
			clearGridRow(grd,tbody[index + 1]);
		}
	}
}

function clearGridRow(grd, row) {
	if (grd!=null) {
		if(grd.getAttribute("hasFiles") && grd.getAttribute("hasFiles").toUpperCase() == "TRUE"){
			var cant = grd.rows.length;		
			var indexToClear = "";
			if(grd.getAttribute("isPaged").toUpperCase() == "TRUE"){
				var currentPage = parseInt(grd.getAttribute("currentPage"));
				var recordsPerPage = parseInt(grd.getAttribute("recordsPerPage"));
				var aux = ((currentPage-1)*recordsPerPage) + (row.rowIndex+1);
				indexToClear = aux.toString() + indexToClear;
			}else{
				//indexToClear = "1" + (row.rowIndex+1);
				indexToClear = (row.rowIndex-1);
			}
			
			if(grd.getAttribute("isPaged").toUpperCase() != "TRUE"){
				document.getElementById("frmMain").action = "execution.FormAction.do?action=clearGridData&toClear=" + indexToClear + "&fldId=" + grd.getAttribute("fldId") + "&frmId=" + grd.getAttribute("frmId") + "&frmParent=" + grd.getAttribute("frmParent");		
				submitFormReload(document.getElementById("frmMain"));	
			}else{
				document.getElementById("frmMain").action = "execution.FormAction.do?action=clearGridRows&toClear=" + indexToClear + "&fldId=" + grd.getAttribute("fldId") + "&frmId=" + grd.getAttribute("frmId") + "&frmParent=" + grd.getAttribute("frmParent") + "&isPaged=" + grd.getAttribute("isPaged");		
				submitFormReload(document.getElementById("frmMain"));
			}
			
		} else {
			for(var h = 0; h < row.cells.length; h++) {
				/*
				var el=row.cells[h].childNodes[0].childNodes[0];
				if(el==null){
					row.cells[h].childNodes[0].innerHTML= "";
				} else {
					clearGridFieldData(el);
				}
				*/
				var el = row.cells[h].childNodes[0];
				
				if(el.nodeName == "SPAN" && el.childNodes.length > 0)
					el = el.childNodes[0];
				
				if(h == 0 && row.cells[h].style.display == "none" && el && el.id == "checkSel" && el.type == "hidden")
					continue;
				
				if(el == null) {
					row.cells[h].innerHTML= "";
				} else {
					clearGridFieldData(el);
				}
			}
		}		


	}
}

function setRequired(formName, fieldName){
	setRequiredByIndex(formName, fieldName,0);
}

function removeRequired(formName, fieldName){
	removeRequiredByIndex(formName, fieldName,0);
}

function setRequiredByIndex(formName, fieldName, index){
	var field = getFieldByIndex(formName, fieldName,index);
	if(field!=null){
		field = getElementFromHidden(field);
		setRequiredField(field);
	} else {
		alert("ELEMENT " + formName + " - " + fieldName + " DOES NOT EXIST");
	}
}

function unselectAllRadios(formName, fieldName){
	var field=getFieldByIndex(formName, fieldName,0);
	if(field.type=="radio"){
		var td=field.parentNode;
		while(td.tagName!="TD"){
			td=td.parentNode;
		}
		var fields=td.getElementsByTagName("INPUT");
		for(var i=0;i<fields.length;i++){
			if(fields[i].type=="radio"){
				fields[i].checked=false;
			}else{
				fields[i].value="";
			}
		}
	}
}

function removeRequiredByIndex(formName, fieldName, index){
	var field = getFieldByIndex(formName, fieldName,index);
	if(field!=null){
		field = getElementFromHidden(field);
		unsetRequiredField(field);
	} else {
		alert("ELEMENT " + formName + " - " + fieldName + " DOES NOT EXIST");
	}
}
function getElementFromHidden(field){
	if(field.type=="hidden" && field.getAttribute("ie6TextArea")!="true"){
		field=field.nextSibling;
		while(field.tagName==undefined){
			field=field.nextSibling;
		}
	}
	return field;
}

function disableFieldModal(field) {
	field.setAttribute("x_deshabilitado","true");
	/*var nextS = field.nextSibling;
	while(nextS!=null){
		if(nextS.tagName == "INPUT"){
			nextS.setAttribute("x_deshabilitado","true");
		}
		nextS = nextS.nextSibling;
	}*/
}

function enableFieldModal(field) {
	field.setAttribute("x_deshabilitado","false");
	/*var nextS = field.nextSibling;
	while(nextS!=null){
		if(nextS.tagName == "INPUT"){
			nextS.setAttribute("x_deshabilitado","false");
		}
		nextS = nextS.nextSibling;
	}*/
}



function manualSubmitByOne(frmName){

	var obj = getForm(frmName);
	//var http_request = new ActiveXObject("Microsoft.XMLHTTP");
	
	
	if (window.XMLHttpRequest) {
			// browser has native support for XMLHttpRequest object
			http_request = new XMLHttpRequest();
		} else if (window.ActiveXObject) {
			// try XMLHTTP ActiveX (Internet Explorer) version

			try {
				http_request = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (e1) {
				try {
					http_request = new ActiveXObject("Microsoft.XMLHTTP");
				} catch (e2) {
					http_request = null;
				}
			}
	}

	var s = "&frmName=" + frmName;
	//INPUTS
	var col = obj.getElementsByTagName("INPUT");
	for (i=0; i<col.length;i++){
		if(col[i].name!=null && col[i].name!=""){
		s= s+ "&"+col[i].name + "=" + escape(col[i].value);
		}
	}
	//COMBOS
	col = obj.getElementsByTagName("SELECT");
	for (i=0; i<col.length;i++){
		if(col[i].name!=null && col[i].name!=""){
		s= s+ "&"+col[i].name + "=" + escape(col[i].value);
		}
	}
	col = obj.getElementsByTagName("TEXTAREA");
	for (i=0; i<col.length;i++){
		if(col[i].name!=null && col[i].name!=""){
		s= s+ "&"+col[i].name + "=" + escape(col[i].value);
		}
	}
	//if(s.length > 1990){
		s=s.substr(1,s.length);
	//}
	
	http_request.open('POST', "execution.FormAction.do?action=submitFormData", false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded; charset=utf-8");
    http_request.send(s);
    
     if (http_request.readyState == 4) {
            if (http_request.status == 200) {
                //alert(http_request.responseText);
                if(http_request.responseText == "OK"){
                	return true;
                } else {
                	return false;
                }
            } else {
               // alert('Hubo problemas con la petici?n.');
               	return false;               
            }
        }
}
 

function getForm(formName) {
	var form = document.getElementById("divTitFrm" + formName);
	if (form != null) { 
		var form = form.nextSibling;
		while(form != null && form.tagName!="DIV"){
			form=form.nextSibling;
		}
	} else {
		form = null;
	}
	return form;
}


 


function manualSubmit(){
	var ret = true;
	//buscar todos los divs
	var col = document.getElementsByTagName("DIV");
	if(col!=null){
		for(z=0;z<col.length;z++){
			var aux = col[z];
			//si se llaman divTitFrmXXXX sirven
			if(aux.id.indexOf("divTitFrm") > -1){
				//por cada div, llamar al submit
				ret = ret &  manualSubmitByOne(aux.id.substr(9));
				
			}
		}
	}
	if(ret==true){
		return true;
	} else {
		return false;
	}
}

function clearMaskedField(field){
	field.clear();
}


function closeForm(formName) {
	var form= document.getElementById("divTitFrm" + formName);
	var obj = form.firstChild.firstChild.firstChild.firstChild;
	var tmp = obj.firstChild.src;
	obj.firstChild.setAttribute("src",obj.firstChild.getAttribute("auxSrc"));
	obj.firstChild.setAttribute("auxSrc",tmp);
	var form2= document.getElementById("divFrm" + formName);
	form2.style.display="none";
}

function openForm(formName) {
	var form= document.getElementById("divTitFrm" + formName);
	var obj = form.firstChild.firstChild.firstChild.firstChild;
	var tmp = obj.firstChild.src;
	obj.firstChild.setAttribute("src",obj.firstChild.getAttribute("auxSrc"));
	obj.firstChild.setAttribute("auxSrc",tmp);
	var form2= document.getElementById("divFrm" + formName);
	form2.style.display="block";
}


//--- This method is used to set disabled a field
function setReadOnly(formName, fieldName){
	setReadonly(formName, fieldName);
}
//--- This method removes the property disabled from a field
function removeReadOnly(formName, fieldName){
	removeReadonly(formName, fieldName);
}

//--- This method is used to set read only a grid's fild
function setReadOnlyByIndex(formName, fieldName, index){
	var field = getFieldByIndex(formName, fieldName,index);
	if(field!=null){
		field = getElementFromHidden(field);
		field.readOnly = true;
		if (field.type == "checkbox") field.disabled = true;
		setBrwsReadOnly(field);
		field.setAttribute("className","readOnly");
	} else {
		alert("ELEMENT " + formName + " - " + fieldName + " DOES NOT EXIST");
	}
}

//--- This method is used to remove the property read only
function removeReadOnlyByIndex(formName, fieldName, index){
	var field = getFieldByIndex(formName, fieldName,index);
	if(field!=null){
		field = getElementFromHidden(field);
		field.readOnly = false;
		if (field.type == "checkbox") field.disabled = false;
		unsetBrwsReadOnly(field);
		field.setAttribute("className","");
	} else {
		alert("ELEMENT " + formName + " - " + fieldName + " DOES NOT EXIST");
	}
}


function hideEditor(formName, fieldName){
	var idLbl=("div_" + formName + "_" + fieldName + "_E_LBL").toUpperCase();
	var idData=("div_" + formName + "_" + fieldName + "_E_DATA").toUpperCase();
	var elementLbl = document.getElementById(idLbl);
	if(elementLbl){
		if (elementLbl != null) {
			elementLbl.style.display="none";
		}
		var elementData = document.getElementById(idData);
		if (elementData != null) {
			elementData.style.display="none";
		}
		return true;
	}
}

function showEditor(formName, fieldName){
	var idLbl=("div_" + formName + "_" + fieldName + "_E_LBL").toUpperCase();
	var idData=("div_" + formName + "_" + fieldName + "_E_DATA").toUpperCase();
	var elementLbl = document.getElementById(idLbl);
	if(elementLbl){
		if (elementLbl != null) {
			elementLbl.style.display="block";
		}
		var elementData = document.getElementById(idData);
		if (elementData != null) {
			elementData.style.display="block";
		}
		return true;
	}
}

function changeTab(tabIndex){
	tabElements[0].showContent(tabIndex);
}
//---------------------Funciones nuevas agregadas -------------------------------------------
function getRadioOptions(formName, fieldName){
	//initialize options
	var options = new Array();
	var field=getFieldByIndex(formName, fieldName,0);
	//check it exists in form and is a radio
	if(field != null && field.type=="radio"){
		var td=field.parentNode;
		while(td.tagName!="TD"){
			td=td.parentNode;
		}
		var fields=td.getElementsByTagName("INPUT");
		for(var i=0;i<fields.length;i++){
			if(fields[i].type=="radio"){
				options.push(fields[i]);
			}
		}
	}
	return options;
}


function getRadioValue(formName, fieldName){
	if(!existField(formName, fieldName)){
		return null;
	}
		
	var field = getField(formName, fieldName);
	if(field!=null){
		var td=field.parentNode;
		while(td.tagName!="TD"){
			td=td.parentNode;
		}
		var fields=td.getElementsByTagName("INPUT");
		for(var i=0;i<fields.length;i++){
			if (fields[i].checked == true)
				return fields[i].value;
		}
		
		return "";
	}
}

function addOptionToFieldIndex(formName, fieldName, value, text, index){
	var combo = getFieldByIndex(formName, fieldName,index);
	//create option
	var option=document.createElement("OPTION");
	option.value=value;
	option.innerHTML=text;
	//ad option
	combo.appendChild(option);
}

function addOptionToField(formName, fieldName, value, text){
	//get field
	var field = getField(formName, fieldName);
	if(field == null) return;
	//check field type
	if(field.tagName=="SELECT"){//combos and list
		if(field.multiple){
			//field is a listbox
			addOptionToCombo(field,value,text);
		}else{//combo, add to all indexes
			var totalCombos = getFieldColumn(formName, fieldName).length;
			for(i=0;i<totalCombos;i++){
				//add option to combo index
				addOptionToFieldIndex(formName, fieldName,value,text,i);
			}
		}
	}else if(field.type=="radio"){
		//for radio buttons
		var td=field.parentNode;
		while(td.tagName!="TD"){
			td=td.parentNode;
		}
		td.innerHTML=td.innerHTML+"<input type='radio' name='"+field.name+"' id='"+field.id+"' value='"+value+"'/>"+text+"<br />";//onblur='if(this.checked==true){document.getElementById('hidRad_"+field.id+"').value='0'}'/>"+text+"<br />";
	}
}

function getLabel(name){
	return document.getElementById(name);
}


function hideField(formName, fieldName){
	if(!hideEditor(formName, fieldName)){
		hideFieldByIndex(formName, fieldName, 0);
	}
}

function showField(formName, fieldName){
	if(!showEditor(formName, fieldName)){
		showFieldByIndex(formName, fieldName, 0);
	}
}

function hideFieldByIndex(formName, fieldName, index){
	var fld = getFieldByIndex(formName, fieldName, index);
	if(fld == null || fld == undefined)
		return;
	if(isInGrid(fld)){
		var td=getParentCell(fld);
		for(var i=0;i<td.childNodes.length;i++){
			if(!MSIE) {
				if((td.childNodes[i].tagName == "img" || td.childNodes[i].tagName == "IMG") &&
						(td.childNodes[i].getAttribute("src") == URL_ROOT_PATH + "/images/cellsizer.gif")) {
					continue;
				}
			}
			try{td.childNodes[i].style.visibility="hidden";}catch(e){}
			try{td.childNodes[i].style.display="none";}catch(e){}
		}
		//Verificar si la grilla tiene ocultos todos los elementos del tr
		var tds = td.parentNode.childNodes;
		var is_hidden = true;
		for (i = 0; i < tds.length && is_hidden; i++) {	
			var td_childs = tds[i].childNodes;
			if(tds[i].style == undefined || tds[i].style.visibility == "hidden" || tds[i].style.display == "none") {
				continue;
			}
			if(tds[i].tagName == "TD" || tds[i].tagName == "td"){
				for (var j = 0; j < td_childs.length; j++) {
					//if(td.childNodes[j].tagName == "SCRIPT" || td.childNodes[j].tagName == "script"){
					if(td_childs[j].tagName == "SCRIPT" || td_childs[j].tagName == "script"){
						continue;
					}
					if(!MSIE) {
						if((td_childs[j].tagName == "img" || td_childs[j].tagName == "IMG") &&
								(td_childs[j].getAttribute("src") == URL_ROOT_PATH + "/images/cellsizer.gif")) {
							continue;
						}
					}
					if(td_childs[j].style != undefined && !(td_childs[j].style.visibility == "hidden" || td_childs[j].style.display == "none")) {						
						is_hidden = false;
						break;
					}
				}
			}
		}
		if(is_hidden) {
			try{ td.parentNode.style.visibility = "hidden"; } catch(e) { }
			try{ td.parentNode.style.display = "none"; } catch (e) { }
		}
	}else{
		getParentCell(fld).previousSibling.style.visibility="hidden";
		getParentCell(fld).style.visibility="hidden";
		if (MSIE6) getParentCell(fld).style.display="none";
	}
}

function showFieldByIndex(formName, fieldName, index){
	var fld = getFieldByIndex(formName, fieldName, index);
	if(fld == null || fld == undefined)
		return;
	if(isInGrid(fld)){
		var td=getParentCell(fld);
		
		try{ td.parentNode.style.visibility = ""; } catch(e) { }
		try{ td.parentNode.style.display = ""; } catch (e) { }
		
		for(var i=0;i<td.childNodes.length;i++){
			if(td.childNodes[i].tagName == "SCRIPT" || td.childNodes[i].tagName == "script"){
				continue;
			}
			
			var elemsParents;
			if(!MSIE) {
				//try{td.childNodes[i].style.visibility="visible";}catch(e){}
				try{td.childNodes[i].style.visibility="";}catch(e){}
				//try{td.childNodes[i].style.display="block";}catch(e){}
				try{td.childNodes[i].style.display="";}catch(e){}
				
				elemsParents = td.childNodes[i];
			} else {
				elemsParents = td;
				
				//Se corrige padding de files ocultos para ie
				elemsParents.style.paddingTop = "";
				elemsParents.style.paddingBottom = "";
			}
			
			//Se busca el tag con propiedad grid = true
			if(elemsParents.tagName != undefined) {
				var elems = elemsParents.getElementsByTagName("*");
				for (var j = 0; j < elems.length; j++) {
					try{
						if (elems[j].getAttribute("grid") == "true" || elems[j].getAttribute("dtPicker") == "true") {
							try{elems[j].style.visibility="";}catch(e){}
							try{elems[j].style.display="";}catch(e){}
						}
					} catch(error) {
						try {
							if (elems[j].grid == "true" || elems[j].getAttribute.dtPicker == "true") {
								try{elems[j].style.visibility="";}catch(e){}
								try{elems[j].style.display="";}catch(e){}
							}
						} catch(error2) {}
					}
				}
			}
		}
	}else{
		getParentCell(fld).previousSibling.style.visibility="visible";
		getParentCell(fld).style.visibility="visible";
		if (MSIE6) getParentCell(fld).style.display="block";
	}
}

function getElementForm(el){
	var parent=el.parentNode;
	while(parent.tagName!="BODY"){
		if(parent.tagName=="DIV" && parent.id.indexOf("divFrm")>=0){
			var frmId=parent.id.split("divFrm")[1];
			if(el.id.indexOf(frmId)>=0){
				return parent;
			}
		}
		parent=parent.parentNode;
	}
	return null;
}


function isFormReadonly(formName){
	var frm = document.getElementById("hidFrm" + formName + "Readonly");
	return frm.value;
}

function existField(formName, fieldName) {
	return existFieldByIndex(formName, fieldName, 0);
}

function existFieldByIndex(formName, fieldName, index) {
	var id=(formName + "_" + fieldName).toUpperCase();
	var elementId = document.getElementById(id);
	var el=null;
	if (elementId != null) {
		var inputs2 = document.getElementsByTagName(elementId.tagName);
		var inputs3 = new Array();
		for (var ppp = 0; ppp < inputs2.length; ppp++) {
			if(inputs2[ppp].id && elementId.id && inputs2[ppp].name && elementId.name){
				if ((inputs2[ppp].id == elementId.id || inputs2[ppp].name == elementId.name) && inputs2[ppp].tagName == elementId.tagName) {
					inputs3.push(inputs2[ppp]);
				}
			}
		}
		
		if (inputs3 != null) {
			if (inputs3.length > index) {
				el=inputs3[index];
			} else if (inputs3.length == 0) {
				el=elementId;
			}
		}
	}
	if(!el){
		return false
	}
	return true;
}

function getTabTitle(tabNumber){
	var samplesTab = document.getElementById("samplesTab");
	var tabs = samplesTab.tabs;
	
	for(var i=0; i < tabs.length; i++) {
		if (i == tabNumber) {
			return tabs[i].getAttribute("tabTitle");
		}
	}
	return null;
}

function getTabNumber(tabTitle){
	var samplesTab = document.getElementById("samplesTab");
	var tabs = samplesTab.tabs;
	
	for(var i=0; i < tabs.length; i++) {
		if (tabs[i].getAttribute("tabTitle") == tabTitle) {
			return i;
		}
	}
	return null;
}

function getFormNamesInTab(tabTitle){
	var samplesTab = document.getElementById("samplesTab");
	var tabs = samplesTab.tabs;
	var tabNumber=getTabNumber(tabTitle);
	var formNames=getFormNamesInTabNumber(tabNumber);
	return formNames;
}

function getFormNamesInTabNumber(tabNumber){
	var formNames=new Array();
	if(tabNumber){
		var frms = tabs[tabNumber].getElementsByTagName("DIV");
		for(var j=0; j < frms.length; j++){
			var str1 = frms[j].id.substring(0,9);
			 
			if (str1 == "divTitFrm") {
				var formName = frms[j].id.substring(9,frms[j].id.length);
				formNames.push(formName);     
			}
		}
	}
}

function sendValue(action){
	var sXMLSourceUrl = action;
	
	var xmlLoad=new xmlLoader();
	xmlLoad.onload=function(xml){
		return this.textLoaded;
	}
	xmlLoad.load(sXMLSourceUrl);
}


function clearForm(frmName){
	
	var frmDiv = getForm(frmName);
	for(var i=0;i<frmDiv.getElementsByTagName("INPUT").length;i++){
		if(frmDiv.getElementsByTagName("INPUT")[i].name.match("^frm_")=="frm_" 
			&& !(frmDiv.getElementsByTagName("INPUT")[i].name.match("_XX$")=="_XX")
			&& !(frmDiv.getElementsByTagName("INPUT")[i].name.match("_ROWID$")=="_ROWID")	
		){
			
			frmDiv.getElementsByTagName("INPUT")[i].value = "";
			if(frmDiv.getElementsByTagName("INPUT")[i].getAttribute("isEditor")){
				tinyMCE.getInstanceById(frmDiv.getElementsByTagName("INPUT")[i].id).setContent("");
			}
		}
	}
	
	for(var i=0;i<frmDiv.getElementsByTagName("SELECT").length;i++){
		if(frmDiv.getElementsByTagName("SELECT")[i].name.match("^frm_")=="frm_" 
			&& !(frmDiv.getElementsByTagName("SELECT")[i].name.match("_XX$")=="_XX")
			&& !(frmDiv.getElementsByTagName("SELECT")[i].name.match("_ROWID$")=="_ROWID")	
		){
			frmDiv.getElementsByTagName("SELECT")[i].selectedIndex = 0;
		}
	}
	
	
	for(var i=0;i<frmDiv.getElementsByTagName("TEXTAREA").length;i++){
		if(frmDiv.getElementsByTagName("TEXTAREA")[i].name.match("^frm_")=="frm_" 
			&& !(frmDiv.getElementsByTagName("TEXTAREA")[i].name.match("_XX$")=="_XX")
			&& !(frmDiv.getElementsByTagName("TEXTAREA")[i].name.match("_ROWID$")=="_ROWID")	
		){
			frmDiv.getElementsByTagName("TEXTAREA")[i].value = "";
		}
	}

	
}


function clearEditor(formName, fieldName, parent) {
	
	
	var id=(formName + "_" + fieldName).toUpperCase() + "_" + parent.toUpperCase();
	

	tinyMCE.getInstanceById(id).setContent("");
 
}

function getAttField(type, attId) {
    var obj;
    var objs = document.getElementsByTagName("*");
    for (i=0;i<objs.length;i++) {
        obj = objs[i];
        if (! obj.name) obj.name = obj.getAttribute("name");
        if (! obj.value) obj.value = obj.getAttribute("value");
        if (obj.name) {
            if (obj.name.indexOf("frm_")>-1 && obj.name.indexOf("_XX")==-1) {
                strArr = obj.name.split("_");
                if (strArr[1] == type && strArr[3] == attId) {
                    return obj;
                }
            }
        }
    }
}


function getCurrentTaskName(){
	return CURRENT_TASK_NAME;
}


function setCheckboxValue(formName, fieldName, value){
	var field = getField(formName, fieldName);
	if(field !=null && field.type == "checkbox"){
		if(value == true || value == "true"){
			field.checked=true;
		}else{
			field.checked=false;
		}
		field.nextSibling.value=field.checked;
	}
}	