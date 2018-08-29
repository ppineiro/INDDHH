<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!--  -  
    <xsl:output method="html"/>      
-    -->
<xsl:template match="text()"/>
<xsl:template match="/">
			<div class="tocHolder" id="tocHolder" nowrap="true">				
					<xsl:apply-templates select="//ROWSET/ROW"/>
			</div>
</xsl:template>
<xsl:template match="ROW[ID_FATHER_NODE=0]">
		<ul>	
			<li>
				<xsl:attribute name="CLASS">clsFolder</xsl:attribute>
				<xsl:attribute name="IDNODO"><xsl:value-of select="ID_NODE" /></xsl:attribute>
				<input type="checkbox" id="chkList" name="chkCat">
					<xsl:attribute name="value"><xsl:value-of select="ID_NODE" /></xsl:attribute>
					<xsl:attribute name="onclick">selectOneChk(this);</xsl:attribute>					
					<xsl:if test="CHECKED[text()='Y']"><xsl:attribute name="checked">true</xsl:attribute>
					</xsl:if>
				</input>  
				<xsl:value-of select="NAME"/>
				<xsl:call-template name="getChildren">
					<xsl:with-param name="kidsOf" select="ID_NODE"/>
				</xsl:call-template>
			</li>
		</ul>
</xsl:template>
<xsl:template name="getChildren">
	<xsl:param name="kidsOf"/>
			<xsl:for-each select="//ROW[ID_FATHER_NODE=$kidsOf]">
				<ul>
				<li>
					<xsl:attribute name="IDNODO"><xsl:value-of select="ID_NODE" /></xsl:attribute>
					<input type="checkbox" id="chkList" name="chkCat">
						<xsl:attribute name="nodo"><xsl:value-of select="ID_NODE" /></xsl:attribute>
						<xsl:attribute name="value"><xsl:value-of select="ID_NODE" /></xsl:attribute>
						<xsl:attribute name="onclick">selectOneChk(this);</xsl:attribute>
						<xsl:if test="CHECKED[text()='Y']"><xsl:attribute name="checked">true</xsl:attribute>
						</xsl:if>
					</input>  
					<xsl:value-of select="NAME"/>
					<xsl:call-template name="getChildren">
						<xsl:with-param name="kidsOf" select="ID_NODE"/>
					</xsl:call-template>
				</li>
		</ul>
			</xsl:for-each>

</xsl:template>
</xsl:stylesheet>