//esta variable se usa para determinar en los campos  numericos si se esta editando o no. para que  en
//firefox, estando en un input numerico, si se apreta un boton que hace submit, no dispare el onclick antes del onblur
var validating = false;

function submitFormFrame(obj) {
	obj.target = "iframeResult";
	obj.action = obj.action + "&mdlTarget=1";
	var win=window;
	var count = 0;
	while(!win.document.getElementById("iframeMessages") || !win.document.getElementById("iframeResult")){
		win=win.parent;
		count ++;
		if (count > 5) win = null;
	}
	
	if (win != null) win.document.getElementById("iframeResult").submitterDoc=document;
	try {
		if (internalDivType != "") {
			obj.action = obj.action + "&" + internalDivType + "="+internalDivSize;
		}
	} catch (e) {}
	try{
		if(windowId!=undefined && windowId!=null){
			form.action = form.action+windowId;
		}
	}catch(e){}
	submitForm(obj);
}

function submitForm(form) {
	if(validating){
		return;
	}

	if(form.target!="_self" && form.target!="" && form.target!=window.name){
		setSubmitWindow(window,form.target);
	}
	try{
		if(windowId!=undefined && windowId!=null){
			form.action = form.action+windowId;
		}
	}catch(e){}
	try {
		if (internalDivType != "") {
			if (form.action.indexOf("?") != -1) {
				form.action = form.action + "&" + internalDivType + "="+internalDivSize; 
			} else {
				form.action = form.action + "?" + internalDivType + "="+internalDivSize; 
			}
		}
	} catch (e) {}
	var win=window;
	while(!win.document.getElementById("iframeMessages") || !win.document.getElementById("iframeResult")){
		win=win.parent;
	}
	if(!MSIE){
		win.document.getElementById("iframeResult").style.visibility="hidden";
		win.document.getElementById("iframeResult").style.display="block";
		win.document.getElementById("iframeResult").doCenterFrame();
	}
	try {
	prepareReadOnlyToSubmit();
	} catch (e) {}
	form.submit();
	win.document.getElementById("iframeMessages").showResultFrame(document.body);
	win.document.getElementById("iframeResult").style.visibility="visible";
	if(!SHOW_WAIT_IN_EXECUTION){
		win.document.getElementById("iframeResult").style.top=(-win.document.getElementById("iframeResult").offsetHeight)+"px";
		win.document.getElementById("iframeMessages").style.top=(-win.document.getElementById("iframeMessages").offsetHeight)+"px";
	}
	prepareReadOnlyAfterSubmit();
}



function submitFormWithoutWaitScreen(form) {
	if(validating){
		return;
	}

	if(form.target!="_self" && form.target!="" && form.target!=window.name){

		setSubmitWindow(window,form.target);
	}
	try{
		if(windowId!=undefined && windowId!=null){
			form.action = form.action+windowId;
		}
	}catch(e){}
	try {
		if (internalDivType != "") {
			if (form.action.indexOf("?") != -1) {
				form.action = form.action + "&" + internalDivType + "="+internalDivSize; 
			} else {
				form.action = form.action + "?" + internalDivType + "="+internalDivSize; 
			}
		}
	} catch (e) {}
	try {
	prepareReadOnlyToSubmit();
	} catch (e) {}
form.submit();
prepareReadOnlyAfterSubmit()
}



function submitFormModal(form) {
	form.submit();
	try{
		//document.getElementById("iframeMessages").showResultFrame(document.body);
	}
	catch(e){}
}

function submitFormToNewDeskWin(form) {
	var newWin=getNewDeskWindow();
	if(newWin){
		var iframe=newWin.getElementsByTagName("IFRAME")[0];
		if(iframe){
			var doc;
			if(iframe.contentDocument){
			      doc = iframe.contentDocument;
			}else if(iframe.contentWindow){
			      doc = iframe.contentWindow.document;
			}else if(iframe.document){
			      doc = iframe.document;
			}
			doc.open();
			doc.close();
			var name=newWin.id;
			form.action = form.action+"&windowId="+name;
			if(!MSIE){
				var cloned=form.cloneNode(true);
				doc.body.appendChild(cloned);
				cloned.submit();
			}else{
				doc.body.innerHTML=form.outerHTML;
				doc.body.firstChild.submit();
			}
		}
	}
}

function getNewDeskWindow(){
	var win=window;
	while(win!=win.parent && !win.createWindow){
		win=win.parent;
	}
	try{
		var newWin=win.openWindow({ url:"#" , title:"", fixedSize:false, persistable:false,icon:"styles/default/images/bin_icon.png" });
		setTimeout(function(){newWin.bringToTop();},300);
		return newWin;
	}catch(e){
//		return null;
	}
}

function isApiaDesk(){
	var win=window;
	var classic = false;
	while(win.parent!=win){
		if(win.name == "workArea"){
			classic = true;
		}
		win=win.parent;
	}
	return !classic;
}

