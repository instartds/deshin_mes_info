<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="bcm104skrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B015" /><!-- 거래처구분    -->  
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
	<t:ExtComboStore comboType="BOR120"  pgmId="bcm104skrv" /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 대조자 -->
</t:appConfig>
<style type= "text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel2 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript">
  var protocol =   ("https:" == document.location.protocol)  ? "https" : "http"  ;
  if(protocol == "https")	{
	  document.write( unescape( "%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E")  );
  }else {
  	document.write( unescape( "%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E") );
  }
</script><!-- Unilite.popup('ZIP',..) -->
<script type="text/javascript" >
var BsaCodeInfo = {	
	grsCustomType: ${grsCustomType}
};
var detailWin;
var purchaseItemSearchWindow; //취급품목 조회 팝업
var unPayAmtSearchWindow;	  //현미지급금, 현재고금액 조회 팝업
function appMain() {

	/**
	 * Model 정의 
	 * @type 
	 */
	
	Unilite.defineModel('bcm104skrvModel', {
		// pkGen : user, system(default)
	    fields: [{name: 'CUSTOM_CODE' 		,text:'거래처코드' 		,type:'string'	,allowBlank:true, isPk:true, pkGen:'user'},
				 {name: 'CUSTOM_TYPE' 		,text:'<t:message code="system.label.base.classfication" default="구분"/>' 			,type:'string'	,comboType:'AU',comboCode:'B015' ,allowBlank: false/*, defaultValue:'1'*/},
				 {name: 'CUSTOM_FULL_NAME' 	,text:'거래처명(전명)' 	,type:'string'	,allowBlank:false},
				 {name: 'CUSTOM_NAME' 		,text:'거래처명(약명)' 		,type:'string'	,allowBlank:false},
				 {name: 'CUSTOM_NAME1' 		,text:'거래처명1' 		,type:'string'	},
				 {name: 'CUSTOM_NAME2' 		,text:'거래처명2' 		,type:'string'	},
				 {name: 'NATION_CODE' 		,text:'국가코드' 		,type:'string'	,comboType:'AU',comboCode:'B012'},
				 {name: 'COMPANY_NUM' 		,text:'사업자번호' 		,type:'string'	},
				 {name: 'TOP_NUM' 			,text:'주민번호' 		,type:'string'	},
				 {name: 'TOP_NAME' 			,text:'대표자' 			,type:'string'	},
				 {name: 'BUSINESS_TYPE' 	,text:'법인/구분' 		,type:'string'	,comboType:'AU',comboCode:'B016'},
				 {name: 'USE_YN' 			,text:'<t:message code="system.label.base.photoflag" default="사진유무"/>' 		,type:'string'	, defaultValue:'Y'},
				 {name: 'COMP_TYPE' 		,text:'업태' 			,type:'string'	},
				 {name: 'COMP_CLASS' 		,text:'업종' 			,type:'string'	},
				 {name: 'AGENT_TYPE' 		,text:'거래처분류' 		,type:'string'	,comboType:'AU',comboCode:'B055' ,allowBlank: false/*, defaultValue:'1'*/},
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
				 {name: 'START_DATE' 		,text:'거래시작일' 	,type:'uniDate'	,allowBlank: false/*, defaultValue:UniDate.today()*/},
				 {name: 'STOP_DATE' 		,text:'거래중단일' 	,type:'uniDate'	},
				 {name: 'TO_ADDRESS' 		,text:'송신주소' 		,type:'string'	},
				 {name: 'TAX_CALC_TYPE' 	,text:'세액계산법' 	,type:'string'	,comboType:'AU',comboCode:'B051', defaultValue:'1'},
				 {name: 'RECEIPT_DAY' 		,text:'결제조건' 		,type:'string'	,comboType:'AU',comboCode:'B034'/*, defaultValue:'1'*/},
				 {name: 'MONEY_UNIT' 		,text:'기준화폐' 		,type:'string'	, comboType:'AU',comboCode:'B004', displayField: 'value'},
				 {name: 'TAX_TYPE' 			,text:'세액포함여부' 	,type:'string'	, comboType:'AU',comboCode:'B030', defaultValue:'2'},
				 {name: 'BILL_TYPE' 		,text:'계산서유형' 	,type:'string'	, comboType:'AU',comboCode:'YP36'},
				 {name: 'SET_METH' 			,text:'결제방법' 		,type:'string'	, comboType:'AU',comboCode:'B038'},
				 {name: 'VAT_RATE' 			,text:'세율' 			,type:'uniFC'	/*,defaultValue:10*/},
				 {name: 'TRANS_CLOSE_DAY' 	,text:'마감종류' 		,type:'string'	, comboType:'AU',comboCode:'B033'/*, defaultValue:'3'*/},
				 {name: 'COLLECT_DAY' 		,text:'수금일'  		,type:'string' , comboType:'AU',comboCode:'YP35', typeAhead: false, multiSelect: true, delimiter:','},                  
				 {name: 'CREDIT_YN' 		,text:'여신적용여부' 	,type:'string'	, defaultValue:'N'},
				 {name: 'TOT_CREDIT_AMT' 	,text:'여신(담보)액' 	,type:'uniPrice'	},
				 {name: 'CREDIT_AMT' 		,text:'신용여신액' 	,type:'uniPrice'	},
				 {name: 'CREDIT_YMD' 		,text:'신용여신만료일' 	,type:'uniDate'	},
				 {name: 'COLLECT_CARE' 		,text:'미수관리방법' 	,type:'string'	, comboType:'AU',comboCode:'B057'/*, defaultValue:'1'*/},
				 {name: 'SAP_CODE' 			,text:'SAP등록코드' 	,type:'string'},
				 {name: 'BUSI_PRSN' 		,text:'주담당자' 		,type:'string'	, comboType:'AU',comboCode:'S010'},
//				 {name: 'CAL_TYPE' 			,text:'카렌더타입' 		,type:'string'	, comboType:'AU',comboCode:'B062'},
				 {name: 'TAX_CALC_ORDER' 	,text:'세액계산순서' 	,type:'string', defaultValue:'2'},
				 {name: 'REMARK' 			,text:'<t:message code="system.label.base.remarks" default="비고"/>' 			,type:'string'	},
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
				 {name: 'UPDATE_DB_TIME' 	,text:'작성시간' 		,type:'uniDate'	},
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
				 {name: 'COMP_CODE' 		,text:'COMP_CODE' 		,type:'string'	, defaultValue: UserInfo.compCode},
				 {name: 'CHANNEL' 			,text:'CHANNEL' 		,type:'string'	},
				 {name: 'BILL_CUSTOM' 		,text:'계산서거래처코드'		,type:'string'	},
				 {name: 'BILL_CUSTOM_NAME' 	,text:'계산서거래처' 	  	,type:'string'	},
				 {name: 'CREDIT_OVER_YN' 	,text:'CREDIT_OVER_YN' 	,type:'string', defaultValue:'N'},
				 {name: 'Flag' 				,text:'Flag' 				,type:'string'	},    
				 {name: 'DEPT_CODE' 		,text:'관련부서' 			,type:'string'	},    
				 {name: 'DEPT_NAME' 		,text:'관련부서명' 			,type:'string'	},
				 
				 //추가 컬럼들
				 {name: 'CUST_LEVEL1' 		  ,text:'고객구분' 		,type:'string'	},
				 {name: 'SERVANT_COMPANY_NUM' ,text:'종사업자번호' 		,type:'string'	},
				 {name: 'RETURN_CODE' 		  ,text:'반품처' 			,type:'string'	},	////
				 {name: 'UPDATE_DB_TIME' 	  ,text:'최종수정일' 		,type:'string'	},				 
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
				 {name: 'MODIFY_REASON'	  	  ,text:'변경사유'			,type:'string'	},
				 {name: 'UNPAY_AMT' 	  	  ,text:'현미지급'			,type:'uniPrice'	},
				 {name: 'STOCK_I' 	  		  ,text:'현재고금액'		,type:'uniPrice'	},
				 {name: '' 	  				  ,text:'기준매입율'		,type:'uniFC'	},
				 {name: 'BALANCE_DATE' 	  	  ,text:'장부대조일자'		,type:'uniDate'	},
				 {name: 'BALANCE_PRSN' 	  	  ,text:'대조자(서점)'		,type:'string'	}
//				 {name: '' 	  				  ,text:'대조자(업체)'		,type:'string'	}
				 
					
			]
	});
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bcm104skrvService.selectDetailList',
			update: 'bcm104skrvService.updateDetail',
			create: 'bcm104skrvService.insertDetail',
			destroy: 'bcm104skrvService.deleteDetail',
			syncAll: 'bcm104skrvService.saveAll'
		}
	});	  
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('bcm104skrvMasterStore',{
			model: 'bcm104skrvModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy
            
            ,listeners: {
//	            write: function(proxy, operation){
//	                if (operation.action == 'destroy') {
//	                	Ext.getCmp('detailForm').reset();	
//	                }                
//            	}
            	update:function( store, record, operation, modifiedFieldNames, eOpts )	{
            		if(masterGrid.isVisible())	{
						detailForm.setActiveRecord(record);
            		}
				},
				metachange:function( store, meta, eOpts ){
					
				}
            	
            } // listeners
            
			// Store 관련 BL 로직
            // 검색 조건을 통해 DB에서 데이타 읽어 오기 
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('bcm104skrvSearchForm').getValues();			
				console.log( param );
				this.load({
					params : param,
						callback : function(records, operation, success) {
							if(success)	{
								var record = directMasterStore.data.items[0];
								if(Ext.isEmpty(record) && masterGrid.isHidden()){
									detailForm.hide();
									Unilite.messageBox(Msg.sMB015);
									return false;
								}/*else if(!Ext.isEmpty(record) && masterGrid.isHidden()){
									var param = {COMP_CODE: UserInfo.compCode, CUSTOM_CODE: record.get('CUSTOM_CODE')}
									bcm104skrvService.getUnPayAmt(param, function(provider, response)	{
										if(!Ext.isEmpty(provider)){
											detailForm.setValue('UNPAY_AMT', provider[0].UNPAY_AMT);
											detailForm.setValue('STOCK_I', provider[0].STOCK_I);
										}
									});
								}*/
								
							}
							if(masterGrid.isHidden()){
								detailForm.getEl().unmask();
//									directSubStore.loadStoreRecords();
							}
						}
				});
			}
			// 수정/추가/삭제된 내용 DB에 적용 하기 
			,saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
//				console.log("inValidRecords : ", inValidRecs);
//				var toCreate = this.getNewRecords();
//       			var toUpdate = this.getUpdatedRecords();       			
//       			var toDelete = this.getRemovedRecords();
//				var list = [].concat(toCreate, toUpdate, toDelete);
				if(inValidRecs.length == 0 )	{					
//					Ext.each(list, function(record,i){	
//			        	if(Ext.isEmpty(record.get('MODIFY_REASON')) && !record.phantom){
//							Unilite.messageBox('변경사유를 입력해 주세요.');
//							return false;
//						}
//						if(i+1 == list.length){
							directMasterStore.syncAllDirect(config);	
//						}
//				    }); 
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
            
		});
	
	/**
	 * 전자세금계산서 모델 정의
	 */
	Unilite.defineModel('bcm120ukrvModel', {
	    extend: 'Ext.data.Model',
	    fields: [{name: 'COMP_CODE' 		,text:'법인' 				,type:'string'	,allowBlank: false	},
				 {name: 'CUSTOM_CODE' 		,text:'거래처코드' 		,type:'string'	,allowBlank: false	},
				 {name: 'SEQ' 				,text:'<t:message code="system.label.base.seq" default="순번"/>' 				,type:'integer'	,allowBlank: false	},
				 {name: 'PRSN_NAME' 		,text:'담당자명' 			,type:'string'	,allowBlank: false	},
				 {name: 'DEPT_NAME' 		,text:'부서명' 			,type:'string'	},
				 {name: 'HAND_PHON' 		,text:'핸드폰번호' 		,type:'string'	},
				 {name: 'TELEPHONE_NUM1' 	,text:'전화번호1' 			,type:'string'	,allowBlank: false	},
				 {name: 'TELEPHONE_NUM2' 	,text:'전화번호2' 			,type:'string'	},
				 {name: 'FAX_NUM' 			,text:'팩스번호' 			,type:'string'	},
				 {name: 'MAIL_ID' 			,text:'E-MAIL주소' 		,type:'string'	,allowBlank: false	},
				 {name: 'BILL_TYPE' 		,text:'전자문서구분'		,type:'string'	, comboType:'AU',comboCode:'S051'},
				 {name: 'MAIN_BILL_YN' 		,text:'전자문서주담당자여부'  ,type:'string'	, comboType:'AU',comboCode:'A020'	,allowBlank: false},
				 {name: 'REMARK' 			,text:'<t:message code="system.label.base.remarks" default="비고"/>' 				,type:'string'	}
			]
	});
	
  

	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('bcm104skrvSearchForm',{
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
		defaults: {
			autoScroll:true
	  	},
		items:[{
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',   			
	    	items:[{	    
				fieldLabel: '거래처코드',
				name: 'CUSTOM_CODE',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CUSTOM_CODE', newValue);
					}
				}
			},{
			    fieldLabel: '거래처명',
				name: 'CUSTOM_NAME',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CUSTOM_NAME', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.base.classfication" default="구분"/>',
				name: 'CUSTOM_TYPE' ,
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'B015',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CUSTOM_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '고객분류'    ,
				name: 'AGENT_TYPE' ,
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'B055' ,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('AGENT_TYPE', newValue);
					}
				}
			}]
		}, {			
		 	title:'<t:message code="system.label.base.additionalinfo" default="추가정보"/>',
   			id: 'search_panel2',
			itemId:'search_panel2',
        	defaultType: 'uniTextfield',
        	layout: {type: 'uniTable', columns: 1},
		 	items: [{
				fieldLabel: '지역',
				name: 'AREA_TYPE' ,
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'B056'
			},{
				fieldLabel: '주영업담당',
				name: 'BUSI_PRSN' ,          
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'S010' 
			},{
				fieldLabel: '법인/개인',
				name: 'BUSINESS_TYPE' ,
				xtype: 'uniCombobox' ,
				comboType: 'AU',
				comboCode: 'B016' 
			},{
			    xtype: 'radiogroup',
			    fieldLabel: '<t:message code="system.label.base.photoflag" default="사진유무"/>',
			    items : [{
			    	boxLabel: '예',
			    	name: 'USE_YN' ,
			    	inputValue: 'Y',
			    	width:95,
			    	checked: true
			    }, {boxLabel: '아니오',
			    	name: 'USE_YN',
			    	inputValue: 'N',
			    	width:85
			    }]				
			},{
				fieldLabel: '대표자명'     ,
				name: 'TOP_NAME'
			},{
				fieldLabel: '사업자번호',
				name: 'COMPANY_NUM'
		    },{
				fieldLabel: '종사업자번호',
				name: 'SERVANT_COMPANY_NUM'
		    },{
				fieldLabel: '사업자번호체크' ,
				name: 'CHK_COMPANY_NUM' ,
				xtype: 'checkboxfield'                  
	    	},{
				fieldLabel: '<t:message code="system.label.base.companycode" default="법인코드"/>' ,
				name: 'COMP_CODE' ,
				hidden: true               
	    	}]	            			             			 
		}]
	});	//end panelSearch    
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		weight:-100,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{	    
			fieldLabel: '거래처코드',
			labelWidth: 97,
			name: 'CUSTOM_CODE',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CUSTOM_CODE', newValue);
				}
			}
		},{
		    fieldLabel: '거래처명',
			name: 'CUSTOM_NAME',
			labelWidth: 94,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CUSTOM_NAME', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.base.classfication" default="구분"/>',
			name: 'CUSTOM_TYPE' ,
			xtype: 'uniCombobox' ,
			comboType: 'AU',
			comboCode: 'B015',
			listeners: {
						labelWidth: 295,
			width: 464,
	change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CUSTOM_TYPE', newValue);
				}
			}
		},{
			fieldLabel: '고객분류'    ,
			name: 'AGENT_TYPE' ,
			xtype: 'uniCombobox' ,
			comboType: 'AU',
			comboCode: 'B055' ,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('AGENT_TYPE', newValue);
				}
			}
		}]	
    });
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('bcm104skrvGrid', {
    	region:'center',
    	store: directMasterStore,
        layout : 'fit',
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
        border:true,
//        tbar: [
//	            {
//	        	text:'상세보기',
//	        	handler: function() {
//	        		var record = masterGrid.getSelectedRecord();
//		        	if(record) {
//		        		openDetailWindow(record);
//		        	}
//	        	}
//        }],
		columns:[{dataIndex:'CUSTOM_CODE'		,width:80, hideable:false, isLink:true},
				 {dataIndex:'CUSTOM_TYPE'		,width:80, hideable:false},
				 {dataIndex:'CUSTOM_FULL_NAME'	,width:170},
				 {dataIndex:'CUSTOM_NAME'		,width:170,hideable:false},
				 {dataIndex:'CUSTOM_NAME1'		,width:150	, hidden:true},
				 {dataIndex:'CUSTOM_NAME2'		,width:150	, hidden:true},
				 {dataIndex:'COMPANY_NUM'		,width:100},
				 {dataIndex:'TOP_NUM'			,width:100	, hidden:true},
				 {dataIndex:'TOP_NAME'			,width:100},
				 {dataIndex:'BUSINESS_TYPE'		,width:80	, hidden:true},
				 {dataIndex:'USE_YN'			,width:60	, hidden:true},
				 {dataIndex:'COMP_TYPE'			,width:140},
				 {dataIndex:'COMP_CLASS'		,width:140},
				 {dataIndex:'AGENT_TYPE'		,width:120},
				 {dataIndex:'AGENT_TYPE2'		,width:80	, hidden:true},
				 {dataIndex:'AGENT_TYPE3'		,width:80	, hidden:true},
				 {dataIndex:'NATION_CODE'		,width:130	, hidden:true},
				 {dataIndex:'AREA_TYPE'			,width:80	, hidden:true},
				 {dataIndex:'ZIP_CODE'			, hidden : true
					,'editor' : Unilite.popup('ZIP_G',{
			  						autoPopup: true,
			  						listeners: {
						                'onSelected': {
						                    fn: function(records, type  ){
						                    	var me = this;
						                    	var grdRecord = Ext.getCmp('bcm104skrvGrid').uniOpt.currentRecord;
						                    	grdRecord.set('ADDR1',records[0]['ZIP_NAME']);
						                    	grdRecord.set('ADDR2',records[0]['ADDR2']);
						                    },
						                    scope: this
						                },
						                'onClear' : function(type){
						                		var me = this;
						                    	var grdRecord = Ext.getCmp('bcm104skrvGrid').uniOpt.currentRecord;
						                    	grdRecord.set('ADDR1','');
						                    	grdRecord.set('ADDR2','');
						                }
						            }
								})},
				 {dataIndex:'ADDR1'				,width:200	, hidden:true},
				 {dataIndex:'ADDR2'				,width:200	, hidden:true},
				 {dataIndex:'TELEPHON'			,width:80},
				 {dataIndex:'FAX_NUM'			,width:80	, hidden:true},
				 {dataIndex:'HTTP_ADDR'			,width:140	, hidden:true},
				 {dataIndex:'MAIL_ID'			,width:100	, hidden:true},
				 {dataIndex:'WON_CALC_BAS'		,width:80	, hidden:true},
				 {dataIndex:'START_DATE'		,width:80	, hidden:true},
				 {dataIndex:'STOP_DATE'			,width:80	, hidden:true},
				 {dataIndex:'TO_ADDRESS'		,width:140	, hidden:true},
				 {dataIndex:'TAX_CALC_TYPE'		,width:90	, hidden:true},				 
				 {dataIndex:'RECEIPT_DAY'		,width:120	, hidden:true},
				 {dataIndex:'MONEY_UNIT'		,width:130	, hidden:true},
				 {dataIndex:'TAX_TYPE'			,width:90	, hidden:true},
				 {dataIndex:'BILL_TYPE'			,width:120	, hidden:true},
				 {dataIndex:'SET_METH'			,width:90	, hidden:true},
				 {dataIndex:'VAT_RATE'			,width:60	, hidden:true},
				 {dataIndex:'TRANS_CLOSE_DAY'	,width:90	, hidden:true},
				 {dataIndex:'COLLECT_DAY'		,width:90	, hidden:true},
				 {dataIndex:'CREDIT_YN'			,width:80	, hidden:true},
				 {dataIndex:'TOT_CREDIT_AMT'	,width:90	, hidden:true},
				 {dataIndex:'CREDIT_AMT'		,width:80	, hidden:true},
				 {dataIndex:'CREDIT_YMD'		,width:80	, hidden:true},
				 {dataIndex:'COLLECT_CARE'		,width:80	, hidden:true},
				 {dataIndex:'SAP_CODE'			,width:80	, hidden:true},
				 {dataIndex:'BUSI_PRSN'			,width:90	, hidden:true},
//				 {dataIndex:'CAL_TYPE'			,width:80	, hidden:true},
				 {dataIndex:'TAX_CALC_ORDER'	,width:80	, hidden:true},
				 {dataIndex:'MODIFY_REASON'		,width:200	},
				 {dataIndex:'REMARK'			,width:150	, flex:1},
				 {dataIndex:'MANAGE_CUSTOM'		,width:140	, hidden:true},
				 {dataIndex:'MCUSTOM_NAME'		,width:140	, hidden:true
//					,'editor' : Unilite.popup('CUST_G',{						            
//				    				textFieldName:'MCUSTOM_NAME',
//				    				listeners: {
//						                'onSelected':  function(records, type  ){
//						                    	//var grdRecord = masterGrid.getSelectedRecord();
//						                    	var grdRecord = masterGrid.uniOpt.currentRecord;
//						                    	grdRecord.set('MANAGE_CUSTOM',records[0]['CUSTOM_CODE']);
//						                }
//						                ,'onClear':  function( type  ){
//						                    	//var grdRecord = masterGrid.getSelectedRecord();
//						                    	var grdRecord = masterGrid.uniOpt.currentRecord;
//						                    	grdRecord.set('MCUSTOM_NAME','');
//						                    	grdRecord.set('MANAGE_CUSTOM','');
//						                }
//						            } // listeners
//								}) 		
				},
				
				 {dataIndex:'COLLECTOR_CP_NAME'	,width:140	, hidden:true
//					,'editor' : Unilite.popup('CUST_G',	{				            
//				    					textFieldName:'COLLECTOR_CP_NAME', 
//					    				listeners: {
//							                'onSelected':  function(records, type  ){
//							                    	var grdRecord = masterGrid.uniOpt.currentRecord;
//							                    	grdRecord.set('COLLECTOR_CP',records[0]['CUSTOM_CODE']);
//							                   
//							                },
//							                'onClear':  function( type  ){
//							                    	//var grdRecord = masterGrid.getSelectedRecord();
//							                    	var grdRecord = masterGrid.uniOpt.currentRecord;
//							                    	grdRecord.set('COLLECTOR_CP_NAME','');
//							                    	grdRecord.set('COLLECTOR_CP','');
//							                }
//							            } // listeners
//								}) 		
				},
				 {dataIndex:'BANK_NAME',  width: 100   	, hidden: true
//						,'editor' : Unilite.popup('BANK_G',	{			            
//										textFieldName:'BANK_NAME',
//				    					listeners: {
//							                'onSelected': function(records, type  ){
//							                    	var grdRecord = masterGrid.uniOpt.currentRecord;
//							                    	grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
//							                    	grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
//							                },
//							                'onClear':  function( type  ){
//							                    	var grdRecord = masterGrid.uniOpt.currentRecord;
//							                    	grdRecord.set('BANK_NAME','');
//							                    	grdRecord.set('BANK_CODE','');
//							                }
//						            	} // listeners
//								}) 		
					}, 
				        
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
				 {dataIndex:'CUSTOM_SALE_HAND_PHON'		,width:110	, hidden:true},
				 {dataIndex:'CUSTOM_SALE_MAIL_ID'		,width:140	, hidden:true},
				 {dataIndex:'ADDR_TYPE'			,width:120	, hidden:true},
				 {dataIndex:'CHANNEL'			,width:80	, hidden:true},
				 {dataIndex:'BILL_CUSTOM_NAME'	,width:120	, hidden:true
//					,'editor' : Unilite.popup('CUST_G',{	            
//										textFieldName:'BILL_CUSTOM_NAME',
//										listeners: {	
//							                'onSelected':  function(records, type  ){
//							                    	var grdRecord = masterGrid.uniOpt.currentRecord;
//							                    	grdRecord.set('BILL_CUSTOM',records[0]['CUSTOM_CODE']);
//							                    
//							                },
//							                'onClear':  function( type  ){
//							                    	var grdRecord = masterGrid.uniOpt.currentRecord;
//							                    	grdRecord.set('BILL_CUSTOM_NAME','');
//							                    	grdRecord.set('BILL_CUSTOM','');
//							                }
//						            	} //listeners
//								}) 		
				 },
				 {dataIndex:'CUST_LEVEL1' 		  ,width:80	, hidden:true},
				 {dataIndex:'SERVANT_COMPANY_NUM' ,width:80	, hidden:true},
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
				 {dataIndex:'UNPAY_AMT'			  ,width:80	, hidden:true},
				 {dataIndex:'STOCK_I'			  ,width:80	, hidden:true},
				 {dataIndex:'BALANCE_DATE'		  ,width:80	, hidden:true},
				 {dataIndex:'BALANCE_PRSN'		  ,width:80	, hidden:true}
          ] 
         /* ,listeners: {	
          		selectionchange: function( grid, selected, eOpts ) {
          			var detailForm = Ext.getCmp('detailForm');
          			detailForm.setActiveRecord(selected[0] || null);  
          			
          			//전자문서정보 Tab 거래처정보 Load (그리드 상단) 
          			Ext.getCmp('eBillSearchForm').setActiveRecord(selected[0] || null);
          			//추가정보 Tab의 Data Load
          			Ext.getCmp('bcm104skrvEBillDetail').setActiveRecord(selected[0] || null);  
  				}
	        	//,validateedit : function(editor, e)  {UniApp.getApp().fnGrdValidedite(e);}
         }*/
         , 
         selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
         listeners: {          	
          	selectionchangerecord:function(selected)	{
          		detailForm.setActiveRecord(selected)
          	},
          	onGridDblClick:function(grid, record, cellIndex, colName) {
          		if(!record.phantom) {
	      			switch(colName)	{
					case 'CUSTOM_CODE' :
//							var record = masterGrid.getSelectedRecord();
//							var param = {COMP_CODE: UserInfo.compCode, CUSTOM_CODE: record.get('CUSTOM_CODE')}
//							bcm104skrvService.getUnPayAmt(param, function(provider, response)	{
//								if(!Ext.isEmpty(provider)){
//									detailForm.setValue('UNPAY_AMT', provider[0].UNPAY_AMT);
//									detailForm.setValue('STOCK_I', provider[0].STOCK_I);
//								}
//							});
							masterGrid.hide();
							break;		
					default:
							break;
	      			}
          		}
          	},
          	beforehide: function(grid, eOpts )	{
   				grid.getEditor().completeEdit();
   			},
			hide:function()	{
				detailForm.show();
			},
			beforeedit  : function( editor, e, eOpts ) {
      			if(e.record.phantom && e.field =='MODIFY_REASON'){			//신규일때 변경이력 수정 불가     
      				return false;
      			}
			}
          } 
    });
    
    /**
     * 상세 조회(Detail Form Panel)
     * @type 
     */
    
    var detailForm = Unilite.createForm('detailForm', {
    	//region:'south',
    	//weight:-100,
    	//height:400,
    	//split:true,
//		disabled:false,
    	hidden: true,
    	autoScroll: true,
    	flex:1,
    	masterGrid: masterGrid,
        padding: '0 0 0 1',
	    layout: {type: 'uniTable', columns: 3, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
	    defaultType: 'uniFieldset',
	    defaults : { margin: '0 0 0 0'},
	    items : [{
    		xtype: 'container',
    		colspan: 4,
    		layout: {type: 'vbox', align: 'stretch'},
    		items: [{
    			xtype: 'container',
    			layout: { type: 'uniTable', columns: 4},
    			defaultType: 'uniTextfield',
    			defaults : {enforceMaxLength: true, readOnly: true},
    			items:[{
					fieldLabel: '거래처코드',
					name: 'CUSTOM_CODE' ,
					allowBlank: false,
					readOnly:true
				},{
					fieldLabel: '거래처명(전명)', 
					name: 'CUSTOM_FULL_NAME',
					allowBlank: false,
					labelWidth: 180
				},{
					fieldLabel: '약명1',
					name: 'CUSTOM_NAME1',					
					labelWidth: 331
//					width: 464
				}, {
					text: '취급품목',
					xtype: 'button',
					margin: '0 0 0 10',
					handler: function(){    	
//						getWindowX = this.getX()-390;
//				   		getWindowY = this.getY()+22;
						if(!Ext.isEmpty(detailForm.getValue('CUSTOM_CODE'))){
							openPurchaseItemSearchWindow();
						}						
					}
				}]
    		}, {
	    			xtype: 'container',
	    			layout: { type: 'uniTable', columns: 3},
	    			defaultType: 'uniTextfield',
	    			defaults : {enforceMaxLength: true, readOnly: true},
	    			items:[{
					fieldLabel: '거래처명(약명)',
					name: 'CUSTOM_NAME',
					labelWidth: 418,
					allowBlank: false,
					width: 685
				},{
						fieldLabel: '약명2', 
						name: 'CUSTOM_NAME2',
						labelWidth: 219
//						width: 342
					}]
	    		}]
	    },
	    	
	    		{ 
        			  title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>'
        			, defaults: {type: 'uniTextfield', enforceMaxLength: true, labelWidth: 140, readOnly: true}
        			, layout: { type: 'uniTable', columns: 1}
        			, height: 520
        			, width: 370
        			, items :[{
						fieldLabel: '<t:message code="system.label.base.classfication" default="구분"/>',
						name: 'CUSTOM_TYPE',
						xtype: 'uniCombobox',
						comboType:'AU',
						comboCode:'B015' ,
						allowBlank: false,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								detailForm.setValue('CUST_LEVEL1', UniAppManager.app.fnGetRefCode(newValue))
//								Unilite.messageBox(UniAppManager.app.fnGetRefCode(newValue));
							}
						}
					},{
						fieldLabel: '고객분류',
						name: 'AGENT_TYPE',
						xtype : 'uniCombobox',
						allowBlank: false,
						comboType:'AU',
						comboCode:'B055'
					},{
						fieldLabel: '고객구분',
						name: 'CUST_LEVEL1',
						xtype : 'uniCombobox',
						comboType:'AU',
						comboCode:'B111'
					},{
						fieldLabel: '법인/개인', 
						name: 'BUSINESS_TYPE', 
						xtype: 'uniCombobox', 
						comboType:'AU',
						comboCode:'B016'
					},{
						xtype: 'component',
						height: 15
					},{
						fieldLabel: '사업자번호',
						name: 'COMPANY_NUM',
						listeners : { blur: function( field, The, eOpts )	{
						  					var newValue = field.getValue().replace(/-/g,'');		
						  					if(!Ext.isNumeric(newValue) && !Ext.isEmpty(newValue))	{	
						  						Unilite.messageBox(Msg.sMB074);
									 			detailForm.setValue('COMPANY_NUM', field.originalValue);
									 			return;
											 }
						  					if(!Ext.isEmpty(newValue) && !(field.originalValue == field.getValue()) )	{
							  					if(Ext.isNumeric(newValue)) {
													var a = newValue;
													var i = (a.substring(0,3)+ "-"+ a.substring(3,5)+"-" + a.substring(5,10));
													if(a.length == 10){
														detailForm.setValue('COMPANY_NUM',i);
													}else{
														detailForm.setValue('COMPANY_NUM',a);
													}													
											 	}							  					
							  					if(Unilite.validate('bizno', newValue) != true)	{
											 		if(!confirm(Msg.sMB173+"\n"+Msg.sMB175+"\n"+"거래처코드 : "+ detailForm.getValue('CUSTOM_CODE')))	{									 		 
											 			detailForm.setValue('COMPANY_NUM', field.originalValue);
											 		}
											 	}
						  					}
										 	
						  				}
						  			 }
		//				listenersX : { blur : function (e, valid){
		//			   							    var frm = Ext.getCmp('detailForm');
		//			   								frm.setValue('CUST_CHK','T');
		//			   								if (e.value.trim().length > 0 )	{
		//											 	console.log("COMPANY_NUM.Unilite.validate('bizno',e.value.trim()) : " , e.value.trim());
		//											 	if(Unilite.validate('bizno',e.value.trim()) != true)	{
		//											 		if(!confirm(Msg.sMB173+"\n"+Msg.sMB175))	{
		//											 			frm.setValue('COMPANY_NUM',e.originalValue);
		//											 			
		//											 		}
		//											 	}
		//											 }
		//			   						}
		//				   	
		//				   				}
					},{
						fieldLabel: '대표자명',
						name: 'TOP_NAME'
					},{
						fieldLabel: '주민번호', 
						name: 'TOP_NUM'
					},{
						fieldLabel: '업태',
						name: 'COMP_TYPE'
					},{
						fieldLabel: '업종',
						name: 'COMP_CLASS'
					},{
						fieldLabel: '지역',
						name: 'AREA_TYPE',
						xtype : 'uniCombobox',
						comboType:'AU',
						comboCode:'B056' 
					},{
						fieldLabel: '반품처',
						name: 'RETURN_CODE',
						xtype : 'uniCombobox',
						comboType:'AU',
						comboCode:'YP04' 
					},{
						xtype: 'component',
						height: 15
					},{
						fieldLabel: '거래시작일',
						name: 'START_DATE' ,
						xtype : 'uniDatefield', 
						allowBlank:false
					},{
						fieldLabel: '거래중단일',  
						name: 'STOP_DATE',
						xtype : 'uniDatefield'
					},{
						fieldLabel: '최종수정일',  
						name: 'UPDATE_DB_TIME',
						xtype : 'uniDatefield',
						readOnly: true
					},{
					    xtype: 'radiogroup',
					    fieldLabel: '<t:message code="system.label.base.useyn" default="사용여부"/>',	
					    items : [{
					    	boxLabel: '예',
					    	name: 'USE_YN' ,
					    	inputValue: 'Y',
					    	width:95,
			    			readOnly: true
					    }, {boxLabel: '아니오',
					    	name: 'USE_YN',
					    	inputValue: 'N',
					    	width:85,
			    			readOnly: true
					    }]				
					},{
						fieldLabel: '사업자번호변경여부',
						name: 'CUST_CHK',
						hidden:true
					},{
						fieldLabel: '주민번호변경여부',  
						name: 'SSN_CHK', hidden:true
					}]
	    		}
	    	   ,{   title: '업무정보'
        			, layout: {
					            type: 'uniTable',
					            columns: 1
					        }
        			, defaults: {type: 'uniTextfield', enforceMaxLength: true, labelWidth: 140, readOnly: true}
        			, height: 520
        			, width: 370
        			, items :[{
						fieldLabel: '국가코드',
						name: 'NATION_CODE',
						xtype : 'uniCombobox',
						comboType:'AU',
						comboCode:'B012'
						
					},{
						fieldLabel: '기준화폐',
						name: 'MONEY_UNIT',
						xtype : 'uniCombobox',
						comboType:'AU',
						fieldStyle: 'text-align: center;',
						comboCode:'B004',
		 				displayField: 'value'
					},{
						fieldLabel: '세액포함여부',
						name: 'TAX_TYPE',
						xtype: 'uniRadiogroup', 
						width: 345, 
						comboType:'AU',
						comboCode:'B030',
						value:'1' , 
						allowBlank:false,
			    		readOnly: true/*,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								if(newValue.TAX_TYPE == '2'){
									if(detailForm.getValue('TAX_CALC_TYPE').TAX_CALC_TYPE == '1'){
										detailForm.setValue('TAX_CALC_TYPE', '2');
									}
									detailForm.getField('TAX_CALC_TYPE').setReadOnly(true);
								}else{
									detailForm.getField('TAX_CALC_TYPE').setReadOnly(false);
								}
																
							}
						}*/
					},{
						fieldLabel: '세액계산방법',
						name: 'TAX_CALC_TYPE',
						xtype: 'uniRadiogroup',
						width: 345, comboType:'AU',
						comboCode:'B051',
						allowBlank:false,
			    		readOnly: true 
					},{
	            		xtype: 'radiogroup',
	            		fieldLabel: '세액계산순서',
	            		items : [{boxLabel  : '공급가',  name: 'TAX_CALC_ORDER', inputValue: '2', width:95, readOnly: true }
	                    		,{boxLabel  : '부가세', name: 'TAX_CALC_ORDER' , inputValue: '1', readOnly: true}
                    	]
                    },{
						fieldLabel: '원미만계산',
						name: 'WON_CALC_BAS',
						xtype : 'uniCombobox',
						comboType:'AU',
						comboCode:'B017'
					},{
						fieldLabel: '세율',
						name: 'VAT_RATE',
						minWidth:50, 
						suffixTpl:'&nbsp;%' ,
						xtype:'uniNumberfield'
					},{
						fieldLabel: '계산서종류',
						name: 'BILL_TYPE',
						xtype : 'uniCombobox',
						comboType:'AU',
						comboCode:'YP36'
					},{
						xtype: 'component',
						height: 15
					},{
						xtype: 'uniDatefield',
						name: 'BALANCE_DATE',
						fieldLabel: '장부대조일자',
						readOnly: true
					},{
						xtype: 'uniCombobox',
						name: 'BALANCE_PRSN',
						fieldLabel: '대조자(서점)',						
						readOnly: true,
						comboType:'AU',
						comboCode:'M201'  
					},{
						xtype: 'component',
						height: 15
					},{
						fieldLabel: '주영업담당',
						name: 'BUSI_PRSN', 
						xtype : 'uniCombobox',
						comboType:'AU',
						comboCode:'S010'  
					}/*,{
						fieldLabel: '카렌더타입',
						name: 'CAL_TYPE',
						xtype : 'uniCombobox',
						comboType:'AU',
						comboCode:'B062'  
					}*/,{
						xtype: 'component',
						height: 15
					},{
					    xtype: 'radiogroup',
					    fieldLabel: '여신초과진행여부',	
//					    name: 'CREDIT_OVER_YN',
					    items : [{
					    	boxLabel: '예',
					    	name: 'CREDIT_OVER_YN' ,
					    	inputValue: 'Y',
					    	width:95,
			    			readOnly: true
					    }, {boxLabel: '아니오',
					    	name: 'CREDIT_OVER_YN',
					    	inputValue: 'N',
					    	width:85,
					    	checked: true,
			    			readOnly: true
					    }]				
					},{
						fieldLabel: '신용여신액',
						name: 'CREDIT_AMT',
						xtype:'uniNumberfield'
					},{
						fieldLabel: '신용여신만료일',
						name: 'CREDIT_YMD',
						xtype : 'uniDatefield'
					},{
						fieldLabel: '변경사유', 
						name: 'MODIFY_REASON',
						xtype:'textarea'						
//						height:70
					}]
	    		}
	    		,{  title: '지불정보'
	    			,autoScroll : Boolean
	    			, layout: {
					            type: 'uniTable',
					            columns: 1
					        }
        			, defaults: {type: 'uniTextfield', enforceMaxLength: true, labelWidth: 140, readOnly: true}
        			, height: 520
        			, width: 371
        			,items :[
        				Unilite.popup('BANK',{
							fieldLabel: '은행',
							id:'BANK_CODE',
							valueFieldName:'BANK_CODE',
							textFieldName:'BANK_NAME' ,
							DBvalueFieldName:'BANK_CODE',
							DBtextFieldName:'BANK_NAME',
							textFieldWidth:89,
							listeners: {
				                'onSelected': function(records, type  ){
				                    	var grdRecord = masterGrid.getSelectedRecord();
				                    	grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
				                    	grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
				                },
				                'onClear':  function( type  ){
				                    	var grdRecord = masterGrid.getSelectedRecord();
				                    	grdRecord.set('BANK_CODE','');
				                    	grdRecord.set('BANK_NAME','');
				                }
							}
					}),{
						fieldLabel: '계좌번호', 
						name: 'BANKBOOK_NUM',
						colspan:2
					},{
						fieldLabel: '예금주',
						name: 'BANKBOOK_NAME',
						colspan:2
					},{
						xtype: 'component',
						height: 15
					},{
						fieldLabel: '수금(지불)일',
						name: 'COLLECT_DAY', 
						xtype : 'uniTagfield',
						comboType:'AU',
						comboCode:'YP35',
						delimiter:',',
						multiSelect: true,
						typeAhead: false,
						width: 295
						
					},{
						fieldLabel: '결제조건', 
						name: 'RECEIPT_DAY',
						xtype : 'uniCombobox',
						comboType:'AU',
						comboCode:'B034'
					},{
						fieldLabel: '결제방법',
						name: 'SET_METH', 
						xtype : 'uniCombobox',
						comboType:'AU',
						comboCode:'B038'
					},{
						fieldLabel: '마감구분',
						name: 'TRANS_CLOSE_DAY', 
						xtype : 'uniCombobox',
						comboType:'AU',
						comboCode:'B033'
					},{
						xtype: 'component',
						height: 15
					},{
					    xtype: 'radiogroup',
					    fieldLabel: '여신/한도적용여부',	
					    items : [{
					    	boxLabel: '예',
					    	name: 'CREDIT_YN' ,
					    	inputValue: 'Y',
					    	width:95,
					    	checked: true,
					    	readOnly: true
					    }, {boxLabel: '아니오',
					    	name: 'CREDIT_YN',
					    	inputValue: 'N',
					    	width:85,
					    	readOnly: true
					    }],
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {						
								if(newValue.CREDIT_YN == 'N'){
									if(detailForm.getValue('CREDIT_OVER_YN')){
										detailForm.getField('CREDIT_OVER_YN').setValue('N');
//										Unilite.messageBox(detailForm.getValue('CREDIT_OVER_YN'));
									}
									detailForm.getField('CREDIT_OVER_YN').setReadOnly(true);
								}else{
									detailForm.getField('CREDIT_OVER_YN').setReadOnly(false);
								}
//								if(newValue.CREDIT_YN == 'N'){
//									if(detailForm.getValue('CREDIT_OVER_YN')){
//										detailForm.getField('CREDIT_OVER_YN').setValue('N');
//									}									
//								}
							}
						}				
					},{
						fieldLabel: '여신/한도액',
						name: 'TOT_CREDIT_AMT',
						xtype:'uniNumberfield'
					},{
						xtype: 'component',
						height: 15
					}, {
						text: '현미지급/현재고금액조회',
						xtype: 'button',
						margin: '0 0 0 144',
						handler: function(){    	
							getWindowX = this.getX()-248;
					   		getWindowY = this.getY()+22;
							if(!Ext.isEmpty(detailForm.getValue('CUSTOM_CODE'))){
								openUnPayAmtSearchWindow();
							}						
						}
					}
				/*,{
						xtype: 'uniNumberfield',
						name: 'UNPAY_AMT',
						fieldLabel: '현미지급',
						readOnly: true
					},{
						xtype: 'uniNumberfield',
						name: 'STOCK_I',
						fieldLabel: '현재고금액',
						readOnly: true
					}*/,{
						xtype: 'uniTextfield',
						name: '',
						fieldLabel: '기준매입율',
						suffixTpl:'&nbsp;%' ,
						hidden: true
					},{
						xtype: 'component',
						height: 15
					},{
						fieldLabel: '미수관리방법',
						name: 'COLLECT_CARE',
						xtype : 'uniCombobox',
						comboType:'AU',
						comboCode:'B057',
						allowBlank: false
					},{
						fieldLabel: 'SAP등록코드',
						name: 'SAP_CODE',
						xtype : 'uniTextfield'
					}/*,					
					
					{
						fieldLabel: '거래조건',
						name: 'TRANS_CLOSE_DAY',
						xtype : 'uniCombobox',
						comboType:'AU',
						comboCode:'B033'
					},{
						xtype: 'uniTextfield',
						name: '',
						fieldLabel: '대조자(업체)'
					}*/]
	    		}, { 
	    			title: '<t:message code="system.label.base.generalinfo" default="일반정보"/>',
	    			colspan: 4,
	    			layout: {type: 'uniTable', columns: 1},
	    			items :[{
        				xtype: 'container',
        				layout: {type: 'uniTable', columns: 4},
        				defaults: {type: 'uniTextfield', enforceMaxLength: true, readOnly: true},
        				items: [
	        				Unilite.popup('ZIP',{
							showValue:false,
							textFieldName:'ZIP_CODE',
							DBtextFieldName:'ZIP_CODE',
							textFieldWidth: 150,
							listeners: { 'onSelected': {
							                    fn: function(records, type  ){
							                    	var frm = Ext.getCmp('detailForm');
							                    	frm.setValue('ADDR1', records[0]['ZIP_NAME']);
							                    	frm.setValue('ADDR2', records[0]['ADDR2']);
							                    	//console.log("(records[0]['ZIP_CODE1_NAME'] : ", records[0]['ZIP_CODE1_NAME']);
							                    	//Ext.getCmp('ADDR2_F').setValue(records[0]['ADDR2']);
							                    },
							                    scope: this
							                  },
							                  'onClear' : function(type)	{
							                  		var frm = Ext.getCmp('detailForm');
							                    	frm.setValue('ADDR1', '');
							                    	frm.setValue('ADDR2', '');
							                  }
							}
						}),{
							xtype: 'uniTextfield',
						  	fieldLabel: '우편주소', 
						  	name: 'ADDR1' , 
						  	id :'ADDR1_F'
						},{
							xtype: 'uniTextfield',
							fieldLabel: '상세주소',
							name: 'ADDR2',
							id:'ADDR2_F',
							colspan: 2,
							width: 471
						},{
							xtype: 'component',
							height: 15
						},{
							xtype: 'uniTextfield',
							fieldLabel: '전화번호',
							name: 'TELEPHON'
						},{
							xtype: 'uniTextfield',
							fieldLabel: '팩스',
							name: 'FAX_NUM'
						},{
							xtype: 'uniTextfield',
							fieldLabel: '홈페이지',
							name: 'HTTP_ADDR'
						},{
							xtype: 'component',
							height: 15,
							colspan: 4
						},{
							xtype: 'uniTextfield',
						 	fieldLabel: '전자문서담당',
						 	name: 'BILL_PRSN',
						 	tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 15px;' }
						 },{
						 	xtype: 'uniTextfield',
						 	fieldLabel: '핸드폰',
						 	name: 'HAND_PHON',
						 	tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 15px;' }
						 	
						 },{
						 	xtype: 'uniTextfield',
						 	fieldLabel: 'e-MAIL',
						 	name: 'BILL_MAIL_ID',
						 	tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 15px;' }
						 },{
						 	fieldLabel: '전자문서구분',
						 	name: 'BILL_MEM_TYPE',
						 	xtype : 'uniCombobox',
						 	comboType:'AU',
						 	comboCode:'S051',
						 	colspan:2,
						 	tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 15px;' }
						 },{
							xtype: 'uniTextfield',
						 	fieldLabel: '영업담당',
						 	name: 'CUSTOM_SALE_PRSN',
						 	tdAttrs: {style: 'border-bottom: 1px solid #cccccc; padding-bottom: 15px'  }
						 },{
						 	xtype: 'uniTextfield',
						 	fieldLabel: '핸드폰',
						 	name: 'CUSTOM_SALE_HAND_PHON',
						 	tdAttrs: {style: 'border-bottom: 1px solid #cccccc; padding-bottom: 15px'  }
						 	
						 },{
						 	xtype: 'uniTextfield',
						 	fieldLabel: 'e-MAIL',
						 	name: 'CUSTOM_SALE_MAIL_ID',
						 	colspan: 2,
						 	tdAttrs: {style: 'border-bottom: 1px solid #cccccc; padding-bottom: 15px'  }
						 },{
							xtype: 'component',
							height: 15,
							colspan: 4
						},
						Unilite.popup('CUST',{
							fieldLabel: '집계거래처', /* id:'MANAGE_CUSTOM', */
							valueFieldName:'MANAGE_CUSTOM',
							textFieldName:'MCUSTOM_NAME',			  
							listeners: {
				                'onSelected': function(records, type  ){
				                    	var grdRecord = masterGrid.getSelectedRecord();
				                    	grdRecord.set('MANAGE_CUSTOM',records[0]['CUSTOM_CODE']);
				                    	grdRecord.set('MCUSTOM_NAME',records[0]['CUSTOM_NAME']);
				                },
				                'onClear':  function( type  ){
				                    	var grdRecord = masterGrid.getSelectedRecord();
				                    	grdRecord.set('MANAGE_CUSTOM','');
				                    	grdRecord.set('MCUSTOM_NAME','');
				                }
							}
			  			}),
						Unilite.popup('CUST',{
							fieldLabel: '수금거래처', 
							valueFieldName:'COLLECTOR_CP',
							textFieldName:'COLLECTOR_CP_NAME',
							listeners: {
				                'onSelected': function(records, type  ){
				                    	var grdRecord = masterGrid.getSelectedRecord();
				                    	grdRecord.set('COLLECTOR_CP',records[0]['CUSTOM_CODE']);
				                    	grdRecord.set('COLLECTOR_CP_NAME',records[0]['CUSTOM_NAME']);
				                },
				                'onClear':  function( type  ){
				                    	var grdRecord = masterGrid.getSelectedRecord();
				                    	grdRecord.set('COLLECTOR_CP','');
				                    	grdRecord.set('COLLECTOR_CP_NAME','');
				                }
							}
						}),{
				        	fieldLabel: '<t:message code="system.label.base.mainwarehouse" default="주창고"/>',
				        	name: 'WH_CODE',
				        	xtype:'uniCombobox',
				        	store: Ext.data.StoreManager.lookup('whList')
				        },{
							xtype: 'component',
							height: 15
						},{
							xtype: 'uniTextfield',
							fieldLabel: '배송처담당자',
							name: 'DVRY_PRSN'
						},{
							xtype: 'uniTextfield',
							fieldLabel: '연락처',
							name: 'DVRY_PHON'
						},{
							xtype: 'uniNumberfield',
							fieldLabel: '배송L/T',
							name: 'DVRY_LT',
							colspan: 2
						},{
							xtype: 'uniCombobox',
							fieldLabel: '출판분야',
							name: 'PUBLICATION_FLD1',
						 	comboType:'AU',
						 	comboCode:'YP03'
						},{
							xtype: 'uniCombobox',
							fieldLabel: ' ',
							name: 'PUBLICATION_FLD2',
						 	comboType:'AU',
						 	comboCode:'YP03'
						},{
							xtype: 'uniCombobox',
							fieldLabel: ' ',
							name: 'PUBLICATION_FLD3',
						 	comboType:'AU',
						 	comboCode:'YP03',
						 	colspan: 2
						}/*,{
							fieldLabel: '카드번호', 
							name: 'CARD_NO1',
							xtype:'uniTextfield'
						},{ 
							fieldLabel: ' ',
							name: 'CARD_NO2',
							xtype:'uniTextfield'
						},{ 
							fieldLabel: ' ',
							name: 'CARD_NO3',
							xtype:'uniTextfield'
						},{ 
							fieldLabel: ' ',
							name: 'CARD_NO4',
							xtype:'uniTextfield'
						}*/]
        				
        			}, {
        				colspan: 3,
        				xtype: 'container',
        				layout: {type: 'uniTable', columns: 5},
        				items: []
        			}, {
        				xtype: 'container',
        				layout: {type: 'uniTable', columns: 1},
        				padding: '0 0 10 0',
        				items: [{
							fieldLabel: '<t:message code="system.label.base.remarks" default="비고"/>', 
							name: 'REMARK',
							xtype:'textarea',
							width:1102,
							height:70,
					    	readOnly: true
						}]
        			}]
	    		}	    		
	    	]
			,loadForm: function(record)	{
   				// window 오픈시 form에 Data load
				this.reset();
				this.setActiveRecord(record || null);   
				this.resetDirtyStatus();				
				
				/*var win = this.up('uniDetailFormWindow');
                if(win) {       // 처음 윈도열때는 윈독 존재 하지 않음.
   				     win.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
                     win.setToolbarButtons(['prev','next'],true);
                }*/
   			},
   			listeners:{
//				beforehide: function(grid, eOpts )	{
//					if(directMasterStore.isDirty() )	{
//						var config={
//							success:function()	{
//								detailForm.hide();
//							}
//						};
//						UniAppManager.app.confirmSaveData(config);
//						return false;
//					}
//				},
				hide:function()	{
					masterGrid.show();
					if(panelSearch.getCollapsed()){		//panelSearch가 닫혀 있으면..
						panelResult.show();
					}
				}
   			}
	});
	
	//취급품목 조회 폼
	var purchaseItemSearchForm = Unilite.createSearchForm('bcm104skrvPurchaseItemSearch', {
        layout :  {type : 'uniTable', columns : 2},
        items :[{ 
			fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120'
		}]
    });
    
	//취급품목 조회 모델
	Unilite.defineModel('bcm104skrvpurchaseItemSearchModel', {
	    fields: [
	    	{name: 'COMP_CODE'				,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'		,type: 'string'},			
			{name: 'ITEM_CODE'				,text: '품번'			,type: 'string'}, 
			{name: 'ITEM_NAME'				,text: '<t:message code="system.label.base.itemname2" default="품명"/>'			,type: 'string'}, 
			{name: 'ITEM_ACCOUNT'			,text: '<t:message code="system.label.base.itemaccount" default="품목계정"/>'		,type: 'string', comboType:'AU', comboCode:'B020'},
			{name: 'SUPPLY_TYPE'			,text: '<t:message code="system.label.base.procurementclassification" default="조달구분"/>'		,type: 'string', comboType:'AU', comboCode:'B014'},
			{name: 'STOCK_CARE_YN'			,text: '재고관리여부'	,type: 'string', comboType:'AU',comboCode:'B010'},
			{name: 'SALE_BASIS_P'			,text: '판매가'		,type: 'uniUnitPrice'},
			{name: 'PURCHASE_P'				,text: '매입가'		,type: 'uniUnitPrice'}, 
			{name: 'PURCHASE_RATE'			,text: '매입률(%)'	,type: 'uniER'}, 
			{name: 'STOCK_Q'				,text: '현재고'		,type: 'uniQty'},
			{name: 'STOCK_I'				,text: '재고금액'		,type: 'uniPrice'},
			{name: 'PUBLISHER'				,text: '출판사'		,type: 'string'},
			{name: 'AUTHOR1'				,text: '저자'			,type: 'string'}
		]
	});
	//취급품목 조회 스토어
    var purchaseItemSearchStore = Unilite.createStore('bcm104skrvpurchaseItemSearchStore', {
			model: 'bcm104skrvpurchaseItemSearchModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	read    : 'bcm104skrvService.selectPurchaseList'
                }
            }
            ,loadStoreRecords : function()	{
            	var param= purchaseItemSearchForm.getValues();
            	param.CUSTOM_CODE = detailForm.getValue('CUSTOM_CODE');
				if(Ext.isEmpty(param.CUSTOM_CODE)){
					return false;
				}
				console.log( param );
				this.load({
					params : param
				});
				var viewNormal = purchaseItemSearchGrid.getView();		
			    viewNormal.getFeature('purchaseItemSearchGridTotal').toggleSummaryRow(true);
			}
	});
	//취급품목 조회 그리드 
    var purchaseItemSearchGrid = Unilite.createGrid('bcm104skrvpurchaseItemSearchGrid', {
        // title: '기본',
        layout : 'fit',
    	store: purchaseItemSearchStore,
		features: [ {id : 'purchaseItemSearchGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
        columns:  [
        	{dataIndex: 'COMP_CODE'				, width: 80, hidden: true},
			{dataIndex: 'ITEM_CODE'				, width: 120},
			{dataIndex: 'ITEM_NAME'				, width: 250},
			{dataIndex: 'ITEM_ACCOUNT'			, width: 80},
			{dataIndex: 'SUPPLY_TYPE'			, width: 80},
			{dataIndex: 'STOCK_CARE_YN'			, width: 90,
			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		       return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
        	}},	
			{dataIndex: 'SALE_BASIS_P'			, width: 80,summaryType: 'average'},
			{dataIndex: 'PURCHASE_P'			, width: 80,summaryType: 'average'},
			{dataIndex: 'PURCHASE_RATE'			, width: 80},
			{dataIndex: 'STOCK_Q'				, width: 80,summaryType: 'sum',tdCls:'x-change-cell'},
			{dataIndex: 'STOCK_I'				, width: 80,summaryType: 'sum',tdCls:'x-change-cell'},
			{dataIndex: 'PUBLISHER'				, width: 130},			
			{dataIndex: 'AUTHOR1'				, width: 100}
          ]         
    });
    
    //취급품목 조회 메인
    function openPurchaseItemSearchWindow() { 
		if(!purchaseItemSearchWindow) {
			purchaseItemSearchWindow = Ext.create('widget.uniDetailWindow', {
                title: '취급품목조회',
                width: 1320,				                
                height: 860,
                layout:{type:'vbox', align:'stretch'},                
                items: [purchaseItemSearchForm, purchaseItemSearchGrid],
                tbar:  ['->',
						        {	itemId : 'saveBtn',
									text: '조회',
									handler: function() {
										purchaseItemSearchStore.loadStoreRecords();
									},
									disabled: false
								},{
									itemId : 'closeBtn',
									text: '닫기',
									handler: function() {
										purchaseItemSearchWindow.hide();
									},
									disabled: false
								}
					    ]
					,
                listeners : {beforehide: function(me, eOpt)	{                							
                							purchaseItemSearchGrid.reset();
    						},
                			 beforeclose: function( panel, eOpts )	{											
                							purchaseItemSearchGrid.reset();
    			 			},
                			 show: function( panel, eOpts )	{            			 	
                			 	purchaseItemSearchForm.setValue('DIV_CODE', UserInfo.divCode);
                			 	purchaseItemSearchStore.loadStoreRecords();
//                			 	purchaseItemSearchWindow.getEl().setXY([getWindowX,getWindowY]);
                			 }
                }
			})
		}
		purchaseItemSearchWindow.center();
		purchaseItemSearchWindow.show();
    }    
	//현미지급금, 현재고금액 조회 모델
	Unilite.defineModel('bcm104skrvUnPayAmtSearchModel', {
	    fields: [
	    	{name: 'COMP_CODE'				,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'		,type: 'string'},			
			{name: 'DIV_CODE'				,text: '<t:message code="system.label.base.division" default="사업장"/>'		,type: 'string', comboType: 'BOR120'}, 
			{name: 'TODAY_IN_AMT_I'			,text: '현미지급'		,type: 'uniPrice'}, 
			{name: 'TODAY_STOCK_I'			,text: '현재고금액'		,type: 'uniPrice'}
		]
	});
	//현미지급금, 현재고금액 조회 스토어
    var unPayAmtSearchStore = Unilite.createStore('bcm104skrvUnPayAmtSearchStore', {
			model: 'bcm104skrvUnPayAmtSearchModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	read    : 'bcm104skrvService.getUnPayAmt'
                }
            }
            ,loadStoreRecords : function()	{
            	var param= {COMP_CODE: UserInfo.compCode, CUSTOM_CODE: detailForm.getValue('CUSTOM_CODE')}            	
				if(Ext.isEmpty(param.CUSTOM_CODE)){
					return false;
				}
				console.log( param );
				this.load({
					params : param
				});
				var viewNormal = unPayAmtSearchGrid.getView();		
			    viewNormal.getFeature('unPayAmtSearchGridTotal').toggleSummaryRow(true);
			}
	});
	//현미지급금, 현재고금액 조회 그리드 
    var unPayAmtSearchGrid = Unilite.createGrid('bcm104skrvunPayAmtSearchGrid', {
        // title: '기본',
        layout : 'fit',
    	store: unPayAmtSearchStore,
		features: [ {id : 'unPayAmtSearchGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
        columns:  [
        	{dataIndex: 'COMP_CODE'				, width: 80, hidden: true},
			{dataIndex: 'DIV_CODE'				, width: 150,
			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		       return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
        	}},
			{dataIndex: 'TODAY_IN_AMT_I'		, width: 100, summaryType: 'sum'},
			{dataIndex: 'TODAY_STOCK_I'			, width: 100, summaryType: 'sum'}
          ]         
    });
    
    //현미지급금, 현재고금액 조회 메인
    function openUnPayAmtSearchWindow() { 
		if(!unPayAmtSearchWindow) {
			unPayAmtSearchWindow = Ext.create('widget.uniDetailWindow', {
                title: '현미지급/현재고금액 조회',
                width: 405,				                
                height: 260,
                layout:{type:'vbox', align:'stretch'},                
                items: [unPayAmtSearchGrid],
                tbar:  ['->',
						        {	itemId : 'saveBtn',
									text: '조회',
									handler: function() {
										unPayAmtSearchStore.loadStoreRecords();
									},
									disabled: false
								},{
									itemId : 'closeBtn',
									text: '닫기',
									handler: function() {
										unPayAmtSearchWindow.hide();
									},
									disabled: false
								}
					    ]
					,
                listeners : {beforehide: function(me, eOpt)	{                							
                							unPayAmtSearchGrid.reset();
    						},
                			 beforeclose: function( panel, eOpts )	{											
                							unPayAmtSearchGrid.reset();
    			 			},
                			 show: function( panel, eOpts )	{
//                			 	unPayAmtSearchForm.setValue('DIV_CODE', UserInfo.divCode);
                			 	unPayAmtSearchStore.loadStoreRecords();
                			 	unPayAmtSearchWindow.getEl().setXY([getWindowX,getWindowY]);
                			 }
                }
			})
		}
//		unPayAmtSearchWindow.center();
		unPayAmtSearchWindow.show();
    }
    /*function openModifyReasonWindow() {
		if(!getModifyReasonWindow) {
			getModifyReasonWindow = Ext.create('widget.uniDetailWindow', {
                title: '변경사유',
                resizable:false,
                width: 390,				                
                height:180,
                layout: {type:'uniTable', columns: 1},	                
                items: [modifyReasonSearch],
                bbar:  [ '->',
				        {	itemId : 'searchBtn',
							text: '저장',
							margin: '0 5 0 0',
							handler: function() {
								detailForm.setValue('MODIFY_REASON', modifyReasonSearch.getValue('MODIFY_REASON'))
								directMasterStore.saveStore();
								getModifyReasonWindow.hide();
							},
							disabled: false
						}, {
							itemId : 'closeBtn',
							text: '취소',
							handler: function() {
								getModifyReasonWindow.hide();
							},
							disabled: false
						},'->'
				],
				listeners : {beforehide: function(me, eOpt)	{
											modifyReasonSearch.clearForm();                							
                						},
                			 beforeclose: function( panel, eOpts )	{
											modifyReasonSearch.clearForm();
                			 			},
                			 show: function( panel, eOpts )	{                			 	
                			 	
                			 }
                }		
			})
		}
		getModifyReasonWindow.center();
		getModifyReasonWindow.show();
    }
    var modifyReasonSearch = Unilite.createSearchForm('modifyReasonSearchForm', {
		padding: '10 0 10 0',
		disabled :false,
		width: 5000,
		height: 3000,		
		layout: {type: 'uniTable', columns :1},
	    trackResetOnLoad: true,
	    items: [{
			fieldLabel: '변경사유', 
			name: 'MODIFY_REASON',
			xtype:'textarea',
			width:370,
			height:110
		}]
    }); // createSearchForm
*/	
	
    Unilite.Main({
    	id  : 'bcm104skrvApp',
		borderItems : [
			panelSearch,
			panelResult,
			{	region:'center',
				//layout : 'border',
				title:'거래처정보',
				layout : {type:'vbox', align:'stretch'},
				flex:1,
				tools: [
					{
						type: 'hum-grid',					            
			            handler: function () {
			            	detailForm.hide();
			                //masterGrid.show();
			            	//panelResult.show();
			            }
					},{
			
						type: 'hum-photo',					            
			            handler: function () {
			            	if(directMasterStore.getCount() != 0){
//			            		var record = masterGrid.getSelectedRecord();
//								var param = {COMP_CODE: UserInfo.compCode, CUSTOM_CODE: record.get('CUSTOM_CODE')}
//								bcm104skrvService.getUnPayAmt(param, function(provider, response)	{
//									if(!Ext.isEmpty(provider)){
//										detailForm.setValue('UNPAY_AMT', provider[0].UNPAY_AMT);
//										detailForm.setValue('STOCK_I', provider[0].STOCK_I);
//									}
//								});
			                	masterGrid.hide();
			                }else{
			                	return false;
			                }
			            }
					}
				],
				items:[					
					masterGrid, 
					detailForm					
				]
			}
		],		
		autoButtonControl : false,
		fnInitBinding : function(params) {
			if(params && params.CUSTOM_CODE ) {
				panelSearch.setValue('CUSTOM_CODE',params.CUSTOM_CODE);
				panelSearch.setValue('COMP_CODE',params.COMP_CODE);
				masterGrid.getStore().loadStoreRecords();
			}
			detailForm.getField('TAX_TYPE').setReadOnly(true);
			detailForm.getField('TAX_CALC_TYPE').setReadOnly(true);
//			UniAppManager.setToolbarButtons(['reset','newData','detail'],true);			
		}
		,onSaveAsExcelButtonDown: function() {
			var masterGrid = Ext.getCmp('bcm104skrvGrid');
			 masterGrid.downloadExcelXml();
		},
		
		onQueryButtonDown : function()	{
			detailForm.clearForm ();
			directMasterStore.loadStoreRecords();
			if(masterGrid.isHidden()){
				detailForm.getEl().mask('로딩중...','loading-indicator');		
			}
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			detailForm.clearForm();
			directMasterStore.loadData({});	
			detailForm.hide();
			this.fnInitBinding();
//			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		rejectSave: function()	{
			directMasterStore.rejectChanges();
			UniAppManager.setToolbarButtons('save',false);
		} 	
		, confirmSaveData: function()	{
            	if(directMasterStore.isDirty())	{
					if(confirm(Msg.sMB061))	{
						this.onSaveDataButtonDown();
					} else {
						this.rejectSave();
					}
				}
				
		},
        fnGetRefCode: function(subCode)	{        	
        	var refCode = '';
        	Ext.each(BsaCodeInfo.grsCustomType, function(item, i)	{        		
        		if(item['codeNo'] == subCode) {
        			refCode = item['refCode1'];        			
        		}
        	});  
        	return refCode;
        }
		
	});	// Main
	
	Unilite.createValidator('validator01', {
		store : directMasterStore,
		grid: masterGrid,
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			if(fieldName == 'CUSTOM_CODE'){
				if(isNaN(newValue)){
					rv = "숫자만 입력 가능합니다.";
				}
			}else if( fieldName == 'CUSTOM_FULL_NAME' ) {		// 거래처(약명)
//				if(newValue == '')	{
//					rv = Msg.sMB083;
//				}else {
//					if(record.get('CUSTOM_FULL_NAME') == '')	{
						record.set('CUSTOM_NAME',newValue);		
//					}
//				}
			} /*else if( fieldName == 'COMPANY_NUM') { 		// '사업자번호'
				 record.set('CUST_CHK','T');
				 if ( (newValue != oldValue) && ( newValue.trim().length > 0 ) )	{
				 	console.log("EEEUnilite.validate('bizno',newValue, oldValue) : [" + newValue + ", " + oldValue + "]");
				 	if(Unilite.validate('bizno', newValue) != true)	{
				 		if(!confirm(Msg.sMB173+"\n"+Msg.sMB175+"\n"+"거래처코드 : "+record.get('CUSTOM_CODE')))	{
				 			rv = false;
				 		}else {
//				 			e.record.setFieldStyle( style )
				 		}
				 	}
				 }
				 
			}*/ else if( fieldName ==  "MONEY_UNIT") { 			// 기준화폐
				if(UserInfo.currency == newValue) {
					record.set('CREDIT_YN', 'Y');
				}else {
					record.set('CREDIT_YN', 'N');
				}
			} else if( fieldName ==  "CREDIT_YN" ) {			// 여신적용여부
				if(UserInfo.currency != record.get("MONEY_UNIT")) {
					console.log('GRID CREDIT_YN BLUR');
					if("Y" == newValue ) 	{
						record.set('CREDIT_YN','N');
						rv = Msg.sMB217;
					}
				}
			} else if( fieldName == "VAT_RATE" ) { 			// 세율
				if(newValue < 0 ) {
					rv = Msg.sMB076;
				}
			} else if( fieldName ==  "TOT_CREDIT_AMT") {		// 여신(담보)액
				if(newValue < 0 ) {
					rv = Msg.sMB076;
				}
			} /*else if( fieldName == "COLLECT_DAY") {
				if(newValue < 1 || newValue > 31 ) {
					rv = Msg.sMB210;
				}
			}*/
				
			return rv;
		}
	}); // validator
	
	
}; // main


</script>


