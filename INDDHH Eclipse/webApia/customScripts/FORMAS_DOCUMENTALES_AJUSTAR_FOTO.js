
function fnc_1001_1230(evtSource) { 
	var cElems = document.getElementsByTagName('IMG');
	var iNumElems = cElems.length;
	for (var i=1;i<iNumElems;i++) {			
		if (cElems[i].id  == "imgFoto"){
			resizeImg(cElems[i], 50, 50);
			//alert("innerHTML: " + cElems[i].src);
			////cElems[i].width = '75px';
			//cElems[i].height = '75px';
			//alert("innerText: " + cElems[i].innerText);
			//alert(cElems[i].width + " - " + cElems[i].width);
			//alert(cElems[i].style.width + " - " + cElems[i].style.height);
			//if ((cElems[i].width > 75) && (cElems[i].height > 75)){
				//cElems[i].width = 200;
				//cElems[i].height = 200;				
				//resizeImg(cElems[i], 75, 75);
			//}
		}
	}
	
	
	/*
alert('aca');
	cElems = document.getElementById('imgFoto');
alert('aca1');	
	iNumElems = cElems.length;
alert(cElems.src);	
alert("innerHTML: " + cElems.innerHTML);
alert("innerText: " + cElems.innerText);
	for (var i=1;i<iNumElems;i++) {
		alert(i);
		//alert(cElems[i].src);
	}
*/

return true; // END
} // END
