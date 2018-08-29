<script type="text/javascript">
	var DEFAULT_DOC_TYPE_ID 			= '<system:edit show="constant" from="com.dogma.vo.DocTypeVo" field="DEFAULT_DOC_TYPE_ID"/>';
	var MSG_METADATA_TITLE_UNIQUE 		= '<system:label show="text" label="msgDocMetaUniq" forScript="true" />';
	var MSG_NO_UP_DOC_TYPE_DIS 			= '<system:label show="text" label="msgNoUpDocTypeDis" forScript="true" />';
	var MSG_NO_EXI_DOC_TYPE_ENA_AND_PER = '<system:label show="text" label="msgNoExiDocTypeEnaAndPer" forScript="true" />';
	var PRIMARY_SEPARATOR				= new Element('div').set('html', '<system:edit show="constant" from="com.st.util.StringUtil" field="PRIMARY_SEPARATOR"/>').get('text');
	var DOCUMENT_EVERYONE_PERMISSION	= "<system:edit show="constant" from="com.dogma.Parameters" field="DOCUMENT_EVERYONE_PERMISSION"/>";
	var DOCUMENT_OWNER_PRIVILEGES		= "<system:edit show="constant" from="com.dogma.Parameters" field="DOCUMENT_OWNER_PRIVILEGES"/>";
</script>

