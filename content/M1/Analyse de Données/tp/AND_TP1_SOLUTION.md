## Formules mohimin
### Moyenne Formule
$$
\bar{X} = \frac{1}{n}\sum_{i=1}^{n} X_i
$$

$$
\bar{Y} = \frac{1}{n}\sum_{i=1}^{n} Y_i
$$
### Variance Formule
$$
S_X^2 = \frac{1}{n-1}\sum_{i=1}^{n}(X_i-\bar{X})^2
$$

$$
S_Y^2 = \frac{1}{n-1}\sum_{i=1}^{n}(Y_i-\bar{Y})^2
$$
### Covariance Formule
$$
\operatorname{Cov}(X,Y) = \frac{1}{n-1}\sum_{i=1}^{n}(X_i-\bar{X})(Y_i-\bar{Y})
$$
### Correlation de Pearson Formule
 $$
r = \frac{\operatorname{Cov}(X,Y)}{S_X S_Y}
$$

$$
r =
\frac{\sum_{i=1}^{n}(X_i-\bar{X})(Y_i-\bar{Y})}
{\sqrt{\sum_{i=1}^{n}(X_i-\bar{X})^2}\sqrt{\sum_{i=1}^{n}(Y_i-\bar{Y})^2}}
$$
### Distance Eucledienne
$$
d_{\mathrm{Eucl}}(A,B) = \sqrt{(x_A-x_B)^2+(y_A-y_B)^2}
$$
### Distance de Manhattan
$$
d_{\mathrm{Manh}}(A,B) = |x_A-x_B|+|y_A-y_B|
$$

## Python script m3a execution
```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy.spatial.distance import pdist, squareform

df = pd.DataFrame({
    "Etudiant": ["E1", "E2", "E3", "E4", "E5"],
    "X": [5, 10, 2, 12, 6],
    "Y": [10, 15, 8, 18, 12]
})

df = df.set_index("Etudiant")
df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>X</th>
      <th>Y</th>
    </tr>
    <tr>
      <th>Etudiant</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>E1</th>
      <td>5</td>
      <td>10</td>
    </tr>
    <tr>
      <th>E2</th>
      <td>10</td>
      <td>15</td>
    </tr>
    <tr>
      <th>E3</th>
      <td>2</td>
      <td>8</td>
    </tr>
    <tr>
      <th>E4</th>
      <td>12</td>
      <td>18</td>
    </tr>
    <tr>
      <th>E5</th>
      <td>6</td>
      <td>12</td>
    </tr>
  </tbody>
</table>
</div>




```python
variance_X = df["X"].var(ddof=1)
variance_Y = df["Y"].var(ddof=1)
covariance = df["X"].cov(df["Y"])
correlation = df["X"].corr(df["Y"])

print("Variance of X:", variance_X)
print("Variance of Y:", variance_Y)
print("Covariance:", covariance)
print("Pearson correlation:", correlation)
```

    Variance of X: 16.0
    Variance of Y: 15.799999999999999
    Covariance: 15.75
    Pearson correlation: 0.9905856294336731



```python
x = df["X"]
y = df["Y"]

a, b = np.polyfit(x, y, 1)

x_line = np.linspace(x.min(), x.max(), 100)
y_line = a * x_line + b

plt.scatter(x, y, label="Students")
plt.plot(x_line, y_line, color="red", label="Trend line")

for student in df.index:
    plt.annotate(
        student,
        (df.loc[student, "X"], df.loc[student, "Y"])
    )

plt.xlabel("Study hours per week")
plt.ylabel("Exam score (/20)")
plt.title("Study Hours vs Exam Scores")
plt.legend()
plt.grid(True)
plt.show()
```


    
![[content/M1/Analyse de Données/tp/AND_TP1_GRAPH.png]]
    



```python
euclidean_matrix = squareform(
    pdist(df[["X", "Y"]], metric="euclidean")
)

euclidean_df = pd.DataFrame(
    euclidean_matrix,
    index=df.index,
    columns=df.index
)

euclidean_df.round(3)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>Etudiant</th>
      <th>E1</th>
      <th>E2</th>
      <th>E3</th>
      <th>E4</th>
      <th>E5</th>
    </tr>
    <tr>
      <th>Etudiant</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>E1</th>
      <td>0.000</td>
      <td>7.071</td>
      <td>3.606</td>
      <td>10.630</td>
      <td>2.236</td>
    </tr>
    <tr>
      <th>E2</th>
      <td>7.071</td>
      <td>0.000</td>
      <td>10.630</td>
      <td>3.606</td>
      <td>5.000</td>
    </tr>
    <tr>
      <th>E3</th>
      <td>3.606</td>
      <td>10.630</td>
      <td>0.000</td>
      <td>14.142</td>
      <td>5.657</td>
    </tr>
    <tr>
      <th>E4</th>
      <td>10.630</td>
      <td>3.606</td>
      <td>14.142</td>
      <td>0.000</td>
      <td>8.485</td>
    </tr>
    <tr>
      <th>E5</th>
      <td>2.236</td>
      <td>5.000</td>
      <td>5.657</td>
      <td>8.485</td>
      <td>0.000</td>
    </tr>
  </tbody>
</table>
</div>




```python
manhattan_matrix = squareform(
    pdist(df[["X", "Y"]], metric="cityblock")
)

manhattan_df = pd.DataFrame(
    manhattan_matrix,
    index=df.index,
    columns=df.index
)

manhattan_df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>Etudiant</th>
      <th>E1</th>
      <th>E2</th>
      <th>E3</th>
      <th>E4</th>
      <th>E5</th>
    </tr>
    <tr>
      <th>Etudiant</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>E1</th>
      <td>0.0</td>
      <td>10.0</td>
      <td>5.0</td>
      <td>15.0</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>E2</th>
      <td>10.0</td>
      <td>0.0</td>
      <td>15.0</td>
      <td>5.0</td>
      <td>7.0</td>
    </tr>
    <tr>
      <th>E3</th>
      <td>5.0</td>
      <td>15.0</td>
      <td>0.0</td>
      <td>20.0</td>
      <td>8.0</td>
    </tr>
    <tr>
      <th>E4</th>
      <td>15.0</td>
      <td>5.0</td>
      <td>20.0</td>
      <td>0.0</td>
      <td>12.0</td>
    </tr>
    <tr>
      <th>E5</th>
      <td>3.0</td>
      <td>7.0</td>
      <td>8.0</td>
      <td>12.0</td>
      <td>0.0</td>
    </tr>
  </tbody>
</table>
</div>

