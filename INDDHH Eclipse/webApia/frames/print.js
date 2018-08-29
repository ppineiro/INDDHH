var aux="";
function start() {
	var tabs = new Array();
	for(var i=0;i<document.getElementsByTagName("div").length;i++){
		if(document.getElementsByTagName("div")[i].getAttribute("type")=="tab"){
			tabs.push(document.getElementsByTagName("div")[i]);
		}
	}
	var tabContent="";
	for (i = 0; i < tabs.length; i++) {
		tabContent+=tabs[i].innerHTML;
	}
	if(tabs.length>0){
		document.getElementById("divContent").innerHTML=tabContent;
		var tabContainer=document.getElementById("tabContainer");
		var tabBottom=document.getElementById("tabBottom");
		tabContainer.parentNode.removeChild(tabContainer);
		tabBottom.parentNode.removeChild(tabBottom);
	}
	for(var i=0;i<document.getElementsByTagName("div").length;i++){
		if(document.getElementsByTagName("div")[i].offsetWidth>=635){
			document.getElementsByTagName("div")[i].style.width="90%";
		}
		if(document.getElementsByTagName("div")[i].offsetWidth>=635 && document.getElementsByTagName("div")[i].getAttribute("type")=="grid"){
			document.getElementsByTagName("div")[i].style.width="90%";
		}
		if(document.getElementsByTagName("div")[i].className!="dataGridContent"){
			document.getElementsByTagName("div")[i].style.position="relative";
		}
	}
	for(var i=0;i<document.getElementsByTagName("table").length;i++){
		if(document.getElementsByTagName("table")[i].clientWidth>=635){
			document.getElementsByTagName("table")[i].style.width="90%";
		}
	}
	while(document.getElementsByTagName("a").length>0){
		document.getElementsByTagName("a")[0].parentNode.innerHTML=document.getElementsByTagName("a")[0].innerHTML;
	}

	var parentElement = null;
	var i = 0;
	var lastName = "";
	

	//-- Ajustar tama?o de los comentarios
	var comments = document.getElementById("divComentScroll");
	if (comments != null) {
		comments.style.height = '';
	}
	
	//document.getElementById("divContent").style.height=document.getElementById("divContent").scrollHeight+"px";
	document.getElementById("divContent").style.width="98%";
	document.getElementById("printContent").style.overflow="hidden";
	document.getElementById("printContent").style.height="365px";
	document.getElementById("printContent").style.width="665px";
	document.getElementById("printContent").style.display="block";
	document.getElementById("btnExitPrint").style.display="block";
	document.getElementById("print").style.display="block";
	document.getElementById("divContent").style.height="90%";
	document.getElementById("divContent").style.overflowY="auto";
	document.getElementById("divContent").style.overflowx="hidden";
	if(document.all){
		
		document.getElementById("printContent").style.overflow="hidden";
		//document.getElementById("printContent").style.overflowY="scroll";
		document.getElementById("divContent").style.overflowY="auto";
		document.getElementById("divContent").style.overflowX="hidden";
	}
}

function startPrint(){
	var body=document.getElementById("divContent").innerHTML;
	document.getElementById("divContent").parentNode.removeChild( document.getElementById("divContent") );
	document.getElementById("printContent").innerHTML+=body;
	body=document.getElementById("printContent").innerHTML;
	document.body.innerHTML=body;
		
	window.focus();
	window.print();
	setTimeout("window.close();",500);
}


function btnExit_click() {
  window.close();
}

if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", start, false);
}else{
	start();
}

