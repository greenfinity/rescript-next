module Next = GreenfinityNext_Next
open GreenfinityNext_NextAuthTypes

module SessionProvider = {
  @module("next-auth/react") @react.component
  external make: (
    ~session: sessionData=?,
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

type rawSignInResult = {
  error: Js.nullable<string>,
  status: int,
  ok: bool,
  url?: string,
}

type signInResult =
  | Some(rawSignInResult)
  | None

@module("next-auth/react")
external signInWithRawProviderOptions: (string, {..}, {..}) => promise<signInResult> = "signIn"

type getSessionRequest = {req: Next.Req.t}
@module("next-auth/react")
external _getSession: getSessionRequest => promise<Js.Nullable.t<sessionData>> = "getSession"

let getSession = async req => (await _getSession({req: req}))->Js.Nullable.toOption

type signOutResponse = {url: string}
type signOutOptions = {
  redirect?: bool,
  callbackUrl?: string,
}
@module("next-auth/react")
external _signOut: signOutOptions => promise<signOutResponse> = "signOut"
let signOut = (~redirect: option<bool>=?, ~callbackUrl: option<string>=?) =>
  _signOut({?redirect, ?callbackUrl})

type internalProvider = [
  | #credentials
  | #email
]

/**
 * Externally binds to the `signIn` function from the `next-auth/react` module.
 * 
 * @param provider - The authentication provider's name as a string (e.g., "credentials", "email").
 * @param options - An object containing provider-specific options.
 * @param authParams - An object containing additional authentication parameters.
 * @returns A promise that resolves to a `rawSignInResult`.
 *
 * Note: This variant **should** not perform a redirect after sign-in.
 * The result is provided only in case "redirect" is false.
* (And redirect only works with the "credentials" or "email" providers.)
 */
@module("next-auth/react")
external _signInWithInternalProviderNoRedirect: (
  internalProvider,
  {..},
  {..},
) => promise<rawSignInResult> = "signIn"
let signInWithInternalProviderNoRedirect = (provider, options, authParams) => {
  let mergedOptions = Js.Obj.assign(Js.Obj.empty(), options)
  mergedOptions["redirect"] = false
  _signInWithInternalProviderNoRedirect(provider, mergedOptions, authParams)
}

/**
 * Signs in a user using email and password credentials.
 *
 * @param email - The user's email address.
 * @param password - The user's password.
 * @returns A promise resolving to the result of the sign-in attempt.
 *
 * This function uses the "credentials" provider and disables automatic redirection on sign-in.
 * Its goal is to make the call type safe and straightforward, avoiding the need for calling the
 * more generic `signInWithRawProviderOptions` directly.
 */
let signInWithCredentials = (~username, ~password) =>
  signInWithInternalProviderNoRedirect(
    #credentials,
    {"username": username, "password": password},
    Js.Obj.empty(),
  )
