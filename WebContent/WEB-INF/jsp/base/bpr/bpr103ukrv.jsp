<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr103ukrv"  >
<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->	
<t:ExtComboStore comboType="AU" comboCode="B013" /><!-- 단위 -->
<t:ExtComboStore comboType="AU" comboCode="B059" /><!-- 세구분 -->
<t:ExtComboStore comboType="AU" comboCode="B010" /><!-- 단위 -->
<t:ExtComboStore comboType="AU" comboCode="B020" /><!-- 품목계정 -->
<t:ExtComboStore comboType="AU" comboCode="B014" /><!-- 조달구분 -->
<t:ExtComboStore comboType="AU" comboCode="B061" /><!-- 발주방침 -->
<t:ExtComboStore comboType="AU" comboCode="A003" /><!-- 매입매출 구분 -->
<t:ExtComboStore comboType="AU" comboCode="YP02" /><!-- 서가 -->
<t:ExtComboStore comboType="AU" comboCode="B019" /><!-- 국내외 -->
<t:ExtComboStore comboType="AU" comboCode="YP08" /><!-- 매입조건 -->
<t:ExtComboStore comboType="AU" comboCode="YP09" /><!-- 판매형태 -->
<t:ExtComboStore comboType="AU" comboCode="YP19" /><!-- 주방프린터 -->
<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="bpr103ukrvLevel1Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="bpr103ukrvLevel2Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="bpr103ukrvLevel3Store" />
</t:appConfig>
<script type="text/javascript" >
//var detailWin;
var getItemPWindow;
var getBookInfoWindow;
var getWindowX;
var getWindowY;

