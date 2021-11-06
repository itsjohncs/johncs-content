+++
date = "2021-11-6 1:35:00"
+++

Want to use [ts-jest](https://github.com/kulshekhar/ts-jest) in [Create React App](https://create-react-app.dev) so [your tests are actually typechecked](https://github.com/facebook/create-react-app/issues/5626)?

First make sure you install the correct `ts-jest` (the major version of `ts-jest` must match the major version of `jest` that's installed). Then add something similar to this to your CRACO configuration:

```javascript
jest: {
    configure: function (jestConfig) {
        // Don't transform typescript files with babel...
        const babelTransform =
            jestConfig.transform["^.+\\.(js|jsx|mjs|cjs|ts|tsx)$"];
        delete jestConfig.transform["^.+\\.(js|jsx|mjs|cjs|ts|tsx)$"];
        jestConfig.transform["^.+\\.(js|jsx|mjs|cjs)$"] = babelTransform;

        // so that ts-jest can!
        jestConfig.preset = "ts-jest";

        return jestConfig;
    },
},
```

You'll probably need to adjust this a bit as `react-scripts`' dependencies change over time. Best of luck.
