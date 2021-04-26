#!/bin/bash

VERSION="0-12-6"
LAYER_NAME="wkhtmltopdf-wwx-$VERSION"
LAYER_ZIP="layer.zip"
REGION="eu-west-1"

printf "%s\n" "Region: $REGION"
OUTPUT=$(
    aws lambda publish-layer-version \
        --description "wkhtmltopdf $VERSION (with patched qt)" \
        --layer-name $LAYER_NAME \
        --output text \
        --query "[LayerVersionArn, Version]" \
        --region $REGION \
        --zip-file fileb://$LAYER_ZIP
)
LAYER_VERSION_ARN=$(echo $OUTPUT | awk '{print $1}')
LAYER_VERSION=$(echo $OUTPUT | awk '{print $2}')
aws lambda add-layer-version-permission \
    --action lambda:GetLayerVersion \
    --layer-name $LAYER_NAME \
    --output text \
    --principal "*" \
    --query "Statement" \
    --region "$REGION" \
    --statement-id public \
    --version-number "$LAYER_VERSION" \
    &>/dev/null
printf "\n"
exit 0
