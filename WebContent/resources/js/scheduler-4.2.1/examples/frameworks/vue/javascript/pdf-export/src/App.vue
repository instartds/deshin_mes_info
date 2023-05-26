<!-- Application -->
<template>
    <div id="app">
        <bryntum-demo-header
            title="Vue PDF export demo"
            link="../../../../../#example-frameworks-vue-javascript-pdf-export"
        />
        <div class="demo-toolbar align-right">
            <bryntum-button
                cls="b-deep-orange b-raised"
                text="Export"
                @click="exportHandler"
            />
        </div>
        <bryntum-scheduler ref="scheduler" v-bind="schedulerConfig" />
    </div>
</template>

<script>
import {
    BryntumScheduler,
    BryntumDemoHeader,
    BryntumButton
} from '@bryntum/scheduler-vue';
import { schedulerConfig } from './AppConfig.js';

export default {
    name: 'App',

    components: {
        BryntumDemoHeader,
        BryntumScheduler,
        BryntumButton
    },

    data() {
        return {
            schedulerConfig
        };
    },

    methods: {
        exportHandler() {
            this.$refs.scheduler.instance.features.pdfExport.showExportDialog();
        }
    }
};
</script>

<style lang="scss">
@import './App.scss';
</style>
