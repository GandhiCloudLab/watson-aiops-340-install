#!/usr/bin/env bash

function verify_event_manager_operator() {

echo "----------------------------------------------------------------------"
echo "3. Verify Event Manager operator subscription installation .."
echo "----------------------------------------------------------------------"

echo "Executing the below command ...."
echo "oc get csv -n $EVENT_MANAGER_NAMESPACE | grep Event Manager"
echo "The output should be like this...."
echo "NAME         DISPLAY                                        VERSION   REPLACES   PHASE"
echo "noi.v1.3.5   IBM Cloud Pak for Watson AIOps Event Manager   1.3.5                Succeeded"

export GLOBAL_POD_VERIFY_STATUS=false

RESOURCE_COUNT=0
RESOURCE_FOUND=false
LOOP_COUNT=0
MAX_LOOP_COUNT=180

while [[ ${RESOURCE_FOUND} == "false" && $LOOP_COUNT -lt $MAX_LOOP_COUNT ]]; do
    LOOP_COUNT=$((LOOP_COUNT+1))
    echo "Trying for $LOOP_COUNT / $MAX_LOOP_COUNT."

    RESOURCE_COUNT=$(oc get csv -n ${EVENT_MANAGER_NAMESPACE} | grep "noi" | grep -c Succeeded)

    if [[ $RESOURCE_COUNT -gt 0 ]]; 
    then
        RESOURCE_FOUND=true
    else
        RESOURCE_FOUND=false
        sleep 5
    fi
done


if [[ $RESOURCE_FOUND == "true" ]]; 
then
    echo "Resource found (IBM Cloud Pak for Watson AIOps Event Manager csv)"
    export GLOBAL_POD_VERIFY_STATUS=true
else
    echo "Resource Not found (IBM Cloud Pak for Watson AIOps Event Manager csv). Terminating.. Retry the install "
    export GLOBAL_POD_VERIFY_STATUS=false
fi


echo "STATS11: ${GLOBAL_POD_VERIFY_STATUS} "


echo "Process completed .... "

}