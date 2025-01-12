open Vitest

describe("it", () => {
  open Expect
  open! Expect.Operators

  test("works", () => {
    true->expect->toEqual(true)
  })
})
