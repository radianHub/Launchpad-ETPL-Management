## CREATE SCRATCH ORG
project="lp-etpl"
branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
scratchOrgName="$project-$branch"

# sf org create scratch -f [SCRATCH ORG DEF PATH] -a [ORG ALIAS] -y [DAYS ACTIVE] -w [WAIT TIME IN MINUTES]
sf org create scratch -f ./config/project-scratch-def.json -a "$scratchOrgName" -y 30 -w 60 -d

## DEPLOY FORCEAPP
# sf project deploy start -d [PATH] -o [TARGET ORG]
sf project deploy start -d force-app -o "$scratchOrgName"

## Install Base WFD Package v3.10
sf package install -p 04t4w000000tPyD -k wfd#install!winter24 -w 60

## Install PIRL package
sf package install -p 04tJ2000000kZkmIAE -w 60


