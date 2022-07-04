#!/usr/bin/env bash

function patch_serviceaccount_ibm_operator_catalog () {

echo "----------------------------------------------------------------------"
echo " 2. Patch imagePullSecrets in the resource : serviceaccount (ibm-operator-catalog) in  openshift-marketplace namespace and patch it with imagePullSecrets"
echo "----------------------------------------------------------------------"

RESOURCE_COUNT=0
RESOURCE_FOUND=false
LOOP_COUNT=0
MAX_LOOP_COUNT=180

while [[ ${RESOURCE_FOUND} == "false" && $LOOP_COUNT -lt $MAX_LOOP_COUNT ]]; do
    LOOP_COUNT=$((LOOP_COUNT+1))
    echo "Trying for $LOOP_COUNT / $MAX_LOOP_COUNT."

    RESOURCE_COUNT=$(oc get serviceaccount noi-catalog -n openshift-marketplace | wc -l)

    if [[ $RESOURCE_COUNT -gt 1 ]]; 
    then
        RESOURCE_FOUND=true
    else
        RESOURCE_FOUND=false
        sleep 5
    fi
done

if [[ $RESOURCE_FOUND == "true" ]]; 
then
    echo "Resource found (serviceaccount noi-catalog)"
    echo "Patch serviceaccount with imagePullSecrets"
    oc patch -n openshift-marketplace serviceaccount noi-catalog -p '{"imagePullSecrets": [{"name": "ibm-entitlement-key"}]}'
    oc patch -n openshift-marketplace serviceaccount default -p '{"imagePullSecrets": [{"name": "ibm-entitlement-key"}]}'

    echo " Delete Pods with ImagePullBackoff issue"
    oc delete pod $(oc get po -n openshift-marketplace|grep ImagePull|awk '{print$1}') -n openshift-marketplace

    echo " Sleep for 5 seconds"
    sleep 5
else
    echo "Resource Not found (serviceaccount noi-catalog)"
fi
}
