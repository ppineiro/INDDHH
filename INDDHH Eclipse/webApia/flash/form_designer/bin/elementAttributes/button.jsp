<element name="button"><attGroup name=""><attribute name="bussinessclasses" label="<%=LabelManager.getName(labelSet,"flaEve")%>" type="modalArray" modalclass="view.modal.ComboAdder" modalwidth="500" modalheight="250" evtXml="<%=Parameters.ROOT_PATH%>/flash/form_designer/bin/events.jsp?type=<%=IFldType.TYPE_BUTTON%>&tabId=<%=tab%>" clsXml="<%=Parameters.ROOT_PATH%>/flash/form_designer/bin/classes.jsp?tabId=<%=tab%>"><data><level width="20%" name="evtname" label="<%=LabelManager.getName(labelSet,"lblEvent")%>" type="label" /><level width="1" name="evtid" label="Evtid" type="label" /><level width="52%" name="clsname" label="<%=LabelManager.getName(labelSet,"flaNom")%>" type="label" /><level width="1" name="clsid" label="Clsid" type="label" /><level width="1" name="bndid" label="Bndid" type="label" /><level width="1" name="order" label="Order" type="label" /><level width="14%" name="binding" label="<%=LabelManager.getName(labelSet,"flaProBnd")%>" type="modalArray" modalclass="view.modal.EntityBinding" modalwidth="600" modalheight="320" modalUrl="<%=Parameters.ROOT_PATH%>/flash/form_designer/bin/bindings.jsp?tabId=<%=tab%>" attributesUrl="<%=Parameters.ROOT_PATH%>/flash/form_designer/bin/attributes.jsp?tabId=<%=tab%>"><data><level width="1" name="id" label="Id" type="text" hidden="true" /><level width="30%" name="param" label="<%=LabelManager.getName(labelSet,"flaProPar")%>" type="label" /><level width="7%" name="type" label="<%=LabelManager.getName(labelSet,"flaPropType")%>" type="label" /><level width="20%" name="value" label="<%=LabelManager.getName(labelSet,"flaProBndVal")%>" type="label" /><level width="25%" name="attribute" label="<%=LabelManager.getName(labelSet,"flaBinAttAtt")%>" type="label" atttype="event" /><level width="1" name="attributeid" label="AttributeId" type="label" /><level width="16%" name="inout" label="<%=LabelManager.getName(labelSet,"lblInOut")%>" type="label" /></data></level><level width="12%" name="condition" label="Cond." modaltitle="Condition" type="modalArray" modalclass="view.modal.Condition" modalwidth="310" modalheight="290"><data>REGLAS DE SINTAXIS: 
String: 'string' | Number: number | Date: [date] | Null: null 
Entity Att.: ent_att('attr_name') | Process Att.: pro_att('attr_name') 
Arith. Operator: +, -, /,* 
Comp. Operator : &gt;, &lt;, &gt;=, &lt;=, =, !=, &lt;&gt; 
Boolean Operator: and, or | Unary Operator: not(expression)</data></level></data></attribute><attribute prpId="2" name="prpReadOnly" prpType="S" label="<%=LabelManager.getName(labelSet,"prpReadOnly")%>" type="checkbox" value="false"/><!--attribute prpId="4" name="prpDisabled" prpType="S" label="<%=LabelManager.getName(labelSet,"prpDisabled")%>" type="checkbox" value="false"/--><attribute prpId="5" name="prpFontColor" prpType="S" label="<%=LabelManager.getName(labelSet,"prpFontColor")%>" type="colorPicker" datatype="String" value=""/><attribute prpId="6" name="prpValue" prpType="S" label="<%=LabelManager.getName(labelSet,"prpValue")%>" type="text" datatype="String" value=""/><attribute prpId="19" name="prpName" prpType="S" label="<%=LabelManager.getName(labelSet,"prpName")%>" type="text" datatype="String" value=""/><attribute prpId="31" name="prpVisibilityHidden" prpType="S" label="<%=LabelManager.getName(labelSet,"prpVisibilityHidden")%>" type="checkbox" value="false"/><attribute prpId="65" name="prpGridLabel" prpType="S" label="<%=LabelManager.getName(labelSet,"prpGridLabel")%>" type="text" datatype="String" value=""/><attribute prpId="35" name="prpToolTip" prpType="S" label="<%=LabelManager.getName(labelSet,"prpToolTip")%>" type="text" datatype="String" value=""/><attribute prpId="40" name="prpNoPrint" prpType="S" label="<%=LabelManager.getName(labelSet,"prpNoPrint")%>" type="checkbox" value="false"/></attGroup></element>