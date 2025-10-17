Summary
=======

What We Did
-----------

- Encoded data and handled non-numeric variables: ::03_non_num:non-numeric variables::.
- Built basic classifiers and discussed performance metrics: ::05_classify:classification::, ::09_roc:ROC curves::, ::10_f1_score:F1 score::.
- Explored linear models and regularization: ::02_lin_reg:linear regression::, ::12_glmnet:glmnet (lasso/ridge)::, ::13_cor_var:correlated variables::.
- Covered model validation and reliability: ::14_cross_validation:cross validation::.
- Learned tree-based ideas and simple splitting logic, then boosted trees: ::15_tree_based:tree-based methods::, ::16_adaboost:adaboost::.

Key Takeaways
-------------

- Always separate training and testing to measure generalization.
- Prefer threshold-free metrics (ROC/AUC) to compare classifiers.
- Regularization combats overfitting; cross validation compares models fairly.
- Trees partition feature space into interpretable regions; ensembles (boosting, forests) improve accuracy.

Where To Go Next
----------------

- Try different tree depths and learning rates in ::16_adaboost:adaboost:: and compare ROC curves.
- Combine cross validation with AUC to select models: ::14_cross_validation:cross validation::.
- Extend tree splits beyond two features and visualize higher-order effects.

