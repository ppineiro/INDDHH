<system:query show="ifValue" from="theBean" field="hasAdditionalFilters" value="true"><div class="fncPanel options lastOptions"><div class="title" title="<system:label show="tooltip" label="titAdmAdtFilter"/>"><system:label show="text" label="titAdmAdtFilter"/></div><div class="content"><system:query show="iteration" from="theBean" field="additionalFilters" saveOn="filter"><div class="filter <system:query show="ifValue" from="filter" field="isRequired" value="true">required filterRequired</system:query>"><span><system:query show="value" from="filter" field="head" /></span><system:query show="value" from="filter" field="htmlFilterAdditional" avoidHtmlConvert="true" /></div></system:query></div></div></system:query>