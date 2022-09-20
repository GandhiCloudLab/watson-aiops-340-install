#!/usr/bin/env bash

function create_subscription() {

echo "----------------------------------------------------------------------"
echo "2. Install operators"
echo "----------------------------------------------------------------------"

### Install the IBM Automation Foundation operator (Subscription)
echo "----------------------------------------------------------------------"
echo "2.1 Install operator (Subscription : ibm-automation)"
echo "----------------------------------------------------------------------"
cat << EOF | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-automation
  namespace: openshift-operators
spec:
  channel: $SUBSCRIPTION_CHANNEL_IAF
  installPlanApproval: Automatic
  name: ibm-automation
  source: ibm-operator-catalog
  sourceNamespace: openshift-marketplace
  startingCSV: $SUBSCRIPTION_STARTINGCSV_IAF
EOF

sleep 80

### Install the Infrastructure Automation operator (Subscription)
echo "----------------------------------------------------------------------"
echo "2.2 Install operator (Subscription : ibm-infrastructure-automation-operator)"
echo "----------------------------------------------------------------------"
cat << EOF | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-infrastructure-automation-operator
  namespace: $NAMESPACE
spec:
  channel: $SUBSCRIPTION_CHANNEL_IA
  installPlanApproval: Automatic
  name: ibm-infrastructure-automation-operator
  source: ibm-operator-catalog
  sourceNamespace: openshift-marketplace
  startingCSV: $SUBSCRIPTION_STARTINGCSV_IA
EOF

sleep 5

echo "Process completed .... "

}


