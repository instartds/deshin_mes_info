Ext.define('AddressBook.view.Contacts', {
    extend: 'Ext.List',
    xtype: 'contacts',

    config: {
        title: '수원여객',
        cls: 'x-contacts',
        variableHeights: true,
        store: 'Contacts',
        
        itemTpl: [
            '<div class="top"><div class="name">{lastName}</div></div>'
        ].join('')
    }
});
