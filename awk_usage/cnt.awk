{
    #统计流程信息
    ok=0 
    flow_flag="unkonwn"
    is_weixinh5 = match($0,"weixinh5");
    if(is_weixinh5) {
        ok=1
        flow_flag = "weixin_oauth"
    }
 
    if(!ok && match($0,"create_visitor")!=0){
        ok=1
        flow_flag="create_visitor"
    }
    if(!ok && match($0,"othersiteid")!=0){
        ok=1
        flow_flag="othersiteid"
    }
    if(!ok && match($0,"grantsignup")!=0){
        ok=1
        flow_flag="grantsignup"
    }
    if(!ok && match($0,"quicksignuplogin")!=0){
        ok=1
        flow_flag="quicksignuplogin_pv"
    }
    if(!ok && match($0,"phone&dev")!=0){
        ok=1
        flow_flag="phone&dev"
    }
    if(!ok && match($0,"erralt")!=0){
        ok=1
        flow_flag="erralt"
    }
    if(!ok && match($0,"grantlogin")!=0){
        ok=1
        flow_flag="grantlogin"
    }
    if(!ok && match($0,"login_already")!=0){
        flow_flag="login_already"
    }   

    if(!ok) {
        #没有匹配上任何流程
        if(match($0,"emptysinfo")){
	    err = "empty_sinfo"
            flow_flag="empty_sinfo"
        }else{
            next
        }
    }  
    flow_cnt[flow_flag]++

    total++
    entry_flag = "unknown"
    if (is_weixinh5 != 0) { 
        entry_flag = "weixinh5"

    }else if (match($0,"mweibo")) {
        entry_flag = "mweibo"

    }else if (match($0,"fans_dig")!=0) {
        entry_flag = "fans_dig"

    }else if (match($0,"hotvid_alipay")!=0) {
        entry_flag = "hotvid_alipay"
    } else {
        entry_flag="others"
    }
    entry_cnt[entry_flag]++
    entry_flow_cnt[entry_flag, " => ",flow_flag]++

    #if(err!=""){
    #    entry_err_cnt[entry_flag, " => ",err]++
    #}
}

END{
    print "\r\n====login type summary====="
    for(f in flow_cnt) {
        print f,":",flow_cnt[f]
    }
    
    print "\r\n====entry symmary====="
    for (e in entry_cnt) {
        print e,":",entry_cnt[e]
    }
    
    print "\r\n====login type group by entry===="
    for (e in entry_flow_cnt){
        print "\r\n",e,":",entry_flow_cnt[e]
    }
    
    #print "\r\n====sinfo err===="
    #for (e in entry_err_cnt){
    #    print "\r\n",e,":",entry_err_cnt[e]
    #}
}
