Every function from the TP, one line of explanation, and the output you should see.

## PART 1: Python basics

### Jupyter

| What | Meaning |
| --- | --- |
| `pip install jupyterlab numpy pandas matplotlib seaborn scikit-learn` | install once |
| `jupyter lab` | start Jupyter (opens localhost:8888) |
| Code cell | run it, result appears below |
| Markdown cell | titles and text (`# Title`, `**bold**`) |
| `Shift+Enter` | run the cell |
| `Esc` then `A` / `B` | new cell above / below |
| `Esc` then `M` / `Y` | Markdown / code |
| `Esc` then `D D` | delete cell |
| Kernel | the Python engine that keeps your variables in memory |

### Variables and types

```python
nom = "Amine"      # str
age = 20           # int
moyenne = 14.5     # float
inscrit = True     # bool
print(type(nom), type(age))
print(f"{nom} a {age} ans, moyenne {moyenne}")
```

```
<class 'str'> <class 'int'>
Amine a 20 ans, moyenne 14.5
```

- `type(x)` gives the type.
- `f"...{x}..."` (f-string) puts variables inside text.
- Operators: `+ - * / // % **`

```python
7 // 2   # 3   (integer division)
7 % 2    # 1   (remainder)
2 ** 3   # 8   (power)
```

### Lists (ordered, modifiable, index starts at 0)

```python
notes = [12, 15, 9, 17]
print(notes[0], notes[-1])     # 12 17      first and last
print(notes[1:3])              # [15, 9]    start included, end excluded
notes.append(14)               # add at the end
print(len(notes), sum(notes)/len(notes))   # 5 13.4
```

Slicing: `liste[start:end:step]`

```python
nombres = [10, 20, 30, 40, 50]
nombres[1:3]      # [20, 30]
nombres[0:5:2]    # [10, 30, 50]   every 2nd element
notes[-3:-1]      # [15, 9]
notes[:-1]        # everything except the last
```

List methods:

```python
fruits = ["pomme", "banane"]
fruits.append("orange")     # ["pomme","banane","orange"]   add at end
fruits.insert(1, "kiwi")    # ["pomme","kiwi","banane","orange"]   add at index 1
fruits.remove("banane")     # ["pomme","kiwi","orange"]   remove first match
elem = fruits.pop(0)        # elem="pomme", fruits=["kiwi","orange"]   remove at index and return it

nums = [3, 1, 4, 2]
nums.sort()                 # [1, 2, 3, 4]   sorts in place
nums.reverse()              # [4, 3, 2, 1]   reverses in place
```

### Dictionaries (key → value)

```python
etudiant = {"nom": "Sara", "age": 21}
etudiant["filiere"] = "Maths"      # new key is added
print(etudiant["nom"])             # Sara
print(list(etudiant.keys()))       # ['nom', 'age', 'filiere']
for cle, valeur in etudiant.items():
    print(cle, "->", valeur)
```

```
nom -> Sara
age -> 21
filiere -> Maths
```

List = same kind of values (grades). Dictionary = fields of one object (name, age).

### Conditions

```python
note = 13
if note >= 16:
    print("Très bien")
elif note >= 10:
    print("Admis")
else:
    print("Ajourné")
```

```
Admis
```

- `=` assigns, `==` compares.
- Comparisons: `== != < <= > >=`. Combine: `and`, `or`, `not`.
- Only the first true branch runs. Indent with 4 spaces and do not forget the `:`.

### Loops

```python
for i in range(3):          # range(3) = 0, 1, 2
    print("tour", i)        # tour 0 / tour 1 / tour 2

somme, n = 0, 1
while n <= 4:               # repeat while condition is true
    somme += n
    n += 1
print(somme)                # 10

carres = [x ** 2 for x in range(5)]   # list comprehension
print(carres)               # [0, 1, 4, 9, 16]
```

- `for`: you know the sequence or number of turns.
- `while`: depends on a condition. Always change the variable, or the loop never ends.

