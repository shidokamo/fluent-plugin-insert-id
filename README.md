# fluent-plugin-insert-id

[Fluentd](https://fluentd.org/) filter plugin to insert unique ID string into the message.

The original implementation was copied from [fluent-plugin-google-cloud](https://github.com/GoogleCloudPlatform/fluent-plugin-google-cloud)
which was created by Google to handle GCP GKE's official Stackdriver Logging reporting in sidecar container for each pod.
Original source requires fluentd v0.12 and doesn't support fluentd v1.0 but this plugin only supports fluentd v1.0.

## How it works
```
# Input message
{"a": "foo", "b": "bar"}
{"a": "foo", "b": "bar"}
{"a": "foo", "b": "bar"}
{"a": "foo", "b": "bar"}
{"a": "foo", "b": "bar"}

# Output message
2019-08-25 21:20:43.539536458 +0000 message.test: {"a":"foo","b":"bar","insert-id":"nu8a3ptahpbetddw"}
2019-08-25 21:20:44.625784851 +0000 message.test: {"a":"foo","b":"bar","insert-id":"nu8a3ptahpbetddx"}
2019-08-25 21:20:45.579060596 +0000 message.test: {"a":"foo","b":"bar","insert-id":"nu8a3ptahpbetddy"}
2019-08-25 21:20:47.019565139 +0000 message.test: {"a":"foo","b":"bar","insert-id":"nu8a3ptahpbetddz"}
2019-08-25 21:20:50.035415329 +0000 message.test: {"a":"foo","b":"bar","insert-id":"nu8a3ptahpbetdea"}
```

* It is guaranteed that ID is fixed length string which contains 0-9 and a-z lowercase characters.
* Initial ID generated is random string like "nu8a3ptahpbetddc".
* Series ID after the initial ID are 'incremented' string which uses Ruby's `String.next()`.
* 'incremented' string also has 'carry' feature. Please check below links for more details.
  * [String.next()](https://ruby-doc.org/core-2.4.0/String.html#method-i-next)
  * [String.next() (Japanese)](https://docs.ruby-lang.org/ja/2.4.0/class/String.html#I_NEXT)
* This ordered ID makes debugging easier in most cases.

## Installation

### RubyGems

```
$ gem install fluent-plugin-insert-id
```

### Bundler

Add following line to your Gemfile:

```ruby
gem "fluent-plugin-insert-id"
```

And then execute:

```
$ bundle
```

## Configuration

You can generate configuration template:

```
$ fluent-plugin-config-format filter insert-id
```

You can copy and paste generated documents here.

## Copyright

* Copyright(c) 2019- Kamome Shido
* Copyright(c) 2014- Google Inc. All rights reserved.
* License
  * Apache License, Version 2.0