function splash() {
	if (window.name.indexOf("modal")>=0){window.close();return true;}
	if(windowId && windowId!=""){
		var win=window;
		while(!win.closeWindow && win!=win.parent){
			win=win.parent;
		}
		if(win.closeWindow){
			try {
				win.closeWindow(windowId.split("=")[1]);
				return null;
			} catch(e) {}
		}
	}
	if ((window.name != "iframeAjax" || window.name == "workArea") && window.name.indexOf("frameContent")<0) {
		window.location.href = "FramesAction.do?action=splash";
	} else {
		window.parent.location.href = "FramesAction.do?action=splash";
	}
}

function replace(data, searchstr, newstr) {
	if(data==null || data==undefined){return null;}
	var newtext = "";
	for (i=0; i < data.length; i++) {
		caracter = data.substring(i,i+1);
		if (caracter == searchstr) {
			newtext = newtext + newstr;
		} else {
			newtext = newtext + caracter;
		}
	}				

	return(newtext);
}

function chkAllGeneric(event,name){
	var oChk;
	if (MSIE){ 
		event=window.event;
		oChk = event.srcElement;
	}else{
		oChk = event.target;
	}
	var grid=oChk.parentNode;
	while(grid.getAttribute("type")!="grid"){
		grid=grid.parentNode;
	}
	
	if(oChk.checked){
		grid.selectAll();
	}else{
		grid.unselectAll();
	}
	
	/*var oChks = document.getElementById(name);
	for(var a=0;a < oChks.length;a++){
		if (! oChks[a].disabled) {
			oChks[a].checked = oChk.checked;
		}
	}*/
}

function chkAllGrid(event,name){
	event=getEventObject(event);
	var oChk=getEventSource(event);
	var oChks = document.getElementsByName(name);
	for(var a=0;a < oChks.length;a++){
		oChks[a].checked = oChk.checked;
		if(oChk.checked == true){
			enableRowInputs(oChks[a].parentNode.parentNode);			
		} else {
			disableRowInputs(oChks[a].parentNode.parentNode);
		}
	}
}

function disableRowInputs(obj) {
	if(obj.childNodes!=null){
		for(i=0;i<obj.childNodes.length;i++){
			if(obj.childNodes[i].firstChild.type == "hidden" && obj.childNodes[i].firstChild.type != "checkbox"){
				obj.childNodes[i].firstChild.name = "X";
			}
		}
	}
}

function enableRowInputs(obj) {
	if(obj.childNodes!=null){
		for(i=0;i<obj.childNodes.length;i++){
			if(obj.childNodes[i].firstChild.type == "hidden" && obj.childNodes[i].firstChild.type != "checkbox"){
				obj.childNodes[i].firstChild.name = obj.childNodes[i].firstChild.name2;
			}
		}
	}
}

function checkGridInputs(obj) {
	if(obj.checked == true){	
		enableRowInputs(obj.parentNode.parentNode);
	}else{
		disableRowInputs(obj.parentNode.parentNode);
	}
}

function selectOneChk(obj) {
	var elements=document.getElementsByTagName(obj.tagName);
	for (i=0;i<elements.length;i++) {
		if(elements[i].name==obj.name && elements[i]!= obj){
			elements[i].checked=0;
		}
	}
}

function openModal(url, width, height) {
	var paramArr = "status:no; help:no; unadorned:yes; dialogWidth:"+width+"px; dialogHeight:"+height+"px; center:yes;";
	return xShowModalDialog((URL_ROOT_PATH +url),null,paramArr);
	//return window.showModalDialog(URL_ROOT_PATH + url,null,paramArr);
}

function xShowModalDialog( sURL, vArguments, sFeatures ){
	var win=window;
	while((!win.document.getElementById("iframeMessages") || !win.document.getElementById("workArea") || !win.document.getElementById("iframeResult")) && (win!=win.parent) ){
		win=win.parent;
	}
	var callerWindow=window;
	return win.xShowModalDialog( sURL, vArguments, sFeatures, callerWindow );
}

function openWindow(url, width, height) {
	valores = "toolbar=no,location=no,status=no,menubar=no,resizable=no,scrollbars=yes,top=0,left=0,height=600, width=800"
	window.open (url,"appWindow", "\"" + valores + "\"" )
}

function openWindow2(url, width, height, resizable) {
	valores = "toolbar=no,location=no,status=no,menubar=no,resizable=" + resizable + ",scrollbars=yes,top=0,left=0,height=" + height + ", width=" + width;
	window.open (url,"appWindow", "\"" + valores + "\"" );
}

function encodeStr(str) {
	ret = "";
	for (i=0;i<str.length;i++) {
		ret+=str[i] + GNR_STRING_SEPARATOR;
	}
	return ret;
}

function showWaitMsg(obj) {}
function hideWaitMsg(obj) {}

function showWaitFrame(obj) {
	if(SHOW_WAIT_IN_EXECUTION){
		if (window.parent.frames.length >= 4) {
			window.parent.document.getElementById("iframeMessages").showResultFrame(document.body);
		} else {
			window.parent.parent.document.getElementById("iframeMessages").showResultFrame(document.body);
		}
	}else{
		window.parent.parent.document.block();
	}
}

