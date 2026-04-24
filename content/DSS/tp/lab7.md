# **Fiche**

[[lab7.pdf|📄 View Fiche PDF]]
[[Guide_JSON.pdf|📄 View Guide PDF]]

## **Solution**

### **Exo**

#### xml code

```xml
<?xml version="1.0" encoding="UTF-8"?>
<library>
    <book>
        <id>1</id>
        <title>The Great Gatsby</title>
        <author>F. Scott Fitzgerald</author>
        <year>1925</year>
        <genre>Fiction</genre>
    </book>
    <book>
        <id>2</id>
        <title>Clean Code</title>
        <author>Robert C. Martin</author>
        <year>2008</year>
        <genre>Technology</genre>
    </book>
</library>
```

#### json code

```json
{
    "library": {
        "book": [
            {
                "id": "1",
                "title": "The Great Gatsby",
                "author": "F. Scott Fitzgerald",
                "year": "1925",
                "genre": "Fiction",
                "available": true,
                "keywords": ["key1", "key2"]
            },
            {
                "id": "2",
                "title": "Clean Code",
                "author": "Robert C. Martin",
                "year": "2008",
                "genre": "Technology",
                "available": true,
                "keywords": ["key1", "key2"]
            }
        ]
    }
}
```
