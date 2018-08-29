/**
 * ApiaWSInputType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.dogma.ws.AutogenerateWSDL.ursea_tramite_interno.gen;
import com.dogma.ws.AutogenerateWSDL.AbstractApiaWSInputType;

public class ApiaWSInputType extends AbstractApiaWSInputType implements java.io.Serializable {
    private java.lang.String e_BO_URL_DOCUMENTO_DATOS_STR;

    private java.lang.String e_BO_TRM_NRO_INSTANCIA_STR;

    private java.lang.String e_BO_TRM_NOMBRE_STR;

    public ApiaWSInputType() {
    }

    public ApiaWSInputType(
           java.lang.String e_BO_URL_DOCUMENTO_DATOS_STR,
           java.lang.String e_BO_TRM_NRO_INSTANCIA_STR,
           java.lang.String e_BO_TRM_NOMBRE_STR) {
           this.e_BO_URL_DOCUMENTO_DATOS_STR = e_BO_URL_DOCUMENTO_DATOS_STR;
           this.e_BO_TRM_NRO_INSTANCIA_STR = e_BO_TRM_NRO_INSTANCIA_STR;
           this.e_BO_TRM_NOMBRE_STR = e_BO_TRM_NOMBRE_STR;
    }


    /**
     * Gets the e_BO_URL_DOCUMENTO_DATOS_STR value for this ApiaWSInputType.
     * 
     * @return e_BO_URL_DOCUMENTO_DATOS_STR
     */
    public java.lang.String getE_BO_URL_DOCUMENTO_DATOS_STR() {
        return e_BO_URL_DOCUMENTO_DATOS_STR;
    }


    /**
     * Sets the e_BO_URL_DOCUMENTO_DATOS_STR value for this ApiaWSInputType.
     * 
     * @param e_BO_URL_DOCUMENTO_DATOS_STR
     */
    public void setE_BO_URL_DOCUMENTO_DATOS_STR(java.lang.String e_BO_URL_DOCUMENTO_DATOS_STR) {
        this.e_BO_URL_DOCUMENTO_DATOS_STR = e_BO_URL_DOCUMENTO_DATOS_STR;
    }


    /**
     * Gets the e_BO_TRM_NRO_INSTANCIA_STR value for this ApiaWSInputType.
     * 
     * @return e_BO_TRM_NRO_INSTANCIA_STR
     */
    public java.lang.String getE_BO_TRM_NRO_INSTANCIA_STR() {
        return e_BO_TRM_NRO_INSTANCIA_STR;
    }


    /**
     * Sets the e_BO_TRM_NRO_INSTANCIA_STR value for this ApiaWSInputType.
     * 
     * @param e_BO_TRM_NRO_INSTANCIA_STR
     */
    public void setE_BO_TRM_NRO_INSTANCIA_STR(java.lang.String e_BO_TRM_NRO_INSTANCIA_STR) {
        this.e_BO_TRM_NRO_INSTANCIA_STR = e_BO_TRM_NRO_INSTANCIA_STR;
    }


    /**
     * Gets the e_BO_TRM_NOMBRE_STR value for this ApiaWSInputType.
     * 
     * @return e_BO_TRM_NOMBRE_STR
     */
    public java.lang.String getE_BO_TRM_NOMBRE_STR() {
        return e_BO_TRM_NOMBRE_STR;
    }


    /**
     * Sets the e_BO_TRM_NOMBRE_STR value for this ApiaWSInputType.
     * 
     * @param e_BO_TRM_NOMBRE_STR
     */
    public void setE_BO_TRM_NOMBRE_STR(java.lang.String e_BO_TRM_NOMBRE_STR) {
        this.e_BO_TRM_NOMBRE_STR = e_BO_TRM_NOMBRE_STR;
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
            ((this.e_BO_URL_DOCUMENTO_DATOS_STR==null && other.getE_BO_URL_DOCUMENTO_DATOS_STR()==null) || 
             (this.e_BO_URL_DOCUMENTO_DATOS_STR!=null &&
              this.e_BO_URL_DOCUMENTO_DATOS_STR.equals(other.getE_BO_URL_DOCUMENTO_DATOS_STR()))) &&
            ((this.e_BO_TRM_NRO_INSTANCIA_STR==null && other.getE_BO_TRM_NRO_INSTANCIA_STR()==null) || 
             (this.e_BO_TRM_NRO_INSTANCIA_STR!=null &&
              this.e_BO_TRM_NRO_INSTANCIA_STR.equals(other.getE_BO_TRM_NRO_INSTANCIA_STR()))) &&
            ((this.e_BO_TRM_NOMBRE_STR==null && other.getE_BO_TRM_NOMBRE_STR()==null) || 
             (this.e_BO_TRM_NOMBRE_STR!=null &&
              this.e_BO_TRM_NOMBRE_STR.equals(other.getE_BO_TRM_NOMBRE_STR())));
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
        if (getE_BO_URL_DOCUMENTO_DATOS_STR() != null) {
            _hashCode += getE_BO_URL_DOCUMENTO_DATOS_STR().hashCode();
        }
        if (getE_BO_TRM_NRO_INSTANCIA_STR() != null) {
            _hashCode += getE_BO_TRM_NRO_INSTANCIA_STR().hashCode();
        }
        if (getE_BO_TRM_NOMBRE_STR() != null) {
            _hashCode += getE_BO_TRM_NOMBRE_STR().hashCode();
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
        elemField.setFieldName("e_BO_URL_DOCUMENTO_DATOS_STR");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "E_BO_URL_DOCUMENTO_DATOS_STR"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("e_BO_TRM_NRO_INSTANCIA_STR");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "E_BO_TRM_NRO_INSTANCIA_STR"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("e_BO_TRM_NOMBRE_STR");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "E_BO_TRM_NOMBRE_STR"));
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
