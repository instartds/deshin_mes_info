<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep630skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('aep630skrModel', {
	    fields: [
			{name: 'UL_NO'					, text: '이용내역번호'	, type: 'string'  },
			{name: 'CARD_NO'				, text: '카드번호(DB)'	, type: 'string'  },
			{name: 'CARD_NO_EXPOS'   		, text: '카드번호'  	,type: 'string',maxLength:20, defaultValue:'***************'},
			{name: 'NAME'					, text: '소유자'		, type: 'string'  },
			{name: 'DEPT_NAME'				, text: '부서'		, type: 'string'  },
			{name: 'APPR_DATE'				, text: '승인일자'		, type: 'uniDate' },
			{name: 'APPR_TIME'				, text: '승인시간'		, type: 'string'  },
			{name: 'APPR_NO'				, text: '승인번호'		, type: 'string'  },
			{name: 'AQUI_SUM'				, text: '금액'		, type: 'uniPrice'},
			{name: 'AQUI_AMT'				, text: '공급가액'		, type: 'uniPrice'},
			{name: 'AQUI_TAX'				, text: '부가세액'		, type: 'uniPrice'},
			{name: 'MERC_SOCNO'				, text: '사업자번호'	, type: 'string'  },
			{name: 'MERC_NM'				, text: '가맹점'		, type: 'string'  },
			{name: 'TOT_ADDR'				, text: '가맹점주소'	, type: 'string'  },
			{name: 'MCC_NM'					, text: '업종'		, type: 'string'  },
			{name: 'VAT_STAT'			    , text: '과세유형'		, type: 'string'  },
			{name: 'SETT_DATE'				, text: '청구예정일'	, type: 'uniDate' },
			{name: 'UL_ST_CD'				, text: '처리상태'		, type: 'string'  }						
	    ] 
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	  
	  
	  
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('aep630skrMasterStore1',{
		model: 'aep630skrModel',
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
                read: 'aep630skrService.selectList'                	
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
		    items: [
				Unilite.popup('Employee',{
					fieldLabel: '사용자',
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
			}),{
				xtype: 'uniTextfield',
				fieldLabel: '카드번호',
				name: 'CARD_NO',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CARD_NO', newValue);
					}
				}
			},{
    			fieldLabel: '등록일자',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'REG_DT_FROM',
		        endFieldName: 'REG_DT_TO',
		        startDate: UniDate.get('startOfMonth'),
        		endDate: UniDate.get('today'),
				allowBlank: false,		        
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('REG_DT_FROM',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('REG_DT_TO',newValue);
			    	}
			    }
	        },
			Unilite.popup('DEPT',{
				fieldLabel: '부서',
			  	valueFieldName:'DEPT_CODE',
			    textFieldName:'DEPT_NAME',
				validateBlank:false,
				autoPopup:true,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_NAME', newValue);				
					}
				}
			}),{
			   width: 110,
		       xtype: 'button',
			   text: '개인사용분 해제',	
			   tdAttrs: {align: 'left', width: 115},
			   margin: '0 0 0 95',
			   handler : function() {
				var selectedRecord = masterGrid.getSelectedRecord();
				var param = {
					'UL_NO' : selectedRecord.data.UL_NO
				}
				aep630skrService.iuaUpdate(param, function(provider, response)	{
					//success 시 조회 관련 확인필요
				});
		   }
		    }]				
		}]		
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3, tableAttrs: {width: '100%'}},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [
			Unilite.popup('Employee',{
				fieldLabel: '사용자',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
				tdAttrs: {width: 300},
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('NAME', newValue);				
					}
				}
		}),{
			xtype: 'uniTextfield',
			fieldLabel: '카드번호',
			name: 'CARD_NO',
			colspan: 2,
			tdAttrs: {width: 300},
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CARD_NO', newValue);
//					//카드번호 암호화
//					if ((!Ext.isEmpty(newValue))) {
//						var params = {
//							DECRYP_WORD  : panelResult.getValue('CARD_NO'),
//							INCDRC_GUBUN : 'INC'
//						}												
//						popupService.incryptDecryptPopup(params, function(provider, response)	{							
//							if(!Ext.isEmpty(provider)){
//								panelResult.setValue('CARD_NO_EXPOS', provider);
//							}													
//						});
//					} else {
//						panelResult.setValue('CARD_NO_EXPOS', '');
//					}
				}
			}
		},{
			fieldLabel: '등록일자',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'REG_DT_FROM',
	        endFieldName: 'REG_DT_TO',
	        startDate: UniDate.get('startOfMonth'),
    		endDate: UniDate.get('today'),
			allowBlank: false,		 
			tdAttrs: {width: 300},
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('REG_DT_FROM',newValue);
                	}
			    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('REG_DT_TO',newValue);
		    	}
		    }
        },
		Unilite.popup('DEPT',{
			fieldLabel: '부서',
		  	valueFieldName:'DEPT_CODE',
		    textFieldName:'DEPT_NAME',
			validateBlank:false,
			autoPopup:true,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_NAME', newValue);				
				}
			}
		}),{
		   width: 110,
	       xtype: 'button',
		   text: '개인사용분 해제',	
		   tdAttrs: {align: 'left', width: 115},
		   handler: function(button, eventObject) {
				var selectedRecord = masterGrid.getSelectedRecord();
				var param = {
					'UL_NO' : selectedRecord.data.UL_NO
				}
				aep630skrService.iuaUpdate(param, function(provider, response)	{
				});
		   }
	    }]	
    });
	
    
    
    /** Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('aep630skrGrid1', {
		store: directMasterStore,
    	layout : 'fit',
        region : 'center',
        store : directMasterStore, 
        uniOpt:{	
        	onLoadSelectFirst	: false,
        	expandLastColumn	: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer		: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch		: true,		//찾기 버튼 사용 여부
    		filter: {						//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
			listeners: {  
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
					
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
					
				}
			}
        }),
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
           			{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns: [
        	{dataIndex: 'CARD_NO'				, width: 100	,hidden: true},
        	{dataIndex: 'CARD_NO_EXPOS'    		, width: 120  , align:'center'},
			{dataIndex: 'NAME'					, width: 60},
			{dataIndex: 'DEPT_NAME'				, width: 100},
			{dataIndex: 'APPR_DATE'				, width: 100},
			{dataIndex: 'APPR_TIME'				, width: 80 , align:'center'},
			{dataIndex: 'APPR_NO'				, width: 80},
			{dataIndex: 'AQUI_SUM'				, width: 100},
			{dataIndex: 'AQUI_AMT'				, width: 100},
			{dataIndex: 'AQUI_TAX'				, width: 100},
			{dataIndex: 'MERC_SOCNO'			, width: 100},
			{dataIndex: 'MERC_NM'				, width: 200},
			{dataIndex: 'TOT_ADDR'				, width: 300},
			{dataIndex: 'MCC_NM'				, width: 100},
			{dataIndex: 'VAT_STAT'			    , width: 100},
			{dataIndex: 'SETT_DATE'				, width: 100},
			{dataIndex: 'UL_ST_CD'				, width: 100,hidden:true}			
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
		id : 'aep630skrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('REG_DT_FROM');
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
