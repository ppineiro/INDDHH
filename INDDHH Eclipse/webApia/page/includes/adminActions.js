function initAdminActions(hideBtnCre,hideBtnUpd,hideBtnClo,hideBtnDel,hideBtnDep, hideBtnClose) {
	ADMIN_SPINNER = new Spinner(document.body, {
		message : WAIT_A_SECOND
	});

	if(Browser.opera)
		ADMIN_SPINNER.content.getParent().addClass('documentSpinner');
	
	var btnCreate = $('btnCreate');
	var btnUpdate = $('btnUpdate');
	var btnDelete = $('btnDelete');
	var btnClone = $('btnClone');
	var btnDependencies = $('btnDependencies');
	var btnCloseTab = $('btnCloseTab');

	if (!hideBtnCre && btnCreate) btnCreate.style.display = '';
	if (!hideBtnUpd && btnUpdate) btnUpdate.style.display = '';
	if (!hideBtnClo && btnClone) btnClone.style.display = '';
	if (!hideBtnDel && btnDelete) btnDelete.style.display = '';
	if (!hideBtnDep && btnDependencies) btnDependencies.style.display = '';
	if (!hideBtnClose && btnCloseTab) btnCloseTab.style.display = '';

	/*
	$$("div.button").each(function(ele) {
		ele.addEvent("onmouseover", function(evt) {
			this.toggleClass("buttonHover")
		});
		ele.addEvent("onmouseout", function(evt) {
			this.toggleClass("buttonHover")
		});
	});
	*/
	
	if (btnCreate) {
		btnCreate.addEvent("click", function(e) {
			e.stop();
			ADMIN_SPINNER.show(true);
			window.location = CONTEXT + URL_REQUEST_AJAX + '?action=create'
					+ TAB_ID_REQUEST;
		});
		
	}

	if (btnUpdate) {
		btnUpdate.addEvent("click", function(e) {
			e.stop();
			// verificar que solo un usuario est� seleccionado
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var uneditableTR = getSelectedRows($('tableData'))[0].get('uneditableTR') == "false" ? true : false;
				uneditableTR = uneditableTR || getSelectedRows($('tableData'))[0].hasClass('uneditableTR');
				
				if (uneditableTR) {
					showConfirm(MSG_ELE_ONLY_READ,  GNR_TIT_WARNING,  function(ret) {  
						if (ret) {
							ADMIN_SPINNER.show(true);
							var id = getSelectedRows($('tableData'))[0].getRowId();
							window.location = CONTEXT + URL_REQUEST_AJAX + '?action=update&onlyRead=true&id=' + id + TAB_ID_REQUEST;
						} 
					}, "modalWarning");
				} else {
					// obtener el usuario seleccionado
					ADMIN_SPINNER.show(true);
					var id = getSelectedRows($('tableData'))[0].getRowId();
					
					window.location = CONTEXT + URL_REQUEST_AJAX + '?action=update&id=' + id + TAB_ID_REQUEST;
				}
			}
		});
	}

	if (btnDelete) {
		btnDelete.addEvent("click", function(e) {
			e.stop();
			hideMessage();
			if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var rows = getSelectedRows($('tableData'));
				var uneditableTR = false;
				if(rows && rows.length) {
					for(var i = 0; i < rows.length; i++) {
						uneditableTR = uneditableTR || rows[i].get('uneditableTR') == "true" || rows[i].hasClass('uneditableTR');
					}
				}
								
				if (uneditableTR) {
					showMessage(MSG_ELE_CANT_DELETE, GNR_TIT_WARNING, "modalWarning");
				} else {
					SYS_PANELS.newPanel();
					var panel = SYS_PANELS.getActive();
					panel.addClass("modalWarning");
					panel.content.innerHTML = CONFIRM_ELEMENT_DELETE;
					panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); btnDeleteClickConfirm();\">"
							+ GNR_NAV_ADM_DELETE + "</div>";
					SYS_PANELS.addClose(panel);

					SYS_PANELS.refresh();
				}
			}
		});
	}

	if (btnClone) {
		btnClone.addEvent("click", function(e) {
			e.stop();
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				
				var selectedRow = getSelectedRows($('tableData'))[0];
				var unclonableTR = selectedRow.get('unclonableTR') == "true" || selectedRow.hasClass('unclonableTR');
				
				var uneditableTR = getSelectedRows($('tableData'))[0].get('uneditableTR') == "false" ? true : false;
				uneditableTR = uneditableTR || getSelectedRows($('tableData'))[0].hasClass('uneditableTR');
				
				var canClone = getSelectedRows($('tableData'))[0].hasClass('canClone') || getSelectedRows($('tableData'))[0].get('canClone') == "true";
				
				if(unclonableTR || (uneditableTR && !canClone)) {
					showMessage(MSG_ELE_CANT_CLONE, GNR_TIT_WARNING, "modalWarning");
				} 
				else {
					// obtener el usuario seleccionado
					var id = selectedRow.getRowId();
					var request = new Request({
						method : 'post',
						url : CONTEXT + URL_REQUEST_AJAX + '?action=clone&isAjax=true' + TAB_ID_REQUEST,
						onRequest : function() {
							SYS_PANELS.showLoading();
						},
						onComplete : function(resText, resXml) {
							SYS_PANELS.closeAll();
							modalProcessXml(resXml);
						}
					}).send('id=' + id);
				}
			}
		});
	}

	if (btnDependencies) {
		btnDependencies.addEvent("click", function(e) {
			e.stop();
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING,
						'modalWarning');
			} else {
				// obtener el usuario seleccionado
				var id = getSelectedRows($('tableData'))[0].getRowId();

				var request = new Request({
					method : 'post',
					url : CONTEXT + URL_REQUEST_AJAX
							+ '?action=loadDeps&isAjax=true&id=' + id
							+ TAB_ID_REQUEST,
					onRequest : function() {
						SYS_PANELS.showLoading();
					},
					onComplete : function(resText, resXml) {
						modalProcessXml(resXml);
					}
				}).send();

			}
		});
	}
	
	if (btnCloseTab) {
		btnCloseTab.addEvent('click', closeCurrentTab);
	}

	initAdminFav();
	
	$$('div.fncDescriptionImage').each(function(e){
		var path = 'url(' + e.get('data-src') + ')'
		e.setStyle('background-image', path);
		e.setStyle('background-repeat', 'no-repeat');
		e.setStyle('width', '64px');
		e.setStyle('height', '64px');
	});
	
	
	//['btnCreate','btnUpdate','btnDelete','btnClone','btnDependencies','btnCloseTab'].each(setTooltip);
}