### break, continue, pass

Same loop on `[12, 15, -1, 9, 17]`, only the keyword inside `if n < 0:` changes:

| Keyword | What it does | Printed |
| --- | --- | --- |
| `break` | leaves the loop completely | `12 15` |
| `continue` | skips this turn, goes to next element | `12 15 9 17` |
| `pass` | does nothing, rest of block runs | `12 15 -1 9 17` |

`pass` is also used as a placeholder for code you write later:

```python
def calculer_moyenne(valeurs):
    pass        # without pass: IndentationError
```

### Functions

```python
def moyenne(valeurs, arrondi=2):
    """Return the average of a list."""      # docstring: help(moyenne) shows it
    return round(sum(valeurs) / len(valeurs), arrondi)

print(moyenne([12, 15, 9, 17]))               # 13.25
print(moyenne([12, 15, 9, 17], arrondi=0))    # 13.0
```

- `def` creates the function (prints nothing). The call runs it.
- `return` sends the result back.
- `arrondi=2` is a default value you can override.
- `#` is a one-line comment. `""" ... """` is a docstring.

### Import and pip

```python
import math
import numpy as np
from math import sqrt
print(math.pi)            # 3.141592653589793
print(sqrt(16))           # 4.0
print(np.mean([1, 2, 3])) # 2.0
```

`ModuleNotFoundError` means not installed: run `pip install name`, then restart the kernel.

| Command | Use |
| --- | --- |
| `pip install requests` | install |
| `pip install requests==2.31.0` | exact version |
| `pip install --upgrade requests` | update |
| `pip install numpy pandas` | several at once |
| `pip install -r requirements.txt` | install a whole project list |
| `python -m pip install name` | safe way if you have several Pythons |

### Part 1 exercises (solutions)

```python
# Q2 f-string
nom, age, moyenne = "Sara", 21, 14.5
print(f"L'étudiant(e) {nom} a {age} ans et a obtenu une moyenne de {moyenne}/20.")

# Q3 list + loop
notes = [12, 8, 15, 9, 17, 10]
print(f"Moyenne : {sum(notes)/len(notes):.2f}")   # 11.83   (:.2f = 2 decimals)
print(min(notes), max(notes))                      # 8 17
compteur = 0
for note in notes:
    if note >= 10:
        compteur += 1
print(compteur)                                    # 4

# Q5 function
def mention(note):
    if note >= 16: return "Très bien"
    elif note >= 14: return "Bien"
    elif note >= 10: return "Passable"
    else: return "Ajourné"

# Q6 comprehension
print([mention(n) for n in notes])
# ['Passable', 'Ajourné', 'Bien', 'Ajourné', 'Très bien', 'Passable']
```

## PART 2: NumPy and Pandas

### NumPy: create arrays

A `ndarray` is a grid of numbers, all of the same type. Fast, no loop needed.

```python
import numpy as np
a = np.array([1, 2, 3, 4])          # from a list
b = np.arange(0, 10, 2)             # start, stop (excluded), step
d = np.linspace(0, 1, 5)            # 5 evenly spaced points, ends included
z = np.zeros((2, 3))                # 2 rows, 3 columns of zeros
m = np.arange(6).reshape(2, 3)      # reshape into 2 rows, 3 columns
print(a, b)       # [1 2 3 4] [0 2 4 6 8]
print(d)          # [0.   0.25 0.5  0.75 1.  ]
print(z)          # [[0. 0. 0.]
                  #  [0. 0. 0.]]
print(m, m.shape) # [[0 1 2]
                  #  [3 4 5]] (2, 3)
```

`shape` gives the dimensions: (rows, columns).

### NumPy: index and filter

