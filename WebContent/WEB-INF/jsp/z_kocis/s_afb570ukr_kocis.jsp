<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb570ukr_kocis"  >

	<t:ExtComboStore comboType="AU" comboCode="A132" />	<!-- 수지구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A170" opts='2;3'/> <!-- 이월/불용승인 구분 (예산구분) -->
    <t:ExtComboStore comboType="AU" comboCode="A134" /> <!-- 결재상태 --> 
	
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
    <t:ExtComboStore items="${COMBO_SAVE_CODE}" storeId="saveCode" /> <!--계좌코드-->
    
    
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_afb570ukrkocisService.selectList',
			update: 's_afb570ukrkocisService.updateDetail',
			create: 's_afb570ukrkocisService.insertDetail',
			destroy: 's_afb570ukrkocisService.deleteDetail',
			syncAll: 's_afb570ukrkocisService.saveAll'
		}
	});
	
	Unilite.defineModel('afb570ukrModel', {
		fields:[
		  
            {name: 'BUDG_YYYY'          ,text: '이월년도'          ,type: 'string'},
            {name: 'DEPT_CODE'          ,text: '기관'            ,type: 'string'},
            {name: 'DEPT_NAME'          ,text: '기관명'           ,type: 'string'},
            {name: 'ACCT_NO'            ,text: '계좌코드'          ,type: 'string'},
            {name: 'ACCT_NAME'          ,text: '계좌명'           ,type: 'string'},
            {name: 'BUDG_CODE'          ,text: '예산과목'          ,type: 'string'},
            {name: 'BUDG_NAME_1'        ,text: '부문'             ,type: 'string'},
            {name: 'BUDG_NAME_4'        ,text: '세부사업'          ,type: 'string'},
            {name: 'BUDG_NAME_6'        ,text: '세목'             ,type: 'string'},
            {name: 'USE_AMT_I'          ,text: '불용금액'          ,type: 'uniPrice'},
            {name: 'CONF_AMT_I'         ,text: '불용승인금액'        ,type: 'uniPrice'},
            {name: 'CONF_AMT_I_DUMMY'   ,text: 'DUMMY'        ,type: 'uniPrice'},
            {name: 'PROCESS_YN'         ,text: '승인여부'           ,type: 'string'}
            
        ]
	});
	
	var detailStore = Unilite.createStore('afb570ukrDetailStore',{
		model: 'afb570ukrModel',
		uniOpt: {
            isMaster: true,				// 상위 버튼 연결
            editable: true,			// 수정 모드 사용
            deletable:false,				// 삭제 가능 여부
	        useNavi : false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					
					success: function(batch, option) {
						//2.마스터 정보(Server 측 처리 시 가공)
						/*var master = batch.operations[0].getResultSet();
						panelSearch.setValue("ORDER_NUM", master.ORDER_NUM);*/
						//3.기타 처리
						
						detailStore.loadStoreRecords();
						
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);		
						
						
					} 
				};
				this.syncAllDirect(config);
			} else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});
	
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
    	width: 360,
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
			title: '기본정보', 	
	   		itemId: 'search_panel1',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
                xtype: 'uniYearField',
                fieldLabel: '이월년도',
                name: 'BUDG_YYYY',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                        panelResult.setValue('BUDG_YYYY', newValue);
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '기관',
                name: 'DEPT_CODE',
                store: Ext.data.StoreManager.lookup('deptKocis'),
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DEPT_CODE', newValue);
                    }
                }
            },
	        Unilite.popup('BUDG_KOCIS_NORMAL',{
		        fieldLabel: '예산과목',
			    valueFieldName:'BUDG_CODE',
			    textFieldName:'BUDG_NAME',
		        //validateBlank:false,
				listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_CODE', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_NAME', newValue);             
                    },
                    applyextparam: function(popup) {
                        popup.setExtParam({'AC_YYYY': panelResult.getValue('BUDG_YYYY')}),
                        popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                        popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = '2' AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                    }
                }
		    })]	
		}]
	});	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
            xtype: 'uniYearField',
            fieldLabel: '이월년도',
            name: 'BUDG_YYYY',
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {      
                    panelSearch.setValue('BUDG_YYYY', newValue);
                }
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '기관',
            name: 'DEPT_CODE',
            store: Ext.data.StoreManager.lookup('deptKocis'),
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DEPT_CODE', newValue);
                }
            }
        },
        Unilite.popup('BUDG_KOCIS_NORMAL',{
            fieldLabel: '예산과목',
            valueFieldName:'BUDG_CODE',
            textFieldName:'BUDG_NAME',
            //validateBlank:false,
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_CODE', newValue);                              
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_NAME', newValue);             
                },
                applyextparam: function(popup) {
                    popup.setExtParam({'AC_YYYY': panelSearch.getValue('BUDG_YYYY')}),
                    popup.setExtParam({'DEPT_CODE' : panelSearch.getValue('DEPT_CODE')}),
                    popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = '2' AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                }
            }
        })]
	});
	
    var masterGrid = Unilite.createGrid('afb570ukrGrid', {	
    	features: [{
			id: 'masterGridSubTotal',	
			ftype: 'uniGroupingsummary',	
			showSummaryRow: false
		},{
			id: 'masterGridTotal',		
			ftype: 'uniSummary',			
			showSummaryRow: false
		}],
    	layout : 'fit',
        region : 'center',
		store: detailStore,
		uniOpt : {
			useMultipleSorting	: true,			 
    		useLiveSearch		: false,			
    		onLoadSelectFirst	: false,		
    		dblClickToEdit		: true,		
    		useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: false,			
			expandLastColumn	: false,		
			useRowContext		: false,	// rink 항목이 있을경우만 true			
			filter: {
				useFilter	: true,		
				autoCreate	: true		
			}
		},
//		selModel:'rowmodel',
		selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly : true,
            listeners: {
                select: function(grid, selectRecord, index, rowIndex, eOpts ){
                	
                    selectRecord.set('CONF_AMT_I',selectRecord.data.USE_AMT_I);
                    
                },
                deselect:  function(grid, selectRecord, index, eOpts ){
                	
                    selectRecord.set('CONF_AMT_I',selectRecord.data.CONF_AMT_I_DUMMY);
                  
                }
            }
		}),
        columns: [
            { dataIndex: 'BUDG_YYYY'              ,width:100},
            { dataIndex: 'DEPT_CODE'              ,width:100,hidden:true},
            { dataIndex: 'DEPT_NAME'              ,width:100},
            { dataIndex: 'ACCT_NO'                ,width:100,hidden:true},
            { dataIndex: 'ACCT_NAME'              ,width:100},
            { dataIndex: 'BUDG_CODE'              ,width:170,
                renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    return (val.substring(0, 3) + '-' + val.substring(3, 7) + '-' + 
                            val.substring(7, 11) + '-' + val.substring(11, 14) + '-' + 
                            val.substring(14, 17) + '-' + val.substring(17, 19));
                }
            },
        
            { dataIndex: 'BUDG_NAME_1'            ,width:150},
            { dataIndex: 'BUDG_NAME_4'            ,width:150},
            { dataIndex: 'BUDG_NAME_6'            ,width:150},
            { dataIndex: 'USE_AMT_I'              ,width:150},
            { dataIndex: 'CONF_AMT_I'             ,width:150},
            { dataIndex: 'CONF_AMT_I_DUMMY'       ,width:150,hidden:true},
            { dataIndex: 'PROCESS_YN'             ,width:80}
        ],
        listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
        		if(UniUtils.indexOf(e.field, ['CONF_AMT_I']))
			   	{
					return true;
  				} else {
  					return false;
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
				masterGrid, panelResult
			]
		},
			panelSearch  	
		], 
		id : 'afb570App',
		fnInitBinding : function() {
            UniAppManager.app.fnInitInputFields(); 
		},
		onQueryButtonDown : function()	{
            if(!panelResult.getInvalidMessage()) return;   //필수체크
			detailStore.loadStoreRecords();
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			detailStore.saveStore();
//			MasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			detailStore.clearData();
			this.fnInitInputFields();
		},
		fnInitInputFields: function(){
			var activeSForm;
            if(!UserInfo.appOption.collapseLeftSearch) {
                activeSForm = panelSearch;
            } else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('BUDG_YYYY');
            panelSearch.setValue('BUDG_YYYY', UniDate.getDbDateStr(UniDate.today()).substring(0, 4));
            panelResult.setValue('BUDG_YYYY', UniDate.getDbDateStr(UniDate.today()).substring(0, 4));
            UniAppManager.setToolbarButtons('reset',false);
			
            panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
            panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
            
            if(!Ext.isEmpty(UserInfo.deptCode)){
                if(UserInfo.deptCode == '01'){
                    panelSearch.getField('DEPT_CODE').setReadOnly(false);
                    panelResult.getField('DEPT_CODE').setReadOnly(false);
                }else{
                    panelSearch.getField('DEPT_CODE').setReadOnly(true);
                    panelResult.getField('DEPT_CODE').setReadOnly(true);
                }
            }else{
                panelSearch.getField('DEPT_CODE').setReadOnly(true);
                panelResult.getField('DEPT_CODE').setReadOnly(true);
            }
            
            
            UniAppManager.setToolbarButtons(['reset'], true);
		}
		
	});
