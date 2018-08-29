	<element name="startevent"><attGroup name=""<%=(!bpmnAtts?" notShown=\"true\"":"")%>><attribute name="documentation" label="<%=lbl("lblbtnDocumentation")%>" type="modalArray" modalclass="view.modal.Condition" modalwidth="530" modalheight="330" use="optional" dataType="string" /><attribute label="<%=lbl("lblName")%>" name="name" type="text" change="setName" use="required" dataType="string"/><attribute name="eventtype" label="EventType" type="label" value="Start" hidden="true" /><attribute name="eventdetailtype" label="<%=lbl("flaTip")%>" type="combo" change="typeChange,setFirstTaskType" value="None"><values><value label="None" value="None" disable="message,timer,conditional,signal,multiple,trigger" /><value label="Message" value="Message" enable="trigger,message" disable="timer,conditional,signal,multiple"/><value label="Timer" value="Timer" enable="trigger,timer" disable="message,conditional,signal,multiple"/><value label="Signal" value="Signal" enable="signal" disable="message,timer,conditional,multiple"/></values></attribute><attribute label="Message" name="message" disabled="true"><attributes><attribute name="wsname" label="<%=lbl("lblTipClaWS")%>" type="text"/><attribute name="processattributes" label="<%=lbl("lblwsBusProAtt")%>" modalwidth="650" modalheight="330" type="modalArray" modalclass="view.modal.ObjectAdder" modalUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?type=attributes&<%=tabId%>" oneCheckedInRow="true"><data><level width="0" name="id" label="id" type="text" hidden="true" /><level width="76%" name="name" label="<%=lbl("lblName")%>" type="label" /><level width="10%" name="uk" label="UK" type="checkbox" /><level width="14%" name="multivalued" label="Multi" type="checkbox" /></data></attribute><attribute name="entityattributes" label="<%=lbl("lblwsBusEntAtt")%>" modalwidth="650" modalheight="330" type="modalArray" modalclass="view.modal.ObjectAdder" modalUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?type=attributes&<%=tabId%>" oneCheckedInRow="true"><data><level width="0" name="id" label="id" type="text" hidden="true" /><level width="76%" name="name" label="<%=lbl("lblName")%>" type="label" /><level width="10%" name="uk" label="UK" type="checkbox" /><level width="14%" name="multivalued" label="Multi" type="checkbox" /></data></attribute><attribute label="Implementation" name="implementation" type="label" value="WebService" hidden="true" /></attributes></attribute><attribute name="timer" label="Timer" disabled="true"><attributes><attribute label="<%=lbl("lblDate")%>" name="timedate"><attributes><attribute label="<%=lbl("lblFchIni")%>" name="initdate" type="text" use="optional" dataType="mask" mask="nnnn'/'nn'/'nn' 'nn':'nn':'nn" /><attribute label="<%=lbl("txtAnaDateTo")%>" name="enddate" type="text" use="optional" dataType="mask" mask="nnnn'/'nn'/'nn' 'nn':'nn':'nn" /></attributes></attribute><attribute label="<%=lbl("lblTimeCycle")%>" name="timecycle"><attributes><attribute label="<%=lbl("lblUnits")%>" name="unit" type="combo" value="Minutes"><values><!--value label="<%=lbl("lblTimeMilSec")%>" value="Milliseconds"/><value label="<%=lbl("lblTimeSec")%>" value="Seconds"/--><value label="<%=lbl("lblTimeMin")%>" value="Minutes"/><value label="<%=lbl("lblTimeHor")%>" value="Hours"/><value label="<%=lbl("lblTimeDay")%>" value="Days"/><value label="<%=lbl("lblTimeWeek")%>" value="Weeks"/></values></attribute><attribute label="<%=lbl("flaVal")%>" name="value" type="text" use="optional" dataType="int" /></attributes></attribute><attribute label="<%=lbl("flaAtt")%>" name="timeattribute"><attributes><attribute label="<%=lbl("flaAtt")%>" name="timerattribute" type="modal" modalclass="view.modal.AttributeFinder" modalwidth="420" modalheight="300" modalUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?type=attributes&attType=N-D&<%=tabId%>"><values><value><level name="id" type="label" value="" /><level name="name" type="label" value="" /></value></values></attribute><attribute label="<%=lbl("flaTip")%>" name="timerattributetype" type="combo" value="P"><values><value label="<%=lbl("lbl_process")%>" value="P"/><value label="<%=lbl("lbl_entity")%>" value="E"/></values></attribute></attributes></attribute></attributes></attribute><attribute label="Multiple" name="multiple" disabled="true"><attributes><attribute label="Message" name="message"><attributes><attribute name="wsname" label="<%=lbl("lblTipClaWS")%>" type="text" /><attribute name="processattributes" label="<%=lbl("lblwsBusProAtt")%>" modalwidth="600" modalheight="330" type="modalArray" modalclass="view.modal.ObjectAdder" modalUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?type=attributes&<%=tabId%>" oneCheckedInRow="true"><data><level width="0" name="id" label="id" type="text" hidden="true" /><level width="76%" name="name" label="<%=lbl("lblName")%>" type="label" /><level width="10%" name="uk" label="UK" type="checkbox" /><level width="14%" name="multivalued" label="Multi" type="checkbox" /></data></attribute><attribute name="entityattributes" label="<%=lbl("lblwsBusEntAtt")%>" modalwidth="600" modalheight="330" type="modalArray" modalclass="view.modal.ObjectAdder" modalUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?type=attributes&<%=tabId%>" oneCheckedInRow="true"><data><level width="0" name="id" label="id" type="text" hidden="true" /><level width="76%" name="name" label="<%=lbl("lblName")%>" type="label" /><level width="10%" name="uk" label="UK" type="checkbox" /><level width="14%" name="multivalued" label="Multi" type="checkbox" /></data></attribute></attributes></attribute><attribute name="timer" label="Timer" type="modalArray" modalclass="view.modal.LevelAdder" modalwidth="310" modalheight="330" single="true"><data><level width="40%" label="TimeDate" name="timedate" type="modalArray" modalclass="view.modal.ComplexElementModal" modalwidth="310" modalheight="330" modalUrl="subProcess.xml"><data><level width="50%" name="value" label="<%=lbl("flaVal")%>"></level></data><values><value label="Init Date" name="initdate" type="text" use="optional" dataType="mask" mask="nnnn'/'nn'/'nn' 'nn':'nn':'nn" /><value label="End Date" name="enddate" type="text" use="optional" dataType="mask" mask="nnnn'/'nn'/'nn' 'nn':'nn':'nn" /></values></level><level width="30%" label="TimeCycle" name="timecycle" type="modalArray" modalclass="view.modal.ComplexElementModal" modalwidth="310" modalheight="330" modalUrl="subProcess.xml"><data><level width="50%" name="value" label="<%=lbl("flaVal")%>"></level></data><values><value label="Time Measurement Unit" name="unit" type="combo" value="Milliseconds"><values><value label="Milliseconds" value="Milliseconds"/><value label="Seconds" value="Seconds"/><value label="Minutes" value="Minutes"/><value label="Hours" value="Hours"/><value label="Days" value="Days"/><value label="Weeks" value="Weeks"/></values></value><value label="<%=lbl("flaVal")%>" name="value" type="text" use="optional" dataType="int" /></values></level><level width="30%" label="TimeAttribute" name="timeattribute"><attributes><attribute label="Timer Attribute" name="timerattribute" type="modal" modalclass="view.modal.AttributeFinder" modalwidth="320" modalheight="280" modalUrl="<%=Parameters.ROOT_PATH%>/apia.design.BPMNProcessAction.run?type=attributes&attType=N-D&<%=tabId%>"><values><value><level name="id" type="label" value="" /><level name="name" type="label" value="" /></value></values></attribute><attribute label="Attribute Type" name="timerattributetype" type="combo" value="P"><values><value label="Process" value="P"/><value label="Entity" value="E"/></values></attribute></attributes></level></data></attribute></attributes></attribute></attGroup><attGroup name="User Defined Attributes" id="userproperties"<%=(!userAtts?" notShown=\"true\"":"")%>><attribute label="User Attributes" name="userattributes" modalwidth="310" modalheight="330" type="modalArray" modalclass="view.modal.LevelAdder"><data><level width="30%" label="<%=lbl("lblName")%>" name="name" type="text" /><level width="30%" label="<%=lbl("flaProBndTyp")%>" name="type" type="combo" value="String"><values><value label="String" value="String" /><value label="Numeric" value="Numeric" /><value label="Boolean" value="Boolean" /></values></level><level width="30%" label="<%=lbl("flaVal")%>" name="value" type="text" /></data></attribute></attGroup></element>