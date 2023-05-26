StartTest(function (t) {
  t.diag('For visual inspection');
  PresetManager.forEach(function (preset, i) {
    t.getScheduler({
      width: 300,
      height: 200,
      style: 'float:left;margin-left:5px',
      columns: [],
      resources: [],
      events: []
    }).zoomToLevel(i);
  });
});