```python
m = np.array([[10, 20, 30],
              [40, 50, 60]])
print(m[0, 1])      # 20          row 0, column 1
print(m[:, 2])      # [30 60]     all rows, column 2
print(m[1, :2])     # [40 50]     row 1, first two columns
mask = m > 25       # boolean mask
print(mask)         # [[False False  True]
                    #  [ True  True  True]]
print(m[mask])      # [30 40 50 60]   keeps only the True
```

### NumPy: operations and broadcasting

Operations apply to the whole array at once (vectorization), faster than a `for` loop.

```python
a = np.array([1, 2, 3])
print(a * 2)     # [2 4 6]
print(a + a)     # [2 4 6]
print(a ** 2)    # [1 4 9]
col = np.array([[10], [20]])
print(a + col)   # [[11 12 13]
                 #  [21 22 23]]
```

Broadcasting: NumPy stretches the smaller array to fit the bigger one. Here `col` (2×1) + `a` (3,) gives a 2×3 result.

### NumPy: aggregations and axis

```python
m = np.array([[1, 2, 3],
              [4, 5, 6]])
print(m.sum(), m.mean())   # 21 3.5        all elements
print(m.sum(axis=0))       # [5 7 9]      one result per column
print(m.sum(axis=1))       # [ 6 15]      one result per row
print(m.max(), m.argmax()) # 6 5          max value, and its position (flattened)
```

- `axis=0`: go down, the rows disappear, one value per column.
- `axis=1`: go right, the columns disappear, one value per row.

### Pandas: load a CSV

A `DataFrame` is a table with column names and a row index. Empty cell in CSV becomes `NaN`.

```python
import pandas as pd
df = pd.read_csv("etudiants.csv")
print(df.head(3))   # first 3 rows
print(df.shape)     # (10, 5)    (rows, columns)
print(df.dtypes)    # type of each column
```

```
      nom        filiere  age  note_maths  note_info
0   Amine   Informatique   20        14.5       16.0
1    Sara  Mathématiques   21        17.0       15.5
2  Yacine   Informatique   19        11.0        NaN
(10, 5)
```

Other useful ones: `df.describe()` (count, mean, std, min, max), `df.columns` (column names).

### Pandas: select

```python
df["nom"]             # one column (Series)
df[["nom", "age"]]    # several columns (DataFrame, double brackets)
df.loc[0, "nom"]      # by label       -> Amine
df.iloc[0:2, 0:2]     # by position (end excluded)
```

```
      nom        filiere
0   Amine   Informatique
1    Sara  Mathématiques
```

- `loc` = labels (names). `iloc` = positions (numbers).

### Pandas: filter and sort

```python
info = df[df["filiere"] == "Informatique"]      # keep matching rows
print(info[["nom", "note_maths"]])
#        nom  note_maths
# 0    Amine        14.5
# 2   Yacine        11.0
# 5    Nadia        15.0
# 8  Sofiane        12.0

bons = df[(df["note_maths"] >= 14) & (df["age"] <= 21)]   # two conditions
print(bons["nom"].tolist())    # ['Amine', 'Sara', 'Nadia']

top = df.sort_values("note_maths", ascending=False)       # sort high to low
print(top[["nom", "note_maths"]].head(3))
#       nom  note_maths
# 1    Sara        17.0
# 7  Meriem        16.5
# 5   Nadia        15.0
```

Use `&` (and) and `|` (or) with parentheses around each condition. Never `and` / `or` in Pandas.

### Pandas: groupby (split, apply, combine)

```python
g = df.groupby("filiere")
print(g["note_maths"].mean())          # average per filiere
stats = g.agg(effectif=("nom", "count"),
              moy_info=("note_info", "mean"))   # several summaries, your own names
print(stats)
```

```
filiere
Informatique     13.125000
Mathématiques    15.666667
Physique         10.000000

               effectif   moy_info
Informatique          4  15.500000
Mathématiques         3  14.750000
Physique              3  11.333333
```

Example by hand: Info = 14.5 and 11.0, so the mean is 12.75. Phys = NaN and 9.5, so the mean is 9.5 (NaN is ignored).

