function initPage(){
	$('btnConf').style.display = '';
	$('btnBackToList').style.display = '';
	$('divAdminActEdit').style.display = '';
	
	$('frmData').formChecker = new FormCheck(
			'frmData',
			{
				submit:false,
				display : {
					keepFocusOnError : 1,
					tipsPosition: 'left',
					tipsOffsetY: -12,
					tipsOffsetX: -10
				}
			}
		);
	
	
	$('btnConf').addEvent("click", function(e) {
		if (e) e.stop();
		
		var form = $('frmData');
		if (!form.formChecker.isFormValid()) return;
		
		var selPro = $('selPro');
		SYS_PANELS.showLoading();
		
		var cmbBusEntId = $('cmbBusEntId');
		var busEntInstId = cmbBusEntId.get("busEntInstId");
		if (busEntInstId == "") busEntInstId = null;
		
		if(!$('processes').hasClass('hidden') && selPro.value!="" ){
			
			var url = (busEntInstId == null) ? 
					'apia.execution.TaskAction.run?action=startCreationProcess&busEntId=' + cmbBusEntId.value + '&proId=' + selPro.value
				:
					'apia.execution.TaskAction.run?action=startAlterationProcess&busEntInstId=' + busEntInstId + '&busEntId=' + cmbBusEntId.value + '&proId=' + selPro.value;
			
			var inIframe = window.parent != null && window.parent.document != null;
			TAB_CONTAINER = document.getElementById("tabContainer");
			if (TAB_CONTAINER == null && inIframe) TAB_CONTAINER = window.parent.document.getElementById("tabContainer");

			TAB_CONTAINER.addNewTab(selPro.options[selPro.selectedIndex].innerHTML, url, null);
			
			$('btnBackToList').fireEvent('click');
		} else {
			var url = 'apia.execution.EntInstanceListAction.run?action=confirmSelection&busEntId=' + cmbBusEntId.value + TAB_ID_REQUEST;
			form.setProperty('action',url);
			form.fireEvent('submit');
		}
		
	});
	
	$('btnBackToList').addEvent("click", function(e) {
		if (e) e.stop();
		
		var form = $('frmData');
		
		if (e) SYS_PANELS.showLoading();
		
		var url = 'apia.execution.EntInstanceListAction.run?action=goBack' + TAB_ID_REQUEST;
		form.setProperty('action',url);
		
		form.fireEvent('submit');
	});
	
	$('frmData').addEvent('submit', function(e) {
		this.submit();
	});
	
	$('cmbBusEntId').addEvent('change', changeEntity);
	$('cmbBusEntId').fireEvent('change');

}

function changeEntity(){
	
	var value = null;
	var type = null;
	
	if (this.tagName.toUpperCase() == 'SELECT') {
		var selected = this.getSelected();
		value = selected[0].get('value');
		type = selected.get('proType');
	} else {
		value = this.get('value');
		type = this.get('proType');
	}
	
	if(type==ADMIN_BOTH || type==ADMIN_PROCESS){
		$('processes').removeClass('hidden');
		
		if (type==ADMIN_PROCESS) {
			$('processes').addClass('required');
			
		} else {
			$('processes').removeClass('required');
		}
		
		if(value!=null && value.length>0){
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=getProcessesForEntity&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() {  SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send("busEntId=" + value + "&type=" + type ); 
		}
	} else {
		$('processes').addClass('hidden');
	}
}

function loadProcessesCombo(){
	$('selPro').empty();
	var ajaxCallXml = getLastFunctionAjaxCall();
	
	var callConfirm = false;
	
	if (ajaxCallXml != null) {
		var processes = ajaxCallXml.getElementsByTagName("process");
		
		if (processes != null && processes.length > 0) {
			var selPro = $('selPro');
			callConfirm = processes.length == 1;
			for(i=0;i<processes.length;i++){
				var id = processes[i].getAttribute('id');
				var text = processes[i].getAttribute('text');
				var opt = new Element('option');
				opt.set('value',id);
				opt.set('text',text);
				opt.inject(selPro);
				if (callConfirm) opt.selected = true;
			}
			
			if (callConfirm) selPro.selectedIndex = 0;
		}
		
	}	
	SYS_PANELS.closeActive();
	
	if (callConfirm) $('btnConf').fireEvent("click");
};