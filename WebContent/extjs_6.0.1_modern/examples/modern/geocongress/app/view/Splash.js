/**
 * Splash screen
 */
Ext.define('GeoCon.view.Splash', {
    extend: 'Ext.Container',
   

    requires: [
        'GeoCon.view.Settings'
    ],

    config: {
        layout: {
            type: 'card',
            animation: {
                type: 'flip'
            }
        },
        items: [
            {
                xclass: 'GeoCon.view.Settings'
            }
        ]
    }

});
