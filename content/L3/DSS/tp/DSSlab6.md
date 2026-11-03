# **Fiche**
[[DSSlab6.pdf|📄 View Fiche PDF]]
[[Guide_xpath_xslt.pdf|📄 View Guide PDF]]

## **Solution**

### **Exo**
> Solution ta3 AI !

#### xslt code

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!--
  Lab 06 - XSLT Transformation
  Stylesheet : library.xsl
  Input      : library.xml
  Output     : HTML table with conditional price coloring
-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Output method: HTML, UTF-8, with DOCTYPE -->
  <xsl:output
    method="html"
    encoding="UTF-8"
    doctype-public="-//W3C//DTD HTML 4.01//EN"
    indent="yes"/>

  <!-- ===========================================================
       ROOT TEMPLATE
       Matches the document root and builds the full HTML page
  =========================================================== -->
  <xsl:template match="/">
    <html>
      <head>
        <title>Library Catalog</title>
        <style>
          /* ---------- Page layout ---------- */
          body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            padding: 30px;
          }
          h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
          }

          /* ---------- Table base styles ---------- */
          table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
          }
          th {
            background-color: #2c3e50;
            color: #fff;
            padding: 12px 16px;
            text-align: left;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
          }
          td {
            padding: 10px 16px;
            font-size: 14px;
            border-bottom: 1px solid #e0e0e0;
          }
          tr:last-child td { border-bottom: none; }

          /* ---------- Conditional price color classes ----------
             Green  : price  3000 DA  (affordable)
             Orange : price 3001-5000 DA (moderate)
             Red    : price  5000 DA  (expensive)
          -------------------------------------------------------- */
          .affordable {
            background-color: #eafaf1;   /* light green  */
            color: #1e8449;
            font-weight: bold;
          }
          .moderate {
            background-color: #fef9e7;   /* light yellow */
            color: #d68910;
            font-weight: bold;
          }
          .expensive {
            background-color: #fdedec;   /* light red    */
            color: #c0392b;
            font-weight: bold;
          }

          /* ---------- Legend ---------- */
          .legend {
            margin-top: 18px;
            font-size: 13px;
            display: flex;
            gap: 20px;
          }
          .legend span {
            display: inline-block;
            width: 14px; height: 14px;
            border-radius: 3px;
            vertical-align: middle;
            margin-right: 5px;
          }
        </style>
      </head>
      <body>
        <h1>Library Catalog</h1>

        <table>
          <!-- Table header row -->
          <tr>
            <th>ID</th>
            <th>Title</th>
            <th>Author</th>
            <th>Year</th>
            <th>Genre</th>
            <th>Price (DA)</th>
          </tr>

          <!--
            Apply the book template to every <book> element.
            Sorted by price in ascending order.
          -->
          <xsl:apply-templates select="//book">
            <xsl:sort select="price" data-type="number" order="ascending"/>
          </xsl:apply-templates>
        </table>

        <!-- Color legend below the table -->
        <div class="legend">
          <div>
            <span style="background:#1e8449;"></span>
            Affordable (price &amp;lt;= 3000 DA)
          </div>
          <div>
            <span style="background:#d68910;"></span>
            Moderate (3001 - 5000 DA)
          </div>
          <div>
            <span style="background:#c0392b;"></span>
            Expensive (price &amp;gt; 5000 DA)
          </div>
        </div>
      </body>
    </html>
  </xsl:template>


  <!-- ===========================================================
       BOOK TEMPLATE
       Matches each <book> element and renders one <tr>
       Conditional coloring is applied to the <td> of price using
       xsl:choose (equivalent to if / else-if / else)
  =========================================================== -->
  <xsl:template match="book">
    <tr>
      <!-- Book ID from the attribute -->
      <td><xsl:value-of select="@id"/></td>
      <td><xsl:value-of select="title"/></td>
      <td><xsl:value-of select="author"/></td>
      <td><xsl:value-of select="year"/></td>
      <td><xsl:value-of select="genre"/></td>

      <!--
        Price cell with conditional CSS class:
          price <= 3000  -->  class="affordable"
          3001 to 5000   -->  class="moderate"
          price > 5000   -->  class="expensive"
      -->
      <td>
        <xsl:attribute name="class">
          <xsl:choose>
            <xsl:when test="price &lt;= 3000">affordable</xsl:when>
            <xsl:when test="price &gt; 3000 and price &lt;= 5000">moderate</xsl:when>
            <xsl:otherwise>expensive</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:value-of select="price"/> DA
      </td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
```

#### xml code

```xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="library.xsl"?>

<library>
  <book id="B001">
    <title>Clean Code</title>
    <author>Robert C. Martin</author>
    <year>2008</year>
    <price>2500</price>
    <genre>Programming</genre>
  </book>
  <book id="B002">
    <title>The Pragmatic Programmer</title>
    <author>Andrew Hunt</author>
    <year>2019</year>
    <price>3200</price>
    <genre>Programming</genre>
  </book>
  <book id="B003">
    <title>Database Systems</title>
    <author>Ramez Elmasri</author>
    <year>2021</year>
    <price>4500</price>
    <genre>Databases</genre>
  </book>
  <book id="B004">
    <title>Introduction to Algorithms</title>
    <author>Thomas H. Cormen</author>
    <year>2022</year>
    <price>5800</price>
    <genre>Algorithms</genre>
  </book>
  <book id="B005">
    <title>Artificial Intelligence: A Modern Approach</title>
    <author>Stuart Russell</author>
    <year>2020</year>
    <price>6100</price>
    <genre>AI</genre>
  </book>
  <book id="B006">
    <title>Operating System Concepts</title>
    <author>Abraham Silberschatz</author>
    <year>2023</year>
    <price>2900</price>
    <genre>Systems</genre>
  </book>
</library>
```
