# fluent-plugin-insert-id

[Fluentd](https://fluentd.org/) filter plugin to insert unique ID string into the message.

The original implementation was copied from [fluent-plugin-google-cloud](https://github.com/GoogleCloudPlatform/fluent-plugin-google-cloud)
which was created by Google to handle GCP GKE's official Stackdriver Logging reporting in sidecar container for each pod.
Original source requires fluentd v0.12 and doesn't support fluentd v1.0 but this plugin only supports fluentd v0.14 or later.

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

* Inserted ID contains 0-9 and a-z lowercase characters.
* Initial ID generated is random string like "nu8a3ptahpbetddc".
* Series ID after the initial ID are 'incremented' string which uses Ruby's `String.next()`.
* 'incremented' string also has 'carry' feature. Please check below links for more details.
  * [String.next()](https://ruby-doc.org/core-2.4.0/String.html#method-i-next)
  * [String.next() (Japanese)](https://docs.ruby-lang.org/ja/2.4.0/class/String.html#I_NEXT)
* This ordered ID makes debugging easier in most cases.

#### ID string length
* **From version 1.1.0, it is guaranteed that ID is fixed length string.**
* **In version 1.0.0, the ID string length is incremented when carry happens at left-most characters.**

```ruby
# Version 1.0.0
{"a":"foo","b":"bar","insert-id":"z99999999999999z"}
{"a":"foo","b":"bar","insert-id":"aa00000000000000z"} # Left most character carry adds new digit.

# Version 1.1.0
{"a":"foo","b":"bar","insert-id":"z99999999999999z"}
{"a":"foo","b":"bar","insert-id":"a00000000000000z"} # Left most character carry is ignored.
```

#### Existing ID protection
If the message already has the key for inserted ID, the filter doesn't touch it and
existing value is protected.

```
2019-08-27 02:10:07.422911774 +0000 message.test: {"a":"foo","b":"bar","insert-id":"ehrbwzp772xitjsv"}
2019-08-27 02:10:08.129842499 +0000 message.test: {"a":"foo","b":"bar","insert-id":"ehrbwzp772xitjsw"}
2019-08-27 02:10:08.940316454 +0000 message.test: {"a":"foo","b":"bar","insert-id":"ehrbwzp772xitjsx"}
2019-08-27 02:11:02.498772740 +0000 message.test: {"a":"foo","b":"bar","insert-id":"existing_ID"}
2019-08-27 02:11:06.802934944 +0000 message.test: {"a":"foo","b":"bar","insert-id":"ehrbwzp772xitjsy"}
```

## Requirements

| fluent-plugin-insert-id  | fluentd | ruby |
|--------------------------|---------|------|
| >= 1.0.0 | >= v0.14.x | >= 2.1 |

fluentd v0.12 is not supported.

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

**insert_id_key** (string) (optional)

The key of inserted-id.
Default value is `"insert-id"`.

## Usage : Insert ID with default key
```aconf
<filter **>
  @type insert_id
</filter>
```

## Usage : Insert ID with custom key
In this case, key of ID is changed to 'message_id'
```aconf
<filter **>
  @type insert_id
  insert_id_key message_id
</filter>
```

## Copyright

* Copyright(c) 2019- Kamome Shido
* Copyright(c) 2014- Google Inc. All rights reserved.
* License
  * Apache License, Version 2.0
