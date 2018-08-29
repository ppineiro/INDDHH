function openInformation(voClass, objId) {
	openModal("/programas/InformationAction.do?action=information&objVo=" + voClass + "&objId=" + objId,700,300);
}

function openInformation2(voClass, objId, objId2) {
	openModal("/programas/InformationAction.do?action=information&objVo=" + voClass + "&objId=" + objId + "&objId2=" + objId2,700,300);
}

function openInformation2(voClass, objId, objId2, objId3) {
	openModal("/programas/InformationAction.do?action=information&objVo=" + voClass + "&objId=" + objId + "&objId2=" + objId2 + "&objId3=" + objId3,700,300);
}