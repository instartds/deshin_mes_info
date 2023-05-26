StartTest(t => {
    t.setWindowSize(1027, 768);

    t.it('Check each online example from example browser to have correct link back to all examples', t => {
        t.waitForSelector('.example', () => {
            const
                examples = Array.from(t.global.document.querySelectorAll('.example:not(.offline)'))
                    .map(el => ({
                        id   : el.id.replace('b-example', 'example'),
                        href : el.href
                    }));

            examples.forEach(example => {
                t.it(`Check example #${example.id}`, t => {
                    t.chain(
                        {
                            waitForPageLoad : null,
                            trigger         : () => t.global.location.href = 'about:blank',
                            desc            : `Clean the page`
                        },
                        {  waitForSelectorNotFound : `#title` },
                        {
                            waitForPageLoad : null,
                            trigger         : () => t.global.location.href = example.href,
                            desc            : `Navigate to example page ${example.href}`
                        },
                        { waitForSelector : `#title` },
                        () => {
                            const
                                title   = t.global.document.getElementById('title'),
                                correct = `examples/#${example.id}`;
                            if (!title?.href?.endsWith(correct)) {
                                t.fail(`Wrong #title href: "${title.href}", Correct ends with: "${correct}"`);
                            }
                        });
                });
            });
        });
    });
});
