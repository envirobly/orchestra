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
ruby -Ilib bin/orchestra services up --config-dir tmp/envirobly-etc --config-bucket envirobly-config-93d409cc --event-url http://localhost:1337 --authorization ABCD

# then stop those services:
ruby -Ilib bin/orchestra services down --config-dir tmp/envirobly-etc
```

### Traefik dynamic config

Testing locally:

```sh
mkdir -p /tmp/orchestra/etc/traefik

ruby -Ilib bin/orchestra traefik fetch_dynamic_config_files --url https://example.com/123 --authorization "Bearer 123" --config-dir /tmp/orchestra/etc/traefik
```
