BEGIN{
    FS="#"
}
{
    if (match($0,"erralt")) {
        flag_cnt["erralt"]++
        next
    }
    if (match($0,"ssoerr")) {
        flag_cnt["ssoerr"]++
    }
    login_flag="unknown"
    if (match($0, "regnew")) {
        flags["regnew"]++
    }
    if (match($0, "regsucc")) {
        flags["regsucc"]++
    }
    if (match($0, "recycle_succ")) {
        flags["recycle_succ"]++
    }
    if (match($0, "recycle_err")) {
        flags["recycle_err"]++
    }
    if (match($0, "login")) {
        flags["login"]++
    }
 
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
        flow_flag="quicksignuplogin"
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
        next
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
    
    print "\r\n====entry login type===="
    for (e in entry_flow_cnt){
        print "\r\n",e,":",entry_flow_cnt[e]
    }
}
