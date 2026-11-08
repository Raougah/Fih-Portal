### Topic & Goal in Machine Learning

**Topic:** Decision Trees for Classification (Prédiction du risque de crédit).  
**Goal in ML:** The goal is to build a model that can automatically learn patterns from historical data to make predictions on new, unseen data. In this specific case, we want to help a bank automate its credit approval process by classifying clients into three categories: **Acceptation**, **Refus**, or **Risque élevé**.  
A Decision Tree does this by learning a series of "IF... THEN..." rules (like a flowchart) that split the data into increasingly pure groups based on the target variable.

---

### Partie A: Exploration des données

**Simple Goal:** "Getting to know the ingredients before cooking." We want to understand the structure, size, and basic statistics of our dataset to spot any obvious issues.

**Solution:**

1. **Charger et afficher les données :**
    - Shape: `(300, 10)` → 300 clients, 10 columns.
    - `df.head()` shows the first 5 rows.
    - `df.info()` shows data types: `age`, `revenu_annuel`, `anciennete_emploi`, `dette_totale`, `ratio_dette_revenu` are **quantitative** (numbers). `revenu_stable` and `decision` are **qualitative** (categories/text). `id_client` is an identifier.
2. **Variables quantitatives vs qualitatives :**
    - _Quantitatives:_ age, revenu_annuel, anciennete_emploi, dette_totale, ratio_dette_revenu, nb_credits_en_cours, retards_paiement (they represent measurable amounts or counts).
    - _Qualitatives:_ revenu_stable (Oui/Non), decision (Acceptation/Refus/Risque élevé) (they represent categories).
3. **Répartition de la cible (`value_counts`) :**
    - Risque élevé: 146, Acceptation: 108, Refus: 46.
    - _Is it balanced?_ No, it is slightly imbalanced. "Risque élevé" is the majority class, and "Refus" is the minority class.
4. **Statistiques descriptives (`describe()`) :** Gives us the mean, min, max, and quartiles for numerical columns. (e.g., mean age is ~43.3, mean annual income is ~67,550).

---

### Partie B: Valeurs manquantes et données quantitatives

**Simple Goal:** "Cleaning up the mess." Machine learning models cannot handle blank cells (NaN) or impossible values (like a 140-year-old person). We must fix these so the model doesn't get confused or biased.

**Solution:**

1. **Détecter les valeurs manquantes :**
    - `revenu_annuel`: 9.0% missing
    - `revenu_stable`: 6.7% missing
    - `anciennete_emploi`: 7.3% missing
    - `ratio_dette_revenu`: 5.0% missing
    - `age`: 4.0% missing  
        _(All are under 10%, so we should impute them rather than drop the rows)._
2. **Moyenne vs Médiane :**
    - For `revenu_annuel`, mean = 67,550, median = 63,800. The mean is higher because of extreme outliers (very high incomes). The gap is largest here due to right-skewness.
3. **Stratégie d'imputation appliquée :**
    - `age`, `anciennete_emploi`, `revenu_annuel`: Imputed with **median** (robust to outliers).
    - `revenu_stable`: Imputed with **mode** (most frequent value, which is 'Oui'), because it's categorical.
4. **Recalcul du `ratio_dette_revenu` :**
    - Instead of guessing the missing ratio with the median, it is **much more reliable** to recalculate it exactly as `dette_totale / revenu_annuel` for rows where both are available. This reduced missing ratios from 15 to just 2. The remaining 2 were filled with the median.
5. **Valeurs aberrantes (Outliers) :**
    - Boxplots reveal an `age` of **140** (impossible) and a `revenu_annuel` of **950,000** (likely a typo for 95,000).
    - _Treatment:_ We replace these specific impossible values with `NaN`, then impute them with the median, just like other missing values.
6. **Vérification de la cohérence :**
    - `ratio_dette_revenu >= 0`: All are valid.
    - `age >= 18`: All are valid after cleaning.
    - `anciennete_emploi <= age - 16`: 7 rows violate this (e.g., someone aged 20 with 10 years of employment). In a real scenario, we might flag these, but for this TP, we leave them as they might represent early part-time work or minor data entry errors.
7. **Question de réflexion (Normalisation) :**
    - **Non**, Decision Trees do _not_ require normalization (standardization/min-max). Why? Because trees split data based on thresholds (e.g., `age <= 30`), not on distances between points. Algorithms like K-Nearest Neighbors or Perceptrons need normalization because they calculate geometric distances, but trees are scale-invariant.
