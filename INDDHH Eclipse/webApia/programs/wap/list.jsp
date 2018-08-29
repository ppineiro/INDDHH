<%@page import="com.dogma.Parameters"%><%@page import="com.dogma.*"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="java.util.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.*"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.execution.UserWorkResumeBean"></jsp:useBean><%String labelSet = "0001"+String.valueOf(Parameters.DEFAULT_LABEL_SET);%><?xml version="1.0"?><!DOCTYPE wml PUBLIC "-//WAPFORUM//DTD WML 1.1//EN" "http://www.wapforum.org/DTD/wml_1.1.xml"><wml><style type="text/css">
	.title {background-color:#92C0E2;border:#416D94 1px solid;}
	body{font-size: 10pt}
</style><%String agent=request.getHeader("User-Agent");
boolean tables=true;
System.out.println("AGENT "+agent);
if(agent.contains("Opera Mini")){
	tables=false;	
}
%><card title="<%=LabelManager.getName(labelSet,"titResUsu")%>"><p><p class="title"><%=LabelManager.getName(labelSet,"tabEjeTarLib")%></p><%if(tables){%><table columns="4" cellspacing="0" border="1" width="100%"><tbody><tr valign="top"><td nowrap="nowrap" style="border:1px solid black;"><font style="font-size:7pt"><%=LabelManager.getName(labelSet,"lblPro")%></font></td><td nowrap="nowrap" style="border:1px solid black;"><font style="font-size:7pt"><%=LabelManager.getName(labelSet,"lblTask")%></font></td><td nowrap="nowrap" style="border:1px solid black;"><font style="font-size:7pt"><%=LabelManager.getName(labelSet,"lblEjeGruTar")%></font></td><td nowrap="nowrap" style="border:1px solid black;"><font style="font-size:7pt"><%=LabelManager.getName(labelSet,"lblTot")%></font></td></tr><%
							Collection col = dBean.getUserResumeReady(request); 
							HashMap colProcessCounts = new HashMap();
							HashMap colTaskCounts = new HashMap();
							HashMap colGroupCounts = new HashMap();
							if(col!=null){
								Iterator it = col.iterator();
								UserWorwResumeRowVo vo = null;
								while(it.hasNext()){
									vo = (UserWorwResumeRowVo)it.next();
									if(colProcessCounts.get(vo.getProName())==null){
										colProcessCounts.put(vo.getProName(),vo.getCount());
									}else{
										int cant = ((Integer)colProcessCounts.get(vo.getProName())).intValue() + vo.getCount().intValue();
										colProcessCounts.put(vo.getProName(),new Integer(cant));
									}
									if(colTaskCounts.get(vo.getTskName())==null){
										colTaskCounts.put(vo.getTskName(),vo.getCount());
									}else{
										int cant = ((Integer)colTaskCounts.get(vo.getTskName())).intValue() + vo.getCount().intValue();
										colTaskCounts.put(vo.getTskName(),new Integer(cant));
									}
									if(colGroupCounts.get(vo.getGrpName())==null){
										colGroupCounts.put(vo.getGrpName(),vo.getCount());
									}else{
										int cant = ((Integer)colGroupCounts.get(vo.getGrpName())).intValue() + vo.getCount().intValue();
										colGroupCounts.put(vo.getGrpName(),new Integer(cant));
									}
							%><tr valign="top"><td style="border:1px solid black;"><font style="font-size:7pt"><%=vo.getProName() %></font></td><td style="border:1px solid black;"><font style="font-size:7pt"><%=vo.getTskName() %></font></td><td style="border:1px solid black;"><font style="font-size:7pt"><%=vo.getGrpName() %></font></td><td style="border:1px solid black;"><font style="font-size:7pt"><%=vo.getCount() %></font></td></tr><%	} //end while
						}//end if%></tbody></table><%}else{
				
				Collection col = dBean.getUserResumeReady(request); 
				HashMap colProcessCounts = new HashMap();
				HashMap colTaskCounts = new HashMap();
				HashMap colGroupCounts = new HashMap();
				if(col!=null){
					Iterator it = col.iterator();
					UserWorwResumeRowVo vo = null;
					while(it.hasNext()){
						vo = (UserWorwResumeRowVo)it.next();
						if(colProcessCounts.get(vo.getProName())==null){
							colProcessCounts.put(vo.getProName(),vo.getCount());
						}else{
							int cant = ((Integer)colProcessCounts.get(vo.getProName())).intValue() + vo.getCount().intValue();
							colProcessCounts.put(vo.getProName(),new Integer(cant));
						}
						if(colTaskCounts.get(vo.getTskName())==null){
							colTaskCounts.put(vo.getTskName(),vo.getCount());
						}else{
							int cant = ((Integer)colTaskCounts.get(vo.getTskName())).intValue() + vo.getCount().intValue();
							colTaskCounts.put(vo.getTskName(),new Integer(cant));
						}
						if(colGroupCounts.get(vo.getGrpName())==null){
							colGroupCounts.put(vo.getGrpName(),vo.getCount());
						}else{
							int cant = ((Integer)colGroupCounts.get(vo.getGrpName())).intValue() + vo.getCount().intValue();
							colGroupCounts.put(vo.getGrpName(),new Integer(cant));
						}
				%><p><%=LabelManager.getName(labelSet,"lblPro")%>:<%=vo.getProName() %></p><p><%=LabelManager.getName(labelSet,"lblTask")%>:<%=vo.getTskName() %></p><p><%=LabelManager.getName(labelSet,"lblEjeGruTar")%>:<%=vo.getGrpName() %></p><p><%=LabelManager.getName(labelSet,"lblTot")%>:<%=vo.getCount() %></p><p>____</p><%	} //end while
			}	
			}%><p>-</p></p></br><p><p class="title"><%=LabelManager.getName(labelSet,"tabEjeTarAdq")%></p><%if(tables){%><table columns="4" cellspacing="0"><tbody><tr valign="top"><td style="border:1px solid black;"><font style="font-size:7pt"><%=LabelManager.getName(labelSet,"lblPro")%></font></td><td style="border:1px solid black;"><font style="font-size:7pt"><%=LabelManager.getName(labelSet,"lblTask")%></font></td><td style="border:1px solid black;"><font style="font-size:7pt"><%=LabelManager.getName(labelSet,"lblEjeGruTar")%></font></td><td style="border:1px solid black;"><font style="font-size:7pt"><%=LabelManager.getName(labelSet,"lblTot")%></font></td></tr><%
					Collection col = dBean.getUserResumeAcquired(request); 
					HashMap colProcessCounts2 = new HashMap();
					HashMap colTaskCounts2 = new HashMap();
					HashMap colGroupCounts2 = new HashMap();
					if(col!=null){
						Iterator it = col.iterator();
						UserWorwResumeRowVo vo = null;
						while(it.hasNext()){
							vo = (UserWorwResumeRowVo)it.next();
							if(colProcessCounts2.get(vo.getProName())==null){
								colProcessCounts2.put(vo.getProName(),vo.getCount());
							}else{
								int cant = ((Integer)colProcessCounts2.get(vo.getProName())).intValue() + vo.getCount().intValue();
								colProcessCounts2.put(vo.getProName(),new Integer(cant));
							}
							if(colTaskCounts2.get(vo.getTskName())==null){
								colTaskCounts2.put(vo.getTskName(),vo.getCount());
							}else{
								int cant = ((Integer)colTaskCounts2.get(vo.getTskName())).intValue() + vo.getCount().intValue();
								colTaskCounts2.put(vo.getTskName(),new Integer(cant));
							}
							if(colGroupCounts2.get(vo.getGrpName())==null){
								colGroupCounts2.put(vo.getGrpName(),vo.getCount());
							}else{
								int cant = ((Integer)colGroupCounts2.get(vo.getGrpName())).intValue() + vo.getCount().intValue();
								colGroupCounts2.put(vo.getGrpName(),new Integer(cant));
							}
					%><tr valign="top"><td style="border:1px solid black;"><font style="font-size:7pt"><%=vo.getProName() %></font></td><td style="border:1px solid black;"><font style="font-size:7pt"><%=vo.getTskName() %></font></td><td style="border:1px solid black;"><font style="font-size:7pt"><%=vo.getGrpName() %></font></td><td style="border:1px solid black;"><font style="font-size:7pt"><%=vo.getCount() %></font></td></tr><%	} //end while
					}//end if%></tbody></table><%}else{
				Collection col = dBean.getUserResumeAcquired(request); 
					HashMap colProcessCounts2 = new HashMap();
					HashMap colTaskCounts2 = new HashMap();
					HashMap colGroupCounts2 = new HashMap();
					if(col!=null){
						Iterator it = col.iterator();
						UserWorwResumeRowVo vo = null;
						while(it.hasNext()){
							vo = (UserWorwResumeRowVo)it.next();
							if(colProcessCounts2.get(vo.getProName())==null){
								colProcessCounts2.put(vo.getProName(),vo.getCount());
							}else{
								int cant = ((Integer)colProcessCounts2.get(vo.getProName())).intValue() + vo.getCount().intValue();
								colProcessCounts2.put(vo.getProName(),new Integer(cant));
							}
							if(colTaskCounts2.get(vo.getTskName())==null){
								colTaskCounts2.put(vo.getTskName(),vo.getCount());
							}else{
								int cant = ((Integer)colTaskCounts2.get(vo.getTskName())).intValue() + vo.getCount().intValue();
								colTaskCounts2.put(vo.getTskName(),new Integer(cant));
							}
							if(colGroupCounts2.get(vo.getGrpName())==null){
								colGroupCounts2.put(vo.getGrpName(),vo.getCount());
							}else{
								int cant = ((Integer)colGroupCounts2.get(vo.getGrpName())).intValue() + vo.getCount().intValue();
								colGroupCounts2.put(vo.getGrpName(),new Integer(cant));
							}
					%><p><%=LabelManager.getName(labelSet,"lblPro")%>:<%=vo.getProName() %></p><p><%=LabelManager.getName(labelSet,"lblTask")%>:<%=vo.getTskName() %></p><p><%=LabelManager.getName(labelSet,"lblEjeGruTar")%>:<%=vo.getGrpName() %></p><p><%=LabelManager.getName(labelSet,"lblTot")%>:<%=vo.getCount() %></p><p>____</p><%	} //end while
					}
				}%><p>-</p></p></card></wml>