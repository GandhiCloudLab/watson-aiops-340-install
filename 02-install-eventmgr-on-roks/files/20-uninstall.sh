#!/usr/bin/env bash

source ./00-config.sh

date1=$(date '+%Y-%m-%d %H:%M:%S')
echo "******************************************************************************************"
echo " IBM Cloud Pak for Watson AIOps Event Manager delete started ....$date1"
echo "******************************************************************************************"



echo "-----------------------------------"
echo "1. NOI CRD"
echo "-----------------------------------"
oc delete NOI evtmanager -n $EVENT_MANAGER_NAMESPACE

echo "-----------------------------------"
echo "2. Subscription"
echo "-----------------------------------"
oc delete Subscription ibm-noi-catalog-subscription -n $EVENT_MANAGER_NAMESPACE

echo "-----------------------------------"
echo "3. CatalogSource"
echo "-----------------------------------"
oc delete CatalogSource ibm-noi-catalog -n openshift-marketplace

echo "-----------------------------------"
echo "4. OperatorGroup"
echo "-----------------------------------"
oc delete OperatorGroup cp4waiops-operator-group -n $EVENT_MANAGER_NAMESPACE

echo "-----------------------------------"
echo "5. Secrets"
echo "-----------------------------------"
oc delete secret noi-registry-secret -n $EVENT_MANAGER_NAMESPACE

echo "-----------------------------------"
echo "6. Namespace $EVENT_MANAGER_NAMESPACE"
echo "-----------------------------------"
oc delete ns $EVENT_MANAGER_NAMESPACE


date1=$(date '+%Y-%m-%d %H:%M:%S')
echo "******************************************************************************************"
echo " IBM Cloud Pak for Watson AIOps Event Manager delete Completed ....$date1"
echo "******************************************************************************************"
