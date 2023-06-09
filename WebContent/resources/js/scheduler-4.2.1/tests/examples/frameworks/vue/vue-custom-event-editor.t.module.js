StartTest(t => {

    t.it('Rendering', t => {
        t.chain(
            { waitForSelector : '.b-timelinebase' },

            // test if popup opens and can save name
            { dblClick : '.b-sch-event:contains("Meeting #1")' },
            { waitForSelector : '.v-dialog [primary-title]:textEquals("Meeting #1")' },
            { click : '.v-dialog label:textEquals("Name") + input' },
            { type : ' is important' },
            { click : '.v-dialog button:textEquals("Save")' },
            { waitForSelector : '.b-sch-event:contains("Meeting #1 is important")' },

            // test if popup can cancel edits
            { dblClick : '.b-sch-event-wrap :contains("Appointment #1")', offset : [80, 10] },
            { waitForSelector : '.v-dialog [primary-title]:textEquals("Appointment #1")' },
            { click : '.v-dialog label:textEquals("Name") + input' },
            { type : ' is important' },
            { click : '.v-dialog button:textEquals("Cancel")' },
            { waitForSelectorNotFound : '.b-sch-event:contains("Meeting #2 is important")' }

        );
    });

    t.it('Drag-create event', t => {
        t.chain(
            { moveCursorTo : '[data-event-id="1"]' },
            { mousedown : '[data-event-id="1"] .b-sch-terminal-right' },
            { moveCursorTo : '[data-event-id="2"]' },
            { moveCursorTo : '[data-event-id="2"] .b-sch-terminal-left' },
            { mouseup : '[data-event-id="2"] .b-sch-terminal-left' },
            { mousedown : '[data-id="r2"] [data-column-id="col2"]', offset : [70, 30] },
            { moveCursorTo : '[data-id="r2"] [data-column-id="col2"]', offset : [200, 30] },
            { mouseup : null  },
            { click : '.event-name input' },
            { type : 'Hello World', clearExisting : true },
            { click : '.v-dialog button:textEquals("Save")' },
            { waitForSelector : '.b-sch-event-content:textEquals("Hello World")' }
        );
    });
});
