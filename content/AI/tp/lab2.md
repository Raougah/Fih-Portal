# **Fiche**

[📄 View Fiche PDF](./lab2.pdf)

## **Solution**

### **Exo 1**

```python
"""
Name: Mohammed Alaa Eddine Mekibes
Date: 12 / 02 / 2026
Code: Sheet Nr 2 (Part 1) Exercise 1

"""

import numpy as np

# ? ========== Q1 =========
print("\n========== Q1 =========\n")

lst = [2, 5, 8, 10] # Python list
arr = np.array(lst) # numpy array

print(type(lst))
print(type(arr))

# ? ========== Q2 =========
print("\n========== Q2 =========\n")

A = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]]) # matrix

# 3x3 matrix operations
A = A + 12
A = A * 5
A = A - 3

print(A)

# ? ========== Q3 =========
print("\n========== Q3 =========\n")

arr = np.arange(0, 24, 2)  # 12 even numbers
matrix = arr.reshape(4, 3)

print(matrix)

# ? ========== Q4 =========
print("\n========== Q4 =========\n")

zeros = np.zeros((4, 3)) # 4x3 matrix of zeros
ones = np.ones((4, 3)) # 4x3 matrix of ones

print(zeros)
print(ones)

# ? ========== Q5 =========
print("\n========== Q5 =========\n")
# 20 evenly spaced numbers → reshape → dimensions

arr = np.linspace(0, 100, 20)

matrix = arr.reshape(5, 4)

print(matrix)
print(matrix.shape)

# ? ========== Q6 =========
print("\n========== Q6 =========\n")
# 5x5 matrix with diagonal = 1

matrix = np.eye(5)

print(matrix)

# ? ========== Q7 =========
print("\n========== Q7 =========\n")
# Random matrices

### 5x2 random between 0 and 1

A = np.random.rand(5, 2)
print(A)

### 4x3 with mean=0 variance=1

B = np.random.randn(4, 3)
print(B)

### 12 natural random numbers between 0 and 101 → reshape

C = np.random.randint(0, 101, 12)
C = C.reshape(4, 3)

print(C)

### Repeat same random values

np.random.seed(0)

# ? ========== Q8 =========
print("\n========== Q8 =========\n")
# Max, Min and indices
arr = np.random.rand(12)

print(arr)

print("Max:", arr.max())
print("Min:", arr.min())

print("Max index:", arr.argmax())
print("Min index:", arr.argmin())

print("Type:", type(arr))

# ? ========== Q9 =========
print("\n========== Q9 =========\n")
# Array slicing

arr = np.random.randint(0, 100, 18)

print(arr)

print("Fourth element:", arr[3])

print("First seven:", arr[:7])

print("Last eight:", arr[-8:])

print("Elements 6 to 13:", arr[6:13])

arr[6:13] = 45

print(arr)

# ? ========== Q10 =========
print("\n========== Q10 =========\n")
# Matrix indexing

A = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

print("Third element first row:", A[0, 2])

print("First row:", A[0])
print("Second row:", A[1])

print("Columns 2 and 3 of rows 1 and 2:")
print(A[0:2, 1:3])

# ? ========== Q11 =========
print("\n========== Q11 =========\n")
# Boolean array

arr = np.arange(1, 13)

mask = arr > 7

print("Boolean array:", mask)

print("Values > 7:", arr[mask])

# ? ========== Q12 =========
print("\n========== Q12 =========\n")

arr = np.arange(1,13)
print(arr)

# transpose
t = arr.reshape(3,4).T
print(t)

# 1/array
inv = 1/arr
print(inv)

# math functions
print("sqrt:", np.sqrt(arr))
print("sin:", np.sin(arr))
print("log:", np.log(arr))
print("sum:", np.sum(arr))
print("mean:", np.mean(arr))
print("max:", np.max(arr))
print("min:", np.min(arr))
print("variance:", np.var(arr))
print("std:", np.std(arr))

# ? ========== Q13 =========
print("\n========== Q13 =========\n")

matrix = np.random.randint(0,101,(5,5))
print(matrix)

print("Total sum:", matrix.sum())

print("Column sums:", matrix.sum(axis=0))

print("Row sums:", matrix.sum(axis=1))

# ? ========== Q14 =========
print("\n========== Q14 =========\n")

A = np.array([
[1,2,3],
[4,5,6],
[7,8,9],
[10,11,12]
])

B = np.array([
[13,14,15],
[16,17,18],
[19,20,21],
[22,23,24]
])

# concatenate
C = np.concatenate((A,B))
print(C)

# sort
print(np.sort(C, axis=None))

# vertical stack
print(np.vstack((A,B)))

# horizontal stack
print(np.hstack((A,B)))

# ? ========== Q15 =========
print("\n========== Q15 =========\n")

# Using Iris dataset

from sklearn.datasets import load_iris # pip install scikit-learn

data = load_iris()

X = data.data

print("Mean:", np.mean(X))
print("Median:", np.median(X))
print("Variance:", np.var(X))
print("Covariance:\n", np.cov(X.T))

np.savetxt("iris_stats.txt", X)
```

