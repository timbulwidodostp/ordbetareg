* File: ord_beta_ll.ado

// Likelihood function definition
program define ord_beta_ll
    args lnf xb phi cut1 cut2

    tempvar mu mu_ql low middle high beta_density cut3 phi2
    
    // define some variables manually that can't be maximized otherwise
    
    quietly gen double `cut3' = exp(`cut1') + `cut2'
    
    quietly gen double `phi2' = exp(`phi')

    // Ensure mu is between 0 and 1 using invlogit
    quietly gen double `mu' = invlogit(`xb')

    // Logistic transformation of mu (log-odds)
    quietly gen double `mu_ql' = logit(`mu')

    // Calculate probabilities for three possible categories (0, proportion, 1)
    quietly gen double `low' = 1 - invlogit(`mu_ql' - `cut1')
    quietly gen double `middle' = invlogit(`mu_ql' - `cut1') - invlogit(`mu_ql' - `cut3')
    quietly gen double `high' = invlogit(`mu_ql' - `cut3')

    // Calculate beta density for the proportions (x in (0, 1))
    tempvar alpha_beta beta_beta
    quietly gen double `alpha_beta' = `mu' * `phi2'
    quietly gen double `beta_beta' = (1 - `mu') * `phi2'

    // Determine the likelihood for each observation based on the value of x (0, 1, or proportion)
    quietly replace `lnf' = log(`low') if $ML_y1 == 0
    quietly replace `lnf' = log(`high') if $ML_y1 == 1
    quietly replace `lnf' = log(`middle') + log(betaden(`alpha_beta',`beta_beta',$ML_y1)) if $ML_y1 > 0 & $ML_y1 < 1
    
end

