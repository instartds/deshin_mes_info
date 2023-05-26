StartTest(t => {
    let scheduler;

    t.it('sanity', t => {
        t.chain(
            { waitForSelector : '.b-sch-foreground-canvas' },

            (next, el) => {
                scheduler = bryntum.fromElement(el[0], 'scheduler');
                t.is(scheduler.timeAxis.weekStartDay, 1, 'weekStartDay localized');
                next();
            },

            () => t.checkGridSanity(scheduler)
        );
    });

    t.it('Default locale (De)', t => {
        t.chain(
        // assume default language is German
            { waitForSelector : '[data-column="company"] .b-grid-header-text:textEquals(Firma)' },

            { dblClick : '.b-sch-event' },

            { waitForSelector : '.b-eventeditor' },

            next => {
                t.selectorExists('button:textEquals(Abbrechen)', 'Cancel button is written in German');
                t.selectorExists('.b-combo label:textEquals(Ressource)', 'Resource selector label is written in German');
                next();
            },

            { click : '[data-ref=infoButton]' },

            { click : '[data-ref=localeCombo] input' },

            // Switch to English locale
            { click : '.b-list :textEquals(English)' },

            { waitForSelector : '[data-column="company"] .b-grid-header-text:textEquals(Company)' },

            { dblClick : '.b-sch-event' },

            { waitForSelector : '.b-eventeditor' },

            () => {
                t.is(scheduler.timeAxis.weekStartDay, 0, 'weekStartDay localized');
                t.selectorExists('button:textEquals(Cancel)', 'Cancel button is written in English');
                t.selectorExists('.b-combo label:textEquals(Resource)', 'Resource selector label is written in English');
            }
        );
    });

    t.it('Check all locales', t => {
        t.chain(
            ['English', 'Nederlands', 'Svenska', 'Русский', 'Deutsch'].map(locale => [
                { diag : `Checking locale ${locale}` },
                { click : '[data-ref=infoButton]' },
                { moveMouseTo : '.info-popup .b-checkbox' },
                { waitForSelector : '.b-tooltip-shared' },
                async() => {
                    t.contentNotLike('.b-tooltip-shared', /L{/, 'Tooltip is localized');
                },
                { click : '[data-ref=localeCombo]' },
                { click : `.b-list-item:contains(${locale})` }
            ])
        );
    });
});
