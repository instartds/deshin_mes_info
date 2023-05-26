/**
 * Custom event editor test
 */
StartTest(t => {
    t.chain(
        // basic rendering
        { waitForSelector : '.b-timelinebase' },

        // test if popup opens and can save name
        { dblClick : '.b-sch-event:contains("Meeting #1")' },
        { waitForSelector : '.popup header:textEquals("Meeting #1")' },
        { click : '.popup input[name=name]' },
        { type : ' is important' },
        { click : '.popup button:textEquals("Save")' },
        { waitForSelector : '.b-sch-event:contains("Meeting #1 is important")' },

        // test if popup can cancel edits
        { dblClick : '.b-sch-event-wrap :contains("Meeting #2")', offset : [80, 10] },
        { waitForSelector : '.popup header:textEquals("Meeting #2")' },
        { click : '.popup input[name=name]' },
        { type : ' is important' },
        { click : '.popup button:textEquals("Cancel")' },
        { waitForSelectorNotFound : '.b-sch-event:contains("Meeting #2 is important")' }

    ); // eo t.chain

}); // eo StartTest

// eof
