# Using Bryntum NPM repository and packages

## Repository access

Bryntum components are commercial products hence they are hosted on private Bryntum repository and you **need to login**
to access them.

Login to the registry using the commands below. This will configure **npm** to download packages for the
`@bryntum` scope from the Bryntum registry and create login credentials on your local machine:

**Note:** `npm config set` command syntax differs for npm versions.

For **npm** version **7.x** use:

```shell
$ npm config set @bryntum:registry=https://npm.bryntum.com
$ npm login --registry=https://npm.bryntum.com
```

For **npm** version **6.x** use:

```shell
$ npm config set @bryntum:registry https://npm.bryntum.com
$ npm login --registry=https://npm.bryntum.com
```

Check installed **npm** version with:

```shell
$ npm -v
```

### Licensed user access

Use your [Bryntum Customer Zone](https://customerzone.bryntum.com) email as login but replace `@` with `..`
(double dot). Use your Bryntum Customer Zone password.

For example, if your username in Customer Zone is `user@yourdomain.com`, use the following:

```shell
$ npm login --registry=https://npm.bryntum.com

Username: user..yourdomain.com
Password: your-customer-zone-password
Email: (this IS public) user@yourdomain.com
```

**Note:** _Access to the Bryntum NPM repository requires an active support subscription. If you have purchased a new
product license or upgraded a trial license, you must re-login to update registry access._

### Trial user access

Use your Email as login but replace `@` with `..` (double dot). Use `trial` as password.

For example, if your Email is `user@yourdomain.com`, use the following:

```shell
$ npm login --registry=https://npm.bryntum.com

Username: user..yourdomain.com
Password: trial
Email: (this IS public) user@yourdomain.com
```

## Yarn Package Manager

To access the Bryntum repository with **yarn** first use authorization with **npm** as described above. This step is
mandatory.  After you have been authorized with **npm** you will be able to install packages with **yarn**.

Please note that **yarn** uses npm authorization token to access private repository so there is **no need to login** to
the repository with **yarn**.

## Components

Bryntum components (libraries) for web applications are built using pure JavaScript and can be used in any modern web
application without enforcing any special JS framework. These components are packaged as follows:

| _Component_           |     _Package_              |   Description                   |
|-----------------------|----------------------------|---------------------------------|
| Bryntum Scheduler       | **@bryntum/scheduler**       | Full licensed component version |
| Bryntum Scheduler Trial | **@bryntum/scheduler-trial** | Trial limited component version |

## Frameworks Wrappers

To integrate Bryntum components easily with all major frameworks including Angular, Ionic, React and Vue, we provide
framework specific wrappers in the following packages:

| _Framework_        | _Package_                    | Integration guide                                           |
|--------------------|------------------------------|-------------------------------------------------------------|
| Angular            | **@bryntum/scheduler-angular** | [Angular integration guide](#Scheduler/guides/integration/angular.md) |
| Ionic with Angular | **@bryntum/scheduler-angular** | [Ionic integration guide](#Scheduler/guides/integration/ionic.md)     |
| React              | **@bryntum/scheduler-react**   | [React integration guide](#Scheduler/guides/integration/react.md)     |
| Vue 2.x            | **@bryntum/scheduler-vue**     | [Vue integration guide](#Scheduler/guides/integration/vue.md)         |
| Vue 3.x            | **@bryntum/scheduler-vue-3**   | [Vue integration guide](#Scheduler/guides/integration/vue.md)         |

**Note:** Wrapper packages require installing **@bryntum/scheduler** but it is not listed in package dependencies.
This was done to support trial package aliasing. You have to add **@bryntum/scheduler** dependency to application's
`package.json` by yourself to use wrapper packages.

## Demo resources

Bryntum demo applications use resources such as images, fonts and styling from the **demo-resources** npm package.
This package is **optional** and it is not necessary to add it in your application.

| _Description_  | _Package_                   |
|----------------|-----------------------------|
| Demo Resources | **@bryntum/demo-resources** |

**Note:** Demo Resources package does not contain framework demos and they are bundled within distribution zip.

Trial distribution zip can be requested from [https://www.bryntum.com](https://www.bryntum.com/products/scheduler)
by clicking **Free Trial** button. Licensed distribution zip is located at
[Bryntum Customer Zone](https://customerzone.bryntum.com).

## Installing packages

All published packages in the private Bryntum npm repository can be installed as any other regular npm packages.

For example for Angular framework integration it can be done with:

Install using **npm**:

```shell
$ npm install @bryntum/demo-resources@1.0.0
$ npm install @bryntum/scheduler@4.2.1
$ npm install @bryntum/scheduler-angular@4.2.1
```

or add using **yarn**:

```shell
$ yarn add @bryntum/scheduler@4.2.1
$ yarn add @bryntum/scheduler-angular@4.2.1
```

or add entries to `"dependencies"` in `package.json` project file:

```json
"dependencies": {
  "@bryntum/scheduler": "4.2.1",
  "@bryntum/scheduler-angular": "4.2.1"
}
```

We recommend to remove caret character (`^`) from the versions to take upgrades fully under control.

To install other Bryntum products, simply replace the product identifier `scheduler` with `gantt`, `scheduler`,
`schedulerpro`, `grid` or `calendar`.

**Note:** To avoid compatibility issues make sure that you use same version for all installed Bryntum product
packages.

Packages for other frameworks are listed in the
[Frameworks Wrappers](#Scheduler/guides/npm-repository.md#frameworks-wrappers) table.

## Installing trial packages

Trial packages require using npm package aliasing to install the `"@bryntum/scheduler-trial"` using
the `"@bryntum/scheduler"` alias.

**Note:** Trial Scheduler package should be installed first.

For example for Angular framework integration it can be done with:

Install using **npm**:

```shell
$ npm install @bryntum/scheduler@npm:@bryntum/scheduler-trial
$ npm install @bryntum/scheduler-angular
```

or add using **yarn**:

```shell
$ yarn add @bryntum/scheduler@npm:@bryntum/scheduler-trial
$ yarn add @bryntum/scheduler-angular
```

or add entries to `"dependencies"` in `package.json` project file:

```json
"dependencies": {
  "@bryntum/scheduler": "npm:@bryntum/scheduler-trial@4.2.1",
  "@bryntum/scheduler-angular": "4.2.1"
}
```

To install other Bryntum trial products, simply replace the product identifier `scheduler-trial` with `gantt-trial`, 
`scheduler-trial`, `schedulerpro-trial`, `grid-trial` or `calendar-trial`.

**Note:** To avoid compatibility issues make sure that you use same version for all installed Bryntum product
packages.

Packages for other frameworks are listed in the
[Frameworks Wrappers](#Scheduler/guides/npm-repository.md#frameworks-wrappers) table.

The benefit of using npm package aliasing is that we create an alias for the `scheduler-trial` package using the name of
the licensed `scheduler` package. This means that it will not be need to change application code after ordering a license,
you will only change the alias in `package.json` to the package version number.

Change this:

```json
"dependencies": {
  "@bryntum/scheduler": "npm:@bryntum/scheduler-trial@4.2.1",
}
```

to:

```json
"dependencies": {
  "@bryntum/scheduler": "4.2.1",
}
```

**Note:** [Frameworks Wrappers](#Scheduler/guides/npm-repository.md#frameworks-wrappers) and
[Bryntum Demo Resources](#Scheduler/guides/npm-repository.md#demo-resources)
packages do not have trial versions.

## NPM Requirements

Bryntum demo applications use package aliasing for trial Scheduler package version and for React applications to solve
[performance issues](#Scheduler/guides/integration/react.md#cra-performance). This requires **npm** versions that support
aliases.

Minimum supported **npm** versions are `v6.9.0` or `v7.11.0`.

Check installed **npm** version with:

```shell
$ npm -v
```

Use [npm upgrade guide](https://docs.npmjs.com/try-the-latest-stable-version-of-npm) for **npm** upgrade
instructions and
check Docs for [package alias](https://docs.npmjs.com/cli/v7/commands/npm-install) syntax.

## Using `.npmrc`

### `.npmrc` locations

`npm` package manager uses configuration file named `.npmrc` that stores information of repositories,
authTokens and other configuration options. `npm` uses this file from the following locations in this order:

* per-project config file (/path/to/my/project/.npmrc)
* per-user config file (~/.npmrc)
* global config file ($PREFIX/etc/npmrc)
* npm builtin config file (/path/to/npm/npmrc)

See also [npmrc documentation](https://docs.npmjs.com/cli/v7/configuring-npm/npmrc).

### Listing the npm configuration

Use `npm config ls` to see the following information:

```ini
; "user" config from /Users/user/.npmrc

@bryntum:registry = "https://npm.bryntum.com"
//npm.bryntum.com/:_authToken = (protected)

; node bin location = /Users/user/.nvm/versions/node/v12.22.1/bin/node
; cwd = /Users/Shared/data/devel/bryntum-suite
; HOME = /Users/user
; Run `npm config ls -l` to show all defaults.
```

The first line shows that the `.npmrc` from the user's home directory will be used and we can also see that we
have configured the registry for `@bryntum` namespace and that we have logged-in because we have an authToken.

If we would have `.npmrc` in the project directory, `/Users/Shared/data/devel/bryntum-suite` in this case,
then the output would look like:

```ini
; "user" config from /Users/user/.npmrc

@bryntum:registry = "https://npm.bryntum.com"
//npm.bryntum.com/:_authToken = (protected)

; "project" config from /Users/Shared/data/devel/bryntum-suite/.npmrc

legacy-peer-deps = true

; node bin location = /Users/user/.nvm/versions/node/v12.22.1/bin/node
; cwd = /Users/Shared/data/devel/bryntum-suite
; HOME = /Users/user
; Run `npm config ls -l` to show all defaults.
```

Both user and project configs are used at this time, `legacy-peer-deps` configured in the project directory
and repository and authToken used from the user home directory.

### Using `.npmrc` in Continuous Integration/Continuous Delivery (CI/CD)

The automated CI/CD process will run `npm install` at some point. The command is run in a directory and as
some user. You can manually verify if the `.npmrc` used by the process contains the `@bryntum` repository
configuration and authToken.

Copy `@bryntum:registry` and `//npm.bryntum.com/:_authToken` entries to the config file used.

## Yarn Requirements

The steps in this guide applies to **yarn** `v1.x` Newer versions of **yarn** might require additional configuration
steps.

## Troubleshooting

### Project cleanup with npm

If you have problems with installing or reinstalling packages you could try these commands for full **npm** cache
cleanup, removing package folders and reinstalling all dependencies:

For MacOS/Linux:

```shell
$ npm cache clean --force
$ rm -rf node_modules
$ rm package-lock.json
$ npm install
```

For Windows:

```shell
$ npm cache clean --force
$ rmdir node_modules /s /q
$ del package-lock.json
$ npm install
```

### Project cleanup with yarn

If you have problems with installing or reinstalling packages you could try these commands for full **yarn** cache
cleanup, removing package folders and reinstalling all dependencies:

For MacOS/Linux:

```shell
$ yarn cache clean
$ rm -rf node_modules
$ rm package-lock.json
$ yarn install
```

For Windows:

```shell
$ yarn cache clean
$ rmdir node_modules /s /q
$ del package-lock.json
$ yarn install
```

### Access problems

#### ERR! user is not allowed to access package

```shell
"user user..yourdomain.com is not allowed to access package @bryntum/scheduler"
```

means you are not allowed to access this package when logged in as **trial** or your account in the
[CustomerZone](https://customerzone.bryntum.com) has no Bryntum Scheduler license.

**Note:** _If you have purchased a new product license or upgraded from trial, you must re-login to update registry
access._

#### ERR! 404 Not Found

```shell
Not Found - GET https://registry.npmjs.org/@bryntum%2fscheduler"
npm ERR! 404
npm ERR! 404 ‘@bryntum/scheduler@4.2.1’ is not in the npm registry.
```

means that **npm** tries to get package from public repository at `https://registry.npmjs.org` but not from Bryntum
private repository at `https://npm.bryntum.com`.

Check npm uses correct Bryntum repository setting with:
```shell
$ npm config list
```

Command output should contain this setting:

```shell
@bryntum:registry = "https://npm.bryntum.com"
```

To fix access problem configure npm, login as stated above in
[Repository access](#Scheduler/guides/npm-repository.md#repository-access) and reinstall the package.

### Other problems

If you have problems with accessing Bryntum NPM repository please check these first:

* Install supported **npm** version as stated above in
  [NPM Requirements](#Scheduler/guides/npm-repository.md#npm-requirements)
* You can not have an access to full package `@bryntum/scheduler` from trial account. Use `@bryntum/scheduler-trial`
  package as described above in [Installing trial packages](#Scheduler/guides/npm-repository.md#installing-trial-packages)
* Check you have typed a correct password from [Bryntum Customer Zone](https://customerzone.bryntum.com)
* To access full packages check if you are a real [Bryntum Customer Zone](https://customerzone.bryntum.com) user.
  Register or ask a license owner to add you there
* If you use **yarn** please check [Yarn Package Manager](#Scheduler/guides/npm-repository.md#yarn-package-manager)
  information above
* Contact us at [Bryntum Support Forum](https://bryntum.com/forum) for any questions. Please attach **npm** console log
  to your question

## Online references

* Visit [npm Package Manager homepage](https://npmjs.com)
* Read [npm Documentation](https://docs.npmjs.com)
* Visit [yarn Package Manager homepage](https://yarnpkg.com)
* Read [yarn Documentation](https://yarnpkg.com/getting-started)
* Check all available packages in [Bryntum npm Repository](https://npm.bryntum.com)
* Browse [Bryntum Scheduler Examples](https://bryntum.com/examples/scheduler)
* Browse [All Bryntum products Examples](https://bryntum.com/examples)
* Purchase licensed components in our [Store](https://bryntum.com/store)
* Read [Scheduler Online Documentation](https://bryntum.com/docs/scheduler)
* Post you questions to [Bryntum Support Forum](https://bryntum.com/forum)
* Access [Bryntum Customer Zone](https://customerzone.bryntum.com)
* [Contacts us](https://www.bryntum.com/contact)


<p class="last-modified">Last modified on 2021-07-07 4:09:55</p>