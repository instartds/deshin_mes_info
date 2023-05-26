<h1 class="title-with-image"><img src="Core/logo/vue.png" 
alt="Bryntum Scheduler supports Vue"/>Using Bryntum Scheduler with Vue</h1>

## Bryntum NPM repository access

Please refer to this [guide for Bryntum NPM repository access](#Scheduler/guides/npm-repository.md).

## Bryntum Scheduler

Scheduler itself is framework agnostic, but it ships with demos and wrappers to simplify using it with popular frameworks
such as Vue. The purpose of this guide is to give a basic introduction on how to use Scheduler with Vue.

## View online demos

Bryntum Scheduler Vue demos can be viewed in our
[online example browser](https://bryntum.com/examples/scheduler/#Integration/Vue).

## Build and run local demos

Vue demos are located in **examples/frameworks/vue** and **examples/frameworks/vue-3** folders inside distribution zip.

Trial distribution zip can be requested from [https://www.bryntum.com](https://www.bryntum.com/products/scheduler)
by clicking **Free Trial** button. Licensed distribution zip is located at
[Bryntum Customer Zone](https://customerzone.bryntum.com).

Each demo contains bundled `README.md` file in demo folder with build and run instructions.

To view and run an example locally in development mode, you can use the following commands:

```shell
$ npm install
$ npm run start
```

That starts a local server accessible at [http://127.0.0.1:8080](http://127.0.0.1:8080). If you modify the example code
while running it locally it is automatically rebuilt and updated in the browser allowing you to see your changes
immediately.

The production version of an example, or your application, is built by running:

```shell
$ npm install
$ npm run build
```

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

The Vue wrappers encapsulate Bryntum Scheduler and other Bryntum widgets in Vue components that expose
configuration options, properties, features and events. The wrapped all Bryntum UI components so they can be used the
usual Vue way.

To use native API package classes with wrappers import them from `@bryntum/scheduler`.

```javascript
import { Scheduler } from '@bryntum/scheduler';
```

### Installing the wrappers package

The wrappers are distributed as a separate package `@bryntum/scheduler-vue` that is installed according to the used
package manager. Please refer to this [guide for Bryntum NPM repository access](#Scheduler/guides/npm-repository.md).

### Wrappers Overview

Wrappers are Vue components which provide full access to Bryntum API widget class configs, properties, events and
features. Each Wrapper has it's own HTML tag which can be used in vue templates. This is the list of available
wrappers for Bryntum Scheduler Vue package:

| Wrapper tag name | API widget reference |
|------------------|----------------------|
| &lt;bryntum-button/&gt; | [Button](#Core/widget/Button) |
| &lt;bryntum-button-group/&gt; | [ButtonGroup](#Core/widget/ButtonGroup) |
| &lt;bryntum-checkbox/&gt; | [Checkbox](#Core/widget/Checkbox) |
| &lt;bryntum-chip-view/&gt; | [ChipView](#Core/widget/ChipView) |
| &lt;bryntum-combo/&gt; | [Combo](#Core/widget/Combo) |
| &lt;bryntum-container/&gt; | [Container](#Core/widget/Container) |
| &lt;bryntum-date-field/&gt; | [DateField](#Core/widget/DateField) |
| &lt;bryntum-date-picker/&gt; | [DatePicker](#Core/widget/DatePicker) |
| &lt;bryntum-date-time-field/&gt; | [DateTimeField](#Core/widget/DateTimeField) |
| &lt;bryntum-duration-field/&gt; | [DurationField](#Core/widget/DurationField) |
| &lt;bryntum-file-field/&gt; | [FileField](#Core/widget/FileField) |
| &lt;bryntum-file-picker/&gt; | [FilePicker](#Core/widget/FilePicker) |
| &lt;bryntum-filter-field/&gt; | [FilterField](#Core/widget/FilterField) |
| &lt;bryntum-grid/&gt; | [Grid](#Grid/view/Grid) |
| &lt;bryntum-grid-base/&gt; | [GridBase](#Grid/view/GridBase) |
| &lt;bryntum-list/&gt; | [List](#Core/widget/List) |
| &lt;bryntum-menu/&gt; | [Menu](#Core/widget/Menu) |
| &lt;bryntum-number-field/&gt; | [NumberField](#Core/widget/NumberField) |
| &lt;bryntum-paging-toolbar/&gt; | [PagingToolbar](#Core/widget/PagingToolbar) |
| &lt;bryntum-panel/&gt; | [Panel](#Core/widget/Panel) |
| &lt;bryntum-resource-combo/&gt; | [ResourceCombo](#Scheduler/widget/ResourceCombo) |
| &lt;bryntum-resource-filter/&gt; | [ResourceFilter](#Scheduler/widget/ResourceFilter) |
| &lt;bryntum-scheduler/&gt; | [Scheduler](#Scheduler/view/Scheduler) |
| &lt;bryntum-scheduler-base/&gt; | [SchedulerBase](#Scheduler/view/SchedulerBase) |
| &lt;bryntum-slider/&gt; | [Slider](#Core/widget/Slider) |
| &lt;bryntum-slide-toggle/&gt; | [SlideToggle](#Core/widget/SlideToggle) |
| &lt;bryntum-splitter/&gt; | [Splitter](#Core/widget/Splitter) |
| &lt;bryntum-tab-panel/&gt; | [TabPanel](#Core/widget/TabPanel) |
| &lt;bryntum-text-area-field/&gt; | [TextAreaField](#Core/widget/TextAreaField) |
| &lt;bryntum-text-field/&gt; | [TextField](#Core/widget/TextField) |
| &lt;bryntum-time-field/&gt; | [TimeField](#Core/widget/TimeField) |
| &lt;bryntum-toolbar/&gt; | [Toolbar](#Core/widget/Toolbar) |
| &lt;bryntum-undo-redo/&gt; | [UndoRedo](#Scheduler/widget/UndoRedo) |
| &lt;bryntum-widget/&gt; | [Widget](#Core/widget/Widget) |

### Using the wrapper in your application

Now you can use the the component defined in the wrapper in your application:

App.vue
```html
<template>
    <bryntum-scheduler 
        ref="scheduler"
        tooltip="schedulerConfig.tooltip"
        v-bind="schedulerConfig"
        @click="onClick"
    />
</template>

<script>

import { BryntumScheduler } from '@bryntum/scheduler-vue';
import { schedulerConfig } from './AppConfig';
import './components/ColorColumn.js';

export default {
    name: 'app',

    // local components
    components: {
        BryntumScheduler
    },
    data() {
        return { schedulerConfig };
    }
};
</script>

<style lang="scss">
@import './App.scss';
</style>
```

As shown above you can assign values and bind to Vue data with `tooltip="schedulerConfig.tooltip"` or `v-bind` option.
Listen to events with `@click="onClick"`, or use `v-on`.

`AppConfig.js` should contain a simple Scheduler configuration.
We recommend to keep it in a separate file because it can become lengthy especially for more advanced configurations.

AppConfig.js
```javascript
export const schedulerConfig =  {
    tooltip : "My cool Scheduler component"
    // Scheduler config options
};
```

Add `sass-loader` to your `package.json` if you used SCSS.

You will also need to import CSS file for Scheduler. 
The ideal place for doing it is the beginning of `App.scss/App.css` that would be imported in `App.vue`:

```javascript
@import "~@bryntum/scheduler/scheduler.stockholm.css";
```

### Syncing bound data changes

The stores used by the wrapper enable [syncDataOnLoad](#Core/data/Store#config-syncDataOnLoad) by default (Stores not
used by the wrapper have it disabled by default). It is done to make Vue column renderer update the value.
Without `syncDataOnLoad`, each time a new array of data is set to the store would apply the data as a completely new
dataset. With `syncDataOnLoad`, the new state is instead compared to the old, and the differences are applied.

## Configs, properties and events

All Bryntum Vue Wrappers support the full set of the public configs, properties and events of a component.

## Features

Features are suffixed with `Feature` and act as both configs and properties for `BryntumSchedulerComponent`.
They are mapped to the corresponding API features of the Scheduler `instance`.

This is a list of all `BryntumSchedulerComponent` features:

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

## Bryntum Scheduler API instance

It is important to know that the Vue `BryntumSchedulerComponent` is **not** the native Bryntum Scheduler instance, it
is a wrapper or an interface between the Vue application and the Bryntum Scheduler itself.

All available configs, properties and features are propagated from the wrapper down to the underlying Bryntum Scheduler
instance, but there might be the situations when you want to access the Bryntum Scheduler directly. That is fully valid
approach and you are free to do it.

### Accessing the Bryntum Scheduler instance (Vue 2)

If you need to access Scheduler functionality not exposed by the wrapper, you can access the Scheduler instance directly.
Within the **Vue 2** wrapper it is available under the `instance` property.

This simple example shows how you could use it:

App.vue
```html
<template>
    <bryntum-scheduler ref="scheduler" v-bind="schedulerConfig" />
</template>

<script>
// scheduler and its config
import { BryntumScheduler } from '@bryntum/scheduler-vue';
import { schedulerConfig } from './SchedulerConfig';
import './components/ColorColumn.js';

// App
export default {
    name: 'App',

    // local components
    components: {
        BryntumScheduler
    },

    data() {
        return { schedulerConfig };
    },

    methods: {
        doSomething() {
            // Reference to Scheduler instance
            const schedulerInstance = this.$refs.scheduler.instance;
        }
    }
};
</script>

<style lang="scss">
@import './App.scss';
</style>
```

When accessing `instance` directly, use wrapper's API widget reference docs from the list above to get available
configs and properties.

### Accessing the Bryntum Scheduler instance (Vue 3)

If you need to access Scheduler functionality not exposed by the wrapper, you can access the Scheduler instance directly.
Within the **Vue 3** wrapper it is available under the `instance.value` property.

This simple example shows how you could use it:

App.vue
```html
<template>
    <bryntum-scheduler ref="scheduler" v-bind="schedulerConfig" />
</template>

<script>
// vue imports
import { ref, reactive } from 'vue';

// scheduler and its config
import { BryntumScheduler } from '@bryntum/scheduler-vue-3';
import { useSchedulerConfig } from './SchedulerConfig';
import './components/ColorColumn.js';

// App
export default {
    name: 'App',

    // local components
    components: {
        BryntumScheduler
    },

    setup() {
        const scheduler = ref(null);
        const schedulerConfig = reactive(useSchedulerConfig());

        doSomething() {
            // Reference to Scheduler instance
            const schedulerInstance = scheduler.value.instance.value;
        }

        return {
            scheduler,
            schedulerConfig,
            doSomething
        };
    },
};
</script>

<style lang="scss">
@import './App.scss';
</style>
```

When accessing `instance` directly, use wrapper's API widget reference docs from the list above to get available
configs and properties.

## Troubleshooting

### Installing, building or running

If you face any issues building or running examples or your application, such issues can be often resolved by the
Project Cleanup procedure which is described in this
[Troubleshooting guide](#Scheduler/guides/npm-repository.md#troubleshooting)

### Transpiling dependencies
If you use Vue CLI, you can also try adding the following to your `vue.config.js`:

```javascript
module.exports = {
...
    transpileDependencies: [
        '@bryntum/scheduler'
    ],
};
```

### Custom Configurations

[Vue CLI](https://cli.vuejs.org/) is the default tooling for creating, developing and managing Vue applications so it
has been chosen for our examples. It also provides an abstraction level between the application and Webpack and easy
configurability of the project through `vue.config.js` file.

While this approach would be best in majority of cases, you can still have a custom Webpack configuration that is not
managed by Vue CLI. Although it is not feasible for us to support all possible custom configurations we have some
guidelines to make the Bryntum Calendar integration easier and smoother.

If you face any issues, executing one or more of the following steps should resolve the problem.

### Add or edit `.eslintignore` file

It may also be necessary to ignore linter for some files. If you do not have `.eslintignore` in your project root create
it (edit it otherwise) so that it has at least the following content:

```javascript
scheduler.module.js
```

## References

* Config options, features, events and methods [API docs](#api)
* Visit [Vue Framework Homepage](https://vuejs.org)
* Post your questions to [Bryntum Support Forum](https://bryntum.com/forum)
* [Contacts us](https://www.bryntum.com/contact)


<p class="last-modified">Last modified on 2021-07-07 4:09:55</p>