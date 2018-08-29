<%@page import="biz.statum.sdk.util.BooleanUtils"%><%@page import="com.dogma.vo.UserVo"%><%@page import="com.dogma.vo.PoolVo"%><%@page import="com.dogma.vo.TaskVo"%><%@page import="com.dogma.DogmaException"%><%@page import="com.dogma.vo.ProcessVo"%><%@page import="biz.statum.sdk.util.StringUtil"%><%@page import="com.dogma.vo.SocMesChannelsVo"%><%@page import="biz.statum.sdk.util.CollectionUtil"%><%@page import="com.apia.core.CoreFacade"%><%@page import="com.dogma.vo.EnvironmentVo"%><%@page import="java.util.Collection"%><%@include file="../../includes/startInc.jsp" %><%!
	public final String ALL 	= "A";
	public final String GLOBAL 	= "G";

	public String getPathURL(HttpServletRequest request){
		String requestURL = request.getRequestURL().toString();
		String requestURL2 = requestURL.substring(0,requestURL.indexOf(request.getContextPath())); 
		return requestURL2 + request.getContextPath() + "/page/rss/social/apiaSocialRSSRead.jsp";		
	}

	public String generateChannelURL(HttpServletRequest request, String objType, String objId, Integer envId){
		objType = objType != null ? objType : StringUtil.EMPTY_STRING;
		objId = objId != null ? objId : StringUtil.EMPTY_STRING;
		
		String url = getPathURL(request);
		url += "?objType=" + objType + "&objId=" + objId;
		if (SocMesChannelsVo.TYPE_PROCESS.equals(objType) || SocMesChannelsVo.TYPE_TASK.equals(objType)){
			 url += "&envId=" + (envId != null ? String.valueOf(envId) : StringUtil.EMPTY_STRING);
		}
		return url;
	}

	public String generateTypeURL(HttpServletRequest request, String objType, Integer envId){
		objType = objType != null ? objType : StringUtil.EMPTY_STRING;
		
		String url = getPathURL(request);
		url += "?objType=" + objType;
		url += "&envId=" + (envId != null ? String.valueOf(envId) : StringUtil.EMPTY_STRING);
		return url;
	}
	
	public String generateUserAndPoolURL(HttpServletRequest request, String objType, String type){
		objType = objType != null ? objType : StringUtil.EMPTY_STRING;
		type = type != null ? type : StringUtil.EMPTY_STRING;
		
		String url = getPathURL(request);
		url += "?objType=" + objType;
		url += "&type=" + type;
		return url;
	}
