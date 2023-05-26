<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr102skrv"  >
<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->	
<t:ExtComboStore comboType="AU" comboCode="B013" /><!-- 단위 -->
<t:ExtComboStore comboType="AU" comboCode="B059" /><!-- 세구분 -->
<t:ExtComboStore comboType="AU" comboCode="B010" /><!-- 단위 -->
<t:ExtComboStore comboType="AU" comboCode="B020"  opts= '${itemAccount}'/><!-- 품목계정 -->
<t:ExtComboStore comboType="AU" comboCode="B014" /><!-- 조달구분 -->
<t:ExtComboStore comboType="AU" comboCode="B061" /><!-- 발주방침 -->
<t:ExtComboStore comboType="AU" comboCode="A003" /><!-- 매입매출 구분 -->
<t:ExtComboStore comboType="AU" comboCode="B019" /><!-- 국내외 -->
<t:ExtComboStore comboType="AU" comboCode="YP08" /><!-- 매입조건 -->
<t:ExtComboStore comboType="AU" comboCode="YP09" /><!-- 판매형태 -->
<t:ExtComboStore comboType="AU" comboCode="YP02" opts= '${binNumList}' /> <!-- 도서 진열대번호 -->
<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="bpr102skrvLevel1Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="bpr102skrvLevel2Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="bpr102skrvLevel3Store" />
</t:appConfig>
<script type="text/javascript" >
//var detailWin;
var stockSearchWindow; //창고별재고 조회 그리드
var getItemPWindow;
var getBookInfoWindow;
var getWindowX;
var getWindowY;

