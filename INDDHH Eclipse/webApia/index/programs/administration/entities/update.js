//-------------------------------
//---- Funciones de botones
//-------------------------------
function btnConf_click(){
	if(isValidName(document.getElementById("txtName").value)){
		if (verifyRequiredObjects() && verifyOrdersForms() && verifyCubeData()) {
			if (verifyPermissions()){
				continueConfirm();
			}
		}
	}
}

function continueConfirm(){
	if (viewsWithError){
		var lbl = msgVwWithError;
		var msg = confirm(lbl.replace("<TOK1>", errorViews));
		if (msg){
			doConfirm();
		}
	}else {
		doConfirm();
	}
}

function doConfirm(){
	document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=confirm";
	submitForm(document.getElementById("frmMain"));
}

function btnExit_click(){
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		splash();
	}
}

function btnBack_click() {
	if (canWrite()){
		var msg = confirm(GNR_PER_DAT_ING);
		if (msg) {
			document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=backToList";
			submitForm(document.getElementById("frmMain"));
		}
	}else{
		document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}
}


function verifyOrdersForms() {
	var formEls = new Array();//document.getElementById("frmMain").getElementsByTagName("*");
	formEls.concat(document.getElementById("frmMain").getElementsByTagName("INPUT"));
	formEls.concat(document.getElementById("frmMain").getElementsByTagName("SELECT"));

	var ordenes = new Array();
	
	for (var indexCampo=0; indexCampo < formEls.length; indexCampo++){
		if (formEls[indexCampo].getAttribute("name") == "ordForm") {
			value = formEls[indexCampo].value
			
			if (ordenes[value]) {
				i = GNR_ORDER_DUPLICATED.indexOf("<TOK1>");
				var label = formEls[indexCampo].parentNode.parentNode.childNodes[1].innerText;
				alert(GNR_ORDER_DUPLICATED.substring(0,i)+ label + GNR_ORDER_DUPLICATED.substring(i+6,GNR_ORDER_DUPLICATED.length));
				return false;
			} else {
				ordenes[value] = true;
			}
		}
	}
	return true;
}

function up_click() {
	var grid=document.getElementById("gridForms");
	grid.moveSelectedUp();
}

function down_click() {
	var grid=document.getElementById("gridForms");
	grid.moveSelectedDown();
}

function upMon_click() {
	var grid=document.getElementById("gridMonForms");
	grid.moveSelectedUp();
}

function downMon_click() {
	var grid=document.getElementById("gridMonForms");
	grid.moveSelectedDown();
}

function swapX(pos1, pos2) {
	var chkChk1 = tblFormBody.rows(pos1).cells(2).children(0).checked;
	var chkChk2 = tblFormBody.rows(pos2).cells(2).children(0).checked;
	var chkChk3 = tblFormBody.rows(pos1).cells(0).children(0).checked;
	var chkChk4 = tblFormBody.rows(pos2).cells(0).children(0).checked;

	tblFormBody.rows(pos1).swapNode(tblFormBody.rows(pos2));

	tblFormBody.rows(pos1).cells(2).children(0).checked = chkChk2;
	tblFormBody.rows(pos2).cells(2).children(0).checked = chkChk1;
	tblFormBody.rows(pos1).cells(0).children(0).checked = chkChk4;
	tblFormBody.rows(pos2).cells(0).children(0).checked = chkChk3;
}
function swapMonX(pos1, pos2) {
	var chkChk1 = tblMonFormBody.rows(pos1).cells(2).children(0).checked;
	var chkChk2 = tblMonFormBody.rows(pos2).cells(2).children(0).checked;
	var chkChk3 = tblMonFormBody.rows(pos1).cells(0).children(0).checked;
	var chkChk4 = tblMonFormBody.rows(pos2).cells(0).children(0).checked;

	tblMonFormBody.rows(pos1).swapNode(tblMonFormBody.rows(pos2));

	tblMonFormBody.rows(pos1).cells(2).children(0).checked = chkChk2;
	tblMonFormBody.rows(pos2).cells(2).children(0).checked = chkChk1;
	tblMonFormBody.rows(pos1).cells(0).children(0).checked = chkChk4;
	tblMonFormBody.rows(pos2).cells(0).children(0).checked = chkChk3;
}
//--------------------------------
//----- Funciones de seleccion
//--------------------------------
function findRow(e) {
	if (e.tagName == "TR" && e.rowIndex!=0) {
		return e;
	} else if (e.tagName == "BODY") {
		return null;
	} else {
		return findRow(e.parentNode);
	}
}

function deselectRowOrCell(r) {
  r.className = r.orgClassName;
  r.selected=false;
}

function selectRowOrCell(r) {
  r.orgClassName = r.className;
  r.className = "trSelected";
  r.selected=true;
}

function findCell(e) {
	if (e.tagName == "TD") {
		return findRow(e.parentNode);
	} else if (e.tagName == "BODY") {
		return null;
	} else {
		return findCell(e.parentNode);
	}
}

//---------------------------------------
//--------- TRABAJAR CON ATRIBUTOS ------
//---------------------------------------

function btnRemAtt_click(val,type) {
	var extra = "";
	var pos = val-1;
	if (TYPE_NUMERIC == type) {
		extra = "Num";
		pos += 5;
	} else if (TYPE_DATE == type) {
		extra = "Dte";
		pos += 8;
	}

	//Verificamos si el atributo no esta siendo utilizado por alguna dimension o medida
	var attId = document.getElementById('hidAttId'+extra+val).value;
	//var useBy = notInUseInCube(attId);
	//if (useBy==0){
		document.getElementById('hidAttId'+extra+val).value = "";
		document.getElementById('hidAttLabel'+extra+val).value = "";
		document.getElementById('txtAttName'+extra+val).value = "";
		document.getElementById('chkAttId'+extra+val).disabled = true;
		document.getElementById('chkAttId'+extra+val).checked = false;
	
		var cmbAttText = document.getElementById("cmbAttText");
		var salir = false;
		for (i = 0; i < cmbAttText.options.length && ! salir; i++) {
			if (cmbAttText.options[i].value == pos) {
				cmbAttText.removeChild(cmbAttText.options[i]);
				salir = false;
			}
		}
		
		clearAttributes(); //Limpiamos los atributos del bean para que se borre el que acabo de borrar
		
		
		document.getElementById('imgUCAtt'+extra+val+'EntNeg').style.visibility="hidden";
		
	//}else if (useBy==1){
	//	alert(MSG_ATT_IN_USE_BY_DIM);	
	//}else if (useBy==2){
	//	alert(MSG_ATT_IN_USE_BY_MEA);
	//}
}

function btnLoadAtt_click(val,type) {
	var rets = openModal("/programs/modals/atts.jsp?onlyOne=true&type=" + type + "&showNative=true",500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var ok = true;
				var extra = "";
				var count = 0;
				var pos = val-1;
			
				if (TYPE_STRING == type) {
					count = 5;
				} else if (TYPE_NUMERIC == type) {
					extra = "Num";
					count = 3;
					pos += 5;
				} else if (TYPE_DATE == type) {
					extra = "Dte";
					count = 3;
					pos += 8;
				}
	
				for (i = 1; i <= count && ok; i++) {
					ok = ok && document.getElementById('hidAttId'+extra+i).value != ret[0];
				}
				if (ok) {
					document.getElementById('hidAttId'+extra+val).value = ret[0];
					document.getElementById('hidAttLabel'+extra+val).value = ret[2];
					document.getElementById('txtAttName'+extra+val).value = ret[1];
					document.getElementById('chkAttId'+extra+val).disabled = false;
		
					option = document.createElement("OPTION"); 
					option.value = pos;
					option.text = ret[1];
					document.getElementById("cmbAttText").options.add(option);
				}else{
					document.getElementById('chkAttId'+extra+val).disabled = true;
				}
			}
			clearAttributes(); //Limpiamos los atributos del bean para que se agregue el que acabo de agregar
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
	/*if (window.navigator.appVersion.indexOf("MSIE")<0){
		var aux=rets.document;
		var isOpen=true;
		rets.onunload=function(event){
			event.cancelBubble=true;
			if(!isOpen){
				doAfter(rets.returnValue);
			}
			isOpen=false;
	    }
    }else{
		doAfter(rets);
	}*/
}

//------------------------------------
//----- Funciones de identificador
//------------------------------------

function changeIdePos(val) {
	document.getElementById("txtIdePos").disabled = val; 
	if (val) {
		unsetRequiredField(document.getElementById("txtIdePos"));
		//document.getElementById("txtIdePos").p_required = 'false';
	} else {
		setRequiredField(document.getElementById("txtIdePos"));
		//document.getElementById("txtIdePos").p_required = 'true';
	}
}

function changeIdePre(val) {
	document.getElementById("txtIdePre").disabled = val; 
	if (val) {
		unsetRequiredField(document.getElementById("txtIdePre"));
		//document.getElementById("txtIdePre").setAttribute("p_required","false");
	} else {
		setRequiredField(document.getElementById("txtIdePre"));
		//document.getElementById("txtIdePre").setAttribute("p_required","true");
	}
}

