open Js.Promise2
module Next = GreenfinityNext_Next

type user = {
  name: option<string>,
  email: option<string>,
  image: option<string>,
}

type sessionData = {
  user: option<user>,
  expires?: Js.Date.t,
}
type session = sessionData

type authOptions

module SessionProvider = {
  @module("next-auth/react") @react.component
  external make: (
    ~session: sessionData,
    ~refetchInterval: int=?,
    ~children: 'children=?,
  ) => React.element = "SessionProvider"
}

type sessionStatus = [
  | #loading
  | #authenticated
  | #onUnauthenticated
]

type useSessionResult = {status: sessionStatus, data: option<sessionData>}

@module("next-auth/react")
external useSession: (
  ~required: bool=?,
  ~onUnauthenticated: unit => unit=?,
  unit,
) => useSessionResult = "useSession"

@module("next-auth/react")
external signIn: unit => unit = "signIn"

@module("next-auth/react")
external signInWithProvider: string => unit = "signIn"

@module("next-auth/react")
external signInWithProviderOptions: (string, {..}, {..}) => promise<{..}> = "signIn"

type getSessionRequest = {req: Next.Req.t}
@module("next-auth/react")
external _getSession: getSessionRequest => Js.Promise2.t<Js.Nullable.t<sessionData>> = "getSession"

let getSession = req => _getSession({req: req})->then(r => r->Js.Nullable.toOption->resolve)

@module("next-auth/next")
external _getServerSession: (
  Next.Req.t,
  Next.Res.t,
  _,
) => Js.Promise2.t<Js.Nullable.t<sessionData>> = "getServerSession"

let getServerSession = (req, res, authOptions) =>
  _getServerSession(req, res, authOptions)->then(r => r->Js.Nullable.toOption->resolve)

let emailOfSession = sessionData =>
  switch sessionData {
  | Some(sessionData) =>
    switch sessionData.user {
    | Some(user) => user.email
    | None => None
    }
  | None => None
  }
