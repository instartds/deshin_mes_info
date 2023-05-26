<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb930skr_KOCIS"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_afb930skr_KOCIS" /> 	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A132" />			<!-- 수지구분 --> 
	
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A391" /> <!-- 원인행위 -->
    
	<t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	Unilite.defineModel('Afb930skrModel', {
	   fields:[
	       
          {name: 'COMP_CODE'        ,text: '법인코드'               ,type: 'string'},
          {name: 'BUDG_NAME_2'      ,text: '프로그램'               ,type: 'string'},
          {name: 'BUDG_NAME_3'      ,text: '단위사업'               ,type: 'string'},
          {name: 'BUDG_NAME_4'      ,text: '세부사업'               ,type: 'string'},
          {name: 'BUDG_NAME_6'      ,text: '목/세목'               ,type: 'string'},
          {name: 'BUDG_NAME_6'      ,text: '목/세목'               ,type: 'string'},
          {name: 'BUDG_NAME'        ,text: '목/세목 명'             ,type: 'string'},
          {name: 'MONT_IN_AMT'      ,text: '분월분'                ,type: 'uniPrice'},
          {name: 'BEFORE_IN_AMT_I'  ,text: '전월누계액'              ,type: 'uniPrice'},
          {name: 'AMT1'             ,text: '본월반납액'              ,type: 'uniPrice'},
          {name: 'IN_AMT_I'         ,text: '차감누계액'              ,type: 'uniPrice'},
          {name: 'PAY_AMT_I'        ,text: '본월분'                ,type: 'uniPrice'},
          {name: 'BEFORE_PAY_AMT_I' ,text: '전월누계액'              ,type: 'uniPrice'},
          {name: 'AMT2'             ,text: '본월회수액'              ,type: 'uniPrice'},
          {name: 'AMT3'             ,text: '본월경정액'              ,type: 'uniPrice'},
          {name: 'OUT_AMT_I'        ,text: '차감누계액'              ,type: 'uniPrice'},
          {name: 'WON_BAL'          ,text: '지급잔액'               ,type: 'uniPrice'}
	  
	   ]
	   
	   
	});		// End of Ext.define('afb930skrModel', {
	  
			
	var directMasterStore = Unilite.createStore('Afb930skrdirectMasterStore',{
		model: 'Afb930skrModel',
		uniOpt: {
            isMaster: true,				// 상위 버튼 연결
            editable: false,			// 수정 모드 사용
            deletable:false,			// 삭제 가능 여부
	        useNavi : false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 's_afb930skrService_KOCIS.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
//			param.budgNameInfoList = budgNameList;	// 예산목록
			this.load({
				params : param
			});
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
                xtype: 'uniCombobox',
                fieldLabel: '기관',
                name: 'DEPT_CODE',
                store: Ext.data.StoreManager.lookup('deptKocis'),
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DEPT_CODE', newValue);
                    }
                }
            }/*,{
                xtype: 'uniCombobox',
                fieldLabel: '회계구분',
                name: 'AC_GUBUN',
                comboType: 'AU',
                comboCode: 'A390',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_GUBUN', newValue);
                    }
                }
            }*/
            ,{
                xtype: 'uniYearField',
                fieldLabel: '회계년도',
                name: 'AC_YEAR',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_YEAR', newValue);
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '발생월',
                name: 'AC_MONTH_FR',
                comboType: 'AU',
                comboCode: 'HE24',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_MONTH_FR', newValue);
                    }
                }
            }/*,{
                xtype: 'uniCombobox',
                fieldLabel: '화폐단위',
                name: 'MONEY_UNIT',
                comboType: 'AU',
                comboCode: 'B004',
//                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('MONEY_UNIT', newValue);
                    }
                }
            }*/]	
		}]
	});	// end panelSearch
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
		items: [{
            xtype: 'uniCombobox',
            fieldLabel: '기관',
            name: 'DEPT_CODE',
            store: Ext.data.StoreManager.lookup('deptKocis'),
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DEPT_CODE', newValue);
                }
            }
        }/*,{
            xtype: 'uniCombobox',
            fieldLabel: '회계구분',
            name: 'AC_GUBUN',
            comboType: 'AU',
            comboCode: 'A390',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('AC_GUBUN', newValue);
                }
            }
        }*/
        ,{
            xtype: 'uniYearField',
            fieldLabel: '회계년도',
            name: 'AC_YEAR',
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('AC_YEAR', newValue);
                }
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '발생월',
            name: 'AC_MONTH_FR',
            comboType: 'AU',
            comboCode: 'HE24',
            width:200,
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('AC_MONTH_FR', newValue);
                }
            }
        }/*,{
            xtype: 'uniCombobox',
            fieldLabel: '화폐단위',
            name: 'MONEY_UNIT',
            comboType: 'AU',
            comboCode: 'B004',
//            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('MONEY_UNIT', newValue);
                }
            }
        }*//*,{
            xtype:'uniTextfield',
            name:'DEPT_CODE',
            hidden:false
            
        }*/
        
        ]
	});
	
    /*
	 * Master Grid1 정의(Grid Panel) @type
	 * 
	 */	
    var masterGrid = Unilite.createGrid('Afb930skrGrid', {
    	title:'관서운영경비 출납계산서',
        features: [{
                id: 'masterGridSubTotal',   
                ftype: 'uniGroupingsummary',    
                showSummaryRow: true//, enableGroupingMenu:false
            },{
                id: 'masterGridTotal',      
                ftype: 'uniSummary',            
                showSummaryRow: true
            }
        ],
//    	layout : 'fit',
        region : 'center',
		store: directMasterStore,
        selModel	: 'rowmodel',
		tbar:[{
            xtype: 'button',
            text: '출납계산서 표지출력',
            handler: function() {/*
                var records = directSearchStore.data.items;
                var tempSum = 0;
                Ext.each(records,  function(record, index, records){
                    record.set('SELECT', true);
                    
                    if(record.get('UL_CHECK') == 'O'){
                        tempSum = tempSum + record.get('AQUI_SUM');
                    }
                });
                searchGrid.down("#checkListSum").setValue(tempSum);
            */}
        },'-',{
            xtype: 'button',
            text: '인쇄',
            handler: function() {/*
                var records = directSearchStore.data.items;
                Ext.each(records,  function(record, index, records){
                    record.set('SELECT', false);
                    
                    searchGrid.down("#checkListSum").setValue(0);
                });
            */}
        },'-'
        ],
        uniOpt: {
            useMultipleSorting  : true,
            useLiveSearch       : true,
            onLoadSelectFirst   : true,
            dblClickToEdit      : false,
//          useGroupSummary     : true,
            useSqlTotal         : false,
            useContextMenu      : false,
            useRowNumberer      : true,
            expandLastColumn    : false,
            useRowContext       : true,
            filter: {
                useFilter       : true,
                autoCreate      : true
            },
            state: {
                useState: false,            
                useStateList: false     
            }
        },        
//		uniOpt: {
//            useMultipleSorting  : true,
//            useLiveSearch       : true,
//            onLoadSelectFirst   : true,
//    		dblClickToEdit		: false,
//    		useGroupSummary		: false,
//			useContextMenu		: false,
//			useRowNumberer		: false,
//			expandLastColumn	: false,
//    		filter: {
//				useFilter		: true,
//				autoCreate		: true
//			},
//            state: {
//                useState: false,            
//                useStateList: false     
//            }
//        },
        columns: [
            { dataIndex: 'COMP_CODE'                    , width:120,hidden:true},
            { text : '과목',
                columns : [
                    { dataIndex: 'BUDG_NAME_2'          , width: 90, align :'left'},
                    { dataIndex: 'BUDG_NAME_3'          , width: 90, align :'left'},
                    { dataIndex: 'BUDG_NAME_4'          , width: 90, align :'left'},
                    { dataIndex: 'BUDG_NAME_6'          , width: 90, align :'left'}
                ]
            },   
            { dataIndex: 'BUDG_NAME'        ,    width: 120,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
                }
            },
            { text : '영수액',
                columns : [
                    { dataIndex: 'MONT_IN_AMT'          , width: 110, align :'right', summaryType:'sum'},
                    { dataIndex: 'BEFORE_IN_AMT_I'      , width: 110, align :'right', summaryType:'sum'},
                    { dataIndex: 'AMT1'                 , width: 110, align :'right', summaryType:'sum'},
                    { dataIndex: 'IN_AMT_I'             , width: 110, align :'right', summaryType:'sum'}
                ]
            },
            { text : '지급액',
                columns : [
                    { dataIndex: 'PAY_AMT_I'            , width: 110, align :'right', summaryType:'sum'},
                    { dataIndex: 'BEFORE_PAY_AMT_I'     , width: 110, align :'right', summaryType:'sum'},
                    { dataIndex: 'AMT2'                 , width: 110, align :'right', summaryType:'sum'},
                    { dataIndex: 'AMT3'                 , width: 110, align :'right', summaryType:'sum'},
                    { dataIndex: 'OUT_AMT_I'            , width: 110, align :'right', summaryType:'sum'}
                ]
            },
            { dataIndex: 'WON_BAL'                      , width:110, summaryType:'sum'}
        ]
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
		id : 'Afb930skrApp',
		fnInitBinding : function() {
            var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
			
            UniAppManager.app.fnInitInputFields(); 
		},
		onQueryButtonDown : function()	{		
			if(!this.isValidSearchForm()){
                return false;
            }else{
                masterGrid.getStore().loadStoreRecords();
            }
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			directMasterStore.clearData();
			this.fnInitBinding();
		},
        fnInitInputFields: function(){
  /*          var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('FR_AC_DATE');*/
//            
//            panelSearch.setValue('FR_AC_DATE', UniDate.get('startOfMonth'));
//            panelSearch.setValue('TO_AC_DATE', UniDate.get('today'));
//            panelResult.setValue('FR_AC_DATE', UniDate.get('startOfMonth'));
//            panelResult.setValue('TO_AC_DATE', UniDate.get('today'));
            UniAppManager.setToolbarButtons('save',false);
            UniAppManager.setToolbarButtons('reset',true);
            
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
        }
	});
};


</script>
