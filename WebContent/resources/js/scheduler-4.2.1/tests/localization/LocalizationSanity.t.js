StartTest('All translations should be used in the code base', t => {

    // NOTE: This test is required to be run against "module" bundle only!

    const
        testConfig                  = t.getConfig(),
        { classRename, ignoreList } = testConfig,
        locale                      = window.bryntum.locales.En,
        bryntumClasses              = window.bryntum.classes,
        singletons                  = [
            'MessageDialog',
            'Ripple'
        ],
        // Specify optional translations which are not required
        optionalKeys                = {
            AnyClass : [
                'height',
                'width',
                'labelWidth',
                'editorWidth',
                'foo'
            ],
            DateHelper : [
                'formats',
                'weekStartDay'
            ],
            PresetManager : [
                'secondAndMinute',
                'minuteAndHour',
                'hourAndDay',
                'dayAndWeek',
                'weekAndDay'
            ],
            Localizable : [
                'group' // Used in snippet
            ]
        },
        isIgnored                   = (className, localeKey) => ignoreList?.includes(className) || ignoreList?.includes(`${className}.${localeKey}`),
        isOptional                  = (className, localeKey) => optionalKeys.AnyClass.includes(localeKey) || optionalKeys[className]?.includes(localeKey) || isIgnored(className, localeKey),
        moduleLocale                = {},
        moduleLocaleStrict          = {},
        moduleLocaleLazy            = {},
        buildModuleLocale           = () => {

            Object.entries(bryntumClasses).forEach(([className, cls]) => {
                const
                    circularReplacer = () => {
                        const seen = new WeakSet();
                        return (key, value) => {
                            if (typeof value === 'object' && value !== null) {
                                if (seen.has(value)) {
                                    return;
                                }
                                seen.add(value);
                            }
                            return value;
                        };
                    },
                    reLocale         = /L{([\w\d. %(){}-]+)}/gm,
                    classText        = cls.toString() + cls.constructor.toString() + JSON.stringify(cls.configurable, circularReplacer());
                let m;

                while ((m = reLocale.exec(classText))) {
                    const
                        classMatch  = /((.*?)\.)?(.+)/g.exec(m[1]),
                        localeKey   = classMatch[3],
                        localeClass = classMatch[2],
                        setLocale   = (bundle, cls, key) => {
                            cls = classRename?.[cls] || cls;
                            bundle[cls] = bundle[cls] || {};
                            bundle[cls][key] = key;
                        };

                    // By original className
                    setLocale(moduleLocale, className, localeKey);
                    // By locale Class if exist
                    localeClass && setLocale(moduleLocale, localeClass, localeKey);

                    // For checking localization
                    setLocale(moduleLocaleStrict, localeClass || className, localeKey);

                    // Localization is used from class with no localeClass
                    !localeClass && setLocale(moduleLocaleLazy, className, localeKey);
                }
            });
        },
        checked$names               = [],
        check$name                  = (t, className, reason = '') => {
            if (checked$names.includes(className)) {
                return;
            }

            checked$names.push(className);

            const bryntumClass = bryntumClasses[className];
            if (!hasOwnProperty.call(bryntumClass, '$name')) {
                t.fail(`${className} class has no $name() static method. ${reason}`);
            }
            else {
                const
                    localeClassName   = bryntumClass.$name,
                    requiredClassName = classRename?.[className] || className;
                if (localeClassName !== requiredClassName) {
                    t.fail(
                        `${className} class has wrong $name() static method result.` +
                        `\nExpected ${requiredClassName} got ${localeClassName}.` +
                        '\nCheck exports in "webpack.entry.js" file or put renamed class to test "classRename" config in "tests/index.js"'
                    );
                }
            }
        };

    // Build locale from classes in module bundle
    buildModuleLocale();
    //console.log(JSON.stringify(moduleLocale, null, 2));

    t.it('Check English locale contains valid keys', t => {
        let count = 0;
        Object.entries(locale).forEach(([className, cls]) => {
            Object.keys(cls).forEach(localeKey => {
                count++;
                if (localeKey.includes('.') || localeKey.includes('?')) {
                    t.fail(`'${localeKey}' in '${className}' has "." or "?" in locale key`);
                }
            });
        });
        t.pass(`Checked ${count} entries`);
    });

    t.it('Check localization is not used in throw new Error()', t => {
        let count = 0;
        Object.entries(bryntumClasses).forEach(([className, cls]) => {
            const classText = typeof cls === 'function' && cls.toString() || '';
            count++;
            if (/throw new Error\((me|this)\.L\(/.test(classText)) {
                t.fail(`"throw new Error(...)" should not contain Localization me.L() or this.L() in class "${className}"`);
            }
        });
        t.pass(`Checked ${count} entries`);
    });

    t.it('Compare English locale with module bundle', t => {
        let count = 0;
        Object.entries(locale).filter(([className]) => !['localeName', 'localeDesc'].includes(className)).forEach(([className, clsValues]) => {
            Object.keys(clsValues).forEach((localeKey) => {
                count++;
                if (!isOptional(className, localeKey)) {
                    if (moduleLocale[className]) {
                        if (!moduleLocale[className][localeKey]) {
                            t.fail(`En localization ${className}.'L{${localeKey}}' is not found in module bundle.`);
                        }
                    }
                    else {
                        t.fail(`En localization ${className}.'L{${localeKey}}' is not found in in module bundle. Add "${className}" to webpack.entry.js`);
                    }
                }
            });
        });
        t.pass(`Checked ${count} entries`);
    });

    t.it('Check localize works for each entry in moduleLocales', t => {
        let count = 0;
        Object.entries(moduleLocaleStrict).filter(([className]) => !['Object'].includes(className)).forEach(([className, clsValues]) => {
            Object.keys(clsValues).forEach((localeKey) => {
                count++;
                if (!isOptional(className, localeKey)) {
                    const bryntumClass = bryntumClasses[className];

                    // Check lazy locale loading and $name static method
                    if (moduleLocaleLazy[className]?.[localeKey] && bryntumClass) {
                        check$name(t, className, `Checking "${localeKey}" key.`);
                    }

                    if (bryntumClass?.localize) {
                        // Class is Localizable
                        if (!bryntumClass.localize(localeKey)) {
                            t.fail(`${className}.localize('${localeKey}') failed`);
                        }
                    }
                    else {
                        // Just check key in locale
                        if (!locale[className]?.[localeKey]) {
                            t.fail(`'L{${localeKey}}' localization is not found for ${className}`);
                        }

                    }
                }
            });
        });
        t.pass(`Checked ${count} entries`);
    });

    t.it('Check $name() and type() methods for Widget classes', t => {
        Object.entries(bryntumClasses).forEach(([className, cls]) => {
            // Skip checking singletons
            if (!singletons.includes(className) &&
                (cls.prototype instanceof bryntumClasses.Widget ||
                    // eslint-disable-next-line no-prototype-builtins
                    cls.prototype?.isPrototypeOf(bryntumClasses.Widget))) {
                // $name is mandatory for Widget class if there's no `get widgetClass` implementation
                if (!cls.widgetClass) {
                    check$name(t, className, `$name is mandatory for Widget child class ${className}!`);
                }
                // type() is mandatory for Widget class
                if (!hasOwnProperty.call(cls, 'type')) {
                    t.fail(`${className} has no static type() method!`);
                }
                else if (/[A-Z]/.test(cls.type)) {
                    t.fail(`${className} static type() method should be in lower case!`);
                }
            }
        });
        t.pass(`Ok`);
    });

});
