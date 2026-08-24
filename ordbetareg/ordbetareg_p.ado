// Custom prediction function
program define ordbetareg_p
    version 16.0
    
    syntax newvarname [if] [in], [ xb ]
    
    marksample touse, novarlist
    
    local noopts: word count `xb'

    // Generate linear predictor (xb) if requested
    if `noopts'==1 {
        _predict `typlist' `varlist' if `touse' , xb
        exit
    }

    // Otherwise, predict the probabilities bounded between 0 and 1
    tempvar xbv
    quietly _predict double `xbv' if `touse' , xb
    generate `typlist' `varlist' = invlogit(`xbv') if `touse'

end
