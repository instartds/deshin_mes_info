<template>
  <div class="charts-page">
    <div class="va-row">
      <div class="flex md6 xs12">
        <vuestic-widget
          class="chart-widget"
          :headerText="$t('charts.verticalBarChart')"
        >
          <vuestic-chart :data="verticalBarChartData" type="vertical-bar"/>
        </vuestic-widget>
      </div>
      <div class="flex md6 xs12">
        <vuestic-widget
          class="chart-widget"
          :headerText="$t('charts.horizontalBarChart')"
        >
          <vuestic-chart :data="horizontalBarChartData" type="horizontal-bar"/>
        </vuestic-widget>
      </div>
    </div>

    <div class="va-row">
      <div class="flex md12 xs12">
        <vuestic-widget
          class="chart-widget"
          :headerText="$t('charts.lineChart')"
        >
          <vuestic-chart :data="lineChartData" type="line"/>
        </vuestic-widget>
      </div>
    </div>

    <div class="va-row">
      <div class="flex md6 xs12">
        <vuestic-widget
          class="chart-widget"
          :headerText="$t('charts.pieChart')"
        >
          <vuestic-chart :data="pieChartData" type="pie"/>
        </vuestic-widget>
      </div>
      <div class="flex md6 xs12">
        <vuestic-widget
          class="chart-widget"
          :headerText="$t('charts.donutChart')"
        >
          <vuestic-chart :data="donutChartData" type="donut"/>
        </vuestic-widget>
      </div>
    </div>

    <div class="va-row">
      <div class="flex md12 xs12">
        <vuestic-widget
          class="chart-widget"
          :headerText="$t('charts.bubbleChart')"
        >
          <vuestic-chart :data="bubbleChartData" type="bubble"/>
        </vuestic-widget>
      </div>
    </div>
  </div>
</template>

<script>
import { getLineChartData } from '../../../data/charts/LineChartData.js'
import BubbleChartData from '../../../data/charts/BubbleChartData.js'
import PieChartData from '../../../data/charts/PieChartData.js'
import DonutChartData from '../../../data/charts/DonutChartData.js'
import VerticalBarChartData from '../../../data/charts/VerticalBarChartData.js'
import HorizontalBarChartData from '../../../data/charts/HorizontalBarChartData.js'
import SidebarLink from '../../admin/app-sidebar/components/SidebarLink.vue'

export default {
  name: 'charts',
  components: {
    SidebarLink,
  },
  data: () => ({
    bubbleChartData: BubbleChartData,
    lineChartData: getLineChartData(),
    pieChartData: PieChartData,
    donutChartData: DonutChartData,
    verticalBarChartData: VerticalBarChartData,
    horizontalBarChartData: HorizontalBarChartData,
  }),
  methods: {
    refreshData () {
      this.lineChartData = getLineChartData()
    },
  },
}
</script>

<style lang="scss">
.widget.chart-widget {
  .widget-body {
    height: 550px;
  }
}
</style>
