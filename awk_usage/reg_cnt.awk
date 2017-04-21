{
    flag="unknown"
    if(match($20,"erralt"))
    { 
        err_cnt["alt_err"]++
        next
    }
    if(match($20,"recycle_err")) {
        err_cnt["recycle_err"]++
	next
    }
    if(match($20,"mcerr")) {
        err_cnt["mc_err"]++
        next
    }
    if(match($20,"ssoerr")) {
        err_cnt["sso_err"]++
        next
    }
    if(match($20,"getsso_empty_lastlogintime")) {
        err_cnt["empty_lt"]++
	next
    }
    if(match($18,"login")) {
        flag="login"

    } else if(match($18,"regnew") && match($19,"regsucc")){
	flag="regsucc"
    }
    if (flag=="unknown") {
        err_cnt[$12]++
    }
    cnt[flag]++
    entry[$4]++
    entry_flow_cnt[$4,flag]++
    uid[$6]=1
    total++
}
 
END{ 
    print "type summary:";
    for(f in cnt) {
        print "\t",f,cnt[f]
    } 
    print "\r\n"
    print "entry summary:"
    for(e in entry) {
        print "\t",e,entry[e]
    }
    
    print "\r\n====type group by entry===="
    for(e in entry_flow_cnt){
        print "\t",e,entry_flow_cnt[e]
    }


    print "unique uid cnt:",length(uid)
    print "total:",length(uid)
    print "\r\n"
    print "errors:"
    for(e in err_cnt){
        print "\t",e,err_cnt[e]
    }
}
