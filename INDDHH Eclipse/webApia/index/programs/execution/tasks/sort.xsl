<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format"
xmlns:msxsl="urn:schemas-microsoft-com:xslt"
xmlns:str="http://exslt.org/strings" 
extension-element-prefixes="msxsl str">
	<xsl:template match="/">
		<DOC>
		<xsl:copy>
			<xsl:for-each select="//TASK">
				<xsl:copy-of select="."/>
			</xsl:for-each>
			<xsl:for-each select="//DOC/*[name(.)='OPERATOR']">
				<xsl:call-template name="sortCond">
					<xsl:with-param name="node" select="."/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:copy>
		</DOC>
	</xsl:template>
	<xsl:template name="sortCond">
		<xsl:param name="node"/>
		<xsl:variable name="condName" select="name($node/*[1])"></xsl:variable>
		<xsl:copy>
			<xsl:for-each select="$node/*[name()=$condName and attribute::isEnd!='true' and name(./*[1])!='OPERATOR']">
				<xsl:sort select="NAME" order="ascending" data-type="text"/>
				<xsl:copy-of select="."/>
			</xsl:for-each>
			<xsl:for-each select="$node/*[name()=$condName and attribute::isEnd='true' and name(./*[1])!='OPERATOR']">
			<xsl:copy-of select="."/>
			</xsl:for-each>
			<xsl:for-each select="$node/*[name()=$condName and attribute::isEnd='false' and name(./*[1])='OPERATOR']">
				<xsl:element name="{$condName}">
					<xsl:attribute name="id"><xsl:value-of select="attribute::id" /></xsl:attribute>
					<xsl:attribute name="isEnd"><xsl:value-of select="attribute::isEnd" /></xsl:attribute>
					<xsl:for-each select="./*[name()='OPERATOR']">
						<xsl:call-template name="sortCond">
							<xsl:with-param name="node" select="."/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:element>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>