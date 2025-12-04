type cacheType =
  | @as("page") Page
  | @as("layout") Layout

@module("next/cache")
external revalidatePath: (string, ~_type: cacheType=?) => unit = "revalidatePath"

type revalidateProfileOptions = {expire?: int}
@unboxed
type revalidateProfile = | @as("max") Max | Options(revalidateProfileOptions)

@module("next/cache")
external revalidateTag: (string, ~profile: revalidateProfile) => unit = "revalidateTag"

@module("next/cache")
external updateTag: string => unit = "updateTag"

@module("next/cache") external cacheTag: string => unit = "cacheTag"

@module("next/cache") external cacheLife: string => unit = "cacheLife"

/**
 * Provides bindings to the Next.js `unstable_cache` API for server-side
 * data caching. This allows you to cache the results of expensive operations,
 * like database queries or API calls, and reuse them across multiple requests.
 *
 * See [Next.js `unstable_cache` documentation](https://nextjs.org/docs/app/api-reference/functions/unstable_cache)
 * for more details on the underlying API.
 *
 * The binding is only produced for a single-parameter function. This is
 * sufficient, as you can wrap multiple parameters into a record or tuple.
 * For many practical use cases, the data has to be serialized into a string
 * anyway, so this is not a significant limitation.
 *
 * ## Example Usage
 *
 * ```rescript
 * // An async function to fetch some data
 * let getUser = async (userId: string) => {
 *   // In a real app, you'd fetch this from a database or API
 *   Js.log2("Fetching user:", userId)
 *   await Js.Promise.resolve() // Simulate network delay
 *   {id: userId, name: `User ${userId}`}
 * }
 *
 * // Create a cached version of the `getUser` function.
 * // The cache key is `["users", userId]`.
 * // The data will be revalidated at most once every 60 seconds.
 * let getCachedUser = (userId) => {
 *   unstable_cache(
 *     getUser,
 *     ["users", userId],
 *     {revalidate: 60, tags: ["users-collection"]},
 *   )(userId)
 * }
 *
 * // Now, use the cached function in your component or page
 * let user1 = await getCachedUser("1") // Will log "Fetching user: 1"
 * let user2 = await getCachedUser("1") // Will NOT log, returns cached data
 * ```
 *
 * @param fn The asynchronous function `('args => promise<'b>)` whose result you want to cache.
 * @param keyParts An `array<string>` that uniquely identifies the cache entry.
 * @param options An `options` record with optional `revalidate` (in seconds) and `tags` for on-demand revalidation.
 * @returns A new function with the same signature as `fn` that is now wrapped with caching logic.
 */
module UnstableCache = {
  type keyParts = array<string>
  type options = {
    tags?: array<string>,
    revalidate?: int,
  }
  @module("next/cache")
  external t: ('args => promise<'b>, keyParts, options) => 'args => promise<'b> = "unstable_cache"
}

let unstable_cache = UnstableCache.t
