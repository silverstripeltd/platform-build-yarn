#!/usr/bin/env bash
set -e

source /funcs.sh

function yarn_install {
	echo "Running: Yarn Dependency Installation"
	yarn --no-progress --non-interactive

	echo "Running: Webpack Production Build"
	yarn run --no-progress --non-interactive production

	echo "Running: Purge Node Modules"
	rm -rf node_modules/
}

if [ -d ".git" ]; then
    SHA=$(git rev-parse HEAD)
else
    echo "Unable to determine SHA, failing."
    exit 1
fi

if [[ "z${IDENT_KEY}" == "z" ]]; then
    echo "No deploy key set"
else
    mkdir -p ~/.ssh
    echo "${IDENT_KEY}" > ~/.ssh/id_rsa
    chmod 0600 ~/.ssh/id_rsa
    echo "Using deploy key"
fi

composer_install

vendor_expose

yarn_install

package_source ${SHA}
