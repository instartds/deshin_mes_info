<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bcm130skrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B015" /><!-- 거래처구분-->  
	<t:ExtComboStore comboType="AU" comboCode="B016" /><!-- 법인/개인-->        
	<t:ExtComboStore comboType="AU" comboCode="B012" /><!-- 국가코드-->         
	<t:ExtComboStore comboType="AU" comboCode="B004" /><!-- 기준화폐-->         
	<t:ExtComboStore comboType="AU" comboCode="B017" /><!-- 원미만계산-->       
	<t:ExtComboStore comboType="AU" comboCode="YP36" /><!-- 계산서종류-->       
	<t:ExtComboStore comboType="AU" comboCode="B038" /><!--결제방법-->  	     
	<t:ExtComboStore comboType="AU" comboCode="B034" /><!--결제조건-->         
	<t:ExtComboStore comboType="AU" comboCode="B033" /><!--마감종류-->         
	<t:ExtComboStore comboType="AU" comboCode="B010" /><!--사용여부-->        
	<t:ExtComboStore comboType="AU" comboCode="B030" /><!--세액포함여부-->
	<t:ExtComboStore comboType="AU" comboCode="B051" /><!--세액계산법-->           
	<t:ExtComboStore comboType="AU" comboCode="B055" /><!--거래처분류-->           
	<t:ExtComboStore comboType="AU" comboCode="B056" /><!--지역구분 -->          
	<t:ExtComboStore comboType="AU" comboCode="B057" /><!--미수관리방법-->         
	<t:ExtComboStore comboType="AU" comboCode="S010" /><!--주담당자  -->           
	<t:ExtComboStore comboType="AU" comboCode="B062" /><!--카렌더타입  -->         
	<t:ExtComboStore comboType="AU" comboCode="B086" /><!--회원구분 -->        
	<t:ExtComboStore comboType="AU" comboCode="S051" /><!--전자문서구분 -->        
	<t:ExtComboStore comboType="AU" comboCode="A020" /><!--전자문서주담당여부 -->  
	<t:ExtComboStore comboType="AU" comboCode="B109" /><!--유통채널	--> 
	<t:ExtComboStore comboType="AU" comboCode="B232" /><!--신/구 주소구분	--> 
	<t:ExtComboStore comboType="AU" comboCode="YP03" /><!-- 출판분야-->
	<t:ExtComboStore comboType="AU" comboCode="YP35" /><!-- 수금(지불)일-->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->	
	<t:ExtComboStore comboType="AU" comboCode="B020" /><!-- 품목계정 -->
	<t:ExtComboStore comboType="AU" comboCode="B014" /><!-- 조달구분 -->
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
	Unilite.defineModel('bcm130skrvModel', {
	    fields: [  	  
	    	 {name: 'CUSTOM_CODE' 		,text:'거래처코드' 		,type:'string'	},
			 {name: 'CUSTOM_TYPE' 		,text:'<t:message code="system.label.base.classfication" default="구분"/>' 			,type:'string'	,comboType:'AU',comboCode:'B015' },			 
			 {name: 'CUSTOM_NAME' 		,text:'거래처명' 		,type:'string'	},
			 {name: 'CUSTOM_FULL_NAME' 	,text:'거래처명(전명)' 	,type:'string'	},
			 {name: 'CUSTOM_NAME1' 		,text:'거래처명1' 		,type:'string'	},
			 {name: 'CUSTOM_NAME2' 		,text:'거래처명2' 		,type:'string'	},
			 {name: 'NATION_CODE' 		,text:'국가코드' 		,type:'string'	,comboType:'AU',comboCode:'B012'},
			 {name: 'COMPANY_NUM' 		,text:'사업자번호' 		,type:'string'	},
			 {name: 'TOP_NUM' 			,text:'주민번호' 		,type:'string'	},
			 {name: 'TOP_NAME' 			,text:'대표자' 			,type:'string'	},
			 {name: 'BUSINESS_TYPE' 	,text:'법인/구분' 		,type:'string'	,comboType:'AU',comboCode:'B016'},
			 {name: 'USE_YN' 			,text:'<t:message code="system.label.base.useyn" default="사용여부"/>' 		,type:'string' , comboType:'AU',comboCode:'B010'},
			 {name: 'COMP_TYPE' 		,text:'업태' 			,type:'string'	},
			 {name: 'COMP_CLASS' 		,text:'업종' 			,type:'string'	},
			 {name: 'AGENT_TYPE' 		,text:'거래처분류' 		,type:'string'	,comboType:'AU',comboCode:'B055' },
			 {name: 'AGENT_TYPE2' 		,text:'거래처분류2' 	,type:'string'	},
			 {name: 'AGENT_TYPE3' 		,text:'거래처분류3' 	,type:'string'	},
			 {name: 'AREA_TYPE' 		,text:'지역' 			,type:'string'	,comboType:'AU',comboCode:'B056'},
			 {name: 'ZIP_CODE' 			,text:'우편번호' 		,type:'string'	},
			 {name: 'ADDR1' 			,text:'주소1' 		,type:'string'	},
			 {name: 'ADDR2' 			,text:'주소2' 		,type:'string'	},					
			 {name: 'TELEPHON' 			,text:'연락처' 		,type:'string'	},
			 {name: 'FAX_NUM' 			,text:'FAX번호' 		,type:'string'	},
			 {name: 'HTTP_ADDR' 		,text:'홈페이지' 		,type:'string'	},  
			 {name: 'MAIL_ID' 			,text:'E-mail' 		,type:'string'	},
			 {name: 'WON_CALC_BAS' 		,text:'원미만계산' 	,type:'string'	,comboType:'AU',comboCode:'B017'},
			 {name: 'START_DATE' 		,text:'거래시작일' 	,type:'uniDate'	},
			 {name: 'STOP_DATE' 		,text:'거래중단일' 	,type:'uniDate'	},
			 {name: 'TO_ADDRESS' 		,text:'송신주소' 		,type:'string'	},
			 {name: 'TAX_CALC_TYPE' 	,text:'세액계산법' 	,type:'string'	,comboType:'AU',comboCode:'B051'},
			 {name: 'RECEIPT_DAY' 		,text:'결제조건' 		,type:'string'	,comboType:'AU',comboCode:'B034'},
			 {name: 'MONEY_UNIT' 		,text:'기준화폐' 		,type:'string'	, comboType:'AU',comboCode:'B004', displayField: 'value'},
			 {name: 'TAX_TYPE' 			,text:'세액포함여부' 	,type:'string'	, comboType:'AU',comboCode:'B030'},
			 {name: 'BILL_TYPE' 		,text:'계산서유형' 	,type:'string'	, comboType:'AU',comboCode:'YP36'},
			 {name: 'SET_METH' 			,text:'결제방법' 		,type:'string'	, comboType:'AU',comboCode:'B038'},
			 {name: 'VAT_RATE' 			,text:'세율' 			,type:'uniFC'},
			 {name: 'TRANS_CLOSE_DAY' 	,text:'마감종류' 		,type:'string'	, comboType:'AU',comboCode:'B033'},
			 {name: 'COLLECT_DAY' 		,text:'수금일'  		,type:'string' , comboType:'AU',comboCode:'YP35'},                  
			 {name: 'CREDIT_YN' 		,text:'여신적용여부' 	,type:'string', comboType:'AU',comboCode:'B010'},
			 {name: 'TOT_CREDIT_AMT' 	,text:'여신(담보)액' 	,type:'uniPrice'	},
			 {name: 'CREDIT_AMT' 		,text:'신용여신액' 	,type:'uniPrice'	},
			 {name: 'CREDIT_YMD' 		,text:'신용여신만료일' 	,type:'uniDate'	},
			 {name: 'COLLECT_CARE' 		,text:'미수관리방법' 	,type:'string'	, comboType:'AU',comboCode:'B057'},
			 {name: 'SAP_CODE' 			,text:'SAP등록코드' 	,type:'string'},
			 {name: 'BUSI_PRSN' 		,text:'주영업담당' 		,type:'string'	, comboType:'AU',comboCode:'S010'},
			 {name: 'TAX_CALC_ORDER' 	,text:'세액계산순서' 	,type:'string'},			 
			 {name: 'MANAGE_CUSTOM' 	,text:'집계거래처' 	,type:'string'	},					
			 {name: 'MCUSTOM_NAME' 		,text:'집계거래처명' 	,type:'string'	},
			 {name: 'COLLECTOR_CP' 		,text:'수금거래처' 	,type:'string'	},					
			 {name: 'COLLECTOR_CP_NAME' ,text:'수금거래처명' 	,type:'string'	},					
			 {name: 'BANK_CODE' 		,text:'금융기관' 		,type:'string'	},
			 {name: 'BANK_NAME' 		,text:'금융기관명' 	,type:'string'	},
			 {name: 'BANKBOOK_NUM' 		,text:'계좌번호' 		,type:'string'	},
			 {name: 'BANKBOOK_NAME' 	,text:'예금주' 		,type:'string'	},
			 {name: 'CUST_CHK' 			,text:'거래처변경여부' 	,type:'string'	},
			 {name: 'SSN_CHK' 			,text:'주민번호변경여부',type:'string'	},
			 {name: 'UPDATE_DB_USER' 	,text:'작성자' 		,type:'string'	},			 
			 {name: 'PURCHASE_BANK' 	,text:'구매카드은행' 	,type:'string'	},
			 {name: 'PURBANKNAME' 		,text:'구매카드은행명' 	,type:'string'	},
			 {name: 'BILL_PRSN' 		,text:'전자문서담당자' 	,type:'string'	},
			 {name: 'HAND_PHON' 		,text:'핸드폰번호' 	,type:'string'	},
			 {name: 'BILL_MAIL_ID' 		,text:'전자문서E-mail'	,type:'string'	},
			 {name: 'CUSTOM_SALE_PRSN' 	,text:'영업담당자' 	,type:'string'	},
			 {name: 'CUSTOM_SALE_HAND_PHON' ,text:'영업담당자핸드폰번호' 	,type:'string'	},
			 {name: 'CUSTOM_SALE_MAIL_ID' 	,text:'영업담당자E-mail'	,type:'string'	},
			 {name: 'BILL_PRSN2' 		,text:'전자문서담당자2' ,type:'string'	},
			 {name: 'HAND_PHON2' 		,text:'핸드폰번호2' 	,type:'string'	},
			 {name: 'BILL_MAIL_ID2' 	,text:'전자문서E-mail2'	,type:'string'	},
			 {name: 'BILL_MEM_TYPE' 	,text:'전자세금계산서' 		,type:'string'	},
			 {name: 'ADDR_TYPE' 		,text:'신/구주소 구분' 		,type:'string'	, comboType:'AU',comboCode:'B232'},
			 {name: 'COMP_CODE' 		,text:'COMP_CODE' 		,type:'string'	},
			 {name: 'CHANNEL' 			,text:'CHANNEL' 		,type:'string'	},
			 {name: 'BILL_CUSTOM' 		,text:'계산서거래처코드'		,type:'string'	},
			 {name: 'BILL_CUSTOM_NAME' 	,text:'계산서거래처' 	  	,type:'string'	},
			 {name: 'CREDIT_OVER_YN' 	,text:'CREDIT_OVER_YN' 	,type:'string'},    
			 {name: 'DEPT_CODE' 		,text:'관련부서' 			,type:'string'	},    
			 {name: 'DEPT_NAME' 		,text:'관련부서명' 			,type:'string'	},
			 
			 //추가 컬럼들
			 {name: 'CUST_LEVEL1' 		  ,text:'고객구분' 		,type:'string'	},
			 {name: 'SERVANT_COMPANY_NUM' ,text:'종사업자번호' 		,type:'string'	},
			 {name: 'RETURN_CODE' 		  ,text:'반품처' 			,type:'string'	},				 
			 {name: 'DVRY_PRSN'			  ,text:'배송처담당자'		,type:'string'	},
			 {name: 'DVRY_PHON' 	  	  ,text:'연락처'			,type:'string'	},
			 {name: 'DVRY_LT' 	  		  ,text:'배송L/T'			,type:'integer'	},
			 {name: 'PUBLICATION_FLD1'	  ,text:'출판분야'			,type:'string'	},
			 {name: 'PUBLICATION_FLD2'	  ,text:'출판분야2'		,type:'string'	},
			 {name: 'PUBLICATION_FLD3'	  ,text:'출판분야3'		,type:'string'	},
			 {name: 'CARD_NO1'	  		  ,text:'CARD_NO1'		,type:'string'	},
			 {name: 'CARD_NO2'	  		  ,text:'CARD_NO2'		,type:'string'	},
			 {name: 'CARD_NO3'	  		  ,text:'CARD_NO3'		,type:'string'	},
			 {name: 'CARD_NO4'	  		  ,text:'CARD_NO4'		,type:'string'	},
			 {name: 'WH_CODE'	  		  ,text:'<t:message code="system.label.base.mainwarehouse" default="주창고"/>'			,type:'string', store: Ext.data.StoreManager.lookup('whList')},		     
		     {name: 'REMARK'			  ,text: '<t:message code="system.label.base.remarks" default="비고"/>'			,type: 'string'},
		     {name: 'KEY_VALUE'			  ,text: '변경이력KEY'		,type: 'string'},
		     {name: 'OPR_FLAG'			  ,text: '변경로그'		,type: 'string'},
		     {name: 'MODIFY_REASON'		  ,text: '변경사유'		,type: 'string'},
		     {name: 'UPDATE_DB_TIME'	  ,text: '수정일'			,type: 'string'},
		     {name: 'UPDATE_DB_USER'	  ,text: '수정자ID'		,type: 'string'},
		     {name: 'USER_NAME'	  		  ,text: '수정자'			,type: 'string'}
		]
	}); //End of Unilite.defineModel('bcm130skrvModel', {

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('bcm130skrvMasterStore1',{
		model: 'bcm130skrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
        	type: 'direct',
            api: {			
            	read: 'bcm130skrvService.selectList'                	
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'CUSTOM_CODE'
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var masterForm = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
		        fieldLabel: '변경일',
		        xtype: 'uniDateRangefield',  
				startFieldName: 'FROM_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('FROM_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('TO_DATE',newValue);
			    	}
			    }
			},
				Unilite.popup('USER',{
					fieldLabel: '수정자',
					valueFieldName:'USER_ID',
			    	textFieldName:'USER_NAME',
			    	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('USER_ID', masterForm.getValue('USER_ID'));
								panelResult.setValue('USER_NAME', masterForm.getValue('USER_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
								panelResult.setValue('USER_ID', '');
								panelResult.setValue('USER_NAME', '');
						}
					}
			}),{
		 		fieldLabel: '고객분류',
		 		name:'AGENT_TYPE', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'B055',
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AGENT_TYPE', newValue);
					}
				}
	 		},
	 			Unilite.popup('CUST', { 
					fieldLabel: '거래처', 
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('CUSTOM_CODE', masterForm.getValue('CUSTOM_CODE'));
								panelResult.setValue('CUSTOM_NAME', masterForm.getValue('CUSTOM_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
								panelResult.setValue('CUSTOM_CODE', '');
								panelResult.setValue('CUSTOM_NAME', '');
						}
					}
			}),{
	        	fieldLabel: '사업자번호', 
				xtype: 'uniTextfield',
				name:'COMPANY_NUM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('COMPANY_NUM', newValue);
					}
				}
		    },{
		 		fieldLabel: '<t:message code="system.label.base.classfication" default="구분"/>',
		 		name:'CUSTOM_TYPE', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'B015',
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CUSTOM_TYPE', newValue);
					}
				}
	 		}]
		}]
    }); //End of var masterForm = Unilite.createSearchForm('searchForm',{
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
  
    var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
		        fieldLabel: '변경일',
		        xtype: 'uniDateRangefield',  
				startFieldName: 'FROM_DATE',
				endFieldName: 'TO_DATE',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				allowBlank: false,
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(masterForm) {
						masterForm.setValue('FROM_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(masterForm) {
			    		masterForm.setValue('TO_DATE',newValue);
			    	}
			    }
			},
				Unilite.popup('USER',{
					fieldLabel: '수정자',
					valueFieldName:'USER_ID',
			    	textFieldName:'USER_NAME',
			    	listeners: {
						onSelected: {
							fn: function(records, type) {
								masterForm.setValue('USER_ID', panelResult.getValue('USER_ID'));
								masterForm.setValue('USER_NAME', panelResult.getValue('USER_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
								masterForm.setValue('USER_ID', '');
								masterForm.setValue('USER_NAME', '');
						}
					}
			}),{
		 		fieldLabel: '고객분류',
		 		name:'AGENT_TYPE', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'B055',
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('AGENT_TYPE', newValue);
					}
				}
	 		},
	 			Unilite.popup('CUST', { 
					fieldLabel: '거래처', 
					valueFieldName: 'CUSTOM_CODE',
			   	 	textFieldName: 'CUSTOM_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								masterForm.setValue('CUSTOM_CODE', panelResult.getValue('CUSTOM_CODE'));
								masterForm.setValue('CUSTOM_NAME', panelResult.getValue('CUSTOM_NAME'));
	                    	},
							scope: this
						},
						onClear: function(type)	{
								masterForm.setValue('CUSTOM_CODE', '');
								masterForm.setValue('CUSTOM_NAME', '');
						}
					}
			}),{
	        	fieldLabel: '사업자번호', 
				xtype: 'uniTextfield',
				name:'COMPANY_NUM',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('COMPANY_NUM', newValue);
					}
				}
		    },{
		 		fieldLabel: '<t:message code="system.label.base.classfication" default="구분"/>',
		 		name:'CUSTOM_TYPE', 
		 		xtype: 'uniCombobox',
		 		comboType:'AU',
		 		comboCode:'B015',
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('CUSTOM_TYPE', newValue);
					}
				}
	 		}]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
   
    var panelChangeHistory = Unilite.createSearchForm('changeHistoryForm',{
    	flex : 1,
    	autoScroll: true,
    	width: -100,
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'east',
		padding:'1 1 1 1',
		border:true,
		layout: {xtype: 'uniTable', columns: 3},
		items: [{
			xtype: 'component',
			margin: '7.5,7.5,7.5,7.5',
			algin: 'center',
			html: '<b><font size = "2" color = "blue">변경이력</font></b>'
		},{
			name: 'CHANGE_HISTORY',
			xtype: 'textarea',
			margin: '1, 1, 1, 1',
			editable: false,
			width: 1000,
			height: 2000
		}]
    });	
    
    var masterGrid = Unilite.createGrid('bcm130skrvGrid1', {
    	layout : 'fit',
    	flex : 3,
    	region:'center',
        store : directMasterStore, 
        selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
       /* tbar: [{
        	text:'상세보기',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],*/
        columns: [
			 {dataIndex:'OPR_FLAG'			,width:80, locked: true},		
			 {dataIndex:'CUSTOM_TYPE'		,width:80, locked: true},			
        	 {dataIndex:'CUSTOM_CODE'		,width:80, locked: true},			
			 {dataIndex:'CUSTOM_FULL_NAME'	,width:170, locked: true},										
			 {dataIndex:'CUSTOM_NAME'		,width:170, hidden:true},			
			 {dataIndex:'COMPANY_NUM'		,width:100},										
			 {dataIndex:'SERVANT_COMPANY_NUM' ,width:90, hidden: true},		
			 {dataIndex:'TOP_NUM'			,width:100, hidden: true},		
			 {dataIndex:'TOP_NAME'			,width:100},	
			 {dataIndex:'AGENT_TYPE'		,width:120},
			 {dataIndex:'TAX_TYPE'			,width:90},	
			 {dataIndex:'TAX_CALC_TYPE'		,width:90},					 
			 {dataIndex:'WON_CALC_BAS'		,width:80},	
			 {dataIndex:'VAT_RATE'			,width:60},
			 {dataIndex:'CREDIT_YN'			,width:85, hidden: true},
			 {dataIndex:'TOT_CREDIT_AMT'	,width:90, hidden: true},
			 {dataIndex:'CREDIT_AMT'		,width:80, hidden: true},
			 {dataIndex:'CREDIT_YMD'		,width:100, hidden: true},
			 {dataIndex:'BUSI_PRSN'			,width:90, hidden: true},
			 {dataIndex:'USE_YN'			,width:60},
			 {dataIndex:'MODIFY_REASON'	  	,width:150, hidden: true},
			 {dataIndex:'UPDATE_DB_TIME'	,width:146},
			 {dataIndex:'UPDATE_DB_USER'	,width:80},
			 {dataIndex:'USER_NAME'			,width:80},
			 {dataIndex:'CUSTOM_NAME1'		,width:150	, hidden:true},
			 {dataIndex:'CUSTOM_NAME2'		,width:150	, hidden:true},
			 {dataIndex:'BUSINESS_TYPE'		,width:80	, hidden:true},
			 {dataIndex:'COMP_TYPE'			,width:140  , hidden:true},
			 {dataIndex:'COMP_CLASS'		,width:140  , hidden:true},
			 {dataIndex:'AGENT_TYPE2'		,width:80	, hidden:true},
			 {dataIndex:'AGENT_TYPE3'		,width:60	, hidden:true},	
			 {dataIndex:'NATION_CODE'		,width:130	, hidden:true},
			 {dataIndex:'AREA_TYPE'			,width:80	, hidden:true},
			 {dataIndex:'ZIP_CODE'			,width:80   , hidden:true},
			 {dataIndex:'ADDR1'				,width:200	, hidden:true},
			 {dataIndex:'ADDR2'				,width:200	, hidden:true},
			 {dataIndex:'TELEPHON'			,width:80   , hidden:true},
			 {dataIndex:'FAX_NUM'			,width:80	, hidden:true},
			 {dataIndex:'HTTP_ADDR'			,width:140	, hidden:true},
			 {dataIndex:'MAIL_ID'			,width:100	, hidden:true},
			 {dataIndex:'START_DATE'		,width:80	, hidden:true},
			 {dataIndex:'STOP_DATE'			,width:80	, hidden:true},
			 {dataIndex:'TO_ADDRESS'		,width:140	, hidden:true},
			 {dataIndex:'RECEIPT_DAY'		,width:120	},
			 {dataIndex:'MONEY_UNIT'		,width:130	, hidden:true},
			 {dataIndex:'BILL_TYPE'			,width:120	, hidden:true},
			 {dataIndex:'SET_METH'			,width:90	},
			 {dataIndex:'TRANS_CLOSE_DAY'	,width:120	},
			 {dataIndex:'COLLECT_DAY'		,width:90	},
			 {dataIndex:'COLLECT_CARE'		,width:120	, hidden:true},
			 {dataIndex:'SAP_CODE'			,width:80	, hidden:true},
			 {dataIndex:'TAX_CALC_ORDER'	,width:80,
			    renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) { 
			     return val == '2' ? '부가세' : (val == '1' ? '공급가' : '');			                              
			 	}
		  	 },
			 {dataIndex:'REMARK'			,width:250	, flex:1, hidden:true},
			 {dataIndex:'MANAGE_CUSTOM'		,width:140	, hidden:true},
			 {dataIndex:'MCUSTOM_NAME'		,width:140	, hidden:true},			
			 {dataIndex:'COLLECTOR_CP_NAME'	,width:140	, hidden:true},
			 {dataIndex:'BANK_NAME'			,width:100	, hidden: true}, 			        
			 {dataIndex:'BANKBOOK_NUM'		,width:100	, hidden:true},
			 {dataIndex:'BANKBOOK_NAME'		,width:100	, hidden:true},
			 {dataIndex:'CUST_CHK'			,width:90	, hidden:true},
			 {dataIndex:'SSN_CHK'			,width:90	, hidden:true},
			 {dataIndex:'UPDATE_DB_USER'	,width:90	, hidden:true},
			 {dataIndex:'UPDATE_DB_TIME'	,width:90	, hidden:true},
			 {dataIndex:'PURCHASE_BANK'		,width:150	, hidden:true},
			 {dataIndex:'PURBANKNAME'		,width:150	, hidden:true},
			 {dataIndex:'BILL_PRSN'			,width:110	, hidden:true},
			 {dataIndex:'HAND_PHON'			,width:110	, hidden:true},
			 {dataIndex:'BILL_MAIL_ID'		,width:140	, hidden:true},
			 {dataIndex:'CUSTOM_SALE_PRSN'	,width:110	, hidden:true},
			 {dataIndex:'CUSTOM_SALE_HAND_PHON',width:110	, hidden:true},
			 {dataIndex:'CUSTOM_SALE_MAIL_ID' ,width:140, hidden:true},
			 {dataIndex:'ADDR_TYPE'			  ,width:120, hidden:true},
			 {dataIndex:'CHANNEL'			  ,width:80	, hidden:true},
			 {dataIndex:'BILL_CUSTOM_NAME'	  ,width:120, hidden:true},
			 {dataIndex:'CUST_LEVEL1' 		  ,width:80	, hidden:true},
			 {dataIndex:'RETURN_CODE' 		  ,width:80	, hidden:true},
			 {dataIndex:'UPDATE_DB_TIME' 	  ,width:80	, hidden:true},
			 {dataIndex:'CREDIT_OVER_YN' 	  ,width:80	, hidden:true},
			 {dataIndex:'DVRY_PRSN'			  ,width:80	, hidden:true},
			 {dataIndex:'DVRY_PHON' 	  	  ,width:80	, hidden:true},
			 {dataIndex:'DVRY_LT' 	  		  ,width:80	, hidden:true},
			 {dataIndex:'PUBLICATION_FLD1'	  ,width:80	, hidden:true},
			 {dataIndex:'PUBLICATION_FLD2'	  ,width:80	, hidden:true},
			 {dataIndex:'PUBLICATION_FLD3'	  ,width:80	, hidden:true},
			 {dataIndex:'CARD_NO1'	  		  ,width:80	, hidden:true},
			 {dataIndex:'CARD_NO2'	 		  ,width:80	, hidden:true},
			 {dataIndex:'CARD_NO3'	  		  ,width:80	, hidden:true},
			 {dataIndex:'CARD_NO4'			  ,width:80	, hidden:true},
			 {dataIndex:'WH_CODE'			  ,width:80	, hidden:true},			 
			 {dataIndex:'REMARK'			  ,width: 133, hidden: true},
			 {dataIndex:'KEY_VALUE'		  	  ,width: 80 , hidden: true}
		],
		listeners: {        	
        	selectionchange:function( model1, selected, eOpts ){
        		panelChangeHistory.setValue('CHANGE_HISTORY', '');
        		if(selected[0].data.OPR_FLAG == '수정'){
					var param = masterGrid.getSelectedRecord().data;
        			bcm130skrvService.getChangeHistory(param, function(provider, response)	{
	        			if(!Ext.isEmpty(provider)){
	        				panelChangeHistory.setValue('CHANGE_HISTORY', provider[0].MODIFY_FACTOR);
	        			}	        		
	        		});	
        		}
        		
				       			
          	}
        } 
    });	//End of   var masterGrid = Unilite.createGrid('bcm130skrvGrid1', {

    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
			masterGrid, panelResult, panelChangeHistory  	
			]
		},
			masterForm
		],
		id: 'bcm130skrvApp',
		fnInitBinding : function() {
			masterForm.setValue('FROM_DATE',UniDate.get('startOfMonth'));
			masterForm.setValue('TO_DATE',UniDate.get('today'));
			panelResult.setValue('FROM_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			
		//	UniAppManager.setToolbarButtons('detail',true);
		//	UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function() {		
			directMasterStore.loadStoreRecords();
			/*var activeTabId = tab.getActiveTab().getId();			
			if(activeTabId == 'bcm130skrvGrid1'){				
				directMasterStore.loadStoreRecords();				
			}
			var viewLocked = tab.getActiveTab().lockedGrid.getView();
			var viewNormal = tab.getActiveTab().normalGrid.getView();
			console.log("viewLocked : ",viewLocked);
			console.log("viewNormal : ",viewNormal);
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);*/
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			panelResult.clearForm();
			this.fnInitBinding();
			directMasterStore.loadData({});
		}
	}); //End of Unilite.Main( {
};

</script>
