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
```

### under docker

```sh
bin/docker-run version

# Starting sample services when bin/dev is running:
bin/docker-run services up --config-dir /etc/envirobly --config-bucket orchestra-development/stack-A --config-region eu-central-1 --event-url http://host.docker.internal:1337 --authorization ABCD

bin/docker-run services down --config-dir /etc/envirobly
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
