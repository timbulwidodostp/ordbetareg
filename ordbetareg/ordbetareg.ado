* File: ordbetareg.ado


program define ordbetareg, eclass
    version 16.0
    
    // Parse the syntax
    syntax varlist [if] [in], [NOCONS]
    
    marksample touse

    // Get dependent and independent variables
    gettoken depvar indepvars : varlist
 
    // Estimate the model using Maximum Likelihood
    ml model lf ord_beta_ll (xb: `depvar'=`indepvars') /phi /cut1 /cut2, technique(nr)
    
    // Maximize the likelihood
    ml maximize
    
    ereturn local depvar `depvar'
    ereturn local indepvars `indepvars'
    ereturn local predict "ordbetareg_p"
    ereturn display

end


