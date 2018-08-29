
function FORMAS_DOCUMENTALES_CONFIRMAR_TAREA(evtSource) { 
	
	if (document.getElementById("btnConf")!=null){
      
      document.getElementById("btnConf").fireEvent('click', new Event({ type: 'click', target: $('btnConf') }));
      
	}

return true; // END
} // END
