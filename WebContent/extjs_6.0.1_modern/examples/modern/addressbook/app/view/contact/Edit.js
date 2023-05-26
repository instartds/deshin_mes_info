Ext.define('AddressBook.view.contact.Edit', {
    extend: 'Ext.Container',
    xtype: 'contact-edit',

    requires: [
        'Ext.form.Panel',
        'Ext.form.FieldSet',
        'Ext.field.Text',
        'Ext.Component'
    ],

    config: {
        title: '수원여객 서비스 만족도',
        layout: 'fit',
        items: [
            {
            	xtype:'component',
            	html:'<div style="font-size:18px;font-weight:bold;margin-left:20px;margin-top:20px;margin-right:20px;">설문에 참여해 주셔서 감사합니다.</div>'
            
            }
        ],

        record: null
    }
});
