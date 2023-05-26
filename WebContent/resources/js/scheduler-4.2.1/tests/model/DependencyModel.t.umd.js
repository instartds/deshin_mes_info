StartTest(function (t) {
  t.it('highlight/unhighlight works correctly', function (t) {
    var dependency = new DependencyModel({
      fromId: 1,
      toId: 2
    });
    t.notOk(dependency.highlighted);
    dependency.unhighlight('heh');
    t.notOk(dependency.highlighted);
    dependency.highlight('foo');
    t.is(dependency.highlighted, 'foo');
    dependency.highlight('foo');
    t.is(dependency.highlighted, 'foo');
    dependency.highlight('bar');
    t.is(dependency.highlighted, 'foo bar');
    dependency.highlight('bar');
    t.is(dependency.highlighted, 'foo bar');
    dependency.unhighlight('foo');
    t.is(dependency.highlighted, 'bar');
    dependency.unhighlight('foo');
    t.is(dependency.highlighted, 'bar');
    dependency.unhighlight('bar');
    t.is(dependency.highlighted, '');
  });
});