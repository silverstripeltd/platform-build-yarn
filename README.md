# Platform Build Yarn

Transforms a SilverStripe source code into a deployable state with Composer and Node

This image is different from [silverstripeltd/platform-build](https://github.com/silverstripeltd/platform-build) in that it runs `yarn` and `yarn run` as well as composer. 


## What is this?

This is a docker container that runs multiple commands:

 - If a `composer.json` file is present:
   - composer validate
   - composer install --no-progress --prefer-dist --no-dev --ignore-platform-reqs --optimize-autoloader --no-interaction --no-suggest
   - The silverstripe [vendor plugin](https://github.com/silverstripe/vendor-plugin-helper) `vendor-plugin-helper copy ./`
 - If a `package.json` file is present:
   - `yarn` or `npm install` (based on the presence of a `yarn.lock` file)
   - `yarn run production` or `npm run production`

## Example usage

```
docker run \
    --interactive \
    --tty \
    --volume composer_cache:/tmp/cache \
    --volume ~/.ssh/id_rsa:/root/.ssh/id_rsa:ro \
    --volume $PWD:/app \
    silverstripe/platform-build-yarn
```

`--volume composer_cache:/tmp/cache`

Creates a composer_cache volume if it doesn't exists and mounts that into the composer home folder `tmp`

`--volume ~/.ssh/id_rsa:/root/.ssh/id_rsa`

If your source code has private repositories, you will need to mount the private key (deploy key) into the container (preferable as read only)

`--volume $PWD:/app`

The source code will be build from the `/app` 'inside' the container, so make sure you mount source code into that
