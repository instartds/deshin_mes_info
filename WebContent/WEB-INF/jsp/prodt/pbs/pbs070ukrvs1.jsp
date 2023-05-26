<%@page language="java" contentType="text/html; charset=utf-8"%>



	var prodt_Holy =	 {
			itemId: 'prodt_Holy',
			layout: {type: 'vbox', align:'stretch'},
			items:[{	
				title:'생산휴일등록',
				itemId: 'tab_holy',
				id:'tab_holyTab',
				xtype: 'container',
		        		layout: {type: 'hbox', align:'stretch'},
		        		flex:1,
		     			autoScroll:false,
		        		items:[
			        	{	
			        		bodyCls: 'human-panel-form-background',
			        		xtype: 'uniGridPanel',
			        		itemId:'pbs070ukrvs_1Grid',
					        store : pbs070ukrvs_1Store, 
					        padding: '0 0 0 0',
					        dockedItems: [{
						        xtype: 'toolbar',
						        dock: 'top',
						        padding:'0px',
						        border:0
						    }],
					        uniOpt:{	expandLastColumn: false,
					        			useRowNumberer: true,
					                    useMultipleSorting: false,
					                    dblClickToEdit     : true
					        },	        
				columns: [{dataIndex: 'HOLY_MONTH'			, width: 66, maxLength: 2 ,tdCls:'x-change-cell3' ,align:'center'},
						  {dataIndex: 'HOLY_DAY'			, width: 66, maxLength: 2 ,tdCls:'x-change-cell3' ,align:'center'},
						  {dataIndex: 'REMARK'				, flex: 1  },
						  {dataIndex: 'UPDATE_DB_USER'		, width: 100 , hidden: true},
						  {dataIndex: 'UPDATE_DB_TIME'		, width: 100 , hidden: true},
						  {dataIndex: 'COMP_CODE'			, width: 100 , hidden: true}
						    
				],
				listeners: {
		        	beforeedit: function( editor, e, eOpts ) {
		        		if(e.record.phantom == false) {
			        		if(UniUtils.indexOf(e.field, ['HOLY_MONTH', 'HOLY_DAY'])) {
								return false;
							}
		        		}
		        	}
		        }
			}]
		}]
	}