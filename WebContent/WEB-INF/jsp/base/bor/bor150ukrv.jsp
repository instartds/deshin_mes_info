<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bor150ukrv"  >
    <t:ExtComboStore comboType="AU" comboCode="B010" /> <!-- 사용유무 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bor150ukrvService.selectList',
			update: 'bor150ukrvService.updateDetail',
			create: 'bor150ukrvService.insertDetail',
			destroy: 'bor150ukrvService.deleteDetail',
			syncAll: 'bor150ukrvService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Bor150ukrvModel', {
	    fields: [  	  
	    	{name: 'L_DEPT_CODE'			, text: '인사부서코드'		 		 ,type: 'string', allowBlank: false},
	    	{name: 'L_DEPT_NAME'            , text: '인사부서명'                ,type: 'string', allowBlank: false},
	    	{name: 'TREE_CODE'              , text: '회계부서코드'               ,type: 'string'},
	    	{name: 'TREE_NAME'              , text: '회계부서명'                ,type: 'string'},
	    	{name: 'USE_YN'                 , text: '<t:message code="system.label.base.photoflag" default="사진유무"/>'                 ,type: 'string', allowBlank: false, defaultValue: 'Y', comboType:"AU", comboCode:"B010" }
	    ]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('bor150ukrvMasterStore1',{
		model: 'Bor150ukrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: true,			// 삭제 가능 여부 
	        useNavi: false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
			var paramMaster= panelSearch.getValues();
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						directMasterStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>', 	
	   		itemId: 'search_panel1',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
			    xtype: 'uniTextfield',
			    fieldLabel: '인사부서코드',
			    name: 'L_DEPT_CODE',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('L_DEPT_CODE', newValue);
                    }
                }
			},{
                xtype: 'uniTextfield',
                fieldLabel: '인사부서명',
                name: 'L_DEPT_NAME',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('L_DEPT_NAME', newValue);
                    }
                }
            }]		
		}]
	});	  
	
	var panelResult = Unilite.createSearchForm('resultForm2',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
            xtype: 'uniTextfield',
            fieldLabel: '인사부서코드',
            name: 'L_DEPT_CODE',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('L_DEPT_CODE', newValue);
                }
            }
        },{
            xtype: 'uniTextfield',
            fieldLabel: '인사부서명',
            name: 'L_DEPT_NAME',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('L_DEPT_NAME', newValue);
                }
            }
        }]
	});	
		
    var masterGrid = Unilite.createGrid('atx425ukrGrid1', {
        region:'center',
    	store: directMasterStore,
    	excelTitle: '고정자산기본정보등록',
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: false,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: false,
			onLoadSelectFirst: true,
			copiedRow:true,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        columns:  [
        	{dataIndex: 'L_DEPT_CODE'               ,       width: 120},
        	{dataIndex: 'L_DEPT_NAME'               ,       width: 180},
            { dataIndex: 'TREE_CODE'                ,       width:120,
                'editor': Unilite.popup('DEPT_G',{
                    autoPopup: true,
                    DBtextFieldName: 'TREE_CODE',
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('TREE_CODE',records[0]['TREE_CODE']);
                            grdRecord.set('TREE_NAME',records[0]['TREE_NAME']);
                            
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('TREE_CODE','');
                            grdRecord.set('TREE_NAME','');
                      }
                    }
                })
            },
            { dataIndex: 'TREE_NAME'                ,               width:180,
              'editor': Unilite.popup('DEPT_G',{
                    autoPopup: true,
                    listeners: { 'onSelected': {
                        fn: function(records, type  ){
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('TREE_CODE',records[0]['TREE_CODE']);
                            grdRecord.set('TREE_NAME',records[0]['TREE_NAME']);
                            
                        },
                        scope: this
                      },
                      'onClear' : function(type)    {
                            var grdRecord = masterGrid.uniOpt.currentRecord;
                            grdRecord.set('TREE_CODE','');
                            grdRecord.set('TREE_NAME','');
                      }
                    }
                })
            },
        	{dataIndex: 'USE_YN'                    ,       width: 120}
		],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom){
					if(UniUtils.indexOf(e.field, ['L_DEPT_CODE','L_DEPT_NAME'])){
						return false;
					}
				}
			}
		}
    });  
    
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid,panelResult
			]	
		},
			panelSearch  	
		],
		id: 'bor150ukrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset','newData'],true);
			UniAppManager.setToolbarButtons(['save'],false);
			var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('L_DEPT_CODE');			
		},
		onQueryButtonDown: function()	{
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown: function()	{
			masterGrid.createRow(null, 'L_DEPT_CODE');				
		},
		onResetButtonDown: function() {		
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			
			directMasterStore.clearData();
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {				
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		}		
	});
	
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		    console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
//				case "GAAP_DRB_YEAR" :
//					if(!Ext.isNumeric(newValue) || Ext.isEmpty(newValue)) {
//						rv='<t:message code = "unilite.msg.sMB074"/>';	
//						Unilite.messageBox("숫자만 입력가능합니다.");
//					}
//					break;			
			}
			return rv;
		}
	});		
};


</script>
