<%@page import="com.dogma.*"%><%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@page import="com.dogma.test.*"%><%
	UserData userData = (UserData) session.getAttribute(Parameters.SESSION_ATTRIBUTE);
	Integer envId = null;
	if (userData == null) {
		com.st.util.log.Log.error("SESSION NULL");
		throw new ServletException("Session Null ... should never happen");
	}

	ArrayList arr = (ArrayList) ((com.dogma.bean.DogmaAbstractNavigationBean) session.getAttribute("lBeanReady")).getList();
	envId = ((com.dogma.bean.DogmaAbstractNavigationBean) session.getAttribute("lBeanReady")).getEnvironmentId();

	if (arr!=null && arr.size() > 0) { 
		int x = (int) Math.floor(Math.random()* arr.size());
		TasksListVo vo = (TasksListVo) (arr).get(x);
	  	String url = "/" + Parameters.ROOT_PATH + "/execution.TasksListAction.do?action=acquire&workMode=R&proInstId=" + vo.getProcInstId() + "&proEleInstId=" + vo.getProEleInstId();
	  	try {
		com.dogma.business.execution.TasksListService.getInstance().acquireTask(envId, vo.getProcInstId(), vo.getProEleInstId(), com.dogma.bean.DogmaAbstractBean.getStaticUserData(request));
		/* this.getServletContext().getRequestDispatcher(response.encodeURL(url)).forward(request, response); */
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("ERROR");
		}
		if ( ((com.dogma.bean.DogmaAbstractBean) session.getAttribute("dBean")).getHasException()) {
			throw new Exception("ERROR");
		}
	}

%>