function appMain() {
	////마스트 모델에 교재구분 정의하려는데 bpr100t에 컬럼 없음
	var activeSubGrid;
	var regFlag = '';	//등록여부 예1, 아니오2
	/**
	 * Master Model
	 */				
	 
	Unilite.defineModel('bpr103ukrvModel', {
		fields: [	 //BPR100T필수
					 { name: 'STOCK_UNIT',  			text: '<t:message code="system.label.base.inventoryunit" default="재고단위"/>', 		type : 'string', allowBlank: false, comboType:'AU', comboCode:'B013', displayField: 'value', defaultValue: 'EA' }      
			  		,{ name: 'TAX_TYPE',  				text: '<t:message code="system.label.base.taxtype" default="세구분"/>', 		type : 'string', allowBlank: false, comboType:'AU', comboCode:'B059' , defaultValue:'1' }
    	 	 		,{ name: 'ITEM_CODE',  				text: '<t:message code="system.label.base.itemcode" default="품목코드"/>', 		type : 'string', allowBlank:false, isPk:true, pkGen:'user',maxLength:20 }      
			  		,{ name: 'ITEM_NAME',  				text: '<t:message code="system.label.base.itemname" default="품목명"/>', 		type : 'string', allowBlank: false, maxLength: 40}        
			  		
			  		,{ name: 'SPEC',  					text: '<t:message code="system.label.base.spec" default="규격"/>', 		type : 'string', maxLength: 160}
				    ,{ name: 'ITEM_LEVEL1',  			text: '<t:message code="system.label.base.majorgroup" default="대분류"/>', 		type : 'string', store: Ext.data.StoreManager.lookup('bpr103ukrvLevel1Store'), child:'ITEM_LEVEL2'}        					       
				    ,{ name: 'ITEM_LEVEL2',  			text: '<t:message code="system.label.base.middlegroup" default="중분류"/>', 		type : 'string', store: Ext.data.StoreManager.lookup('bpr103ukrvLevel2Store'), child:'ITEM_LEVEL3'}        
				    ,{ name: 'ITEM_LEVEL3',  			text: '<t:message code="system.label.base.minorgroup" default="소분류"/>', 		type : 'string', store: Ext.data.StoreManager.lookup('bpr103ukrvLevel3Store')}
			  		,{ name: 'SALE_UNIT',  				text: '<t:message code="system.label.base.salesunit" default="판매단위"/>', 		type : 'string', comboType:'AU', comboCode:'B013', displayField: 'value', allowBlank: false, fieldStyle: 'text-align: center;', defaultValue: 'EA'}      
			  		,{ name: 'TRNS_RATE',  				text: '<t:message code="system.label.base.salespackednumber" default="판매입수"/>', 		type : 'int', defaultValue:1.00, maxLength: 12 }           
			  		,{ name: 'SALE_BASIS_P',  	 		text: '<t:message code="system.label.base.sellingprice" default="판매단가"/>', 		type : 'uniUnitPrice', maxLength: 18, allowBlank: false}
			  		,{ name: 'BF_SALE_BASIS_P',  		text: '이전단가', 		type : 'uniUnitPrice', maxLength: 18}
			  		
			  		//BPR200T 필수
			  		,{ name: 'DIV_CODE',  				text: '<t:message code="system.label.base.division" default="사업장"/>', 		type : 'string', allowBlank: false, comboType: 'BOR120' /*, multiSelect: true, typeAhead: false*/}
			  		,{ name: 'ITEM_ACCOUNT',  			text: '<t:message code="system.label.base.itemaccount" default="품목계정"/>', 		type : 'string', comboType:'AU', comboCode:'B020', allowBlank: false }
			  		,{ name: 'TEMP_ITEM_ACCOUNT',  		text: 'TEMP_ITEM_ACCOUNT', 		type : 'string', comboType:'AU', comboCode:'B020'}
			  		,{ name: 'SUPPLY_TYPE',  			text: '<t:message code="system.label.base.procurementclassification" default="조달구분"/>', 		type : 'string', comboType:'AU', comboCode:'B014', allowBlank: false, defaultValue: '1'}			  		
			  		,{ name: 'ORDER_UNIT',  			text: '<t:message code="system.label.base.purchaseunit" default="구매단위"/>', 		type : 'string', comboType:'AU', comboCode:'B013', displayField: 'value', allowBlank: false, defaultValue: 'EA'}
			  		,{ name: 'WH_CODE',  				text: '<t:message code="system.label.base.mainwarehouse" default="주창고"/>', 		type : 'string', store: Ext.data.StoreManager.lookup('whList'), defaultValue: 'W052'}
			  		,{ name: 'ORDER_PLAN',  			text: '<t:message code="system.label.base.popolicy" default="발주방침"/>', 		type : 'string', comboType:'AU', comboCode:'B061', allowBlank: false, defaultValue: '1'}
			  		
			  		//BPR200T 일반
			  		,{ name: 'BUY_RATE',  				text: '<t:message code="system.label.base.purchasereceiptcount" default="구매입수"/>', 		type : 'int', maxLength:12 }
			  		,{ name: 'LOCATION',  				text: 'Location', 	type : 'string', maxLength:8 }
			  		,{ name: 'MATRL_PRESENT_DAY',  		text: '올림기간', 		type : 'int', maxLength: 10} //자재올림
			  		,{ name: 'PURCHASE_BASE_P',  		text: '공통구매단가', 	type : 'uniUnitPrice', maxLength: 18}
			  		,{ name: 'CUSTOM_CODE',  			text: '기준거래처', 	type : 'string', maxLength: 8}
			  		,{ name: 'CUSTOM_NAME',  			text: '기준거래처명', 	type : 'string', maxLength: 20}
			  		,{ name: 'K_PRINTER',  				text: '주방프린터', 	type : 'string', comboType:'AU', comboCode:'YP19'}
			  		
			  		
			  		
			  		//hidden
			  		,{ name: 'ITEM_NAME1',  			text: '<t:message code="system.label.base.itemname" default="품목명"/>1', 		type : 'string', maxLength: 40}       
			  		,{ name: 'ITEM_NAME2',  			text: '<t:message code="system.label.base.itemname" default="품목명"/>2', 		type : 'string', maxLength: 40}
			  		,{ name: 'DOM_FORIGN',  			text: '국내외구분', 	type : 'string', maxLength: 2, comboType:'AU', comboCode:'B019', defaultValue:'1' }
				    ,{ name: 'ITEM_GROUP',  			text: '<t:message code="system.label.base.repmodelcode" default="대표모델코드"/>',	type : 'string', maxLength: 20}  
				    ,{ name: 'ITEM_GROUP_NAME',  		text: '<t:message code="system.label.base.repmodelname" default="대표모델명"/>', 	type : 'string', maxLength: 40}    
			  		,{ name: 'STOCK_CARE_YN',  			text: '<t:message code="system.label.base.inventorymanageobject" default="재고관리대상"/>', 	type : 'string', comboType:'AU', comboCode:'B010', defaultValue:'Y' }   
			  		,{ name: 'START_DATE',  			text: '<t:message code="system.label.base.usestartdate" default="사용시작일"/>', 	type : 'uniDate', defaultValue:new Date(), maxLength: 10}    
			  		,{ name: 'STOP_DATE',  				text: '<t:message code="system.label.base.usestopdate" default="사용중단일"/>', 	type : 'uniDate', maxLength: 10}    
			  		,{ name: 'USE_YN',  				text: '<t:message code="system.label.base.photoflag" default="사진유무"/>', 		type : 'string', allowBlank: false, comboType:'AU', comboCode:'B010',defaultValue:'Y'}				    
				    ,{ name: 'SALE_COMMON_P',  			text: '시중가', 		type : 'uniUnitPrice', maxLength: 18}
				    ,{ name: 'AUTO_DISCOUNT',  			text: '자동할인여부', 	type : 'string', maxLength: 80, comboType:'AU', comboCode:'B010',defaultValue:'Y', allowBlank: false}
				    ,{ name: 'MEMBER_DISCOUNT_YN',  	text: '회원할인대상', 	type : 'string', maxLength: 80, comboType:'AU', comboCode:'B010',defaultValue:'N', allowBlank: false}
				    ,{ name: 'SPEC_CONTROL',  			text: '특정여부', 		type : 'string', comboType:'AU', comboCode:'B010',defaultValue:'N', allowBlank: false}
				    ,{ name: 'SPEC_CONTROL_CODE',	  	text: '특정코드', 		type : 'string', maxLength:3 }				    
			  		,{ name: 'EXCESS_RATE',  			text: '과출고허용률 ',	type : 'uniPercent', defaultValue:0.00, maxLength: 3}
			  		,{ name: 'BIG_BOX_BARCODE',  		text: '물류바코드', 	type : 'string', maxLength: 20 }
			  		,{ name: 'BUY_BIG_BOX_BARCODE',  	text: 'BUY물류바코드', type : 'string', maxLength: 20 }
			  		,{ name: 'BOOK_LINK',  				text: '책소개링크 ',	type : 'string'}
			  		
			  		/*품목 정보*/			  		
//			  		,{ name: 'SMALL_BOX_BARCODE',  		text: '소박스바코드', 	type : 'string', maxLength: 20 }
			  		,{ name: 'BARCODE',  				text: '상품바코드', 		type : 'string', maxLength: 15 }
			  		,{ name: 'BIN_NUM',  				text: '서가진열대번호', type : 'string', maxLength: 20}
			  		,{ name: 'BIN_NAME',  				text: 'BIN_NAME', 	type : 'string', maxLength: 100}
			  		,{ name: 'BIN_FLOOR',  				text: '선반번호', 		type : 'string', maxLength: 2 }//bpr100t 추가
			  		,{ name: 'USE_BY_DATE',  			text: '재고유효일', 	type : 'int', defaultValue:'${UseByDate}', maxLength: 10}       
			  		,{ name: 'CIR_PERIOD_YN',  			text: '유통기한관리여부',type : 'string', comboType:'AU', comboCode:'B010',defaultValue:'Y', allowBlank: false}
			  		,{ name: 'CONSIGNMENT_FEE',  		text: '위탁수수료', 		type : 'uniPrice', maxLength: 18}
			  		
			  		/*도서 정보*/
			  		,{ name: 'ISBN_CODE',  				text: 'ISBN코드', 	type : 'string', maxLength: 20}
			  		,{ name: 'PUBLISHER_CODE',  		text: '출판사코드', 	type : 'string', maxLength: 8}
			  		,{ name: 'PUBLISHER',  				text: '출판사', 		ype : 'string', maxLength: 50}
			  		,{ name: 'AUTHOR1',  				text: '저자1', 		type : 'string', maxLength: 30}
			  		,{ name: 'AUTHOR2',  				text: '저자2', 		type : 'string', maxLength: 30}
			  		,{ name: 'TRANSRATOR',  			text: '역자', 		type : 'string', maxLength: 30}
			  		,{ name: 'PUB_DATE',  				text: '초판발행일', 	type : 'uniDate', maxLength: 8}
			  		,{ name: 'BIN_NUM',  				text: '서가진열대번호', type : 'string', maxLength: 10}
			  		,{ name: 'BIN_FLOOR',  				text: '진열대', type : 'string', maxLength: 10}
			  		,{ name: 'PROD_TYPE',  				text: '교재구분', 		type : 'string', maxLength: 80,defaultValue:'Y'}
			  		
			  		
			  		,{ name: 'FIRST_PURCHASE_DATE',   	text: '최초매입일 ', 	type : 'uniDate', maxLength: 10}
			  		,{ name: 'LAST_PURCHASE_DATE',    	text: '최종매입일 ', 	type : 'uniDate', maxLength: 10}
			  		,{ name: 'FIRST_SALES_DATE',      	text: '최초판매일 ', 	type : 'uniDate', maxLength: 10}
			  		,{ name: 'LAST_SALES_DATE',       	text: '최종판매일 ', 	type : 'uniDate', maxLength: 10}
			  		,{ name: 'LAST_RETURN_DATE',      	text: '최종반품일 ', 	type : 'uniDate', maxLength: 10}
			  		,{ name: 'LAST_DELIVERY_DATE',    	text: '최종납품일 ', 	type : 'uniDate', maxLength: 10}
			  		,{ name: 'LAST_DELIVERY_CUSTOM',  	text: '최종납품처 ', 	type : 'string',  maxLength: 30}
			  		
			  		
			  		
			  		,{ name: 'REMARK1',  				text: '비고1', 		type : 'string', maxLength: 300}
			  		,{ name: 'REMARK2',  				text: '비고2', 		type : 'string', maxLength: 300}
			  		,{ name: 'REMARK3',  				text: '비고3', 		type : 'string', maxLength: 300}
			  		,{ name: 'MONEY_UNIT',  			text: 'MONEY_UNIT', type : 'string'}
			  		,{ name: 'SALE_DATE',  				text: 'SALE_DATE',  type : 'uniDate', maxLength: 10}
			  		
			  		,{ name: 'SFLAG',  					text: '등록여부'	   ,type : 'string', maxLength: 10}
			  		,{ name: 'TO_DIV_CODE',  			text: '변경할사업장',  type : 'string', maxLength: 5}
			  		
			  		,{ name: 'PROPER_STOCK_Q',  		text: '적정재고',  	type : 'uniQty', maxLength: 10}
			  		,{ name: 'STOCK_Q',  				text: '현재고',   	type : 'uniQty', maxLength: 10}
			  		,{ name: 'ISSUE_PLAN_Q',  			text: '납품예정일',  	type : 'uniQty', maxLength: 10}
		]
	});
	
	/**
	 * Master Store
	 */
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bpr103ukrvService.selectDetailList',
			update: 'bpr103ukrvService.updateDetail',
//			create: 'bpr103ukrvService.insertDetail',
			destroy: 'bpr103ukrvService.deleteDetail',
			syncAll: 'bpr103ukrvService.saveAll'
		}
	});
	var directMasterStore = Unilite.createStore('bpr103ukrvMasterStore',{
			model: 'bpr103ukrvModel',
           	autoLoad: false,
        	uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
           	proxy: directProxy
			,listeners: {
	            write: function(proxy, operation){
	                if (operation.action == 'destroy') {
	                	Ext.getCmp('goodDetailForm').reset();			         
	                }
            	}
        	}
        	,loadStoreRecords : function()	{
				var param= panelSearch.getValues();
				param.FR_DIV_CODE = panelResult.getValue('FR_DIV_CODE');
				console.log( param );
				this.load({
						params : param,
						callback : function(records, operation, success) {
							if(success)	{
	    						
							}
						}
					}
				);
				
			}
			,saveStore : function(config)	{	
//				var paramMaster= [];
//				var app = Ext.getCmp('bpr103ukrvApp');
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
            	var toUpdate = this.getUpdatedRecords();
            	console.log("toUpdate",toUpdate);

            	var rv = true;
       	
            	
				if(inValidRecs.length == 0 )	{
					for(var i=0 ; i < toCreate.length ; i++)	{
						if(toCreate[i].data['ITEM_LEVEL1']==null || toCreate[i].data['ITEM_LEVEL1']=='' ){
							toCreate[i].data["ITEM_LEVEL1"]		= "*";
						}
						if(toCreate[i].data['ITEM_LEVEL2']==null || toCreate[i].data['ITEM_LEVEL2']=='' ){
							toCreate[i].data["ITEM_LEVEL2"]		= "*";
						}
						if(toCreate[i].data['ITEM_LEVEL3']==null || toCreate[i].data['ITEM_LEVEL3']=='' ){
							toCreate[i].data["ITEM_LEVEL3"]		= "*";
						}
					}
					for(var i=0 ; i < toUpdate.length ; i++)	{
						if(toUpdate[i].data['ITEM_LEVEL1']==null || toUpdate[i].data['ITEM_LEVEL1']==''){
							toUpdate[i].data["ITEM_LEVEL1"]		= "*";
						}
						if(toUpdate[i].data['ITEM_LEVEL2']==null || toUpdate[i].data['ITEM_LEVEL2']==''){
							toUpdate[i].data["ITEM_LEVEL2"]		= "*";
						}
						if(toUpdate[i].data['ITEM_LEVEL3']==null || toUpdate[i].data['ITEM_LEVEL3']==''){
							toUpdate[i].data["ITEM_LEVEL3"]		= "*";
						}
					}					
					config = {
//							params: [paramMaster],
							success: function(batch, option) {
//								var toolbar = activeSubGrid.getDockedItems('toolbar[dock="top"]');
//								var needSave = !toolbar[0].getComponent('sub_save').isDisabled();
//								if(!needSave) {
//									directMasterStore.suspendEvent('datachanged');	//저장뒤 잠시 상위버튼 컨트롤 사용off
//									directMasterStore.remove(masterGrid.getSelectedRecord());
//									directMasterStore.resumeEvent('datachanged');	//상위버튼 컨트롤 사용on
//									masterGrid.getSelectionModel().select(0);
//								}		
								var param = panelSearch.getValues();
								bpr103ukrvService.goInterFace(param, function(provider, response)	{
								});
								goodDetailForm.resetDirtyStatus();														
								UniAppManager.setToolbarButtons('save', false);			
							}
					};
					
//					if(config == null)	{
//						var config = {success : 
//											function()	{
//												goodDetailForm.resetDirtyStatus();
//											}
//									}
//						
//					}
					this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			_onStoreDataChanged: function( store, eOpts )	{
		    	if(this.uniOpt.isMaster) {
		       		console.log("_onStoreDataChanged store.count() : ", store.count());
		       		if(store.count() == 0)	{
		       			UniApp.setToolbarButtons(['delete'], false);
			    		Ext.apply(this.uniOpt.state, {'btn':{'delete':false}});
			    		if(this.uniOpt.useNavi) {
			       			UniApp.setToolbarButtons(['prev','next'], false);
			    		}
		       		}else {
		       			if(this.uniOpt.deletable && regFlag == '1')	{
			       			UniApp.setToolbarButtons(['delete'], true);
//				    		Ext.apply(this.uniOpt.state, {'btn':{'delete':true}});
		       			}else{
		       				UniApp.setToolbarButtons(['delete'], false);
		       			}
			    		if(this.uniOpt.useNavi) {
			       			UniApp.setToolbarButtons(['prev','next'], true);
			    		}
		       		}
		       		if(store.isDirty())	{
		       			UniApp.setToolbarButtons(['save'], true);
		       		}else {
		       			UniApp.setToolbarButtons(['save'], false);
		       		}
		    	}
		    },
			listeners:{
				update:function( store, record, operation, modifiedFieldNames, eOpts )	{
					//goodDetailForm.setActiveRecord(record); radio 버튼 클릭시 오류
				},
				load: function(store, records, successful, eOpts) {
					if(records.length == 0){
						detailForm.show();			
						goodDetailForm.hide();
						bookDetailForm.hide();
					}					
				}
			}
	});
	
	
	Unilite.defineModel('bpr103ukrvSubModel', {
    	fields: [ {name: 'CUSTOM_CODE'	 		,text: '매입처코드' 			,type: 'string', allowBlank: false},
		    	  {name: 'CUSTOM_NAME'	 		,text: '매입처명' 				,type: 'string', allowBlank: false},
		    	  {name: 'TYPE'	 				,text: '<t:message code="system.label.base.classfication" default="구분"/>' 				,type: 'string', comboType:'AU', comboCode:'A003'},
		    	  {name: 'PURCHASE_TYPE'	 	,text: '매입조건' 				,type: 'string', comboType:'AU', comboCode:'YP08'},
		    	  {name: 'SALES_TYPE'	 		,text: '판매형태' 				,type: 'string', comboType:'AU', comboCode:'YP09'},
		    	  {name: 'APLY_START_DATE'		,text: '적용일자' 				,type: 'uniDate', allowBlank: false},
		    	  {name: 'APLY_END_DATE'		,text: '종료일자' 				,type: 'uniDate', allowBlank: false},
		    	  {name: 'PURCHASE_RATE'		,text: '매입율(%)' 			,type: 'uniPercent', allowBlank: true},
		    	  {name: 'ORDER_RATE'			,text: '발주율(%)' 			,type: 'uniPercent'},
		    	  {name: 'USE_YN'				,text: 'USE_YN' 			,type: 'string'},
		    	  {name: 'ITEM_P'				,text: '매입가' 				,type: 'uniUnitPrice', allowBlank: true},//단가 * 발주율 %
			  	  {name: 'BASIS_P'				,text: '<t:message code="system.label.base.sellingprice" default="판매단가"/>'				,type :'uniUnitPrice'},			  	  
			  	  {name: 'COMP_CODE'	 		,text: 'COMP_CODE' 			,type: 'string'},
		    	  {name: 'DIV_CODE'	 			,text: '<t:message code="system.label.base.division" default="사업장"/>' 				,type: 'string'},
		    	  {name: 'ITEM_CODE'	 		,text: '<t:message code="system.label.base.itemcode" default="품목코드"/>' 				,type: 'string', allowBlank: false},
		    	  {name: 'MONEY_UNIT'	 		,text: '화폐단위' 				,type: 'string',comboType:'AU',comboCode:'B004',displayField: 'value'},
		    	  {name: 'ORDER_UNIT'	 		,text: '<t:message code="system.label.base.purchaseunit" default="구매단위"/>' 				,type: 'string',comboType:'AU',comboCode:'B013',displayField: 'value'},		    	
		    	  {name: 'UPDATE_DB_USER'		,text: 'UPDATE_DB_USER' 	,type: 'string'},
		      	  {name: 'UPDATE_DB_TIME'		,text: 'UPDATE_DB_TIME' 	,type: 'string'},
		      	  {name: 'REG_FLAG'				,text: '등록여부' 				,type: 'string'}
			  	 
			  	 
		]
	});
	
	var directSubProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bpr103ukrvService.selectSubDetailList',
			update: 'bpr103ukrvService.updateSubDetail',
			create: 'bpr103ukrvService.insertSubDetail',
			destroy: 'bpr103ukrvService.deleteSubDetail',
			syncAll: 'bpr103ukrvService.subSaveAll'
		}
	});
	
	var directSubStore = Unilite.createStore('bpr103ukrvSubStore', {
		model: 'bpr103ukrvSubModel',
        autoLoad: false,
        uniOpt : {
        	isMaster: false,			// 상위 버튼 연결
        	editable: true,			// 수정 모드 사용
        	deletable:true,			// 삭제 가능 여부
            useNavi : false			// prev | next 버튼 사용
        },
        proxy: directSubProxy
        ,loadStoreRecords : function()	{
        	var record = masterGrid.getSelectedRecord();
        	if(Ext.isEmpty(record)){
        		return false;
        	}
        	if(Ext.isEmpty(record.get('ITEM_CODE'))){
        		return false;
        	}
			var param = {DIV_CODE: panelSearch.getField( 'REG_YN').getValue() == '1' ? 
								   panelSearch.getValue('TO_DIV_CODE') :
								   panelResult.getValue('FR_DIV_CODE')																					
					   , ITEM_CODE: record.get('ITEM_CODE')
					   , TO_DIV_CODE: panelSearch.getValue('TO_DIV_CODE')}			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{	
        	var paramMaster= panelSearch.getValues();
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						if(regFlag == '2'){	//등록여부 아니오 일시만 업데이트 일어날시 레코드를 삭제함 예인 경우는 레코드 삭제하면 안됨
							directMasterStore.suspendEvent('datachanged');	//저장뒤 잠시 상위버튼 컨트롤 사용off
							directMasterStore.remove(masterGrid.getSelectedRecord());
							directMasterStore.resumeEvent('datachanged');	//상위버튼 컨트롤 사용on
							activeSubGrid.reset();
							masterGrid.getSelectionModel().select(0);
//							directMasterStore.loadStoreRecords();
						}		
					 }
				};
				this.syncAllDirect(config);
		},
	    _onStoreUpdate: function (store, eOpt) {	    	
	    	console.log("Store data updated save btn enabled !");
	    	this.setToolbarButtons('sub_save', true);    	
	    } // onStoreUpdate
	    ,_onStoreLoad: function ( store, records, successful, eOpts ) {	    	
	    	console.log("onStoreLoad");
	    	if(regFlag == "2"){
	    		this.setToolbarButtons('sub_delete', false);
		    	this.setToolbarButtons('sub_newData', false);
		    	this.setToolbarButtons('sub_reset', false);
		    	this.setToolbarButtons('sub_query', false);	
	    	}else{
		    	this.setToolbarButtons('sub_newData', true);
		    	this.setToolbarButtons('sub_reset', true);
		    	this.setToolbarButtons('sub_query', true);
	    	}
	    		    	
	    	if (panelSearch.getValue('REG_FLAG') == '2' && !Ext.isEmpty(records[0])) {
	    		this.setToolbarButtons('sub_save', true);		    		
	    	}else{
	    		this.setToolbarButtons('sub_save', false);
//					var msg = records.length + Msg.sMB001; //'건이 조회되었습니다.';
		    	//console.log(msg, st);
//			    	UniAppManager.updateStatus(msg, true);
	    	}	    	
	    },
		_onStoreDataChanged: function( store, eOpts )	{	    	
       		console.log("_onStoreDataChanged store.count() : ", store.count());
       		if(store.count() == 0)	{
       			this.setToolbarButtons(['sub_delete'], false);
	    		Ext.apply(this.uniOpt.state, {'btn':{'sub_delete':false}});
//	    		goodDetailForm.getField('SALE_COMMON_P').setReadOnly(false);
	    		if(this.uniOpt.useNavi) {
	       			this.setToolbarButtons(['prev','next'], false);
	    		}
       		}else {
       			if(this.uniOpt.deletable)	{
	       			this.setToolbarButtons(['sub_delete'], true);
		    		Ext.apply(this.uniOpt.state, {'btn':{'sub_delete':true}});
       			}
	    		if(this.uniOpt.useNavi) {
	       			this.setToolbarButtons(['prev','next'], true);
	    		}
       		}
       		if(store.isDirty())	{
       			this.setToolbarButtons(['sub_save'], true);
       		}else {
       			this.setToolbarButtons(['sub_save'], false);
       		}	    	
    	},
    	setToolbarButtons: function( btnName, state)	{
    		var toolbar = activeSubGrid.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
			}
    	},
    	listeners: {
    		load : function(store, records, successful, eOpts){
    			if(regFlag == '2'){	//등록 안됨 조회
    				if(!Ext.isEmpty(records)){
    					Ext.each(records, function(record, index) {
							record.set('REG_FLAG', '2'); 						
						});	
    				}    								
    			}    			
    		}    		
    	}
	});
	
	

	/**
	 * 검색 Form
	 */
	var sortSeqStore = Unilite.createStore('bpr103ukrvSeqStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'<t:message code="system.label.base.ascending" default="오름차순"/>'		, 'value':'ASC'},
			        {'text':'<t:message code="system.label.base.descending" default="내림차순"/>'		, 'value':'DESC'}
	    		]
		});
	
    /**
     * Master Grid
     */
	 var masterGrid = Unilite.createGrid('bpr103ukrvGrid', {  
	 	uniOpt:{
			useRowNumberer: false,
        	expandLastColumn: false,
            useMultipleSorting: false,
            
            state: {
			   useState: false,   
			   useStateList: false  
			}
        },
        border:false,
    	store : directMasterStore,
    	/* tbar: ['->',
            {
	        	text:'상세보기',
	        	handler: function() {
	        		var record = masterGrid.getSelectedRecord();
		        	if(record) {
		        		openDetailWindow(record);
		        	}
	        	}
            }
        ],*/
        columns:  [ { dataIndex: 'ITEM_CODE',  			  	width: 100/*, isLink:true*/},
        			{ dataIndex: 'ITEM_NAME',  			  	width: 130},
        			{ dataIndex: 'SPEC',  				  	width: 110},
        			{ dataIndex: 'STOCK_UNIT',  		  	width: 63, align: 'center'},
//        			{ dataIndex: 'ITEM_LEVEL1',  		  	width: 120, hidden: true},
//        			{ dataIndex: 'ITEM_LEVEL2',  		  	width: 120, hidden: true},
//        			{ dataIndex: 'ITEM_LEVEL3',  		  	width: 120, hidden: true},
//        			{ dataIndex: 'DIV_CODE',  			  	width: 130, hidden: true},
//        			{ dataIndex: 'SALE_UNIT',  			  	width: 90, hidden: true},
//        			{ dataIndex: 'TRNS_RATE',  			  	width: 80, hidden: true},
//        			{ dataIndex: 'TAX_TYPE',  			  	width: 80,  hidden: true},
//        			{ dataIndex: 'SALE_BASIS_P',  	 	  	width: 100, hidden: true},
        			{ dataIndex: 'ITEM_ACCOUNT',  		  	width: 80, hidden: false}
//        			{ dataIndex: 'SUPPLY_TYPE',  		  	width: 80, hidden: true},
//        			{ dataIndex: 'ORDER_UNIT',  		  	width: 90, hidden: true},
//        			{ dataIndex: 'WH_CODE',  			  	width: 120, hidden: true},
//        			{ dataIndex: 'ORDER_PLAN',  		  	width: 100, hidden: true},
//        			{ dataIndex: 'ITEM_NAME1',  		    width: 140, hidden: true},
//        			{ dataIndex: 'ITEM_NAME2',  		    width: 140, hidden: true},
//        			{ dataIndex: 'DOM_FORIGN',  		    width: 140, hidden: true},        			
//        			{ dataIndex: 'ITEM_GROUP',  		  	width: 80, hidden: true},
//					{ dataIndex: 'ITEM_GROUP_NAME',  	  	width: 80, hidden: true},	
//        			{ dataIndex: 'STOCK_CARE_YN',  		  	width: 80, hidden: true},
//        			{ dataIndex: 'START_DATE',  		  	width: 80, hidden: true},
//        			{ dataIndex: 'STOP_DATE',  			  	width: 80, hidden: true},
//        			{ dataIndex: 'USE_YN',  			  	width: 80, hidden: true},
//        			{ dataIndex: 'SALE_COMMON_P',		  	width: 80, hidden: true},
//        			{ dataIndex: 'CONSIGNMENT_FEE',  	 	width: 80, hidden: true},        			
//        			{ dataIndex: 'AUTO_DISCOUNT',  		  	width: 80, hidden: true},
//        			{ dataIndex: 'MEMBER_DISCOUNT_YN',  	width: 80, hidden: true},        			
//        			{ dataIndex: 'SPEC_CONTROL',  		  	width: 80, hidden: true},
//        			{ dataIndex: 'SPEC_CONTROL_CODE',	  	width: 80, hidden: true},
//        			{ dataIndex: 'EXCESS_RATE',  		  	width: 80, hidden: true},
//        			{ dataIndex: 'BOOK_LINK',  		  		width: 80, hidden: false}
//        			{ dataIndex: 'BIG_BOX_BARCODE',   		width: 80, hidden: true},
//        			{ dataIndex: 'BUY_BIG_BOX_BARCODE',		width: 80, hidden: true},        			
////       			{ dataIndex: 'SMALL_BOX_BARCODE', 		width: 80, hidden: true},
//        			{ dataIndex: 'BARCODE',  		 		width: 80, hidden: true},
//        			{ dataIndex: 'BIN_NUM',  		 		width: 80, hidden: true},
//        			{ dataIndex: 'BIN_FLOOR',  		 		width: 80, hidden: true},
//        			{ dataIndex: 'USE_BY_DATE',  	 		width: 80, hidden: true},
//        			{ dataIndex: 'CIR_PERIOD_YN',  	 		width: 80, hidden: true},
//        			{ dataIndex: 'ISBN_CODE',  			  	width: 80, hidden: true},
//        			{ dataIndex: 'PUBLISHER_CODE',  		width: 80, hidden: true},
//        			{ dataIndex: 'PUBLISHER',  				width: 80, hidden: true},
//        			{ dataIndex: 'AUTHOR1',  	  			width: 80, hidden: true},
//        			{ dataIndex: 'AUTHOR2',  	  			width: 80, hidden: true},
//        			{ dataIndex: 'TRANSRATOR',    			width: 80, hidden: true},
//        			{ dataIndex: 'PUB_DATE',  	  			width: 80, hidden: true},
//        			{ dataIndex: 'BIN_NUM',  	  			width: 80, hidden: true},
//        			{ dataIndex: 'BIN_FLOOR',  	  			width: 80, hidden: true},        			
//        			{ dataIndex: 'PROD_TYPE',  	  			width: 80, hidden: true},
//        			{ dataIndex: 'FIRST_PURCHASE_DATE',   	width: 80, hidden: true},
//        			{ dataIndex: 'LAST_PURCHASE_DATE',    	width: 80, hidden: true},
//        			{ dataIndex: 'FIRST_SALES_DATE',      	width: 80, hidden: true},
//        			{ dataIndex: 'LAST_SALES_DATE',       	width: 80, hidden: true},
//        			{ dataIndex: 'LAST_RETURN_DATE',      	width: 80, hidden: true},
//        			{ dataIndex: 'LAST_DELIVERY_DATE',    	width: 80, hidden: true},
//        			{ dataIndex: 'LAST_DELIVERY_CUSTOM',  	width: 80, hidden: true},
//        			{ dataIndex: 'BUY_RATE',  			  	width: 80, hidden: true},
//        			{ dataIndex: 'LOCATION',  			  	width: 80, hidden: true},
//					{ dataIndex: 'MATRL_PRESENT_DAY',  	  	width: 80, hidden: true},
//					{ dataIndex: 'PURCHASE_BASE_P',  	  	width: 80, hidden: true},
//					{ dataIndex: 'CUSTOM_CODE',  		  	width: 80, hidden: true},
//					{ dataIndex: 'CUSTOM_NAME',  		  	width: 80, hidden: true},       			
//					{ dataIndex: 'REMARK1',  			  	width: 80, hidden: true},
//					{ dataIndex: 'REMARK2',  			  	width: 80, hidden: true},
//					{ dataIndex: 'REMARK3',  			  	width: 80, hidden: true},
//					{ dataIndex: 'BF_SALE_BASIS_P',  		width: 80, hidden: true},
//					{ dataIndex: 'MONEY_UNIT',		  		width: 80, hidden: true},
//					{ dataIndex: 'SALE_DATE',		  		width: 80, hidden: true},
//        			{ dataIndex: 'SFLAG',		  			width: 80, hidden: true},
//        			{ dataIndex: 'TO_DIV_CODE',			  	width: 80, hidden: true}
          ] ,
          listeners: {          	
//          	selectionchangerecord:function(selected)	{
//          		goodDetailForm.loadForm(selected);
//          	},
          	beforedeselect: function( grid, record, index, eOpts )	{
				if(directMasterStore.isUpdateDirty())	{
					if(confirm(Msg.sMB061))	{
						UniAppManager.app.onSaveDataButtonDown();
						return false;
					}  else {
						UniAppManager.app.rejectSave();
					}
				}				
			},
      		selectionchange: function( grid, selected, eOpts ) { 
				var record = selected[0];
				if(!Ext.isEmpty(record)){
					if(record.get('TEMP_ITEM_ACCOUNT') == '00'){					
						bookDetailForm.loadForm(selected[0]);					
//						var bookLink = bookDetailForm.down('#bookLink');
//						if(!Ext.isEmpty(record.get('BOOK_LINK'))){						
//							bookLink.setValue('<a href="javascript:void(0);" onclick="javascript:'+UniNaverSearch.getLinkScript(record.get('BOOK_LINK'))+';"><u>책소개</u></a>')
//						}else{
//							bookLink.setValue('<a href="javascript:void(0);"><u>책소개</u></a>')
//						}
						goodDetailForm.hide();
						detailForm.hide();
//						record.set('DIV_CODE', panelSearch.getValue('TO_DIV_CODE'));
//						bookDetailForm.setValue('DIV_CODE', panelSearch.getValue('TO_DIV_CODE'))
						bookDetailForm.show();
						activeSubGrid = bookDetailFormSubGrid;						
	//					detailFormSubGrid.reset();
	//					Unilite.messageBox(bookDetailForm.isHideen());					
					}else{					
						goodDetailForm.loadForm(selected[0]);
						bookDetailForm.hide();
						detailForm.hide();
//						record.set('DIV_CODE', panelSearch.getValue('TO_DIV_CODE'));
//						goodDetailForm.setValue('DIV_CODE', panelSearch.getValue('TO_DIV_CODE'))
						goodDetailForm.show();
						activeSubGrid = goodDetailFormSubGrid;
						
	//					detailFormSubGrid.reset();
	//					Unilite.messageBox(goodDetailForm.isHideen());
					}
					directSubStore.loadStoreRecords();	//매입처단가 그리드 조회 
					if(regFlag == '2'){
						directMasterStore.uniOpt.deletable = false;						
					}else{
						directMasterStore.uniOpt.deletable = true;
					}
					
				}
				
			},
//			celldblclick: function( tbl, td, cellIndex, record, tr, rowIndex, e, eOpts )	{
//				/*var edit = masterGrid.findPlugin('cellediting');
//				if(Ext.isDefined(edit) && edit.editing)	{
//					edit.completeEdit();
//				}*/
//				masterGrid.hide();
//			},
//          	onGridDblClick:function(grid, record, cellIndex, colName) {
//          		if(!record.phantom) {
//	      			switch(colName)	{
//					case 'ITEM_CODE' :
//							masterGrid.hide();
//							break;		
//					default:
//							break;
//	      			}
//          		}
//          	},
          	beforeedit  : function( editor, e, eOpts ) {							
//				if(e.field == 'DIV_CODE')
				return false;					
			
			}
//			beforehide: function(grid, eOpts )	{
//				if(directMasterStore.isDirty() )	{
//					var config={
//						success:function()	{
//							masterGrid.hide();
//						}
//					};
//					UniAppManager.app.confirmSaveData(config);
//					return false;
//				}
//			},
//			hide:function()	{
//				goodDetailForm.show();
//				var record = masterGrid.getSelectedRecord();
//				if(!Ext.isEmpty(record)){
//					var bookLink = goodDetailForm.down('#bookLink');
//					if(!Ext.isEmpty(record.get('BOOK_LINK'))){						
//						bookLink.setValue('<a href="javascript:void(0);" onclick="javascript:'+UniNaverSearch.getLinkScript(record.get('BOOK_LINK'))+';"><u>책소개</u></a>')
//					}else{
//						bookLink.setValue('<a href="javascript:void(0);"><u>책소개</u></a>')
//					}
//				}				
//				
//			},
//			show:function()	{
//				
//			}
          }
    });
    
    var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',         
		defaultType: 'uniSearchSubPanel',
//		collapsed: UserInfo.appOption.collapseLeftSearch,		
		border: true,