function hideShowDiv(name,obj,hid){

	var b = window.document.getElementById(name);
	var hidClosed = window.document.getElementsByName(hid);
	
	if(b!=null && b!=undefined){
		var tmp = obj.firstChild.src;

		obj.firstChild.setAttribute("src",obj.firstChild.getAttribute("auxSrc"));
		obj.firstChild.setAttribute("auxSrc",tmp);
	     if (b.style.display == 'none') {
	         b.style.display = 'block';
	         fixInnerGrids(b);
	         hidClosed[0].value=false;
	     } else {
	         b.style.display = 'none';
	         hidClosed[0].value=true;
	     }
	     if(MSIE){
			var tables=b.getElementsByTagName("TABLE");
			for(var i=0;i<tables.length;i++){
				if(tables[i].className=="navBar"){
					tables[i].style.display = 'none';
					tables[i].style.display = 'block';
				}
			}
		}
	}
	
	setTimeout(function(){
		try{setPageOverFlow();}catch(e){}
	},100);

}

var addedTR;


function checkSecondTR(obj,name){
/*	var bodyElement = document.getElementById(obj);
	for(i=0;i<bodyElement.childNodes.length;i++){
		if(i==1){
			bodyElement.childNodes[i].id = name;
		}
	}
*/
}

function htmlGridAdd(gridName,trName){
	var firstTr = document.getElementById(gridName).rows[0];
	var secondTr = document.getElementById(gridName).rows[1];
	var oTr;
 
	var visibility=firstTr.style.visibility+"";
	var display=firstTr.style.display+"";
	
	oTr = document.createElement("TR");
	var tds=firstTr.cells;
	if (MSIE){
		for(var i=0;i<tds.length;i++){
			var td=document.createElement("TD")
			
			var str = tds[i].innerHTML;
			while(str.indexOf("_XX") >-1){
				str = str.replace("_XX","");
			}
			while(str.indexOf("_hidden") >-1){
				str = str.replace("_hidden","");
			}
			td.innerHTML=str;
			oTr.appendChild(td);
		}
	}else{
		for(var i=0;i<tds.length;i++){
			var td=oTr.insertCell(i); 
			var str = tds[i].innerHTML;
			while(str.indexOf("_XX") >-1){
				str = str.replace("_XX","");
			}
			while(str.indexOf("_hidden") >-1){
				str = str.replace("_hidden","");
			}
			td.innerHTML=str;
		}
	}
 
	var grid = document.getElementById(gridName);
	grid.unselectAll();
	grid.addRow(oTr);
	/*if(secondTr){
		for(m=0;m<secondTr.getElementsByTagName("INPUT").length;m++){
			var elementA=secondTr.getElementsByTagName("INPUT")[m];
			var elementB=oTr.getElementsByTagName("INPUT")[m];
			if(elementA.tagName!=null && elementB.tagName!=null && elementA.name){
				elementB.name=elementA.name;
				elementB.id=elementA.id;
			}
		}
		for(m=0;m<secondTr.getElementsByTagName("SELECT").length;m++){
			var elementA=secondTr.getElementsByTagName("SELECT")[m];
			var elementB=oTr.getElementsByTagName("SELECT")[m];
			if(elementA.tagName!=null && elementB.tagName!=null && elementA.name){
				elementB.name=elementA.name;
				elementB.id=elementA.id;
			}
		}
	}*/
	//oTr.innerHTML=firstTr.innerHTML;
	oTr.setAttribute("name","");
	var tds=oTr.getElementsByTagName("TD");
	var tds2=firstTr.getElementsByTagName("TD");
	for (i = 0; i < tds2.length; i++) { //recorro los TD
		var oTd = tds[i];
		var input=oTd.getElementsByTagName("INPUT")[0];
		if(input && input.type=="text"){
			if(input.getAttribute("def_value")){
				input.value=input.getAttribute("def_value");
			}else{
				if(input.name.indexOf("ROWID")==-1 && !input.getAttribute("p_mask")){
					input.value="";
				}
			}
			//ver si esta bien el tema de los disabled
			if(input.disabled == true && input.getAttribute("x_deshabilitado")!="true"){
				input.disabled=false;
			}
		}
		 
		if(oTd.firstChild != null) {
			if(tds2[i].tdType != "label") {
				if(oTd.getElementsByTagName("input")[0]){
					addBehaviors(oTd.getElementsByTagName("input")[0]);
				}
			}
		}	
	}
	
		//si los rowId no tienen valor, ponerles 0
	var c = oTr.getElementsByTagName("INPUT");
	for(i=0;i<c.length;i++){
		if(c[i].type=="hidden" && (c[i].value == "" || c[i].value == null)){
			c[i].value = "0";
		}
	}

	//descheckear los checkboxes del ultimo row
	uncheckLastRowChecks(grid);
	
	if(!MSIE){
		grid.fixTBodyPosition();
	}
	//renumerar value de los checkboxes
	//renumGridChk(grid);

	//sacar la imagen que sobra del calendario	
	addedTR = oTr; //tr recien insertado
	//se hace un delay porque demora un poquito
//	setTimeout("removeImg()",30);

	
}

