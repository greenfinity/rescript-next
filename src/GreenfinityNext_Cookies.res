type cookieOptions = {
  name?: string,
  value?: string,
  path?: string,
  maxAge?: int,
  expires?: Date.t,
  httpOnly?: bool,
  secure?: bool,
  sameSite?: [#strict | #lax | #none],
}

type cookie = {
  name: string,
  value: string,
}

type t

@module("next/headers") external make: unit => promise<t> = "cookies"

@send @returns(nullable) external get: (t, string) => option<cookie> = "get"

@send external getAll: t => array<cookie> = "getAll"

@send external has: (t, string) => bool = "has"

@send external set: (t, string, string, ~options: cookieOptions=?) => unit = "set"

@send external delete: (t, string) => unit = "delete"
