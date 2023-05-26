Ext.define('AddressBook.view.contact.Show', {
    extend: 'Ext.Container',
    xtype: 'contact-show',

    requires: [
        'Ext.form.FieldSet',
        'Ext.field.Radio',
        'Ext.field.Checkbox',
        'Ext.Component'
    ],

    config: {
        title: '수원여객 서비스 만족도',
        baseCls: 'x-show-contact',
        layout: 'vbox',

        items: [
            {
                id: 'content',
                tpl: [
                    '<div class="top">',
                        '<div class="name"> {telephone}<br />{country}</div>',
                    '</div>'
                ].join('')
            },
            {
            	xtype:'component',
            	html:'<div style="margin-left:20px;margin-right:20px">당신이 타고 있는 버스의 기사분이 얼마나 친절 하십니까?</div>'
            	
            },
            {
               xtype:'fieldset',
               defaults:{
               	
               },
               items:[
               		{
			            xtype: 'checkboxfield',
			            name : 'score',
			            value: '5',
			            label: '매우 만족한다',
			            labelWidth:'85%',
			            checked : true
			        },
			        {
			            xtype: 'checkboxfield',
			            name : 'score',
			            value: '4',
			            label: '만족한다',
			            labelWidth:'85%'
			        },
			        {
			            xtype: 'checkboxfield',
			            name : 'score',
			            value: '3',
			            label: '보통이다',
			            labelWidth:'85%'
			        },
			        {
			            xtype: 'checkboxfield',
			            name : 'score',
			            value: '2',
			            label: '불만족하다',
			            labelWidth:'85%'
			        },
			        	{
			            xtype: 'checkboxfield',
			            name : 'score',
			            value: '1',
			            label: '매우 불만족하다',
			            labelWidth:'85%'
			        }
               ]
            }
        ],

        record: null
    },

    updateRecord: function(newRecord) {
        if (newRecord) {
            this.down('#content').setData(newRecord.data);

            
        }
    }
});
