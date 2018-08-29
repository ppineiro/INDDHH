<%@page import="com.dogma.vo.LanguageVo"%>
<%@ taglib uri='regions' prefix='region'%>
<%@include file="../includes/startInc.jsp" %>
<html>
<head>
	<%@include file="../includes/headInclude.jsp" %>
	<link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalExecution.css" rel="stylesheet" type="text/css">
	<link href="<system:util show="context" />/css/<system:util show="currentStyle" />/modal.css" rel="stylesheet" type="text/css">
	<region:render section='scripts_include' />
	<style type="text/css">
		#tabHolder {
			display: none;
		}
		#dataContainer {
			padding: 0px !important;
		}
		html, body {
			overflow: hidden;
		}
	</style>
	<script type="text/javascript">
	<%
	Collection<LanguageVo> langs = null;
	Object tskLangs = request.getAttribute("tskTradLang");
	if(tskLangs != null)
		langs = (Collection<LanguageVo>)tskLangs;
	
	out.write("var DOC_LANGS		= {");
	if(langs != null) {
		String str_langs = "";
		for(LanguageVo lang : langs) {
			if(str_langs.length() > 0)
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

<body>
	<div id="exec-blocker"></div>
	<div class="header"></div>
	
	<div class="body" id="bodyDiv">
		<form id="frmData" action="" method="post">
		
			<div id="dataContainer" class="dataContainer max-size">
			 	<div class='tabComponent' id="tabComponent">
			 		<div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div>
										
					<div class='aTab'>
						<div class='tab'><system:label show="text" label="tabEjeFor"/></div>
						<div class='contentTab'>
							<region:render section='entityForms' />
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
	<%@include file="../modals/documents.jsp" %>
	<%@include file="../execution/includes/endInclude.jsp" %>
</body>

</html>