module Req = {
  type t

  @set_index external set: (t, string, 'a) => unit = ""
  @get_index external get: (t, string) => Js.Nullable.t<'a> = ""
  @get_index external get_UNSAFE: (t, string) => 'a = ""
  @deprecated("Use bodyAsJson") @get external body: t => Js.Nullable.t<'a> = "body"
  @get external bodyAsJson: t => Js.Json.t = "body"
  @get external url: t => string = "url"
}

module Res = {
  type t

  // https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
  @set
  external statusCode: (
    t,
    @int
    [
      | @as(200) #Success
      | @as(400) #BadRequest
      | @as(403) #Forbidden
      | @as(404) #NotFound
      | @as(500) #ServerError
    ],
  ) => unit = "statusCode"

  @send external setHeader: (t, string, string) => unit = "setHeader"
  @send external sendString: (t, string) => unit = "send"
  @send external sendBinary: (t, Js.TypedArray2.ArrayBuffer.t) => unit = "send"
  @send external writeString: (t, string) => unit = "write"
  @send external endString: (t, string) => unit = "end"
  @send external end: t => unit = "end"
  // For some reason explicit conversion is needed to send anything else than
  // an object, such as a standalone string or null.
  let sendJson = (res, json) => res->sendString(json->Js.Json.stringify)
}

module GetServerSideProps = {
  // See: https://github.com/zeit/next.js/blob/canary/packages/next/types/index.d.ts
  type context<'props, 'params, 'previewData> = {
    params: 'params,
    query: Js.Dict.t<string>,
    preview: option<bool>, // preview is true if the page is in the preview mode and undefined otherwise.
    previewData: Js.Nullable.t<'previewData>,
    req: Req.t,
    res: Res.t,
  }

  // See: https://github.com/zeit/next.js/blob/canary/packages/next/types/index.d.ts
  // export type GetServerSidePropsResult<P> =
  // | { props: P }
  // | { redirect: Redirect }
  // | { notFound: true }

  type redirect = {
    destination: string,
    permanent: bool,
  }

  type result<'props> = {
    props: option<'props>,
    redirect: option<redirect>,
    notFound: bool,
  }

  // The definition of a getServerSideProps function
  type t<'props, 'params, 'previewData> = context<'props, 'params, 'previewData> => Js.Promise.t<
    result<'props>,
  >
}

module GetStaticProps = {
  // See: https://github.com/zeit/next.js/blob/canary/packages/next/types/index.d.ts
  type context<'props, 'params, 'previewData> = {
    params: 'params,
    preview: option<bool>, // preview is true if the page is in the preview mode and undefined otherwise.
    previewData: Js.Nullable.t<'previewData>,
  }

  type return<'props> = {
    props: option<'props>,
    revalidate: option<int>,
    notFound: bool,
  }

  // The definition of a getStaticProps function
  type t<'props, 'params, 'previewData> = context<'props, 'params, 'previewData> => Js.Promise.t<
    return<'props>,
  >
}

