<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html"/> 
<xsl:template match="text()"/>
<xsl:template match="/">
			<div class="tocHolder" id="tocHolder" nowrap="true" noWrap="">				
					<xsl:apply-templates select="ROWSET/ROW">
						<xsl:sort select="ID_SIBLING" order="ascending" data-type="number"/>
					</xsl:apply-templates>
			</div>
</xsl:template>
<xsl:template match="ROW[ID_FATHER_NODE=0]">
		<ul>	
			<li>
				<xsl:attribute name="CLASS">clsFolder</xsl:attribute>
				<xsl:attribute name="IDNODO"><xsl:value-of select="ID_NODE" /></xsl:attribute>
				<input type="checkbox" id="chkList" name="chkList" onclick='clickChk(this)'>
					<xsl:attribute name="node_id"><xsl:value-of select="ID_NODE" /></xsl:attribute>
					<xsl:attribute name="node_name"><xsl:value-of select="NAME" /></xsl:attribute>
					<xsl:attribute name="node_father_id"><xsl:value-of select="ID_FATHER_NODE" /></xsl:attribute>
					<xsl:attribute name="node_sibling_id"><xsl:value-of select="ID_SIBLING" /></xsl:attribute>
					<xsl:attribute name="node_url"><xsl:value-of select="URL" /></xsl:attribute>
					<xsl:attribute name="node_tooltip"><xsl:value-of select="TOOL_TIP" /></xsl:attribute>
					<xsl:attribute name="node_type"><xsl:value-of select="TYPE" /></xsl:attribute>
					<xsl:attribute name="node_group"><xsl:value-of select="FNC_GROUP" /></xsl:attribute>
					<xsl:attribute name="node_open"><xsl:value-of select="FNC_NEW_WIN" /></xsl:attribute>
					<xsl:attribute name="node_dw"><xsl:value-of select="FNC_IS_DW" /></xsl:attribute>
					<xsl:attribute name="node_user"><xsl:value-of select="FNC_IS_USER" /></xsl:attribute>
					<xsl:attribute name="node_global"><xsl:value-of select="FNC_IS_GLOBAL" /></xsl:attribute>
				</input>  

				<xsl:if test="TYPE='F'">
					<IMG style="position:static;">
						<xsl:attribute name="SRC"><xsl:value-of select="IMG_SRC" /></xsl:attribute>
					</IMG>
				</xsl:if>
				<xsl:value-of select="NAME"/>
			</li>
		
			<xsl:call-template name="getChildren">
				<xsl:with-param name="kidsOf" select="ID_NODE"/>
			</xsl:call-template>
			
		</ul>
</xsl:template>
<xsl:template name="getChildren">
	<xsl:param name="kidsOf"/>
		<ul>
			<xsl:for-each select="//ROW[ID_FATHER_NODE=$kidsOf]">
				<xsl:sort select="ID_SIBLING" order="ascending" data-type="number"/>
					<xsl:if test="TYPE='F'">
						<li>
							<xsl:attribute name="CLASS">clsFolder</xsl:attribute>
							<xsl:attribute name="IDNODO"><xsl:value-of select="ID_NODE" /></xsl:attribute>
							<input type="checkbox" id="chkList" name="chkList" onclick='clickChk(this)'>
								<xsl:attribute name="node_id"><xsl:value-of select="ID_NODE" /></xsl:attribute>
								<xsl:attribute name="node_name"><xsl:value-of select="NAME" /></xsl:attribute>
								<xsl:attribute name="node_father_id"><xsl:value-of select="ID_FATHER_NODE" /></xsl:attribute>
								<xsl:attribute name="node_sibling_id"><xsl:value-of select="ID_SIBLING" /></xsl:attribute>
								<xsl:attribute name="node_url"><xsl:value-of select="URL" /></xsl:attribute>
								<xsl:attribute name="node_tooltip"><xsl:value-of select="TOOL_TIP" /></xsl:attribute>
								<xsl:attribute name="node_type"><xsl:value-of select="TYPE" /></xsl:attribute>
								<xsl:attribute name="node_group"><xsl:value-of select="FNC_GROUP" /></xsl:attribute>
								<xsl:attribute name="node_open"><xsl:value-of select="FNC_NEW_WIN" /></xsl:attribute>
								<xsl:attribute name="node_dw"><xsl:value-of select="FNC_IS_DW" /></xsl:attribute>
								<xsl:attribute name="node_global"><xsl:value-of select="FNC_IS_GLOBAL" /></xsl:attribute>
							</input>  

							<IMG  style="position:static;">
								<xsl:attribute name="SRC"><xsl:value-of select="IMG_SRC" /></xsl:attribute>
							</IMG>
							<xsl:value-of select="NAME"/>
						
							<xsl:call-template name="getChildren">
								<!--      <xsl:with-param name="kidsOf" select="current()/ID_NODE"/>          -->
								<xsl:with-param name="kidsOf" select="ID_NODE"/>
							</xsl:call-template>
						</li>
					</xsl:if>
					<xsl:if test="TYPE='L'">
						<li>
							<xsl:attribute name="IDNODO"><xsl:value-of select="ID_NODE" /></xsl:attribute>
							<input type="checkbox" id="chkList" name="chkList" onclick='clickChk(this)'>
								<xsl:attribute name="node_id"><xsl:value-of select="ID_NODE" /></xsl:attribute>
								<xsl:attribute name="node_name"><xsl:value-of select="NAME" /></xsl:attribute>
								<xsl:attribute name="node_father_id"><xsl:value-of select="ID_FATHER_NODE" /></xsl:attribute>
								<xsl:attribute name="node_sibling_id"><xsl:value-of select="ID_SIBLING" /></xsl:attribute>
								<xsl:attribute name="node_url"><xsl:value-of select="URL" /></xsl:attribute>
								<xsl:attribute name="node_tooltip"><xsl:value-of select="TOOL_TIP" /></xsl:attribute>
								<xsl:attribute name="node_type"><xsl:value-of select="TYPE" /></xsl:attribute>
								<xsl:attribute name="node_group"><xsl:value-of select="FNC_GROUP" /></xsl:attribute>
								<xsl:attribute name="node_open"><xsl:value-of select="FNC_NEW_WIN" /></xsl:attribute>
								<xsl:attribute name="node_dw"><xsl:value-of select="FNC_IS_DW" /></xsl:attribute>
								<xsl:attribute name="node_global"><xsl:value-of select="FNC_IS_GLOBAL" /></xsl:attribute>
							</input>  
							<xsl:value-of select="NAME"/>
						</li>
					</xsl:if>
			</xsl:for-each>
		</ul>
</xsl:template>
</xsl:stylesheet>