function appMain() {
	var processFlag = '0';
	var isViewImage = false;	//이미지 보임 여부..
	////마스트 모델에 교재여부 정의하려는데 bpr100t에 컬럼 없음
	Ext.define("Docs.view.search.Container", {
		extend: "Ext.container.Container",
		alias: "widget.searchcontainer",
		initComponent: function() {
			var me = this;	
	    	var searchStore  = Ext.create('Ext.data.Store',{
	            fields: [ 
		            {name:'ITEM_NAME', type:'string'}
	            ],	            
	            storeId: 'SearchMenuStore',
	            autoLoad: false,
	            pageSize: 50,
	            proxy: {
	                type: 'direct',
	                api: {
	                    read : 'bpr102skrvService.searchMenu'
	                },
		            reader: {
		                type: 'json',
				<c:choose>
		        	<c:when test="${ext_version == '4.2.2'}">
		        		root: 'records'	//4.2.2
		        	</c:when>		
		        	<c:otherwise>
		        		rootProperty: 'records'	//5.1.0
		        	</c:otherwise>		
		        </c:choose>		                
		            },
		            extraParams: {
				        DIV_CODE: UserInfo.divCode
//				        param2: 'value2'
				    }
	            }
	        });
			this.items = [{
				fieldLabel:'도서명',
		        xtype: "combobox",
		        autoSelect: false,
	  	        store: searchStore,
		        queryMode: 'remote',
	//	        pageSize: true, 
		        displayField: 'ITEM_NAME',
		        name: 'ITEM_NAME',
		        minChars: 1,
		        queryParam: 'searchStr',
		        hideTrigger: true,
		        selectOnFocus: false,
//		        labelWidth: 147,
		        width: 450,
		        itemId: 'itemSearchForm',
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_NAME', newValue);
						panelResult.setValue('ITEM_NAME', newValue);
					},
					blur: function(){
						var itemID = me.getItemId();
						if(itemID == 'panelSearch'){
							panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
						}else{
							panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
						}
					}
				}
			}];  
			searchStore.on('beforeload', function(store, operation) {		    
		    var proxy = store.getProxy();
		    proxy.setConfig('extraParams', {DIV_CODE: panelSearch.getValue('DIV_CODE')});
//		    console.log(store.getProxy().getCurrentConfig());
			});
			this.callParent();
		}
	});
	/**
	 * Master Model
	 */				
	 
	Unilite.defineModel('bpr102skrvModel', {
		fields: [	 //BPR100T필수
					 { name: 'STOCK_UNIT',  			text: '<t:message code="system.label.base.inventoryunit" default="재고단위"/>', 		type : 'string', allowBlank: false, comboType:'AU', comboCode:'B013', displayField: 'value'/*, defaultValue: 'EA'*/ }      
			  		,{ name: 'TAX_TYPE',  				text: '<t:message code="system.label.base.taxtype" default="세구분"/>', 		type : 'string', allowBlank: false, comboType:'AU', comboCode:'B059' /*, defaultValue:'2'*/}
    	 	 		,{ name: 'ITEM_CODE',  				text: '도서코드', 		type : 'string', allowBlank:true, isPk:true, pkGen:'user',maxLength: 20}      
			  		,{ name: 'ITEM_NAME',  				text: '도서명', 		type : 'string', allowBlank: false, maxLength: 40}        
			  		
			  		,{ name: 'SPEC',  					text: '<t:message code="system.label.base.spec" default="규격"/>', 		type : 'string', maxLength: 160}
				    ,{ name: 'ITEM_LEVEL1',  			text: '<t:message code="system.label.base.majorgroup" default="대분류"/>', 		type : 'string', store: Ext.data.StoreManager.lookup('bpr102skrvLevel1Store'), child:'ITEM_LEVEL2'}        					       
				    ,{ name: 'ITEM_LEVEL2',  			text: '<t:message code="system.label.base.middlegroup" default="중분류"/>', 		type : 'string', store: Ext.data.StoreManager.lookup('bpr102skrvLevel2Store'), child:'ITEM_LEVEL3'}        
				    ,{ name: 'ITEM_LEVEL3',  			text: '<t:message code="system.label.base.minorgroup" default="소분류"/>', 		type : 'string', store: Ext.data.StoreManager.lookup('bpr102skrvLevel3Store'),parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'], levelType:'ITEM'}
			  		,{ name: 'SALE_UNIT',  				text: '<t:message code="system.label.base.salesunit" default="판매단위"/>', 		type : 'string', comboType:'AU', comboCode:'B013', displayField: 'value', allowBlank: false/*, defaultValue: 'EA'*/}      
			  		,{ name: 'TRNS_RATE',  				text: '<t:message code="system.label.base.salespackednumber" default="판매입수"/>', 		type : 'uniUnitPrice', /*defaultValue:1.00,*/ maxLength: 12}           
			  		,{ name: 'SALE_BASIS_P',  	 		text: '<t:message code="system.label.base.sellingprice" default="판매단가"/>', 		type : 'uniUnitPrice', maxLength: 18, allowBlank: false}
			  		,{ name: 'BF_SALE_BASIS_P',  		text: '이전단가', 		type : 'uniUnitPrice', maxLength: 18}			  		
			  		
			  		//BPR200T 필수
			  		,{ name: 'DIV_CODE',  				text: '<t:message code="system.label.base.division" default="사업장"/>', 		type : 'string', maxLength: 80, allowBlank: false, comboType: 'BOR120'/*, multiSelect: true, typeAhead: false*/}
			  		,{ name: 'ITEM_ACCOUNT',  			text: '<t:message code="system.label.base.itemaccount" default="품목계정"/>', 		type : 'string', comboType:'AU', comboCode:'B020', maxLength: 80, allowBlank: false/*, defaultValue: '00'*/}
			  		,{ name: 'SUPPLY_TYPE',  			text: '<t:message code="system.label.base.procurementclassification" default="조달구분"/>', 		type : 'string', comboType:'AU', comboCode:'B014', maxLength: 80, allowBlank: false}			  		
			  		,{ name: 'ORDER_UNIT',  			text: '<t:message code="system.label.base.purchaseunit" default="구매단위"/>', 		type : 'string', comboType:'AU', comboCode:'B013', displayField: 'value', allowBlank: false/*, defaultValue: 'EA'*/ }
			  		,{ name: 'WH_CODE',  				text: '<t:message code="system.label.base.mainwarehouse" default="주창고"/>', 		type : 'string', maxLength: 80,  store: Ext.data.StoreManager.lookup('whList'), defaultValue: 'W052'}
			  		,{ name: 'ORDER_PLAN',  			text: '<t:message code="system.label.base.popolicy" default="발주방침"/>', 		type : 'string', comboType:'AU', comboCode:'B061', maxLength: 80, allowBlank: true/*, defaultValue:1*/}
			  		
			  		//BPR200T 일반
			  		,{ name: 'BUY_RATE',  				text: '<t:message code="system.label.base.purchasereceiptcount" default="구매입수"/>', 		type : 'int', maxLength: 12/*, defaultValue:1*/}
			  		,{ name: 'LOCATION',  				text: 'Location', 	type : 'string', maxLength: 8}
			  		,{ name: 'MATRL_PRESENT_DAY',  		text: '올림기간', 		type : 'int', maxLength: 10} //자재올림
			  		,{ name: 'PURCHASE_BASE_P',  		text: '공통구매단가', 	type : 'uniUnitPrice', maxLength: 18}
			  		,{ name: 'CUSTOM_CODE',  			text: '기준거래처', 	type : 'string', maxLength: 8}
			  		,{ name: 'CUSTOM_NAME',  			text: '기준거래처명', 	type : 'string', maxLength: 20}
			  		
			  		
			  		
			  		
			  		//hidden
			  		,{ name: 'ITEM_NAME1',  			text: '도서명1', 		type : 'string', maxLength: 40}       
			  		,{ name: 'ITEM_NAME2',  			text: '도서명2', 		type : 'string', maxLength: 40}
			  		,{ name: 'DOM_FORIGN',  			text: '국내외구분', 	type : 'string', maxLength: 2, comboType:'AU', comboCode:'B019', defaultValue:'1' }
				    ,{ name: 'ITEM_GROUP',  			text: '<t:message code="system.label.base.repmodelcode" default="대표모델코드"/>',	type : 'string', maxLength: 20 }  
				    ,{ name: 'ITEM_GROUP_NAME',  		text: '<t:message code="system.label.base.repmodelname" default="대표모델명"/>', 	type : 'string', maxLength: 40}    
			  		,{ name: 'STOCK_CARE_YN',  			text: '<t:message code="system.label.base.inventorymanageobject" default="재고관리대상"/>', 	type : 'string', comboType:'AU', comboCode:'B010', defaultValue:'Y'}   
			  		,{ name: 'START_DATE',  			text: '<t:message code="system.label.base.usestartdate" default="사용시작일"/>', 	type : 'uniDate',  maxLength: 10}    
			  		,{ name: 'STOP_DATE',  				text: '<t:message code="system.label.base.usestopdate" default="사용중단일"/>', 	type : 'uniDate', maxLength: 10}    
			  		,{ name: 'USE_YN',  				text: '<t:message code="system.label.base.photoflag" default="사진유무"/>', 		type : 'string', allowBlank: false, comboType:'AU', comboCode:'B010',defaultValue:'Y'}				    
				    ,{ name: 'SALE_COMMON_P',  			text: '시중가', 		type : 'uniUnitPrice', maxLength: 18, allowBlank: true}
				    ,{ name: 'AUTO_DISCOUNT',  			text: '자동할인여부', 	type : 'string', maxLength: 80, comboType:'AU', comboCode:'B010',defaultValue:'Y', allowBlank: false}
				    ,{ name: 'MEMBER_DISCOUNT_YN',  	text: '회원할인대상', 	type : 'string', maxLength: 80, comboType:'AU', comboCode:'B010',defaultValue:'N', allowBlank: false}
				    ,{ name: 'SPEC_CONTROL',  			text: '특정여부', 		type : 'string', maxLength: 80, comboType:'AU', comboCode:'B010',defaultValue:'N', allowBlank: false}
				    ,{ name: 'SPEC_CONTROL_CODE',	  	text: '특정코드', 		type : 'string', maxLength: 3}				    
			  		,{ name: 'EXCESS_RATE',  			text: '과출고허용률 ',	type : 'uniPercent', defaultValue:0.00,maxLength: 3}	
			  		,{ name: 'BOOK_LINK',  				text: '책소개링크 ',	type : 'string'}
			  		
			  		,{ name: 'ISBN_CODE',  				text: 'ISBN코드', 	type : 'string', maxLength: 20}
			  		,{ name: 'PUBLISHER_CODE',  		text: '출판사코드', 	type : 'string', maxLength: 8}
			  		,{ name: 'PUBLISHER',  				text: '출판사', 		ype : 'string', maxLength: 50}
			  		,{ name: 'AUTHOR1',  				text: '저자1', 		type : 'string', maxLength: 30}
			  		,{ name: 'AUTHOR2',  				text: '저자2', 		type : 'string', maxLength: 30}
			  		,{ name: 'TRANSRATOR',  			text: '역자', 		type : 'string', maxLength: 30}
			  		,{ name: 'PUB_DATE',  				text: '초판발행일', 	type : 'uniDate', maxLength: 8}
			  		,{ name: 'BIN_NUM',  				text: '서가진열대번호', type : 'string', maxLength: 20}
			  		,{ name: 'BIN_NAME',  				text: 'BIN_NAME', 	type : 'string', maxLength: 100}
			  		,{ name: 'BIN_FLOOR',  				text: '선반번호', 		type : 'string', maxLength: 2 }//bpr100t 추가
			  		,{ name: 'PROD_TYPE',  				text: '교재여부', 		type : 'string', maxLength: 80,defaultValue:'Y'}
			  		
			  		,{ name: 'FIRST_PURCHASE_DATE',   	text: '최초매입일 ', 	type : 'uniDate', maxLength: 10}
			  		,{ name: 'LAST_PURCHASE_DATE',    	text: '최종매입일 ', 	type : 'uniDate', maxLength: 10}
			  		,{ name: 'FIRST_SALES_DATE',      	text: '최초판매일 ', 	type : 'uniDate', maxLength: 10}
			  		,{ name: 'LAST_SALES_DATE',       	text: '최종판매일 ', 	type : 'uniDate', maxLength: 10}
			  		,{ name: 'LAST_RETURN_DATE',      	text: '최종반품일 ', 	type : 'uniDate', maxLength: 10}
			  		,{ name: 'LAST_DELIVERY_DATE',    	text: '최종납품일 ', 	type : 'uniDate', maxLength: 10}
			  		,{ name: 'LAST_DELIVERY_CUSTOM',  	text: '최종납품처 ', 	type : 'string' , maxLength: 10}
			  		
			  		
			  		
			  		,{ name: 'REMARK1',  				text: '비고1', 		type : 'string', maxLength: 300}
			  		,{ name: 'REMARK2',  				text: '비고2', 		type : 'string', maxLength: 300}
			  		,{ name: 'REMARK3',  				text: '비고3', 		type : 'string', maxLength: 300}
			  		,{ name: 'MONEY_UNIT',  			text: 'MONEY_UNIT', type : 'string', maxLength: 80}
			  		,{ name: 'SALE_DATE',  				text: 'SALE_DATE',  type : 'uniDate', maxLength: 10}
			  		
			  		,{ name: 'PROPER_STOCK_Q',  		text: '적정재고',  	type : 'uniQty', maxLength: 10}
			  		,{ name: 'STOCK_Q',  				text: '현재고',   	type : 'uniQty', maxLength: 10}
			  		,{ name: 'RTN_REMAIN_Q',  			text: '반품예정',   	type : 'uniQty', maxLength: 10}
			  		,{ name: 'ISSUE_PLAN_Q',  			text: '납품예정일',  	type : 'uniQty', maxLength: 10}			  		
		]
	});
	
	/**
	 * Master Store
	 */
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bpr102skrvService.selectDetailList',
			update: 'bpr102skrvService.updateDetail',
			create: 'bpr102skrvService.insertDetail',
			destroy: 'bpr102skrvService.deleteDetail',
			syncAll: 'bpr102skrvService.saveAll'
		}
	});
	var directMasterStore = Unilite.createStore('bpr102skrvMasterStore',{
			model: 'bpr102skrvModel',
           	autoLoad: false,
        	uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
           	proxy: directProxy
			,listeners: {
	            write: function(proxy, operation){
	                if (operation.action == 'destroy') {
	                	Ext.getCmp('detailForm').reset();			         
	                }                
            	}            
        	}
        	,loadStoreRecords : function()	{
				var param= panelSearch.getValues();
				var checkParam = {ITEM_CODE: param.ITEM_CODE.trim(), DIV_CODE: param.DIV_CODE}
				bpr101ukrvService.checkItemCode(checkParam, function(provider1, response)	{
					if(!Ext.isEmpty(param.ITEM_CODE) && !isNaN(param.ITEM_CODE) && 13 != param.ITEM_CODE.length && provider1[0].CNT == 0){
						var zero = ''
						var dataLength = param.ITEM_CODE.length;
						for(var i = 0; i < 13 - dataLength; i++){
							zero += '0'
						}
						param.ITEM_CODE = zero + param.ITEM_CODE;
						panelSearch.setValue('ITEM_CODE', param.ITEM_CODE);
						panelResult.setValue('ITEM_CODE', param.ITEM_CODE);							
						directMasterStore.load({
							params : param,
							callback : function(records, operation, success) {							
								if(success)	{
									var record = directMasterStore.data.items[0];
									if(Ext.isEmpty(record) && masterGrid.isHidden()){
										detailForm.hide();
										Unilite.messageBox(Msg.sMB015);
										return false;
									}
		    						if(processFlag == '1'){	    							
										detailForm.loadForm(record);
										masterGrid.hide();
										processFlag = '0'									
		    						}
		    						var record = masterGrid.getSelectedRecord();
									if(record && record.phantom){
//										detailForm.down('#setBasisPBtn').setDisabled(true);
//										detailForm.getField('SALE_BASIS_P').setReadOnly(false);
									}else{
//										detailForm.down('#setBasisPBtn').setDisabled(false);
//										detailForm.getField('SALE_BASIS_P').setReadOnly(true);
									}  
								}
//								if(record){
//									UniAppManager.app.fnGetbookImage(record.get('ITEM_CODE'));
//								}else{
//									var bookImage = detailForm.down('#bookImage');
//										bookImage.setSrc('');	
//								}		
								if(masterGrid.isHidden()){
									detailForm.getEl().unmask();
//									directSubStore.loadStoreRecords();
								}
							}
						});						
					}else{
						directMasterStore.load({
							params : param,
							callback : function(records, operation, success) {							
								if(success)	{
									var record = directMasterStore.data.items[0];
									if(Ext.isEmpty(record) && masterGrid.isHidden()){
										detailForm.hide();
										Unilite.messageBox(Msg.sMB015);
										return false;
									}
		    						if(processFlag == '1'){	    							
										detailForm.loadForm(record);
										masterGrid.hide();
										processFlag = '0'									
		    						}
		    						var record = masterGrid.getSelectedRecord();
									if(record && record.phantom){
//										detailForm.down('#setBasisPBtn').setDisabled(true);
//										detailForm.getField('SALE_BASIS_P').setReadOnly(false);
									}else{
//										detailForm.down('#setBasisPBtn').setDisabled(false);
//										detailForm.getField('SALE_BASIS_P').setReadOnly(true);
									}  
								}
//								if(record){
//									UniAppManager.app.fnGetbookImage(record.get('ITEM_CODE'));
//								}else{
//									var bookImage = detailForm.down('#bookImage');
//										bookImage.setSrc('');	
//								}		
								if(masterGrid.isHidden()){
//									directSubStore.loadStoreRecords();
								}
							}
						});
					}				
				});				
			}
			,saveStore : function(config)	{	
//				var paramMaster= [];
//				var app = Ext.getCmp('bpr102skrvApp');
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
								var master = batch.operations[0].getResultSet();								
								var param = {KEY_VALUE: master.KEY_VALUE}
								bpr102skrvService.goInterFace(param, function(provider, response)	{
								});
								detailForm.resetDirtyStatus();
								UniAppManager.setToolbarButtons('save', false);
//								detailForm.down('#setBasisPBtn').setDisabled(false);
//								detailForm.getField('SALE_BASIS_P').setReadOnly(true);
							 } 
					};
					
//					if(config == null)	{
//						var config = {success : 
//											function()	{
//												detailForm.resetDirtyStatus();
//											}
//									}
//						
//					}
					this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			listeners:{
				update:function( store, record, operation, modifiedFieldNames, eOpts )	{
					if(masterGrid.isVisible())	{
						detailForm.setActiveRecord(record);
					}
				}	
			}
	});
	
	
	Unilite.defineModel('bpr102skrvSubModel', {
    	fields: [ {name: 'CUSTOM_CODE'	 		,text: '매입처코드' 			,type: 'string', allowBlank: false},
		    	  {name: 'CUSTOM_NAME'	 		,text: '매입처명' 				,type: 'string', allowBlank: false},
		    	  {name: 'TYPE'	 				,text: '<t:message code="system.label.base.classfication" default="구분"/>' 				,type: 'string', comboType:'AU', comboCode:'A003'},
		    	  {name: 'PURCHASE_TYPE'	 	,text: '매입조건' 				,type: 'string', comboType:'AU', comboCode:'YP08', defaultValue: '1'},
		    	  {name: 'SALES_TYPE'	 		,text: '판매형태' 				,type: 'string', comboType:'AU', comboCode:'YP09', defaultValue: '1'},
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
		      	  {name: 'UPDATE_DB_TIME'		,text: 'UPDATE_DB_TIME' 	,type: 'string'}	
			  	 
			  	 
		]
	});
	
	var directSubProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bpr102skrvService.selectSubDetailList',
			update: 'bpr102skrvService.updateSubDetail',
			create: 'bpr102skrvService.insertSubDetail',
			destroy: 'bpr102skrvService.deleteSubDetail',
			syncAll: 'bpr102skrvService.subSaveAll'
		}
	});
	
	var directSubStore = Unilite.createStore('bpr102skrvSubStore', {
		model: 'bpr102skrvSubModel',
        autoLoad: false,
        uniOpt : {
        	isMaster: false,			// 상위 버튼 연결
        	editable: true,			// 수정 모드 사용
        	deletable:true,			// 삭제 가능 여부
            useNavi : false			// prev | next 버튼 사용
        },
        proxy: directSubProxy
        ,loadStoreRecords : function(selected)	{
        	var record = selected;
        	if(Ext.isEmpty(record) || directMasterStore.getCount() == 0){
        		return false;
        	}
        	if(Ext.isEmpty(record.get('ITEM_CODE'))){
        		return false;
        	}
			var param = {DIV_CODE: record.get('DIV_CODE'), ITEM_CODE: record.get('ITEM_CODE')}			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
			config = {
//							params: [paramMaster],
				success: function(batch, option) {
					var master = batch.operations[0].getResultSet();								
					var param = {KEY_VALUE: master.KEY_VALUE}
					bpr102skrvService.goInterFace(param, function(provider, response)	{
					});
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
	    	if (records) {
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
//	    		detailForm.getField('SALE_COMMON_P').setReadOnly(false);
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
    		var toolbar = subGrid.getDockedItems('toolbar[dock="top"]');
			var obj = toolbar[0].getComponent(btnName);
			if(obj) {
				(state) ? obj.enable():obj.disable();
			}
    	}
	});
	
	

	/**
	 * 검색 Form
	 */
	var sortSeqStore = Unilite.createStore('bpr102skrvSeqStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'<t:message code="system.label.base.ascending" default="오름차순"/>'		, 'value':'ASC'},
			        {'text':'<t:message code="system.label.base.descending" default="내림차순"/>'		, 'value':'DESC'}
	    		]
		});
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',         
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        	panelSearch.down('#itemSearchForm').setWidth(450);
	        },
	        expand: function() {
	        	panelResult.hide();	        	
	        	panelSearch.down('#itemSearchForm').setWidth(245);
	        },
			afterrender: function(){	  			 	
				if(!UserInfo.appOption.collapseLeftSearch){
					panelSearch.down('#itemSearchForm').setWidth(245);
				}
 			}
	        
	        
	    },
		items: [{     
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',   
			itemId: 'search_panel1',
			layout: {type: 'vbox', align: 'stretch'},
            items: [{
        		xtype: 'container',
        		layout: {type: 'uniTable', columns: 1},
        		items: [{
        			xtype: 'uniTextfield',
		            name: 'ITEM_CODE',  		
	    			fieldLabel: '도서코드' ,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ITEM_CODE', newValue);
						},
						specialkey: function(field, event){
							if(Ext.isEmpty(field.getValue())) return false;
							if(event.getKey() == event.ENTER){
								var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
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
							                  		UniAppManager.app.onSaveAndQueryButtonDown();
							                    });
							                    saveTask.delay(500);
									     	} else if(res === 'no') {
									     		UniAppManager.app.onQueryButtonDown();
									     	}
									     }
									});
								} else {
									setTimeout(function(){
										UniAppManager.app.onQueryButtonDown()
										}
										, 500
									)
								}
							}												
						}
					}
	    		},{ 
	    			xtype: 'searchcontainer',
	    			itemId: 'panelSearch'
	            },{ 
					fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
					name: 'DIV_CODE',
					xtype: 'uniCombobox',
					comboType: 'BOR120',
					allowBlank: false,
					readOnly: false,
					listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
							combo.changeDivCode(combo, newValue, oldValue, eOpts);
							panelResult.setValue('DIV_CODE', newValue);
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
			}]			
    	}, {
		 	title:'<t:message code="system.label.base.additionalinfo" default="추가정보"/>',
   			id: 'search_panel2',
			itemId:'search_panel2',
        	defaultType: 'uniTextfield',
        	layout: {type: 'uniTable', columns: 1},
		 	items: [{
		    	name: 'ITEM_LEVEL1',
    			fieldLabel: '<t:message code="system.label.base.majorgroup" default="대분류"/>',
    			xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('bpr102skrvLevel1Store'),
                child: 'ITEM_LEVEL2'
              }, {
              	name: 'ITEM_LEVEL2',
              	fieldLabel: '<t:message code="system.label.base.middlegroup" default="중분류"/>',
              	xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('bpr102skrvLevel2Store'),
                child: 'ITEM_LEVEL3'
                
             }, {
             	name: 'ITEM_LEVEL3',
             	fieldLabel: '<t:message code="system.label.base.minorgroup" default="소분류"/>',
             	xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('bpr102skrvLevel3Store'),
                parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
                levelType:'ITEM'
            }, {
            	fieldLabel: '<t:message code="system.label.base.searchitem" default="검색항목"/>' ,
            	name:'TXTFIND_TYPE',
            	xtype: 'uniCombobox',
            	comboType:'AU',
            	comboCode:'B052',
            	value:'01'
            }, {
            	fieldLabel: '<t:message code="system.label.base.searchword" default="검색어"/>',
            	name: 'TXT_SEARCH' ,
            	xtype: 'uniTextfield' 
            }, {
            	fieldLabel: '<t:message code="system.label.base.repmodel" default="대표모델"/>',
            	name:'ITEM_GROUP',
            	xtype: 'uniTextfield'
            }, {
	    		xtype: 'radiogroup',		            		
	    		fieldLabel: '<t:message code="system.label.base.useyn" default="사용여부"/>',	    		
	    		items: [{
	    			boxLabel: '<t:message code="system.label.base.use" default="사용"/>',
	    			width: 80,
	    			name: 'USE_YN',
	    			inputValue: 'Y',
	    			checked: true
	    		}, {
	    			boxLabel: '<t:message code="system.label.base.unused" default="미사용"/>',
	    			width: 80,
	    			name: 'USE_YN',
	    			inputValue: 'N'
	    		}]
	        }]	            			             			 
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
		weight:-100,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{		
			name: 'ITEM_CODE',  		
			fieldLabel: '도서코드' ,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ITEM_CODE', newValue);
				},
				specialkey: function(field, event){
					if(Ext.isEmpty(field.getValue())) return false;
					if(event.getKey() == event.ENTER){	
						var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
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
					                  		UniAppManager.app.onSaveAndQueryButtonDown();
					                    });
					                    saveTask.delay(500);
							     	} else if(res === 'no') {
							     		UniAppManager.app.onQueryButtonDown();
							     	}
							     }
							});
						} else {
							setTimeout(function(){
								UniAppManager.app.onQueryButtonDown()
								}
								, 500
							)
						}						
					}					
				}
			}
		},{ 
			xtype: 'searchcontainer',
			itemId: 'panelResult'
        },{ 
			fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			labelWidth: 140,
			readOnly: false,
			allowBlank: false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					panelSearch.setValue('DIV_CODE', newValue);
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
		}/*, {
			text: '상품전송',
			xtype: 'button',
			margin: '0 0 0 40',
			handler: function(){    	
				var param = panelSearch.getValues();
				bpr102skrvService.goInterFace(param, function(provider, response)	{
				});
			}
		}*/]	
    });
	
	
    /**
     * Master Grid
     */
	 var masterGrid = Unilite.createGrid('bpr102skrvGrid', {  
    	region:'center',
    	store : directMasterStore,
    	sortableColumns : false,
    	//border:false,
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
        columns:  [ { dataIndex: 'ITEM_CODE',  			  	width: 105, isLink:true, locked: false},
        			{ dataIndex: 'ITEM_NAME',  			  	width: 200, locked: false},
        			{ dataIndex: 'SPEC',  				  	width: 90},
        			{ dataIndex: 'STOCK_UNIT',  		  	width: 90, align: 'center'},
        			{ dataIndex: 'ITEM_LEVEL1',  		  	width: 120},
        			{ dataIndex: 'ITEM_LEVEL2',  		  	width: 120},
        			{ dataIndex: 'ITEM_LEVEL3',  		  	width: 120},
        			{ dataIndex: 'DIV_CODE',  			  	width: 130, hidden: true},
        			{ dataIndex: 'SALE_UNIT',  			  	width: 90, align: 'center'},
        			{ dataIndex: 'TRNS_RATE',  			  	width: 80},
        			{ dataIndex: 'TAX_TYPE',  			  	width: 80, align: 'center'},
        			{ dataIndex: 'SALE_BASIS_P',  	 	  	width: 100},
        			{ dataIndex: 'SALE_COMMON_P',		  	width: 80},
        			{ dataIndex: 'ITEM_ACCOUNT',  		  	width: 145},
        			{ dataIndex: 'SUPPLY_TYPE',  		  	width: 110},
        			{ dataIndex: 'ORDER_UNIT',  		  	width: 90, align: 'center'},
        			{ dataIndex: 'WH_CODE',  			  	width: 160, hidden: true},
        			{ dataIndex: 'ORDER_PLAN',  		  	width: 100},
        			
//        			hidden
        			{ dataIndex: 'ITEM_NAME1',  		    width: 140, hidden: true},
        			{ dataIndex: 'ITEM_NAME2',  		    width: 140, hidden: true},
        			{ dataIndex: 'ITEM_GROUP',  		  	width: 80, hidden: true},
					{ dataIndex: 'ITEM_GROUP_NAME',  	  	width: 80, hidden: true},	
        			{ dataIndex: 'STOCK_CARE_YN',  		  	width: 80, hidden: true},
        			{ dataIndex: 'START_DATE',  		  	width: 80, hidden: true},
        			{ dataIndex: 'STOP_DATE',  			  	width: 80, hidden: true},
        			{ dataIndex: 'USE_YN',  			  	width: 80, hidden: true},        			
        			{ dataIndex: 'AUTO_DISCOUNT',  		  	width: 80, hidden: true},
        			{ dataIndex: 'MEMBER_DISCOUNT_YN',  	width: 80, hidden: true},
        			{ dataIndex: 'SPEC_CONTROL',  		  	width: 80, hidden: true},
        			{ dataIndex: 'SPEC_CONTROL_CODE',	  	width: 80, hidden: true},
        			{ dataIndex: 'EXCESS_RATE',  		  	width: 80, hidden: true},
        			{ dataIndex: 'BOOK_LINK',  		  		width: 80, hidden: true},
        			{ dataIndex: 'ISBN_CODE',  			  	width: 80, hidden: true},
        			{ dataIndex: 'PUBLISHER_CODE',  		width: 80, hidden: true},
        			{ dataIndex: 'PUBLISHER',  				width: 80, hidden: true},
        			{ dataIndex: 'AUTHOR1',  	  			width: 80, hidden: true},
        			{ dataIndex: 'AUTHOR2',  	  			width: 80, hidden: true},
        			{ dataIndex: 'TRANSRATOR',    			width: 80, hidden: true},
        			{ dataIndex: 'PUB_DATE',  	  			width: 80, hidden: true},
        			{ dataIndex: 'BIN_NUM',  	  			width: 80, hidden: true},
        			{ dataIndex: 'BIN_FLOOR',  	  			width: 80, hidden: true},
        			{ dataIndex: 'PROD_TYPE',  	  			width: 80, hidden: true},
        			{ dataIndex: 'FIRST_PURCHASE_DATE',   	width: 80, hidden: true},
        			{ dataIndex: 'LAST_PURCHASE_DATE',    	width: 80, hidden: true},
        			{ dataIndex: 'FIRST_SALES_DATE',      	width: 80, hidden: true},
        			{ dataIndex: 'LAST_SALES_DATE',       	width: 80, hidden: true},
        			{ dataIndex: 'LAST_RETURN_DATE',      	width: 80, hidden: true},
        			{ dataIndex: 'LAST_DELIVERY_DATE',    	width: 80, hidden: true},
        			{ dataIndex: 'LAST_DELIVERY_CUSTOM',  	width: 80, hidden: true},
        			{ dataIndex: 'BUY_RATE',  			  	width: 80, hidden: true},
        			{ dataIndex: 'LOCATION',  			  	width: 80, hidden: true},
					{ dataIndex: 'MATRL_PRESENT_DAY',  	  	width: 80, hidden: true},
					{ dataIndex: 'PURCHASE_BASE_P',  	  	width: 80, hidden: true},
					{ dataIndex: 'CUSTOM_CODE',  		  	width: 80, hidden: true},
					{ dataIndex: 'CUSTOM_NAME',  		  	width: 80, hidden: true},
					{ dataIndex: 'REMARK1',  			  	width: 80, hidden: true},
					{ dataIndex: 'REMARK2',  			  	width: 80, hidden: true},
					{ dataIndex: 'REMARK3',  			  	width: 80, hidden: true},
					{ dataIndex: 'BF_SALE_BASIS_P',  		width: 80, hidden: true},
					{ dataIndex: 'MONEY_UNIT',		  		width: 80, hidden: true},
					{ dataIndex: 'SALE_DATE',		  		width: 80, hidden: true},
					{ dataIndex: 'RTN_REMAIN_Q',			width: 80, hidden: true}	//반품예정 2015.9.15추가
          ] ,
          selModel: 'rowmodel',		// 조회화면 selectionchange event 사용
          listeners: {          	
          	selectionchangerecord:function(selected)	{
          		if(masterGrid.isHidden()){
	          		directSubStore.load();
	         		directSubStore.loadStoreRecords(selected);
	          		detailForm.loadForm(selected);
	          		var record = selected;
					if(!record.phantom || isViewImage){
						UniAppManager.app.fnGetbookImage(detailForm.getValue('ITEM_CODE'));
					}else{
						var bookImage = detailForm.down('#bookImage');				
						bookImage.setSrc('');	
					}
					if(selected.phantom){
//						detailForm.down('#setBasisPBtn').setDisabled(true);
//						detailForm.getField('SALE_BASIS_P').setReadOnly(false);
					}else{
//						detailForm.down('#setBasisPBtn').setDisabled(false);
//						detailForm.getField('SALE_BASIS_P').setReadOnly(true);
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
          	onGridDblClick:function(grid, record, cellIndex, colName) {
          		if(!record.phantom) {
	      			switch(colName)	{
					case 'ITEM_CODE' :
							masterGrid.hide();
							break;		
					default:
							break;
	      			}
          		}
          	},
          	beforeedit  : function( editor, e, eOpts ) {
							
				if(e.field == 'DIV_CODE') return false;				
				if(!e.record.phantom && e.field == 'SALE_BASIS_P'){
					return false;
				}
			
			},
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
			hide:function()	{
				var record = masterGrid.getSelectedRecord();
				directSubStore.load();
         		directSubStore.loadStoreRecords(record);
          		detailForm.show();
          		detailForm.loadForm(record);
          		var record = record;
				if(record && !record.phantom || isViewImage){
					UniAppManager.app.fnGetbookImage(detailForm.getValue('ITEM_CODE'));
				}else{
					var bookImage = detailForm.down('#bookImage');				
					bookImage.setSrc('');	
				}
				if(record && record.phantom){
//					detailForm.down('#setBasisPBtn').setDisabled(true);
//					detailForm.getField('SALE_BASIS_P').setReadOnly(false);
				}else{
//					detailForm.down('#setBasisPBtn').setDisabled(false);
//					detailForm.getField('SALE_BASIS_P').setReadOnly(true);
				}
				
//				var record = masterGrid.getSelectedRecord();
//				if(!record.phantom || isViewImage){
//					UniAppManager.app.fnGetbookImage(detailForm.getValue('ITEM_CODE'));
//				}else{
//					var bookImage = detailForm.down('#bookImage');				
//					bookImage.setSrc('');	
//				}
//				var record = masterGrid.getSelectedRecord();
//				if(!Ext.isEmpty(record)){
//					var bookLink = detailForm.down('#bookLink');
//					if(!Ext.isEmpty(record.get('BOOK_LINK'))){						
//						bookLink.setValue('<a href="javascript:void(0);" onclick="javascript:'+UniNaverSearch.getLinkScript(record.get('BOOK_LINK'))+';"><u>책소개</u></a>')
//					}else{
//						bookLink.setValue('<a href="javascript:void(0);"><u>책소개</u></a>')
//					}
//				}				
				
			},
			show:function()	{
				
			}
          }
    });
	
    /*상세폼에  BPR400T그리드*/
    var subGrid = Unilite.createGrid('bpr102skrvsubGrid', {    	
    	//region:'center',
    	store : directSubStore,
    	sortableColumns : false,
//    	layout: 'fit',
    	height: 230,
    	width: 760,
    	margin: '0 0 0 118',
    	
    	//border:false,
    	uniOpt:{
			 expandLastColumn: false
			,useRowNumberer: false
			,useMultipleSorting: false
			,enterKeyCreateRow: false//마스터 그리드 추가기능 삭제
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
//					var toolbar = subGrid.getDockedItems('toolbar[dock="top"]');
//					var needSave = !toolbar[0].getComponent('sub_save').isDisabled();
					var record = masterGrid.getSelectedRecord();
//					if(needSave) {
//						Ext.Msg.show({
//						     title:'확인',
//						     msg: Msg.sMB017 + "\n" + Msg.sMB061,
//						     buttons: Ext.Msg.YESNOCANCEL,
//						     icon: Ext.Msg.QUESTION,
//						     fn: function(res) {
//						     	//console.log(res);
//						     	if (res === 'yes' ) {
//						     		var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
//				                  		directSubStore.saveStore();
//				                    });
//				                    saveTask.delay(500);
//						     	} else if(res === 'no') {
//						     		directSubStore.loadStoreRecords(record);
//						     	}
//						     }
//						});
//					} else {
						directSubStore.loadStoreRecords(record);
//					}
				}
			}/*,{
                xtype: 'uniBaseButton',
				text : '신규',
				tooltip : '초기화',
				iconCls: 'icon-reset',
				width: 26, height: 26,
		 		itemId : 'sub_reset',
				handler : function() { 
//					var toolbar = subGrid.getDockedItems('toolbar[dock="top"]');
//					var needSave = !toolbar[0].getComponent('sub_save').isDisabled();
//					if(needSave) {
//						Ext.Msg.show({
//						     title:'확인',
//						     msg: Msg.sMB017 + "\n" + Msg.sMB061,
//						     buttons: Ext.Msg.YESNOCANCEL,
//						     icon: Ext.Msg.QUESTION,
//						     fn: function(res) {
//						     	console.log(res);
//						     	if (res === 'yes' ) {
//						     		var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
//					                  	directSubStore.saveStore();
//					                });
//					                saveTask.delay(500);
//						     	} else if(res === 'no') {
//						     		subGrid.reset();
//						     		directSubStore.clearData();
//						     		directSubStore.setToolbarButtons('sub_save', false);
//						     		directSubStore.setToolbarButtons('sub_delete', false);
//						     		detailForm.getField('SALE_COMMON_P').setReadOnly(false);//시중가 readOnly: false
//						     	}
//						     }
//						});
//					} else {
						subGrid.reset();
						directSubStore.clearData();
						directSubStore.setToolbarButtons('sub_save', false);
						directSubStore.setToolbarButtons('sub_delete', false);
//						detailForm.getField('SALE_COMMON_P').setReadOnly(false);//시중가 readOnly: false
//					}					
				}
			}*//*,{
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
					}
					if(record.phantom){
						Unilite.messageBox("품목을 먼저 등록해야 합니다.");
						return false;
					}
					else{
						if(Ext.isEmpty(record.get('SALE_COMMON_P')) || record.get('SALE_COMMON_P') == 0){
							Unilite.messageBox('시중가를 입력해 주세요');
							detailForm.getField('SALE_COMMON_P').focus();
							return false;
						}
					}
//					detailForm.getField('SALE_COMMON_P').setReadOnly(true);//시중가 readOnly: true
					var compCode = UserInfo.compCode;  
					var type = '1';
					var divCode = record.get('DIV_CODE');
					var itemCode = record.get('ITEM_CODE');
					var moneyUnit = UserInfo.currency;
//					var orderUnit = record.get('ORDER_UNIT');
					var orderUnit = 'EA';
					var purchageRate = '100';	
					var orderRate 	= '100';	
					var useYn = 'Y'
					var aplyStartDate = UniDate.get('today');
					var aplyEndDate = '29991231';
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
					subGrid.createRow(r,'ITEM_CODE');
				}
			},{
                xtype: 'uniBaseButton',
				text : '삭제',
				tooltip : '삭제',
				iconCls: 'icon-delete',disabled: true,
				width: 26, height: 26,
		 		itemId : 'sub_delete',
				handler : function() { 
					var selRow = subGrid.getSelectedRecord();
					if(selRow.phantom === true)	{
						subGrid.deleteSelectedRow();
					}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						subGrid.setEndDate();
						subGrid.deleteSelectedRow();						
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
                  var inValidRecs = directSubStore.getInvalidRecords();       	
					if(inValidRecs.length == 0 )	{
						var saveTask =  Ext.create('Ext.util.DelayedTask', function(){
	                  	if(subGrid.setAplyDate()){
	                  		directSubStore.saveStore();
	                  	}                  	
	                  });
	                  saveTask.delay(500);
					}else {
						subGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
					}
                }
			}*/]
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
			                    	var grdRecord = subGrid.uniOpt.currentRecord;
    								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
    								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
			                    },
			                    scope: this
	                  	   },
			                  'onClear' : function(type)	{
			                  		//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
			                  		var grdRecord = subGrid.uniOpt.currentRecord;
    								grdRecord.set('CUSTOM_CODE','');
    								grdRecord.set('CUSTOM_NAME','');
			                  }
							}
						})
        			 }
			  		,{ dataIndex: 'CUSTOM_NAME'	 		,  		width: 188,
			  			editor: Unilite.popup('CUST_G',{
			  				autoPopup: true,
			  				listeners:{ 'onSelected': {
			                    fn: function(records, type  ){
			                    	//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
			                    	var grdRecord = subGrid.uniOpt.currentRecord;
    								grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
    								grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
			                    },
			                    scope: this
	                  	   	},
			                  'onClear' : function(type)	{
			                  		//var grdRecord = Ext.getCmp('sof100ukrvGrid').uniOpt.currentRecord;
			                  		var grdRecord = subGrid.uniOpt.currentRecord;
    								grdRecord.set('CUSTOM_CODE','');
    								grdRecord.set('CUSTOM_NAME','');
			                  }
							}
						})
			  		}
			  		,{ dataIndex: 'TYPE'	 			,  		width: 90, hidden: true }
			  		,{ dataIndex: 'PURCHASE_TYPE'	 	,  		width: 60 }
			  		,{ dataIndex: 'SALES_TYPE'		 	,  		width: 60 }
			  		,{ dataIndex: 'APLY_START_DATE'		,  		width: 90}
			  		,{ dataIndex: 'APLY_END_DATE'		,  		width: 90}
			  		,{ dataIndex: 'PURCHASE_RATE'		,  		width: 70 }
			  		,{ dataIndex: 'ITEM_P'				,  		width: 108 }
			  		,{ dataIndex: 'ORDER_RATE'			,  		width: 106, hidden: true }
			  		,{ dataIndex: 'USE_YN'				,  		width: 106, hidden: true }
					,{ dataIndex: 'BASIS_P'				,  		width: 108, hidden: true}			  		
			  		,{ dataIndex: 'COMP_CODE'	 		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'DIV_CODE'	 		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'ITEM_CODE'	 		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'MONEY_UNIT'	 		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'ORDER_UNIT'	 		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'UPDATE_DB_USER'		,  		width: 60, hidden: true}
			  		,{ dataIndex: 'UPDATE_DB_TIME'		,  		width: 60, hidden: true}
          ] ,
          listeners: {          	
			beforeedit  : function( editor, e, eOpts ) {
				return false;
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
        	var deleteRecord = subGrid.getSelectedRecord();				//삭제될 레코드
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
    var stockSearchForm = Unilite.createSearchForm('bpr101ukrvstockSearchForm', {        
            layout :  {type : 'uniTable', columns : 1},
            items :[{
				name: 'DIV_CODE',
				fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>',
				xtype:'uniCombobox',
				comboType:'BOR120'
			}]
    });
    //창고별재고 조회 모델
	Unilite.defineModel('bpr102skrvstockSearchModel', {
	    fields: [{name: 'COMP_CODE'			    	,text: 'COMP_CODE'				, type: 'string'},
	    		 {name: 'WH_CODE'			    	,text: '창고코드'					, type: 'string'},
	    		 {name: 'WH_NAME'			    	,text: '창고명'					, type: 'string'},
	    		 {name: 'CUSTOM_CODE'			    ,text: '매입처코드'					, type: 'string'},
	    		 {name: 'CUSTOM_NAME'			    ,text: '매입처명'					, type: 'string'},
	    		 {name: 'PURCHASE_P'			    ,text: '매입가'					, type: 'uniUnitPrice'},
	    		 {name: 'STOCK_Q'			    	,text: '현재고'					, type: 'uniQty'}				 				 
		]
	});
	//창고별재고 조회 스토어
    var stockSearchStore = Unilite.createStore('bpr102skrvstockSearchStore', {
			model: 'bpr102skrvstockSearchModel',
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
                	read    : 'bpr102skrvService.selectStockList'
                }
            }
            ,loadStoreRecords : function()	{
				var param= {
					ITEM_CODE: detailForm.getValue('ITEM_CODE'), 
					DIV_CODE: stockSearchForm.getValue('DIV_CODE')
				}			
				console.log( param );
				this.load({
					params : param
				});
			}
	});
	//창고별재고 조회 그리드 
    var stockSearchGrid = Unilite.createGrid('bpr102skrvstockSearchGrid', {
        // title: '기본',
        layout : 'fit',
    	store: stockSearchStore,
        columns:  [{ dataIndex: 'COMP_CODE'			    	,	  width: 100, hidden: true },
        		   { dataIndex: 'WH_CODE'			    	,	  width: 100, hidden: true},   		   
          		   { dataIndex: 'WH_NAME'			    	,	  width: 100}, 
          		   { dataIndex: 'CUSTOM_CODE'			    ,	  width: 100, hidden: true },
          		   { dataIndex: 'CUSTOM_NAME'			    ,	  width: 170}, 
          		   { dataIndex: 'PURCHASE_P'			   	,	  width: 100}, 
          		   { dataIndex: 'STOCK_Q'			    	,	  width: 100} 
          		   
          ]         
    });
    
    //창고별재고 조회 메인
    function openStockSearchWindow() { 
		if(!stockSearchWindow) {
			stockSearchWindow = Ext.create('widget.uniDetailWindow', {
                title: '창고별재고조회',
                width: 510,				                
                height: 360,
                layout:{type:'vbox', align:'stretch'},                
                items: [stockSearchForm, stockSearchGrid],
                tbar:  ['->',
			        {	itemId : 'saveBtn',
						text: '조회',
						handler: function() {
							stockSearchStore.loadStoreRecords();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '닫기',
						handler: function() {
							stockSearchWindow.hide();
						},
						disabled: false
					}
			    ],
                listeners : {beforehide: function(me, eOpt)	{                							
                							stockSearchGrid.reset();
    						},
                			 beforeclose: function( panel, eOpts )	{											
                							stockSearchGrid.reset();
    			 			},
                			 show: function( panel, eOpts )	{
                			 	stockSearchForm.setValue('DIV_CODE', '');
                			 	stockSearchStore.loadStoreRecords();
                			 	stockSearchWindow.getEl().setXY([getWindowX,getWindowY]);
                			 }
                }
			})
		}
		stockSearchWindow.center();
		stockSearchWindow.show();
    }
    /**
     * 상세 Form
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
	    layout: {type: 'uniTable', columns: 5, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
	    defaultType: 'uniFieldset',
	    defaults : { margin: '0 0 0 0', readOnly: true},
	    items : [{
	    		xtype: 'container',
	    		colspan: 5,
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
		    					var record = masterGrid.getSelectedRecord();
		    					var param = {ITEM_CODE: field.getValue(), DIV_CODE: panelSearch.getValue('DIV_CODE')}
					        	bpr101ukrvService.checkItemDuplicate(param, function(provider1, response)	{							
									if(provider1[0].CNT > 0 && record.phantom){
										Unilite.messageBox('기등록품목입니다.');
										record.set('ITEM_CODE', '');
									}else if(record.phantom && !Ext.isEmpty(record.get('ITEM_CODE'))){
										isViewImage = false
										UniAppManager.app.fnSearchBookInfo(field.getValue());	
									}
					        	});		    							    						
		    				}
		    			}
		    		}, {
		    			fieldLabel: '도서명',
		    			labelWidth: 141,
		    			name: 'ITEM_NAME',		    			
		    			width: 612,
		    			allowBlank: false, 
		    			readOnly: true,
		    			listeners:{ 
		    				change : function(combo, newValue, oldValue, eOpts){
//		    					detailForm.setValue('ITEM_NAME1', newValue);
//		    					detailForm.setValue('ITEM_NAME2', newValue);
		    				}
		    			}
		    		}, {
    					text: '창고별재고조회',
    					xtype: 'button',
    					margin: '0 0 0 195',
    					handler: function(){
    						getWindowX = this.getX()-390;
					   		getWindowY = this.getY()+22;
    						openStockSearchWindow();
    					}
    				}]
	    		}, {
	    			xtype: 'container',
	    			layout: { type: 'uniTable', columns: 3},
	    			defaultType: 'uniTextfield',
	    			items:[{
					    xtype: 'radiogroup',
					    fieldLabel: '국내외구분',	
					    items : [{
					    	boxLabel: '국내',
					    	name: 'DOM_FORIGN' ,
					    	inputValue: '1',
					    	width:85, 
		    				readOnly: true
					    }, {boxLabel: '해외',
					    	name: 'DOM_FORIGN',
					    	inputValue: '2',
					    	width:85, 
		    				readOnly: true
					    }]				
					}, {
		    			fieldLabel: '약명1',
		    			name: 'ITEM_NAME1',
		    			labelWidth: 113, 
		    			readOnly: true
		    		}, {
		    			fieldLabel: '약명2',
		    			name: 'ITEM_NAME2',
		    			labelWidth: 161, 
		    			readOnly: true
		    		}]
	    		}]
	    },
	    	
	    		{ 
        			  title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>'
        			, defaults: {type: 'uniTextfield', readOnly: true}
        			, layout: { type: 'uniTable', columns: 1}
        			, height: 350
        			, items :[	 { name: 'ITEM_LEVEL1',  			fieldLabel: '<t:message code="system.label.base.majorgroup" default="대분류"/>' 		,xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('bpr102skrvLevel1Store'), child: 'ITEM_LEVEL2'}   
						  		,{ name: 'ITEM_LEVEL2',  			fieldLabel: '<t:message code="system.label.base.middlegroup" default="중분류"/>' 		,xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('bpr102skrvLevel2Store'), child: 'ITEM_LEVEL3'}    
						  		,{ name: 'ITEM_LEVEL3',  			fieldLabel: '<t:message code="system.label.base.minorgroup" default="소분류"/>' 		,xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('bpr102skrvLevel3Store'), parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],levelType:'ITEM'}
						  		,{ name: 'SPEC',  					fieldLabel: '<t:message code="system.label.base.spec" default="규격"/>' 		,maxLength: 160} 
						  		,{ name: 'STOCK_UNIT',  			fieldLabel: '<t:message code="system.label.base.inventoryunit" default="재고단위"/>',	 xtype:'uniCombobox',	comboType:'AU', comboCode:'B013' , allowBlank:false, fieldStyle: 'text-align: center;', displayField: 'value'}     
						  		, Unilite.popup('ITEM_GROUP',  	   {fieldLabel: '<t:message code="system.label.base.repmodel" default="대표모델"/>', textFieldName:'ITEM_GROUP_NAME', valueFieldName:'ITEM_GROUP', valueFieldWidth:120, textFieldWidth:150, verticalMode:true,
						  			listeners: {
										onSelected: {
											fn: function(records, type) {
												var grdRecord = masterGrid.getSelectedRecord();
												grdRecord.set('ITEM_GROUP', records[0]['ITEM_CODE']);
												grdRecord.set('ITEM_GROUP_NAME', records[0]['ITEM_NAME']);
					                    	},
											scope: this
										},
										onClear: function(type)	{
											var grdRecord = masterGrid.getSelectedRecord();
											grdRecord.set('ITEM_GROUP', '');
											grdRecord.set('ITEM_GROUP_NAME', '');
										}
									}
						  		})
//						  		,{ name: 'STOCK_CARE_YN',  			fieldLabel: '<t:message code="system.label.base.inventorymanageobject" default="재고관리대상"/>', xtype:'uniRadiogroup', comboType:'AU', comboCode:'B010', width:235, allowBlank:false} 
						  		,{
								    xtype: 'radiogroup',
								    fieldLabel: '<t:message code="system.label.base.inventorymanageobject" default="재고관리대상"/>',	
								    items : [{
								    	boxLabel: '예',
								    	name: 'STOCK_CARE_YN' ,
								    	inputValue: 'Y',
								    	width:85,
	    								readOnly: true	
								    }, {boxLabel: '아니오',
								    	name: 'STOCK_CARE_YN',
								    	inputValue: 'N',
								    	width:85,
	    								readOnly: true
								    }]				
								}
						  		,{ name: 'START_DATE',  			fieldLabel: '<t:message code="system.label.base.usestartdate" default="사용시작일"/>', 	xtype : 'uniDatefield', maxLength: 10}    
						  		,{ name: 'STOP_DATE',  				fieldLabel: '<t:message code="system.label.base.usestopdate" default="사용중단일"/>', 	xtype : 'uniDatefield', maxLength: 10}    
//						  		,{ name: 'USE_YN',  				fieldLabel: '<t:message code="system.label.base.useyn" default="사용여부"/>', 	xtype:'uniRadiogroup', comboType:'AU', comboCode:'B010', width:235, allowBlank:false}
						  		,{
								    xtype: 'radiogroup',
								    fieldLabel: '<t:message code="system.label.base.useyn" default="사용여부"/>',	
								    items : [{
								    	boxLabel: '예',
								    	name: 'USE_YN' ,
								    	inputValue: 'Y',
								    	width:85,
	    								readOnly: true
								    }, {boxLabel: '아니오',
								    	name: 'USE_YN',
								    	inputValue: 'N',
								    	width:85,
	    								readOnly: true
								    }]
								}					  		
					         ]
	    		}
	    	   ,{   title: '제원정보'
        			, layout: {
					            type: 'uniTable',
					            columns: 2
					        }
        			, defaults: {type: 'uniTextfield', colspan: 2, readOnly: true}
        			, height: 350
        			, width: 300
        			, items :[	 { name: 'TAX_TYPE',  				fieldLabel: '<t:message code="system.label.base.taxtype" default="세구분"/>', 	xtype:'uniCombobox', comboType:'AU', comboCode:'B059' , allowBlank:false}         
						  		,{ name: 'SALE_BASIS_P',  	 		fieldLabel: '<t:message code="system.label.base.sellingprice" default="판매단가"/>', 	xtype : 'uniNumberfield', maxLength: 18, readOnly: true, allowBlank:false}
						  		/*,{						           
						           margin: '0 0 0 5',
						           xtype: 'button',
								   text: '변경',
								   itemId:'setBasisPBtn',
								   handler : function() {
								   	var record = masterGrid.getSelectedRecord();
										if(record.phantom){
											Unilite.messageBox("품목을 먼저 등록해야 합니다.");
											return false;
										}
								   	   getWindowX = this.getX();
								   	   getWindowY = this.getY()+22;
									   openGetItemPWindow();									  								       
					               }
						         }*/
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
							    ,{ name: 'SALE_COMMON_P',  	 		fieldLabel: '시중가', allowBlank: true,	xtype : 'uniNumberfield', maxLength: 18}
//							    ,{ name: 'AUTO_DISCOUNT',  	 		fieldLabel: '자동할인', 	xtype : 'uniRadiogroup', comboType:'AU', comboCode:'B010', width:235, allowBlank:false}
							     ,{
								    xtype: 'radiogroup',
								    fieldLabel: '자동할인',			    
//								    colspan: 2,
								    items : [{
								    	boxLabel: '예',
								    	name: 'AUTO_DISCOUNT' ,
								    	inputValue: 'Y',
								    	width:85,
	    								readOnly: true
								    }, {boxLabel: '아니오',
								    	name: 'AUTO_DISCOUNT',
								    	inputValue: 'N',
								    	width:85,
								    	checked: true,
	    								readOnly: true
								    }]				
								} ,{
								    xtype: 'radiogroup',
								    fieldLabel: '회원할인대상',			    
//								    colspan: 2,
								    items : [{
								    	boxLabel: '예',
								    	name: 'MEMBER_DISCOUNT_YN' ,
								    	inputValue: 'Y',
								    	width:85,
	    								readOnly: true
								    }, {boxLabel: '아니오',
								    	name: 'MEMBER_DISCOUNT_YN',
								    	inputValue: 'N',
								    	width:85,
								    	checked: true,
	    								readOnly: true
								    }]				
								}
//							    ,{ name: 'SPEC_CONTROL',  	 		fieldLabel: '특정', 		xtype : 'uniRadiogroup', comboType:'AU', comboCode:'B010', width:235, allowBlank:false}
							    ,{
								    xtype: 'radiogroup',
								    fieldLabel: '특정',	
								    items : [{
								    	boxLabel: '예',
								    	name: 'SPEC_CONTROL' ,
								    	inputValue: 'Y',
								    	width:85,
	    								readOnly: true
								    }, {boxLabel: '아니오',
								    	name: 'SPEC_CONTROL',
								    	inputValue: 'N',
								    	width:85,
	    								readOnly: true
								    }]				
								}
							    ,{ name: 'SPEC_CONTROL_CODE',  		fieldLabel: '특정코드',	xtype:'uniCombobox',	comboType:'AU', comboCode:'YP05'}
								,{ name: 'SALE_UNIT',  				fieldLabel: '<t:message code="system.label.base.salesunit" default="판매단위"/>',	xtype:'uniCombobox',	comboType:'AU', comboCode:'B013' , displayField: 'value', allowBlank:false}							    
							    ,{ name: 'TRNS_RATE',  				fieldLabel: '<t:message code="system.label.base.salespackednumber" default="판매입수"/>',	xtype:'uniNumberfield'}
							    ,{ name: 'EXCESS_RATE',  			fieldLabel: '<t:message code="system.label.base.overissuerate" default="과출고허용율"/>',	xtype : 'uniNumberfield',  decimalPrecision:'2'}
							]
	    		}
	    		,{  title: '도서정보'
	    			, layout: {
					            type: 'uniTable',
					            columns: 2
					        }
        			, defaults: {type: 'uniTextfield', colspan: 2, labelWidth: 85, readOnly: true}
        			, height: 350
        			,items :[ { name: 'ISBN_CODE',  				fieldLabel: 'ISBN', 		 xtype:'uniTextfield', comboType:'AU', comboCode:'', colspan: 1, width: 160}
        					 , {
		    					text: '책소개',
		    					xtype: 'button',		    					
		    					handler: function(){
		    						var record = masterGrid.getSelectedRecord();
		    						if(!record.phantom){
		    							UniAppManager.app.fnGetbookLink(detailForm.getValue('ITEM_CODE'));
		    						}
		    						if(record.phantom && !Ext.isEmpty(detailForm.getValue('ITEM_CODE'))){
		    							UniAppManager.app.fnGetbookLink(detailForm.getValue('ITEM_CODE'));
		    						}		    						
	    						}
		    				}        				
        					 ,Unilite.popup('AGENT_CUST_SINGLE2',  	   {fieldLabel: '출판사', valueFieldWidth:120, textFieldWidth:150, verticalMode:true, valueFieldName:'PUBLISHER_CODE', textFieldName:'PUBLISHER',			    
	        					   	textFieldName:'PUBLISHER_CODE',
									DBtextFieldName: 'CUSTOM_CODE',
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
        					 ,{ name: 'PUBLISHER', 					fieldLabel: '출판사명', 		 xtype:'uniTextfield'}  
        					 ,{ name: 'AUTHOR1',  					fieldLabel: '저자1', 			 xtype:'uniTextfield'}
        					 ,{ name: 'AUTHOR2',  					fieldLabel: '저자2',			 xtype:'uniTextfield'}
        					 ,{ name: 'TRANSRATOR',  	 			fieldLabel: '역자',		 	 xtype:'uniTextfield'}
        					 ,{ name: 'PUB_DATE',  					fieldLabel: '초판발행일', 		 xtype:'uniDatefield'}
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
										popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
										popup.setExtParam({'BINTYPE': 'DOC'});	//도서
									}
								}
							})
        					 ,{fieldLabel: '선반번호', name: 'BIN_FLOOR', xtype:'uniCombobox', maxLength :4, comboType:'AU', comboCode:'YP16'}
