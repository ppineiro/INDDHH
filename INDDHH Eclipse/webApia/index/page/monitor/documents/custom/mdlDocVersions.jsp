
<system:edit show="ifModalNotLoaded" field="mdlDocVersions.jsp"><system:edit show="markModalAsLoaded" field="mdlDocVersions.jsp" /><div id="mdlDocVersionsContainer" class="mdlContainer hiddenModal"><div class="mdlHeader"><system:label show="text" label="prpHistory" /></div><div class="mdlBody" id="mdlBodyDocVer"><!-- DATOS GENERALES --><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtDocInfo" /></div><div class="field fieldHalfMdl"><label title="<system:label show="tooltip" label="lblDocType" />" style="width: auto !important;"><system:label show="text" label="lblDocType" />:&nbsp;</label><span id="vdocType"></span></div><div class="field fieldHalfMdl"><label title="<system:label show="tooltip" label="lblNom" />" style="width: auto !important;"><system:label show="text" label="lblNom" />:&nbsp;</label><span id="vdocName"></span></div><div class="field fieldHalfMdl"><label title="<system:label show="tooltip" label="lblDesc" />" style="width: auto !important;"><system:label show="text" label="lblDesc" />:&nbsp;</label><span id="vdocDesc"></span></div><div class="field fieldHalfMdl"><label title="<system:label show="tooltip" label="lblLock" />" style="width: auto !important;"><system:label show="text" label="lblLock" />:&nbsp;</label><span id="vdocLock"></span></div></div><!-- VERSIONES --><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtDocVer" /></div></div><div id="divVersions"><div class="gridHeader"><!-- Cabezal y filtros --><table cellpadding="0" cellspacing="0"><thead><tr id="trOrderBy" class="header"><th title="<system:label show="tooltip" label="lblVer" />"><div style="width:120px"><system:label show="text" label="lblVer" /></div></th><th title="<system:label show="tooltip" label="lblUsu" />"><div style="width:150px"><system:label show="text" label="lblUsu" /></div></th><th title="<system:label show="tooltip" label="lblDate" />"><div style="width:150px"><system:label show="text" label="lblDate" /></div></th></tr></thead></table></div><div class="gridBody" id="mdlGridBody" style="overflow-x: hidden !important; height: 180px;"><!-- Cuerpo de la tabla --><table cellpadding="0" cellspacing="0"><thead><tr><th width="120px"></th><th width="149px"></th><th width="149px"></th></tr></thead><tbody class="tableData" id="tableDataVersions"></tbody></table></div><div class="gridFooter"></div></div></div><div class="mdlFooter"><div class="modalButton" id="btnDownloadModal" title="<system:label show="text" label="btnDow" />"><system:label show="text" label="btnDow" /></div><div class="close" id="closeDocVersionsModal" title="<system:label show="text" label="btnCer" />"><system:label show="text" label="btnCer" /></div></div></div></system:edit>