ruby-amqp-publish-files
=======================

:boom: **Strongly consider using [ModCloth's amqp-tools](https://github.com/modcloth/amqp-tools) instead.** :boom:

## General

Reads file names from STDIN and publishes their content over AMQP

Run with `-h` or `--help` to get the usage message.

## Usage

```bash
Options:
          --uri, -u <s>:   Full AMQP uri (default: amqp://guest:guest@localhost:5672)
  --routing-key, -r <s>:   Publish message to this routing key
     --exchange, -e <s>:   Publish message to this exchange
          --verbose, -v:   Verbose mode
             --help, -h:   Show this message
```

## Examples

```bash
# single file
echo '/path/to/file.json' | amqp_publisher.rb -r 'routing.key' -e 'exchange'

# multiple files
find /path/to/files -type f -name '*.json' | amqp_publisher.rb -r 'routing.key' -e 'exchange'
```

