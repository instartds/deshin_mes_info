 Ext.define('nbox.detailForm',    {
            extend : 'Ext.form.Panel',
            layout: {
                type: 'table', 
                columns: 1, 
                tableAttrs: {
                    style: {
                        width: '100%'
                    }
                }
            },
            width: '100%',
            defaultType: 'textfield',
            items: [ 
                { fieldLabel: '조건',    name:'TXT_SEARCH', id:'TXT_SEARCH'},
                { fieldLabel: '조건2',    name:'TXT_SEARCH2', id:'TXT_SEARCH2'}
            ]
        }
    
 ); //detailForm