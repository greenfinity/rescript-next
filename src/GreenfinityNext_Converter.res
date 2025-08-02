module type Config = {
  type t
  let t_encode: t => Js.Json.t
  let t_decode: Js.Json.t => Belt.Result.t<t, Spice.decodeError>
  let assignFromStorage: {..} => {..}
  let assignToStorage: {..} => {..}
}

exception SerializeError(Spice.decodeError)

module Make = (Config: Config) => {
  external fromJson: Js.Json.t => {..} = "%identity"
  external toJson: {..} => Js.Json.t = "%identity"
  external toJs: 't => {..} = "%identity"
  external fromJs: Js.t<'a> => Config.t = "%identity"
  let convertFrom = (o: Js.t<'a>): Js.t<'a> =>
    Js.Obj.empty()->Js.Obj.assign(o)->Js.Obj.assign(Config.assignFromStorage(o))
  let fromStorage = (o): Config.t =>
    switch o->convertFrom->toJson->Config.t_decode {
    | Belt.Result.Ok(req) => req
    | Belt.Result.Error(error) => throw(SerializeError(error))
    }
  let fromStorageOption = (o): option<Config.t> =>
    switch o {
    | Some(o) => o->fromStorage->Some
    | _ => None
    }
  let fromStorageNullable = (o): option<Config.t> => o->Js.Null.toOption->fromStorageOption
  let convertTo = (o: Js.t<'a>): Js.t<'a> =>
    Js.Obj.empty()->Js.Obj.assign(o)->Js.Obj.assign(Config.assignToStorage(o))
  let toStorage = (o: Config.t) => o->Config.t_encode->fromJson->convertTo
}

@deprecated("ResultField module will be removed")
module ResultField = {
  // let int64 = o => o->Int64.of_string->Int64.float_of_bits
  let date = o => o->Js.Date.toISOString
  let option = (o, inner) =>
    switch Js.Nullable.isNullable(o) {
    | false => o->Js.Nullable.toOption->Belt.Option.getExn->inner->Js.Nullable.return
    | _ => Js.Nullable.null
    }
}

external toJs: 't => {..} = "%identity"