function uncheckLastRowChecks(grid){
	var xRows = grid.rows;
	var xTR = xRows[xRows.length-1];
	var tds=xTR.getElementsByTagName("TD");
	for(i=0;i<tds.length;i++){
		if(tds[i].childNodes[0].type=="checkbox"){
			tds[i].childNodes[0].checked=false;
			try{
				tds[i].childNodes[0].value=false;
			}catch(e){}
		}
	}
}

function removeImg(){
	for (i = 0; i < addedTR.childNodes.length; i++) { //recorro los TD
		var oTd = addedTR.childNodes[i];
		if(oTd.children.length == 2){
			if(oTd.children(0).tagName == "SPAN") {
				if(oTd.children(1).tagName == "IMG"){
					oTd.children(1).removeNode();
				}
			}
		}
	}
}

function addBehaviors(ele){
	if((ele.getAttribute("p_calendar")==true || ele.getAttribute("p_calendar")=="true") && ele.type == "text"){
		for(var i=0;i<ele.parentNode.getElementsByTagName("SPAN").length;i++){
			if(ele.parentNode.getElementsByTagName("SPAN")[i].getAttribute("dtPicker")=="true"){
				ele.parentNode.getElementsByTagName("SPAN")[i].parentNode.removeChild(ele.parentNode.getElementsByTagName("SPAN")[i]);
				ele.setAttribute("dtPicker","");
			}
		}
		setMask(ele,ele.getAttribute("p_mask"));
		setDTPicker(ele);
	} 
	if(ele.tagName=="INPUT" && ele.getAttribute("onpropertychange")!=null && !MSIE){
		setPropertyChanged(ele);
	}

	
}


function swap(tblBody,pos1, pos2) {
	//si bajo la prmer linea.... swapeo el nombre tambien para que solo no se pueda borrar la ultima linea
	if(tblBody.rows[pos1].name == "firstTr") {
		tblBody.rows[pos2].name = tblBody.rows[pos1].name;
		tblBody.rows[pos2].id = tblBody.rows[pos1].id;
		tblBody.rows[pos1].name = "";
		tblBody.rows[pos1].id = "";
	}
	//cambiar posiciones
	var toBeCloned=tblBody.rows[pos2];
	var clone=toBeCloned.cloneNode(true);
	var cmbs=toBeCloned.getElementsByTagName("SELECT");
	var cmbsCloned=clone.getElementsByTagName("SELECT");
	for(var i=0;i<cmbs.length;i++){
		cmbsCloned[i].selectedIndex=cmbs[i].selectedIndex;
	}
	var checkInputs=toBeCloned.getElementsByTagName("INPUT");
	var clonedCheckInputs=clone.getElementsByTagName("INPUT");
	for(var i=0;i<clonedCheckInputs.length;i++){
		if(clonedCheckInputs[i].type=="checkbox"){
			clonedCheckInputs[i].checked=checkInputs[i].checked;
		}
	}
	var row1=tblBody.rows[pos1];
	var row2=tblBody.rows[pos2];
	var checked1=tblBody.rows[pos1].getElementsByTagName("INPUT")[0].value=="on";
	var checked2=tblBody.rows[pos2].getElementsByTagName("INPUT")[0].value=="on";
	tblBody.rows[pos1].parentNode.insertBefore(clone,row1);
	tblBody.rows[pos1].parentNode.removeChild(row2);
	tblBody.rows[pos1].cells[0].getElementsByTagName("INPUT")[0].checked=false;
	tblBody.rows[pos2].cells[0].getElementsByTagName("INPUT")[0].checked=false;
	tblBody.rows[pos1].id="";
	tblBody.rows[pos2].id="";
	//renumerar value de los checkboxes
	//renumGridChk(tblBody);
	var grid=tblBody.parentNode.parentNode.parentNode.parentNode;
	grid.setOdds();
	grid.unselectAll();
	if(checked1){
		grid.selectElement(tblBody.rows[pos2]);
	}
	if(checked2){
		grid.selectElement(tblBody.rows[pos1]);
	}
}

function trim(str){
   return str.replace(/^\s*|\s*$/g,"");
}

//--- This method adds thousand separator to a number
function addThousSeparator(nStr) {
	nStr += '';
	var x = nStr.split(charDecimalSeparator);
	x1 = x[0];
	x2 = x.length > 1 ? charDecimalSeparator + x[1] : '';
	var rgx = /(\d+)(\d{3})/;
	while (rgx.test(x1)) {
		x1 = x1.replace(rgx, '$1' + charThousSeparator + '$2');
	}
	return x1 + x2;
}

//--- This method returns the logged user
function getLoggedUser() {
	return LOGGED_USER;
}

