<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">


<xsl:output method="xml" omit-xml-declaration="no"/>
<xsl:template match="/">
<dimensions>
	<xsl:for-each select="/nodes/*">
		<xsl:if test="@used='true'">
			<dimensionUsage>
				<xsl:attribute name="name"><xsl:value-of select="@label" /></xsl:attribute>
				<xsl:attribute name="source"><xsl:value-of select="@dimension" /></xsl:attribute>
				<xsl:attribute name="foreignkey"><xsl:value-of select="@foreign" /></xsl:attribute>
			</dimensionUsage>
		</xsl:if>
		<xsl:if test="@local='true'">
			<dimension>
				<xsl:attribute name="name"><xsl:value-of select="@label" /></xsl:attribute>
				<xsl:attribute name="source"><xsl:value-of select="@dimension" /></xsl:attribute>
				<xsl:attribute name="foreignkey"><xsl:value-of select="@foreign" /></xsl:attribute>
				<xsl:attribute name="shared"><xsl:value-of select="@shared" /></xsl:attribute>
				<xsl:for-each select="./*">
					<hierarchy>
						<xsl:attribute name="name"><xsl:value-of select="@label" /></xsl:attribute>
						<xsl:attribute name="source"><xsl:value-of select="@dimension" /></xsl:attribute>
						<xsl:attribute name="foreignkey"><xsl:value-of select="@foreign" /></xsl:attribute>
						<xsl:attribute name="shared"><xsl:value-of select="@shared" /></xsl:attribute>
						<xsl:for-each select=".//node">
							<level>
								<xsl:attribute name="name"><xsl:value-of select="@label" /></xsl:attribute>
								<xsl:attribute name="column"><xsl:value-of select="@column" /></xsl:attribute>
								<xsl:attribute name="levelType"><xsl:value-of select="@levelType" /></xsl:attribute>
								<xsl:attribute name="hideMemberIf"><xsl:value-of select="@hideMemberIf" /></xsl:attribute>
							</level>
						</xsl:for-each>
					</hierarchy>
				</xsl:for-each>
			</dimension>
		</xsl:if>
	</xsl:for-each>
	</dimensions>
</xsl:template>




</xsl:stylesheet>
