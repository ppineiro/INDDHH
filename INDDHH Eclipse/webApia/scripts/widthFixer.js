// JavaScript Document

function fixWidths(){
	var tables=document.getElementsByTagName("TABLE");
	for(var i=0;i<tables.length;i++){
		if(table[i].style.width.indexOf("%")>=0){
			width=table[i].style.width.split("%")[0];
			table[i].style.width=((width/100)*table[i].parentNode.clientWidth)+"px";
		}
		if(table[i].width.indexOf("%")>=0){
			width=table[i].width.split("%")[0];
			table[i].style.width=((width/100)*table[i].parentNode.clientWidth)+"px";
		}
		var tds=table[i].getElementsByTagName("thead")[0].childNodes;
		for(var u=0;u<tds.length;u++){
			if(tds[u].style.width.indexOf("%")>=0){
				width=tds[u].style.width.split("%")[0];
				tds[u].style.width=((width/100)*table[i].clientWidth)+"px";
			}
			if(tds[u].width.indexOf("%")>=0){
				width=tds[u].width.split("%")[0];
				tds[u].style.width=((width/100)*table[i].clientWidth)+"px";
			}
		}
	}
}

fixWidths();