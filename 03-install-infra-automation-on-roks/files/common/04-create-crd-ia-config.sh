#!/usr/bin/env bash

function create_crd_ia_config () {

echo "----------------------------------------------------------------------"
echo "4. Install CRD IAConfig (ibm-ia-installer) ..."
echo "----------------------------------------------------------------------"

YOUR_IM_HTTPD_ROUTE=$(oc get route -n ibm-common-services cp-console -o jsonpath={.spec.host})
echo "YOUR_IM_HTTPD_ROUTE before ==> $YOUR_IM_HTTPD_ROUTE" 

YOUR_IM_HTTPD_ROUTE="inframgmtinstall.$YOUR_IM_HTTPD_ROUTE"
echo "YOUR_IM_HTTPD_ROUTE after ==> $YOUR_IM_HTTPD_ROUTE" 


cat << EOF | oc apply -f -
kind: IAConfig
apiVersion: aiops.ibm.com/v1alpha1
metadata:
  name: ibm-ia-installer
  namespace: $NAMESPACE
spec:
  imagePullSecret: ibm-entitlement-key
  infraAutoComposableComponents:
    - enabled: true
      name: ibm-management-im-install
      spec:
        iminstall:
          applicationDomain: $YOUR_IM_HTTPD_ROUTE
          imagePullPolicy: Always
          imagePullSecret: ibm-entitlement-key
          initialAdminGroupName: $YOUR_LDAP_USER_GROUP
          license:
            accept: true
    - enabled: true
      name: ibm-management-cam-install
      spec: {}
  license:
    accept: true
  storageClass: $STORAGE_CLASS
  storageClassLargeBlock: $STORAGE_CLASS_LARGE_BLOCK
EOF

echo "Process completed .... "

}