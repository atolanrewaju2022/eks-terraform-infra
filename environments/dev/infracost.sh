#! /bin/bash

terraform init
terraform plan -out tfplan.binary
terraform show -json tfplan.binary > plan.json
export INFRACOST_API_KEY=ico-pXyHSooFPKX2CxeDLt9OSMhjHdxgGCFF
infracost breakdown --path plan.json
