function initPage(){
	initQueryButtons();
	initAdminFav();
	initAdminActions(!FLAG_BTN_CREATE,!FLAG_BTN_UPDATE,!FLAG_BTN_CLONE,!FLAG_BTN_DELETE,!FLAG_BTN_DEPENDENCIES);
	initNavButtons();	
	customizeRefresh();
	customizeButtons();
	callNavigateRefresh();
}

function customizeButtons() {
	
	var btnCreate = $('btnCreate');
	var btnUpdate = $('btnUpdate');
	var btnDelete = $('btnDelete');
	
	if (btnCreate) {
		btnCreate.removeEvents('click');
		btnCreate.addEvent("click", function(e) {
			e.stop();
			var request = new Request({
				method : 'post',
				url : CONTEXT + URL_REQUEST_AJAX + '?action=checkAction&isAjax=true&op=create' + TAB_ID_REQUEST,
				onRequest : function() { SYS_PANELS.showLoading(); },
				onComplete : function(resText, resXml) { SYS_PANELS.closeAll(); customModalProcessXml(resXml); }
			}).send();
		});
		
	}

	if (btnUpdate) {
		btnUpdate.removeEvents('click');
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
					var id = getSelectedRows($('tableData'))[0].getRowId();
					var request = new Request({
						method : 'post',
						url : CONTEXT + URL_REQUEST_AJAX + '?action=checkAction&isAjax=true&op=update' + TAB_ID_REQUEST,
						onRequest : function() { SYS_PANELS.showLoading(); },
						onComplete : function(resText, resXml) { SYS_PANELS.closeAll(); customModalProcessXml(resXml); }
					}).send('id=' + id);
				}
			}
		});
	}

	if (btnDelete) {
		btnDelete.removeEvents('click');
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
					var id = getSelectedRows($('tableData'))[0].getRowId();
					var request = new Request({
						method : 'post',
						url : CONTEXT + URL_REQUEST_AJAX + '?action=checkAction&isAjax=true&op=delete' + TAB_ID_REQUEST,
						onRequest : function() { SYS_PANELS.showLoading(); },
						onComplete : function(resText, resXml) { SYS_PANELS.closeAll(); customModalProcessXml(resXml); }
					}).send('id=' + id);
				}
			}
		});
	}
}

function customModalProcessXml (resXml) {
	var mainTag = resXml.getElementsByTagName('checkResult');
	if (mainTag && mainTag.length > 0 && mainTag.item(0) != null) {
		var tagResult = mainTag.item(0).getElementsByTagName('operation')[0];
		var opType = tagResult.getAttribute('opType');
		var allowOp = tagResult.getAttribute('allowOp');
		if (opType == 'create') {
			if (allowOp == 'true') {
				ADMIN_SPINNER.show(true);
				window.location = CONTEXT + URL_REQUEST_AJAX + '?action=create'
						+ TAB_ID_REQUEST;
			} else
				showMessage(LBL_CANT_CREATE_INST, GNR_TIT_WARNING, 'modalWarning');
		} else if (opType == 'update') {
			if (allowOp == 'true') {
				ADMIN_SPINNER.show(true);
				var id = getSelectedRows($('tableData'))[0].getRowId();
				window.location = CONTEXT + URL_REQUEST_AJAX + '?action=update&id=' + id + TAB_ID_REQUEST;
			} else
				showMessage(LBL_CANT_UPDATE_INST, GNR_TIT_WARNING, 'modalWarning');
		} else if (opType == 'delete') {
			if (allowOp == 'true') {
				SYS_PANELS.newPanel();
				var panel = SYS_PANELS.getActive();
				panel.addClass("modalWarning");
				panel.content.innerHTML = CONFIRM_ELEMENT_DELETE;
				panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); btnDeleteClickConfirm();\">"
						+ GNR_NAV_ADM_DELETE + "</div>";
				SYS_PANELS.addClose(panel);
				SYS_PANELS.refresh();
			} else
				showMessage(LBL_CANT_DELETE_INST, GNR_TIT_WARNING, 'modalWarning');
		}
	}
	
//	
//	var mainTag = resXml.getElementsByTagName('checkResult');
//	var opType = mainTag.item(0).getAttribute('operation');
//	if (opType == 'create') {
//		if (mainTag && mainTag.length > 0 && mainTag.item(0) != null) {
//			var tagResult = mainTag.item(0).getElementsByTagName("create")[0];
//			var entityAllwInstUpd = tagResult.getAttribute("allowCreate");
//			
//			if ('true' == entityAllwInstUpd) {
//				ADMIN_SPINNER.show(true);
//				window.location = CONTEXT + URL_REQUEST_AJAX + '?action=create'
//						+ TAB_ID_REQUEST;
//			} else {
//				showMessage(LBL_CANT_CREATE_INST, GNR_TIT_WARNING, 'modalWarning');
//			}
//		}
//	} else if (opType == 'update') {
//		if (mainTag && mainTag.length > 0 && mainTag.item(0) != null) {
//			var tagResult = mainTag.item(0).getElementsByTagName("update")[0];
//			var entityAllwInstUpd = tagResult.getAttribute("allowUpdate");
//			
//			if ('true' == entityAllwInstUpd) {
//				ADMIN_SPINNER.show(true);
//				var id = getSelectedRows($('tableData'))[0].getRowId();
//				
//				window.location = CONTEXT + URL_REQUEST_AJAX + '?action=update&id=' + id + TAB_ID_REQUEST;
//			} else {
//				showMessage(LBL_CANT_UPDATE_INST, GNR_TIT_WARNING, 'modalWarning');
//			}
//		}
//	} else if (opType == 'delete') {
//		if (mainTag && mainTag.length > 0 && mainTag.item(0) != null) {
//			var tagResult = mainTag.item(0).getElementsByTagName("delete")[0];
//			var entityAllwInstUpd = tagResult.getAttribute("allowDelete");
//			
//			if ('true' == entityAllwInstUpd) {
//				SYS_PANELS.newPanel();
//				var panel = SYS_PANELS.getActive();
//				panel.addClass("modalWarning");
//				panel.content.innerHTML = CONFIRM_ELEMENT_DELETE;
//				panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); btnDeleteClickConfirm();\">"
//						+ GNR_NAV_ADM_DELETE + "</div>";
//				SYS_PANELS.addClose(panel);
//
//				SYS_PANELS.refresh();
//			} else {
//				showMessage(LBL_CANT_DELETE_INST, GNR_TIT_WARNING, 'modalWarning');
//			}
//		}
//	}
}

