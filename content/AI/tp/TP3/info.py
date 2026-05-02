# =============================================================
# EXERCISE 1 - Dataset Familiarity
# Goal: load each dataset and explore its shape, types,
#       basic stats, and distributions.
# =============================================================


# =============================================================
# EXERCISE 2 - Missing, Duplicate, Non-Relevant Cleaning
# Goal: remove or fill NaN values, drop duplicates,
#       and drop columns that add no value to an ML model.
# =============================================================



# =============================================================
# EXERCISE 3 - Categorical Properties
# Goal: convert text/category columns into numbers so ML
#       models can read them.
# Two main techniques:
#   Label Encoding  -> maps each category to an integer (0,1,2...)
#                      use when the column has a natural order (ordinal)
#   One-Hot Encoding -> creates one binary column per category
#                      use when there is no order (nominal)
# =============================================================



# =============================================================
# EXERCISE 4 - Feature Scaling
# Goal: bring all numeric columns to the same scale so no
#       single column dominates just because of its unit.
# Two main techniques:
#   MinMaxScaler    -> squeezes values between 0 and 1
#                     formula: (x - min) / (max - min)
#   StandardScaler  -> centers around 0 with std=1
#                     formula: (x - mean) / std
#                     better when data has outliers
# =============================================================


# =============================================================
# EXERCISE 5 - Correlated Properties
# Goal: find columns that carry the same information.
#       If two columns correlate at 0.9+, you usually drop one.
# A correlation value:
#   +1.0 = perfect positive link (one goes up, other goes up)
#    0.0 = no link at all
#   -1.0 = perfect negative link (one goes up, other goes down)
# =============================================================


# =============================================================
# EXERCISE 6 - Outliers
# Goal: detect and remove extreme values that skew the model.
# Detection tool: box plot (IQR method)
#   IQR = Q3 - Q1  (the middle 50% of data)
#   Lower fence = Q1 - 1.5 * IQR
#   Upper fence = Q3 + 1.5 * IQR
#   Any point outside those fences is an outlier.
# =============================================================
