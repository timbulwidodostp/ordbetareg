help for ordbetareg
-------------------

Title
-----

    ordbetareg -- Ordered Beta Regression Model

Syntax
------

    ordbetareg depvar indepvars [if] [in] [, NOCONS]

    depvar      : The dependent variable. Must take values of 0, 1, or between 0 and 1 (proportions).
    indepvars   : Independent variables to be included in the regression model.

Description
-----------

    ordbetareg fits an ordered beta regression model where the dependent variable is either 0, 1, or
    a value between 0 and 1. Unlike standard betareg, this model can handle bounded dependent variables with values at the bounds (i.e. values of 0 or 1).
    
    For a full description of the model, see
    
    Kubinec, Robert. "Ordered Beta Regression: A Parsimonious, Well-fitting Model for Continuous Data with Lower and Upper Bounds." Political Analysis. 2023; 31(4):519-536. doi:10.1017/pan.2022.20
    
    
    The model assumes that outcomes 0 and 1 are boundary categories and that
    values between 0 and 1 follow a beta distribution. The model fits covariates to an outcome/response
    and returns coefficients on the logit scale. These can be then converted to marginal effects to obtain
    the effect of the covariate on the bounded [0,1] outcome scale using the margins command (see example below).

    The model divides the dependent variable into three categories:
      - 0: The lower boundary (exact zero).
      - 1: The upper boundary (exact one).
      - Proportional values between 0 and 1: These are modeled using a beta distribution.

    The model estimates the regression coefficients for the independent variables, as well as the cutpoints that divide the latent variable into ordered categories and the beta-distribution shape parameter (phi).

Options
-------

    NOCONS       : Suppresses the constant term in the model.

Examples
--------

    . * Generate some example data
    . clear all
    . set obs 1000
    . gen X = rnormal()
    . gen eta = 0.5 + 1.0 * X
    . gen mu = invlogit(eta)
    . gen rand = runiform()
    . gen outcome = .
    . replace outcome = 0 if rand < 1 - invlogit(logit(mu) - -1)
    . replace outcome = 1 if rand > invlogit(logit(mu) - -1) - invlogit(logit(mu) - 1)
    . replace outcome = rbeta(mu * 2, (1 - mu) * 2) if outcome == .
    
    . * Fit the ordered beta regression model
    . ordbetareg outcome X

    . * View the results
    . ml display
    
    . * Estimate marginal effects of the covariate X
    . margins, dydx(X)

    . * Predicted probabilities at representative values of X
    . margins, at(X=(-2 -1 0 1 2))

Methods and Formulas
--------------------

    The ordered beta regression model is estimated using maximum likelihood estimation (MLE). The main limitation of MLE is that the data must have at least one observation at each bound (0 and 1). If all the values are within [0,1], the model will revert to ordinary beta regression. 
    The likelihood function is composed of:
      - A logistic probability for the 0 and 1 categories.
      - A beta-distribution density for the proportions between 0 and 1.

    The cutpoints (which define the boundaries between the categories) and the shape parameter of the beta distribution (phi) are ancillary parameters that are reported along with regression coefficients. 
    The cutpoints are on the logit scale and the correct value of the second cutpoint is cut1 + exp(cut2). The phi parameter is on the exponential scale and to obtain the correct value the reported value must also be exponentiated.

Saved Results
-------------

    ordbetareg saves the following in `e()`:

    Scalars:
      e(N)           Number of observations
      e(df_m)        Model degrees of freedom
      e(ll)          Log likelihood
      e(chi2)        Chi-squared statistic
      e(p)           p-value for the model

    Macros:
      e(cmd)         Command name (`ordbetareg')
      e(depvar)      Name of the dependent variable
      e(indepvars)   List of independent variables
      e(title)       Title of the model

    Matrices:
      e(b)           Coefficient vector
      e(V)           Variance-covariance matrix of the estimators

Author
------

    Created by Robert Kubinec
    rkubinec@mailbox.sc.edu
    Department of Political Science
    University of South Carolina
