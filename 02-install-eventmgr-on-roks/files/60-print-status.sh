#!/usr/bin/env bash

source ./00-config.sh

echo "******************************************************************************************"

echo "-----------------------------------"
echo "1. Namespace $EVENT_MANAGER_NAMESPACE"
echo "-----------------------------------"
oc get ns $EVENT_MANAGER_NAMESPACE

echo "-----------------------------------"
echo "2. Secrets"
echo "-----------------------------------"
oc describe secret noi-registry-secret -n $EVENT_MANAGER_NAMESPACE

echo "-----------------------------------"
echo "3. OperatorGroup"
echo "-----------------------------------"
oc describe OperatorGroup cp4waiops-operator-group -n $EVENT_MANAGER_NAMESPACE

echo "-----------------------------------"
echo "4. CatalogSource"
echo "-----------------------------------"
oc describe CatalogSource ibm-noi-catalog -n openshift-marketplace

echo "-----------------------------------"
echo "5. Subscription"
echo "-----------------------------------"
oc describe Subscription ibm-noi-catalog-subscription -n $EVENT_MANAGER_NAMESPACE

echo "-----------------------------------"
echo "6. NOI CRD"
echo "-----------------------------------"
oc describe NOI evtmanager -n $EVENT_MANAGER_NAMESPACE

echo "******************************************************************************************"
