<%@page import="com.dogma.vo.LanguageVo"%><%@page import="java.util.Collection"%><%

String prefix = "";
if(request.getParameter("frmParent") != null ){
	prefix = request.getParameter("frmParent");
}

Collection<LanguageVo> langs = null;
Object tskLangs = request.getAttribute("tskTradLang");
if(tskLangs != null)
	langs = (Collection<LanguageVo>)tskLangs;

%><script type="text/javascript">
	var MSG_CONFIG_DELETE_DOCUMENT	= '<system:label show="text" label="msgConfDelDoc" forScript="true" />';
	var LBL_DOWN_FILE	= '<system:label show="text" label="lblDownFile" forScript="true" />';
	var LBL_UPLOAD_FILE	= '<system:label show="text" label="lblUploadFile" forScript="true" />';
	var BTN_LOC			= '<system:label show="text" label="btnLoc" forScript="true" />';
	var LBL_INFO		= '<system:label show="text" label="lblInfo" forScript="true" forHtml="true"/>';
	var LBL_LIST_FILE	= '<system:label show="text" label="lblFileListMode" forScript="true" />';
	var LBL_BLOCK_FILE	= '<system:label show="text" label="lblFileBlockMode" forScript="true" />';
	var BTN_SIGN		= '<system:label show="text" label="prpSign" forScript="true" />';
	var BTN_VERIF_SIGN	= '<system:label show="text" label="prpVerify" forScript="true" />';
	var BTN_DELETE		= '<system:label show="text" label="btnDel" forScript="true" />';
	var BTN_TRAD		= '<system:label show="text" label="lblTranslations" forScript="true" />';
	<%
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
	
	window.addEvent("domready", function() {
		var docContainer = $("docContent<%=prefix%>");
		
		var listBtn = docContainer.getElement('div').getElement('div');//$('file-order-list');
		var blockBtn = docContainer.getElement('div').getElements('div')[1];//$('file-order-block');
		var divAdder = docContainer.getChildren('div')[1];
		listBtn.addEvent("click", function() {
			listBtn.addClass('file-mode-selected');
			blockBtn.removeClass('file-mode-selected');
			Cookie.write('fileOrder', 'list');
			divAdder.addClass('asList');
		}).tooltip(LBL_LIST_FILE, { mode: 'auto', width: 140, hook: false });
		blockBtn.addEvent("click", function() {
			blockBtn.addClass('file-mode-selected');
			listBtn.removeClass('file-mode-selected');
			Cookie.write('fileOrder', 'block');
			divAdder.removeClass('asList');
		}).tooltip(LBL_BLOCK_FILE, { mode: 'auto', width: 140, hook: false });
		
		var mode = Cookie.read("fileOrder");
		if(mode == "list") {
			divAdder.addClass('asList');
			listBtn.addClass('file-mode-selected');
			blockBtn.removeClass('file-mode-selected');
		}
	});
	
</script><div class="fieldGroup" id="docContent<%=prefix%>"><div style="height: 20px;"><div id="file-order-list"></div><div id="file-order-block" class="file-mode-selected"></div></div><div class="divAdder"><div class="modalOptionsContainer" id="prmDocumentContainter<%= prefix %>"><%if(!"true".equals(request.getAttribute("isMonitor"))){ %><div class="element docAddDocument" id="docAddDocument<%= prefix %>" helper="true"><div class="option optionAdd"><system:label show="text" label="btnAgr" /></div></div><%} else { %><span id="docAddDocument<%= prefix %>" helper="true"></span><%} %></div><div style="display: none;" id="tradDocContainter<%= prefix %>"></div></div><div class="clear"></div></div>

