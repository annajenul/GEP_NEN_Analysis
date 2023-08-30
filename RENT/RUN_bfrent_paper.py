# -*- coding: utf-8 -*-
"""
title: "Experiment 1"
author: "Anna Jenul et al."
date: "August 2023"
output:
"""


# =============================================================================
# Import modules
# =============================================================================

import pandas as pd
import numpy as np
import bfrent
from RENT import RENT
from sklearn.preprocessing import StandardScaler, PowerTransformer



# =============================================================================
# Load data
# =============================================================================

# Load all blocks
X1_df = pd.read_csv('X1.csv', index_col=0)
X2_df = pd.read_csv('X2.csv', index_col=0)
X3_df = pd.read_csv('X3.csv', index_col=0)
X4_df = pd.read_csv('X4.csv', index_col=0)
X5_df = pd.read_csv('X5.csv', index_col=0)
X6_df = pd.read_csv('X6.csv', index_col=0)

# Load array holding information on patients belonging to certain folds
fold_info = pd.read_csv('fold_matrix.csv')



# =============================================================================
# Prepare data for BF RENT
# =============================================================================

# Construct X from all blocks and read OS data from response
X_df = pd.concat([X1_df, X2_df, X3_df, X4_df, X5_df, X6_df], axis=1)

# Get target data
Y_df = pd.read_csv('response.csv', index_col=0)
y_df = pd.DataFrame(Y_df['OS (months)'])


# Extract patient indices for each of the five folds
fold_1_ind = fold_info.iloc[:, 0]
fold_2_ind = fold_info.iloc[:, 1]
fold_3_ind = fold_info.iloc[:, 2]
fold_4_ind = fold_info.iloc[:-1, 3]
fold_5_ind = fold_info.iloc[:-1, 4]


# Set which fold is to be the outer fold in nested cross validation
keep_out_fold = 5

# Set scaling for X and y
X_scale = 'yeo_johnson'
y_scale = 'none'


# Select data according to what is the outer fold and what are the inner folds
if keep_out_fold == 1:
    print('Leaving out fold ', 1)
    X_df_outer = X_df.loc[fold_1_ind]
    X_df_inner = X_df.drop(fold_1_ind, axis=0)
    
    y_df_outer = y_df.loc[fold_1_ind]
    y_df_inner = y_df.drop(fold_1_ind, axis=0)
    
if keep_out_fold == 2:
    print('Leaving out fold ', 2)
    X_df_outer = X_df.loc[fold_2_ind]
    X_df_inner = X_df.drop(fold_2_ind, axis=0)
    
    y_df_outer = y_df.loc[fold_2_ind]
    y_df_inner = y_df.drop(fold_2_ind, axis=0)

if keep_out_fold == 3:
    print('Leaving out fold ', 3)
    X_df_outer = X_df.loc[fold_3_ind]
    X_df_inner = X_df.drop(fold_3_ind, axis=0)
    
    y_df_outer = y_df.loc[fold_3_ind]
    y_df_inner = y_df.drop(fold_3_ind, axis=0)

if keep_out_fold == 4:
    print('Leaving out fold ', 4)
    X_df_outer = X_df.loc[fold_4_ind]
    X_df_inner = X_df.drop(fold_4_ind, axis=0)
    
    y_df_outer = y_df.loc[fold_4_ind]
    y_df_inner = y_df.drop(fold_4_ind, axis=0)

if keep_out_fold == 5:
    print('Leaving out fold ', 5)
    X_df_outer = X_df.loc[fold_5_ind]
    X_df_inner = X_df.drop(fold_5_ind, axis=0)
    
    y_df_outer = y_df.loc[fold_5_ind]
    y_df_inner = y_df.drop(fold_5_ind, axis=0)



# =============================================================================
# Run BF RENT on inner loop data
# =============================================================================

C_params = [1, 10, 100, 1000]
l1_ratio_params = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]


# Initialise brute force RENT
bfr = bfrent.BF_RENT_REGRESSION(X=X_df_inner,
                                y=y_df_inner,
                                C_par=C_params,
                                l1_rat_par=l1_ratio_params,
                                K_num=100,
                                num_splits=5,
                                num_reps=4,
                                X_scale=X_scale,
                                y_scale=y_scale)


# Compute results
results = bfr.apply_brute_force()

# Get overall summary for specific performance metrics
df_r2 = bfr.overall_performance_summary('r2')
df_MAE = bfr.overall_performance_summary('MAE')
df_MSE = bfr.overall_performance_summary('MSE')
df_RMSE = bfr.overall_performance_summary('RMSE')



# =============================================================================
# Extract results for requested model 
# =============================================================================


C = 1
l1_ratio = 0.3
tau_1 = 0.25
tau_2 = 0.25
tau_3 = 0.975



obs_train_summary = bfr.observation_prediction_summary(C=C, l1_ratio=l1_ratio,
                                                        tau_1=tau_1, tau_2=tau_2, tau_3=tau_3,
                                                        pred='train_pred')



obs_test_summary = bfr.observation_prediction_summary(C=C, l1_ratio=l1_ratio,
                                                      tau_1=tau_1, tau_2=tau_2, tau_3=tau_3,
                                                      pred='test_pred')



obs_train_details = bfr.observation_prediction_details(C=C, l1_ratio=l1_ratio,
                                                            tau_1=tau_1, tau_2=tau_2, tau_3=tau_3,
                                                            pred='train_pred')


obs_train_details = bfr.observation_prediction_details(C=C, l1_ratio=l1_ratio,
                                                                tau_1=tau_1, tau_2=tau_2, tau_3=tau_3,
                                                                pred='train_pred')


selected_features = bfr.selected_features_count(C=C, l1_ratio=l1_ratio, 
                                                tau_1=tau_1, tau_2=tau_2, tau_3=tau_3)




