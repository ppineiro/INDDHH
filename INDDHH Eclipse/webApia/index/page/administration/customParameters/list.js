function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	var btnGoToView = $('btnGoToView');
	if (btnGoToView){
		btnGoToView.addEvent("click",function(e){
			e.stop();
			if (!MODE_SERVER){
				ADMIN_SPINNER.show(true);
				window.location = CONTEXT + URL_REQUEST_AJAX + '?action=goToViewMode&favFncId=182&forceModeView=true' + TAB_ID_REQUEST;
			}			
		});
	}
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	['orderByName','orderByLabel','orderByType','orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['orderByName','orderByLabel','orderByType','orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['nameFilter','labelFilter','descFilter','regUsrFilter'].each(setAdmFilters);
	
	$('regDateFilter').setFilter = setFilter;
	$('regDateFilter').addEvent("change", function(e) {
		this.setFilter();
	});
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['nameFilter','labelFilter','descFilter','regUsrFilter'].each(clearFilter);
		['regDateFilter'].each(clearFilterDate);
		$('projectFilter').value = '';
		$('typeFilter').value = '';
		$('requiredFilter').value = '';
		$('readonlyFilter').value = '';
		$('nameFilter').setFilter();
	});
	
	initAdminActions(false,false,false,false,true,false);
	initNavButtons();
	
	callNavigate();
	
	$("lastMemoryUpdate").set("html", lastMemoryUpdate);	
	$("lastDBUpdate").set("html", lastDBUpdate);	
	
	$("btnReloadPars").addEvent("click", 
			function(evt) { 			
				var request = new Request({
					method: 'post',
					url: CONTEXT + URL_REQUEST_AJAX + '?action=reloadParameters&isAjax=true' + TAB_ID_REQUEST,
					onRequest: function() { SYS_PANELS.closeAll(); SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { 
						if (synchronizedParameters)
							$("lastDBUpdate").removeClass('paramsDateStatus');
						modalProcessXml(resXml);  }
				}).send(); 
			}
	);
	
	if (!synchronizedParameters){
		//Resalto error en fecha BD		
		$("lastDBUpdate").addClass('paramsDateStatus');
		
		//Necesario debido a que se encuentra dentro del initPage
		setTimeout(function() {
			showConfirm(LABEL_CONFIRM_UPDATE, GNR_TIT_WARNING, 
					function(ret){					
							if (ret)
								$("btnReloadPars").fireEvent('click');					
					}, 'modalWarning');
		}, 500);
		
	}
	
	$("btnDelete").addEvent("onAfterDelete", 
		function(evt) { 			
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=getLastUpdate&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.closeAll(); SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) {					
					var code = resXml.getElementsByTagName("RESULT");
					code = code.item(0);
					$("lastMemoryUpdate").set("html", code.firstChild.nodeValue);	
					$("lastDBUpdate").set("html", code.firstChild.nodeValue);
					
					SYS_PANELS.closeAll(); }
			}).send(); 
		}
	);
}

//establecer un filtro
function setFilter(){
	callNavigateFilter({
		txtName: $('nameFilter').value,
		txtLabel: $('labelFilter').value,
		txtDesc: $('descFilter').value,			
		txtPrj: $('projectFilter').value,
		txtType: $('typeFilter').value,
		txtParRequired: $('requiredFilter').value,
		txtParReadonly: $('readonlyFilter').value,
		txtRegUsr: $('regUsrFilter').value,
		txtRegDte: $('regDateFilter').value
	},null);
}

function createDatePickerModalClone(){
	var cusParValueDte = $('custParValue');
	if (cusParValueDte){
		cusParValueDte.set("size","10");
		cusParValueDte.set("format",'d/m/Y');
		cusParValueDte.setStyle("width","80%");
		setAdmDatePicker(cusParValueDte);
	}
}

function reloadChanges(url) {
	if (url != null && url != undefined && url != ''){
		setTimeout(function() { 
			SYS_PANELS.closeAll(); 
			SYS_PANELS.showLoading();
			window.location = CONTEXT + url;			
		}, 1000);		
	}
}