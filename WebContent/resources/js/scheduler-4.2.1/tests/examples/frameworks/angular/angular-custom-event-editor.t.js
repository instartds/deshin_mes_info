/**
 * Custom event editor test
 */
StartTest(t => {
    t.chain(
        // basic rendering
        { waitForSelector : '.b-timelinebase' },

        // test if popup opens and can save name
        { dblClick : '.b-sch-event:contains("Meeting #1")' },
        { waitForSelector : '.mat-dialog-title:contains("Meeting #1")' },
        { click : 'input[placeholder="Event name"]' },
        { type : ' is important' },
        { click : 'button:textEquals("Save")' },
        { waitForSelector : '.b-sch-event:contains("Meeting #1 is important")' },

        // test if popup can cancel edits
        { dblClick : '.b-sch-event-wrap :contains("Meeting #2")', offset : [10, 10] },
        { waitForSelector : '.mat-dialog-title:contains("Meeting #2")' },
        { click : 'input[placeholder="Event name"]' },
        { type : ' is important' },
        { click : 'button:textEquals("Cancel")' },
        { waitForSelectorNotFound : '.b-sch-event:contains("Meeting #2 is important")' }

    );

});
