<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="text()"/>

<xsl:template match="/">
	
	<div nowrap="true">
			
		<xsl:apply-templates select="ROWSET/ROW">
<!--			<xsl:sort select="ID_NODE" order="ascending" data-type="number"/>-->
		</xsl:apply-templates>
	
	</div>
	
</xsl:template>

<xsl:template match="ROW[ID_FATHER_NODE=-1]">
		<ul>	
			<li>
				<xsl:if test="ACTUAL='N'">
								<input type="radio" id="chkSelPoolId" name="chkSelPoolId" onclick="chk_click(this)">
									<xsl:attribute name="poolId"><xsl:value-of select="ID_NODE" /></xsl:attribute>
									<xsl:attribute name="value"><xsl:value-of select="ID_NODE" /></xsl:attribute>
								</input>
								<font size="2">
									<xsl:value-of select="NAME"/>
								</font>
							</xsl:if>
							<xsl:if test="ACTUAL='Y'">
								
								<font size="2">
									<B>
										<xsl:value-of select="NAME"/>
									</B>
								</font>
							</xsl:if>
			</li>
			<xsl:call-template name="getChildren">
				<xsl:with-param name="kidsOf" select="ID_NODE"/>
			</xsl:call-template>
			
		</ul>
</xsl:template>

<xsl:template name="getChildren">
	<xsl:param name="kidsOf"/>
		<xsl:if test="count(//ROW[ID_FATHER_NODE=$kidsOf])>0">	
		 <ul> 
			<xsl:for-each select="//ROW[ID_FATHER_NODE=$kidsOf]">
<!--				<xsl:sort select="ID" order="ascending" data-type="number"/>-->
						<li>
							<xsl:if test="ACTUAL='N'">
								<input type="radio" name="chkSelPoolId" onclick="chk_click(this)">
									<xsl:attribute name="poolId"><xsl:value-of select="ID_NODE" /></xsl:attribute>
									<xsl:attribute name="value"><xsl:value-of select="ID_NODE" /></xsl:attribute>
								</input>
								<font size="2">
									<xsl:value-of select="NAME"/>
								</font>
							</xsl:if>
							<xsl:if test="ACTUAL='Y'">
								
								<font size="2">
									<B>
										<xsl:value-of select="NAME"/>
									</B>
								</font>
							</xsl:if>
						</li>			
						<xsl:call-template name="getChildren">
							<xsl:with-param name="kidsOf" select="ID_NODE"/>
						</xsl:call-template>
										
			</xsl:for-each>
	 </ul>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
