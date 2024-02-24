type cacheType = [#page | #layout]

@module("next/cache")
external revalidatePath: (string, ~_type: cacheType=?) => unit = "revalidatePath"
