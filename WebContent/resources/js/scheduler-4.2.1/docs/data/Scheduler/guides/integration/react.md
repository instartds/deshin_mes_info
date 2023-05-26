<h1 class="title-with-image"><img src="Core/logo/react.png"
alt="Bryntum Scheduler supports React"/>Using Bryntum Scheduler with React</h1>

## Bryntum NPM repository access

Please refer to this [guide for Bryntum NPM repository access](#Scheduler/guides/npm-repository.md).

## Bryntum Scheduler

Scheduler itself is framework agnostic, but ships with demos and wrappers to simplify using it with popular frameworks
such as React. The purpose of this guide is to give a basic introduction on how to use Scheduler with React.

Bryntum Scheduler is integrated to React applications using the provided wrappers.

### The React wrappers

The wrappers encapsulate Bryntum Scheduler and other Bryntum widgets in React components that expose configuration
options, properties, features and events. The wrapped Bryntum components are then used the usual React way.

## View online demos

Bryntum Scheduler demos can be viewed in our
[online example browser](https://bryntum.com/examples/scheduler/#Integration/React).

## Build and run local demos

React demos are located in **examples/frameworks/react** folder inside distribution zip.

Trial distribution zip can be requested from [https://www.bryntum.com](https://www.bryntum.com/products/scheduler)
by clicking **Free Trial** button. Licensed distribution zip is located at
[Bryntum Customer Zone](https://customerzone.bryntum.com).

Each demo contains bundled `README.md` file in demo folder with build and run instructions.

You may run them either in development mode or built for production. They have been created using
[create-react-app](https://github.com/facebook/create-react-app) script so that they can be run locally by running:

```shell
$ npm install
$ npm run start
```

That starts a local server accessible at [http://localhost:3000](http://localhost:3000). If
you modify the example code while running it locally it is automatically rebuilt and updated in the browser allowing you
to see your changes immediately.

The production version of an example, or your application, is built by running:

```shell
$ npm install
$ npm run build
```

The built version is then located in `build` sub-folder which contains the compiled code that can be deployed to your
production server.

## TypeScript and Typings

Bryntum bundles ship with typings for the classes for usage in TypeScript applications. You can find `scheduler*.d.ts`
files in the `build` folder inside the distribution zip package. The definitions also contain a special config type
which can be passed to the class constructor.

The config specific types are also accepted by multiple other properties and functions, for example
the [Store.data](#Core/data/Store#config-data) config of the `Store` which accepts type `Partial<ModelConfig>[]`.

Sample code for tree store creation with `ModelConfig` and `StoreConfig` classes:

```typescript
import { Store, StoreConfig, ModelConfig } from '@bryntum/scheduler';

const storeConfig: Partial<StoreConfig> = {
    tree : true,
    data : [
        {
            id       : 1,
            children : [
                {
                    id : 2
                }
            ] as Partial<ModelConfig>[]
        }
    ] as Partial<ModelConfig>[]
};

new Store(storeConfig);
```

## Wrappers

### Installing the wrappers package

The wrappers are implemented in a separate package `@bryntum/scheduler-react` that is installed according to the used
package manager. Please refer to this [guide for Bryntum NPM repository access](#Scheduler/guides/npm-repository.md).

To use native API package classes with wrappers import them from `@bryntum/scheduler/scheduler.umd`.

```javascript
import { Scheduler } from '@bryntum/scheduler/scheduler.umd';
```

### Wrappers Overview

Wrappers are React components which provide full access to Bryntum API widget class configs, properties, events and
features. Each Wrapper has it's own tag which can be used in React JSX code. This is the list of available wrappers for
Bryntum Scheduler React package.

| Wrapper name | API widget reference |
|--------------|----------------------|
| &lt;BryntumButton/&gt; | [Button](#Core/widget/Button) |
| &lt;BryntumButtonGroup/&gt; | [ButtonGroup](#Core/widget/ButtonGroup) |
| &lt;BryntumCheckbox/&gt; | [Checkbox](#Core/widget/Checkbox) |
| &lt;BryntumChipView/&gt; | [ChipView](#Core/widget/ChipView) |
| &lt;BryntumCombo/&gt; | [Combo](#Core/widget/Combo) |
| &lt;BryntumContainer/&gt; | [Container](#Core/widget/Container) |
| &lt;BryntumDateField/&gt; | [DateField](#Core/widget/DateField) |
| &lt;BryntumDatePicker/&gt; | [DatePicker](#Core/widget/DatePicker) |
| &lt;BryntumDateTimeField/&gt; | [DateTimeField](#Core/widget/DateTimeField) |
| &lt;BryntumDurationField/&gt; | [DurationField](#Core/widget/DurationField) |
| &lt;BryntumFileField/&gt; | [FileField](#Core/widget/FileField) |
| &lt;BryntumFilePicker/&gt; | [FilePicker](#Core/widget/FilePicker) |
| &lt;BryntumFilterField/&gt; | [FilterField](#Core/widget/FilterField) |
| &lt;BryntumGrid/&gt; | [Grid](#Grid/view/Grid) |
| &lt;BryntumGridBase/&gt; | [GridBase](#Grid/view/GridBase) |
| &lt;BryntumList/&gt; | [List](#Core/widget/List) |
| &lt;BryntumMenu/&gt; | [Menu](#Core/widget/Menu) |
| &lt;BryntumNumberField/&gt; | [NumberField](#Core/widget/NumberField) |
| &lt;BryntumPagingToolbar/&gt; | [PagingToolbar](#Core/widget/PagingToolbar) |
| &lt;BryntumPanel/&gt; | [Panel](#Core/widget/Panel) |
| &lt;BryntumResourceCombo/&gt; | [ResourceCombo](#Scheduler/widget/ResourceCombo) |
| &lt;BryntumResourceFilter/&gt; | [ResourceFilter](#Scheduler/widget/ResourceFilter) |
| &lt;BryntumScheduler/&gt; | [Scheduler](#Scheduler/view/Scheduler) |
| &lt;BryntumSchedulerBase/&gt; | [SchedulerBase](#Scheduler/view/SchedulerBase) |
| &lt;BryntumSlider/&gt; | [Slider](#Core/widget/Slider) |
| &lt;BryntumSlideToggle/&gt; | [SlideToggle](#Core/widget/SlideToggle) |
| &lt;BryntumSplitter/&gt; | [Splitter](#Core/widget/Splitter) |
| &lt;BryntumTabPanel/&gt; | [TabPanel](#Core/widget/TabPanel) |
| &lt;BryntumTextAreaField/&gt; | [TextAreaField](#Core/widget/TextAreaField) |
| &lt;BryntumTextField/&gt; | [TextField](#Core/widget/TextField) |
| &lt;BryntumTimeField/&gt; | [TimeField](#Core/widget/TimeField) |
| &lt;BryntumToolbar/&gt; | [Toolbar](#Core/widget/Toolbar) |
| &lt;BryntumUndoRedo/&gt; | [UndoRedo](#Scheduler/widget/UndoRedo) |
| &lt;BryntumWidget/&gt; | [Widget](#Core/widget/Widget) |

### Using the wrapper in your application

The wrapper defines a React component named `BryntumScheduler`. You can use it the same way as you would use other React
components. For example:

```javascript
import React from 'react';
import { BryntumScheduler } from '@bryntum/scheduler-react';
import { schedulerConfig } from './AppConfig'

export const App = () => {
    return (
        <BryntumScheduler
            {...schedulerConfig}
            // other props, event handlers, etc
        />
    );
}
```

`AppConfig.js` may look like:

```javascript
export const schedulerConfig =  {
    tooltip : "My cool Scheduler component",
    // Scheduler config options
};
```

### Syncing bound data changes

The stores used by the wrapper enable [syncDataOnLoad](#Core/data/Store#config-syncDataOnLoad) by default (Stores not
used by the wrapper have it disabled by default). This allows two-way binding to work out of the box.
Without `syncDataOnLoad`, each change to state would apply the bound data as a completely new dataset.
With `syncDataOnLoad`, the new state is instead compared to the old, and the differences are applied.

## Rendering React components in column cells

Bryntum Scheduler column already supports a [renderer](#Grid/column/Column#config-renderer) configuration option which is
a function that receives parameters used as inputs to compose the resulting html. Any kind of conditional complex logic
can be used to prepare visually rich cell contents.

If you have a React component that implements the desired cell visualization, it is possible to use it by using regular
JSX which references your React components from the cell renderer. The support is implemented in the `BryntumScheduler`
wrapper therefore the wrapper must be used for the JSX renderers to work.

### Using simple inline JSX

Using inline JSX is as simple as the following:

```javascript
renderer: ({ value }) => <CustomComponent>{value}</CustomComponent>
```

If you also need to access other data fields or pass them into the React component, you can do it this way:

```javascript
renderer: (renderData) => {
  return(
    <CustomComponent dataProperty={renderData} ><b>{renderData.value}</b>/{renderData.record.city}</CustomComponent>
  );
}
```

_**Note:** Mind please that the above functions return html-like markup without quotes. That makes the return value JSX
and it is understood and processed as such. If you enclose the markup in quotes it will not work._

### Using a custom React component

It is similarly simple. Let's have the following simple component:

```javascript
import React from 'react';

const DemoButton = props => {
    return <button {...props}>{props.text}</button>;
};

```

The renderer then could be:

```javascript
import DemoButton from '../components/DemoButton';

handleCellButtonClick = (record) => {
    alert('Go ' + record.team + '!');
};

return (
  <BryntumScheduler
    // Columns
    columns = {[
      {
        // Using custom React component
        renderer : ({ record }) =>
          <DemoButton
            text = {'Go ' + record.team + '!'}
            onClick = {() => handleCellButtonClick(record)}
          />,
        // other column props,
      },
      // ... other columns
    ]}
    // ... other BryntumScheduler props
  />
);
```

The column `renderer` function above is expected to return JSX, exactly same as in the case of simple inline JSX, but
here it returns imported `DemoButton` component. The `renderer` also passes the mandatory props down to the component so
that it can render itself in the correct row context.

## Configs, properties and events

All Bryntum React Wrappers support the full set of the public configs, properties and events of a component.

### Listening to BryntumScheduler events

The conventional React way is used to listen to Scheduler events. For example, if we want to listen to `selectionChange`
event we pass the listener function to `onSelectionChange` property. The property name must be camel case and is case
sensitive.

```javascript
const selectionChangeHandler = useCallback(({ selection }) => {
    console.log(selection); // actual logic comes here
});

// ...

return (
    <BryntumScheduler
        onSelectionChange={selectionChangeHandler}
        // other properties
    />
)
```

You can find details of all events that are fired by BryntumScheduler in
the [API documentation](https://bryntum.com/docs/scheduler/#Scheduler/view/Scheduler#events).

## Features

Features are suffixed with `Feature` and act as both configs and properties for `BryntumSchedulerComponent`. They are
mapped to the corresponding API features of the `instance`.

This is a list of all `BryntumScheduler` features:

|Wrapper feature name|API feature reference |
|--------------------|----------------------|
| cellEditFeature | [cellEdit](#Grid/feature/CellEdit) |
| cellMenuFeature | [cellMenu](#Grid/feature/CellMenu) |
| cellTooltipFeature | [cellTooltip](#Grid/feature/CellTooltip) |
| columnAutoWidthFeature | [columnAutoWidth](#Grid/feature/ColumnAutoWidth) |
| columnDragToolbarFeature | [columnDragToolbar](#Grid/feature/ColumnDragToolbar) |
| columnLinesFeature | [columnLines](#Scheduler/feature/ColumnLines) |
| columnPickerFeature | [columnPicker](#Grid/feature/ColumnPicker) |
| columnReorderFeature | [columnReorder](#Grid/feature/ColumnReorder) |
| columnResizeFeature | [columnResize](#Grid/feature/ColumnResize) |
| contextMenuFeature | [contextMenu](#Grid/feature/ContextMenu) |
| dependenciesFeature | [dependencies](#Scheduler/feature/Dependencies) |
| dependencyEditFeature | [dependencyEdit](#Scheduler/feature/DependencyEdit) |
| eventContextMenuFeature | [eventContextMenu](#Scheduler/feature/EventContextMenu) |
| eventCopyPasteFeature | [eventCopyPaste](#Scheduler/feature/EventCopyPaste) |
| eventDragCreateFeature | [eventDragCreate](#Scheduler/feature/EventDragCreate) |
| eventDragFeature | [eventDrag](#Scheduler/feature/EventDrag) |
| eventDragSelectFeature | [eventDragSelect](#Scheduler/feature/EventDragSelect) |
| eventEditFeature | [eventEdit](#Scheduler/feature/EventEdit) |
| eventFilterFeature | [eventFilter](#Scheduler/feature/EventFilter) |
| eventMenuFeature | [eventMenu](#Scheduler/feature/EventMenu) |
| eventResizeFeature | [eventResize](#Scheduler/feature/EventResize) |
| eventTooltipFeature | [eventTooltip](#Scheduler/feature/EventTooltip) |
| excelExporterFeature | [ExcelExporter](#Scheduler/feature/experimental/ExcelExporter) |
| filterBarFeature | [filterBar](#Grid/feature/FilterBar) |
| filterFeature | [filter](#Grid/feature/Filter) |
| groupFeature | [group](#Grid/feature/Group) |
| groupSummaryFeature | [groupSummary](#Scheduler/feature/GroupSummary) |
| headerContextMenuFeature | [headerContextMenu](#Scheduler/feature/HeaderContextMenu) |
| headerMenuFeature | [headerMenu](#Grid/feature/HeaderMenu) |
| headerZoomFeature | [headerZoom](#Scheduler/feature/HeaderZoom) |
| labelsFeature | [labels](#Scheduler/feature/Labels) |
| nonWorkingTimeFeature | [nonWorkingTime](#Scheduler/feature/NonWorkingTime) |
| panFeature | [pan](#Scheduler/feature/Pan) |
| pdfExportFeature | [PdfExport](#Scheduler/feature/export/PdfExport) |
| quickFindFeature | [quickFind](#Grid/feature/QuickFind) |
| regionResizeFeature | [regionResize](#Grid/feature/RegionResize) |
| resourceTimeRangesFeature | [resourceTimeRanges](#Scheduler/feature/ResourceTimeRanges) |
| rowCopyPasteFeature | [rowCopyPaste](#Grid/feature/RowCopyPaste) |
| rowReorderFeature | [rowReorder](#Grid/feature/RowReorder) |
| scheduleContextMenuFeature | [scheduleContextMenu](#Scheduler/feature/ScheduleContextMenu) |
| scheduleMenuFeature | [scheduleMenu](#Scheduler/feature/ScheduleMenu) |
| scheduleTooltipFeature | [scheduleTooltip](#Scheduler/feature/ScheduleTooltip) |
| searchFeature | [search](#Grid/feature/Search) |
| simpleEventEditFeature | [simpleEventEdit](#Scheduler/feature/SimpleEventEdit) |
| sortFeature | [sort](#Grid/feature/Sort) |
| stickyCellsFeature | [stickyCells](#Grid/feature/StickyCells) |
| stickyEventsFeature | [stickyEvents](#Scheduler/feature/StickyEvents) |
| stripeFeature | [stripe](#Grid/feature/Stripe) |
| summaryFeature | [summary](#Scheduler/feature/Summary) |
| timeAxisHeaderMenuFeature | [timeAxisHeaderMenu](#Scheduler/feature/TimeAxisHeaderMenu) |
| timeRangesFeature | [timeRanges](#Scheduler/feature/TimeRanges) |
| treeFeature | [tree](#Grid/feature/Tree) |

## The native Bryntum Scheduler instance

It is important to know that the React component that we may even call "scheduler" is _not_ the native Bryntum Scheduler
instance, it is a wrapper or an interface between the React application and the Bryntum Scheduler itself.

The properties and features are propagated from the wrapper down to the underlying Bryntum Scheduler instance but there
might be the situations when you want to access the Bryntum Scheduler directly. That is fully valid approach and you are
free to do it.

### Accessing the Bryntum Scheduler instance

If you need to access Scheduler instance, you can do like this:

```javascript
const schedulerRef = useRef();

useEffect(()=>{
  // the instance is available as
  console.log(schedulerRef.current.instance);
},[])

return <BryntumScheduler ref={schedulerRef} {...schedulerConfig} />
```

## Using Bryntum Scheduler themes

For the scheduler styling you must also import a CSS file that contains a theme for Bryntum Scheduler. There are
two main ways of importing the theme.

### Using single theme

The easiest way is to import the CSS file in your `App.js` or in `App.scss`.

In `App.js` you would import **one** of the following:

```javascript
import '@bryntum/scheduler/scheduler.classic-dark.css';
import '@bryntum/scheduler/scheduler.classic-light.css';
import '@bryntum/scheduler/scheduler.classic.css';
import '@bryntum/scheduler/scheduler.material.css';
import '@bryntum/scheduler/scheduler.stockholm.css';
```

The syntax is slightly different in `App.scss`; use **one** of the following:

```scss
@import '~@bryntum/scheduler/scheduler.classic-dark.css';
@import '~@bryntum/scheduler/scheduler.classic-light.css';
@import '~@bryntum/scheduler/scheduler.classic.css';
@import '~@bryntum/scheduler/scheduler.material.css';
@import '~@bryntum/scheduler/scheduler.stockholm.css';
```

Note: Importing theme in `App.scss` file is recommended because this way we keep all styling-related code
together in one file.

### Selecting from multiple themes

Theme switching can be implemented with the help of the `<BryntumThemeCombo />` component. It has to be imported
as any other component before it is used, for example:

```javascript
import { BryntumThemeCombo, } from '@bryntum/scheduler-react';

// ... other code

return (
    // ... other components
    <BryntumThemeCombo />
    // ... other components
);

```

CSS and fonts files that contain themes must be accessible by the server in any subdirectory of the public server
root in `themes` and `themes/fonts`. The easiest way of putting them there is to copy the files automatically during
`postinstall` process in `package.json`:

```json
  "scripts": {
    "postinstall": "postinstall"
  },
  "postinstall": {
    "node_modules/@bryntum/scheduler/*.css": "copy public/themes/",
    "node_modules/@bryntum/scheduler/fonts": "copy public/themes/fonts"
  },
  "devDependencies": {
    "postinstall": "~0.7.0"
  }
},
```

Note: use `npm install --save-dev postinstall` to install the required `postinstall` package or add it manually
to `package.json`.

The last part is to add the default theme link to the head of `public/index.html`:

```html
<head>
  <link
    rel="stylesheet"
  	href="%PUBLIC_URL%/themes/scheduler.stockholm.css"
  	id="bryntum-theme"
  />
</head>
```

Note: `id="bryntum-theme"` is mandatory because `BryntumThemeCombo` relies on it.

Note: If you adjust location of themes and fonts, adjust it in both `package.json` and in `index.html`, for example
`my-resources/themes/` and `my-resources/themes/fonts`. No other configuration is needed.

## Loading components dynamically with Next.js

Bryntum components are client-side only, they do not support server-side rendering. Therefore they must be loaded with
`ssr` turned off. Furthermore, the life cycle of dynamically loaded components is different from normal React
components hence the following steps are needed.

The BryntumScheduler must be wrapped in another component so that React `refs` will continue to work. To implement it
create a folder outside of Next.js `pages`, for example `components`, and put this extra wrapper there. For example:

`components/Scheduler.js`:

```javascript
/**
 * A simple wrap around BryntumScheduler for ref to work
 */
import { BryntumScheduler } from '@bryntum/scheduler-react';

export default function Scheduler({schedulerRef, ...props }) {
    return <BryntumScheduler {...props} ref={schedulerRef} />
}
```

The above component then can be loaded dynamically with this code:

```javascript
import dynamic from "next/dynamic";
import { useRef } from 'react';

const Scheduler = dynamic(
  () => import("../components/Scheduler.js"), {ssr: false}
);

const MyComponent = () => {
  const schedulerRef = useRef();

  const clickHandler = function(e) {
    // This will log the Scheduler native instance after it has been loaded
    console.log(schedulerRef.current?.instance);
  }

  return (
    <>
      <button onClick={clickHandler}>ref test</button>
      <Scheduler
        schedulerRef={schedulerRef}
        // other props
      />
    </>
```

## CRA performance

CRA scripts by default use `@babel/plugin-transform-runtime` plugin to transpile application's `*.js` library
dependencies. This affects React application performance, which is seriously degraded due to heavy usage of `async`
functions in the Bryntum API.

### Workaround

We offer an updated babel preset `@bryntum/babel-preset-react-app` npm package for CRA scripts to solve this issue.
Patch details can be found inside package `@bryntum/babel-preset-react-app/readme-bryntum.md`.

Add this package alias to your application's `package.json` in `devDependencies`:

```json
  "devDependencies": {
    "babel-preset-react-app": "npm:@bryntum/babel-preset-react-app"
  }
```

Or install with command line:

```shell
npm i --save-dev babel-preset-react-app@npm:@bryntum/babel-preset-react-app
```

Use `browserlist` option to enable most modern browsers babel configuration in app's `package.json`:

```json
     "browserslist": {
       "production": [
         "last 1 chrome version",
         "last 1 firefox version",
         "last 1 safari version"
       ]
     }
```

### CRA references

* [Original CRA scripts](https://github.com/facebook/create-react-app)
* [Alternatives to Ejecting](https://create-react-app.dev/docs/alternatives-to-ejecting)
* Customizing create-react-app: [How to Configure CRA](https://auth0.com/blog/how-to-configure-create-react-app)

## Best practices

There are many possible ways of creating and building React applications ranging from the recommended default way of
using [Create React App](https://create-react-app.dev/) scripts through applications initially created with Create React
App but ejected later, up to very custom setups using Webpack or another packager and manually created application.

We used Create React App to create all our React examples and it has proven to be the simples, most compatible and most
reliable way of using Bryntum Scheduler in a React application.

The broad steps are as follows:

* Download the Bryntum Scheduler, trial or full version depending on your license
* Use `npx create-react-app bryntum-demo` to create a basic empty React application
* Install `@bryntum/scheduler-react` package according to section **Install Scheduler npm package** above
* Optional: Copy `BryntumScheduler.js` wrapper
* Import and use the `BryntumScheduler` in the application
* Import a Scheduler CSS file, for example `scheduler.stockholm.css` to achieve the proper Scheduler look

Our examples also use resources from `@bryntum/demo-resources`, for example `example.scss`, fonts and images that are
used to style demo's header, logo, etc. These are generally not needed in your application because you have different
logo, colors, layout of header, etc.

We recommend to use the above procedure and create the application from scratch but if you take our demo as the basis,
do not forget to clean it up from imports, resources, css files and rules that are not needed.

Also we do not recommend to copy the downloaded and unzipped Scheduler to your project tree not only because it would
bloat the size but mainly because it can fool the IDE to propose auto-imports from the wrong places.

If you decide to copy the files from Bryntum download to your project, always copy selectively only the source files you
need, not the whole distribution.

Please consult Custom Configurations section below if your project has not been created with Create React App.

## Troubleshooting

### Installing, building or running

If you face any issues building or running examples or your application, such issues can be often resolved by the
Project Cleanup procedure which is described in this
[Troubleshooting guide](#Scheduler/guides/npm-repository.md#troubleshooting)

### Bryntum bundle included twice

The error `Bundle included twice` usually means that somewhere you have imported both the normal and UMD versions of the
Scheduler package. Check inspect the code and import either UMD or normal version of the Scheduler but not both. Scheduler
wrapper uses `scheduler.umd.js`.

## References

* Config options, features, events and methods [API docs](#api)
* Visit [React Framework Homepage](https://reactjs.org)
* Post your questions to [Bryntum Support Forum](https://bryntum.com/forum)
* [Contacts us](https://www.bryntum.com/contact)


<p class="last-modified">Last modified on 2021-07-07 4:09:55</p>