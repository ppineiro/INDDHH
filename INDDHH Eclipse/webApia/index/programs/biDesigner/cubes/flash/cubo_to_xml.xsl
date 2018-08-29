<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">


<xsl:template match="/dimensions">
	<xsl:for-each select="*">
		<xsl:if test="name(.)='dimensionUsage'">
			<node>
				<xsl:attribute name="label"><xsl:value-of select="@name" /></xsl:attribute>
				<xsl:attribute name="dimension"><xsl:value-of select="@source" /></xsl:attribute>
				<xsl:attribute name="foreign"><xsl:value-of select="@foreignkey" /></xsl:attribute>
			</node>
		</xsl:if>
		<xsl:if test="name(.)='dimension'">
			<node>
				<xsl:attribute name="label"><xsl:value-of select="@name" /></xsl:attribute>
				<xsl:attribute name="dimension"><xsl:value-of select="@source" /></xsl:attribute>
				<xsl:attribute name="foreign"><xsl:value-of select="@foreignkey" /></xsl:attribute>
				<xsl:attribute name="shared"><xsl:value-of select="@shared" /></xsl:attribute>
				<xsl:for-each select="./*">
				<node>
					<xsl:attribute name="label"><xsl:value-of select="@name" /></xsl:attribute>
					<xsl:attribute name="dimension"><xsl:value-of select="@source" /></xsl:attribute>
					<xsl:attribute name="foreign"><xsl:value-of select="@foreignkey" /></xsl:attribute>
					<xsl:attribute name="shared"><xsl:value-of select="@shared" /></xsl:attribute>
						
						<xsl:for-each select="./level">
						
						<node>
							<xsl:attribute name="level"><xsl:value-of select="'true'" /></xsl:attribute>
							<xsl:attribute name="label"><xsl:value-of select="@name" /></xsl:attribute>
							<xsl:attribute name="column"><xsl:value-of select="@column" /></xsl:attribute>
							<xsl:attribute name="levelType"><xsl:value-of select="@levelType" /></xsl:attribute>
							<xsl:attribute name="hideMemberIf"><xsl:value-of select="@hideMemberIf" /></xsl:attribute>
							
						</node>
						
						</xsl:for-each>
						
				</node>
				</xsl:for-each>
			</node>
		</xsl:if>
	</xsl:for-each>
</xsl:template>



</xsl:stylesheet>
