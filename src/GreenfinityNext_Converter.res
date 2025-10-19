module type Config = {
  type t
  let t_encode: t => JSON.t
  let t_decode: JSON.t => Belt.Result.t<t, Spice.decodeError>
  let assignFromStorage: {..} => {..}
  let assignToStorage: {..} => {..}
}

exception SerializeError(Spice.decodeError)

module Make = (Config: Config) => {
  external fromJson: JSON.t => {..} = "%identity"
  external toJson: {..} => JSON.t = "%identity"
  external toJs: 't => {..} = "%identity"
  external fromJs: {..} => Config.t = "%identity"
  let convertFrom = (o: {..}): {..} =>
    Object.make()->Object.assign(o)->Object.assign(Config.assignFromStorage(o))
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
  let fromStorageNullable = (o): option<Config.t> => o->Null.toOption->fromStorageOption
  let convertTo = (o: {..}): {..} =>
    Object.make()->Object.assign(o)->Object.assign(Config.assignToStorage(o))
  let toStorage = (o: Config.t) => o->Config.t_encode->fromJson->convertTo
}

@deprecated("ResultField module will be removed")
module ResultField = {
  // let int64 = o => o->Int64.of_string->Int64.float_of_bits
  let date = o => o->Date.toISOString
  let option = (o, inner) =>
    switch Nullable.isNullable(o) {
    | false => o->Nullable.toOption->Belt.Option.getExn->inner->Nullable.make
    | _ => Nullable.null
    }
}

external toJs: 't => {..} = "%identity"
