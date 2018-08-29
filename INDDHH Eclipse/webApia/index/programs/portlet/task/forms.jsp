<%@page import="com.dogma.bean.execution.TaskBean"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="com.dogma.bean.execution.FormBean"%><%@page import="java.util.ArrayList"%><%@page import="java.util.Collection"%><%

Integer currentStep = new Integer(1);
DogmaAbstractBean aBean = (DogmaAbstractBean) session.getAttribute("apiaPortletBean");

TaskBean tBean = null;
if (aBean instanceof TaskBean) {
	tBean = (TaskBean) aBean;
	currentStep = tBean.getCurrentStep();
}

Collection<FormBean> forms = new ArrayList<FormBean>();
Collection<FormBean> formsProcessed = new ArrayList<FormBean>();
Collection<FormBean> formsToProcess = aBean.getForms(request);
if (formsToProcess != null) forms.addAll(formsToProcess);

String frmResult = null;
while (forms!=null && forms.size() > 0) {
	for (FormBean fBean : forms) {
		if (currentStep == null || fBean.getFormStepId() == null || currentStep.equals(fBean.getFormStepId())) {
			if (tBean == null || tBean.evaluateFormCondition(fBean.getFormDef())) {
				try{
					if (tBean != null) tBean.setHasFormsInStep(true); 
					
					frmResult = fBean.getFormPortlet(request);
					if (!"".equals(frmResult)) out.println("<BR>");
					out.println(frmResult);
					
					fBean.firstLoad = false;
					
				} catch (Exception e) {
					out.println("***** ERROR FORM NOT LOADED ****" );
					out.println("<BR>" + e.getMessage() + "<BR>");			
					out.println(" View standard output for more information " );	
					e.printStackTrace();
				}
			}
		}
		
		fBean.setAjaxSubmit(false);
		fBean.formHasBeenDrawed(true);
		
		formsProcessed.addAll(forms);
		forms = new ArrayList<FormBean>();
		formsToProcess = aBean.getForms(request);
		if (formsToProcess != null) forms.addAll(formsToProcess);
		forms.removeAll(formsProcessed);
	}
}
%>