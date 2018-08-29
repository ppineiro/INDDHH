<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html"/>
	<xsl:template match="/">
			<xsl:apply-templates select="ROWSET/ROW"/>
	</xsl:template>
	
	<xsl:template match="ROW">
		<tr>
			<td>
				<input type="checkbox" name="chkForm">
					<xsl:if test="CHECKED[text()='Y']"><xsl:attribute name="checked">true</xsl:attribute></xsl:if>
					<xsl:attribute name="value"><xsl:value-of select="FORM_ID"/></xsl:attribute>
				</input>  
			</td>
			<td>
				<xsl:value-of select="FORM_NAME"/>
			</td>
		</tr>
	</xsl:template>
 </xsl:stylesheet>