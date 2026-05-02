import matplotlib.pyplot as plt

# some random data to use across all examples
ages    = [22, 35, 58, 18, 45, 60, 30, 25, 40, 70]
fares   = [7, 52, 263, 5, 80, 512, 15, 9, 70, 300]
names   = ['A', 'B', 'C', 'D', 'E']
scores  = [10, 25, 15, 30, 20]

# =============================================================
# figure() : creates a blank canvas before drawing anything
# figsize  : sets the width and height of the canvas in inches
# =============================================================
plt.figure(figsize=(6, 4))
plt.title("Empty Canvas Example")
plt.show()

# =============================================================
# scatter() : one dot per data point
# good for seeing the relationship between two numeric columns
# x axis = ages, y axis = fares
# =============================================================
plt.figure(figsize=(6, 4))
plt.scatter(ages, fares)
plt.title("Age vs Fare")   # text at the top
plt.xlabel("Age")          # label under x axis
plt.ylabel("Fare")         # label on the left of y axis
plt.show()

# =============================================================
# hist() - مدرج : counts how many values fall in each range
# good for seeing the distribution of one column
# bins=5 splits the range into 5 buckets
# =============================================================
plt.figure(figsize=(6, 4))
plt.hist(ages, bins=5)
plt.title("Age Distribution")
plt.xlabel("Age")
plt.ylabel("Count")        # y axis here counts how many values are in each bucket
plt.show()

# =============================================================
# boxplot() : draws the IQR box, median line, and outlier dots
# good for seeing outliers in one column
# =============================================================
plt.figure(figsize=(6, 4))
plt.boxplot(fares)
plt.title("Fare Boxplot")
plt.ylabel("Fare")
plt.show()

# =============================================================
# bar() أعمدة بيانية : vertical bars, one per category
# good for comparing counts or values across categories
# first argument = category labels (x axis)
# second argument = values (height of each bar)
# =============================================================
plt.figure(figsize=(6, 4))
plt.bar(names, scores)
plt.title("Scores per Person")
plt.xlabel("Person")
plt.ylabel("Score")
plt.show()

# =============================================================
# plot() - منحنى بيانى : draws a line connecting points in order
# good for time series or sequences where order matters
# =============================================================
plt.figure(figsize=(6, 4))
plt.plot(ages)
plt.title("Ages in Order")
plt.xlabel("Index")        # x axis here is just the row number
plt.ylabel("Age")
plt.show()

# =============================================================
# subplot() : splits one canvas into multiple plots
# subplot(rows, cols, position)
# subplot(1, 2, 1) = 1 row, 2 columns, draw in position 1 (left)
# subplot(1, 2, 2) = 1 row, 2 columns, draw in position 2 (right)
# tight_layout() prevents the two plots from overlapping
# =============================================================
plt.figure(figsize=(10, 4))

plt.subplot(1, 2, 1)       # left plot
plt.hist(ages, bins=5)
plt.title("Age Distribution")
plt.xlabel("Age")
plt.ylabel("Count")

plt.subplot(1, 2, 2)       # right plot
plt.boxplot(ages)
plt.title("Age Boxplot")
plt.ylabel("Age")

plt.tight_layout()         # fixes overlapping between the two plots
plt.show()

# =============================================================
# heatmap() from seaborn : draws a colored grid of numbers
# used for correlation matrices
# annot=True  : prints the number inside each cell
# cmap        : color scheme, coolwarm = blue for negative, red for positive
# =============================================================
import seaborn as sns

data = {
    'Age':  [22, 35, 58, 18, 45],
    'Fare': [7,  52, 263, 5, 80],
    'Pclass': [3, 2, 1, 3, 2]
}
import pandas as pd
df = pd.DataFrame(data)

corr = df.corr()           # computes correlation between every pair of columns

plt.figure(figsize=(5, 4))
sns.heatmap(corr, annot=True, cmap='coolwarm')
plt.title("Correlation Heatmap")
plt.show()