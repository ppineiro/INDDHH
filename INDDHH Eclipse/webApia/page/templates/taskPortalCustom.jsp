<%@page import="com.dogma.vo.LanguageVo"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="st.url.TramiteHelper"%>

<%@ taglib uri='regions' prefix='region'%>
<%@include file="../includes/startInc.jsp"%>
<html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>">
<head>

<%
TramiteHelper th = new TramiteHelper();
String NOMBRE_LOGO = th.getCustomParametersTrm("NOMBRE_LOGO");
//String URL_RETORNO = (String)session.getAttribute("URL_RETORNO");
String URL_RETORNO = th.getUrlRetorno(1);
%>

<script type="text/javascript">
var URL_RETORNO = "<%=URL_RETORNO%>";
var NOMBRE_LOGO = "<%=NOMBRE_LOGO%>";
var URL_APP = "<%=Configuration.ROOT_PATH%>";
</script>

<%@include file="../includes/headInclude.jsp"%>
<region:render section='scripts_include' />

<link href="<%=Configuration.ROOT_PATH %>/portal/css/tel.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/portal/js/tel.js"></script>
	
<script type="text/javascript">
<%Collection<LanguageVo> langs = null;
Object tskLangs = request.getAttribute("tskTradLang");
if (tskLangs != null)
	langs = (Collection<LanguageVo>) tskLangs;

out.write("var DOC_LANGS		= {");
if (langs != null) {
	String str_langs = "";
	for (LanguageVo lang : langs) {
		if (str_langs.length() > 0)
			str_langs += ", " + lang.getLangId() + ": '" + lang.getLangName() + "'";
		else
			str_langs += lang.getLangId() + ": '" + lang.getLangName() + "'";
	}
	out.write(str_langs + "};");
} else {
	out.write("};");
}
%>
</script>
</head>
<body id="paginaPortal"  onLoad="loadAttributes();" onmousemove="raton(event);">

	<div id="div-nav-error"></div>
	<!-- 
	<div id="div_video" style="display: none" class="header_video">
		<iframe width="360px" height="270px" src="https://www.youtube.com/embed/4PibEQRrf-8"></iframe>
	</div>
	 -->
	<div id="tabla-msg-confirm-block" class="css-tabla-msg-confirm"></div>
    <div id="tabla-msg-confirm">    	
    </div>
    
	<div id="exec-blocker"></div>
	<div class="body" id="bodyDiv">
		<form id="frmData" action="dummy" method="post">

			<div class="optionsContainer">
				<system:campaign inLogin="false" inSplash="false"
					location="verticalUp" />
				<system:campaign inLogin="false" inSplash="false"
					location="verticalDown" />
			</div>

			<div class="dataContainer">
				<div class='tabComponent' id="tabComponent">
				
					<h1 style="visibility: hidden;display:none;">Search Technical Periodicals</h1>
					
					<div id="titleTramite" class="titleTramite">
					<%=request.getParameter("eatt_STR_TRM_NOMBRE_STR")%>
					<input type="text" id="trmInput" style="visibility: hidden;">
					</div>
										
					<div class="aTabHeader">
						<system:campaign inLogin="false" inSplash="false"
							location="horizontalUp" />
					</div>
					<div class="fncPanel info" style='display: none'>

						<div class="title">
							<span class="title"><region:render section='title' /></span>
						</div>

						<div class="content divFncDescription" style="position: relative;">
							<div class="fncDescriptionImgSection">
								<region:render section='taskImage' />
							</div>
							<div class="descInfo">
								<div class="title" style="font-weight: bold;"></div>
								<div class="fncDescriptionText" id="fncDescriptionText"></div>
							</div>
							<div class="clear"></div>
						</div>

						<region:render section='apiaSocial' />
					</div>
									
					<div class='aTab'>
						<div class='tab' style="display: none">
							<system:label show="text" label="tabEjeFor" />
						</div>
						<div class='contentTab'>
							<region:render section='entityForms' />
							<region:render section='processForms' />							
							<div class="divBotones">

