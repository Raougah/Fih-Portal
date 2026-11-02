# EXO1

```python
import matplotlib.pyplot as plt
from collections import Counter
from time import time  #قيمة الوقت الحالي
from math import floor #تحويل رقم حقيقي إلى عدد صحيح بتقريب إلى أسفل

# Display histogram of different types of data: floats (continuous), ints or string (discrete).
# عرض الهيستوغرام لأنواع مختلفة من البيانات: أعداد عشرية (بيانات مستمرة)، أعداد صحيحة أو سلاسل نصية (بيانات متقطعة).
# data: list of data values  قائمة بقيم البيانات
# title: title to display with the histogram  عنوان لعرضه مع الهيستوغرام
# bins: number of bars to draw or intervals  عدد الأعمدة لرسمها أو الفواصل
# proba: False -> display frequencies عرض عدد التكرارات, True -> display probabilities عرض الاحتمالات
def histogram(data, title="Histogram", bins=None, proba=False):
    if all(isinstance(val, float) for val in data): #أعداد عشرية
        if bins is None: bins=10
        plt.hist(data, bins=bins, alpha=0.7, edgecolor="black", density=proba)
    elif all(isinstance(val, int) for val in data): #أعداد صحيحة
        if bins is None: bins=range(min(data), max(data) + 2)
        plt.hist(data, bins=bins, alpha=0.7, edgecolor="black", rwidth=0.6, align="left", density=proba)
    else: #سلاسل نصية
        data = [str(val) for val in data]
        value_counts = dict(sorted(Counter(data).items()))
        unique_values = list(value_counts.keys())
        frequencies = list(value_counts.values())
        if proba:
            total_freq = sum(frequencies)
            frequencies = [freq/total_freq for freq in frequencies]
        plt.bar(unique_values, frequencies, alpha=0.7, edgecolor='black', width=0.6)
        plt.xticks(rotation=45)

    plt.title(title)
    plt.xlabel("Values")
    plt.ylabel("Probability" if proba else "Frequency")
    plt.grid(axis='y', linestyle='--', alpha=0.7)
    plt.show()

```


```python
def lcg(seed, n, m, a, c):
    """
    Générateur LCG
    seed : X0, la graine initiale
    n : nombre de valeurs à générer
    m, a, c : paramètres du LCG

    retourne : (X, U) avec X entiers et U = X / m dans [0,1[
    """
    X = [0] * n
    U = [0.0] * n

    X[0] = seed
    U[0] = X[0] / m

    for i in range(1, n):
        X[i] = (a * X[i-1] + c) % m
        U[i] = X[i] / m

    return X, U

```


```python
LCG1 = lcg(1, 2000, 256, 65, 1)
```


```python
LCG2 = lcg(1, 2000, 2048, 65, 1)
```


```python
LCG3 = lcg(1, 2000, 2**32, 1664525, 1013904223)
```


```python
lcg(12345, 10, 2**32, 1664525, 1013904223)
```

```python
lcg(67, 10, 2**32, 1664525, 1013904223)
```

```python
lcg(5, 10, 16, 65, 1)
```

```python
import numpy as np 
x = np.linspace(0,1,2000)
plt.plot(x,LCG1[1],linestyle="",marker=".")
plt.show()
```

```python
plt.plot(x,LCG2[1],linestyle="",marker=".")
plt.show()
```

```python
plt.plot(x,LCG3[1],linestyle="",marker=".")
plt.show()
```

```python
histogram(LCG1[1], title="Histogram LCG1", bins=20)
histogram(LCG2[1], title="Histogram LCG2", bins=20)
histogram(LCG3[1], title="Histogram LCG3", bins=20)
```