#!/bin/bash
set -o pipefail

GOVERSION=$1

go clean -modcache

bump_go_version () {
    go mod edit -go=$GOVERSION
    go get -u ./...
    go mod tidy --compat=$GOVERSION
}

# bump go version in base v3 directory
bump_go_version


# bump go version and deps in all integration packages
echo "Updating all integrations and their dependencies to be compatible with go version $GOVERSION"
for DIR in $(find ./integrations -type d)
do
    cd $DIR
    bump_go_version | true
    cd -
done


