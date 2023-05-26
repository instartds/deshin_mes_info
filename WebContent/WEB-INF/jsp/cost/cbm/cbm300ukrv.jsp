<%@page language="java" contentType="text/html; charset=utf-8"%>

	{
		title	: '품목별배부율등록',
		itemId	: 'tab_distRate',
		id		: 'tab_distRate',
		xtype	: 'uniDetailForm',
		layout	: {type: 'vbox', align:'stretch'},
		items	: [{
			xtype: 'uniSearchForm',
			itemId:'calcuBasisSearch1',
			region:'north',
			layout:{type:'uniTable', columns:'3'},
			items:[{
				xtype:'uniCombobox',
				comboType:'BOR120',
				fieldLabel:'사업장',
				name:'DIV_CODE',
				value:UserInfo.divCode
			},{
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode: 'C101',
				fieldLabel:'배부유형',
				name:'DISTR_STND_CD',
				value:UserInfo.divCode
			},{
	    		fieldLabel: '품목계정',
	    		name: 'ITEM_ACCOUNT', 
	    		xtype: 'uniCombobox',
				comboType: 'AU', 
				comboCode: 'B020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{
		    	name: 'ITEM_LEVEL1',
    			fieldLabel: '대분류',
    			xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('Level1Store'),
                child: 'ITEM_LEVEL2',
                listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL1', newValue);
					}
				}
            }, {
              	name: 'ITEM_LEVEL2',
              	fieldLabel: '중분류',
              	xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('Level2Store'),
                child: 'ITEM_LEVEL3',
                listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL2', newValue);
					}
				}
             }, {
             	name: 'ITEM_LEVEL3',
             	fieldLabel: '소분류',
             	xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('Level3Store'),
                listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_LEVEL3', newValue);
					}
				}
            },
            Unilite.popup('DIV_PUMOK',{ 
				fieldLabel: '품목코드',
				textFieldWidth: 170,
				itemId:'ITEM_CODE',
				valueFieldName: 'ITEM_CODE', 
				textFieldName: 'ITEM_NAME',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
							panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
	                	},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_NAME', '');
					},
	                applyExtParam:{
	                    scope:this,
	                    fn:function(popup){
	                        popup.setExtParam({"CUSTOM_TYPE":'3'});
	                    }
	                }
				}
			})]
		}, {	
			xtype: 'uniGridPanel',
			itemId:'cbm020ukrvsGrid2',
		    store : cbm020ukrvStore2,
		    uniOpt: {			
			    useMultipleSorting	: true,		
			    useLiveSearch		: true,		
			    onLoadSelectFirst	: true,			
			    dblClickToEdit		: true,		
			    useGroupSummary		: false,		
				useContextMenu		: false,	
				useRowNumberer		: true,	
				expandLastColumn	: false,		
				useRowContext		: true,	
				copiedRow			: true,
			    filter: {				
					useFilter		: false,
					autoCreate		: false
				}			
			},		        
			columns: [
				{dataIndex: 'COMP_CODE'		, width: 100,		hidden: true},
				{dataIndex: 'DIV_CODE'		, width: 100,		hidden: true},
				{dataIndex: 'WORK_MONTH'	, width: 100,		hidden: true},
				{dataIndex: 'ITEM_CODE'		, width: 100},
				{dataIndex: 'ITEM_NAME'		, width: 200},
				{dataIndex: 'SPEC'			, width: 200},
				{dataIndex: 'DIST_RATE'		, width: 100},
				{dataIndex: 'REMARK'		, width: 300}
			],
			listeners:{
				beforeedit  : function( editor, e, eOpts ) {
					if(UniUtils.indexOf(e.field, ['SUB_CODE', 'CODE_NAME', 'USE_YN'])){
						if(e.record.phantom){
							return true;
						}else{
							return false;
						}
					}
				}	
			}
		}]      
	}
