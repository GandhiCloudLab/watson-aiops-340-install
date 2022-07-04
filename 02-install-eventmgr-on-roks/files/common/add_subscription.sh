#!/bin/bash

# Make the usage stand out on the command line
USAGE=$(cat <<-END
Usage: ./add_subscription.sh <deploy namespace>  <catalogsource>

END
)

DEPLOY_NAMESPACE=${1:?"${USAGE}       - Deploy namespace argument not supplied"}
CATALOG_SOURCE=${2:?"${USAGE}       - Catalog source argument not supplied"}
IMAGE_PULL_SECRET=$3
if ! oc get namespace "${DEPLOY_NAMESPACE}" > /dev/null; then
  echo "${USAGE}       - Deploy namespace argument is invalid" >&2
  exit 1
fi



# Apply with a spec section to indicate watching a particular namespace
oc apply -f - <<END
---
apiVersion: operators.coreos.com/v1alpha2
kind: OperatorGroup
metadata:
  name: "noi-group"
  namespace: "${DEPLOY_NAMESPACE}"
spec:
  targetNamespaces:
  - ${DEPLOY_NAMESPACE}
END


oc apply -f - <<END
---
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: noi-subscription
  namespace: "${DEPLOY_NAMESPACE}"
spec:
  channel: v1.8
  installPlanApproval: Automatic
  name: noi
  source: "${CATALOG_SOURCE}"
  sourceNamespace: openshift-marketplace
  startingCSV: noi.v1.5.0
END


sleep 10


maxRetries=10
retriesRemaining=100
CAT_POD=`kubectl get pod -n openshift-operator-lifecycle-manager | grep catalog | sed "s/ .*//"`
echo CAT_POD $CAT_POD

while [ $retriesRemaining -ne "0" ]; do
  retriesRemaining=$((retriesRemaining - 1))

  kubectl get deployment
  kubectl get installplan
  kubectl describe installplan
  kubectl get csv
  COUNT=`kubectl get deployment | grep noi-operator | grep 1.1 | wc -l `
  echo COUNT $COUNT
  if [ $COUNT == 1 ]
  then
      exit 0
  fi


  echo sleeping for 10 seconds waiting for operator to startup
  sleep 10
  if [ ! -z $IMAGE_PULL_SECRET ]
  then
     POD=` kubectl get pod | grep noi-operator | grep -i image | sed "s/ .*//"`
     if [ ! -z $POD ]
     then
        kubectl delete POD $POD
        kubectl patch serviceaccount noi-operator -p '{"imagePullSecrets": [{"name": "'$IMAGE_PULL_SECRET'"}]}'
     fi
  fi

done
exit -1