8. **Encodage et séparation :**
    - `revenu_stable` is mapped to `1` (Oui) and `0` (Non).
    - `X` (features) = all columns except `id_client` and `decision`.
    - `y` (target) = `decision`.

---

### Partie C: Construction de l'arbre

**Simple Goal:** "Building the flowchart." We train the model to find the best questions to ask to separate the clients into the correct categories.

**Solution:**

1. **Découpage des données :** 70% train (210 clients), 30% test (90 clients), with `stratify=y` to keep the same proportion of classes in both sets.
2. **Entraînement :** `DecisionTreeClassifier(criterion='gini', max_depth=3, random_state=42)`.
3. **Anatomie de l'arbre obtenu :**
    - **Racine (Root):** The very first split (`ratio_dette_revenu <= 0.41`).
    - **Nœud interne:** Any middle question (e.g., `revenu_stable <= 0.50`).
    - **Branche:** The arrow/path connecting two nodes.
    - **Feuille (Leaf):** The final prediction at the bottom (e.g., `class: Acceptation`).
    - **Profondeur (Depth):** 3. **Nombre de feuilles:** 8.
4. **Variable à la racine :** `ratio_dette_revenu`. The algorithm chose this because it provides the highest **Information Gain** (or lowest Gini impurity). It is the single most powerful feature to separate the classes. Using `entropy` instead of `gini` would yield a very similar tree structure, as both measure impurity in slightly different mathematical ways.
5. **Règles de décision (exemples) :**
    - SI `ratio_dette_revenu` <= 0.41 ET `revenu_stable` == 1 ET `retards_paiement` <= 4 ALORS **Acceptation**.
    - SI `ratio_dette_revenu` > 0.41 ET `revenu_annuel` <= 104650 ET `dette_totale` <= 73600 ALORS **Risque élevé**.
    - SI `ratio_dette_revenu` > 0.41 ET `revenu_annuel` > 104650 ET `age` <= 29 ALORS **Refus**.
6. **Prédiction pour le nouveau client :**
    - Client: age=35, revenu=55000, anciennete=6, ratio=0.30, credits=1, retards=0, stable=Oui (1).
    - _Manuel:_ ratio (0.30) <= 0.41 → Oui. stable (1) <= 0.50 → Non. retards (0) <= 4 → Oui. → **Feuille: Acceptation**.
    - _Code:_ `clf.predict(new_client)` returns `['Acceptation']`. Matches perfectly.

---

### Partie D: Évaluation et sur-apprentissage

**Simple Goal:** "The final exam." We check if the model actually learned general rules or if it just memorized the training data (overfitting). We also try to make it even better.

**Solution:**

1. **Évaluation :**
    - Train Accuracy: ~94.8% | Test Accuracy: ~97.8%
    - The model performs excellently on unseen data. The confusion matrix shows very few misclassifications (e.g., only 2 "Acceptation" predicted as "Risque élevé").
2. **Courbes d'exactitude et Sur-apprentissage (Overfitting) :**
    - As `max_depth` increases, **Train Accuracy** keeps climbing (reaching 100% at depth 10).
    - However, **Test Accuracy** peaks at depth 3 or 4 (~97.8%) and then _drops or stagnates_ (to ~93.3% at depth 10+).
    - _Conclusion:_ Overfitting starts to become noticeable around **depth 5**, where the tree becomes too specific to the training data and loses its ability to generalize.
3. **Importance des variables (`feature_importances_`) :**
    
    1. `ratio_dette_revenu` (66.8%)
    2. `revenu_stable` (29.1%)
    3. `retards_paiement` (1.6%)
    
    - _Cohérence métier :_ Oui, c'est très logique. A bank cares primarily about your debt-to-income ratio and whether your income is stable. The number of current credits or job seniority mattered less for this specific dataset.
4. **Effet de `min_samples_leaf` et `max_depth` :**
    - Decreasing `max_depth` or increasing `min_samples_leaf` makes the tree smaller and simpler, which _reduces_ overfitting and improves generalization.
    - **GridSearchCV (cv=5) meilleur résultat :** `{'criterion': 'gini', 'max_depth': 3, 'min_samples_leaf': 5}`. This confirms that a shallow tree with a requirement of at least 5 samples per leaf is the most robust configuration.
5. **Bonus : Random Forest :**
    - Training a `RandomForestClassifier(n_estimators=100)` yields a Test Accuracy of **~97.8%**.
    - _Comparison:_ It matches the best single Decision Tree here. While Random Forests usually outperform single trees by averaging many trees (reducing variance), our dataset is small and the single tree was already well-regularized (max_depth=3), so the performance is equally excellent.

