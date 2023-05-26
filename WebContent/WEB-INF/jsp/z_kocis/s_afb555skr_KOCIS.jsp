<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb555skr_KOCIS"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_afb555skr_KOCIS" /> 	<!-- 사업장 --> 
	
    <t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A391" /> <!-- 원인행위 -->
    
    <t:ExtComboStore comboType="AU" comboCode="A395" />        <!-- 지급방법 -->
    <t:ExtComboStore comboType="AU" comboCode="A394" />        <!-- 계약구분 -->
    
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
    
	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	
	Unilite.defineModel('Afb555Model1', {
        fields: [
        	{name: 'AC_GUBUN'          , text: '회계구분'             , type: 'string',comboType:'AU', comboCode:'A390'},
            {name: 'BUDG_CODE'         , text: '예산과목'             , type: 'string'},
            {name: 'BUDG_NAME_1'       , text: '부문'                , type: 'string'},
            {name: 'BUDG_NAME_4'       , text: '세부사업'             , type: 'string'},
            {name: 'BUDG_NAME_6'       , text: '세목'                , type: 'string'},
            {name: 'BUDG_I'            , text: '연간예산금액'           , type: 'uniUnitPrice'},
            {name: 'RESULT'            , text: '예산잔액'             , type: 'uniUnitPrice'},
            {name: 'DOC_NO'            , text: '지출번호'             , type: 'string'},
            {name: 'TITLE'             , text: '지출건명'             , type: 'string'},
            {name: 'PAY_DATE'          , text: '지출일'              , type: 'uniDate'},
            {name: 'TOT_AMT_I'         , text: '지출금액'             , type: 'uniUnitPrice'},
            {name: 'PAY_DIVI'          , text: '지급방법'             , type: 'string',comboType:'AU', comboCode:'A395'},
            {name: 'CUSTOM_NAME'       , text: '거래처명'             , type: 'string'},
            {name: 'CONTRACT_GUBUN'    , text: '계약구분'             , type: 'string',comboType:'AU', comboCode:'A394'}
        ]
    }); 
	  			
	var masterStore = Unilite.createStore('Afb555masterStore',{
		model: 'Afb555Model1',
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
                read: 's_afb555skrService_KOCIS.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
    	width: 380,
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
                fieldLabel: '예산년도',
                name: 'AC_YEAR',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('AC_YEAR', newValue);
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '지출월',
                name: 'PAY_MONTH',
                comboType: 'AU',
                comboCode: 'HE24',
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('PAY_MONTH', newValue);
                    }
                }
            },{
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
            },{
                fieldLabel: '원인행위',
                name: 'AC_TYPE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'A391',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {      
                        panelResult.setValue('AC_TYPE', newValue);
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '기관',
                name: 'DEPT_CODE',
                store: Ext.data.StoreManager.lookup('deptKocis'),
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DEPT_CODE', newValue);
                    }
                }
            },
            Unilite.popup('BUDG_KOCIS_NORMAL', {
                fieldLabel: '예산과목', 
                valueFieldName: 'BUDG_CODE',
                textFieldName: 'BUDG_NAME', 
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_CODE', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_NAME', newValue);                
                    },
                    applyextparam: function(popup) {
                        popup.setExtParam({'AC_YYYY': panelResult.getValue('AC_YEAR')}),
                        popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                        popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = '2' AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                    }
                }
            })
			]	
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
            xtype: 'uniYearField',
            fieldLabel: '예산년도',
            name: 'AC_YEAR',
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('AC_YEAR', newValue);
                }
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '지출월',
            name: 'PAY_MONTH',
            comboType: 'AU',
            comboCode: 'HE24',
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('PAY_MONTH', newValue);
                }
            }
        },{
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
        },{
            fieldLabel: '원인행위',
            name: 'AC_TYPE',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'A391',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('AC_TYPE', newValue);
                }
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '기관',
            name: 'DEPT_CODE',
            store: Ext.data.StoreManager.lookup('deptKocis'),
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DEPT_CODE', newValue);
                }
            }
        },
        Unilite.popup('BUDG_KOCIS_NORMAL', {
            fieldLabel: '예산과목', 
            valueFieldName: 'BUDG_CODE',
            textFieldName: 'BUDG_NAME', 
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_CODE', newValue);                                
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_NAME', newValue);                
                },
                applyextparam: function(popup) {
                    popup.setExtParam({'AC_YYYY': panelResult.getValue('AC_YEAR')}),
                    popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                    popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = '2' AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                }
            }
        })]
	});
	
    var masterGrid = Unilite.createGrid('Afb555Grid1', {
    	features: [{
			id: 'masterGridSubTotal',	
			ftype: 'uniGroupingsummary',	
			showSummaryRow: false
		},{
			id: 'masterGridTotal',		
			ftype: 'uniSummary',			
			showSummaryRow: true
		}],
    	layout : 'fit',
        region : 'center',
		store: masterStore,
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: false,
			useRowContext 		: false,
			expandLastColumn	: true,
			onLoadSelectFirst 	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true
		},
		selModel:'rowmodel',
        columns:
        [
            {dataIndex: 'AC_GUBUN'       , width: 100,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
                }
            },       
            {dataIndex: 'BUDG_CODE'      , width: 200,
                renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    return (val.substring(0, 3) + '-' + val.substring(3, 7) + '-' + 
                            val.substring(7, 11) + '-' + val.substring(11, 14) + '-' + 
                            val.substring(14, 17) + '-' + val.substring(17, 19));
                }
            },         
            {dataIndex: 'BUDG_NAME_1'    , width: 150},         
            {dataIndex: 'BUDG_NAME_4'    , width: 150},         
            {dataIndex: 'BUDG_NAME_6'    , width: 150},         
            {dataIndex: 'BUDG_I'         , width: 150},         
            {dataIndex: 'RESULT'         , width: 150},         
            {dataIndex: 'DOC_NO'         , width: 150},         
            {dataIndex: 'TITLE'          , width: 200},         
            {dataIndex: 'PAY_DATE'       , width: 100},         
            {dataIndex: 'TOT_AMT_I'      , width: 150,summaryType:'sum'},      
            {dataIndex: 'PAY_DIVI'       , width: 100},        
            {dataIndex: 'CUSTOM_NAME'    , width: 200},        
            {dataIndex: 'CONTRACT_GUBUN' , width: 100}  
            
        ]
