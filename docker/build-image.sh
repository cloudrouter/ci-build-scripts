#!/usr/bin/env bash

DISTRO=$1

function usage {
  printf "usage:  $0 DISTRO\n"
  printf "Allowed DISTRO values: [centos | fedora]\n"
}

if [ -z ${DISTRO} ]
then
	echo "Error - No DISTRO provided"
	usage
	exit 1
fi

case ${DISTRO} in
  "fedora")
    : ${IMAGE:="cloudrouter/rpmbuilder-fedora:latest"}
    ;;
  "centos")
    : ${IMAGE:="cloudrouter/rpmbuilder-centos:latest"}
    ;;
  *)
    printf "ERROR: Invalid \$DISTRO specified. Exiting.\n" >&2
    usage
    exit 1
esac

function check_var {
  VAR_NAME=${!1}
  if [ -z "${!VAR_NAME}" ]; then
    printf "ERROR: No \$${VAR_NAME} specified. Exiting.\n" >&2
    usage
    exit 1
  fi
}

# Ensures that all the required parameters are specified
for VAR in IMAGE
do
  check_var VAR
done

docker build -t ${IMAGE} .
docker push ${IMAGE}
