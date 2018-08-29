<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="text()"/>
<xsl:template match="/">
	<xsl:apply-templates select="TEST"/>
</xsl:template>

<xsl:template match="TEST">
	<table class="tblDataGrid">
	<thead><tr><td>Saved DB</td><td>Current DB</td></tr></thead>
	<xsl:apply-templates select="TABLE"/>
	</table>
</xsl:template>

<xsl:template match="TABLE">
	<tr><td colspan="2" style="background-color:slategray;font-weight:bold;color:white">
	<xsl:value-of select="@name"/>
	</td></tr>
	<tr>
		<td width="50%">
			<xsl:for-each select="ROW[@location='table1']">
				<table><tr><td>
				<xsl:call-template name="ROW"/>
				</td></tr>
				</table>
			</xsl:for-each>
		</td>
		<td width="50%">
			<xsl:for-each select="ROW[@location='table2']">
				<table><tr><td>
				<xsl:call-template name="ROW"/>
				</td></tr>
				</table>
			</xsl:for-each>		
		</td>
	</tr>	
</xsl:template>

<xsl:template name="ROW">
	 <xsl:for-each select="*">	
	   [<B><xsl:value-of select="local-name()"/></B> = <xsl:value-of select="@value"/>] 
	 </xsl:for-each> 
</xsl:template>

<xsl:template match="PI_SERVER_CONFIG">
		<DIV class="subTit">Server Config</DIV>
		<table class="tblFormLayout">
			<COL class="col1"/><COL class="col2"/><COL class="col3"/><COL class="col4"/>
	   		<tr>
	   			<td>Server: </td>
	   			<td class="readOnly" colspan="3">
	   				http://<xsl:value-of select="@server"/>:<xsl:value-of select="@port"/>/<xsl:value-of select="@context"/>
	   			</td>
	   		</tr>
	   		<tr>
	   			<td>Version: </td>
	   			<td class="readOnly">
	   				<xsl:value-of select="@version"/>	   				
	   			</td>
	   		</tr>
	   		<tr>
	   			<td>DB Url: </td>
	   			<td colspan="3" class="readOnly">
	   				<xsl:value-of select="@dbUrl"/>
	   			</td>	   			
			</tr>
			<tr>	   			
	   			<td>Result: </td>
	   			<td colspan="3">
		   			<xsl:attribute name="CLASS">
		   				<xsl:if test="../@result='OK'">tdOk</xsl:if>
		   				<xsl:if test="../@result!='OK'">tdNotOk</xsl:if>
		   			</xsl:attribute>
	   				<xsl:value-of select="../@result"/>
	   			</td>
	   		</tr>
		</table>
</xsl:template>

<xsl:template match="PI_URL_SET">
		<thead>
			<tr>
				<TD width="200px">URL</TD>
				<TD width="80px">Action</TD>
				<TD width="40px">RSLT</TD>
				<TD width="40px">EXPT</TD>
				<TD width="40px">HTML</TD>
				<TD>Message</TD>
				<TD width="40px">Time</TD>				
				<TD width="40px"></TD>
   			</tr>
		</thead>
</xsl:template>

