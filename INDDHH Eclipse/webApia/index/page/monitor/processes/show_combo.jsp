<div class="fncPanel options"><div class="title" title="<system:label show="tooltip" label="titAdmAdtFilter"/>"><system:label show="text" label="titAdmAdtFilter"/></div><div class="content"><div class="filter"><system:label show="tooltip" label="lblSelShow" />: 
			<select name="showCombo" id="showCombo" onchange="setShow(this.value)" ><system:util show="prepareProcessShowCombo" saveOn="types" /><system:edit show="iteration" from="types" saveOn="type_save"><system:edit show="saveValue" from="type_save" field="type" saveOn="type"/><option value="<system:edit show="value" from="type_save" field="type"/>" <system:edit show="ifValue" from="theBean" field="show" value="with:type">selected</system:edit>><system:edit show="value" from="type_save" field="typeName"/></option></system:edit></select></div></div></div>
