# =============================================================
# SHEET IV: Machine Learning Models
# Datasets: Iris (sklearn), Titanic (train.csv), MovieLens Users
# Models:   KNN | Simple Regression | SVM | CNN (Bonus)
# =============================================================

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder, MinMaxScaler, StandardScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.linear_model import LinearRegression
from sklearn.svm import SVC
from sklearn.metrics import (
    accuracy_score, classification_report, confusion_matrix,
    mean_squared_error, r2_score
)


# =============================================================
# STEP 0 — LOAD AND PREPROCESS ALL DATASETS
# (This repeats the key steps from Sheet III so the script
#  is self-contained. Comments are shorter here.)
# =============================================================

# ── IRIS ──────────────────────────────────────────────────────
raw = load_iris()
iris = pd.DataFrame(raw.data, columns=raw.feature_names)
iris['species'] = raw.target              # 0=setosa 1=versicolor 2=virginica
iris.drop_duplicates(inplace=True)

scaler = MinMaxScaler()
feat_iris = raw.feature_names
iris[feat_iris] = scaler.fit_transform(iris[feat_iris])

# ── TITANIC ───────────────────────────────────────────────────
titanic = pd.read_csv('datasets/titanic/train.csv')
titanic.drop(columns=['PassengerId', 'Name', 'Ticket', 'Cabin'], inplace=True)
titanic['Age'].fillna(titanic['Age'].median(), inplace=True)
titanic['Embarked'].fillna(titanic['Embarked'].mode()[0], inplace=True)
titanic.drop_duplicates(inplace=True)

le = LabelEncoder()
titanic['Sex'] = le.fit_transform(titanic['Sex'])          # male=1 female=0
titanic = pd.get_dummies(titanic, columns=['Embarked'], drop_first=True)

num_cols_t = ['Age', 'Fare', 'SibSp', 'Parch', 'Pclass']
titanic[num_cols_t] = StandardScaler().fit_transform(titanic[num_cols_t])

# ── MOVIELENS USERS ───────────────────────────────────────────
users = pd.read_csv(
    'datasets/movielens/users.dat', sep='::', engine='python',
    names=['UserID', 'Gender', 'Age', 'Occupation', 'Zip-code']
)
users.drop(columns=['Zip-code', 'UserID'], inplace=True)
users.drop_duplicates(inplace=True)
users['Gender'] = le.fit_transform(users['Gender'])        # F=0 M=1
users[['Age', 'Occupation']] = MinMaxScaler().fit_transform(
    users[['Age', 'Occupation']]
)


# =============================================================
# UTILITY FUNCTIONS
# =============================================================

def split(df, target, test_size=0.2):
    """
    Splits a DataFrame into X (features) and y (target),
    then into train and test sets.
    test_size=0.2 means 20% of rows go to the test set.
    random_state=42 fixes the random split so results are
    reproducible each time you run the script.
    """
    X = df.drop(columns=[target])
    y = df[target]
    return train_test_split(X, y, test_size=0.2, random_state=42)


def plot_confusion(y_test, y_pred, title):
    """
    Draws a heatmap of the confusion matrix.
    A confusion matrix shows how many predictions were correct
    vs. how many were wrong, broken down by class.
    """
    cm = confusion_matrix(y_test, y_pred)
    plt.figure(figsize=(6, 4))
    sns.heatmap(cm, annot=True, fmt='d', cmap='Blues')
    plt.xlabel('Predicted')
    plt.ylabel('Actual')
    plt.title(f'Confusion Matrix – {title}')
    plt.tight_layout()
    plt.show()


def plot_regression(y_test, y_pred, title):
    """
    Scatter plot: actual vs. predicted values.
    The red diagonal line shows perfect predictions.
    Points close to it mean the model is accurate.
    """
    plt.figure(figsize=(6, 4))
    plt.scatter(y_test, y_pred, alpha=0.5, color='steelblue')
    lims = [min(y_test.min(), y_pred.min()), max(y_test.max(), y_pred.max())]
    plt.plot(lims, lims, 'r--', label='Perfect fit')
    plt.xlabel('Actual')
    plt.ylabel('Predicted')
    plt.title(f'Actual vs Predicted – {title}')
    plt.legend()
    plt.tight_layout()
    plt.show()


