StartTest(t => {

    const
        config               = t.getConfig(),
        testTags = (t, tag, ignoreList) => {
            const missingTags   = [];
            window.docsJson.classes.forEach(cls => {
                let ignoreIndex = ignoreList.indexOf(cls.modulePath);
                if (cls.modulePath.includes(`/${tag}/`) && !cls[tag] && ignoreIndex === -1) {
                    missingTags.push(cls.modulePath);
                }
                if (ignoreIndex >= 0) {
                    ignoreList.splice(ignoreIndex, 1);
                }
            });

            if (missingTags.length > 0) {
                t.fail(`Classes below don't have "@${tag}" docs tag. To ignore add class name to "tests/index.js" to "ignore/${tag}s" test config array\n`);
                missingTags.forEach(cls => t.fail(`'${cls}'`));
            }

            if (ignoreList.length > 0) {
                t.fail(`Redundant test ignore items in "tests/index.js" in "ignore/${tag}s" test config array`);
                ignoreList.forEach(cls => t.fail(`'${cls}'`));
            }

            if ((missingTags.length === 0)  && (ignoreList.length === 0)) {
                t.pass(`Docs @${tag} integrity is OK`);
            }
        };

    t.it('Check @feature tags in docs', t => {
        testTags(t, 'feature', [...config.ignore.features]);
    });

    t.it('Check @mixin tags in docs', t => {
        testTags(t, 'mixin', [...config.ignore.mixins]);
    });

});
