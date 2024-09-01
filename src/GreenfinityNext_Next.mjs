
// workaround for "cannot be used from client component" error
export const headersMakeWithRequire = () =>
    require('next/headers').headers()
