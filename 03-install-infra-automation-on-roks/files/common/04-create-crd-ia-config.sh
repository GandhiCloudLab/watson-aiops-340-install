#!/usr/bin/env bash

function create_crd_ia_config () {

echo "----------------------------------------------------------------------"
echo "4. Install CRD IAConfig (ibm-ia-installer) ..."
echo "----------------------------------------------------------------------"


cat << EOF | oc apply -f -
apiVersion: aiops.ibm.com/v1alpha1
kind: IAConfig
metadata:
  name: ibm-ia-installer
  namespace: $NAMESPACE
spec:
  imagePullSecret: ibm-entitlement-key
  infraAutoComposableComponents:
    - enabled: true
      name: ibm-management-im-install
      spec: {}
    - enabled: true
      name: ibm-management-cam-install
      spec: {}
  license:
    accept: true
  storageClass: $STORAGE_CLASS
  storageClassLargeBlock: $STORAGE_CLASS
EOF

echo "Process completed .... "

}