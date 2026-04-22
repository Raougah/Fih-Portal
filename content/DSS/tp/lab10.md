# **Fiche**

[📄 View Fiche PDF](./lab10.pdf)
[📄 View Guide PDF](../guide/Guide_MongoDB.pdf)

## **Solution**

### **Exo**

#### mongoDB code

```javascript
//* 1 
db.products.aggregate([
    {
        $group: {
            _id: null,
            averagePrice: { $avg: "$price" }
        }
    }
])

//* 2
db.products.aggregate([
    {
        $group: {
            _id: "category",
            totalProducts: { $sum: 1 },
            averagePrice: { $avg: "$price" }
        }
    }
])

//* 3
db.products.aggregate([
    {
        $sort: { price: -1 }
    }
])
```
