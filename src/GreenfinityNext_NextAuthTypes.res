type user = {
  name: option<string>,
  email: option<string>,
  image: option<string>,
}

type sessionData = {
  user: option<user>,
  expires?: Date.t,
}
type session = sessionData

type authOptions

let emailOfSession = (sessionData: option<sessionData>) =>
  switch sessionData {
  | Some(sessionData) =>
    switch sessionData.user {
    | Some(user) => user.email
    | None => None
    }
  | None => None
  }
