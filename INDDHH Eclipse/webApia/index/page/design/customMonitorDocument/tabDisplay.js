function initTabDisplay(){
	
}

function executeBeforeConfirmTabDisplay(){
	return true;
}

function oneSelected(ele){
	//Verifico que al menos una columna este para mostrar
	if (!($('flagColDocType').checked || 
			$('flagColName').checked || 
				$('flagColSize').checked || 
					$('flagColRegUser').checked || 	
						$('flagColRegDate').checked)){
		
		ele.errors.push(MSG_CHK_COLUMN);
		return false;
	}
	return true;	
}