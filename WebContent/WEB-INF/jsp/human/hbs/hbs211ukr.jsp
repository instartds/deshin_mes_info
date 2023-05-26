<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hbs211ukr"  >
    <t:ExtComboStore comboType="AU" comboCode="H008" /> <!-- 담당업무-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >


function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'hbs211ukrService.selectList',
            update: 'hbs211ukrService.updateDetail',
            create: 'hbs211ukrService.insertDetail',
            destroy: 'hbs211ukrService.deleteDetail',
            syncAll: 'hbs211ukrService.saveAll'
        }
    });
	

	Unilite.defineModel('hbs211ukrModel', {
        fields: [
			 {name: 'COMP_CODE'     ,text: '법인코드'       ,type: 'string' ,allowBlank:false}
			,{name: 'PAY_GRADE_YYYY',text: '기준년도'       ,type: 'string' ,allowBlank:false} 
            ,{name: 'JOB_CODE'		,text: '담당업무'	     ,type:'string'	,allowBlank:false	,comboType: 'AU'	,comboCode:'H008'}
            ,{name: 'WAGES_CODE'    ,text: '수당코드'       ,type: 'string' ,allowBlank:false}
            ,{name: 'WAGES_I'		,text: '기본급'        ,type: 'uniPrice'}
        ]
    });
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var detailStore = Unilite.createStore('hbs211ukrStore', {
        model: 'hbs211ukrModel',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결 
            editable: true,            // 수정 모드 사용 
            deletable: true,           // 삭제 가능 여부 
            allDeletable:false,
            useNavi : false         // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        saveStore : function(config)    {
            var inValidRecs = this.getInvalidRecords();
            var paramMaster= panelSearch.getValues();   //syncAll 수정
            
            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    
                    success: function(batch, option) {
                        panelSearch.getForm().wasDirty = false;
                        panelSearch.resetDirtyStatus();
                        console.log("set was dirty to false");
                        UniAppManager.setToolbarButtons('save', false); 
                        
                        UniAppManager.app.onQueryButtonDown();
                        }
                    
                };
                this.syncAllDirect(config);
            } else {
                detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
        },
        loadStoreRecords: function() {
            var param = Ext.getCmp('panelSearch').getValues();
            console.log( param );
            this.load({
                params: param
            });
        }
    }); 
	
	var panelSearch = Unilite.createSearchForm('panelSearch',{
        region: 'north',
        layout : {type : 'uniTable', columns : 2},
        padding:'1 1 1 1',
        border:true,
        items: [{
            xtype: 'uniYearField',
            fieldLabel: '기준년도',
            name: 'PAY_GRADE_YYYY',
            allowBlank:false
        },{
            xtype: 'uniCombobox',
            fieldLabel: '담당업무',
            name: 'JOB_CODE',
            comboType: 'AU',
            comboCode: 'H008'
        }  
        ]
    });
	var detailGrid = Unilite.createGrid('hbs211ukrGrid', {
        layout: 'fit',
        region: 'center',
        height:300,
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: false,
            useMultipleSorting: true,
            onLoadSelectFirst: false,
            useRowNumberer: true,
            expandLastColumn: true,
            useRowContext: false,
            state: {
                useState: true,         
                useStateList: true      
            }
        },
        features: [{
            id: 'detailGridSubTotal', 
            ftype: 'uniGroupingsummary', 
            showSummaryRow: false
        },{
            id: 'detailGridTotal', 
            ftype: 'uniSummary', 
            showSummaryRow: false,
            dock:'bottom'
        }],
        store: detailStore,
        selModel:'rowmodel',
        columns: [
            { dataIndex: 'COMP_CODE' ,width:100, hidden:true, align:'center'},
            { dataIndex: 'PAY_GRADE_YYYY' ,width:100, hidden:true, align:'center'},
            { dataIndex: 'JOB_CODE' ,width:150},
            { dataIndex: 'WAGES_CODE' ,width:100, hidden:true, align:'center'},
            { dataIndex: 'WAGES_I'  ,width:100}
        ],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
        		
                    if(e.record.phantom == true){
                    	if( UniUtils.indexOf(e.field, ['COMP_CODE'])
                          	|| UniUtils.indexOf(e.field, ['PAY_GRADE_YYYY'])
                          	|| UniUtils.indexOf(e.field, ['WAGES_CODE'])){
                          		return false;
                         }
                    	if(UniUtils.indexOf(e.field, ['WAGES_I'])){
                    		if(Ext.isEmpty(e.record.data.JOB_CODE)){
                    			alert('담당업무를 먼저 입력 해주십시오');
                    			return false;
                    		}else{
                                return true;
                    		}
                    	}else{
                    	   return true;
                    	}
                    }else{
                    	if(UniUtils.indexOf(e.field, ['JOB_CODE'])
                    	  || UniUtils.indexOf(e.field, ['COMP_CODE'])
                    	  || UniUtils.indexOf(e.field, ['PAY_GRADE_YYYY'])
                    	  || UniUtils.indexOf(e.field, ['WAGES_CODE'])){
                    		return false;
                    	}
                    }
        	
        	}
        }
    });   

    Unilite.Main( {
    	borderItems:[{
            region: 'center',
            layout: {type: 'vbox', align: 'stretch'},
            border: false,
            autoScroll: true,
            id:'pageAll',
            items: [
            	panelSearch, detailGrid
            ]
        }],
		id  : 'hbs211ukrApp',
		fnInitBinding: function(){
            UniAppManager.app.fnInitInputFields();
			UniAppManager.setToolbarButtons(['save','print'], false);
            UniAppManager.setToolbarButtons(['reset','newData'], true);
		},
		onQueryButtonDown: function() {
			if(!panelSearch.getInvalidMessage()) return;   //필수체크
			panelSearch.getField('PAY_GRADE_YYYY').setReadOnly(true);//조회 버튼 클릭 시 기준 년도 버튼 readOnly true
            detailStore.loadStoreRecords();
		},
		onNewDataButtonDown: function()	{
			if(!panelSearch.getInvalidMessage()) return;	//필수체크
		
		 	 var compCode = UserInfo.compCode;
             var wagesCode = "BSE";
             var payGradeYyyy = panelSearch.getValue('PAY_GRADE_YYYY');
	
		     
        	 var r = {
				COMP_CODE: compCode,
				PAY_GRADE_YYYY: payGradeYyyy,
				WAGES_CODE: wagesCode		
	        }; 
        	 
			detailGrid.createRow(r); 
			panelSearch.getField('PAY_GRADE_YYYY').setReadOnly(true);
		},
		onSaveDataButtonDown: function() {
            detailStore.saveStore();
        },
        onDeleteDataButtonDown: function() {
            var selRow = detailGrid.getSelectedRecord();
            if(!Ext.isEmpty(selRow)){
                if(selRow.phantom === true) {
                    detailGrid.deleteSelectedRow();
                }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')){
                    detailGrid.deleteSelectedRow();   
                }
            }
                     
        },
		onResetButtonDown: function() {
            panelSearch.clearForm();
            panelSearch.getField('PAY_GRADE_YYYY').setReadOnly(false);
			detailGrid.reset();
			detailStore.clearData();
			UniAppManager.app.fnInitInputFields();
			UniAppManager.setToolbarButtons(['save','delete'], false);
			UniAppManager.setToolbarButtons(['reset'], true);
		},
		fnInitInputFields: function(){
			panelSearch.setValue('PAY_GRADE_YYYY',new Date().getFullYear());
		}
	});
};

</script>
