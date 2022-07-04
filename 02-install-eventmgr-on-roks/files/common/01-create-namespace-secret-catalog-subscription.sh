#!/usr/bin/env bash

function create_namespace_secret_catalog_subscription() {

echo "----------------------------------------------------------------------"
echo "1. Creating - Namespace, Secrets, Operator Group, CatalogSource and Subscription"
echo "----------------------------------------------------------------------"

echo "-----------------------------------"
echo "1.1. Create namespace $EVENT_MANAGER_NAMESPACE ..."
echo "-----------------------------------"
oc create namespace $EVENT_MANAGER_NAMESPACE

sleep 3

### Create secrets
echo "-----------------------------------"
echo "1.2. Create secrets"
echo "-----------------------------------"

oc create secret docker-registry noi-registry-secret \
    --docker-username=cp\
    --docker-password=$ENTITLEMENT_KEY \
    --docker-server=cp.icr.io \
    --namespace=$EVENT_MANAGER_NAMESPACE

oc create secret docker-registry ibm-entitlement-key \
    --docker-username=cp\
    --docker-password=$ENTITLEMENT_KEY \
    --docker-server=cp.icr.io \
    --namespace=$EVENT_MANAGER_NAMESPACE

    oc create secret docker-registry noi-registry-secret \
        --docker-username=cp\
        --docker-password=$ENTITLEMENT_KEY \
        --docker-server=cp.icr.io \
        --namespace=openshift-marketplace

      
      oc create secret docker-registry ibm-entitlement-key \
          --docker-username=cp\
          --docker-password=$ENTITLEMENT_KEY \
          --docker-server=cp.icr.io \
          --namespace=openshift-marketplace


          oc create secret docker-registry noi-registry-secret \
              --docker-username=cp\
              --docker-password=$ENTITLEMENT_KEY \
              --docker-server=cp.icr.io \
              --namespace=openshift-operators

          
          oc create secret docker-registry ibm-entitlement-key \
              --docker-username=cp\
              --docker-password=$ENTITLEMENT_KEY \
              --docker-server=cp.icr.io \
              --namespace=openshift-operators




sleep 3

cat <<EOF | oc apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: noi-service-account
  namespace: $EVENT_MANAGER_NAMESPACE
  labels:
    managedByUser: 'true'
imagePullSecrets:
  - name: ibm-entitlement-key
EOF


### Create OperatorGroup
echo "-----------------------------------"
echo "1.3. Create OperatorGroup ..."
echo "-----------------------------------"
cat << EOF | oc apply -f -
apiVersion: operators.coreos.com/v1alpha2
kind: OperatorGroup
metadata:
  name: noi-group
  namespace: $EVENT_MANAGER_NAMESPACE
spec:
  targetNamespaces:
  - $EVENT_MANAGER_NAMESPACE
EOF


### Create CatalogSource
echo "-----------------------------------"
echo "1.4. Create CatalogSource"
echo "-----------------------------------"
cat << EOF | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: noi-catalog
  namespace: openshift-marketplace
spec:
  displayName: noi-catalog
  publisher: IBM
  sourceType: grpc
  image: icr.io/cpopen/ibm-operator-catalog:latest
  updateStrategy:
    registryPoll:
      interval: 45m
EOF

  
sleep 3

### Install Event Manager operator (Subscription)
echo "-----------------------------------"
echo "1.5. Install Event Manager operator (Subscription)"
echo "-----------------------------------"
cat << EOF | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: noi-subscription
  namespace: $EVENT_MANAGER_NAMESPACE
spec:
  channel: $EVENT_MANAGER_CHANNEL
  installPlanApproval: Automatic
  name: noi
  source: noi-catalog
  sourceNamespace: openshift-marketplace
  startingCSV: $EVENT_MANAGER_STARTING_CSV
EOF

sleep 90

echo "Process completed .... "

}