//------------------------------------------
//---- Funciones de relaci?n de entidades
//------------------------------------------
function btnAdd_click() {

	var ret = openModal("/administration.EntitiesAction.do?action=openRelModal",500,300);
	var doAfter=function(ret){
		if (ret != null) {
	
			var oTd = document.createElement("TD"); 
			var oTd0 = document.createElement("TD"); 
			var oTd1 = document.createElement("TD"); 
			var oTd2 = document.createElement("TD");
			var oTd3 = document.createElement("TD"); 
			var oTd4 = document.createElement("TD");
			
			oTd.innerHTML = "<input type='checkbox' name='chkSel'>";
			//oTd.children(0).value = ret[0];
			oTd.align="center";
			
			oTd0.innerHTML = "<input type='hidden' name='txtRolA'>" + ret[0];
			oTd0.children(0).value = ret[0];
			oTd0.align="center";
			
			oTd1.innerHTML = "<input type='hidden' name='txtCarA'>" + ret[1];
			oTd1.children(0).value = ret[1];
			oTd1.align="center";
			
			oTd2.innerHTML = "<input type='hidden' name='txtCarB'>" + ret[2];
			oTd2.children(0).value = ret[2];
			oTd2.align="center";
	
			oTd3.innerHTML = "<input type='hidden' name='txtRolB'>" + ret[3];
			oTd3.children(0).value = ret[3];
			oTd3.align="center";
	
			oTd4.innerHTML = "<input type='hidden' name='txtEntB'>" + ret[5];
			oTd4.children(0).value = ret[4];
			oTd4.align="center";
	
			
			var oTr = document.createElement("TR");
			oTr.appendChild(oTd);
			oTr.appendChild(oTd0);
			oTr.appendChild(oTd1);
			oTr.appendChild(oTd2);
			oTr.appendChild(oTd3);
			oTr.appendChild(oTd4);
			document.getElementById("gridRelations").addRow(oTr);
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
	/*if (window.navigator.appVersion.indexOf("MSIE")<0){
		var aux=ret.document;
		var isOpen=true;
		ret.onunload=function(event){
			event.cancelBubble=true;
			if(!isOpen){
				doAfter(ret.returnValue);
			}
			isOpen=false;
	    }
    }else{
		doAfter(ret);
	}*/
}

function btnDel_click() {
	document.getElementById("gridRelations").removeSelected();
}

//----------------------------------
//---- Funciones de formularios 
//----------------------------------

function btnAddForm_click() {
	var rets = openModal("/programs/modals/forms.jsp",500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				trows=document.getElementById("gridForms").rows;
				for (i=0;i<trows.length && addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
						addRet = false;
					}
				}
	
				if (addRet) {
					var oTd0 = document.createElement("TD"); 
					var oTd1 = document.createElement("TD"); 
					var oTd2 = document.createElement("TD");
			
					oTd0.innerHTML = "<input type='checkbox' name='chkFormSel'><input type='hidden' name='chkForm'>";
					oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
					oTd0.align="center";
			
					oTd1.innerHTML = ret[1];
			
					oTd2.innerHTML = "<input type='checkbox' name='showForm" + ret[0] + "' value='true' checked>";
					oTd2.align="center";
			
					var oTr = document.createElement("TR");
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					oTr.appendChild(oTd2);
					
					document.getElementById("gridForms").addRow(oTr);
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
	/*if (window.navigator.appVersion.indexOf("MSIE")<0){
		var aux=rets.document;
		var isOpen=true;
		rets.onunload=function(event){
			event.cancelBubble=true;
			if(!isOpen){
				doAfter(rets.returnValue);
			}
			isOpen=false;
	    }
    }else{
		doAfter(rets);
	}*/
}

function btnDelForm_click() {
	var rows=document.getElementById("gridForms").selectedItems;
	var esta = false;
	var fixedForms="";
	for(var i=0;i<rows.length;i++){
		var input=rows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1];
		
		//si el form esta usado por un proc. no se borra
		if("true"==(rows[i].getAttribute("fixed_ent"))){
			var firstChild = rows[i].getElementsByTagName("TD")[1].firstChild;
			if(firstChild.nodeValue == null)
				fixedForms += " " + firstChild.firstChild.nodeValue;
			else
				fixedForms += " " + firstChild.nodeValue; 
			continue;
		}
	
		
		if(input.value==USRCREATION_FORM_ID){
			if (rows.length == 1){
				alert(MSG_FOR_NO_BOR);	
			}
		}else{
			document.getElementById("gridForms").deleteElement(rows[i]);
		}
	}
 
	if(fixedForms!=""){
		alert(MSG_USED_FORMS + fixedForms);
	}
}

function btnDelMonForm_click() {
	var rows=document.getElementById("gridMonForms").selectedItems;
	var esta = false;
	for(var i=0;i<rows.length;i++){
		var input=rows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1];
		if(input.value==USRCREATION_FORM_ID){
			if (rows.length == 1){
				alert(MSG_FOR_NO_BOR);	
			}
		}else{
			document.getElementById("gridMonForms").deleteElement(rows[i]);
		}
	}
}
function btnAddMonForm_click() {
	var rets = openModal("/programs/modals/forms.jsp",500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				trows=document.getElementById("gridMonForms").rows;
				for (i=0;i<trows.length && addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
						addRet = false;
					}
				}
	
				if (addRet) {
					var oTd0 = document.createElement("TD"); 
					var oTd1 = document.createElement("TD"); 
			
					oTd0.innerHTML = "<input type='checkbox' name='chkMonFormSel'><input type='hidden' name='chkMonForm'>";
					oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
					oTd0.align="center";
			
					oTd1.innerHTML = ret[1];
			
					var oTr = document.createElement("TR");
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					
					document.getElementById("gridMonForms").addRow(oTr);
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}
//----------------------------------------
//---- Funciones de estados de entidad
//----------------------------------------
function btnAddStatus_click() {
	var rets = openModal("/programs/modals/status.jsp",500,300);
	var added = false;
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				
				trows=document.getElementById("gridStatus").rows;
				for (i=0;i<trows.length && addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
						addRet = false;
					}
				}
				
				if (addRet) {
					added = true;
					
					var oTd0 = document.createElement("TD"); 
					var oTd1 = document.createElement("TD"); 
					
					oTd0.innerHTML = "<input type='checkbox' name='chkStatusSel'><input type='hidden' name='chkStatus'><input type='hidden' name='staName'>";
					oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
					oTd0.getElementsByTagName("INPUT")[2].value = ret[1];
					oTd0.align="center";
					
					oTd1.innerHTML = ret[1];
					
					var oTr = document.createElement("TR");
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					document.getElementById("gridStatus").addRow(oTr);
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
	/*if (window.navigator.appVersion.indexOf("MSIE")<0){
		var aux=rets.document;
		var isOpen=true;
		rets.onunload=function(event){
			event.cancelBubble=true;
			if(!isOpen){
				doAfter(rets.returnValue);
			}
			isOpen=false;
	    }
    }else{
		doAfter(rets);
	}*/
}

function btnDelStatus_click() {
	var rows = document.getElementById("gridStatus").selectedItems;
	var fixedStatus = "";
	for(var i = 0; i < rows.length; i++) {
		var firstChild = rows[i].getElementsByTagName("TD")[1].firstChild;
		
		if(rows[i].getAttribute("fixed_ent") == "true") {
			var firstChild = rows[i].getElementsByTagName("TD")[1].firstChild;
			if(firstChild.nodeValue == null)
				fixedStatus += " " + firstChild.firstChild.nodeValue;
			else
				fixedStatus += " " + firstChild.nodeValue; 
			continue;
		} else {
			document.getElementById("gridStatus").deleteElement(rows[i]);
		}
	}
	
	if(fixedStatus != ""){
		alert(MSG_USED_STATUS + fixedStatus);
	}
	//var cant = document.getElementById("gridStatus").removeSelected();
}

//-----------------------------------
//---- Fcuniones de procesos
//-----------------------------------
function btnAddProc_click() {
	var rets = openModal("/programs/modals/processes.jsp?getAll=false",500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				
				trows=document.getElementById("gridProcesses").rows;
				for (i=0;i<trows.length & addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
						addRet = false;
					}
				}
				
			if (addRet) {
				var oTd0 = document.createElement("TD"); 
				var oTd1 = document.createElement("TD"); 
			
					oTd0.innerHTML = "<input type='checkbox' name='chkProcSel'><input type='hidden' name='chkProc'><input type='hidden' name='hidProVerId'>";
					oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
					oTd0.getElementsByTagName("INPUT")[2].value = ret[2];
					oTd0.align="center";
					
					oTd1.innerHTML = ret[1];
					
					var oTr = document.createElement("TR");
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					document.getElementById("gridProcesses").addRow(oTr);
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
	/*if (window.navigator.appVersion.indexOf("MSIE")<0){
		var aux=rets.document;
		var isOpen=true;
		rets.onunload=function(event){
			event.cancelBubble=true;
			if(!isOpen){
				doAfter(rets.returnValue);
			}
			isOpen=false;
	    }
    }else{
		doAfter(rets);
	}*/	
}

function btnDelProc_click() {
	document.getElementById("gridProcesses").removeSelected();
}

//---------------------------------
//-- Funciones para el template
//---------------------------------
function btnViewTemplate() {
    tmpl = document.getElementById("txtTemplate").value;

	if (document.getElementById("txtTemplate").selectedIndex == document.getElementById("txtTemplate").options.length-1) {
		tmpl = document.getElementById("customTemplate").value;
	}

    if (tmpl == "") {
	    tmpl = "/templates/entityDefault.jsp";
    }
    
	openModal("/programs/modals/templateTest.jsp?template="+escape(tmpl),600,500);
}

function changeTemplate() {
	if (document.getElementById("txtTemplate").value=="<CUSTOM>") {
		document.getElementById("customTemplate").disabled=false;
		document.getElementById("customTemplate").style.display = "";
	} else if (!document.getElementById("customTemplate").disabled) {
		document.getElementById("customTemplate").disabled=true;
		document.getElementById("customTemplate").style.display = "none";		
	}
}
		 
function onClickUsrAdm(){
	addRemoveUserForm();
	addRemoveLoginAttribute();
}

function addRemoveUserForm(){
	var rows=document.getElementById("gridForms").rows;
	var esta = false;
	if (rows.length > 0){
		for(var i=0;i<rows.length;i++){
			var input=rows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1];
			if(input.value==USRCREATION_FORM_ID){
				esta = true;
			}
		}
		if (esta == false){
			addUserForm();
		}else{
			removeUserForm();
		}
	}else{
		addUserForm();
	}
}

function addUserForm(){
	var oTd0 = document.createElement("TD"); 
	var oTd1 = document.createElement("TD"); 
	var oTd2 = document.createElement("TD");
						
	oTd0.innerHTML = "<input type='hidden' name='chkFormSel'><input type='hidden' name='chkForm'>";
	oTd0.getElementsByTagName("INPUT")[1].value = USRCREATION_FORM_ID;
	oTd0.align="center";
				
	oTd1.innerHTML = USRCREATION_FORM_NAME;
							
	oTd2.innerHTML = "<input type='checkbox' name='showForm1' value='true' checked>";
	oTd2.align="center";
					
	var oTr = document.createElement("TR");
	oTr.appendChild(oTd0);
	oTr.appendChild(oTd1);
	oTr.appendChild(oTd2);
							
	document.getElementById("gridForms").addRow(oTr);
}
function removeUserForm(){
	var rows=document.getElementById("gridForms").rows;
	for(var i=0;i<rows.length;i++){
		var input=rows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1];
		if(input.value==USRCREATION_FORM_ID){
			document.getElementById("gridForms").deleteElement(rows[i]);
		}
	}
}
function addRemoveLoginAttribute(){

	if (document.getElementById("hidAttId1").value != LOGIN_ATT_ID){

		//Lo elimino del combobox
		if (document.getElementById("hidAttId1").value != null){
			for(var i=0;i<document.getElementById("cmbAttText").options.length;i++){
				if(document.getElementById("cmbAttText").options[i].text== document.getElementById("txtAttName1").value){
					var opt=document.getElementById("cmbAttText").options[i];
					opt.parentNode.removeChild(opt);
				}
			}
		}

		//Agrego atributo login
		document.getElementById('hidAttId1').value = LOGIN_ATT_ID;
		document.getElementById('hidAttLabel1').value = LOGIN_ATT_LBL;
		document.getElementById('txtAttName1').value = LOGIN_ATT_NAME;

		//Agrego el atributo en el combobox
		option = document.createElement("OPTION"); 
		option.value = 0;
		option.text = document.getElementById('txtAttName1').value;
		document.getElementById("cmbAttText").options.add(option);
				
		//Oculto lupa y goma
//		setVisibilityLupaYGoma('hidden');
		document.getElementById('btnQuery1').style.visibility = "hidden";
		document.getElementById('eraser1').style.visibility = "hidden";
		
		//Selecciono el tipo admin entidad de Funcionalidad y lo pongo solo lectura
//		var cmb=document.getElementById("cmbType");
//		for(var i=0;i<cmb.options.length;i++){
//			if(cmb.options[i].value==ADMIN_FUNC){
//				cmb.selectedIndex=i;
//			}
//		}
//		cmb.disabled = true;
		
	}else{
		//Elimino atributo login
		document.getElementById('hidAttId1').value = "";
		document.getElementById('hidAttLabel1').value = "";
		document.getElementById('txtAttName1').value = "";
		//Elimino el atributo del combobox
		for(var i=0;i<document.getElementById("cmbAttText").options.length;i++){
			if(document.getElementById("cmbAttText").options[i].text== LOGIN_ATT_NAME){
				var opt=document.getElementById("cmbAttText").options[i];
				opt.parentNode.removeChild(opt);
			}
		}
		
		//Hago visible lupa y goma
//		setVisibilityLupaYGoma('visible');
		document.getElementById('btnQuery1').style.visibility = "visible";
		document.getElementById('eraser1').style.visibility = "visible";
		
		//Habilito el combo de tipo admin entidad
		//document.getElementById("cmbType").disabled = false;
		
	}
}

//function setVisibilityLupaYGoma(var val){
//	document.getElementById('btnQuery1').style.visibility = val;
//	document.getElementById('eraser1').style.visibility = val;
//}

//-------------------------------
//---- Funciones de solapa de Consultas Analiticas
//-------------------------------

function enableDisable(){
	if(document.getElementById('chkCreateCbe').checked){
		//Habilitamos todo
		document.getElementById('txtCbeName').p_required=true;
		document.getElementById('txtCbeName').disabled=false;
		document.getElementById('txtCbeTitle').p_required=true;
		document.getElementById('txtCbeTitle').disabled=false;
		document.getElementById('txtCbeDesc').disabled=false;
		document.getElementById('btnAddDim').disabled=false;
		document.getElementById('btnDelDim').disabled=false;
		document.getElementById('btnDupMeas').disabled=false;
		document.getElementById('btnAddMeas').disabled=false;
		document.getElementById('btnDelMeas').disabled=false;
		document.getElementById('btnAddCbePrf').disabled=false;
		document.getElementById('btnDelCbePrf').disabled=false;
		document.getElementById('btnAddNoAccPrf').disabled=false;
		document.getElementById('btnDelNoAccPrf').disabled=false;
		//document.getElementById('chkLodInMemAtStart').disabled=false;
		document.getElementById('btnEstTime').disabled=false;
		document.getElementById('dataLoad1').disabled=false;
		document.getElementById('dataLoad2').disabled=false;
	}else{
		if (confirm(MSG_DELETE_CUBE_CONFIRM)) {
			var widNames = getWidgetDependency();
			if (widNames == null || widNames == "null"){
				var cbeNames = getCubesDependency();
				if (cbeNames == null || cbeNames == "null"){
					if (borrarAllInBean()){
						document.getElementById('txtCbeName').p_required=false;
						document.getElementById('txtCbeName').disabled=true;
						document.getElementById('txtCbeName').value = "";
						document.getElementById('txtCbeTitle').p_required=false;
						document.getElementById('txtCbeTitle').disabled=true;
						document.getElementById('txtCbeTitle').value = "";
						document.getElementById('txtCbeDesc').disabled=true;
						document.getElementById('txtCbeDesc').value = "";
						document.getElementById('btnAddDim').disabled=true;
						document.getElementById('btnDelDim').disabled=true;
						document.getElementById('btnDupMeas').disabled=true;
						document.getElementById('btnAddMeas').disabled=true;
						document.getElementById('btnDelMeas').disabled=true;
						document.getElementById('btnAddCbePrf').disabled=true;
						document.getElementById('btnDelCbePrf').disabled=true;
						//document.getElementById('chkLodInMemAtStart').checked = false;
						//document.getElementById('chkLodInMemAtStart').disabled=true;
						document.getElementById('btnEstTime').disabled=true;
						document.getElementById('dataLoad1').disabled=true;
						document.getElementById('dataLoad2').disabled=true;
						borrarAllDimensions();
						borrarAllMeasures();
						borrarAllProfiles();
						borrarAllNoAccProfiles();
					}
				}else{
					alert(MSG_CBE_IN_USE_BY_CUBE.replace("<TOK1>", cbeNames));
					document.getElementById('chkCreateCbe').checked = true;
				}
			}else{
				alert(MSG_CBE_IN_USE_BY_WIDGET.replace("<TOK1>",widNames));
				document.getElementById('chkCreateCbe').checked = true;
			}
		}else{
			document.getElementById('chkCreateCbe').checked = true;
		}
	}
}

function getWidgetDependency(){
	var	http_request = getXMLHttpRequest();
	http_request.open('POST', "administration.EntitiesAction.do?action=getWidgetDeps"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	var str = "";
	http_request.send(str);
	    
	if (http_request.readyState == 4) {
		if (http_request.status == 200) {
		     if(http_request.responseText != "NOK"){
		         return http_request.responseText;
		     }else{
				     alert("ERROR");
	         }
    	} else {
        	 alert("Could not contact the server.");            
        }
	}
}

function getCubesDependency(){
	var	http_request = getXMLHttpRequest();
	http_request.open('POST', "administration.EntitiesAction.do?action=getCubeDeps"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	var str = "";
	http_request.send(str);
	    
	if (http_request.readyState == 4) {
		if (http_request.status == 200) {
		     if(http_request.responseText != "NOK"){
		         return http_request.responseText;
		     }else{
				     alert("ERROR");
	         }
    	} else {
        	 alert("Could not contact the server.");            
        }
	}
}

//btn: Agregar Dimensiones --> Agrega una dimension
function btnAddDimension_click() {
	
	//1- Mostramos el tree con formularios y atributos
	var rets = null;
	var rets = openModal("/administration.EntitiesAction.do?action=addAttDimension" + windowId,(getStageWidth()*.8),(getStageHeight()*.7));//ancho,largo
	var doLoad=function(rets){
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
							var trows=document.getElementById("gridDims").rows;
							for (i=0;i<trows.length && addDim;i++) {
								if (trows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[1].value == attId) {
									addDim = false;
								}
							}
							
							var row = trows.length;
							
							//3- Si no se habia agregado, agregamos el atributo seleccionado como dimension
							if (addDim) {
								var oTd0 = document.createElement("TD"); //oculto
								var oTd1 = document.createElement("TD"); //atributo
								var oTd2 = document.createElement("TD"); //tipo
								var oTd3 = document.createElement("TD"); //props
								var oTd4 = document.createElement("TD"); //Entidad Mapeo o levels de dimension tipo fecha
								
								var dimName = "DIMENSION" + (document.getElementById("gridDims").rows.length + 1);
							
								oTd0.innerHTML='<input type="hidden" name="chkSel" value="">';
								
								//Atributo
								var oInputAtt = "<input name='attDimName' disabled id='attDimName' style='width:90px;' value='"+ attName +"' title='" + attName + "' >";
								oInputAtt = oInputAtt + "<input type='hidden' name='hidAttId' value='"+ attId +"'>";
								oInputAtt = oInputAtt + "<input type='hidden' name='hidAttName' value='"+ attName +"'>";
								oInputAtt = oInputAtt + "<input type='hidden' name='hidAttType' value='"+ attType +"'>";
								oInputAtt = oInputAtt + "<input type='hidden' name='hidDimEntDwColId' value='0'>";
								oTd1.innerHTML = oInputAtt;
									
								var oSelectMed = "";
								
								if (attType=='S'){
									oTd2.innerHTML="STRING";
								}else if (attType == 'N'){
									oTd2.innerHTML="NUMERIC";
								}else{
									oTd2.innerHTML="DATE";
								}
								
								//Propiedades
								oTd3.innerHTML = "<span style=\"vertical-align;bottom;\">";
								oTd3.innerHTML += "<img title=\""+LBL_CLI_TO_PROPS+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE  + "/images/btn_mod.gif\" width=\"17\" height=\"16\" onclick=\"openPropModal(this)\" style=\"cursor:pointer;cursor:hand\">";
								oTd3.innerHTML += "</span>";
								oTd3.innerHTML += "<input type=\"hidden\" id=\"hidDimProp\" name=\"hidDimProp\" value=\""+ "" +"\">";
								
								//Nombre de la dimension
								oTd4.innerHTML = "<input type='text' name='txtDimName' maxlength='50' onchange='chkDimName(this)' value='" + dimName +"'>"; //--> Agregamos el disp name	
								
								if (attType=='S'||attType=='N'){
									oTd4.innerHTML += " <input type=\"hidden\" id=\"txtMapEntityId\" name=\"txtMapEntityId\" value=\""+ attMapEntId +"\">";
									if (attId > 0){
										oTd4.innerHTML += " <input type=\"text\" id=\"txtMapEntityName\" name=\"txtMapEntityName\" title=\""+MAP_ENTITY+ ": " + attMapEntName + "\" disabled value=\""+ attMapEntName +"\">";
										oTd4.innerHTML += "<span style=\"vertical-align:bottom;\">";
										oTd4.innerHTML += " <img title=\""+LBL_SEL_MAP_ENTITY+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE  + "/images/btn_mod.gif\" width=\"17\" height=\"16\" onclick=\"openEntModal(this)\" style=\"cursor:pointer;cursor:hand\">";
										oTd4.innerHTML += "<img title=\""+LBL_DEL_MAP_ENTITY+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE + "/images/eraser.gif\" width=\"17\" height=\"16\" onclick=\"btnRemMapEnt_click(this)\" style=\"cursor:pointer;cursor:hand\">";
										oTd4.innerHTML += " <input type=\"hidden\" id=\"hidAttTypeOriginal\" name=\"hidAttTypeOriginal\" value=\"STRING\">";
										oTd4.innerHTML += "</span>";
									}
								}else if (attType == 'D'){
									oTd4.innerHTML += "<span> | </span><span>" + LBL_YEAR + ":</span> <span><input type='checkbox' name='chkYear' checked='true' value=\"" + row + "\"></span>";
									oTd4.innerHTML += "<span> | </span><span>" + LBL_SEMESTER + ":</span> <span><input type='checkbox' name='chkSem' checked='true' value=\"" + row + "\"></span>";
									oTd4.innerHTML += "<span> | </span><span>" + LBL_TRIMESTER + ":</span> <span><input type='checkbox' name='chkTrim' value=\"" + row + "\"></span>";
									oTd4.innerHTML += "<span> | </span><span>" + LBL_MONTH + ":</span> <span><input type='checkbox' name='chkMonth' checked='true' value=\"" + row + "\"></span>";
									oTd4.innerHTML += "<span> | </span><span>" + LBL_WEEKDAY + ":</span> <span><input type='checkbox' name='chkWeekDay' value=\"" + row + "\"></span>";
									oTd4.innerHTML +="<span> | </span><span>" + LBL_DAY + ":</span> <span><input type='checkbox' name='chkDay' value=\"" + row + "\"></span>";
									oTd4.innerHTML +="<span> | </span><span>" + LBL_HOUR + ":</span> <span><input type='checkbox' name='chkHour' value=\"" + row + "\"></span>";
									oTd4.innerHTML +="<span> | </span><span>" + LBL_MINUTE + ":</span> <span><input type='checkbox' name='chkMin' value=\"" + row + "\"></span>";
									oTd4.innerHTML +="<span> | </span><span>" + LBL_SECOND + ":</span> <span><input type='checkbox' name='chkSec' value=\"" + row + "\"></span>";
									oTd4.innerHTML += "<input type=\"hidden\" id=\"txtMapEntityId\" name=\"txtMapEntityId\" value=\""+ attMapEntId +"\">"											
								}
								var oTr = document.createElement("TR");
								
								oTr.appendChild(oTd0);
								oTr.appendChild(oTd1);
								oTr.appendChild(oTd2); //Se inserta este vacio para poner luego de seleccionado un atributo el tipo
								oTr.appendChild(oTd3);
								oTr.appendChild(oTd4);
								document.getElementById("gridDims").addRow(oTr);
								
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
					trows=document.getElementById("gridDims").rows;
					var i = 0;
					while (i<trows.length) {
						document.getElementById("gridDims").deleteElement(trows[i]);
					}
				}
			}
			if (strAttIds!=""){
				//Verificamos si se des-selecciono algun atributo que antes era dimension
				trows=document.getElementById("gridDims").rows;
				var i = 0;
				while (i<trows.length) {
					var attId = trows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[1].value;
					if (!inAttIds(strAttIds+"",attId)){ //se le agrega "" por si es un  valor solo, para transformarlo a string
						document.getElementById("gridDims").deleteElement(trows[i]);
					}else{
						i++;
					}
				}
			}else{//Debemos borrar todas las filas
				trows=document.getElementById("gridDims").rows;
				var i = 0;
				while (i<trows.length) {
					document.getElementById("gridDims").deleteElement(trows[i]);
				}
			}
			document.getElementById("txtHidAttIds").value = strAttIds;
		}
	}
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}

//btn: Agregar Medida --> Abrega una medida
function btnAddMeasure_click() {

	//1- Mostramos el tree con formularios y atributos
	var rets = null;
	var rets = openModal("/administration.EntitiesAction.do?action=addAttMeasure"+ windowId,(getStageWidth()*.8),(getStageHeight()*.7));//ancho,largo
	var doLoadMsr=function(rets){
		if (rets != null) {
			if (rets!="NOK"){
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
						var addMeas = true;
						
						//Guardamos el attId que se selecciono en el string attIds
						if (strAttIds == ""){
							strAttIds = attId;
						}else{
							strAttIds = strAttIds + "," + attId;
						}
						
						//2- Nos fijamos si ya no se agrego una medida con ese atributo (si se desea generar otra medida con ese atributo se debe duplicar)
						trows=document.getElementById("gridMeasures").rows;
						for (i=0;i<trows.length && addMeas;i++) {
							if (trows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[1].value == attId) {
								addMeas = false;
							}
						}
						
						//3- Si no se habia agregado, agregamos el atributo seleccionado como dimension
						if (addMeas) {
	
							/*
							Agregado de medidas: Hay dos tipos de medidas: Medidas comunes que utilizan una columna de la tabla de hechos y medidas calculadas que utilzan otras medidas
							*/
							
							// agregamos como tipo Measure por defecto
							
							var oTd0 = document.createElement("TD"); //oculto
							var oTd1 = document.createElement("TD"); //atributo
							var oTd2 = document.createElement("TD"); //nombre de la medida
							var oTd3 = document.createElement("TD"); //tipos de medida
							var oTd4 = document.createElement("TD"); //agregadores
							var oTd5 = document.createElement("TD"); //formato
							var oTd6 = document.createElement("TD"); //formula
							var oTd7 = document.createElement("TD"); //visible
							
							var measureName = "MEASURE" + (document.getElementById("gridMeasures").rows.length + 1);
								
							oTd0.innerHTML='<input type="hidden" name="chkSel" value="">';
						
							//Atributo
							var oInputAtt = "<input name='attMeaName' disabled id='attMeaName' style='width:150px;'  value='"+ attName +"' title='" + attName + "' >";
							oInputAtt = oInputAtt + "<input type='hidden' name='hidAttMeasId' value='"+ attId +"'>";
							oInputAtt = oInputAtt + "<input type='hidden' name='hidAttMeasName' value='"+ attName +"'>";
							oInputAtt = oInputAtt + "<input type='hidden' name='hidAttMeasType' value='"+ attType +"'>";
							oInputAtt = oInputAtt + "<input type='hidden' name='hidMeasEntDwColId' value='0'>";
							oTd1.innerHTML = oInputAtt;
									
							//Nombre a mostrar
							oTd2.innerHTML = "<input type='text' name='dispName' maxlength='50' onchange='chkMeasName(this)' value='" + measureName +"'>"; //--> Agregamos el disp name
								
							var oSelectMed = "";
							//Tipo de medida
							oSelectMed = "<select name='selTypeMeasure' onchange='changeMeasureType(this)'>";
							oSelectMed = oSelectMed + "<option value='0' selected>"+ LBL_MEAS_STANDARD + "</option>";
							oSelectMed = oSelectMed + "<option value='1'>"+ LBL_MEAS_CALCULATED + "</option>";
							oSelectMed = oSelectMed + "</select>";
							oTd3.innerHTML = oSelectMed; //--> Agregamos el combo con lo tipos de medidas
							//Opciones de agregador
							var oSelect = "<select name='selAgregator' style='display:block'>";
							if (attType == "S" || attType == "D"){
								oSelect = oSelect + "<option value='2'>COUNT</option>";
								oSelect = oSelect + "<option value='5'>DIST. COUNT</option>";
							}else{
								oSelect = oSelect + "<option value='0'>SUM</option>";
								oSelect = oSelect + "<option value='1'>AVG</option>";
								oSelect = oSelect + "<option value='2'>COUNT</option>";
								oSelect = oSelect + "<option value='3'>MIN</option>";	
								oSelect = oSelect + "<option value='4'>MAX</option>";
								oSelect = oSelect + "<option value='5'>DIST. COUNT</option>";
							}
							oSelect = oSelect + "</select>";
							
							oTd4.innerHTML = oSelect; //--> Agregamos el combo con los agregadores
							//Formato
							oTd5.innerHTML = "<input type='text' name='format' value='#,###.0'>"; //--> Agregamos el input formato
							//Formula
							oTd6.innerHTML = "<input type='text' name='formula'  onchange='chkFormula(this,null)' value='' size=40 style='display:none' title='[Measure1] [+,-,*,/] [Measure2 or Number] Ej: TotalCompras - TotalGastos'>"; //--> Agregamos el input formula
							
							var oTr = document.createElement("TR");
							
							oTr.appendChild(oTd0);
							oTr.appendChild(oTd1);
							oTr.appendChild(oTd2);
							oTr.appendChild(oTd3);
							oTr.appendChild(oTd4);
							oTr.appendChild(oTd5);
							oTr.appendChild(oTd6);
							oTr.appendChild(oTd7);
							
							document.getElementById("gridMeasures").addRow(oTr);
							
							var rowIndx = oTr.rowIndex - 1;
							
							//Visible
							oTd7.innerHTML = "<input type='checkbox' name='visible' value='"+ rowIndx + "' checked='true'>"; //--> Agregamos el checkbox visible
							
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

				} //end For
				document.getElementById("txtHidAttMeasureIds").value = strAttIds;
			} //end if (rets!="NOK")
		}// end if (rets != null) 
	}//end doLoad=function
	rets.onclose=function(){
		doLoadMsr(rets.returnValue);
	}
}

function inAttIds(attIds, attId){
	if (attIds!=""){
		var posSep = attIds.indexOf(",");
		while (posSep>0){
			var actual = attIds.substring(0,posSep);
			if (actual == attId){
				return true;
			}else{
				attIds = attIds.substring(posSep+1, attIds.length);
			}
			posSep = attIds.indexOf(",");
		}
		if (attIds == attId){
			return true;
		}
	}
	return false;
}

//btn: Agregar Dimensions --> Agrega una dimension
/*
function btnAddAttInfoAsDimension_click() {
		
		var oTd0 = document.createElement("TD"); 
		var oTd1 = document.createElement("TD");
		var oTd2 = document.createElement("TD");
		var oTd3 = document.createElement("TD");
		
		var dimName = "DIMENSION" + (document.getElementById("gridDims").rows.length + 1);
	
		oTd0.innerHTML='<input type="hidden" name="chkSel" value="">';
		
		//Atributo
		var oInputAtt = "<input name='attDimName' disabled id='attDimName' style='width:110px;'>";
		oInputAtt = oInputAtt + "<span style=\"vertical-align:bottom;\">";	
		oInputAtt = oInputAtt + "<img title=\""+LBL_SEL_ATTRIBUTE+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE  + "/images/btn_mod.gif\" width=\"17\" height=\"16\" onclick=\"openAttDimModal(this)\" style=\"cursor:pointer;cursor:hand\">";
		oInputAtt = oInputAtt + "</span>";
		oInputAtt = oInputAtt + "<input type='hidden' name='hidAttId' value=''>";
		oInputAtt = oInputAtt + "<input type='hidden' name='hidAttName' value=''>";
		oInputAtt = oInputAtt + "<input type='hidden' name='hidAttType' value=''>";
		oInputAtt = oInputAtt + "<input type='hidden' name='hidDimEntDwColId' value='0'></input>";
		oTd1.innerHTML = oInputAtt;
			
		var oSelectMed = "";
				
		//Nombre de la dimension
		oTd3.innerHTML = "<input type='text' name='txtDimName' onchange='chkDimName(this)' value='" + dimName +"'>"; //--> Agregamos el disp name	
		
		var oTr = document.createElement("TR");
		
		oTr.appendChild(oTd0);
		oTr.appendChild(oTd1);
		oTr.appendChild(oTd2); //Se inserta este vacio para poner luego de seleccionado un atributo el tipo
		oTr.appendChild(oTd3);
		
		document.getElementById("gridDims").addRow(oTr);
		document.getElementById("gridDims").selectElement(oTr);
		
		cubeChanged();//Marcamos como que el cubo se modifico estructuralmente
		
		return oTr;
}
*/
function chkMeasName(obj){
	var name = obj.value;
	var cant = 0;
	if (isValidMeasureName(name)){
		if (document.getElementById("gridMeasures").selectedItems.length >= 0){
			trows=document.getElementById("gridMeasures").rows;
			for (i=0;i<trows.length;i++) {
				if (trows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value == name) {
					if (cant==1){
						alert(MSG_ALR_EXI_MEAS);		
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

//Verifica si la formula es correcta
// formatos posibles: Measure op Measure, Measure op NUMBER
function chkFormula(obj, measName){
	
	//1. Hallamos la medida 1, el operarador y la medida2 (o number)
	var formula = obj.value;
	if (formula == ""){
		alert(MSG_MUST_ENTER_FORMULA);
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
			alert(formula + ": " + MSG_MEAS_OP1_NAME_INVALID);
		}else {
			alert(meas1 + ": " + MSG_MEAS_OP1_NAME_INVALID);
		}
		obj.focus();		
		return false;
	}
	
	//3. Verificamos el operador sea valido
	if (op != '/' && op != '-' && op != '+' && op != '*'){
		alert(op + ": " + MSG_OP_INVALID);
		obj.focus();
		return false;
	}
	
	//4. Verificamos la medida2 exista
	if (!chkMeasExist(meas2)){//Si no existe como medida talvez sea un numero
		if (isNaN(meas2)){
			alert(meas2 + ": " + MSG_MEAS_OP2_NAME_INVALID);
			obj.focus();
			return false;
		}
	}
	
	//5. Verificamos no se utilice el nombre de la propia medida como un operando de la formula.
	if (measName == meas1 || measName == meas2){
		alert(measName + ": " + MSG_MEAS_NAME_LOOP_INVALID);
		obj.focus();
		return false;
	}
	
	return true;
}

//Verifica si la medida usada en una formula es valida
function chkMeasExist(measure){
	if (document.getElementById("gridMeasures").selectedItems.length >= 0){
		trows=document.getElementById("gridMeasures").rows;
		for (i=0;i<trows.length;i++) {
			if (trows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value == measure) {
				return true;
			}
		}
	}else{
		return false;		
	}

	return false;
}

function chkDimName(obj){
	var name = obj.value;
	var cant = 0;
	if (isValidDimensionName(name)){
		if (document.getElementById("gridDims").selectedItems.length >= 0){
			trows=document.getElementById("gridDims").rows;
			for (i=0;i<trows.length;i++) {
				if (trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].value == name) {
					if (cant==1){
						alert(MSG_ALR_EXI_DIM);		
						trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].value = '';
						trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].focus();
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

//btn: Duplicar medida
function btnDupMeasure_click() {
	var trows=document.getElementById("gridMeasures").rows;
	if (trows.length>0 && document.getElementById("gridMeasures").selectedItems.length == 1){
			var selItem = document.getElementById("gridMeasures").selectedItems[0].rowIndex-1;
			if (selItem<0){
				alert(MSG_MUST_SEL_MEAS_FIRST);
				return;
			}
			
			var cmbMeasType = trows[selItem].getElementsByTagName("TD")[3].getElementsByTagName("SELECT")[0];
			var measType = cmbMeasType.options[cmbMeasType.selectedIndex].value;
			var attId = "";
			var attName = "";
			var attLbl = "";
			var attType = "";
			var attMapEntId = "";
			if (measType == "0"){ //Si es una medida estandard
				attId = trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[1].value;
				attName = trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[2].value;
				attLbl = trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[2].value;
				attType = trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[3].value;
				attMapEntId = trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[4].value;
			}
			var measureName = trows[selItem].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value;
			var cmbMeasFunc = trows[selItem].getElementsByTagName("TD")[4].getElementsByTagName("SELECT")[0];
			var measFunc = cmbMeasFunc.options[cmbMeasFunc.selectedIndex].value;
			var measFormat = trows[selItem].getElementsByTagName("TD")[5].getElementsByTagName("INPUT")[0].value;
			var measFormul = trows[selItem].getElementsByTagName("TD")[6].getElementsByTagName("INPUT")[0].value;
			var measVis = trows[selItem].getElementsByTagName("TD")[7].getElementsByTagName("INPUT")[0].checked;
			
			var oTd0 = document.createElement("TD"); //oculto
			var oTd1 = document.createElement("TD"); //atributo
			var oTd2 = document.createElement("TD"); //nombre de la medida
			var oTd3 = document.createElement("TD"); //tipos de medida
			var oTd4 = document.createElement("TD"); //agregadores
			var oTd5 = document.createElement("TD"); //formato
			var oTd6 = document.createElement("TD"); //formula
			var oTd7 = document.createElement("TD"); //visible
			
			oTd0.innerHTML='<input type="hidden" name="chkSel" value="">';
			
			//Atributo
			var oInputAtt = "";
			if (measType == "0"){
				oInputAtt = "<input name='attMeaName' disabled id='attMeaName' style='width:150px;'  value='"+ attName +"' title='" + attName + "' >";
				oInputAtt = oInputAtt + "<input type='hidden' name='hidAttMeasId' value='"+ attId +"'>";
				oInputAtt = oInputAtt + "<input type='hidden' name='hidAttMeasName' value='"+ attName +"'>";
				oInputAtt = oInputAtt + "<input type='hidden' name='hidAttMeasType' value='"+ attType +"'>";
				oInputAtt = oInputAtt + "<input type='hidden' name='hidMeasEntDwColId' value='0'>";
				oTd1.innerHTML = oInputAtt;
			}else{
				oInputAtt = "<input name='attMeaName' disabled id='attMeaName' style='display:none;width:150px;'  value='' title='' >";
				oInputAtt = oInputAtt + "<input type='hidden' name='hidAttMeasId' value=''>";
				oInputAtt = oInputAtt + "<input type='hidden' name='hidAttMeasName' value=''>";
				oInputAtt = oInputAtt + "<input type='hidden' name='hidAttMeasType' value=''>";
				oInputAtt = oInputAtt + "<input type='hidden' name='hidMeasEntDwColId' value='0'>";
				oTd1.innerHTML = oInputAtt;
			}
					
			//Nombre a mostrar
			var newMeasureName = "MEASURE" + (document.getElementById("gridMeasures").rows.length + 1);
			oTd2.innerHTML = "<input type='text' name='dispName' maxlength='50' onchange='chkMeasName(this)' value='" + newMeasureName +"'>"; //--> Agregamos el disp name
				
			var oSelectMed = "";
			//Tipo de medida
			oSelectMed = "<select name='selTypeMeasure' onchange='changeMeasureType(this)'>";
			if (measType == "0"){
				oSelectMed = oSelectMed + "<option value='0' selected>"+ LBL_MEAS_STANDARD + "</option>";
				oSelectMed = oSelectMed + "<option value='1'>"+ LBL_MEAS_CALCULATED + "</option>";
			}else{
				oSelectMed = oSelectMed + "<option value='1' selected>"+ LBL_MEAS_CALCULATED + "</option>";
			}
			
			oSelectMed = oSelectMed + "</select>";
			oTd3.innerHTML = oSelectMed; //--> Agregamos el combo con lo tipos de medidas
			//Opciones de agregador
			var oSelect = "";
			if (measType == "0"){
				oSelect = "<select name='selAgregator' style='display:block'>";
			}else{
				oSelect = "<select name='selAgregator' style='display:none'>";
			}
			if (measFunc == "0"){
				oSelect = oSelect + "<option value='0' selected>SUM</option>";
			}else if (attType == "N"){
				oSelect = oSelect + "<option value='0'>SUM</option>";
			}
			if (measFunc == "1"){
				oSelect = oSelect + "<option value='1' selected>AVG</option>";
			}else if (attType == "N"){
				oSelect = oSelect + "<option value='1'>AVG</option>";
			}
			if (measFunc == "2"){
				oSelect = oSelect + "<option value='2' selected>COUNT</option>";
			}else{
				oSelect = oSelect + "<option value='2'>COUNT</option>";
			}
			if (measFunc == "3"){
				oSelect = oSelect + "<option value='3' selected>MIN</option>";	
			}else if (attType == "N"){
				oSelect = oSelect + "<option value='3'>MIN</option>";
			}
			if (measFunc == "4"){
				oSelect = oSelect + "<option value='4' selected>MAX</option>";
			}else if (attType == "N"){
				oSelect = oSelect + "<option value='4'>MAX</option>";
			}
			if (measFunc == "4"){
				oSelect = oSelect + "<option value='5' selected>DIST. COUNT</option>";
			}else{
				oSelect = oSelect + "<option value='5'>DIST. COUNT</option>";
			}
			oSelect = oSelect + "</select>";
			oTd4.innerHTML = oSelect; //--> Agregamos el combo con los agregadores
			//Formato
			if (measType == "0"){
				oTd5.innerHTML = "<input type='text' name='format' value='"+ measFormat +"'>"; //--> Agregamos el input formato
			}else{
				oTd5.innerHTML = "<input type='text' name='format' style='display:none' value='"+ measFormat +"'>"; //--> Agregamos el input formato
			}
			//Formula
			if (measType == "0"){
				oTd6.innerHTML = "<input type='text' name='formula'  onchange='chkFormula(this,null)' value='" + measFormul+ "' size=40 style='display:none' title='[Measure1] [+,-,*,/] [Measure2 or Number] Ej: TotalCompras - TotalGastos'>"; //--> Agregamos el input formula
			}else{
				oTd6.innerHTML = "<input type='text' name='formula'  onchange='chkFormula(this,null)' value='" + measFormul+ "' size=40 title='[Measure1] [+,-,*,/] [Measure2 or Number] Ej: TotalCompras - TotalGastos'>"; //--> Agregamos el input formula
			}
			
			var oTr = document.createElement("TR");
			
			oTr.appendChild(oTd0);
			oTr.appendChild(oTd1);
			oTr.appendChild(oTd2);
			oTr.appendChild(oTd3);
			oTr.appendChild(oTd4);
			oTr.appendChild(oTd5);
			oTr.appendChild(oTd6);
			oTr.appendChild(oTd7);
			
			document.getElementById("gridMeasures").addRow(oTr);
			
			var rowIndx = oTr.rowIndex - 1;
			
			//Visible
			if (measVis){
				oTd7.innerHTML = "<input type='checkbox' name='visible' value='"+ rowIndx + "' checked='true'>"; //--> Agregamos el checkbox visible
			}else{
				oTd7.innerHTML = "<input type='checkbox' name='visible' value='"+ rowIndx + "'>"; //--> Agregamos el checkbox visible		
			}
			
			var hidStr = document.getElementById("txtHidAttMeasureIds").value;
			if (hidStr==""){
				hidStr = attId;
			}else{
				hidStr = hidStr + "," + attId;
			}
			document.getElementById("txtHidAttMeasureIds").value = hidStr;
			
			cubeChanged();//Marcamos como que el cubo se modifico estructuralmente
	}else{
		alert(MSG_MUST_SEL_MEAS_FIRST);
	}
}
//btn: Eliminar Medida --> Elimina una medida
function btnDelMeasure_click() {
	if (document.getElementById("gridMeasures").selectedItems.length > 0){
		if (document.getElementById("gridMeasures").selectedItems.length == 1){
			var trows=document.getElementById("gridMeasures").rows;
			var selItem = document.getElementById("gridMeasures").selectedItems[0].rowIndex-1;
			var attId = trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[1].value;
			var dwName = trows[selItem].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value;
			if (attId != null && attId != ""){
				document.getElementById("txtHidAttMeasureIds").value = remFromString(document.getElementById("txtHidAttMeasureIds").value, attId,false);
			}
			
			//Eliminamos el objeto EntityDwColumnVo correspondiente de la collection del bean
			var	http_request = getXMLHttpRequest();
			var str = "&dwName="+dwName + "&forMeasure=true" + "&attId="+attId;
			http_request.open('POST', "administration.EntitiesAction.do?action=removeEntDwCol"+windowId, false);
			http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");

			http_request.send(str);
			if (http_request.readyState == 4) {
		   	   if (http_request.status == 200) {
		           if(http_request.responseText != "NOK"){
		              var result = http_request.responseText; 
		              if (result = "OK"){
		              	document.getElementById("gridMeasures").removeSelected(); //<-- Si todo salio bien removemos la medida de la grilla
		              }
		            }
		       }
		   }
		}else{
			alert(MSG_MUST_SEL_JUST_ONE);
		}
	}else{
		alert(MSG_MUST_SEL_MEAS_FIRST);
	}
}	

//btn: Eliminar Dimension --> Elimina una dimension
function btnDelDimension_click() {
	if (document.getElementById("gridDims").selectedItems.length > 0){
		if (document.getElementById("gridDims").selectedItems.length == 1){
			
			var trows=document.getElementById("gridDims").rows;
			var selItem = document.getElementById("gridDims").selectedItems[0].rowIndex-1;
			updateLvlRowIndex(selItem);
			var attId = trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[1].value;
			document.getElementById("txtHidAttIds").value = remFromString(document.getElementById("txtHidAttIds").value, attId,true);
			
			//Eliminamos el objeto EntityDwColumnVo correspondiente de la collection del bean
			var	http_request = getXMLHttpRequest();
			var str = "&attId="+attId + "&forDimension=true";
			http_request.open('POST', "administration.EntitiesAction.do?action=removeEntDwCol"+windowId, false);
			http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");

			http_request.send(str);
			if (http_request.readyState == 4) {
		   	   if (http_request.status == 200) {
		           if(http_request.responseText != "NOK"){
		              var result = http_request.responseText; 
		              if (result = "OK"){
		              	document.getElementById("gridDims").removeSelected(); //<-- Si todo salio bien removemos la dimension de la grilla
		              }
		            }
		       }
		   }
		}else{
			alert(MSG_MUST_SEL_JUST_ONE);
		}
	}else{
		alert(MSG_MUST_SEL_DIM_FIRST);
	}
}	

//Actualiza el value de todas las dimensiones de tipo fecha posteriores a la row pasada por parametro
function updateLvlRowIndex(rowIni){
	var trows=document.getElementById("gridDims").rows;
	for (var i=rowIni+1;i<trows.length;i++){
		if (trows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[3].value == "D"){
			var newRowId = trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[1].value - 1;
			trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[1].value = newRowId;
			trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[2].value = newRowId;
			trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[3].value = newRowId;
			trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[4].value = newRowId;
			trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[5].value = newRowId;
			trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[6].value = newRowId;															
			trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[7].value = newRowId;
			trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[8].value = newRowId;
			trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[9].value = newRowId;
		}
	}
}

//Funcion llamada cuando se cambia el atributo de la grilla de medidas (se cambia el nombre del atributo del input hidAttMeasName)
// y segun el tipo del atributo se filtran los tipos de agregador a mostrar
function changeMeasAtt(object){

//1. Cambiamos el valor del input hidAttMeasName
	var type = object.options[object.selectedIndex].getAttribute("attType");
	var father = object.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	var cells = father.cells;
	var inputName = cells[1].getElementsByTagName("INPUT")[1]; //input oculto que contiene el name
	var inputType=cells[1].getElementsByTagName("INPUT")[0]; //input oculto que contiene el type
	
	inputName.value=object.options[object.selectedIndex].text;//nombre del atributo
	inputType.value=type;
	
//2. Filtramos los agregadores según el tipo de atributo
	 //Si es numerico --> SUM, AVG, COUNT, MIN , MAX, DIST COUNT
	 //Si es string   --> COUNT, DIST COUNT
	 //Si es date     --> COUNT, DIST COUNT (MIN Y MAX? probar)
	
	var selAgregator=cells[4].getElementsByTagName("SELECT")[0];
	while(selAgregator.options.length>0){
		selAgregator.removeChild(selAgregator.options[0]);
	}
	if ("S" == type){ //Atributo de tipo String
	 	var opt1=document.createElement("OPTION");
	 	opt1.innerHTML="COUNT";
	 	opt1.value="2";
	 	var opt2=document.createElement("OPTION");
	 	opt2.innerHTML="DIST. COUNT";
	 	opt2.value="5";
	 	selAgregator.appendChild(opt1);
	 	selAgregator.appendChild(opt2);
	 }else if ("D" == type){//Atributo de tipo Date
	 	var opt1=document.createElement("OPTION");
	 	opt1.innerHTML="COUNT";
	 	opt1.value="2";
	 	var opt2=document.createElement("OPTION");
	 	opt2.innerHTML="DIST. COUNT";
	 	opt2.value="5";
	 	selAgregator.appendChild(opt1);
	 	selAgregator.appendChild(opt2);
	 }else { //Atributo de tipo Numerico
	    var opt0=document.createElement("OPTION");
	 	opt0.innerHTML="SUM";
	 	opt0.value="0";
	 	
	    var opt1=document.createElement("OPTION");
	 	opt1.innerHTML="AVG";
	 	opt1.value="1";
	 	
	 	var opt2=document.createElement("OPTION");
	 	opt2.innerHTML="COUNT";
	 	opt2.value="2";
	 	
	 	var opt3=document.createElement("OPTION");
	 	opt3.innerHTML="MIN";
	 	opt3.value="3";
	 	
	 	var opt4=document.createElement("OPTION");
	 	opt4.innerHTML="MAX";
	 	opt4.value="4";
	 	
	 	var opt5=document.createElement("OPTION");
	 	opt5.innerHTML="DIST. COUNT";
	 	opt5.value="5";
	 	
	 	selAgregator.appendChild(opt0);
	 	selAgregator.appendChild(opt1);
	 	selAgregator.appendChild(opt2);
	 	selAgregator.appendChild(opt3);
	 	selAgregator.appendChild(opt4);
	 	selAgregator.appendChild(opt5);
	 }
}

//Funcion llamada cuando se cambia el tipo de una medida
function changeMeasureType(object){
	var val = object.value;
	var father = object.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	if (val == 0){ //Measure
		var cells=father.cells;
		cells[6].getElementsByTagName("INPUT")[0].style.display='none'; //ocultamos formula
		//cells[1].getElementsByTagName("INPUT")[0].style.display='block'; //mostramos column
		//cells[1].getElementsByTagName("IMG")[0].style.display='block'; //mostramos imagen para abrir modal
		cells[1].getElementsByTagName("INPUT")[0].style.visibility='visible'; //mostramos column
		cells[4].getElementsByTagName("SELECT")[0].style.display='block'; //mostramos aggregator
		cells[5].getElementsByTagName("INPUT")[0].style.display='block'; //mostramos formato
		
	}else { //Calculated Member
		var cells=father.cells;
		cells[6].getElementsByTagName("INPUT")[0].style.display='block'; //mostramos formula
		//cells[1].getElementsByTagName("INPUT")[0].style.display='none'; //ocultamos column
		//cells[1].getElementsByTagName("IMG")[0].style.display='none'; //ocultamos imagen para abrir modal
		cells[1].getElementsByTagName("INPUT")[0].style.visibility='hidden'; //mostramos column
		cells[4].getElementsByTagName("SELECT")[0].style.display='none'; //ocultamos aggregator
		cells[5].getElementsByTagName("INPUT")[0].style.display='none'; //ocultamos formato
		
		//chgHidValue(object,"null");
	}
}

//Devuelve un string con el siguiente formato: "1-2-4-45-500" donde cada numero es un attId
function getAttIds(){
  	var str = "";
  	if (document.getElementById("hidAttId1").value != ""){
  		if (str == ""){
	  		str = document.getElementById("hidAttId1").value;
	  	}else{
	  		str = str + "-" + document.getElementById("hidAttId1").value;
	  	}
  	}
  	if (document.getElementById("hidAttId2").value != ""){
  		if (str == ""){
	  		str = document.getElementById("hidAttId2").value;
	  	}else{
	  		str = str + "-" + document.getElementById("hidAttId2").value;
	  	}
  	}
  	if (document.getElementById("hidAttId3").value != ""){
  		if (str == ""){
	  		str = document.getElementById("hidAttId3").value;
	  	}else{
	  		str = str + "-" + document.getElementById("hidAttId3").value;
	  	}
  	}
  	if (document.getElementById("hidAttId4").value != ""){
  		if (str == ""){
	  		str = document.getElementById("hidAttId4").value;
	  	}else{
	  		str = str + "-" + document.getElementById("hidAttId4").value;
	  	}
  	}
  	if (document.getElementById("hidAttId5").value != ""){
  		if (str == ""){
	  		str = document.getElementById("hidAttId5").value;
	  	}else{
	  		str = str + "-" + document.getElementById("hidAttId5").value;
	  	}
  	}
  	if (document.getElementById("hidAttId6").value != ""){
  		if (str == ""){
	  		str = document.getElementById("hidAttId6").value;
	  	}else{
	  		str = str + "-" + document.getElementById("hidAttId6").value;
	  	}
  	}
  	if (document.getElementById("hidAttId7").value != ""){
  		if (str == ""){
	  		str = document.getElementById("hidAttId7").value;
	  	}else{
	  		str = str + "-" + document.getElementById("hidAttId7").value;
	  	}
  	}
  	if (document.getElementById("hidAttId8").value != ""){
  		if (str == ""){
	  		str = document.getElementById("hidAttId8").value;
	  	}else{
	  		str = str + "-" + document.getElementById("hidAttId8").value;
	  	}
  	}
  	if (document.getElementById("hidAttId9").value != ""){
  		if (str == ""){
	  		str = document.getElementById("hidAttId9").value;
	  	}else{
	  		str = str + "-" + document.getElementById("hidAttId9").value;
	  	}
  	}
  	if (document.getElementById("hidAttId10").value != ""){
  		if (str == ""){
	  		str = document.getElementById("hidAttId10").value;
	  	}else{
	  		str = str + "-" + document.getElementById("hidAttId10").value;
	  	}
  	}
  	if (document.getElementById("hidAttIdNum1").value != ""){
  		if (str == ""){
	  		str = document.getElementById("hidAttIdNum1").value;
	  	}else{
	  		str = str + "-" + document.getElementById("hidAttIdNum1").value;
	  	}
  	}
  	if (document.getElementById("hidAttIdNum2").value != ""){
  		if (str == ""){
	  		str = document.getElementById("hidAttIdNum2").value;
	  	}else{
	  		str = str + "-" + document.getElementById("hidAttIdNum2").value;
	  	}
  	}
  	if (document.getElementById("hidAttIdNum3").value != ""){
  		if (str == ""){
	  		str = document.getElementById("hidAttIdNum3").value;
	  	}else{
	  		str = str + "-" + document.getElementById("hidAttIdNum3").value;
	  	}
  	}
  	if (document.getElementById("hidAttIdNum4").value != ""){
  		if (str == ""){
	  		str = document.getElementById("hidAttIdNum4").value;
	  	}else{
	  		str = str + "-" + document.getElementById("hidAttIdNum4").value;
	  	}
  	}
  	if (document.getElementById("hidAttIdNum5").value != ""){
  		if (str == ""){
	  		str = document.getElementById("hidAttIdNum5").value;
	  	}else{
	  		str = str + "-" + document.getElementById("hidAttIdNum5").value;
	  	}
  	}
  	if (document.getElementById("hidAttIdNum6").value != ""){
  		if (str == ""){
	  		str = document.getElementById("hidAttIdNum6").value;
	  	}else{
	  		str = str + "-" + document.getElementById("hidAttIdNum6").value;
	  	}
  	}
  	if (document.getElementById("hidAttIdNum7").value != ""){
  		if (str == ""){
	  		str = document.getElementById("hidAttIdNum7").value;
	  	}else{
	  		str = str + "-" + document.getElementById("hidAttIdNum7").value;
	  	}
  	}
  	if (document.getElementById("hidAttIdNum8").value != ""){
  		if (str == ""){
	  		str = document.getElementById("hidAttIdNum8").value;
	  	}else{
	  		str = str + "-" + document.getElementById("hidAttIdNum8").value;
	  	}
  	}
  	if (document.getElementById("hidAttIdDte1").value != ""){
  		if (str == ""){
	  		str = document.getElementById("hidAttIdDte1").value;
	  	}else{
	  		str = str + "-" + document.getElementById("hidAttIdDte1").value;
	  	}
  	}
	if (document.getElementById("hidAttIdDte2").value != ""){
  		if (str == ""){
	  		str = document.getElementById("hidAttIdDte2").value;
	  	}else{
	  		str = str + "-" + document.getElementById("hidAttIdDte2").value;
	  	}
  	}
  	if (document.getElementById("hidAttIdDte3").value != ""){
  		if (str == ""){
	  		str = document.getElementById("hidAttIdDte3").value;
	  	}else{
	  		str = str + "-" + document.getElementById("hidAttIdDte3").value;
	  	}
  	}  	
	if (document.getElementById("hidAttIdDte4").value != ""){
  		if (str == ""){
	  		str = document.getElementById("hidAttIdDte4").value;
	  	}else{
	  		str = str + "-" + document.getElementById("hidAttIdDte4").value;
	  	}
  	}
	if (document.getElementById("hidAttIdDte5").value != ""){
  		if (str == ""){
	  		str = document.getElementById("hidAttIdDte5").value;
	  	}else{
	  		str = str + "-" + document.getElementById("hidAttIdDte5").value;
	  	}
  	}
	if (document.getElementById("hidAttIdDte6").value != ""){
  		if (str == ""){
	  		str = document.getElementById("hidAttIdDte61").value;
	  	}else{
	  		str = str + "-" + document.getElementById("hidAttIdDte6").value;
	  	}
  	}  	  	
	return str;
}

//Devuelve un string con el siguiente formato: "frmId-frmId-...-frmId"
function getFrmIds(){
	var str ="";
	if (document.getElementById("gridForms").rows.length > 0){
		trows=document.getElementById("gridForms").rows;
		for (i=0;i<trows.length;i++) {
			if (str == ""){
	  			str = trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value;
	  		}else{
	  			str = str + "-" + trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value;
	  		}
		}
	}
	return str;
}

function getXMLHttpRequest(){

		var http_request = null;
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
	return http_request;
}

//verifica que sea un nombre valido
var reBIAlphanumeric = /^[a-zA-Z0-9_]*$/;
function isValidMeasureName(s){
	var x = reBIAlphanumeric.test(s);
	
	if(!x){
		alert(GNR_INVALID_NAME);
		return false;
	}
	return true;
}
function isValidDimensionName(s){
	var x = reBIAlphanumeric.test(s);
	
	if(!x){
		alert(GNR_INVALID_NAME);
		return false;
	}
	return true;
}

function btnAddProfile_click() {

	var rets = null;
	var rets = openModal("/administration.EntitiesAction.do?action=addProfile&attIds=" + windowId,500,300);//ancho,largo
	var doLoad=function(rets){
		if (rets != null) {
			if (rets != null) {
				for (j = 0; j < rets.length; j++) {
					var ret = rets[j];
					var addRet = true;
					
					trows=document.getElementById("gridProfiles").rows;
					for (i=0;i<trows.length && addRet;i++) {
						if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
							addRet = false;
						}
					}
					
					if (addRet) {
						var oTd0 = document.createElement("TD"); 
						var oTd1 = document.createElement("TD"); 
				
						oTd0.innerHTML = "<input type='checkbox' name='chkPrfSel'><input type='hidden' name='chkPrf'>";
						oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
						oTd0.align="center";
				
						if(ret[2]==1){
							oTd1.innerHTML = "<B>"+ret[1]+"</B>";			
						} else {
							oTd1.innerHTML = ret[1];			
						}
				
						var oTr = document.createElement("TR");
						oTr.appendChild(oTd0);
						oTr.appendChild(oTd1);
						document.getElementById("gridProfiles").addRow(oTr);
					}
				}
			}
		}
	}
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}

function btnDelProfile_click() {
	document.getElementById("gridProfiles").removeSelected();
}

function borrarAllInBean(){
	//Eliminamos los objetos EntityDwColumnVo correspondiente de la collection del bean
	var	http_request = getXMLHttpRequest();
	var str = "";
	http_request.open('POST', "administration.EntitiesAction.do?action=removeAllEntDwCol"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	
	http_request.send(str);
	if (http_request.readyState == 4) {
	   if (http_request.status == 200) {
	   		if(http_request.responseText != "NOK"){
				   var result = http_request.responseText; 
			       if (attsInfo = "OK"){
			       		return true;
				   }
			}
		}
	}
	
	return false;
}

function borrarAllMeasures(){
	trows=document.getElementById("gridMeasures").rows;
	var i = 0;
	while (i<trows.length) {
		document.getElementById("gridMeasures").deleteElement(trows[i]);
	}
}

function borrarAllDimensions(){
    trows=document.getElementById("gridDims").rows;
	var i = 0;
	while (i<trows.length) {
		document.getElementById("gridDims").deleteElement(trows[i]);
	}
}

function borrarAllProfiles(){
	trows=document.getElementById("gridProfiles").rows;
	var i = 0;
	while (i<trows.length) {
		document.getElementById("gridProfiles").deleteElement(trows[i]);
	}
}

function borrarAllNoAccProfiles(){
	trows=document.getElementById("gridNoAccProfiles").rows;
	var i = 0;
	while (i<trows.length) {
		document.getElementById("gridNoAccProfiles").deleteElement(trows[i]);
	}
}

function checkDimNames(){
	trows=document.getElementById("gridDims").rows;
	for (i=0;i<trows.length;i++) {
		var attId = trows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[1].value;
		var dimName = trows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].value;
		for (j=0;j<trows.length;j++){
			var attId2 = trows[j].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[1].value;
			var dimName2 = trows[j].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].value;
			if (attId != attId2 && dimName == dimName2){
				return false; //se repite el nombre de una dimension
			}
		}
	}
	return true; //no se repite el nombre de ninguna dimension
}

function checkMeasureNames(){
	trows=document.getElementById("gridMeasures").rows;
	for (i=0;i<trows.length;i++) {
		var rowId = i;
		var measName = trows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value;
		for (j=0;j<trows.length;j++){
			var measName2 = trows[j].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value;
			if (j != rowId && measName == measName2){
				return false; //se repite el nombre de una medida
			}
		}
	}
	return true; //no se repite el nombre de ninguna medida
}

function isValidCubeName(s){
var re = new RegExp("^[a-zA-Z0-9_.]+[^ ]*$");
//	var x = reAlphanumeric.test(s);
//	if(!x){
	if (!s.match(re)) {
		alert(MSG_CUBE_NAME_INVALID);
		return false;
	}
	return true;
}

function verifyCubeData() {
	if(document.getElementById('chkCreateCbe')!=null && document.getElementById('chkCreateCbe').checked){
		//Verificamos si ingreso nombre al cubo
		if (document.getElementById("txtCbeName").value==""){
			alert(MSG_MUST_ENT_CBE_NAME);
			return false;
		}
		if(!isValidCubeName(document.getElementById("txtCbeName").value)){
			return false;
		}
		//Verificamos si el nombre del cubo es único
		if (checkExistCubeName(document.getElementById("txtCbeName").value)){
			alert(MSG_CUBE_NAME_ALREADY_EXIST);
			return false;
		}
		//Verificamos si ingreso al menos una dimension
		if (document.getElementById("gridDims").rows.length < 1){
			alert(MSG_MUST_ENT_ONE_DIM);
			return false;
		}
		//Verificamos todas las dimensiones se llamen distinto
		if (!checkDimNames()){
			alert(MSG_DIM_NAME_UNIQUE);
			return false;
		}
		//Verificamos dimensiones
		var dimRows=document.getElementById("gridDims").rows;
		var someAttNoBasic = false;
		for(var i=0;i<dimRows.length;i++){
			var dimName=dimRows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].value;
			var attName = dimRows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value;
			var attId = dimRows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[1].value;
			if(attName == ""){//Verificamos que los nombres de los atributos no sean nulos
				alert(MSG_MIS_DIM_ATT);
				return false;
			}
			if (dimName == ""){//Verificamos que los nombres de las dimensiones no sean nulos
				alert(MSG_WRG_DIM_NAME);
				return false;
			}
			if (attId>0){
				someAttNoBasic = true;
			}
		}
		
		//Verificamos se haya ingresado almenos una dimension con un atributo
		//if (someAttNoBasic == false){
		//	alert(MSG_AT_LEAST_ONE_DIM_MUST_USE_ATT);
		//	return false;
		//}
				
		//Verificamos si ingreso al menos una medida
		if (document.getElementById("gridMeasures").rows.length < 1){
			alert(MSG_MUST_ENT_ONE_MEAS);
			return false;
		}
		
		//Verificamos todas las medidas se llamen distinto
		if (!checkMeasureNames()){
			alert(MSG_MEASURE_NAME_UNIQUE);
			return false;
		}
		
		//Verificamos medidas
		var meaRows=document.getElementById("gridMeasures").rows;
		var visible = false;
		for(var i=0;i<meaRows.length;i++){
			var meaName=meaRows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value;
			if (meaName == ""){//Verificamos que los nombres de las medidas no sean nulos
				alert(MSG_WRG_MEA_NAME);
				return false;
			}
			
			var cmb=meaRows[i].cells[3].getElementsByTagName("SELECT")[0];
			var measType = (cmb.options[cmb.selectedIndex].value);
			if (measType == 1){//Si es medida calculada verificamos la formula
				var measFormula = meaRows[i].getElementsByTagName("TD")[6].getElementsByTagName("INPUT")[0];
				if (!chkFormula(measFormula,meaName)){
					return false;
				}
			}else{
				var attName = meaRows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value;
				if (attName == ""){
					alert(MSG_MIS_MEA_ATT);
					return false;
				}
			}
			if (meaRows[i].getElementsByTagName("TD")[7].getElementsByTagName("INPUT")[0].checked){
				visible = true;
			}
		}
		
		if (!visible){
			alert(MSG_ATLEAST_ONE_MEAS_VISIBLE);
			return false;
		}
		/*
		//Verificamos si ingreso al menos un perfil
		if (document.getElementById("gridProfiles").rows.length < 1){
			alert(MSG_MUST_ENT_ONE_PRF);
			return false;
		}*/
		
		//9. Verificamos que si se agrego algun perfil para restringir sus dimensiones, se haya restringido alguna
		var i = 0;
		var prfs = "";
		var trows = document.getElementById("gridNoAccProfiles").rows;
		for (i=0;i<trows.length;i++){
			if ("true" == trows[i].getElementsByTagName("TD")[1].getAttribute("flagNew")){
				if (prfs==""){
					prfs = trows[i].getElementsByTagName("TD")[1].getAttribute("value");
				}else {
					prfs += ";" + trows[i].getElementsByTagName("TD")[1].getAttribute("value");
				}
				
			}
		}
		if (prfs!=""){
			if (prfs.indexOf(";")<0){
				var msg = MSG_PRF_NO_ACC_DELETED.replace("<TOK1>",prfs);
				if (!confirm(msg)){
					return false;
				}
			}else {
				var msg = MSG_PRFS_NO_ACC_DELETED.replace("<TOK1>",prfs);
				if (!confirm(msg)){
					return false;
				}
			}
		}
	}	
	return true;
}

function checkExistCubeName(cubeName,cubeId){
	var	http_request = getXMLHttpRequest();
	http_request.open('POST', "administration.EntitiesAction.do?action=checkExistCbeName"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	var str = "cubeName=" + cubeName;
	if (cubeId!=null && cubeId!=''){
		str = str + "&cubeId=" + cubeId;
	}
	http_request.send(str);
	    
	if (http_request.readyState == 4) {
		if (http_request.status == 200) {
		     if(http_request.responseText != "false"){
		         return true;
		     }else{
				 return false;
	         }
    	} else {
        	 alert("Could not contact the server.");            
        }
	}
}

function notInUseDimAtt(attId){
	var selected = document.getElementById("gridDims").selectedItems[0].rowIndex - 1;
	var notIn=true;
	var rows=document.getElementById("gridDims").rows;
	for(var i=0;i<rows.length;i++){
		var actId=rows[i].cells[1].getElementsByTagName("INPUT")[1].value;
		if(actId == attId && i!=selected){
			alert(MSG_ATT_IN_USE);
			return false;
		}
	}
	return notIn;
}

//Devuelve 1 si el atributo es utilizado en una dimension
//Devuelve 2 si el atributo es utilizado en una medida
//Devuelve 0 si el atributo no es utilizado en una dimension ni medida
function notInUseInCube(attId){

	if (document.getElementById("gridDims") != null && document.getElementById("gridMeasures")){
		var dimRows=document.getElementById("gridDims").rows;
		for(var i=0;i<dimRows.length;i++){
			var actAttId=dimRows[i].cells[1].getElementsByTagName("INPUT")[1].value;
			if(actAttId == attId){
				return 1;
			}
		}
		var dimMeas=document.getElementById("gridMeasures").rows;
		for(var i=0;i<dimMeas.length;i++){
			var actAttId=dimMeas[i].cells[1].getElementsByTagName("INPUT")[1].value;
			if(actAttId == attId){
				return 2;
			}
		}
	}
	return 0;
}

//Devuelve 1 si el formulario contiene un atributo utilizado en una dimension
//Devuelve 2 si el formulario contiene un atributo utilizado en una medida
//Devuelve 0 si el formulario no contiene ningun atributo utilizado en una dimension ni medida
function attsFrmInUseInCube(frmId){
	var attributes = getFrmAttributes(frmId);	//attributes = attId1;attId2;..;attIdN
	
	if (attributes!=""){
		var pos = attributes.indexOf(",");
		if (pos > 0){
			while (pos>0){
				var attId = attributes.substring(0,pos);
				var ret = notInUseInCube(attId);
				if (ret==0){
					attributes = attributes.substring(pos, attributes.length);
					pos = attributes.indexOf(",");
				}else{
					return ret;
				}
			}
		}else{
			var ret = notInUseInCube(attributes);
			if (ret!=0){
				return ret;
			}
		}
	}
	return 0;
}

//Limpia todos los atributos del bean (pues se agrego o quito uno)
function clearAttributes(){
	var	http_request = getXMLHttpRequest();
	http_request.open('POST', "administration.EntitiesAction.do?action=clearAtts"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	var str = "";
	http_request.send(str);
	    
	if (http_request.readyState == 4) {
		if (http_request.status == 200) {
		     if(http_request.responseText != "NOK"){
		         return http_request.responseText;
		     }else{
				     alert("ERROR");
	         }
    	} else {
        	 alert("Could not contact the server.");            
        }
	}
}

//Devuelve los attributos de un formulario con el siguiente formato:<option value='3033' attType='S'>CLI_NOMBRE</option><option value='3034' attType='N'>CLI_COMPRAS</option><option value='3035' attType='D'>CLI_FECHACOMPRA</option>
function getFrmAttributes(frmId){
	var	http_request = getXMLHttpRequest();
	http_request.open('POST', "administration.EntitiesAction.do?action=getAtts"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	var str = "frmId=" + frmId;
	http_request.send(str);
	    
	if (http_request.readyState == 4) {
		if (http_request.status == 200) {
		     if(http_request.responseText != "NOK"){
		         return http_request.responseText;
		     }else{
				 alert("ERROR");
	         }
    	} else {
        	 alert("Could not contact the server.");            
        }
	}
}
/*
function openAttDimModal(obj) {

	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	var cells = father.cells;
	
	var rets = openModal("/programs/modals/atts.jsp?onlyOne=true",500,300);
	var td=obj.parentNode;
	while(td.tagName!="TD"){
		td=td.parentNode;
	}
		
	var doLoad=function(rets){
		if (rets != null) {
			var ret = rets[0];
			var attId = ret[0];
			var attName = ret[1];
			var attType = ret[3];
			var dimName = cells[3].getElementsByTagName("INPUT")[0].value;
			if (notInUseDimAtt(attId)){
				if (attType=='S'){
					cells[1].getElementsByTagName("INPUT")[0].value = attName;
					cells[1].getElementsByTagName("INPUT")[0].title = attName;
					cells[1].getElementsByTagName("INPUT")[1].value = attId;
					cells[1].getElementsByTagName("INPUT")[2].value = attName;
					cells[1].getElementsByTagName("INPUT")[3].value="S";
					cells[2].innerHTML = "STRING";
					cells[3].innerHTML = "<input type='text' name='txtDimName' onchange='chkDimName(this)' value='" + dimName +"'>"; //--> Agregamos el disp name	
					cells[3].innerHTML += " <input type=\"hidden\" id=\"txtMapEntityId\" name=\"txtMapEntityId\" value=\"\">";
					cells[3].innerHTML += " <input type=\"text\" id=\"txtMapEntityName\" name=\"txtMapEntityName\" title=\""+MAP_ENTITY+"\" disabled value=\"\">";
					cells[3].innerHTML += "<span style=\"vertical-align:bottom;\">";
					cells[3].innerHTML += " <img title=\""+LBL_SEL_MAP_ENTITY+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE  + "/images/btn_mod.gif\" width=\"17\" height=\"16\" onclick=\"openEntModal(this)\" style=\"cursor:pointer;cursor:hand\">";
					cells[3].innerHTML += "<img title=\""+LBL_DEL_MAP_ENTITY+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE + "/images/eraser.gif\" width=\"17\" height=\"16\" onclick=\"btnRemMapEnt_click(this)\" style=\"cursor:pointer;cursor:hand\">";
					cells[3].innerHTML += " <input type=\"hidden\" id=\"hidAttTypeOriginal\" name=\"hidAttTypeOriginal\" value=\"STRING\">";
					cells[3].innerHTML += "</span>";
					
				}else if (attType=='N'){
					cells[1].getElementsByTagName("INPUT")[0].value = attName;
					cells[1].getElementsByTagName("INPUT")[0].title = attName;
					cells[1].getElementsByTagName("INPUT")[1].value = attId;
					cells[1].getElementsByTagName("INPUT")[2].value = attName;
					cells[1].getElementsByTagName("INPUT")[3].value="N";
					cells[2].innerHTML = "NUMERIC";
					cells[3].innerHTML = "<input type='text' name='txtDimName' onchange='chkDimName(this)' value='" + dimName +"'>"; //--> Agregamos el disp name	
					cells[3].innerHTML += " <input type=\"hidden\" id=\"txtMapEntityId\" name=\"txtMapEntityId\" value=\"\">";
					cells[3].innerHTML += " <input type=\"text\" id=\"txtMapEntityName\" name=\"txtMapEntityName\" title=\""+MAP_ENTITY+"\" disabled value=\"\">";
					cells[3].innerHTML += " <img title=\""+LBL_SEL_MAP_ENTITY+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE  + "/images/btn_mod.gif\" width=\"17\" height=\"16\" onclick=\"openEntModal(this)\" style=\"cursor:pointer;cursor:hand\">";
					cells[3].innerHTML += "<img title=\""+LBL_DEL_MAP_ENTITY+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE + "/images/eraser.gif\" width=\"17\" height=\"16\" onclick=\"btnRemMapEnt_click(this)\" style=\"cursor:pointer;cursor:hand\">";
					cells[3].innerHTML += " <input type=\"hidden\" id=\"hidAttTypeOriginal\" name=\"hidAttTypeOriginal\" value=\"NUMERIC\">";
					cells[3].innerHTML += "</span>";
				}else if (attType=='D'){
					cells[1].getElementsByTagName("INPUT")[0].value = attName;
					cells[1].getElementsByTagName("INPUT")[0].title = attName;
					cells[1].getElementsByTagName("INPUT")[1].value = attId;
					cells[1].getElementsByTagName("INPUT")[2].value = attName;
					cells[1].getElementsByTagName("INPUT")[3].value="D";
					cells[2].innerHTML = "DATE";
					cells[3].innerHTML +="<span> | </span><span>" + LBL_YEAR + ":</span> <span><input type='checkbox' name='chkYear' checked='true'></span>";
					cells[3].innerHTML +="<span> | </span><span>" + LBL_SEMESTER + ":</span> <span><input type='checkbox' name='chkSem' checked='true'></span>";
					cells[3].innerHTML +="<span> | </span><span>" + LBL_TRIMESTER + ":</span> <span><input type='checkbox' name='chkTrim'></span>";
					cells[3].innerHTML +="<span> | </span><span>" + LBL_MONTH + ":</span> <span><input type='checkbox' name='chkMonth' checked='true'></span>";
					cells[3].innerHTML +="<span> | </span><span>" + LBL_WEEKDAY + ":</span> <span><input type='checkbox' name='chkWeekDay'></span>";
					cells[3].innerHTML +="<span> | </span><span>" + LBL_DAY + ":</span> <span><input type='checkbox' name='chkDay'></span>";
					cells[3].innerHTML +="<span> | </span><span>" + LBL_HOUR + ":</span> <span><input type='checkbox' name='chkHour'></span>";
					cells[3].innerHTML +="<span> | </span><span>" + LBL_MINUTE + ":</span> <span><input type='checkbox' name='chkMin'></span>";
					cells[3].innerHTML +="<span> | </span><span>" + LBL_SECOND + ":</span> <span><input type='checkbox' name='chkSec'></span>";
					cells[3].innerHTML += "<input type=\"hidden\" id=\"txtMapEntityId\" name=\"txtMapEntityId\" value=\"\">";
				}
			}
			cubeChanged(); //Marcamos como que el cubo se modifico estructuralmente
		}
	}
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}
*/

function openAttMeasModal(obj) {

	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	var cells = father.cells;
	
	var rets = openModal("/programs/modals/atts.jsp?onlyOne=true",500,300);
	var td=obj.parentNode;
	while(td.tagName!="TD"){
		td=td.parentNode;
	}
		
	var doLoad=function(rets){
		if (rets != null) {
			var ret = rets[0];
			var attId = ret[0];
			var attName = ret[1];
			var attType = ret[3];
			
			var selAgregator=cells[4].getElementsByTagName("SELECT")[0];
			while(selAgregator.options.length>0){
				selAgregator.removeChild(selAgregator.options[0]);
			}
			
			if ("S" == attType){ //Atributo de tipo String
				cells[1].getElementsByTagName("INPUT")[0].title = attName;
			 	var opt1=document.createElement("OPTION");
			 	opt1.innerHTML="COUNT";
			 	opt1.value="2";
			 	var opt2=document.createElement("OPTION");
			 	opt2.innerHTML="DIST. COUNT";
			 	opt2.value="5";
			 	selAgregator.appendChild(opt1);
			 	selAgregator.appendChild(opt2);
			 }else if ("D" == attType){//Atributo de tipo Date
	            cells[1].getElementsByTagName("INPUT")[0].title = attName;
			 	var opt1=document.createElement("OPTION");
			 	opt1.innerHTML="COUNT";
			 	opt1.value="2";
			 	var opt2=document.createElement("OPTION");
			 	opt2.innerHTML="DIST. COUNT";
			 	opt2.value="5";
			 	selAgregator.appendChild(opt1);
			 	selAgregator.appendChild(opt2);
			 }else { //Atributo de tipo Numerico
				 cells[1].getElementsByTagName("INPUT")[0].title = attName;
			    var opt0=document.createElement("OPTION");
			 	opt0.innerHTML="SUM";
			 	opt0.value="0";
			 	
			    var opt1=document.createElement("OPTION");
			 	opt1.innerHTML="AVG";
			 	opt1.value="1";
			 	
			 	var opt2=document.createElement("OPTION");
			 	opt2.innerHTML="COUNT";
			 	opt2.value="2";
				 	
			 	var opt3=document.createElement("OPTION");
			 	opt3.innerHTML="MIN";
			 	opt3.value="3";
				 	
			 	var opt4=document.createElement("OPTION");
			 	opt4.innerHTML="MAX";
			 	opt4.value="4";
	 	
			 	var opt5=document.createElement("OPTION");
		 		opt5.innerHTML="DIST. COUNT";
		 		opt5.value="5";
	 	
			 	selAgregator.appendChild(opt0);
		 		selAgregator.appendChild(opt1);
			 	selAgregator.appendChild(opt2);
			 	selAgregator.appendChild(opt3);
		 		selAgregator.appendChild(opt4);
			 	selAgregator.appendChild(opt5);
			 }
				
			td.getElementsByTagName("INPUT")[0].value = attName;
			td.getElementsByTagName("INPUT")[1].value = attId;
			td.getElementsByTagName("INPUT")[2].value = attName;
			td.getElementsByTagName("INPUT")[3].value = attType;
			
			cubeChanged(); //Marcamos como que el cubo se modifico estructuralmente
		}
	}
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}

function openEntModal(obj) {
	var rets = null;
	rets = openModal("/programs/modals/entities.jsp?envId="+envId,500,400);
	var td=obj.parentNode;
	while(td.tagName!="TD"){
		td=td.parentNode;
	}
	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	var cells = father.cells;
	var doLoad=function(rets){
		if (rets != null) {
			var ret = rets[0];
			td.getElementsByTagName("INPUT")[1].value = ret[0];
			td.getElementsByTagName("INPUT")[2].value = ret[1];
			cells[1].getElementsByTagName("INPUT")[3].value="S";
			cells[2].innerHTML = "STRING";
			
			cubeChanged(); //Marcamos como que el cubo se modifico estructuralmente
		}
	}
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}

function openPropModal(obj) {
	
	var td=obj.parentNode;
	while(td.tagName!="TD"){
		td=td.parentNode;
	}
	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	var cells = father.cells;
	
	var rets = null;
	var inptAllMemName = cells[3].getElementsByTagName("input")[0];
	var allMembName = LBL_TOD;
	if (inptAllMemName.value != ""){
		allMembName = inptAllMemName.value;
	}
	
	var props = allMembName;
	//Si hay mas props las separamos por ;
	rets = openModal("/programs/modals/dimProps.jsp?props="+props,(getStageWidth()*.4),(getStageHeight()*.3));
	
	var doLoad=function(rets){
		if (rets != null) {
			document.getElementById("hidCbeChanged").value = "true"; //Indicamos que se modifico algo del cubo
			
			var prpsArr = rets.split(";");
			inptAllMemName.value = prpsArr[0]; //Nombre de la agrupación
		}
	}
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}

function btnRemMapEnt_click(obj){
	var td=obj.parentNode;
	while(td.tagName!="TD"){
		td=td.parentNode;
	}
	td.getElementsByTagName("INPUT")[1].value = "";
	td.getElementsByTagName("INPUT")[2].value = "";
	
	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	/*
	var cells = father.cells;
	cells[2].innerHTML = td.getElementsByTagName("INPUT")[2].value;
	if (td.getElementsByTagName("INPUT")[2].value == "NUMERIC"){
		cells[1].getElementsByTagName("INPUT")[2].value="N";
	}else if (td.getElementsByTagName("INPUT")[2].value == "STRING"){
		cells[1].getElementsByTagName("INPUT")[2].value="S";	
	}else{
		cells[1].getElementsByTagName("INPUT")[2].value="D";	
	}
	*/
	cubeChanged(); //Marcamos como que el cubo se modifico estructuralmente
}

function changeRadFact(val){
	if (val == 1){
		document.getElementById("radSelected").value = 1;
		document.getElementById("txtFchIni").disabled=true;
		document.getElementById("txtHorIni").disabled=true;
		document.getElementById("txtFchIni").p_required=false;
		document.getElementById("txtHorIni").p_required=false;
		document.getElementById("btnEstTime").disabled=false;
	}else if (val == 2){
		document.getElementById("radSelected").value = 2;
		document.getElementById("txtFchIni").disabled=false;
		document.getElementById("txtHorIni").disabled=false;
		document.getElementById("txtFchIni").p_required=true;
		document.getElementById("txtHorIni").p_required=true;
		document.getElementById("btnEstTime").disabled=true;
	}
}

function btnEstTime_click(){
	if (verifyCubeDataToEstimateTime()){
		var	http_request = getXMLHttpRequest();
		http_request.open('POST', "administration.EntitiesAction.do?action=estimateTime"+windowId, false);
		http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
		var str = getAttIdsSelected();
		if (str == ""){
			alert("Must complete cube first");
		}else{ 
			http_request.send(str);
			    
			if (http_request.readyState == 4) {
				if (http_request.status == 200) {
				     if(http_request.responseText != "NOK"){
				         return alert(http_request.responseText);
				     }else{
						    alert("ERROR");
			         }
		    	} else {
		        	 alert("Could not contact the server.");            
		        }
			}
		}
	}
}

function verifyCubeDataToEstimateTime(){
	//Verificamos si ingreso al menos dos dimensiones
		if (document.getElementById("gridDims").rows.length < 2){
			alert(MSG_MUST_ENT_TWO_DIMS);
			return false;
		}
		
		//Verificamos dimensiones
		var dimRows=document.getElementById("gridDims").rows;
		for(var i=0;i<dimRows.length;i++){
			var dimName=dimRows[i].getElementsByTagName("TD")[4].getElementsByTagName("INPUT")[0].value;
			var attName = dimRows[i].cells[1].getElementsByTagName("INPUT")[0];
			if(attName == ""){//Verificamos que los nombres de los atributos no sean nulos
				alert(MSG_MIS_DIM_ATT);
				return false;
			}
			if (dimName == ""){//Verificamos que los nombres de las dimensiones no sean nulos
				alert(MSG_WRG_DIM_NAME);
				return false;
			}
		}
				
		//Verificamos si ingreso al menos una medida
		if (document.getElementById("gridMeasures").rows.length < 1){
			alert(MSG_MUST_ENT_ONE_MEAS);
			return false;
		}
		
		//Verificamos medidas
		var meaRows=document.getElementById("gridMeasures").rows;
		for(var i=0;i<meaRows.length;i++){
			//Verificamos haya seleccionado atributos en las medidas estandard			
			var cmb=meaRows[i].cells[3].getElementsByTagName("SELECT")[0];
			var measType = (cmb.options[cmb.selectedIndex].value);
			if (measType == 0){//Si es medida calculada verificamos la formula
				var attName = meaRows[i].cells[1].getElementsByTagName("INPUT")[0];
				if(attName == ""){//Verificamos que los nombres de los atributos no sean nulos
					alert(MSG_MIS_MEA_ATT);
					return false;
				}
			}
		}
		return true;
}

function getAttIdsSelected(){
  	var str = "";
  	var mapAtts = 0;
  	if (document.getElementById("gridDims") != null && document.getElementById("gridMeasures")!=null){
		var dimRows=document.getElementById("gridDims").rows;
		for(var i=0;i<dimRows.length;i++){
			var attId = dimRows[i].cells[1].getElementsByTagName("INPUT")[1].value;
			if (str == ""){
	  			str = "attId=" + attId;
		  	}else if (str.indexOf(attId)<0){
		  		str = str + "&attId=" + attId;
	  		}
	  		if (dimRows[i].cells[1].getElementsByTagName("INPUT")[3].value != "D"){
		  		var map=dimRows[i].cells[4].getElementsByTagName("INPUT")[1].value;
		  		
		  	}else{
		  		var map=dimRows[i].cells[4].getElementsByTagName("INPUT")[10].value;
		  	}
	  		if (map != "" && map != "on"){
	  			mapAtts++;
		  	}
		}
		var dimMeas=document.getElementById("gridMeasures").rows;
		for(var i=0;i<dimMeas.length;i++){
			var attId=dimMeas[i].cells[1].getElementsByTagName("INPUT")[1].value;
			if (str == ""){
	  			str = "attId=" + attId;
		  	}else if (str.indexOf(attId)<0){
		  		str = str + "&attId=" + attId;
	  		}
		}
		str = str + "&mapAtts="+mapAtts;
	}
	return str;

}

function setCodiguera(){
	if(document.getElementById('chkCod').checked){
		//Agrego el atributo
		var oldValue = document.getElementById('txtAttName1').value;
		document.getElementById('hidAttId1').value = "13";
		document.getElementById('hidAttLabel1').value = attCodigueraLabel;
		document.getElementById('txtAttName1').value = attCodigueraLabel;
		
		document.getElementById('chkAttId1').checked = true;
		document.getElementById('imgUCAtt1EntNeg').style.visibility="visible";
		
		if(oldValue != null){
			for(var i = 0; i<document.getElementById("cmbAttText").options.length; i++){
				if(document.getElementById("cmbAttText").options[i].text == oldValue){
					document.getElementById("cmbAttText").options[i]=null;
				}	
			}
		}

		option = document.createElement("OPTION"); 
		option.value = 0;
		option.text = attCodigueraLabel;
		document.getElementById("cmbAttText").options.add(option);
		
		document.getElementById('btnQuery1').style.visibility = "hidden";
		document.getElementById('eraser1').style.visibility = "hidden";
		
		//Agrego el formulario
		var oTd0 = document.createElement("TD"); 
		var oTd1 = document.createElement("TD"); 
		var oTd2 = document.createElement("TD");

		oTd0.innerHTML = "<input type='checkbox' name='chkFormSel'><input type='hidden' name='chkForm'>";
		oTd0.getElementsByTagName("INPUT")[1].value = "2";
		oTd0.align="center";

		oTd1.innerHTML = frmCodigueraLabel;

		oTd2.innerHTML = "<input type='checkbox' name='showForm" + "2" + "' value='true' checked>";
		oTd2.align="center";

		var oTr = document.createElement("TR");
		oTr.appendChild(oTd0);
		oTr.appendChild(oTd1);
		oTr.appendChild(oTd2);
		
		document.getElementById("gridForms").addRow(oTr);
		
		//Agrego el formulario al monitor
		var oTd0 = document.createElement("TD"); 
		var oTd1 = document.createElement("TD"); 

		oTd0.innerHTML = "<input type='checkbox' name='chkMonFormSel'><input type='hidden' name='chkMonForm'>";
		oTd0.getElementsByTagName("INPUT")[1].value = "2";
		oTd0.align="center";

		oTd1.innerHTML = frmCodigueraLabel;

		var oTr = document.createElement("TR");
		oTr.appendChild(oTd0);
		oTr.appendChild(oTd1);
		
		document.getElementById("gridMonForms").addRow(oTr);
		
	}else{
		//elimino el atributo
		document.getElementById('hidAttId1').value = "";
		document.getElementById('hidAttLabel1').value = "";
		document.getElementById('txtAttName1').value = "";
		
		
		document.getElementById('chkAttId1').checked = false;
		document.getElementById('imgUCAtt1EntNeg').style.visibility="hidden";

		for(var i = 0; i<document.getElementById("cmbAttText").options.length; i++){
			if(document.getElementById("cmbAttText").options[i].text == attCodigueraLabel){
				document.getElementById("cmbAttText").options[i]=null;
			}
		}	
		
		document.getElementById('btnQuery1').style.visibility = "visible";
		document.getElementById('eraser1').style.visibility = "visible";
		
		//elimino el formulario
		var deleterow;
		for(var i = 0; i<document.getElementById("gridForms").rows.length; i++){
			if(document.getElementById("gridForms").rows[i].cells[0].getElementsByTagName("INPUT")[1].value == "2"){
				deleterow = document.getElementById("gridForms").rows[i];
			}	
		}
		if(deleterow != null){
			document.getElementById("gridForms").deleteElement(deleterow);
		}
	}
}

//Marcamos que el cubo se modifico estructuralmente
function cubeChanged(){
	document.getElementById("hidCbeChanged").value = "true";
}

function clickChk(obj) {
	if (obj.checked){
		cantSelected ++;
	}else{
		cantSelected --;
	}
	
	selected = obj;
	document.getElementById("btnDel").disabled = ! obj.checked;
	document.getElementById("btnUpd").disabled = false;
	clearData();

	document.getElementById("cmbTyp").disabled=false;

	if(obj.checked==false){
		return;
	}
	
	selectOneChk(obj);

	document.getElementById("txtNom").value 		= obj.getAttribute("node_name");
	document.getElementById("txtUrl").value 		= obj.getAttribute("node_url");	
	document.getElementById("txtToolTip").value	= obj.getAttribute("node_tooltip");	
	document.getElementById("cmbTyp").value		= obj.getAttribute("node_type");	
	document.getElementById("cmbFather").value	= obj.getAttribute("node_father_id");
	document.getElementById("hidFncId").value		= obj.getAttribute("node_id");
	document.getElementById("txtOrd").value		= obj.getAttribute("node_sibling_id");
	document.getElementById("cmbOpen").value		= obj.getAttribute("node_open");
	document.getElementById("hidFncGlobal").value	= obj.getAttribute("node_global");

	if (document.getElementById("hidFncGlobal").value == "1" && ! ADM_GLOBAL) {
		document.getElementById("txtNom").readOnly = true;
		document.getElementById("txtNom").className = "txtReadOnly";
		document.getElementById("txtToolTip").readOnly = true;
		document.getElementById("txtToolTip").className = "txtReadOnly";

		document.getElementById("txtUrl").readOnly = true;
		document.getElementById("txtUrl").className = "txtReadOnly";
		
		document.getElementById("cmbOpen").parentNode.style.display = "none";
		document.getElementById("txtOpen").value = document.getElementById("cmbOpen").options[document.getElementById("cmbOpen").selectedIndex].text
		document.getElementById("txtOpen").parentNode.style.display = "block";

		document.getElementById("cmbFather").style.display = "none";
		try{
			document.getElementById("txtFather").value = document.getElementById("cmbFather").options[document.getElementById("cmbFather").selectedIndex].text
		}catch(e){
			document.getElementById("txtFather").value = "";
		}

		document.getElementById("txtFather").style.display = "block";

		document.getElementById("txtTyp").value = document.getElementById("cmbTyp").options(document.getElementById("cmbTyp").selectedIndex).text
		document.getElementById("txtTyp").parentNode.style.display = "block";
		document.getElementById("cmbTyp").parentNode.style.display = "none";
		unsetRequiredField(document.getElementById("cmbTyp"));
 	
		document.getElementById("txtOrd").readOnly	= true;
		document.getElementById("txtOrd").className	= "txtReadOnly";
	
		document.getElementById("btnUpd").disabled = true;
		document.getElementById("btnDel").disabled = true;
		
	} else if(obj.getAttribute("node_type") == "F" || obj.getAttribute("node_group") != 4 ){
		document.getElementById("txtNom").readOnly = true;
		document.getElementById("txtNom").className = "txtReadOnly";
		document.getElementById("txtToolTip").readOnly = true;
		document.getElementById("txtToolTip").className = "txtReadOnly";

		document.getElementById("txtUrl").readOnly = true;
		document.getElementById("txtUrl").className = "txtReadOnly";
		
		document.getElementById("cmbOpen").parentNode.style.display = "none";
		document.getElementById("txtOpen").value = document.getElementById("cmbOpen").options[document.getElementById("cmbOpen").selectedIndex].text
		document.getElementById("txtOpen").parentNode.style.display = "block";

		if (! obj.getAttribute("node_dw") || obj.getAttribute("node_father_id") == ADM_FNC_FATHER) {
			document.getElementById("cmbFather").style.display = "none";
			try{
				document.getElementById("txtFather").value = document.getElementById("cmbFather").options(document.getElementById("cmbFather").selectedIndex).text
			}catch(e){
				document.getElementById("txtFather").value = "";
			}
			document.getElementById("txtFather").style.display = "block";
		}

		document.getElementById("txtTyp").value = document.getElementById("cmbTyp").options[document.getElementById("cmbTyp").selectedIndex].text
		document.getElementById("txtTyp").parentNode.style.display = "block";
		document.getElementById("cmbTyp").parentNode.style.display = "none";
		unsetRequiredField(document.getElementById("cmbTyp"));
	} 
	document.getElementById("cmbTyp").disabled=true;
}

//// FUNCIONES UTILIZADAS EN LA GRILLA DE PERFILES CON ACCESO RESTRINGIDO EN MODO VISUALIZADOR /////

function btnAddNoAccProfile_click() {
	var rets = null;
	rets = openModal("/programs/modals/profiles.jsp",500,300);
	var doLoad=function(rets){
		if (rets != null) {
			if (rets != null) {
				for (j = 0; j < rets.length; j++) {
					var ret = rets[j];
					var addRet = true;
					
					trows=document.getElementById("gridNoAccProfiles").rows;
					for (i=0;i<trows.length && addRet;i++) {
						if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
							addRet = false;
						}
					}
					
					if (addRet) {
						var oTd0 = document.createElement("TD"); 
						var oTd1 = document.createElement("TD"); 
						var oTd2 = document.createElement("TD");
				
						oTd0.innerHTML = "<input type='checkbox' name='chkPrfRestSel'><input type='hidden' name='chkPrfRest'>";
						oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
						oTd0.align="center";
				
						//if(ret[2]==1){
						//	oTd1.innerHTML = "<B>"+ret[1]+"</B>";			
						//} else {
							oTd1.innerHTML = ret[1];			
						//}
						oTd1.setAttribute("value",ret[1]);
						oTd1.setAttribute("flagNew","true");
				
						oTd2.innerHTML += "<span style=\"vertical-align:bottom;\">";
						oTd2.innerHTML += " <img title=\""+LBL_SEL_DIM_TO_DENIE_ACCESS+"\" src=\"" + rootPath + "/styles/" + GNR_CURR_STYLE  + "/images/btn_mod.gif\" width=\"17\" height=\"16\" onclick=\"openNoAccDims(this)\" style=\"cursor:pointer;cursor:hand\">";
						oTd2.innerHTML += "</span>";
		
						var oTr = document.createElement("TR");
						oTr.appendChild(oTd0);
						oTr.appendChild(oTd1);
						oTr.appendChild(oTd2);
						document.getElementById("gridNoAccProfiles").addRow(oTr);
					}
				}
			}
		}
	}
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}

function btnDelNoAccProfile_click() {
	var cant = chksChecked(document.getElementById("gridNoAccProfiles"));
	if(cant == 1) {
		var selPrfItem = document.getElementById("gridNoAccProfiles").selectedItems[0].rowIndex-1;
		var trows=document.getElementById("gridNoAccProfiles").rows;
		var prfName = trows[selPrfItem].getElementsByTagName("TD")[1].getAttribute("value");
		
		var frm=document.getElementById("frmMain");
		var action=frm.action;
		var target=frm.target;
		frm.action="administration.EntitiesAction.do?action=removeNoAccProfile"+windowId+"&prfName="+prfName;
		frm.target="gridCbePrfNoAcc";
		frm.submit();
		frm.action=action;
		frm.target=target;
		
		document.getElementById("gridNoAccProfiles").removeSelected();
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function openNoAccDims(obj) {
	//Para agregar un perfil de acceso restringido, se debe verificar previamente que el cubo tenga nombre
	if (document.getElementById("txtCbeName")==""){
		alert(MSG_CBE_NAME_MISS);
		return;
	}
	var selPrfItem = document.getElementById("gridNoAccProfiles").selectedItems[0].rowIndex-1;
	var trows=document.getElementById("gridNoAccProfiles").rows;
	var prfName = trows[selPrfItem].getElementsByTagName("TD")[1].getAttribute("value");
	trows[selPrfItem].getElementsByTagName("TD")[1].setAttribute("flagNew","false");
	
	var frm=document.getElementById("frmMain");
	var action=frm.action;
	var target=frm.target;
	frm.action="administration.EntitiesAction.do?action=loadDims"+windowId+"&after=openNoAccDimsModal&prfName="+prfName;
	frm.target="gridCbePrfNoAcc";
	frm.submit();
	frm.action=action;
	frm.target=target;
}

function openNoAccDimsModal(dims){
	var cbeName = document.getElementById("txtName").value; //pasamos el nombre del cubo por si se esta creando (en el servidor aún no esta el nombre)
	var selPrfItem = document.getElementById("gridNoAccProfiles").selectedItems[0].rowIndex-1;
	var trows=document.getElementById("gridNoAccProfiles").rows;
	var prfName = trows[selPrfItem].getElementsByTagName("TD")[1].getAttribute("value");

	var rets = null;
	rets = openModal("/programs/modals/setCubePermissions.jsp",500,400);
	var doLoad=function(rets){
		if (rets != null) {
			if (rets=="removeRow"){
				document.getElementById("gridNoAccProfiles").removeSelected();
			}
		}
	}
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
	
	rets.onload=function(){
		var ifr=this.getElementsByTagName("IFRAME")[0];
		window.parent.parent.parent.frames[ifr.name].setXml(dims,prfName,cbeName,"entityCube");
	}
}

//////////// FIN DE FUNCIONES DE PERFILES CON ACCIONES RESTRINGIDOS EN MODO VISUALIZADOR //////////////

//Elimina el valor pasado por parametro del string pasado por parametro
//Formato del string: valores separados por ;
function remFromString(str, value, all){
	var newStr = "";
	var pos = str.indexOf(",");
	while (pos>0){
		var val = str.substring(0,pos);
		if (val!=value){
			if (newStr == ""){
				newStr=val;
			}else{
				newStr=newStr+","+val;
			}
		}
		if (val==value && all==false){
			str=str.substring(pos+1,str.length);
			newStr = newStr + "," + str;
			return (newStr);
		}
		str=str.substring(pos+1,str.length);
		pos = str.indexOf(",");
	}
	if (str!=value){
		if (newStr == ""){
			newStr=str;
		}else{
			newStr=newStr+","+str;
		}
	}
	return newStr;
}

function openImagePicker(caller){
	var rets = openModal("/administration.ImagesAction.do?action=picker",560,300);
	var doAfter=function(rets){
		if(rets && rets.path && rets.id){
			var path=rets.path;
			var id=rets.id;
			caller.style.backgroundImage="url("+path+")";
			caller.firstChild.value=id;
		}else{
			caller.firstChild.value="";
			caller.style.backgroundImage="url("+URL_ROOT_PATH+"/images/uploaded/enticon.png)";
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function btnAddRelChild_click(){
	var oTd0 = document.createElement("TD"); 
	var oTd1 = document.createElement("TD"); 
	var oTd2 = document.createElement("TD");
	 
	
	oTd0.innerHTML = "<input type='text' req_desc=\""+LBLENT+"\" name='txtEntNameChild' p_required=\"true\">" ;
	//oTd0.children(0).value = ret[0];
	oTd0.align="center";
	
	oTd1.innerHTML = "<select name='txtEntNameChildRel'><option value=\"1\">1</option><option value=\"n\">N</option></select>";
	//oTd1.children(0).value = ret[1];
	oTd1.align="center";
	
	oTd2.innerHTML = "<input type='text' name='txtEntNameChildRelNameB'><input type='hidden' name='txtEntNameChildRelNameA'>";
	//oTd2.children(0).value = ret[2];
	oTd2.align="center";
 
	var oTr = document.createElement("TR");
	oTr.appendChild(oTd0);
	oTr.appendChild(oTd1);
	oTr.appendChild(oTd2);
	document.getElementById("gridEntVinChi").addRow(oTr);
}

function btnDelRelChild_click(){
	document.getElementById("gridEntVinChi").removeSelected();
}


function btnAddRelFather_click(){
	var oTd0 = document.createElement("TD"); 
	var oTd1 = document.createElement("TD"); 
	var oTd2 = document.createElement("TD");
	 
	
	oTd0.innerHTML = "<input type='text' req_desc=\""+LBLENT+"\"  name='txtEntNameFather' p_required=\"true\">" ;
	oTd0.align="center";
	
	oTd1.innerHTML = "<input type='text' name='txtEntNameFatherRel' readonly value=\"1\" class=\"txtReadOnly\">";
	oTd1.align="center";
	
	oTd2.innerHTML = "<input type='text' name='txtEntNameFatherRelNameA'><input type='hidden' name='txtEntNameFatherRelNameB'>";
	oTd2.align="center";
 
	var oTr = document.createElement("TR");
	oTr.appendChild(oTd0);
	oTr.appendChild(oTd1);
	oTr.appendChild(oTd2);
	document.getElementById("gridEntVinFat").addRow(oTr);
}

function btnDelRelFather_click(){
	document.getElementById("gridEntVinFat").removeSelected();
}

function verifyPermissions(){
	if (!document.getElementById("usePrjPerms").checked){ //Si no se usan los permisos del proyecto
		//Verificamos si almenos una persona tiene acceso de modificacion
		var permRows=document.getElementById("permGrid").rows;
		var someoneCanModify = false;
		for(var i=0;i<permRows.length;i++){
			var canModify= ("1" == permRows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[3].value);
			if(canModify){//Verificamos que los nombres de los atributos no sean nulos
				someoneCanModify = true;
			}
		}
		if (!someoneCanModify){
			alert(MSG_PERMISSIONS_ERROR);	
			return false;
		}
	}
	return true;
}

function canWrite(){
	var usrCanWrite = document.getElementById("hidUsrCanWrite").value;
	if (usrCanWrite=='true'){
		return true;
	}else{
		return false;	
	}
}

function cmbProySel(){
	if (document.getElementById("selPrj").value == "0"){
		//Deshabilitamos el checkbox de usar permisos del proyecto
		document.getElementById("usePrjPerms").checked = false;
		document.getElementById("usePrjPerms").disabled = true;
		//Habilitamos la grilla de permisos
		document.getElementById("permGrid").disabled = false;
		document.getElementById("addPoolUsrPerm").disabled = false;
		document.getElementById("delPoolUsrPerm").disabled = false;
		//Vaciamos la grilla de permisos, dejando TODOS clickeado
		//delAllPerms(true);
		var oRows = document.getElementById("permGrid").rows;
		var td = oRows[0].getElementsByTagName("TD");
		//Marcamos el modo lectura
		td[3].getElementsByTagName("INPUT")[0].checked = true;
		td[0].getElementsByTagName("INPUT")[2].value = 1;
		//Marcamos escritura
		td[3].getElementsByTagName("INPUT")[1].checked = true;
	 	td[0].getElementsByTagName("INPUT")[3].value = 1;		
	}else{
		//Habilitamos el checkbox de usar permisos del proyecto	
		document.getElementById("usePrjPerms").disabled = false;
		//Cargamos la grilla con los permisos del proyecto
		//loadProyectPerms(); <--- TODO, SI SE HACE SE DEBE HACER PARA TODOS LOS OBJETOS DE DISEÑO
		if (!document.getElementById("usePrjPerms").checked){ //Si no esta clickeado el checkbox de usar los permisos del proyecto
			var msg = confirm(MSG_USE_PROY_PERMS);
			if (msg) {
				document.getElementById("usePrjPerms").checked = true;
				//Deshabilitamos la grilla de permisos
				document.getElementById("permGrid").disabled = true;
				document.getElementById("addPoolUsrPerm").disabled = true;
				document.getElementById("delPoolUsrPerm").disabled = true;
				//Vaciamos la grilla de permisos, dejando TODOS sin clickear
				delAllPerms(false);
			}
		}
	}
}

function loadProyectPerms(){
	//1. Obtenemos el id del proyecto seleccionado
	var prjId = document.getElementById("selPrj").value;
	var sXMLSourceUrl = "administration.EntitiesAction.do?action=getProjPermssions&prjId=" + prjId;
	var xmlLoad=new xmlLoader();
	xmlLoad.onload=function(xmlRoot){
	
		for(i=0;i<xmlRoot.childNodes.length;i++){
			xRow = xmlRoot.childNodes[i];
			var option = document.createElement("OPTION");
			
			/* TODO */
		
		}
	}
	xmlLoad.load(sXMLSourceUrl);
}


function btnAddAtt_click(){
	var oTd0 = document.createElement("TD"); 
	var oTd1 = document.createElement("TD"); 
	var oTd2 = document.createElement("TD"); 
	
	oTd0.innerHTML = ""  ;
	oTd0.align="center";
	
	oTd1.innerHTML = "<input type='text' style='display:none' name='txtAttId'><input type='text' readonly class='txtReadOnly' req_desc=\""+LBLNOMATT+"\"  name='txtAttName' p_required='true'><img src='" + imgQryPath + "' style='cursor:hand' onclick='addAttribute(this)'>"  ;
	oTd1.align="center";
	
	oTd2.innerHTML = "<input type='text'  style='display:none' name='txtEntId'><input type='text' readonly class='txtReadOnly' req_desc=\""+LBLNOMENT+"\"  name='txtEntName' p_required='true'><img src='" + imgQryPath + "' style='cursor:hand' onclick='addEntity(this)'>"  ;
	oTd2.align="center";
	
	
	var oTr = document.createElement("TR");
	oTr.appendChild(oTd0);
	oTr.appendChild(oTd1);
	oTr.appendChild(oTd2);
	document.getElementById("gridAttRel").addRow(oTr);
}

function addAttribute(obj){
	var rets = openModal("/programs/modals/atts.jsp?onlyOne=true",500,300);
	var doAfter=function(rets,obj){
		if (rets != null) {
			var ret = rets[0];
			
			//verificar si existe ya en la grilla
			var elements = document.getElementsByName("txtAttId");
			var found = false;
			for(var i=0;i<elements.length;i++){
				if(elements[i].value == ret[0]){
					found = true;
					break;
				}
			}
			if(!found){
				var inputs = obj.parentNode.getElementsByTagName("INPUT");
				inputs[0].value = ret[0];
				inputs[1].value = ret[1];
			} else {
				alert(LBLATTDUP);
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue,obj);
	}
}

function addEntity(obj){
	var rets = openModal("/programs/modals/entities.jsp?onlyOne=true&envId="+envId,500,300);
	var doAfter=function(rets,obj){
		if (rets != null) {
			
			var ret = rets[0];
			var inputs = obj.parentNode.getElementsByTagName("INPUT");
			inputs[0].value = ret[0];
			inputs[1].value = ret[1];
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue,obj);
	}
}


function btnDelAtt_click(){
	document.getElementById("gridAttRel").removeSelected();
}