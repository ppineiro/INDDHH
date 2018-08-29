<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:template match="/dimensions">
<nodes>
	<xsl:for-each select="*">
		<xsl:if test="name(.)='dimensionUsage'">
			<node>
				<xsl:attribute name="label"><xsl:value-of select="@name" /></xsl:attribute>
				<xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
				<xsl:attribute name="dimension"><xsl:value-of select="@source" /></xsl:attribute>
				<xsl:attribute name="foreignKey"><xsl:value-of select="@foreignKey" /></xsl:attribute>
				<xsl:attribute name="type"><xsl:value-of select="@type" /></xsl:attribute>
				<xsl:attribute name="el_type"><xsl:value-of select="'dimension'" /></xsl:attribute>
			</node>
		</xsl:if>
		<xsl:if test="name(.)='dimension'">
			<node>
				<xsl:attribute name="label"><xsl:value-of select="@name" /></xsl:attribute>
				<xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
				<xsl:attribute name="foreignKey"><xsl:value-of select="@foreignKey" /></xsl:attribute>
				<xsl:attribute name="type"><xsl:value-of select="@type" /></xsl:attribute>
				<xsl:attribute name="shared"><xsl:value-of select="@shared" /></xsl:attribute>
				<xsl:attribute name="innerDimension"><xsl:value-of select="@innerDimension" /></xsl:attribute>
				<xsl:attribute name="local"><xsl:value-of select="'true'" /></xsl:attribute>
				<xsl:for-each select="./*">
				<xsl:attribute name="el_type"><xsl:value-of select="'dimension'" /></xsl:attribute>
				<node>
					<xsl:attribute name="el_type"><xsl:value-of select="'hierarchy'" /></xsl:attribute>
					<xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
					<xsl:attribute name="label"><xsl:value-of select="@name" /></xsl:attribute>
					<xsl:attribute name="primaryKey"><xsl:value-of select="@primaryKey" /></xsl:attribute>
					<xsl:attribute name="primaryKeyTable"><xsl:value-of select="@primaryKeyTable" /></xsl:attribute>
					<xsl:attribute name="table"><xsl:value-of select="@table" /></xsl:attribute>
					<xsl:attribute name="hasAll"><xsl:value-of select="@hasAll" /></xsl:attribute>
					<xsl:attribute name="allMemberName"><xsl:value-of select="@allMemberName" /></xsl:attribute>
						
						<xsl:for-each select="./level">
						
						<node>
							<xsl:attribute name="el_type"><xsl:value-of select="'field'" /></xsl:attribute>
							<xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
							<xsl:attribute name="level"><xsl:value-of select="'true'" /></xsl:attribute>
							<xsl:attribute name="label"><xsl:value-of select="@name" /></xsl:attribute>
							<xsl:attribute name="ordinalColumn"><xsl:value-of select="@ordinalColumn" /></xsl:attribute>
							<xsl:attribute name="levelType"><xsl:value-of select="@levelType" /></xsl:attribute>
							<xsl:attribute name="hideMemberIf"><xsl:value-of select="@hideMemberIf" /></xsl:attribute>
							<xsl:attribute name="uniqueMembers"><xsl:value-of select="@uniqueMembers" /></xsl:attribute>
							<xsl:attribute name="type"><xsl:value-of select="@type" /></xsl:attribute>
							<xsl:attribute name="column"><xsl:value-of select="@column" /></xsl:attribute>
						</node>
						
						</xsl:for-each>
						
				</node>
				</xsl:for-each>
			</node>
		</xsl:if>
	</xsl:for-each>
</nodes>
</xsl:template>



</xsl:stylesheet>
