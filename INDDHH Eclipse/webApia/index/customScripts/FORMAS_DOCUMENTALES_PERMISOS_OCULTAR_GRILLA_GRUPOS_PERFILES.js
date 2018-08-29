
function fnc_1001_4096(evtSource) { 

	var form = ApiaFunctions.getForm('USERCREATION');
	if (form.getField('usrprofiles') != null){
	
		//document.getElementById('USERCREATION_usrprofiles').parentNode.style.display="none";
		form.getField('usrprofiles').setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);				
		//document.getElementById('USERCREATION_usrprofiles').style.display="none";		
	}
	if (form.getField('usrgroups') != null) {
		
		form.getField('usrgroups').setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);		
		//document.getElementById('USERCREATION_usrgroups').parentNode.style.display="none";
	}
	
return true; // END
} // END
