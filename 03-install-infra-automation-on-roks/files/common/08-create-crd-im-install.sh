#!/usr/bin/env bash

function create_crd_im_install () {

echo "----------------------------------------------------------------------"
echo "8. Install CRD IMInstall (ibm-ia-installer) ..."
echo "----------------------------------------------------------------------"

YOUR_IM_HTTPD_ROUTE=$(oc get route -n ibm-common-services cp-console -o jsonpath={.spec.host})
echo "YOUR_IM_HTTPD_ROUTE before ==> $YOUR_IM_HTTPD_ROUTE" 

YOUR_IM_HTTPD_ROUTE=$(echo $YOUR_IM_HTTPD_ROUTE | sed "s/cp-console/inframgmt/")
echo "YOUR_IM_HTTPD_ROUTE after ==> $YOUR_IM_HTTPD_ROUTE" 

cat << EOF | oc apply -f -
apiVersion: infra.management.ibm.com/v1alpha1
kind: IMInstall
metadata:
  labels:
    app.kubernetes.io/instance: ibm-infra-management-install-operator
    app.kubernetes.io/managed-by: ibm-infra-management-install-operator
    app.kubernetes.io/name: ibm-infra-management-install-operator
  name: im-iminstall
  namespace: $NAMESPACE
spec:
  applicationDomain: $YOUR_IM_HTTPD_ROUTE
  imagePullPolicy: Always
  imagePullSecret: ibm-entitlement-key
  initialAdminGroupName: $YOUR_LDAP_USER_GROUP
  license:
    accept: true  
EOF


echo "Process completed .... "

}

