## Project setup

The example uses packages from the Bryntum private NPM repository. You must be logged-in to this repository as a
licensed or trial user to access the packages.
See [Npm Packages Guide](https://bryntum.com/docs/scheduler/#guides/packages.md) for detailed information on the
sign-up/login process.

Use the following command to install the example packages after the successful login.

```
npm i
```

## Getting started

This is a very simple project which was bootstrapped with [TypeScript React Starter](https://github.com/Microsoft/TypeScript-React-Starter#typescript-react-starter).
To run this project, simply navigate to example folder and run:

```
npm install
npm run start
```

For more information please refer to this guide [here](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md).

## Using scheduler module bundle

Typescript demands all sources to be inside sources root folder (as specified
in tsconfig.json), `./src/` by default, or `node_modules`. We took a liberty
to put everything required for the build into the `./src/lib` folder.
