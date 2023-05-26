<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="java.util.*" %>
<%@page import="foren.unilite.modules.com.combo.ComboItemModel" %>
<%
	// Controller에서 구현 
	List<ComboItemModel> list = new ArrayList<ComboItemModel>();
	for (int i=0, len = 10; i < len; i ++) {
		ComboItemModel item = new ComboItemModel("vxxasdasdasasdasdsas" + i , "tXs" + i,null);
		list.add(item);
	}
	request.setAttribute("list", list);

	List<ComboItemModel> listMaster = new ArrayList<ComboItemModel>();
	request.setAttribute("listMaster", listMaster);
	listMaster.add(new ComboItemModel("01", "한국",""));
	listMaster.add(new ComboItemModel("02", "캐나다",""));
	request.setAttribute("listMaster", listMaster);
	

	List<ComboItemModel> listDetail = new ArrayList<ComboItemModel>();
	listDetail.add(new ComboItemModel("011", "서울","01"));
	listDetail.add(new ComboItemModel("012", "경기","01"));
	listDetail.add(new ComboItemModel("021", "BC","02"));
	listDetail.add(new ComboItemModel("022", "Ontario","02"));
	listDetail.add(new ComboItemModel("023", "Quebec","02"));
	request.setAttribute("listDetail", listDetail);
	//model.add("customsList", list);

%>
<t:ExtComboStore comboType="AU" comboCode="A008" storeId="CUS_M"  />
<t:ExtComboStore comboType="AU" comboCode="A008" storeId="CUS_M2" opts='2;3' />
<t:ExtComboStore comboType="AU" comboCode="A022" />

<t:ExtComboStore items="${listDetail}" storeId="CUS_D" />

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
    [ '0', "Admin" ],
    [ '1', "Email" ],
    [ '2', "홍길동" ],
    [ '3', "대한민국" ],
    [ 'A3', "ㄱㄴㄷ" ],
    [ 'A4', "ABBBBBBBBBBBBBBBBBBBBBBBBBBBB" ]
  ]
});
// the edit combo
var combo = new Ext.form.ComboBox({
  store: store,
  valueField: "value",
  displayField: "text"
});

    var detailForm = Ext.create('Unilite.com.form.UniDetailForm', {
	    id : 'bcm100ukrvDetail',
	    layout: {type: 'uniTable', columns: 2,tdAttrs: {valign:'top'}},
	    defaultType: 'fieldset',
	    defaults : { margin: '5 5 5 5',anchor: '100%'},
	    disabled: false,
	    items : [
	    		{fieldLabel: '고객분류',  name: 'AGENT_TYPE',  xtype : 'uniCombobox', allowBlank: false, store:store, value:'1'},
	    		{fieldLabel: 'allowBlank:true',  name: 'AGENT_TYPE',  xtype : 'uniCombobox', allowBlank: true, store:store, value:'2'},
	    		{fieldLabel: 'readOnly:true',  name: 'AGENT_TYPE',  xtype : 'uniCombobox', readOnly: true, store:store, value:'A3'},
	    		{fieldLabel: 'disabled:true',  name: 'AGENT_TYPE',  xtype : 'uniCombobox', disabled: true, store:store, value:'3'},
	    		{fieldLabel: 'Sencha',  name: 'AGENT_TYPE1',  xtype : 'combobox', allowBlank: false, width:130,
	    			queryMode: 'local',
    				displayField: 'text',
    			    valueField: 'value',
    			    /* tpl: Ext.create('Ext.XTemplate',
					        '<tpl for=".">',
					            '<div class="x-boundlist-item">{text}|{value}</div>',
					        '</tpl>'),*/
	    		 	store:store, value:'1'},
	    		 {
					fieldLabel : '계정과목유형 ',
					name : 'country',
					xtype : 'uniCombobox',
					allowBlank: false,
					store: Ext.data.StoreManager.lookup('CUS_M'),
					child:'cmbsec'
				} , {
					fieldLabel : '계정과목2 ',
					name : 'country',
					xtype : 'uniCombobox',
					allowBlank: false,
					store: Ext.data.StoreManager.lookup('CUS_M2'),
					child:'cmbsec'
				} , {
					fieldLabel : '주 ',
					name : 'state',
					id: 'cmbsec',
					xtype : 'uniCombobox',
					allowBlank: false,
					store: Ext.data.StoreManager.lookup('CUS_D')
				} ,
				{
					fieldLabel: '계산서유형', 
					name: 'BILL_TYPE', 
					xtype: 'uniCombobox', 
					comboType: 'AU', 
					comboCode: 'A022',
					allowBlank: false,
					width:350
				}
	      ]
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
    width: 450
   
});

Ext.create('Ext.Viewport', {
			layout : 'vbox',
			defaults:{border:1},
			items : [detailForm, grid ],
			renderTo : Ext.getBody()
		});
    
   
    
});
</script>

