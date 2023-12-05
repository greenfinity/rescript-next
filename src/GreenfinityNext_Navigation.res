// Support of server components

module SearchParams = {
  type value
  external unsafeArray: value => Js.Array2.t<string> = "%identity"

  type t = Js.Dict.t<value>
  let all = value => Js.Array2.concat([], value->unsafeArray)
  let first = value => (value->all)[0]
}

module Headers = {
  type t
  @new @module("next/headers") external make: unit => t = "headers"
  @send external get: (t, string) => option<string> = "get"
  @send external keys: t => Js.Array.array_like<string> = "keys"
  @send external values: t => Js.Array.array_like<string> = "values"
  @send external items: t => Js.Array.array_like<(string, string)> = "items"
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

type \"type" = [#replace | #push]
@module("next/navigation")
external redirect: (string, ~\"type": \"type"=?, unit) => unit = "redirect"

module Router = {
  type t = {
    route: string,
    asPath: string,
    events: GreenfinityNext_Next.Router.Events.t,
    // pathname, query are not returned in server components,
    // usePathname and useSearchParams has to be used instead.
  }

  @module("next/navigation") external useRouter: unit => t = "useRouter"
  @module("next/navigation") external usePathname: unit => string = "usePathname"
  @module("next/navigation")
  external useSearchParams: unit => URLSearchParams.t = "useSearchParams"

  @send external push: (t, string) => unit = "push"
  @send external pushObj: (t, GreenfinityNext_Next.Router.pathObj) => unit = "push"

  @send external replace: (t, string) => unit = "replace"
  @send external replaceObj: (t, GreenfinityNext_Next.Router.pathObj) => unit = "replace"
}
