function initPage(){
	//Se verifica si existe algún error
	if ($('gridErrMsgs')) return;
	
	$$('div.fncDescriptionImage').each(function(e){
		var path = 'url(' + e.get('data-src') + ')'
		e.setStyle('background-image', path);
		e.setStyle('background-repeat', 'no-repeat');
		e.setStyle('width', '64px');
		e.setStyle('height', '64px');
	});
	
	initQueryButtons();
	initAdminFav();
	
	var btnsAction = $$('*.actionBtn');
	for(var i = 0; i < btnsAction.length; i++) {
		btnsAction[i].addEvent('click', function(e) {
			e.stop();
			var tableData = $('tableData');
			
			if (selectionCount(tableData) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				$('frmBtnActionsNavTo').set('value', e.target.getParent('div.actionBtn').get('id'));
				$('frmBtnActionsId').set('value', getSelectedRows($('tableData'))[0].getRowId());
				doAjaxSubmit('frmBtnActions', true);
			}
		});
	}
	
	var btnGoBack = $('btnGoBack');
	if (btnGoBack) {
		btnGoBack.addEvent('click', function(evt){
			SYS_PANELS.showLoading();
			document.location = CONTEXT + URL_REQUEST_AJAX + "?action=returnAction"  + TAB_ID_REQUEST;
		});
	}
	
	var btnCloseTab = $('btnCloseTab');
	if (btnCloseTab) {
		btnCloseTab.addEvent('click', function() {
			if(FROM_MINISITE) {
				SYS_PANELS.showLoading();
				window.parent.location = 'apia.security.LoginAction.run?action=gotoMinisiteQueries' + TAB_ID_REQUEST;
			} else {	
				getTabContainerController().removeActiveTab();
			}
		});
	}
	
	calculateRequiredForChart();
	initChartButtons();
	
	var showRegs = $('showRegs');
	
	if (showRegs) {
		/*showRegs.url = URL;*/
		showRegs.addEvent("change", function(e) {
			e.stop();
			new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=setAmount&isAjax=true&pageNumber=1&amount=' + showRegs.options[showRegs.selectedIndex].value + TAB_ID_REQUEST,
				onRequest: function() { sp.show(true); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
			}).send(); 
		});
	}
	
	var btnDocuments = $('btnDocuments');
	if (btnDocuments){
		btnDocuments.addEvent("click",function(e){
			e.stop();
			//verificar que solo un registro esta seleccionado
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if(selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var id = getSelectedRows($('tableData'))[0].getRowId();
				var request = new Request({
					method: 'post',
					url: CONTEXT + URL_REQUEST_AJAX + '?action=getQueryInfoForMonDocument&isAjax=true&id=' + id + TAB_ID_REQUEST,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); }
				}).send();
			}
		});
	}
	
	//['btnActions','btnGoBack','btnPrint','btnDocuments'].each(setTooltip);
	
	var btnPrint = $('btnPrint');
	if(btnPrint){
		btnPrint.addEvent('click', function(e){
			var results = new Array();
			var headers = new Array(); 
			var values = new Array();	
			var graphs = new Array();
			
			//results
			results.push(QUERY_RESULTS.replace('<TOK_1>',$('amountRecordsValue').innerHTML));
			if ($('hasMore') && !$('hasMore').hasClass("hidden")){
				results.push(QUERY_MORE_DATA);
			}
			//headers
			$('trOrderBy').getElements("th").each(function(th){
				if(th.get('data-moreInfo')) return;
				
				var div = th.getElement("div");
				headers.push(div.innerHTML);
			});
			//values
			$('tableData').getElements("tr").each(function(tr, index) {
				//if(index % 2 == 0) {
				if(!tr.hasClass('info')) {
					var trContent = tr.getRowContent();
					values.push(trContent);
				}
			});
			//graphs
			if ($('chartContainer')){
				var chartValues = new Array();
				$$('div.chartButton').each(function (chartBtn){
					chartValues.push({'id':chartBtn.get("data-qryChtId"), 'title': chartBtn.get("title")});
				});
				
				for (var i = 0; i < chartValues.length; i++){
					graphs.push(
						new Element('img', {
							'class': 'chartImg',
							'id': 'chartImg' + chartValues[i].id,
							'title': chartValues[i].title,
							'src': CONTEXT + URL_REQUEST_AJAX + "?action=showChart&qryChtId=" + chartValues[i].id + "&sizeX=" + SIZE_X + "&sizeY=" + SIZE_Y + "&bgc=" + escape(BGC) + "&UID=" + Math.random() + TAB_ID_REQUEST}
						)
					);
				}
			}			
			
			printUserQuery(QUERY_TITLE,results,headers,values,graphs);
		});
	}
	
	$$('div.tabHolder').each(function(div){
		div.setStyle('margin-right','0px');
	});
	$$('div.tabComponent').each(function(div){
		div.setStyle('margin-right','0px');
	});
	
	//CAM_12242: cuando se cambia de tabs se actualiza scroll de tabla
	$$('div.tab').each(function(tab){

		tab.addEvent('custom_blur', function() {
			var gridBodys = $('gridContainer').getElements('div.gridBody');
			
			if(gridBodys && gridBodys.length) {
				setTimeout(function() {
					gridBodys.each(function(gridBody) {
						addScrollTable(gridBody.getElement('.tableData'));
					});
				}, 50);
			}
		});
	});
	
	initNavButtons();
	customizeRefresh();
	callNavigateRefresh();
}