/*            
        listeners: {
        	itemmouseenter:function(view, record, item, index, e, eOpts )	{ 
        		view.ownerGrid.setCellPointer(view, item);
//        		if(UniUtils.indexOf(e.field, ['DRAFT_NO', 'DRAFT_TITLE', 'DRAFT_DATE', 'DRAFT_AMT', 'CLOSE_YN'])) {
//        			view.ownerGrid.setCellPointer(view, item);
//        		} else if(UniUtils.indexOf(e.field, ['PAY_DRAFT_NO', 'PAY_TITLE', 'SLIP_DATE', 'PAY_AMT'])) {
//        			view.ownerGrid.setCellPointer(view, item);
//        		}
        	}
        },
		onItemcontextmenu:function( menu, grid, record, item, index, event, e, eOpts )	{          		
//      		if(UniUtils.indexOf(e.field, ['DRAFT_NO', 'DRAFT_TITLE', 'DRAFT_DATE', 'DRAFT_AMT', 'CLOSE_YN'])) {
//    			menu.down('#linkAfb700ukr').hide();
//    			menu.down('#linkAfb600ukr').show();
//    		} else if(UniUtils.indexOf(field, ['PAY_DRAFT_NO', 'PAY_TITLE', 'SLIP_DATE', 'PAY_AMT'])) {
//    			menu.down('#linkAfb600ukr').hide();
//    			menu.down('#linkAfb700ukr').show();
//    		}
			if(record.get('BUDG_TYPE') == '1') {
				menu.down('#linkAfb600ukr').hide();
				menu.down('#linkAfb700ukr').hide();
				menu.down('#linkAfb800ukr').show();
			} else {
				menu.down('#linkAfb600ukr').show();
				menu.down('#linkAfb700ukr').show();
				menu.down('#linkAfb800ukr').hide();
			}
        	return true;
      	},
        uniRowContextMenu:{
			items: [
	            {	text: '예산기안(추산)등록 보기',   
	            	itemId	: 'linkAfb600ukr',
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAfb600(param.record);
	            	}
	        	},{	text: '지출결의등록 이동',   
	            	itemId	: 'linkAfb700ukr',
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAfb700(param.record);
	            	}
	        	},{	text: '수입결의등록 이동',   
	            	itemId	: 'linkAfb800ukr',
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAfb800(param.record);
	            	}
	        	}
	        ]
	    },
		gotoAfb600:function(record)	{
			if(record)	{
		    	var params = {
					action:'select',
					'PGM_ID'			: 's_afb555skr_KOCIS',
					'DRAFT_NO' 			: record.data['DRAFT_NO']
				}
		  		var rec1 = {data : {prgID : 'afb600ukr', 'text':''}};							
				parent.openTab(rec1, '/accnt/afb600ukr.do', params);
			}
    	},
		gotoAfb700:function(record)	{
			if(record)	{
		    	var params = {
					action:'select',
					'PGM_ID'			: 's_afb555skr_KOCIS',
					'PAY_DRAFT_NO' 		: record.data['PAY_DRAFT_NO']
				}
		  		var rec1 = {data : {prgID : 'afb700ukr', 'text':''}};							
				parent.openTab(rec1, '/accnt/afb700ukr.do', params);
			}
    	},
		gotoAfb800:function(record)	{
			if(record)	{
		    	var params = {
					action:'select',
					'PGM_ID'			: 's_afb555skr_KOCIS',
					'DRAFT_DATE' 		: record.data['DRAFT_DATE'],
					'DRAFT_NO' 			: record.data['DRAFT_NO'],
					'TITLE' 			: record.data['DRAFT_TITLE'],
					'STATUS' 			: record.data['DRAFT_TITLE']
				}
		  		var rec1 = {data : {prgID : 'afb800ukr', 'text':''}};							
				parent.openTab(rec1, '/accnt/afb800ukr.do', params);
			}
    	}*/
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
		id : 'Afb555App',
		fnInitBinding : function(params) {
	/*		var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_MONTH');
			var param= Ext.getCmp('searchForm').getValues();
			panelSearch.setValue('ST_DATE',getStDt[0].STDT.substring(0, 4));
			panelSearch.setValue('FR_MONTH', UniDate.get('startOfYear'));
			panelResult.setValue('FR_MONTH', UniDate.get('startOfYear'));
			panelSearch.setValue('TO_MONTH', UniDate.get('endOfMonth'));
			panelResult.setValue('TO_MONTH', UniDate.get('endOfMonth'));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			param.budgNameInfoList = budgNameList;	//예산목록
			if(!Ext.isEmpty(params && params.PGM_ID)){
				this.processParams(params);
			}*/
			
			
            UniAppManager.app.fnInitInputFields(); 
			
		},
		onQueryButtonDown : function()	{	
            if(!panelResult.getInvalidMessage()) return;   //필수체크
                masterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
            panelSearch.clearForm();
            panelResult.clearForm();
            masterGrid.reset();
            masterStore.clearData();
            this.fnInitInputFields();
        },
        
        
       /* 
        
        //링크로 넘어오는 params 받는 부분 (Agj100skr)
        processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'afb540skr') {
				panelSearch.setValue('FR_YYYYMM',params.FR_YYYYMM);
				panelSearch.setValue('TO_YYYYMM',params.TO_YYYYMM);
				panelSearch.setValue('BUDG_CODE',params.BUDG_CODE);
				panelSearch.setValue('BUDG_NAME',params.BUDG_NAME);
				panelSearch.setValue('DEPT_CODE',params.DEPT_CODE);
				panelSearch.setValue('DEPT_NAME',params.DEPT_NAME);
				panelSearch.setValue('BUDG_TYPE',params.BUDG_TYPE);
				panelSearch.setValue('RDO',params.RDO);
				panelSearch.setValue('MONEY_UNIT',params.MONEY_UNIT);
				panelSearch.setValue('AC_PROJECT_CODE',params.AC_PROJECT_CODE);
				panelSearch.setValue('AC_PROJECT_NAME',params.AC_PROJECT_NAME);
				panelResult.setValue('FR_YYYYMM',params.FR_YYYYMM);
				panelResult.setValue('TO_YYYYMM',params.TO_YYYYMM);
				panelResult.setValue('BUDG_CODE',params.BUDG_CODE);
				panelResult.setValue('BUDG_NAME',params.BUDG_NAME);
				panelResult.setValue('DEPT_CODE',params.DEPT_CODE);
				panelResult.setValue('DEPT_NAME',params.DEPT_NAME);
				panelResult.setValue('BUDG_TYPE',params.BUDG_TYPE);
				panelResult.setValue('RDO',params.RDO);
				panelResult.setValue('MONEY_UNIT',params.MONEY_UNIT);
				panelResult.setValue('AC_PROJECT_CODE',params.AC_PROJECT_CODE);
				panelResult.setValue('AC_PROJECT_NAME',params.AC_PROJECT_NAME);
				
			}
			masterStore.loadStoreRecords();
        },
        
        */
        
        
        fnInitInputFields: function(){
            var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch) {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
//            activeSForm.onLoadSelectText('FR_AC_DATE');
            
            panelSearch.setValue('AC_YEAR',new Date().getFullYear());
            panelResult.setValue('AC_YEAR',new Date().getFullYear());
            
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
