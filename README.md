# blackops

How to install:

(1) As Root:
  chmod +x init_vm_run_as_root.sh && ./init_vm_run_as_root.sh

(2) As blackops (su - blackops):
  cd blackops_repo && make env && source ../.profile && make && source ../.profile
