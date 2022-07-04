#!/usr/bin/env bash

function print_console_url_pwd () {

echo "-----------------------------------"
echo "6. Printing Event Manager console access details..."
echo "-----------------------------------"

MY_URL=$(oc get route -n $EVENT_MANAGER_NAMESPACE evtmanager-ibm-hdm-common-ui -o jsonpath={.spec.host})
MY_PASSWORD=$(oc get secret -n $EVENT_MANAGER_NAMESPACE evtmanager-was-secret -o jsonpath='{.data.WAS_PASSWORD}'| base64 --d)

echo "===================================================================================="
echo "URL : https://$MY_URL"
echo "USER: smadmin"
echo "PASSWORD: $MY_PASSWORD"
echo "===================================================================================="

}