import { BrowserHelper } from '../../build/scheduler.module.js';

StartTest(t => {
    let scheduler;

    t.beforeEach(() => scheduler?.destroy?.());

    t.it('Should support setting eventColor to known value with eventStyle colored', async t => {
        scheduler = t.getScheduler({
            startDate : new Date(2011, 0, 2),
            events    : [
                {
                    id         : 'e4-1',
                    startDate  : '2011-01-03',
                    endDate    : '2011-01-04',
                    eventColor : 'red',
                    eventStyle : 'colored',
                    resourceId : 'r1'
                }
            ]
        });

        await t.waitForSelector('.b-sch-event');

        const barEl = t.query('.b-sch-event')[0];

        t.is(window.getComputedStyle(barEl).backgroundColor, 'rgb(255, 231, 231)', 'Background');
        t.is(window.getComputedStyle(barEl).borderLeftColor, 'rgb(255, 96, 96)', 'Border left');
    });

    !(BrowserHelper.isIE11 || BrowserHelper.isEdge) && t.it('Should support setting eventColor to hex value with eventStyle colored', async t => {
        scheduler = t.getScheduler({
            startDate : new Date(2011, 0, 2),
            events    : [
                {
                    id         : 'e4-1',
                    startDate  : '2011-01-03',
                    endDate    : '2011-01-04',
                    eventColor : '#333',
                    eventStyle : 'colored',
                    resourceId : 'r1'
                }
            ]
        });

        await t.waitForSelector('.b-sch-event');

        const barEl = t.query('.b-sch-event')[0];

        t.is(window.getComputedStyle(barEl).backgroundColor, 'rgb(51, 51, 51)', 'Background');
        t.is(window.getComputedStyle(barEl).borderLeftColor, 'rgb(51, 51, 51)', 'Border left');
    });

    t.it('Should support setting color using hex, hsl, rgb, rgba', async t => {
        scheduler = t.getScheduler({
            startDate : new Date(2011, 0, 2),
            events    : [
                {
                    id         : 1,
                    startDate  : '2011-01-03',
                    endDate    : '2011-01-04',
                    eventColor : '#ff0000',
                    resourceId : 'r1'
                },
                {
                    id         : 2,
                    startDate  : '2011-01-03',
                    endDate    : '2011-01-04',
                    eventColor : 'rgba(255,0,0, 1)',
                    resourceId : 'r1'
                },
                {
                    id         : 3,
                    startDate  : '2011-01-03',
                    endDate    : '2011-01-04',
                    eventColor : 'rgb(255, 0, 0)',
                    resourceId : 'r1'
                },
                {
                    id         : 4,
                    startDate  : '2011-01-03',
                    endDate    : '2011-01-04',
                    eventColor : 'hsl(0, 100%, 50%)',
                    resourceId : 'r1'
                }
            ]
        });

        await t.waitForSelector('.b-sch-event');

        const
            events = t.query('.b-sch-event'),
            hexEl  = events[0],
            rgbaEl = events[1],
            rgbEl  = events[2],
            hslEl  = events[3];

        t.is(window.getComputedStyle(hexEl).backgroundColor, 'rgb(255, 0, 0)', 'Hex Background ok');
        t.is(window.getComputedStyle(rgbaEl).backgroundColor, 'rgb(255, 0, 0)', ' rgba Background ok');
        t.is(window.getComputedStyle(rgbEl).backgroundColor, 'rgb(255, 0, 0)', 'rgb Background ok');
        t.is(window.getComputedStyle(hslEl).backgroundColor, 'rgb(255, 0, 0)', 'hsl Background ok');
    });

});
