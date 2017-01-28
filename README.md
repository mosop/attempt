# Attempt

A tiny Crystal library for trying code blocks again and again.

[![Build Status](https://travis-ci.org/mosop/attempt.svg?branch=master)](https://travis-ci.org/mosop/attempt)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  attempt:
    github: mosop/attempt
```

## Code Samples

### Trying 5 Times

```crystal
response = Attempt.times(5).start do
  begin
    response = HTTP::Client.get("http://unstable.net")
    break response if response.success?
  rescue
  end
end

if response
  puts response.body
else
  raise "UNSTABLE!"
end
```

### Wait 60 Sec. Before a Retry

```crystal
response = Attempt.times(5).wait(60).start do
  begin
    response = HTTP::Client.get("http://unstable.net")
    break response if response.success?
  rescue
  end
end
```

### Every Hour Forever

```crystal
Attempt.wait(60 * 60).start do
  begin
    response = HTTP::Client.get("http://api.cat.pics/links.json")
    File.write("/path/to/kitty.json", response.body) if response.success?
  rescue
  end
end
```

### Wait 10 Sec. Before the First Attempt

```crystal
`rails s`
response = Attempt.prewait(10).start do
  begin
    response = HTTP::Client.get("http://localhost:3000")
    break response if response.success?
  rescue
  end
end
```

## Usage

```crystal
require "attempt"
```

<!--
and see [API Document](http://mosop.me/attempt/Attempt.html).
-->
