<%@page import="com.dogma.*"%><%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@page import="com.dogma.test.*"%><%
	UserData userData = (UserData) session.getAttribute(Parameters.SESSION_ATTRIBUTE);
	if (userData == null) {
		com.st.util.log.Log.error("SESSION NULL");
		throw new ServletException("Session Null ... should never happen");
	}


	ArrayList arr = (ArrayList) ((com.dogma.bean.DogmaAbstractNavigationBean) session.getAttribute("lBeanInproc")).getList();

	if (arr!=null && arr.size() > 0) { 
		int x = (int) Math.floor(Math.random()* arr.size());
		TasksListVo vo = (TasksListVo) (arr).get(x);
	  	String url = "/" + Parameters.ROOT_PATH + "/execution.TasksListAction.do?action=work&workMode=A&proInstId=" + vo.getProcInstId() + "&proEleInstId=" + vo.getProEleInstId();

		// work task
		
	  	try {
		    getServletConfig().getServletContext().getRequestDispatcher(response.encodeURL(url)).forward(request, response);
		} catch (Exception e) {
			e.printStackTrace();
		}

		session.setAttribute("TEST_TASK_NAME",vo.getTaskName().toLowerCase());
	} else {
		session.setAttribute("TEST_TASK_NAME",null);	
	}

%>

WORK TASK OK!

