# Week 2: Random Forest Regression, Conditional Probabilities, Smoothing & Linear Regression for Prediction
## Day 1  
### What I've Learned 📚
**k-Nearest Neighbors (k-NN) Algorithm**
- k-NN is a non-parametric algorithm used for both classification and regression. It estimates an outcome by averaging or majority-voting among the k nearest training examples.
- It's easier to apply in multiple dimensions and adapts naturally to nonlinear data.
- Smoothing behavior depends on **k**: larger k values yield smoother predictions.
- k-NN uses **cross-validation** to reduce error and tune hyperparameters (like `k`) to balance bias and variance.
- k-NN is highly flexible, but overfitting is a risk if `k` is too small.

**caret Package & Syntax in R**
- `knn3()` from the caret package can be used for classification.
- Formula format: `outcome ~ predictor1 + predictor2 + ...`
- All predictors can be included using `~ .`.
- Data must be in a `data.frame`, and `y = .` uses all predictors by default.

**Overtraining vs Oversmoothing**
- Overtraining occurs when `k = 1`, leading to perfect training fit but poor generalization.
- Oversmoothing happens when `k` is too large, which reduces the model’s flexibility.
- Good cross-validation helps estimate generalization error and avoids both extremes.

### Challenges faced
None, everything seemed very straight forward. Already have knowledge of about these concepts from Python, but it was nice to work on code on these topics to visualize what is actually happening.

---

## Day 2  
### What I've Learned 📚

**Choosing the Best `k` Value**
- Choosing `k` is crucial to balance overfitting and underfitting.
- Goal: minimize **expected loss**, not just observed loss from a single test set.
- Use a test set (or validation set) to evaluate model accuracy and consistently check for improvements.

**Ensemble Methods (Brief Intro)**
- Combine multiple base models to improve predictions (bagging, boosting, stacking).
- These methods are often tested on separate test sets, then predicitons are averaged/combined.

**Cross-Validation Concepts**
- Cross-validation helps avoid overfitting by testing the model’s ability to generalize.
- Two key characteristics:
  1. If training/test splits are random, apparent error is itself a random variable.
  2. Training on one data split can yield misleadingly low error.

**Theoretical Error vs Apparent Error**
- **Apparent error**: error from testing on same data as trained.
- **True error**: estimated using new, random samples.

**Cross-Validation Formula**
```
MSE(λ) = (1/B) * Σ (from b=1 to B) (1/N) * Σ (from i=1 to N) (y_i^(b) - ŷ_i^(b))^2
```
### Reflection
Ensemble method seems super cool. Can't wait to apply that to more projects.
---
