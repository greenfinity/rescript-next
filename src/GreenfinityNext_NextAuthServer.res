module Next = GreenfinityNext_Next
open GreenfinityNext_NextAuthTypes

@module("next-auth/next")
external _getServerSession: (Next.Req.t, Next.Res.t, _) => promise<Js.Nullable.t<sessionData>> =
  "getServerSession"

let getServerSession = async (req, res, authOptions) =>
  (await _getServerSession(req, res, authOptions))->Js.Nullable.toOption
