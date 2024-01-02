open GreenfinityNext_NextServer

// App route support

let default: (NextRequest.t, 'a) => 'b = async (req, processIt) => {
  try await (await (await req->NextRequest.json)->processIt)->NextResponse.json catch {
  | NextResponse.ApiError(status) =>
    await Js.Json.null->NextResponse.json(~options={status: status})
  | e => raise(e)
  }
}
