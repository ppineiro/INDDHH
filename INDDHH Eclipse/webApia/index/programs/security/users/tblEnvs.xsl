<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

 <xsl:output method="html"/> 
	
	<xsl:template match="/">
		<table cellpadding="0" cellspacing="0" class="tblFormLayout">
			<COL class="col1"/><COL class="col2"/>
			<xsl:apply-templates select="ROWSET/ROW"/>
		</table>
	</xsl:template>
	
	<xsl:template match="ROW">
		<tr>
			<td style="border-bottom:1px solid silver;">
				<input type="checkbox">
					<xsl:if test="CHECKED[text()='Y']"><xsl:attribute name="checked">true</xsl:attribute></xsl:if>
					<xsl:attribute name="env_id"><xsl:value-of select="ENV_ID"/></xsl:attribute>
				</input>  
			</td>
			<td style="border-bottom:1px solid silver;">
			<xsl:value-of select="ENV_NAME"/>
			</td>
		</tr>
	</xsl:template>
 </xsl:stylesheet>