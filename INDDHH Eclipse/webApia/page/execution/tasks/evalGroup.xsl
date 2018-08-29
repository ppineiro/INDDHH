<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html"/> 
<xsl:template match="text()"/>
<xsl:template match="/">
	<table>
		<xsl:apply-templates/>
	</table>
</xsl:template>
<xsl:template match="TASK">
		<TR><TD>
			<xsl:value-of select="@name"/>:
			<input type="hidden" name="task">
				<xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
			</input>
		</TD>
		<TD> 
		</TD>
		<TD>
			<SELECT>
				<xsl:attribute name="name">pool<xsl:value-of select="@id"/></xsl:attribute>
				<xsl:apply-templates/>
			</SELECT>
		</TD></TR>
</xsl:template>
<xsl:template match="POOL">
		<OPTION>
			<xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
			<xsl:value-of select="@name"/>
		</OPTION>
</xsl:template>
</xsl:stylesheet>