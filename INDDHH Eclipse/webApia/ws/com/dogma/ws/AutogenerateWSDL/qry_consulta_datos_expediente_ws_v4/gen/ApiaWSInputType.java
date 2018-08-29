/**
 * ApiaWSInputType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.dogma.ws.AutogenerateWSDL.qry_consulta_datos_expediente_ws_v4.gen;
import com.dogma.ws.AutogenerateWSDL.AbstractApiaWSInputType;

public class ApiaWSInputType extends AbstractApiaWSInputType implements java.io.Serializable {
    private java.lang.String q_nroexpediente;

    public ApiaWSInputType() {
    }

    public ApiaWSInputType(
           java.lang.String q_nroexpediente) {
           this.q_nroexpediente = q_nroexpediente;
    }


    /**
     * Gets the q_nroexpediente value for this ApiaWSInputType.
     * 
     * @return q_nroexpediente
     */
    public java.lang.String getQ_nroexpediente() {
        return q_nroexpediente;
    }


    /**
     * Sets the q_nroexpediente value for this ApiaWSInputType.
     * 
     * @param q_nroexpediente
     */
    public void setQ_nroexpediente(java.lang.String q_nroexpediente) {
        this.q_nroexpediente = q_nroexpediente;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ApiaWSInputType)) return false;
        ApiaWSInputType other = (ApiaWSInputType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.q_nroexpediente==null && other.getQ_nroexpediente()==null) || 
             (this.q_nroexpediente!=null &&
              this.q_nroexpediente.equals(other.getQ_nroexpediente())));
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
        if (getQ_nroexpediente() != null) {
            _hashCode += getQ_nroexpediente().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ApiaWSInputType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "ApiaWSInputType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("q_nroexpediente");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "Q_nroexpediente"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
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
