/**
 * Parameter.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.dogma.ws.AutogenerateWSDL.creacion_de_expediente_via_ws.gen;

public class Parameter  implements java.io.Serializable {
    private java.lang.String PRMT_NRO_EXPEDIENTE_STR;

    public Parameter() {
    }

    public Parameter(
           java.lang.String PRMT_NRO_EXPEDIENTE_STR) {
           this.PRMT_NRO_EXPEDIENTE_STR = PRMT_NRO_EXPEDIENTE_STR;
    }


    /**
     * Gets the PRMT_NRO_EXPEDIENTE_STR value for this Parameter.
     * 
     * @return PRMT_NRO_EXPEDIENTE_STR
     */
    public java.lang.String getPRMT_NRO_EXPEDIENTE_STR() {
        return PRMT_NRO_EXPEDIENTE_STR;
    }


    /**
     * Sets the PRMT_NRO_EXPEDIENTE_STR value for this Parameter.
     * 
     * @param PRMT_NRO_EXPEDIENTE_STR
     */
    public void setPRMT_NRO_EXPEDIENTE_STR(java.lang.String PRMT_NRO_EXPEDIENTE_STR) {
        this.PRMT_NRO_EXPEDIENTE_STR = PRMT_NRO_EXPEDIENTE_STR;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof Parameter)) return false;
        Parameter other = (Parameter) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.PRMT_NRO_EXPEDIENTE_STR==null && other.getPRMT_NRO_EXPEDIENTE_STR()==null) || 
             (this.PRMT_NRO_EXPEDIENTE_STR!=null &&
              this.PRMT_NRO_EXPEDIENTE_STR.equals(other.getPRMT_NRO_EXPEDIENTE_STR())));
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
        if (getPRMT_NRO_EXPEDIENTE_STR() != null) {
            _hashCode += getPRMT_NRO_EXPEDIENTE_STR().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(Parameter.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "Parameter"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("PRMT_NRO_EXPEDIENTE_STR");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "PRMT_NRO_EXPEDIENTE_STR"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
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
