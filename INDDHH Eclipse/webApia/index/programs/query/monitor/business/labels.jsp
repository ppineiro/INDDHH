
<%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.Parameters"%><%!

void writeLabel(String lbl,String lblName,JspWriter out,Integer labelSet,Integer langId,String end){
	try{
	out.print(lbl+"=");
	out.print(LabelManager.getName(labelSet, langId, lblName));
	out.print(end);
	}
	catch(Exception e){}
}

%><%
if(request.getHeader("User-Agent").indexOf("Firefox")<0){response.setHeader("Pragma","public no-cache");}else{	if(request.getHeader("User-Agent").indexOf("Firefox")<0){response.setHeader("Pragma","public no-cache");}else{	response.setHeader("Pragma","no-cache");}}
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");
//**************THIS IS USED TO GET THE LABEL SET OF THE USER***************//
Integer labelSet = Parameters.DEFAULT_LABEL_SET;
Integer langId = Parameters.DEFAULT_LANG;

boolean envUsesEntities = false;
com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
if (uData!=null) {
	labelSet = uData.getLabelSetId();
	langId = uData.getLangId();
}
out.clear();writeLabel("lbl_search","btnBus",out,labelSet,langId,"&");
writeLabel("lbl_navigation","lblMonNavigation",out,labelSet,langId,"&");
writeLabel("lbl_history","lblHistoric",out,labelSet,langId,"&");
writeLabel("lbl_finder","lblMonFinder",out,labelSet,langId,"&");
writeLabel("lbl_instances","lblMonInstances",out,labelSet,langId,"&");
writeLabel("lbl_diagram","lblMonDiagram",out,labelSet,langId,"&");
writeLabel("lbl_process","lblEleProcess",out,labelSet,langId,"&");
writeLabel("lbl_task","lblTask",out,labelSet,langId,"&");
writeLabel("lbl_entity","lblEnt",out,labelSet,langId,"&");
writeLabel("lbl_visualization","lblMonVisualization",out,labelSet,langId,"&");
writeLabel("lbl_showEntities","lblMonShwRelEnt",out,labelSet,langId,"&");
writeLabel("lbl_showProcess","lblMonShwRelPrc",out,labelSet,langId,"&");
writeLabel("lbl_showTasks","lblMonShwRelTsk",out,labelSet,langId,"&");
writeLabel("lbl_export","btnExport",out,labelSet,langId,"&");
writeLabel("lbl_cancel","btnCan",out,labelSet,langId,"&");
writeLabel("lbl_downloadError","msgMonDownError",out,labelSet,langId,"&");
writeLabel("lbl_loading","flaProCarg",out,labelSet,langId,"&");
writeLabel("lbl_properties","sbtProperties",out,labelSet,langId,"&");
writeLabel("lbl_details","btnMonDet",out,labelSet,langId,"&");
writeLabel("lbl_tasks","btnMonTsk",out,labelSet,langId,"&");
writeLabel("lbl_circleLayout","lblMonCircLayout",out,labelSet,langId,"&");
writeLabel("lbl_treeLayout","lblMonTreeLayout",out,labelSet,langId,"&");
writeLabel("lbl_groupEntitiesInstances","lblGrpEntInsts",out,labelSet,langId,"&");
writeLabel("lbl_groupProcessInstances","lblGrpPrcInst",out,labelSet,langId,"&");
writeLabel("lbl_name","flaNom",out,labelSet,langId,"&");
writeLabel("lbl_clear","lblClearAll",out,labelSet,langId,"&");
writeLabel("lbl_erase","lblDelSel",out,labelSet,langId,"&");
writeLabel("lbl_refresh","btnAct",out,labelSet,langId,"&");
writeLabel("lbl_back","btnNavPrev",out,labelSet,langId,"&");
writeLabel("lbl_next","btnNavNext",out,labelSet,langId,"&");
writeLabel("lbl_first","btnNavFirst",out,labelSet,langId,"&");
writeLabel("lbl_last","btnNavLast",out,labelSet,langId,"&");
writeLabel("lbl_type","flaTip",out,labelSet,langId,"&");
writeLabel("lbl_description","lblDesc",out,labelSet,langId,"&");
writeLabel("lbl_title","lblTit",out,labelSet,langId,"&");
writeLabel("lbl_comments","lblCom",out,labelSet,langId,"&");
writeLabel("lbl_status","lblEjeStaEnt",out,labelSet,langId,"&");
writeLabel("lbl_filter","btnEjeFil",out,labelSet,langId,"&");
writeLabel("lbl_visible","titVisible",out,labelSet,langId,"&");
writeLabel("lbl_groupBy","lblGroupedBy",out,labelSet,langId,"&");
writeLabel("lbl_pro","lblPro",out,labelSet,langId,"&");
writeLabel("lbl_entInstance","lblBusEntInst",out,labelSet,langId,"&");
writeLabel("lbl_proInstance","lblProInst",out,labelSet,langId,"&");
writeLabel("lbl_pool","lblProPool",out,labelSet,langId,"&");
writeLabel("lbl_ident","lblId",out,labelSet,langId,"&");
writeLabel("lblForObj","lblForObj",out,labelSet,langId,"&");
writeLabel("lblComments","lblComments",out,labelSet,langId,"&");
writeLabel("lblAtt1EntNeg","lblAtt1EntNeg",out,labelSet,langId,"&");
writeLabel("lblAtt2EntNeg","lblAtt2EntNeg",out,labelSet,langId,"&");
writeLabel("lblAtt3EntNeg","lblAtt3EntNeg",out,labelSet,langId,"&");
writeLabel("lblAtt4EntNeg","lblAtt4EntNeg",out,labelSet,langId,"&");
writeLabel("lblAtt5EntNeg","lblAtt5EntNeg",out,labelSet,langId,"&");
writeLabel("lblAtt6EntNeg","lblAtt6EntNeg",out,labelSet,langId,"&");
writeLabel("lblAtt7EntNeg","lblAtt7EntNeg",out,labelSet,langId,"&");
writeLabel("lblAtt8EntNeg","lblAtt8EntNeg",out,labelSet,langId,"&");
writeLabel("lblAtt9EntNeg","lblAtt9EntNeg",out,labelSet,langId,"&");
writeLabel("lblAtt10EntNeg","lblAtt10EntNeg",out,labelSet,langId,"&");
writeLabel("lblAttNum1EntNeg","lblAttNum1EntNeg",out,labelSet,langId,"&");
writeLabel("lblAttNum2EntNeg","lblAttNum2EntNeg",out,labelSet,langId,"&");
writeLabel("lblAttNum3EntNeg","lblAttNum3EntNeg",out,labelSet,langId,"&");
writeLabel("lblAttNum4EntNeg","lblAttNum4EntNeg",out,labelSet,langId,"&");
writeLabel("lblAttNum5EntNeg","lblAttNum5EntNeg",out,labelSet,langId,"&");
writeLabel("lblAttNum6EntNeg","lblAttNum6EntNeg",out,labelSet,langId,"&");
writeLabel("lblAttNum7EntNeg","lblAttNum7EntNeg",out,labelSet,langId,"&");
writeLabel("lblAttNum8EntNeg","lblAttNum8EntNeg",out,labelSet,langId,"&");
writeLabel("lblAttDte1EntNeg","lblAttDte1EntNeg",out,labelSet,langId,"&");
writeLabel("lblAttDte2EntNeg","lblAttDte2EntNeg",out,labelSet,langId,"&");
writeLabel("lblAttDte3EntNeg","lblAttDte3EntNeg",out,labelSet,langId,"&");
writeLabel("lblAttDte4EntNeg","lblAttDte4EntNeg",out,labelSet,langId,"&");
writeLabel("lblAttDte5EntNeg","lblAttDte5EntNeg",out,labelSet,langId,"&");
writeLabel("lblAttDte6EntNeg","lblAttDte6EntNeg",out,labelSet,langId,"&");
writeLabel("lblAttTxtCmbEntNeg","lblAttTxtCmbEntNeg",out,labelSet,langId,"&");
writeLabel("lblTod","lblTod",out,labelSet,langId,"&");

