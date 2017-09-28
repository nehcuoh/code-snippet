#过滤 ok 和 succ 行
sed -n '/ok/p; /succ/p'
#编辑以disable_functions 开头的行，将 proc_open,  删除
sed -i '/^\<disable_functions\>/ s/proc_open\,//g' $php_ini

