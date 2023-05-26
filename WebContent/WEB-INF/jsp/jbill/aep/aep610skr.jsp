<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep610skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="J631" />         <!-- 카드구분 -->
	<t:ExtComboStore comboType="AU" comboCode="J637" />         <!-- 카드사 -->
	<t:ExtComboStore comboType="AU" comboCode="J655" />         <!-- 대사상태 -->
	<t:ExtComboStore comboType="AU" comboCode="J694" />         <!-- 이용내역상태 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Aep610skrModel', {
	    fields: [
			{name: 'CARD_NO'			, text: '카드번호'			, type: 'string'},
			{name: 'CARD_NO_EXPOS'   	, text: '카드번호'  		, type: 'string'	, maxLength:20	, defaultValue:'***************'},
			{name: 'EMP_NM'				, text: '소유자'			, type: 'string'},
			{name: 'APPR_DATE'			, text: '사용일자'			, type: 'uniDate'},
			//??
			{name: 'APPR_TIME'			, text: '승인시간'			, type: 'string'},
			{name: 'AQUI_TIME'			, text: '매입시간'			, type: 'string'},
			{name: 'MERC_NM'			, text: '가맹점명'			, type: 'string'},
			{name: 'AQUI_SUM'			, text: '금액'			, type: 'uniPrice'},
			{name: 'AQUI_AMT'			, text: '공급가액'			, type: 'uniPrice'},
			{name: 'AQUI_TAX'			, text: '부가세액'			, type: 'uniPrice'},
			{name: 'MCC_NM'				, text: '업종'			, type: 'string'},
			{name: 'VAT_STAT_NM'		, text: '과세유형'			, type: 'string'},
			{name: 'APPR_NO'			, text: '승인번호'			, type: 'string'},
			{name: 'MERC_ADDR'			, text: '가맹점주소'		, type: 'string'},
			{name: 'ELEC_SLIP_NO'		, text: '전표번호'			, type: 'string'},
			{name: 'GL_DATE'			, text: '회계일자'			, type: 'uniDate'},
			{name: 'SLIP_STAT'			, text: '전표상태'			, type: 'string'},
			{name: 'ACCT_CD'			, text: '계정코드'			, type: 'string'},
			//??
			{name: 'BIZ_DIV_CD'			, text: '사업코드'			, type: 'string'},
			{name: 'TAX'				, text: '공제여부'			, type: 'string'},
			{name: 'REG_ID'				, text: '작성자'			, type: 'string'},
			//??
			{name: 'EXPENSE_NM'	        , text: '처리자'			, type: 'string'},
			{name: 'AQUI_STAT'			, text: '매입상태'			, type: 'string'},
			{name: 'INV_YYMM'			, text: '청구년월'			, type: 'string'},
			{name: 'SEND_DTM'			, text: '전송일시'			, type: 'string'},
			{name: 'UL_ST_NM'			, text: '이용내역진행상태'	, type: 'string'},
			{name: 'CAL_ST_CD'			, text: '대사상태'			, type: 'string'},
			{name: 'COMP_NANE'			, text: '회사구분'			, type: 'string'},
			{name: 'CARDCO_NM'			, text: '카드사'			, type: 'string'},
			{name: 'CARD_KIND'			, text: '카드구분'			, type: 'string'},
			//??
			{name: 'DEPT_NM'			, text: '비용부서'			, type: 'string'},
			//??
			{name: 'DEPT_NAME'			, text: '인사부서'			, type: 'string'},
			//??
			{name: 'JBFLG'			    , text: '처리상태'	        , type: 'string'},
			{name: 'SLIP_DESC'			, text: '사용내역'			, type: 'string'},
			{name: 'APPR_LINE'			, text: '결재라인'			, type: 'string'}			
	    ] 
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	  
	  
	  
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('aep610skrMasterStore1',{
		model: 'Aep610skrModel',
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
                read: 'aep610skrService.selectList'                	
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
	
	
	
	/** 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        width: 370,
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
           	defaults: {labelWidth: 120},
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
				fieldLabel: '이용내역상태',
				name:'UL_ST_CD', 
				xtype: 'uniCombobox',
		        comboType:'AU',
		        comboCode: 'J694',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('UL_ST_CD', newValue);
					}
				}
			},{
				fieldLabel: '청구년월',  
				name: 'invYymm',
				xtype : 'uniMonthfield',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('invYymm', newValue);
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
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
					},
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
			},
			Unilite.popup('DEPT',{
				fieldLabel: '카드소유자 비용부서',
			  	valueFieldName:'DEPT_CODE',
			    textFieldName:'DEPT_NAME',
				validateBlank:false,
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('DEPT_CODE', '');
						panelResult.setValue('DEPT_NAME', '');
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_NAME', newValue);				
					}
				}
			}), {
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
			}]				
		}]		
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		defaults: {labelWidth: 120},
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
			fieldLabel: '이용내역상태',
			name:'UL_ST_CD', 
			xtype: 'uniCombobox',
	        comboType:'AU',
	        comboCode: 'J694',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('UL_ST_CD', newValue);
				}
			}
		},{
			fieldLabel: '청구년월',  
			name: 'invYymm',
			xtype : 'uniMonthfield',
//			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('invYymm', newValue);
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
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
						panelSearch.setValue('NAME', panelResult.getValue('NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('PERSON_NUMB', '');
					panelSearch.setValue('NAME', '');
				},
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
		},
		Unilite.popup('DEPT',{
			fieldLabel: '카드소유자 비용부서',
		  	valueFieldName:'DEPT_CODE',
		    textFieldName:'DEPT_NAME',
			validateBlank:false,
			autoPopup:true,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
						panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('DEPT_CODE', '');
					panelSearch.setValue('DEPT_NAME', '');
				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_NAME', newValue);				
				}
			}
		}), {
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
		}]	
    });
	
    
    
    /** Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('aep610skrGrid1', {
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
		//selModel:'rowmodel',
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
           			{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
		store: directMasterStore,
        columns: [
        	  {dataIndex: 'CARD_NO'	 			, width: 120  , hidden: true}  
        	, {dataIndex: 'CARD_NO_EXPOS'    	, width: 120  , align:'center'}  
        	, {dataIndex: 'EMP_NM'	 			, width: 160}        	
        	, {dataIndex: 'APPR_DATE'	 		, width: 80}        	
        	, {dataIndex: 'APPR_TIME'	 		, width: 80, align: 'center'}        	
        	, {dataIndex: 'AQUI_TIME'	 		, width: 80, align: 'center'}        	
        	, {dataIndex: 'MERC_NM'	 			, width: 160}        	
        	, {dataIndex: 'AQUI_SUM'	 		, width: 140}        	
        	, {dataIndex: 'AQUI_AMT'	 		, width: 140}        	
        	, {dataIndex: 'AQUI_TAX'	 		, width: 140}        	
        	, {dataIndex: 'MCC_NM'	 			, width: 160}        	
        	, {dataIndex: 'VAT_STAT_NM'	 		, width: 100}        	
        	, {dataIndex: 'APPR_NO'	 			, width: 80}        	
        	, {dataIndex: 'MERC_ADDR'	 		, width: 300}        	
        	, {dataIndex: 'ELEC_SLIP_NO'	 	, width: 120}        	
        	, {dataIndex: 'GL_DATE'	 			, width: 120}        	
        	, {dataIndex: 'TAX'	 				, width: 80}        	
        	, {dataIndex: 'SLIP_STAT'	 		, width: 100}        	
        	, {dataIndex: 'ACCT_CD'	 			, width: 200}        	
        	, {dataIndex: 'BIZ_DIV_CD'	 		, width: 120}        	
        	, {dataIndex: 'REG_ID'	 			, width: 200}        	
        	, {dataIndex: 'EXPENSE_NM' 	    	, width: 160}        	
        	, {dataIndex: 'AQUI_STAT'	 		, width: 120}        	
        	, {dataIndex: 'INV_YYMM'	 		, width: 80}        	
        	, {dataIndex: 'SEND_DTM'	 		, width: 150, align: 'center'}        	
        	, {dataIndex: 'UL_ST_NM'            , width: 110}        	        	
        	, {dataIndex: 'CAL_ST_CD'	 		, width: 120}        	
        	, {dataIndex: 'COMP_NANE'	 		, width: 160}        	
        	, {dataIndex: 'CARDCO_NM'	 		, width: 160}        	
        	, {dataIndex: 'CARD_KIND'	 		, width: 80}        	
        	, {dataIndex: 'DEPT_NM'	 			, width: 160}        	
        	, {dataIndex: 'DEPT_NAME'	 		, width: 160}
        	, {dataIndex: 'JBFLG'               , width: 90}
        	, {dataIndex: 'SLIP_DESC'	 		, width: 250}
        	, {dataIndex: 'APPR_LINE'           , width: 400}
		],
        listeners:{
            onGridDblClick:function(grid, record, cellIndex, colName, td)	{
				if(colName =="CARD_NO_EXPOS") {
                	grid.ownerGrid.openCryptCardNoPopup(record);      
				}	
			}	
        },
		openCryptCardNoPopup:function( record )	{
			if(record)	{
				var params = {'CRDT_FULL_NUM': record.get('CARD_NO'), 'GUBUN_FLAG': '1', 'INPUT_YN': 'Y'}
				Unilite.popupCipherComm('grid', record, 'CREDIT_NUM_EXPOS', 'CARD_NO', params);
			}
				
		}		
    });                          
    
    
    
	 Unilite.Main( {
		id : 'aep610skrApp',
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
