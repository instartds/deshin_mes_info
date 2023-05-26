/**
 * Locale combo implementation
 */
// libraries
import React, { useRef, useEffect } from 'react';
// we import scheduler.umd for IE11 compatibility only. If you don't use IE import:
// import { WidgetHelper } from '@bryntum/scheduler';
import { WidgetHelper } from '@bryntum/scheduler/scheduler.umd';
import { connect } from 'react-redux';
import { useTranslation } from 'react-i18next';

// our stuff (action creator)
import { setLocale } from '../../redux/actions/actions.js';

const LocaleCombo = ({ container, onChange, locale }) => {
    // refs and t function
    const elRef = useRef(),
        inputRef = useRef(),
        { t } = useTranslation();

    // Bryntum input instance
    const input = (inputRef.current =
        inputRef.current ||
        WidgetHelper.createWidget({
            type: 'combo',
            label: 'Select Language:',
            inputWidth: '7em',
            editable: false,
            value: locale,
            onChange: onChange,
            store: [
                { id: 'en', text: 'English' },
                { id: 'se', text: 'Swedish' },
                { id: 'ru', text: 'Russian' }
            ]
        }));

    // initial combo rendering
    useEffect(() => {
        input.appendTo = container || elRef.current;
        input.render();

        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []);

    // runs on locale change
    useEffect(() => {
        input.labelElement.innerText = t('selectLanguage');
        input.input.value = input.store.getById(locale).text;
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [locale]);

    return container ? null : <div ref={elRef}></div>;
};

// maps Redux state to this button props
const mapStateToProps = (state, props) => {
    return {
        locale: state.locale
    };
};

// maps Redux dispatch method to props
const mapDispatchToProps = (dispatch, props) => {
    return {
        onChange: ({ value: locale }) => {
            dispatch(setLocale(locale));
        }
    };
};

// connects to Redux and exports the combo
export default connect(mapStateToProps, mapDispatchToProps)(LocaleCombo);
