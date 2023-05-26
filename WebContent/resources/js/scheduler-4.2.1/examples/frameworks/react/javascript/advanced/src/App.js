/**
 * Main App script
 */
// libraries
import React, { useEffect, Fragment } from 'react';
import { connect } from 'react-redux';
import { useTranslation } from 'react-i18next';

// styles
import './App.scss';

// locales
import './locales';
import { LocaleManager, Toast } from '@bryntum/scheduler/scheduler.umd';

// our stuff
import Scheduler from './components/Scheduler';
import Toolbar from './components/toolbar/Toolbar';
import { BryntumDemoHeader, BryntumThemeCombo } from '@bryntum/scheduler-react';

import { loadData, clearError } from './redux/actions/actions';

const App = props => {
    const { t, i18n } = useTranslation();

    /**
     * @param {String} locale Locale to set
     *
     * Sets state and changes language. The function is passed to the
     * global SettingsContext so that it can be called from any even
     * deeply nested components that are consumers of SettingsContext.
     */
    const changeLocale = locale => {
        // change locale in i18next
        i18n.changeLanguage(locale);

        // translate document title
        document.title = t('title');

        // change the scheduler locale
        applySchedulerLocale(locale);
    };

    /**
     * @param {String} schedulerLocale
     * Applies scheduler locale. Called always when
     * locale changes by SettingContext setLocale
     */
    const applySchedulerLocale = schedulerLocale => {
        if (schedulerLocale === 'en-US') {
            changeLocale('en');
            return;
        }

        switch (schedulerLocale) {
            case 'se':
                LocaleManager.applyLocale('SvSE');
                break;

            case 'ru':
                LocaleManager.applyLocale('Ru');
                break;

            default:
                LocaleManager.applyLocale('En');
                break;
        }
    };

    // set the translated document title as soon as we have the locale
    document.title = t('title');

    // set scheduler locale at startup
    applySchedulerLocale(props.locale);

    if (props.locale && props.locale !== i18n.language) {
        changeLocale(props.locale);
    }

    // error handler
    useEffect(() => {
        if (props.err) {
            Toast.show(t(props.err.message));
            props.clearError();
        }

        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [props.err]);

    return (
        <Fragment>
            <BryntumDemoHeader
                title={t('title')}
                href="../../../../../#example-frameworks-react-javascript-advanced"
                children={<BryntumThemeCombo />}
            />
            <Toolbar />
            <Scheduler />
        </Fragment>
    );
};

const mapStateToProps = state => {
    return {
        locale: state.locale,
        err: state.err
    };
};

const mapDispatchToProps = dispatch => {
    return {
        loadData: () => dispatch(loadData()),
        clearError: () => dispatch(clearError())
    };
};

export default connect(mapStateToProps, mapDispatchToProps)(App);
