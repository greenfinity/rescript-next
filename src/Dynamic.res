// Next.js dynamic import binding
// https://nextjs.org/docs/app/building-your-application/optimizing/lazy-loading

type dynamicOptions = {
  ssr?: bool,
  loading?: unit => React.element,
}

/**
 * Dynamically import a React component with code splitting.
 *
 * This creates a separate chunk that is loaded on-demand, reducing the initial
 * bundle size. Use with `ssr: false` to also skip server-side rendering.
 *
 * @example
 * ```rescript
 * module LazyComponent = {
 *   type props = {children: React.element}
 *
 *   let component: React.component<props> = GreenfinityNext2_Dynamic.dynamic(
 *     async () => await Js.import(MyComponent.make),
 *     {ssr: false, loading: () => <LoadingSpinner />},
 *   )
 * }
 *
 * // Usage:
 * {React.createElement(LazyComponent.component, {children: ...})}
 * ```
 */
@module("next/dynamic")
external dynamic: ('a => promise<'b>, dynamicOptions) => React.component<'props> = "default"