//		defaults: {
//			autoScroll:true
//	  	},
	  	width: 380,
	  	listeners: {
	  		afterrender: function( panel, eOpts ) {
	  			panel.expand();
	  		}
	  	},
		items: [{     
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',   
			id: 'search_panel1',
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
            items: [{
				fieldLabel: '적용사업장',
				name: 'TO_DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				readOnly: false
			}, {
				name: 'ITEM_ACCOUNT',
				fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
				xtype:'uniCombobox',
				comboType:'AU',
				comboCode:'B020'
			}, {
    			xtype: 'uniTextfield',
	            name: 'ITEM_CODE',  		
    			fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>' 
    		},{ 
    			xtype: 'uniTextfield',
            	name: 'ITEM_NAME',  		
            	fieldLabel: '<t:message code="system.label.base.itemname" default="품목명"/>'
            },{
        		xtype: 'radiogroup',
        		fieldLabel: '등록여부',
        		//name: 'SALE_YN',
        		items: [{
        			boxLabel: '예',
        			width:70,
        			name: 'REG_YN',
        			inputValue: '1'
        		}, {
        			boxLabel: '아니오', 
        			width: 70,
        			name: 'REG_YN',
        			inputValue: '2'
        		},{
        			xtype: 'uniTextfield',
        			name: 'REG_FLAG',
        			hidden: true
        			
        		}]
           }]
		},{	
			header: false,
			id: 'search_panel2',
   			itemId: 'search_panel2',
   			layout:{type:'vbox', align:'stretch'},
   			flex: .8,
           	items: [masterGrid]			
		}],		
	    setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
																	return !field.validate();
																});
   				if(invalid.length > 0) {
					r=false;
   					var labelText = ''
   	
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
   					}

				   	Unilite.messageBox(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				}
	  		}
			return r;
  		}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 1},
		items: [{ 
			fieldLabel: '원본사업장',
			name: 'FR_DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			allowBlank: false,
			value: '01'
		}],		
	    setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
																	return !field.validate();
																});
   				if(invalid.length > 0) {
					r=false;
   					var labelText = ''
   	
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
   					}

				   	Unilite.messageBox(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				}
	  		}
			return r;
  		}	
    });
	
    /*상세폼에  BPR400T그리드*/
    var detailFormSubGrid = Unilite.createGrid('bpr103ukrvDetailFormSubGrid', {    	
    	//region:'center',
    	store : directSubStore,
    	sortableColumns : false,
//    	layout: 'fit',
    	height: 160,
    	width: 729,
    	margin: '0 0 0 92',    	
    	//border:false,
    	uniOpt:{
			 expandLastColumn: false
			,useRowNumberer: false
			,useMultipleSorting: false
			,enterKeyCreateRow: false
    	},
    	dockedItems: [{    		
	        xtype: 'toolbar',
	        dock: 'top',
	        items: [{
                xtype: 'uniBaseButton',
		 		text : '조회',
		 		tooltip : '조회',
		 		iconCls : 'icon-query', 
		 		width: 26, height: 26,
		 		itemId : 'sub_query'/*,
				handler: function() { 
					//if( me._needSave()) {
					var toolbar = activeSubGrid.getDockedItems('toolbar[dock="top"]');
					var needSave = !toolbar[0].getComponent('sub_save').isDisabled();
					if(needSave) {
						Ext.Msg.show({
						     title:'확인',
						     msg: Msg.sMB017 + "\n" + Msg.sMB061,
						     buttons: Ext.Msg.YESNOCANCEL,
						     icon: Ext.Msg.QUESTION,
						     fn: function(res) {
						     	//console.log(res);
						     	if (res === 'yes' ) {
						     		var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
				                  		directSubStore.saveStore();
				                    });
				                    saveTask.delay(500);
						     	} else if(res === 'no') {
						     		directSubStore.loadStoreRecords();
						     	}
						     }
						});
					} else {
						directSubStore.loadStoreRecords();
					}
				}*/
			},{
                xtype: 'uniBaseButton',
				text : '신규',
				tooltip : '초기화',
				iconCls: 'icon-reset',
				width: 26, height: 26,
		 		itemId : 'sub_reset',
				handler : function() { 
					/*var toolbar = activeSubGrid.getDockedItems('toolbar[dock="top"]');
					var needSave = !toolbar[0].getComponent('sub_save').isDisabled();
					if(needSave) {
						Ext.Msg.show({
						     title:'확인',
						     msg: Msg.sMB017 + "\n" + Msg.sMB061,
						     buttons: Ext.Msg.YESNOCANCEL,
						     icon: Ext.Msg.QUESTION,
						     fn: function(res) {
						     	console.log(res);
						     	if (res === 'yes' ) {
						     		var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
					                  	directSubStore.saveStore();
					                });
					                saveTask.delay(500);
						     	} else if(res === 'no') {
						     		activeSubGrid.reset();
						     		directSubStore.setToolbarButtons('sub_save', false);
						     		directSubStore.setToolbarButtons('sub_delete', false);
						     		goodDetailForm.getField('SALE_COMMON_P').setReadOnly(false);//시중가 readOnly: false
						     	}
						     }
						});
					} else {
						activeSubGrid.reset();
						directSubStore.setToolbarButtons('sub_save', false);
						directSubStore.setToolbarButtons('sub_delete', false);
						goodDetailForm.getField('SALE_COMMON_P').setReadOnly(false);//시중가 readOnly: false
					}	*/				
				}
			},{
                xtype: 'uniBaseButton',
				text : '추가',
				tooltip : '추가',
				iconCls: 'icon-new',
				width: 26, height: 26,
		 		itemId : 'sub_newData',
				handler : function() { 
					/*var record = masterGrid.getSelectedRecord();
					if(Ext.isEmpty(record)){
						return false;
					}else{
//						if(Ext.isEmpty(record.get('SALE_COMMON_P')) || record.get('SALE_COMMON_P') == 0){
//							Unilite.messageBox('시중가를 입력해 주세요');
//							goodDetailForm.getField('SALE_COMMON_P').focus();
//							return false;
//						}
					}
					goodDetailForm.getField('SALE_COMMON_P').setReadOnly(true);//시중가 readOnly: true
					var compCode = UserInfo.compCode;  
					var type = '1';
					var divCode = record.get('DIV_CODE');
					var itemCode = record.get('ITEM_CODE');
					var moneyUnit = UserInfo.currency;
					var orderUnit = record.get('ORDER_UNIT');
					var orderRate = '100';										
					var aplyStartDate = UniDate.get('today');
					var itemP = record.get('SALE_COMMON_P');
	
	            	var r = {
	            	 	COMP_CODE:			compCode,
	            	 	TYPE:				type,
	            	 	DIV_CODE:			divCode,
	            	 	ITEM_CODE:			itemCode,
	            	 	MONEY_UNIT:			moneyUnit,
	            	 	ORDER_UNIT:			orderUnit,
						PURCHASE_RATE:			orderRate,
						APLY_START_DATE:	aplyStartDate,
						ITEM_P:				itemP
			        };
					activeSubGrid.createRow(r,'ITEM_CODE');*/
				}
			},{
                xtype: 'uniBaseButton',
				text : '삭제',
				tooltip : '삭제',
				iconCls: 'icon-delete',disabled: true,
				width: 26, height: 26,
		 		itemId : 'sub_delete',
				handler : function() { 
					/*if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {				
						activeSubGrid.deleteSelectedRow();			
					}*/	
				}
				
			},{
                xtype: 'uniBaseButton',
				text : '저장', 
				tooltip : '저장', 
				iconCls: 'icon-save',disabled: true,
				width: 26, height: 26,
		 		itemId : 'sub_save',
				handler : function() { 
                  /*var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
                  	directSubStore.saveStore();
                  });
                  saveTask.delay(500);*/
                }
			}]
	    }],	    
    	/* tbar: ['->',
            {
	        	text:'상세보기',
	        	handler: function() {
	        		var record = masterGrid.getSelectedRecord();
		        	if(record) {
		        		openDetailWindow(record);
		        	}
	        	}
            }
        ],*/
        columns:  [  { dataIndex: 'CUSTOM_CODE'	 		,  		width: 80,
        				editor: Unilite.popup('CUST_G',{
        					textFieldName: 'CUSTOM_CODE',
		 	 				DBtextFieldName: 'CUSTOM_CODE',
			  				autoPopup: true,
        					listeners:{ 'onSelected': {
			                    fn: function(records, type  ){
			                    	//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
			                    	var grdRecord = activeSubGrid.getSelectedRecord();
    								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
    								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
			                    },
			                    scope: this
	                  	   },
			                  'onClear' : function(type)	{
			                  		//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
			                  		var grdRecord = activeSubGrid.getSelectedRecord();
    								grdRecord.set('CUSTOM_CODE','');
    								grdRecord.set('CUSTOM_NAME','');
			                  }
							}
						})
        			 }
			  		,{ dataIndex: 'CUSTOM_NAME'	 		,  		width: 130,
			  			editor: Unilite.popup('CUST_G',{
			  				autoPopup: true,
			  				listeners:{ 'onSelected': {
			                    fn: function(records, type  ){
			                    	//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
			                    	var grdRecord = activeSubGrid.getSelectedRecord();
    								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
    								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
			                    },
			                    scope: this
	                  	   	},
			                  'onClear' : function(type)	{
			                  		//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
			                  		var grdRecord = activeSubGrid.getSelectedRecord();
    								grdRecord.set('CUSTOM_CODE','');
    								grdRecord.set('CUSTOM_NAME','');
			                  }
							}
						})
			  		}
			  		,{ dataIndex: 'TYPE'	 			,  		width: 90, hidden: true }
			  		,{ dataIndex: 'PURCHASE_TYPE'	 	,  		width: 82 }
			  		,{ dataIndex: 'SALES_TYPE'		 	,  		width: 83 }
			  		,{ dataIndex: 'APLY_START_DATE'		,  		width: 90}
			  		,{ dataIndex: 'APLY_END_DATE'		,  		width: 90}
			  		,{ dataIndex: 'PURCHASE_RATE'		,  		width: 75 }
			  		,{ dataIndex: 'ORDER_RATE'			,  		width: 106, hidden: true }
			  		,{ dataIndex: 'USE_YN'				,  		width: 106, hidden: true }
			  		,{ dataIndex: 'ITEM_P'				,  		width: 123 }
//			  		,{ dataIndex: 'PRICE'				,  		width: 108}
			  		
			  		,{ dataIndex: 'COMP_CODE'	 		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'DIV_CODE'	 		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'ITEM_CODE'	 		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'MONEY_UNIT'	 		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'ORDER_UNIT'	 		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'UPDATE_DB_USER'		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'UPDATE_DB_TIME'		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'REG_FLAG'			,  		width: 60, hidden: true}
          ] ,
          listeners: {          	
			beforeedit  : function( editor, e, eOpts ) {
				if(regFlag == "2"){
					return false;
				}else{
					if(e.record.phantom){
					
						if (UniUtils.indexOf(e.field, 
								['CUSTOM_CODE','CUSTOM_NAME','MONEY_UNIT','ORDER_UNIT','PURCHASE_RATE','ITEM_P','APLY_START_DATE', 'PURCHASE_TYPE', 'SALES_TYPE']))
								{	
									return true;
								}else{
									return false;
								}					
					}else{
						if(e.field == 'ITEM_P' || e.field == 'PURCHASE_RATE'){	
							return true;
						}else{
							return false;
						}
					}
				}
			}	
          }
    });
    var goodDetailFormSubGrid = Unilite.createGrid('bpr103ukrvGoodDetailFormSubGrid', {    	
    	//region:'center',
    	store : directSubStore,
    	sortableColumns : false,
//    	layout: 'fit',
    	height: 160,
    	width: 729,
    	margin: '0 0 0 92',    	
    	//border:false,
    	uniOpt:{
			 expandLastColumn: false
			,useRowNumberer: false
			,useMultipleSorting: false
			,enterKeyCreateRow: false
    	},
    	dockedItems: [{    		
	        xtype: 'toolbar',
	        dock: 'top',
	        items: [{
                xtype: 'uniBaseButton',
		 		text : '조회',
		 		tooltip : '조회',
		 		iconCls : 'icon-query', 
		 		width: 26, height: 26,
		 		itemId : 'sub_query',
				handler: function() { 
					//if( me._needSave()) {
					var toolbar = activeSubGrid.getDockedItems('toolbar[dock="top"]');
					var needSave = !toolbar[0].getComponent('sub_save').isDisabled();
					if(needSave) {
						Ext.Msg.show({
						     title:'확인',
						     msg: Msg.sMB017 + "\n" + Msg.sMB061,
						     buttons: Ext.Msg.YESNOCANCEL,
						     icon: Ext.Msg.QUESTION,
						     fn: function(res) {
						     	//console.log(res);
						     	if (res === 'yes' ) {
						     		var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
				                  		directSubStore.saveStore();
				                    });
				                    saveTask.delay(500);
						     	} else if(res === 'no') {
						     		directSubStore.loadStoreRecords();
						     	}
						     }
						});
					} else {
						directSubStore.loadStoreRecords();
					}
				}
			},{
                xtype: 'uniBaseButton',
				text : '신규',
				tooltip : '초기화',
				iconCls: 'icon-reset',
				width: 26, height: 26,
		 		itemId : 'sub_reset',
				handler : function() { 
					var toolbar = activeSubGrid.getDockedItems('toolbar[dock="top"]');
					var needSave = !toolbar[0].getComponent('sub_save').isDisabled();
					if(needSave) {
						Ext.Msg.show({
						     title:'확인',
						     msg: Msg.sMB017 + "\n" + Msg.sMB061,
						     buttons: Ext.Msg.YESNOCANCEL,
						     icon: Ext.Msg.QUESTION,
						     fn: function(res) {
						     	console.log(res);
						     	if (res === 'yes' ) {
						     		var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
					                  	directSubStore.saveStore();
					                });
					                saveTask.delay(500);
						     	} else if(res === 'no') {
						     		activeSubGrid.reset();
						     		directSubStore.clearData();
						     		directSubStore.setToolbarButtons('sub_save', false);
						     		directSubStore.setToolbarButtons('sub_delete', false);
						     		goodDetailForm.getField('SALE_COMMON_P').setReadOnly(false);//시중가 readOnly: false
						     	}
						     }
						});
					} else {
						activeSubGrid.reset();
						directSubStore.clearData();
						directSubStore.setToolbarButtons('sub_save', false);
						directSubStore.setToolbarButtons('sub_delete', false);
						goodDetailForm.getField('SALE_COMMON_P').setReadOnly(false);//시중가 readOnly: false
					}					
				}
			},{
                xtype: 'uniBaseButton',
				text : '추가',
				tooltip : '추가',
				iconCls: 'icon-new',
				width: 26, height: 26,
		 		itemId : 'sub_newData',
				handler : function() { 
					var record = masterGrid.getSelectedRecord();
					if(Ext.isEmpty(record)){
						return false;
					}else{
//						if(Ext.isEmpty(record.get('SALE_COMMON_P')) || record.get('SALE_COMMON_P') == 0){
//							Unilite.messageBox('시중가를 입력해 주세요');
//							goodDetailForm.getField('SALE_COMMON_P').focus();
//							return false;
//						}
					}
//					goodDetailForm.getField('SALE_COMMON_P').setReadOnly(true);//시중가 readOnly: true
					var compCode = UserInfo.compCode;  
					var type = '1';
					var divCode = record.get('DIV_CODE');
					var itemCode = record.get('ITEM_CODE');
					var moneyUnit = UserInfo.currency;
					var orderUnit = record.get('ORDER_UNIT');
					var purchageRate = '100';	
					var orderRate 	= '100';	
					var useYn = 'Y'
					var aplyStartDate = UniDate.get('today');
					var aplyEndDate = '2999.12.31';
					var itemP = record.get('SALE_BASIS_P');
					var basisP = record.get('SALE_BASIS_P');
	
	            	var r = {
	            	 	COMP_CODE:			compCode,
	            	 	TYPE:				type,
	            	 	DIV_CODE:			divCode,
	            	 	ITEM_CODE:			itemCode,
	            	 	MONEY_UNIT:			moneyUnit,
	            	 	ORDER_UNIT:			orderUnit,
						PURCHASE_RATE:		purchageRate,
						ORDER_RATE:			orderRate,
						USE_YN:				useYn,
						APLY_START_DATE:	aplyStartDate,
						APLY_END_DATE:		aplyEndDate,
						ITEM_P:				itemP,
						BASIS_P:			basisP
			        };
					activeSubGrid.createRow(r,'ITEM_CODE');
				}
			},{
                xtype: 'uniBaseButton',
				text : '삭제',
				tooltip : '삭제',
				iconCls: 'icon-delete',disabled: true,
				width: 26, height: 26,
		 		itemId : 'sub_delete',
				handler : function() { 
					var selRow = goodDetailFormSubGrid.getSelectedRecord();
					if(selRow.phantom === true)	{
						goodDetailFormSubGrid.deleteSelectedRow();
					}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						goodDetailFormSubGrid.setEndDate();
						goodDetailFormSubGrid.deleteSelectedRow();						
					}		
				}
				
			},{
                xtype: 'uniBaseButton',
				text : '저장', 
				tooltip : '저장', 
				iconCls: 'icon-save',disabled: true,
				width: 26, height: 26,
		 		itemId : 'sub_save',
				handler : function() {
					var record = masterGrid.getSelectedRecord();
				    var param = {"COMP_CODE": UserInfo.compCode, "DIV_CODE": record.get('DIV_CODE'), "ITEM_CODE": record.get('ITEM_CODE') }
					bpr103ukrvService.checkItemCode(param, function(provider1, response)	{							
						if(provider1[0].CNT > 0){
							var inValidRecs = directSubStore.getInvalidRecords();       	
							if(inValidRecs.length == 0 )	{
								var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
				                  	if(goodDetailFormSubGrid.setAplyDate()){
				                  		directSubStore.saveStore();
				                  	}                  	
			                  	});
			                  	saveTask.delay(500);
							}else {
								goodDetailFormSubGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
							}
						}else{
							Unilite.messageBox("품목을 먼저 등록해야 합니다.");					
						}
					});                  	
				}
			}]
	    }],	    
    	/* tbar: ['->',
            {
	        	text:'상세보기',
	        	handler: function() {
	        		var record = masterGrid.getSelectedRecord();
		        	if(record) {
		        		openDetailWindow(record);
		        	}
	        	}
            }
        ],*/
        columns:  [  { dataIndex: 'CUSTOM_CODE'	 		,  		width: 90,
        				editor: Unilite.popup('CUST_G',{
        					textFieldName: 'CUSTOM_CODE',
		 	 				DBtextFieldName: 'CUSTOM_CODE',
			  				autoPopup: true,
        					listeners:{ 'onSelected': {
			                    fn: function(records, type  ){
			                    	//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
			                    	var grdRecord = activeSubGrid.uniOpt.currentRecord;
    								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
    								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
			                    },
			                    scope: this
	                  	   },
			                  'onClear' : function(type)	{
			                  		//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
			                  		var grdRecord = activeSubGrid.uniOpt.currentRecord;
    								grdRecord.set('CUSTOM_CODE','');
    								grdRecord.set('CUSTOM_NAME','');
			                  }
							}
						})
        			 }
			  		,{ dataIndex: 'CUSTOM_NAME'	 		,  		width: 152,
			  			editor: Unilite.popup('CUST_G',{
			  				autoPopup: true,
			  				listeners:{ 'onSelected': {
			                    fn: function(records, type  ){
			                    	//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
			                    	var grdRecord = activeSubGrid.uniOpt.currentRecord;
    								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
    								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
			                    },
			                    scope: this
	                  	   	},
			                  'onClear' : function(type)	{
			                  		//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
			                  		var grdRecord = activeSubGrid.uniOpt.currentRecord;
    								grdRecord.set('CUSTOM_CODE','');
    								grdRecord.set('CUSTOM_NAME','');
			                  }
							}
						})
			  		}
			  		,{ dataIndex: 'TYPE'	 			,  		width: 90, hidden: true }
			  		,{ dataIndex: 'PURCHASE_TYPE'	 	,  		width: 70 }
			  		,{ dataIndex: 'SALES_TYPE'		 	,  		width: 70 }
			  		,{ dataIndex: 'APLY_START_DATE'		,  		width: 90}
			  		,{ dataIndex: 'APLY_END_DATE'		,  		width: 90}
			  		,{ dataIndex: 'PURCHASE_RATE'		,  		width: 75 }
			  		,{ dataIndex: 'ORDER_RATE'			,  		width: 106, hidden: true }
			  		,{ dataIndex: 'USE_YN'				,  		width: 106, hidden: true }
			  		,{ dataIndex: 'ITEM_P'				,  		width: 90 }
					,{ dataIndex: 'BASIS_P'				,  		width: 90, hidden: true}			  		
			  		,{ dataIndex: 'COMP_CODE'	 		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'DIV_CODE'	 		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'ITEM_CODE'	 		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'MONEY_UNIT'	 		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'ORDER_UNIT'	 		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'UPDATE_DB_USER'		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'UPDATE_DB_TIME'		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'REG_FLAG'			,  		width: 60, hidden: true}
          ] ,
          listeners: {          	
			beforeedit  : function( editor, e, eOpts ) {
				if(regFlag == "2"){
					return false;
				}else{
					if(e.record.phantom){
					
						if (UniUtils.indexOf(e.field, 
								['CUSTOM_CODE','CUSTOM_NAME','MONEY_UNIT','ORDER_UNIT','PURCHASE_RATE','ITEM_P','APLY_START_DATE', 'PURCHASE_TYPE', 'SALES_TYPE']))
								{	
									return true;
								}else{
									return false;
								}					
					}else{
						if(e.field == 'ITEM_P' || e.field == 'PURCHASE_RATE'){	
							return true;
						}else{
							return false;
						}
					}
				}
			}
          },          
        setAplyDate: function() {
        	var isSuccess = true;
        	var totRecords = directSubStore.data.items;					//그리드의 모든 레코드
        	var duplRecord = new Array();								//거래처, 매입조건, 판매형태가 같은 신규 레코드들
        	var compareRecords = new Array();							//거래처, 매입조건, 판매형태가 같은 기존 레코드들
        	var updateRec;												//적용종료될 레코드
        	var insertRec;												//적용시작될 레코드
        	var reci = 0;												//거래처, 매입조건, 판매형태가 같은 레코드들의 length
        	var duReci = 0;
        	var aplyStartDate = '';										//최신날짜 가져오기 위해..
        	
        	Ext.each(totRecords, function(record1,i){
        		if(record1.phantom){
        			Ext.each(totRecords, function(record1_1,i_1){
	        			if( record1.get('CUSTOM_CODE') 	   == record1_1.get('CUSTOM_CODE') &&
		        			record1.get('PURCHASE_TYPE')   == record1_1.get('PURCHASE_TYPE') &&
		        			record1.get('SALES_TYPE') 	   == record1_1.get('SALES_TYPE') &&
		        			record1_1.phantom
		        		){	        			
		        			duplRecord[duReci] = record1_1;					
		        			duReci++;  
		        		}	        		
	        		});
	        		if(duplRecord.length > 1 && isSuccess){
	        			Unilite.messageBox('중복되는 자료가 입력되었습니다.\n 저장후 입력하여 주십시요.\n 매입처명:' + duplRecord[0].get('CUSTOM_NAME'));
	        			isSuccess = false;
	        			duplRecord = [];
    					return isSuccess;
	        		}	
	        		
        			Ext.each(totRecords, function(record2,j){
	        			if( record1.get('CUSTOM_CODE') 	   == record2.get('CUSTOM_CODE') &&
		        			record1.get('PURCHASE_TYPE')   == record2.get('PURCHASE_TYPE') &&
		        			record1.get('SALES_TYPE') 	   == record2.get('SALES_TYPE') &&
		        			!record2.phantom
		        		){	        			
		        			compareRecords[reci] = record2;					//거래처, 매입조건, 판매형태가 같은 기존 레코드들 담기.
		        			reci++;  
		        		}	        		
	        		});
	        		
	        		
//		        var recordI;
//		        var recordJ;
//		        var temp = new Array();
//		        for(var i = 0; i < compareRecords.length-1; i++){
//		        	for(var j = 0; j < compareRecords.length-1; j++){	        		
//		        		if(compareRecords[j].get('APLY_START_DATE') < compareRecords[j+1].get('APLY_START_DATE')){
//		        			temp = compareRecords[j];
//		        			compareRecords[j] = compareRecords[j+1];
//		        			compareRecords[j+1] = temp;
//		        		}		        	
//		        	}
//		        }
//	        Ext.each(compareRecords, function(record3,i){
//	        	Unilite.messageBox(record3.get('APLY_START_DATE'));
//	        });		
	        		
	        		if(compareRecords.length > 0){
//	        			if(compareRecords.length > 1){
//	        				Unilite.messageBox('중복되는 자료가 입력되었습니다.\n 매입처명:' + compareRecords[0].get('CUSTOM_NAME'));
//	    					isSuccess = false;
//	    					return isSuccess;	 	        			
//	        			}
	        			Ext.each(compareRecords, function(record3,i){
	        				if(UniDate.getDbDateStr(record3.get('APLY_START_DATE')) > aplyStartDate){
	        					aplyStartDate = UniDate.getDbDateStr(record3.get('APLY_START_DATE'));
	        					updateRec = record3;        					
	        					insertRec = record1;
	        				}        			
	    				});
//	    				if(updateRec.phantom && isSuccess){
//	    					Unilite.messageBox('중복되는 자료가 입력되었습니다.\n 매입처명:' + updateRec.get('CUSTOM_NAME'));
//	    					isSuccess = false;
//	    					return isSuccess;   					
//	    				}
	    				if(updateRec && insertRec && isSuccess){
	    					if(UniDate.getDbDateStr(insertRec.get('APLY_START_DATE')) >  UniDate.getDbDateStr(updateRec.get('APLY_START_DATE'))){
	    						updateRec.set('APLY_END_DATE', UniDate.add(insertRec.get('APLY_START_DATE'),  {days: -1}));
								insertRec.set('APLY_END_DATE', '29991231');
	    					}		    				
	    				}	    				
	        		}
	        		compareRecords = [];	        		
	        		reci = 0;
	        		duReci = 0;
	        		aplyStartDate = '';
	        		updateRec = null;
	        		insertRec = null;
	        		isSuccess = true;
        		}        		
		    });
		    if(isSuccess){
		    	return true;
		    }else{
		    	return false;
		    }
        },          
        setEndDate: function() {
        	var deleteRecord = goodDetailFormSubGrid.getSelectedRecord();				//삭제될 레코드
			if(deleteRecord.phantom) return false;        	
			
        	var totRecords = directSubStore.data.items;					//그리드의 모든 레코드        	
        	var compareRecords = new Array();							//거래처, 매입조건, 판매형태가 같은 기존 레코드들
        	var updateRec;												//적용종료될 레코드        	
        	var reci = 0;												//거래처, 매입조건, 판매형태가 같은 레코드들의 length
        	var aplyStartDate = '';										//최신날짜 가져오기 위해..        	
        	
        	Ext.each(totRecords, function(record1,i){    
    			if( record1.get('CUSTOM_CODE') 	   == deleteRecord.get('CUSTOM_CODE') &&
        			record1.get('PURCHASE_TYPE')   == deleteRecord.get('PURCHASE_TYPE') &&
        			record1.get('SALES_TYPE') 	   == deleteRecord.get('SALES_TYPE') &&
        			!record1.phantom
        		){	        			
        			compareRecords[reci] = record1;					//거래처, 매입조건, 판매형태가 같은 기존 레코드들 담기.
        			reci++;  
        		}
		    });
		    if(compareRecords.length > 0){        			
    			Ext.each(compareRecords, function(record2,i){
    				if(UniDate.getDbDateStr(record2.get('APLY_START_DATE')) > aplyStartDate && UniDate.getDbDateStr(record2.get('APLY_START_DATE')) != UniDate.getDbDateStr(deleteRecord.get('APLY_START_DATE'))){
    					aplyStartDate = UniDate.getDbDateStr(record2.get('APLY_START_DATE'));
    					updateRec = record2; 
    				}        			
				});

				if(updateRec){
					updateRec.set('APLY_END_DATE', '29991231');
				}	    				
    		}
        }
    });
	var bookDetailFormSubGrid =  Unilite.createGrid('bpr103ukrvBookDetailFormSubGrid', {    	
    	//region:'center',
    	store : directSubStore,
    	sortableColumns : false,
//    	layout: 'fit',
    	height: 230,
    	width: 727,
    	margin: '0 0 0 117',    	
    	//border:false,
    	uniOpt:{
			 expandLastColumn: false
			,useRowNumberer: false
			,useMultipleSorting: false
			,enterKeyCreateRow: false
    	},
    	dockedItems: [{    		
	        xtype: 'toolbar',
	        dock: 'top',
	        items: [{
                xtype: 'uniBaseButton',
		 		text : '조회',
		 		tooltip : '조회',
		 		iconCls : 'icon-query', 
		 		width: 26, height: 26,
		 		itemId : 'sub_query',
				handler: function() { 
					//if( me._needSave()) {
					var toolbar = activeSubGrid.getDockedItems('toolbar[dock="top"]');
					var needSave = !toolbar[0].getComponent('sub_save').isDisabled();
					if(needSave) {
						Ext.Msg.show({
						     title:'확인',
						     msg: Msg.sMB017 + "\n" + Msg.sMB061,
						     buttons: Ext.Msg.YESNOCANCEL,
						     icon: Ext.Msg.QUESTION,
						     fn: function(res) {
						     	//console.log(res);
						     	if (res === 'yes' ) {
						     		var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
				                  		directSubStore.saveStore();
				                    });
				                    saveTask.delay(500);
						     	} else if(res === 'no') {
						     		directSubStore.loadStoreRecords();
						     	}
						     }
						});
					} else {
						directSubStore.loadStoreRecords();
					}
				}
			},{
                xtype: 'uniBaseButton',
				text : '신규',
				tooltip : '초기화',
				iconCls: 'icon-reset',
				width: 26, height: 26,
		 		itemId : 'sub_reset',
				handler : function() { 
					var toolbar = activeSubGrid.getDockedItems('toolbar[dock="top"]');
					var needSave = !toolbar[0].getComponent('sub_save').isDisabled();
					if(needSave) {
						Ext.Msg.show({
						     title:'확인',
						     msg: Msg.sMB017 + "\n" + Msg.sMB061,
						     buttons: Ext.Msg.YESNOCANCEL,
						     icon: Ext.Msg.QUESTION,
						     fn: function(res) {
						     	console.log(res);
						     	if (res === 'yes' ) {
						     		var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
					                  	directSubStore.saveStore();
					                });
					                saveTask.delay(500);
						     	} else if(res === 'no') {
						     		activeSubGrid.reset();
						     		directSubStore.clearData();
						     		directSubStore.setToolbarButtons('sub_save', false);
						     		directSubStore.setToolbarButtons('sub_delete', false);
						     		goodDetailForm.getField('SALE_COMMON_P').setReadOnly(false);//시중가 readOnly: false
						     	}
						     }
						});
					} else {
						activeSubGrid.reset();
						directSubStore.clearData();
						directSubStore.setToolbarButtons('sub_save', false);
						directSubStore.setToolbarButtons('sub_delete', false);
						goodDetailForm.getField('SALE_COMMON_P').setReadOnly(false);//시중가 readOnly: false
					}					
				}
			},{
                xtype: 'uniBaseButton',
				text : '추가',
				tooltip : '추가',
				iconCls: 'icon-new',
				width: 26, height: 26,
		 		itemId : 'sub_newData',
				handler : function() { 
					var record = masterGrid.getSelectedRecord();
					if(Ext.isEmpty(record)){
						return false;
					}else{
//						if(Ext.isEmpty(record.get('SALE_COMMON_P')) || record.get('SALE_COMMON_P') == 0){
//							Unilite.messageBox('시중가를 입력해 주세요');
//							goodDetailForm.getField('SALE_COMMON_P').focus();
//							return false;
//						}
					}
//					bookDetailForm.getField('SALE_COMMON_P').setReadOnly(true);//시중가 readOnly: true
					var compCode = UserInfo.compCode;  
					var type = '1';
					var divCode = record.get('DIV_CODE');
					var itemCode = record.get('ITEM_CODE');
					var moneyUnit = UserInfo.currency;
					var orderUnit = record.get('ORDER_UNIT');
					var purchageRate = '100';	
					var orderRate 	= '100';	
					var useYn = 'Y'
					var aplyStartDate = UniDate.get('today');
					var aplyEndDate = '2999.12.31';
					var itemP = record.get('SALE_BASIS_P');
					var basisP = record.get('SALE_BASIS_P');
	
	            	var r = {
	            	 	COMP_CODE:			compCode,
	            	 	TYPE:				type,
	            	 	DIV_CODE:			divCode,
	            	 	ITEM_CODE:			itemCode,
	            	 	MONEY_UNIT:			moneyUnit,
	            	 	ORDER_UNIT:			orderUnit,
						PURCHASE_RATE:		purchageRate,
						ORDER_RATE:		orderRate,
						USE_YN:				useYn,
						APLY_START_DATE:	aplyStartDate,
						APLY_END_DATE:		aplyEndDate,
						ITEM_P:				itemP,
						BASIS_P:			basisP
			        };
					activeSubGrid.createRow(r,'ITEM_CODE');
				}
			},{
                xtype: 'uniBaseButton',
				text : '삭제',
				tooltip : '삭제',
				iconCls: 'icon-delete',disabled: true,
				width: 26, height: 26,
		 		itemId : 'sub_delete',
				handler : function() { 
					var selRow = bookDetailFormSubGrid.getSelectedRecord();
					if(selRow.phantom === true)	{
						bookDetailFormSubGrid.deleteSelectedRow();
					}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						bookDetailFormSubGrid.setEndDate();
						bookDetailFormSubGrid.deleteSelectedRow();						
					}	
				}
				
			},{
                xtype: 'uniBaseButton',
				text : '저장', 
				tooltip : '저장', 
				iconCls: 'icon-save',disabled: true,
				width: 26, height: 26,
		 		itemId : 'sub_save',
				handler : function() { 
				  var record = masterGrid.getSelectedRecord();
				  var param = {"COMP_CODE": UserInfo.compCode, "DIV_CODE": record.get('DIV_CODE'), "ITEM_CODE": record.get('ITEM_CODE') }
                  bpr103ukrvService.checkItemCode(param, function(provider1, response)	{							
						if(provider1[0].CNT > 0){
							var inValidRecs = directSubStore.getInvalidRecords();       	
							if(inValidRecs.length == 0 )	{
								var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
				                  	if(goodDetailFormSubGrid.setAplyDate()){
				                  		directSubStore.saveStore();
				                  	}                  	
			                  	});
			                  	saveTask.delay(500);
							}else {
								goodDetailFormSubGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
							}
						}else{
							Unilite.messageBox("품목을 먼저 등록해야 합니다.");					
						}
					});
                }
			}]
	    }],	    
    	/* tbar: ['->',
            {
	        	text:'상세보기',
	        	handler: function() {
	        		var record = masterGrid.getSelectedRecord();
		        	if(record) {
		        		openDetailWindow(record);
		        	}
	        	}
            }
        ],*/
        columns:  [  { dataIndex: 'CUSTOM_CODE'	 		,  		width: 80,
        				editor: Unilite.popup('CUST_G',{
        					textFieldName: 'CUSTOM_CODE',
		 	 				DBtextFieldName: 'CUSTOM_CODE',
			  				autoPopup: true,
        					listeners:{ 'onSelected': {
			                    fn: function(records, type  ){
			                    	//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
			                    	var grdRecord = activeSubGrid.getSelectedRecord();
    								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
    								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
			                    },
			                    scope: this
	                  	   },
			                  'onClear' : function(type)	{
			                  		//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
			                  		var grdRecord = activeSubGrid.getSelectedRecord();
    								grdRecord.set('CUSTOM_CODE','');
    								grdRecord.set('CUSTOM_NAME','');
			                  }
							}
						})
        			 }
			  		,{ dataIndex: 'CUSTOM_NAME'	 		,  		width: 152,
			  			editor: Unilite.popup('CUST_G',{
			  				autoPopup: true,
			  				listeners:{ 'onSelected': {
			                    fn: function(records, type  ){
			                    	//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
			                    	var grdRecord = activeSubGrid.getSelectedRecord();
    								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
    								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
			                    },
			                    scope: this
	                  	   	},
			                  'onClear' : function(type)	{
			                  		//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
			                  		var grdRecord = activeSubGrid.getSelectedRecord();
    								grdRecord.set('CUSTOM_CODE','');
    								grdRecord.set('CUSTOM_NAME','');
			                  }
							}
						})
			  		}
			  		,{ dataIndex: 'TYPE'	 			,  		width: 90, hidden: true }
			  		,{ dataIndex: 'PURCHASE_TYPE'	 	,  		width: 79 }
			  		,{ dataIndex: 'SALES_TYPE'		 	,  		width: 79 }
			  		,{ dataIndex: 'APLY_START_DATE'		,  		width: 85}
			  		,{ dataIndex: 'APLY_END_DATE'		,  		width: 85}
			  		,{ dataIndex: 'PURCHASE_RATE'		,  		width: 75 }
			  		,{ dataIndex: 'ORDER_RATE'			,  		width: 106, hidden: true }
			  		,{ dataIndex: 'USE_YN'				,  		width: 106, hidden: true }
			  		,{ dataIndex: 'ITEM_P'				,  		width: 90 }
			  		,{ dataIndex: 'BASIS_P'				,  		width: 90, hidden: true}
			  		,{ dataIndex: 'COMP_CODE'	 		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'DIV_CODE'	 		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'ITEM_CODE'	 		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'MONEY_UNIT'	 		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'ORDER_UNIT'	 		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'UPDATE_DB_USER'		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'UPDATE_DB_TIME'		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'REG_FLAG'			,  		width: 60, hidden: true}
          ] ,
          listeners: {          	
			beforeedit  : function( editor, e, eOpts ) {
				if(regFlag == "2"){
					return false;
				}else{
					if(e.record.phantom){
					
						if (UniUtils.indexOf(e.field, 
								['CUSTOM_CODE','CUSTOM_NAME','MONEY_UNIT','ORDER_UNIT','PURCHASE_RATE','ITEM_P','APLY_START_DATE', 'PURCHASE_TYPE', 'SALES_TYPE']))
								{	
									return true;
								}else{
									return false;
								}					
					}else{
						if(e.field == 'ITEM_P' || e.field == 'PURCHASE_RATE'){	
							return true;
						}else{
							return false;
						}
					}
				}
			}
          },          
        setAplyDate: function() {
        	var isSuccess = true;
        	var totRecords = directSubStore.data.items;					//그리드의 모든 레코드
        	var duplRecord = new Array();								//거래처, 매입조건, 판매형태가 같은 신규 레코드들
        	var compareRecords = new Array();							//거래처, 매입조건, 판매형태가 같은 기존 레코드들
        	var updateRec;												//적용종료될 레코드
        	var insertRec;												//적용시작될 레코드
        	var reci = 0;												//거래처, 매입조건, 판매형태가 같은 레코드들의 length
        	var duReci = 0;
        	var aplyStartDate = '';										//최신날짜 가져오기 위해..
        	
        	Ext.each(totRecords, function(record1,i){
        		if(record1.phantom){
        			Ext.each(totRecords, function(record1_1,i_1){
	        			if( record1.get('CUSTOM_CODE') 	   == record1_1.get('CUSTOM_CODE') &&
		        			record1.get('PURCHASE_TYPE')   == record1_1.get('PURCHASE_TYPE') &&
		        			record1.get('SALES_TYPE') 	   == record1_1.get('SALES_TYPE') &&
		        			record1_1.phantom
		        		){	        			
		        			duplRecord[duReci] = record1_1;					
		        			duReci++;  
		        		}	        		
	        		});
	        		if(duplRecord.length > 1 && isSuccess){
	        			Unilite.messageBox('중복되는 자료가 입력되었습니다.\n 저장후 입력하여 주십시요.\n 매입처명:' + duplRecord[0].get('CUSTOM_NAME'));
	        			isSuccess = false;
	        			duplRecord = [];
    					return isSuccess;
	        		}	
	        		
        			Ext.each(totRecords, function(record2,j){
	        			if( record1.get('CUSTOM_CODE') 	   == record2.get('CUSTOM_CODE') &&
		        			record1.get('PURCHASE_TYPE')   == record2.get('PURCHASE_TYPE') &&
		        			record1.get('SALES_TYPE') 	   == record2.get('SALES_TYPE') &&
		        			!record2.phantom
		        		){	        			
		        			compareRecords[reci] = record2;					//거래처, 매입조건, 판매형태가 같은 기존 레코드들 담기.
		        			reci++;  
		        		}	        		
	        		});
	        		
	        		
//		        var recordI;
//		        var recordJ;
//		        var temp = new Array();
//		        for(var i = 0; i < compareRecords.length-1; i++){
//		        	for(var j = 0; j < compareRecords.length-1; j++){	        		
//		        		if(compareRecords[j].get('APLY_START_DATE') < compareRecords[j+1].get('APLY_START_DATE')){
//		        			temp = compareRecords[j];
//		        			compareRecords[j] = compareRecords[j+1];
//		        			compareRecords[j+1] = temp;
//		        		}		        	
//		        	}
//		        }
//	        Ext.each(compareRecords, function(record3,i){
//	        	Unilite.messageBox(record3.get('APLY_START_DATE'));
//	        });		
	        		
	        		if(compareRecords.length > 0){
//	        			if(compareRecords.length > 1){
//	        				Unilite.messageBox('중복되는 자료가 입력되었습니다.\n 매입처명:' + compareRecords[0].get('CUSTOM_NAME'));
//	    					isSuccess = false;
//	    					return isSuccess;	 	        			
//	        			}
	        			Ext.each(compareRecords, function(record3,i){
	        				if(UniDate.getDbDateStr(record3.get('APLY_START_DATE')) > aplyStartDate){
	        					aplyStartDate = UniDate.getDbDateStr(record3.get('APLY_START_DATE'));
	        					updateRec = record3;        					
	        					insertRec = record1;
	        				}        			
	    				});
//	    				if(updateRec.phantom && isSuccess){
//	    					Unilite.messageBox('중복되는 자료가 입력되었습니다.\n 매입처명:' + updateRec.get('CUSTOM_NAME'));
//	    					isSuccess = false;
//	    					return isSuccess;   					
//	    				}
	    				if(updateRec && insertRec && isSuccess){
	    					if(UniDate.getDbDateStr(insertRec.get('APLY_START_DATE')) >  UniDate.getDbDateStr(updateRec.get('APLY_START_DATE'))){
	    						updateRec.set('APLY_END_DATE', UniDate.add(insertRec.get('APLY_START_DATE'),  {days: -1}));
								insertRec.set('APLY_END_DATE', '29991231');
	    					}		    				
	    				}	    				
	        		}
	        		compareRecords = [];	        		
	        		reci = 0;
	        		duReci = 0;
	        		aplyStartDate = '';
	        		updateRec = null;
	        		insertRec = null;
	        		isSuccess = true;
        		}        		
		    });
		    if(isSuccess){
		    	return true;
		    }else{
		    	return false;
		    }
        },          
        setEndDate: function() {
        	var deleteRecord = bookDetailFormSubGrid.getSelectedRecord();				//삭제될 레코드
			if(deleteRecord.phantom) return false;        	
			
        	var totRecords = directSubStore.data.items;					//그리드의 모든 레코드        	
        	var compareRecords = new Array();							//거래처, 매입조건, 판매형태가 같은 기존 레코드들
        	var updateRec;												//적용종료될 레코드        	
        	var reci = 0;												//거래처, 매입조건, 판매형태가 같은 레코드들의 length
        	var aplyStartDate = '';										//최신날짜 가져오기 위해..        	
        	
        	Ext.each(totRecords, function(record1,i){    
    			if( record1.get('CUSTOM_CODE') 	   == deleteRecord.get('CUSTOM_CODE') &&
        			record1.get('PURCHASE_TYPE')   == deleteRecord.get('PURCHASE_TYPE') &&
        			record1.get('SALES_TYPE') 	   == deleteRecord.get('SALES_TYPE') &&
        			!record1.phantom
        		){	        			
        			compareRecords[reci] = record1;					//거래처, 매입조건, 판매형태가 같은 기존 레코드들 담기.
        			reci++;  
        		}
		    });
		    if(compareRecords.length > 0){        			
    			Ext.each(compareRecords, function(record2,i){
    				if(UniDate.getDbDateStr(record2.get('APLY_START_DATE')) > aplyStartDate && UniDate.getDbDateStr(record2.get('APLY_START_DATE')) != UniDate.getDbDateStr(deleteRecord.get('APLY_START_DATE'))){
    					aplyStartDate = UniDate.getDbDateStr(record2.get('APLY_START_DATE'));
    					updateRec = record2; 
    				}        			
				});

				if(updateRec){
					updateRec.set('APLY_END_DATE', '29991231');
				}	    				
    		}
        }
    });
    	//제품정보등록 상세
    
    var goodDetailForm = Unilite.createForm('goodDetailForm', {
    	//region:'south',
    	//weight:-100,
    	//height:400,
    	//split:true,
//    	title: '상품정보',
		disabled:false,
    	hidden: true,
    	autoScroll: true,
    	flex:1,
    	masterGrid: masterGrid,
        padding: '0 0 0 1',
	    layout: {type: 'uniTable', columns: 4, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
	    defaultType: 'uniFieldset',
	    defaults : { margin: '0 0 0 0'},
	    items : [{
	    		xtype: 'container',
	    		colspan: 4,
	    		layout: {type: 'vbox', align: 'stretch'},
	    		items: [{
	    			xtype: 'container',
	    			layout: { type: 'uniTable', columns: 3},
	    			defaultType: 'uniTextfield',
	    			defaults : {enforceMaxLength: true},
	    			items:[{
		    			fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
		    			name: 'ITEM_CODE',
		    			allowBlank: true,
		    			maxLength :20
		    		}, {
		    			fieldLabel: '<t:message code="system.label.base.itemname2" default="품명"/>',
		    			labelWidth: 114,
		    			name: 'ITEM_NAME',		    			
		    			width: 578,
		    			allowBlank: false,
		    			maxLength :40,
		    			readOnly: true
		    		}/*, {
    					text: '재고조회',
    					xtype: 'button',
    					margin: '0 0 0 207',
    					handller: function(){
    					
    					}
    				}*/]
	    		}, {
	    			xtype: 'container',
	    			layout: { type: 'uniTable', columns: 3},
	    			defaultType: 'uniTextfield',
	    			defaults : {enforceMaxLength: true},
	    			items:[{ 
		    			xtype: 'displayfield',
		    			name: ''
		    		}, {
		    			fieldLabel: '품명1',
		    			name: 'ITEM_NAME1',
		    			labelWidth: 358,
		    			maxLength :40,
		    			readOnly: true
		    		}, {
		    			fieldLabel: '품명2',
		    			name: 'ITEM_NAME2',
		    			labelWidth: 154,
		    			maxLength :40,
		    			readOnly: true
		    		}]
	    		}]
	    },
	    	
	    		{ 
        			  title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>'
        			, defaults: {type: 'uniTextfield', enforceMaxLength: true}
        			, layout: { type: 'uniTable', columns: 1}
        			, height: 435
        			, items :[	 { name: 'ITEM_LEVEL1',  			fieldLabel: '<t:message code="system.label.base.majorgroup" default="대분류"/>' 		,xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('bpr103ukrvLevel1Store'), child: 'ITEM_LEVEL2', readOnly: true}   
						  		,{ name: 'ITEM_LEVEL2',  			fieldLabel: '<t:message code="system.label.base.middlegroup" default="중분류"/>' 		,xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('bpr103ukrvLevel2Store'), child: 'ITEM_LEVEL3', readOnly: true}    
						  		,{ name: 'ITEM_LEVEL3',  			fieldLabel: '<t:message code="system.label.base.minorgroup" default="소분류"/>' 		,xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('bpr103ukrvLevel3Store'), readOnly: true}
						  		,{xtype: 'displayfield', name: ''}
						  		,{ name: 'SPEC',  					fieldLabel: '<t:message code="system.label.base.spec" default="규격"/>' 		,maxLength: 160, readOnly: true} 
						  		,{ name: 'STOCK_UNIT',  			fieldLabel: '<t:message code="system.label.base.inventoryunit" default="재고단위"/>',	 xtype:'uniCombobox',	comboType:'AU', comboCode:'B013' , allowBlank:false, displayField: 'value', fieldStyle: 'text-align: center;', readOnly: true}     
						  		, Unilite.popup('ITEM_GROUP',  	   {fieldLabel: '<t:message code="system.label.base.repmodel" default="대표모델"/>', textFieldName:'ITEM_GROUP_NAME', valueFieldName:'ITEM_GROUP', valueFieldWidth:120, textFieldWidth:150, verticalMode:true, readOnly: true,
						  			listeners: {
										onClear: function(type)	{
											var grdRecord = masterGrid.uniOpt.currentRecord;
											grdRecord.set('ITEM_GROUP', '');
											grdRecord.set('ITEM_GROUP_NAME', '');
										}
									}
						  		})
//						  		,{ name: 'STOCK_CARE_YN',  			fieldLabel: '<t:message code="system.label.base.inventorymanageobject" default="재고관리대상"/>', xtype:'uniRadiogroup', comboType:'AU', comboCode:'B010', width:235, allowBlank:false, readOnly: true}
						  		,{
								    xtype: 'radiogroup',
								    readOnly: true,
								    id: 'rdo1',
								    fieldLabel: '<t:message code="system.label.base.inventorymanageobject" default="재고관리대상"/>',	
								    items : [{
								    	boxLabel: '예',
								    	name: 'STOCK_CARE_YN' ,
								    	inputValue: 'Y',
								    	width:70
								    }, {boxLabel: '아니오',
								    	name: 'STOCK_CARE_YN',
								    	inputValue: 'N',
								    	width:70
								    }]				
								}
						  		,{ name: 'START_DATE',  			fieldLabel: '<t:message code="system.label.base.usestartdate" default="사용시작일"/>', 	xtype : 'uniDatefield', maxLength: 10, readOnly: true}    
						  		,{ name: 'STOP_DATE',  				fieldLabel: '<t:message code="system.label.base.usestopdate" default="사용중단일"/>', 	xtype : 'uniDatefield', maxLength: 10, readOnly: true}    
//						  		,{ name: 'USE_YN',  				fieldLabel: '<t:message code="system.label.base.useyn" default="사용여부"/>', 	xtype:'uniRadiogroup', comboType:'AU', comboCode:'B010', width:235, allowBlank:false, readOnly: true}
						  		,{
								    xtype: 'radiogroup',
								    readOnly: true,
								    id: 'rdo2',
								    fieldLabel: '<t:message code="system.label.base.useyn" default="사용여부"/>',	
								    items : [{
								    	boxLabel: '예',
								    	name: 'USE_YN' ,
								    	inputValue: 'Y',
								    	width:70
								    }, {boxLabel: '아니오',
								    	name: 'USE_YN',
								    	inputValue: 'N',
								    	width:70
								    }]				
								}
						  								  		
					         ]
	    		}
	    	   ,{   title: '제원정보'
        			, layout: {
					            type: 'uniTable',
					            columns: 2
					        }
        			, defaults: {type: 'uniTextfield', colspan: 2, enforceMaxLength: true}
        			, height: 435
        			, width: 300
        			, items :[	 { name: 'TAX_TYPE',  				fieldLabel: '<t:message code="system.label.base.taxtype" default="세구분"/>', 	xtype:'uniCombobox', comboType:'AU', comboCode:'B059' , allowBlank:false, readOnly: true, fieldStyle: 'text-align: center;'}         
						  		,{ name: 'SALE_BASIS_P',  	 		fieldLabel: '<t:message code="system.label.base.sellingprice" default="판매단가"/>', 	xtype : 'uniNumberfield', allowBlank: false, maxLength: 18, colspan: 1, readOnly: true}
						  		,{xtype: 'component'}
						  	   , {
						           fieldLabel: '이전단가',//DB용
						           name: 'BF_SALE_BASIS_P',
						           xtype:'uniNumberfield',
						           readOnly: true
						        }, {
						           fieldLabel: '적용일자',
						           name: 'SALE_DATE',//단가검색 팝업 날짜 hidden
						           xtype:'uniDatefield',
						           allowBlank: false,
						           vlaue: UniDate.get('today'),
						           hidden: true
						        }
							    ,{ name: 'SALE_COMMON_P',  	 		fieldLabel: '시중가', allowBlank: true,	xtype : 'uniNumberfield', maxLength: 18, readOnly: true}
							    ,{ name: 'CONSIGNMENT_FEE',  	 	fieldLabel: '위탁수수료', 	xtype : 'uniNumberfield', maxLength: 18}
							    ,{xtype: 'displayfield', name: ''}
//							    ,{ name: 'AUTO_DISCOUNT',  	 		fieldLabel: '자동할인', 	xtype : 'uniRadiogroup', comboType:'AU', comboCode:'B010', width:235, allowBlank:false, readOnly: true}
							    ,{
								    xtype: 'radiogroup',
								    readOnly: true,
								    id: 'rdo3',
								    fieldLabel: '자동할인',	
								    items : [{
								    	boxLabel: '예',
								    	name: 'AUTO_DISCOUNT' ,
								    	inputValue: 'Y',
								    	width:70
								    }, {boxLabel: '아니오',
								    	name: 'AUTO_DISCOUNT',
								    	inputValue: 'N',
								    	width:70
								    }]				
								} ,{
								    xtype: 'radiogroup',
								    fieldLabel: '회원할인대상',			    
//								    colspan: 2,
								    items : [{
								    	boxLabel: '예',
								    	name: 'MEMBER_DISCOUNT_YN' ,
								    	inputValue: 'Y',
								    	width:70
								    }, {boxLabel: '아니오',
								    	name: 'MEMBER_DISCOUNT_YN',
								    	inputValue: 'N',
								    	width:70,
								    	checked: true
								    }]				
								}
//							    ,{ name: 'SPEC_CONTROL',  	 		fieldLabel: '특정', 		xtype : 'uniRadiogroup', comboType:'AU', comboCode:'B010', width:235, allowBlank:false, readOnly: true}
							    ,{
								    xtype: 'radiogroup',
								    readOnly: true,
								    id: 'rdo4',
								    fieldLabel: '특정',	
								    items : [{
								    	boxLabel: '예',
								    	name: 'SPEC_CONTROL' ,
								    	inputValue: 'Y',
								    	width:70
								    }, {boxLabel: '아니오',
								    	name: 'SPEC_CONTROL',
								    	inputValue: 'N',
								    	width:70
								    }]				
								}
							    ,{ name: 'SPEC_CONTROL_CODE',  		fieldLabel: '특정코드',	xtype:'uniCombobox',	comboType:'AU', comboCode:'YP05', readOnly: true}
							    ,{xtype: 'displayfield', name: ''}
								,{ name: 'SALE_UNIT',  				fieldLabel: '<t:message code="system.label.base.salesunit" default="판매단위"/>',	xtype:'uniCombobox',	comboType:'AU', comboCode:'B013' , displayField: 'value', allowBlank:false, fieldStyle: 'text-align: center;', readOnly: true}							    
							    ,{ name: 'TRNS_RATE',  				fieldLabel: '<t:message code="system.label.base.salespackednumber" default="판매입수"/>',	xtype:'uniNumberfield', maxLength :12, readOnly: true}
							    ,{ name: 'BIG_BOX_BARCODE', 		fieldLabel: '박스바코드',	xtype:'uniTextfield', maxLength :20, readOnly: true}
							    ,{ name: 'EXCESS_RATE',  			fieldLabel: '<t:message code="system.label.base.overissuerate" default="과출고허용율"/>',	xtype : 'uniNumberfield',  decimalPrecision:'2', maxLength :3, readOnly: true}
							]
	    		}
	    		,{  title: '조달정보'
	    			, layout: {
					            type: 'uniTable',
					            columns: 1
					        }
        			, defaults: {type: 'uniTextfield', enforceMaxLength: true}
        			, height: 435
        			,items :[ { name: 'DIV_CODE',  					fieldLabel: '적용사업장', 		 xtype:'uniCombobox', comboType:'BOR120', value:UserInfo.divCode, readOnly: true,allowBlank:false/*, multiSelect: true, typeAhead: false*/}//bpr200t	 
        					 ,{ name: 'ITEM_ACCOUNT',  				fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>', 		 xtype:'uniCombobox', comboType:'AU', comboCode:'B020', allowBlank:false}//bpr200t
        					 ,{ name: 'SUPPLY_TYPE',  				fieldLabel: '<t:message code="system.label.base.procurementclassification" default="조달구분"/>', 		 xtype:'uniCombobox', comboType:'AU', comboCode:'B014', allowBlank:false}//bpr200t
        					 ,{ name: 'ORDER_UNIT',  				fieldLabel: '<t:message code="system.label.base.purchaseunit" default="구매단위"/>',		 xtype:'uniCombobox', comboType:'AU', comboCode:'B013', displayField: 'value', fieldStyle: 'text-align: center;', allowBlank:false}//bpr200t        					 
        					 ,{				            	
			    				xtype: 'uniNumberfield',
			    				fieldLabel: '<t:message code="system.label.base.purchasereceiptcount" default="구매입수"/>',
			    				name: 'BUY_RATE',
			    				maxLength :12 				    			
					          }
					         ,{ name: 'BUY_BIG_BOX_BARCODE', 		fieldLabel: '물류스바코드',		 xtype:'uniTextfield', maxLength :20}
//        					 ,{ name: 'SMALL_BOX_BARCODE', 		 	fieldLabel: '소박스바코드',		 xtype:'uniTextfield', maxLength :20, readOnly: true}
        					 ,{ name: 'BARCODE',  					fieldLabel: '상품바코드', 		 xtype:'uniTextfield', maxLength :15, readOnly: true}
        					 ,{xtype: 'displayfield', name: ''} 
        					 ,{xtype: 'uniCombobox', fieldLabel: '주방프린터', name: 'K_PRINTER', comboType:'AU', comboCode:'YP19', maxLength :10 }
//        					 ,{xtype: 'uniCombobox', fieldLabel: '진열대번호', name: 'BIN_NUM', comboType:'AU', comboCode:'YP02', maxLength :10 }
        					  ,
							Unilite.popup('BIN', { 
								fieldLabel: '진열대번호',
								valueFieldWidth:120, 
								textFieldWidth:150,
								verticalMode:true,
								listeners: {
									onSelected: {
										fn: function(records, type) {
											var grdRecord = masterGrid.getSelectedRecord();
											grdRecord.set('BIN_NUM', records[0]['BIN_NUM']);
											grdRecord.set('BIN_NAME', records[0]['DOC_NAME']);
				                    	},
										scope: this
									},
									onClear: function(type)	{
										var grdRecord = masterGrid.getSelectedRecord();
										grdRecord.set('BIN_NUM', '');
										grdRecord.set('BIN_NAME', '');
									},
									applyextparam: function(popup){	
										popup.setExtParam({'DIV_CODE': panelSearch.getValue('FR_DIV_CODE')});
										popup.setExtParam({'BINTYPE': 'FAN'});	//상품
									}
								}
							})
        					 ,{fieldLabel: '선반번호', name: 'BIN_FLOOR', xtype:'uniCombobox', maxLength :4, comboType:'AU', comboCode:'YP16'}        					 
        					 ,{ name: 'WH_CODE',	  				fieldLabel: '<t:message code="system.label.base.mainwarehouse" default="주창고"/>', 		 xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('whList')}//bpr200t
        					 ,{ name: 'LOCATION',  					fieldLabel: 'Location', 	 xtype:'uniTextfield', maxLength :20}//bpr200t
        					 
        			]
	    		},{  title: '재고정보'
	    			, layout: {
					            type: 'uniTable',
					            columns: 1
					        }
        			, defaults: {type: 'uniTextfield', enforceMaxLength: true}
        			, height: 435
        			,items :[ { name: 'PROPER_STOCK_Q',  			fieldLabel: '적정재고',		 xtype:'uniNumberfield', readOnly: true}
        					 ,{ name: 'STOCK_Q',  					fieldLabel: '현재고', 		 xtype:'uniNumberfield', readOnly: true}
//        					 ,{ name: '',  							fieldLabel: '반품예정',		 xtype:'uniTextfield', readOnly: true}
        					 ,{ name: 'ISSUE_PLAN_Q',  				fieldLabel: '납품예정',		 xtype:'uniNumberfield', readOnly: true}
        					 ,{xtype: 'displayfield', name: ''}
        					 ,{ name: 'FIRST_PURCHASE_DATE',  		fieldLabel: '최초매입일 ',		 xtype:'uniDatefield', readOnly: true}
        					 ,{ name: 'LAST_PURCHASE_DATE',   		fieldLabel: '최종매입일 ',		 xtype:'uniDatefield', readOnly: true}
        					 ,{ name: 'FIRST_SALES_DATE',     		fieldLabel: '최초판매일 ',		 xtype:'uniDatefield', readOnly: true}
        					 ,{ name: 'LAST_SALES_DATE',      		fieldLabel: '최종판매일 ',		 xtype:'uniDatefield', readOnly: true}
        					 ,{ name: 'LAST_RETURN_DATE',     		fieldLabel: '최종반품일 ',		 xtype:'uniDatefield', readOnly: true}
        					 ,{ name: 'LAST_DELIVERY_DATE',   		fieldLabel: '최종납품일 ',		 xtype:'uniDatefield', readOnly: true}
        					 ,{ name: 'LAST_DELIVERY_CUSTOM',  		fieldLabel: '최종납품처',		 xtype:'uniTextfield', readOnly: true}
        			]
	    		},{ 
	    			height: 264,
	    			colspan: 4,
	    			layout: {type: 'uniTable', columns: 2},
	    			items :[{
        				xtype: 'container',
        				layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
        				defaults: {type: 'uniTextfield', enforceMaxLength: true},
        				items: [
//        					{ name: 'CIR_PERIOD_YN',  			fieldLabel: '유효기한관리', 	 xtype : 'uniRadiogroup', comboType:'AU', comboCode:'B010', width:260, allowBlank:false, padding: '8 0 0 0', readOnly: true}
        						{	
        							padding: '8 0 0 0',
								    xtype: 'radiogroup',
								    readOnly: true,
								    hidden: true,
								    id: 'rdo5',
								    fieldLabel: '유효기한관리',	
								    items : [{
								    	boxLabel: '예',
								    	name: 'CIR_PERIOD_YN' ,
								    	inputValue: 'Y',
								    	width:70
								    }, {boxLabel: '아니오',
								    	name: 'CIR_PERIOD_YN',
								    	inputValue: 'N',
								    	width:70
								    }]				
								}
        					   ,{ name: 'USE_BY_DATE',  			fieldLabel: '<t:message code="system.label.base.availabledate" default="유효일"/>',		 xtype:'uniNumberfield',value:'${UseByDate}', hidden: true, maxLength: 10, readOnly: true}
//        					   ,{xtype: 'displayfield', name: ''}
        					   ,{ name: 'ORDER_PLAN',  				fieldLabel: '<t:message code="system.label.base.popolicy" default="발주방침"/>',		 xtype:'uniCombobox', comboType:'AU', comboCode:'B061', hidden: true, allowBlank:false}//bpr200t
        					   ,{ name: 'MATRL_PRESENT_DAY',  		fieldLabel: '올림기간', 		 xtype:'uniNumberfield', suffixTpl: '일', hidden: true, maxLength: 5}//bpr200t
//        					   ,{xtype: 'displayfield', name: ''}
        					   , Unilite.popup('CUST',  	   {fieldLabel: '주거래처', valueFieldWidth:120, textFieldWidth:150, verticalMode:true,//bpr200t
	        					   	listeners: {
										onSelected: {
											fn: function(records, type) {
												var grdRecord = masterGrid.getSelectedRecord();
												grdRecord.set('CUSTOM_CODE', records[0]['CUSTOM_CODE']);
												grdRecord.set('CUSTOM_NAME', records[0]['CUSTOM_NAME']);
					                    	},
											scope: this
										},
										onClear: function(type)	{
											var grdRecord = masterGrid.getSelectedRecord();	                  
											grdRecord.set('CUSTOM_CODE', '');                                 
											grdRecord.set('CUSTOM_NAME', '');                                 
										}
									}	        					   
	        					   })
	        				   ,{ name: 'PURCHASE_BASE_P', 			fieldLabel: '<t:message code="system.label.base.purchaseprice" default="구매단가"/>',		 xtype:'uniNumberfield', maxLength: 18}//bpr200t
	        				   ,{xtype: 'displayfield', name: '', height: 160}
//	        				   ,{xtype: 'displayfield', name: ''}
//	        				   ,{xtype: 'displayfield', name: ''}
        					   ]
        				
        			}, {
        				xtype: 'container',
        				layout: {type: 'uniTable', columns: 1},
        				padding: '0 0 0 26',
        				items: [ {
	        				xtype: 'container',
	        				layout: {type: 'uniTable', columns: 1},
	        				defaults: {type: 'uniTextfield', enforceMaxLength: true},
	        				items: [ { name: 'REMARK1',  			fieldLabel: '비고사항1'  ,width:820, labelWidth: 87, xtype:'uniTextfield'	, maxLength: 300, readOnly: true}       
							  		,{ name: 'REMARK2',  			fieldLabel: '비고사항2'  ,width:820, labelWidth: 87, xtype:'uniTextfield', maxLength: 300, readOnly: true} 
							  		,{ name: 'REMARK3',  			fieldLabel: '비고사항3'  ,width:820, labelWidth: 87, xtype:'uniTextfield', maxLength: 300, readOnly: true}
							]
        				}, 
        				goodDetailFormSubGrid
//        				,{xtype: 'displayfield', name: ''}
        				/*,
        				{	
        					margin: '0 0 0 400',
	        				xtype: 'container',
	        				layout: {type: 'uniTable', columns: 3},
	        				items: [{
	        					text: '단가등록',
	        					xtype: 'button',
	        					handller: function(){
	        					
	        					}
	        				}, {
	        					xtype: 'container',
	        					html:'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
	        				}, {
	        					text: '재고조회',
	        					xtype: 'button',
	        					handller: function(){
	        					
	        					}
	        				}] 
        				}*/]
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
//				hide:function()	{
//					bookDetailForm.show();
//					detailFormSubGrid.reset();					
//				},
				show: function ( me, eOpts )	{					
					directSubStore.loadStoreRecords();						   			 	
    			}
   			}
	});
    
    //도서정보등록 상세
    var bookDetailForm = Unilite.createForm('bookDetailForm', {
    	//region:'south',
    	//weight:-100,
    	//height:400,
    	//split:true,
//		title: '도서정보',
    	hidden: true,
    	autoScroll: true,
    	flex:1,
    	masterGrid: masterGrid,
        padding: '0 0 0 1',
	    layout: {type: 'uniTable', columns: 4, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
	    defaultType: 'uniFieldset',
	    defaults : { margin: '0 0 0 0'},
	    items : [{
	    		xtype: 'container',
	    		colspan: 4,
	    		layout: {type: 'vbox', align: 'stretch'},
	    		items: [{
	    			xtype: 'container',
	    			layout: { type: 'uniTable', columns: 3},
	    			defaultType: 'uniTextfield',
	    			items:[{
		    			fieldLabel: '도서코드',
		    			name: 'ITEM_CODE',
		    			allowBlank: true,
		    			listeners:{ 
		    				blur : function( field, event, eOpts ){
		    				UniAppManager.app.fnSearchBookInfo(field.getValue());		//여기에파람 담아서 전송 해주는거 부터할차례
		    				}
		    			}
		    		}, {
		    			fieldLabel: '도서명',
		    			labelWidth: 114,
		    			name: 'ITEM_NAME',		    			
		    			width: 582,
		    			allowBlank: false,
		    			readOnly: true
		    		}/*, {
    					text: '재고조회',
    					xtype: 'button',
    					margin: '0 0 0 207',
    					handller: function(){
    					
    					}
    				}*/]
	    		}, {
	    			xtype: 'container',
	    			layout: { type: 'uniTable', columns: 3},
	    			defaultType: 'uniTextfield',
	    			items:[{
					    xtype: 'radiogroup',
					    id: 'rdo11',
					    fieldLabel: '국내외구분',	
					    items : [{
					    	boxLabel: '국내',
					    	name: 'DOM_FORIGN' ,
					    	inputValue: '1',
					    	width:85
					    }, {boxLabel: '해외',
					    	name: 'DOM_FORIGN',
					    	inputValue: '2',
					    	width:85
					    }]				
					}, {
		    			fieldLabel: '약명1',
		    			name: 'ITEM_NAME1',
		    			labelWidth: 399,
		    			readOnly: true
		    		}, {
		    			fieldLabel: '약명2',
		    			name: 'ITEM_NAME2',
		    			labelWidth: 114,
		    			readOnly: true
		    		}]
	    		}]
	    },
	    	
	    		{ 
        			  title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>' 
        			, defaults: {type: 'uniTextfield'}
        			, layout: { type: 'uniTable', columns: 1}
        			, height: 340
        			, items :[	 { name: 'ITEM_LEVEL1',  			fieldLabel: '<t:message code="system.label.base.majorgroup" default="대분류"/>' 		,xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('bpr103ukrvLevel1Store'), child: 'ITEM_LEVEL2', readOnly: true}   
						  		,{ name: 'ITEM_LEVEL2',  			fieldLabel: '<t:message code="system.label.base.middlegroup" default="중분류"/>' 		,xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('bpr103ukrvLevel2Store'), child: 'ITEM_LEVEL3', readOnly: true}    
						  		,{ name: 'ITEM_LEVEL3',  			fieldLabel: '<t:message code="system.label.base.minorgroup" default="소분류"/>' 		,xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('bpr103ukrvLevel3Store'), readOnly: true}
						  		,{ name: 'SPEC',  					fieldLabel: '<t:message code="system.label.base.spec" default="규격"/>' 		,maxLength: 160, readOnly: true} 
						  		,{ name: 'STOCK_UNIT',  			fieldLabel: '<t:message code="system.label.base.inventoryunit" default="재고단위"/>',	 xtype:'uniCombobox',	comboType:'AU', comboCode:'B013' , allowBlank:false, displayField: 'value', fieldStyle: 'text-align: center;', readOnly: true}     
						  		, Unilite.popup('ITEM_GROUP',  	   {fieldLabel: '<t:message code="system.label.base.repmodel" default="대표모델"/>', textFieldName:'ITEM_GROUP_NAME', valueFieldName:'ITEM_GROUP', valueFieldWidth:120, textFieldWidth:150, verticalMode:true, readOnly: true,
						  			listeners: {
										onClear: function(type)	{
											var grdRecord = masterGrid.uniOpt.currentRecord;
											grdRecord.set('ITEM_GROUP', '');
											grdRecord.set('ITEM_GROUP_NAME', '');
										}
									}
						  		})
//						  		,{ name: 'STOCK_CARE_YN',  			fieldLabel: '<t:message code="system.label.base.inventorymanageobject" default="재고관리대상"/>', xtype:'uniRadiogroup', comboType:'AU', comboCode:'B010', width:235, allowBlank:false, readOnly: true}
						  		,{
								    xtype: 'radiogroup',
								    readOnly: true,
								    id: 'rdo6',
								    fieldLabel: '<t:message code="system.label.base.inventorymanageobject" default="재고관리대상"/>',	
								    items : [{
								    	boxLabel: '예',
								    	name: 'STOCK_CARE_YN' ,
								    	inputValue: 'Y',
								    	width:70
								    }, {boxLabel: '아니오',
								    	name: 'STOCK_CARE_YN',
								    	inputValue: 'N',
								    	width:70
								    }]				
								}
						  		,{ name: 'START_DATE',  			fieldLabel: '<t:message code="system.label.base.usestartdate" default="사용시작일"/>', 	xtype : 'uniDatefield', maxLength: 10, readOnly: true}    
						  		,{ name: 'STOP_DATE',  				fieldLabel: '<t:message code="system.label.base.usestopdate" default="사용중단일"/>', 	xtype : 'uniDatefield', maxLength: 10, readOnly: true}    
//						  		,{ name: 'USE_YN',  				fieldLabel: '<t:message code="system.label.base.useyn" default="사용여부"/>', 	xtype:'uniRadiogroup', comboType:'AU', comboCode:'B010', width:235, allowBlank:false, readOnly: true}
						  		,{
								    xtype: 'radiogroup',
								    readOnly: true,
								    id: 'rdo7',
								    fieldLabel: '<t:message code="system.label.base.useyn" default="사용여부"/>',	
								    items : [{
								    	boxLabel: '예',
								    	name: 'USE_YN' ,
								    	inputValue: 'Y',
								    	width:70
								    }, {boxLabel: '아니오',
								    	name: 'USE_YN',
								    	inputValue: 'N',
								    	width:70
								    }]				
								}
						  								  		
					         ]
	    		}
	    	   ,{   title: '제원정보'
        			, layout: {
					            type: 'uniTable',
					            columns: 2
					        }
        			, defaults: {type: 'uniTextfield', colspan: 2}
        			, height: 340
        			, width: 300
        			, items :[	 { name: 'TAX_TYPE',  				fieldLabel: '<t:message code="system.label.base.taxtype" default="세구분"/>', 	xtype:'uniCombobox', comboType:'AU', comboCode:'B059' , allowBlank:false, readOnly: true, fieldStyle: 'text-align: center;'}         
						  		,{ name: 'SALE_BASIS_P',  	 		fieldLabel: '<t:message code="system.label.base.sellingprice" default="판매단가"/>', 	xtype : 'uniNumberfield', allowBlank: false, maxLength: 18, colspan: 1, readOnly: true}
						  		,{xtype: 'component'}
						  	   , {
						           fieldLabel: '이전단가',//DB용
						           name: 'BF_SALE_BASIS_P',
						           xtype:'uniNumberfield',
						           readOnly: true
						        }, {
						           fieldLabel: '적용일자',
						           name: 'SALE_DATE',//단가검색 팝업 날짜 hidden
						           xtype:'uniDatefield',
						           allowBlank: false,
						           vlaue: UniDate.get('today'),
						           hidden: true
						        }
							    ,{ name: 'SALE_COMMON_P',  	 		fieldLabel: '시중가', allowBlank: true,	xtype : 'uniNumberfield', maxLength: 18, readOnly: true}
//							    ,{ name: 'AUTO_DISCOUNT',  	 		fieldLabel: '자동할인', 	xtype : 'uniRadiogroup', comboType:'AU', comboCode:'B010', width:235, allowBlank:false, readOnly: true}
							    ,{
								    xtype: 'radiogroup',
								    readOnly: true,
								    id: 'rdo8',
								    fieldLabel: '자동할인',	
								    items : [{
								    	boxLabel: '예',
								    	name: 'AUTO_DISCOUNT' ,
								    	inputValue: 'Y',
								    	width:70
								    }, {boxLabel: '아니오',
								    	name: 'AUTO_DISCOUNT',
								    	inputValue: 'N',
								    	width:70
								    }]				
								} ,{
								    xtype: 'radiogroup',
								    fieldLabel: '회원할인대상',			    
//								    colspan: 2,
								    items : [{
								    	boxLabel: '예',
								    	name: 'MEMBER_DISCOUNT_YN' ,
								    	inputValue: 'Y',
								    	width:70
								    }, {boxLabel: '아니오',
								    	name: 'MEMBER_DISCOUNT_YN',
								    	inputValue: 'N',
								    	width:70,
								    	checked: true
								    }]				
								}
//							    ,{ name: 'SPEC_CONTROL',  	 		fieldLabel: '특정', 		xtype : 'uniRadiogroup', comboType:'AU', comboCode:'B010', width:235, allowBlank:false, readOnly: true}
							    ,{
								    xtype: 'radiogroup',
								    readOnly: true,
								    id: 'rdo9',
								    fieldLabel: '특정',	
								    items : [{
								    	boxLabel: '예',
								    	name: 'SPEC_CONTROL' ,
								    	inputValue: 'Y',
								    	width:70
								    }, {boxLabel: '아니오',
								    	name: 'SPEC_CONTROL',
								    	inputValue: 'N',
								    	width:70
								    }]				
								}
							    ,{ name: 'SPEC_CONTROL_CODE',  		fieldLabel: '특정코드',	xtype:'uniCombobox',	comboType:'AU', comboCode:'YP05', readOnly: true}
								,{ name: 'SALE_UNIT',  				fieldLabel: '<t:message code="system.label.base.salesunit" default="판매단위"/>',	xtype:'uniCombobox',	comboType:'AU', comboCode:'B013' , displayField: 'value', allowBlank:false, fieldStyle: 'text-align: center;', readOnly: true}							    
							    ,{ name: 'TRNS_RATE',  				fieldLabel: '<t:message code="system.label.base.salespackednumber" default="판매입수"/>',	xtype:'uniNumberfield', readOnly: true}
							    ,{ name: 'EXCESS_RATE',  			fieldLabel: '<t:message code="system.label.base.overissuerate" default="과출고허용율"/>',	xtype : 'uniNumberfield',  decimalPrecision:'2', readOnly: true}
							]
	    		}
	    		,{  title: '도서정보'
	    			, layout: {
					            type: 'uniTable',
					            columns: 2
					        }
        			, defaults: {type: 'uniTextfield', colspan: 2, labelWidth: 85}
        			, height: 340
        			,items :[ { name: 'ISBN_CODE',  				fieldLabel: 'ISBN', 		 xtype:'uniTextfield', comboType:'AU', comboCode:'', colspan: 2, width: 160, readOnly: true}
//        					 ,{xtype: 'displayfield', itemId: 'bookLink', fieldLabel: '', value: '<a href="javascript:void(0);"><u>책소개</u></a>', padding: '0 0 0 -10', readOnly: true}        				
        					 ,Unilite.popup('CUST',  	   {fieldLabel: '출판사', valueFieldWidth:120, textFieldWidth:150, verticalMode:true, valueFieldName:'PUBLISHER_CODE', textFieldName:'PUBLISHER', readOnly: true,			    
	        					   	listeners: {
										onSelected: {
											fn: function(records, type) {
												var grdRecord = masterGrid.getSelectedRecord();
												grdRecord.set('PUBLISHER_CODE', records[0]['CUSTOM_CODE']);
												grdRecord.set('PUBLISHER', records[0]['CUSTOM_NAME']);
					                    	},
											scope: this
										},
										onClear: function(type)	{
											var grdRecord = masterGrid.getSelectedRecord();
											grdRecord.set('PUBLISHER_CODE', '');
											grdRecord.set('PUBLISHER', '');
										}
									}	        					   
        					   })
        					 ,{ name: 'AUTHOR1',  					fieldLabel: '저자1', 			 xtype:'uniTextfield', readOnly: true}
        					 ,{ name: 'AUTHOR2',  					fieldLabel: '저자2',			 xtype:'uniTextfield', readOnly: true}
        					 ,{ name: 'TRANSRATOR',  	 			fieldLabel: '역자',		 	 xtype:'uniTextfield', readOnly: true}
        					 ,{ name: 'PUB_DATE',  					fieldLabel: '초판발행일', 		 xtype:'uniDatefield', readOnly: true}
//        					 ,{ name: 'BIN_NUM',  					fieldLabel: '서가진열대번호', 		 	 xtype:'uniCombobox',	comboType:'AU', comboCode:'YP02'}
        					 ,
							Unilite.popup('BIN', { 
								fieldLabel: '서가진열대번호',
								valueFieldWidth:120, 
								textFieldWidth:150,
								verticalMode:true,
								listeners: {
									onSelected: {
										fn: function(records, type) {
											var grdRecord = masterGrid.getSelectedRecord();
											grdRecord.set('BIN_NUM', records[0]['BIN_NUM']);
											grdRecord.set('BIN_NAME', records[0]['DOC_NAME']);
				                    	},
										scope: this
									},
									onClear: function(type)	{
										var grdRecord = masterGrid.getSelectedRecord();
										grdRecord.set('BIN_NUM', '');
										grdRecord.set('BIN_NAME', '');
									},
									applyextparam: function(popup){	
										popup.setExtParam({'DIV_CODE': panelSearch.getValue('FR_DIV_CODE')});
										popup.setExtParam({'BINTYPE': 'DOC'});	//도서
									}
								}
							})
        					 ,{fieldLabel: '선반번호', name: 'BIN_FLOOR', xtype:'uniCombobox', maxLength :4, comboType:'AU', comboCode:'YP16'}        					  
//        					 ,{ name: 'PROD_TYPE',  	 			fieldLabel: '교재구분', 		xtype : 'uniRadiogroup', comboType:'AU', comboCode:'B010', width:235, allowBlank:false, readOnly: true}
        					 ,{
							    xtype: 'radiogroup',
							    readOnly: true,
							    id: 'rdo10',
							    fieldLabel: '교재구분',	
							    items : [{
							    	boxLabel: '예',
							    	name: 'PROD_TYPE' ,
							    	inputValue: 'Y',
							    	width:70
							    }, {boxLabel: '아니오',
							    	name: 'PROD_TYPE',
							    	inputValue: 'N',
							    	width:70
							    }]				
							}
        					 ,{						           
					           margin: '0 0 0 158',
					           width: 75,
					           xtype: 'button',
							   text: '+상세보기',								   	
							   handler : function() {							   	   
							   	   getWindowX = this.getX();
							   	   getWindowY = this.getY()+22;
								   openGetBookInfoWindow();
							   }
					        }
        			]
	    		},{  title: '재고정보'
	    			, layout: {
					            type: 'uniTable',
					            columns: 1
					        }
        			, defaults: {type: 'uniTextfield'}
        			, height: 340
        			,items :[ { name: '',  							fieldLabel: '적정재고',		 xtype:'uniTextfield', readOnly: true}
        					 ,{ name: '',  							fieldLabel: '현재고', 		 xtype:'uniTextfield', readOnly: true}
//        					 ,{ name: '',  							fieldLabel: '반품예정',		 xtype:'uniTextfield', readOnly: true}
        					 ,{ name: '',  							fieldLabel: '납품예정',		 xtype:'uniTextfield', readOnly: true}
        					 ,{xtype: 'displayfield', name: ''}
        					 ,{ name: 'FIRST_PURCHASE_DATE',  		fieldLabel: '최초매입일 ',		 xtype:'uniDatefield', readOnly: true}
        					 ,{ name: 'LAST_PURCHASE_DATE',   		fieldLabel: '최종매입일 ',		 xtype:'uniDatefield', readOnly: true}
        					 ,{ name: 'FIRST_SALES_DATE',     		fieldLabel: '최초판매일 ',		 xtype:'uniDatefield', readOnly: true}
        					 ,{ name: 'LAST_SALES_DATE',      		fieldLabel: '최종판매일 ',		 xtype:'uniDatefield', readOnly: true}
        					 ,{ name: 'LAST_RETURN_DATE',     		fieldLabel: '최종반품일 ',		 xtype:'uniDatefield', readOnly: true}
        					 ,{ name: 'LAST_DELIVERY_DATE',   		fieldLabel: '최종납품일 ',		 xtype:'uniDatefield', readOnly: true}
        					 ,{ name: 'LAST_DELIVERY_CUSTOM',  		fieldLabel: '최종납품처',		 xtype:'uniTextfield', readOnly: true}
        			]
	    		},{ 
	    			height: 335,
	    			colspan: 4,
	    			layout: {type: 'uniTable', columns: 2},
	    			items :[{
        				xtype: 'container',
        				layout: {type: 'uniTable', columns: 1},
        				items: [{ name: 'DIV_CODE',  				fieldLabel: '적용사업장', 		 xtype:'uniCombobox', comboType:'BOR120', value:UserInfo.divCode, readOnly: true,allowBlank:false, margin: '8 0 0 0'/*, multiSelect: true, typeAhead: false*/}	 
        					   ,{ name: 'ITEM_ACCOUNT',  			fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>', 		 xtype:'uniCombobox', comboType:'AU', comboCode:'B020', allowBlank:false}
        					   ,{ name: 'SUPPLY_TYPE',  			fieldLabel: '<t:message code="system.label.base.procurementclassification" default="조달구분"/>', 		 xtype:'uniCombobox', comboType:'AU', comboCode:'B014', allowBlank:false}
        					   ,{ name: 'ORDER_UNIT',  				fieldLabel: '<t:message code="system.label.base.purchaseunit" default="구매단위"/>',		 xtype:'uniCombobox', comboType:'AU', comboCode:'B013', displayField: 'value', fieldStyle: 'text-align: center;', allowBlank:false}
        					   ,{ name: 'BUY_RATE',  		    	fieldLabel: '<t:message code="system.label.base.purchasereceiptcount" default="구매입수"/>',		 xtype:'uniNumberfield'}
        					   ,{ name: 'WH_CODE',  				fieldLabel: '<t:message code="system.label.base.mainwarehouse" default="주창고"/>', 		 xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('whList')}
        					   ,{ name: 'LOCATION',  				fieldLabel: 'Location', 	 xtype:'uniTextfield'}
        					   ,{ name: 'ORDER_PLAN',  				fieldLabel: '<t:message code="system.label.base.popolicy" default="발주방침"/>',		 xtype:'uniCombobox', comboType:'AU', comboCode:'B061', allowBlank:false}
        					   ,{ name: 'MATRL_PRESENT_DAY',  		fieldLabel: '올림기간', 		 xtype:'uniNumberfield', suffixTpl: '일'}
        					   ,{ name: 'PURCHASE_BASE_P', 			fieldLabel: '<t:message code="system.label.base.purchaseprice" default="구매단가"/>',		 xtype:'uniNumberfield'}        					   
        					   , Unilite.popup('CUST',  	   {fieldLabel: '주거래처', valueFieldWidth:120, textFieldWidth:150, verticalMode:true,
	        					   	listeners: {
										onSelected: {
											fn: function(records, type) {
												var grdRecord = masterGrid.getSelectedRecord();
												grdRecord.set('CUSTOM_CODE', records[0]['CUSTOM_CODE']);
												grdRecord.set('CUSTOM_NAME', records[0]['CUSTOM_NAME']);
					                    	},
											scope: this
										},
										onClear: function(type)	{
											var grdRecord = masterGrid.getSelectedRecord();	                  
											grdRecord.set('CUSTOM_CODE', '');                                 
											grdRecord.set('CUSTOM_NAME', '');                                 
										}
									}	        					   
	        					   })
        					   ]
        				
        			}, {
        				xtype: 'container',
        				layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
        				items: [ {
	        				xtype: 'container',
	        				layout: {type: 'uniTable', columns: 1},
	        				items: [ { name: 'REMARK1',  			fieldLabel: '비고사항1'  ,width:844, labelWidth: 112, xtype:'uniTextfield'	, maxLength: 300, readOnly: true}       
							  		,{ name: 'REMARK2',  			fieldLabel: '비고사항2'  ,width:844, labelWidth: 112, xtype:'uniTextfield', maxLength: 300, readOnly: true} 
							  		,{ name: 'REMARK3',  			fieldLabel: '비고사항3'  ,width:844, labelWidth: 112, xtype:'uniTextfield', maxLength: 300, readOnly: true}
							]
        				}, 
        				bookDetailFormSubGrid
//        				,{xtype: 'displayfield', name: ''}
/*,
        				{	
        					margin: '0 0 0 400',
	        				xtype: 'container',
	        				layout: {type: 'uniTable', columns: 3},
	        				items: [{
	        					text: '단가등록',
	        					xtype: 'button',
	        					handller: function(){
	        					
	        					}
	        				}, {
	        					xtype: 'container',
	        					html:'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
	        				}, {
	        					text: '재고조회',
	        					xtype: 'button',
	        					handller: function(){
	        					
	        					}
	        				}] 
        				}*/]
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
//								goodDetailForm.hide();
//							}
//						};
//						UniAppManager.app.confirmSaveData(config);
//						return false;
//					}
//				},
//				hide:function()	{
//					goodDetailForm.show();
//					detailFormSubGrid.reset();
//				},
   				show: function ( me, eOpts )	{					
					directSubStore.loadStoreRecords();						   			 	
    			}
   			}
	});
	
	var detailForm = Unilite.createForm('detailForm', {
    	//region:'south',
    	//weight:-100,
    	//height:400,
    	//split:true,
//    	title: '상세정보',
		disabled: true,
//    	hidden: true,
    	autoScroll: true,
    	flex:1,
    	masterGrid: masterGrid,
        padding: '0 0 0 1',
	    layout: {type: 'uniTable', columns: 4, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
	    defaultType: 'uniFieldset',
	    defaults : { margin: '0 0 0 0'},
	    items : [{
	    		xtype: 'container',
	    		colspan: 4,
	    		layout: {type: 'vbox', align: 'stretch'},
	    		items: [{
	    			xtype: 'container',
	    			layout: { type: 'uniTable', columns: 3},
	    			defaultType: 'uniTextfield',
	    			defaults : {enforceMaxLength: true},
	    			items:[{
		    			fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>',
		    			name: 'ITEM_CODE',
		    			allowBlank: true,
		    			maxLength :20
		    		}, {
		    			fieldLabel: '<t:message code="system.label.base.itemname2" default="품명"/>',
		    			labelWidth: 114,
		    			name: 'ITEM_NAME',		    			
		    			width: 578,
		    			allowBlank: false,
		    			maxLength :40,
		    			readOnly: true
		    		}/*, {
    					text: '재고조회',
    					xtype: 'button',
    					margin: '0 0 0 207',
    					handller: function(){
    					
    					}
    				}*/]
	    		}, {
	    			xtype: 'container',
	    			layout: { type: 'uniTable', columns: 3},
	    			defaultType: 'uniTextfield',
	    			defaults : {enforceMaxLength: true},
	    			items:[{ 
		    			xtype: 'displayfield',
		    			name: ''
		    		}, {
		    			fieldLabel: '품명1',
		    			name: 'ITEM_NAME1',
		    			labelWidth: 358,
		    			maxLength :40,
		    			readOnly: true
		    		}, {
		    			fieldLabel: '품명2',
		    			name: 'ITEM_NAME2',
		    			labelWidth: 154,
		    			maxLength :40,
		    			readOnly: true
		    		}]
	    		}]
	    },
	    	
	    		{ 
        			  title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>'
        			, defaults: {type: 'uniTextfield', enforceMaxLength: true}
        			, layout: { type: 'uniTable', columns: 1}
        			, height: 435
        			, items :[	 { name: 'ITEM_LEVEL1',  			fieldLabel: '<t:message code="system.label.base.majorgroup" default="대분류"/>' 		,xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('bpr103ukrvLevel1Store'), child: 'ITEM_LEVEL2', readOnly: true}   
						  		,{ name: 'ITEM_LEVEL2',  			fieldLabel: '<t:message code="system.label.base.middlegroup" default="중분류"/>' 		,xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('bpr103ukrvLevel2Store'), child: 'ITEM_LEVEL3', readOnly: true}    
						  		,{ name: 'ITEM_LEVEL3',  			fieldLabel: '<t:message code="system.label.base.minorgroup" default="소분류"/>' 		,xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('bpr103ukrvLevel3Store'), readOnly: true}
						  		,{xtype: 'displayfield', name: ''}
						  		,{ name: 'SPEC',  					fieldLabel: '<t:message code="system.label.base.spec" default="규격"/>' 		,maxLength: 160, readOnly: true} 
						  		,{ name: 'STOCK_UNIT',  			fieldLabel: '<t:message code="system.label.base.inventoryunit" default="재고단위"/>',	 xtype:'uniCombobox',	comboType:'AU', comboCode:'B013' , allowBlank:false, displayField: 'value', fieldStyle: 'text-align: center;', readOnly: true}     
						  		, Unilite.popup('ITEM_GROUP',  	   {fieldLabel: '<t:message code="system.label.base.repmodel" default="대표모델"/>', textFieldName:'ITEM_GROUP_NAME', valueFieldName:'ITEM_GROUP', valueFieldWidth:120, textFieldWidth:150, verticalMode:true, readOnly: true,
						  			listeners: {
										onClear: function(type)	{
											var grdRecord = masterGrid.uniOpt.currentRecord;
											grdRecord.set('ITEM_GROUP', '');
											grdRecord.set('ITEM_GROUP_NAME', '');
										}
									}
						  		})
						  		,{ name: 'STOCK_CARE_YN',  			fieldLabel: '<t:message code="system.label.base.inventorymanageobject" default="재고관리대상"/>', xtype:'uniRadiogroup', comboType:'AU', comboCode:'B010', width:235, allowBlank:false, readOnly: true} 
						  		,{ name: 'START_DATE',  			fieldLabel: '<t:message code="system.label.base.usestartdate" default="사용시작일"/>', 	xtype : 'uniDatefield', maxLength: 10, readOnly: true}    
						  		,{ name: 'STOP_DATE',  				fieldLabel: '<t:message code="system.label.base.usestopdate" default="사용중단일"/>', 	xtype : 'uniDatefield', maxLength: 10, readOnly: true}    
						  		,{ name: 'USE_YN',  				fieldLabel: '<t:message code="system.label.base.useyn" default="사용여부"/>', 	xtype:'uniRadiogroup', comboType:'AU', comboCode:'B010', width:235, allowBlank:false, readOnly: true}  
						  								  		
					         ]
	    		}
	    	   ,{   title: '제원정보'
        			, layout: {
					            type: 'uniTable',
					            columns: 2
					        }
        			, defaults: {type: 'uniTextfield', colspan: 2, enforceMaxLength: true}
        			, height: 435
        			, width: 300
        			, items :[	 { name: 'TAX_TYPE',  				fieldLabel: '<t:message code="system.label.base.taxtype" default="세구분"/>', 	xtype:'uniCombobox', comboType:'AU', comboCode:'B059' , allowBlank:false, readOnly: true, fieldStyle: 'text-align: center;'}         
						  		,{ name: 'SALE_BASIS_P',  	 		fieldLabel: '<t:message code="system.label.base.sellingprice" default="판매단가"/>', 	xtype : 'uniNumberfield', allowBlank: false, maxLength: 18, colspan: 1, readOnly: true}
						  		,{xtype: 'component'}
						  	   , {
						           fieldLabel: '이전단가',//DB용
						           name: 'BF_SALE_BASIS_P',
						           xtype:'uniNumberfield',
						           readOnly: true
						        }, {
						           fieldLabel: '적용일자',
						           name: 'SALE_DATE',//단가검색 팝업 날짜 hidden
						           xtype:'uniDatefield',
						           allowBlank: false,
						           vlaue: UniDate.get('today'),
						           hidden: true
						        }
							    ,{ name: 'SALE_COMMON_P',  	 		fieldLabel: '시중가', allowBlank: true,	xtype : 'uniNumberfield', maxLength: 18, readOnly: true}
							    ,{ name: 'CONSIGNMENT_FEE',  	 	fieldLabel: '위탁수수료', 	xtype : 'uniNumberfield', maxLength: 18}
							    ,{xtype: 'displayfield', name: ''}
							    ,{ name: 'AUTO_DISCOUNT',  	 		fieldLabel: '자동할인', 	xtype : 'uniRadiogroup', comboType:'AU', comboCode:'B010', width:235, allowBlank:false, readOnly: true}
							     ,{
								    xtype: 'radiogroup',
								    fieldLabel: '회원할인대상',			    
//								    colspan: 2,
								    items : [{
								    	boxLabel: '예',
								    	name: 'MEMBER_DISCOUNT_YN' ,
								    	inputValue: 'Y',
								    	width:70
								    }, {boxLabel: '아니오',
								    	name: 'MEMBER_DISCOUNT_YN',
								    	inputValue: 'N',
								    	width:70,
								    	checked: true
								    }]				
								}
							    ,{ name: 'SPEC_CONTROL',  	 		fieldLabel: '특정', 		xtype : 'uniRadiogroup', comboType:'AU', comboCode:'B010', width:235, allowBlank:false, readOnly: true}
							    ,{ name: 'SPEC_CONTROL_CODE',  		fieldLabel: '특정코드',	xtype:'uniCombobox',	comboType:'AU', comboCode:'YP05', readOnly: true}
							    ,{xtype: 'displayfield', name: ''}
								,{ name: 'SALE_UNIT',  				fieldLabel: '<t:message code="system.label.base.salesunit" default="판매단위"/>',	xtype:'uniCombobox',	comboType:'AU', comboCode:'B013' , displayField: 'value', allowBlank:false, fieldStyle: 'text-align: center;', readOnly: true}							    
							    ,{ name: 'TRNS_RATE',  				fieldLabel: '<t:message code="system.label.base.salespackednumber" default="판매입수"/>',	xtype:'uniNumberfield', maxLength :12, readOnly: true}
							    ,{ name: 'BIG_BOX_BARCODE', 		fieldLabel: '박스바코드',	xtype:'uniTextfield', maxLength :20, readOnly: true}
							    ,{ name: 'EXCESS_RATE',  			fieldLabel: '<t:message code="system.label.base.overissuerate" default="과출고허용율"/>',	xtype : 'uniNumberfield',  decimalPrecision:'2', maxLength :3, readOnly: true}
							]
	    		}
	    		,{  title: '조달정보'
	    			, layout: {
					            type: 'uniTable',
					            columns: 1
					        }
        			, defaults: {type: 'uniTextfield', enforceMaxLength: true}
        			, height: 435
        			,items :[ { name: 'DIV_CODE',  					fieldLabel: '적용사업장', 		 xtype:'uniCombobox', comboType:'BOR120', value:UserInfo.divCode, readOnly: true,allowBlank:false/*, multiSelect: true, typeAhead: false*/}//bpr200t	 
        					 ,{ name: 'ITEM_ACCOUNT',  				fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>', 		 xtype:'uniCombobox', comboType:'AU', comboCode:'B020', allowBlank:false}//bpr200t
        					 ,{ name: 'SUPPLY_TYPE',  				fieldLabel: '<t:message code="system.label.base.procurementclassification" default="조달구분"/>', 		 xtype:'uniCombobox', comboType:'AU', comboCode:'B014', allowBlank:false}//bpr200t
        					 ,{ name: 'ORDER_UNIT',  				fieldLabel: '<t:message code="system.label.base.purchaseunit" default="구매단위"/>',		 xtype:'uniCombobox', comboType:'AU', comboCode:'B013', displayField: 'value', fieldStyle: 'text-align: center;', allowBlank:false}//bpr200t        					 
        					 ,{				            	
			    				xtype: 'uniNumberfield',
			    				fieldLabel: '<t:message code="system.label.base.purchasereceiptcount" default="구매입수"/>',
			    				name: 'BUY_RATE',
			    				maxLength :12 				    			
					          }
					         ,{ name: 'BUY_BIG_BOX_BARCODE', 		fieldLabel: '물류스바코드',		 xtype:'uniTextfield', maxLength :20}
//        					 ,{ name: 'SMALL_BOX_BARCODE', 		 	fieldLabel: '소박스바코드',		 xtype:'uniTextfield', maxLength :20, readOnly: true}
        					 ,{ name: 'BARCODE',  					fieldLabel: '상품바코드', 		 xtype:'uniTextfield', maxLength :15, readOnly: true}
        					 ,{xtype: 'displayfield', name: ''}        	
        					 ,{xtype: 'uniCombobox', fieldLabel: '주방프린터', name: 'K_PRINTER', comboType:'AU', comboCode:'YP19', maxLength :10 }
//        					 ,{xtype: 'uniCombobox', fieldLabel: '진열대번호', name: 'BIN_NUM', comboType:'AU', comboCode:'YP02', maxLength :10 }
        					 ,
							Unilite.popup('BIN', { 
								fieldLabel: '진열대번호',
								valueFieldWidth:120, 
								textFieldWidth:150,
								verticalMode:true
							})
        					 ,{fieldLabel: '선반번호', name: 'BIN_FLOOR', xtype:'uniCombobox', maxLength :4, comboType:'AU', comboCode:'YP16'}
        					 ,{ name: 'WH_CODE',	  				fieldLabel: '<t:message code="system.label.base.mainwarehouse" default="주창고"/>', 		 xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('whList')}//bpr200t
        					 ,{ name: 'LOCATION',  					fieldLabel: 'Location', 	 xtype:'uniTextfield', maxLength :20}//bpr200t
        					 
        			]
	    		},{  title: '재고정보'
	    			, layout: {
					            type: 'uniTable',
					            columns: 1
					        }
        			, defaults: {type: 'uniTextfield', enforceMaxLength: true}
        			, height: 435
        			,items :[ { name: '',  							fieldLabel: '적정재고',		 xtype:'uniTextfield', readOnly: true}
        					 ,{ name: '',  							fieldLabel: '현재고', 		 xtype:'uniTextfield', readOnly: true}
//        					 ,{ name: '',  							fieldLabel: '반품예정',		 xtype:'uniTextfield', readOnly: true}
        					 ,{ name: '',  							fieldLabel: '납품예정',		 xtype:'uniTextfield', readOnly: true}
        					 ,{xtype: 'displayfield', name: ''}
        					 ,{ name: 'FIRST_PURCHASE_DATE',  		fieldLabel: '최초매입일 ',		 xtype:'uniDatefield', readOnly: true}
        					 ,{ name: 'LAST_PURCHASE_DATE',   		fieldLabel: '최종매입일 ',		 xtype:'uniDatefield', readOnly: true}
        					 ,{ name: 'FIRST_SALES_DATE',     		fieldLabel: '최초판매일 ',		 xtype:'uniDatefield', readOnly: true}
        					 ,{ name: 'LAST_SALES_DATE',      		fieldLabel: '최종판매일 ',		 xtype:'uniDatefield', readOnly: true}
        					 ,{ name: 'LAST_RETURN_DATE',     		fieldLabel: '최종반품일 ',		 xtype:'uniDatefield', readOnly: true}
        					 ,{ name: 'LAST_DELIVERY_DATE',   		fieldLabel: '최종납품일 ',		 xtype:'uniDatefield', readOnly: true}
        					 ,{ name: 'LAST_DELIVERY_CUSTOM',  		fieldLabel: '최종납품처',		 xtype:'uniTextfield', readOnly: true}
        			]
	    		},{ 
	    			height: 264,
	    			colspan: 4,
	    			layout: {type: 'uniTable', columns: 2},
	    			items :[{
        				xtype: 'container',
        				layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
        				defaults: {type: 'uniTextfield', enforceMaxLength: true},
        				items: [{ name: 'CIR_PERIOD_YN',  			fieldLabel: '유효기한관리', 	 xtype : 'uniRadiogroup', comboType:'AU', comboCode:'B010', width:260, hidden: true, allowBlank:false, padding: '8 0 0 0', readOnly: true}
        					   ,{ name: 'USE_BY_DATE',  			fieldLabel: '<t:message code="system.label.base.availabledate" default="유효일"/>',		 xtype:'uniNumberfield',value:'${UseByDate}', maxLength: 10, hidden: true, readOnly: true}
//        					   ,{xtype: 'displayfield', name: ''}
        					   ,{ name: 'ORDER_PLAN',  				fieldLabel: '<t:message code="system.label.base.popolicy" default="발주방침"/>',		 xtype:'uniCombobox', comboType:'AU', comboCode:'B061', hidden: true, allowBlank:false}//bpr200t
        					   ,{ name: 'MATRL_PRESENT_DAY',  		fieldLabel: '올림기간', 		 xtype:'uniNumberfield', suffixTpl: '일', hidden: true, maxLength: 5}//bpr200t
//        					   ,{xtype: 'displayfield', name: ''}
        					   , Unilite.popup('CUST',  	   {fieldLabel: '주거래처', valueFieldWidth:120, textFieldWidth:150, verticalMode:true,//bpr200t
	        					   	listeners: {
										onClear: function(type)	{
											var grdRecord = masterGrid.uniOpt.currentRecord;	                  
											grdRecord.set('CUSTOM_CODE', '');                                 
											grdRecord.set('CUSTOM_NAME', '');                                 
										}
									}	        					   
	        					   })
	        				   ,{ name: 'PURCHASE_BASE_P', 			fieldLabel: '<t:message code="system.label.base.purchaseprice" default="구매단가"/>',		 xtype:'uniNumberfield', maxLength: 18}//bpr200t
	        				   ,{xtype: 'displayfield', name: '', height: 160}
//	        				   ,{xtype: 'displayfield', name: ''}
//	        				   ,{xtype: 'displayfield', name: ''}
        					   ]
        				
        			}, {
        				xtype: 'container',
        				layout: {type: 'uniTable', columns: 1},
        				items: [ {
	        				xtype: 'container',
	        				layout: {type: 'uniTable', columns: 1},
	        				defaults: {type: 'uniTextfield', enforceMaxLength: true},
	        				items: [ { name: 'REMARK1',  			fieldLabel: '비고사항1'  ,width:820, labelWidth: 87, xtype:'uniTextfield'	, maxLength: 300, readOnly: true}       
							  		,{ name: 'REMARK2',  			fieldLabel: '비고사항2'  ,width:820, labelWidth: 87, xtype:'uniTextfield', maxLength: 300, readOnly: true} 
							  		,{ name: 'REMARK3',  			fieldLabel: '비고사항3'  ,width:820, labelWidth: 87, xtype:'uniTextfield', maxLength: 300, readOnly: true}
							]
        				}, 
        				detailFormSubGrid
//        				,{xtype: 'displayfield', name: ''}
        				/*,
        				{	
        					margin: '0 0 0 400',
	        				xtype: 'container',
	        				layout: {type: 'uniTable', columns: 3},
	        				items: [{
	        					text: '단가등록',
	        					xtype: 'button',
	        					handller: function(){
	        					
	        					}
	        				}, {
	        					xtype: 'container',
	        					html:'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
	        				}, {
	        					text: '재고조회',
	        					xtype: 'button',
	        					handller: function(){
	        					
	        					}
	        				}] 
        				}*/]
        			}]
	    		}	    		
	    	]
			,loadForm: function(record)	{
   				// window 오픈시 form에 Data load
//				this.reset();
//				this.setActiveRecord(record || null);   
//				this.resetDirtyStatus();				
				
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
//				hide:function()	{
//					bookDetailForm.show();
//					detailFormSubGrid.reset();					
//				},
//				show: function ( me, eOpts )	{					
//					directSubStore.loadStoreRecords();						   			 	
//    			}
   			}
	});
	
	var getItemPSearch = Unilite.createSearchForm('getItemSearchForm', {
		padding: '0 0 0 0',
		disabled :false,
		width: 5000,
		height: 3000,		
		layout: {type: 'uniTable', columns :2},
	    trackResetOnLoad: true,
	    items: [{
           fieldLabel: '기존단가',
           name: 'BF_SALE_BASIS_P',
           xtype:'uniNumberfield',
           readOnly: true,
           colspan: 2
        }, {
           fieldLabel: '변경단가',
           name: 'SALE_BASIS_P',
           xtype:'uniNumberfield',
           colspan: 2
        }, {
           fieldLabel: '적용일자',
           name: 'SALE_DATE',
           xtype:'uniDatefield',
           colspan: 2
        }/*, {
           fieldLabel: '',
           margin: '0 0 0 5',
           xtype: 'button',
		   text: '확인',
		   handler: function() {
		   			
		   }				
         }, {
           fieldLabel: '',
           margin: '0 0 0 5',
           xtype: 'button',
		   text: '취소',
		   handler: function() {
		   		getItemPWindow.hide();	
		   }				
         }*/]
    }); // createSearchForm
    
    var getBookInfoSearch = Unilite.createSearchForm('getBookInfoSearchForm', {
		padding: '0 0 0 0',
		disabled :false,
		width: 5000,
		height: 3000,		
		layout: {type: 'uniTable', columns :1},
	    trackResetOnLoad: true,
	    items: [{
        	xtype: 'container',
			defaultType: 'uniTextfield',
			layout: {type: 'uniTable'},	
			defaults: {enforceMaxLength: true},
			items: [{
				xtype: 'uniCombobox',
				fieldLabel: '학년/학기',
				name: '',
				width: 168.5,
				comboType:'AU',
				comboCode:'',
				maxLength :10
			}, {
				hideLabel: true,
				name: '',	//쿼리에 추가할 차례
				width: 76.5, 
				maxLength :2
			}] 
          },{ 
      		name: '',
      		fieldLabel: '학과',
      		xtype:'uniCombobox',
      		comboType:'AU',
      		comboCode:'' 
      	},{
      		xtype: 'uniTextfield',
      		name: '',
      		fieldLabel: '담당교수'
      	},{
      		xtype: 'uniTextfield',
      		name: '',
      		fieldLabel: '수강인원'
      	}]
    }); // createSearchForm
	
	//단가검색 창
	function openGetItemPWindow() {
		if(!getItemPWindow) {
			getItemPWindow = Ext.create('widget.uniDetailWindow', {
                title: '단가 검색',
                resizable:false,
                width: 300,				                
                height:150,
                layout: {type:'uniTable', columns: 1},	                
                items: [getItemPSearch],
                bbar:  [ '->',
				        {	itemId : 'searchBtn',
							text: '확인',
							margin: '0 5 0 0',
							handler: function() {
								var rtnRecord = masterGrid.getSelectedRecord();
								if(Ext.isEmpty(getItemPSearch.getValue('SALE_BASIS_P'))){
									rtnRecord.set('SALE_BASIS_P', 0);
								}else{
//									goodDetailForm.setValue('SALE_BASIS_P', getItemPSearch.getValue('SALE_BASIS_P'));
									rtnRecord.set('SALE_BASIS_P', getItemPSearch.getValue('SALE_BASIS_P'));
								}								
								rtnRecord.set('BF_SALE_BASIS_P', getItemPSearch.getValue('BF_SALE_BASIS_P'));
								rtnRecord.set('SALE_DATE', getItemPSearch.getValue('SALE_DATE'));
								getItemPWindow.hide();
							},
							disabled: false
						}, {
							itemId : 'closeBtn',
							text: '취소',
							handler: function() {
								getItemPWindow.hide();
							},
							disabled: false
						},'->'
				],
				listeners : {beforehide: function(me, eOpt)	{
											getItemPSearch.clearForm();                							
                						},
                			 beforeclose: function( panel, eOpts )	{
											getItemPSearch.clearForm();
                			 			},
                			 show: function( panel, eOpts )	{
                			 	getItemPSearch.setValue('BF_SALE_BASIS_P',goodDetailForm.getValue('SALE_BASIS_P'));
                			 	getItemPSearch.setValue('SALE_BASIS_P', 0);
								getItemPSearch.setValue('SALE_DATE', Ext.isEmpty(goodDetailForm.getValue('SALE_DATE')) ? UniDate.get('today') : goodDetailForm.getValue('SALE_DATE'));
								getItemPWindow.getEl().setXY([getWindowX,getWindowY]);
                			 }
                }		
			})
		}
		getItemPWindow.show();
    }
    
    //교재 상세보기창
	function openGetBookInfoWindow() {
		if(!getBookInfoWindow) {
			getBookInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '교재구분',
                resizable:false,
                width: 300,				                
                height:180,
                layout: {type:'uniTable', columns: 1},	                
                items: [getBookInfoSearch],
                bbar:  [ '->',
				        {	itemId : 'searchBtn',
							text: '확인',
							margin: '0 5 0 0',
							handler: function() {
								var rtnRecord = masterGrid.getSelectedRecord();
								if(Ext.isEmpty(getItemPSearch.getValue('SALE_BASIS_P'))){
									rtnRecord.set('SALE_BASIS_P', 0);
								}else{
//									goodDetailForm.setValue('SALE_BASIS_P', getItemPSearch.getValue('SALE_BASIS_P'));
									rtnRecord.set('SALE_BASIS_P', getItemPSearch.getValue('SALE_BASIS_P'));
								}								
								rtnRecord.set('BF_SALE_BASIS_P', getItemPSearch.getValue('BF_SALE_BASIS_P'));
								rtnRecord.set('SALE_DATE', getItemPSearch.getValue('SALE_DATE'));
								getBookInfoWindow.hide();
							},
							disabled: false
						}, {
							itemId : 'closeBtn',
							text: '취소',
							handler: function() {
								getBookInfoWindow.hide();
							},
							disabled: false
						},'->'
				],
				listeners : {beforehide: function(me, eOpt)	{
											getItemPSearch.clearForm();                							
                						},
                			 beforeclose: function( panel, eOpts )	{
											getItemPSearch.clearForm();
                			 			},
                			 show: function( panel, eOpts )	{
                			 	getItemPSearch.setValue('BF_SALE_BASIS_P',goodDetailForm.getValue('SALE_BASIS_P'));
                			 	getItemPSearch.setValue('SALE_BASIS_P', 0);
								getItemPSearch.setValue('SALE_DATE', Ext.isEmpty(goodDetailForm.getValue('SALE_DATE')) ? UniDate.get('today') : goodDetailForm.getValue('SALE_DATE'));
								getBookInfoWindow.getEl().setXY([getWindowX,getWindowY]);
                			 }
                }		
			})
		}
		getBookInfoWindow.show();
    }
        
     Unilite.Main({
      	id  : 'bpr103ukrvApp',
		borderItems : [
			panelSearch,
			
			{	region:'center',
				//layout : 'border',
				layout : {type:'vbox', align:'stretch'},
				flex:1,
				items:[
					panelResult,
					goodDetailForm,
					bookDetailForm,
					detailForm
				]
			}
		],
		fnInitBinding : function(params) {
		    /**
			* 기본값 셋업 
			*/
			if(params && params.ITEM_CODE ) {
				panelSearch.setValue('ITEM_CODE',params.ITEM_CODE);
				masterGrid.getStore().loadStoreRecords();
			}
			panelSearch.setValue('TO_DIV_CODE',UserInfo.divCode);			
			UniAppManager.setToolbarButtons(['reset'],true);
			UniAppManager.setToolbarButtons('save', false);			
			panelSearch.getField( 'REG_YN').setValue('2');
			Ext.getCmp('rdo1').setReadOnly(true);
			Ext.getCmp('rdo2').setReadOnly(true);
			Ext.getCmp('rdo3').setReadOnly(true);
			Ext.getCmp('rdo4').setReadOnly(true);
			Ext.getCmp('rdo5').setReadOnly(true);
			Ext.getCmp('rdo6').setReadOnly(true);
			Ext.getCmp('rdo7').setReadOnly(true);
			Ext.getCmp('rdo8').setReadOnly(true);
			Ext.getCmp('rdo9').setReadOnly(true);
			Ext.getCmp('rdo10').setReadOnly(true);
			Ext.getCmp('rdo11').setReadOnly(true);
			//panelSearch.expand();
//			masterGrid.getStore().loadStoreRecords();
	    },
	    onQueryButtonDown: function () {
	    	if(!panelSearch.setAllFieldsReadOnly(true) || !panelResult.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
//	    	goodDetailForm.clearForm();
//	    	bookDetailForm.clearForm();
//			goodDetailForm.resetDirtyStatus();
//			bookDetailForm.resetDirtyStatus();
			if(activeSubGrid) activeSubGrid.reset();		
			masterGrid.getStore().loadStoreRecords();
			
			//등록여부 판단(삭제, 업데이트 로우를 컨트롤 하기 위해)
			if(panelSearch.getValue('REG_YN') == '1'){
				regFlag = '1';
				panelSearch.setValue('REG_FLAG', '1');	//매입처 단가 저장용 플래그
			}else{
				regFlag = '2';
				panelSearch.setValue('REG_FLAG', '2');  //매입처 단가 저장용 플래그	   UPDATE 동작도 INSERT해주기 위함.
			}
				//등록여부 '아니오'
		},
		onNewDataButtonDown : function()	{        	 
        	 var moneyUnit = UserInfo.currency;
        	 var saleDate = UniDate.get('today');
        	 var r = {
				MONEY_UNIT: moneyUnit,
				SALE_DATE: saleDate,
				DIV_CODE: panelSearch.getValue('DIV_CODE')
	        };	        
			masterGrid.createRow(r);
			//openDetailWindow(null, true);
		},
		onPrevDataButtonDown:  function()	{			
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();			
		},
		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		},
		/**
		 *  삭제
		 *	@param 
		 *	@return
		 */
		 onDeleteDataButtonDown: function() {
		 	var record = masterGrid.getSelectedRecord();
		 	var param= {ITEM_CODE : record.get('ITEM_CODE'), DIV_CODE: record.get('DIV_CODE')}
		 	bpr103ukrvService.checkExistBpr400tInfo(param, function(provider, response)	{
				if(provider[0].CNT > 0){	
					Unilite.messageBox('매입 단가정보를 먼저 삭제 하셔야 합니다.');
					return false;
				}else{
					if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {				
						masterGrid.deleteSelectedRow();
		//				goodDetailForm.clearForm();				
					}	
				}
			});
			
		},
		/**
		 *  저장
		 *	@param 
		 *	@return
		 */
		onSaveDataButtonDown: function (config) {
			var rtnrecord = masterGrid.getSelectedRecord();
			if(!Ext.isEmpty(rtnrecord)){
				if(Ext.isEmpty(rtnrecord.get('SALE_DATE'))){
					rtnrecord.set('SALE_DATE', UniDate.get('today'))
				}
			}
//			rtnrecord.set('TO_DIV_CODE', panelSearch.getValue('TO_DIV_CODE'))
			directMasterStore.saveStore(config);			
		}
		,onResetButtonDown:function() {			
			panelSearch.clearForm();			
//			goodDetailForm.clearForm();
			directMasterStore.removeAll();
			if(activeSubGrid) activeSubGrid.reset();
			detailForm.show();
			
			goodDetailForm.hide();
			bookDetailForm.hide();
			activeSubGrid = detailFormSubGrid;
			this.fnInitBinding();
		},
		onSaveAndQueryButtonDown : function()	{
			this.onSaveDataButtonDown();
			//this.onQueryButtonDown();
		},
		saveStoreEvent: function(str, newCard)	{
			var config = null;
			this.onSaveDataButtonDown(config);
		}, // end saveStoreEvent()
//		
//		rejectSave: function()	{
//			var rowIndex = masterGrid.getSelectedRowIndex();			
//			directMasterStore.rejectChanges();
//			if(masterGrid.getStore().getCount() > 0)	{
//				masterGrid.select(rowIndex);
//			}
//			directMasterStore.onStoreActionEnable();
//		} // end rejectSave()
		
		rejectSave: function() {			
			directMasterStore.rejectChanges();	
			directMasterStore.onStoreActionEnable();
		},
		 confirmSaveData: function(config)	{
        	if(directMasterStore.isDirty() )	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
					goodDetailForm.resetDirtyStatus();
					//if (detailWin.isVisible())	detailWin.hide();
				}
			}			
        }, fnSearchBookInfo: function(isbn){
        	 params: {
        	 	var params = {
	        		query: isbn,
	        		d_isbn: isbn,	//ex) 9788950967062 9780495384724
	        		//d_titl: '삼국지',
	        		//display: '10',
	        		display: '1'	//검색결과 출력건수
	        		//start: '1'
	        	};

	        	/*
	        	 * 네이버 검색API 책 상세검색 예
	        	 * 
	        	 * params 	: request parameters
	        	 * function : callback 함수
	        	 *    naver : UniNaverSearch 객체 자신
	        	 *    item  : 검색결과 item (array 가 될 수 있으며 params 의 display:1 로 단일건만 받을 수 있다.)
	        	 *    result: 응답 정보
	        	 */
				UniNaverSearch.searchBookAdv(params, function(naver, item, result) {					
					if(Ext.isArray(item)) {
				    	item = item[0];
		    		}		    		
					UniAppManager.app.fnSetBookInfo(item);
					var bookLink = goodDetailForm.down('#bookLink');
//					bookLink.setMargin('0 0 0 0')
					
					bookLink.setValue('<a href="javascript:void(0);" onclick="javascript:'+naver.getLinkScript(item.link)+';"><u>책소개</u></a>')
				});
        	 }      
        }, fnSetBookInfo: function(item){
           var isbn = item.isbn.substring(0,10);
           var rtnRecord = masterGrid.getSelectedRecord();
           rtnRecord.set('ISBN_CODE', isbn);
           rtnRecord.set('ITEM_NAME', item.title);
           rtnRecord.set('PUBLISHER', item.publisher);
           rtnRecord.set('AUTHOR1',   item.author);
           rtnRecord.set('PUB_DATE',  item.pubdate);
           rtnRecord.set('SALE_COMMON_P', item.price);
           rtnRecord.set('BOOK_LINK', item.link);
           
           
//         goodDetailForm.setValue('ISBN_CODE',  		 isbn);			//isbn
//         goodDetailForm.setValue('ITEM_NAME',  		 item.title);	//도서명
//	     goodDetailForm.setValue('PUBLISHER',     	 item.publisher);	//출판사 정보
//	     goodDetailForm.setValue('AUTHOR1',  		 item.author);		//저자
//	     goodDetailForm.setValue('AUTHOR2',  		 item.author);
//  	     goodDetailForm.setValue('TRANSRATOR',  	 item.description);	//역자
//	     goodDetailForm.setValue('PUB_DATE',  		 item.pubdate); 	//출간일
//	     goodDetailForm.setValue('SALE_COMMON_P',  	 item.price); 	    //정가
	    }
	});
	
	Unilite.createValidator('masterGridValidator', {
		store : directMasterStore,
		grid: masterGrid,
		forms: {'formA:':goodDetailForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			
			if(fieldName == "SALE_BASIS_P" )	{	
					if(newValue < 0 ) {
						 rv='<t:message code="unilite.msg.sMB076" default="양수만 입력가능합니다."/>';
					}else{
						var rtnRecord = masterGrid.getSelectedRecord();
						rtnRecord.set('BF_SALE_BASIS_P', rtnRecord.get('SALE_BASIS_P'));
						rtnRecord.set('SALE_DATE', UniDate.get('today'));
					}
					
			}
			return rv;
		}
	}); // validator
	
	Unilite.createValidator('goodDetailFormSubGridValidator', {
		store : directSubStore,
		grid: goodDetailFormSubGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			
			if(fieldName == "PURCHASE_RATE" )	{	
					if(newValue < 0 ) {
						 rv='<t:message code="unilite.msg.sMB076" default="양수만 입력가능합니다."/>';
					}else{
						if(!Ext.isEmpty(goodDetailForm.getValue('SALE_BASIS_P')) && goodDetailForm.getValue('SALE_BASIS_P') != 0){
							record.set('ITEM_P', goodDetailForm.getValue('SALE_BASIS_P') * (newValue / 100) );
						}												
					}
					
			}else if(fieldName == "ITEM_P"){
				if(newValue < 0 ) {
						 rv='<t:message code="unilite.msg.sMB076" default="양수만 입력가능합니다."/>';
				}else{
					if(!Ext.isEmpty(goodDetailForm.getValue('SALE_BASIS_P')) && goodDetailForm.getValue('SALE_BASIS_P') != 0){
						record.set('PURCHASE_RATE',   newValue / (goodDetailForm.getValue('SALE_BASIS_P') / 100));
					}
				}
			}
			return rv;
		}
	}); // validator
	Unilite.createValidator('bookDetailFormSubGridValidator', {
		store : directSubStore,
		grid: bookDetailFormSubGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			
			if(fieldName == "PURCHASE_RATE" )	{	
					if(newValue < 0 ) {
						 rv='<t:message code="unilite.msg.sMB076" default="양수만 입력가능합니다."/>';
					}else{
						if(!Ext.isEmpty(bookDetailForm.getValue('SALE_BASIS_P')) && bookDetailForm.getValue('SALE_BASIS_P') != 0){
							record.set('ITEM_P', bookDetailForm.getValue('SALE_BASIS_P') * (newValue / 100) );
						}												
					}
					
			}else if(fieldName == "ITEM_P"){
				if(newValue < 0 ) {
						 rv='<t:message code="unilite.msg.sMB076" default="양수만 입력가능합니다."/>';
				}else{
					if(!Ext.isEmpty(bookDetailForm.getValue('SALE_BASIS_P')) && bookDetailForm.getValue('SALE_BASIS_P') != 0){
						record.set('PURCHASE_RATE',   newValue / (bookDetailForm.getValue('SALE_BASIS_P') / 100));
					}
				}
			}
			return rv;
		}
	}); // validator	

	Unilite.createValidator('formValidator', {
		forms: {'formA:':goodDetailForm},		
		validate: function( type, fieldName, newValue, oldValue) {
			if(newValue == oldValue){
				return false;
			}
			var rv = true;
			switch(fieldName) {	
				case "SALE_BASIS_P" :
					var rtnRecord = masterGrid.getSelectedRecord();
					goodDetailForm.setValue('BF_SALE_BASIS_P', rtnRecord.get('SALE_BASIS_P'));
					if(Ext.isEmpty(goodDetailForm.getValue('SALE_DATE'))){
						goodDetailForm.setValue('SALE_DATE', UniDate.get('today'));
					}
					
				break;
			}
			return rv;
		}
	}); 
};


</script>

