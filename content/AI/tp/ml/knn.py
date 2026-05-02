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