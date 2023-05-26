<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr101ukrv"  >
<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->	
<t:ExtComboStore comboType="AU" comboCode="B013" /><!-- 단위 -->
<t:ExtComboStore comboType="AU" comboCode="B059" /><!-- 세구분 -->
<t:ExtComboStore comboType="AU" comboCode="B010" /><!-- 단위 -->
<t:ExtComboStore comboType="AU" comboCode="B020" opts= '${itemAccount}'/><!-- 품목계정 -->
<t:ExtComboStore comboType="AU" comboCode="B014" /><!-- 조달구분 -->
<t:ExtComboStore comboType="AU" comboCode="B061" /><!-- 발주방침 -->
<t:ExtComboStore comboType="AU" comboCode="A003" /><!-- 매입매출 구분 -->
<t:ExtComboStore comboType="AU" comboCode="YP08" /><!-- 매입조건 -->
<t:ExtComboStore comboType="AU" comboCode="YP09" /><!-- 판매형태 -->
<t:ExtComboStore comboType="AU" comboCode="YP19" /><!-- 주방프린터 -->
<t:ExtComboStore comboType="AU" comboCode="YP02" opts= '${binNumList}' /> <!-- 상품 진열대번호 -->
<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="bpr101ukrvLevel1Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="bpr101ukrvLevel2Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="bpr101ukrvLevel3Store" />
</t:appConfig>
<script type="text/javascript" >
var BsaCodeInfo = {	
	gsItemCodeSyncYN: '${gsItemCodeSyncYN}'	//품목코드, 바코드 동기화 여부
};
//var detailWin;
var stockSearchWindow; //창고별재고 조회 그리드
var getItemPWindow;
var getWindowX;
var getWindowY;
var excelWindow;	// 엑셀참조
var excelUploadFlag = "N";
function appMain() {
	var processFlag = '0';
//	var isAllowBasisPriceChange = true;
		////그리드에서 판매단가 수정시 지속적으로 이전단가가 바뀌어서 이전단가가 최초의 이전단가로 맞지 않는 문제
		////매입단가 등록에서 추가버튼 누른 시점에 필수값record들이 아직 작성 안되었을때??
		
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
	                    read : 'bpr101ukrvService.searchMenu'
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
		            }
	            }
	        });
			this.items = [{
				fieldLabel:'<t:message code="system.label.base.itemname" default="품목명"/>',
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
		        width: 388,
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
			});
			this.callParent();
		}
	});
	/**
	 * Master Model
	 */				
	 
	Unilite.defineModel('bpr101ukrvModel', {
		fields: [	 //BPR100T필수
					 { name: 'PAGE_LINK',  				text: 'LINK', 		type : 'string'}
					,{ name: 'STOCK_UNIT',  			text: '<t:message code="system.label.base.inventoryunit" default="재고단위"/>', 		type : 'string', allowBlank: false, comboType:'AU', comboCode:'B013', displayField: 'value'/*, defaultValue: 'EA'*/ }      
			  		,{ name: 'TAX_TYPE',  				text: '<t:message code="system.label.base.taxtype" default="세구분"/>', 		type : 'string', allowBlank: false, comboType:'AU', comboCode:'B059' /*, defaultValue:'1'*/ }
    	 	 		,{ name: 'ITEM_CODE',  				text: '<t:message code="system.label.base.itemcode" default="품목코드"/>', 		type : 'string', allowBlank: true, isPk:true, pkGen:'user',maxLength:20 }
			  		,{ name: 'ITEM_NAME',  				text: '<t:message code="system.label.base.itemname" default="품목명"/>', 		type : 'string', allowBlank: false, maxLength: 40}        
			  		
			  		,{ name: 'SPEC',  					text: '<t:message code="system.label.base.spec" default="규격"/>', 		type : 'string', maxLength: 160}
				    ,{ name: 'ITEM_LEVEL1',  			text: '<t:message code="system.label.base.majorgroup" default="대분류"/>', 		type : 'string', store: Ext.data.StoreManager.lookup('bpr101ukrvLevel1Store'), child:'ITEM_LEVEL2'}        					       
				    ,{ name: 'ITEM_LEVEL2',  			text: '<t:message code="system.label.base.middlegroup" default="중분류"/>', 		type : 'string', store: Ext.data.StoreManager.lookup('bpr101ukrvLevel2Store'), child:'ITEM_LEVEL3'}        
				    ,{ name: 'ITEM_LEVEL3',  			text: '<t:message code="system.label.base.minorgroup" default="소분류"/>', 		type : 'string', store: Ext.data.StoreManager.lookup('bpr101ukrvLevel3Store'),parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'], levelType:'ITEM'}
			  		,{ name: 'SALE_UNIT',  				text: '<t:message code="system.label.base.salesunit" default="판매단위"/>', 		type : 'string', comboType:'AU', comboCode:'B013', displayField: 'value', allowBlank: false/*, defaultValue: 'EA'*/}      
			  		,{ name: 'TRNS_RATE',  				text: '<t:message code="system.label.base.salespackednumber" default="판매입수"/>', 		type : 'int'/*, defaultValue:1.00*/, maxLength: 12 }           
			  		,{ name: 'SALE_BASIS_P',  	 		text: '<t:message code="system.label.base.sellingprice" default="판매단가"/>', 		type : 'uniUnitPrice', maxLength: 18, allowBlank: true}
			  		,{ name: 'BF_SALE_BASIS_P',  		text: '이전단가', 		type : 'uniUnitPrice', maxLength: 18}
			  		
			  		//BPR200T 필수
			  		,{ name: 'DIV_CODE',  				text: '<t:message code="system.label.base.division" default="사업장"/>', 		type : 'string', allowBlank: false, comboType: 'BOR120' /*, multiSelect: true, typeAhead: false*/}
			  		,{ name: 'ITEM_ACCOUNT',  			text: '<t:message code="system.label.base.itemaccount" default="품목계정"/>', 		type : 'string', comboType:'AU', comboCode:'B020', allowBlank: false }
			  		,{ name: 'SUPPLY_TYPE',  			text: '<t:message code="system.label.base.procurementclassification" default="조달구분"/>', 		type : 'string', comboType:'AU', comboCode:'B014', allowBlank: false}			  		
			  		,{ name: 'ORDER_UNIT',  			text: '<t:message code="system.label.base.purchaseunit" default="구매단위"/>', 		type : 'string', comboType:'AU', comboCode:'B013', displayField: 'value', allowBlank: false/*, defaultValue: 'EA'*/}
			  		,{ name: 'WH_CODE',  				text: '<t:message code="system.label.base.mainwarehouse" default="주창고"/>', 		type : 'string', store: Ext.data.StoreManager.lookup('whList'), defaultValue: 'W052'}
			  		,{ name: 'ORDER_PLAN',  			text: '<t:message code="system.label.base.popolicy" default="발주방침"/>', 		type : 'string', comboType:'AU', comboCode:'B061', allowBlank: true/*, defaultValue: '1'*/}
			  		
			  		//BPR200T 일반
			  		,{ name: 'BUY_RATE',  				text: '<t:message code="system.label.base.purchasereceiptcount" default="구매입수"/>', 		type : 'int', maxLength:12 }
			  		,{ name: 'LOCATION',  				text: 'Location', 	type : 'string', maxLength:8 }
			  		,{ name: 'MATRL_PRESENT_DAY',  		text: '올림기간', 		type : 'int', maxLength: 10} //자재올림
			  		,{ name: 'PURCHASE_BASE_P',  		text: '공통구매단가', 	type : 'uniUnitPrice', maxLength: 18}
			  		,{ name: 'CUSTOM_CODE',  			text: '기준거래처', 	type : 'string', maxLength: 8}
			  		,{ name: 'CUSTOM_NAME',  			text: '기준거래처명', 	type : 'string', maxLength: 20}
			  		,{ name: 'K_PRINTER',  				text: '주방프린터', 	type : 'string', comboType:'AU', comboCode:'YP19'}
			  		//,{ name: 'EXCEL',  			text: '엑셀업로드', 	type : 'string'}
			  		
			  		
			  		
			  		//hidden
			  		,{ name: 'ITEM_NAME1',  			text: '<t:message code="system.label.base.itemname" default="품목명"/>1', 		type : 'string', maxLength: 40}       
			  		,{ name: 'ITEM_NAME2',  			text: '<t:message code="system.label.base.itemname" default="품목명"/>2', 		type : 'string', maxLength: 40}
				    ,{ name: 'ITEM_GROUP',  			text: '<t:message code="system.label.base.repmodelcode" default="대표모델코드"/>',	type : 'string', maxLength: 20}  
				    ,{ name: 'ITEM_GROUP_NAME',  		text: '<t:message code="system.label.base.repmodelname" default="대표모델명"/>', 	type : 'string', maxLength: 40}    
			  		,{ name: 'STOCK_CARE_YN',  			text: '<t:message code="system.label.base.inventorymanageobject" default="재고관리대상"/>', 	type : 'string', comboType:'AU', comboCode:'B010'}   
			  		,{ name: 'START_DATE',  			text: '<t:message code="system.label.base.usestartdate" default="사용시작일"/>', 	type : 'uniDate', maxLength: 10}    
			  		,{ name: 'STOP_DATE',  				text: '<t:message code="system.label.base.usestopdate" default="사용중단일"/>', 	type : 'uniDate', maxLength: 10}    
			  		,{ name: 'USE_YN',  				text: '<t:message code="system.label.base.photoflag" default="사진유무"/>', 		type : 'string', allowBlank: false, comboType:'AU', comboCode:'B010',defaultValue:'Y'}				    
				    ,{ name: 'SALE_COMMON_P',  			text: '시중가', 		type : 'uniUnitPrice', maxLength: 18}
				    ,{ name: 'CONSIGNMENT_FEE',  		text: '위탁수수료', 	type : 'string', maxLength: 18}
				    
				    ,{ name: 'AUTO_DISCOUNT',  			text: '자동할인여부', 	type : 'string', comboType:'AU', comboCode:'B010',defaultValue:'N', allowBlank: false}
				    ,{ name: 'MEMBER_DISCOUNT_YN',  	text: '회원할인대상', 	type : 'string', maxLength: 80, comboType:'AU', comboCode:'B010',defaultValue:'N', allowBlank: false}
				    ,{ name: 'SPEC_CONTROL',  			text: '특정여부', 		type : 'string', comboType:'AU', comboCode:'B010',defaultValue:'N', allowBlank: false}
				    ,{ name: 'SPEC_CONTROL_CODE',	  	text: '특정코드', 		type : 'string', maxLength:3 }				    
			  		,{ name: 'EXCESS_RATE',  			text: '과출고허용률 ',	type : 'uniPercent', defaultValue:0.00, maxLength: 3}
			  		,{ name: 'IN_EXCESS_RATE',  		text: '<t:message code="system.label.base.overreceiptrate" default="과입고허용율"/>',  	type : 'uniPercent', defaultValue:99999.00, maxLength: 10}
			  		,{ name: 'BIG_BOX_BARCODE',  		text: '물류바코드', 	type : 'string', maxLength: 20 }
			  		
			  		
			  		,{ name: 'BUY_BIG_BOX_BARCODE',  	text: 'BUY물류바코드', 	type : 'string', maxLength: 20 }
			  		,{ name: 'BARCODE',  				text: '상품바코드', 		type : 'string', maxLength: 15 }
			  		,{ name: 'BIN_NUM',  				text: '진열대번호', 	type : 'string', maxLength: 20}
			  		,{ name: 'BIN_NAME',  				text: 'BIN_NAME', 	type : 'string', maxLength: 100}
			  		,{ name: 'BIN_FLOOR',  				text: '선반번호', 		type : 'string', maxLength: 2 }//bpr100t 추가
			  		,{ name: 'USE_BY_DATE',  			text: '재고유효일', 	type : 'int', defaultValue:'${UseByDate}', maxLength: 10}       
			  		,{ name: 'CIR_PERIOD_YN',  			text: '유통기한관리여부',type : 'string', comboType:'AU', comboCode:'B010',defaultValue:'Y', allowBlank: false}
			  		
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
			  		,{ name: 'SALE_DATE',  				text: 'SALE_DATE',  type : 'uniDate', maxLength: 10, defaultValue: UniDate.get('today')}
			  		
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
			read: 'bpr101ukrvService.selectDetailList',
			update: 'bpr101ukrvService.updateDetail',
			create: 'bpr101ukrvService.insertDetail',
			destroy: 'bpr101ukrvService.deleteDetail',
			syncAll: 'bpr101ukrvService.saveAll'
		}
	});
	var directMasterStore = Unilite.createStore('bpr101ukrvMasterStore',{
			model: 'bpr101ukrvModel',
           	autoLoad: false,
        	uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
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
											detailForm.down('#setBasisPBtn').setDisabled(true);
											detailForm.getField('SALE_BASIS_P').setReadOnly(false);
										}else{
											detailForm.down('#setBasisPBtn').setDisabled(false);
											detailForm.getField('SALE_BASIS_P').setReadOnly(true);
										}  
									}								
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
											detailForm.down('#setBasisPBtn').setDisabled(true);
											detailForm.getField('SALE_BASIS_P').setReadOnly(false);
										}else{
											detailForm.down('#setBasisPBtn').setDisabled(false);
											detailForm.getField('SALE_BASIS_P').setReadOnly(true);
										}  
									}
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
//				var app = Ext.getCmp('bpr101ukrvApp');
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
            	var toUpdate = this.getUpdatedRecords();
            	var list = [].concat(toUpdate,toCreate);            	
				var isErr = false;
            	Ext.each(list, function(record, index) {            		
            		if(isNaN(record.get('ITEM_CODE'))){
						Unilite.messageBox('품목코드는 숫자만 입력 가능합니다.');
						detailForm.getField('ITEM_CODE').focus();
						isErr = true;
						return false;
					}
            		if(!Ext.isEmpty(record.get('ITEM_CODE')) && record.get('ITEM_CODE').length != 13){
						Unilite.messageBox('품목코드 13자리를 입력해 주세요.');
						detailForm.getField('ITEM_CODE').focus();
						isErr = true;
						return false;
					}
					
					if(record.get('ITEM_ACCOUNT') == "02" && Ext.isEmpty(record.get('CONSIGNMENT_FEE'))){
						Unilite.messageBox('위탁수수료를 입력해 주세요.');
						detailForm.getField('CONSIGNMENT_FEE').focus();
						isErr = true;
						return false;
					}
					
					//커피부자재는 판가 0 그외는 판가 필수체크
					if(record.get('SPEC_CONTROL_CODE') != "01") {
						if(record.get('SALE_BASIS_P') <= 0){
							Unilite.messageBox('판매단가를 입력해 주세요.');
							detailForm.getField('SALE_BASIS_P').focus();
							isErr = true;
							return false;
						}
					}else{
						record.set('SALE_BASIS_P', 0);
						record.set('SPEC_CONTROL', 'Y');						
					}
					
					if(!Ext.isEmpty(record.get('BUY_BIG_BOX_BARCODE')) && record.get('BUY_RATE') <= 1){
						Unilite.messageBox('구매입수를 2이상 입력해 주세요.');
						detailForm.getField('BUY_RATE').focus();
						isErr = true;
						return false;
					}else if(record.get('BUY_RATE') < 1){
						Unilite.messageBox('구매입수를 입력해 주세요.');
						detailForm.getField('BUY_RATE').focus();
						isErr = true;
						return false;
					}
            	});
            	if(isErr) return false;
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
								bpr101ukrvService.goInterFace(param, function(provider, response)	{
								});
