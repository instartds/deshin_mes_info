<%@page language="java" contentType="text/html; charset=utf-8"%>
<script type="text/javascript">
Ext.onReady(function () {
    
var s = Ext.create('Ext.data.Store', {
    fields:['name', 'email', 
            {name: 'date', type: 'date' , dateFormat: 'd/m/Y'}
            , 'value', 'c1', 'c2', 'check'],
    data:[
        {"name":"Lisa", "email":"lisa@simpsons.com", "date":'02/07/2013',"value": 0, 'c1': 0, 'c2': 0, 'check': 0},
        {"name":"Bart", "email":"bart@simpsons.com", "date":'12/07/2013',"value": 1, 'c1': 0, 'c2': 0, 'check': 0},
        {"name":"Homer", "email":"home@simpsons.com", "date":'12/07/2013',"value": 1, 'c1': 0, 'c2': 0, 'check': 1},
        {"name":"Marge", "email":"marge@simpsons.com", "date":'12/07/2013',"value": 2, 'c1': 0, 'c2': 0, 'check': 0}
    ]
});

// the combo store
var store = new Ext.data.SimpleStore({
  fields: [ "value", "text" ],
  data: [
    [ 0, "Admin" ],
    [ 1, "sub1" ],
    [ 2, "sub2" ]
  ]
});
// the edit combo
var combo = new Ext.form.ComboBox({
  store: store,
  valueField: "value",
  displayField: "text"
});


// demogrid
var grid = Ext.create('Ext.grid.Panel', {
    title: 'Example',
    store: s,
    columns: [
        {header: 'Name',  dataIndex: 'name', width:50},
        {header: 'Email', dataIndex: 'email', width: 150},
        {header: 'date', dataIndex: 'date', xtype: 'datecolumn',
         format: 'Y/m/d',
        editor: {
            xtype: 'datefield',
            allowBlank: true,
            format: 'Y/m/d'
        }
        },
       
        {header: 'value', dataIndex: 'value', flex: 1, 
         renderer: function(value) {
            var idx = store.find('value', value)
            var rec = store.getAt(idx);
            return rec.get('text');                    
        },
         editor: combo
        }
    ],
    selType: 'cellmodel',
    plugins: [
        Ext.create('Ext.grid.plugin.CellEditing', {
            clicksToEdit: 1
        })
    ],
    height: 200,
    width: 450,
    renderTo: Ext.getBody()
   
});
    
   
    
});
</script>