function downloadElementDependencies(id) {
	createDownloadIFrame("",DOWNLOADING,URL_REQUEST_AJAX,"downloadDeps","&id="+id,"","",null);
}

function btnDeleteClickConfirm() {
	var selected = getSelectedRows($('tableData'));
	var selection = "";
	for (i = 0; i < selected.length; i++) {
		selection += selected[i].getRowId();
		if (i < selected.length - 1) {
			selection += ";";
		}
	}
	if(PRIMARY_SEPARATOR_IN_BODY) {
		new Request({
			method : 'post',
			url : CONTEXT + URL_REQUEST_AJAX + '?action=delete&isAjax=true'
					+ TAB_ID_REQUEST,
			onRequest : function() {
				sp.show(true);
			},
			onComplete : function(resText, resXml) {
				modalProcessXml(resXml);
				btnDelete.fireEvent('onAfterDelete');
				sp.hide(true);
			}
		}).send('id=' + selection);
	} else {
		new Request({
			method : 'post',
			url : CONTEXT + URL_REQUEST_AJAX + '?action=delete&isAjax=true&id='
					+ selection + TAB_ID_REQUEST,
			onRequest : function() {
				sp.show(true);
			},
			onComplete : function(resText, resXml) {
				modalProcessXml(resXml);
				btnDelete.fireEvent('onAfterDelete');
				sp.hide(true);
			}
		}).send();
	}
}

function closeCurrentTab() {
	getTabContainerController().removeActiveTab();
}