function initChartButtons() {
	$$('div.chartButton').each(function(ele) {
		ele.addEvent('click', showChart);
	});
	
	var chartContainer = $('chartContainer');
	if (chartContainer) {
		chartContainer.parentNode.tabTitle.addEvent('focus', function(evt){
			loadChart(null);
		});
	}
}

function showChart(evt) {
	var tabComponent = $('tabComponent');
	if (! tabComponent) return false;
	
	$('chartContainer').set("data-qryChtId", null);
	
	tabComponent.changeTo(1);
	loadChart(this.get("data-qryChtId"));
}

function loadChart(qryChtId) {
	var chartContainer = $('chartContainer');
	if (! chartContainer) return;
	if (qryChtId == null) {
		qryChtId = chartContainer.get("data-qryChtId");
		if (qryChtId==null) qryChtId = chartContainer.getElements("img").get("data-qryChtId")[0];
		chartContainer.set("data-qryChtId", null);
	}
	if (qryChtId == null) return;
	
	chartContainer.getElements("img.chartImg").each(function(ele) {
		if (ele.zoomerContainer) {
			ele.zoomerContainer.addClass('hidden');
		} else {
			ele.addClass('hidden');
		}
	});
	
	var chartImg = $('chartImg' + qryChtId);
	
//	if (! chartImg)	{
	if (chartImg) chartImg.destroy(chartContainer);
	chartImg = new Element('img', {
			'class': 'chartImg',
			'id': 'chartImg' + qryChtId, 
			'src': CONTEXT + URL_REQUEST_AJAX + "?action=showChart&qryChtId=" + qryChtId + "&sizeX=" + SIZE_X + "&sizeY=" + SIZE_Y + "&bgc=" + escape(BGC) + "&UID=" + Math.random() + TAB_ID_REQUEST});
		chartImg.set('data-qryChtId', qryChtId);
		chartImg.inject(chartContainer);
		chartImg.addEvent('click', doZoom);
//	}
	
	
	if (chartImg.zoomerContainer) {
		chartImg.zoomerContainer.removeClass('hidden');
	} else {
		chartImg.removeClass('hidden');
	}
}

function doZoom(evt) {
	if (this.get('hasZoom') == 'true') return;
	
	this.set('hasZoom', 'true');
	var qryChtId = this.get('data-qryChtId');
	
	new Zoomer(this, {big: CONTEXT + URL_REQUEST_AJAX + "?action=showChart&qryChtId=" + qryChtId + "&sizeX=" + (SIZE_X * 2) + "&sizeY=" + (SIZE_Y * 2) + "&bgc=" + escape(BGC) + "&UID=" + Math.random() + TAB_ID_REQUEST});
}