//        					 ,{ name: 'PROD_TYPE',  	 			fieldLabel: '교재여부', 		xtype : 'uniRadiogroup', comboType:'AU', comboCode:'B010', width:235, allowBlank:false}
        					 ,{
								    xtype: 'radiogroup',
								    fieldLabel: '교재여부',	
								    items : [{
								    	boxLabel: '예',
								    	name: 'PROD_TYPE' ,
								    	inputValue: 'Y',
								    	width:85,
	    								readOnly: true
								    }, {boxLabel: '아니오',
								    	name: 'PROD_TYPE',
								    	inputValue: 'N',
								    	width:85,
	    								readOnly: true
								    }]				
								}
        					 ,{						           
					           margin: '0 0 0 158',
					           width: 75,
					           xtype: 'button',
							   text: '+상세보기',								   	
							   handler : function() {							   	   
							   	   if(masterGrid.getSelectedRecord().phantom){
							   	   		return false;
							   	   }
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
        			, defaults: {type: 'uniTextfield', readOnly: true}
        			, height: 350
        			,items :[ { name: 'PROPER_STOCK_Q',  			fieldLabel: '적정재고',		 xtype:'uniNumberfield', readOnly: true}
        					 ,{ name: 'STOCK_Q',  					fieldLabel: '현재고', 		 xtype:'uniNumberfield', readOnly: true}
        					 ,{ name: 'RTN_REMAIN_Q',  				fieldLabel: '반품예정',		 xtype:'uniNumberfield', readOnly: true}
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
	    		},{xtype: 'image',  src: '', itemId: 'bookImage', width:100, height: 130, margin: '9 0 0 0'},{ 
	    			height: 335,
	    			width: 1162,
	    			colspan: 5,
	    			layout: {type: 'uniTable', columns: 2},
	    			items :[{
        				xtype: 'container',
        				layout: {type: 'uniTable', columns: 1},
        				defaults: {readOnly: true},
        				items: [{ name: 'DIV_CODE',  				fieldLabel: '적용사업장', 		 xtype:'uniCombobox', comboType:'BOR120', value:UserInfo.divCode, readOnly: true,allowBlank:false, margin: '8 0 0 0'/*, multiSelect: true, typeAhead: false*/}	 
        					   ,{ name: 'ITEM_ACCOUNT',  			fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>', 		 xtype:'uniCombobox', comboType:'AU', comboCode:'B020', allowBlank:false}
        					   ,{ name: 'SUPPLY_TYPE',  			fieldLabel: '<t:message code="system.label.base.procurementclassification" default="조달구분"/>', 		 xtype:'uniCombobox', comboType:'AU', comboCode:'B014', allowBlank:false}
        					   ,{ name: 'ORDER_UNIT',  				fieldLabel: '<t:message code="system.label.base.purchaseunit" default="구매단위"/>',		 xtype:'uniCombobox', comboType:'AU', comboCode:'B013', displayField: 'value', allowBlank:false}
        					   ,{ name: 'BUY_RATE',  		    	fieldLabel: '<t:message code="system.label.base.purchasereceiptcount" default="구매입수"/>',		 xtype:'uniNumberfield'}
        					   ,{ name: 'WH_CODE',  				fieldLabel: '<t:message code="system.label.base.mainwarehouse" default="주창고"/>', 		 xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('whList')}
        					   ,{ name: 'LOCATION',  				fieldLabel: 'Location', 	 xtype:'uniTextfield'}
        					   ,{ name: 'ORDER_PLAN',  				fieldLabel: '<t:message code="system.label.base.popolicy" default="발주방침"/>',		 xtype:'uniCombobox', comboType:'AU', comboCode:'B061', allowBlank:true}
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
        				padding: '0 0 0 26',
        				xtype: 'container',
        				layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
        				items: [ {
	        				xtype: 'container',
	        				layout: {type: 'uniTable', columns: 1},
	        				defaults: {readOnly: true},
	        				items: [ { name: 'REMARK1',  			fieldLabel: '비고사항1'  ,width:879, labelWidth: 113, xtype:'uniTextfield'	}       
							  		,{ name: 'REMARK2',  			fieldLabel: '비고사항2'  ,width:879, labelWidth: 113, xtype:'uniTextfield'} 
							  		,{ name: 'REMARK3',  			fieldLabel: '비고사항3'  ,width:879, labelWidth: 113, xtype:'uniTextfield'}
							]
        				}, 
        				subGrid/*,
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
				hide:function()	{
					subGrid.reset(); 
					var bookImage = detailForm.down('#bookImage');				
//					bookImage.setSrc('');		//이미지 초기화
					masterGrid.show();
					if(panelSearch.getCollapsed()){		//panelSearch가 닫혀 있으면..
						panelResult.show();
					}
				},
				show: function ( me, eOpts )	{					
//					directSubStore.loadStoreRecords();					
    			}
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
           fieldLabel: '이전단가',
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
           colspan: 2,
           readOnly: true
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
							text: '변경',
							margin: '0 5 0 0',
							handler: function() {
								if(getItemPSearch.getValue('SALE_BASIS_P') == getItemPSearch.getValue('BF_SALE_BASIS_P')){
									Unilite.messageBox('이전단가와 변경단가가 같습니다.');
									return false;
								}
								var record = masterGrid.getSelectedRecord();
								var param = {
									COMP_CODE : UserInfo.compCode,
									TYPE : '2',
									DIV_CODE : '*',
									ITEM_CODE : record.get('ITEM_CODE'),
									CUSTOM_CODE : '000000',
									MONEY_UNIT : UserInfo.currency,
									ORDER_UNIT : record.get('ORDER_UNIT'),
									APLY_START_DATE : UniDate.getDbDateStr(getItemPSearch.getValue('SALE_DATE')),
									APLY_END_DATE : "29991231",
									USE_YN : "Y",
									ITEM_P : getItemPSearch.getValue('SALE_BASIS_P'),
									BF_ITEM_P : getItemPSearch.getValue('BF_SALE_BASIS_P')
//									BASIS_P : ,
//									SALES_TYPE : ,						
									//BASIS_P 뭘로 들어가야 하는지? 1일땐 200T PURCHAGE_P? 2일땐 100t SALE_BASIS_P라는데..
									//SALES_TYPE 넣어야 하는지?
								}								
								bpr101ukrvService.updateSaleBasisP(param, function(provider, response)	{
									if(!Ext.isEmpty(provider)){										
										if(Ext.isEmpty(getItemPSearch.getValue('SALE_BASIS_P'))){
											record.set('SALE_BASIS_P', 0);
										}else{
											record.set('SALE_BASIS_P', getItemPSearch.getValue('SALE_BASIS_P'));
										}								
										record.set('BF_SALE_BASIS_P', getItemPSearch.getValue('BF_SALE_BASIS_P'));
	//									record.set('SALE_DATE', getItemPSearch.getValue('SALE_DATE'));
										getItemPWindow.hide();
										var param = {KEY_VALUE: provider}
										bpr102skrvService.goInterFace(param, function(provider, response)	{
										});
										UniAppManager.updateStatus(Msg.sMB011);	
									}
								});	
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
                			 	getItemPSearch.setValue('BF_SALE_BASIS_P',detailForm.getValue('SALE_BASIS_P'));
                			 	getItemPSearch.setValue('SALE_BASIS_P', 0);
								getItemPSearch.setValue('SALE_DATE', Ext.isEmpty(detailForm.getValue('SALE_DATE')) ? UniDate.get('today') : detailForm.getValue('SALE_DATE'));
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
                title: '교재여부',
                resizable:false,
                width: 400,				                
                height:180,
                layout: {type:'uniTable', columns: 1},	                
                items: [getBookInfoSearch],
                bbar:  [ '->',
				        {	itemId : 'searchBtn',
							text: '확인',
							margin: '0 5 0 0',
							handler: function() {
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
											getBookInfoSearch.clearForm();                							
                						},
                			 beforeclose: function( panel, eOpts )	{
											getBookInfoSearch.clearForm();
                			 			},
                			 show: function( panel, eOpts )	{                			 	
                			 	var param = {ITEM_CODE: detailForm.getValue('ITEM_CODE')}
                			 	bpr102skrvService.setBookInfo(param, function(provider1, response)	{							
									if(!Ext.isEmpty(provider1[0])){
										getBookInfoSearch.setValue('TXT_YYYY', provider1[0].TXT_YYYY);
										getBookInfoSearch.setValue('TXT_SEQ', provider1[0].TXT_SEQ);
										getBookInfoSearch.setValue('MAJOR_NAME', provider1[0].MAJOR_NAME);
										getBookInfoSearch.setValue('SUBJECT_NAME', provider1[0].SUBJECT_NAME);
										getBookInfoSearch.setValue('PROFESSOR_NAME', provider1[0].PROFESSOR_NAME);										
									}
								});
								getBookInfoWindow.getEl().setXY([getWindowX,getWindowY]);
                			 }
                }		
			})
		}
		getBookInfoWindow.show();
    }
    var getBookInfoSearch = Unilite.createSearchForm('getBookInfoSearchForm', {
		padding: '0 0 0 0',
		disabled :false,
		width: 5000,
		height: 3000,		
		layout: {type: 'uniTable', columns :1},
	    trackResetOnLoad: true,
	    defaults: {xtype: 'uniTextfield', readOnly: true, width: 350},
	    items: [{
        	xtype: 'container',
			defaultType: 'uniTextfield',
			layout: {type: 'uniTable'},	
			defaults: {enforceMaxLength: true, readOnly: true},
			items: [{
				fieldLabel: '학년/학기',
				name: 'TXT_YYYY',
				width: 220,
				maxLength :10
			}, {
				hideLabel: true,
				name: 'TXT_SEQ',	//쿼리에 추가할 차례
				width: 130, 
				maxLength :2
			}] 
          },{ 
      		name: 'MAJOR_NAME',
      		fieldLabel: '학과'
      	},{ 
      		name: 'SUBJECT_NAME',
      		fieldLabel: '과목'
      	},{
      		name: 'PROFESSOR_NAME',
      		fieldLabel: '담당교수'
      	}]
    }); // createSearchForm
        
     Unilite.Main({
      	id  : 'bpr102skrvApp',
		borderItems : [
			panelSearch,
			panelResult,
			{	region:'center',
				//layout : 'border',
				title:'도서정보',
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
		fnInitBinding : function(params) {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
//			this.processParams(params);
		    /**
			* 기본값 셋업 
			*/
//			if(params && params.ITEM_CODE ) {
//				panelSearch.setValue('ITEM_CODE',params.ITEM_CODE);
//				masterGrid.getStore().loadStoreRecords();
//			}			
//			UniAppManager.setToolbarButtons(['reset','newData','detail'],true);
//			UniAppManager.setToolbarButtons('save', false);	
	    },
	    onQueryButtonDown: function () {
	    	if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
	    	if(
	    		Ext.isEmpty(panelSearch.getValue('ITEM_CODE')) &&
	    		Ext.isEmpty(panelSearch.getValue('ITEM_NAME')) &&
	    		Ext.isEmpty(panelSearch.getValue('ITEM_LEVEL1')) &&
	    		Ext.isEmpty(panelSearch.getValue('ITEM_LEVEL2')) &&
	    		Ext.isEmpty(panelSearch.getValue('ITEM_LEVEL3')) &&
	    		Ext.isEmpty(panelSearch.getValue('TXT_SEARCH')) &&
	    		Ext.isEmpty(panelSearch.getValue('ITEM_GROUP'))
	    	)
		    	{
		    		Unilite.messageBox('품목명을 1자이상 입력해 주세요.');
		    		return false;
		    	}
	    	detailForm.clearForm();
			detailForm.resetDirtyStatus();
			subGrid.reset();
			if(masterGrid.isHidden()){
				detailForm.getEl().mask('로딩중...','loading-indicator');		
			}
			masterGrid.getStore().loadStoreRecords();
			
		}/*,
		onNewDataButtonDown : function(additemCode)	{        	 
        	 var moneyUnit = UserInfo.currency;
        	 var toDay = UniDate.get('today');
        	 var itemCode = '';        	 
        	 if(!Ext.isEmpty(additemCode)){
        	 	itemCode = additemCode
        	 }
        	 var r = {
				MONEY_UNIT: moneyUnit,
				SALE_DATE: toDay,
				START_DATE: toDay,
				SUPPLY_TYPE: '1',
				DIV_CODE: panelSearch.getValue('DIV_CODE'),
				ITEM_CODE: itemCode,
				
				STOCK_UNIT: 'EA',
				TAX_TYPE: '2',
				SALE_UNIT: 'EA',
				TRNS_RATE: '1',
				ITEM_ACCOUNT: '00',
				ORDER_UNIT: 'EA',
				ORDER_PLAN: '1',
				BUY_RATE: '1'
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
		*//**
		 *  삭제
		 *	@param 
		 *	@return
		 *//*
		 onDeleteDataButtonDown: function() {
		 	var selRow = masterGrid.getSelectedRecord();
		 	if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
//				var record = masterGrid.getSelectedRecord();
//				if(!record.phantom || isViewImage){
//					UniAppManager.app.fnGetbookImage(detailForm.getValue('ITEM_CODE'));
//				}else{
//					var bookImage = detailForm.down('#bookImage');				
//					bookImage.setSrc('');	
//				}
//				detailForm.clearForm();		
			}
			var record = directMasterStore.data.items[0];
			if(Ext.isEmpty(record) && masterGrid.isHidden()){
				detailForm.hide();
				return false;
			}
		},
		*//**
		 *  저장
		 *	@param 
		 *	@return
		 *//*
		onSaveDataButtonDown: function (config) {
//			var rtnrecord = masterGrid.getSelectedRecord();
//			if(!Ext.isEmpty(rtnrecord)){
//				if(Ext.isEmpty(rtnrecord.get('SALE_DATE'))){
//					rtnrecord.set('SALE_DATE', UniDate.get('today'))
//				}
//			}
			if(!Ext.isEmpty(detailForm.getValue('ITEM_CODE')) && detailForm.getValue('ITEM_CODE').length != 13){
				Unilite.messageBox('도서코드 13자리를 입력해 주세요.');
				detailForm.getField('ITEM_CODE').focus();
				return false;
			}
			directMasterStore.saveStore(config);			
		}*/
		,onResetButtonDown:function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			detailForm.clearForm();
			
			subGrid.reset();
			directMasterStore.loadData({});
			detailForm.hide();
			this.fnInitBinding();
		},
		/*processParams: function(params) {
			this.uniOpt.appParams = params;			
			if(params && params.ITEM_CODE) {
				panelSearch.setValue('DIV_CODE', params.DIV_CODE);
				panelResult.setValue('DIV_CODE', params.DIV_CODE);
				
				var param = {ITEM_CODE: params.ITEM_CODE.trim(), DIV_CODE: params.DIV_CODE}
				bpr102skrvService.checkItemDuplicate(param, function(provider1, response)	{							
					if(provider1[0].CNT > 0){
						panelSearch.setValue('ITEM_CODE', params.ITEM_CODE);
						panelResult.setValue('ITEM_CODE', params.ITEM_CODE);
						processFlag = '1';	//load후 success처리 위해..
						directMasterStore.loadStoreRecords();						
					}else{
						UniAppManager.app.onNewDataButtonDown(params.ITEM_CODE.trim());
						var record = masterGrid.getSelectedRecord();
						detailForm.loadForm(record);
						subGrid.getStore().loadData({});
						masterGrid.hide();
						detailForm.getField('ITEM_CODE').focus();
					}
				});
//				if(params.action == 'new') {	//품목 신규 등록(입고등록,반품등록->미등록상품일때 호출)
//					var rec = masterGrid.createRow(
//						{
//							ITEM_CODE: params.ITEM_CODE
//						}
//					);
//					
//					masterGrid.hide();
//			        panelResult.hide();
//			        
//			        detailForm.loadForm(rec);
//			        detailForm.show();
//			        
//		   			UniAppManager.setToolbarButtons(['save'],true);		   			
//				} else {
//					panelSearch.setValue('ITEM_CODE',params.ITEM_CODE);
//					masterGrid.getStore().loadStoreRecords();
//				}
			}
		},
		onSaveAndQueryButtonDown : function()	{
			this.onSaveDataButtonDown();
			//this.onQueryButtonDown();
		},*/
		saveStoreEvent: function(str, newCard)	{
			var config = null;
			this.onSaveDataButtonDown(config);
		}, // end saveStoreEvent()
		
//		rejectSave: function()	{
//			var rowIndex = masterGrid.getSelectedRowIndex();			
//			directMasterStore.rejectChanges();
//			if(masterGrid.getStore().getCount() > 0)	{
//				masterGrid.select(rowIndex);
//			}
//			directMasterStore.onStoreActionEnable();
//		} // end rejectSave()
		/*rejectSave: function() {			
			directMasterStore.rejectChanges();	
			directMasterStore.onStoreActionEnable();
		},
		 confirmSaveData: function(config)	{
        	if(directMasterStore.isDirty() )	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
					detailForm.resetDirtyStatus();
					//if (detailWin.isVisible())	detailWin.hide();
				}
			}			
        },*/ 
        fnSearchBookInfo: function(isbn){		//도서코드 Blur시..
        	 params: {
        	 	var params = {
	        		query: isbn,
	        		d_isbn: isbn,	//ex) 9788950967062 9780495384724 9780451522900
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
		    		var bookImage = detailForm.down('#bookImage');
		    		if(result){
						UniAppManager.app.fnSetBookInfo(item);	//책정보 set
						bookImage.setSrc(item.image);
						isViewImage = true
					}else{
						bookImage.setSrc('');
					}					
//					var bookLink = detailForm.down('#bookLink');
//					bookLink.setMargin('0 0 0 0')
					
//					bookLink.setValue('<a href="javascript:void(0);" onclick="javascript:'+naver.getLinkScript(item.link)+';"><u>책소개</u></a>')
				});
        	 }      
        },
        fnGetbookImage: function(isbn){
        	 params: {
        	 	var params = {
	        		query: isbn,
	        		d_isbn: isbn,	//ex) 9788950967062 9780495384724 9780451522900
	        		//d_titl: '삼국지',
	        		//display: '10',
	        		display: '1'	//검색결과 출력건수
	        		//start: '1'
	        	};
				var bookImage = detailForm.down('#bookImage');
				UniNaverSearch.searchBookAdv(params, function(naver, item, result) {
					if(result && item){
						bookImage.setSrc(item.image);
					}else{
						bookImage.setSrc('');
					}
						
				});
				
        	 }      
        },
        fnGetbookLink: function(isbn){
        	 params: {
        	 	var params = {
	        		query: isbn,
	        		d_isbn: isbn,	//ex) 9788950967062 9780495384724 9780451522900
	        		//d_titl: '삼국지',
	        		//display: '10',
	        		display: '1'	//검색결과 출력건수
	        		//start: '1'
	        	};
				UniNaverSearch.searchBookAdv(params, function(naver, item, result) {
					if(item && Ext.isArray(item) && item.length >0){
						naver.openLink(item[0].link);
					}
				});
        	 }      
        }, fnSetBookInfo: function(item){
           var isbn = item.isbn.substring(0,10);
           var title = item.title.substring(0,100);
           var author = item.author.substring(0,100);           
           var rtnRecord = masterGrid.getSelectedRecord();
           rtnRecord.set('ISBN_CODE', isbn);
           rtnRecord.set('ITEM_NAME', title);
           rtnRecord.set('ITEM_NAME1', title);
           rtnRecord.set('PUBLISHER', item.publisher);
           rtnRecord.set('AUTHOR1', author);
           rtnRecord.set('PUB_DATE',  item.pubdate);
           rtnRecord.set('SALE_COMMON_P', item.price);
           rtnRecord.set('SALE_BASIS_P', item.price);
//           rtnRecord.set('BOOK_LINK', item.link);
        }
           
//         detailForm.setValue('ISBN_CODE',  		 isbn);			//isbn
//         detailForm.setValue('ITEM_NAME',  		 item.title);	//도서명
//	     detailForm.setValue('PUBLISHER',     	 item.publisher);	//출판사 정보
//	     detailForm.setValue('AUTHOR1',  		 item.author);		//저자
//	     detailForm.setValue('AUTHOR2',  		 item.author);
//  	     detailForm.setValue('TRANSRATOR',  	 item.description);	//역자
//	     detailForm.setValue('PUB_DATE',  		 item.pubdate); 	//출간일
//	     detailForm.setValue('SALE_COMMON_P',  	 item.price); 	    //정가
//	    ,
//        duplicateItemCheck: function(newValue)	{
//        	var record = masterGrid.getSelectedRecord();
//        	var param = {ITEM_CODE: newValue, DIV_CODE: panelSearch.getValue('DIV_CODE')}
//        	bpr101ukrvService.checkItemDuplicate(param, function(provider1, response)	{							
//				if(provider1[0].CNT > 0){
//					Unilite.messageBox('기등록품목입니다.');
//					record.set('ITEM_CODE', '');
//				}
//			});
//        }
	});
	
	Unilite.createValidator('validator01', {
		store : directMasterStore,
		grid: masterGrid,
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			
			if(fieldName == "ITEM_CODE" )	{	
				if(isNaN(newValue)){
					rv = "숫자만 입력 가능합니다.";
//					return false;
				}
				var record = masterGrid.getSelectedRecord();
				var param = {ITEM_CODE: newValue, DIV_CODE: panelSearch.getValue('DIV_CODE')}
	        	bpr102skrvService.checkItemDuplicate(param, function(provider1, response)	{							
					if(provider1[0].CNT > 0 && record.phantom){
						Unilite.messageBox('기등록품목입니다.');
						record.set('ITEM_CODE', '');
					}else if(record.phantom && !Ext.isEmpty(newValue)){
						isViewImage = false;
						UniAppManager.app.fnSearchBookInfo(newValue);	
					}
	        	});	
			}
			
			if(fieldName == "SALE_BASIS_P" )	{	
					if(newValue < 0 ) {
						 rv='<t:message code="unilite.msg.sMB076" default="양수만 입력가능합니다."/>';
					}/*else{
						var rtnRecord = masterGrid.getSelectedRecord();
						rtnRecord.set('BF_SALE_BASIS_P', rtnRecord.get('SALE_BASIS_P'));
						rtnRecord.set('SALE_DATE', UniDate.get('today'));
					}*/					
			}
			return rv;
		}
	}); // validator
	
	Unilite.createValidator('validator02', {
		store : directSubStore,
		grid: subGrid,
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
						var masterRecord = masterGrid.getSelectedRecord();
						if(!Ext.isEmpty(masterRecord.get('SALE_BASIS_P')) && masterRecord.get('SALE_BASIS_P') != 0){
							record.set('ITEM_P', detailForm.getValue('SALE_BASIS_P') * (newValue / 100) );
						}					
					}
					
			}else if(fieldName == "ITEM_P"){
				if(newValue < 0 ) {
						 rv='<t:message code="unilite.msg.sMB076" default="양수만 입력가능합니다."/>';
				}else{										
					var masterRecord = masterGrid.getSelectedRecord();
					if(!Ext.isEmpty(masterRecord.get('SALE_BASIS_P')) && masterRecord.get('SALE_BASIS_P') != 0){
						record.set('PURCHASE_RATE',   newValue / (detailForm.getValue('SALE_BASIS_P') / 100));
					}
				}
			}
			return rv;
		}
	}); // validator

