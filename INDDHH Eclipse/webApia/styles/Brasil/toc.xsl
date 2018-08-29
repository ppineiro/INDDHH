<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 
<xsl:template match="text()"/>
<xsl:template match="/">
		<div style="position: absolute; top: 0px; right: 0px;z-index:-1" >
		<table width="100%" class="tblBackColor" cellspacing="0">
		<tr><td width="30%" class="tocTd1"><BR/></td>
			<td width="40%" class="tocTd2"><BR/></td>
			<td width="30%" class="tocTd3"><BR/></td></tr></table></div>

		<body onload="preloadImages('/images/folder_closed.gif','/images/folder_open.gif','/images/doc.gif')">
			
			<table class="tocTop" id="tocBar" height="0px">
				<tr><td></td></tr>
			</table>
			<div id="tocContainerBack" style="position:relative;z-index:1;"></div>
			<div id="tocContainer" style="overflow-X:hidden;overflow-Y:auto;position:relative;z-index:9999999;" onclick="sizeToc()">
			<table cellpadding="0" cellspacing="0" class="tocHolder" id="tocHolder" nowrap="true" style="white-space:nowrap;position:static;overflow:hidden;" onMouseOver="mouseOverToc()"><tr><td nowrap="" valign="top">
			<table class="tblAcord">
				<xsl:apply-templates select="ROWSET/ROW">
					<xsl:sort select="ID_SIBLING" order="ascending" data-type="number"/>
				</xsl:apply-templates>
			</table>
			<iframe style="display:none" name="externalLogout" id="externalLogout" height="0" width="0" frameborder="0"></iframe>
			</td></tr></table>
			</div>
		</body>
</xsl:template>
<xsl:template match="ROW[ID_FATHER_NODE=0]">
		<tr>
			<td nowrap="true" width="100%" class="tdInnerTitleAcord" onclick="doLIAction(event)">
					<xsl:attribute name="TITLE">
						<xsl:value-of select="TOOL_TIP" />
					</xsl:attribute>
					<span>
						<xsl:attribute name="ONCLICK">doLIAction(event)</xsl:attribute>
						<xsl:value-of select="NAME"/>
					</span>					
			</td>
		</tr>
		<tr>
			<td nowrap="true" align="left">
				<xsl:attribute name="CLASS">tdBodyAcord</xsl:attribute>
				<xsl:if test="OPEN='true'">
					<xsl:attribute name="STYLE">display:block</xsl:attribute>
				</xsl:if>
				<table>
					<tr>
						<td nowrap="true" width="" align="left">
						<xsl:call-template name="getChildren">
							<xsl:with-param name="kidsOf" select="ID_NODE"/>
							<xsl:with-param name="open" select="OPEN"/>
						</xsl:call-template>
						</td>
					</tr>
				</table>
			</td>
		</tr>
</xsl:template>
<xsl:template name="getChildren">
	<xsl:param name="kidsOf"/>
	<xsl:param name="open"/>
	<xsl:if test="count(//ROW[ID_FATHER_NODE=$kidsOf])>0">
		<ul>
			<xsl:if test="OPEN='true' or $open='true'">
				<xsl:attribute name="STYLE">display:block</xsl:attribute>
			</xsl:if>
			<xsl:for-each select="//ROW[ID_FATHER_NODE=$kidsOf]">
				<xsl:sort select="ID_SIBLING" order="ascending" data-type="number"/>
					<xsl:if test="TYPE='F'">
						<li onclick="doLIAction(event)">
							<xsl:attribute name="CLASS">clsFolder</xsl:attribute>
							<xsl:if test="OPEN='true' or $open='true'">
								<xsl:attribute name="STYLE">display:block</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="TITLE"><xsl:value-of select="TOOL_TIP" /></xsl:attribute>
							
							<span>
								<xsl:attribute name="ONCLICK">doLIAction(event)</xsl:attribute>
								<xsl:value-of select="NAME"/>
							</span>
							<xsl:call-template name="getChildren">
								<xsl:with-param name="kidsOf" select="ID_NODE"/>
								<xsl:with-param name="open" select="OPEN"/>
							</xsl:call-template>
						</li>			
					</xsl:if>
					<xsl:if test="TYPE='L'">
						<li onclick="doLIAction(event)">
							<xsl:attribute name="TITLE"><xsl:value-of select="TOOL_TIP" /></xsl:attribute>
							<xsl:if test="FNC_NEW_WIN!='1'">
								<xsl:attribute name="URL">../../toc/<xsl:value-of select="URL" /></xsl:attribute>
							</xsl:if>	
							<xsl:if test="FNC_NEW_WIN='1'">
								<xsl:attribute name="URL"><xsl:value-of select="URL" /></xsl:attribute>
							</xsl:if>	
							<xsl:attribute name="FNC_NEW_WIN"><xsl:value-of select="FNC_NEW_WIN" /></xsl:attribute>
							
							<span>
								<xsl:attribute name="ONCLICK">doLIAction(event)</xsl:attribute>
								<xsl:value-of select="NAME"/>
							</span>
							
						</li>
					</xsl:if>
					<xsl:if test="TYPE='S'">
						<xsl:if test="count(SUB_TREE/PROCESS[ID_FATHER_NODE=0])+count(SUB_TREE/ENTITY[ID_FATHER_NODE=0])>0">
							<li onclick="doLIAction(event)">
								<xsl:attribute name="CLASS">clsFolder</xsl:attribute>
								<xsl:attribute name="TITLE"><xsl:value-of select="TOOL_TIP" /></xsl:attribute>
								<span>
									<xsl:attribute name="ONCLICK">doLIAction(event)</xsl:attribute>
									<xsl:value-of select="NAME"/>
								</span>
								<xsl:for-each select="SUB_TREE">
									<xsl:call-template name="SUB_TREE">
										<xsl:with-param name="kidsOf" select="ID_NODE"/>
									</xsl:call-template>
								</xsl:for-each>	
							</li>				
						</xsl:if>
					</xsl:if>
			</xsl:for-each>
		</ul>
	</xsl:if>
