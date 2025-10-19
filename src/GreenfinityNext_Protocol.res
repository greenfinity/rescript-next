open Belt

module type TProtocol = {
  let path: string
  type req
  let req_encode: req => JSON.t
  let req_decode: JSON.t => Result.t<req, Spice.decodeError>
  type resp
  let resp_encode: resp => JSON.t
  let resp_decode: JSON.t => Result.t<resp, Spice.decodeError>
}

module MakeProtocol = (P: TProtocol) => {
  let make = async (req: P.req): P.resp =>
    (await GreenfinityNext_Fetch.fetchJson(P.path, req->P.req_encode))->P.resp_decode->Result.getExn
}
