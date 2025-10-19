type cacheType =
  | @as("page") Page
  | @as("layout") Layout

@module("next/cache")
external revalidatePath: (string, ~_type: cacheType=?) => unit = "revalidatePath"
@module("next/cache") external cacheTag: string => unit = "cacheTag"
@module("next/cache") external cacheLife: string => unit = "cacheLife"
