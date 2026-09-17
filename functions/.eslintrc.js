// module.exports = {
//   env: {
//     es6: true,
//     node: true,
//   },
//   parserOptions: {
//     "ecmaVersion": 2018,
//   },
//   extends: [
//     "eslint:recommended",
//     "google",
//   ],
//   rules: {
//     "no-restricted-globals": ["error", "name", "length"],
//     "prefer-arrow-callback": "error",
//     "quotes": ["error", "double", {"allowTemplateLiterals": true}],
//   },
//   overrides: [
//     {
//       files: ["**/*.spec.*"],
//       env: {
//         mocha: true,
//       },
//       rules: {},
//     },
//   ],
//   globals: {},
// };


module.exports = {
  env: {
    es6: true,
    node: true,
  },
  parserOptions: {
    "ecmaVersion": 2018,
  },
  extends: [
    "eslint:recommended",
    "google", // Keeps Google's code-quality rules
  ],
  rules: {
    "no-restricted-globals": ["error", "name", "length"],
    "prefer-arrow-callback": "error",
    "quotes": ["error", "double", { "allowTemplateLiterals": true }],

    // OVERRIDES TO FORCE AUTO-FORMATTING ON SAVE:
    "indent": ["error", 2, { "SwitchCase": 1 }], // Forces standard 2-space indent (overriding Google's 4-spaces)
    "object-curly-spacing": ["error", "always"], // Puts spaces inside { brackets }
    "max-len": ["warn", { "code": 100 }], // Softens line-length limit to a warning instead of a red error
    "comma-dangle": ["error", "always-multiline"], // Automatically fixes trailing commas
  },
  overrides: [
    {
      files: ["**/*.spec.*"],
      env: {
        mocha: true,
      },
      rules: {},
    },
  ],
  globals: {},
};
