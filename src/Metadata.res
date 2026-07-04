/**
 * Typed subset of the Next.js App Router Metadata API — the `metadata` export
 * and the `generateMetadata` return value — following the official
 * recommendations: the TITLE TEMPLATE lives in the root layout and pages
 * return plain title strings (or opt out with an absolute title);
 * `metadataBase` lives in the root layout so per-page canonical and OpenGraph
 * URLs can stay relative. Structural: Next consumes the plain object shape.
 *
 * Supersedes the minimal `Next.Metadata` (kept for compatibility).
 *
 * @example
 *
 *  // Root layout
 *  let metadata: Metadata.t = {
 *    metadataBase: Metadata.makeUrl("https://example.com"),
 *    title: Metadata.titleTemplate({default: "Site", template: "%s | Site"}),
 *    description: "Default description",
 *    openGraph: {siteName: "Site", type_: "website"},
 *    icons: [{rel: "icon", url: "/favicon.ico", sizes: "32x32"}],
 *  }
 *
 *  // Page-level generateMetadata
 *  let generateMetadata = async (props): Metadata.t => {
 *    ...
 *    {
 *      title: Metadata.title(pageTitle), // templated by the root layout
 *      alternates: {canonical: path},    // relative, resolved by metadataBase
 *    }
 *  }
 */
// metadataBase must be a JS URL instance.
type url
@new external makeUrl: string => url = "URL"

// `title` is string | {default, template} | {absolute}: three runtime shapes
// behind one abstract type, with typed constructors.
type title
type titleTemplate = {default: string, template: string}
type titleAbsolute = {absolute: string}
external title: string => title = "%identity"
external titleTemplate: titleTemplate => title = "%identity"
external titleAbsolute: titleAbsolute => title = "%identity"

type alternates = {canonical?: string}

type ogImage = {url: string, width?: int, height?: int, alt?: string}

type openGraph = {
  title?: string,
  description?: string,
  url?: string,
  siteName?: string,
  locale?: string,
  @as("type") type_?: string,
  images?: array<ogImage>,
}

type icon = {
  rel: string,
  url: string,
  @as("type") type_?: string,
  sizes?: string,
}

type robots = {index?: bool, follow?: bool}

type t = {
  metadataBase?: url,
  title?: title,
  description?: string,
  alternates?: alternates,
  openGraph?: openGraph,
  icons?: array<icon>,
  manifest?: string,
  robots?: robots,
}
