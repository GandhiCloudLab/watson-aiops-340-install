#!/usr/bin/env bash

source ./00-config.sh

source ./common/01-create-namespace-secret-catalog-subscription.sh
source ./common/02-patch-serviceaccount_ibm_operator_catalog.sh
source ./common/03-verify-event-manager-operator.sh
source ./common/04-create-crd-installation.sh
source ./common/05-verify-pods-count.sh
source ./common/06-print-console-url-pwd.sh

install_main() {

  date1=$(date '+%Y-%m-%d %H:%M:%S')
  echo "******************************************************************************************"
  echo " IBM Cloud Pak for Watson AIOps Event Manager install started ....$date1"
  echo "******************************************************************************************"
  
  create_namespace_secret_catalog_subscription
  patch_serviceaccount_ibm_operator_catalog
  verify_event_manager_operator
  if [[ $GLOBAL_POD_VERIFY_STATUS == "true" ]]; then 
    create_crd_installation
    verify_pods_count
    print_console_url_pwd
  fi

  date1=$(date '+%Y-%m-%d %H:%M:%S')
  echo "******************************************************************************************"
  echo " IBM Cloud Pak for Watson AIOps Event Manager install completed ....$date1"
  echo "******************************************************************************************"

}

install_main