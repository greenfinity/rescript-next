module Next = Next
open NextAuthTypes

@module("next-auth/next")
external _getServerSession: (Next.Req.t, Next.Res.t, _) => promise<Nullable.t<sessionData>> =
  "getServerSession"

let getServerSession = async (req, res, authOptions) =>
  (await _getServerSession(req, res, authOptions))->Nullable.toOption
