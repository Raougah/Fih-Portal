# **Fiche**
[[DSSlab9.pdf|📄 View Fiche PDF]]
[[Guide_MongoDB.pdf|📄 View Guide PDF]]

## **Solution**

### **Exo**

#### mongoDB code

```javascript
//* 1
db.createCollection("products");

//*2
db.products.insertMany(
    [{
        name: "phone",
        color: "black",
        price: 3000,
        category: "Electronics"
    },
    {
        name: "pc",
        color: "black",
        price: 5000,
        category: "Electronics"
    },
    {
        name: "pen",
        color: "black",
        price: 100,
        category: "Tools"
    },
    {
        name: "mouse",
        color: "white",
        price: 800,
        category: "Electronics"
    },
    {
        name: "book",
        color: "blue",
        price: 200,
        category: "Tools"
    }]
)

//* 3
db.products.find({ price: { $gt: 1000 } })

//* 4
db.products.updateOne({ name: "mouse" }, { $set: { price: 2000 } })
```
