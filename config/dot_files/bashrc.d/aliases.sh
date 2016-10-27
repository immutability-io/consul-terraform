# reload settings
alias profile="source $HOME/.profile"

# Existing commands behavior
ls_supp_flags=""
if [ $RUNNING_ENV = "OSX" ];then
   ls_supp_flags="$ls_supp_flags -G"
else
   ls_supp_flags="$ls_supp_flags --color"
fi
alias ls='ls $ls_supp_flags'
alias ll='ls -lh $ls_supp_flags'

# Versioning stuff
alias git-graph='git log --graph --oneline --decorate --all'