### Pandas: missing values

```python
print(df.isna().sum())          # count NaN per column
df2 = df.dropna()               # delete rows that contain NaN
print(len(df), "->", len(df2))  # 10 -> 7
moy = df["note_info"].mean()
df["note_info"] = df["note_info"].fillna(moy)   # replace NaN by the mean
print(round(moy, 2), df["note_info"].isna().sum())   # 13.75 0
```

```
nom           0
filiere       0
age           0
note_maths    1
note_info     2
```

Delete = you lose data. Replace = you add an assumption. Always justify your choice in the notebook.

### NumPy or Pandas?

|  | NumPy | Pandas |
| --- | --- | --- |
| Object | `ndarray` (any dimensions) | `DataFrame` (2D), `Series` (1D) |
| Types | one type for everything | one type per column |
| Access | by position `a[0,1]` | by position or label `loc`, `iloc` |
| Missing values | NaN for floats only | `isna`, `fillna`, `dropna` |
| Files | `np.loadtxt` | `read_csv`, `read_excel`, `to_csv` |
| Best for | pure numbers, math, images, ML inputs | named tables, cleaning, groupby |

```python
arr = np.array([[14.5, 16.0], [17.0, 14.0]])
df_s = pd.DataFrame(arr, columns=["maths", "info"], index=["Amine", "Sara"])
print(arr[0, 1], df_s.loc["Amine", "info"])   # 16.0 16.0
print(arr.mean(axis=0))   # [15.75 15.  ]   no names
print(df_s.mean())        # maths 15.75 / info 15.00   named

mix = np.array([["Amine", 20, 14.5]])
print(mix.dtype)          # <U32   everything became text!

df.to_numpy()                          # Pandas -> NumPy
pd.DataFrame(arr, columns=cols)        # NumPy -> Pandas
```

Rule: prepare data with Pandas, compute with NumPy.

### Part 2 exercises (key lines)

```python
a = np.arange(1, 13).reshape(3, 4)
a[:, 1]                 # 2nd column
a[-1]                   # last row
a[a > 6]                # values greater than 6
a.sum(axis=0); a.sum(axis=1)
((a - a.mean()) / a.std()).mean()    # about 0 (centered and scaled)

df = pd.read_csv("etudiants.csv")
df.shape; df.dtypes; df.head(); df.describe()
df[df["filiere"] == "Physique"].sort_values("note_maths", ascending=False)[["nom", "note_maths"]]
df["moyenne"] = (df["note_maths"] + df["note_info"]) / 2
df.groupby("filiere")["moyenne"].mean()
df.isna().sum()
df = df.fillna(df.mean(numeric_only=True))
```

## PART 3: Visualization and first ML model

### Matplotlib (always `import matplotlib.pyplot as plt`)

```python
# Curve
x = np.linspace(0, 10, 50)
plt.plot(x, np.sin(x), label="sin(x)")   # line
plt.title("Courbe"); plt.xlabel("x"); plt.ylabel("y"); plt.legend()
plt.show()

# Histogram: how values are distributed
rng = np.random.default_rng(0)       # random generator, seed 0 = same numbers every run
notes = rng.normal(12, 3, 200)       # 200 values, mean 12, std 3 (bell curve)
plt.hist(notes, bins=12)             # bins = number of bars
plt.show()

# Scatter: relation between 2 variables
plt.scatter(df["note_maths"], df["note_info"])
plt.xlabel("note_maths"); plt.show()
```

Result: a sine wave, a bell-shaped histogram centered near 12, and points going up (higher maths grade means higher info grade).

Exercise Q1 (two curves, one figure):

```python
x = np.linspace(-3, 3, 100)
plt.plot(x, x**2, label="x²"); plt.plot(x, x**3, label="x³")
plt.title("x² et x³"); plt.xlabel("x"); plt.ylabel("y"); plt.legend(); plt.show()
```

### Seaborn (on top of Matplotlib, works directly with DataFrames)

