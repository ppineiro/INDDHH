function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
		
	initAdminFieldOnChangeHighlight();
	initAdminActionsEdition(verifyPermissions,false,false,false);
	initPermissions();
	initAdminFav();
	
	getBodyController().canRemoveTab = function() { return ! AT_LEAST_ON_FIELD_INPUT_CHANGED; };
}

