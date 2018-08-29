
<%@ taglib uri='/WEB-INF/regions.tld' prefix='region' %><%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %><div class="tabContent"><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtEjeEntAsoc" /></div><%@include file="../../modals/entityInstances.jsp" %><%@include file="../../generic/asociations.jsp"%></div></div><script type="text/javascript">	
	$('tableDataAsoc').formChecker = new FormCheck(
			'tableDataAsoc',
			{
				submit:false,
				display : {
					keepFocusOnError : 1,
					tipsPosition: 'left',
					tipsOffsetY: 10,
					tipsOffsetX: -10
				}
			}
	);
	
	var btnAddAsoc = $('btnAddAsoc');
	if (btnAddAsoc &&!IS_READONLY){		
		btnAddAsoc.addEvent("click",function(e){
			e.stop();
			addRowAsoc($('tableDataAsoc'),null);
		});
	}
	
	var btnDeleteDesc = $('btnDeleteAsoc');
	if (btnDeleteDesc && !IS_READONLY){
		btnDeleteDesc.addEvent("click",function(e){
			e.stop();			
			var selected = new Array(getSelectedRows($('tableDataAsoc'))[0]);
			if (selected){
				disposeValidation(selected);
			}
			deleteRow($('tableDataAsoc'));
		});
	}
	
	var gridButtons = $('idGridButtons');
	if (gridButtons && IS_READONLY){
		gridButtons.destroy();
	}
</script>