open Errors
open Belt

type method = [#get | #post | #put]

exception JsonDecodeError(string)

module Headers = {
  type t
  @new external make: unit => t = "Headers"
  @send external append: (t, string, string) => unit = "append"
  @send external delete: (t, string, string) => unit = "delete"
  @send external set: (t, string, string) => unit = "set"
  @send external _get: (t, string) => nullable<string> = "get"
  let get = (t, string) => t->_get(string)->Nullable.toOption
  @send external has: (t, string) => bool = "has"
  @send external keys: t => array<string> = "keys"
  @send external values: t => array<string> = "values"
  @send external entries: t => array<(string, string)> = "entries"
  // missing forEach, getSetCookie
}

module FetchResponse = {
  type t = {
    ok: bool,
    status: int,
    arrayBuffer: unit => promise<Js.TypedArray2.ArrayBuffer.t>,
    text: unit => promise<string>,
    json: unit => promise<JSON.t>,
  }
  let jsonResult = async response => {
    let text = await response.text()
    try JSON.parseOrThrow(text)->Result.Ok catch {
    | JsExn(obj) =>
      switch JsExn.name(obj) {
      | Some("SyntaxError") => Result.Error(text)
      | Some(_) => throw(JsonDecodeError(obj->JsExn.message->Option.getWithDefault("")))
      | None => throw(JsonDecodeError(""))
      }
    | _ => Result.Error(text)
    }
  }
  let json = async response => await response.json()
}

@val external fetch: (string, {..}) => promise<FetchResponse.t> = "fetch"

let fetchJson = async (url: string, body: JSON.t) => {
  let options = {
    "method": #put,
    "headers": {
      "Content-Type": "application/json",
    },
    "body": body->JSON.stringify,
  }
  let res = await fetch(url, options)
  switch res.ok {
  | true => await res.json()
  | false => throw(ApiError(res.status->apiErrorFromStatus))
  }
}

let fetchJson0 = url => fetchJson(url, JSON.Encode.null)