function validTime(element) {
	if (element != null && element.value != "") {
		var hour = element.value;
		if (hour.length != 5) {
			alert(GNR_INVALID_TIME);
			element.value = "";
			return false;
		}
		hour = hour.substring(0,2) + hour.substring(3,5);
		var mHour = parseFloat(hour);
		if (mHour < 0 || mHour >= 2400 || (mHour % 100) >= 60) {
			alert(GNR_INVALID_TIME);
			element.value = "";
			return false;
		}
	}
	return true;
}

function toggleFilterSection(){
	if(document.getElementById("listFilterArea").style.display=="none"){
		var filter=document.getElementById("listFilterArea");
		if(filter.getAttribute("ready")!="true"){
			filter.setAttribute("openWhenReady","true")
			return;
		}
		filter.style.display="block";
		if(document.getElementById("frmMain").parentNode.getAttribute("type")=="tab"){
			document.getElementById("divContent").appendChild(filter);
		}
		sizeFilter();
	}else{
		var filter=document.getElementById("listFilterArea");
		filter.style.height="0px";
		filter.filterContent.style.height="0px";
		filter.style.display="none";
	}
}

function processBodyToPrint(){
	var clonedBody=document.createElement("DIV");
	clonedBody.innerHTML=document.body.innerHTML;
	
	//-- Cambiar los inputs
	var inputs = clonedBody.getElementsByTagName("INPUT");
	var originalInputs = document.body.getElementsByTagName("INPUT");
	//var i=0;
	var i = inputs.length - 1;
	var parentNode;
	while (i >= 0) {
		if(inputs[i] && inputs[i].parentNode){
			parentNode = inputs[i].parentNode;
			if (inputs[i].id == "chkAddAlert" || inputs[i].id == "chkAddAllAlert" || inputs[i].id == "chkRemAlert") {
				var tr = inputs[i].parentNode.parentNode;
				tr.parentNode.removeChild(tr);
			} else {
				if (originalInputs[i].type == "text" && !((getStyle(originalInputs[i],"display")+"")=="none")) {
					if (originalInputs[i].p_calendar == "true") {
						while (parentNode != null && parentNode.tagName != "TD") {
							parentNode = parentNode.parentNode;
						}
					}
					if (parentNode != null) {
						parentNode.innerHTML = "<div style='width:100%;white-space:normal'>"+originalInputs[i].value+"</div>";						
					}
				} else if (originalInputs[i].type == "password") {
					lastName = originalInputs[i].name;
					parentNode.innerHTML = "**********";
				} else {
					lastName = originalInputs[i].name
				}
				if (originalInputs[i].getAttribute("ie6TextArea") == "true") {
					parentNode.style.border = "1px solid #000000";
					parentNode.innerHTML = originalInputs[i].value;
				}
			}
		}
		i--;
		if(i>inputs.length){
			i=inputs.length-1;
		}
	}
	//-- Cambiar los textArea
	var textAreas = clonedBody.getElementsByTagName("TEXTAREA");
	var originalTextAreas = document.getElementsByTagName("TEXTAREA");
	for (var i=0;i<originalTextAreas.length ;i++) {
		parentNode = textAreas[0].parentNode;
		parentNode.innerHTML = "<div style='width:100%;white-space:" + (MSIE ? "pre;word-wrap:break-word" : "pre-line") + "'>"+originalTextAreas[i].value+"</div>";
		if(MSIE){
			//parentNode.getElementsByTagName("DIV")[0].innerHTML = originalTextAreas[i].value.replace(new RegExp("\\n", "g"), '<br/>');
			parentNode.getElementsByTagName("DIV")[0].innerHTML = "<pre>" + originalTextAreas[i].value + "</pre>";
		}
	}

	//-- Cambiar los select
	var selects = clonedBody.getElementsByTagName("SELECT");
	var originalSelects = document.body.getElementsByTagName("SELECT");
	
	var count=selects.length;
	while (count > 0) {
	count--;
	  parentNode = selects[count].parentNode;
	  if (! originalSelects[count].multiple && originalSelects[count].selectedIndex>0) {
		  if(originalSelects[count].options[originalSelects[count].selectedIndex].value==originalSelects[count].options[originalSelects[count].selectedIndex].text){
			  parentNode.innerHTML = originalSelects[count].options[originalSelects[count].selectedIndex].text;
		  } else {
			  parentNode.innerHTML = originalSelects[count].options[originalSelects[count].selectedIndex].value+" - "+originalSelects[count].options[originalSelects[count].selectedIndex].text;
		  }
	  } else {
	    var aux = "";
	    for (j = 0; j < selects[count].options.length; j++) {
	      if (selects[count].options[j].selected) {
	        aux += selects[count].options[j].text + "<br>";
	      }
	    }
	    parentNode.innerHTML = aux;
	  }
	  selects = clonedBody.getElementsByTagName("SELECT");
	}
	
	if(!MSIE) {
		//-- Quitar los cellsizer
		var imgs = clonedBody.getElementsByTagName("IMG");
		if(imgs) {
			for (var k  = imgs.length - 1; k >= 0; k--) {
				if(imgs[k].src.indexOf("cellsizer.gif") >= 0)
					imgs[k].parentNode.removeChild(imgs[k]);
			}
		}
		if(FIREFOX) {
			var tHeaders = clonedBody.getElementsByTagName("TH");
			if(tHeaders) {
				for (var k = 0; k < tHeaders.length; k++) {
					tHeaders[k].style.paddingLeft = "3px";
					tHeaders[k].style.paddingRight = "3px";
				}
			}
		}
	}
	
	return processGridsToPrint(clonedBody);
}

