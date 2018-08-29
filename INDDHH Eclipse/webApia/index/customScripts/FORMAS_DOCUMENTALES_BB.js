
function fnc_1001_2030(evtSource) { 
	/*
	alert(evtSource.parentNode);
	alert(evtSource.parentNode.innerHTML);	
	alert(evtSource.parentNode.parentNode.innerHTML);
	alert(evtSource.parentNode.parentNode.parentNode.innerHTML);
	*/
	
	var vIndex = evtSource.index;	
	var cKids;
	
	if (vIndex==0){
		cKids = evtSource.parentNode.parentNode.parentNode.children;
	}else{
		cKids = evtSource.parentNode.parentNode.children;	
	}
	
	/*	
	for (var i=0;i<cKids.length;i++){
		//if (sTagName == cKids[i].innerHTML) return cKids[i];
		//alert(i + " - " + cKids[i].innerHTML);   
	}
	*/
	
	var nroExp  = cKids[3].innerHTML;	
	verFoliado(nroExp);


return true; // END
} // END
