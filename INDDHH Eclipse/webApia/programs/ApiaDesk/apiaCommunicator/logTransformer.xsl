<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:template match="/">
	<div style="width:100%;overflow:auto;position:relative;">
		<table width="200" style="width:200px">
			<tbody>
				<xsl:for-each select="//conference/*">
					<tr style="padding:5px;"><td style="border-bottom:1px solid #999999;word-wrap:break-word">
						<xsl:if test="name(.)='registered'">
								<xsl:value-of select="attribute::user"></xsl:value-of> in at <xsl:value-of select="attribute::time"></xsl:value-of>
						</xsl:if>
						<xsl:if test="name(.)='unregistered'">
							<xsl:value-of select="attribute::user"></xsl:value-of> out at <xsl:value-of select="attribute::time"></xsl:value-of>
						</xsl:if>
						<xsl:if test="name(.)='messageReceived'">
							message from <xsl:value-of select="attribute::from"> </xsl:value-of> at <xsl:value-of select="attribute::time"></xsl:value-of> : <xsl:value-of select="attribute::value"></xsl:value-of>
						</xsl:if>
					</td></tr>
				</xsl:for-each>
			</tbody>
		</table>
	</div>
</xsl:template>

</xsl:stylesheet>
