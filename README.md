# Greenfinity bindings for NextJS

## Scope

Bindings for NextJS.

A drop in replacement for more official bindings.

### Next

Unofficial bindings for NextJs.

```res
open Next
```

### Fetch

Utilities to use NextJs's Fetch.

```res
open Fetch
```

### Errors

Utility module to define errors.

### Protocol and Middleware

Works with the converters generated by spice / decco, to be used with NextJs.

Example for protocol in file `GetAnswer.res`:

```res
open GreenfinityNext.Protocol

module Protocol = {
  let path = "/api/getAnswer"
  @spice
  type req = string
  @spice
  type resp = int
}

module Make = MakeProtocol(Protocol)
let make = Make.make
```

Example for a middleware that runs on the server, `Mw_GetAnswer.res`:

```res
open GetAnswer

module Middleware = {
  include Protocol
  let processIt = async (question: Protocol.req, _: Content.Types.user): Protocol.resp =>
    switch question {
      | "How many Vogons does it take to change a lightbulb?" => 42
      | _ => 0
    }
}

module Default = MakeMiddleware(Middleware)
let default = Default.default
```

Api route imports the middleware, from file `pages/api/getAnswer.js`:

```js
import Mw_GetTopicTypes from "../../src/api/get-topic-types/Mw_GetAnswer.bs.js";
export default function GetTopicTypes(req, res) {
  return Mw_GetTopicTypes(req, res);
}
```

Calling the api route from the client side,

```res
let answer = await GetAnswer.make("How many Vogons does it take to change a lightbulb?")
```

### Converter

Conversion between Rescript records and abstract objects in a type-safe way. One possible use case is to convert records to and from a database.

Example with one-on-one type conversion:

```res

module Converter = GreenfinityTypeUtils.Make({
  @spice
  type t = myType
  let assignFromStorage = _ => Js.Obj.empty()
  let assignToStorage = _ => Js.Obj.empty()
})

open Converter

// converting a value to an abstract object
myValue->toStorage

// converting a value from an abstract object
o->fromStorage
```

There are variant to convert from a storage with nullable or optional objects:

```res
// converting a value from a nullable abstract object
o->fromStorageNullable->Option.getExn

// converting a value from an optional abstract object
a[0]->fromStorageOptional->Option.getExn
```

Example with additional conversion. The dictionary returned will be assigned to the object after converting to (or before converting from) a record.

`Storage_Converter.ResultField` contains some conversion functions.

```res
external toJs: 't => {..} = "%identity"

module Converter = Storage_Converter.Make({
  @spice
  type t = myType
  let assignFromStorage = topic =>
    {
      "topic_id": (topic->toJs)["topic_id"]->Storage_Converter.ResultField.int64,
    }->toJs
  let assignToStorage = topic =>
    {
      "topic_id": (topic->toJs)["topic_id"]->Storage_Converter.ResultField.int64,
    }->toJs
})
```

`toJs` is an annoyance and it's currently needed to make the abstract type less specific, avoiding a type error.
