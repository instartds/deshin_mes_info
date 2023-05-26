/*global DocsBrowserInstance*/
/*eslint no-undef: "error"*/

describe('Open all links in docs tree and assert correct content + no crashes', async t => {

    let classRecord;
    const
        { navigationTree } = DocsBrowserInstance,
        {
            ignoreTopics  = [],
            docsTitle
        }                  = t.getConfig(),
        records            = [];

    DocsBrowserInstance.animateScroll = false;

    t.beforeEach(async(t, cb) => {
        classRecord = records.shift();

        if (classRecord) {
            location.hash = classRecord.href || classRecord.fullName;

            t.suppressPassedWaitForAssertion = true;
            await t.waitForSelector(`#content h1:contains(${classRecord.readableName})`);
            await t.waitForSelectorNotFound('.b-mask:contains(Loading),.fiddlePanelResult:empty,[data-error]');
        }

        cb();
    });

    DocsBrowserInstance.onSettingsChange({
        settings : {
            showPublic    : true,
            showInternal  : true,
            showPrivate   : true,
            showInherited : true
        }
    });

    navigationTree.expandAll();

    await t.waitForSelector(`#content h1:textEquals(${docsTitle})`);

    await t.waitForSelectorNotFound('.loading');

    navigationTree.store.traverse(classRec => {
        if ((!classRec.children || !classRec.children.length) && !ignoreTopics.includes(classRec.get('id')) && !classRec.isGuide && classRec.id !== 'apidiff') {
            records.push(classRec);

            t.it(`Checking ${classRec.id}`, async t => await t.assertDocsLinks(classRecord));
        }
    });

    t.it('Should not see any global members, only classes', t => {
        for (const p in t.global.docsJson) {
            if (p !== 'classes') {
                t.fail(t.global.docsJson[p].map(o => o.name).join(', '), 'Should not find any top level members');
            }
        }
    });
});
