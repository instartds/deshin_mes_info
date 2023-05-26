<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hpa910rkr_jw"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
</t:appConfig>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>

<script type="text/javascript" >

function appMain() {
	         
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read    : 'S_hpa910rkr_jwService.selectList1'
        }
    }); 
    
    var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read    : 'S_hpa910rkr_jwService.selectList2'
        }
    }); 
    
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_hpa910rkr_jwModel1', {
	    fields: [
	    	{name: 'COMP_CODE'        , text: '법인코드'             , type: 'string'},
	    	{name: 'DIV_CODE'		  , text: '사업장'		         , type: 'string', comboType: 'BOR120'},
	    	{name: 'PAY_YYYYMM'    	  , text: '급여년월'	         , type: 'string'},
	    	{name: 'SUPP_TYPE'		  , text: '지급구분'	         , type: 'string'},
	    	{name: 'DEPT_CODE'		  , text: '부서코드'	         , type: 'string'},
	    	{name: 'DEPT_NAME'	      , text: '부서명'		         , type: 'string'},
	    	{name: 'AMOUNT_I_1'       , text: '기본급여(본봉)'        , type: 'uniPrice'},
	    	{name: 'AMOUNT_I_2'       , text: '출장,파견,(기타)수당'    , type: 'uniPrice'},
	    	{name: 'AMOUNT_I_3'       , text: '연장,심야수당'         , type: 'uniPrice'},
	    	{name: 'AMOUNT_I_4'       , text: '특근수당'            , type: 'uniPrice'},
	    	{name: 'DED_AMOUNT_I_1'   , text: '기본급여(본봉) 공제'     , type: 'uniPrice'},
            {name: 'DED_AMOUNT_I_2'   , text: '출장,파견,(기타)수당 공제' , type: 'uniPrice'},
            
            {name: 'DED_AMOUNT_I_3'   , text: '연장,심야수당 공제'      , type: 'uniPrice'},
            {name: 'DED_AMOUNT_I_4'   , text: '특근수당 공제'         , type: 'uniPrice'},
	    	{name: 'AMOUNT_I_TOT'     , text: '지급액 합계'          , type: 'uniPrice'},
	    	{name: 'DED_AMOUNT_TOT'   , text: '공제액 합계'          , type: 'uniPrice'},
	    	{name: 'REAL_AMOUNT_I'    , text: '실지급액 합계'         , type: 'uniPrice'},
	    	{name: 'BF_MONTH_AMOUNT_I', text: '지급액 합계'          , type: 'uniPrice'},
	    	{name: 'INCREASE_AMOUNT_I', text: '급상여 증감'          , type: 'uniPrice'},
	    	{name: 'AF_PERSONNEL'     , text: '인원'                , type: 'int'},
	    	{name: 'BF_PERSONNEL'     , text: '인원'                , type: 'int'},
	    	{name: 'PERSONEL'         , text: '인원 증감'           , type: 'int'},
	    	{name: 'REMARK'           , text: '비고'              , type: 'string'}
	    	
		]
	});
	
	/**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_hpa910rkr_jwModel2', {
        fields: [
            {name: 'COMP_CODE'        , text: '법인코드'             , type: 'string'},
            {name: 'DIV_CODE'         , text: '사업장'              , type: 'string', comboType: 'BOR120'},
            {name: 'PAY_YYYYMM'       , text: '급여년월'             , type: 'string'},
            {name: 'SUPP_TYPE'        , text: '지급구분'             , type: 'string'},
            {name: 'DEPT_CODE'        , text: '부서코드'             , type: 'string'},
            {name: 'DEPT_NAME'        , text: '부서명'              , type: 'string'},
            {name: 'AMOUNT_I_1'       , text: '기본급여(본봉)'        , type: 'uniPrice'},
            {name: 'AMOUNT_I_2'       , text: '출장,파견,(기타)수당'    , type: 'uniPrice'},
            {name: 'AMOUNT_I_3'       , text: '연장,심야수당'         , type: 'uniPrice'},
            {name: 'AMOUNT_I_4'       , text: '특근수당'            , type: 'uniPrice'},
            {name: 'DED_AMOUNT_I_1'   , text: '기본급여(본봉) 공제'     , type: 'uniPrice'},
            {name: 'DED_AMOUNT_I_2'   , text: '출장,파견,(기타)수당 공제' , type: 'uniPrice'},
            {name: 'DED_AMOUNT_I_3'   , text: '연장,심야수당 공제'      , type: 'uniPrice'},
            {name: 'DED_AMOUNT_I_4'   , text: '특근수당 공제'         , type: 'uniPrice'},
            {name: 'AMOUNT_I_TOT'     , text: '지급액 합계'          , type: 'uniPrice'},
            {name: 'DED_AMOUNT_TOT'   , text: '공제액 합계'          , type: 'uniPrice'},
            {name: 'REAL_AMOUNT_I'    , text: '차인지급액'         , type: 'uniPrice'},
            {name: 'AF_PERSONNEL'    , text: '인원'               , type: 'int'}
        ]
    });
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('s_hpa910rkr_jwMasterStore1',{
		model: 's_hpa910rkr_jwModel1',
		uniOpt: {
			isMaster: false,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable:false,			// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
        autoLoad: false,
        proxy   : directProxy,
		loadStoreRecords: function() {
			var param = Ext.getCmp('resultForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
        saveStore : function()  {
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();                
            var toDelete = this.getRemovedRecords();
            
            var paramMaster = Ext.getCmp('resultForm').getValues();
            
            if(inValidRecs.length == 0 )    {
                config = {
                    params  : [paramMaster],
                    success : function(batch, option) {                             
                        panelResult.resetDirtyStatus();
                        UniAppManager.setToolbarButtons('save', false); 

                    } 
                };                  
                this.syncAllDirect(config);
                
            }else {
                masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }

	});
	
	/**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore2 = Unilite.createStore('s_hpa910rkr_jwMasterStore2',{
        model: 's_hpa910rkr_jwModel2',
        uniOpt: {
            isMaster: false,            // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable:false,            // 삭제 가능 여부 
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy   : directProxy2,
        loadStoreRecords: function() {
            var param = Ext.getCmp('resultForm').getValues();           
            console.log( param );
            this.load({
                params : param
            });
        },
        saveStore : function()  {
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();                
            var toDelete = this.getRemovedRecords();
            
            var paramMaster = Ext.getCmp('resultForm').getValues();
            
            if(inValidRecs.length == 0 )    {
                config = {
                    params  : [paramMaster],
                    success : function(batch, option) {                             
                        panelResult.resetDirtyStatus();
                        UniAppManager.setToolbarButtons('save', false); 

                    } 
                };                  
                this.syncAllDirect(config);
                
            }else {
                masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }

    });
		
    var panelResult = Unilite.createSearchForm('resultForm', {        
        region: 'north',
        layout : {type : 'uniTable', columns :  2},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [
                {
                    fieldLabel: '사업장',
                    name: 'DIV_CODE',
                    xtype: 'uniCombobox',
                    comboType: 'BOR120'
                },
                {
                    fieldLabel: '급여년월',
                    xtype: 'uniMonthfield',
                    name: 'PAY_YYYYMM',
                    allowBlank:false,
                    listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                            var month = parseInt(UniDate.getDbDateStr(newValue).substring(4,6));
                            Ext.getCmp('PAY_YYYYMM').setText(  month  + '월' + '급상여 내역');
                            Ext.getCmp('PAY_YYYYMM1').setText( month-1  + '월' + '급상여 내역');
                            Ext.getCmp('PERSONNEL1').setText( month    + '월' + ' 인원');
                            Ext.getCmp('PERSONNEL2').setText( month-1  + '월' + ' 인원');
                        }
                    }
                },
                Unilite.popup('DEPT',{
                    fieldLabel: '부서',
                    valueFieldName: 'FR_DEPT_CODE',
                    textFieldName: 'FR_DEPT_NAME',
                    validateBlank: false
                }),
                Unilite.popup('DEPT', {
                    fieldLabel: '~',
                    labelWidth:15,
                    valueFieldName: 'TO_DEPT_CODE',
                    textFieldName: 'TO_DEPT_NAME',
                    validateBlank: false
                }),
                {
                xtype: 'radiogroup',
                fieldLabel: '출력구분 ',
                id: 'printGubun',
                items: [{
                    boxLabel: '부서별내역',
                    width: 120,
                    name: 'printGubun',
                    inputValue: '1',
                    checked: true
                }, {
                    boxLabel: '표지',
                    width: 120,
                    inputValue: '2',
                    name: 'printGubun'
                }]
            }]
    });
	
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid1 = Unilite.createGrid('s_hpa910rkr_jwGrid1', {
    	// for tab    
    	title: '부서별내역',
        layout: 'fit',
        region:'center',
        id : 's_hpa910rkr_jwGrid1Tab',
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true,
                    useGroupSummary     : true
        },
        store: directMasterStore1,
        features: [
            {id: 'masterGridSubTotal'   , ftype: 'uniGroupingsummary'   , showSummaryRow: true},
            {id: 'masterGridTotal'      , ftype: 'uniSummary'           , showSummaryRow: true}
        ],
        tbar:[
            '->',
        {
            xtype:'button',
            text:'보고서 출력',
            handler:function()  {                
                if(masterGrid1.getSelectedRecords().length > 0 ){
                    UniAppManager.app.onPrintButtonDown();
                }
                else{
                    alert("선택된 자료가 없습니다.");
                }
            }
        }],
        columns: [
			{dataIndex: 'COMP_CODE'       , width: 90, hidden: true},
			{dataIndex: 'DIV_CODE'		  , width: 120, hidden: true},
			{dataIndex: 'DEPT_NAME'		  , width: 150,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
                }
            },
			{dataIndex: 'PAY_YYYYMM'        , width: 150, hidden: true},
			{id: 'PAY_YYYYMM' , 
                columns: [
                    {dataIndex: 'AMOUNT_I_1' , width: 100,summaryType: 'sum'}, 
                    {dataIndex: 'AMOUNT_I_2' , width: 100,summaryType: 'sum'},
                    {dataIndex: 'AMOUNT_I_3' , width: 100,summaryType: 'sum'},
                    {dataIndex: 'AMOUNT_I_4' , width: 100,summaryType: 'sum'},
                    {dataIndex: 'DED_AMOUNT_I_1' , width: 100, hidden: true}, 
                    {dataIndex: 'DED_AMOUNT_I_2' , width: 100, hidden: true},
                    {dataIndex: 'DED_AMOUNT_I_3' , width: 100, hidden: true},
                    {dataIndex: 'DED_AMOUNT_I_4' , width: 100, hidden: true},
                    {dataIndex: 'AMOUNT_I_TOT' , width: 100,summaryType: 'sum'},
                    {dataIndex: 'DED_AMOUNT_TOT' , width: 100,summaryType: 'sum'},
                    {dataIndex: 'REAL_AMOUNT_I' , width: 100,summaryType: 'sum'}
                ]
            },
            {id: 'PAY_YYYYMM1' , 
                columns: [
                    {dataIndex: 'BF_MONTH_AMOUNT_I' , width: 100,summaryType: 'sum'} 
                ]
            },
            {dataIndex: 'INCREASE_AMOUNT_I' , width: 100,summaryType: 'sum'},
            {id: 'PERSONNEL1' , 
                columns: [
                    {dataIndex: 'AF_PERSONNEL' , width: 100,summaryType: 'sum'} 
                ]
            },
            {id: 'PERSONNEL2' , 
                columns: [
                    {dataIndex: 'BF_PERSONNEL' , width: 100,summaryType: 'sum'} 
                ]
            },
            {dataIndex: 'PERSONEL' , width: 100,summaryType: 'sum'},
            {dataIndex: 'REMARK' , width: 100}
		],
        selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
        listeners: {
            
        }
	});
	 /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
    var masterGrid2 = Unilite.createGrid('s_hpa910rkr_jwGrid2', {
        // for tab    
        title: '표지',
        layout: 'fit',
        region:'center',
        id : 's_hpa910rkr_jwGrid2Tab',
        uniOpt:{    expandLastColumn: true,
                    useRowNumberer: true,
                    useMultipleSorting: true,
                    useGroupSummary     : true
        },
        tbar:[
            '->',
        {
            xtype:'button',
            text:'보고서 출력',
            handler:function()  {                
                if(masterGrid2.getSelectedRecords().length > 0 ){
                    UniAppManager.app.onPrintButtonDown();
                }
                else{
                    alert("선택된 자료가 없습니다.");
                }
            }
        }],
        store: directMasterStore2,
        features: [
            {id: 'masterGridSubTotal'   , ftype: 'uniGroupingsummary'   , showSummaryRow: true},
            {id: 'masterGridTotal'      , ftype: 'uniSummary'           , showSummaryRow: true}
        ],
        columns: [
           {dataIndex: 'COMP_CODE'       , width: 90, hidden: true},
            {dataIndex: 'DIV_CODE'        , width: 120, hidden: true},
            {dataIndex: 'DEPT_NAME'       , width: 150,
              summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                  return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
              }
            },
            {dataIndex: 'PAY_YYYYMM'        , width: 150, hidden: true},
            {dataIndex: 'AMOUNT_I_1' , width: 100,summaryType: 'sum'}, 
            {dataIndex: 'AMOUNT_I_2' , width: 100,summaryType: 'sum'},
            {dataIndex: 'AMOUNT_I_3' , width: 100,summaryType: 'sum'},
            {dataIndex: 'AMOUNT_I_4' , width: 100,summaryType: 'sum'},
            {dataIndex: 'DED_AMOUNT_I_1' , width: 100, hidden: true}, 
            {dataIndex: 'DED_AMOUNT_I_2' , width: 100, hidden: true},
            {dataIndex: 'DED_AMOUNT_I_3' , width: 100, hidden: true},
            {dataIndex: 'DED_AMOUNT_I_4' , width: 100, hidden: true},
            {dataIndex: 'AMOUNT_I_TOT' , width: 100,summaryType: 'sum'},
            {dataIndex: 'DED_AMOUNT_TOT' , width: 100,summaryType: 'sum'},
            {dataIndex: 'REAL_AMOUNT_I' , width: 100,summaryType: 'sum'},
            {dataIndex: 'AF_PERSONNEL' , width: 100,summaryType: 'sum'}
            
        ],
        selModel: 'rowmodel',       // 조회화면 selectionchange event 사용
        listeners: {
            
        }
    });
		
	var tab = Ext.create('Ext.tab.Panel',{
            region:'center',
//          activeTab: 0,
//          tabPosition : 'bottom',
//          dockedItems : [tbar],
            //layout:  {    type: 'vbox',  align: 'stretch' },
//          layout:  'border',                     
//          flex : 1,
            items: [
                masterGrid1, masterGrid2
            ],
            listeners: {
             tabchange: function(){
                var activeTabId = tab.getActiveTab().getId();
                    if (activeTabId == 's_hpa910rkr_jwGrid1'){
                    	Ext.getCmp('printGubun').setValue('1');
                    } 
                    if (activeTabId == 's_hpa910rkr_jwGrid2'){
                    	Ext.getCmp('printGubun').setValue('2');
                    }
             }
         }
        });
        	
		
	Unilite.Main( {
		borderItems:[{
			layout:'border',
			region:'center',
			flex:1.4,
			items:[
		 		 //masterGrid1
		 	   //, masterGrid2
		 	    tab
			   , panelResult
			   
		    ]
		 }],

		id: 's_hpa910rkr_jwApp',
		fnInitBinding: function() {
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('PAY_YYYYMM', UniDate.get('startOfMonth'));
            var month = parseInt(UniDate.getDbDateStr(panelResult.getValue('PAY_YYYYMM')).substring(4,6));
            Ext.getCmp('PAY_YYYYMM').setText( month  +'월' +'급상여 내역');
            Ext.getCmp('PAY_YYYYMM1').setText( month-1  +'월' +'급상여 내역');
            Ext.getCmp('PERSONNEL1').setText( month  +'월' +' 인원');
            Ext.getCmp('PERSONNEL2').setText( month-1  +'월' +' 인원');
		},
		onQueryButtonDown: function() {
			
			var activeTabId = tab.getActiveTab().getId();
			//masterGrid1.getStore().loadStoreRecords();
			
			if(!this.isValidSearchForm()){
                return false;
            } else {
    			if(tab.getActiveTab().getId() == 's_hpa910rkr_jwGrid1'){
    				    masterGrid1.getStore().loadStoreRecords();
    				    
                    } else if(tab.getActiveTab().getId() == 's_hpa910rkr_jwGrid2') {
                        masterGrid2.getStore().loadStoreRecords();
                    } 
            }
            var viewNormal = masterGrid1.getView();
            viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
            viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
        },
        onResetButtonDown: function () {
                panelResult.clearForm();
                this.fnInitBinding();
        },
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		},
		onPrintButtonDown: function() {
			if(!panelResult.getInvalidMessage()) return;   //필수체크
            var param = panelResult.getValues();
            var win = Ext.create('widget.CrystalReport', {
                url: CPATH+'/z_jw/s_hpa910crkrv_jw.do',
                prgID: 's_hpa910crkrv_jw',
                    extParam: param
                });
                win.center();
                win.show();
            
        }
	});
};


</script>
