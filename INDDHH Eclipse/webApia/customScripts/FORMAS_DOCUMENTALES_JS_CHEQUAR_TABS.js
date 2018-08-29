
function FORMAS_DOCUMENTALES_JS_CHEQUAR_TABS(evtSource) { 
	
	var titles = [
	              "Iniciar expediente" ,
	              "Firmar carátula" ,
	              "Realizar actuación" ,
	              "Firmar actuación" ,
	              "Archivar expediente" ,
	              "A la espera",
	              "En organismo externo (manual)",
	              "Pase masivo"
	              ];
	
	var topParent = window;
	var tabContainer = topParent.$('tabContainer');

	// CARGO EL CONTENEDOR DE TABS
	while(tabContainer == null && topParent != topParent.parent) {
		topParent = topParent.parent;
		tabContainer = topParent.$('tabContainer');
	}
	
	// SI EL CONTENEDOR CONTIENE TABS EJECUTO
	if(tabContainer != null && tabContainer.tabs) {
		var cant = 0;
		var tab_active = tabContainer.tabs[0];
	  	
		// PARA CADA TAB VEO LOS DEMAS
		for(var i = 0; i < tabContainer.tabs.length; i++) {
	  		
			if(tabContainer.tabs[i]) {
	          
				var span = tabContainer.tabs[i].getElement('span');		
	          	if(span){ 
	              
	          		var tabtitle = span.get('text'); 
	          		
	          		var inexp		= tabtitle.indexOf(titles[0]) != -1;
	          		var fircar		= tabtitle.indexOf(titles[1]) != -1;
	          		var realact		= tabtitle.indexOf(titles[2]) != -1;
	          		var firact		= tabtitle.indexOf(titles[3]) != -1;
	          		var archexp		= tabtitle.indexOf(titles[4]) != -1;
	          		var alaespera	= tabtitle.indexOf(titles[5]) != -1;
	          		var enorgext	= tabtitle.indexOf(titles[6]) != -1;
	          		var pasemasivo	= tabtitle.indexOf(titles[7]) != -1;
	          		
	          		var tab_objetivo = (inexp || fircar || realact || firact || archexp || alaespera || enorgext || pasemasivo); 
	              	
	                if (tab_objetivo){
	                  	cant = cant + 1;               	
	                }
	                
	            }
	          	
			}
			
		}
		
	    if(cant > 1 ){  
	      if(tab_active){
	        	alert("Usted esta trabajando un expediente en otra pestaña. No se puede trabajar más de un expediente al mismo tiempo.")
	            tabContainer.removeTab(tab_active);
	      }else{
	            alert("Tab not fonud");
	      }
	    }
	    
	}
	
return true; // END
} // END
