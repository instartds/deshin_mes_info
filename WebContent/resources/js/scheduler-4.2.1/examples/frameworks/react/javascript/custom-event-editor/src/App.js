/**
 * Application file
 */
import React, { Fragment, useState, useRef, useCallback, useEffect } from 'react';

import { BryntumScheduler, BryntumDemoHeader, BryntumThemeCombo } from '@bryntum/scheduler-react';
import Popup from './components/Popup';
import { schedulerConfig } from './AppConfig'
import './App.scss';

function App() {
    const scheduler = useRef();

    const [popupShown, showPopup] = useState(false);
    const [eventRecord, setEventRecord] = useState(null);
    const [eventStore, setEventStore] = useState(null);
    const [resourceStore, setResourceStore] = useState(null);

    useEffect(() => {
        const { eventStore, resourceStore } = scheduler.current.instance;
        setEventStore(eventStore);
        setResourceStore(resourceStore);
    }, []);

    const showEditor = useCallback(eventRecord => {
        setEventRecord(eventRecord);
        showPopup(true);
    }, []);

    const hideEditor = useCallback(() => {
        setEventRecord(null);
        showPopup(false);
    }, []);

    return (
        <Fragment>
            <BryntumDemoHeader
                href="../../../../../#example-frameworks-react-javascript-custom-event-editor"
                title="Bryntum Scheduler Custom React Event Editor demo"
                children={<BryntumThemeCombo />}
            />
            <BryntumScheduler ref={scheduler} {...schedulerConfig} listeners={{
                beforeEventEdit: source => {
                    source.eventRecord.resourceId = source.resourceRecord.id;
                    showEditor(source.eventRecord);
                    return false;
                }
            }} />
            <div>
                {popupShown ? (
                    <Popup
                        text="Popup text"
                        closePopup={hideEditor}
                        eventRecord={eventRecord}
                        eventStore={eventStore}
                        resourceStore={resourceStore}
                    ></Popup>
                ) : null}
            </div>
        </Fragment>
    );
}

export default App;
