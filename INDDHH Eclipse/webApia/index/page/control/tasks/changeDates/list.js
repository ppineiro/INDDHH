function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	$$('div.fncDescriptionImage').each(function(e){
		var path = 'url(' + e.get('src') + ')'
		e.setStyle('background-image', path);
		e.setStyle('background-repeat', 'no-repeat');
		e.setStyle('width', '64px');
		e.setStyle('height', '64px');
	});
	 
	['orderByTskTit','orderByProTit','orderByMonInstProNroReg','orderByDateWarn','orderByDateOverdue'].each(function(ele){
		setAdmListTitle(ele);
	});
	['orderByTskTit','orderByProTit','orderByMonInstProNroReg','orderByDateWarn','orderByDateOverdue'].each(function(ele){
		setAdmOrder(ele);
	});
	
	['cmbTskTitFilter','cmbProcTitFilter','monInstProNroRegFilter','proPoolFilter','monInstProCreUsuFilter','tskUsrAcqFilter',
	 'priorityFilter','createDateFilterStart','createDateFilterEnd','txtReaSta','txtReaEnd','alertDateFilterStart','alertDateFilterEnd',
	 'overdueDateFilterStart','overdueDateFilterEnd'].each(function(ele) {
		 setAdmFilters(ele);			
	});
	
	$('createDateFilterStart').setFilter = setFilter;
	$('createDateFilterStart').addEvent("change", function(e) {
		this.setFilter();
	});
	$('createDateFilterEnd').setFilter = setFilter;
	$('createDateFilterEnd').addEvent("change", function(e) {
		this.setFilter();
	});
	
	$('txtReaSta').setFilter = setFilter;
	$('txtReaSta').addEvent("change", function(e) {
		this.setFilter();
	});
	$('txtReaEnd').setFilter = setFilter;
	$('txtReaEnd').addEvent("change", function(e) {
		this.setFilter();
	});
	
	$('alertDateFilterStart').setFilter = setFilter;
	$('alertDateFilterStart').addEvent("change", function(e) {
		this.setFilter();
	});
	$('alertDateFilterEnd').setFilter = setFilter;
	$('alertDateFilterEnd').addEvent("change", function(e) {
		this.setFilter();
	});
	
	$('overdueDateFilterStart').setFilter = setFilter;
	$('overdueDateFilterStart').addEvent("change", function(e) {
		this.setFilter();
	});
	$('overdueDateFilterEnd').setFilter = setFilter;
	$('overdueDateFilterEnd').addEvent("change", function(e) {
		this.setFilter();
	});
	
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['cmbTskTitFilter','cmbProcTitFilter','monInstProNroRegFilter',,'proPoolFilter','monInstProCreUsuFilter','tskUsrAcqFilter','priorityFilter'].each(clearFilter);
		['createDateFilterStart','createDateFilterEnd','txtReaSta','txtReaEnd','alertDateFilterStart','alertDateFilterEnd','overdueDateFilterStart','overdueDateFilterEnd'].each(clearFilterDate); 
		titOld = "";
		cleanCmbTskTitFilter();
		$('cmbTskTitFilter').setFilter();		
	});
	
	
	$('btnModDate').addEvent("click",function(e){
		e.stop();
		if (selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING,'modalWarning');
		} else {
			var selected = getSelectedRows($('tableData'));
			var id = "";
			for (i = 0; i < selected.length; i++) {
				id += selected[i].getRowId();
				if (i < selected.length - 1) {
					id += ";";
				}
			}
			var request = new Request({
				method : 'post',
				url : CONTEXT + URL_REQUEST_AJAX + '?action=startChangeDateModal&isAjax=true&id=' + id + TAB_ID_REQUEST,
				onRequest : function() { SYS_PANELS.showLoading(); },
				onComplete : function(resText, resXml) { showDatesModal(resXml,reloadList); SYS_PANELS.closeLoading(); }
			}).send();
		}
	});
	
	$('btnCloseTab').addEvent('click', function(e){
		e.stop();
		getTabContainerController().removeActiveTab();
	});
	
	initNavButtons(URL_REQUEST_AJAX,"",['cmbProcTitFilter'],'tableData');
	initAdminFav();
	initDatesModalPage();
	
	loadTasksByProcess($('cmbProcTitFilter'));	
	
	callNavigate();	
}


//establecer un filtro
var titOld= "";
function setFilter(back){
	if ($('cmbProcTitFilter').value!=""){
		titOld = $('cmbProcTitFilter').value;
	}
	callNavigateFilterTasks({
		txtTskTitle:$('cmbTskTitFilter').value,
		txtProTitle:$('cmbProcTitFilter').value,
		filProName:$('monInstProNroRegFilter').value,
		txtProPool:$('proPoolFilter').value,
		txtProInstUser:$('monInstProCreUsuFilter').value,
		txtTskUsrAcq:$('tskUsrAcqFilter').value,
		cmbPriority:$('priorityFilter').value,
		txtProStaSta:$('createDateFilterStart').value,
		txtProStaEnd:$('createDateFilterEnd').value,
		txtReaSta:$('txtReaSta').value,
		txtReaEnd:$('txtReaEnd').value,
		txtProAlertSta:$('alertDateFilterStart').value,
		txtProAlertEnd:$('alertDateFilterEnd').value,
		txtProOverdueSta:$('overdueDateFilterStart').value,
		txtProOverdueEnd:$('overdueDateFilterEnd').value,
		back:(back!=null?back:false),
		proId: $('cmbProcTitFilter').options[cmbProcTitFilter.selectedIndex].getAttribute("proId"),
		proNameAux: $('cmbProcTitFilter').value != "" ? $('cmbProcTitFilter').options[cmbProcTitFilter.selectedIndex].getAttribute("proName") : ""
	},null);		
}

