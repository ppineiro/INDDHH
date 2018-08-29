function resizeImg(which, w, h) {	
	try{
	  	elem = which;
	  	if (elem == undefined || elem == null) return false;
	  	
	  	var t;
	  	var wt = elem.width;
	  	var ht = elem.height;
	  	
	  	if (wt > w) {
	  		t = wt / w;
	  		wt = wt / t;
	  		ht = ht / t;
	  	}
	  	
	  	if (ht > h) {
	  		t = ht / h;
	  		ht = ht / h;
	  		wt = wt / h;
	  	}
	
		elem.width = wt;
		elem.height = ht;  
	}catch(e){
		alert(e);
	}		
}

function resizeImgBKP(which, max) {	
	document.getElementById("").re ;  	
  	//var elem = document.getElementById(which);  	
  	elem = which;
  	if (elem == undefined || elem == null) return false;
  	if (max == undefined) max = 100;
  	if (elem.width > elem.height) {
    	if (elem.width > max) elem.width = max;
  	} else {
    	if (elem.height > max) elem.height = max;
  	}
}