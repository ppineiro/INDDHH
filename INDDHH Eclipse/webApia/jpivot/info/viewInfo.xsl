<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" indent="no" encoding="US-ASCII"/>
<xsl:param name="context"/>
<xsl:param name="renderId"/>
<xsl:param name="token"/>
<!-- 
<xsl:include href="../../wcf/catedit.xsl"/>
<xsl:include href="../../wcf/changeorder.xsl"/>
<xsl:include href="../../wcf/controls.xsl"/>
<xsl:include href="../../wcf/xform.xsl"/>
<xsl:include href="../../wcf/xtable.xsl"/>
<xsl:include href="../../wcf/xtree.xsl"/>
<xsl:include href="../../wcf/xtabbed.xsl"/>
<xsl:include href="../../wcf/popup.xsl"/>
 -->
<xsl:template match="skip[@hidden='true']"/>

<xsl:template match="skip">
  <xsl:apply-templates/>
</xsl:template>

<!-- identity transform -->
<xsl:template match="*|@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="*|@*|node()"/>
  </xsl:copy>
</xsl:template>

<!-- 

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" indent="no" encoding="US-ASCII"/>
<xsl:param name="context"/>
<xsl:param name="renderId"/>
<xsl:param name="token"/>
<xsl:param name="imgpath" select="'jpivot/table'"/>

<xsl:template match="/">
	<xsl:copy-of select="."></xsl:copy-of>
</xsl:template>

</xsl:stylesheet>


 -->

</xsl:stylesheet>


