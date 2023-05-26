<%@page language="java" contentType="text/html; charset=utf-8"%>
	 {
		title:'부서별요율등록',
		id:'hbs020ukrTab13',
		itemId: 'hbs020ukrPanel13',
		border: false,
		subCode:'',
		getSubCode: function()	{
			return this.subCode;
		},
		xtype: 'uniDetailForm',
		layout: {type: 'vbox', align: 'stretch'},
		bodyCls: 'human-panel-form-background',
        padding: '0 0 0 0',
		items:[{
			xtype: 'uniDetailFormSimple',
			id:'hbs020ukrTab13_inner',
			layout: {type: 'uniTable'},
			items:[{
				fieldLabel: '지급구분',
				name: 'SUPP_TYPE',
				id:'SUPP_TYPE13', 
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('bonusTypeList'),
				value: value18_1,
				itemId: 'tabFocus13'				
			},
			Unilite.treePopup('DEPTTREE',{
				fieldLabel: '부서',
				valueFieldName:'DEPT_CODE',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPTS' ,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
				textFieldWidth:89,
				validateBlank:true,
				width:300,
				autoPopup:true,
				useLike:true,
				listeners: {
	                'onValueFieldChange': function(field, newValue, oldValue  ){
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
	                },
	                'onValuesChange':  function( field, records){
	                	var tagfield = Ext.getCmp('hbs020ukrTab13').getField('DEPTS') ;
                    	tagfield.setStoreData(records)
	                }
				}
			}),{
				margin: '0 0 0 50',
				xtype: 'button',
				name: 'CREATE_DEPT',
				id: 'createDept',
				text: '대상부서일괄생성',
				handler: function() {
					if(confirm('대상부서를 일괄 생성합니다.\n 생성 하시겠습니까?')){
						var param = {SUPP_TYPE: Ext.getCmp('hbs020ukrTab13').getValue('SUPP_TYPE')}
						hbs020ukrService.createBaseDept(param, function(provider, response)	{
			        		var activeTab = panelDetail.down('#hbs020Tab').getActiveTab();
			        		Ext.getCmp('createDept').setDisabled(true);
			        		UniAppManager.app.onQueryButtonDown();
						});
					}					
				}
			}]			
		}, {				
			xtype: 'uniGridPanel',
			id:'uniGridPanel13',
			itemId:'uniGridPanel13',
		    store : hbs020ukrs13Store,
		    uniOpt: {
		    	expandLastColumn: true,
		        useRowNumberer: true,
		        useMultipleSorting: false
			},		        
			columns: [
					{dataIndex: 'COMP_CODE'          	,		width: 133, hidden: true},				  
				  	{dataIndex: 'TREE_CODE'           	,		width: 130,
					  'editor': Unilite.popup('DEPT_G',{	
					  			autoPopup: true,
                    	  	 	textFieldName : 'DEPT_NAME',
                    	  	 	listeners: { 'onSelected': {
				                    fn: function(records, type  ){
				                    	var grdRecord = Ext.getCmp('uniGridPanel13').uniOpt.currentRecord;
                						grdRecord.set('TREE_NAME',records[0]['TREE_NAME']);
                						grdRecord.set('TREE_CODE',records[0]['TREE_CODE']);
				                    },
				                    scope: this
				                  },
				                  'onClear' : function(type)	{
				                    	var grdRecord = Ext.getCmp('uniGridPanel13').uniOpt.currentRecord;
                						grdRecord.set('TREE_NAME','');
                						grdRecord.set('TREE_CODE','');
				                  }
                    	  	 	}
							})
						},
					  {dataIndex: 'TREE_NAME'         	,		width: 240,
						  'editor': Unilite.popup('DEPT_G',{
						  		autoPopup: true,
                    	  	 	listeners: { 'onSelected': {
				                    fn: function(records, type  ){
				                    	var grdRecord = Ext.getCmp('uniGridPanel13').uniOpt.currentRecord;
                						grdRecord.set('TREE_NAME',records[0]['TREE_NAME']);
                						grdRecord.set('TREE_CODE',records[0]['TREE_CODE']);
				                    },
				                    scope: this
				                  },
				                  'onClear' : function(type)	{
				                    	var grdRecord = Ext.getCmp('uniGridPanel13').uniOpt.currentRecord;
                						grdRecord.set('TREE_NAME','');
                						grdRecord.set('TREE_CODE','');
				                  }
                    	  	 	}
							})
						},				  
					  {dataIndex: 'DEPART_RATE'      	,		width: 120},				  
					  {dataIndex: 'SUPP_TYPE'	       	,		width: 80, hidden: true},					  				  
					  {dataIndex: 'UPDATE_DB_USER'     	,		width: 100, hidden: true},				  
					  {dataIndex: 'UPDATE_DB_TIME'     	,		width: 100, hidden: true}
			],
	    	features: [{
	    		id: 'masterGridSubTotal',
	    		ftype: 'uniGroupingsummary', 
	    		showSummaryRow: false 
	    	},{
	    		id: 'masterGridTotal', 	
	    		ftype: 'uniSummary', 	  
	    		showSummaryRow: false
	    	}], 
			listeners: {
				beforeedit: function(editor, e) {
					if (!e.record.phantom) {
						if (e.field == 'TREE_CODE' || e.field == 'TREE_NAME') {
							return false;
						}
					}
				}
			}
		}]
	}