<xsl:template match="WEB_TEST">
	<TR>
		<TD><xsl:value-of select="@url"/></TD>
		<TD><xsl:value-of select="@action"/></TD>
		<TD>
			<xsl:attribute name="CLASS">
   				<xsl:if test="@resultOk='OK'">tdOk</xsl:if>
   				<xsl:if test="@resultOk!='OK'">tdNotOk</xsl:if>
   			</xsl:attribute>
			<xsl:value-of select="@resultOk"/>
		</TD>
		<TD>
			<xsl:attribute name="CLASS">
   				<xsl:if test="@hasException='OK'">tdOk</xsl:if>
   				<xsl:if test="@hasException!='OK'">tdNotOk</xsl:if>
   			</xsl:attribute>
			<xsl:value-of select="@hasException"/>
		</TD>
		<TD>
			<xsl:attribute name="CLASS">
   				<xsl:if test="@htmlOk='OK'">tdOk</xsl:if>
   				<xsl:if test="@htmlOk!='OK'">tdNotOk</xsl:if>
   			</xsl:attribute>		
			<xsl:value-of select="@htmlOk"/>
		</TD>
		<TD><xsl:value-of select="@message"/></TD>
		<TD><xsl:value-of select="@time"/></TD>		
		<td>
			<xsl:if test="@htmlOk='OK' or @htmlOk='NOK'">
			<xsl:if test="count(*)=0">
			<button>
				<xsl:attribute name="onclick">showHtml('<xsl:value-of select="../@path"/>',<xsl:value-of select="@pos"/>)</xsl:attribute>				
	   			View
			</button>
			</xsl:if>
			<xsl:if test="count(*)>0">
			<button>
				<xsl:attribute name="onclick">showHtml('<xsl:value-of select="../@id"/>-<xsl:value-of select="@pos"/>')</xsl:attribute>
	   			View
			</button>
			</xsl:if>			
			</xsl:if>
		</td>
	</TR>
</xsl:template>


<xsl:template match="PI_DB_RESTORE">
		<DIV class="subTit">DB Restore : <xsl:value-of select="@name"/></DIV>
		<table class="tblFormLayout">
			<COL class="col1"/><COL class="col2"/><COL class="col3"/><COL class="col4"/>
			<tr>	   			
	   			<td>Result: </td>
	   			<td colspan="3">
		   			<xsl:attribute name="CLASS">
		   				<xsl:if test="../@result='OK'">tdOk</xsl:if>
		   				<xsl:if test="../@result!='OK'">tdNotOk</xsl:if>
		   			</xsl:attribute>
	   				<xsl:value-of select="../@result"/>
	   			</td>
	   		</tr>
			<tr>	   			
	   			<td>Time: </td>
	   			<td colspan="3">
	   				<xsl:value-of select="../@testTime"/>
	   			</td>
	   		</tr>	   		
		</table>
</xsl:template>

<xsl:template match="PI_DB_COMPARE">
		<DIV class="subTit">DB Compare : <xsl:value-of select="@name"/></DIV>
		<table class="tblFormLayout">
			<COL class="col1"/><COL class="col2"/><COL class="col3"/><COL class="col4"/>
			<tr>	   			
	   			<td>File: </td>
	   			<td class="readOnly">
	   				<xsl:value-of select="@dbFile"/>
	   			</td>
	   			<td>Time: </td>
	   			<td class="readOnly">
	   				<xsl:value-of select="../@testTime"/>
	   			</td>
	   		</tr>
			<tr>	   			
	   			<td>Result: </td>
	   			<td colspan="3">
		   			<xsl:attribute name="CLASS">
		   				<xsl:if test="../@result='OK'">tdOk</xsl:if>
		   				<xsl:if test="../@result!='OK'">tdNotOk</xsl:if>
		   			</xsl:attribute>
	   				<xsl:value-of select="../@result"/>
	   			</td>
	   		</tr>
			<tr>	   			
	   			<td>Table Diffs: </td>
	   			<td class="readOnly">
	   				<xsl:value-of select="count(../DB_CMP_TEST/TABLE)"/>
	   			</td>
	   			<td>
					<xsl:if test="../@result='OK'">
	   				<button>
					<xsl:attribute name="onclick">showDBCmp('<xsl:value-of select="../@path"/>')</xsl:attribute>
			   			View
					</button>
					</xsl:if>
				</td>
	   			<td class="readOnly">
	   			</td>
	   		</tr>	   		 		
			<tr>	   			
	   			<td>Row Diffs: </td>
	   			<td class="readOnly">
	   				<xsl:value-of select="count(../DB_CMP_TEST/*/ROW)"/>
	   			</td>
	   		</tr>	 
		</table>
</xsl:template>

</xsl:stylesheet>