function callNavigateFilterTasks(objParams, strParams,url){
	hideMessage();
	if (checkReqFilters()){
		if(!url){
			url = URL_REQUEST_AJAX;
		}
		var request = new Request({
			method: 'post',
			data: objParams,
			url: CONTEXT + url + '?action=filterTasks&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { sp.show(true); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
		}).send(strParams);
	}
} 

function getMessage(){
	var aux =  "";
	var i = GNR_REQUIRED.indexOf("<TOK1>");
	if ($('statusFilter').value==""){
		aux = GNR_REQUIRED.substring(0,i)+ STATUS +GNR_REQUIRED.substring(i+6,GNR_REQUIRED.length); 
	}else{
		aux = GNR_REQUIRED.substring(0,i)+ PROCESS_TITLE +GNR_REQUIRED.substring(i+6,GNR_REQUIRED.length);
	}
	return aux;
}

//establecer el orden
function setOrderByClass(obj){
	obj.toggleClass("orderedBy");
	if(obj.hasClass("unsorted")){
		obj.removeClass("unsorted")
		obj.addClass("sortUp");
	} else {
		if(obj.hasClass("sortUp")){
			obj.removeClass("sortUp")
			obj.addClass("sortDown");
		}else{
			obj.addClass("sortUp")
			obj.removeClass("sortDown");
		}
	}
	
}

function removeOrderByClass(obj){
	$('trOrderBy').getElements(".orderedBy").each(function(item, index){
	    item.removeClass("orderedBy");
	});
	
	$('trOrderBy').getElements(".sortUp").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortUp");
			item.addClass("unsorted");
		}
	});
	
	$('trOrderBy').getElements(".sortDown").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortDown");
			item.addClass("unsorted");
		}
	});
	
}

function download(){
	
	var pdf = $('pdf'); 
	var excel = $('excel'); 
	
	var all = $('all'); 
	
	var format = "csv";
	var count = "actual";
	if (pdf.checked){
		format="pdf";
	}else if (excel.checked){
		format = "excel";
	}
	
	if (all.checked){
		count = "all";
	}
	hideMessage();
	createDownloadIFrame("",DOWNLOADING,URL_REQUEST_AJAX,"download","&count="+count+"&format="+format,"","",null);
}
function processXMLResponseReload(ajaxCallXml){
	if (ajaxCallXml != null) {
		//recargar la pagina--- no se llama a la funcion navigate para que no borre los mensajes
		var currPage = parseInt($('navBarCurrentPage').value);
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX+'?action=page&isAjax=true&pageNumber='+currPage + TAB_ID_REQUEST,
			onRequest: function() { sp.show(true); },
			onComplete: function(resText, resXml) { processXMLListResponse(resXml); sp.hide(true); }
		}).send();
		
		//obtener el codigo de retorno
		var code = ajaxCallXml.getElementsByTagName("code");
		if("0" == code.item(0).firstChild.nodeValue){
			
			
		} else {
			//si el codigo es diferente de 0	
			var messages = ajaxCallXml.getElementsByTagName("messages");
			if (messages != null && messages.length > 0 && messages.item(0) != null) {
				messages = messages.item(0).getElementsByTagName("message");
				for(var i = 0; i < messages.length; i++) {
					var message = messages.item(i);
					var text	= message.getAttribute("text");
					showMessage(text);	
				}
			}
			
			messages = ajaxCallXml.getElementsByTagName("exceptions");
			if (messages != null && messages.length > 0 && messages.item(0) != null) {
				messages = messages.item(0).getElementsByTagName("exception");
				for(var i = 0; i < messages.length; i++) {
					var message = messages.item(i);
					var text	= message.getAttribute("text");
					showMessage(text);	
				}
			}
		}
	}
}

function loadTasksByProcess(cmbProcTitFilter){
	cleanCmbTskTitFilter();
	var cmbValue = cmbProcTitFilter.value;
	if (cmbValue != null && cmbValue != ""){
		var proId = cmbProcTitFilter.options[cmbProcTitFilter.selectedIndex].getAttribute("proId");
		var request = new Request({
			method : 'post',
			url : CONTEXT + URL_REQUEST_AJAX + '?action=loadTasksByProcess&isAjax=true&proId=' + proId + TAB_ID_REQUEST,
			onRequest : function() { },
			onComplete : function(resText, resXml) { processXmlTasksByProcess(resXml); }
		}).send();
	}
}

function cleanCmbTskTitFilter(){
	var cmbTskTitFilter = $('cmbTskTitFilter');
	while(cmbTskTitFilter.options.length>0){
		cmbTskTitFilter.options[0].parentNode.removeChild(cmbTskTitFilter.options[0]);
	}
	cmbTskTitFilter.options[0] = new Option("","");
	cmbTskTitFilter.value = "";
}

function processXmlTasksByProcess(resXml){
	var cmbTskTitFilter = $('cmbTskTitFilter');
	var tasks = resXml.getElementsByTagName("tasks")
	if (tasks != null && tasks.length > 0 && tasks.item(0) != null) {
		tasks = tasks.item(0).getElements("task");
				
		for (var i = 0; i < tasks.length; i++){
			var tsk = tasks[i];
			cmbTskTitFilter.options[i+1] = new Option(tsk.getAttribute("id"),tsk.getAttribute("text"));			
		}
	}
	
	if (cmbTskTitFilterValue != null){
		cmbTskTitFilter.value = cmbTskTitFilterValue;
		cmbTskTitFilterValue = null;
	}
}

function reloadList(){
	callNavigate();
}
