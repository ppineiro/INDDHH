<div class="aTab"><div class="tab"><system:label show="text" label="tabTskSchProps" /></div><div class="contentTab"><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtSchProps" /></div><div class="field fieldTwoFifths"><!-- VER DISPONIBLES EN ASIGNACION --><label class="label" title="<system:label show="tooltip" label="lblSeeDispInAsign" />"><system:label show="text" label="lblSeeDispInAsign" />:</label><input type="checkbox" name="chkSeeDisp" id="chkSeeDisp" <system:edit show="ifValue" from="theBean" field="propSeeDispInAsignation" value="true">checked</system:edit>></div></div><div class="fieldGroup"><div class="field fieldTwoFifths"><!-- PERMITIR CITAS EN SEMANAS NO CONFIGURADAS --><label class="label" title="<system:label show="tooltip" label="lblSchPerCitNoConfig" />"><system:label show="text" label="lblSchPerCitNoConfig" />:</label><input type="checkbox" name="chkAllowCit" id="chkAllowCit" <system:edit show="ifValue" from="theBean" field="allowSchInWeeksNotConfig" value="true">checked</system:edit>></div><br/><div class="field"><label class="label" title="<system:label show="tooltip" label="lblDefOvrAsign" />"><system:label show="text" label="lblDefOvrAsign" />:</label><input type="text" name="txtDefOvrAsgn" id="txtDefOvrAsgn" class="validate['required','~validateDefOvrAsgn']" value="<system:edit show="value" from="theEdition" field="tskSchDefOvrasgn"/>" <system:edit show="ifValue" from="theBean" field="allowSchInWeeksNotConfig" value="false">disabled</system:edit>></div><div class="field fieldTwoFifths"><label class="label" title="<system:label show="tooltip" label="lblSubHoraria" />"><system:label show="text" label="lblDefSubHoraria" />:</label><select class="small20" name="selDefSubHor" id="selDefSubHor" <system:edit show="ifValue" from="theBean" field="allowSchInWeeksNotConfig" value="false">disabled</system:edit>><system:edit show="iteration" from="theBean" field="frecCol" saveOn="frec"><option value="<system:edit show="value" from="frec" decoder="biz.statum.apia.web.decoder.IntegerDecoder"/>"
								<system:edit show="ifValue" from="theEdition" field="tskSchDefFrac" value="with:frec">selected</system:edit>
						><system:edit show="value" from="frec" decoder="biz.statum.apia.web.decoder.IntegerDecoder"/></option></system:edit><option value="0" <system:edit show="ifValue" from="theBean" field="isComboDefFrec" value="false">selected</system:edit>><system:label show="text" label="lblOther" /></option></select><input style="margin-left: 5px;" class="small40" type="text" name="txtDefOthFrec" id="txtDefOthFrec"  
					<system:edit show="ifValue" from="theBean" field="isComboDefFrec" value="true">disabled</system:edit><system:edit show="ifValue" from="theBean" field="allowSchInWeeksNotConfig" value="false">disabled</system:edit>  
					value="<system:edit show="ifNotValue" from="theBean" field="isComboDefFrec" value="true"><system:edit show="value" from="theEdition" field="tskSchDefFrac"/></system:edit>"><input type="hidden" name="txtHidFrec" id="txtHidFrec" value="<system:edit show="value" from="theEdition" field="tskSchDefFrac"/>"></div><br/><br/><div class="field fieldOneFifths"><!-- NOTIFICAR AL ADMINISTRADOR --><label class="label" title="<system:label show="tooltip" label="lblSchNotAdmin" />"><system:label show="text" label="lblSchNotAdmin" />:</label><input type="checkbox" name="chkNotify" id="chkNotify" <system:edit show="ifValue" from="theBean" field="notifAdministrator" value="true">checked</system:edit>></div><div class="field fieldTwoFifths"><!-- EMAIL DE ADMINISTRADORES --><label class="label" title="<system:label show="tooltip" label="lblSchAdmEmails" />"><system:label show="text" label="lblSchAdmEmails" />:</label><input type="text" name="txtEmails" id="txtEmails" class="validate['required','~validateEmails']" title="<system:label show="text" label="msgSchAdmEmails" />" value="<system:edit show="value" from="theEdition" field="tskSchMails"/>" <system:edit show="ifValue" from="theBean" field="notifAdministrator" value="false">disabled</system:edit>></div></div></div></div>	