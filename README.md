# thejsonparser

The name speaks for itself. This is a JSON parser written in Elixir.

## Usage

```bash
$ iex -S mix
iex(1)> Parser.validate("tests/step1/valid.json")
```

## Run

```bash
elixirc parser.ex
$ iex
iex(1)> Parser.validate("tests/step2/valid.json")
```

## Test

A valid JSON file will return `true` and an invalid JSON file will return `false`.

