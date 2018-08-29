<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" omit-xml-declaration="no"/>
<xsl:template match="/">
		<views>
			<xsl:for-each select="/directory/folder[@parentid='null']">
				<folder>
					<xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>
					<xsl:attribute name="parentid"><xsl:value-of select="@parentid" /></xsl:attribute>
					<xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
					<xsl:call-template name="getNodes">
						<xsl:with-param name="parent" select="@id"/>
					</xsl:call-template>
				</folder>
			</xsl:for-each>
			<xsl:for-each select="/directory/view[@parentid='null']">
				<view>
					<xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>
					<xsl:attribute name="parentid"><xsl:value-of select="@parentid" /></xsl:attribute>
					<xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
					<xsl:attribute name="description"><xsl:value-of select="@desc" /></xsl:attribute>
					<xsl:attribute name="mainView"><xsl:value-of select="@mainView" /></xsl:attribute>
				</view>
			</xsl:for-each>
		</views>
</xsl:template>

<xsl:template name="getNodes">
	<xsl:param name="date"/>
	<xsl:param name="parent"/>
		<xsl:for-each select="//directory/folder[@parentid=$parent]">
			<folder>
				<xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>
				<xsl:attribute name="parentid"><xsl:value-of select="@parentid" /></xsl:attribute>
				<xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
				<xsl:call-template name="getNodes">
					<xsl:with-param name="parent" select="@id"/>
				</xsl:call-template>
			</folder>
		</xsl:for-each>
		<xsl:for-each select="//directory/view[@parentid=$parent]">
			<view>
				<xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>
				<xsl:attribute name="parentid"><xsl:value-of select="@parentid" /></xsl:attribute>
				<xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
				<xsl:attribute name="description"><xsl:value-of select="@desc" /></xsl:attribute>
				<xsl:attribute name="mainView"><xsl:value-of select="@mainView" /></xsl:attribute>
			</view>
		</xsl:for-each>
</xsl:template>

</xsl:stylesheet>