# =============================================================
# EXERCISE 1 — KNN (K-Nearest Neighbors)
# -------------------------------------------------------------
# HOW IT WORKS:
#   To classify a new point, the algorithm looks at the K
#   closest training points (neighbors) and takes a majority
#   vote. If K=5 and 4 neighbors are class A, it predicts A.
#
# KEY PARAMETER:
#   n_neighbors (K) — small K = complex boundary (risk of
#   overfitting), large K = smooth boundary (risk of missing
#   detail). K=5 is a safe starting point.
#
# GOOD FOR:
#   Classification tasks where similar inputs have similar
#   outputs. Works well when your dataset is not too large.
# =============================================================

print("\n" + "="*60)
print("EXERCISE 1 — KNN")
print("="*60)

datasets_knn = {
    'Iris'    : (iris,    'species'),
    'Titanic' : (titanic, 'Survived'),
    'Users'   : (users,   'Gender'),
}

for name, (df, target) in datasets_knn.items():
    print(f"\n--- KNN on {name} (target: {target}) ---")

    X_tr, X_te, y_tr, y_te = split(df, target)

    # Train the model
    knn = KNeighborsClassifier(n_neighbors=5)
    knn.fit(X_tr, y_tr)          # learn from training data

    # Predict on the test set
    y_pred = knn.predict(X_te)

    # Accuracy = correct predictions / total predictions
    acc = accuracy_score(y_te, y_pred)
    print(f"Accuracy: {acc:.4f} ({acc*100:.2f}%)")

    # Classification report: precision, recall, F1 per class
    # Precision = of all predicted class X, how many are really X?
    # Recall    = of all real class X, how many did we catch?
    # F1        = harmonic mean of precision and recall
    print(classification_report(y_te, y_pred))

    plot_confusion(y_te, y_pred, f'KNN – {name}')

    # ── Instance classification (predict on new data points) ──
    # We take the first 3 rows of the test set and predict them.
    # This simulates using the model on real new data.
    sample = X_te.iloc[:3]
    pred   = knn.predict(sample)
    print(f"Sample predictions for {name}: {pred}")
    print(f"Actual labels:                 {y_te.iloc[:3].values}")


# =============================================================
# EXERCISE 2 — SIMPLE LINEAR REGRESSION
# -------------------------------------------------------------
# HOW IT WORKS:
#   Regression predicts a NUMBER, not a category.
#   Linear regression fits a straight line: y = a*x + b
#   It finds 'a' (slope) and 'b' (intercept) that minimize the
#   total error between the line and all training points.
#
# "SIMPLE" = one input feature predicts one output.
# (Multiple regression would use all features at once.)
#
# METRICS:
#   R² (R-squared): how much of the variance the model explains.
#     R²=1.0 is perfect. R²=0 means the model is no better than
#     just predicting the mean every time.
#   RMSE: average prediction error in the same unit as y.
#     Lower is better.
#
# WE PICK ONE NUMERIC COLUMN AS X AND ONE AS y PER DATASET.
# =============================================================

print("\n" + "="*60)
print("EXERCISE 2 — SIMPLE LINEAR REGRESSION")
print("="*60)

# (feature_col, target_col, dataset_name)
regression_tasks = [
    (iris,    'petal length (cm)', 'petal width (cm)',  'Iris'),
    (titanic, 'Age',               'Fare',              'Titanic'),
    (users,   'Occupation',        'Age',               'Users'),
]

