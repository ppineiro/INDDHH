
<%@ taglib uri='/WEB-INF/regions.tld' prefix='region' %><%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %><div class="tabContent"><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtEjeEntVis" /></div><%@include file="../../generic/visibilities.jsp"%></div></div><script type="text/javascript">
	if ($('addPool')){
		if (IS_READONLY){
			$('addPool').addClass('hidden');			
		}
		else{					
			$('addPool').addEvent("click", function(e) {
				e.stop();
				//abrir modal
				showPoolsModal(processPoolsModalReturn);
			});		
		}
	}	
</script>