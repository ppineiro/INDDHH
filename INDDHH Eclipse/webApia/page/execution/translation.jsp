<%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.vo.LanguageVo"%><%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %><%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"><title></title><script type="text/javascript" src="<system:util show="context" />/js/mootools-core-1.4.5-full-compat.js"></script><script type="text/javascript" src="<system:util show="context" />/js/mootools-more-1.4.0.1-compat.js"></script><%if("".equals(com.dogma.Configuration.CUSTOM_TINYMCE_PATH)){ %><script type="text/javascript" src="<system:util show="context" />/scripts/tinymce/jscripts/tinymce_4.1.5/tinymce.min.js"></script><script type="text/javascript" src="<system:util show="context" />/scripts/tinymce/jscripts/tinymce_4.1.5/tinymce.custom.js"></script><%} else { %><script type="text/javascript" src="<system:util show="context" /><%=com.dogma.Configuration.CUSTOM_TINYMCE_PATH%>"></script><%} %><system:util show="baseStyles" /><script type="text/javascript">

var WAIT_A_SECOND			= '<system:label show="text" label="lblEspUnMom" forHtml="true" forScript="true" />';

var ed_target_focus = null;

tinymce.init({
	<%
		com.dogma.UserData uData = BasicBeanStatic.getUserDataStatic(request);
	
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
		"searchreplace visualblocks code fullscreen",
		"insertdatetime table contextmenu paste textcolor"
    ],
    toolbar1: "bold italic underline | custom_fontsizeselect | forecolor backcolor | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | spellchecker ",
    templates: [
        {title: 'Test template 1', content: 'Test 1'},
        {title: 'Test template 2', content: 'Test 2'}
    ],
    setup: function(ed) {
    	ed.on('blur', function(e) {
    		
//     		console.log("ed.onblur: inicio");
    		
			if(e.target.isDirty())
					e.target.save();
			
			
			//e.target.getElement().fireEvent('change');
			e.target.getElement().changeTranslation();	//Firefox no soporta eventos entre iframes
			
			if(Browser.firefox)
				ed_target_focus = null;
			
// 			console.log("ed.onblur: fin");
      	});	
		ed.on('focus', function(e) {
    		
//     		console.log("ed.onfocus: inicio");
			
    		if(Browser.firefox)
    			ed_target_focus = e.target;
			
// 			console.log("ed.onfocus: fin");
      	});	
		
		addCustomFontSizeSelect(ed);
    },
    spellchecker_rpc_url: "<%=Parameters.ROOT_PATH%>/spellchecker/jmyspell-spellchecker",
    spellchecker_language: "es_UY",
    spellchecker_languages: '<system:label show="text" label="lblIdiIng" forHtml="true" forScript="true" />=en_US,<system:label show="text" label="lblIdiEsp" forHtml="true" forScript="true" />=es_UY,<system:label show="text" label="lblIdiPor" forHtml="true" forScript="true" />=pt_PT'
});

function getModalReturnValue() {
// 	console.log("getModalReturnValue: inicio");
	
	if(Browser.firefox && ed_target_focus) {
		
		if(ed_target_focus.isDirty())
			ed_target_focus.save();
		
		ed_target_focus.getElement().changeTranslation();
	}
		
	//Mostrar espere un momento
	sp.show(true);
	var frmElement = window.frameElement ? $(window.frameElement) : null;
	
	if(frmElement && frmElement.hasClass('modal-content')) {
		frmElement.fireEvent('block');
	}
	
	//setTimeout chequeando el estado de la sincronizacion
		//Cuando termine
			//Quitar espere un momento
			//Si todo ok
				//Lanzar closeModal
			//Si hubo error
				//Mostrar mensaje de error
		
	//Sincronizar
	$$('.AJAXfield').each(function(ele) {		
		ele.startSyncTraduction(function() {
			sp.hide(true);
			if(frmElement) {
				frmElement.fireEvent('unblock');
				frmElement.fireEvent('closeModal');
			}
			
// 			console.log("getModalReturnValue: fin async");
		});
	});
	
// 	console.log("getModalReturnValue: fin sync");
	
	return null;
}

var sp;

window.addEvent('load', function() {
	
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
})
</script></head><body style="padding-left: 10px; padding-right: 10px;"></body></html>