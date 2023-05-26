Ext.define('AddressBook.store.Contacts', {
    extend: 'Ext.data.Store',

    config: {
        model: 'AddressBook.model.Contact',
        autoLoad: true,
        proxy: {
            type: 'ajax',
            url: 'contacts.json'
        }
    }
});
