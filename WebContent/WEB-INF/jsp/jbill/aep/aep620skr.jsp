<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep620skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="J631" />         <!-- 카드구분 -->
    <t:ExtComboStore comboType="AU" comboCode="J637" />         <!-- 카드사 -->
    <t:ExtComboStore comboType="AU" comboCode="J655" />         <!-- 대사상태 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('aep620skrModel', {
	    fields: [
			{name: 'COMP_NM'			, text: '회사구분'		, type: 'string'},
			{name: 'CARDCO_NM'			, text: '카드사'		, type: 'string'},
			{name: 'CARD_KIND'			, text: '카드구분'		, type: 'string'},
			{name: 'CARD_NO'			, text: '카드번호'		, type: 'string'},
			{name: 'CARD_NO_EXPOS'   	, text: '카드번호'  	, type: 'string'	, maxLength:20	, defaultValue:'***************'},
			{name: 'EMP_NM'				, text: '소유자'		, type: 'string'},
			{name: 'DEPT_NM'			, text: '부서'		, type: 'string'},
			{name: 'APPR_DATE'			, text: '사용일자'		, type: 'string'},
			{name: 'APPR_TIME'			, text: '시간'		, type: 'string'},
			{name: 'MERC_NM'			, text: '가맹점명'		, type: 'string'},
			{name: 'SETT_TOTAL'			, text: '금액'		, type: 'string'},
			{name: 'AQUI_AMT'			, text: '공급가액'		, type: 'string'},
			{name: 'AQUI_TAX'			, text: '부가세액'		, type: 'string'},
			{name: 'MCC_NM'				, text: '업종'		, type: 'string'},
			{name: 'VAT_STAT_NM'		, text: '과세유형'		, type: 'string'},
			{name: 'APPR_NO'			, text: '승인번호'		, type: 'string'},
			{name: 'INV_YYMM'			, text: '청구년월'		, type: 'string'},
			{name: 'REG_DT'				, text: '전송일시'		, type: 'string'},
			{name: 'CAL_ST_CD'			, text: '대사상태'		, type: 'string'}
			
	    ] 
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('aep620skrMasterStore1',{
		model: 'aep620skrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'aep620skrService.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var detailform = panelSearch.getForm();
        	
        	if (detailform.isValid()) {
        		var param = detailform.getValues();			
    			console.log( param );
    			this.load({
    				params : param
    			});
        	}else{
        		var invalid = panelSearch.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				    	
				if(invalid.length > 0)	{
					r = false;
					var labelText = ''
					    	
					if(Ext.isDefined(invalid.items[0]['fieldLabel']))	{
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					}else if(Ext.isDefined(invalid.items[0].ownerCt))	{
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					
					Ext.Msg.alert('확인', labelText+Msg.sMB083);
					invalid.items[0].focus();
				}
        	}
		}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
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
    			fieldLabel: '사용일자',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'apprStDate',
		        endFieldName: 'apprEdDate',
		        startDate: UniDate.get('startOfMonth'),
        		endDate: UniDate.get('today'),
				allowBlank: false,		        
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('apprStDate',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('apprEdDate',newValue);
			    	}
			    }
	        }, {
				fieldLabel: '대사상태',
				name:'CAL_ST_CD', 
				xtype: 'uniCombobox',
		        comboType:'AU',
		        comboCode: 'J655',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CAL_ST_CD', newValue);
					}
				}
			},{
				fieldLabel: '청구년월',  
				name: 'INV_YYMM',
				xtype : 'uniMonthfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('INV_YYMM', newValue);
					}
				}
			},{
				xtype: 'uniTextfield',
				fieldLabel: '카드번호',
				name: 'CARD_NO',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CARD_NO', newValue);
					}
				}
			},{
				xtype: 'uniTextfield',
				fieldLabel: '승인번호',
				name: 'APPR_NO',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('APPR_NO', newValue);
					}
				}
			}, {
				fieldLabel: '카드사',
				name:'CARDCO_CD', 
				xtype: 'uniCombobox',
		        comboType:'AU',
		        comboCode: 'J637',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CARDCO_CD', newValue);
					}
				}
			},
			Unilite.popup('Employee',{
				fieldLabel: '카드소유자',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					}
				}
			}), {
				fieldLabel: '카드구분',
				name:'CARD_TYPE', 
				xtype: 'uniCombobox',
		        comboType:'AU',
		        comboCode: 'J631',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CARD_TYPE', newValue);
					}
				}
			}]				
		}]		
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '사용일자',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'apprStDate',
	        endFieldName: 'apprEdDate',
	        startDate: UniDate.get('startOfMonth'),
    		endDate: UniDate.get('today'),
			allowBlank: false,		        
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('apprStDate',newValue);
                	}
			    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('apprEdDate',newValue);
		    	}
		    }
        }, {
			fieldLabel: '대사상태',
			name:'CAL_ST_CD', 
			xtype: 'uniCombobox',
	        comboType:'AU',
	        comboCode: 'J655',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CAL_ST_CD', newValue);
				}
			}
		},{
			fieldLabel: '청구년월',  
			name: 'INV_YYMM',
			xtype : 'uniMonthfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('INV_YYMM', newValue);
				}
			}
		},{
			xtype: 'uniTextfield',
			fieldLabel: '카드번호',
			name: 'CARD_NO',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CARD_NO', newValue);
				}
			}
		},{
			xtype: 'uniTextfield',
			fieldLabel: '승인번호',
			name: 'APPR_NO',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('APPR_NO', newValue);
				}
			}
		}, {
			fieldLabel: '카드사',
			name:'CARDCO_CD', 
			xtype: 'uniCombobox',
	        comboType:'AU',
	        comboCode: 'J637',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CARDCO_CD', newValue);
				}
			}
		},
		Unilite.popup('Employee',{
			fieldLabel: '카드소유자',
		  	valueFieldName:'PERSON_NUMB',
		    textFieldName:'NAME',
			validateBlank:false,
			autoPopup:true,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);				
				}
			}
		}), {
			fieldLabel: '카드구분',
			name:'CARD_TYPE', 
			xtype: 'uniCombobox',
	        comboType:'AU',
	        comboCode: 'J631',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CARD_TYPE', newValue);
				}
			}
		}]	
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('aep620skrGrid1', {
    	layout : 'fit',
        region : 'center',
        store : directMasterStore, 
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
           			{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
		store: directMasterStore,
        columns: [
        	{dataIndex: 'COMP_NM'			, width: 100},
        	{dataIndex: 'CARDCO_NM'			, width: 100},
        	{dataIndex: 'CARD_KIND'			, width: 100},
        	{dataIndex: 'CARD_NO'			, width: 100	,hidden:true},
        	{dataIndex: 'CARD_NO_EXPOS'    	, width: 120  , align:'center'},
        	{dataIndex: 'EMP_NM'			, width: 100},
        	{dataIndex: 'DEPT_NM'			, width: 100},
        	{dataIndex: 'APPR_DATE'			, width: 100},
        	{dataIndex: 'APPR_TIME'			, width: 100},
        	{dataIndex: 'MERC_NM'			, width: 100},
        	{dataIndex: 'SETT_TOTAL'		, width: 100},
        	{dataIndex: 'AQUI_AMT'			, width: 100},
        	{dataIndex: 'AQUI_TAX'			, width: 100},
        	{dataIndex: 'MCC_NM'			, width: 100},
        	{dataIndex: 'VAT_STAT_NM'			, width: 100},
        	{dataIndex: 'APPR_NO'			, width: 100},
        	{dataIndex: 'INV_YYMM'			, width: 100},
        	{dataIndex: 'REG_DT'			, width: 100},
        	{dataIndex: 'CAL_ST_CD'			, width: 100}        	
		],
        listeners:{
            onGridDblClick:function(grid, record, cellIndex, colName, td)	{
				if(colName =="CARD_NO_EXPOS") {
                	grid.ownerGrid.openCryptCardNoPopup(record);      
				}	
			}
            /*cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
                if(record.get('INPUT_PATH') == '79'){
                    Ext.getCmp("linkPayInDtlBtn").enable(true);
                    linkPgmId = linkId[0].IN_ID
                }else if(record.get('INPUT_PATH') == '80'){
                    Ext.getCmp("linkPayInDtlBtn").enable(true);
                    linkPgmId = linkId[0].PAY_ID
                }else{
                    Ext.getCmp("linkPayInDtlBtn").disable(true);
                }
            }*/
        },
		openCryptCardNoPopup:function( record )	{
			if(record)	{
				var params = {'CRDT_FULL_NUM': record.get('CARD_NO'), 'GUBUN_FLAG': '1', 'INPUT_YN': 'Y'}
				Unilite.popupCipherComm('grid', record, 'CARD_NO_EXPOS', 'CARD_NO', params);
			}
				
		}			
    });                          
    
	 Unilite.Main( {
	 	border: false,
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
		id : 'aep620skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('apprStDate');
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			directMasterStore.loadStoreRecords();
		}
	});
};
</script>
