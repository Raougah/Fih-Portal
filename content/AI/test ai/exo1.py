""" 
Name: Alaa Mekibes
Date: 04/30/2026
Test AI
"""
import pandas as pd
from sklearn.preprocessing import MinMaxScaler, LabelEncoder 
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns

# Load dataset
def load_dataset():
    df = pd.read_csv("Suicide_rate_trend_FINAL.csv")
    return df

# Understanding data
def understand(df):
    print(f"first 5 rows: {df.head()}")
    print(f"info: {df.info()}")
    print(f"Information about data types: {df.describe()}")
    # View how much data is missing
    print(f"null values (empty values): {df.isnull().sum()}")

def cleaning_dataset(df):
    # Drop duplicates   
    print("\n========DROP DUPLICATES==========\n")
    df.drop_duplicates()
    # fill numerical values
    print("\n========Fill numerical values==========\n")
    for column in df.columns:
            if df[column].dtype in ['int64', 'float64']:
                df[column] = df[column].fillna(df[column].mean())

    # Fill non numerical values
    print("\n========Fill non numerical values==========\n")
    for column in df.columns:
        if df[column].dtype == 'str':
            mode = df[column].mode()
            if not mode.empty:
                print(f"Filling NaN values in column '{column}' with mode: {mode[0]}")
                df[column] = df[column].fillna(mode[0])

    # categorical var
    print("\n========Categorical variables ()==========\n")
    scaler = MinMaxScaler()
   
    numerical_columns = df.select_dtypes(include = [np.number]).columns.tolist()
    print("Using MinMaxScaler")
    df[numerical_columns] = scaler.fit_transform(df[numerical_columns])
            

    # encoding
    label_encoder = LabelEncoder()
   
   
    print("\n========Transform string to numbers==========\n")
    non_numerical_columns = df.select_dtypes(exclude = [np.number]).columns.tolist()
    for column in non_numerical_columns:
        df[column] = label_encoder.fit_transform(df[column])

    
    # Reduction
    """ 
    This avoid clumn affect to another column
    """
    corr = df.corr()

    # plot heatmap
    sns.heatmap(corr, annot=True, cmap='coolwarm')
    plt.title('Correlation Matrix')
    plt.show()

    # drop columns with correlation above 0.9
    to_drop = []
    for i in range(len(corr)):
        for j in range(i + 1, len(corr)):
            if abs(corr.iloc[i, j]) > 0.9:
                to_drop.append(corr.columns[j])

    df = df.drop(columns=to_drop)
    # outliers

# ========= Exo2

from sklearn.preprocessing import LabelEncoder, MinMaxScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import (accuracy_score, classification_report)

def knn():
    print("KNN")
# main
df = load_dataset()
understand(df)
cleaning_dataset(df)
print("\nFINAL\n")
print(f"After cleaning data:\n{df.isnull().sum()}")
print(f"\nFirst 10 rows:\n{df.head(10)}")

print("\n===============EXO2=================\n")
knn()