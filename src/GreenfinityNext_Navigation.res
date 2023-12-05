// Support of server components

open GreenfinityNext_Url

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
