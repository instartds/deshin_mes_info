// @charset UTF-8
/**
 * @class Unilite.com.panel.portal.UniPortalColumn
 * @extends Ext.container.Container
 * A layout column class used internally be {@link Unilite.com.panel.portal.UniPortalPanel}.
 */
Ext.define('Unilite.com.panel.portal.UniPortalColumn', {
    extend: 'Ext.container.Container',
    alias: 'widget.uniPortalcolumn',

    requires: [
        'Ext.layout.container.Anchor'
    ],

    layout: 'anchor',
    defaultType: 'uniPortlet',
    cls: 'x-portal-column'

    // This is a class so that it could be easily extended
    // if necessary to provide additional behavior.
});
