# Command completions
[[ /sbin/kubectl ]] && zsh-defer -c "source <(kubectl completion zsh)"
[[ /sbin/k3d ]] && zsh-defer -c "source <(k3d completion zsh)"
[[ /sbin/datree ]] && zsh-defer -c "source <(datree completion zsh)"
[[ /sbin/helm ]] && zsh-defer -c "source <(helm completion zsh)"
[[ /sbin/tobs ]] && zsh-defer -c "source <(tobs completion zsh)"
[[ /sbin/go-micro ]] && zsh-defer -c "source <(go-micro completion zsh)"
[[ /sbin/cilium ]] && zsh-defer -c "source <(cilium completion zsh)"
[[ /sbin/gh ]] && zsh-defer -c "source <(gh completion -s zsh)"
