open Vitest

describe("Fetch.Response", () => {
  open Expect

  test("make sets status + headers; body may be null", () => {
    let headers = Fetch.Headers.make()
    headers->Fetch.Headers.set("Location", "/somewhere")
    headers->Fetch.Headers.set("Cache-Control", "public, max-age=3600")
    let res = Fetch.Response.make(Nullable.null, {status: 307, headers})
    (
      res.status,
      res.headers->Fetch.Headers.get("Location"),
      res.headers->Fetch.Headers.get("Cache-Control"),
    )
    ->expect
    ->toEqual((307, Some("/somewhere"), Some("public, max-age=3600")))
  })

  test("redirect sets Location + status", () => {
    let res = Fetch.Response.redirect("https://example.com/y", 307)
    (res.status, res.headers->Fetch.Headers.get("Location"))
    ->expect
    ->toEqual((307, Some("https://example.com/y")))
  })
})
