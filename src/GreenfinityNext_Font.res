type t = {variable: string}
type fonts = array<t>

let classNameOfFonts = fonts =>
  fonts->Belt.Array.map(font => font.variable)->Js.Array2.joinWith(" ")