for df, x_col, y_col, name in regression_tasks:
    print(f"\n--- Regression on {name}: {x_col} → {y_col} ---")

    X = df[[x_col]]   # must be 2D (double brackets) for sklearn
    y = df[y_col]

    X_tr, X_te, y_tr, y_te = train_test_split(
        X, y, test_size=0.2, random_state=42
    )

    model = LinearRegression()
    model.fit(X_tr, y_tr)

    y_pred = model.predict(X_te)

    r2   = r2_score(y_te, y_pred)
    rmse = np.sqrt(mean_squared_error(y_te, y_pred))

    print(f"R² Score : {r2:.4f}   (1.0 = perfect)")
    print(f"RMSE     : {rmse:.4f}  (lower = better)")
    print(f"Slope (a): {model.coef_[0]:.4f}")
    print(f"Intercept (b): {model.intercept_:.4f}")

    # Scatter + regression line
    plt.figure(figsize=(7, 4))
    plt.scatter(X_te, y_te, alpha=0.4, color='steelblue', label='Actual')
    x_line = np.linspace(X_te.min().values[0], X_te.max().values[0], 100)
    y_line = model.coef_[0] * x_line + model.intercept_
    plt.plot(x_line, y_line, 'r-', linewidth=2, label='Regression Line')
    plt.xlabel(x_col)
    plt.ylabel(y_col)
    plt.title(f'Simple Regression – {name}')
    plt.legend()
    plt.tight_layout()
    plt.show()

    # Instance prediction: predict y for 3 specific x values
    sample_x = np.array([[0.2], [0.5], [0.8]])
    sample_pred = model.predict(sample_x)
    print(f"For {x_col} = [0.2, 0.5, 0.8]:")
    print(f"Predicted {y_col}: {sample_pred.round(4)}")


# =============================================================
# EXERCISE 3 (BONUS) — SVM (Support Vector Machine)
# -------------------------------------------------------------
# HOW IT WORKS:
#   SVM finds the best boundary (hyperplane) between classes.
#   "Best" means it maximizes the margin: the gap between the
#   boundary and the nearest points from each class.
#   Those nearest points are called "support vectors".
#
# KEY PARAMETERS:
#   kernel='rbf' — Radial Basis Function. Allows SVM to draw
#     curved boundaries (not just straight lines).
#     Other options: 'linear', 'poly'.
#   C — regularization. High C = tries harder to classify all
#     training points correctly (risk of overfitting).
#     Low C = allows some errors for a smoother boundary.
#   gamma='scale' — controls how far each point's influence
#     reaches. 'scale' sets it automatically.
#
# GOOD FOR:
#   High-dimensional data, binary classification.
#   Works best when features are scaled (which we already did).
# =============================================================

print("\n" + "="*60)
print("EXERCISE 3 (BONUS) — SVM")
print("="*60)

datasets_svm = {
    'Iris'    : (iris,    'species'),
    'Titanic' : (titanic, 'Survived'),
    'Users'   : (users,   'Gender'),
}

for name, (df, target) in datasets_svm.items():
    print(f"\n--- SVM on {name} (target: {target}) ---")

    X_tr, X_te, y_tr, y_te = split(df, target)

    svm = SVC(kernel='rbf', C=1.0, gamma='scale', random_state=42)
    svm.fit(X_tr, y_tr)

    y_pred = svm.predict(X_te)

    acc = accuracy_score(y_te, y_pred)
    print(f"Accuracy: {acc:.4f} ({acc*100:.2f}%)")
    print(classification_report(y_te, y_pred))

    plot_confusion(y_te, y_pred, f'SVM – {name}')

    # Instance classification
    sample = X_te.iloc[:3]
    pred   = svm.predict(sample)
    print(f"Sample predictions: {pred}")
    print(f"Actual labels:      {y_te.iloc[:3].values}")


# =============================================================
# EXERCISE 4 (BONUS) — CNN (Convolutional Neural Network)
# -------------------------------------------------------------
# HOW IT WORKS:
#   CNNs are normally used for images. Each layer slides a
#   small filter (kernel) over the input to detect patterns.
#
# ON TABULAR DATA:
#   We reshape each row (1D array of features) into a
#   (features, 1) tensor, so Conv1D treats each feature like
#   a pixel in a 1-pixel-wide image. This lets the CNN learn
#   local patterns between neighboring features.
#
# KEY LAYERS:
#   Conv1D   — applies filters to detect feature patterns
#   MaxPool1D — keeps the strongest signal, shrinks the size
#   Flatten  — converts 2D output to 1D for the Dense layers
#   Dense    — standard fully-connected layer
#   Dropout  — randomly zeros some neurons during training
#               to prevent overfitting
#   Softmax  — final activation for multi-class output
#              (outputs probabilities that sum to 1)
#
# TRAINING TERMS:
#   epoch — one full pass over the training data
#   batch_size — how many samples to process at once
#   loss='sparse_categorical_crossentropy' — standard loss for
#     integer class labels (0, 1, 2...)
# =============================================================

