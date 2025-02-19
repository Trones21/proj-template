 
 # This doesnt keep the session open
 ssh -t user@host "bash --login" 
 #these commands are run locally 
 touch test.txt
 ls

 #ssh -A user@host "sudo -S mkdir ~/transferred/" # this works but not ideal

#Random commands with evn vars replaced so that i can run manually without typing 
#  scp frontend.tar backend.tar compose_pre_built.yaml ~/env_setup/pk_projName/prod_backend.sh user@host:~/transferred

#  ssh -A trones@talktop.us ". ~/transferred/prod_backend.sh"