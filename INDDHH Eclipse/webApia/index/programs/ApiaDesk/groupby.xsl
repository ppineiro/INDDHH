<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">


	<xsl:template match="/">
		<xsl:call-template name="getSort">
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="getSort">
		<!-- <xsl:for-each select="//tasks/task[1]/*"> -->
			<xsl:variable name="attName"><xsl:value-of select="''"/></xsl:variable>
			<tasks>
				<xsl:attribute name="page"><xsl:value-of select="@page"/></xsl:attribute>
				<xsl:attribute name="cantPages"><xsl:value-of select="@cantPages"/></xsl:attribute>
				<xsl:attribute name="hidTotalRecords"><xsl:value-of select="@hidTotalRecords"/></xsl:attribute>
				<xsl:attribute name="name"><xsl:value-of select="$attName"/></xsl:attribute>
				<xsl:call-template name="getPossibleValues">
					<xsl:with-param name="colName" select="$attName"/>
				</xsl:call-template>
			</tasks>
		<!-- </xsl:for-each> -->
	</xsl:template>
	
	<xsl:template name="getPossibleValues" match="nodes">
		<xsl:param name="colName"/>
			<xsl:for-each select="//tasks/task/*[@colname=$colName]">
				<xsl:sort select="./@colvalue" order="ascending" data-type="text"/>
				<xsl:variable name="position" select="position()"/>
				<xsl:variable name="colValue" select="@colvalue"/>
				<xsl:variable name="nextNodeValue">
					<xsl:call-template name="getNextNodeValue">
						<xsl:with-param name="colName" select="$colName"/>
						<xsl:with-param name="nodePos" select="position()"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="($nextNodeValue!=$colValue) or (last()=position())">
					<folder>
						<xsl:attribute name="page"><xsl:value-of select="'0'"/></xsl:attribute>
						<xsl:attribute name="cantPages"><xsl:value-of select="'0'"/></xsl:attribute>
						<xsl:attribute name="hidTotalRecords"><xsl:value-of select="'0'"/></xsl:attribute>
						<xsl:attribute name="value"><xsl:value-of select="$colValue"/></xsl:attribute>
						<xsl:attribute name="cant"><xsl:value-of select="count( //*[@colname=$colName and text()=$colValue] )"/></xsl:attribute>
						<xsl:call-template name="getElementsOf">
							<xsl:with-param name="of" select="$colName"/>
							<xsl:with-param name="with" select="$colValue"/>
						</xsl:call-template>
					</folder>
				</xsl:if>
			</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="getNextNodeValue" match="//nodes/node/*">
		<xsl:param name="nodePos"/>
		<xsl:param name="colName"/>
		<xsl:copy>
			<xsl:for-each select="//tasks/task/*[@colname=$colName]">
				<xsl:sort select="@colvalue" order="ascending" data-type="text"/>
					<xsl:if test="(position()=($nodePos+1))">
							<xsl:value-of select="@colvalue"></xsl:value-of>
					</xsl:if>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template name="getElementsOf">
		<xsl:param name="of"/>
		<xsl:param name="with"/>
		<xsl:for-each select="//tasks/task[./*[@colname=$of and @colvalue=$with]]">
			<xsl:copy-of select="."></xsl:copy-of>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
