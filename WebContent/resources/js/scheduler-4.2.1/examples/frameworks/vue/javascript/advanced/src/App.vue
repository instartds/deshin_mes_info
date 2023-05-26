<!--
 * Main App component
 -->
<template>
    <div id="app">
        <demo-header
            title="Vue Advanced demo"
            link='../../../../../#example-frameworks-vue-javascript-advanced'
        />
        <keep-alive>
            <router-view/>
        </keep-alive>
  </div>
</template>

<script>
    // Stockholm theme
    import 'bootstrap/scss/bootstrap.scss';
    // Bootstrap css forces page and body size
    // https://github.com/twbs/bootstrap/issues/25629
    import './bootstrap-fix.css';

    import DemoHeader from './components/header/Header';

    export default {
        components : {
            DemoHeader
        }
    }
</script>

<style lang="scss">
    @import './App.scss';
</style>