//	Unilite.createValidator('formValidator', {
//		forms: {'formA:':detailForm},		
//		validate: function( type, fieldName, newValue, oldValue) {
////			if(newValue == oldValue){
////				return false;
////			}
//			var rv = true;
//			switch(fieldName) {	
////				case "ITEM_CODE" :					
////					var rtnRecord = masterGrid.getSelectedRecord();
////					if(!Ext.isEmpty(rtnRecord)){
////						UniAppManager.app.duplicateItemCheck(newValue);
////					}
////				break;
//				
////				case "SALE_BASIS_P" :
////					var rtnRecord = masterGrid.getSelectedRecord();
////					if(!Ext.isEmpty(rtnRecord)){
////						detailForm.setValue('BF_SALE_BASIS_P', rtnRecord.get('SALE_BASIS_P'));
////						if(Ext.isEmpty(detailForm.getValue('SALE_DATE'))){
////							detailForm.setValue('SALE_DATE', UniDate.get('today'));
////						}
////					}					
////				break;
//			}
//			return rv;
//		}
//	});
	Unilite.createValidator('validator03', {
//		store : directMasterStore,
//		grid: masterGrid,
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			if( fieldName == 'ITEM_NAME' ) {
				record.set('ITEM_NAME1',newValue);		
			}else if( fieldName == 'ITEM_CODE' ){
				if(isNaN(newValue)){
//					detailForm.setValue('ITEM_CODE', '');
					
					rv = "숫자만 입력 가능합니다.";
				}
			} 				
			return rv;
		}
	}); // validator
};


</script>

