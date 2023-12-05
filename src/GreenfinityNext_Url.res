// Not strictlyr nextjs Url support

module SearchParams = {
  type value
  external unsafeArray: value => Js.Array2.t<string> = "%identity"

  type t = Js.Dict.t<value>
  let all = value => Js.Array2.concat([], value->unsafeArray)
  let first = value => (value->all)[0]
}

module URLSearchParams = {
  type t
  @new external make: unit => t = "URLSearchParams"
  @new external fromQuery: string => t = "URLSearchParams"
  @send external getAll: (t, string) => array<string> = "getAll"
  @send external get: (t, string) => option<string> = "get"
  @send external keys: t => Js.Array.array_like<string> = "keys"
  @send external values: t => Js.Array.array_like<string> = "values"
  @send external items: t => Js.Array.array_like<(string, string)> = "items"
  @send external toString: t => string = "toString"
}

module URL = {
  @deriving(abstract)
  type t = {
    hash: string,
    host: string,
    hostname: string,
    href: string,
    origin: string,
    password: string,
    pathname: string,
    port: string,
    protocol: string,
    search: string,
    searchParams: URLSearchParams.t,
    username: string,
  }
  @new external make: string => t = "URL"
}