---

### Summary of Key Takeaways for your Report:

- Always **explore and clean** data before modeling (handle outliers like age=140!).
- **Recalculating** missing values from existing columns is always better than blind imputation.
- Decision Trees are highly **interpretable** (you can read the rules) and **don't need feature scaling**.
- **Overfitting** is the enemy: a deeper tree is not always a better tree. Use validation (or GridSearch) to find the sweet spot.

## The complete code
## Libs

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.tree import DecisionTreeClassifier, plot_tree, export_text
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, confusion_matrix, classification_report

# Configuration de l'affichage
pd.set_option('display.max_columns', None)
sns.set_theme(style="whitegrid")
```

## Partie A: Exploration des données

```python
# 1. Charger le fichier, afficher les 5 premières lignes, la shape et info()
df = pd.read_csv('dataset_credit_TP3.csv')

print("=== 1. Exploration de base ===")
print("5 premières lignes:\n", df.head(), "\n")
print("Shape (lignes, colonnes):", df.shape, "\n")
print("Info:\n", df.info(), "\n")

# 3. Répartition de la cible
print("=== 3. Répartition de la cible ===")
print(df['decision'].value_counts())

# 4. Statistiques descriptives
print("\n=== 4. Statistiques descriptives ===")
print(df.describe())
```

## Partie B: Valeurs manquantes et données quantitatives

```python
# 1. Détecter les valeurs manquantes
missing_counts = df.isna().sum()
missing_pcts = (df.isna().mean() * 100).round(1)
missing_df = pd.DataFrame({'Count': missing_counts, 'Percentage': missing_pcts})
missing_df = missing_df[missing_df['Count'] > 0]

print("\n=== 1. Valeurs manquantes ===")
print(missing_df)

plt.figure(figsize=(10, 5))
sns.barplot(x=missing_df.index, y=missing_df['Percentage'], color='red')
plt.title('Pourcentage de valeurs manquantes par colonne')
plt.ylabel('Pourcentage (%)')
plt.show()

# 2. Moyenne vs Médiane pour les colonnes avec NaN
cols_na = ['age', 'revenu_annuel', 'anciennete_emploi', 'ratio_dette_revenu']
print("\n=== 2. Moyenne vs Médiane ===")
for col in cols_na:
    mean_val = df[col].mean()
    median_val = df[col].median()
    print(f"{col}: Moyenne = {mean_val:.2f}, Médiane = {median_val:.2f}")


# 4. Recalcul du ratio_dette_revenu (Méthode la plus fiable)
# On recalcule exactement là où c'est possible avant d'imputer le reste
mask_recalc = df['ratio_dette_revenu'].isna() & df['dette_totale'].notna() & df['revenu_annuel'].notna()
df.loc[mask_recalc, 'ratio_dette_revenu'] = df.loc[mask_recalc, 'dette_totale'] / df.loc[mask_recalc, 'revenu_annuel']


# 5. Boxplots et traitement des valeurs aberrantes
fig, axes = plt.subplots(1, 2, figsize=(12, 5))
sns.boxplot(x=df['age'], ax=axes[0], color='skyblue')
axes[0].set_title('Boxplot de l\'âge (Outlier: 140)')
sns.boxplot(x=df['revenu_annuel'], ax=axes[1], color='lightgreen')
axes[1].set_title('Boxplot du revenu annuel (Outlier: 950000)')
plt.show()

# Traitement des outliers (remplacement par NaN puis imputation)
df.loc[df['age'] > 100, 'age'] = np.nan
df.loc[df['revenu_annuel'] > 500000, 'revenu_annuel'] = np.nan

# 3. Application des stratégies d'imputation
# Quantitatives -> Médiane (robuste aux outliers)
df['age'] = df['age'].fillna(df['age'].median())
df['revenu_annuel'] = df['revenu_annuel'].fillna(df['revenu_annuel'].median())
df['anciennete_emploi'] = df['anciennete_emploi'].fillna(df['anciennete_emploi'].median())
df['ratio_dette_revenu'] = df['ratio_dette_revenu'].fillna(df['ratio_dette_revenu'].median())
# Qualitative -> Mode
df['revenu_stable'] = df['revenu_stable'].fillna(df['revenu_stable'].mode()[0])

# 6. Vérification de la cohérence
print("\n=== 6. Vérification de la cohérence ===")
print("Lignes avec ratio < 0:", (df['ratio_dette_revenu'] < 0).sum())
print("Lignes avec age < 18:", (df['age'] < 18).sum())
print("Lignes avec ancienneté > age - 16:", (df['anciennete_emploi'] > (df['age'] - 16)).sum())

