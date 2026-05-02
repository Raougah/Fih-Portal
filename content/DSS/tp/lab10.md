# **Fiche**

<<<<<<< HEAD
[📄 View Fiche PDF](./lab10.pdf)
[📄 View Guide PDF](../guide/Guide_MongoDB.pdf)
=======
[[lab10.pdf|📄 View Fiche PDF]]
[[Guide_MongoDB.pdf|📄 View Guide PDF]]
>>>>>>> 77837cad2793ac2c6b78d363892a03b2f873e75a

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
