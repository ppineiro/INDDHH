

function abrirSis(desktopURL,valores){
	if (valores=="1"){
		valores="height= " + 570 + " , " + "width= " + 790
	}else{
		valores="height= " + (screen.availHeight-30) + " , " + "width= " + (screen.availWidth-10)
	}
	valores = "toolbar=no,location=no,status=no,menubar=no,resizable=yes,scrollbars=yes,top=0,left=0," + valores
	x="\""
	valores = x + valores + x
	window.open (desktopURL,"_DOGMA", valores);
}