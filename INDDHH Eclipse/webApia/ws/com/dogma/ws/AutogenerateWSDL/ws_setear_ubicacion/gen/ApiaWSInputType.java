/**
 * ApiaWSInputType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.dogma.ws.AutogenerateWSDL.ws_setear_ubicacion.gen;
import com.dogma.ws.AutogenerateWSDL.AbstractApiaWSInputType;

public class ApiaWSInputType extends AbstractApiaWSInputType implements java.io.Serializable {
    private java.lang.String b_nroTramite;

    private java.lang.String b_valor;

    public ApiaWSInputType() {
    }

    public ApiaWSInputType(
           java.lang.String b_nroTramite,
           java.lang.String b_valor) {
           this.b_nroTramite = b_nroTramite;
           this.b_valor = b_valor;
    }


    /**
     * Gets the b_nroTramite value for this ApiaWSInputType.
     * 
     * @return b_nroTramite
     */
    public java.lang.String getB_nroTramite() {
        return b_nroTramite;
    }


    /**
     * Sets the b_nroTramite value for this ApiaWSInputType.
     * 
     * @param b_nroTramite
     */
    public void setB_nroTramite(java.lang.String b_nroTramite) {
        this.b_nroTramite = b_nroTramite;
    }


    /**
     * Gets the b_valor value for this ApiaWSInputType.
     * 
     * @return b_valor
     */
    public java.lang.String getB_valor() {
        return b_valor;
    }


    /**
     * Sets the b_valor value for this ApiaWSInputType.
     * 
     * @param b_valor
     */
    public void setB_valor(java.lang.String b_valor) {
        this.b_valor = b_valor;
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
            ((this.b_nroTramite==null && other.getB_nroTramite()==null) || 
             (this.b_nroTramite!=null &&
              this.b_nroTramite.equals(other.getB_nroTramite()))) &&
            ((this.b_valor==null && other.getB_valor()==null) || 
             (this.b_valor!=null &&
              this.b_valor.equals(other.getB_valor())));
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
        if (getB_nroTramite() != null) {
            _hashCode += getB_nroTramite().hashCode();
        }
        if (getB_valor() != null) {
            _hashCode += getB_valor().hashCode();
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
        elemField.setFieldName("b_nroTramite");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "B_nroTramite"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("b_valor");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "B_valor"));
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
