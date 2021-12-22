#!/bin/bash

# Prerequisites
# * logged in to kubernetes so that kubectl works

# Example usage:
# Connect to postgres db of your namespace
# - ./connect-to-kube-postgres.sh mynamespace service-name db-name

# set default AWS_PROFILE to testing
PROFILE=testing
# read namespace from arguments
NAMESPACE=$1
SERVICE_NAME=$2
DB_NAME=$3
DB_USER=postgres

# exit with error if last operaion failed
CheckSuccess() {
	if [ $? -ne 0 ]; then
			echo "Failed to execute $1 . Make sure you are authorized with kubectl"
			exit 1
	fi
}

# if namespace is undefined default to testing
if [ -z $1 ]; then
	echo "Please provide a namespace as argument"
	exit 1
fi

POD_NAME=$(AWS_PROFILE=$PROFILE kubectl --context=testing get pods -n ${NAMESPACE} | grep $DB_POD_NAME-db | cut -f 1 -d " ")
CheckSuccess "<retrieving pod>"

if [ -z $POD_NAME ]; then
	echo "Could not retrieve default pod name from namespace ${NAMESPACE}. Are you sure it is running?"
	exit 1
fi

echo "Connecting to pod - ${POD_NAME} - on namespace - ${NAMESPACE} - ..."
PGPASSWORD="" AWS_PROFILE=$PROFILE kubectl --context=testing exec -it -n $NAMESPACE $POD_NAME -- psql -U $DB_USER $DB_NAME
