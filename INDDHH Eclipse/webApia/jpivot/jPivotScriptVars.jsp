<%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.DogmaException"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.EnvParameters"%><%@page import="com.st.util.StringUtil"%><%
String labelSet = "0001"+String.valueOf(Parameters.DEFAULT_LABEL_SET);
if (uData!=null) {
	labelSet = uData.getStrLabelSetId();
}
%><script language="javascript">
	var viewsLabel="<%=LabelManager.getName(labelSet,"lblViews")%>";
	var profilesLabel="<%=LabelManager.getName(labelSet,"titPer")%>";
		
	var nameLabel="<%=LabelManager.getName(labelSet,"lblNom")%>";
	var descriptionLabel="<%=LabelManager.getName(labelSet,"lblDes")%>";
	var mainLabel="<%=LabelManager.getName(labelSet,"lblMainView")%>";
</script>