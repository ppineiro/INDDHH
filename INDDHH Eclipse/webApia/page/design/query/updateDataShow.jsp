<div style="position: relative;"><div id="qryFixedColumn"
		style='background-image: none; height: inherit;'><table><thead><tr class="header"><th width="155px" style='width: 10%;'><div style="width: 155px;"><system:label show="text" label="lblField" forHtml="true" /></div></th></tr></thead><tbody class="tableData"><tr><td width="155px" style='width: 155px;'><div class="width150"><span><system:label show="text" label="lblQryColName" /></span></div></td></tr><system:edit show="ifValue" from="theEdition" field="freeSQL"
					value="true"><tr><td width="155px" style='width: 155px;'><div
								class="width150"><span><system:label show="text" label="lblQryColType" /></span></div></td></tr></system:edit><tr><td style="width: 0px; display: none"></td></tr><tr><td width="155px" style='width: 155px;'><div class="width150"><span><system:label show="text" label="lblQryColHeadName" /></span></div></td></tr><tr><td width="155px" style='width: 155px;'><div class="width150"><span><system:label show="text" label="lblTooTip" /></span></div></td></tr><tr><td width="155px"
						style="width: 155px;<system:edit show="ifNotFlag" from="theEdition" field="2">display:none</system:edit>"><div
							class="width150"><span><system:label show="text" label="lblQrySort" /></span></div></td></tr><tr><td width="155px" style='width: 155px;'><div class="width150"><span><system:label show="text" label="lblQryWidth" /></span></div></td></tr><tr><td width="155px"
						style="width: 155px;display:<system:edit show="value" from="theBean" field="qryColHid" value="qryColHid" />"><div
							class="width150"><span><system:label show="text" label="lblQryColHid" /></span></div></td></tr><tr><td width="155px"
						style="width: 155px;display:<system:edit show="value" from="theBean" field="dispAttFrom" />"><div
							class="width150"><span><system:label show="text" label="lblQryAttFrom" /></span></div></td></tr><tr><td width="155px" style='width: 155px;'><div class="width150"><span><system:label show="text" label="lblQryShowTime" /></span></div></td></tr><tr><td width="155px" style='width: 155px;'><div class="width150"><span><system:label show="text" label="lblQryIsHTML" /></span></div></td></tr><system:edit show="ifValue" from="theBean" field="qryDontExp"
					value="true"><tr><td width="155px" style='width: 155px;'><div
								class="width150"><span><system:label show="text" label="lblQryDontExp" /></span></div></td></tr></system:edit><tr><td width="155px" style='width: 155px;'><div class="width150"><span><system:label show="text" label="lblEnt" /></span></div></td></tr><system:edit show="ifValue" from="theEdition" field="qryType"
					value="Q"><tr><td width="155px" style='width: 155px;'><div
								class="width150"><span><system:label show="text"
										label="lblQryAvoidAutoFilter" /></span></div></td></tr></system:edit><tr><td width="155px"
						style="width: 155px;display:<system:edit show="value" from="theBean" field="qryAttJoinValues"/>"><div
							class="width150"><span><system:label show="text"
									label="lblQryAttJoinValues" /></span></div></td></tr><system:edit show="ifNotValue" from="theEdition" field="qryType"
					value="O"><tr><td width="155px" style='width: 155px;'><div
								class="width150"><span><system:label show="text"
										label="lblQryShowAsMoreInfo" /></span></div></td></tr></system:edit><tr><td width="155px" style='width: 155px;'><div class="width150"><span><system:label show="text" label="lblShowAsInt" /></span></div></td></tr><tr><td width="155px" style='width: 155px;'><div class="width150"><span><system:label show="text" label="lblIsDocument" /></span></div></td></tr><system:edit show="ifValue" from="theBean" field="canHavePanel" value="true"><system:edit show="ifValue" from="theBean" field="offlineQuery" value="false"><tr><td width="155px" style='width: 155px;'><div class="width150"><span><system:label show="text" label="lblDontShowInPanel" /></span></div></td></tr></system:edit></system:edit><system:edit show="ifNotValue" from="theEdition" field="qryType" value="O"><tr><td width="155px" style='width: 155px;'><div class="width150"><span><system:label show="text" label="lblAutoFitWidthTitle" /></span></div></td></tr></system:edit><tr><td width="155px" style='width: 155px;'><div class="width150"><span><system:label show="text" label="lblIsEntSta" /></span></div></td></tr></tbody></table></div><div style="margin-left: 168px;"><div class="gridBody gridHeader"
			style='background-image: none; height: inherit;'><!-- Cuerpo de la tabla --><table id="bodyShow"><thead><tr class="header"><th class="hideTD"></th></tr></thead><tbody class="tableData" id="tblShows"><tr><td class="hideTD"></td></tr><system:edit show="ifValue" from="theEdition" field="freeSQL"
						value="true"><tr><td class="hideTD"></td></tr></system:edit><tr><td style="width: 0px; display: none"></td></tr><tr><td class="hideTD"></td></tr><tr><td class="hideTD"></td></tr><tr><td
							<system:edit show="ifNotFlag" from="theEdition" field="2"> style="display:none" keepHidden="true"</system:edit>
							class="hideTD"></td></tr><tr><td class="hideTD"></td></tr><tr><td
							style="display:<system:edit show="value" from="theBean" field="qryColHid" value="qryColHid" />"
							class="hideTD"
							<system:edit show="ifValue" from="theBean" field="qryColHid" value="none">keepHidden="true"</system:edit>></td></tr><tr><td
							style="display:<system:edit show="value" from="theBean" field="dispAttFrom" />"
							class="hideTD"
							<system:edit show="ifValue" from="theBean" field="dispAttFrom" value="none">keepHidden="true"</system:edit>></td></tr><tr><td class="hideTD"></td></tr><tr><td class="hideTD"></td></tr><system:edit show="ifValue" from="theBean" field="qryDontExp"
						value="true"><tr><td class="hideTD"></td></tr></system:edit><tr><td class="hideTD"></td></tr><system:edit show="ifValue" from="theEdition" field="qryType"
						value="Q"><tr><td class="hideTD"></td></tr></system:edit><tr><td style="display:<system:edit show="value" from="theBean" field="qryAttJoinValues"/>" class="hideTD"></td></tr><system:edit show="ifNotValue" from="theEdition" field="qryType"
						value="O"><tr><td class="hideTD"></td></tr></system:edit><tr><td class="hideTD"></td></tr><tr><td class="hideTD"></td></tr><system:edit show="ifValue" from="theBean" field="canHavePanel" value="true"><system:edit show="ifValue" from="theBean" field="offlineQuery" value="false"><tr><td class="hideTD"></td></tr></system:edit></system:edit><system:edit show="ifNotValue" from="theEdition" field="qryType" value="O"><tr><td class="hideTD"></td></tr></system:edit><tr><td class="hideTD"></td></tr></tbody></table></div></div><div class="gridFooter"><div class="listActionButtons" id="gridFooterFormEnt"><div class="listUpDown"><div class="actSeparator"></div><div class="navButtons btnUp" style="margin-top: -5px;"><div class="pGroup"><div id="btnFirstShow" class="pButton btnFirst" title=""></div><div id="btnLeftShow" class="pButton btnPrev" title=""></div></div><div class="pGroup"><div id="btnRightShow" class="pButton btnNext" title=""></div><div id="btnLastShow" class="pButton btnLast" title=""></div></div></div></div><div class=" listAddDel"><div class="btnDelete navButton" id="btnDeleteShow"><system:label show="text" label="btnEli" /></div><system:edit show="ifValue" from="theEdition" field="source"
					value="C"><system:edit show="ifFlag" from="theEdition" field="5"><div class="btnAdd navButton" id="btnAddShowAtt"><system:label show="text" label="btnAgrAtt" /></div></system:edit><div class="btnAdd navButton" id="btnAddShowCol"><system:label show="text" label="btnAgrCol" /></div></system:edit><system:edit show="ifValue" from="theEdition" field="source"
					value="B"><div class="btnAdd navButton" id="btnAddShow"><system:label show="text" label="btnAgrPar" /></div></system:edit></div></div></div></div><div class="clearLeft sep"></div><div class="clearLeft sep"></div><system:edit show="ifValue" from="theBean" field="tdAllAtt" value="true"><div class="fieldGroup splitTable"><div class="field fieldOneThird"><label
				title="<system:label show="tooltip" label="lblQryNoExecFirst" />"
				for="chkDontExceFirst" class="label"><system:label
					show="text" label="lblQryNoExecFirst" />:&nbsp;</label><input
				type="checkbox" id="chkDontExceFirst" name="chkDontExceFirst"
				<system:edit show="ifFlag" from="theEdition" field="9" >checked</system:edit>
				style="width: 30px !important;"></div><div class="field fieldOneThird"><label
				title="<system:label show="tooltip" label="lblShowQuantRes" />"
				for="chkQuantRes" class="label"><system:label show="text"
					label="lblShowQuantRes" />:&nbsp;</label><input type="checkbox"
				id="chkQuantRes" name="chkQuantRes"
				<system:edit show="ifFlag" from="theEdition" field="17" >checked</system:edit>
				style="width: 30px !important;"></div></div></system:edit><system:edit show="ifFlag" from="theEdition" field="5"><div class="fieldGroup splitTable"><div class="field fieldOneThird"><label title="<system:label show="tooltip" label="lblShowAllAtt" />"
				for="chkAllAtt" class="label"><system:label show="text"
					label="lblShowAllAtt" />:&nbsp;</label><input type="checkbox"
				id="chkAllAtt" name="chkAllAtt" onclick="chkAllAtt_click()"
				<system:edit show="ifFlag" from="theEdition" field="4" >checked</system:edit><system:edit show="ifNotValue" from="theEdition" field="attColumnsSize" value="0" >disabled='disabled'</system:edit>
				style="width: 30px !important;"><system:edit show="ifFlag" from="theEdition" field="0"><system:edit show="ifFlag" from="theEdition" field="1"><select name="selAllAttFrom" id="selAllAttFrom"
						style="width: 90px !important; display:<system:edit show="value" from="theBean" field="selAllAttFrom" />"><option value="1"
							<system:edit show="ifFlag" from="theEdition" field="6" >selected</system:edit>><system:label show="text" label="lblShowAllEntAtt" /></option><option value="0"
							<system:edit show="ifNotFlag" from="theEdition" field="6" >selected</system:edit>><system:label show="text" label="lblShowAllProAtt" /></option></select></system:edit></system:edit><system:edit show="ifFlag" from="theEdition" field="0"><system:edit show="ifNotFlag" from="theEdition" field="1"><div class="field" style='display: none'><input type="hidden" name="selAllAttFrom" value="1"
							id="selAllAttFrom"></div></system:edit></system:edit><system:edit show="ifNotFlag" from="theEdition" field="0"><system:edit show="ifNotFlag" from="theEdition" field="1"><div class="field" style='display: none'><input type="hidden" name="selAllAttFrom" value="0"
							id="selAllAttFrom"></div></system:edit></system:edit></div><div class="field fieldOneThird">&nbsp;&nbsp;</div></div></system:edit><system:edit show="ifValue" from="theEdition" field="qryType" value="E"><div class="field extendedSize"><label
			title="<system:label show="tooltip" label="lblQryEntForDelRel" />"
			for="chkForceDelRelation" class="label"><system:label
				show="text" label="lblQryEntForDelRel" />:&nbsp;</label><input
			type="checkbox" name="chkForceDelRelation" id="chkForceDelRelation"
			onclick="validateEntRelations(this)"
			<system:edit show="ifFlag" from="theEdition" field="13" >checked</system:edit>></div><div class="field extendedSize"><label
			title="<system:label show="tooltip" label="lblQryEntDontDelOnRel" />"
			for="chkDontDelOnRelation" class="label"><system:label
				show="text" label="lblQryEntDontDelOnRel" />:&nbsp;</label><input
			type="checkbox" name="chkDontDelOnRelation" id="chkDontDelOnRelation"
			onclick="validateEntRelations(this)"
			<system:edit show="ifFlag" from="theEdition" field="14" >checked</system:edit>></div></system:edit><div id="tblModValue"
	style="<system:edit show="value" from="theBean" field="tblModValue">style='display:none'</system:edit>"><div class="field fieldTwoFifths"><label
			title="<system:label show="tooltip" label="lblQryColModValue" />"
			for="chkForceDelRelation" class="label"><system:label
				show="text" label="lblQryColModValue" />:&nbsp;</label><system:edit show="value" from="theBean" field="selQryColIdModValue"  avoidHtmlConvert="true" /></div><div class="field"
		<system:edit show="ifNotFlag" from="theEdition" field="3" >style='display:none'</system:edit>><system:edit show="ifFlag" from="theEdition" field="3"><system:edit show="value" from="theBean"
				field="selQryColIdModValueParam"  avoidHtmlConvert="true" /></system:edit><system:edit show="ifNotFlag" from="theEdition" field="3"><input type="hidden" value="-1" name="selQryColIdModValueParam"></system:edit></div><div class="field fieldTwoFifths"><label
			title="<system:label show="tooltip" label="lblQryColModText" />"
			class="label"><system:label show="text"
				label="lblQryColModText" />:&nbsp;</label><system:edit show="value" from="theBean" field="selQryColIdModText"  avoidHtmlConvert="true"/><system:edit show="ifFlag" from="theEdition" field="3"><system:edit show="value" from="theBean"
				field="selQryColIdModTextParam"  avoidHtmlConvert="true"/></system:edit><system:edit show="ifNotFlag" from="theEdition" field="3"><input type="hidden" value="-1" name="selQryColIdModTextParam"></system:edit></div></div>
