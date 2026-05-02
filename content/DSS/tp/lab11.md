# **Fiche**

<<<<<<< HEAD
[📄 View Fiche PDF](./lab11.pdf)
=======
[[lab11.pdf|📄 View Fiche PDF]]
>>>>>>> 77837cad2793ac2c6b78d363892a03b2f873e75a

## **Solution**

### **Exo**

#### HTML code

```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Lab 11 - REST API</title>
    <link rel="stylesheet" href="style.css">
</head>

<body>

    <header>
        <h1>Products Explorer</h1>
        <p>Please enter a product name</p>
    </header>

    <div class="controls">
        <input type="text" id="searchInput" placeholder="Search product..." />
        <button class="btn-primary" onclick="fetchCountries()">Fetch Data</button>
        <button class="btn-secondary" onclick="clearData()">Clear</button>
    </div>

    <div id="status"></div>
    <div id="grid"></div>
    <div id="count"></div>

    <script src="main.js"></script>

</body>

</html>
```

#### CSS code

```css
 * {
     box-sizing: border-box;
     margin: 0;
     padding: 0;
 }

 body {
     background: #0f172a;
     color: #e2e8f0;
     min-height: 100vh;
     padding: 30px 20px;
 }

 header {
     text-align: center;
     margin-bottom: 30px;
 }

 header h1 {
     font-size: 1.8rem;
     color: #38bdf8;
 }

 header p {
     color: #94a3b8;
     margin-top: 6px;
     font-size: 0.9rem;
 }

 .controls {
     display: flex;
     justify-content: center;
     gap: 10px;
     flex-wrap: wrap;
     margin-bottom: 24px;
 }

 input {
     padding: 10px 16px;
     border-radius: 8px;
     border: 1px solid #334155;
     background: #1e293b;
     color: #e2e8f0;
     font-size: 0.95rem;
     width: 240px;
     outline: none;
     transition: border 0.2s;
 }

 input:focus {
     border-color: #38bdf8;
 }

 button {
     padding: 10px 20px;
     border-radius: 8px;
     border: none;
     cursor: pointer;
     font-size: 0.95rem;
     font-weight: 600;
     transition: background 0.2s, transform 0.1s;
 }

 button:active {
     transform: scale(0.97);
 }

 .btn-primary {
     background: #38bdf8;
     color: #0f172a;
 }

 .btn-primary:hover {
     background: #7dd3fc;
 }

 .btn-secondary {
     background: #334155;
     color: #e2e8f0;
 }

 .btn-secondary:hover {
     background: #475569;
 }

 #status {
     text-align: center;
     min-height: 24px;
     color: #94a3b8;
     font-size: 0.85rem;
     margin-bottom: 16px;
 }

 #status.error {
     color: #f87171;
 }

 .spinner {
     display: inline-block;
     width: 16px;
     height: 16px;
     border: 2px solid #334155;
     border-top-color: #38bdf8;
     border-radius: 50%;
     animation: spin 0.7s linear infinite;
     vertical-align: middle;
     margin-right: 6px;
 }

 @keyframes spin {
     to {
         transform: rotate(360deg);
     }
 }

 #grid {
     display: grid;
     grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
     gap: 16px;
     max-width: 1100px;
     margin: 0 auto;
 }

 .card {
     background: #1e293b;
     border: 1px solid #334155;
     border-radius: 12px;
     padding: 18px;
     transition: transform 0.2s, border-color 0.2s;
     animation: fadeIn 0.3s ease;
 }

 @keyframes fadeIn {
     from {
         opacity: 0;
         transform: translateY(10px);
     }

     to {
         opacity: 1;
         transform: translateY(0);
     }
 }

 .card:hover {
     transform: translateY(-4px);
     border-color: #38bdf8;
 }

 .card-flag {
     font-size: 2.8rem;
     margin-bottom: 10px;
 }

 .card-name {
     font-size: 1rem;
     font-weight: 700;
     color: #f1f5f9;
     margin-bottom: 8px;
 }

 .card-info {
     font-size: 0.8rem;
     color: #94a3b8;
     line-height: 1.7;
 }

 .badge {
     display: inline-block;
     background: #0f172a;
     border: 1px solid #334155;
     border-radius: 999px;
     padding: 2px 10px;
     font-size: 0.72rem;
     color: #7dd3fc;
     margin-top: 8px;
 }

 #count {
     text-align: center;
     color: #64748b;
     font-size: 0.8rem;
     margin-top: 20px;
 }
```

#### JS code

```javascript
let allCards = [];

async function fetchCountries() {
    const input = document.getElementById('searchInput');
    const status = document.getElementById('status');
    const grid = document.getElementById('grid');
    const count = document.getElementById('count');

    // Reset
    grid.innerHTML = '';
    count.textContent = '';
    allCards = [];
    status.className = '';
    status.innerHTML = '<span class="spinner"></span> Fetching data from API…';

    try {
        const productName = input?.value;
        if (!productName) throw new Error('please enter a product name')
        const res = await fetch(`https://dummyjson.com/products/search?q=${productName}`)

        if (!res.ok) throw new Error(`HTTP error: ${res.status}`);

        const data = await res.json()

        const products = data.products;
        if (!products.length) throw new Error(`No product available, try search bu another name`);
        console.log(products)

        status.textContent = `${res.total} products loaded successfully.`;

        products.forEach(p => {
            const id = p.id;
            const title = p.title;
            const description = p.description;
            const price = p.price;
            const rating = p.rating;

            const card = document.createElement('div');
            card.className = 'card';
            card.innerHTML = `
          <div class="card-id">id: ${id}</div>
          <div class="card-title">title: ${title}</div>
          <div class="card-info">
            <b>description:</b>description: ${description}<br>
             <b>price:</b>${price ?? 'N/A'}<br>
          </div>
          <span class="badge">${rating ?? 'N/A'}</span>
        `;

            grid.appendChild(card);
            allCards.push(card);
        });

        count.textContent = `Showing ${allCards.length} products`;

    } catch (err) {
        status.className = 'error';
        status.textContent = `Error: ${err.message}`;
    }
}

function clearData() {
    document.getElementById('grid').innerHTML = '';
    document.getElementById('status').textContent = '';
    document.getElementById('count').textContent = '';
    document.getElementById('searchInput').value = '';
    allCards = [];
}
```
