<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" omit-xml-declaration="yes"/>
<xsl:template match="/">
		<scheduler>
			<xsl:for-each select="/elements/*">
				<date>
					<xsl:attribute name="value"><xsl:value-of select="@value" /></xsl:attribute>
					<xsl:variable name="date" select="@value"/>
						<xsl:call-template name="getPostits">
							<xsl:with-param name="date" select="$date"/>
						</xsl:call-template>
						<xsl:call-template name="getNodes">
							<xsl:with-param name="date" select="$date"/>
							<xsl:with-param name="parent" select="0"/>
						</xsl:call-template>
				</date>
			</xsl:for-each>
		</scheduler>
</xsl:template>

<xsl:template name="getNodes">
	<xsl:param name="date"/>
	<xsl:param name="parent"/>
		<xsl:for-each select="//elements/date[@value=$date]/*[@parentNumber=$parent]">
				<xsl:if test="@type='D'">
					<element>
						<xsl:attribute name="icon"><xsl:value-of select="'/folder_icon.png'" /></xsl:attribute>
						<xsl:attribute name="name"><xsl:value-of select="@data" /></xsl:attribute>
						<xsl:variable name="folderDate" select="@date"/>
						<xsl:variable name="folderNum" select="@number"/>
						<xsl:call-template name="getNodes">
							<xsl:with-param name="date" select="$folderDate"/>
							<xsl:with-param name="parent" select="$folderNum"/>
						</xsl:call-template>
					</element>
				</xsl:if>
				<xsl:if test="@type='F'">
					<element>
						<xsl:attribute name="icon"><xsl:value-of select="'/func_icon.png'" /></xsl:attribute>
						<xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
						<xsl:attribute name="url"><xsl:value-of select="@url" /></xsl:attribute>
					</element>
				</xsl:if>
				<xsl:if test="@type='P'">
					<element>
						<xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
						<xsl:attribute name="icon"><xsl:value-of select="'/procicon.png'" /></xsl:attribute>
						<xsl:attribute name="url">../../toc/execution.TaskAction.do?action=startProcess&amp;<xsl:value-of select="@data" /></xsl:attribute>
						<xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
					</element>
				</xsl:if>
				<xsl:if test="@type='T'">
					<element>
						<xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
						<xsl:attribute name="icon"><xsl:value-of select="'/taskicon.png'" /></xsl:attribute>
						<xsl:attribute name="url">../../toc/execution.TasksListAction.do?action=init&amp;after=work&amp;workMode=I&amp;<xsl:value-of select="@data" /></xsl:attribute>
					</element>
				</xsl:if>
				<xsl:if test="@type='N' and $parent!=0">
					<element>
						<xsl:attribute name="icon"><xsl:value-of select="'/postit_icon_50x50.png'" /></xsl:attribute>
						<xsl:attribute name="postit"><xsl:value-of select="'true'" /></xsl:attribute>
						<xsl:attribute name="postitText"><xsl:value-of select="@data" /></xsl:attribute>
					</element>
				</xsl:if>
		</xsl:for-each>
</xsl:template>

<xsl:template name="getPostits">
	<xsl:param name="date"/>
	<!-- <postits> -->
		<xsl:for-each select="//elements/date[@value=$date]/*[@type='N' and @parentNumber=0]">
			<!-- <postit> -->
			<element>
				<xsl:attribute name="icon"><xsl:value-of select="'/postit_icon_50x50.png'" /></xsl:attribute>
				<xsl:attribute name="postit"><xsl:value-of select="'true'" /></xsl:attribute>
				<xsl:attribute name="text"><xsl:value-of select="@data" /></xsl:attribute>
				<xsl:attribute name="postitText"><xsl:value-of select="@data" /></xsl:attribute>
				<xsl:attribute name="name"><xsl:value-of select="@data" /></xsl:attribute>
			</element>
			<!-- </postit> -->
		</xsl:for-each>
	<!-- </postits> -->
</xsl:template>

</xsl:stylesheet>