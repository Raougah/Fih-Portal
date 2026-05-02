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