print("\n" + "="*60)
print("EXERCISE 4 (BONUS) — CNN")
print("="*60)

# Import TensorFlow here so the script still runs without it
# if you only want to test Exercises 1-3.
try:
    import tensorflow as tf
    from tensorflow.keras.models import Sequential
    from tensorflow.keras.layers import (
        Conv1D, MaxPooling1D, Flatten, Dense, Dropout
    )
    from tensorflow.keras.utils import to_categorical

    print(f"TensorFlow version: {tf.__version__}")

    def build_cnn(n_features, n_classes):
        """
        Builds a 1D CNN for tabular classification.
        Input shape: (n_features, 1) — one channel per feature.
        """
        model = Sequential([
            # Conv1D(filters, kernel_size)
            # filters=32: learns 32 different patterns
            # kernel_size=2: each filter looks at 2 adjacent features
            Conv1D(32, kernel_size=2, activation='relu',
                   input_shape=(n_features, 1)),
            MaxPooling1D(pool_size=1),      # keep strongest signal
            Dropout(0.3),                   # drop 30% to avoid overfitting
            Flatten(),                      # flatten to 1D
            Dense(64, activation='relu'),   # fully connected layer
            Dense(n_classes, activation='softmax')  # output layer
        ])
        model.compile(
            optimizer='adam',
            loss='sparse_categorical_crossentropy',
            metrics=['accuracy']
        )
        return model

    datasets_cnn = {
        'Iris'    : (iris,    'species'),
        'Titanic' : (titanic, 'Survived'),
        'Users'   : (users,   'Gender'),
    }

    for name, (df, target) in datasets_cnn.items():
        print(f"\n--- CNN on {name} (target: {target}) ---")

        X_tr, X_te, y_tr, y_te = split(df, target)

        n_feat    = X_tr.shape[1]
        n_classes = df[target].nunique()

        # Reshape: (samples, features) → (samples, features, 1)
        # Conv1D expects a 3D input.
        X_tr_cnn = X_tr.values.reshape(-1, n_feat, 1)
        X_te_cnn = X_te.values.reshape(-1, n_feat, 1)

        cnn = build_cnn(n_feat, n_classes)
        cnn.summary()

        # Train for 30 epochs, use 20% of training data for validation
        history = cnn.fit(
            X_tr_cnn, y_tr,
            epochs=30,
            batch_size=32,
            validation_split=0.2,
            verbose=0            # set to 1 to see epoch-by-epoch output
        )

        # Evaluate on test set
        loss, acc = cnn.evaluate(X_te_cnn, y_te, verbose=0)
        print(f"Test Accuracy: {acc:.4f} ({acc*100:.2f}%)")
        print(f"Test Loss    : {loss:.4f}")

        # Plot training vs validation accuracy over epochs
        plt.figure(figsize=(8, 4))
        plt.plot(history.history['accuracy'],     label='Train Accuracy')
        plt.plot(history.history['val_accuracy'], label='Val Accuracy')
        plt.xlabel('Epoch')
        plt.ylabel('Accuracy')
        plt.title(f'CNN Training History – {name}')
        plt.legend()
        plt.tight_layout()
        plt.show()

        # Confusion matrix
        y_pred_proba = cnn.predict(X_te_cnn)
        y_pred_cnn   = np.argmax(y_pred_proba, axis=1)
        plot_confusion(y_te, y_pred_cnn, f'CNN – {name}')

        # Instance classification: 3 test samples
        sample_cnn = X_te_cnn[:3]
        pred_cnn   = np.argmax(cnn.predict(sample_cnn), axis=1)
        print(f"Sample predictions: {pred_cnn}")
        print(f"Actual labels:      {y_te.iloc[:3].values}")

except ImportError:
    print("TensorFlow not installed. Run: pip install tensorflow")
    print("Exercises 1-3 are complete without it.")


print("\n=== ALL EXERCISES COMPLETE ===")