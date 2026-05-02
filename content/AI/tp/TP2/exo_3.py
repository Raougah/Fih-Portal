"""
Name: Mohammed Alaa Eddine Mekibes
Date: 12 / 02 / 2026
Code: Sheet Nr 2 (Part 1) Exercise 3

"""

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