</xsl:template>

<xsl:template name="SUB_TREE">
	<xsl:param name="kidsOf"/>
	<ul>
	<xsl:call-template name="getClassification"/>
	<xsl:call-template name="RootProcess"/>
	</ul>
	<xsl:call-template name="getEntities"/>
</xsl:template>

<xsl:template name="getClassification">
	<xsl:if test="count(CLA[ID_FATHER_NODE=0])>0">
		<xsl:for-each select="CLA[ID_FATHER_NODE=0]">
				<li onclick="doLIAction(event)">
					<xsl:attribute name="CLASS">clsFolder</xsl:attribute>
					<xsl:attribute name="TITLE"><xsl:value-of select="TOOL_TIP" /></xsl:attribute>
					<xsl:attribute name="ONCLICK">doLIAction(event)</xsl:attribute>
					<span>
						<xsl:attribute name="ONCLICK">doLIAction(event)</xsl:attribute>
						<xsl:value-of select="NAME"/>
					</span>	
					<xsl:call-template name="getClaChildren">
						<xsl:with-param name="kidsOf" select="ID_NODE"/>
					</xsl:call-template>
				</li>
		</xsl:for-each>
	</xsl:if>
</xsl:template>

<xsl:template name="getClaChildren">
	<xsl:param name="kidsOf"/>
	<xsl:if test="count(//CLA[ID_FATHER_NODE=$kidsOf])>0">	
	<ul>	
			<xsl:for-each select="//CLA[ID_FATHER_NODE=$kidsOf]">
				<li onclick="doLIAction(event)">
					<xsl:attribute name="CLASS">clsFolder</xsl:attribute>
					<xsl:attribute name="TITLE">
						<xsl:value-of select="TOOL_TIP" />
					</xsl:attribute>
					<span>
						<xsl:attribute name="ONCLICK">doLIAction(event)</xsl:attribute>
						<xsl:value-of select="NAME"/>
					</span>
					<xsl:call-template name="getClaChildren">
						<xsl:with-param name="kidsOf" select="ID_NODE"/>
					</xsl:call-template>
					<xsl:call-template name="ClaProcess">
						<xsl:with-param name="kidsOf" select="ID_NODE"/>
					</xsl:call-template>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:if>	
</xsl:template>

<xsl:template name="RootProcess">
	<xsl:if test="count(PROCESS[ID_FATHER_NODE=0])>0">	
		<xsl:for-each select="PROCESS[ID_FATHER_NODE=0]">
			<li onclick="doLIAction(event)">
				<xsl:attribute name="TITLE"><xsl:value-of select="TOOL_TIP" /></xsl:attribute>
				<xsl:attribute name="URL"><xsl:value-of select="URL" /></xsl:attribute>
				<span>
					<xsl:attribute name="ONCLICK">doLIAction(event)</xsl:attribute>
					<xsl:value-of select="NAME"/>
				</span>
			</li>			
		</xsl:for-each>
	</xsl:if>	
</xsl:template>

<xsl:template name="ClaProcess">
	<xsl:param name="kidsOf"/>
		<xsl:if test="count(../PROCESS[ID_FATHER_NODE=$kidsOf])>0">	
		<ul>	
			<xsl:for-each select="../PROCESS[ID_FATHER_NODE=$kidsOf]">
				<li onclick="doLIAction(event)">
					<xsl:attribute name="TITLE"><xsl:value-of select="TOOL_TIP" /></xsl:attribute>
					<xsl:attribute name="URL"><xsl:value-of select="URL" /></xsl:attribute>
					<span>
						<xsl:attribute name="ONCLICK">doLIAction(event)</xsl:attribute>
						<xsl:value-of select="NAME"/>
					</span>
				</li>			
			</xsl:for-each>
		</ul>
		</xsl:if>	
</xsl:template>

<xsl:template name="getEntities">
	<xsl:if test="count(ENTITY[ID_FATHER_NODE=0])>0">	
	<ul>	
		<xsl:for-each select="ENTITY[ID_FATHER_NODE=0]">
			<li onclick="doLIAction(event)">
				<xsl:attribute name="TITLE"><xsl:value-of select="TOOL_TIP" /></xsl:attribute>
				<xsl:attribute name="URL"><xsl:value-of select="URL" /></xsl:attribute>
				<span>
					<xsl:attribute name="ONCLICK">doLIAction(event)</xsl:attribute>
					<xsl:value-of select="NAME"/>
				</span>
			</li>			
		</xsl:for-each>
	</ul>
	</xsl:if>	
</xsl:template>

</xsl:stylesheet>