//								isAllowBasisPriceChange = true;
								detailForm.resetDirtyStatus();
								UniAppManager.setToolbarButtons('save', false);
								detailForm.down('#setBasisPBtn').setDisabled(false);
								detailForm.getField('SALE_BASIS_P').setReadOnly(true);
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
					if(excelUploadFlag == "N") {
						detailForm.setActiveRecord(record);
						console.log(modifiedFieldNames);
					}
				}	
			}
	});
	
	
	Unilite.defineModel('bpr101ukrvSubModel', {
    	fields: [ {name: 'CUSTOM_CODE'	 		,text: '매입처코드' 			,type: 'string', allowBlank: false},
		    	  {name: 'CUSTOM_NAME'	 		,text: '매입처명' 				,type: 'string', allowBlank: false},
		    	  {name: 'TYPE'	 				,text: '<t:message code="system.label.base.classfication" default="구분"/>' 				,type: 'string', comboType:'AU', comboCode:'A003'}, 
		    	  {name: 'PURCHASE_TYPE'	 	,text: '매입조건' 				,type: 'string', comboType:'AU', comboCode:'YP08', defaultValue: '2'},
		    	  {name: 'SALES_TYPE'	 		,text: '판매형태' 				,type: 'string', comboType:'AU', comboCode:'YP09', defaultValue: '1'},
		    	  {name: 'APLY_START_DATE'		,text: '적용일자' 				,type: 'uniDate', allowBlank: false},
		    	  {name: 'APLY_END_DATE'		,text: '종료일자' 				,type: 'uniDate', allowBlank: false},
		    	  {name: 'PURCHASE_RATE'		,text: '매입율(%)' 			,type: 'uniPercent', allowBlank: true, editable: false},
		    	  {name: 'ORDER_RATE'			,text: '발주율(%)' 			,type: 'uniPercent'},
		    	  {name: 'USE_YN'				,text: 'USE_YN' 			,type: 'string'},
		    	  {name: 'ITEM_P'				,text: '매입가' 				,type: 'uniUnitPrice', allowBlank: true},//단가 * 발주율 %
			  	  {name: 'BASIS_P'				,text: '<t:message code="system.label.base.sellingprice" default="판매단가"/>'				,type :'uniUnitPrice'},
			  	  {name: 'COMP_CODE'	 		,text: '<t:message code="system.label.base.companycode" default="법인코드"/>' 				,type: 'string'},
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
			read: 'bpr101ukrvService.selectSubDetailList',
			update: 'bpr101ukrvService.updateSubDetail',
			create: 'bpr101ukrvService.insertSubDetail',
			destroy: 'bpr101ukrvService.deleteSubDetail',
			syncAll: 'bpr101ukrvService.subSaveAll'
		}
	});
	
	var directSubStore = Unilite.createStore('bpr101ukrvSubStore', {
		model: 'bpr101ukrvSubModel',
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
        	if(Ext.isEmpty(record) || directMasterStore.getCount() == 0 || record.phantom){
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
					bpr101ukrvService.goInterFace(param, function(provider, response)	{
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
	    		detailForm.getField('SALE_COMMON_P').setReadOnly(false);
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
	var sortSeqStore = Unilite.createStore('bpr101ukrvSeqStore', {
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
	        	panelSearch.down('#itemSearchForm').setWidth(388);
	        },
	        expand: function() {
	        	panelResult.hide();	
	        	panelSearch.down('#itemSearchForm').setWidth(245);
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
	    			fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>' ,
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
						/*blur: function(field, event, eOpts) {
							if(Ext.isEmpty(field.getValue())) return false;
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
						}*/
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
					fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
					name: 'ITEM_ACCOUNT',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'B020',
					readOnly: false,
					listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
							combo.changeDivCode(combo, newValue, oldValue, eOpts);
							panelResult.setValue('ITEM_ACCOUNT', newValue);
						}
					}
				},{
					fieldLabel: '엑셀JOBID',
					name: '_EXCEL_JOBID',
					xtype: 'uniTextfield',
					hidden: true
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
                store: Ext.data.StoreManager.lookup('bpr101ukrvLevel1Store'),
                child: 'ITEM_LEVEL2'
              }, {
              	name: 'ITEM_LEVEL2',
              	fieldLabel: '<t:message code="system.label.base.middlegroup" default="중분류"/>',
              	xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('bpr101ukrvLevel2Store'),
                child: 'ITEM_LEVEL3'
                
             }, {
             	name: 'ITEM_LEVEL3',
             	fieldLabel: '<t:message code="system.label.base.minorgroup" default="소분류"/>',
             	xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('bpr101ukrvLevel3Store'),
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
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		hidden: !UserInfo.appOption.collapseLeftSearch,
		border:true,
		items: [{		
			name: 'ITEM_CODE',  		
			fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>' ,
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
				/*blur: function(field, event, eOpts) {
					if(Ext.isEmpty(field.getValue())) return false;
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
				}*/		
			}
		},{ 
			xtype: 'searchcontainer',
			itemId: 'panelResult'
        },{ 
			fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
			name: 'DIV_CODE',
			labelWidth: 70,
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			readOnly: false,
			allowBlank: false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{ 
			fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>',
			name: 'ITEM_ACCOUNT',
			labelWidth: 110,
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B020',
			readOnly: false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				}
			}
		}/*, {
			text: '상품전송',
			xtype: 'button',
			margin: '0 0 0 40',
			handler: function(){    	
				var param = panelSearch.getValues();
				bpr101ukrvService.goInterFace(param, function(provider, response)	{
				});
			}
		}*/]	
    });
	
	
    /**
     * Master Grid
     */
	 var masterGrid = Unilite.createGrid('bpr101ukrvGrid', {  
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
	    tbar: [{
			xtype: 'splitbutton',
	       	itemId:'refTool',
			text: '참조...',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'excelBtn',
					text: '엑셀참조',
		        	handler: function() {
			        	openExcelWindow();
			        }
				}]
			})
		}],
        columns:  [ 
        			{ dataIndex: 'ITEM_CODE',  			  	width: 105, isLink:true, locked: false
	        			/*editor:{
	        				listeners: {
		        				blur: function( column, event, eOpts ){
		        					var newValue = column.value;
		        					var record = masterGrid.getSelectedRecord();
		        					if(!Ext.isEmpty(newValue)){
		        						if(isNaN(newValue)){
											Unilite.messageBox("숫자만 입력 가능합니다.");
											return false;
										}
										UniAppManager.app.duplicateItemCheck(newValue);
										if(BsaCodeInfo.gsItemCodeSyncYN == "Y"){
											record.set('BARCODE', newValue);
										}	
										var zero = ''
										var dataLength = newValue.length;
										for(var i = 0; i < 13 - dataLength; i++){
											zero += '0'
										}
										var itemCode = zero + newValue;										
										record.set('ITEM_CODE', itemCode);
									}
		        				}
	        				}	
	        			}*/
        			},
        			{ dataIndex: 'ITEM_NAME',  			  	width: 200, locked: false},
        			{ dataIndex: 'PAGE_LINK',  			  	width: 105, locked: false, hidden: true,
			          align: 'center',
			          xtype: 'actioncolumn',
			          width:70,
			          items: [{
		                  icon: CPATH+'/resources/css/theme_01/module_14.png',
		                  handler: function(grid, rowIndex, colIndex, item, e, record) {
		                  	masterGrid.getSelectionModel().select(rowIndex); 
		                  	masterGrid.hide();
		                  }
        			}]},
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
        			{ dataIndex: 'CONSIGNMENT_FEE',		  	width: 80, align: 'right',
						renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {    		
		    				return Ext.util.Format.number(val,'0,000');
		    			
		    		}},
        			{ dataIndex: 'ITEM_ACCOUNT',  		  	width: 145},
        			{ dataIndex: 'SUPPLY_TYPE',  		  	width: 110},
        			{ dataIndex: 'ORDER_UNIT',  		  	width: 90, align: 'center'},
        			{ dataIndex: 'WH_CODE',  			  	width: 160, hidden: true},
        			{ dataIndex: 'ORDER_PLAN',  		  	width: 100},
        			//{ dataIndex: 'EXCEL',  		  	width: 100},
        			
//        			hidden
        			{ dataIndex: 'ITEM_NAME1',  		    width: 140,hidden: true},
        			{ dataIndex: 'ITEM_NAME2',  		    width: 140,hidden: true},
        			{ dataIndex: 'ITEM_GROUP',  		  	width: 80, hidden: true},
					{ dataIndex: 'ITEM_GROUP_NAME',  	  	width: 80, hidden: true},	
        			{ dataIndex: 'STOCK_CARE_YN',  		  	width: 80, hidden: true},
        			{ dataIndex: 'START_DATE',  		  	width: 80, hidden: true},
        			{ dataIndex: 'STOP_DATE',  			  	width: 80, hidden: true},
        			{ dataIndex: 'USE_YN',  			  	width: 80, hidden: true},
        			{ dataIndex: 'SALE_COMMON_P',		  	width: 80, hidden: true},
        			{ dataIndex: 'AUTO_DISCOUNT',  		  	width: 80, hidden: true},
        			{ dataIndex: 'MEMBER_DISCOUNT_YN',  	width: 80, hidden: true},
        			{ dataIndex: 'SPEC_CONTROL',  		  	width: 80, hidden: true},
        			{ dataIndex: 'SPEC_CONTROL_CODE',	  	width: 80, hidden: true},
        			{ dataIndex: 'EXCESS_RATE',  		  	width: 80, hidden: true},
        			{ dataIndex: 'IN_EXCESS_RATE', 		  	width: 80, hidden: true},
        			{ dataIndex: 'BIG_BOX_BARCODE',  		width: 80, hidden: true},
        			{ dataIndex: 'BUY_BIG_BOX_BARCODE',   	width: 80, hidden: true},
//        			{ dataIndex: 'SMALL_BOX_BARCODE',  	  	width: 80, hidden: true},
        			{ dataIndex: 'BARCODE',  			  	width: 80, hidden: true},
        			{ dataIndex: 'BIN_NUM',  			  	width: 80, hidden: true},
        			{ dataIndex: 'USE_BY_DATE',  		  	width: 80, hidden: true},
        			{ dataIndex: 'CIR_PERIOD_YN',  		  	width: 80, hidden: true},
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
					{ dataIndex: 'K_PRINTER',  		  		width: 80, hidden: true},
					{ dataIndex: 'REMARK1',  			  	width: 80, hidden: true},
					{ dataIndex: 'REMARK2',  			  	width: 80, hidden: true},
					{ dataIndex: 'REMARK3',  			  	width: 80, hidden: true},
					{ dataIndex: 'BF_SALE_BASIS_P',  		width: 80, hidden: true},
					{ dataIndex: 'MONEY_UNIT',		  		width: 80, hidden: true},
					{ dataIndex: 'SALE_DATE',		  		width: 80, hidden: true},					
					{ dataIndex: 'BIN_FLOOR',			  	width: 80, hidden: true},
					{ dataIndex: 'RTN_REMAIN_Q',			width: 80, hidden: true}	//반품예정 2015.9.15추가
          ] ,
          listeners: {          	
         	selectionchangerecord:function(selected)	{
//         		subGrid.reset();
//				directSubStore.clearData();
         		if(masterGrid.isHidden()){
         			directSubStore.load();
	         		directSubStore.loadStoreRecords(selected);
	         		detailForm.loadForm(selected);
					if(selected.phantom){
						detailForm.down('#setBasisPBtn').setDisabled(true);
						detailForm.getField('SALE_BASIS_P').setReadOnly(false);
					}else{
						detailForm.down('#setBasisPBtn').setDisabled(false);
						detailForm.getField('SALE_BASIS_P').setReadOnly(true);
					}
         		}
//				isAllowBasisPriceChange = true;
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
				//         		subGrid.reset();
//				directSubStore.clearData();
				var record = masterGrid.getSelectedRecord();
         		directSubStore.load();
         		directSubStore.loadStoreRecords(record);         		
         		detailForm.show();
         		detailForm.loadForm(record);
				if(record && record.phantom){
					detailForm.down('#setBasisPBtn').setDisabled(true);
					detailForm.getField('SALE_BASIS_P').setReadOnly(false);
				}else{
					detailForm.down('#setBasisPBtn').setDisabled(false);
					detailForm.getField('SALE_BASIS_P').setReadOnly(true);
				}
				
			},
			show:function()	{
				
			}
          }/*,
	        setExcelData: function(record) {
				var grdRecord = this.getSelectedRecord();
				grdRecord.set('DIV_CODE' 			, record['DIV_CODE']);
				grdRecord.set('ITEM_CODE' 			, record['ITEM_CODE']);
				grdRecord.set('ITEM_NAME' 			, record['ITEM_NAME']);
				grdRecord.set('ITEM_ACCOUNT' 		, record['ITEM_ACCOUNT']);
				grdRecord.set('ITEM_LEVEL1' 		, record['ITEM_LEVEL1']);
				grdRecord.set('ITEM_LEVEL2' 		, record['ITEM_LEVEL2']);
				grdRecord.set('ITEM_LEVEL3' 		, record['ITEM_LEVEL3']);
				grdRecord.set('STOCK_UNIT' 			, 'EA');
				grdRecord.set('TAX_TYPE' 			, record['TAX_TYPE']);
				grdRecord.set('SALE_UNIT' 			, 'EA');
				grdRecord.set('ORDER_UNIT' 			, 'EA');
				grdRecord.set('SALE_BASIS_P' 		, record['SALE_BASIS_P']);
				grdRecord.set('TRNS_RATE' 			, '1');
				grdRecord.set('BARCODE' 			, record['ITEM_CODE']);
				grdRecord.set('USE_YN' 				, 'Y');
				grdRecord.set('WH_CODE' 			, record['WH_CODE']);
				grdRecord.set('PURCHASE_TYPE' 		, record['PURCHASE_TYPE']);
				grdRecord.set('SUPPLY_TYPE' 		, record['SUPPLY_TYPE']);
				grdRecord.set('SALES_TYPE' 			, record['SALES_TYPE']);
				grdRecord.set('CUSTOM_CODE' 		, record['CUSTOM_CODE']);
				grdRecord.set('CUSTOM_NAME' 		, record['CUSTOM_NAME']);
				grdRecord.set('ITEM_P' 				, record['ITEM_P']);
				grdRecord.set('APLY_START_DATE' 	, record['APLY_START_DATE']);
				grdRecord.set('APLY_END_DATE' 		, '29991231');
				//grdRecord.set('PURCHASE_RATE' 		, record['PURCHASE_RATE']);
				grdRecord.set('STOCK_CARE_YN' 		, record['STOCK_CARE_YN']);
				//grdRecord.set('EXCEL' 				, 'Y');
			}*/
    });
	
    /*상세폼에  BPR400T그리드*/
    var subGrid = Unilite.createGrid('bpr101ukrvsubGrid', {    	
    	//region:'center',
    	store : directSubStore,
    	sortableColumns : false,
//    	layout: 'fit',
    	height: 160,
    	width: 729,
    	margin: '0 0 0 116',
    	
    	excelTitle: '상품정보등록(매입처정보)',
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
					var toolbar = subGrid.getDockedItems('toolbar[dock="top"]');
					var needSave = !toolbar[0].getComponent('sub_save').isDisabled();
					var record = masterGrid.getSelectedRecord();
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
						     		directSubStore.loadStoreRecords(record);
						     	}
						     }
						});
					} else {
						directSubStore.loadStoreRecords(record);
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
					var toolbar = subGrid.getDockedItems('toolbar[dock="top"]');
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
						     		subGrid.reset();
						     		directSubStore.clearData();
						     		directSubStore.setToolbarButtons('sub_save', false);
						     		directSubStore.setToolbarButtons('sub_delete', false);
						     		detailForm.getField('SALE_COMMON_P').setReadOnly(false);//시중가 readOnly: false
						     	}
						     }
						});
					} else {
						subGrid.reset();
						directSubStore.clearData();
						directSubStore.setToolbarButtons('sub_save', false);
						directSubStore.setToolbarButtons('sub_delete', false);
						detailForm.getField('SALE_COMMON_P').setReadOnly(false);//시중가 readOnly: false
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
					}					
					if(record.phantom){
						Unilite.messageBox("품목을 먼저 등록해야 합니다.");
						return false;
					}
					/*else{
						if(Ext.isEmpty(record.get('SALE_COMMON_P')) || record.get('SALE_COMMON_P') == 0){
							Unilite.messageBox('시중가를 입력해 주세요');
							detailForm.getField('SALE_COMMON_P').focus();
							return false;
						}
					}*/
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
						ORDER_RATE:			orderRate,
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
			  		,{ dataIndex: 'CUSTOM_NAME'	 		,  		width: 159,
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
			  		,{ dataIndex: 'TYPE'	 			,  		width: 90 , hidden: true}
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
				if(e.record.phantom){
					
					if (UniUtils.indexOf(e.field, 
							['CUSTOM_CODE','CUSTOM_NAME','MONEY_UNIT','ORDER_UNIT','PURCHASE_RATE','ITEM_P','APLY_START_DATE', 'PURCHASE_TYPE', 'SALES_TYPE']))
							{	
								return true;
							}else{
								return false;
							}					
				}else{
					if(e.field == 'ITEM_P' || e.field == 'PURCHASE_RATE')
						{	
							return true;
						}else{
							return false;
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
	        		
	        		if(compareRecords.length > 0){
	        			
	        			Ext.each(compareRecords, function(record3,i){
	        				if(UniDate.getDbDateStr(record3.get('APLY_START_DATE')) > aplyStartDate){
	        					aplyStartDate = UniDate.getDbDateStr(record3.get('APLY_START_DATE'));
	        					updateRec = record3;        					
	        					insertRec = record1;
	        				}        			
	    				});

	    				if(updateRec && insertRec && isSuccess){
	    					if(UniDate.getDbDateStr(insertRec.get('APLY_START_DATE')) >  UniDate.getDbDateStr(updateRec.get('APLY_START_DATE'))){
	    						updateRec.set('APLY_END_DATE', UniDate.add(insertRec.get('APLY_START_DATE'),  {days: -1}));
								insertRec.set('APLY_END_DATE', '29991231');
	    					}else{
	    						Unilite.messageBox('최종 적용일자보다 이전 날짜를 입력 할 수 없습니다.\n 매입처명:' + duplRecord[0].get('CUSTOM_NAME'));
			        			isSuccess = false;
			        			duplRecord = [];
		    					return isSuccess;
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
	Unilite.defineModel('bpr101ukrvstockSearchModel', {
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
    var stockSearchStore = Unilite.createStore('bpr101ukrvstockSearchStore', {
			model: 'bpr101ukrvstockSearchModel',
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
                	read    : 'bpr101ukrvService.selectStockList'
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
    var stockSearchGrid = Unilite.createGrid('bpr101ukrvstockSearchGrid', {
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
					    ]
					,
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
		    			maxLength :20,
		    			listeners:{ 
		    				blur : function( field, event, eOpts ){
		    					if(BsaCodeInfo.gsItemCodeSyncYN == "Y"){
									detailForm.setValue('BARCODE',field.getValue());		
								}
								if(!Ext.isEmpty(field.getValue())){
									var zero = ''
									var dataLength = field.getValue().length;
									for(var i = 0; i < 13 - dataLength; i++){
										zero += '0'
									}
									var itemCode = zero + field.getValue();
									detailForm.setValue('ITEM_CODE', itemCode);
								}								
		    				}
		    			}
		    		}, {
		    			fieldLabel: '<t:message code="system.label.base.itemname" default="품목명"/>',
		    			labelWidth: 141,
		    			name: 'ITEM_NAME',		    			
		    			width: 607,
		    			allowBlank: false,
		    			maxLength :40
		    		}, {
    					text: '창고별재고조회',
    					xtype: 'button',
    					margin: '0 0 0 168',
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
	    			defaults : {enforceMaxLength: true},
	    			items:[{ 
		    			xtype: 'displayfield',
		    			name: ''
		    		}, {
		    			fieldLabel: '<t:message code="system.label.base.itemname" default="품목명"/>1',
		    			name: 'ITEM_NAME1',
		    			labelWidth: 386,
		    			maxLength :40
		    		}, {
		    			fieldLabel: '<t:message code="system.label.base.itemname" default="품목명"/>2',
		    			name: 'ITEM_NAME2',
		    			labelWidth: 156,
		    			maxLength :40
		    		}]
	    		}]
	    },
	    	
	    		{ 
        			  title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>'
        			, defaults: {type: 'uniTextfield', enforceMaxLength: true}
        			, layout: { type: 'uniTable', columns: 1}
        			, height: 435
        			, items :[	 { name: 'ITEM_LEVEL1',  			fieldLabel: '<t:message code="system.label.base.majorgroup" default="대분류"/>' 		,xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('bpr101ukrvLevel1Store'), child: 'ITEM_LEVEL2'}   
						  		,{ name: 'ITEM_LEVEL2',  			fieldLabel: '<t:message code="system.label.base.middlegroup" default="중분류"/>' 		,xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('bpr101ukrvLevel2Store'), child: 'ITEM_LEVEL3'}    
						  		,{ name: 'ITEM_LEVEL3',  			fieldLabel: '<t:message code="system.label.base.minorgroup" default="소분류"/>' 		,xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('bpr101ukrvLevel3Store'), parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],levelType:'ITEM'}
						  		,{xtype: 'displayfield', name: ''}
						  		,{ name: 'SPEC',  					fieldLabel: '<t:message code="system.label.base.spec" default="규격"/>' 		,maxLength: 160} 
						  		,{ name: 'STOCK_UNIT',  			fieldLabel: '<t:message code="system.label.base.inventoryunit" default="재고단위"/>',	 xtype:'uniCombobox',	comboType:'AU', comboCode:'B013' , allowBlank:false, displayField: 'value'}     
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
								    	width:85
								    }, {boxLabel: '아니오',
								    	name: 'STOCK_CARE_YN',
								    	inputValue: 'N',
								    	width:85
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
								    	width:85
								    }, {boxLabel: '아니오',
								    	name: 'USE_YN',
								    	inputValue: 'N',
								    	width:85
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
        			, items :[	 { name: 'TAX_TYPE',  				fieldLabel: '<t:message code="system.label.base.taxtype" default="세구분"/>', 	xtype:'uniCombobox', comboType:'AU', comboCode:'B059' , allowBlank:false}         
						  		,{ name: 'SALE_BASIS_P',  	 		fieldLabel: '<t:message code="system.label.base.sellingprice" default="판매단가"/>', 	xtype : 'uniNumberfield', maxLength: 18, colspan: 1, readOnly: true, allowBlank: false}
						  		,{						           
						           margin: '0 0 0 4',
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
						         }
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
							    ,{ name: 'SALE_COMMON_P',  	 		fieldLabel: '시중가', allowBlank: true, 	xtype : 'uniNumberfield', maxLength: 18}
							    ,{ name: 'CONSIGNMENT_FEE',  	 	fieldLabel: '위탁수수료', 	xtype : 'uniNumberfield', maxLength: 18, fieldStyle: 'text-align: right;'
								/*
								listeners: {
									validitychange: function(field) {					
										detailForm.setValue('CONSIGNMENT_FEE', Ext.util.Format.number(field.value,'0,000'));
									}
								}*/
							    }
							    ,{xtype: 'displayfield', name: ''}
//							    ,{ name: 'AUTO_DISCOUNT',  	 		fieldLabel: '자동할인', 	xtype : 'uniRadiogroup', comboType:'AU', comboCode:'B010', width:235, allowBlank:false}
							    ,{
								    xtype: 'radiogroup',
								    fieldLabel: '자동할인',	
								    items : [{
								    	boxLabel: '예',
								    	name: 'AUTO_DISCOUNT' ,
								    	inputValue: 'Y',
								    	width:85
								    }, {boxLabel: '아니오',
								    	name: 'AUTO_DISCOUNT',
								    	inputValue: 'N',
								    	width:85
								    }]				
								} ,{
								    xtype: 'radiogroup',
								    fieldLabel: '회원할인대상',			    
//								    colspan: 2,
								    items : [{
								    	boxLabel: '예',
								    	name: 'MEMBER_DISCOUNT_YN' ,
								    	inputValue: 'Y',
								    	width:85
								    }, {boxLabel: '아니오',
								    	name: 'MEMBER_DISCOUNT_YN',
								    	inputValue: 'N',
								    	width:85,
								    	checked: true
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
								    	width:85
								    }, {boxLabel: '아니오',
								    	name: 'SPEC_CONTROL',
								    	inputValue: 'N',
								    	width:85
								    }]				
								}
							    ,{ name: 'SPEC_CONTROL_CODE',  		fieldLabel: '특정코드',	xtype:'uniCombobox',	comboType:'AU', comboCode:'YP05'}
							    ,{xtype: 'displayfield', name: ''}
								,{ name: 'SALE_UNIT',  				fieldLabel: '<t:message code="system.label.base.salesunit" default="판매단위"/>',	xtype:'uniCombobox',	comboType:'AU', comboCode:'B013' , displayField: 'value', allowBlank:false}							    
							    ,{ name: 'TRNS_RATE',  				fieldLabel: '<t:message code="system.label.base.salespackednumber" default="판매입수"/>',	xtype:'uniNumberfield', maxLength :12}
							    ,{ name: 'BIG_BOX_BARCODE', 		fieldLabel: '박스바코드',	xtype:'uniTextfield', maxLength :20}
							    ,{ name: 'EXCESS_RATE',  			fieldLabel: '<t:message code="system.label.base.overissuerate" default="과출고허용율"/>',	xtype : 'uniNumberfield',  decimalPrecision:'2', maxLength :3}
							]
	    		}
	    		,{  title: '조달정보'
	    			, layout: {
					            type: 'uniTable',
					            columns: 1
					        }
        			, defaults: {type: 'uniTextfield', enforceMaxLength: true}
        			, height: 435
        			,items :[ { name: 'DIV_CODE',  					fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>', 		 xtype:'uniCombobox', comboType:'BOR120', value:UserInfo.divCode, readOnly: true,allowBlank:false/*, multiSelect: true, typeAhead: false*/}//bpr200t	 
        					 ,{ name: 'ITEM_ACCOUNT',  				fieldLabel: '<t:message code="system.label.base.itemaccount" default="품목계정"/>', 		 xtype:'uniCombobox', comboType:'AU', comboCode:'B020', allowBlank:false}//bpr200t
        					 ,{ name: 'SUPPLY_TYPE',  				fieldLabel: '<t:message code="system.label.base.procurementclassification" default="조달구분"/>', 		 xtype:'uniCombobox', comboType:'AU', comboCode:'B014', allowBlank:false}//bpr200t
        					 ,{ name: 'ORDER_UNIT',  				fieldLabel: '<t:message code="system.label.base.purchaseunit" default="구매단위"/>',		 xtype:'uniCombobox', comboType:'AU', comboCode:'B013', displayField: 'value', allowBlank:false}//bpr200t        					 
        					 ,{				            	
			    				xtype: 'uniNumberfield',
			    				fieldLabel: '<t:message code="system.label.base.purchasereceiptcount" default="구매입수"/>',
			    				name: 'BUY_RATE',
			    				maxLength :12 				    			
					          }
					         ,{ name: 'BUY_BIG_BOX_BARCODE', 		fieldLabel: '물류바코드',		 xtype:'uniTextfield', maxLength :20}
//        					 ,{ name: 'SMALL_BOX_BARCODE', 		 	fieldLabel: '소박스바코드',		 xtype:'uniTextfield', maxLength :20}
        					 ,{ name: 'BARCODE',  					fieldLabel: '상품바코드', 		 xtype:'uniTextfield', maxLength :15}
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
									/*onSelected: {
										fn: function(records, type) {
											UniAppManager.setToolbarButtons('save', true);
				                    	},
										scope: this
									},
									onClear: function(type)	{
										UniAppManager.setToolbarButtons('save', true);
									}*/
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
										popup.setExtParam({'BINTYPE': 'FAN'});	//상품
									}
								}
							})
        					 ,{fieldLabel: '선반번호', name: 'BIN_FLOOR', xtype:'uniCombobox', maxLength :4, comboType:'AU', comboCode:'YP16'}
        					 ,{ name: 'WH_CODE',	  				fieldLabel: '<t:message code="system.label.base.mainwarehouse" default="주창고"/>', 		 xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('whList')}//bpr200t
        					 ,{ name: 'LOCATION',  					fieldLabel: 'Location', 	 xtype:'uniTextfield', maxLength :20}//bpr200t
        					 ,{ name: 'IN_EXCESS_RATE',  			fieldLabel: '<t:message code="system.label.base.overreceiptrate" default="과입고허용율"/>',	xtype : 'uniNumberfield',  decimalPrecision:'2', maxLength :10}
        					 
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
	    		},{ height: 264,
	    			colspan: 4,
	    			layout: {type: 'uniTable', columns: 2},
	    			items :[{
        				xtype: 'container',
        				layout: {type: 'uniTable', columns: 1, tdAttrs: {valign:'top'}},
        				defaults: {type: 'uniTextfield', enforceMaxLength: true},
        				items: [
//        					{ name: 'CIR_PERIOD_YN',  			fieldLabel: '유효기한관리', 	 xtype : 'uniRadiogroup', comboType:'AU', comboCode:'B010', width:260, allowBlank:false, padding: '8 0 0 0'}
        						{
	    							padding: '8 0 0 0',
								    xtype: 'radiogroup',
								    fieldLabel: '유효기한관리',
								    hidden: true,
								    items : [{
								    	boxLabel: '예',
								    	name: 'CIR_PERIOD_YN' ,
								    	inputValue: 'Y',
								    	width:85
								    }, {boxLabel: '아니오',
								    	name: 'CIR_PERIOD_YN',
								    	inputValue: 'N',
								    	width:85
								    }]				
								}
        					   ,{ name: 'USE_BY_DATE',  			fieldLabel: '<t:message code="system.label.base.availabledate" default="유효일"/>',		 xtype:'uniNumberfield',value:'${UseByDate}', hidden: false, maxLength: 10}
//        					   ,{xtype: 'displayfield', name: ''}
        					   ,{ name: 'ORDER_PLAN',  				fieldLabel: '<t:message code="system.label.base.popolicy" default="발주방침"/>',		 xtype:'uniCombobox', comboType:'AU', comboCode:'B061', hidden: true, allowBlank:true}//bpr200t
        					   ,{ name: 'MATRL_PRESENT_DAY',  		fieldLabel: '올림기간', 		 xtype:'uniNumberfield', suffixTpl: '일',hidden: true, maxLength: 5}//bpr200t
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
	        				   ,{xtype: 'displayfield', name: '', height: 162}
        					   ]
        				
        			}, {
        				xtype: 'container',
        				layout: {type: 'uniTable', columns: 1},
        				items: [ {
	        				xtype: 'container',
	        				layout: {type: 'uniTable', columns: 1},
	        				defaults: {type: 'uniTextfield', enforceMaxLength: true},
	        				items: [ { name: 'REMARK1',  			fieldLabel: '비고사항1'  ,width:846, labelWidth: 111, xtype:'uniTextfield'	, maxLength: 300}       
							  		,{ name: 'REMARK2',  			fieldLabel: '비고사항2'  ,width:846, labelWidth: 111, xtype:'uniTextfield', maxLength: 300} 
							  		,{ name: 'REMARK3',  			fieldLabel: '비고사항3'  ,width:846, labelWidth: 111, xtype:'uniTextfield', maxLength: 300}
							]
        				},subGrid
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
				hide:function()	{
					masterGrid.show();
					subGrid.reset();
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
           maxLength: 18,
           enforceMaxLength: true,
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
										bpr101ukrvService.goInterFace(param, function(provider, response)	{
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
    
    // 엑셀참조
	Unilite.Excel.defineModel('excel.bpr101.sheet01', {
	    fields: [
	    	{name: '_EXCEL_JOBID' 		 	 ,text:'EXCEL_JOBID',type: 'string'},
	    	{name: 'DIV_CODE' 		 		 ,text:'<t:message code="system.label.base.division" default="사업장"/>'		,type: 'string', xtype: 'uniCombobox', comboType: 'BOR120'},	
	    	{name: 'ITEM_CODE' 		 		 ,text:'<t:message code="system.label.base.itemcode" default="품목코드"/>'		,type: 'string'},			 
			{name: 'ITEM_NAME' 		 		 ,text:'<t:message code="system.label.base.itemname" default="품목명"/>'		,type: 'string'},			 
			{name: 'ITEM_ACCOUNT' 		 	 ,text:'<t:message code="system.label.base.itemaccount" default="품목계정"/>'		,type: 'string'},			 
			{name: 'ITEM_LEVEL1' 		 	 ,text:'대분류코드'		,type: 'string'},
			{name: 'ITEM_LEVEL_NAME1' 		 ,text:'<t:message code="system.label.base.majorgroup" default="대분류"/>'		,type: 'string'},
			{name: 'ITEM_LEVEL2' 		 	 ,text:'중분류코드'		,type: 'string'},
			{name: 'ITEM_LEVEL_NAME2' 		 ,text:'<t:message code="system.label.base.middlegroup" default="중분류"/>'		,type: 'string'},			 
			{name: 'ITEM_LEVEL3' 		 	 ,text:'소분류코드'		,type: 'string'},	
			{name: 'ITEM_LEVEL_NAME3' 		 ,text:'<t:message code="system.label.base.minorgroup" default="소분류"/>'		,type: 'string'},		 
			{name: 'STOCK_UNIT' 		 	 ,text:'<t:message code="system.label.base.inventoryunit" default="재고단위"/>'		,type: 'string'},			 
			{name: 'TAX_TYPE' 		 		 ,text:'과세구분'		,type: 'string', comboType: 'AU', comboCode: 'B059'},			 
			{name: 'SALE_UNIT' 		 		 ,text:'<t:message code="system.label.base.salesunit" default="판매단위"/>'		,type: 'string'},	
			{name: 'ORDER_UNIT' 		 	 ,text:'<t:message code="system.label.base.purchaseunit" default="구매단위"/>'		,type: 'string'},		
			{name: 'SALE_BASIS_P' 		 	 ,text:'<t:message code="system.label.base.sellingprice" default="판매단가"/>'		,type: 'uniUnitPrice'},			 
			{name: 'TRNS_RATE' 		 		 ,text:'입수'			,type: 'string'},			 
			{name: 'BARCODE' 		 		 ,text:'<t:message code="system.label.base.barcode" default="바코드"/>'		,type: 'string'},			 
			{name: 'STOCK_CARE_YN' 		 	 ,text:'<t:message code="system.label.base.inventorymanageobject" default="재고관리대상"/>'	,type: 'string', comboType:'AU', comboCode:'B010'},			 
			{name: 'WH_CODE' 		 		 ,text:'<t:message code="system.label.base.mainwarehouse" default="주창고"/>'		,type: 'string', store: Ext.data.StoreManager.lookup('whList')},			 
			{name: 'PURCHASE_TYPE' 		 	 ,text:'매입조건'		,type: 'string', comboType: 'AU', comboCode: 'YP08'},  
			{name: 'SUPPLY_TYPE' 		 	 ,text:'<t:message code="system.label.base.procurementclassification" default="조달구분"/>'		,type: 'string', comboType:'AU', comboCode:'B014'},
			{name: 'SALES_TYPE' 		 	 ,text:'판매형태'		,type: 'string', comboType: 'AU', comboCode: 'YP09'},   			 
			{name: 'CUSTOM_CODE' 		 	 ,text:'매입처코드'		,type: 'string'},
			{name: 'CUSTOM_NAME' 		 	 ,text:'매입처명'		,type: 'string'},
			{name: 'ITEM_P' 		 		 ,text:'매입단가'		,type: 'uniUnitPrice'},			 
			{name: 'APLY_START_DATE' 		 ,text:'단가적용일'		,type: 'uniDate'},			 
			{name: 'APLY_END_DATE' 		 	 ,text:'단가종료일'		,type: 'uniDate'}	 
		]
	});
    
    function openExcelWindow() {
		
			var me = this;
	        var vParam = {};
	        var appName = 'Unilite.com.excel.ExcelUploadWin';

            
            if(!excelWindow) {
            	excelWindow =  Ext.WindowMgr.get(appName);
                excelWindow = Ext.create( appName, {
                		modal: false,
                		excelConfigName: 'bpr101',
                		extParam: { 
                			'DIV_CODE': panelSearch.getValue('DIV_CODE')
                			//'CUSTOM_CODE': panelSearch.getValue('CUSTOM_CODE')
                		},
                		
                        grids: [{
                        		itemId: 'grid01',
                        		title: '상품정보',                        		
                        		useCheckbox: false,
                        		model : 'excel.bpr101.sheet01',
                        		readApi: 'bpr101ukrvService.selectExcelUploadSheet1',
                        		//useCheckbox: false,
                        		columns: [
                        			{dataIndex: '_EXCEL_JOBID' 		 		 		, 		width: 80, hidden: true},
                        			{dataIndex: 'DIV_CODE' 		 		 			, 		width: 80},
                        			{dataIndex: 'ITEM_CODE' 		 		 		, 		width: 110},
                        			{dataIndex: 'ITEM_NAME' 		 		 		, 		width: 200},
                        			{dataIndex: 'ITEM_ACCOUNT' 	 		 		 	, 		width: 100},
                        			{dataIndex: 'ITEM_LEVEL1' 	 		 		 	, 		width: 100},
                        			{dataIndex: 'ITEM_LEVEL_NAME1' 	 		 		, 		width: 100, hidden: true},
                        			{dataIndex: 'ITEM_LEVEL2' 	 		 		 	, 		width: 100},
                        			{dataIndex: 'ITEM_LEVEL_NAME2' 	 		 		, 		width: 100, hidden: true},
                        			{dataIndex: 'ITEM_LEVEL3' 	 		 		 	, 		width: 100},
                        			{dataIndex: 'ITEM_LEVEL_NAME3' 	 		 		, 		width: 100, hidden: true},
                        			{dataIndex: 'STOCK_UNIT' 	 		 		 	, 		width: 80, align: 'center'},
                        			{dataIndex: 'TAX_TYPE' 		 		 		 	, 		width: 80, align: 'center'},
                        			{dataIndex: 'SALE_UNIT' 		 		 		, 		width: 80, align: 'center'},
                        			{dataIndex: 'ORDER_UNIT' 		 		 		, 		width: 80, align: 'center'},
                        			{dataIndex: 'SALE_BASIS_P' 	 		 		 	, 		width: 100},
                        			{dataIndex: 'TRNS_RATE' 		 		 		, 		width: 80},
                        			{dataIndex: 'BARCODE' 		 		 		 	, 		width: 80},
                        			{dataIndex: 'STOCK_CARE_YN' 		 		 	, 		width: 100},
                        			{dataIndex: 'WH_CODE' 		 		 		 	, 		width: 80},
                        			{dataIndex: 'PURCHASE_TYPE' 	 		 		, 		width: 80},
                        			{dataIndex: 'SUPPLY_TYPE' 	 		 			, 		width: 80},
                        			{dataIndex: 'SALES_TYPE' 	 		 		 	, 		width: 80},
                        			{dataIndex: 'CUSTOM_CODE' 	 		 		 	, 		width: 110},
                        			{dataIndex: 'CUSTOM_NAME' 	 		 		 	, 		width: 110},
                        			{dataIndex: 'ITEM_P' 		 		 		 	, 		width: 100},
                        			{dataIndex: 'APLY_START_DATE' 		 		 	, 		width: 100},
                        			{dataIndex: 'APLY_END_DATE' 	 		 		, 		width: 100}
								]
                        }],
                        listeners: {
                            close: function() {
                                this.hide();
                            }
                        },
                        onApply:function()	{
                        	excelWindow.getEl().mask('로딩중...','loading-indicator');
                        	var me = this;
                        	var grid = this.down('#grid01');
                			var records = grid.getStore().getAt(0);	
				        	var param = {
				        		"_EXCEL_JOBID": records.get('_EXCEL_JOBID'),
				        		"MONEY_UNIT": UserInfo.currency,
				        		"USE_BY_DATE": '${UseByDate}'
				        	};
				        	excelUploadFlag = "Y"
				        	//if(Ext.isEmpty(records.data._EXCEL_HAS_ERROR)) {
							bpr101ukrvService.selectExcelUploadSheet1(param, function(provider, response){
						    	var store = masterGrid.getStore();
						    	var records = response.result;
						    	store.insert(0, records);
						    	console.log("response",response)
								excelWindow.getEl().unmask();
								grid.getStore().removeAll();
								me.hide();
						    });
							excelUploadFlag = "N"
				        	/*} else {
				        		Unilite.messageBox("에러가있는 행은 적용 불가합니다.");
				        		return false;
				        	}*/
						}
                 });
            }
            excelWindow.center();
            excelWindow.show();
	}
    
        
     Unilite.Main({
      	id  : 'bpr101ukrvApp',
		borderItems : [
			panelSearch,
			panelResult,
			{	region:'center',
				//layout : 'border',
				title:'상품정보',
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
			this.processParams(params);
		    /**
			* 기본값 셋업 
			*/
//			if(params && params.ITEM_CODE ) {
//				panelSearch.setValue('ITEM_CODE',params.ITEM_CODE);
//				masterGrid.getStore().loadStoreRecords();
//			}		
			UniAppManager.setToolbarButtons(['reset','newData','detail'],true);
			UniAppManager.setToolbarButtons('save', false);				
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
			    		Ext.isEmpty(panelSearch.getValue('ITEM_GROUP')) &&
			    		Ext.isEmpty(panelSearch.getValue('ITEM_ACCOUNT'))
			    	)
				    	{
				    		Unilite.messageBox('품목명을 1자이상 입력해 주세요.');
				    		if(panelSearch.getCollapsed()){
				    			panelResult.getField('ITEM_NAME').focus();
				    		}else{
				    			panelSearch.getField('ITEM_NAME').focus();
				    		}		    		
				    		return false;
				    	}
			    	detailForm.clearForm();
					detailForm.resetDirtyStatus();
					subGrid.reset();	
	    		//}
				if(masterGrid.isHidden()){
					detailForm.getEl().mask('로딩중...','loading-indicator');		
				}
		//			isAllowBasisPriceChange = true;
					masterGrid.getStore().loadStoreRecords();

		},
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
				TAX_TYPE: '1',
				SALE_UNIT: 'EA',
				TRNS_RATE: '1',
				ORDER_UNIT: 'EA',
				ORDER_PLAN: '1',
				BUY_RATE: 1				
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
		 	var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
//				detailForm.clearForm();		//넣으면 폼 깨짐
			}
			var record = directMasterStore.data.items[0];
			if(Ext.isEmpty(record) && masterGrid.isHidden()){
				detailForm.hide();
				return false;
			}
		},
		/**
		 *  저장
		 *	@param 
		 *	@return
		 */
		onSaveDataButtonDown: function (config) {
			
			directMasterStore.saveStore(config);			
		}
		,onResetButtonDown:function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			detailForm.clearForm();		
			subGrid.getStore().loadData({});
			masterGrid.getStore().loadData({});	//grid.reset()은 store에 삭제를 시키므로 못씀
			masterGrid.reset();
			subGrid.reset();
			detailForm.hide();
			this.fnInitBinding();
		},
		processParams: function(params) {
			this.uniOpt.appParams = params;			
			if(params && params.ITEM_CODE) {
				panelSearch.setValue('DIV_CODE', params.DIV_CODE);
				panelResult.setValue('DIV_CODE', params.DIV_CODE);
				
				var param = {ITEM_CODE: params.ITEM_CODE.trim(), DIV_CODE: params.DIV_CODE}
				bpr101ukrvService.checkItemDuplicate(param, function(provider1, response)	{							
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
		},
		saveStoreEvent: function(str, newCard)	{
			var config = null;
			this.onSaveDataButtonDown(config);
		}, // end saveStoreEvent()
		
		rejectSave: function()	{
			var rowIndex = masterGrid.getSelectedRowIndex();			
			directMasterStore.rejectChanges();
			if(masterGrid.getStore().getCount() > 0)	{
				masterGrid.select(rowIndex);
			}
			directMasterStore.onStoreActionEnable();
		} // end rejectSave()
		, confirmSaveData: function(config)	{
        	if(directMasterStore.isDirty() )	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
					detailForm.resetDirtyStatus();
					//if (detailWin.isVisible())	detailWin.hide();
				}
			}			
        }, 
        duplicateItemCheck: function(newValue)	{
        	var record = masterGrid.getSelectedRecord();
        	var param = {ITEM_CODE: newValue, DIV_CODE: panelSearch.getValue('DIV_CODE')}
        	bpr101ukrvService.checkItemDuplicate(param, function(provider1, response)	{							
				if(provider1[0].CNT > 0 && record.phantom){
					Unilite.messageBox('기등록품목입니다.');
					record.set('ITEM_CODE', '');
				}
			});
        }        
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
				}else{
					if(excelUploadFlag == 'N') {
						UniAppManager.app.duplicateItemCheck(newValue);
						if(BsaCodeInfo.gsItemCodeSyncYN == "Y"){
							record.set('BARCODE', newValue);
						}	
					}
				}
				
			}
			if(fieldName == "SALE_BASIS_P" )	{	
					if(newValue < 0 ) {
						 rv='<t:message code="unilite.msg.sMB076" default="양수만 입력가능합니다."/>';
					}/*else{
						if(isAllowBasisPriceChange){
							record.set('BF_SALE_BASIS_P', record.get('SALE_BASIS_P'));
							isAllowBasisPriceChange = false;
						}
					}*/
					
			}
			if( fieldName == 'CONSIGNMENT_FEE' ) {
				if(isNaN(newValue)){
					rv = "숫자만 입력 가능합니다."
				}
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
						record.set('PURCHASE_RATE',   Math.round(newValue / (detailForm.getValue('SALE_BASIS_P') / 100)));
					}
					
				}
			}/*else if(fieldName == "APLY_START_DATE"){
				UniAppManager.app.setAplyDate(record, fieldName, newValue);
			}*/
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
//				case "ITEM_CODE" :					
//					var rtnRecord = masterGrid.getSelectedRecord();
//					if(!Ext.isEmpty(rtnRecord)){
//						UniAppManager.app.duplicateItemCheck(newValue);
//					}
//				break;
//				
//				case "SALE_BASIS_P" :
//					var rtnRecord = masterGrid.getSelectedRecord();
////					if(!Ext.isEmpty(rtnRecord) && isAllowBasisPriceChange){
////						detailForm.setValue('BF_SALE_BASIS_P', rtnRecord.get('SALE_BASIS_P'));
////						isAllowBasisPriceChange = false;	//이전단가는 한번change로
////					}
//				break;
//			
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
				var rtnRecord = masterGrid.getSelectedRecord();
				if(!Ext.isEmpty(rtnRecord)){
					UniAppManager.app.duplicateItemCheck(newValue);
				}
			} 			
			return rv;
		}
	}); // validator
};


</script>

