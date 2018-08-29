	<element name="task"><attGroup name=""<%=(!bpmnAtts?" notShown=\"true\"":"")%>><attribute name="documentation" label="<%=lbl("lblbtnDocumentation")%>" type="modalArray" modalclass="view.modal.Condition" modalwidth="530" modalheight="330" use="optional" dataType="string" /><attribute label="<%=lbl("lblName")%>" regExp="a-zA-Z0-9_." name="nameChooser" type="modal" change="setName" useLabelName="true" modalclass="view.modal.ElementChoose" modalwidth="580" modalheight="390" modalUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?type=task&<%=tabId%>" value="DEFAULT_TASK"><complexadd regExp="a-zA-Z0-9_."><level name="name" label="<%=lbl("lblName")%>" type="text" /><level name="title" label="Title" type="text" /></complexadd><values><value value="DEFAULT_TASK"><level name="id" value="2" /><level name="name" value="DEFAULT_TASK" /><level name="label" value="Default Task" /></value></values></attribute><attribute label="StartQuantity" name="startquantity" type="text" use="optional" dataType="string" value="1" hidden="true" /><attribute label="CompletionQuantity" name="completionquantity" type="text" use="optional" dataType="string" value="1" hidden="true" /><attribute label="CompletionQuantity" name="completionquantity" type="text" use="optional" dataType="string" value="1" hidden="true" /><attribute label="ActivityType" name="activitytype" type="label" value="Task" change="setDependencyProps" hidden="true" /><attribute label="<%=lbl("lblProPool")%>" name="performers" modalwidth="640" modalheight="337" type="modalArray" modalclass="view.modal.ObjectAdder" modalUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?type=group&<%=tabId%>"><data><level name="perfid" type="label" width="0" label="Id" /><level name="perfname" type="label" width="75%" label="<%=lbl("lblName")%>" /><level width="13%" name="condition" label="Cond" hideLabel="true" modaltitle="Condition" type="modalArray" modalclass="view.modal.Condition" modalwidth="530" modalheight="330" validateurl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?action=xmlValCondition&<%=tabId%>"><data><%=condRules%></data></level><level width="12%" name="documentation" label="Doc" hideLabel="true" modaltitle="Docuementation" type="modalArray" modalclass="view.modal.Condition" modalwidth="530" modalheight="330" use="optional" dataType="string"></level></data></attribute><attribute label="<%=lbl("lblProPool")%>" name="hiddenperformers" modalwidth="340" modalheight="330" type="modalArray" modalclass="view.modal.ObjectAdder" modalUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?type=group&<%=tabId%>" hidden="true"><data><level name="perfid" type="label" width="0" label="Id" /><level name="perfname" type="label" width="40%" label="<%=lbl("lblName")%>" /><level width="30%" name="condition" label="Cond." modaltitle="Condition" type="modalArray" modalclass="view.modal.Condition" modalwidth="530" modalheight="330" validateurl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?action=xmlValCondition&<%=tabId%>"><data><%=condRules%></data></level><level width="30%" name="documentation" label="Doc." modaltitle="Docuementation" type="modalArray" modalclass="view.modal.Condition" modalwidth="530" modalheight="330" use="optional" dataType="string"></level></data></attribute><attribute label="<%=lbl("lbl_taskType")%>" name="taskType" type="combo" change="typeChange" value="User"><values><value label="None" value="None" enable="name,performers,looptype,role,steps" disable="service,receive,send,user" /><value label="Service" value="Service" enable="service,name" disable="receive,send,user,performers,role,looptype,steps" /><value label="Receive" value="Receive" enable="receive,name" disable="service,send,user,looptype,performers,role,steps" /><value label="Send" value="Send" enable="send,name,looptype" disable="service,receive,user,performers,role,steps" /><value label="User" value="User" enable="user,looptype,performers,role,steps" disable="service,receive,send,name" /><value label="Manual" value="Manual" enable="name,looptype,performers,role,steps" disable="service,send,user,receive" /><value label="Script" value="Script" enable="name,looptype,bussinessclasses" disable="service,send,user,receive,performers,role,steps" /></values></attribute><attribute label="<%=lbl("lblLoopType")%>" name="looptype" type="combo" change="loopTypeChange,setMultiInMsgs" value="None"><values><value label="None" value="None" disable="testtime,mi_ordering,loopmaximum,loopcounter,mi_condition,mi_flowcondition,complexmi_flowcondition" enable="" /><value label="MultiInstance" value="MultiInstance" enable="mi_ordering,mi_condition" disable="testtime,loopmaximum,mi_flowcondition,complexmi_flowcondition,loopcounter"/></values></attribute><attribute label="<%=lbl("lblMICond")%>" name="mi_condition" disabled="true" textenabled="true" type="modal" regExp="0-9" modalwidth="520" modalheight="360" modalUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?type=attributes&attType=N&<%=tabId%>" modalclass="view.modal.ElementChoose" title="attributes" /><attribute label="LoopCounter" name="loopcounter" type="text" disabled="true" use="required" dataType="int"/><attribute label="LoopMaximum" name="loopmaximum" type="text" disabled="true" use="optional" dataType="int"/><attribute label="TestTime" name="testtime" type="combo" disabled="true" value="After" dataType="string" hidden="true"><values><value label="After" value="After" /><value label="Before" value="Before" /></values></attribute><attribute label="MI_Ordering" name="mi_ordering" type="combo" disabled="true" value="Parallel" dataType="string" hidden="true"><values><value label="Parallel" value="Parallel" enable="mi_flowcondition" disable="complexmi_flowcondition" /><value label="Sequential" value="Sequential" disable="mi_flowcondition,complexmi_flowcondition"/></values></attribute><attribute label="MI_FlowCondition" name="mi_flowcondition" type="combo" disabled="true" value="All" dataType="string" hidden="true"><values><value label="All" value="All" disable="complexmi_flowcondition"/><value label="One" value="One" disable="complexmi_flowcondition"/><value label="Complex" value="Complex" enable="complexmi_flowcondition"/></values></attribute><attribute label="ComplexMI_FlowCondition" name="complexmi_flowcondition" type="text" disabled="true" use="optional" dataType="string"/><attribute name="user" label="<%=lbl("lblUsrName")%>" disabled="false"><attributes><attribute name="inmessageref" label="<%=lbl("lblInMsgRef")%>"><attributes><attribute name="wsname" label="<%=lbl("lblTipClaWS")%>" type="text" /><attribute name="processattributes" label="<%=lbl("lblwsBusProAtt")%>" modalwidth="650" modalheight="330" type="modalArray" modalclass="view.modal.ObjectAdder" modalUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?type=attributes&<%=tabId%>" oneCheckedInRow="true"><data><level width="0" name="id" label="id" type="text" hidden="true" /><level width="76%" name="name" label="<%=lbl("lblName")%>" type="label" /><level width="10%" name="uk" label="UK" type="checkbox" /><level width="14%" name="multivalued" label="Multi" type="checkbox" /></data></attribute><attribute name="entityattributes" label="<%=lbl("lblwsBusEntAtt")%>" modalwidth="650" modalheight="330" type="modalArray" modalclass="view.modal.ObjectAdder" modalUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?type=attributes&<%=tabId%>" oneCheckedInRow="true"><data><level width="0" name="id" label="id" type="text" hidden="true" /><level width="76%" name="name" label="<%=lbl("lblName")%>" type="label" /><level width="10%" name="uk" label="UK" type="checkbox" /><level width="14%" name="multivalued" label="Multi" type="checkbox" /></data></attribute></attributes></attribute><attribute name="outmessageref" label="OutMessageRef"><attributes><attribute label="<%=lbl("lblTipClaWS")%>" name="wsclasses" type="modalArray" modalclass="view.modal.ComboAdder" modalwidth="384" modalheight="250" clsXml="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?action=classes&amp;wsClasses=true&<%=tabId%>"><data><level width="0" name="evtname" label="Event" type="label" /><level width="0" name="evtid" label="Event" type="label" /><level width="87%" name="clsname" label="<%=lbl("lblName")%>" type="label" /><level width="0" name="clsid" label="Clsid" type="label" /><level width="13%" name="binding" label="<%=lbl("flaProBnd")%>" hideLabel="true" type="modalArray" modalclass="view.modal.EntityBinding" modalwidth="530" modalheight="330" modalUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?action=bindings&<%=tabId%>" attributesUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?type=attributes&<%=tabId%>"><data><level width="0" name="id" label="Id" type="text" hidden="true" /><level width="32%" name="param" label="<%=lbl("flaProBndPar")%>" type="label" /><level width="8%" name="type" label="<%=lbl("flaProBndTyp")%>" type="label" /><level width="25%" name="value" label="<%=lbl("flaVal")%>" type="label" /><level width="25%" name="attribute" label="<%=lbl("flaAtt")%>" type="label" atttype="event" /><level width="0" name="attributeid" label="AttributeId" type="label" /><level width="10%" name="inout" label="In/Out" type="label" /><level width="0" name="attributetooltip" label="AttributeTooltip" type="label" hidden="true" /></data></level></data></attribute></attributes></attribute><attribute name="implementation" label="Implementation" value="WebService" type="label" hidden="true" /></attributes></attribute><attribute name="service" label="Service" disabled="true"><attributes><attribute name="inmessageref" label="<%=lbl("lblInMsgRef")%>"><attributes><attribute name="wsname" label="<%=lbl("lblTipClaWS")%>" type="text" /><attribute name="processattributes" label="<%=lbl("lblwsBusProAtt")%>" modalwidth="650" modalheight="330" type="modalArray" modalclass="view.modal.ObjectAdder" modalUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?type=attributes&<%=tabId%>" oneCheckedInRow="true"><data><level width="0" name="id" label="id" type="text" hidden="true" /><level width="76%" name="name" label="<%=lbl("lblName")%>" type="label" /><level width="10%" name="uk" label="UK" type="checkbox" /><level width="14%" name="multivalued" label="Multi" type="checkbox" /></data></attribute><attribute name="entityattributes" label="<%=lbl("lblwsBusEntAtt")%>" modalwidth="650" modalheight="330" type="modalArray" modalclass="view.modal.ObjectAdder" modalUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?type=attributes&<%=tabId%>" oneCheckedInRow="true"><data><level width="0" name="id" label="id" type="text" hidden="true" /><level width="76%" name="name" label="<%=lbl("lblName")%>" type="label" /><level width="10%" name="uk" label="UK" type="checkbox" /><level width="14%" name="multivalued" label="Multi" type="checkbox" /></data></attribute></attributes></attribute><attribute name="outmessageref" label="OutMessageRef"><attributes><attribute label="<%=lbl("lblTipClaWS")%>" name="wsclasses" type="modalArray" modalclass="view.modal.ComboAdder" modalwidth="384" modalheight="250" clsXml="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?action=classes&amp;wsClasses=true&<%=tabId%>"><data><level width="0" name="evtname" label="Event" type="label" /><level width="0" name="evtid" label="Event" type="label" /><level width="87%" name="clsname" label="<%=lbl("lblName")%>" type="label" /><level width="0" name="clsid" label="Clsid" type="label" /><level width="13%" name="binding" label="<%=lbl("flaProBnd")%>" hideLabel="true" type="modalArray" modalclass="view.modal.EntityBinding" modalwidth="530" modalheight="330" modalUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?action=bindings&<%=tabId%>" attributesUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?type=attributes&<%=tabId%>"><data><level width="0" name="id" label="Id" type="text" hidden="true" /><level width="32%" name="param" label="<%=lbl("flaProBndPar")%>" type="label" /><level width="8%" name="type" label="<%=lbl("flaProBndTyp")%>" type="label" /><level width="25%" name="value" label="<%=lbl("flaVal")%>" type="label" /><level width="25%" name="attribute" label="<%=lbl("flaAtt")%>" type="label" atttype="event" /><level width="0" name="attributeid" label="AttributeId" type="label" /><level width="10%" name="inout" label="In/Out" type="label" /><level width="0" name="attributetooltip" label="AttributeTooltip" type="label" hidden="true" /></data></level></data></attribute></attributes></attribute><attribute name="implementation" label="Implementation" value="WebService" type="label" hidden="true" /></attributes></attribute><attribute name="receive" label="Receive" disabled="true"><attributes><attribute name="messageref" label="<%=lbl("lblMsgRef")%>"><attributes><attribute name="wsname" label="<%=lbl("lblTipClaWS")%>" type="text" /><attribute name="processattributes" label="<%=lbl("lblwsBusProAtt")%>" modalwidth="650" modalheight="330" type="modalArray" modalclass="view.modal.ObjectAdder" modalUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?type=attributes&<%=tabId%>" oneCheckedInRow="true"><data><level width="0" name="id" label="id" type="text" hidden="true" /><level width="76%" name="name" label="<%=lbl("lblName")%>" type="label" /><level width="10%" name="uk" label="UK" type="checkbox" /><level width="14%" name="multivalued" label="Multi" type="checkbox" /></data></attribute><attribute name="entityattributes" label="<%=lbl("lblwsBusEntAtt")%>" modalwidth="650" modalheight="330" type="modalArray" modalclass="view.modal.ObjectAdder" modalUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?type=attributes&<%=tabId%>" oneCheckedInRow="true"><data><level width="0" name="id" label="id" type="text" hidden="true" /><level width="76%" name="name" label="<%=lbl("lblName")%>" type="label" /><level width="10%" name="uk" label="UK" type="checkbox" /><level width="14%" name="multivalued" label="Multi" type="checkbox" /></data></attribute></attributes></attribute><attribute name="instantiate" label="Instantiate" type="checkbox" value="false" disabled="true" /><attribute name="implementation" label="Implementation" value="WebService" type="label" hidden="true" /></attributes></attribute><attribute name="send" label="Send" disabled="true"><attributes><attribute name="messageref" label="<%=lbl("lblMsgRef")%>"><attributes><attribute label="<%=lbl("lblTipClaWS")%>" name="wsclasses" type="modalArray" modalclass="view.modal.ComboAdder" modalwidth="384" modalheight="250" clsXml="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?action=classes&amp;wsClasses=true&<%=tabId%>"><data><level width="0" name="evtname" label="Event" type="label" /><level width="0" name="evtid" label="Event" type="label" /><level width="87%" name="clsname" label="<%=lbl("lblName")%>" type="label" /><level width="0" name="clsid" label="Clsid" type="label" /><level width="13%" name="binding" label="<%=lbl("flaProBnd")%>" hideLabel="true" type="modalArray" modalclass="view.modal.EntityBinding" modalwidth="530" modalheight="330" modalUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?action=bindings&<%=tabId%>" attributesUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?type=attributes&<%=tabId%>"><data><level width="0" name="id" label="Id" type="text" hidden="true" /><level width="32%" name="param" label="<%=lbl("flaProBndPar")%>" type="label" /><level width="8%" name="type" label="<%=lbl("flaProBndTyp")%>" type="label" /><level width="25%" name="value" label="<%=lbl("flaVal")%>" type="label" /><level width="25%" name="attribute" label="<%=lbl("flaAtt")%>" type="label" atttype="event" /><level width="0" name="attributeid" label="AttributeId" type="label" /><level width="10%" name="inout" label="In/Out" type="label" /><level width="0" name="attributetooltip" label="AttributeTooltip" type="label" hidden="true" /></data></level></data></attribute></attributes></attribute><attribute name="implementation" label="Implementation" value="WebService" type="label" hidden="true" /></attributes></attribute><attribute label="FirstTask" name="firsttask" type="text" use="optional" dataType="string" value="false" hidden="true" /><attribute name="role" label="<%=lbl("lblRole")%>" modalwidth="340" modalheight="320" type="modal" modalclass="view.modal.ElementChoose" modalUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?type=roles&<%=tabId%>"/><attribute label="<%=lbl("lblFomEnt")%>" name="steps" type="modalArray" modalclass="view.modal.LevelAdder" modalwidth="425" modalheight="337"><data><level width="20%" name="step" label="Step" type="label" value="step" /><level width="40%" name="entityforms" label="<%=lbl("lblProEntFor")%>" modalwidth="680" modalheight="330" type="modalArray" modalclass="view.modal.ObjectAdder" modalUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?type=form&<%=tabId%>&busEntId=<%=currentEntity%>"<%=((currentEntity==null)?" message=\"An Entity has not been selected\"":"")%>><data><level width="0" name="id" label="Id" type="text" hidden="true"/><level width="60%" name="name" label="<%=lbl("lblName")%>" type="label"/><level width="9%" name="readonly" label="RO" type="checkbox"/><level width="7%" name="multiple" label="M" type="checkbox"/><level width="12%" name="condition" label="Cond" hideLabel="true" modaltitle="Condition" type="modalArray" modalclass="view.modal.Condition" modalwidth="530" modalheight="330" validateurl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?action=xmlValCondition&<%=tabId%>"><data><%=condRules%></data></level><level width="11%" name="documentation" label="Doc" hideLabel="true" modaltitle="Docuementation" type="modalArray" modalclass="view.modal.Condition" modalwidth="530" modalheight="330" use="optional" dataType="string" /></data></level><level width="40%" name="processforms" label="<%=lbl("flaProProFor")%>" modalwidth="680" modalheight="330" type="modalArray" modalclass="view.modal.ObjectAdder" modalUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?type=form&<%=tabId%>"><data><level width="0" name="id" label="Id" type="text" hidden="true"/><level width="60%" name="name" label="<%=lbl("lblName")%>" type="label"/><level width="9%" name="readonly" label="RO" type="checkbox"/><level width="7%" name="multiple" label="M" type="checkbox"/><level width="12%" name="condition" label="Cond" hideLabel="true" type="modalArray" modalclass="view.modal.Condition" modalwidth="530" modalheight="330" modaltitle="Condition" validateurl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?action=xmlValCondition&<%=tabId%>"><data><%=condRules%></data></level><level width="11%" name="documentation" label="Doc" hideLabel="true" modaltitle="Docuementation" type="modalArray" modalclass="view.modal.Condition" modalwidth="530" modalheight="330" use="optional" dataType="string" /></data></level></data></attribute><attribute label="<%=lbl("flaEve")%>" name="bussinessclasses" type="modalArray" modalclass="view.modal.ComboAdder" modalwidth="534" modalheight="350" evtXml="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?action=events&amp;evtScope=T&<%=tabId%>" clsXml="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?action=classes&<%=tabId%>"><data><level width="18%" name="evtname" label="<%=lbl("lblEvent")%>" type="label" /><level width="0" name="evtid" label="Event" type="label" /><level width="60%" name="clsname" label="<%=lbl("lblName")%>" type="label" /><level width="0" name="clsid" label="Clsid" type="label" /><level width="10%" name="binding" label="<%=lbl("flaProBnd")%>" hideLabel="true" type="modalArray" modalclass="view.modal.EntityBinding" modalwidth="600" modalheight="330" modalUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?action=bindings&<%=tabId%>" attributesUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?type=attributes&<%=tabId%>"><data><level width="0" name="id" label="Id" type="text" hidden="true" /><level width="32%" name="param" label="<%=lbl("lblPar")%>" type="label" /><level width="8%" name="type" label="<%=lbl("flaProBndTyp")%>" type="label" /><level width="25%" name="value" label="<%=lbl("flaVal")%>" type="label" /><level width="25%" name="attribute" label="<%=lbl("flaAtt")%>" type="label" atttype="event" /><level width="0" name="attributeid" label="AttributeId" type="label" /><level width="10%" name="inout" label="<%=lbl("lblInOut")%>" type="label" /><level width="0" name="attributetooltip" label="AttributeTooltip" type="label" hidden="true" /></data></level><level width="12%" label="<%=lbl("flaProCnd")%>" hideLabel="true" name="skipcondition" type="modalArray" modalclass="view.modal.Condition" modalwidth="530" modalheight="330" validateurl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?action=xmlValCondition&<%=tabId%>"><data><%=condRules%></data></level></data></attribute><attribute label="<%=lbl("flaProStatus")%>" name="taskstates" type="modalArray" modalclass="view.modal.ComboAdder" modalwidth="520" modalheight="330" evtXml="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?action=events&amp;evtScope=T&<%=tabId%>" clsXml="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?action=status&<%=tabId%>&busEntId=<%=currentEntity%>"<%=((currentEntity==null)?" message=\"An Entity has not been selected\"":"")%>><data><level width="18%" name="evtname" label="<%=lbl("lblEvent")%>" type="label" /><level width="0" name="evtid" label="Event" type="label" /><level width="62%" name="clsname" label="<%=lbl("lblSta")%>" type="label" /><level width="0" name="clsid" label="Clsid" type="label" /><level width="12%" label="<%=lbl("flaProCnd")%>" hideLabel="true" name="condition" type="modalArray" modalclass="view.modal.Condition" modalwidth="530" modalheight="330" validateurl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?action=xmlValCondition&<%=tabId%>"><data><%=condRules%></data></level><level width="8%" name="documentation" label="Doc" hideLabel="true" type="modalArray" modalclass="view.modal.Condition" modalwidth="530" modalheight="330" use="optional" dataType="string" modaltitle="<%=lbl("lblbtnDocumentation")%>" /></data></attribute><attribute label="ProEleId" name="proeleid" type="text" use="optional" dataType="string" value="" hidden="true" /><attribute name="highlightcomments" label="<%=lbl("flaProTskHC")%>" type="checkbox" use="optional" dataType="boolean"/><attribute label="<%=lbl("lblScheduler")%>" name="scheduledTask" type="modalArray" modalclass="view.modal.CalendarModal" modalwidth="360" modalheight="160" modalUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?action=xmlCalendars&<%=tabId%>" procTasksUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?action=xmlProcTasks&<%=tabId%>" subProcUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?type=subProcess&<%=tabId%>"><values><value><level name="tsk_sch_id" label="<%=lbl("lblScheduler")%>" value="" /><level name="active_tsk_id" label="<%=lbl("lblTask")%>" value="" /><level name="active_prc_id" label="<%=lbl("flaProSubPro")%>" value="" /><level name="active_prc_name" label="<%=lbl("flaProSubPro")%>" value="" /><level name="asgn_type" label="<%=lbl("flaProBndTyp")%>" value="" /></value></values></attribute><attribute name="skipcondition" label="<%=lbl("lblSkipCond")%>" type="modalArray" validateurl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?action=xmlValCondition&<%=tabId%>" modalclass="view.modal.Condition" modalwidth="530" modalheight="330"><data><%=condRules%></data></attribute></attGroup><attGroup name="User Defined Attributes" id="userproperties"<%=(!userAtts?" notShown=\"true\"":"")%>><attribute label="User Attributes" name="userattributes" modalwidth="310" modalheight="330" type="modalArray" modalclass="view.modal.LevelAdder"><data><level width="30%" label="<%=lbl("lblName")%>" name="name" type="text" /><level width="30%" label="<%=lbl("flaProBndTyp")%>" name="type" type="combo" value="String"><values><value label="String" value="String" /><value label="Numeric" value="Numeric" /><value label="Boolean" value="Boolean" /></values></level><level width="30%" label="<%=lbl("flaVal")%>" name="value" type="text" /></data></attribute></attGroup><%if(simAtts){%><attGroup name="Simulator" id="simulator"><%@include file="freqcombo.jsp" %><attribute label="<%=lbl("lblFirstParam")%>" name="firstvalue" type="text" use="optional" dataType="int" value="0" /><attribute label="<%=lbl("lblSecondParam")%>" name="secondvalue" type="text" use="optional" dataType="int" value="0" /><attribute label="<%=lbl("lblSimQueueType")%>" name="queuetype" type="combo" value="1" dataType="string"><values><value label="<%=lbl("lblQueLifo")%>" value="1" /><value label="<%=lbl("lblQueFifo")%>" value="0" /></values></attribute><attribute label="<%=lbl("lblPoolProbability")%>" name="poolprobability" type="modalArray" modalclass="view.modal.FixedLevelAdder" modalwidth="310" modalheight="330"><data><level width="0" name="id" label="Id" type="label" value="" /><level width="69%" name="pool" label="<%=lbl("lblProPool")%>" type="label" value="" /><level width="29%" name="probability" label="<%=lbl("lblProbability")%>" type="text" dataType="int" value="0" /></data></attribute><attribute label="<%=lbl("lblRoleProbability")%>" name="roleprobability" type="modalArray" modalclass="view.modal.FixedLevelAdder" modalwidth="310" modalheight="330"><data><level width="0"   name="id" label="Id" type="label" value="" /><level width="69%" name="pool" label="<%=lbl("lblProRole")%>" type="label" value="" /><level width="29%" name="probability" label="<%=lbl("lblProbability")%>" type="label" value="0"/></data></attribute><attribute label="<%=lbl("lblMultiProbability")%>" name="multiplyprobability" type="modalArray" modalclass="view.modal.LevelAdder" modalwidth="310" modalheight="330"><data><level width="69%" name="multiply" label="<%=lbl("flaAttMult")%>" type="text" dataType="int" value="" /><level width="29%" name="probability" label="<%=lbl("lblMultiProbability")%>" type="text" dataType="int" value="" /></data><values><data><level width="69%" name="multiply" label="<%=lbl("flaAttMult")%>" type="text" dataType="int" value="1" /><level width="29%" name="probability" label="<%=lbl("lblMultiProbability")%>" type="text" dataType="int" value="100" /></data></values></attribute></attGroup><%}%></element>