# 8. Encodage et séparation X / y
df['revenu_stable'] = df['revenu_stable'].map({'Oui': 1, 'Non': 0})
X = df.drop(columns=['id_client', 'decision'])
y = df['decision']
```

## Partie C: Construction de l'arbre

```python
# 1. Découper les données
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, stratify=y, random_state=42)

# 2. Entraîner et afficher l'arbre
clf = DecisionTreeClassifier(criterion='gini', max_depth=3, random_state=42)
clf.fit(X_train, y_train)

plt.figure(figsize=(18, 10))
plot_tree(clf, feature_names=X.columns, class_names=clf.classes_, filled=True, rounded=True, fontsize=11)
plt.title("Arbre de décision (max_depth=3, criterion='gini')")
plt.show()

# Affichage textuel pour une lecture facile
print("\n=== Structure de l'arbre (Texte) ===")
print(export_text(clf, feature_names=list(X.columns)))

# 6. Prédiction pour un nouveau client
new_client = pd.DataFrame({
    'age': [35], 'revenu_annuel': [55000], 'anciennete_emploi': [6],
    'dette_totale': [16500], # 0.30 * 55000
    'ratio_dette_revenu': [0.30], 'nb_credits_en_cours': [1], 
    'retards_paiement': [0], 'revenu_stable': [1] # Oui
})

print("\n=== 6. Prédiction Nouveau Client ===")
# Chemin manuel: ratio (0.30) <= 0.41 -> Oui. revenu_stable (1) > 0.50 -> Oui. retards (0) <= 4 -> Oui. -> Feuille: Acceptation
prediction = clf.predict(new_client)
print("Prédiction du modèle:", prediction[0])
```

## Partie D: Évaluation et sur-apprentissage

```python
# 1. Évaluation du modèle
y_train_pred = clf.predict(X_train)
y_test_pred = clf.predict(X_test)

print("\n=== 1. Métriques d'évaluation ===")
print(f"Accuracy Train: {accuracy_score(y_train, y_train_pred):.4f}")
print(f"Accuracy Test : {accuracy_score(y_test, y_test_pred):.4f}\n")

print("Matrice de confusion:\n", confusion_matrix(y_test, y_test_pred, labels=clf.classes_))
print("\nRapport de classification:\n", classification_report(y_test, y_test_pred))

# 2. Courbes d'exactitude et Sur-apprentissage
train_acc = []
test_acc = []
depths = range(1, 16)

for d in depths:
    clf_d = DecisionTreeClassifier(criterion='gini', max_depth=d, random_state=42)
    clf_d.fit(X_train, y_train)
    train_acc.append(accuracy_score(y_train, clf_d.predict(X_train)))
    test_acc.append(accuracy_score(y_test, clf_d.predict(X_test)))

plt.figure(figsize=(10, 5))
plt.plot(depths, train_acc, label='Train Accuracy', marker='o', color='blue')
plt.plot(depths, test_acc, label='Test Accuracy', marker='s', color='red')
plt.xlabel('Profondeur de l\'arbre (max_depth)')
plt.ylabel('Exactitude (Accuracy)')
plt.title('Évolution de l\'exactitude en fonction de la profondeur')
plt.xticks(depths)
plt.legend()
plt.grid(True)
plt.show()

# 3. Importance des variables
importances = pd.Series(clf.feature_importances_, index=X.columns).sort_values(ascending=False)
print("\n=== 3. Importance des variables ===")
print(importances)

plt.figure(figsize=(10, 5))
sns.barplot(
    x=importances.values, 
    y=importances.index, 
    hue=importances.index,
    palette='viridis', 
    legend=False
) 

plt.title('Importance des variables dans le modèle')
plt.xlabel('Score d\'importance')
plt.ylabel('Variables')
plt.show()


# 4. GridSearchCV pour trouver les meilleurs hyperparamètres
param_grid = {
    'max_depth': [2, 3, 4, 5],
    'min_samples_leaf': [1, 5, 10, 20],
    'criterion': ['gini', 'entropy']
}

grid = GridSearchCV(DecisionTreeClassifier(random_state=42), param_grid, cv=5, scoring='accuracy')
grid.fit(X_train, y_train)

print("\n=== 4. GridSearchCV ===")
print("Meilleurs hyperparamètres:", grid.best_params_)
print("Meilleur score (Cross-Validation):", grid.best_score_.round(4))