function processGridsToPrint(clone){
	var grids=new Array();
	for(var i=0;i<clone.getElementsByTagName("DIV").length;i++){
		if(clone.getElementsByTagName("DIV")[i].getAttribute("type")=="grid"){
			grids.push(clone.getElementsByTagName("DIV")[i]);
		}
		//textareas solo lectura
		if(clone.getElementsByTagName("DIV")[i].parentNode.className=="readOnly"){
			var current_div = clone.getElementsByTagName("DIV")[i];
			//if(MSIE && current_div.childNodes.length) {
				//current_div.innerHTML = current_div.childNodes[0].innerHTML.replace(new RegExp("\\n", "g"), '<br/>');
			//}
			
			current_div.style.width="100%";
			current_div.style.height="";
			if(MSIE)
				current_div.style.whiteSpace="pre";
			else
				current_div.style.whiteSpace="pre-line";
			current_div.style.wordWrap="break-word";
			current_div.style.overflow="hidden";
		}
	}
	for(var i=0;i<grids.length;i++){
		var grid=grids[i];
		if(grid.id.indexOf("gridListfrm")>=0 || (grid.id=="queryGrid")){
			var gridClone=grid.cloneNode(true);
			var trs=gridClone.getElementsByTagName("TBODY")[0].getElementsByTagName("TR");
			var ths=gridClone.getElementsByTagName("THEAD")[0].getElementsByTagName("TH");
			var table=document.createElement("TABLE");
			table.setAttribute("cellpadding","0");
			table.setAttribute("cellspacing","0");
			table.width="95%";
			//var divTitle=document.createElement("DIV");
			var divEmpty=document.createElement("DIV");
			divEmpty.innerHTML="&nbsp;";
			/*
			divTitle.innerHTML=gridClone.getAttribute("gridTitle");
			divTitle.style.border="1px solid #666666";
			divTitle.style.backgroundColor="#EEEEEE";
			divTitle.style.fontWeight="bold";
			divTitle.style.width="95%";
			*/
			var start=0;
			if(trs[0].style.display=="none"){
				start=1;
			}
			for(var j=start;j<trs.length;j++){
				var tds=trs[j].getElementsByTagName("TD");
				var tr=null;
				for(var k=0;k<tds.length;k++){
					while(k<tds.length && tds[k].getElementsByTagName("BUTTON").length>0){
						k++;
					}
					if(( (k!=0 && tds[k] && tds[k].style.display!="none")  || (k==0 && tds[k].style.display!="none"))&& k<tds.length){
						if(tr==null){
							tr=document.createElement("TR");
						}else if(tr.getElementsByTagName("TD").length==4){
							tr=document.createElement("TR");
						}
						var td1=document.createElement("TD");
						if(ths[k].getElementsByTagName("IMG")[0]){
							ths[k].getElementsByTagName("IMG")[0].parentNode.removeChild(ths[k].getElementsByTagName("IMG")[0]);
						}
						/*if(ths[k].getElementsByTagName("INPUT")[0]){
							td1.innerHTML=ths[k].getElementsByTagName("INPUT")[0].name+":";
						}else */if(ths[k].getElementsByTagName("SPAN")[0]){
							var txt=ths[k].getElementsByTagName("SPAN")[0].innerHTML;
							txt=txt.replace(/(\r\n|\n|\r|<br>)/gm,"");
							td1.innerHTML=txt+":";
						}else{
							var txt=ths[k].innerHTML;
							txt=txt.replace(/(\r\n|\n|\r|<br>)/gm,"");
							td1.innerHTML=txt+":";
						}
						td1.style.fontSize="12px";
						td1.style.fontWeight="bold";
						td1.style.border="1px solid #666666";
						td1.style.backgroundColor="#EEEEEE";
						td1.style.width="25%";
						var td2=document.createElement("TD");
						var value=getContentValue(tds[k]);
						if(value==""){value ="&nbsp;";}
						td2.innerHTML=value;
						td2.style.fontSize="12px";
						td2.style.border="1px solid #666666";
						td2.style.width="25%";
						
						var inputs1 = tds[k].getElementsByTagName("INPUT");
						var inputs2 = td2.getElementsByTagName("INPUT");
						for(var h = 0; h < inputs1.length; h++) {
							if(inputs1[h].type == "checkbox")
								if(inputs1[h].checked == true || inputs1[h+1].value=="true")
									inputs2[h].setAttribute("checked","checked");
						}
						
						tr.appendChild(td1);
						tr.appendChild(td2);
						if(tr.getElementsByTagName("TD").length==2 && tds.length==(k+1)){
							var td3=document.createElement("TD");
							td3.innerHTML="&nbsp;";
							td3.style.width="25%";
							var td4=document.createElement("TD");
							td4.innerHTML="&nbsp;";
							td4.style.width="25%";
							tr.appendChild(td3);
							tr.appendChild(td4);
						}
						if(tr.getElementsByTagName("TD").length==4){
							table.appendChild(tr);
						}
					}
				}
				var emptyTr=document.createElement("TR");
				var emptyTd=document.createElement("TD");
				emptyTd.innerHTML="&nbsp;";
				emptyTr.appendChild(emptyTd);
				table.appendChild(emptyTr);
			}
			grid.parentNode.insertBefore(table,grid.nextSibling);
			/*
			if(divTitle.innerHTML!="null"){
				grid.parentNode.insertBefore(divTitle,table);
			}
			*/
			grid.parentNode.insertBefore(divEmpty,table);
			grid.parentNode.removeChild(grid);
		}else if(grid.id.indexOf("docGrid")>=0){
			var rows=grid.getElementsByTagName("TR");
			for(var j=0;j<rows.length;j++){
				rows[j].style.position="static";
				var tds=rows[j].cells;
				rows[j].removeChild(tds[2]);
				rows[j].removeChild(tds[1]);
				rows[j].removeChild(tds[0]);
				
				tds = rows[j].cells;
				var brs = tds[2].getElementsByTagName("BR");
				if(brs.length > 1) {
					tds[2].removeChild(brs[1]);
				}
				var brs = tds[1].getElementsByTagName("BR");
				if(brs.length > 0) {
					tds[1].removeChild(brs[0]);
				}
				
				
			}
			grid.style.width="100%";
			grid.getElementsByTagName("THEAD")[0].className="";
			grid.innerHTML=grid.getElementsByTagName("table")[0].parentNode.innerHTML;
			grid.style.fontFamily="Tahoma";
			grid.style.fontSize="12px";
		}
	}
	return clone.innerHTML;
}

