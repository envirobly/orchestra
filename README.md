# Orchestra

SiliconSail container orchestrator.

## Requirements

```sh
brew install docker-credential-helper-ecr
```

Edit `~/.docker/config` to contain:

```json
{
	"credsStore": "ecr-login",
}
```

## Running CLI commands in development

```sh
ruby -Ilib bin/orchestra version

# Starting sample services when bin/dev is running:
ruby -Ilib bin/orchestra services up --config-dir tmp/envirobly-etc --config-bucket orchestra-development/stack-A --config-region eu-central-1 --event-url http://localhost:1337 --authorization ABCD

# then stop those services:
ruby -Ilib bin/orchestra services down --config-dir tmp/envirobly-etc

# Building and pushing and image
ruby -Ilib bin/orchestra images build --git-url https://git-codecommit.eu-north-1.amazonaws.com/v1/repos/envirobly-fbcd116e22 --commit-id c3f5d057ab10794efa2544620fa5c2500e2a13e6 --cache-bucket envirobly-build-cache-fbcd116e22 --cache-region eu-north-1 --image-uri 406367475671.dkr.ecr.eu-north-1.amazonaws.com/envirobly-fbcd116e22:c48387cb7af279f764ee3b8b410760fb4db712a8e746826e225456fe31d05327 --dockerfile Dockerfile --build-context .
```

### under docker

```sh
bin/docker-run version

# Starting sample services when bin/dev is running:
bin/docker-run services up --config-dir /etc/envirobly --config-bucket orchestra-development/stack-A --config-region eu-central-1 --event-url http://host.docker.internal:1337 --authorization ABCD

bin/docker-run services down --config-dir /etc/envirobly

# Building and pushing and image
docker run --name orchestra \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v $PWD/.docker/config.json:/root/.docker/config.json \
	-v $HOME/.aws:/root/.aws \
	--rm \
	-e AWS_PROFILE=client1 \
	envirobly/orchestra orchestra \
	images build --git-url https://git-codecommit.eu-north-1.amazonaws.com/v1/repos/envirobly-fbcd116e22 --commit-id c3f5d057ab10794efa2544620fa5c2500e2a13e6 --cache-bucket envirobly-build-cache-fbcd116e22 --cache-region eu-north-1 --image-uri 406367475671.dkr.ecr.eu-north-1.amazonaws.com/envirobly-fbcd116e22:c48387cb7af279f764ee3b8b410760fb4db712a8e746826e225456fe31d05327 --dockerfile Dockerfile --build-context .
```

## Lock testing

```sh
ruby -Ilib bin/orchestra services lock --config-dir tmp/envirobly-etc
ruby -Ilib bin/orchestra services lock --config-dir tmp/envirobly-etc
```

# Builds

Proof of concept building inside the container:

```sh
docker run --name orchestra \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v $HOME/envirobly/benchpress:/app \
	-v $HOME/.aws:/root/.aws \
	-it \
	--rm \
	envirobly/orchestra \
	sh

cd /app
export DOCKER_BUILDKIT=1
docker build . -f Dockerfile -t benchpress:latest
```

