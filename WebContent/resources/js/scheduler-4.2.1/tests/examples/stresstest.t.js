StartTest(async t => {

    await t.waitForSelector('.b-scheduler .b-sch-event');
    t.pass('Example rendered without exception');

    t.waitForAnimations = cb => cb();
    bryntum.query('slider').value = 80;

    t.monkeyTest({
        target          : '.b-scheduler',
        nbrInteractions : 30,
        async callback() {
            await t.click('.b-button:contains(Stop)');
            await t.waitForSelectorNotFound('.b-animating');
        }
    });

});
