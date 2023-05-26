/**
 * The settings form panel
 */
Ext.define('GeoCon.view.SettingsBK', {
    extend: 'Ext.form.Panel',

    requires: [
        'Ext.form.FieldSet',
        'Ext.Component'
    ],

    id: 'settingsForm',

    config: {
        items: [
		            {
		                xtype: 'component',
		                html : '<div style="text-align:center;margin-top:50px;margin-bottom:50px;font-size:24px;">수원여객 <br /><br />만족도 조사 시스템</div>'
		            },
		            {
		                xtype: 'component',
		                html : '<div style="text-align:center"></div>'
		            },
		        
		            {
		                xtype: 'button',
		                margin: '0 70%',
		                text: '설문시작하기',
		                ui: 'confirm',
		                id: 'lookupBtn'
		            }
        ]
    }
});
