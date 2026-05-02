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