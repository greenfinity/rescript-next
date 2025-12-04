// --
// app routes support
// --

module NextRequest = {
  @deprecated("Use Cookies instead")
  module Cookies = Cookies

  module URL = {
    type t = {
      ...Url.URL.t,
      // According to the docs, these should exist:
      // basePath: string,
      // buildId?: string,
    }
  }

  type geo = {
    city: option<string>,
    country: option<string>,
    flag: option<string>,
    countryRegion: option<string>,
    region: option<string>,
    latitude: option<string>,
    longitude: option<string>,
    postalCode: option<string>,
  }

  type t = {
    headers: Fetch.Headers.t,
    nextUrl: URL.t,
    cookies: GreenfinityNext.Cookies.t,
  }

  @send external json: t => promise<JSON.t> = "json"

  @module("@vercel/functions") external geolocation: t => geo = "geolocation"
  @module("@vercel/functions") external ipAddress: t => option<string> = "ipAddress"
}

module NextResponse = {
  type t

  type status =
    | @as(200) Success
    | @as(400) BadRequest
    | @as(403) Forbidden
    | @as(404) NotFound
    | @as(500) ServerError

  exception ApiError(status)

  type options = {status?: status, statusText?: string, headers?: Fetch.Headers.t}

  @module("next/server") @new
  external make: ('a, ~options: options=?) => promise<t> = "NextResponse"
  @module("next/server") @scope("NextResponse")
  external json: (JSON.t, ~options: options=?) => promise<t> = "json"

  /* `next` can be called either with
   * `{request: {headers}}` or with `{headers}`.
   */
  type nextOptionsHeaders = {headers: Fetch.Headers.t}
  type nextOptions = {
    request?: nextOptionsHeaders,
    headers?: Fetch.Headers.t,
  }
  @module("next/server") @scope("NextResponse")
  external next: nextOptions => t = "next"
}

module Middleware = {
  type config = {matcher: array<string>}
}
