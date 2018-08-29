<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html"/> 
<xsl:template match="text()"/>
<xsl:template match="/">
	<xsl:apply-templates/>
</xsl:template>
<xsl:template match="TASK">
		<input type="hidden">
			<xsl:attribute name="name">chk<xsl:value-of select="@id"/></xsl:attribute>
			<xsl:attribute name="value">T</xsl:attribute>
		</input>		
		<input type="hidden" >
			<xsl:attribute name="name">txtDependency</xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
		</input>
</xsl:template>
<xsl:template match="OPERATOR">
	<TD class="tdPathText">
		<TABLE class="tblPath"><TBODY>
			<xsl:apply-templates/>
		</TBODY></TABLE>
	</TD>
</xsl:template>
<xsl:template match="OR">
		<TR><TD class="tdPathOr">
		<input type="checkbox" disabled="true" onclick="checkCheckbox(this)">
			<xsl:attribute name="name">chk<xsl:value-of select="@id"/></xsl:attribute>
			<xsl:attribute name="value">T</xsl:attribute>
		</input>
		<input type="hidden">
			<xsl:attribute name="name">txtDependency</xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
		</input>
		</TD>
		<xsl:apply-templates/>
		</TR>
</xsl:template>
<xsl:template match="XOR">
		<TR><TD class="tdPathXor">
		<input type="radio" onclick="checkRadio(this)" disabled="true">
			<xsl:attribute name="name">chk<xsl:value-of select="@id"/></xsl:attribute>
			<xsl:attribute name="value">T</xsl:attribute>
		</input>		
		<input type="hidden">
			<xsl:attribute name="name">txtDependency</xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
		</input>
		</TD>
		<xsl:apply-templates/>
		</TR>
</xsl:template>
<xsl:template match="AND">
		<TR><TD class="tdPathAnd"><pre/><font style="visibility:hidden">·</font></TD>
		<xsl:apply-templates/>
		</TR>
</xsl:template>
<xsl:template match="NAME">
	<TD class="tdPathText">
	<xsl:value-of select="."/>
	</TD>
</xsl:template>
</xsl:stylesheet>