writeLabel("lblAtt1Pro","lblAtt1Pro",out,labelSet,langId,"&");
writeLabel("lblAtt2Pro","lblAtt2Pro",out,labelSet,langId,"&");
writeLabel("lblAtt3Pro","lblAtt3Pro",out,labelSet,langId,"&");
writeLabel("lblAtt4Pro","lblAtt4Pro",out,labelSet,langId,"&");
writeLabel("lblAtt5Pro","lblAtt5Pro",out,labelSet,langId,"&");
writeLabel("lblAttNum1Pro","lblAttNum1Pro",out,labelSet,langId,"&");
writeLabel("lblAttNum2Pro","lblAttNum2Pro",out,labelSet,langId,"&");
writeLabel("lblAttNum3Pro","lblAttNum3Pro",out,labelSet,langId,"&");
writeLabel("lblAttDte1Pro","lblAttDte1Pro",out,labelSet,langId,"&");
writeLabel("lblAttDte2Pro","lblAttDte2Pro",out,labelSet,langId,"&");
writeLabel("lblAttDte3Pro","lblAttDte3Pro",out,labelSet,langId,"&");

writeLabel("lblMonInstProStaRun","lblMonInstProStaRun",out,labelSet,langId,"&");
writeLabel("lblMonInstProStaCan","lblMonInstProStaCan",out,labelSet,langId,"&");
writeLabel("lblMonInstProStaFin","lblMonInstProStaFin",out,labelSet,langId,"&");
writeLabel("lblMonInstProStaCom","lblMonInstProStaCom",out,labelSet,langId,"&");
writeLabel("lblMonInstProStaSus","lblMonInstProStaSus",out,labelSet,langId,"&");

writeLabel("lblFilLik","lblFilLik",out,labelSet,langId,"&");
writeLabel("lblFilEqu","lblFilEqu",out,labelSet,langId,"&");
writeLabel("lblFilDis","lblFilDis",out,labelSet,langId,"&");
writeLabel("lblFilLikRig","lblFilLikRig",out,labelSet,langId,"&");
writeLabel("lblFilNotLik","lblFilNotLik",out,labelSet,langId,"&");
writeLabel("lblFilMor","lblFilMor",out,labelSet,langId,"&");
writeLabel("lblFilMorE","lblFilMorE",out,labelSet,langId,"&");
writeLabel("lblFilLes","lblFilLes",out,labelSet,langId,"&");
writeLabel("lblFilLesE","lblFilLesE",out,labelSet,langId,"");
%>