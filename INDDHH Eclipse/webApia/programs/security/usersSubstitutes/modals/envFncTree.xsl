<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html"/> 
<xsl:template match="text()"/>
<xsl:template match="/">
			<div class="tocHolder" id="tocHolder" nowrap="true">				
					<xsl:apply-templates select="ROWSET/ROW">
						<xsl:sort select="ID_SIBLING" order="ascending" data-type="number"/>
					</xsl:apply-templates>
			</div>
</xsl:template>
<xsl:template match="ROW[ID_FATHER_NODE=0]">
		<ul>	
			<xsl:if test="TYPE='F'">
				<li>
					<xsl:attribute name="CLASS">clsFolder</xsl:attribute>
					<xsl:attribute name="IDNODO"><xsl:value-of select="ID_NODE" /></xsl:attribute>
					<IMG>
						<xsl:attribute name="SRC"><xsl:value-of select="IMG_SRC" /></xsl:attribute>
					</IMG>
					<xsl:value-of select="NAME"/>	
				</li>
				<xsl:call-template name="getChildren">
					<xsl:with-param name="kidsOf" select="ID_NODE"/>
				</xsl:call-template>
				
			</xsl:if>
			<xsl:if test="TYPE='L'">
				<li>
					<xsl:attribute name="IDNODO"><xsl:value-of select="ID_NODE" /></xsl:attribute>
					<input type="checkbox" id="chkList" name="chkList" disabled="true">
						<xsl:attribute name="nodo"><xsl:value-of select="ID_NODE" /></xsl:attribute>
						<xsl:if test="CHECKED[text()='Y']"><xsl:attribute name="checked">true</xsl:attribute></xsl:if>
					 </input>  
					<xsl:value-of select="NAME"/>
				</li>
			</xsl:if>
			
		</ul>
</xsl:template>
<xsl:template name="getChildren">
	<xsl:param name="kidsOf"/>
		<ul>
			<xsl:for-each select="//ROW[ID_FATHER_NODE=$kidsOf]">
				<xsl:sort select="ID_SIBLING" order="ascending" data-type="number"/>
					<xsl:if test="TYPE='F'">
						<li>
							<xsl:attribute name="CLASS">clsFolder</xsl:attribute>
							<xsl:attribute name="IDNODO"><xsl:value-of select="ID_NODE" /></xsl:attribute>
							<IMG>
								<xsl:attribute name="SRC"><xsl:value-of select="IMG_SRC" /></xsl:attribute>
							</IMG>
							<xsl:value-of select="NAME"/>	
						</li>
						<xsl:call-template name="getChildren">
							<!--     - <xsl:with-param name="kidsOf" select="current()/ID_NODE"/>          -->
							<xsl:with-param name="kidsOf" select="ID_NODE"/>
						</xsl:call-template>
						
					</xsl:if>
					<xsl:if test="TYPE='L'">
						<li>
							<xsl:attribute name="IDNODO"><xsl:value-of select="ID_NODE" /></xsl:attribute>
							<input type="checkbox" id="chkList" name="chkList" disabled="true">
								<xsl:attribute name="nodo"><xsl:value-of select="ID_NODE" /></xsl:attribute>
								<xsl:if test="CHECKED[text()='Y']"><xsl:attribute name="checked">true</xsl:attribute></xsl:if>
							</input>  
							<xsl:value-of select="NAME"/>
						</li>
					</xsl:if>
			</xsl:for-each>
		</ul>
</xsl:template>
</xsl:stylesheet>
