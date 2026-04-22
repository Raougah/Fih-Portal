# **Fiche**

[📄 View Fiche PDF](./lab4.pdf)
[📄 View Guide PDF](../guide/Guide_XSD.pdf)

## **Solution**

### **Exo 1 & 2 & 3**

#### xsd code

```xsd
<?xml version="1.0" encoding="UTF-8"?>

<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">

<xs:element name="realEstateProperties">

  <xs:complexType>
    <xs:sequence>

      <xs:element name="owners">
        <xs:complexType>
          <xs:sequence>
            <xs:element name="owner" maxOccurs="unbounded">
              <xs:complexType>
                <xs:sequence>
                  <xs:element name="name" type="xs:string"/>

                  <xs:element name="email">
                    <xs:simpleType>
                      <xs:restriction base="xs:string">
                        <xs:pattern value=".+@.+\..+"/>
                      </xs:restriction>
                    </xs:simpleType>
                  </xs:element>

                  <xs:element name="phone">
                    <xs:simpleType>
                      <xs:restriction base="xs:string">
                        <xs:pattern value="0[0-9]{9}"/>
                      </xs:restriction>
                    </xs:simpleType>
                  </xs:element>

                </xs:sequence>

                <xs:attribute name="id" type="xs:ID" use="required"/>

              </xs:complexType>
            </xs:element>
          </xs:sequence>
        </xs:complexType>
      </xs:element>


      <xs:element name="property" maxOccurs="unbounded">
        <xs:complexType>
          <xs:sequence>

            <xs:element name="type">
              <xs:simpleType>
                <xs:restriction base="xs:string">
                  <xs:enumeration value="house"/>
                  <xs:enumeration value="apartment"/>
                  <xs:enumeration value="land"/>
                </xs:restriction>
              </xs:simpleType>
            </xs:element>

            <xs:element name="surface">
              <xs:simpleType>
                <xs:restriction base="xs:decimal">
                  <xs:minExclusive value="0"/>
                </xs:restriction>
              </xs:simpleType>
            </xs:element>

            <xs:element name="price" type="xs:decimal"/>

            <xs:element name="ownerRef" type="xs:IDREF"/>

          </xs:sequence>

          <xs:attribute name="id" type="xs:ID" use="required"/>

        </xs:complexType>
      </xs:element>

    </xs:sequence>
  </xs:complexType>

</xs:element>

</xs:schema>
```

#### xml code

```xml
<?xml version="1.0" encoding="UTF-8"?>

<realEstateProperties xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:noNamespaceSchemaLocation="realestate.xsd">

    <owners>
        <owner id="o1">
            <name>Ali Ahmed</name>
            <email>ali@example.com</email>
            <phone>0550123456</phone>
        </owner>

        <owner id="o2">
            <name>Sara Ben</name>
            <email>sara@example.com</email>
            <phone>0661123456</phone>
        </owner>
    </owners>

    <property id="p1">
        <type>house</type>
        <surface>120</surface>
        <price>150000</price>
        <ownerRef>o1</ownerRef>
    </property>

    <property id="p2">
        <type>apartment</type>
        <surface>85</surface>
        <price>90000</price>
        <ownerRef>o2</ownerRef>
    </property>

</realEstateProperties>
```
