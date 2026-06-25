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

// The web `Response` — one Web API type, so one binding for both its *read*
// side (what `fetch` resolves to) and its *construct* side (what an App Router
// route handler returns). The latter is why `make` / `redirect` live here:
// `next/navigation`'s `redirect` / `notFound` are control-flow throwers for
// pages (no custom headers; `notFound` renders the HTML page), and
// `NextServer.NextResponse`'s status is a closed 200/400/403/404/500 variant.
module Response = {
  type t = {
    ok: bool,
    status: int,
    headers: Headers.t,
    arrayBuffer: unit => promise<Js.TypedArray2.ArrayBuffer.t>,
    text: unit => promise<string>,
    json: unit => promise<JSON.t>,
  }

  // Construct: `new Response(body, init)`. Body may be null (redirects, empty
  // bodies); every `init` field is optional.
  type init = {status?: int, statusText?: string, headers?: Headers.t}
  @new external make: (Nullable.t<string>, init) => t = "Response"

  // Static `Response.redirect(url, status)`. Sets Location + status only; for
  // extra headers (e.g. `Cache-Control`) use `make` with `init.headers`.
  @val @scope("Response") external redirect: (string, int) => t = "redirect"

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

// Former name; kept so existing consumers keep compiling. Prefer `Response`.
module FetchResponse = Response

@val external fetch: (string, {..}) => promise<Response.t> = "fetch"

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
