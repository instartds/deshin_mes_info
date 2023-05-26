/* eslint-disable no-unused-vars */
import '../_shared/shared.js'; // required for example styling etc.
import Toast from '../../lib/Core/widget/Toast.js';
import Scheduler from '../../lib/Scheduler/view/Scheduler.js';
import WidgetHelper from '../../lib/Core/helper/WidgetHelper.js';
import WebSocketHelper from './lib/WebSocketHelper.js';

//region Init Scheduler

const scheduler = new Scheduler({
    appendTo                  : 'container',
    autoAdjustTimeAxis        : false,
    emptyText                 : '',
    zoomOnMouseWheel          : false,
    zoomOnTimeAxisDoubleClick : false,

    features : {
        regionResize : false,
        cellMenu     : {
            items : {
                removeRow : false
            }
        }
    },

    responsiveLevels : {
        small : {
            levelWidth : 800,
            rowHeight  : 35,
            barMargin  : 5
        },
        normal : {
            levelWidth : '*',
            rowHeight  : 50,
            barMargin  : 10
        }
    },

    viewPreset : {
        base           : 'hourAndDay',
        timeResolution : {
            unit      : 'minute',
            increment : 5
        }
    },

    columns : [
        {
            field : 'name',
            text  : 'Name',
            width : 70
        }
    ],

    tbar : [
        {
            type        : 'textfield',
            ref         : 'wsHost',
            placeholder : 'Address:Port',
            label       : 'Host',
            cls         : 'b-login',
            inputType   : 'url',
            width       : 300,
            required    : true,
            onChange({ value }) {
                wsHelper.host = value;
            }
        },
        {
            type        : 'textfield',
            ref         : 'wsUserName',
            placeholder : 'Your name',
            label       : 'Username',
            cls         : 'b-login',
            onChange({ value }) {
                wsHelper.userName = value;
            }
        },
        {
            type : 'button',
            ref  : 'wsLogin',
            cls  : 'b-login b-blue',
            icon : 'b-fa b-fa-sign-in-alt',
            text : 'Login',
            onClick() {
                if (scheduler.widgetMap.wsHost.isValid) {
                    wsHelper.wsOpen();
                }
                else {
                    Toast.show('Invalid host');
                }
            }
        },
        {
            type : 'widget',
            ref  : 'wsLoginLabel',
            html : '<label>:</label>',
            cls  : 'b-logout b-login-name'
        },
        {
            type : 'button',
            ref  : 'wsReset',
            cls  : 'b-logout b-blue',
            icon : 'b-fa b-fa-trash',
            text : 'Reset data',
            onClick() {
                wsHelper.wsResetData();
            }
        },
        {
            type : 'button',
            ref  : 'wsLogout',
            cls  : 'b-logout b-red',
            icon : 'b-fa b-fa-sign-out-alt',
            text : 'Logout',
            onClick() {
                wsHelper.wsClose();
            }
        }
    ]
});

const { wsHost, wsUserName, wsLoginLabel } = scheduler.widgetMap;

//endregion

//region Online user container

WidgetHelper.append([
    {
        type  : 'container',
        id    : 'ws-online',
        cls   : 'b-logout',
        items : [
            {
                type  : 'container',
                cls   : 'ws-online-users',
                items : [{
                    type : 'widget',
                    html : '<label>Who is online:</label>'
                }, {
                    type : 'container',
                    id   : 'ws-online-container'
                }
                ]
            }
        ]
    }
], 'container');

//endregion

//region Init WebSocketHelper

const wsHelper = scheduler.webSocketHelper = new WebSocketHelper(scheduler, wsLoginLabel);
wsHost.value = wsHelper.host;
wsUserName.value = wsHelper.userName;

//endregion
