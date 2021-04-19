locals {
    taint_critical = var.server_taint_criticalonly == true ? "--node-taint \"CriticalAddonsOnly=true:NoExecute\" \\" : "\\"
}