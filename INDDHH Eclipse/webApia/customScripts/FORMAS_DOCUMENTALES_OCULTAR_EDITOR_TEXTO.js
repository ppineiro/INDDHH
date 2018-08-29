function fnc_1001_1600(evtSource, par_ID_CAMPO) { 
	try{
		//alert(document.getElementById("BTN_MEMO_DATOS_BTN_VER_MEMO").parentNode.parentNode.innerHTML);
		//alert(document.getElementById("BTN_MEMO_DATOS_BTN_VER_MEMO").style.visibility);
		var cKids = document.getElementById("BTN_CONTENIDO_MEMO_BTN_VER_MEMO").parentNode.parentNode.children;
		/*
		for (var i=0;i<cKids.length;i++){
			//if (sTagName == cKids[i].innerHTML) return cKids[i];
			alert(i + " - " + cKids[i].innerHTML);   
		} 
		alert(cKids[1].style.visibility);
		*/
		if (cKids[1].style.visibility != "hidden"){
		
			var lbl = "DIV_" + par_ID_CAMPO + "_LBL";
			var data = "DIV_" + par_ID_CAMPO + "_DATA";
			
			document.getElementById(lbl).style.display="none";	
			document.getElementById(data).style.display="none";
			
		}
	}catch (e){}

return true; // END
} // END
