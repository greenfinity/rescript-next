// Typed wrappers around the Next.js `'use cache'` tag + lifetime APIs (Cache),
// as a functor so each app supplies its own cache-tag type while reusing one
// implementation. Tags + lifetimes are typed variants rather than raw strings,
// so cache keys stay typo-proof.
//
// The string coercion of a tag lives at the *call site* (the app's
// `tagToString`): the library can't coerce an abstract functor type to string,
// and the app's concrete `@as`-string variant can (`(t :> string)`).
// `DefaultsLife` carries the common lifetime enum so apps rarely define their own.
//
// `cacheTag` / `cacheLife` are called INSIDE a `'use cache'` component;
// `updateTag` / `revalidateTag` bust a tag from a mutation server action.

module type CacheConfig = {
  type tag
  type life
  let tagToString: tag => string
  let lifeToString: life => string
}

module DefaultsLife = {
  type life =
    | @as("seconds") Seconds
    | @as("minutes") Minutes
    | @as("hours") Hours
    | @as("days") Days
    | @as("max") Max

  let lifeToString = (life: life) => (life :> string)
}

module Make = (Config: CacheConfig) => {
  type tag = Config.tag
  type life = Config.life
  let tagToString = Config.tagToString
  let lifeToString = Config.lifeToString
  let cacheTag = tag => tag->tagToString->Cache.cacheTag
  let cacheLife = life => life->lifeToString->Cache.cacheLife
  let updateTag = tag => tag->tagToString->Cache.updateTag
  let revalidateTag = (tag, ~profile: Cache.revalidateProfile) =>
    tag->tagToString->Cache.revalidateTag(~profile)
}

// Example usage — an app supplies its own cache-tag type, then applies `Make`.
// The config must be a *named* module (the functor result mentions its `tag` /
// `life`, so an inline struct gives "parameter cannot be eliminated");
// `include DefaultsLife` takes the standard lifetime enum as the default.
//
//   module MyCacheConfigBase = {
//     include DefaultsLife
//     type tag = | @as("public-content") PublicContent
//     let tagToString = (tag: tag) => (tag :> string)
//   }
//   module MyCacheConfig = Make(MyCacheConfigBase)
//
//   // tag + lifetime values come from the Base module:
//   MyCacheConfig.cacheTag(MyCacheConfigBase.PublicContent)
//   MyCacheConfig.cacheLife(MyCacheConfigBase.Max)
//   MyCacheConfig.updateTag(MyCacheConfigBase.PublicContent)