var BGC = null;
var SIZE_X = 900;
var SIZE_Y = 500;

function calculateRequiredForChart() {
	if (document.body.currentStyle){
		var oStyleSheet=document.styleSheets[0];
		var oRule=oStyleSheet.rules[0];
		BGC = oRule.style.backgroundColor;
	}
	if (BGC == null || BGC == "") {
		var BGCAux = null;
		try { BGCAux=window.getComputedStyle(document.body,"").getPropertyValue("background-color"); } catch(e) { BGCAux = "(255,255,255)"; }
		if (BGCAux == 'transparent' || BGCAux && BGCAux.rgbToHex() == 'transparent') 
			BGCAux = "(255,255,255)";
		
		BGCAux=BGCAux.split("(")[1];
		BGCAux=BGCAux.split(")")[0];
		
		BGC="#";
		BGC+=( (parseInt(BGCAux.split(",")[0]).toString(16)) + (parseInt(BGCAux.split(",")[1]).toString(16)) + (parseInt(BGCAux.split(",")[2]).toString(16)) );
	}
}

function initTabContainer() {
	if (! TAB_CONTAINER) {
		var inIframe = window.parent != null && window.parent.document != null;
		TAB_CONTAINER = document.getElementById("tabContainer");
		if (TAB_CONTAINER == null && inIframe) TAB_CONTAINER = window.parent.document.getElementById("tabContainer");
		
		try {
			if(TAB_CONTAINER == null && inIframe) {
				var curr_window = window;
				while(TAB_CONTAINER == null && curr_window != curr_window.parent) {
					curr_window = curr_window.parent;
					TAB_CONTAINER = curr_window.document.getElementById("tabContainer");
				}
			}
		} catch(error) {
			
		}
		
		if (TAB_CONTAINER == null) {
			TAB_CONTAINER = new Object();
			TAB_CONTAINER.addNewTab = function(name, url) {
				showMessage(Generic.formatMsg(ERR_OPEN_URL, name, url));
			}
		}
	}
}

function fncExecuteAction() {
	var ajaxCallXml = getLastFunctionAjaxCall();
	var doRefresh = ajaxCallXml.getAttribute("doRefresh");
	var openTab = ajaxCallXml.getAttribute("openTab");
	var url = ajaxCallXml.getAttribute("url");
	var fncId = ajaxCallXml.getAttribute("fncId");
	var title = ajaxCallXml.getAttribute("title");
	
	if (doRefresh == "true") {
		//$('navRefresh').fireEvent('click');
		document.location = CONTEXT + URL_REQUEST_AJAX + "?action=list" + TAB_ID_REQUEST;
	} else if (openTab == "true") {
		initTabContainer();
		
		if(url.indexOf('?') > 0){
			//CAM_12092: Se altera comportamiento para que se permita modificar una entidad desde
			// ejecucion de consultas del usuario
			
			if (url.indexOf('action=update') < 0)
				url += "&fromEntQuery=true";
			
			if (url.indexOf('action=update') > 0)
				url += "&fromWorkEntity=true";
		}
			
				
		TAB_CONTAINER.addNewTab(title,url,fncId);
	}
	
	SYS_PANELS.closeAll();
}



function openMonDocument(envId, procTitle, procRegInst, busEntTitle, busEntRegInst, qryTitle){
	SYS_PANELS.closeAll();
	var tabContainer = window.parent.document.getElementById('tabContainer');
	var url = CONTEXT + URL_REQUEST_AJAX_MON_DOCUMENT + '?action=init&favFncId=54&preFilQuery=true&envId=' + envId + '&procTitle=' + procTitle + '&procRegInst=' + procRegInst + '&busEntTitle=' + busEntTitle + '&busEntRegInst=' + busEntRegInst + '&qryTitle=' + qryTitle + TAB_ID_REQUEST;
	tabContainer.addNewTab(MON_DOC_TAB_TITLE,url,null);		
}