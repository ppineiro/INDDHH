function gantt(){	
	var url = GANTT_CMP_PATH+"width=" + cmpWidth+TAB_ID_REQUEST;
	document.getElementById("img"+GANTT_REAL_HOPED).src= url+"&type="+GANTT_REAL_HOPED;
	document.getElementById("img"+GANTT_REAL).src=url+"&type="+GANTT_REAL;
}
