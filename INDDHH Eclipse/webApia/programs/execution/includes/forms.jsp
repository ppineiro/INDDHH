<%@page import="com.dogma.bean.execution.EntInstanceBean"%><%@page import="com.dogma.bean.execution.TaskBean"%><%@page import="java.util.*"%><%@page import="com.dogma.vo.*"%><%@include file="../../../components/scripts/server/includeStart.jsp"%><%


	if("true".equals(request.getSession().getAttribute("MCE"))){
		StringBuffer str = new StringBuffer();
		str.append("<script language=\"javascript\" type=\"text/javascript\" src=\"" + Parameters.ROOT_PATH + "/scripts/tinymce/jscripts/tiny_mce/tiny_mce.js\"></script>");
		str.append("<script language=\"javascript\" type=\"text/javascript\">");
		str.append("executionMode=true;");
		str.append("tinyMCE.init({");
		str.append("mode : \"exact\",");
		str.append("height : \"350\",");
		str.append("width : \"600\",");
		str.append("theme : \"advanced\",");
		if(LanguageVo.LANG_EN==uData.getLangId().intValue()){
			str.append("language : \"en\",");
		} else if(LanguageVo.LANG_SP==uData.getLangId().intValue()){
			str.append("language : \"es\",");
		} else if(LanguageVo.LANG_PT==uData.getLangId().intValue()){
			str.append("language : \"pt\",");
		}
		str.append("init_instance_callback:\"sizeMe\",");
		str.append("plugins : \"safari,spellchecker,pagebreak,style,table,save,advhr,inlinepopups,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template,advlist\",");
		str.append("theme_advanced_toolbar_location : \"top\",");
		str.append("theme_advanced_buttons1 : \"bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,styleselect,formatselect,fontselect,fontsizeselect\",");
		str.append("theme_advanced_buttons2 : \"cut,copy,paste,pastetext,pasteword,|,search,replace,|,bullist,numlist,|,outdent,indent,|,undo,redo,|,cleanup,code,|,insertdate,inserttime,preview,|,forecolor,backcolor\",");
		str.append("theme_advanced_buttons3 : \"tablecontrols,|,hr,removeformat,visualaid,|,sub,sup,|,charmap,|,spellchecker\",");
		str.append("theme_advanced_toolbar_align : \"left\",");
		str.append("theme_advanced_statusbar_location : \"bottom\",");
		//str.append("content_css : \"css/example.css\",");
		str.append("template_external_list_url : \"js/template_list.js\",");
		//str.append("external_link_list_url : \"js/link_list.js\",");
		//str.append("external_image_list_url : \"js/image_list.js\",");
		//str.append("media_external_list_url : \"js/media_list.js\",");
		str.append("theme_advanced_resizing : true,");
		
		str.append("spellchecker_languages : \"" +
				((LanguageVo.LANG_SP == uData.getLangId().intValue()) ? "+" : "") +
				LabelManager.getName(uData.getLabelSetId(), uData.getLangId(), "lblIdiEsp") + "=es_UY," +
				((LanguageVo.LANG_EN == uData.getLangId().intValue()) ? "+" : "") +
				LabelManager.getName(uData.getLabelSetId(), uData.getLangId(), "lblIdiIng") + "=en_US," +
				((LanguageVo.LANG_PT == uData.getLangId().intValue()) ? "+" : "") +
				LabelManager.getName(uData.getLabelSetId(), uData.getLangId(), "lblIdiPor") + "=pt_PT" + 
				"\",");
		str.append("spellchecker_rpc_url    : \"" + Parameters.ROOT_PATH  + "/spellchecker/jmyspell-spellchecker\",");
		
		// Style formats
		str.append("style_formats : [" +
				"{title : '" + LabelManager.getName(uData.getLabelSetId(), uData.getLangId(), "lbltmceStyRedText") + "', inline : 'span', styles : {color : '#ff0000'}}," +
				"{title : '" + LabelManager.getName(uData.getLabelSetId(), uData.getLangId(), "lbltmceStyRedHead") + "', block : 'h1', styles : {color : '#ff0000'}}" +
			    /*
				"{title : 'Bold text', inline : 'b'}," +
				"{title : 'Red text', inline : 'span', styles : {color : '#ff0000'}}," +
				"{title : 'Red header', block : 'h1', styles : {color : '#ff0000'}}," +
				"{title : 'Example 1', inline : 'span', classes : 'example1'}," +
				"{title : 'Table styles'}," +
				"{title : 'Table row 1', selector : 'tr', classes : 'tablerow1'}" +
				*/
		"]");
		
		str.append("});");
		str.append("</script>");
		out.print(str.toString());
		request.getSession().setAttribute("MCE","false");
	}