### **Exo 2**

```python
"""
Name: Mohammed Alaa Eddine Mekibes
Date: 12 / 02 / 2026
Code: Sheet Nr 2 (Part 1) Exercise 1

"""

import numpy as np
import pandas as pd

# ? ========== Q1 =========
print("\n========== Q1 =========\n")

arr = np.random.randint(0,21,5)

series = pd.Series(arr)

print(arr)
print(series)

students = ["Ali","Sara","Yacine","Amel","Karim"]

series = pd.Series(arr,index=students)

print(series)

# ? ========== Q2 =========
print("\n========== Q2 =========\n")

print(series.index)
print(series.values)

print("Third student mark:", series.iloc[2])

series.iloc[2] = 16

print(series)

print(series[series > 10])

series = series * 1.5

print(series)

# ? ========== Q3 =========
print("\n========== Q3 =========\n")

city_data = {
"Oran":1500000,
"Algiers":3000000,
"Constantine":1000000,
"Annaba":600000,
"Blida":500000
}

city_series = pd.Series(city_data)

print(city_series)

city_dict = city_series.to_dict()

print(city_dict)
# ? ========== Q4 =========
print("\n========== Q4 =========\n")

cities = ["Oran","Algiers","Annaba","Paris","Tokyo"]

new_series = pd.Series(city_data,index=cities)

print(new_series)

print("Null values:")
print(new_series[new_series.isnull()])

print("Not null:")
print(new_series[new_series.notnull()])

new_series.name = "population"
new_series.index.name = "state"

print(new_series)

# ? ========== Q5 =========
print("\n========== Q5 =========\n")

print("Sum:", series.sum())
print("Max:", series.max())
print("Min:", series.min())
print("Average:", series.mean())
print("Median:", series.median())

# ? ========== Q6 =========
print("\n========== Q6 =========\n")

df = pd.DataFrame({
"Student":series.index,
"Mark":series.values
})

print(df)

# ? ========== Q7 =========
print("\n========== Q7 =========\n")

df["Code"] = ["ST1","ST2","ST3","ST4","ST5"]

print(df)

# ? ========== Q8 =========
print("\n========== Q8 =========\n")

# iloc examples
print(df.iloc[2:4,1])

print(df.iloc[1:,2])

print(df.iloc[0:2,0:2])

# loc examples
print(df.loc[0])

print(df.loc[[1,3],["Student","Code"]])

# ? ========== Q9 =========
print("\n========== Q9 =========\n")

df.head()
df.tail()
df.info()
df.describe()

print(df.shape)

df.sort_values("Mark")

df.groupby("Student").sum()
```

### **Exo 3**

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import pandas as pd

# ? ========== Qa =========
print("\n========== Qa =========\n")

# create data using arange
axis_x1 = np.arange(0, 8)        # 0 to 7
axis_y1 = np.arange(10, 18)      # 10 to 17

# plot
plt.figure()
plt.plot(axis_x1, axis_y1)

# labels and title
plt.title("Simple Line Plot")
plt.xlabel("X axis")
plt.ylabel("Y axis")

plt.show()

# ? ========== Q2 =========
print("\n========== Q2 =========\n")

# second dataset
axis_x2 = np.arange(0, 8)
axis_y2 = axis_x2 ** 2   # example relation

plt.figure()

# first line
plt.plot(axis_x1, axis_y1, color='blue', label='Linear')

# second line
plt.plot(axis_x2, axis_y2, color='red', label='Quadratic')

# labels and title
plt.title("Two Datasets")
plt.xlabel("X axis")
plt.ylabel("Y axis")

# legend
plt.legend()

plt.show()

# ? ========== Q3 =========
print("\n========== Q3 =========\n")


# sample dataset
data = {
    "age": [20, 22, 23, 21, 25, 30, 28, 27, 24, 22],
    "score": [12, 15, 14, 10, 18, 20, 17, 16, 19, 13]
}

df = pd.DataFrame(data)

# Histogram
plt.figure()

plt.hist(df["age"], bins=5, color='green', edgecolor='black')

plt.title("Age Distribution")
plt.xlabel("Age")
plt.ylabel("Frequency")

plt.show()

# Pie chart

# count categories manually
age_counts = df["age"].value_counts()

plt.figure()

plt.pie(
    age_counts,
    labels=age_counts.index,
    colors=['red', 'blue', 'green', 'orange', 'purple'],
    autopct='%1.1f%%'
)

plt.title("Age Distribution Pie")

plt.show()
```