<system:edit show="ifModalNotLoaded" field="documents.jsp">
	<system:edit show="markModalAsLoaded" field="documents.jsp" />
	<div id="mdlDocumentContainer" class="mdlContainer hiddenModal" tabIndex="0">
		<div class="mdlHeader"><system:label show="text" label="titDoc" /></div>
		<iframe title="uploadIframe" style="display:none;" id="documentIframeUpload" name="documentIframeUpload"></iframe>
		<form id="frmModalDocumentUpload" target="documentIframeUpload" enctype="multipart/form-data" method="post">
			<button type="submit" aria-label="submit" id="btnDocumentSubmitIfr" style="display: none;"></button>
			<div class="mdlBody">
				<table aria-label="<system:label show="tooltip" label="titDoc" /> modal" title="<system:label show="text" label="titDoc" />">
					<thead>
						<tr>
							<th id="mdlDocsTableCol1"></th>
							<th id="mdlDocsTableCol2"></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td headers="mdlDocsTableCol1" class="text"><label for="cmbDocType"><system:label show="text" label="lblDocType" />:&nbsp;</label></td>
							<td headers="mdlDocsTableCol2" class="content">
								<select title="<system:label show="text" label="lblDocType" />" id="cmbDocType" name="cmbDocType" style="width: 100% !important;" class="validate['required']">
									
								</select>
								<span id="spanDocType" style="display: none;"></span>
							</td>
						</tr>
					
						<tr>
							<td headers="mdlDocsTableCol1" class="text"><label for="documentModalDocFile"><system:label show="text" label="lblNueDoc" />:</label></td>
							<td headers="mdlDocsTableCol2" class="content"><input type="file" name="docFile" id="documentModalDocFile" title="<system:label show="text" label="lblNueDoc" />" class="validate['required']"></td>
						</tr>
						<tr>
							<td headers="mdlDocsTableCol1" colspan="2">
								<div class="progressBarContainer" id="documentProgressBarContainer">
									<div class="progressBar" id="documentProgressBar"></div>
								</div>
								<div id="documentProgressMessages"></div>
							</td>
						</tr>
						<tr>
							<td headers="mdlDocsTableCol1" class="text"><label for="documentModalDocDesc"><system:label show="text" label="lblDesc" />:</label></td>
							<td headers="mdlDocsTableCol2" class="content"><textarea title="<system:label show="text" label="lblDesc" />" name="docDesc" id="documentModalDocDesc" style="width: 350px" maxlength="255"></textarea></td>
						</tr>
						<tr id="permission">
							<td headers="mdlDocsTableCol1" class="text"><system:label show="text" label="sbtPerAccDoc" />:</td>
							<td headers="mdlDocsTableCol2" class="content">
							
								<div class="modalOptionsContainer" id="mdlDocumentPoolContainter">
						
									<span class="option">
										<label for="selDocAllPoolPerm"><system:label show="text" label="lblTod" />:</label> 
										<select name="docAllowAllType" id="selDocAllPoolPerm" title="<system:label show="text" label="sbtPerAccDoc" />">
											<option value="M"><system:label show="text" label="lblPerMod" /></option>
											<option value="R"><system:label show="text" label="lblPerVer" /></option>
											<option value=""><system:label show="text" label="lblAccessDenied" /></option>
										</select>
									</span>
									
									<div id="scrollOptions" style="max-height:105px;overflow:auto">
									</div>
									
									<hr id="mdlDocumentPoolContainterDivider" style="clear: both;">
									<span class="option optionAdd" id="mdlDocumentAddPool" tabIndex="0"><system:label show="text" label="btnAgrGru" /> </span>
									<span class="option optionAdd" id="mdlDocumentAddUser" tabIndex="0"><system:label show="text" label="btnAgrUsu" /> </span>
								</div>
							
							</td>
						</tr>
					</tbody>
				</table>
				
				<br><br>
				
				<!-- METADATA -->
				<div class="fieldGroup" id="metadata">
					<div class="title"><system:label show="text" label="titMetadata" /></div>
					<div class="gridContainer" style="margin: 0px;" id="gridMetadata">
						<div class="gridHeader" style="width: 100%;">
							<table aria-label="meta" title="<system:label show="tooltip" label="titMetadata" />">
								<thead>
									<tr class="header">
										<th id="m1" title="<system:label show="tooltip" label="lblTit" />" style="width: 50%"><div style="width: 100%"><system:label show="text" label="lblTit" /></div></th>
										<th id="m2" title="<system:label show="tooltip" label="lblVal" />" style="width: 50%"><div style="width: 100%"><system:label show="text" label="lblVal" /></div></th>
									</tr>					
								</thead>
								<tbody>
								<tr><td headers="m1"></td><td headers="m2"></td></tr>
								</tbody>
							</table>
						</div>
						<div class="gridBody" style="height: 135px; overflow: hidden !important;">
							<table aria-label="meta-att" title="<system:label show="tooltip" label="titMetadata" />">			
								<thead>					
									<tr>
										<th id="tableMetadataCol1"></th>
										<th id="tableMetadataCol2"></th>
									</tr>								
								</thead>
								<tbody class="tableData" id="tableMetadata">		
								<tr><td headers="tableMetadataCol1"></td><td headers="tableMetadataCol2"></td></tr>							
								</tbody>
							</table>
						</div>
						<div class="gridFooter listActionButtons" style="margin-top: 0px;">
							<div class="listAddDel" id="buttonsMetadata" >
								<div class="actSeparator">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
								<div class="btnAdd navButton" id="btnAddMeta" style="margin-top: 5px;"><system:label show="text" label="btnAgr" /></div>
								<div class="actSeparator">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
								<div class="btnDelete navButton" id="btnDeleteMeta" style="margin-top: 5px;"><system:label show="text" label="btnEli" /></div>													
							</div>
						</div>							
					</div>
				</div>
				
				
			</div>
			<div class="mdlFooter">
				<div class="close" id="btnCloseDocumentModal" tabIndex="0"><system:label show="text" label="btnCer" /></div>
				<div class="modalButton" id="btnConfirmDocumentModal" tabIndex="0"><system:label show="text" label="btnCon" /></div>
			</div>
		</form>
	</div>
	
	
	<div id="mdlDocumentInfo" class="mdlDocContainer mdlContainer hiddenModal">
		<div class="mdlHeader"><system:label show="text" label="lblInfo" /></div>
		<div class="mdlBody">
			<!-- GENERAL INFO -->
			<table class="generalInfo" title="<system:label show="text" label="lblInfo" />">
				<tbody >
					<tr>
						<td class="text"><system:label show="text" label="lblDocType" />:&nbsp;</td>
						<td class="content"><span id="docTypeLabel"></span></td>
					</tr>
					<tr>
						<td class="text"><system:label show="text" label="lblNom" />:&nbsp;</td>
						<td class="content"><span id="lblNom"></span></td>
					</tr>
					<tr>
						<td class="text"><system:label show="text" label="lblDesc" />:&nbsp;</td>
						<td class="content"><span id="docDesc"></span></td>
					</tr>
					
					<tr id="permissionInfo">
						<td class="text"><system:label show="text" label="sbtPerAccDoc" />:</td>
						<td class="content">
						
							<div class="modalOptionsContainer" id="mdlDocumentPoolContainterInfo">
					
								<span class="option">
									<label for="selDocAllPoolPermInfo"><system:label show="text" label="lblTod" />:</label> <select title="<system:label show="text" label="sbtPerAccDoc" />" name="docAllowAllType" id="selDocAllPoolPermInfo" class="readonly" disabled>
										<option value="M" selected><system:label show="text" label="lblPerMod" /></option>
										<option value="R"><system:label show="text" label="lblPerVer" /></option>
										<option value=""><system:label show="text" label="lblAccessDenied" /></option>
									</select>
								</span>
								
								
								<div id="scrollOptionsInfo" style="max-height:105px;overflow:auto">
								</div>
								<br>	
								<hr id="mdlDocumentPoolContainterDividerInfo" style="clear: both;display:none;">
							</div>
						
						</td>
					</tr>
										
				</tbody>
			</table>

			
			<!-- HISTORY -->
			<table class="history" title="<system:label show="tooltip" label="lblDocVers" />">
				<thead>
					<tr>
						<td id="docHistCol1"><system:label show="text" label="lblVer" /></td>
						<td id="docHistCol2"><system:label show="text" label="lblUsu" /></td>
						<td id="docHistCol3"><system:label show="text" label="lblFecUpl" /></td>
					</tr>
				</thead>
				<tbody id="tblDocHistory">
					
				</tbody>
			</table>
		</div>
		
		<br><br>
		<!-- METADATA -->
		<div class="fieldGroup" id="metadataInfo">
			<div class="title"><system:label show="text" label="titMetadata" /></div>
			<div class="gridContainer" style="margin: 0px;" id="gridMetadataInfo">
				<div class="gridHeader">
					<table aria-label="meta-info" title="<system:label show="tooltip" label="titMetadata" />">
						<thead>
							<tr class="header">
								<th id="mi1" title="<system:label show="tooltip" label="lblTit" />" style="width: 50%"><div style="width: 100%"><system:label show="text" label="lblTit" /></div></th>
								<th id="mi2" title="<system:label show="tooltip" label="lblVal" />" style="width: 50%"><div style="width: 100%"><system:label show="text" label="lblVal" /></div></th>
							</tr>					
						</thead>
						<tbody>		
								<tr><td headers="mi1"></td><td headers="mi2"></td></tr>							
						</tbody>
					</table>
				</div>
				<div class="gridBody" style="height: 135px">
					<table aria-label="meta-meta"  title="<system:label show="tooltip" label="titMetadata" />">			
						<thead>					
							<tr>
								<th id="mm1"></th>
								<th id="mm2"></th>
							</tr>								
						</thead>
						<tbody class="tableData" id="tableMetadataInfo">							
								<tr><td headers="mm1"></td><td headers="mm2"></td></tr>														
						</tbody>
					</table>
				</div>
				<div class="gridFooter listActionButtons"></div>							
			</div>
		</div>
		
		<div class="mdlFooter">
			<div class="close" id="btnCloseDocumentInfo"><system:label show="text" label="btnCer" /></div>
			
		</div>		
	</div>
</system:edit>

<%@include file="pools.jsp" %>
<%@include file="users.jsp" %>
