module Errors = GreenfinityNext_Errors
module Next = GreenfinityNext_Next

let default: (Next.Req.t, Next.Res.t, 'a) => 'b = async (req, res, processIt) => {
  let v = await processIt(req->Next.Req.bodyAsJson)
  try {
    res->Next.Res.statusCode(Success)
    res->Next.Res.setHeader("Content-Type", "application/json")
    res->Next.Res.sendJson(v)
    ignore()
  } catch {
  | Errors.ApiError(statusCode) => {
      res->Next.Res.statusCode(statusCode)
      res->Next.Res.setHeader("Content-Type", "application/json")
      res->Next.Res.sendJson(JSON.Encode.null)
      ignore()
    }

  | e => {
      res->Next.Res.statusCode(ServerError)
      res->Next.Res.setHeader("Content-Type", "application/json")
      res->Next.Res.sendJson(JSON.Encode.null)
      throw(e)
    }
  }
}
