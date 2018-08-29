function initPage(){
	initQueryButtons();
	initAdminFav();
	initAdminActions(!FLAG_BTN_CREATE,!FLAG_BTN_UPDATE,!FLAG_BTN_CLONE,!FLAG_BTN_DELETE,!FLAG_BTN_DEPENDENCIES);
	initNavButtons();	
	customizeRefresh();
	callNavigateRefresh();
}

