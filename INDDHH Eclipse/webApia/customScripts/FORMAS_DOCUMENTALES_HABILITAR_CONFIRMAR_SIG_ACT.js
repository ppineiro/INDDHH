
function fnc_1001_3752(evtSource) { 
	try{
		if (document.getElementById("btnConf")!=null){
			document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, false);
		}
	}catch(e){
		//alert(e);
	}		

return true; // END
} // END
