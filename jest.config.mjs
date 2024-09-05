const config = {
    verbose: false,
    rootDir: "./",
    testMatch: ["**/__tests__/**/*_test.mjs", "**/__tests__/**/*_test.bs.mjs"],
    testPathIgnorePatterns: ["/node_modules/", "/.cache/"],
    setupFiles: ["./jestSetup.js"],
    transform: {},
    transformIgnorePatterns: ["node_modules/@glennsl/bs-rescript/"],
    collectCoverage: false, // unless explititly specified
    coveragePathIgnorePatterns: [
        "/node_modules/",
    ],
    coverageThreshold: {
        global: {
            branches: 10,
            functions: 10,
            lines: 10,
            statements: -10000,
        },
    },
};

export default config;
