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