<table aria-describedby="titleTramite" aria-labelledby="paginaPortal" style="width:100%;">
<caption class="hide-read">&nbsp;</caption>
<thead>
    <tr>
        <th id="pPortalTh1" style="width:37%">&nbsp;</th>
        <th id="pPortalTh2" style="width:10%">&nbsp;</th>
        <th id="pPortalTh3" style="width:10%">&nbsp;</th>
        <th id="pPortalTh4" style="width:10%">&nbsp;</th>
        <th id="pPortalTh5" style="width:30%">&nbsp;</th>        
    </tr>
</thead>
<tbody>
<tr>
<td class="cssBtnPagina" headers="pPortalTh1">
	<button id="btnLast" type="button" class="btn-lg btn-link">&lt;&lt; Volver al paso anterior</button>
</td>
<td class="cssBtnPagina" headers="pPortalTh2">								
	<button id="btnSalir" type="button" class="btn-lg btn-secundario2" onclick="salirTramite();return false;">Salir</button>
</td>
<td class="cssBtnPagina" headers="pPortalTh3">											
	<button id="btnDescartar" type="button" class="btn-lg btn-secundario1" onclick="descartarTramite();return false;">Descartar</button>
</td>
<td class="cssBtnPagina" headers="pPortalTh4">								
	<button id="btnSave" type="button" class="btn-lg btn-secundario">Guardar</button>
</td>
<td class="cssBtnPagina" headers="pPortalTh5">								
	<button id="btnNext" type="button" class="btn-lg btn-primario submit suggestedAction validate['submit']" onclick="javascript:hayQueRemoveErrors='true';btnAction='next';">Continuar al paso siguiente &gt;&gt;</button>									 						
<!-- 	<button id="btnConf" type="button" class="btn-lg btn-primario submit suggestedAction validate['submit']" onclick="javascript:btnAction='conf'">Enviar el formulario web &gt;&gt;</button> -->
	<button id="btnConf" type="button" class="btn-lg btn-primario submit suggestedAction validate['submit']" onclick="javascript:hayQueRemoveErrors='true';btnAction='conf'">Finalizar &gt;&gt;</button>
</td>
</tr>
</tbody>
</table>

<!-- 
<div style="width:100%; white-space: nowrap; border:1px solid black; float:left;">
<div style="width:20%; white-space: nowrap; border:1px solid black; float:left;">
								<button id="btnLast" class="btn-lg btn-link">&lt;&lt; Volver al paso anterior</button>
</div>
<div style="width:10%; white-space: nowrap; border:1px solid black; float:left;">								
								<button id="btnSalir" class="btn-lg btn-secundario2" onclick="salirTramite();return false;">Salir</button>
</div>
<div style="width:10%; white-space: nowrap; border:1px solid black; float:left;">								
								<button id="btnDescartar" class="btn-lg btn-secundario1" onclick="descartarTramite();return false;">Descartar</button>
</div>
<div style="width:10%; white-space: nowrap; border:1px solid black; float:left;">					
								<button id="btnSave" class="btn-lg btn-secundario">Guardar</button>
</div>
<div style="width:25%; white-space: nowrap; border:1px solid black; float:left;">
								<button id="btnNext" class="btn-lg btn-primario submit suggestedAction validate['submit']">Continuar al paso siguiente &gt;&gt;</button>
</div>
<div style="width:25%; white-space: nowrap; border:1px solid black; float:left;">						 							
								<button id="btnConf" class="btn-lg btn-primario submit suggestedAction validate['submit']">Enviar el formulario web &gt;&gt;</button>
</div>
</div>																			
 -->																								
							</div>
						
						</div>
					</div>
				</div>
				<div class='bottom fncPanel' id="btnPanel">
				
					<div id="btnBack" class="button extendedSize" title="Volver">Volver</div>
 <!-- 
					<div class="float-left-buttons">
						<region:render section='buttons' />
					</div>
			-->
				</div>
				<system:campaign inLogin="false" inSplash="false"
					location="horizontalDown" />
			</div>
			<button type="submit" title="Submit" id="btnSubmit" style="visibility: hidden;"></button>
		</form>
	</div>
	

	<%@include file="../modals/documents.jsp"%>
	<%@include file="../modals/calendarsView.jsp"%>
	<%@include file="../social/socialShareMdl.jsp"%>
	<%@include file="../social/socialReadChannelMdl.jsp"%>
	<%@include file="../execution/includes/endInclude.jsp"%>

	<region:render section='signature' />
	
	<div class="div_ayuda" id="div_ayuda"></div>
		 					                            
</body>

</html>