module GetStaticPaths = {
  // 'params: dynamic route params used in dynamic routing paths
  // Example: pages/[id].js would result in a 'params = { id: string }
  type path<'params> = {params: 'params}

  type genericReturn<'params, 'fallback> = {
    paths: array<path<'params>>,
    fallback: 'fallback,
  }

  // The definition of a getStaticPaths function
  type genericT<'params, 'fallback> = unit => Js.Promise.t<genericReturn<'params, 'fallback>>

  // default: with fallback blocking
  type return<'params> = genericReturn<'params, [#blocking]>
  type t<'params> = genericT<'params, [#blocking]>

  // customized with boolean fallback
  module WithBoolFallback = {
    type return<'params> = genericReturn<'params, bool>
    type t<'params> = genericT<'params, bool>
  }
}

module Link = {
  @module("next/link") @react.component
  external make: (
    ~href: string,
    ~_as: string=?,
    ~prefetch: bool=?,
    ~replace: option<bool>=?,
    ~shallow: option<bool>=?,
    ~passHref: option<bool>=?,
    ~children: React.element,
    ~className: string=?,
    ~scroll: bool=?,
  ) => React.element = "default"
}

module Router = {
  /*
      Make sure to only register events via a useEffect hook!
 */
  module Events = {
    type t

    @send
    external on: (
      t,
      @string
      [
        | #routeChangeStart(string => unit)
        | #routeChangeComplete(string => unit)
        | #hashChangeComplete(string => unit)
      ],
    ) => unit = "on"

    @send
    external off: (
      t,
      @string
      [
        | #routeChangeStart(string => unit)
        | #routeChangeComplete(string => unit)
        | #hashChangeComplete(string => unit)
      ],
    ) => unit = "off"
  }

  type router = {
    route: string,
    asPath: string,
    events: Events.t,
    pathname: string,
    query: Js.Dict.t<string>,
  }

  type pathObj = {
    pathname: string,
    query: Js.Dict.t<string>,
  }

  @send external push: (router, string) => unit = "push"
  @send external pushObj: (router, pathObj) => unit = "push"

  @module("next/router") external useRouter: unit => router = "useRouter"

  @send external replace: (router, string) => unit = "replace"
  @send external replaceObj: (router, pathObj) => unit = "replace"
}

module Head = {
  @module("next/head") @react.component
  external make: (~children: React.element) => React.element = "default"
}

/*
module Document = {

  module Html = {
    @module("next/document") @react.component
    external make: (~children: React.element) => React.element = "Html"
  }

  module Head = {
    @module("next/document") @react.component
    external make: (~children: React.element) => React.element = "Head"
  }

  module Main = {
    @module("next/document") @react.component
    external make: (~children: React.element) => React.element = "Main"
  }

  module NextScript = {
    @module("next/document") @react.component
    external make: (~children: React.element) => React.element = "NextScript"
  }
// https://nextjs.org/docs/basic-features/script
module Script = {
  @module("next/script") @react.component
  external make: (~src: string) => React.element = "default"
}
*/

/*
// https://nextjs.org/docs/advanced-features/custom-error-page#reusing-the-built-in-error-page
module Error = {
  // @string and @int attributes not supported. See https://github.com/rescript-lang/rescript-compiler/issues/5724
  // @module("next/error") @react.component
  // external make = (
  // ~statusCode: @int
  // [
  //   | @as(#400) #BadRequest
  //   | @as(#403) #Forbidden
  //   | @as(#404) #NotFound
  //   | @as(#500) #ServerError
  // ],
  // ~title: string=?,
  // ~withDarkMode: bool=?,
  // ) => React.element = "default"
  type rawProps = {
    statusCode: int,
    title?: string,
    withDarkMode?: bool,
  }
  @module("next/error") external rawMake: rawProps => React.element = "default"

  type statusCode = [
    | #BadRequest
    | #Forbidden
    | #NotFound
    | #ServerError
  ]

  type props = {
    statusCode: statusCode,
    title: option<string>,
    withDarkMode: option<bool>,
  }

  let make = ({statusCode, title, withDarkMode}: props) =>
    rawMake({
      statusCode: {
        switch statusCode {
        | #BadRequest => 400
        | #Forbidden => 400
        | #NotFound => 400
        | #ServerError => 500
        }
      },
      ?title,
      ?withDarkMode,
    })
}
*/

module Dynamic = {
  @deriving(abstract)
  type options = {
    @optional
    ssr: bool,
    @optional
    loading: unit => React.element,
  }

  @module("next/dynamic")
  external dynamic: (unit => Js.Promise.t<'a>, options) => 'a = "default"

  @val external import_: string => Js.Promise.t<'a> = "import"
}

// https://nextjs.org/docs/api-reference/next/image
module Image = {
  type loaderOptions = {
    src: string,
    width: float,
    quality: float,
  }
  @module("next/image") @react.component
  external make: (
    ~alt: string=?,
    ~blurDataURL: string=?,
    ~placeholder: [#blur | #empty]=?,
    ~className: string=?,
    ~height: float=?,
    ~layout: [#fixed | #intrinsic | #responsive | #fill]=?,
    ~loader: loaderOptions => string=?,
    ~loading: [
      | @as("lazy") #lazy_
      | #eager
    ]=?,
    ~priority: bool=?,
    ~objectFit: [
      | #fill
      | #contain
      | #cover
      | #none
      | #"scale-down"
    ]=?,
    ~objectPosition: string=?,
    ~quality: float=?,
    ~sizes: string=?,
    ~src: string,
    ~unoptimized: bool=?,
    ~width: float=?,
  ) => React.element = "default"
}

module Headers = {
  type t

  @deprecated("Use makePromise instead and await the result.") @new @module("next/headers")
  external make: unit => t = "headers"

  @new @module("next/headers") external makeAsync: unit => promise<t> = "headers"

  // workaround for "cannot be used from client component" error (deprecated)
  @module("./GreenfinityNext_Next.mjs")
  @deprecated("Use makePromiseWithRequire instead and await the result.")
  external makeWithRequire: unit => t = "headersMakeWithRequire"

  // workaround for "cannot be used from client component" error
  @module("./GreenfinityNext_Next.mjs")
  external makeAsyncWithRequire: unit => promise<t> = "headersMakeWithRequire"

  @send external _get: (t, string) => Js.Nullable.t<string> = "get"
  let get = (headers, k) => headers->_get(k)->Js.Nullable.toOption

  @send external keys: t => Js.Array.array_like<string> = "keys"

  @send external values: t => Js.Array.array_like<string> = "values"

  @send external items: t => Js.Array.array_like<(string, string)> = "items"
}

/**
 * Module for handling Next.js metadata configuration
 */
module Metadata = {
  /**
   * @example

    let metadata: Metadata.t = {
      title: "Greenfinity",
      description: "Welcome to Greenfinity",
      icons: [
        {rel: "icon", url: "/favicon.ico", sizes: "32x32"},
        {rel: "apple-touch-icon", url: "/icon-180.png"},
        {rel: "icon", url: "/icon.svg", type_: "image/svg+xml"},
      ],
      manifest: "/manifest.webmanifest",
    }

   */
  type icon = {
    rel: string,
    url: string,
    @as("type") type_?: string,
    sizes?: string,
  }
  type icons = array<icon>
  type t = {
    title?: string,
    description?: string,
    icons?: icons,
    manifest?: string,
  }
}