```python
import seaborn as sns
from sklearn.datasets import load_iris
iris = load_iris(as_frame=True)
X = iris.data
X.columns = ["sep_l", "sep_w", "pet_l", "pet_w"]
d = X.assign(espece=iris.target_names[iris.target])   # add a column with species names
sns.scatterplot(data=d, x="pet_l", y="pet_w", hue="espece")
```

- `data=` is the DataFrame, `x=` and `y=` are column names.
- `hue=` colors points by a column.
- Result: 3 colored clusters. Setosa is far from the other two.

### Correlation matrix

```python
sns.heatmap(X.corr(), annot=True, cmap="coolwarm")
plt.show()
```

- Correlation goes from -1 (opposite) to +1 (same direction), 0 means no linear link.
- `X.corr()` computes the matrix. `annot=True` writes the numbers in the cells. `cmap="coolwarm"` is blue for negative and red for positive.
- Diagonal = 1.00 (a variable with itself).
- `pet_l` and `pet_w`: 0.96, very correlated.
- `sep_w` and `pet_l`: -0.43, moderate negative.
- Correlation is not causation.

### Iris dataset

150 flowers, 3 species, 4 measurements. The "Hello World" of ML.

```python
iris = load_iris(as_frame=True)
X = iris.data.set_axis(["sep_l", "sep_w", "pet_l", "pet_w"], axis=1)   # features (inputs)
y = iris.target                                                       # target (what we predict)
print(X.shape, y.shape)               # (150, 4) (150,)
print(X.head(3))
print(iris.target_names.tolist())     # ['setosa', 'versicolor', 'virginica']
print(y.value_counts().to_dict())     # {0: 50, 1: 50, 2: 50}   balanced classes
```

```
   sep_l  sep_w  pet_l  pet_w
0    5.1    3.5    1.4    0.2
1    4.9    3.0    1.4    0.2
2    4.7    3.2    1.3    0.2
```

- `X` = features = inputs. `y` = target = species coded 0, 1, 2.

### Train / test split

Train on one part, evaluate on data the model has never seen.

```python
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y)
print(X_train.shape, X_test.shape)    # (120, 4) (30, 4)
```

- `test_size=0.2`: 20% for test, 80% for train.
- `random_state=42`: same split every run.
- `stratify=y`: same proportion of each species in train and test.

### First model: KNN (k nearest neighbors)

Predicts a flower's species by looking at its k closest flowers in the training set.

```python
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score

model = KNeighborsClassifier(n_neighbors=3)   # k = 3
model.fit(X_train, y_train)                   # learn on train
pred = model.predict(X_test)                  # predict on test
print(accuracy_score(y_test, pred))           # 1.0   share of correct predictions
print(pred[:6], y_test.values[:6])            # [0 2 1 1 0 1] [0 2 1 1 0 1]
```

Accuracy 1.0 on only 30 flowers does not prove the model is perfect. Iris is small and easy, and another split can give a slightly different score.

Exercise Q6 (compare k):

```python
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=0)
for k in [1, 3, 5, 7]:
    m = KNeighborsClassifier(n_neighbors=k).fit(X_train, y_train)
    print(k, accuracy_score(y_test, m.predict(X_test)))
```

## Common errors

| Error | Cause | Fix |
| --- | --- | --- |
| `IndentationError` | block not indented after `if`, `for`, `def` | 4 spaces, always the same |
| `NameError` | variable or import never run | run the cell, or Kernel > Restart & Run All |
| `FileNotFoundError` | CSV not found | put it next to the notebook, check `os.getcwd()` |
| `KeyError` | wrong column name | compare with `df.columns` (case, accents) |
| `ValueError` (shape) | arrays with incompatible shapes | print `.shape`, use `reshape` |
| weird result with `and` / `or` | wrong operator in Pandas | use `&` and `\|` with parentheses |

Tip: read the last line of an error message first, it usually names the cause.
