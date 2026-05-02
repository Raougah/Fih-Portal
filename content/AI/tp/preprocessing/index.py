import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from sklearn.preprocessing import StandardScaler, MinMaxScaler, LabelEncoder
import seaborn as sns

def loadingData():
    try:
        df = pd.read_csv("datasets/titanic/train.csv")
    except Exception as e:
        print(f"Error loading dataset: {e}")
        return None
    print("Dataset loaded successfully.")
    return df

def understanding(df):
    print("\n=== Understanding the Dataset ===\n")
    print(df.head())
    print(df.info())
    print(df.describe())
    print(f"Number of rows: {df.shape[0]}")
    print(f"Number of columns: {df.shape[1]}")
    print(f"\nMissing values per column:\n{df.isnull().sum()}")

    return
    plt.scatter(df['Age'], df['Survived'])
    plt.xlabel('Age')
    plt.ylabel('Survived')
    plt.title('Age vs Survived')
    plt.show()

def UnnecessaryData(df):
    print("\n=== Removing Unnecessary Data ===\n")
    df.drop_duplicates()
    df.drop(columns=['Embarked'])
    print(f"Missing values per column after drop:\n{df.isnull().sum()}")

def FillNaNValues(df):
    print("\n=== Filling NaN Values ===\n")
    # Fill NaN values in numeric columns with the mean of the column
    for column in df.columns:
        if df[column].dtype in ['int64', 'float64']:
            df[column] = df[column].fillna(df[column].mean())

    # Fill NaN values in object columns with the mode of the column
    for column in df.columns:
        if df[column].dtype == 'str':
            mode = df[column].mode()
            if not mode.empty:
                print(f"Filling NaN values in column '{column}' with mode: {mode[0]}")
                df[column] = df[column].fillna(mode[0])

    print(f"Missing values per column after filling NaN values:\n{df.isnull().sum()}")

def Outliers(df):
    print("\n=== Handling Outliers ===\n")
    numerical_columns = df.select_dtypes(include = [np.number]).columns.tolist()
    print(f"Numerical columns: {numerical_columns}")
    for column in numerical_columns:
        Q1 = df[column].quantile(0.25)
        Q3 = df[column].quantile(0.75)
        IQR = Q3 - Q1
        lower_bound = Q1 - 1.5 * IQR
        upper_bound = Q3 + 1.5 * IQR

        print(f"lower_bound for column '{column}': {lower_bound}")
        print(f"upper_bound for column '{column}': {upper_bound}")

        is_affected = (df[column] < lower_bound) | (df[column] > upper_bound)

        if(is_affected.any()):
            print(f"Outliers in column '{column}':")
            print(df[is_affected][column])
        
            df[column] = np.where(df[column] < lower_bound, lower_bound, df[column])
            df[column] = np.where(df[column] > upper_bound, upper_bound, df[column])

def categorical_properties(df):
   print("\n=== Categorical properties ===\n")
   label_encoder = LabelEncoder()
   
   non_numerical_columns = df.select_dtypes(exclude = [np.number]).columns.tolist()
   for column in non_numerical_columns:
       df[column] = label_encoder.fit_transform(df[column])

def scaling(df, choice = 1):
   print("\n=== Feature Scaling ===\n")
   scaler1 = MinMaxScaler()
   scaler2 = StandardScaler()
   
   numerical_columns = df.select_dtypes(include = [np.number]).columns.tolist()

   if choice == 1:
       print("Using MinMaxScaler")
       df[numerical_columns] = scaler1.fit_transform(df[numerical_columns])
   else:
       print("Using StandardScaler")
       df[numerical_columns] = scaler2.fit_transform(df[numerical_columns])

def correlated_detection(df):
    print("\n=== Correlated Features ===\n")
    # compute correlation matrix
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


df = loadingData()
understanding(df)
UnnecessaryData(df)
FillNaNValues(df)
categorical_properties(df) # Make text columns into numbers
scaling(df, choice=1) # Make numeric columns between 0 and 1
correlated_detection(df) # Detect correlated features
""" 
 1   = when one goes up, the other always goes up
-1   = when one goes up, the other always goes down
 0   = no relationship at all
 => above or below 0.9 is a strong correlation, we can drop one of the two columns
"""
Outliers(df)
print(df.head(20))