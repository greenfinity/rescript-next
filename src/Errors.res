type apiErrorStatus =
  | @as(200) Success
  | @as(400) BadRequest
  | @as(403) Forbidden
  | @as(404) NotFound
  | @as(500) ServerError

let apiErrorFromStatus = status =>
  switch status {
  | 200 => Success
  | 400 => BadRequest
  | 403 => Forbidden
  | 404 => NotFound
  | _ => ServerError
  }

exception ApiError(apiErrorStatus)

exception ApiErrorWithMessage(apiErrorStatus, string)

exception TokenSigningError

exception Unauthorized
