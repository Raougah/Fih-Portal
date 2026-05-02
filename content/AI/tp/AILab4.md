# **Fiche**

[[AILab4.pdf|Voir Fiche PDF]]

## **Solution**

### **Exo KNN**

```python
import pandas as pd
from sklearn.neighbors import KNeighborsRegressor  # regression because Purchase is a number
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error, r2_score
from sklearn.preprocessing import StandardScaler
from sklearn.datasets import load_iris

# 1. load your already preprocessed
raw = load_iris()
df = pd.DataFrame(raw.data, columns=raw.feature_names)

# 2. separate features (X) from target (y)
# X = everything the model uses to predict
# y = what we want to predict
X = df.drop(columns=['Purchase'])
y = df['Purchase']

# 3. split into training and test sets
# test_size=0.2 means 80% training, 20% testing
# random_state=42 makes the split reproducible
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# 4. scale the features
# KNN uses distance, so large values like Age dominate small ones like Gender
# scaling puts everyone on the same range so distance is fair
scaler = StandardScaler()
X_train = scaler.fit_transform(X_train)  # learn scale from training data
X_test  = scaler.transform(X_test)       # apply same scale to test data

# 5. train the model with K=5
# n_neighbors=5 means it looks at the 5 closest neighbors and averages their Purchase value
model = KNeighborsRegressor(n_neighbors=5)
model.fit(X_train, y_train)  # memorize training data

# 6. predict on test set
y_pred = model.predict(X_test)

# 7. analyze accuracy
print(f"MAE : {mean_absolute_error(y_test, y_pred):.2f}")  # average error in dollars
print(f"R2  : {r2_score(y_test, y_pred):.2f}")             # 1.0 = perfect, 0 = bad

# 8. instance classification
# create one new fake customer and predict their purchase amount
new_customer = pd.DataFrame([{
    'Age': 2,           # encoded age group
    'Gender': 0,        # 0 = male
    'Occupation': 4,
    'City_Category': 1, # encoded city
    'Stay_In_Current_City_Years': 2,
    'Marital_Status': 0,
    'Product_Category_1': 5,
    'Product_Category_2': 3,
    'Product_Category_3': 1
}])

new_customer_scaled = scaler.transform(new_customer)
prediction = model.predict(new_customer_scaled)
print(f"Predicted Purchase: ${prediction[0]:.2f}")
```

### **Exo Linear regression**

```python
import torch
import matplotlib.pyplot as plt

# create dataset y = ax + b
a  = 0.3
b = 0.7

# torch.arange(start, end, step)
x = torch.arange(0,1,0.02) # return a tensor supports gradients and GPU

y = a * x + b

""" 
Real dataset:
# 1. load data
df = pd.read_csv("insurance_preprocessed.csv")

# 2. extract one feature and target, convert to tensors
x = torch.tensor(df['bmi'].values, dtype=torch.float32)
y = torch.tensor(df['charges'].values, dtype=torch.float32)

# 3. normalize x and y so gradient descent converges faster on real data
x = (x - x.mean()) / x.std()
y = (y - y.mean()) / y.std()
"""

print(f"x = {x}\ny = {y}")

# plt.scatter(x, y)
# plt.xlabel("x")
# plt.ylabel("y")
# plt.title("Linear Regression")
# plt.show()

# split to train and test
train_size = int(0.8 * len(x)) # 80% for training and 20% for testing

x_train, x_test = x[:train_size], x[train_size:]
y_train, y_test = y[:train_size], y[train_size:]

# plt.scatter(x_train, y_train, label="Train Data")
# plt.scatter(x_test, y_test, label="Test Data")
# plt.xlabel("x")
# plt.ylabel("y")
# plt.title("Linear Regression")
# plt.legend()
# plt.show()

# create model
from torch import float32, nn
class LinearRegressionModel(nn.Module):
    def __init__(self):
        super().__init__()
        self.w = nn.Parameter(torch.rand(1, requires_grad=True, dtype=torch.float32))
        self.b = nn.Parameter(torch.rand(1, requires_grad=True, dtype=torch.float32))

    def forward(self, x):
        return self.w * x + self.b # return a tensor
    
model = LinearRegressionModel()
print(f"Initial parameters: w = {model.w.item()}, b = {model.b.item()}") # item() to get the value from the tensor

# train model
model.train()
learning_rate = 0.01 # alpha
num_epochs = 1000
for epoch in range(num_epochs):
    y_pred = model(x_train) # forward pass
    print(y_pred)
    loss = torch.mean((y_pred - y_train) ** 2) # mean squared error loss, mean is 1/m (average)
    loss.backward() # backward pass to compute gradients (derivative of J(w,b))
    with torch.no_grad(): # update parameters without tracking gradients
        model.w -= learning_rate * model.w.grad
        model.b -= learning_rate * model.b.grad
    model.w.grad.zero_() # zero the gradients after updating
    model.b.grad.zero_()
    if (epoch+1) % 50 == 0: # print loss every 50 epochs
        print(f"Epoch [{epoch+1}/{num_epochs}], Loss: {loss.item():.4f}, w: {model.w.item():.4f}, b: {model.b.item():.4f}")

# test model
model.eval() # set the model to evaluation mode
with torch.no_grad(): # disable gradient calculation because we don't need it for inference (testing)
    y_pred = model(x_test) # in pytorch __call_ calls forward method automatically

plt.scatter(x_train, y_train, label="Train Data")
plt.scatter(x_test, y_test, label="Test Data")
plt.scatter(x_test, y_pred, label="Predicted Data")
plt.xlabel("x")
plt.ylabel("y")
plt.title("Linear Regression")
plt.legend() # map keys to labels
plt.show()

""" 
Built-in version
loss_fn = nn.MSELoss()
optimizer = torch.optim.SGD(model.parameters(), lr=0.01)

loss = loss_fn(y_pred, y_train)

optimizer.zero_grad()
loss.backward()
optimizer.step()
=========================
- mean((error)^2) = MSE loss
- update = gradient descent
- zeroing = optimizer.zero_grad()
"""
```
