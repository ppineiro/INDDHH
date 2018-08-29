/**
 * ExecResultType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.dogma.ws.AutogenerateWSDL.creacion_de_expediente_via_ws.gen;

public class ExecResultType  implements java.io.Serializable {
    private int resultCode;

    private java.lang.String resultMessage;

    private com.dogma.ws.AutogenerateWSDL.creacion_de_expediente_via_ws.gen.Parameter parameters;

    public ExecResultType() {
    }

    public ExecResultType(
           int resultCode,
           java.lang.String resultMessage,
           com.dogma.ws.AutogenerateWSDL.creacion_de_expediente_via_ws.gen.Parameter parameters) {
           this.resultCode = resultCode;
           this.resultMessage = resultMessage;
           this.parameters = parameters;
    }


    /**
     * Gets the resultCode value for this ExecResultType.
     * 
     * @return resultCode
     */
    public int getResultCode() {
        return resultCode;
    }


    /**
     * Sets the resultCode value for this ExecResultType.
     * 
     * @param resultCode
     */
    public void setResultCode(int resultCode) {
        this.resultCode = resultCode;
    }


    /**
     * Gets the resultMessage value for this ExecResultType.
     * 
     * @return resultMessage
     */
    public java.lang.String getResultMessage() {
        return resultMessage;
    }


    /**
     * Sets the resultMessage value for this ExecResultType.
     * 
     * @param resultMessage
     */
    public void setResultMessage(java.lang.String resultMessage) {
        this.resultMessage = resultMessage;
    }


    /**
     * Gets the parameters value for this ExecResultType.
     * 
     * @return parameters
     */
    public com.dogma.ws.AutogenerateWSDL.creacion_de_expediente_via_ws.gen.Parameter getParameters() {
        return parameters;
    }


    /**
     * Sets the parameters value for this ExecResultType.
     * 
     * @param parameters
     */
    public void setParameters(com.dogma.ws.AutogenerateWSDL.creacion_de_expediente_via_ws.gen.Parameter parameters) {
        this.parameters = parameters;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ExecResultType)) return false;
        ExecResultType other = (ExecResultType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            this.resultCode == other.getResultCode() &&
            ((this.resultMessage==null && other.getResultMessage()==null) || 
             (this.resultMessage!=null &&
              this.resultMessage.equals(other.getResultMessage()))) &&
            ((this.parameters==null && other.getParameters()==null) || 
             (this.parameters!=null &&
              this.parameters.equals(other.getParameters())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        _hashCode += getResultCode();
        if (getResultMessage() != null) {
            _hashCode += getResultMessage().hashCode();
        }
        if (getParameters() != null) {
            _hashCode += getParameters().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ExecResultType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "ExecResultType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("resultCode");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "resultCode"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("resultMessage");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "resultMessage"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("parameters");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "parameters"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "Parameter"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
