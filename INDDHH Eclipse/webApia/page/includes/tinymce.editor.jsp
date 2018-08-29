<%if("".equals(com.dogma.Configuration.CUSTOM_TINYMCE_PATH)){ %><script type="text/javascript" src="<system:util show="context" />/scripts/tinymce/jscripts/tinymce_4.1.5/tinymce.min.js"></script><script type="text/javascript" src="<system:util show="context" />/scripts/tinymce/jscripts/tinymce_4.1.5/tinymce.custom.js"></script><%} else { %><script type="text/javascript" src="<system:util show="context" /><%=com.dogma.Configuration.CUSTOM_TINYMCE_PATH%>"></script><%} %><script type="text/javascript">
tinymce.init({
	<%
		if(LanguageVo.LANG_EN == uData.getLangId().intValue()) {
			//No colocamos el lenguaje, toma ingles por defecto
		} else if(LanguageVo.LANG_SP == uData.getLangId().intValue()) {
			out.write("language: 'es',");
		} else if(LanguageVo.LANG_PT == uData.getLangId().intValue()) {
			out.write("language: 'pt_BR', ");
		}
	%>
	
    theme: "modern",
    mode : "exact",
	height : "350",
	width : "600",
    plugins: [
		"advlist autolink lists charmap print preview hr spellchecker",
		"<%= "true".equals(session.getAttribute("mobile")) ? "" : "searchreplace" %> visualblocks code fullscreen",
		"insertdatetime <%= "true".equals(session.getAttribute("mobile")) ? "" : "table" %> contextmenu paste textcolor"
    ],
    toolbar1: "bold italic underline | custom_fontsizeselect | forecolor backcolor | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | spellchecker ",
    templates: [
        {title: 'Test template 1', content: 'Test 1'},
        {title: 'Test template 2', content: 'Test 2'}
    ],
    setup: function(ed) {
    	ed.on('blur', function(e) {
			if(e.target.isDirty())
					e.target.save();
			
			e.target.getElement().fireEvent('change');
      	});
    	
    	addCustomFontSizeSelect(ed);
    },
    spellchecker_rpc_url: "<%=Parameters.ROOT_PATH%>/spellchecker/jmyspell-spellchecker",
    spellchecker_language: "es_UY",
    spellchecker_languages: '<system:label show="text" label="lblIdiIng" forHtml="true" forScript="true" />=en_US,<system:label show="text" label="lblIdiEsp" forHtml="true" forScript="true" />=es_UY,<system:label show="text" label="lblIdiPor" forHtml="true" forScript="true" />=pt_PT'
});	
</script>