%><%	try{
		String strScriptLoad = "";
		String strScriptSubmit = "";
		String strScriptBeforePrint = "";
		String strScriptAfterPrint = "";
		

		Integer currentStep = new Integer(1);
		com.dogma.bean.DogmaAbstractBean aBean = (com.dogma.bean.DogmaAbstractBean) session.getAttribute("dBean");
		if (request.getParameter(com.dogma.DogmaConstants.IN_MODAL)!=null && "T".equals(request.getParameter(com.dogma.DogmaConstants.IN_MODAL))) {
			out.print("<input type=\"hidden\" name=\"" + com.dogma.DogmaConstants.IN_MODAL + "\" value=\"T\">");
		}
		com.dogma.bean.execution.TaskBean tBean = null;
		if (aBean instanceof com.dogma.bean.execution.TaskBean) {
			tBean = (com.dogma.bean.execution.TaskBean) aBean;
			currentStep = tBean.getCurrentStep();
		}
		
		Collection<String> requiredToSign = new ArrayList<String>();
		Collection<String> requiredToSignNames = new ArrayList<String>();
		
		boolean lastStep = true;
		boolean hasSign = false;
		
		if(aBean instanceof TaskBean){ 
			if (tBean !=null && tBean.getStepQty().intValue() > tBean.getCurrentStep().intValue()) {
				lastStep = false;
			}
		}
		
		String frmResult = null;
		boolean stop = false;
		while(!stop){
			com.dogma.bean.execution.FormBean fBean = aBean.getNextUnprocessedForm(request);
			if(fBean == null){
				stop = true;
				continue;
			}
			if (currentStep == null || fBean.getFormStepId() == null || currentStep.equals(fBean.getFormStepId())) {
				if (tBean == null || tBean.evaluateFormCondition(fBean.getFormDef(),request)) {
					try{
						frmResult = fBean.getForm(request);
						if(fBean.getFormDef().getFlagValue(FormVo.FLAG_SIGNABLE_REQ) && !fBean.onlyVerifySignature()){
							if(lastStep || !Parameters.DIGITAL_SIGN_IN_CLIENT){
								requiredToSign.add("hid" + fBean.getParentBeanDesc() + "_" + fBean.getFormId() + "_Signed");
							} else {
								requiredToSign.add("hid" + fBean.getParentBeanDesc() + "_" + fBean.getFormId() + "_DigitalSign");
							}
							requiredToSignNames.add(fBean.getFormDef().getFrmName());
						}
						
						
						out.println(frmResult);
						
						if(fBean.hasOnload && fBean.firstLoad){
							strScriptLoad +=  fBean.getOnLoadName() + ";\n";
						}
						
						if(fBean.hasOnReload && !fBean.firstLoad){
							strScriptLoad +=  fBean.getOnReloadName() + ";\n";
						}
						
						if(fBean.hasOnSubmit){
							strScriptSubmit += "boolContinue = boolContinue & " + fBean.getOnSubmitName() + ";\n";
						}
						
						
						if(fBean.hasOnBeforePrint){
							strScriptBeforePrint += "boolContinue = boolContinue & " + fBean.getOnBeforePrintName() + ";\n";
						}
						if(fBean.hasOnAfterPrint){
							strScriptAfterPrint += "boolContinue = boolContinue & " + fBean.getOnAfterPrintName() + ";\n";
						}
						
	
						fBean.firstLoad = false;
						
						if(tBean!=null){
							tBean.setHasFormsInStep(true);
							if(tBean.hasRequiredSignableForms()){
								hasSign = true;
							}
						} else {
							if(aBean instanceof EntInstanceBean){
								if(((EntInstanceBean)aBean).hasRequiredSignableForms()){
									hasSign = true;	
								}
							}
						}
						
						try{
						if(fBean.getMessages()!=null){
							Iterator it2 = fBean.getMessages().iterator();
							while(it2.hasNext()){
								aBean.addMessage((ErrMessageVo)it2.next());
							}
						}
						}catch(Exception e){ e.printStackTrace();}
		
					} catch (Exception e) {
						out.println("***** ERROR FORM NOT LOADED ****" );
						out.println("<BR>" + e.getMessage() + "<BR>");			
						out.println(" View standard output for more information " );	
						e.printStackTrace();
					}
				}
			} //- End if form in step
				
			fBean.setAjaxSubmit(false);
			fBean.formHasBeenDrawed(true);
		}
		
		aBean.clearProcessedForms(request);
		
		String strScript = (String)request.getAttribute("FORM_SCRIPTS");
	
		if(strScript==null){
			strScript="";
		}
		
		StringBuffer strBuf = new StringBuffer(strScript);
	
		strBuf.append("\n<script language=\"javascript\" DEFER>\n");
		strBuf.append("\nvar saving = false;\n");
		if("E".equals(request.getParameter("frmParent"))){
			strBuf.append("function frmOnloadE(){\n");
		} else {
			strBuf.append("function frmOnloadP(){\n");
		}
		strBuf.append(strScriptLoad);
		strBuf.append("}\n");
		if("E".equals(request.getParameter("frmParent"))){
			strBuf.append("function submitFormsData_E(){\n");
			strBuf.append("if(saving){return true;}");
			strBuf.append("if(!getRequiredToSignFields_E()){return false;}\n");
		} else {
			strBuf.append("function submitFormsData_P(){\n");
			strBuf.append("if(saving){return true;}");
			strBuf.append("if(!getRequiredToSignFields_P()){return false;}\n");
		}
		strBuf.append("var boolContinue = true;\n");
		strBuf.append(strScriptSubmit);
		strBuf.append("if(boolContinue){\n");
		strBuf.append("return true;\n");
		strBuf.append("} else {\n");
		strBuf.append("return false;\n");
		strBuf.append("}\n");
		strBuf.append("}\n");
		
		
		if("E".equals(request.getParameter("frmParent"))){
			strBuf.append("function beforePrintFormsData_E(){\n");
		} else {
			strBuf.append("function beforePrintFormsData_P(){\n");
		}
		strBuf.append("var boolContinue = true;\n");
		strBuf.append(strScriptBeforePrint);
		strBuf.append("if(boolContinue){\n");
		strBuf.append("return true;\n");
		strBuf.append("} else {\n");
		strBuf.append("return false;\n");
		strBuf.append("}\n");
		strBuf.append("}\n");
		
		if("E".equals(request.getParameter("frmParent"))){
			strBuf.append("function afterPrintFormsData_E(){\n");
		} else {
			strBuf.append("function afterPrintFormsData_P(){\n");
		}
		strBuf.append("var boolContinue = true;\n");
		strBuf.append(strScriptAfterPrint);
		strBuf.append("if(boolContinue){\n");
		strBuf.append("return true;\n");
		strBuf.append("} else {\n");
		strBuf.append("return false;\n");
		strBuf.append("}\n");
		strBuf.append("}\n");
		
		if("E".equals(request.getParameter("frmParent"))){
			strBuf.append("function getRequiredToSignFields_E(){\n");
		}else{
			strBuf.append("function getRequiredToSignFields_P(){\n");
		}
		
			
		strBuf.append("if(signedOK!='true'){alert(MSG_REQ_SIGNATURE_FORM); return false;}");
			
		Iterator itReqSign = requiredToSign.iterator();
		Iterator itReqSignNames = requiredToSignNames.iterator();
		while(itReqSign.hasNext()){
			String fieldName = (String)itReqSign.next();	
			String formName = (String)itReqSignNames.next();
			strBuf.append("if(document.getElementById('"+ fieldName +"').value==\"false\"){\n alert(MSG_REQ_SIGNATURE_FORM);\n return false;\n }\n");
			
		}
		if(!lastStep || requiredToSign.size() == 0){ 
			strBuf.append("signedOK = \"true\";");
		}
		if(Parameters.DIGITAL_SIGN_IN_CLIENT && hasSign){
			strBuf.append("if(\"true\" == signedOK){ return true; } else {alert(MSG_REQ_SIGNATURE_FORM); return false;}");
		}else{
			strBuf.append("return true;\n");
		}
		strBuf.append("}\n");

		strBuf.append("</script>\n");
		request.setAttribute("FORM_SCRIPTS",strBuf.toString());
	} catch (Exception e) {
		out.println("***** ERROR FORM NOT LOADED ****" );
		out.println("<BR>" + e.getMessage() + "<BR>");			
		out.println(" View standard output for more information " );	
		e.printStackTrace();
	}
%><%@include file="../../../components/scripts/server/includeEnd.jsp"%>