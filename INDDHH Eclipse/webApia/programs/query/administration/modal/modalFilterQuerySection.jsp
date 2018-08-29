<%
boolean addedNewLine = false;
boolean addedEndLine = true;
for (java.util.Iterator iterator = filterColumns.iterator(); iterator.hasNext(); ) {
	com.dogma.vo.filter.QryColumnFilterVo filter = (com.dogma.vo.filter.QryColumnFilterVo) iterator.next();
	if (com.dogma.vo.QryColumnVo.FUNCTION_NONE == filter.getFunction() && ! filter.isHidden()) {
		if (addedEndLine || filter.is2Column()) {
			if (filter.is2Column() && ! addedEndLine) {
				out.print("</tr>");
				addedEndLine = true;
			}
			out.print("<tr>");
			addedNewLine = true; 
		} else {
			addedNewLine = false; 
		} 
		out.print("<td style='whiteSpace:nowrap' title=\"");
		out.print(dBeanModal.fmtHTML(filter.getQryColumnVo().getQryColTooltip()));
		out.print("\">");
		out.print(dBeanModal.fmtHTML(filter.getQryColumnVo().getQryColHeadName()));
		out.print(":</td>");
		out.print("<td ");
		out.print((filter.is2Column())?"colspan='3'":"");
		out.print(">");
		out.print(filter.getHTML(styleDirectory,queryVo.getFlagValue(QueryVo.FLAG_TO_PROCEDURE)));
		out.print("</td>");
		if (filter.is2Column()) {
			out.print("</tr>");
			addedEndLine = true;
			addedNewLine = false;
		} else if (! addedNewLine) {
			out.print("</tr>");
			addedEndLine = true;
		} else {
			addedEndLine = false;
		}
	}
}
if (! addedEndLine) {
	out.print("</tr>");
} %><script>
function stringType(field) {
	var rets = openModal("/programs/query/administration/filter/string.jsp?type=" + document.getElementById(field).value,500,200);
	var doAfter=function(rets){
		if (rets != null) {
			document.getElementById(field).value = rets;
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function numberType(field) {
	var rets = openModal("/programs/query/administration/filter/number.jsp?type=" + document.getElementById(field).value,500,220);
	var doAfter=function(rets){
		if (rets != null) {
			document.getElementById(field).value = rets;
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}
</script>
