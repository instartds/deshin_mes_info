<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agj400skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A178" /> <!-- 구분 -->      
	<t:ExtComboStore comboType="AU" comboCode="A177" /> <!-- 지출유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A172" /> <!--결제방법-->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->      
	<t:ExtComboStore comboType="AU" comboCode="B111" /> <!-- 거래처분류2 -->
	<t:ExtComboStore comboType="AU" comboCode="B112" /> <!--거래처분류3-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />'></script>
<script type="text/javascript" >
function appMain() {
var gsFocusFlag = false;	
var postitWindow;		// 각주팝업
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('agj400skrModel', {
		fields: [
			 {name : 'ORDER_SEQ'			, text : '순번'				, type : 'string' }
	    	,{name : 'STATUS'				, text : '상태'				, type : 'string' }
	    	,{name : 'CONFIRM_YN'			, text : '확정'				, type : 'string' }
	    	,{name : 'PAY_DRAFT_NO'			, text : '지출결의번호'			, type : 'string' }
	    	,{name : 'SEQ'					, text : '순번'				, type : 'string' }
	    	,{name : 'USE_DATE'     		, text: '사용일' 				,type: 'uniDate'}
	    	,{name : 'PAY_DATE'				, text : '지출작성일'			, type : 'uniDate' }
	    	,{name : 'PAY_SLIP_DATE'		, text : '사용일(전표일)'		, type : 'uniDate' }
	    	,{name : 'TITLE'				, text : '지출제목'			, type : 'string' }
	    	,{name : 'TOTAL_AMT_I'			, text : '금액'				, type : 'uniPrice' }
	    	,{name : 'GUBUN'				, text : '구분'				, type : 'string' }
	    	,{name : 'PAY_TYPE'				, text : '지출유형'			, type : 'string' }
	    	,{name : 'MAKE_SALE'			, text : '제조판관'			, type : 'string' }
	    	,{name : 'ACCNT'				, text : '계정코드'			, type : 'string' }
	    	,{name : 'ACCNT_NAME'			, text : '계정과목명'			, type : 'string' }
	    	,{name : 'PAY_DIVI'				, text : '결제방법'			, type : 'string' }
	    	,{name : 'PROOF_DIVI'			, text : '증빙구분'			, type : 'string' }
	    	,{name : 'QTY'					, text : '수량'				, type : 'uniQty' }
	    	,{name : 'PRICE'				, text : '수량단가'			, type : 'uniUnitPrice' }
	    	,{name : 'SUPPLY_AMT_I'			, text : '공급가액'			, type : 'uniPrice' }
	    	,{name : 'TAX_AMT_I'			, text : '세액'				, type : 'uniPrice' }
	    	,{name : 'ADD_REDUCE_AMT_I'		, text : '증가차감액'			, type : 'uniPrice' }
	    	,{name : 'TOT_AMT_I'			, text : '지급액'				, type : 'uniPrice' }
	    	,{name : 'CUSTOM_NAME'			, text : '거래처명'			, type : 'string' }
	    	,{name : 'AGENT_TYPE'			, text : '거래처분류'			, type : 'string' }
	    	,{name : 'AGENT_TYPE2'			, text : '거래처분류2'			, type : 'string' }
	    	,{name : 'AGENT_TYPE3'			, text : '거래처분류3'			, type : 'string' }
	    	,{name : 'EB_YN'				, text : '전자발행'			, type : 'string' }
	    	,{name : 'CRDT_NUM'				, text : '카드코드'			, type : 'string' }
	    	,{name : 'CRDT_NAME'			, text : '법인카드명'			, type : 'string' }
	    	,{name : 'CRDT_FULL_NUM'     	, text : '법인카드번호' 				,type: 'string',maxLength:255}
	   	    ,{name : 'CRDT_FULL_NUM_EXPOS'  , text : '법인카드번호' 				,type: 'string',maxLength:255, defaultValue:'***************'}
	    	,{name : 'APP_NUM'				, text : '현금영수증'			, type : 'string' }
	    	,{name : 'REASON_CODE'			, text : '불공제사유'			, type : 'string' }
	    	,{name : 'PAY_CUSTOM_CODE'		, text : '지급처코드'			, type : 'string' }
	    	,{name : 'PAY_CUSTOM_NAME'		, text : '지급처명'			, type : 'string' }
	    	,{name : 'SEND_DATE'			, text : '지급예정일'			, type : 'uniDate' }
	    	,{name : 'BILL_DATE'			, text : '계산서/카드승인일	'	, type : 'uniDate' }
	    	,{name : 'SAVE_CODE'			, text : '출금통장코드'			, type : 'string' }
	    	,{name : 'SAVE_NAME'			, text : '출금통장명'			, type : 'string' }
	    	,{name : 'OUT_BANKBOOK_NUM'		, text : '출금계좌'			, type : 'string' }
	    	,{name : 'PJT_NAME'				, text : '프로젝트명'			, type : 'string' }
	    	,{name : 'PAY_USER'				, text : '지출작성자'			, type : 'string' }
	    	,{name : 'DEPT_NAME'			, text : '부서명'				, type : 'string' }
	    	,{name : 'DIV_CODE'				, text : '사업장'				, type : 'string' , comboType: 'BOR120'}
	    	,{name : 'DIV_NAME'				, text : '사업장'				, type : 'string' }
	    	,{name : 'EX_DATE'				, text : '결의일자'				, type : 'uniDate' }
	    	,{name : 'EX_NUM'				, text : '번호'					, type : 'string' }
	    	,{name : 'AP_STS'				, text : '승인상태'				, type : 'string' }	  
	    	,{name : 'COMPANY_NUM'     		, text: '사업자번호' 				,type: 'string' }
	   	 	,{name : 'BOOK_CODE'     		, text: '거래처<br/>계좌코드' 				,type: 'string'}
	   	 	,{name : 'BOOK_NAME'     		, text: '거래처<br/>계좌명' 					,type: 'string'}
	   	    ,{name : 'CUST_BOOK_ACCOUNT'  	, text: '거래처<br/>계좌번호' 				,type: 'string'}
	   	 	,{name : 'BANK_NAME'     		, text: '거래처<br/>은행명' 				,type: 'string'}
	   	 	,{name : 'BANKBOOK_NAME'     	, text: '거래처<br/>예금주' 				,type: 'string'}	 
	    	,{name : 'MONEY_UNIT'			, text:'화폐단위'			,type : 'string',  comboType:'AU',comboCode:'B004'}
			,{name : 'EXCHG_RATE_O'			, text:'환율'				,type : 'uniER'}
			,{name : 'FOR_AMT_I'			, text:'외화금액'			,type : 'uniFC'}
		]
	});
	

	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('agj400skrDetailStore',{
		model: 'agj400skrModel',
		uniOpt : {
        	isMaster	:	true,			// 상위 버튼 연결 
        	editable	:	false,			// 수정 모드 사용 
        	deletable	:	false,			// 삭제 가능 여부 
            useNavi		:	false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
            	   read: 'agj400skrService.selectList'                	
            }
        },
        loadStoreRecords : function()	{
			var form = Ext.getCmp('searchForm');
			var param= form.getValues();			
			console.log( param );
			if(form.isValid())	{
				this.load({
					params : param
				});
			}
		}
	});
	
	/* 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
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
		    items : [
		    	Unilite.popup('ACCNT_PRSN',{
			    	fieldLabel: '지출작성자',
			    	validateBlank:true,
			        autoPopup:true,
			    	valueFieldName:'DRAFTER',
				    textFieldName:'NAME',
				    listeners: {
				    	onValueFieldChange: function(field, newValue){
							panelResult.setValue('DRAFTER', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('NAME', newValue);				
						}
					}
			    }),{
			        fieldLabel: '결제방법',
				    name:'PAY_DIVI', 
				    xtype: 'uniCombobox',
				    comboType: 'AU', 
				    comboCode: 'A172',
				    width: 325,
				    listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelResult.setValue('PAY_DIVI', newValue);
						}
					}
			    },{ 
	    			fieldLabel: '지출작성일',
			        xtype: 'uniDateRangefield',
			        startFieldName: 'PAY_DATE_FR',
			        endFieldName: 'PAY_DATE_TO',
			        width: 470,
			        startDate: UniDate.get('today'),
			        endDate: UniDate.get('today'),
			        allowBlank: false,
			        colspan: 2, 
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
							panelResult.setValue('PAY_DATE_FR',newValue);
				    	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('PAY_DATE_TO',newValue);
				    	}
				    }
		        }, { 
	    			fieldLabel: '지출제목',
			        xtype: 'uniTextfield',
			        name: 'TITLE',
			        width: 325,
			        listeners: {
					change: function(field, newValue, oldValue, eOpts) {   
							panelResult.setValue('TITLE',newValue);
	                	}
				    }				   
		        },{ 
	    			fieldLabel: '지출사용일',
			        xtype: 'uniDateRangefield',
			        startFieldName: 'PAY_SLIP_DATE_FR',
			        endFieldName: 'PAY_SLIP_DATE_TO',
			        width: 470,
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
							panelResult.setValue('PAY_SLIP_DATE_FR',newValue);
				    	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('PAY_SLIP_DATE_TO',newValue);
				    	}
				    }
		        },{
			        fieldLabel: '사업장',
				    name:'DIV_CODE', 
				    xtype: 'uniCombobox',
				    comboType: 'BOR120', 
				    multiSelect: true, 
					typeAhead: false,
					value:UserInfo.divCode,
				    width: 325,
				    listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
			    },Unilite.popup('DEPT',{
			        validateBlank:true,
			        autoPopup:true,
				    valueFieldName:'DEPT_CODE',
				    textFieldName:'DEPT_NAME',
		        	listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('DEPT_CODE', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('DEPT_NAME', newValue);				
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			    }), Unilite.popup('USER',{
			    	fieldLabel: '사용자',
			    	validateBlank:true,
			        autoPopup:true,
			        valueFieldName:'PAY_USER',
					textFieldName:'USER_NAME',
					DBvalueFieldName: 'USER_ID',
					DBtextFieldName: 'USER_NAME',
				    listeners: {
				    	onSelected: {
							fn: function(records, type) {
								panelResult.setValue('PAY_USER', panelResult.getValue('USER_ID'));
								panelResult.setValue('USER_NAME', panelResult.getValue('USER_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('PAY_USER', '');
							panelResult.setValue('USER_NAME', '');
						},
				    	onValueFieldChange: function(field, newValue){
							panelResult.setValue('PAY_USER', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('USER_NAME', newValue);				
						}
					}
			    }),Unilite.popup('CUST',{
			        fieldLabel: '거래처',
			        allowBlank:true,
					autoPopup:false,
					validateBlank:false,
				    valueFieldName:'CUSTOM_CODE',
				    textFieldName:'CUSTOM_NAME',
		        	listeners: {
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
						},						
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}		        
			    }),Unilite.popup('AC_PROJECT',{
			    	fieldLabel: '프로젝트',
			        autoPopup:true,
			        valueFieldName:'PJT_CODE',
					textFieldName:'PJT_NAME',
					DBvalueFieldName: 'AC_PROJECT_CODE',
					DBtextFieldName: 'AC_PROJECT_NAME',
		        	listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('PJT_CODE', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('PJT_NAME', newValue);				
						}
					}		        
			    }),{
			        fieldLabel: '지출유형',
				    name:'PAY_TYPE', 
				    xtype: 'uniCombobox',
				    comboType: 'AU', 
				    comboCode: 'A177',
				    width: 325,
				    listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelResult.setValue('PAY_TYPE', newValue);
						}
					}
			    },{ 
		    		fieldLabel: '지출결의번호',
				    xtype: 'uniTextfield',
				    name: 'PAY_DRAFT_NO',
				    width: 325,
				    listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelResult.setValue('PAY_DRAFT_NO', newValue);
				      	}
					}
				},{
			        fieldLabel: '거래처분류',
				    name:'AGENT_TYPE', 
				    xtype: 'uniCombobox',
				    comboType: 'AU', 
				    comboCode: 'B055',
				    width: 325,
				    listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelResult.setValue('AGENT_TYPE', newValue);
						}
					}
			    },{
			        fieldLabel: '구분',
				    name:'GUBUN', 
				    xtype: 'uniCombobox',
				    comboType: 'AU', 
				    comboCode: 'A178',
				    width: 325,
				    listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelResult.setValue('GUBUN', newValue);
						}
					}
			    }]
			}]
	}); 
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {		
		region: 'north',
		layout : {type : 'uniTable', columns : 2
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items : [
			Unilite.popup('ACCNT_PRSN',{
		    	fieldLabel: '지출작성자',
		    	validateBlank:true,
		        autoPopup:true,
		    	valueFieldName:'DRAFTER',
			    textFieldName:'NAME',
			    listeners: {
			    	onValueFieldChange: function(field, newValue){
			    		panelSearch.setValue('DRAFTER', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('NAME', newValue);				
					}
				}
		    }),{
		        fieldLabel: '결제방법',
			    name:'PAY_DIVI', 
			    xtype: 'uniCombobox',
			    comboType: 'AU', 
			    comboCode: 'A172',
			    width: 325,
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelSearch.setValue('PAY_DIVI', newValue);
					}
				}
		    },{ 
				fieldLabel: '지출작성일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'PAY_DATE_FR',
		        endFieldName: 'PAY_DATE_TO',
		        width: 470,
		        startDate: UniDate.get('today'),
		        endDate: UniDate.get('today'),
		        allowBlank: false,

	            pickerWidth : 386,
	            pickerHeight : 220,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('PAY_DATE_FR',newValue);
			    	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('PAY_DATE_TO',newValue);
			    	}
			    }
	        }, { 
				fieldLabel: '지출제목',
		        xtype: 'uniTextfield',
		        name: 'TITLE',
		        width: 325,
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {   
	            		panelSearch.setValue('TITLE',newValue);
	                }
		        }
	        },{ 
				fieldLabel: '지출사용일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'PAY_SLIP_DATE_FR',
		        endFieldName: 'PAY_SLIP_DATE_TO',
		        width: 470,
		        colspan: 2, 
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('PAY_SLIP_DATE_FR',newValue);
			    	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('PAY_SLIP_DATE_TO',newValue);
			    	}
			    }
        	},{
		        fieldLabel: '사업장',
			    name:'DIV_CODE', 
			    xtype: 'uniCombobox',
			    comboType: 'BOR120', 
			    multiSelect: true, 
				typeAhead: false,
				value:UserInfo.divCode,
			    width: 325,
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
		    },Unilite.popup('DEPT',{
		        validateBlank:true,
		        autoPopup:true,
			    valueFieldName:'DEPT_CODE',
			    textFieldName:'DEPT_NAME',
		        colspan: 2, 
	        	listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('DEPT_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('DEPT_NAME', newValue);				
					},
					applyextparam: function(popup){							
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
		    }), Unilite.popup('USER',{
		    	fieldLabel: '사용자',
		    	validateBlank:true,
		        autoPopup:true,
		        valueFieldName:'PAY_USER',
				textFieldName:'USER_NAME',
				DBvalueFieldName: 'USER_ID',
				DBtextFieldName: 'USER_NAME',
			    listeners: {
			    	onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('PAY_USER', panelResult.getValue('USER_ID'));
							panelSearch.setValue('USER_NAME', panelResult.getValue('USER_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('PAY_USER', '');
						panelSearch.setValue('USER_NAME', '');
					},
			    	onValueFieldChange: function(field, newValue){
			    		panelSearch.setValue('PAY_USER', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('USER_NAME', newValue);				
					}
				}
		    }),Unilite.popup('CUST',{
		        fieldLabel: '거래처',
				allowBlank:true,
				autoPopup:false,
				validateBlank:false,
			    valueFieldName:'CUSTOM_CODE',
			    textFieldName:'CUSTOM_NAME',
	        	listeners: {
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
					},
				
					applyextparam: function(popup){							
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}		        
		    }),Unilite.popup('AC_PROJECT',{
		    	fieldLabel: '프로젝트',
		        autoPopup:true,
		        valueFieldName:'PJT_CODE',
				textFieldName:'PJT_NAME',
				DBvalueFieldName: 'AC_PROJECT_CODE',
				DBtextFieldName: 'AC_PROJECT_NAME',
	        	listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('PJT_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('PJT_NAME', newValue);				
					}
				}		        
		    }),{
		        fieldLabel: '지출유형',
			    name:'PAY_TYPE', 
			    xtype: 'uniCombobox',
			    comboType: 'AU', 
			    comboCode: 'A177',
			    width: 325,
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelSearch.setValue('PAY_TYPE', newValue);
					}
				}
		    },{ 
	    		fieldLabel: '지출결의번호',
			    xtype: 'uniTextfield',
			    name: 'PAY_DRAFT_NO',
			    width: 325,
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelSearch.setValue('PAY_DRAFT_NO', newValue);
			      	}
				}
			},{
		        fieldLabel: '거래처분류',
			    name:'AGENT_TYPE', 
			    xtype: 'uniCombobox',
			    comboType: 'AU', 
			    comboCode: 'B055',
			    width: 325,
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelSearch.setValue('AGENT_TYPE', newValue);
					}
				}
		    },{
		        fieldLabel: '구분',
			    name:'GUBUN', 
			    xtype: 'uniCombobox',
			    comboType: 'AU', 
			    comboCode: 'A178',
			    width: 325,
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelSearch.setValue('GUBUN', newValue);
					}
				}
		    }]
	});    
    
	/* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('agj400skrGrid', {
        layout : 'fit',
        region:'center',
//        flex: 0.65,
//        minHeight :100,
        flex: 3,
    	store: masterStore,
        selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
        tbar : [
        	{
		    	xtype:'button',
		    	text : '자동분개보기',
		    	handler : function()	{
		    		var record = masterGrid.getSelectedRecord()
		    		if(record)	{
		    			masterGrid.gotoAgj105ukr(record);
		    		} else {
		    			Unilite.messageBox("지출결의내역을 선택하세요.");
		    		}
		    	}
		    }
        ],
    	uniOpt:{						
			useMultipleSorting	: true,			
		    useLiveSearch		: true,			
		    onLoadSelectFirst	: true,				
		    dblClickToEdit		: false,			
		    useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: true,		
			expandLastColumn	: true,			
			useRowContext		: true,		
		    filter: {					
				useFilter		: false,	
				autoCreate		: false	
			}						
        },
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
        columns:  [ 			
	   		 {dataIndex : 'ORDER_SEQ'			, width : 100 , hidden : true }
	   		,{dataIndex : 'STATUS'				, width : 100 , hidden : true }
	   		,{dataIndex : 'CONFIRM_YN'			, width : 100 , hidden : true}
	   		,{dataIndex : 'PAY_DRAFT_NO'		, width : 120 
		   		  , summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				       return Unilite.renderSummaryRow(summaryData, metaData, '합계', '합계');
		    	    }
		   	}
	   		,{dataIndex : 'SEQ'					, width : 100 , hidden : true}
	   		,{dataIndex : 'PAY_DATE'			, width : 100 }
	   		,{dataIndex : 'PAY_SLIP_DATE'		, width : 100 }
	   		,{dataIndex : 'TITLE'				, width : 100 }
	   		,{dataIndex : 'TOTAL_AMT_I'			, width : 100 }
	   		,{dataIndex : 'GUBUN'				, width : 100 }
	   		,{dataIndex : 'USE_DATE'     		, width: 100	}
	   		,{dataIndex : 'PAY_TYPE'			, width : 100 }
	   		,{dataIndex : 'MAKE_SALE'			, width : 100 }
	   		,{dataIndex : 'ACCNT'				, width : 100 }
	   		,{dataIndex : 'ACCNT_NAME'			, width : 150 }
	   		,{dataIndex : 'PAY_DIVI'			, width : 100 }
	   		,{dataIndex : 'PROOF_DIVI'			, width : 140 }
	   		,{dataIndex : 'QTY'					, width : 100 ,	summaryType: 'sum'}
	   		,{dataIndex : 'PRICE'				, width : 100 ,	summaryType: 'sum'}
	   		
	   		,{dataIndex : 'ADD_REDUCE_AMT_I'	, width : 100 ,	summaryType: 'sum'}
	   		,{dataIndex : 'MONEY_UNIT'			, width : 100	} 
			,{dataIndex : 'EXCHG_RATE_O'		, width : 100	}
			,{dataIndex : 'FOR_AMT_I'			, width : 100	, summaryType : 'sum'}
	   		,{dataIndex : 'TOT_AMT_I'			, width : 100 ,	summaryType: 'sum'}
	   		,{dataIndex : 'SUPPLY_AMT_I'		, width : 100 ,	summaryType: 'sum'}
	   		,{dataIndex : 'TAX_AMT_I'			, width : 100 ,	summaryType: 'sum'}
	   		,{dataIndex : 'CUSTOM_NAME'			, width : 100 }
	   		,{dataIndex : 'COMPANY_NUM'     	, width : 100}
	   		,{dataIndex : 'BOOK_CODE'     		, width : 100}
	   		,{dataIndex : 'BANK_NAME'     		, width : 100}
	   		,{dataIndex : 'BANKBOOK_NAME'     	, width : 100}
	   		,{dataIndex : 'CUST_BOOK_ACCOUNT'   , width : 100}
	   		,{dataIndex : 'AGENT_TYPE'			, width : 100 }
	   		,{dataIndex : 'AGENT_TYPE2'			, width : 100 }
	   		,{dataIndex : 'AGENT_TYPE3'			, width : 100 }
	   		,{dataIndex : 'EB_YN'				, width : 100 }
	   		,{dataIndex : 'CRDT_NUM'			, width : 100 , hidden : true}
	   		,{dataIndex : 'CRDT_NAME'			, width : 120 }
	   		,{dataIndex : 'CRDT_FULL_NUM_EXPOS' , width: 100  }
	   		,{dataIndex : 'APP_NUM'				, width : 100 }
	   		,{dataIndex : 'REASON_CODE'			, width : 100 }
	   		,{dataIndex : 'PAY_CUSTOM_CODE'		, width : 100 }
	   		,{dataIndex : 'PAY_CUSTOM_NAME'		, width : 100 }
	   		,{dataIndex : 'SEND_DATE'			, width : 100 }
	   		,{dataIndex : 'BILL_DATE'			, width : 120 }
	   		,{dataIndex : 'SAVE_CODE'			, width : 100 }
	   		,{dataIndex : 'SAVE_NAME'			, width : 100 }
	   		,{dataIndex : 'OUT_BANKBOOK_NUM'	, width : 100 }
	   		,{dataIndex : 'PJT_NAME'			, width : 100 }
	   		,{dataIndex : 'PAY_USER'			, width : 100 }
	   		,{dataIndex : 'DEPT_NAME'			, width : 100 }
	   		,{dataIndex : 'DIV_CODE'			, width : 100 , hidden : true}
	   		,{dataIndex : 'DIV_NAME'			, width : 100 }
	   		,{dataIndex : 'EX_DATE'				, width : 100 }
	   		,{dataIndex : 'EX_NUM'				, width : 100 }
	   		,{dataIndex : 'AP_STS'				, width : 100 }
        ],
        listeners: {
	        onGridDblClick:function(grid, record, cellIndex, colName, td) {
	        	if(colName=='CRDT_FULL_NUM_EXPOS' ) {
					grid.ownerGrid.openCryptCardNoPopup(record);
				} else {
					grid.ownerGrid.gotoAgj400ukr(record); 
				}
			},
			selectionChange : function(grid, selected, eOpts)	{
				var fp = Ext.getCmp('agj400skrFileUploadPanel');
				if(selected && selected.length > 0)	{
					var fileNum = selected[0].get('FILE_NUM');
					if(!Ext.isEmpty(fileNum))	{
						Ext.getBody().mask()
						bdc100ukrvService.getFileList({DOC_NO : fileNum},
							function(provider, response) {
								Ext.getBody().unmask()
								var fp = Ext.getCmp('agj400skrFileUploadPanel');
								fp.loadData(response.result);
							}
						)
					} else {
						fp.clear();
					}
				} else {
					fp.clear();
				}
			}
        }
        ,gotoAgj105ukr:function(record)	{
			if(Ext.isEmpty(record.get("EX_NUM")))	{
				Unilite.messageBox("생성된 전표가 없습니다.");
				return;
			}
    		var param = {
    			'PGM_ID'			: 'agj400skr',
    			'DIV_CODE'			: record.get('DIV_CODE'),
				'AC_DATE'		    : UniDate.getDbDateStr(record.get('EX_DATE')),
				'EX_NUM'			: record.get('EX_NUM'),
				'AP_STS'			: record.get('AP_STS'),
				'INPUT_PATH'		: "80"
    		};
    		
	  		var rec1 = {data : {prgID : 'agj105ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agj105ukr.do', param);
    	},
    	gotoAgj400ukr:function(record)	{
    		var param = {
    			'PGM_ID'			: 'agj400skr',
    			'PAY_DRAFT_NO'		: record.get('PAY_DRAFT_NO')
    		};
    		
	  		var rec1 = {data : {prgID : 'agj400ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agj400ukr.do', param);
    	},
		openCryptCardNoPopup:function( record ) {
			if(record) {
				var params = {'CRDT_FULL_NUM': record.get('CRDT_FULL_NUM'), 'GUBUN_FLAG': '1', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'CRDT_FULL_NUM_EXPOS', 'CRDT_FULL_NUM', params);
			}
		}
	});
    

 	
    Unilite.Main( {
		borderItems:[{
			border: false,
			region:'center',
			layout: 'border',
			items:[
			 	panelResult,
				masterGrid,
				{
	     			xtype:'xuploadpanel',
	     			region :'south',
	     			id : 'agj400skrFileUploadPanel',
			    	itemId:'fileUploadPanel',
			    	height: 80,
			    	readOnly : true,
			    	uniOpt: {
			    		isDirty : false,
			    		isLoading: false,
			    		autoStart: true,
			    		editable: false,
			    		maxFileNumber: 0		//최대 업로드 파일 갯수
			    	}
		    	} 
			]	
		}		
		,panelSearch
		],
		id  : 'agj400skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('PAY_DATE_FR', UniDate.get('today'));	
			panelSearch.setValue('PAY_DATE_FR', UniDate.get('today'));	
			
			UniAppManager.setToolbarButtons(['detail','reset','save'],false);

		},
		onQueryButtonDown : function()	{		
			if(!this.isValidSearchForm()){
				return false;
			}
			
			var viewNormal = masterGrid.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);

			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true);
		},
		onResetButtonDown: function() {			
			this.suspendEvents();
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterStore.clearData();
			this.fnInitBinding();
		}
	});

};


</script>
