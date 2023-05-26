<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx115skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 					<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A014" />			<!-- 승인상태 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" />			<!-- 영업담당자 -->
	<t:ExtComboStore comboType="AU" comboCode="S080" />			<!-- 응답상태코드(웹캐시) -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Atx115skrModel', {
	   fields: [
			{name: 'SEQ'					, text: '합계 FLAG'				, type: 'string'},
			{name: 'CUSTOM_CODE'			, text: '고객코드'					, type: 'string'},
			{name: 'CUSTOM_FULL_NAME'		, text: '고객명(전명)'				, type: 'string'},
			{name: 'CUSTOM_NAME'			, text: '고객명(약명)'				, type: 'string'},
			{name: 'BILL_DATE'				, text: '발행일'					, type: 'string'},
			{name: 'BILL_TYPE_CD'			, text: '계산서유형 HIDDEN'			, type: 'string'},
			{name: 'BILL_TYPE_NM'			, text: '계산서유형'				, type: 'string'},
			                                         	
			{name: 'PUB_NUM'				, text: '계산서번호'				, type: 'string'},
			{name: 'SALE_LOC_AMT_I'			, text: '공급가액'					, type: 'uniPrice'},
			{name: 'TAX_AMT_O'				, text: '세액'					, type: 'uniPrice'},
			{name: 'TOT_SALE_LOC_AMT'		, text: '합계'					, type: 'uniPrice'},
			{name: 'PUB_FR_DATE'			, text: '매출일(FROM)'			, type: 'uniDate'},
			                                         	
			{name: 'PUB_TO_DATE'			, text: '매출일(TO)'				, type: 'uniDate'},
			{name: 'RECEIPT_PLAN_DATE'		, text: '수금일'					, type: 'uniDate'},
			{name: 'AGENT_TYPE'				, text: '고객분류'					, type: 'string'},
			{name: 'AREA_TYPE'				, text: '지역'					, type: 'string'},
			{name: 'MANAGE_CUSTOM_CD'		, text: '집계거래처코드'				, type: 'string'},
			{name: 'MANAGE_CUSTOM_NM'		, text: '집계거래처명'				, type: 'string'},

			{name: 'PROJECT_NO'				, text: '관리번호'					, type: 'string'},
			{name: 'PJT_CODE'				, text: '프로젝트'					, type: 'string'},
			{name: 'PJT_NAME'				, text: '프로젝트명'				, type: 'string'},
			{name: 'REMARK'					, text: '비고'					, type: 'string'},
			{name: 'COMPANY_NUM1'			, text: '집계거래처 사업자번호'		, type: 'string'},

			{name: 'GUBUN'					, text: 'GUBUN'					, type: 'string'},
			{name: 'DIV_CODE'				, text: 'DIV_CODE'				, type: 'string'},
			{name: 'SORT'					, text: 'SORT'					, type: 'string'},
			{name: 'SALE_DIV_CODE'			, text: '매출사업장'				, type: 'string'		,comboType:'BOR120'},
			{name: 'DEPT_NAME'				, text: '귀속부서'					, type: 'string'},

			{name: 'BILL_SEND_YN'			, text: '발행여부'					, type: 'string'},
			{name: 'EB_NUM'					, text: '전자세금계산서번호'			, type: 'string'},
			{name: 'BILL_FLAG'				, text: '계산서 유형'				, type: 'string'},
			{name: 'BILL_PUBLISH_TYPE'		, text: '계산서 구분'				, type: 'string'},
			{name: 'MODI_REASON'			, text: '수정사유'					, type: 'string'},
			{name: 'SALE_PRSN'				, text: '영업담담자'				, type: 'string'},
			{name: 'BEFORE_PUB_NUM'			, text: '수정전계산서번호'			, type: 'string'},
			{name: 'ORIGINAL_PUB_NUM'		, text: '원본계산서번호'				, type: 'string'},
			{name: 'PLUS_MINUS_TYPE'		, text: '계산서타입'				, type: 'string'},
			{name: 'COMPANY_NUM'			, text: '사업자번호'				, type: 'string'},
			{name: 'SERVANT_COMPANY_NUM'	, text: '종사업자번호'				, type: 'string'},
			{name: 'TOP_NAME'				, text: '대표자'					, type: 'string'},
			{name: 'ADDR'					, text: '주소'					, type: 'string'},
			{name: 'COMP_CLASS'				, text: '업종'					, type: 'string'},
			{name: 'COMP_TYPE'				, text: '업태'					, type: 'string'},
			{name: 'RECEIVE_PRSN_NAME'		, text: '받는자이름'				, type: 'string'},
			{name: 'RECEIVE_PRSN_EMAIL'		, text: '이메일'					, type: 'string'},
			{name: 'RECEIVE_PRSN_TEL'		, text: '받는자전화번호'				, type: 'string'},
			{name: 'RECEIVE_PRSN_MOBL'		, text: '받는자휴대번호'				, type: 'string'},
			
			{name: 'ISSU_ID'				, text: '국세청 일련번호'			, type: 'string'},
			{name: 'STAT_CODE'				, text: '전자세금계산서 상태'			, type: 'string'		,comboType:"AU"		, comboCode:"S080"},					//S080
			{name: 'REQ_STAT_CODE'			, text: '요청상태'					, type: 'string'		,comboType:"AU"		, comboCode:"S081"},					//S081
			{name: 'ERR_CD'					, text: '응답코드'					, type: 'string'},					//정상 : 000000
			{name: 'ERR_MSG'				, text: '응답메시지'				, type: 'string'},
			{name: 'SEND_PNAME'				, text: 'SEND_PNAME'			, type: 'string'},
			{name: 'SEND_ERR_DESC'			, text: '주소'					, type: 'string'},
			{name: 'SND_STAT'				, text: '메일전송결과'				, type: 'string'},					//(01:정상전송, 02:전송실패, 03:전송대기)
			{name: 'RCV_VIEW_YN'			, text: '수신확인여부'				, type: 'string'},					//(Y:수신확인함. N:수신확인안함.)
			{name: 'MAIL_SEQNO'				, text: '메일재전송횟수'				, type: 'string'},

			{name: 'BROK_PRSN_NAME'			, text: '수탁담당자'				, type: 'string'},					//(01:정상전송, 02:전송실패, 03:전송대기)
			{name: 'BROK_PRSN_EMAIL'		, text: '수탁담당자메일'				, type: 'string'},					//(Y:수신확인함. N:수신확인안함.)
			{name: 'BROK_PRSN_PHONE'		, text: '수탁담당자연락처'			, type: 'string'},

			{name: 'EX_DATE'				, text: '결의일자'					, type: 'uniDate'},
			{name: 'EX_NUM'					, text: '번호'					, type: 'int'	},
			{name: 'AGREE_YN'				, text: '승인여부'					, type: 'string'		,comboType:"AU"		, comboCode:"A014"},
			{name: 'SEND_NAME'				, text: '전송자'					, type: 'string'}
	    ]
	});		// End of Ext.define('Atx115skrModel', {
	  
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('atx115skrMasterStore1',{
		model	: 'Atx115skrModel',
		uniOpt	: {
            isMaster	: true,			// 상위 버튼 연결 
            editable	: false,		// 수정 모드 사용 
            deletable	: false,			// 삭제 가능 여부 
	        useNavi 	: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy	: {
           type: 'direct',
            api: {			
                read: 'atx115skrService.selectList'                	
            }
        },
		loadStoreRecords: function() {
			var param= panelSearch.getValues();		//조회폼 파라미터 수집		
			console.log( param );
			this.load({								//그리드에 Load..
				params : param,
				callback : function(records, operation, success) {
					if(success)	{	//조회후 처리할 내용
					
					}
				}
			});
		},
		listeners: {
          	load: function(store, records, successful, eOpts) {
			}          		
      	},
		_onStoreLoad: function ( store, records, successful, eOpts ) {
	    	if(this.uniOpt.isMaster) {
		    	if (records.length > 0) {
			    	UniAppManager.setToolbarButtons('save', false);
					var msg = records[0].data.COUNT + Msg.sMB001; 					//'건이 조회되었습니다.';
			    	UniAppManager.updateStatus(msg, true);	
		    	}
	    	}
	    }
	});
	
	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title		: '검색조건',
        defaultType	: 'uniSearchSubPanel',
		collapsed	: UserInfo.appOption.collapseLeftSearch,
        listeners	: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items	: [{	
			title	: '기본정보', 	
	   		itemId	: 'search_panel1',
	        layout	: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items	: [{ 
				fieldLabel	: '사업장',
				name		: 'DIV_CODE', 
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
//				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '발행일',
	            xtype		: 'uniDateRangefield',
	            startFieldName: 'DATE_FR',
	            endFieldName: 'DATE_TO',              	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('DATE_FR', newValue);						
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DATE_TO', newValue);				    		
			    	}
			    }
	     	},{
				xtype	: 'radiogroup',		            		
				fieldLabel: '소계표시여부',						            		
				id		: 'rdoSelect0_0',
				items	: [{
					boxLabel: '예', 
					width	: 50, 
					name	: 'MIN_TOTAL',
					inputValue: 'Y',
					checked	: true  
				},{
					boxLabel: '아니오', 
					width	: 100,
					name	: 'MIN_TOTAL',
					inputValue: 'N'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {			
						panelResult.getField('MIN_TOTAL').setValue(newValue.MIN_TOTAL);
						UniAppManager.app.onQueryButtonDown();
					}
				}
			},{ 
				fieldLabel	: '영업담당',
				name		: 'SALE_PRSN', 
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	:'S010',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SALE_PRSN', newValue);
					}
				}
			},
	        Unilite.popup('CUST',{
		        fieldLabel	: '고객',
				allowBlank:true,
				autoPopup:false,
				validateBlank:false,		        
			    valueFieldName:'CUSTOM_CODE',
			    textFieldName:'CUSTOM_NAME',
           		extParam	: {'CUSTOM_TYPE': ['1','3']},  
				listeners	: {
							onValueFieldChange:function( elm, newValue, oldValue) {						
								panelResult.setValue('CUSTOM_CODE', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUSTOM_NAME', '');
									panelSearch.setValue('CUSTOM_NAME', '');
								}
							},
							onTextFieldChange:function( elm, newValue, oldValue) {
								panelResult.setValue('CUSTOM_NAME', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('CUSTOM_CODE', '');
									panelSearch.setValue('CUSTOM_CODE', '');
								}
							}
				}
		    }),{
				xtype	: 'radiogroup',		            		
				fieldLabel: '자동기표여부',				            		
				id		: 'rdoSelect1-0',
				items	: [{
					boxLabel: '전체', 
					width	: 50, 
					name	: 'AUTO_YN',
					inputValue: '',
					checked: true  
				},{
					boxLabel: '기표', 
					width	: 50,
					inputValue: 'Y',
					name	: 'AUTO_YN'
				},{
					boxLabel: '미기표', 
					width	: 55,
					inputValue: 'N',
					name	: 'AUTO_YN'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {			
						panelResult.getField('AUTO_YN').setValue(newValue.AUTO_YN);
						UniAppManager.app.onQueryButtonDown();
					}
				}
			}]	
		}]
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden	: !UserInfo.appOption.collapseLeftSearch,
    	region	: 'north',
		layout	: {type : 'uniTable', columns : 3
//		tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//		tdAttrs	: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	:'1 1 1 1',
		border	: true,
		items	: [{ 
			fieldLabel	: '사업장',
			name		: 'DIV_CODE', 
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
//			allowBlank	: false,
            tdAttrs		: {width: 350},
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '발행일',
            xtype		: 'uniDateRangefield',
            startFieldName: 'DATE_FR',
            endFieldName: 'DATE_TO',
            tdAttrs		: {width: 380},               	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('DATE_FR', newValue);						
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('DATE_TO', newValue);				    		
		    	}
		    }
     	},{
			xtype		: 'radiogroup',		            		
			fieldLabel	: '소계표시여부',						            		
			id			: 'rdoSelect0_1',
            tdAttrs		: {width: 380},
			items		: [{
				boxLabel: '예', 
				width	: 50, 
				name	: 'MIN_TOTAL',
				inputValue: 'Y',
				checked	: true  
			},{
				boxLabel: '아니오', 
				width	: 100,
				name	: 'MIN_TOTAL',
				inputValue: 'N'
			}],
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {			
					panelSearch.getField('MIN_TOTAL').setValue(newValue.MIN_TOTAL);
					UniAppManager.app.onQueryButtonDown();
				}
			}
		},{ 
			fieldLabel	: '영업담당',
			name		: 'SALE_PRSN', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'S010',
            tdAttrs		: {width: 350},
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('SALE_PRSN', newValue);
				}
			}
		},
        Unilite.popup('CUST',{
	        fieldLabel	: '고객',
			allowBlank:true,
			autoPopup:false,
			validateBlank:false,	        
		    valueFieldName:'CUSTOM_CODE',
		    textFieldName:'CUSTOM_NAME',
            tdAttrs		: {width: 380},
            extParam	: {'CUSTOM_TYPE': ['1','3']},  
			listeners	: {
						onValueFieldChange:function( elm, newValue, oldValue) {						
							panelSearch.setValue('CUSTOM_CODE', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('CUSTOM_NAME', '');
								panelSearch.setValue('CUSTOM_NAME', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelSearch.setValue('CUSTOM_NAME', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('CUSTOM_CODE', '');
								panelSearch.setValue('CUSTOM_CODE', '');
							}
						}
			}
	    }),{
			xtype		: 'radiogroup',		            		
			fieldLabel	: '자동기표여부',					            		
			id			: 'rdoSelect1-1',
            tdAttrs		: {width: 380},
			items		: [{
				boxLabel: '전체', 
				width	: 50, 
				name	: 'AUTO_YN',
				inputValue: '',
				checked	: true  
			},{
				boxLabel: '기표', 
				width	: 50,
				name	: 'AUTO_YN',
				inputValue: 'Y'
			},{
				boxLabel: '미기표', 
				width	: 55,
				name	: 'AUTO_YN',
				inputValue: 'N'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {			
					panelSearch.getField('AUTO_YN').setValue(newValue.AUTO_YN);
					UniAppManager.app.onQueryButtonDown();
				}
			}
		}]
	});
	
    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('atx115skrGrid1', {
    	layout	: 'fit',
        region	: 'center',
        uniOpt	:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: true,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
		store	: directMasterStore,
    	features: [{
    		id		: 'masterGridSubTotal',
    		ftype	: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id		: 'masterGridTotal', 	
    		ftype	: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [        
        	{dataIndex: 'CUSTOM_CODE'			, width: 80}, 				
			{dataIndex: 'CUSTOM_FULL_NAME'		, width: 150}, 				
			{dataIndex: 'BILL_DATE'				, width: 100		, align:'center'}, 	
        	{dataIndex: 'STAT_CODE'				, width: 130}, 		//전자세금계산서 상태코드(S080)		
			{dataIndex: 'BILL_TYPE_NM'			, width: 120}, 				
			{dataIndex: 'PUB_NUM'				, width: 140}, 				
			{dataIndex: 'SALE_LOC_AMT_I'		, width: 120}, 				
			{dataIndex: 'TAX_AMT_O'				, width: 120}, 				
			{dataIndex: 'TOT_SALE_LOC_AMT'		, width: 120}, 				
			{dataIndex: 'PUB_FR_DATE'			, width: 100		, align:'center'		, hidden: true}, 				
			{dataIndex: 'PUB_TO_DATE'			, width: 100		, align:'center'		, hidden: true}, 				
			{dataIndex: 'REMARK'				, width: 200}, 				
			{dataIndex: 'SALE_DIV_CODE'			, width: 150},  					
			{dataIndex: 'BILL_SEND_YN'			, width: 100		, align:'center'}, 				
			{dataIndex: 'EB_NUM'				, width: 140}, 				
			{dataIndex: 'BILL_FLAG'				, width: 80			, align:'center'}, 				
			{dataIndex: 'BILL_PUBLISH_TYPE'		, width: 80			, hidden: true}, 				
			{dataIndex: 'MODI_REASON'			, width: 100}, 				
			{dataIndex: 'SALE_PRSN'				, width: 100}, 				
			{dataIndex: 'BEFORE_PUB_NUM'		, width: 140}, 				
			{dataIndex: 'ORIGINAL_PUB_NUM'		, width: 140}, 				
			{dataIndex: 'PLUS_MINUS_TYPE'		, width: 100}, 				
			{dataIndex: 'COMPANY_NUM'			, width: 100}, 				
			{dataIndex: 'SERVANT_COMPANY_NUM'	, width: 100}, 				
			{dataIndex: 'TOP_NAME'				, width: 100}, 				
			{dataIndex: 'ADDR'					, width: 250}, 				
			{dataIndex: 'COMP_CLASS'			, width: 140}, 				
			{dataIndex: 'COMP_TYPE'				, width: 140}, 				
			{dataIndex: 'RECEIVE_PRSN_NAME'		, width: 130}, 				
			{dataIndex: 'RECEIVE_PRSN_EMAIL'	, width: 200}, 				
			{dataIndex: 'RECEIVE_PRSN_TEL'		, width: 100}, 				
			{dataIndex: 'RECEIVE_PRSN_MOBL'		, width: 100}, 				
			{dataIndex: 'EX_DATE'				, width: 100}, 				
			{dataIndex: 'EX_NUM'				, width: 100}, 				
			{dataIndex: 'AGREE_YN'				, width: 100}, 						
			{dataIndex: 'DEPT_NAME'				, width: 100}, 	
			{dataIndex: 'SEND_NAME'				, width: 100}		
		],
        listeners: {
        	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	if (record.get('SEQ') == '0') {
	        		view.ownerGrid.setCellPointer(view, item);
	        	}
        	},
        	onGridDblClick :function( grid, record, cellIndex, colName ) {
        		if (record.get('SEQ') == '0') {
					masterGrid.gotoAtx110ukr(record);
                }
            }
        },
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
        	if (record.get('SEQ') == '0') {
      			return true;
        	}
      	},
        uniRowContextMenu:{
			items: [{
				text: '세금계산서등록',   
	            	itemId	: 'linkAtx110ukr',
	            	handler: function(menuItem, event) {
	            		var record = masterGrid.getSelectedRecord();
	            		masterGrid.gotoAtx110ukr(record);
	            	}
	        	}
	        ]
	    },
		gotoAtx110ukr:function(record)	{
			if(record)	{
				atx115skrService.getLinkID({}, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
	            		var param = {
							action:'select',
							'PGM_ID'			: 'atx115skr',
							'SALE_DIV_CODE'		: record.data['SALE_DIV_CODE'],
							'BILL_DATE' 		: record.data['BILL_DATE'],
							'CUSTOM_CODE'		: record.data['CUSTOM_CODE'],
							'PUB_NUM'			: record.data['PUB_NUM'],
							'DIV_CODE'			: record.data['DIV_CODE'],
							'BILL_PUBLISH_TYPE'	: record.data['BILL_PUBLISH_TYPE'],
							'BROK_PRSN_NAME'	: record.data['BROK_PRSN_NAME'],
							'BROK_PRSN_EMAIL'	: record.data['BROK_PRSN_EMAIL'],
							'BROK_PRSN_PHONE'	: record.data['BROK_PRSN_PHONE']
						};
						pgmId = provider;
//						var params = record;
				  		var rec1 = {data : {prgID : pgmId, 'text':''}};							
						parent.openTab(rec1, '/accnt/'+pgmId+'.do', param);
					}
				})
			}
    	},
    	
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	          	if(record.get('SEQ') == '1') {
					cls = 'x-change-cell_light';
				} else if(record.get('SEQ') == '2') { 
					cls = 'x-change-cell_normal';
				}  else if(record.get('SEQ') == '3') { 
					cls = 'x-change-cell_dark';
				} 
				return cls;
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
		id : 'atx115skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('DATE_TO',UniDate.get('today'));
			panelResult.setValue('DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('DATE_TO',UniDate.get('today'));
			
			UniAppManager.setToolbarButtons('reset',false);
			
			//화면 초기화 시 첫번째 필드에 포커스 가도록 설정
			var activeSForm ;	
			if(!UserInfo.appOption.collapseLeftSearch) {
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
		},

		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){			//조회전 필수값 입력 여부 체크
				return false;
			}
			directMasterStore.loadStoreRecords();
		}
	});
};


</script>
