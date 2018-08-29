var PAGE_NUMBER = 1;
var PAGES_COUNT = 1;

function initPage(){
	//Volver
	var btnBackToList = $('btnBackToList');
	if (btnBackToList){
		btnBackToList.addEvent('click', function(evt){
			window.location = CONTEXT + URL_REQUEST_AJAX + '?action=back' + TAB_ID_REQUEST;
		});	
	}
	//Cerrar
	var btnCloseTab = $('btnCloseTab');
	if (btnCloseTab){
		btnCloseTab.addEvent("click", function(e){
			getTabContainerController().removeActiveTab();
		});
	}
	
	//['btnBackToList','btnCloseTab'].each(setTooltip);
	
	var theFotterPrev = $$('div.theFotterPrev');
	if (theFotterPrev){ theFotterPrev.destroy(); }
	
	var tableData = $('tableData');
	if (tableData){
		var trs = tableData.getElements("tr");
		if (trs != null && trs.length > 0){
			
			for (var i = 0; i < trs.length; i++){
				trs[i].addClass(i % 2 == 0 ? 'trOdd' : '');
			}
			
			var lastTr = trs[trs.length-1];
			lastTr.addClass("lastTr");
		}
		
		addScrollTable(tableData);
	}	
	
	var pAnt = $('pAnt') ? toBoolean($('pAnt').value) : false;
	var pSig = $('pSig') ? toBoolean($('pSig').value) : false;
	PAGE_NUMBER = $('pNumber') ? Number.from($('pNumber').value) : 1;
	PAGES_COUNT = $('pCount') ? Number.from($('pCount').value) : 0;
	
	var navFirst = $('navFirst');
	if (navFirst) {
		if (pAnt){
			navFirst.addEvent("click", function(e){
				window.location = CONTEXT + URL_REQUEST_AJAX + '?action=openResultPage&page=1' + TAB_ID_REQUEST;
			});
		} else {
			navFirst.setStyle("display","none");
		}		
	}
	var navPrev = $('navPrev');
	if (navPrev) {
		if (pAnt){
			navPrev.addEvent("click", function(e){
				window.location = CONTEXT + URL_REQUEST_AJAX + '?action=openResultPage&page=' + (PAGE_NUMBER-1) + TAB_ID_REQUEST;
			});
		} else {
			navPrev.setStyle("display","none");
		}
	}
	var navNext = $('navNext');
	if (navNext){
		if (pSig){
			navNext.addEvent("click", function(e){
				window.location = CONTEXT + URL_REQUEST_AJAX + '?action=openResultPage&page=' + (PAGE_NUMBER+1) + TAB_ID_REQUEST;
			});
		} else {
			navNext.setStyle("display","none");
		}
	}
	var navLast = $('navLast');
	if (navLast) {
		if (pSig){
			navLast.addEvent("click", function(e){
				window.location = CONTEXT + URL_REQUEST_AJAX + '?action=openResultPage&page=' + PAGES_COUNT + TAB_ID_REQUEST;
			});
		} else {
			navLast.setStyle("display","none");
		}		
	}
	var navRefresh = $('navRefresh');
	if (navRefresh) navRefresh.setStyle("display","none");
	var navBarCurrentPage = $('navBarCurrentPage');
	if (navBarCurrentPage) {
		navBarCurrentPage.value = PAGE_NUMBER;
		navBarCurrentPage.disabled = true;
	}
	var navBarPageCount = $('navBarPageCount');
	if (navBarPageCount) navBarPageCount.innerHTML = PAGES_COUNT;
	var clearFilters = $('clearFilters');
	if (clearFilters) clearFilters.setStyle("display","none");
	
}
