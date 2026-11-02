# **Fiche**


[[DSSlab5.pdf|📄 View Fiche PDF]]
[[Guide_xpath_xslt.pdf|📄 View Guide PDF]]

## **Solution**

> Solution ta3 AI !

### **Exo**

#### xpath code

```xpath
# Q1
//book[year > 2020]

# Q2
count(//book)

# Q3
//book[price > 3000]/title
```

#### xml code

```xsd
<?xml version="1.0" encoding="UTF-8"?>

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