/*	
    function setCalcAmt1 (values,record) {
        var mainRecords = detailStore.data.items;
        Ext.each(mainRecords, function(mainRecord, i){
            if(mainRecord.phantom === true){ 
                if(record.get('BUDG_CODE') == mainRecord.get('BUDG_CODE')){
                    values = values - mainRecord.get('IWALL_AMT_I');
                }
            }
        })
        return values;//Ext.String.htmlDecode(value);
    }
    function setCalcAmt2 (values,record) {
        var mainRecords = detailStore.data.items;
        Ext.each(mainRecords, function(mainRecord, i){
            if(mainRecord.phantom === true){ 
                if(record.get('BUDG_CODE') == mainRecord.get('BUDG_CODE')){
                    values = values - mainRecord.get('IWALL_AMT_I');
                }
            }
        })
        return values;//Ext.String.htmlDecode(value);
    }*/
	Unilite.createValidator('validator01', {
		store: detailStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				
				case "CONF_AMT_I" :			// 불용승인금액
				    if(newValue < 0 ) {
                        rv='불용승인금액이 0보다 작을 수 없습니다.';
                        break;
                    }
					if(record.get('USE_AMT_I') < newValue) {
						rv='불용승인금액이 불용금액보다 클 수 없습니다.';
						break;
					}
				break;
			}
			return rv;
		}
	})
};
</script>