function getContentValue(td){
	var elements=td.getElementsByTagName("*");
	for(var i=0;i<elements.length;i++){
		if(elements[i].tagName=="INPUT" && elements[i].type=="text" && !((getStyle(elements[i],"display")+"")=="none")){
			return elements[i].value;
		}
		if(elements[i].tagName=="INPUT" && elements[i].type=="password"){
			return "*******";
		}
		/*
		if(elements[i].tagName=="INPUT" && elements[i].type=="checkbox"){
			if(elements[i].value=="on"){
				//elements[i].checked=true;
				elements[i].value="on";
			}
		}*/
		if(elements[i].tagName=="SELECT"){
			if(elements[i].selectedIndex>0){
				return elements[i].options[elements[i].selectedIndex].text;
			}
			return "&nbsp;";
		}
	}
	return td.innerHTML;
}

function removeHTMLChars(txt){
	var result="";
	for(var i=0;i<txt.length;i++){
		if(txt.charAt(i)=="<"){
			while(txt.charAt(i)!=">"){
				i++;
			}
			i++;
		}
		result+=txt.charAt(i);
	}
	return result;
}

function getParentRow(element){
	while(element.tagName!="TR"){
		element=element.parentNode;
	}
	return element;
}

function getParentCell(element){
	while(element.tagName!="TD"){
		element=element.parentNode;
	}
	return element;
}

