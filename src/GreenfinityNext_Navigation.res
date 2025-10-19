// Support of server components

open GreenfinityNext_Url

type type_ = [#replace | #push]
@module("next/navigation")
external redirect: (string, ~type_: type_=?) => unit = "redirect"
@module("next/navigation")
external notFound: unit => unit = "notFound"
@module("next/navigation")
external unauthorized: unit => unit = "unauthorized"
@module("next/navigation")
external useSelectedLayoutSegment: (~parallelRoutesKey: string=?) => string =
  "useSelectedLayoutSegment"
@module("next/navigation")
external useSelectedLayoutSegments: (~parallelRoutesKey: string=?) => array<string> =
  "useSelectedLayoutSegments"
@module("next/navigation")
external usePathname: unit => string = "usePathname"
@module("next/navigation")
external useParams: unit => dict<string> = "useParams"

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

  type options = {scroll?: bool}

  @send external push: (t, string, ~options: options=?) => unit = "push"
  @send
  external pushObj: (t, GreenfinityNext_Next.Router.pathObj, ~options: options=?) => unit = "push"

  @send external replace: (t, string, ~options: options=?) => unit = "replace"
  @send
  external replaceObj: (t, GreenfinityNext_Next.Router.pathObj, ~options: options=?) => unit =
    "replace"

  @send external back: t => unit = "back"
  @send external forward: t => unit = "forward"

  @send external refresh: t => unit = "refresh"
  @send external prefetch: (t, string) => unit = "prefetch"
}
