<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_afb510skr_KOCIS"  >
	<t:ExtComboStore comboType="AU" comboCode="A132" /> <!-- 수지구분 -->
    <t:ExtComboStore comboType="AU" comboCode="B042" /> <!-- 금액단위 -->
    <t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A170" opts='1;2'/> <!-- 이월/불용승인 구분 (예산구분) -->
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	
	Unilite.defineModel('Afb510Model1', {
		fields: [  
			{name: 'COMP_CODE'					, text: '법인코드'				, type: 'string'},
            {name: 'ACCT_NAME'                  , text: '계좌'                , type: 'string'},
			{name: 'DEPT_CODE'					, text: '기관코드'		        , type: 'string'},
			{name: 'DEPT_NAME'					, text: '기관'				, type: 'string'},
			{name: 'BUDG_CODE'                  , text: '예산과목'             , type: 'string'},
            {name: 'BUDG_NAME_1'                , text: '부문'               , type: 'string'},
            {name: 'BUDG_NAME_4'                , text: '세부사업'            , type: 'string'},
            {name: 'BUDG_NAME_6'                , text: '세목'               , type: 'string'},
			{name: 'BUDG_I'						, text: '연간예산'				, type: 'uniPrice'},
			{name: 'ACT_I'						, text: '연간집행'				, type: 'uniPrice'},
			{name: 'BAL_I'						, text: '잔액'				, type: 'uniPrice'},
			{name: 'ACT_I01'					, text: '1월 실적'				, type: 'uniPrice'},
			{name: 'ACT_I02'					, text: '2월 실적'				, type: 'uniPrice'},
			{name: 'ACT_I03'					, text: '3월 실적'				, type: 'uniPrice'},
			{name: 'ACT_I04'					, text: '4월 실적'				, type: 'uniPrice'},
			{name: 'ACT_I05'					, text: '5월 실적'				, type: 'uniPrice'},
			{name: 'ACT_I06'					, text: '6월 실적'				, type: 'uniPrice'},
			{name: 'ACT_I07'					, text: '7월 실적'				, type: 'uniPrice'},
			{name: 'ACT_I08'					, text: '8월 실적'				, type: 'uniPrice'},
			{name: 'ACT_I09'					, text: '9월 실적'				, type: 'uniPrice'},
			{name: 'ACT_I10'					, text: '10월 실적'			, type: 'uniPrice'},
			{name: 'ACT_I11'					, text: '11월 실적'			, type: 'uniPrice'},
			{name: 'ACT_I12'					, text: '12월 실적'			, type: 'uniPrice'},
            {name: 'ACT_I13'                    , text: '13월 실적'            , type: 'uniPrice'}
	    ]
	});	
	
	var masterStore = Unilite.createStore('Afb510masterStore',{
		model: 'Afb510Model1',
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
                read: 's_afb510skrService_KOCIS.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			this.load({
				params : param
			});
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
                xtype: 'uniCombobox',
                name: 'BUDG_TYPE',
                comboType:'AU',
                comboCode:'A132',
                value: '2',
                fieldLabel: '수지구분',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('BUDG_TYPE', newValue);
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
            Unilite.popup('BUDG_KOCIS_NORMAL',{
                fieldLabel: '예산과목',
                valueFieldName:'BUDG_CODE_FR',
                textFieldName:'BUDG_NAME_FR',
                //validateBlank:false,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_CODE_FR', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_NAME_FR', newValue);                
                    },
                    applyextparam: function(popup) {
                        popup.setExtParam({'AC_YYYY': panelResult.getValue("AC_YEAR")}),
                        popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                        popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = "+ "'" + panelResult.getValue('BUDG_TYPE')+ "'" + " AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                    }
                }
            }),
            Unilite.popup('BUDG_KOCIS_NORMAL',{
                fieldLabel: '~',
                valueFieldName:'BUDG_CODE_TO',
                textFieldName:'BUDG_NAME_TO',
                //validateBlank:false,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_CODE_TO', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('BUDG_NAME_TO', newValue);                
                    },
                    applyextparam: function(popup) {
                        popup.setExtParam({'AC_YYYY': panelResult.getValue("AC_YEAR")}),
                        popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                        popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = "+ "'" + panelResult.getValue('BUDG_TYPE')+ "'" + " AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                    }
                }
            }),{
                xtype: 'uniCombobox',
                fieldLabel: '예산실적집계',
                name: 'BUDG_GUBUN',
                comboType: 'AU',
                comboCode: 'A170',
                multiSelect: true,
                typeAhead: false,
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('BUDG_GUBUN', newValue);
                    }
                }
            }
            /*{
            	
                xtype: 'uniCheckboxgroup',  
                fieldLabel: '예산실적집계',
                items: [{
                    boxLabel: '본예산',
                    width: 60,
                    name: 'BUDG_GUBUN1',
                    inputValue: '1',
                    uncheckedValue: '0',
                    checked: true,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('BUDG_GUBUN1', newValue);
                        }
                    }
                },{
                    boxLabel: '이월예산',
                    width: 75,
                    name: 'BUDG_GUBUN2',
                    inputValue: '2',
                    uncheckedValue: '0',
                    checked: true,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('BUDG_GUBUN2', newValue);
                        }
                    }
                },{
                    boxLabel: '불용승인',
                    width: 80,
                    name: 'BUDG_GUBUN3',
                    inputValue: '3',
                    uncheckedValue: '0',
                    checked: true,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('BUDG_GUBUN3', newValue);
                        }
                    }
                }]
            }*/]	
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
            xtype: 'uniCombobox',
            name: 'BUDG_TYPE',
            comboType:'AU',
            comboCode:'A132',
            value: '2',
            fieldLabel: '수지구분',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('BUDG_TYPE', newValue);
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
        Unilite.popup('BUDG_KOCIS_NORMAL',{
            fieldLabel: '예산과목',
            valueFieldName:'BUDG_CODE_FR',
            textFieldName:'BUDG_NAME_FR',
            //validateBlank:false,
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_CODE_FR', newValue);                                
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_NAME_FR', newValue);                
                },
                applyextparam: function(popup) {
                    popup.setExtParam({'AC_YYYY': panelResult.getValue("AC_YEAR")}),
                    popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                    popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = "+ "'" + panelResult.getValue('BUDG_TYPE')+ "'" + " AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                }
            }
        }),
        Unilite.popup('BUDG_KOCIS_NORMAL',{
            fieldLabel: '~',
            valueFieldName:'BUDG_CODE_TO',
            textFieldName:'BUDG_NAME_TO',
            labelWidth:15,
            //validateBlank:false,
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_CODE_TO', newValue);                                
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('BUDG_NAME_TO', newValue);                
                },
                applyextparam: function(popup) {
                    popup.setExtParam({'AC_YYYY': panelResult.getValue("AC_YEAR")}),
                    popup.setExtParam({'DEPT_CODE' : panelResult.getValue('DEPT_CODE')}),
                    popup.setExtParam({'ADD_QUERY' : "B.BUDG_TYPE = "+ "'" + panelResult.getValue('BUDG_TYPE')+ "'" + " AND B.GROUP_YN = 'N' AND A.USE_YN = 'Y'"})
                }
            }
        }),
        {
            xtype: 'uniCombobox',
            fieldLabel: '예산실적집계',
            name: 'BUDG_GUBUN',
            comboType: 'AU',
            comboCode: 'A170',
            multiSelect: true,
            typeAhead: false,
            allowBlank: false,
            width:300,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('BUDG_GUBUN', newValue);
                }
            }
        }
        /*{
    		xtype: 'uniCheckboxgroup',	
    		fieldLabel: '예산실적집계',
    		items: [{
    			boxLabel: '본예산',
    			width: 60,
    			name: 'BUDG_GUBUN1',
	        	inputValue: '1',
				uncheckedValue: '0',
				checked: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('BUDG_GUBUN1', newValue);
					}
				}
    		},{
    			boxLabel: '이월예산',
    			width: 75,
    			name: 'BUDG_GUBUN2',
	        	inputValue: '2',
				uncheckedValue: '0',
				checked: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('BUDG_GUBUN2', newValue);
					}
				}
    		},{
                boxLabel: '불용승인',
                width: 80,
                name: 'BUDG_GUBUN3',
                inputValue: '3',
                uncheckedValue: '0',
                checked: true,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('BUDG_GUBUN3', newValue);
                    }
                }
    		}]
        }*/]
	});
    var masterGrid = Unilite.createGrid('Afb510Grid1', {
    	features: [{
    			id: 'masterGridSubTotal',	
    			ftype: 'uniGroupingsummary',	
    			showSummaryRow: false
    		},{
    			id: 'masterGridTotal',		
    			ftype: 'uniSummary',			
    			showSummaryRow: false
    		}
    	],
    	layout : 'fit',
        region : 'center',
		store: masterStore,
		uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: false,
			useRowContext 		: false,
			expandLastColumn	: false,
			onLoadSelectFirst 	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false
		},
        selModel:'rowmodel',
        columns: [
            {dataIndex: 'COMP_CODE'	                          , width: 120,hidden:true},
            {dataIndex: 'ACCT_NAME'                           , width: 120},
            
            {dataIndex: 'DEPT_CODE'	                          , width: 120,hidden:true},
            {dataIndex: 'DEPT_NAME'	                          , width: 120},
            {dataIndex: 'BUDG_CODE'	                          , width: 170,
                renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    return (val.substring(0, 3) + '-' + val.substring(3, 7) + '-' + 
                            val.substring(7, 11) + '-' + val.substring(11, 14) + '-' + 
                            val.substring(14, 17) + '-' + val.substring(17, 19));
                }
            },
            {dataIndex: 'BUDG_NAME_1'           , width: 150},   
            {dataIndex: 'BUDG_NAME_4'           , width: 150},   
            {dataIndex: 'BUDG_NAME_6'           , width: 150},
            
            {dataIndex: 'BUDG_I'		                      , width: 120},
            {dataIndex: 'ACT_I'		                          , width: 120},
            {dataIndex: 'BAL_I'		                          , width: 120},
            {dataIndex: 'ACT_I01'	                          , width: 120},
            {dataIndex: 'ACT_I02'	                          , width: 120},
            {dataIndex: 'ACT_I03'	                          , width: 120},
            {dataIndex: 'ACT_I04'	                          , width: 120},
            {dataIndex: 'ACT_I05'	                          , width: 120},
            {dataIndex: 'ACT_I06'	                          , width: 120},
            {dataIndex: 'ACT_I07'	                          , width: 120},
            {dataIndex: 'ACT_I08'	                          , width: 120},
            {dataIndex: 'ACT_I09'	                          , width: 120},
            {dataIndex: 'ACT_I10'	                          , width: 120},
            {dataIndex: 'ACT_I11'	                          , width: 120},
            {dataIndex: 'ACT_I12'	                          , width: 120},
            {dataIndex: 'ACT_I13'                             , width: 120}
            
        ]
        /*listeners: {
        	itemmouseenter:function(view, record, item, index, e, eOpts, column )	{  
        		if(column, ['ACT_I01','ACT_I02','ACT_I03','ACT_I04','ACT_I05','ACT_I06',
        					'ACT_I07','ACT_I08','ACT_I09','ACT_I10','ACT_I11','ACT_I12']) {
	        		view.ownerGrid.setCellPointer(view, item);
        		}
        	}
        },
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
      		return true;
      	},
        uniRowContextMenu:{
			items: [
	            {	text: '예산집행현황 보기',   
	            	handler: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAfb540(param.record);
	            	}
	        	}
	        ]
	    },
		gotoAfb540:function(grid, record, cellIndex, colName)	{
			if(record)	{
				switch(colName)	{
					case 'BUDG_I01' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 's_afb510skr_KOCIS',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '01',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '01',
							'BUDG_CODE'			: record.data['BUDG_CODE'],
							'BUDG_NAME'			: record.data['BUDG_NAME'],
							'DEPT_CODE'			: record.data['DEPT_CODE'],
							'DEPT_NAME'			: record.data['DEPT_NAME'],
							'BUDG_TYPE' 		: record.data['BUDG_TYPE'],	
							'RDO' 				: Ext.getCmp('RDO_SELECT').getChecked()[0].inputValue,
							'MONEY_UNIT'		: panelSearch.getValue('MONEY_UNIT'),
							'AC_PROJECT_CODE'	: panelSearch.getValue('AC_PROJECT_CODE'),
							'AC_PROJECT_NAME'	: panelSearch.getValue('AC_PROJECT_NAME')
				    	}
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I02' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 's_afb510skr_KOCIS',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '02',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '02',
							'BUDG_CODE'			: record.data['BUDG_CODE'],
							'BUDG_NAME'			: record.data['BUDG_NAME'],
							'DEPT_CODE'			: record.data['DEPT_CODE'],
							'DEPT_NAME'			: record.data['DEPT_NAME'],
							'BUDG_TYPE' 		: record.data['BUDG_TYPE'],	
							'RDO' 				: Ext.getCmp('RDO_SELECT').getChecked()[0].inputValue,
							'MONEY_UNIT'		: panelSearch.getValue('MONEY_UNIT'),
							'AC_PROJECT_CODE'	: panelSearch.getValue('AC_PROJECT_CODE'),
							'AC_PROJECT_NAME'	: panelSearch.getValue('AC_PROJECT_NAME')
				    	}
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I03' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 's_afb510skr_KOCIS',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '03',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '03',
							'BUDG_CODE'			: record.data['BUDG_CODE'],
							'BUDG_NAME'			: record.data['BUDG_NAME'],
							'DEPT_CODE'			: record.data['DEPT_CODE'],
							'DEPT_NAME'			: record.data['DEPT_NAME'],
							'BUDG_TYPE' 		: record.data['BUDG_TYPE'],	
							'RDO' 				: Ext.getCmp('RDO_SELECT').getChecked()[0].inputValue,
							'MONEY_UNIT'		: panelSearch.getValue('MONEY_UNIT'),
							'AC_PROJECT_CODE'	: panelSearch.getValue('AC_PROJECT_CODE'),
							'AC_PROJECT_NAME'	: panelSearch.getValue('AC_PROJECT_NAME')
				    	}
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I04' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 's_afb510skr_KOCIS',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '04',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '04',
							'BUDG_CODE'			: record.data['BUDG_CODE'],
							'BUDG_NAME'			: record.data['BUDG_NAME'],
							'DEPT_CODE'			: record.data['DEPT_CODE'],
							'DEPT_NAME'			: record.data['DEPT_NAME'],
							'BUDG_TYPE' 		: record.data['BUDG_TYPE'],	
							'RDO' 				: Ext.getCmp('RDO_SELECT').getChecked()[0].inputValue,
							'MONEY_UNIT'		: panelSearch.getValue('MONEY_UNIT'),
							'AC_PROJECT_CODE'	: panelSearch.getValue('AC_PROJECT_CODE'),
							'AC_PROJECT_NAME'	: panelSearch.getValue('AC_PROJECT_NAME')
				    	}
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I05' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 's_afb510skr_KOCIS',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '05',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '05',
							'BUDG_CODE'			: record.data['BUDG_CODE'],
							'BUDG_NAME'			: record.data['BUDG_NAME'],
							'DEPT_CODE'			: record.data['DEPT_CODE'],
							'DEPT_NAME'			: record.data['DEPT_NAME'],
							'BUDG_TYPE' 		: record.data['BUDG_TYPE'],	
							'RDO' 				: Ext.getCmp('RDO_SELECT').getChecked()[0].inputValue,
							'MONEY_UNIT'		: panelSearch.getValue('MONEY_UNIT'),
							'AC_PROJECT_CODE'	: panelSearch.getValue('AC_PROJECT_CODE'),
							'AC_PROJECT_NAME'	: panelSearch.getValue('AC_PROJECT_NAME')
				    	}
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I06' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 's_afb510skr_KOCIS',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '06',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '06',
							'BUDG_CODE'			: record.data['BUDG_CODE'],
							'BUDG_NAME'			: record.data['BUDG_NAME'],
							'DEPT_CODE'			: record.data['DEPT_CODE'],
							'DEPT_NAME'			: record.data['DEPT_NAME'],
							'BUDG_TYPE' 		: record.data['BUDG_TYPE'],	
							'RDO' 				: Ext.getCmp('RDO_SELECT').getChecked()[0].inputValue,
							'MONEY_UNIT'		: panelSearch.getValue('MONEY_UNIT'),
							'AC_PROJECT_CODE'	: panelSearch.getValue('AC_PROJECT_CODE'),
							'AC_PROJECT_NAME'	: panelSearch.getValue('AC_PROJECT_NAME')
				    	}
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I07' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 's_afb510skr_KOCIS',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '07',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '07',
							'BUDG_CODE'			: record.data['BUDG_CODE'],
							'BUDG_NAME'			: record.data['BUDG_NAME'],
							'DEPT_CODE'			: record.data['DEPT_CODE'],
							'DEPT_NAME'			: record.data['DEPT_NAME'],
							'BUDG_TYPE' 		: record.data['BUDG_TYPE'],	
							'RDO' 				: Ext.getCmp('RDO_SELECT').getChecked()[0].inputValue,
							'MONEY_UNIT'		: panelSearch.getValue('MONEY_UNIT'),
							'AC_PROJECT_CODE'	: panelSearch.getValue('AC_PROJECT_CODE'),
							'AC_PROJECT_NAME'	: panelSearch.getValue('AC_PROJECT_NAME')
				    	}
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I08' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 's_afb510skr_KOCIS',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '08',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '08',
							'BUDG_CODE'			: record.data['BUDG_CODE'],
							'BUDG_NAME'			: record.data['BUDG_NAME'],
							'DEPT_CODE'			: record.data['DEPT_CODE'],
							'DEPT_NAME'			: record.data['DEPT_NAME'],
							'BUDG_TYPE' 		: record.data['BUDG_TYPE'],	
							'RDO' 				: Ext.getCmp('RDO_SELECT').getChecked()[0].inputValue,
							'MONEY_UNIT'		: panelSearch.getValue('MONEY_UNIT'),
							'AC_PROJECT_CODE'	: panelSearch.getValue('AC_PROJECT_CODE'),
							'AC_PROJECT_NAME'	: panelSearch.getValue('AC_PROJECT_NAME')
				    	}
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I09' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 's_afb510skr_KOCIS',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '09',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '09',
							'BUDG_CODE'			: record.data['BUDG_CODE'],
							'BUDG_NAME'			: record.data['BUDG_NAME'],
							'DEPT_CODE'			: record.data['DEPT_CODE'],
							'DEPT_NAME'			: record.data['DEPT_NAME'],
							'BUDG_TYPE' 		: record.data['BUDG_TYPE'],	
							'RDO' 				: Ext.getCmp('RDO_SELECT').getChecked()[0].inputValue,
							'MONEY_UNIT'		: panelSearch.getValue('MONEY_UNIT'),
							'AC_PROJECT_CODE'	: panelSearch.getValue('AC_PROJECT_CODE'),
							'AC_PROJECT_NAME'	: panelSearch.getValue('AC_PROJECT_NAME')
				    	}
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I10' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 's_afb510skr_KOCIS',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '10',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '10',
							'BUDG_CODE'			: record.data['BUDG_CODE'],
							'BUDG_NAME'			: record.data['BUDG_NAME'],
							'DEPT_CODE'			: record.data['DEPT_CODE'],
							'DEPT_NAME'			: record.data['DEPT_NAME'],
							'BUDG_TYPE' 		: record.data['BUDG_TYPE'],	
							'RDO' 				: Ext.getCmp('RDO_SELECT').getChecked()[0].inputValue,
							'MONEY_UNIT'		: panelSearch.getValue('MONEY_UNIT'),
							'AC_PROJECT_CODE'	: panelSearch.getValue('AC_PROJECT_CODE'),
							'AC_PROJECT_NAME'	: panelSearch.getValue('AC_PROJECT_NAME')
				    	}
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I11' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 's_afb510skr_KOCIS',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '11',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '11',
							'BUDG_CODE'			: record.data['BUDG_CODE'],
							'BUDG_NAME'			: record.data['BUDG_NAME'],
							'DEPT_CODE'			: record.data['DEPT_CODE'],
							'DEPT_NAME'			: record.data['DEPT_NAME'],
							'BUDG_TYPE' 		: record.data['BUDG_TYPE'],	
							'RDO' 				: Ext.getCmp('RDO_SELECT').getChecked()[0].inputValue,
							'MONEY_UNIT'		: panelSearch.getValue('MONEY_UNIT'),
							'AC_PROJECT_CODE'	: panelSearch.getValue('AC_PROJECT_CODE'),
							'AC_PROJECT_NAME'	: panelSearch.getValue('AC_PROJECT_NAME')
				    	}
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				    	
				    case 'BUDG_I12' :
				    	var params = {
							action:'select',
							'PGM_ID'			: 's_afb510skr_KOCIS',
							'FR_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '12',
							'TO_YYYYMM'			: panelSearch.getValue('AC_YYYY') + '12',
							'BUDG_CODE'			: record.data['BUDG_CODE'],
							'BUDG_NAME'			: record.data['BUDG_NAME'],
							'DEPT_CODE'			: record.data['DEPT_CODE'],
							'DEPT_NAME'			: record.data['DEPT_NAME'],
							'BUDG_TYPE' 		: record.data['BUDG_TYPE'],	
							'RDO' 				: Ext.getCmp('RDO_SELECT').getChecked()[0].inputValue,
							'MONEY_UNIT'		: panelSearch.getValue('MONEY_UNIT'),
							'AC_PROJECT_CODE'	: panelSearch.getValue('AC_PROJECT_CODE'),
							'AC_PROJECT_NAME'	: panelSearch.getValue('AC_PROJECT_NAME')
				    	}
				  		var rec1 = {data : {prgID : 'afb540skr', 'text':''}};							
						parent.openTab(rec1, '/accnt/afb540skr.do', params);
				    	break;
				}
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
		id : 'Afb510App',
		fnInitBinding : function() {
            UniAppManager.app.fnInitInputFields(); 
           
        },
		onQueryButtonDown : function()	{
            if(!panelResult.getInvalidMessage()) return;   //필수체크
            masterStore.loadStoreRecords();
		},
        processParams: function(params) {
			this.uniOpt.appParams = params;
			if(params.PGM_ID == 'afb500skr') {
				panelSearch.setValue('AC_YYYY',params.AC_YYYY);
				panelSearch.setValue('BUDG_CODE_FR',params.BUDG_CODE);
				panelSearch.setValue('BUDG_NAME_FR',params.BUDG_NAME);
				panelSearch.setValue('BUDG_CODE_TO',params.BUDG_CODE);
				panelSearch.setValue('BUDG_NAME_TO',params.BUDG_NAME);
				panelSearch.setValue('DEPT_CODE',params.DEPT_CODE);
				panelSearch.setValue('DEPT_NAME',params.DEPT_NAME);
				panelSearch.setValue('BUDG_TYPE',params.BUDG_TYPE);
				panelSearch.setValue('RDO',params.RDO);
				panelSearch.setValue('MONEY_UNIT',params.MONEY_UNIT);
				panelSearch.setValue('AC_PROJECT_CODE',params.AC_PROJECT_CODE);	
				panelSearch.setValue('AC_PROJECT_NAME',params.AC_PROJECT_NAME);	
				panelResult.setValue('AC_YYYY',params.AC_YYYY);
				panelResult.setValue('BUDG_CODE_FR',params.BUDG_CODE);
				panelResult.setValue('BUDG_NAME_FR',params.BUDG_NAME);
				panelResult.setValue('BUDG_CODE_TO',params.BUDG_CODE);
				panelResult.setValue('BUDG_NAME_TO',params.BUDG_NAME);
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
        fnInitInputFields: function(){
            var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
//            activeSForm.onLoadSelectText('FR_AC_DATE');
            
            panelSearch.setValue('AC_YEAR', UniDate.getDbDateStr(UniDate.today()).substring(0, 4));
            panelResult.setValue('AC_YEAR', UniDate.getDbDateStr(UniDate.today()).substring(0, 4));
            
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
