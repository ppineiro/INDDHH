<script type="text/javascript"></script><div class="aTab"><div class="tab" id="tabActions"><system:label show="text" label="tabAct" /></div><div class="contentTab" id="contentTabActions"><div><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtDurAct" /></div></div><div class="fieldGroup splitOneThird"><div class="field inputDayHr"><label title="<system:label show="tooltip" label="lblIniTskAlert" />"><system:label show="text" label="lblIniTskAlert" />:&nbsp;</label><label title="<system:label show="tooltip" label="lblDay" />">&nbsp;<system:label show="text" label="lblDay" />&nbsp;</label><input type="text" name="iniAlertDay" id="iniAlertDay" class="validate['numeric']" size="4" maxlength="3" value="<system:edit show="value" from="theEdition" field="tskAlertDurationDay" />" ><label title="<system:label show="tooltip" label="lblHour" />">&nbsp;<system:label show="text" label="lblHour" /></label><input type="text" name="iniAlertHour" id="iniAlertHour" class="validate['numeric']" size="4" maxlength="3" value="<system:edit show="value" from="theEdition" field="tskAlertDurationHour" />" ></div></div><div class="fieldGroup splitOneThird"></div><div class="fieldGroup splitOneThird"><div class="field inputDayHr"><label title="<system:label show="tooltip" label="lblIniTskAtr" />"><system:label show="text" label="lblIniTskAtr" />:&nbsp;</label><label title="<system:label show="tooltip" label="lblDay" />">&nbsp;<system:label show="text" label="lblDay" />&nbsp;</label><input type="text" name="iniAtrDay" id="iniAtrDay" class="validate['numeric']" size="4" maxlength="3" value="<system:edit show="value" from="theEdition" field="tskMaxDurationDay" />" ><label title="<system:label show="tooltip" label="lblHour" />">&nbsp;<system:label show="text" label="lblHour" /></label><input type="text" name="iniAtrHour" id="iniAtrHour" class="validate['numeric']" size="4" maxlength="3" value="<system:edit show="value" from="theEdition" field="tskMaxDurationHour" />" ></div></div><div class="fieldGroup"><div class="defBlock split"><div class="defLbl"><label title="<system:label show="tooltip" label="lblTipNot" />" class="label"><system:label show="text" label="lblTipNot" />:&nbsp;</label></div><div class="oneLineChbox"><input type="checkbox" name="chkNotifEmail" id="chkNotifEmail" <system:edit show="ifValue" from="theEdition" field="notEmail" value="true">checked</system:edit> ><label title="<system:label show="tooltip" label="lblProNotMail" />" class="label"><system:label show="text" label="lblProNotMail" />&nbsp;</label></div><div>&nbsp;</div><div class="oneLineChbox"><input type="checkbox" name="chkNotifMsg" id="chkNotifMsg" <system:edit show="ifValue" from="theEdition" field="notMessage" value="true">checked</system:edit> ><label title="<system:label show="tooltip" label="lblProNotMes" />" class="label"><system:label show="text" label="lblProNotMes" /></label></div><div>&nbsp;</div><div class="oneLineChbox"><input type="checkbox" name="chkNotifChat" id="chkNotifChat" <system:edit show="ifValue" from="theEdition" field="notChat" value="true">checked</system:edit> ><label title="<system:label show="tooltip" label="lblProNotChat" />" class="label"><system:label show="text" label="lblProNotChat" /></label></div></div><div class="defBlock split"><div class="defLbl"><label title="<system:label show="tooltip" label="lblProInAtr" />" class="label"><system:label show="text" label="lblProInAtr" />:&nbsp;</label></div><div class="oneLineChbox"><input type="checkbox" name="chkRelTsk" id="chkRelTsk" <system:edit show="ifFlag" from="theEdition" field="5" >checked</system:edit> ><label title="<system:label show="tooltip" label="lblLibTsks" />" class="label"><system:label show="text" label="lblLibTsks" />&nbsp;</label></div><div>&nbsp;</div><div class="oneLineChbox"><input type="checkbox" name="chkReaPool" id="chkReaPool" <system:edit show="ifValue" from="theEdition" field="hasPool" value="true">checked</system:edit> onchange="onChangeChkReaPool(this);"><label title="<system:label show="tooltip" label="lblReaTskGru" />" class="label"><system:label show="text" label="lblReaTskGru" /></label><select name="cmbReaPool" id="cmbReaPool" style="width: 200px; margin-left: 10px; margin-top: 6px;"><option value=""></option><system:util show="prepareEnvPools" saveOn="pools" /><system:edit show="iteration" from="pools" saveOn="pool"><system:edit show="saveValue" from="pool" field="poolId" saveOn="poolId"/><option value="<system:edit show="value" from="pool" field="poolId"/>" <system:edit show="ifValue" from="theEdition" field="tskGruReasign" value="with:poolId">selected</system:edit>><system:edit show="value" from="pool" field="poolName"/></option></system:edit></select></div></div></div><div class="clear"></div><br><br><div class="fieldGroup"><div class="title"><system:label show="text" label="titNot" /></div><!-- div class="field fieldFull"--><div class="gridContainer" style="margin-right: 0px"><div class="gridHeader" id="gridHeader"><table cellpadding="0" cellspacing="0"><thead><tr class="filter highFixed"><th title=""><div style="width: 170px"></div></th><th title="<system:label show="tooltip" label="lblTskAsi" />"><div style="width: 160px"><system:label show="text" label="lblTskAsi" /></div></th><th title="<system:label show="tooltip" label="lblTskCom" />"><div style="width: 160px"><system:label show="text" label="lblTskCom" /></div></th><th title="<system:label show="tooltip" label="lblTskAcq" />"><div style="width: 160px"><system:label show="text" label="lblTskAcq" /></div></th><th title="<system:label show="tooltip" label="lblTskRel" />"><div style="width: 160px"><system:label show="text" label="lblTskRel" /></div></th><th title="<system:label show="tooltip" label="lblTskAle" />"><div style="width: 160px"><system:label show="text" label="lblTskAle" /></div></th><th title="<system:label show="tooltip" label="lblTskOver" />"><div style="width: 160px"><system:label show="text" label="lblTskOver" /></div></th><th title="<system:label show="tooltip" label="lblTskRea" />"><div style="width: 160px"><system:label show="text" label="lblTskRea" /></div></th><th title="<system:label show="tooltip" label="lblTskEle" />"><div style="width: 160px"><system:label show="text" label="lblTskEle" /></div></th><th title="<system:label show="tooltip" label="lblTskDele" />"><div style="width: 160px"><system:label show="text" label="lblTskDele" /></div></th></tr></thead></table></div><div class="gridBody" id="gridBody"><table cellpadding="0" cellspacing="0" style="width:1730px;"><thead><tr><th width="170px"></th><th width="160px"></th><th width="160px"></th><th width="160px"></th><th width="160px"></th><th width="160px"></th><th width="160px"></th><th width="160px"></th><th width="160px"></th><th width="160px"></th></tr></thead><tbody class="tableData" id="tableData"><tr class="trOdd highFixed"><td width="170px" align="left" title="<system:label show="tooltip" label="lblTskNotU" />"><label><b><system:label show="text" label="lblTskNotU" /></b></label></td><td width="160px" align="center"><input type="checkbox" id="chkAsiNotU" name="chkAsiNotU" align="middle"></td><td width="160px" align="center"><input type="checkbox" id="chkComNotU" name="chkComNotU" align="middle"></td><td width="160px" align="center"><input type="checkbox" id="chkAcqNotU" name="chkAcqNotU" align="middle"></td><td width="160px" align="center"><input type="checkbox" id="chkRelNotU" name="chkRelNotU" align="middle"></td><td width="160px" align="center"><input type="checkbox" id="chkAleNotU" name="chkAleNotU" align="middle"></td><td width="160px" align="center"><input type="checkbox" id="chkOveNotU" name="chkOveNotU" align="middle"></td><td width="160px" align="center"><input type="checkbox" id="chkReaNotU" name="chkReaNotU" align="middle"></td><td width="160px" align="center"><input type="checkbox" id="chkEleNotU" name="chkEleNotU" align="middle"></td><td width="160px" align="center"><input type="checkbox" id="chkDelNotU" name="chkDelNotU" align="middle"></td></tr><tr class="highFixed"><td width="170px" align="left" title="<system:label show="tooltip" label="lblTskNotP" />"><label><b><system:label show="text" label="lblTskNotP" /></b></label></td><td width="160px"><select id="cmbAsiNotP" name="cmbAsiNotP" style="width:75%;" onchange="onChangeCmbNotif(this);"><system:util show="prepareNotifications" saveOn="notifications" /><system:edit show="iteration" from="notifications" saveOn="notif"><option value="<system:edit show="value" from="notif" field="value"/>"><system:edit show="value" from="notif" field="name"/></option></system:edit></select>
												&nbsp;
												<input type="text" id="levXcmbAsiNotP" name="levXcmbAsiNotP" class="compact validate['digit']" maxlength="3" value=""></td><td width="160px"><select id="cmbComNotP" name="cmbComNotP" style="width:75%;" onchange="onChangeCmbNotif(this);"><system:util show="prepareNotifications" saveOn="notifications" /><system:edit show="iteration" from="notifications" saveOn="notif"><option value="<system:edit show="value" from="notif" field="value"/>"><system:edit show="value" from="notif" field="name"/></option></system:edit></select>
												&nbsp;
												<input type="text" id="levXcmbComNotP" name="levXcmbComNotP" class="compact validate['digit']" maxlength="3" value=""></td><td width="160px"><select id="cmbAcqNotP" name="cmbAcqNotP" style="width:75%;" onchange="onChangeCmbNotif(this);"><system:util show="prepareNotifications" saveOn="notifications" /><system:edit show="iteration" from="notifications" saveOn="notif"><option value="<system:edit show="value" from="notif" field="value"/>"><system:edit show="value" from="notif" field="name"/></option></system:edit></select>
												&nbsp;
												<input type="text" id="levXcmbAcqNotP" name="levXcmbAcqNotP" class="compact validate['digit']" maxlength="3" value=""></td><td width="160px"><select id="cmbRelNotP" name="cmbRelNotP" style="width:75%;" onchange="onChangeCmbNotif(this);"><system:util show="prepareNotifications" saveOn="notifications" /><system:edit show="iteration" from="notifications" saveOn="notif"><option value="<system:edit show="value" from="notif" field="value"/>"><system:edit show="value" from="notif" field="name"/></option></system:edit></select>
												&nbsp;
												<input type="text" id="levXcmbRelNotP" name="levXcmbRelNotP" class="compact validate['digit']" maxlength="3" value=""></td><td width="160px"><select id="cmbAleNotP" name="cmbAleNotP" style="width:75%;" onchange="onChangeCmbNotif(this);"><system:util show="prepareNotifications" saveOn="notifications" /><system:edit show="iteration" from="notifications" saveOn="notif"><option value="<system:edit show="value" from="notif" field="value"/>"><system:edit show="value" from="notif" field="name"/></option></system:edit></select>
												&nbsp;
												<input type="text" id="levXcmbAleNotP" name="levXcmbAleNotP" class="compact validate['digit']" maxlength="3" value=""></td><td width="160px"><select id="cmbOveNotP" name="cmbOveNotP" style="width:75%;" onchange="onChangeCmbNotif(this);"><system:util show="prepareNotifications" saveOn="notifications" /><system:edit show="iteration" from="notifications" saveOn="notif"><option value="<system:edit show="value" from="notif" field="value"/>"><system:edit show="value" from="notif" field="name"/></option></system:edit></select>
												&nbsp;
												<input type="text" id="levXcmbOveNotP" name="levXcmbOveNotP" class="compact validate['digit']" maxlength="3" value=""></td><td width="160px"><select id="cmbReaNotP" name="cmbReaNotP" style="width:75%;" onchange="onChangeCmbNotif(this);"><system:util show="prepareNotifications" saveOn="notifications" /><system:edit show="iteration" from="notifications" saveOn="notif"><option value="<system:edit show="value" from="notif" field="value"/>"><system:edit show="value" from="notif" field="name"/></option></system:edit></select>
												&nbsp;
												<input type="text" id="levXcmbReaNotP" name="levXcmbReaNotP" class="compact validate['digit']" maxlength="3" value=""></td><td width="160px"><select id="cmbEleNotP" name="cmbEleNotP" style="width:75%;" onchange="onChangeCmbNotif(this);"><system:util show="prepareNotifications" saveOn="notifications" /><system:edit show="iteration" from="notifications" saveOn="notif"><option value="<system:edit show="value" from="notif" field="value"/>"><system:edit show="value" from="notif" field="name"/></option></system:edit></select>
												&nbsp;
												<input type="text" id="levXcmbEleNotP" name="levXcmbEleNotP" class="compact validate['digit']" maxlength="3" value=""></td><td width="160px"><select id="cmbDelNotP" name="cmbDelNotP" style="width:75%;" onchange="onChangeCmbNotif(this);"><system:util show="prepareNotifications" saveOn="notifications" /><system:edit show="iteration" from="notifications" saveOn="notif"><option value="<system:edit show="value" from="notif" field="value"/>"><system:edit show="value" from="notif" field="name"/></option></system:edit></select>
												&nbsp;
												<input type="text" id="levXcmbDelNotP" name="levXcmbDelNotP" class="compact validate['digit']" maxlength="3" value=""></td></tr><tr class="trOdd highFixed"><td width="170px" align="left" title="<system:label show="tooltip" label="lblTskNotE" />"><label><b><system:label show="text" label="lblTskNotE" /></b></label></td><td width="160px" align="center"><input type="checkbox" id="chkAsiNotE" name="chkAsiNotE" align="middle"></td><td width="160px" align="center"><input type="checkbox" id="chkComNotE" name="chkComNotE" align="middle"></td><td width="160px" align="center"><input type="checkbox" id="chkAcqNotE" name="chkAcqNotE" align="middle"></td><td width="160px" align="center"><input type="checkbox" id="chkRelNotE" name="chkRelNotE" align="middle"></td><td width="160px" align="center"><input type="checkbox" id="chkAleNotE" name="chkAleNotE" align="middle"></td><td width="160px" align="center"><input type="checkbox" id="chkOveNotE" name="chkOveNotE" align="middle"></td><td width="160px" align="center"><input type="checkbox" id="chkReaNotE" name="chkReaNotE" align="middle"></td><td width="160px" align="center"><input type="checkbox" id="chkEleNotE" name="chkEleNotE" align="middle"></td><td width="160px" align="center"><input type="checkbox" id="chkDelNotE" name="chkDelNotE" align="middle"></td></tr><tr class="highFixed"><td width="170px" align="left" title="<system:label show="tooltip" label="lblTskNotT" />"><label><b><system:label show="text" label="lblTskNotT" /></b></label></td><td width="160px"><select id="cmbAsiNotT" name="cmbAsiNotT" style="width:75%;" onchange="onChangeCmbNotif(this);"><system:util show="prepareNotifications" saveOn="notifications" /><system:edit show="iteration" from="notifications" saveOn="notif"><option value="<system:edit show="value" from="notif" field="value"/>"><system:edit show="value" from="notif" field="name"/></option></system:edit></select>
												&nbsp;
												<input type="text" id="levXcmbAsiNotT" name="levXcmbAsiNotT" class="compact validate['digit']" maxlength="3" value=""></td><td width="160px"><select id="cmbComNotT" name="cmbComNotT" style="width:75%;" onchange="onChangeCmbNotif(this);"><system:util show="prepareNotifications" saveOn="notifications" /><system:edit show="iteration" from="notifications" saveOn="notif"><option value="<system:edit show="value" from="notif" field="value"/>"><system:edit show="value" from="notif" field="name"/></option></system:edit></select>
												&nbsp;
												<input type="text" id="levXcmbComNotT" name="levXcmbComNotT" class="compact validate['digit']" maxlength="3" value=""></td><td width="160px"><select id="cmbAcqNotT" name="cmbAcqNotT" style="width:75%;" onchange="onChangeCmbNotif(this);"><system:util show="prepareNotifications" saveOn="notifications" /><system:edit show="iteration" from="notifications" saveOn="notif"><option value="<system:edit show="value" from="notif" field="value"/>"><system:edit show="value" from="notif" field="name"/></option></system:edit></select>
												&nbsp;
												<input type="text" id="levXcmbAcqNotT" name="levXcmbAcqNotT" class="compact validate['digit']" maxlength="3" value=""></td><td width="160px"><select id="cmbRelNotT" name="cmbRelNotT" style="width:75%;" onchange="onChangeCmbNotif(this);"><system:util show="prepareNotifications" saveOn="notifications" /><system:edit show="iteration" from="notifications" saveOn="notif"><option value="<system:edit show="value" from="notif" field="value"/>"><system:edit show="value" from="notif" field="name"/></option></system:edit></select>
												&nbsp;
												<input type="text" id="levXcmbRelNotT" name="levXcmbRelNotT" class="compact validate['digit']" maxlength="3" value=""></td><td width="160px"><select id="cmbAleNotT" name="cmbAleNotT" style="width:75%;" onchange="onChangeCmbNotif(this);"><system:util show="prepareNotifications" saveOn="notifications" /><system:edit show="iteration" from="notifications" saveOn="notif"><option value="<system:edit show="value" from="notif" field="value"/>"><system:edit show="value" from="notif" field="name"/></option></system:edit></select>
												&nbsp;
												<input type="text" id="levXcmbAleNotT" name="levXcmbAleNotT" class="compact validate['digit']" maxlength="3" value=""></td><td width="160px"><select id="cmbOveNotT" name="cmbOveNotT" style="width:75%;" onchange="onChangeCmbNotif(this);"><system:util show="prepareNotifications" saveOn="notifications" /><system:edit show="iteration" from="notifications" saveOn="notif"><option value="<system:edit show="value" from="notif" field="value"/>"><system:edit show="value" from="notif" field="name"/></option></system:edit></select>
												&nbsp;
												<input type="text" id="levXcmbOveNotT" name="levXcmbOveNotT" class="compact validate['digit']" maxlength="3" value=""></td><td width="160px"><select id="cmbReaNotT" name="cmbReaNotT" style="width:75%;" onchange="onChangeCmbNotif(this);"><system:util show="prepareNotifications" saveOn="notifications" /><system:edit show="iteration" from="notifications" saveOn="notif"><option value="<system:edit show="value" from="notif" field="value"/>"><system:edit show="value" from="notif" field="name"/></option></system:edit></select>
												&nbsp;
												<input type="text" id="levXcmbReaNotT" name="levXcmbReaNotT" class="compact validate['digit']" maxlength="3" value=""></td><td width="160px"><select id="cmbEleNotT" name="cmbEleNotT" style="width:75%;" onchange="onChangeCmbNotif(this);"><system:util show="prepareNotifications" saveOn="notifications" /><system:edit show="iteration" from="notifications" saveOn="notif"><option value="<system:edit show="value" from="notif" field="value"/>"><system:edit show="value" from="notif" field="name"/></option></system:edit></select>
												&nbsp;
												<input type="text" id="levXcmbEleNotT" name="levXcmbEleNotT" class="compact validate['digit']" maxlength="3" value=""></td><td width="160px"><select id="cmbDelNotT" name="cmbDelNotT" style="width:75%;" onchange="onChangeCmbNotif(this);"><system:util show="prepareNotifications" saveOn="notifications" /><system:edit show="iteration" from="notifications" saveOn="notif"><option value="<system:edit show="value" from="notif" field="value"/>"><system:edit show="value" from="notif" field="name"/></option></system:edit></select>
												&nbsp;
												<input type="text" id="levXcmbDelNotT" name="levXcmbDelNotT" class="compact validate['digit']" maxlength="3" value=""></td></tr><tr class="trOdd highFixed"><td width="170px" align="left" title="<system:label show="tooltip" label="lblPool" />"><label><b><system:label show="text" label="lblPool" /></b></label></td><td width="160px"><div class="modalOptionsContainer" id="containerPoolsAsi"><div class="option optionAddOnlyIcon optionAddRigth" id="addPoolAsi" helper="true" title="<system:label show="text" label="btnAgr" />"></div></div><input type="hidden" id="poolsIdAsi" name="poolsIdAsi" value=""></td><td width="160px"><div class="modalOptionsContainer" id="containerPoolsCom"><div class="option optionAddOnlyIcon optionAddRigth" id="addPoolCom" helper="true" title="<system:label show="text" label="btnAgr" />"></div></div><input type="hidden" id="poolsIdCom" name="poolsIdCom" value=""></td><td width="160px"><div class="modalOptionsContainer" id="containerPoolsAcq"><div class="option optionAddOnlyIcon optionAddRigth" id="addPoolAcq" helper="true" title="<system:label show="text" label="btnAgr" />"></div></div><input type="hidden" id="poolsIdAcq" name="poolsIdAcq" value=""></td><td width="160px"><div class="modalOptionsContainer" id="containerPoolsRel"><div class="option optionAddOnlyIcon optionAddRigth" id="addPoolRel" helper="true" title="<system:label show="text" label="btnAgr" />"></div></div><input type="hidden" id="poolsIdRel" name="poolsIdRel" value=""></td><td width="160px"><div class="modalOptionsContainer" id="containerPoolsAle"><div class="option optionAddOnlyIcon optionAddRigth" id="addPoolAle" helper="true" title="<system:label show="text" label="btnAgr" />"></div></div><input type="hidden" id="poolsIdAle" name="poolsIdAle" value=""></td><td width="160px"><div class="modalOptionsContainer" id="containerPoolsOve"><div class="option optionAddOnlyIcon optionAddRigth" id="addPoolOve" helper="true" title="<system:label show="text" label="btnAgr" />"></div></div><input type="hidden" id="poolsIdOve" name="poolsIdOve" value=""></td><td width="160px"><div class="modalOptionsContainer" id="containerPoolsRea"><div class="option optionAddOnlyIcon optionAddRigth" id="addPoolRea" helper="true" title="<system:label show="text" label="btnAgr" />"></div></div><input type="hidden" id="poolsIdRea" name="poolsIdRea" value=""></td><td width="160px"><div class="modalOptionsContainer" id="containerPoolsEle"><div class="option optionAddOnlyIcon optionAddRigth" id="addPoolEle" helper="true" title="<system:label show="text" label="btnAgr" />"></div></div><input type="hidden" id="poolsIdEle" name="poolsIdEle" value=""></td><td width="160px"><div class="modalOptionsContainer" id="containerPoolsDel"><div class="option optionAddOnlyIcon optionAddRigth" id="addPoolDel" helper="true" title="<system:label show="text" label="btnAgr" />"></div></div><input type="hidden" id="poolsIdDel" name="poolsIdDel" value=""></td></tr><tr class="lastTr highFixed"><td width="170px" align="left" title="<system:label show="tooltip" label="lblMen" />"><label><b><system:label show="text" label="lblMen" /></b></label></td><td width="160px" align="center"><div id="viewMsgAsi" class="mdl-btn" title="<system:label show="text" label="btnVer" />""></div><input type="hidden" id="msgTextAsi" name="msgTextAsi" value=""><input type="hidden" id="msgSubAsi" name="msgSubAsi" value=""></td><td width="160px" align="center"><div id="viewMsgCom" class="mdl-btn" title="<system:label show="text" label="btnVer" />""></div><input type="hidden" id="msgTextCom" name="msgTextCom" value=""><input type="hidden" id="msgSubCom" name="msgSubCom" value=""></td><td width="160px" align="center"><div id="viewMsgAcq" class="mdl-btn" title="<system:label show="text" label="btnVer" />""></div><input type="hidden" id="msgTextAcq" name="msgTextAcq" value=""><input type="hidden" id="msgSubAcq" name="msgSubAcq" value=""></td><td width="160px" align="center"><div id="viewMsgRel" class="mdl-btn" title="<system:label show="text" label="btnVer" />""></div><input type="hidden" id="msgTextRel" name="msgTextRel" value=""><input type="hidden" id="msgSubRel" name="msgSubRel" value=""></td><td width="160px" align="center"><div id="viewMsgAle" class="mdl-btn" title="<system:label show="text" label="btnVer" />""></div><input type="hidden" id="msgTextAle" name="msgTextAle" value=""><input type="hidden" id="msgSubAle" name="msgSubAle" value=""></td><td width="160px" align="center"><div id="viewMsgOve" class="mdl-btn" title="<system:label show="text" label="btnVer" />""></div><input type="hidden" id="msgTextOve" name="msgTextOve" value=""><input type="hidden" id="msgSubOve" name="msgSubOve" value=""></td><td width="160px" align="center"><div id="viewMsgRea" class="mdl-btn" title="<system:label show="text" label="btnVer" />""></div><input type="hidden" id="msgTextRea" name="msgTextRea" value=""><input type="hidden" id="msgSubRea" name="msgSubRea" value=""></td><td width="160px" align="center"><div id="viewMsgEle" class="mdl-btn" title="<system:label show="text" label="btnVer" />""></div><input type="hidden" id="msgTextEle" name="msgTextEle" value=""><input type="hidden" id="msgSubEle" name="msgSubEle" value=""></td><td width="160px" align="center"><div id="viewMsgDel" class="mdl-btn" title="<system:label show="text" label="btnVer" />""></div><input type="hidden" id="msgTextDel" name="msgTextDel" value=""><input type="hidden" id="msgSubDel" name="msgSubDel" value=""></td></tr></tbody></table></div></div><!-- /div--></div></div></div></div>