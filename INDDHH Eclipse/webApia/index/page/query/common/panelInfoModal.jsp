<%@page import="com.dogma.vo.QueryVo"%><%@page import="biz.statum.sdk.util.BooleanUtils"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.bean.query.QueryExecutionBean"%><%@page import="biz.statum.apia.web.action.BasicAction"%><%@page import="biz.statum.apia.web.action.query.QueryExecutionAction"%><%@page import="com.st.util.labels.LabelManager"%><%
Object modalQuery = pageContext.getAttribute("modalQuery");

Object aBean = QueryExecutionAction.staticRetrieveBean(new HttpServletRequestResponse(request, response), BooleanUtils.isTrue(modalQuery) ? BasicAction.BEAN_QUERY_MODAL_NAME : BasicAction.BEAN_QUERY_NAME);

QueryExecutionBean bean = (QueryExecutionBean) aBean;
QueryVo queryVo = bean.getQueryVo();
%><div class="fncPanel info"><div class="title"><%
		if(queryVo.getQryId() < 1000)
			out.print(LabelManager.getName(uData, queryVo.getQryTitle()));
		else
			out.print(queryVo.getQryTitle());
		%><div class="right modalAccessFilters" id="modalAccessFilters"><system:label show="text" label="lblQryFil"/></div></div></div>
