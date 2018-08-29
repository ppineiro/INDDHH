<%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.vo.ImagesVo"%><%@page import="biz.statum.apia.xml.rss.RssImgChannel"%><%@page import="java.util.Date"%><%@page import="java.util.Collection"%><%@page import="biz.statum.apia.vo.SocialMessageChannelVo"%><%@page import="biz.statum.apia.xml.rss.RssItem"%><%@page import="biz.statum.sdk.util.CollectionUtil"%><%@page import="biz.statum.apia.web.bean.SocialBean"%><%@page import="biz.statum.apia.vo.filter.SocialMessageChannelFilterVo"%><%@page import="com.dogma.vo.UserVo"%><%@page import="com.dogma.vo.PoolVo"%><%@page import="com.dogma.vo.EnvironmentVo"%><%@page import="com.dogma.vo.TaskVo"%><%@page import="com.dogma.DogmaException"%><%@page import="com.apia.core.CoreFacade"%><%@page import="com.dogma.vo.ProcessVo"%><%@page import="biz.statum.sdk.util.BooleanUtils"%><%@page import="com.dogma.vo.SocMesChannelsVo"%><%@page import="biz.statum.sdk.util.StringUtil"%><%@page import="biz.statum.apia.xml.rss.RssChannel"%><%@page import="com.dogma.Parameters"%><%@page import="biz.statum.apia.xml.rss.RssXml"%><%
	
	if(request.getHeader("User-Agent").indexOf("Firefox")<0){response.setHeader("Pragma","public no-cache");}else{	response.setHeader("Pragma","no-cache");}
	response.setHeader("Cache-Control","no-store");
	response.setDateHeader("Expires",-1);	

	RssXml rss = new RssXml();	
	
	final String ALL 	= "A";
	final String GLOBAL 	= "G";
	
	try{
		String objType 	= request.getParameter("objType");
		String objId 	= request.getParameter("objId");
		String envId 	= request.getParameter("envId");
		String type		= request.getParameter("type");
		
		//CONTROL: Apia Social y Apia Social RSS activos.
		if (BooleanUtils.isTrue(Parameters.APIASOCIAL_ACTIVE) && Parameters.APIASOCIALRSS_ACTIVE){
			//CONTROL: objType con valor.
			if (StringUtil.notEmpty(objType)){
				boolean isValid = false;
				String chnTitle = null;
				String chnLink = null;
				String chnDescription = null;
				String imgUrl = null;
				String imgLink = null;
				String imgTitle = null;
				boolean isRSSType = false;
				boolean isRSSUserAndPoolType = false;
								
				//CONTROL: Apia Social RSS correspondiente activo (proceso,tarea,ambiente,grupo,usuario).
				//CONTROL: Objeto correspondiente al canal con publicación RSS activada.
				//CONTROL: envId con valor para los casos de procesos y tareas.
				if (Parameters.APIASOCIALRSS_PROCESS && SocMesChannelsVo.TYPE_PROCESS.equals(objType) && StringUtil.notEmpty(envId)){
					if (StringUtil.notEmpty(objId)){ //proceso
						ProcessVo proVo = CoreFacade.getInstance().getProcess(Integer.valueOf(envId),Integer.valueOf(objId),null);
						isValid = proVo != null && proVo.getFlagValue(ProcessVo.FLAG_PUBLISH_RSS);
						chnTitle = proVo != null ? SocMesChannelsVo.getChannelTypeLabel(objType) + " - " + proVo.getProTitle() : "";
						chnDescription = proVo != null && proVo.getProDesc() != null ? proVo.getProDesc() : StringUtil.EMPTY_STRING;
						imgTitle = proVo != null && proVo.getProTitle() != null ? proVo.getProTitle() : SocMesChannelsVo.getChannelTypeLabel(SocMesChannelsVo.TYPE_PROCESS);
						imgUrl = proVo != null ? (proVo.getImgPath() != null ? proVo.getImgPath() : ImagesVo.DEFAULT_IMG_PRO) : null;	
					} else { //todos los procesos del ambiente
						Collection<ProcessVo> colPro = CoreFacade.getInstance().getProcessRSS(Integer.valueOf(envId));
						EnvironmentVo envVo = CoreFacade.getInstance().getEnvironment(Integer.valueOf(envId));
						isValid = CollectionUtil.notEmpty(colPro) && envVo != null;
						chnTitle = LabelManager.getName("titPro") + (envVo != null ? " (" + envVo.getEnvName() + ")" : ""); 
						chnDescription = StringUtil.EMPTY_STRING;
						imgTitle = chnTitle;
						imgUrl = ImagesVo.DEFAULT_IMG_PRO;
						isRSSType = true;
					}
				} else if (Parameters.APIASOCIALRSS_TASK && SocMesChannelsVo.TYPE_TASK.equals(objType) && StringUtil.notEmpty(envId)){
					if (StringUtil.notEmpty(objId)){ //tarea
						TaskVo tskVo = CoreFacade.getInstance().getTask(Integer.valueOf(envId),Integer.valueOf(objId));
						isValid = tskVo != null && tskVo.getFlagValue(TaskVo.POS_FLAG_PUBLISH_RSS);
						chnTitle = tskVo != null ? SocMesChannelsVo.getChannelTypeLabel(objType) + " - " + tskVo.getTskTitle() : "";
						chnDescription = tskVo != null && tskVo.getTskDesc() != null ? tskVo.getTskDesc() : StringUtil.EMPTY_STRING;
						imgTitle = tskVo != null && tskVo.getTskTitle() != null ? tskVo.getTskTitle() : SocMesChannelsVo.getChannelTypeLabel(SocMesChannelsVo.TYPE_TASK);
						imgUrl = tskVo != null ? (tskVo.getImgPath() != null ? tskVo.getImgPath() : ImagesVo.DEFAULT_IMG_TASK) : null;
					} else { //todas las tareas del ambiente
						Collection<TaskVo> colTsk = CoreFacade.getInstance().getTaskRSS(Integer.valueOf(envId));
						EnvironmentVo envVo = CoreFacade.getInstance().getEnvironment(Integer.valueOf(envId));
						isValid = CollectionUtil.notEmpty(colTsk) && envVo != null;
						chnTitle = LabelManager.getName("titTar") + (envVo != null ? " (" + envVo.getEnvName() + ")" : ""); 
						chnDescription = StringUtil.EMPTY_STRING;
						imgTitle = chnTitle;
						imgUrl = ImagesVo.DEFAULT_IMG_TASK;
						isRSSType = true;
					}
					
				} else if (Parameters.APIASOCIALRSS_ENVIRONMENT && SocMesChannelsVo.TYPE_ENVIRONMENT.equals(objType)){
					EnvironmentVo envVo = null;
					if (StringUtil.notEmpty(objId)){ //ambiente
						envVo = CoreFacade.getInstance().getEnvironment(Integer.valueOf(objId));
						isValid = envVo != null && envVo.getFlagValue(EnvironmentVo.FLAG_PUBLISH_RSS);
						chnTitle = envVo != null ? SocMesChannelsVo.getChannelTypeLabel(objType) + " - " + envVo.getEnvName() : "";
						chnDescription = envVo != null && envVo.getEnvDesc() != null ? envVo.getEnvDesc() : StringUtil.EMPTY_STRING;
						imgTitle = envVo != null ? envVo.getEnvName() : SocMesChannelsVo.getChannelTypeLabel(SocMesChannelsVo.TYPE_ENVIRONMENT);
						imgUrl = envVo != null ? "fncAmbientes.gif" : null;
					} else { //ambiente (ingresando por titulo)
						if (StringUtil.notEmpty(envId)){
							objId = envId;
							envVo = CoreFacade.getInstance().getEnvironment(Integer.valueOf(objId));
							isValid = envVo != null && envVo.getFlagValue(EnvironmentVo.FLAG_PUBLISH_RSS);
							chnTitle = envVo != null ? SocMesChannelsVo.getChannelTypeLabel(objType) + " - " + envVo.getEnvName() : "";
							chnDescription = envVo != null && envVo.getEnvDesc() != null ? envVo.getEnvDesc() : StringUtil.EMPTY_STRING;
							imgTitle = envVo != null ? envVo.getEnvName() : SocMesChannelsVo.getChannelTypeLabel(SocMesChannelsVo.TYPE_ENVIRONMENT);
							imgUrl = envVo != null ? "fncAmbientes.gif" : null;
							isRSSType = true;
						} 
					}
					
				} else if (Parameters.APIASOCIALRSS_POOL && SocMesChannelsVo.TYPE_POOL.equals(objType)){
					if (StringUtil.notEmpty(objId)){ //grupo
						PoolVo poolVo = CoreFacade.getInstance().getPool(Integer.valueOf(objId));
						isValid = poolVo != null && poolVo.getFlagValue(PoolVo.FLAG_PUBLISH_RSS);
						chnTitle = poolVo != null ? SocMesChannelsVo.getChannelTypeLabel(objType) + " - " + poolVo.getPoolName() : "";
						chnDescription = poolVo != null && poolVo.getPoolDesc() != null ? poolVo.getPoolDesc() : StringUtil.EMPTY_STRING;
						imgTitle = poolVo != null ? poolVo.getPoolName() : SocMesChannelsVo.getChannelTypeLabel(SocMesChannelsVo.TYPE_POOL);
						imgUrl = poolVo != null ? (poolVo.getImgPath() != null ? poolVo.getImgPath() : ImagesVo.DEFAULT_IMG_POOL) : null;
					} else { 
						if (StringUtil.notEmpty(envId)){ //todos los grupos globales y del ambiente
							Collection<PoolVo> colPool = CoreFacade.getInstance().getPoolRSS(Integer.valueOf(envId),false);
							EnvironmentVo envVo = CoreFacade.getInstance().getEnvironment(Integer.valueOf(envId));
							isValid = CollectionUtil.notEmpty(colPool) && envVo != null;
							chnTitle = LabelManager.getName("titGru") + (envVo != null ? " (" + envVo.getEnvName() + ")" : ""); 
							chnDescription = StringUtil.EMPTY_STRING;
							imgTitle = chnTitle;
							imgUrl = ImagesVo.DEFAULT_IMG_POOL;
							isRSSType = true;
						} else if (StringUtil.notEmpty(type)){ //grupos globales o todos
							Collection<PoolVo> colPool = GLOBAL.equals(type) ? CoreFacade.getInstance().getPoolRSS(null,false) : (ALL.equals(type) ? CoreFacade.getInstance().getPoolRSS(null,true) : null);
							isValid = CollectionUtil.notEmpty(colPool);
							chnTitle = LabelManager.getName(GLOBAL.equals(type) ? "lblGlobalPool" : "lblAllPool"); 
							chnDescription = StringUtil.EMPTY_STRING;
							imgTitle = chnTitle;
							imgUrl = ImagesVo.DEFAULT_IMG_POOL;
							isRSSUserAndPoolType = true;							
						}
					}
					
				} else if (Parameters.APIASOCIALRSS_USER && SocMesChannelsVo.TYPE_USER.equals(objType)){
					if (StringUtil.notEmpty(objId)){ //usuario
						UserVo usrVo = CoreFacade.getInstance().getUser(objId);
						isValid = usrVo != null && usrVo.getFlagValue(UserVo.FLAG_PUBLISH_RSS);
						chnTitle = usrVo != null ? SocMesChannelsVo.getChannelTypeLabel(objType) + " - " + usrVo.getUsrLogin() : "";
						chnDescription = usrVo != null && usrVo.getUsrComments() != null ? usrVo.getUsrComments() : StringUtil.EMPTY_STRING;
						imgTitle = usrVo != null ? usrVo.getUsrLogin() : SocMesChannelsVo.getChannelTypeLabel(SocMesChannelsVo.TYPE_USER);
						imgUrl = usrVo != null ? "fncUsuarios.gif" : null;
					} else { 
						if (StringUtil.notEmpty(envId)){ //todos los usuarios globales y del ambiente
							Collection<UserVo> colUsr = CoreFacade.getInstance().getUserRSS(Integer.valueOf(envId),false);
							EnvironmentVo envVo = CoreFacade.getInstance().getEnvironment(Integer.valueOf(envId));
							isValid = CollectionUtil.notEmpty(colUsr) && envVo != null;
							chnTitle = LabelManager.getName("titUsu") + (envVo != null ? " (" + envVo.getEnvName() + ")" : ""); 
							chnDescription = StringUtil.EMPTY_STRING;
							imgTitle = chnTitle;
							imgUrl = "fncUsuarios.gif";
							isRSSType = true;
						} else if (StringUtil.notEmpty(type)){ //usuarios globales o todos
							Collection<UserVo> colUsr = GLOBAL.equals(type) ? CoreFacade.getInstance().getUserRSS(null,false) : (ALL.equals(type) ? CoreFacade.getInstance().getUserRSS(null,true) : null);
							isValid = CollectionUtil.notEmpty(colUsr);
							chnTitle = LabelManager.getName(GLOBAL.equals(type) ? "lblGlobalUsr" : "lblAllUsers"); 
							chnDescription = StringUtil.EMPTY_STRING;
							imgTitle = chnTitle;
							imgUrl = "fncUsuarios.gif";
							isRSSUserAndPoolType = true;
						}
					}
				} 
				
				if (isValid){
					RssChannel channel = new RssChannel(chnTitle,chnLink,chnDescription);
					Date now = new Date();
					channel.setLastBuildDate(now);
					channel.setPubDate(now);
					if (imgUrl != null){
						String requestURL = request.getRequestURL().toString();
						String requestURL2 = requestURL.substring(0,requestURL.indexOf(request.getContextPath())); 
						imgUrl = requestURL2 + request.getContextPath() + ImagesVo.IMAGES_UPLOADED + imgUrl;
						RssImgChannel image = new RssImgChannel(imgTitle,imgLink,imgUrl);
						channel.addImage(image);	
					}					
					rss.addChannel(channel);		
					
					SocialMessageChannelFilterVo filter = new SocialMessageChannelFilterVo();
					if (!isRSSType && !isRSSUserAndPoolType){ //objeto
						filter.setShowChannel(objType,objId);	
					} else if (isRSSType){ //todos los objetos del ambiente
						filter.setEnvId(Integer.valueOf(envId));
						filter.setShowChannel(objType,null);
						filter.setRssType(true);						
					} else if (isRSSUserAndPoolType){ //grupos o usuarios
						filter.setShowChannel(objType,null);
						filter.setRssType(true);
						filter.setRssPoolUser(true);
						filter.setGlobalMode(GLOBAL.equals(type));
					}
					SocialBean socialBean = new SocialBean(null);
					Collection<SocialMessageChannelVo> col = socialBean.getSocialMessages(filter);
					if (CollectionUtil.notEmpty(col)){
						for (SocialMessageChannelVo socMesChnVo : col){
							String prefix = "";
							if (isRSSType){
								prefix = socMesChnVo.getObjTitle() + " | ";
							} else if (isRSSUserAndPoolType){
								if (SocMesChannelsVo.TYPE_POOL.equals(objType)){
									if (GLOBAL.equals(type)){
										prefix = LabelManager.getName("lblGlobalPool") + " | ";
									} else if (ALL.equals(type)){
										prefix = LabelManager.getName("lblAllPool") + " | ";
									}
								} else if (SocMesChannelsVo.TYPE_USER.equals(objType)){
									if (GLOBAL.equals(type)){
										prefix = LabelManager.getName("lblGlobalUsr") + " | ";
									} else if (ALL.equals(type)){
										prefix = LabelManager.getName("lblAllUsers") + " | ";
									}
								}
							}
							String iTitle = prefix + socMesChnVo.getMessageDateWithFormat() + " | " + socMesChnVo.getMessageAuthor();
							String iLink = null;
							String iDescription = socMesChnVo.getMessageText();
							Date iDate = socMesChnVo.getMessageDate();
							RssItem item = new RssItem(iTitle,iLink,iDescription);
							item.setPubDate(iDate);
							channel.addItem(item);
						}
					}
				}	
			}	
		}
	} catch (DogmaException e){
		rss = null;
	}
	
%><%=rss != null ? rss.generate() : ""%>