%><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"><title><system:label show="text" label="lblApiaSocRSS" /></title><system:util show="baseStyles" /><link href="<system:util show="context" />/css/base/modules/rss.css" rel="stylesheet" type="text/css" /><script type="text/javascript" src="<system:util show="context" />/js/mootools-core-1.4.5-full-compat.js"></script><script type="text/javascript" src="<system:util show="context" />/js/mootools-more-1.4.0.1-compat.js"></script><script type="text/javascript" src="<system:util show="context" />/js/generics.js"></script><script type="text/javascript" src="<system:util show="context" />/js/modal.js"></script><script type="text/javascript">
			var BTN_CLOSE	= '<system:label show="text" label="btnCer" forHtml="true" forScript="true"/>';
			var MSG_COPY	= '<system:label show="text" label="msgLinkCopy" forHtml="true" forScript="true"/>'; 
			
			window.addEvent('load', function() {
				$$('h2.showHide-container').each(eventShowHideContainer);
				$$('li.type_section').each(eventShowHideSection);
				$$('li.i_copy').each(function(li){
					eventCopyURL(li);
					eventHover(li);
				});
				
			});
			
			function eventShowHideContainer(ele){
				ele.addEvent('click',function(e){
					if (ele.hasClass("open")){ //se debe cerrar
						ele.removeClass("open");
						ele.addClass("close");
						ele.getNext("div.sections-container").setStyle("display","none");
					} else if (ele.hasClass("close")){ //se debe abrir
						ele.removeClass("close");
						ele.addClass("open");
						ele.getNext("div.sections-container").setStyle("display","");
					}
				}); 
			}
			
			function eventShowHideSection(ele){
				ele.addEvent('click',function(e){
					if (ele.hasClass("open")){ //se debe cerrar
						ele.removeClass("open");
						ele.addClass("close");
						var type = ele.getAttribute("type");
						$$('li.'+type).each(function(li){ li.setStyle("display","none"); });
					} else if (ele.hasClass("close")){ //se debe abrir
						ele.removeClass("close");
						ele.addClass("open");
						var type = ele.getAttribute("type");
						$$('li.'+type).each(function(li){ li.setStyle("display",""); });
					}
				});				
			}
			
			function eventCopyURL(ele){
				ele.addEvent('click',function(e){
					e.stopPropagation();
					var a = ele.getElement("a");
					var rssId = a.getAttribute("copy");
					var element = $(rssId);
					var url = element.getAttribute("href");
					var li = element.getParent("li");
					var lblType = li.getAttribute("label");
					var lblTitle = "";
					if (li.hasClass("type_section")){
						lblType = lblType.toUpperCase();						
					} else {
						lblTitle = " - " + element.innerHTML;
					}
										
					if (window.clipboardData){ //copia automaticamente
						window.clipboardData.setData("Text", url);
						showMessage(MSG_COPY, "RSS: " + lblType + lblTitle);
						hideMessage.delay(1000);
					} else { //copia manual
						showMessage(url, "RSS: " + lblType + lblTitle, "modalRSS");
					}
				});
			}
			
			function eventHover(li){
				li.getElement("a").addEvent("mouseover",function(e){
					var rssId = this.getAttribute("copy");
					var li = $(rssId).getParent("li");
					li.getElement("a").addClass("hover");
				});
				li.getElement("a").addEvent("mouseout",function(e){
					var rssId = this.getAttribute("copy");
					var li = $(rssId).getParent("li");
					li.getElement("a").removeClass("hover");
				});
			}
		
		</script></head><body><div class="contenedor"><div class="contenedor_principal"><div style="border: 1px solid grey;" class="contenido_principal stretch"><div class="header-home-rss stretch"><div class="rss-logo"></div><div class="rss-title"><system:label show="text" label="lblApiaSocRSS" /></div></div><!-- CONTROL: Apia Social y Apia Social RSS activos. --><%if (BooleanUtils.isTrue(Parameters.APIASOCIAL_ACTIVE) && Parameters.APIASOCIALRSS_ACTIVE){%><div class="col-i stretch"><%
								try{
									int count = 0;
									/****** SECCIONES DE AMBIENTES ******/
							%><div class="title"><system:label show="text" label="lblEnvs" /></div><%
									Collection<EnvironmentVo> colEnvironments = CoreFacade.getInstance().getAllEnvironments();
									if (CollectionUtil.notEmpty(colEnvironments)){
										for (EnvironmentVo eVo : colEnvironments){
							%><!-- AMBIENTES --><div class="m-rss"><h2 class="showHide-container close"><%=eVo.getEnvName()%></h2><div class="sections-container interior stretch" style="display:none;"><div class="col"><ul class="stretch"><!-- CONTROL: Procesos activos --><!-- PROCESOS --><%if (Parameters.APIASOCIALRSS_PROCESS){ %><li class="type_section close" type="pro" label="<system:label show="text" label="titPro" />"><a id="rss_<%=count%>" target="_blank" href="<%=generateTypeURL(request,SocMesChannelsVo.TYPE_PROCESS,eVo.getEnvId())%>"><strong><system:label show="text" label="titPro" /></strong></a><ul class="icons"><li class="i_copy"><a copy="rss_<%=count%>" title="<system:label show="tooltip" label="lblCopyRSS" />"><system:label show="text" label="lblCopyRSS" /></a><%count++;%></li></ul></li><%
																	Collection<ProcessVo> colPro = CoreFacade.getInstance().getProcessRSS(eVo.getEnvId());
																	if (CollectionUtil.notEmpty(colPro)){
																		for (ProcessVo pVo : colPro){
																%><li class="pro" style="display:none;" label="<system:label show="text" label="lblPro" />"><a id="rss_<%=count%>" target="_blank" href="<%=generateChannelURL(request,SocMesChannelsVo.TYPE_PROCESS,String.valueOf(pVo.getProId()),pVo.getEnvId())%>"><%=pVo.getProTitle()%></a><ul class="icons"><li class="i_copy"><a copy="rss_<%=count%>" title="<system:label show="tooltip" label="lblCopyRSS" />"><system:label show="text" label="lblCopyRSS" /></a><%count++;%></li></ul></li><%			
																		}
																	}
																%><%}%><!-- CONTROL: Tareas activos --><!-- TAREAS --><%if (Parameters.APIASOCIALRSS_TASK){ %><li class="type_section close" type="tsk" label="<system:label show="text" label="titTar" />"><a id="rss_<%=count%>" target="_blank" href="<%=generateTypeURL(request,SocMesChannelsVo.TYPE_TASK,eVo.getEnvId())%>"><strong><system:label show="text" label="titTar" /></strong></a><ul class="icons"><li class="i_copy"><a copy="rss_<%=count%>" title="<system:label show="tooltip" label="lblCopyRSS" />"><system:label show="text" label="lblCopyRSS" /></a><%count++;%></li></ul></li><%
																	Collection<TaskVo> colTsk = CoreFacade.getInstance().getTaskRSS(eVo.getEnvId());
																	if (CollectionUtil.notEmpty(colTsk)){
																		for (TaskVo tVo : colTsk){
																%><li class="tsk" style="display:none;" label="<system:label show="text" label="lblTask" />"><a id="rss_<%=count%>" target="_blank" href="<%=generateChannelURL(request,SocMesChannelsVo.TYPE_TASK,String.valueOf(tVo.getTskId()),tVo.getEnvId())%>"><%=tVo.getTskTitle()%></a><ul class="icons"><li class="i_copy"><a copy="rss_<%=count%>" title="<system:label show="tooltip" label="lblCopyRSS" />"><system:label show="text" label="lblCopyRSS" /></a><%count++;%></li></ul></li><%			
																		}
																	}
																%><%}%><!-- CONTROL: Ambientes activos --><!-- AMBIENTE --><%if (Parameters.APIASOCIALRSS_ENVIRONMENT){ %><li class="type_section close" type="env" label="<system:label show="text" label="lblAmb" />"><a id="rss_<%=count%>" target="_blank" href="<%=generateTypeURL(request,SocMesChannelsVo.TYPE_ENVIRONMENT,eVo.getEnvId())%>"><strong><system:label show="text" label="lblAmb" /></strong></a><ul class="icons"><li class="i_copy"><a copy="rss_<%=count%>" title="<system:label show="tooltip" label="lblCopyRSS" />"><system:label show="text" label="lblCopyRSS" /></a><%count++;%></li></ul></li><%
																	EnvironmentVo envVo = CoreFacade.getInstance().getEnvironmentRSS(eVo.getEnvId());
																	if (envVo != null){																
																%><li class="env" style="display:none;" label="<system:label show="text" label="lblAmb" />"><a id="rss_<%=count%>" target="_blank" href="<%=generateChannelURL(request,SocMesChannelsVo.TYPE_ENVIRONMENT,String.valueOf(envVo.getEnvId()),envVo.getEnvId())%>"><%=envVo.getEnvName()%></a><ul class="icons"><li class="i_copy"><a copy="rss_<%=count%>" title="<system:label show="tooltip" label="lblCopyRSS" />"><system:label show="text" label="lblCopyRSS" /></a><%count++;%></li></ul></li><%			
																		
																	}
																%><%}%><!-- CONTROL: Grupos activos --><!-- GRUPOS --><%if (Parameters.APIASOCIALRSS_POOL){ %><li class="type_section close" type="pool" label="<system:label show="text" label="titGru" />"><a id="rss_<%=count%>" target="_blank" href="<%=generateTypeURL(request,SocMesChannelsVo.TYPE_POOL,eVo.getEnvId())%>"><strong><system:label show="text" label="titGru" /></strong></a><ul class="icons"><li class="i_copy"><a copy="rss_<%=count%>" title="<system:label show="tooltip" label="lblCopyRSS" />"><system:label show="text" label="lblCopyRSS" /></a><%count++;%></li></ul></li><%
																	Collection<PoolVo> colPool = CoreFacade.getInstance().getPoolRSS(eVo.getEnvId(),false);
																	if (CollectionUtil.notEmpty(colPool)){
																		for (PoolVo pVo : colPool){
																%><li class="pool" style="display:none;" label="<system:label show="text" label="lblProPool" />"><a id="rss_<%=count%>" target="_blank" href="<%=generateChannelURL(request,SocMesChannelsVo.TYPE_POOL,String.valueOf(pVo.getPoolId()),null)%>"><%=pVo.getPoolName()%></a><ul class="icons"><li class="i_copy"><a copy="rss_<%=count%>" title="<system:label show="tooltip" label="lblCopyRSS" />"><system:label show="text" label="lblCopyRSS" /></a><%count++;%></li></ul></li><%			
																		}
																	}
																%><%}%><!-- CONTROL: Usuarios activos --><!-- USUARIOS --><%if (Parameters.APIASOCIALRSS_USER){ %><li class="type_section close" type="usr" label="<system:label show="text" label="titUsu" />"><a id="rss_<%=count%>" target="_blank" href="<%=generateTypeURL(request,SocMesChannelsVo.TYPE_USER,eVo.getEnvId())%>"><strong><system:label show="text" label="titUsu" /></strong></a><ul class="icons"><li class="i_copy"><a copy="rss_<%=count%>" title="<system:label show="tooltip" label="lblCopyRSS" />"><system:label show="text" label="lblCopyRSS" /></a><%count++;%></li></ul></li><%
																	Collection<UserVo> colUsr = CoreFacade.getInstance().getUserRSS(eVo.getEnvId(),false);
																	if (CollectionUtil.notEmpty(colUsr)){
																		for (UserVo uVo : colUsr){
																%><li class="usr" style="display:none;" label="<system:label show="text" label="lblUsu" />"><a id="rss_<%=count%>" target="_blank" href="<%=generateChannelURL(request,SocMesChannelsVo.TYPE_USER,uVo.getUsrLogin(),null)%>"><%=uVo.getUsrLogin()%></a><ul class="icons"><li class="i_copy"><a copy="rss_<%=count%>" title="<system:label show="tooltip" label="lblCopyRSS" />"><system:label show="text" label="lblCopyRSS" /></a><%count++;%></li></ul></li><%			
																		}
																	}
																%><%}%></ul></div></div></div><%					
										}
									}
							%><!-- GRUPOS Y USUARIOS --><div class="title"><system:label show="text" label="lblUsrAndPool" /></div><!-- grupos --><div class="m-rss"><h2 class="showHide-container close"><system:label show="text" label="titGru" /></h2><div class="sections-container interior stretch" style="display:none;"><div class="col"><ul class="stretch"><!-- CONTROL: Grupos activos --><!-- GRUPOS --><%if (Parameters.APIASOCIALRSS_POOL){ %><!-- Grupos globales --><li class="type_section close" type="gpool" label="<system:label show="text" label="lblGlobalPool" />"><a id="rss_<%=count%>" target="_blank" href="<%=generateUserAndPoolURL(request,SocMesChannelsVo.TYPE_POOL,GLOBAL)%>"><strong><system:label show="text" label="lblGlobalPool" /></strong></a><ul class="icons"><li class="i_copy"><a copy="rss_<%=count%>" title="<system:label show="tooltip" label="lblCopyRSS" />"><system:label show="text" label="lblCopyRSS" /></a><%count++;%></li></ul></li><%
																Collection<PoolVo> colPool = CoreFacade.getInstance().getPoolRSS(null,false);
																if (CollectionUtil.notEmpty(colPool)){
																	for (PoolVo pVo : colPool){
															%><li class="gpool" style="display:none;" label="<system:label show="text" label="lblProPool" />"><a id="rss_<%=count%>" target="_blank" href="<%=generateChannelURL(request,SocMesChannelsVo.TYPE_POOL,String.valueOf(pVo.getPoolId()),null)%>"><%=pVo.getPoolName()%></a><ul class="icons"><li class="i_copy"><a copy="rss_<%=count%>" title="<system:label show="tooltip" label="lblCopyRSS" />"><system:label show="text" label="lblCopyRSS" /></a><%count++;%></li></ul></li><%			
																	}
																}
															%><!-- Todos los grupos --><li class="type_section close" type="apool" label="<system:label show="text" label="lblAllPool" />"><a id="rss_<%=count%>" target="_blank" href="<%=generateUserAndPoolURL(request,SocMesChannelsVo.TYPE_POOL,ALL)%>"><strong><system:label show="text" label="lblAllPool" /></strong></a><ul class="icons"><li class="i_copy"><a copy="rss_<%=count%>" title="<system:label show="tooltip" label="lblCopyRSS" />"><system:label show="text" label="lblCopyRSS" /></a><%count++;%></li></ul></li><%
																colPool = CoreFacade.getInstance().getPoolRSS(null,true);
																if (CollectionUtil.notEmpty(colPool)){
																	for (PoolVo pVo : colPool){
															%><li class="apool" style="display:none;" label="<system:label show="text" label="lblProPool" />"><a id="rss_<%=count%>" target="_blank" href="<%=generateChannelURL(request,SocMesChannelsVo.TYPE_POOL,String.valueOf(pVo.getPoolId()),null)%>"><%=pVo.getPoolName()%></a><ul class="icons"><li class="i_copy"><a copy="rss_<%=count%>" title="<system:label show="tooltip" label="lblCopyRSS" />"><system:label show="text" label="lblCopyRSS" /></a><%count++;%></li></ul></li><%			
																	}
																}
															%><%}%></ul></div></div></div><!-- usuarios --><div class="m-rss"><h2 class="showHide-container close"><system:label show="text" label="titUsu" /></h2><div class="sections-container interior stretch" style="display:none;"><div class="col"><ul class="stretch"><!-- CONTROL: Usuarios activos --><!-- USUARIOS --><%if (Parameters.APIASOCIALRSS_POOL){ %><!-- Grupos globales --><li class="type_section close" type="gusr" label="<system:label show="text" label="lblGlobalUsr" />"><a id="rss_<%=count%>" target="_blank" href="<%=generateUserAndPoolURL(request,SocMesChannelsVo.TYPE_USER,GLOBAL)%>"><strong><system:label show="text" label="lblGlobalUsr" /></strong></a><ul class="icons"><li class="i_copy"><a copy="rss_<%=count%>" title="<system:label show="tooltip" label="lblCopyRSS" />"><system:label show="text" label="lblCopyRSS" /></a><%count++;%></li></ul></li><%
																Collection<UserVo> colUsr = CoreFacade.getInstance().getUserRSS(null,false);
																if (CollectionUtil.notEmpty(colUsr)){
																	for (UserVo uVo : colUsr){
															%><li class="gusr" style="display:none;" label="<system:label show="text" label="lblUsu" />"><a id="rss_<%=count%>" target="_blank" href="<%=generateChannelURL(request,SocMesChannelsVo.TYPE_USER,uVo.getUsrLogin(),null)%>"><%=uVo.getUsrLogin()%></a><ul class="icons"><li class="i_copy"><a copy="rss_<%=count%>" title="<system:label show="tooltip" label="lblCopyRSS" />"><system:label show="text" label="lblCopyRSS" /></a><%count++;%></li></ul></li><%			
																	}
																}
															%><!-- Todos los usuarios --><li class="type_section close" type="ausr" label="<system:label show="text" label="lblAllUsers" />"><a id="rss_<%=count%>" target="_blank" href="<%=generateUserAndPoolURL(request,SocMesChannelsVo.TYPE_USER,ALL)%>"><strong><system:label show="text" label="lblAllUsers" /></strong></a><ul class="icons"><li class="i_copy"><a copy="rss_<%=count%>" title="<system:label show="tooltip" label="lblCopyRSS" />"><system:label show="text" label="lblCopyRSS" /></a><%count++;%></li></ul></li><%
																colUsr = CoreFacade.getInstance().getUserRSS(null,true);
																if (CollectionUtil.notEmpty(colUsr)){
																	for (UserVo uVo : colUsr){
															%><li class="ausr" style="display:none;" label="<system:label show="text" label="lblProPool" />"><a id="rss_<%=count%>" target="_blank" href="<%=generateChannelURL(request,SocMesChannelsVo.TYPE_USER,uVo.getUsrLogin(),null)%>"><%=uVo.getUsrLogin()%></a><ul class="icons"><li class="i_copy"><a copy="rss_<%=count%>" title="<system:label show="tooltip" label="lblCopyRSS" />"><system:label show="text" label="lblCopyRSS" /></a><%count++;%></li></ul></li><%			
																	}
																}
															%><%}%></ul></div></div></div><%		
									
								} catch (DogmaException e){} 						
							%></div><%} else { %><div class="rss-off"><system:label show="text" label="msgRSSNoAct" /></div><%}%></div></div></div></body></html>