function isInGrid(el){
	while(el.tagName!="BODY"){
		if(el.getAttribute("type")=="grid"){
			return true;
		}
		el=el.parentNode;
	}
	return false;
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


function askAjax(url,requestString,after){
	var http_request = getXMLHttpRequest();
	http_request.after=after;
	http_request.open('POST', url, true);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded; charset=utf-8");
    if(MSIE){
    	http_request.onreadystatechange=function(){
    		if (http_request.readyState == 4) {
			    if (http_request.status == 200) {
			        http_request.after(http_request.responseText);
			    } else {
			       alert('The system could not contact server using AJAX.');
			       http_request.after(null);
			    }
			}
		}
    }else{
		http_request.onload=function(){
			if (http_request.status == 200) {
		        http_request.after(http_request.responseText);
		    } else {
		       alert('The system could not contact server using AJAX.');
		       http_request.after(null);
		    }
		}    	
    }
	http_request.send(requestString);
}

function setSubmitWindow(win,target){
	var win2=window;
	while(!win2.document.getElementById(target) && win2.parent!=win2){
		win2=win2.parent;
	}
	try{win2.document.getElementById(target).setSubmitWindow(win);}catch(e){}
}

function getSubmitWindow(target){
	var win2=window;
	while(!win2.document.getElementById(target)){
		win2=win2.parent;
	}
	try{return win2.document.getElementById(target).getSubmitWindow();}catch(e){}
}

function openQryModal(qry2,attId,index,action,formId,parent,inModal,width,height) {
		index=index-2;		
		var qry = qry2;
		var rets = openModal("/query.ModalAction.do?action=" + action + "&frmId="+ formId + "&parent=" + parent +"&inModal=" + inModal + "&query=" + qry.getElementsByTagName("IMG")[0].getAttribute("modal") + "&attId=" + attId + "&index=" + index, width , height );
		var doAfter=function(rets){
			lastModalReturn = rets;
			if (rets != null) {
				//-ver si tiene mascara o no
				if(qry.previousSibling.tagName=="INPUT"){
					var input=qry.previousSibling;
					if( (input.getAttribute("p_numeric")=="true" && input.getAttribute("qryReturnType")!="N")
					||	(input.getAttribute("p_calendar")=="true" && input.getAttribute("qryReturnType")!="D") ){
						alert("TIPOS DE DATOS INCOMPATIBLES");
					}else{
						var inputs=input.parentNode.getElementsByTagName("INPUT");
						var val=null;
						for(var i=0;i<inputs.length;i++){
							if(inputs[i].type=="hidden" && inputs[i].name.indexOf("ROWID")<0){
								val=inputs[i];
							}
						}
						if(val){
							val.value = rets[0];
						}
						
						if(input.getAttribute("grid")=="true"){
							input.value = rets[0];
						} else {
							input.value = rets[1];
						}
					}
					if(input.getAttribute("onmodalreturn")){
						var f=new Function(input.getAttribute("onmodalreturn")+"(this)");
						input.modalReturn=f;
						input.modalReturn();
					}
					//try{
						input.setAttribute("manualFire","false");
						if(input.getAttribute("events")=="true" || input.getAttribute("eventsclient")=="true" || input.getAttribute("hasBinding")=="true"){
							fireEvent(input,"change");
						}
						
					//}catch(e){}
				} else if (qry.previousSibling.tagName=="SPAN"){ 
					var input=qry.previousSibling;
					while(input.tagName!="INPUT" && input.type!="hidden"){
						input=input.previousSibling;
					}
					var inputs=input.parentNode.getElementsByTagName("INPUT");
					var val=null;
					for(var i=0;i<inputs.length;i++){
						if(inputs[i].type=="hidden" && inputs[i].name.indexOf("ROWID")<0){
							val=inputs[i];
						}
					}
					if(val){
						val.value = rets[0];
					}
					if(input.getAttribute("grid")=="true"){
						input.value = rets[0];
					} else {
						input.value = rets[1];
					}
					if(input.getAttribute("onmodalreturn")){
						var f=new Function(input.getAttribute("onmodalreturn")+"(this)");
						input.modalReturn=f;
						input.modalReturn();
					}
					//try{
						input.setAttribute("manualFire","false");
						if(input.getAttribute("events")=="true" || input.getAttribute("eventsclient")=="true" || input.getAttribute("hasBinding")=="true"){
							fireEvent(input,"change");
						}

					//}catch(e){}
				}
			}
		}
		rets.onclose=function(){
			doAfter(this.returnValue);
		}
}

function loadGridData(rets,hasFiles,btn,frmId,fldId){
try{
	if(rets!=null && rets.length>0){
		btn.setAttribute('withData',"true");
	    for (var i = 0; i < rets.length; i++) {
			var x = rets[i];
			
			
						//--esto trae el TR que contiene los datos a llenar
		    oTr = btn.parentNode; 
		    while(oTr.tagName!='TR'){
		    	oTr=oTr.parentNode;
		    }
		    //--recorro los elementos del TR
		    for (j=0;j<oTr.cells.length;j++) {
				//--ACA VER TODOS LOS POSIBLES CASOS
		        var ele = oTr.cells[j].firstChild; 
		        while(ele.tagName=='SPAN'){
		        	ele=ele.firstChild;
		        }
		        if(x[0]==ele.getAttribute('attid')){
		        	if(ele.type == "checkbox"){
						var value=false; 
						if(x[1]=='true'){
							value=true;
						} 
						ele.checked=value;ele.value=x[1];
						try{
							ele.onpropertychange();
						}catch(e){}
					}
					if (ele.tagName == "SELECT") {
						for (var k = 0; k < ele.options.length; k++) {
							if (ele.options[k].value == x[1]) {
								ele.selectedIndex = 0;
								ele.value = x[1];
								ele.nextSibling.value = ele.options[k].text;
								try{
									ele.onpropertychange();
								}catch(e){}
							}
						}
					}
		        
					ele.value=x[1];
					if(ele.getAttribute('p_mask') && ele.getAttribute('p_mask').length>0){
						ele.value=x[1];
					}
			        try{
			            ele.onchange();
					}catch(e){}
				}
			}//--end for
		}//--end for
	}else{//--end if arr!=null
		alert('Los datos pueden quedar inconsistentes');
	}
	if(hasFiles){
		document.getElementById("frmMain").action = "execution.FormAction.do?action=reloadEditableGrid&frmId=" + frmId + "&fldId=" + fldId;		
		submitFormReload(document.getElementById("frmMain"));
	}
}catch(e){alert(e.message);}
}




function createCookie(name,value,days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/;";
}

function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

function eraseCookie(name) {
	createCookie(name,"",-1);
} 

function jsCaller(fnc,data) {
	fnc(data);
}
