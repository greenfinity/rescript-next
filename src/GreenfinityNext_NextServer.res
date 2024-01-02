open GreenfinityNext_Next

// --
// app routes support
// --

module NextRequest = {
  type geo = {
    city: option<string>,
    country: option<string>,
    region: option<string>,
    latitude: option<string>,
    longitude: option<string>,
  }

  type t = {
    headers: Headers.t,
    ip: option<string>,
    geo: geo,
  }

  @send external json: t => promise<Js.Json.t> = "json"
}

module NextResponse = {
  type t

  type status =
    | @as(200) Success
    | @as(400) BadRequest
    | @as(403) Forbidden
    | @as(404) NotFound
    | @as(500) ServerError

  type options = {status: status}

  exception ApiError(status)

  @module("next/server") @scope("NextResponse")
  external json: (Js.Json.t, ~options: options=?) => promise<t> = "json"
}