# 5. Bonus: Random Forest
rf = RandomForestClassifier(n_estimators=100, random_state=42)
rf.fit(X_train, y_train)
rf_test_pred = rf.predict(X_test)

print("\n=== 5. Random Forest (Bonus) ===")
print(f"Accuracy Random Forest (Test): {accuracy_score(y_test, rf_test_pred):.4f}")
```

## Responses of questions
## Partie A

```python
# 2. Variables quantitatives vs qualitatives
# Quantitatives (numériques): age, revenu_annuel, anciennete_emploi, dette_totale,
# ratio_dette_revenu, nb_credits_en_cours, retards_paiement.
# Qualitatives (catégories): revenu_stable (Oui/Non), decision (Acceptation/Refus/Risque élevé).
```

```python
# 3. Répartition de la cible
# Réponse: Le jeu n'est pas parfaitement équilibré. "Risque élevé" est la classe majoritaire (146),
# et "Refus" est la classe minoritaire (46).
```

## Partie B

```python
# 2. Moyenne vs Médiane
# Réponse: L'écart est le plus grand pour 'revenu_annuel'. Cela s'explique par la présence
# d'une valeur aberrante extrême (950,000) qui tire la moyenne vers le haut, tandis que la médiane reste robuste.
```

```python
# 4. Recalcul du ratio_dette_revenu
# Réponse: Le recalcul exact (dette/revenu) est beaucoup plus fiable qu'une imputation par la médiane
# car il préserve la relation mathématique réelle entre les variables pour ce client.
```

```python
# 7. Question de réflexion: Normalisation
# Réponse: NON. Les arbres de décision n'ont pas besoin de normalisation (standardisation/min-max).
# Contrairement au Perceptron ou aux K-Plus Proches Voisins (KNN) qui calculent des distances géométriques
# (où l'échelle des variables a un impact direct), les arbres séparent les données en créant des seuils
# (ex: age <= 30). Ces seuils s'adaptent automatiquement à l'échelle de chaque variable.
```

## Partie C

```python
# 3. Anatomie de l'arbre
# - Racine (Root) : Le tout premier nœud en haut (ratio_dette_revenu <= 0.41).
# - Nœud interne : Un nœud au milieu qui pose une question (ex: revenu_stable <= 0.50).
# - Branche : La ligne/flèche qui relie un nœud à un autre.
# - Feuille (Leaf) : Les nœuds finaux qui donnent la classe (ex: class: Acceptation).
# - Profondeur : 3.
# - Nombre de feuilles : 8.
```

```python
# 4. Variable à la racine
# Réponse: 'ratio_dette_revenu'. L'algorithme la choisit car c'est celle qui réduit le plus l'impureté
# (Gini) des classes. Si on utilisait 'entropy', la structure serait quasi identique car les deux
# mesures évaluent le désordre de manière très similaire.
```

```python
# 5. Règles de décision (exemples lus sur l'arbre)
# Règle 1: SI ratio_dette_revenu <= 0.41 ET revenu_stable == 0 (Non) ALORS Refus
# Règle 2: SI ratio_dette_revenu <= 0.41 ET revenu_stable == 1 (Oui) ET retards_paiement <= 4 ALORS Acceptation
# Règle 3: SI ratio_dette_revenu > 0.41 ET revenu_annuel <= 104650 ET dette_totale <= 73600 ALORS Risque élevé
```

## Partie D

```python
# 2. Courbes d'exactitude et sur-apprentissage
# Réponse: Le sur-apprentissage (overfitting) commence à être visible à partir de la profondeur 4 ou 5.
# L'accuracy sur le train continue de monter (jusqu'à 100%), mais l'accuracy sur le test stagne ou baisse,
# prouvant que l'arbre mémorise le bruit au lieu d'apprendre des règles générales.
```

```python
# 3. Importance des variables
# Réponse: Oui, c'est très cohérent avec l'intuition métier. Le ratio d'endettement et la stabilité
# du revenu sont les critères fondamentaux qu'un banquier regarde en premier pour accorder un crédit.
```

```python
# 4. Effet de min_samples_leaf et max_depth
# Réponse: Diminuer max_depth ou augmenter min_samples_leaf force l'arbre à être plus petit et plus simple.
# Cela réduit le sur-apprentissage et améliore la capacité de généralisation sur de nouvelles données.
```

```python
# 5. Bonus: Random Forest
# Réponse: La Random Forest obtient une performance similaire (voire légèrement meilleure ou égale).
# En regroupant plusieurs arbres, elle réduit la variance et le risque de sur-apprentissage par rapport à un arbre unique.
```
