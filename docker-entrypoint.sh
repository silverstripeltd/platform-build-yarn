#!/usr/bin/env bash
set -e

source /funcs.sh

function nvm_switch {
	if [[ -f ".nvmrc" ]]; then
		echo "Running: Apply NVM Configuration"
		. /root/.nvm/nvm.sh
		nvm use
		which node
	fi
}

function npm_build {
	if [[ -f "yarn.lock" ]]; then
		echo "Running: Yarn Dependency Installation"
		yarn --no-progress --non-interactive

		echo "Running: Yarn Production Build Task"
		yarn run --no-progress --non-interactive scp-build
	else
		echo "Running: NPM Dependency Installation"
		npm install

		echo "Running: NPM Production Build Task"
		npm run --no-progress --non-interactive scp-build
	fi

	echo "Running: Purge Node Modules"
	rm -rf node_modules/
}

function composer_build {
	echo "Running: Composer Production Build Task"
	composer run-script scp-build
}

if [[ -d ".git" ]]; then
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

# Run NPM/Yarn build script if the scp-build command is defined
if [[ -f package.json && "`cat package.json | jq '.scripts["scp-build"]?'`" != "null" ]]; then
    nvm_switch

    npm_build
fi

# Run Composer build script if the scp-build command is defined
if [[ -f composer.json && "`cat composer.json | jq '.scripts["scp-build"]?'`" != "null" ]]; then
	composer_build
fi

package_source ${SHA}
