function initVisibilities() {
	var addPool = $('addPool');
	if (addPool) {
		if (window.IS_READONLY) {
			addPool.addClass('hidden');			
		} else{					
			addPool.addEvent("click", function(e) {
				e.stop();
				//abrir modal
				showPoolsModal(processPoolsModalReturn);
			}).addEvent('keypress', Generic.enterKeyToClickListener);
		}
	}
	if(!kb) {
		loadPools();
	}
}

function loadPools() {
	var request = new Request({
		method : 'post',
		url : CONTEXT + URL_REQUEST_AJAX + '?action=loadPools&isAjax=true'
				+ TAB_ID_REQUEST,
		onComplete : function(resText, resXml) {
			processXMLEntInstPools(resXml);
		}
	}).send();
}

function processXMLEntInstPools(ajaxCallXml) {
	if (ajaxCallXml != null) {
		var poolsXml = ajaxCallXml.getElementsByTagName("pools");
		if (poolsXml != null && poolsXml.length > 0 && poolsXml.item(0) != null) {
			var pools = poolsXml.item(0).getElementsByTagName("pool");
			for ( var i = 0; i < pools.length; i++) {
				var pool = pools.item(i);
				var name = pool.getAttribute("poolName");
				var id = pool.getAttribute("poolId");
				var canUpdate = pool.getAttribute("canUpdate") == "true";
				var content = addActionElement($('poolsContainter'), name, id,
						"poolId");

				new Element('span.checkcontainer', {
					html : ' ' + LBL_CAN_UPDATE + ': '
				}).inject(content);
				var checkbox = new Element('input', {
					type : 'checkbox',
					name : 'chkVisPoolUpdate' + id
				}).inject(content);
				checkbox.addEvent('click', function(evt) {
					evt.stopPropagation();
				});
				if (canUpdate)
					checkbox.checked = true;

				if (IS_READONLY) {
					content.addClass("optionRemoveNoImg");
					content.removeClass("optionRemove");
					content.removeEvents("click");
					content.removeEvents("mouseenter");
					content.removeEvents("mouseleave");
					checkbox.disabled = true;
				}
			}
		}
	}
}

function processPoolsModalReturn(ret) {
	ret.each(function(e) {
		var id = e.getRowId();
		var name = e.getRowContent()[0];
		var content = addActionElement($('poolsContainter'), name, id, "poolId");

		if (content == null)
			return;
		new Element('span.checkcontainer', {
			html : ' ' + LBL_CAN_UPDATE + ': '
		}).inject(content);
		var checkbox = new Element('input', {
			type : 'checkbox',
			name : 'chkVisPoolUpdate' + id
		}).inject(content);
		checkbox.addEvent('click', function(evt) {
			evt.stopPropagation();
		});
	});
}