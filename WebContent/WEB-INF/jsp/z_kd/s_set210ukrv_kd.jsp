A<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_s_set210ukrv_kd_kd">
	<t:ExtComboStore comboType="AU" comboCode="S086" />
	<!-- SET 제작구분	-->
	<t:ExtComboStore comboType="AU" comboCode="B024" />
	<!-- 담당자  		-->
	<t:ExtComboStore comboType="AU" comboCode="S012" />
	<!-- 영업자동채번여부  -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" />
	<!-- 창고   -->
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />
	<!--창고Cell-->
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" />
	<!-- 작업장 -->
	<t:ExtComboStore comboType="BOR120" pgmId="s_set210ukrv_kd" />
	<!-- 사업장  -->
</t:appConfig>

<script type="text/javascript">
	var SearchInfoWindow;
	var SearchInfoWindow2;
	var BsaCodeInfo = {
		gsSumTypeCell : '${gsSumTypeCell}',
		gsSumTypeLot : '${gsSumTypeLot}',
		gsPriceAmtYn : '${gsPriceAmtYn}',
		gsMoneyUnit : '${gsMoneyUnit}',
		gsDefaultWhCode : '${gsDefaultWhCode}'
	};

	var CustomCodeInfo = {
		csPricePrecision : UniFormat.Price ? UniFormat.Price.length- (UniFormat.Price.indexOf(".") != -1 ? UniFormat.Price.indexOf(".") + 1 : UniFormat.Price.length - 2) : 2,
		csQtyPrecision : UniFormat.Qty ? UniFormat.Qty.length- (UniFormat.Qty.indexOf(".") != -1 ? UniFormat.Qty.indexOf(".") + 1 : UniFormat.Qty.length - 2) : 2
	};

	var sumtypeCell = true; //재고합산유형 : 창고 Cell 합산에 따라 컬럼설정
	if (BsaCodeInfo.gsSumTypeCell == 'Y') {
		sumtypeCell = false;
	}

	function appMain() {
		var outDivCode = UserInfo.divCode;

		var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
			api : {
				read : 's_set210ukrv_kdService.selectMaster',
				update : 's_set210ukrv_kdService.updateDetail',
				create : 's_set210ukrv_kdService.insertDetail',
				destroy : 's_set210ukrv_kdService.deleteDetail',
				syncAll : 's_set210ukrv_kdService.saveAll'
			}
		});

		var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',
				{
					api : {
						read : 's_set210ukrv_kdService.selectMaster2',
						update : 's_set210ukrv_kdService.updateDetail2',
						create : 's_set210ukrv_kdService.insertDetail2',
						destroy : 's_set210ukrv_kdService.deleteDetail2',
						syncAll : 's_set210ukrv_kdService.saveAll'
					}
				});

		Unilite.defineModel('s_set210ukrv_kdModel', {
			fields : [ 
			    {name : 'INOUT_NUM',		                              	text : '제작번호',				type : 'string'}, 
				{name : 'INOUT_SEQ',		                              		text : '순번',						type : 'int'	}, 
				{name : 'ITEM_CODE',		                              		text : '구성품목코드',			type : 'string',				allowBlank : false},
				{name : 'ITEM_NAME',		                              		text : '구성품목명',			type : 'string',				allowBlank : false}, 
				{name : 'SPEC',				                              			text : '규격',						type : 'string'},
				{name : 'STOCK_UNIT',		                              	text : '단위',						type : 'string',				displayField : 'value'}, 
				{name : 'CONST_Q',			                              		text : '구성수량',				type : 'uniQty',				allowBlank : false}, 
				{name : 'WH_CODE',			                              	text : '출고창고',				type : 'string',				store : Ext.data.StoreManager.lookup('whList'),	child : 'WH_CELL_CODE'}, 
				{name : 'WH_NAME',			                              	text : '출고창고',				type : 'string'			}, 
				{name : 'WH_CELL_CODE',		                            text : '출고창고 Cell',		type : 'string',	allowBlank : sumtypeCell,	store : Ext.data.StoreManager.lookup('whCellList'),	parentNames : [ 'WH_CODE', 'DIV_CODE' ]}, 
				{name : 'WH_CELL_NAME',		                            text : '출고창고CELL명',	type : 'string'}, /* 로직필요*/
				{name : 'LOT_NO',			                              		text : 'LOT NO',				type : 'string'}, /*'재고합산유형 : Lot No. 합산에 따라 컬럼설정*/
				{name : 'INOUT_Q',			                              		text : '소요량',					type : 'uniQty',				allowBlank : false}, 
				{name : 'CURRENT_STOCK',	                            text : '현재고량',				type : 'uniQty'},
				{name : 'DIV_CODE',			                              	text : '사업장',					type : 'string',				child : 'WH_CODE'}, 
				{name : 'INOUT_CODE',		                              	text : '출고처',					type : 'string'},
				{name : 'INOUT_DATE',		                              	text : '출고일',					type : 'uniDate'}, 
				{name : 'ITEM_STATUS',		                              	text : '품목상태',				type : 'string'}, 
				{name : 'INOUT_TYPE',		                              	text : '타입',						type : 'string'}, 
				{name : 'INOUT_METH',		                              	text : '방법',						type : 'string'}, 
				{name : 'INOUT_TYPE_DETAIL',							text : '출고유형',				type : 'string'}, 
				{name : 'INOUT_CODE_TYPE',								text : '출고처구분',			type : 'string'}, 
				{name : 'INOUT_P',		                    					text : '단가',						type : 'uniUnitPrice',				allowBlank : false}, 
				{name : 'INOUT_I',		                    					text : '금액',						type : 'uniPrice'}, 
				{name : 'MONEY_UNIT',	                    				text : '화폐',						type : 'string'}, 
				{name : 'INOUT_FOR_P',	                    	        	text : '재고단위단가',			type : 'uniUnitPrice'	}, 
				{name : 'INOUT_FOR_O',	                    	        	text : '재고단위금액',			type : 'uniPrice'}, 
				{name : 'EXCHG_RATE_O',	                           	 	text : '환율',						type : 'uniER'}, 
				{name : 'ORDER_UNIT',	                    	        	text : '자사단가',				type : 'string'}, 
				{name : 'TRNS_RATE',	                    		        	text : '입수',						type : 'string'}, 
				{name : 'ORDER_UNIT_Q',	                    			text : '출고량',					type : 'uniQty'}, 
				{name : 'ORDER_UNIT_P',	                    			text : '자사단가',				type : 'uniUnitPrice'	}, 
				{name : 'ORDER_UNIT_O',	                    			text : '자사금액',				type : 'uniPrice'}, 
				{name : 'ORDER_UNIT_FOR_P',							text : '단가',						type : 'uniUnitPrice'	}, 
				{name : 'CREATE_LOC',										text : '생성경로',				type : 'string'}, 
				{name : 'SALE_C_YN',											text : '미매출마감여부',		type : 'string'}, 
				{name : 'SALE_DIV_CODE',									text : '매출사업장',			type : 'string'}, 
				{name : 'SALE_CUSTOM_CODE',							text : '매출처',					type : 'string'}, 
				{name : 'BILL_TYPE',												text : '매출유형',				type : 'string'}, 
				{name : 'SALE_TYPE',											text : '매출구분',				type : 'string'}, 
				{name : 'UPDATE_DB_USER',								text : '수정자',					type : 'string'}, 
				{name : 'UPDATE_DB_TIME',								text : '수정한 날짜',			type : 'string'},
				{name : 'PERSONS_NUM',									text : 'PERSONS_NUM',	type : 'string'}, 
				{name : 'WORK_TIME',											text : '실근무시간',			type : 'string'}, 
				{name : 'GONG_SU',											text : 'GONG_SU',			type : 'string'}, 
				{name : 'MAKER_TYPE',										text : '제작구분',				type : 'string'}, 
				{name : 'SET_TYPE',												text : '결제유형',				type : 'string'}, 
				{name : 'WORK_SHOP_CODE',							text : '작업장',					type : 'string'},
				{name : 'REMARK',												text : '비고',						type : 'string'}, 
				{name : 'OLD_INOUT_Q',										text : 'OLD_INOUT_Q',		type : 'uniQty'}, 
				{name : 'INOUT_PRSN',										text : '출고담당',				type : 'string'},
				{name : 'SALE_P',													text : '표준판매단가',			type : 'uniUnitPrice'},
				{name : 'SALE_AMT',											text : '표준판매금액',			type : 'uniPrice'},
				{name : 'CUSTOM_CODE',									text : '거래처코드',						type : 'string'},
				{name : 'CUSTOM_NAME',									text : '거래처명',						type : 'string'}
				]
		});

		Unilite.defineModel('s_set210ukrv_kdModel2', {
			fields : [ 
			    {name : 'INOUT_NUM',				text : '제작번호',				type : 'string'			}, 
			    {name : 'INOUT_SEQ',					text : '순번',				type : 'int'			}, 
			    {name : 'ITEM_CODE',					text : '품목코드',				type : 'string',				allowBlank : false			}, 
			    {name : 'ITEM_NAME',					text : '품목명',				type : 'string',				allowBlank : false			}, 
			    {name : 'SPEC',								text : '규격',				type : 'string'			}, 
			    {name : 'STOCK_UNIT',				text : '단위',				type : 'string',				displayField : 'value'			}, 
				{name : 'CONST_Q',						text : '구성수량',				type : 'uniQty',				allowBlank : false			}, 
				{name : 'WH_CODE',					text : '입고창고',				type : 'string',				store : Ext.data.StoreManager.lookup('whList'),				child : 'WH_CELL_CODE'			}, 
				{name : 'WH_NAME',					text : '입고',				type : 'string'			}, 
				{name : 'WH_CELL_CODE',			text : '입고창고 Cell',				type : 'string',				allowBlank : sumtypeCell,				store : Ext.data.StoreManager.lookup('whCellList'),				parentNames : [ 'WH_CODE', 'DIV_CODE' ]			}, 
			    {name : 'WH_CELL_NAME',			text : '입고창고CELL명',				type : 'string'			}, /* 로직필요*/
				{name : 'LOT_NO',						text : 'LOT NO',				type : 'string'			}, /*'재고합산유형 : Lot No. 합산에 따라 컬럼설정*/
			    {name : 'INOUT_Q',						text : '분해량',				type : 'uniQty'			}, 
			    {name : 'DIV_CODE',					text : '사업장',				type : 'string',				child : 'WH_CODE'			}, 
			    {name : 'INOUT_CODE',				text : '입고처',				type : 'string'			}, 
			    {name : 'INOUT_DATE',				text : '입고일',				type : 'uniDate'			}, 
			    {name : 'ITEM_STATUS',				text : '품목상태',				type : 'string'			}, 
			    {name : 'INOUT_TYPE',				text : '타입',				type : 'string'			}, 
			    {name : 'INOUT_METH',				text : '방법',				type : 'string'			}, 
			    {name : 'INOUT_TYPE_DETAIL',	text : '입고유형',				type : 'string'			}, 
			    {name : 'INOUT_CODE_TYPE',		text : '입고처구분',				type : 'string'			},
			    {name : 'INOUT_P',						text : '단가',				type : 'uniUnitPrice'			}, 
			    {name : 'INOUT_I',						text : '금액',				type : 'uniPrice'			}, 
			    {name : 'MONEY_UNIT',				text : '화폐',				type : 'string'			}, 
			    {name : 'INOUT_FOR_P',				text : '재고단위단가',				type : 'uniUnitPrice'			},
			    {name : 'INOUT_FOR_O',				text : '재고단위금액',				type : 'uniPrice'			},
			    {name : 'EXCHG_RATE_O',			text : '환율',				type : 'uniER'			}, 
			    {name : 'ORDER_UNIT',				text : '자사단가',				type : 'string'			}, 
			    {name : 'TRNS_RATE',					text : '입수',				type : 'string'			},
			    {name : 'ORDER_UNIT_Q',			text : '입고량',				type : 'uniQty'			}, 
			    {name : 'ORDER_UNIT_P',			text : '자사단가',				type : 'uniUnitPrice'			}, 
			    {name : 'ORDER_UNIT_O',			text : '자사금액',				type : 'uniPrice'			}, 
			    {name : 'ORDER_UNIT_FOR_P',	text : '단가',				type : 'string'			}, 
			    {name : 'CREATE_LOC',				text : '생성경로',				type : 'string'			}, 
			    {name : 'SALE_C_YN',					text : '미매출마감여부',				type : 'string'			}, 
			    {name : 'SALE_DIV_CODE',			text : '매출사업장',				type : 'string'			},
			    {name : 'SALE_CUSTOM_CODE',	text : '매출처',				type : 'string'			}, 
			    {name : 'BILL_TYPE',						text : '매출유형',				type : 'string'			}, 
			    {name : 'SALE_TYPE',					text : '매출구분',				type : 'string'			}, 
			    {name : 'UPDATE_DB_USER',		text : '수정자',				type : 'string'			}, 
			    {name : 'UPDATE_DB_TIME',		text : '수정한 날짜',				type : 'string'			}, 
			    {name : 'PERSONS_NUM',			text : 'PERSONS_NUM',				type : 'string'			}, 
			    {name : 'WORK_TIME',					text : '실근무시간',				type : 'string'			}, 
			    {name : 'GONG_SU',					text : 'GONG SU',				type : 'string'			}, 
			    {name : 'MAKER_TYPE',				text : '제작구분',				type : 'string'			}, 
			    {name : 'SET_TYPE',						text : '결제유형',				type : 'string'			}, 
			    {name : 'WORK_SHOP_CODE',	text : '작업장',				type : 'string'			}, 
			    {name : 'REMARK',						text : '비고',				type : 'string'			}, 
			    {name : 'OLD_INOUT_Q',				text : 'OLD_INOUT_Q',				type : 'uniQty'			}, 
			    {name : 'INOUT_PRSN',				text : '출고담당',				type : 'string'			}
			]
		});

		Unilite.defineModel('workNoMasterModel', {
			fields : [ 
				{name : 'DIV_CODE',					text : '사업장',						type : 'string',				comboType : 'BOR120',				defaultValue : UserInfo.divCode			}, 
			 	{name : 'INOUT_NUM',				text : 'SET품목 제작번호',		type : 'string'			}, 
				{name : 'INOUT_SEQ',					text : '순번',						type : 'int'			},
				{name : 'INOUT_TYPE',				text : '타입',						type : 'string'			}, 
				{name : 'ITEM_CODE',					text : '품목코드',				type : 'string'			}, 
				{name : 'ITEM_NAME',					text : '품목명',					type : 'string',				displayField : 'value'			}, 
				{name : 'WH_CODE',					text : '창고',						type : 'string',				store : Ext.data.StoreManager.lookup('whList')			}, 
				{name : 'WH_NAME',					text : '창고',						type : 'string'			}, 
				{name : 'WH_CELL_CODE',			text : 'CELL창고',				type : 'string'			}, /* 로직필요*/			
				{name : 'WH_CELL_NAME',			text : 'CELL창고명',				type : 'string'			}, /* 로직필요*/
				{name : 'INOUT_DATE',				text : '생성일',					type : 'string'			}, /*'재고합산유형 : Lot No. 합산에 따라 컬럼설정*/
				{name : 'INOUT_Q',						text : '소요량',					type : 'uniQty'			}, 
				{name : 'PERSONS_NUM',			text : 'PERSONS_NUM',	type : 'string'			}, 
				{name : 'WORK_TIME',					text : '실근무시간',				type : 'string'			}, 
				{name : 'GONG_SU',					text : 'GONG_SU',			type : 'string'			},
				{name : 'MAKER_TYPE',				text : '제작구분',				type : 'string'			}, 
				{name : 'LOT_NO',						text : 'LOT NO',				type : 'string'			}, 
				{name : 'WORK_SHOP_CODE',	text : '작업장',					type : 'string'			}, 
				{name : 'REMARK',						text : '비고',						type : 'string'			}, 
				{name : 'INOUT_P',						text : '단가',						type : 'uniUnitPrice'			}, 
				{name : 'INOUT_I',						text : '금액',						type : 'uniPrice'			}, 
				{name : 'INOUT_PRSN',				text : '수출담당',				type : 'string'			}
			]
		});

		Unilite.defineModel('workNoMasterModel2', {
			fields : [ 
			 {name : 'DIV_CODE',						text : '사업장',				type : 'string',				comboType : 'BOR120',				defaultValue : UserInfo.divCode			}, 
			 {name : 'INOUT_NUM',					text : 'SET품목 제작번호',				type : 'string'			}, 
			 {name : 'INOUT_SEQ',						text : '순번',				type : 'int'			}, 
			 {name : 'INOUT_TYPE',					text : '타입',				type : 'string'			}, 
			 {name : 'ITEM_CODE',						text : '품목코드',				type : 'string'			}, 
			 {name : 'ITEM_NAME',					text : '품목명',				type : 'string',				displayField : 'value'			}, 
		     {name : 'WH_CODE',				 	    text : '창고',				type : 'string',				store : Ext.data.StoreManager.lookup('whList')			}, 
		     {name : 'WH_NAME',				  		text : '창고',				type : 'string'			}, 
			 {name : 'WH_CELL_CODE',				text : 'CELL창고',				type : 'string'			}, /* 로직필요*/
			 {name : 'WH_CELL_NAME',				text : 'CELL창고명',				type : 'string'			}, /* 로직필요*/
			 {name : 'INOUT_DATE',					text : '생성일',				type : 'string'			}, /*'재고합산유형 : Lot No. 합산에 따라 컬럼설정*/
			 {name : 'INOUT_Q',						text : '소요량',				type : 'uniQty'			}, 
			 {name : 'PERSONS_NUM',				text : 'PERSONS_NUM',				type : 'string'			}, 
			 {name : 'WORK_TIME',					text : '실근무시간',				type : 'string'			}, 
			 {name : 'GONG_SU',						text : 'GONG_SU',				type : 'string'			}, 
			 {name : 'MAKER_TYPE',					text : '제작구분',				type : 'string'			}, 
			 {name : 'LOT_NO',							text : 'LOT NO',				type : 'string'			}, 
			 {name : 'WORK_SHOP_CODE',		text : '작업장',				type : 'string'			}, 
			 {name : 'REMARK',							text : '비고',				type : 'string'			}, 
			 {name : 'INOUT_P',							text : '단가',				type : 'uniUnitPrice'			}, 
			 {name : 'INOUT_I',							text : '금액',				type : 'uniPrice'			}, 
			 {name : 'INOUT_PRSN',					text : '수출담당',				type : 'string'			}
			]
		});
		
		
//PART1
		var MasterStore = Unilite.createStore('s_set210ukrv_kdMasterStore', {
			model : 's_set210ukrv_kdModel',
			uniOpt : {
				isMaster : true, // 상위 버튼 연결 
				editable : true, // 수정 모드 사용 
				deletable : true, // 삭제 가능 여부 
				useNavi : false
			// prev | newxt 버튼 사용
			},
			autoLoad : false,
			proxy : directProxy,
			loadStoreRecords : function(opflag, callback) {
				var param = panelResult.getValues();
				param.CUSTOM_CODE = Ext.getCmp('customCode').valueField.originalValue;
				param["gsSumTypeCell"] = BsaCodeInfo.gsSumTypeCell;
				if (opflag == "child") {
					param["OP_FLAG"] = opflag;
					param["WORK_NUM"] = '$#G#!$#1m0';
				}
				this.load({
					params : param,
					callback : callback
				});
			},
			listeners : {
	          	load: function(store, records, successful, eOpts) {
					//조회된 데이터가 있을 때, 합계 보이게 설정 변경
					if(store.getCount() > 0){
						var sum = 0;						
						Ext.each(records, function(record, index) {
							sum = sum + record.get('SALE_AMT');
						});
						//panelResult.setValue('TOTAL_AMT_I', sum);
						Ext.getCmp('totalAmt').setValue(sum);
					}
					
					
					
	          	}
			},
			saveStore : function() {
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
				var toUpdate = this.getUpdatedRecords();
				var toDelete = this.getRemovedRecords();
				var list = [].concat(toUpdate, toCreate);

				var inoutNum = panelResult.getValue('WORK_NUM');
				Ext.each(list, function(record, index) {
					if (record.data['INOUT_NUM'] != inoutNum) {
						record.set('INOUT_NUM', inoutNum);
					}
				});
				//1. 마스터 정보 파라미터 구성
				var paramMaster = panelResult.getValues(); //syncAll 수정
				paramMaster["OptFlag"] = "1";
				if (inValidRecs.length == 0) {
					config = {
						params : [ paramMaster ],
						success : function(batch, option) {
							var result = batch.operations[0].getResultSet();
							panelResult.setValue("WORK_NUM",
									result['INOUT_NUM']);
							UniAppManager.app.fnQryStockQty("1", panelResult2)
							panelResult.getForm().wasDirty = false;
							panelResult.resetDirtyStatus();
							UniAppManager.setToolbarButtons('save', false);
							UniAppManager.app.onQueryButtonDown();
						}
					};
					this.syncAllDirect(config);
				} else {
					var grid = Ext.getCmp('s_set210ukrv_kdGrid');
					grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
		});

		var MasterStore2 = Unilite.createStore('s_set210ukrv_kdMasterStore2', {
			model : 's_set210ukrv_kdModel2',
			uniOpt : {
				isMaster : true, // 상위 버튼 연결 
				editable : true, // 수정 모드 사용 
				deletable : true, // 삭제 가능 여부 
				useNavi : false
			// prev | newxt 버튼 사용
			},
			autoLoad : false,
			proxy : directProxy2,
			loadStoreRecords : function(opflag, callback) {
				var param = panelResult2.getValues();
				param["gsSumTypeCell"] = BsaCodeInfo.gsSumTypeCell;
				if (opflag == "child") {
					param["OP_FLAG"] = opflag;
					param["WORK_NUM"] = '$#G#!$#1m0';
				}
				this.load({
					params : param,
					callback : callback
				});
			},
			listeners : {},
			saveStore : function() {
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
				var toUpdate = this.getUpdatedRecords();
				var toDelete = this.getRemovedRecords();
				var list = [].concat(toUpdate, toCreate);

				var inoutNum = panelResult2.getValue('WORK_NUM');
				Ext.each(list, function(record, index) {
					if (record.data['INOUT_NUM'] != inoutNum) {
						record.set('INOUT_NUM', inoutNum);
					}
				})
				//1. 마스터 정보 파라미터 구성
				var paramMaster = panelResult2.getValues(); //syncAll 수정
				paramMaster["OptFlag"] = "2";
				if (inValidRecs.length == 0) {
					config = {
						params : [ paramMaster ],
						success : function(batch, option) {
							var result = batch.operations[0].getResultSet();
							panelResult2.setValue("WORK_NUM",
									result['INOUT_NUM']);
							UniAppManager.app.fnQryStockQty("2", panelResult2)
							panelResult2.getForm().wasDirty = false;
							panelResult2.resetDirtyStatus();
							UniAppManager.setToolbarButtons('save', false);
							UniAppManager.app.onQueryButtonDown();
						}
					};
					this.syncAllDirect(config);
				} else {
					var grid = Ext.getCmp('s_set210ukrv_kdGrid');
					grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
		}); // End of var MasterStore 

		var workNoMasterStore = Unilite.createStore('workNoMasterStore', { // 검색버튼 조회창
			model : 'workNoMasterModel',
			autoLoad : false,
			uniOpt : {
				isMaster : false, // 상위 버튼 연결
				editable : false, // 수정 모드 사용
				deletable : false, // 삭제 가능 여부
				useNavi : false
			// prev | newxt 버튼 사용
			},
			proxy : {
				type : 'direct',
				api : {
					read : 's_set210ukrv_kdService.selectWorkNoMaster'
				}
			},
			loadStoreRecords : function() {
				var param = workNoSearch.getValues();
				param["gsGubun"] = "1";
				this.load({
					params : param
				});
			}
		});

		var workNoMasterStore2 = Unilite.createStore('workNoMasterStore2', { // 검색버튼 조회창
			model : 'workNoMasterModel2',
			autoLoad : false,
			uniOpt : {
				isMaster : false, // 상위 버튼 연결
				editable : false, // 수정 모드 사용
				deletable : false, // 삭제 가능 여부
				useNavi : false
			// prev | newxt 버튼 사용
			},
			proxy : {
				type : 'direct',
				api : {
					read : 's_set210ukrv_kdService.selectWorkNoMaster'
				}
			},
			loadStoreRecords : function() {
				var param = workNoSearch2.getValues();
				param["gsGubun"] = "2";
				this.load({
					params : param
				});
			}
		});

		var panelResult = Unilite.createSearchForm('panelResultForm',
						{
							hidden : !UserInfo.appOption.collapseLeftSearch,
							region : 'north',
							layout : {
								type : 'uniTable',
								columns : 4
							},
							padding : '1 1 1 1',
							defaults : {
								//holdable : 'hold'
							},
							border : true,
							items : [
									{
										fieldLabel : '사업장',
										name : 'DIV_CODE',
										labelWidth : 110,
										holdable : 'hold',
										xtype : 'uniCombobox',
										value : UserInfo.divCode,
										comboType : 'BOR120',
										allowBlank : false,
										listeners : {
											change : function(combo, newValue,oldValue, eOpts) {
												panelResult.setValue("ITEM_CODE", "");
												panelResult.setValue("ITEM_NAME", "");
												panelResult.setValue("WH_CODE","");
												panelResult.setValue("LOT_NO","");
												panelResult.setValue("WH_CELL_CODE", "");
												panelResult.setValue("CURRENT_STOCK", "");
											}
										}
									},
									{
										fieldLabel : 'SPEC',
										name : 'SPEC',
										xtype : 'uniTextfield',
										colspan : 1,
										hidden : true
									},
									Unilite.popup('DIV_PUMOK',{
														fieldLabel : 'SET품목',
														colspan : 3,
														holdable : 'hold',
														valueFieldName : 'ITEM_CODE',
														textFieldName : 'ITEM_NAME',
														allowBlank : false,
														listeners : {
															onSelected : {
																fn : function(records,type) {
																	panelResult.setValue('SPEC',records[0]["SPEC"]);
																	UniAppManager.app.fnQryStockQty("1",panelResult)
																},
																scope : this
															},
															onClear : function(type) {
																panelResult.setValue('SPEC',"");
																UniAppManager.app.fnQryStockQty("1",panelResult)
															},
															applyextparam : function(popup) {
																popup.setExtParam({'DIV_CODE' : panelResult.getValue("DIV_CODE")});
															}
														}
													}),
									{
										fieldLabel : 'SET품목제작창고',
										labelWidth : 110,
										name : 'WH_CODE',
										holdable : 'hold',
										xtype : 'uniCombobox',
										child : 'WH_CELL_CODE',
										allowBlank : false,
										store : Ext.data.StoreManager.lookup('whList'),
										listeners : {
											change : function(combo, newValue,oldValue, eOpts) {
												if (BsaCodeInfo.gsSumTypeCell != "Y") {
													UniAppManager.app.fnQryStockQty("1",panelResult2)
												}
											}
										}
									},
									{
										fieldLabel : '출고창고CELL',
										name : 'WH_CELL_CODE',
										holdable : 'hold',
										xtype : 'uniCombobox',
										store : Ext.data.StoreManager.lookup('whCellList'),
										allowBlank : false,
										listeners : {
											change : function(combo, newValue,oldValue, eOpts) {
												UniAppManager.app.fnQryStockQty("1",panelResult)
											}
										}
									},
									{
										fieldLabel : '제작구분',
										name : 'MAKER_TYPE',
										xtype : 'uniCombobox',
										comboType : "AU",
										holdable : 'hold',
										comboCode : "S086",
										listeners : {
											change : function(combo, newValue,oldValue, eOpts) {
												var records = MasterStore.data.items;
												Ext.each(records, function(record, i) {
													record.set("MAKER_TYPE",newValue);
												});
											}
										}
									},
									{
										fieldLabel : 'LOT NO',
										name : 'LOT_NO',
										xtype : 'uniTextfield',
										holdable : 'hold',
										colspan : 2
									},
									{
										fieldLabel : '생성일',
										xtype : 'uniDatefield',
										name : 'CREATE_DATE',
										labelWidth : 110,
										holdable : 'hold',
										allowBlank : false,
										listeners : {
											change : function(combo, newValue,oldValue, eOpts) {
												var records = MasterStore.data.items;
												Ext.each(records, function(record, i) {
													record.set("INOUT_DATE",newValue);
												});
											}
										}
									},
									{
										fieldLabel : '제작수량',
										name : 'SET_QTY',
										xtype : 'uniNumberfield',
										allowBlank : false,
										//holdable : 'hold',
										decimalPrecision : CustomCodeInfo.csQtyPrecision,
										listeners : {
											change : function(combo, newValue,oldValue, eOpts) {
												UniAppManager.app.setQtyChange(MasterStore,panelResult);
											}
										}
									},
									{
										fieldLabel : '단가',
										name : 'INOUT_P',
										xtype : 'uniNumberfield',
										decimalPrecision : CustomCodeInfo.csPricePrecision,
										readOnly : true
									},
									{
										fieldLabel : '금액',
										name : 'INOUT_I',
										xtype : 'uniNumberfield',
										decimalPrecision : CustomCodeInfo.csPricePrecision,
										readOnly : true
									},
									{
										fieldLabel : 'SET품목제작번호',
										name : 'WORK_NUM',
										labelWidth : 110,
										xtype : 'uniTextfield',
										readOnly : true
									},
									{
										fieldLabel : '인원수',
										name : 'PERSONS_NUM',
										xtype : 'uniNumberfield',
										holdable : 'hold',
										listeners : {
											change : function(combo, newValue,oldValue, eOpts) {
												var records = MasterStore.data.items;
												Ext.each(records, function(record, i) {
													record.set("PERSONS_NUM",newValue);
												});
												if (newValue > 0&& panelResult.getValue("WORK_TIME") > 0) {
													panelResult.setValue("GONG_SU",newValue* panelResult.getValue("WORK_TIME"))
													var records = MasterStore.data.items;
													Ext.each(records,function(record,i) {
																		record.set("GONG_SU",newValue* panelResult.getValue("WORK_TIME"));
																	});
												}
											}
										}
									},
									{
										fieldLabel : '작업시간',
										name : 'WORK_TIME',
										holdable : 'hold',
										xtype : 'uniNumberfield',
										listeners : {
											change : function(combo, newValue,oldValue, eOpts) {
												var records = MasterStore.data.items;
												Ext.each(records, function(record, i) {
													record.set("WORK_TIME",newValue);
												});
												if (newValue > 0&& panelResult.getValue("PERSONS_NUM") > 0) {
													panelResult.setValue("GONG_SU",newValue	* panelResult.getValue("PERSONS_NUM"))
													var records = MasterStore.data.items;
													Ext.each(records,function(record,i) {
																		record.set("GONG_SU",newValue* panelResult.getValue("PERSONS_NUM"));
																	});
												}
											}
										}
									},
									{
										fieldLabel : '공수',
										name : 'GONG_SU',
										holdable : 'hold',
										xtype : 'uniNumberfield',
										listeners : {
											change : function(combo, newValue,oldValue, eOpts) {
												var records = MasterStore.data.items;
												Ext.each(records, function(record, i) {
													record.set("GONG_SU",newValue);
												});
											}
										}
									},
									{
										fieldLabel : '비고',
										name : 'REMARK',
										holdable : 'hold',
										labelWidth : 110,
										width : 510,
										xtype : 'uniTextfield',
										colspan : 2,
										listeners : {
											change : function(combo, newValue,oldValue, eOpts) {
												var records = MasterStore.data.items;
												Ext.each(records, function(record, i) {
													record.set("REMARK",newValue);
												});
											}
										}
									},
									{
										fieldLabel : '작업장',
										name : 'WORK_SHOP_CODE',
										holdable : 'hold',
										xtype : 'uniCombobox',
										store : Ext.data.StoreManager.lookup('wsList'),
										listeners : {
											change : function(combo, newValue,oldValue, eOpts) {
												var records = MasterStore.data.items;
												Ext.each(records, function(record, i) {
													record.set("WORK_SHOP_CODE",newValue);
												});
											}
										}
									},
									{
										fieldLabel : '수불담당',
										name : 'INOUT_PRSN',
										xtype : 'uniCombobox',
										holdable : 'hold',
										comboType : 'AU',
										comboCode : 'B024',
										listeners : {
											change : function(combo, newValue,oldValue, eOpts) {
												var records = MasterStore.data.items;
												Ext.each(records, function(record, i) {
													record.set("INOUT_PRSN",newValue);
												});
											}
										}
									} ],
							setAllFieldsReadOnly : setAllFieldsReadOnly
						});

		var panelResult2 = Unilite.createSearchForm('panelResultForm2',
						{
							hidden : !UserInfo.appOption.collapseLeftSearch,
							region : 'north',
							layout : {
								type : 'uniTable',
								columns : 4
							},
							padding : '1 1 1 1',
							border : true,
							items : [
									{
										fieldLabel : '사업장',
										name : 'DIV_CODE',
										xtype : 'uniCombobox',
										value : UserInfo.divCode,
										holdable : 'hold',
										comboType : 'BOR120',
										allowBlank : false,
										labelWidth : 110,
										listeners : {
											change : function(combo, newValue,oldValue, eOpts) {
												panelResult2.setValue("ITEM_CODE", "");
												panelResult2.setValue("ITEM_NAME", "");
												panelResult2.setValue("WH_CODE", "");
												panelResult2.setValue("LOT_NO","");
												panelResult2.setValue("WH_CELL_CODE", "");
												panelResult2.setValue("CURRENT_STOCK", "");
											}
										}
									},
									{
										fieldLabel : 'SPEC',
										name : 'SPEC',
										xtype : 'uniTextfield',
										colspan : 1,
										hidden : true
									},
									Unilite.popup('DIV_PUMOK',
													{
														fieldLabel : 'SET품목',
														colspan : 3,
														holdable : 'hold',
														valueFieldName : 'ITEM_CODE',
														textFieldName : 'ITEM_NAME',
														allowBlank : false,
														listeners : {
															onSelected : {
																fn : function(records,type) {
																	panelResult2.setValue('SPEC',records[0]['SPEC']);
																	UniAppManager.app.fnQryStockQty("1",panelResult2)
																},
																scope : this
															},
															onClear : function(type) {
																panelResult2.setValue('SPEC',"");
																UniAppManager.app.fnQryStockQty("1",panelResult2)
															},
															applyextparam : function(popup) {
																popup.setExtParam({
																			'DIV_CODE' : panelResult2.getValue("DIV_CODE")
																		});
															}
														}
													}),
									{
										fieldLabel : 'SET품목분해창고',
										name : 'WH_CODE',
										holdable : 'hold',
										xtype : 'uniCombobox',
										child : 'WH_CELL_CODE',
										labelWidth : 110,
										allowBlank : false,
										store : Ext.data.StoreManager.lookup('whList'),
										listeners : {
											change : function(combo, newValue,oldValue, eOpts) {
												if (BsaCodeInfo.gsSumTypeCell != "Y") {
													UniAppManager.app.fnQryStockQty("1",panelResult2)
												}
											}
										}
									},
									{
										fieldLabel : '입고창고CELL',
										name : 'WH_CELL_CODE',
										holdable : 'hold',
										xtype : 'uniCombobox',
										store : Ext.data.StoreManager.lookup('whCellList'),
										listeners : {
											change : function(combo, newValue,oldValue, eOpts) {
												UniAppManager.app.fnQryStockQty("1",panelResult2)
											}
										}
									},
									{
										fieldLabel : '제작구분',
										name : 'MAKER_TYPE',
										xtype : 'uniCombobox',
										comboType : "AU",
										comboCode : "S086",
										listeners : {
											change : function(combo, newValue,oldValue, eOpts) {
												var records = MasterStore2.data.items;
												Ext.each(records, function(record, i) {
													record.set("MAKER_TYPE",newValue);
												});
											}
										}
									},
									Unilite.popup('LOT_NO',
													{
														fieldLabel : 'LOT_NO',
														valueFieldName : 'LOT_CODE',
														colspan : 2,
														listeners : {
															onSelected : {
																fn : function(rec,type) {
																	panelResult2.setValue('ITEM_CODE',rec[0]["ITEM_CODE"]);
																	panelResult2.setValue('ITEM_NAME',rec[0]["ITEM_NAME"]);
																	panelResult2.setValue('WH_CODE',rec[0]["WH_CODE"]);
																	panelResult2.setValue('CURRENT_STOCK',rec[0]["GOOD_STOCK_Q"]);
																},
																scope : this
															},
															onClear : function(type) {
																panelResult2.setValue('LOT_CODE','');
															},
															applyextparam : function(popup) {
																popup.setExtParam({
																			'DIV_CODE' : panelResult2.getValue('DIV_CODE')
																		});
																popup.setExtParam({
																			'ITEM_CODE' : panelResult2.getValue('ITEM_CODE')
																		});
																popup.setExtParam({
																			'ITEM_NAME' : panelResult2.getValue('ITEM_NAME')
																		});
															}
														}
													}),
									{
										fieldLabel : '분해일',
										xtype : 'uniDatefield',
										name : 'CREATE_DATE',
										labelWidth : 110,
										allowBlank : false,
										listeners : {
											change : function(combo, newValue,oldValue, eOpts) {
												var records = MasterStore2.data.items;
												Ext.each(records, function(record, i) {
													record.set("INOUT_DATE",newValue);
												});
											}
										}
									},
									{
										fieldLabel : '현재고량',
										name : 'CURRENT_STOCK',
										xtype : 'uniNumberfield',
										readOnly : true,
										decimalPrecision : CustomCodeInfo.csQtyPrecision
									},
									{
										fieldLabel : '인원수',
										name : 'PERSONS_NUM',
										xtype : 'uniNumberfield',
										listeners : {
											change : function(combo, newValue,
													oldValue, eOpts) {
												var records = MasterStore2.data.items;
												Ext.each(records, function(record, i) {
													record.set("PERSONS_NUM",newValue);
												});
												if (newValue > 0&& panelResult2.getValue("WORK_TIME") > 0) {
													panelResult2.setValue("GONG_SU",newValue* panelResult2.getValue("WORK_TIME"))
													var records = MasterStore2.data.items;
													Ext.each(records,function(record,i) {
																		record.set("GONG_SU",newValue* panelResult2.getValue("WORK_TIME"));
																	});
												}
											}
										}
									},
									{
										fieldLabel : '작업시간',
										name : 'WORK_TIME',
										xtype : 'uniNumberfield',
										listeners : {
											change : function(combo, newValue,oldValue, eOpts) {
												var records = MasterStore2.data.items;
												Ext.each(records, function(record, i) {
													record.set("WORK_TIME",newValue);
												});
												if (newValue > 0&& panelResult2.getValue("PERSONS_NUM") > 0) {
													panelResult2.setValue("GONG_SU",newValue* panelResult2.getValue("PERSONS_NUM"));
													var records = MasterStore2.data.items;
													Ext.each(records,function(record,i) {
																		record.set("GONG_SU",newValue* panelResult2.getValue("PERSONS_NUM"));
																	});
												}
											}
										}
									},
									{
										fieldLabel : 'SET품목제작번호',
										name : 'WORK_NUM',
										xtype : 'uniTextfield',
										labelWidth : 110,
										readOnly : true,
										listeners : {
											change : function(combo, newValue,oldValue, eOpts) {
												var records = MasterStore2.data.items;
												Ext.each(records, function(record, i) {
													record.set("INOUT_NUM",newValue);
												});
											}
										}
									},
									{
										fieldLabel : '분해수량',
										name : 'SET_QTY',
										xtype : 'uniNumberfield',
										allowBlank : false,
										decimalPrecision : CustomCodeInfo.csQtyPrecision,
										listeners : {
											change : function(combo, newValue,oldValue, eOpts) {
												UniAppManager.app.setQtyChange(MasterStore2,panelResult2);
											}
										}
									},
									{
										fieldLabel : '단가',
										name : 'INOUT_P',
										xtype : 'uniNumberfield',
										decimalPrecision : CustomCodeInfo.csPricePrecision,
										align : 'right',
										readOnly : true
									},
									{
										fieldLabel : '금액',
										name : 'INOUT_I',
										decimalPrecision : CustomCodeInfo.csPricePrecision,
										xtype : 'uniNumberfield',
										align : 'right',
										readOnly : true
									},
									{
										fieldLabel : '비고',
										name : 'REMARK',
										labelWidth : 110,
										width : 510,
										xtype : 'uniTextfield',
										colspan : 2,
										listeners : {
											change : function(combo, newValue,oldValue, eOpts) {
												var records = MasterStore2.data.items;
												Ext.each(records, function(record, i) {
													record.set("REMARK",newValue);
												});
											}
										}
									},
									{
										fieldLabel : '공수',
										name : 'GONG_SU',
										xtype : 'uniNumberfield',
										listeners : {
											change : function(combo, newValue,oldValue, eOpts) {
												var records = MasterStore2.data.items;
												Ext.each(records, function(record, i) {
													record.set("GONG_SU",newValue);
												});
											}
										}
									},
									{
										fieldLabel : '수불담당',
										name : 'INOUT_PRSN',
										xtype : 'uniCombobox',
										comboType : 'AU',
										comboCode : 'B024',
										listeners : {
											change : function(combo, newValue,oldValue, eOpts) {
												var records = MasterStore2.data.items;
												Ext.each(records, function(record, i) {
													record.set("INOUT_PRSN",newValue);
												});
											}
										}
									} ],
							setAllFieldsReadOnly : setAllFieldsReadOnly
						});

		var workNoSearch = Unilite.createSearchForm('workNoSearchForm', { //  set 품목 제작/분해 팝업
			layout : {
				type : 'uniTable',
				columns : 2
			},
			trackResetOnLoad : true,
			items : [ {
				fieldLabel : '사업장',
				name : 'DIV_CODE',
				xtype : 'uniCombobox',
				value : UserInfo.divCode,
				comboType : 'BOR120'
			}, {
				fieldLabel : 'SET품목제작번호',
				name : 'WORK_NUM',
				xtype : 'uniTextfield',
				labelWidth : 150
			},//缺少一个itemSpec
			Unilite.popup('DIV_PUMOK', {
				fieldLabel : 'SET품목',
				valueFieldName : 'ITEM_CODE',
				textFieldName : 'ITEM_NAME',
				colspan : 2,
				listeners : {
					onSelected : {
						fn : function(records, type) {
							panelResult.setValue('SPEC', records.SPEC);
						},
						scope : this
					},
					onClear : function(type) {
					}
				}
			}), {
				fieldLabel : 'SET제작창고',
				colspan : 2,
				name : 'WH_CODE',
				xtype : 'uniCombobox',
				store : Ext.data.StoreManager.lookup('whList')
			}, {
				fieldLabel : '발주일',
				xtype : 'uniDateRangefield',
				startFieldName : 'CREATE_DATE_FR',
				endFieldName : 'CREATE_DATE_TO',
				startDate : UniDate.get('startOfMonth'),
				endDate : UniDate.get('today'),
				width : 315
			}, {
				fieldLabel : 'SET제작창고CELL',
				name : 'WH_CELL_CODE',
				xtype : 'uniTextfield',
				hidden : true
			} ]
		}); // createSearchForm

		var workNoSearch2 = Unilite.createSearchForm('workNoSearchForm2', { //  set 품목 제작/분해 팝업
			layout : {
				type : 'uniTable',
				columns : 2
			},
			trackResetOnLoad : true,
			items : [ {
				fieldLabel : '사업장',
				name : 'DIV_CODE',
				xtype : 'uniCombobox',
				value : UserInfo.divCode,
				comboType : 'BOR120'
			}, {
				fieldLabel : 'SET품목제작번호',
				name : 'WORK_NUM',
				xtype : 'uniTextfield',
				labelWidth : 150
			},//缺少一个itemSpec
			Unilite.popup('DIV_PUMOK', {
				fieldLabel : 'SET품목',
				valueFieldName : 'ITEM_CODE',
				textFieldName : 'ITEM_NAME',
				colspan : 2
			}), {
				fieldLabel : 'SET제작창고',
				colspan : 2,
				name : 'WH_CODE',
				xtype : 'uniCombobox',
				store : Ext.data.StoreManager.lookup('whList')
			}, {
				fieldLabel : '발주일',
				xtype : 'uniDateRangefield',
				startFieldName : 'CREATE_DATE_FR',
				endFieldName : 'CREATE_DATE_TO',
				startDate : UniDate.get('startOfMonth'),
				endDate : UniDate.get('today'),
				width : 315
			}, {
				fieldLabel : 'SET제작창고CELL',
				name : 'WH_CELL_CODE',
				xtype : 'uniTextfield',
				hidden : true
			} ]
		}); // createSearchForm

		var MasterGrid = Unilite.createGrid('s_set210ukrv_kdGrid',
						{
							region : 'center',
							layout : 'fit',
							store : MasterStore,
							width : 400,
							uniOpt : {
								expandLastColumn : true,
								useLiveSearch : true,
								useContextMenu : true,
								useMultipleSorting : true,
								useGroupSummary : false,
								useRowNumberer : false,
								filter : {
									useFilter : true,
									autoCreate : true
								}
							},
							tbar : [
								Unilite.popup('CUST',{ 
							    	fieldLabel: '거래처', 
							    	labelWidth : 40,
							    	id:'customCode',
							    	valueFieldName: 'CUSTOM_CODE',
									textFieldName: 'CUSTOM_NAME',
									allowBlank : false,
									autoPopup : true,
									listeners:{
										
									}
								}),{xtype: 'component', width: 20},
								{
									fieldLabel : '구성품 총금액',
									name : 'TOTAL_AMT_I',
									xtype : 'uniNumberfield',
									id:'totalAmt',
									decimalPrecision : CustomCodeInfo.csPricePrecision,
							    	labelWidth : 80,
									readOnly : true,
									listeners : {
										change : function(combo, newValue,oldValue, eOpts) {
											var records = MasterStore.data.items;
											Ext.each(records, function(record, i) {
												record.set("SALE_AMT",newValue);
											});
										}
									}
								}, {
								xtype : 'button',
								itemId : 'createComponentBtn',
								text : '구성품생성',
								handler : function() {
									var param = Ext.getCmp('customCode').valueField.value;
									if (panelResult.setAllFieldsReadOnly(true)&&param) {
										MasterStore.loadStoreRecords("child",MasterGrid.fnChildDataCreate);
									}else{
										alert('필수항목이 있음!');
									}
								}
							} ],
							features : [ {
								id : 'MasterGridSubTotal',
								ftype : 'uniGroupingsummary',
								showSummaryRow : false
							}, {
								id : 'MasterGridTotal',
								ftype : 'uniSummary',
								showSummaryRow : false
							} ],
							columns : [
									{dataIndex : 'INOUT_NUM',										width : 120,										hidden : true},
									{dataIndex : 'INOUT_SEQ',										width : 66,										align : 'center',										editable : false},
									{dataIndex : 'ITEM_CODE',										width : 120,
										editor : Unilite.popup('DIV_PUMOK_G',
														{
															textFieldName : 'ITEM_CODE',
															DBtextFieldName : 'ITEM_CODE',
															extParam : {
																SELMODEL : 'MULTI',
																DIV_CODE : outDivCode,
																POPUP_TYPE : 'GRID_CODE'
															},
															autoPopup : true,
															listeners : {
																'onSelected' : {
																	fn : function(records,type) {
																		Ext.each(records,function(record,i) {
																							console.log('record',record);
																							if (i == 0) {
																								MasterGrid.setItemData(record,false);
																							} else {
																								UniAppManager.app.onNewDataButtonDown();
																								MasterGrid.setItemData(record,false);
																							}
																						});
																	},
																	scope : this
																},
																'onClear' : function(type) {
																	MasterGrid.setItemData(null,true);
																}
															}
														})
									},
									{dataIndex : 'ITEM_NAME',										width : 160,
										editor : Unilite.popup('DIV_PUMOK_G',
														{
															extParam : {
																SELMODEL : 'MULTI',
																DIV_CODE : outDivCode
															},
															autoPopup : true,
															listeners : {
																'onSelected' : {
																	fn : function(records,type) {
																		console.log('records : ',records);
																		Ext.each(records,function(record,i) {
																							if (i == 0) {
																								MasterGrid.setItemData(record,false);
																							} else {
																								UniAppManager.app.onNewDataButtonDown();
																								MasterGrid.setItemData(
																												record,false);
																							}
																						});
																	},
																	scope : this
																},
																'onClear' : function(type) {
																	MasterGrid.setItemData(null,true);
																}
															}
														})
									},
									{dataIndex : 'SPEC',										width : 160,										editable : false},
									{dataIndex : 'STOCK_UNIT',										width : 66,										align : 'center',										editable : false},
									{dataIndex : 'CONST_Q',										width : 100},
									{dataIndex : 'WH_CODE',										width : 100},
									{dataIndex : 'WH_NAME',										width : 100,										hidden : true},
									{dataIndex : 'WH_CELL_CODE',										width : 100,										hidden : sumtypeCell},
									{dataIndex : 'WH_CELL_NAME',										width : 100,										hidden : true},
									{dataIndex : 'LOT_NO',										width : 93,										hidden : BsaCodeInfo.gsSumTypeLot == "Y" ? false: true,
										editor : Unilite.popup('LOTNO_G',
														{
															textFieldName : 'LOTNO_CODE',
															DBtextFieldName : 'LOTNO_CODE',
															validateBlank : false,
															autoPopup : true,
															listeners : {
																'onSelected' : {
																	fn : function(records,type) {
																		var rtnRecord;
																		Ext.each(records,function(record,i) {
																							if (i == 0) {
																								rtnRecord = MasterGrid.uniOpt.currentRecord
																							} else {
																								rtnRecord = MasterGrid.getSelectedRecord()
																							}
																							rtnRecord.set('LOT_NO',record["LOT_NO"]);
																							rtnRecord.set('CURRENT_STOCK',record["STOCK_Q"]);
																						});
																	},
																	scope : this
																},
																'onClear' : function(type) {
																	var rtnRecord = MasterGrid.uniOpt.currentRecord;
																	rtnRecord.set('LOT_NO','');
																	rtnRecord.set('CURRENT_STOCK',0);
																},
																applyextparam : function(popup) {
																	var selectRec = MasterGrid.getSelectedRecord();
																	if (!Ext.isEmpty(selectRec)) {
																		popup.setExtParam({
																					'DIV_CODE' : selectRec.get('DIV_CODE')
																				});
																		popup.setExtParam({
																					'ITEM_CODE' : selectRec.get('ITEM_CODE')
																				});
																		popup.setExtParam({
																					'ITEM_NAME' : selectRec.get('ITEM_NAME')
																				});
																		popup.setExtParam({
																					'S_WH_CODE' : selectRec.get('WH_CODE')
																				});
																		popup.setExtParam({
																					'S_WH_CELL_CODE' : selectRec.get('WH_CELL_CODE')
																				});
																		popup.setExtParam({
																					'LOT_NO' : selectRec.get('LOT_NO')
																				});
																		popup.setExtParam({
																					'stockYN' : 'Y'
																				});
																	}
																}
															}
														})
									}, 
									{dataIndex : 'INOUT_Q',										width : 100}, 
									{dataIndex : 'CURRENT_STOCK',										width : 113,										editable : false}, 
									{dataIndex : 'DIV_CODE',										width : 66,										hidden : true},
									{dataIndex : 'INOUT_CODE',										width : 66,										hidden : true}, 
									{dataIndex : 'INOUT_DATE',										width : 66,										hidden : true}, 
									{dataIndex : 'ITEM_STATUS',										width : 66,										hidden : true}, 
									{dataIndex : 'INOUT_TYPE',										width : 66,										hidden : true}, 
									{dataIndex : 'INOUT_METH',										width : 66,										hidden : true}, 
									{dataIndex : 'INOUT_TYPE_DETAIL',										width : 66,										hidden : true}, 
									{dataIndex : 'INOUT_CODE_TYPE',										width : 66,										hidden : true}, 
									{dataIndex : 'INOUT_P',										width : 100}, 
									{dataIndex : 'INOUT_I',										width : 100}, 
									{dataIndex : 'MONEY_UNIT',										width : 66,												hidden : true}, 
									{dataIndex : 'INOUT_FOR_P',										width : 66,										hidden : true	}, 
									{dataIndex : 'INOUT_FOR_O',										width : 66,										hidden : true}, 
									{dataIndex : 'EXCHG_RATE_O',										width : 66,										hidden : true}, 
									{dataIndex : 'ORDER_UNIT',										width : 66,										hidden : true},
									{dataIndex : 'TRNS_RATE',										width : 66,										hidden : true}, 
									{dataIndex : 'ORDER_UNIT_Q',										width : 66,										hidden : true}, 
									{dataIndex : 'ORDER_UNIT_P',										width : 66,										hidden : true}, 
									{dataIndex : 'ORDER_UNIT_O',										width : 66,										hidden : true}, 
									{dataIndex : 'ORDER_UNIT_FOR_P',										width : 66,										hidden : true}, 
									{dataIndex : 'CREATE_LOC',										width : 66,										hidden : true}, 
									{dataIndex : 'SALE_C_YN',										width : 66,										hidden : true}, 
									{dataIndex : 'SALE_DIV_CODE',										width : 66,										hidden : true}, 
									{dataIndex : 'SALE_CUSTOM_CODE',										width : 66,										hidden : true}, 
									{dataIndex : 'BILL_TYPE',										width : 66,										hidden : true	}, 
									{dataIndex : 'SALE_TYPE',										width : 66,										hidden : true	}, 
									{dataIndex : 'COMP_CODE',										width : 66,										hidden : true}, 
									{dataIndex : 'UPDATE_DB_USER',										width : 66,										hidden : true}, 
									{dataIndex : 'UPDATE_DB_TIME',										width : 66,										hidden : true}, 
									{dataIndex : 'PERSONS_NUM',										width : 66,										hidden : true}, 
									{dataIndex : 'WORK_TIME',										width : 66,										hidden : true}, 
									{dataIndex : 'GONG_SU',										width : 66,										hidden : true}, 
									{dataIndex : 'MAKER_TYPE',										width : 66,										hidden : true}, 
									{dataIndex : 'SET_TYPE',										width : 66,										hidden : true}, 
									{dataIndex : 'WORK_SHOP_CODE',										width : 66,										hidden : true}, 
									{dataIndex : 'SALE_P',										width : 100}, 
									{dataIndex : 'SALE_AMT',										width : 100}, 
									{dataIndex : 'REMARK',										width : 180,										editable : false}, 
									{dataIndex : 'OLD_INOUT_Q',										width : 66,										hidden : true}, 
									{dataIndex : 'INOUT_PRSN',										width : 66,										hidden : true},
									{dataIndex : 'CUSTOM_CODE',								width : 66,										hidden : true},
									{dataIndex : 'CUSTOM_NAME',								width : 66,										hidden : true}
							],
							listeners : {
								beforeedit : function(editor, e, eOpts) {
									//        		cbStore.loadStoreRecords(e.record.get('WH_CODE'));
									if (e.record.phantom) {
										if (UniUtils.indexOf(e.field, [
												'WH_CODE', 'WH_NAME', 'LOT_NO','WH_CELL_CODE', 'WH_CELL_NAME',
												'ITEM_CODE', 'ITEM_NAME','CONST_Q', 'INOUT_Q','INOUT_P', 'INOUT_I' ])) {
											return true;
										} else {
											return false;
										}
									} else {
										if (UniUtils.indexOf(e.field,
												[ 'WH_CELL_CODE','WH_CELL_NAME','INOUT_Q', 'INOUT_P','INOUT_I' ])) {
											return true;
										} else {
											return false;
										}
									}
								}
							},
							setItemData : function(record, dataClear) {
								var grdRecord = this.getSelectedRecord();
								if (dataClear) {
									grdRecord.set('ITEM_CODE', '');
									grdRecord.set('ITEM_NAME', '');
									grdRecord.set('SPEC', '');
									grdRecord.set('STOCK_UNIT', '');
									grdRecord.set('WH_CODE', '');
									grdRecord.set('WH_CELL_CODE', '');
									grdRecord.set('WH_CELL_NAME', '');
									grdRecord.set('INOUT_P', '0');
									grdRecord.set('INOUT_I', '0');
									grdRecord.set('INOUT_FOR_P', '0');
									grdRecord.set('ORDER_UNIT_P', '0');
									grdRecord.set('ORDER_UNIT_O', '0');
									grdRecord.set('ORDER_UNIT_FOR_P', '0');
									grdRecord.set('CONST_Q', '0');
									grdRecord.set('INOUT_Q', '0');

									UniAppManager.app.setQtyChange(MasterStore,
											panelResult)

								} else {
									grdRecord.set('ITEM_CODE',record['ITEM_CODE']);
									grdRecord.set('ITEM_NAME',record['ITEM_NAME']);
									grdRecord.set('SPEC', record['SPEC']);
									grdRecord.set('STOCK_UNIT',record['STOCK_UNIT']);
									grdRecord.set('WH_CODE', record['WH_CODE']);
									grdRecord.set('WH_CELL_CODE',record['WH_CELL_CODE']);
									grdRecord.set('WH_CELL_NAME',record['WH_CELL_NAME']);

									UniAppManager.app.setQtyChange(MasterStore,panelResult)
								}
							},
							fnChildDataCreate : function() {
								var records = MasterStore.data.items;
								Ext.each(records,function(record, i) {
													record.phantom = true;
													if (record.get("INOUT_NUM") == '') {
														record.set("INOUT_SEQ",i + 1);
														record.set("INOUT_Q",record.get("CONST_Q")* panelResult.getValue("SET_QTY"))
													}
													record.set("DIV_CODE",panelResult.getValue("DIV_CODE"));
													record.set("INOUT_CODE",panelResult.getValue("DIV_CODE"));
													record.set("INOUT_DATE",panelResult.getValue("CREATE_DATE"));

													var inoutQ = record.get("INOUT_Q");
													var inoutP = record.get("INOUT_P");

													record.set("ITEM_STATUS","1");
													record.set("INOUT_TYPE","2");//수불타입 : 출고
													record.set("INOUT_METH","2");
													record.set("INOUT_TYPE_DETAIL","98");
													record.set("INOUT_CODE_TYPE","*");

													record.set("INOUT_P",inoutP);
													record.set("INOUT_I",inoutP * inoutQ);
													record.set("MONEY_UNIT",BsaCodeInfo.gsMoneyUnit);
													record.set("INOUT_FOR_P",inoutP);
													record.set("INOUT_FOR_O",inoutP * inoutQ);
													record.set("EXCHG_RATE_O",1);
													record.set("ORDER_UNIT",record.get("STOCK_UNIT"));
													record.set("TRNS_RATE", 1);
													record.set("ORDER_UNIT_Q",inoutQ);
													record.set("ORDER_UNIT_P",inoutP);
													record.set("ORDER_UNIT_O",inoutP * inoutQ);
													record.set("ORDER_UNIT_FOR_P",inoutP);

													record.set("CREATE_LOC","1");
													record.set("SALE_C_YN","N");
													record.set("SALE_DIV_CODE","*");
													record.set("SALE_CUSTOM_CODE","*");
													record.set("BILL_TYPE","*");
													record.set("SALE_TYPE","*");
													//record.set("SALE_CUSTOM_CODE",Ext.getCmp('customCode').valueField.originalValue);

													if (Ext.isEmpty(BsaCodeInfo.gsDefaultWhCode)) {
														record.set("WH_CODE",panelResult.getValue("WH_CODE"));
													} else {
														record.set("WH_CODE",BsaCodeInfo.gsDefaultWhCode);
													}
													if (Ext.isEmpty(BsaCodeInfo.gsDefaultWhCellCode)) {
														record.set("WH_CELL_CODE",panelResult.getValue("WH_CELL_CODE"));
													} else {
														record.set("WH_CELL_CODE",BsaCodeInfo.gsDefaultWhCellCode);
													}

													record.set("PERSONS_NUM",panelResult.getValue("PERSONS_NUM") ? panelResult.getValue("PERSONS_NUM"): '0');
													record.set("WORK_TIME",panelResult.getValue("WORK_TIME") ? panelResult.getValue("WORK_TIME"): '0');
													record.set("GONG_SU",panelResult.getValue("GONG_SU") ? panelResult.getValue("GONG_SU"): '0');
													record.set("MAKER_TYPE",panelResult.getValue("MAKER_TYPE"));
													record.set("SET_TYPE", "1");//SET구성
													record.set("WORK_SHOP_CODE",panelResult.getValue("WORK_SHOP_CODE"));
													record.set("REMARK",panelResult.getValue("REMARK"));
													record.set("INOUT_PRSN",panelResult.getValue("INOUT_PRSN"));

													var param = {
														'WH_CODE' : record.get("WH_CODE"),
														'ITEM_CODE' : record.get("ITEM_CODE"),
														'DIV_CODE' : record.get("DIV_CODE")
													}
													s_set210ukrv_kdService.selectStockQty(param,function(provider,response) {
																		if (provider) {
																			if (provider["GOOD_STOCK_Q"] > 0) {
																				record.set("CURRENT_STOCK",provider["GOOD_STOCK_Q"]);
																			}
																			if (BsaCodeInfo.gsSumTypeCell == "Y") {
																				record.set("LOT_NO",provider["LOT_NO"])
																			}
																		}
																	});
												});
								UniAppManager.app.setQtyChange(MasterStore,panelResult);
								UniAppManager.setToolbarButtons([ 'save' ],true);
							}
						}); //End of var MasterGrid

		var MasterGrid2 = Unilite.createGrid('s_set210ukrv_kdGrid2',
						{
							region : 'center',
							layout : 'fit',
							store : MasterStore2,
							width : 400,
							uniOpt : {
								expandLastColumn : true,
								useLiveSearch : true,
								useContextMenu : true,
								useMultipleSorting : true,
								useGroupSummary : false,
								useRowNumberer : false,
								filter : {
									useFilter : true,
									autoCreate : true
								}
							},
							tbar : [ {
								xtype : 'button',
								itemId : 'createComponentBtn',
								text : '구성품생성',
								handler : function() {
									if (panelResult2.setAllFieldsReadOnly(true)) {
										MasterStore2.loadStoreRecords("child",MasterGrid2.fnChildDataCreate);
									}
								}
							} ],
							features : [ {
								id : 'MasterGridSubTotal',
								ftype : 'uniGroupingsummary',
								showSummaryRow : false
							}, {
								id : 'MasterGridTotal',
								ftype : 'uniSummary',
								showSummaryRow : false
							} ],
							columns : [
									{dataIndex : 'INOUT_NUM',										width : 120,										hidden : true},
									{dataIndex : 'INOUT_SEQ',										width : 66,										align : 'center'},
									{dataIndex : 'ITEM_CODE',										width : 120,
										editor : Unilite.popup('DIV_PUMOK_G',
														{
															textFieldName : 'ITEM_CODE',
															DBtextFieldName : 'ITEM_CODE',
															extParam : {
																SELMODEL : 'MULTI',
																DIV_CODE : outDivCode,
																POPUP_TYPE : 'GRID_CODE'
															},
															autoPopup : true,
															listeners : {
																'onSelected' : {fn : function(records,type) {
																		Ext.each(records,function(record,i) {
																							console.log('record',record);
																							if (i == 0) {
																								MasterGrid2.setItemData(record,false);
																							} else {
																								UniAppManager.app.onNewDataButtonDown();
																								MasterGrid2.setItemData(record,false);
																							}
																						});
																	},
																	scope : this
																},
																'onClear' : function(type) {
																	MasterGrid2.setItemData(null,true);
																}
															}
														})
									},
									{
										dataIndex : 'ITEM_NAME',
										width : 160,
										editor : Unilite
												.popup(
														'DIV_PUMOK_G',
														{
															textFieldName : 'ITEM_CODE',
															DBtextFieldName : 'ITEM_CODE',
															extParam : {
																SELMODEL : 'MULTI',
																DIV_CODE : outDivCode,
																POPUP_TYPE : 'GRID_CODE'
															},
															autoPopup : true,
															listeners : {
																'onSelected' : {
																	fn : function(records,type) {
																		Ext.each(records,function(record,i) {
																							console.log('record',record);
																							if (i == 0) {
																								MasterGrid2.setItemData(record,false);
																							} else {
																								UniAppManager.app.onNewDataButtonDown();
																								MasterGrid2.setItemData(record,false);
																							}
																						});
																	},
																	scope : this
																},
																'onClear' : function(type) {
																	MasterGrid2.setItemData(null,true);
																}
															}
														})
									},
									{dataIndex : 'SPEC',										width : 160,										editable : false},
									{dataIndex : 'STOCK_UNIT',										width : 66,										editable : false},
									{dataIndex : 'CONST_Q',										width : 100},
									{dataIndex : 'WH_CODE',										width : 100},
									{dataIndex : 'WH_NAME',										width : 100,										hidden : true},
									{dataIndex : 'WH_CELL_CODE',										width : 100,										hidden : sumtypeCell},
									{dataIndex : 'WH_CELL_NAME',										width : 100,										hidden : true},
									{dataIndex : 'LOT_NO',										width : 93,										hidden : BsaCodeInfo.gsSumTypeLot == "Y" ? false: true,
										editor : Unilite.popup('LOTNO_G',
														{
															textFieldName : 'LOTNO_CODE',
															DBtextFieldName : 'LOTNO_CODE',
															validateBlank : false,
															autoPopup : true,
															listeners : {
																'onSelected' : {
																	fn : function(records,type) {
																		var rtnRecord;
																		Ext.each(records,function(record,i) {
																							if (i == 0) {
																								rtnRecord = MasterGrid2.uniOpt.currentRecord
																							} else {
																								rtnRecord = MasterGrid2.getSelectedRecord()
																							}
																							rtnRecord.set('LOT_NO',record["LOT_NO"]);
																							rtnRecord.set('CURRENT_STOCK',record["STOCK_Q"]);
																						});
																	},
																	scope : this
																},
																'onClear' : function(type) {
																	var rtnRecord = MasterGrid2.uniOpt.currentRecord;
																	rtnRecord.set('LOT_NO','');
																	rtnRecord.set('CURRENT_STOCK',0);
																},
																applyextparam : function(popup) {
																	var selectRec = MasterGrid2.getSelectedRecord();
																	if (!Ext	.isEmpty(selectRec)) {
																		popup.setExtParam({
																					'DIV_CODE' : selectRec.get('DIV_CODE')
																				});
																		popup.setExtParam({
																					'ITEM_CODE' : selectRec.get('ITEM_CODE')
																				});
																		popup.setExtParam({
																					'ITEM_NAME' : selectRec.get('ITEM_NAME')
																				});
																		popup.setExtParam({
																					'S_WH_CODE' : selectRec.get('WH_CODE')
																				});
																		popup.setExtParam({
																					'S_WH_CELL_CODE' : selectRec.get('WH_CELL_CODE')
																				});
																		popup.setExtParam({
																					'LOT_NO' : selectRec.get('LOT_NO')
																				});
																		popup.setExtParam({
																					'stockYN' : 'Y'
																				});
																	}
																}
															}
														})
									}, 
									{dataIndex : 'INOUT_Q',										width : 100}, 
									{dataIndex : 'DIV_CODE',										width : 100,										hidden : true}, 
									{dataIndex : 'INOUT_CODE',										width : 120,										hidden : true}, 
									{dataIndex : 'INOUT_DATE',										width : 86,										hidden : true}, 
									{dataIndex : 'ITEM_STATUS',										width : 86,										hidden : true}, 
									{dataIndex : 'INOUT_TYPE',										width : 66,										hidden : true}, 
									{dataIndex : 'INOUT_METH',										width : 66,										hidden : true}, 
									{dataIndex : 'INOUT_TYPE_DETAIL',										width : 66,										hidden : true},
									{dataIndex : 'INOUT_CODE_TYPE',										width : 66,										hidden : true}, 
									{dataIndex : 'INOUT_P',										width : 100,										hidden : true}, 
									{dataIndex : 'INOUT_I',										width : 100,										hidden : true}, 
									{dataIndex : 'MONEY_UNIT',										width : 86,										hidden : true}, 
									{dataIndex : 'INOUT_FOR_P',										width : 100,										hidden : true}, 
									{dataIndex : 'INOUT_FOR_O',										width : 100,										hidden : true}, 
									{dataIndex : 'EXCHG_RATE_O',										width : 66,										hidden : true}, 
									{dataIndex : 'ORDER_UNIT',										width : 66,										hidden : true}, 
									{dataIndex : 'TRNS_RATE',										width : 66,										hidden : true}, 
									{dataIndex : 'ORDER_UNIT_Q',										width : 100,										hidden : true},
									{dataIndex : 'ORDER_UNIT_P',										width : 100,										hidden : true}, 
									{dataIndex : 'ORDER_UNIT_O',										width : 100,										hidden : true}, 
									{dataIndex : 'ORDER_UNIT_FOR_P',										width : 100,										hidden : true}, 
									{dataIndex : 'CREATE_LOC',										width : 66,										hidden : true}, 
									{dataIndex : 'SALE_C_YN',										width : 66,										hidden : true	}, 
									{dataIndex : 'SALE_DIV_CODE',										width : 66,										hidden : true}, 
									{dataIndex : 'SALE_CUSTOM_CODE',										width : 120,										hidden : true}, 
									{dataIndex : 'BILL_TYPE',										width : 66,										hidden : true}, 
									{dataIndex : 'SALE_TYPE',										width : 66,										hidden : true}, 
									{dataIndex : 'COMP_CODE',										width : 66,										hidden : true},
									{dataIndex : 'UPDATE_DB_USER',										width : 100,										hidden : true}, 
									{dataIndex : 'UPDATE_DB_TIME',										width : 100,										hidden : true},
									{dataIndex : 'PERSONS_NUM',										width : 120,										hidden : true}, 
									{dataIndex : 'WORK_TIME',										width : 66,										hidden : true}, 
									{dataIndex : 'GONG_SU',										width : 66,										hidden : true}, 
									{dataIndex : 'MAKER_TYPE',										width : 66,										hidden : true},
									{dataIndex : 'SET_TYPE',										width : 66,										hidden : true}, 
									{dataIndex : 'WORK_SHOP_CODE',										width : 86,										hidden : true}, 
									{dataIndex : 'REMARK',										width : 180,										editable : false}, 
									{dataIndex : 'OLD_INOUT_Q',										width : 100,										hidden : true}, 
									{dataIndex : 'INOUT_PRSN',										width : 86,										hidden : true	} 
									],
							listeners : {
								beforeedit : function(editor, e, eOpts) {
									if (e.record.phantom) {
										if (UniUtils.indexOf(e.field, [
												'WH_CODE', 'LOT_NO','WH_CELL_CODE', 'ITEM_CODE','ITEM_NAME' ])) {
											return true;
										} else {
											return false;
										}
									} else {
										return false;
									}
								}
							},
							setItemData : function(record, dataClear) {
								var grdRecord = this.getSelectedRecord();
								if (dataClear) {
									grdRecord.set('ITEM_CODE', '');
									grdRecord.set('ITEM_NAME', '');
									grdRecord.set('SPEC', '');
									grdRecord.set('STOCK_UNIT', '');
									grdRecord.set('WH_CODE', '');
									grdRecord.set('WH_CELL_CODE', '');
									grdRecord.set('WH_CELL_NAME', '');
									grdRecord.set('INOUT_P', '0');
									grdRecord.set('INOUT_I', '0');
									grdRecord.set('INOUT_FOR_P', '0');
									grdRecord.set('ORDER_UNIT_P', '0');
									grdRecord.set('ORDER_UNIT_O', '0');
									grdRecord.set('ORDER_UNIT_FOR_P', '0');
									grdRecord.set('CONST_Q', '0');
									grdRecord.set('INOUT_Q', '0');

									UniAppManager.app.fnGetAverageP(grdRecord)
									UniAppManager.app.setQtyChange(MasterStore2, panelResult2);

								} else {
									grdRecord.set('ITEM_CODE',record['ITEM_CODE']);
									grdRecord.set('ITEM_NAME',record['ITEM_NAME']);
									grdRecord.set('SPEC', record['SPEC']);
									grdRecord.set('STOCK_UNIT',record['STOCK_UNIT']);
									grdRecord.set('WH_CODE', record['WH_CODE']);
									grdRecord.set('WH_CELL_CODE',record['WH_CELL_CODE']);
									grdRecord.set('WH_CELL_NAME',record['WH_CELL_NAME']);

									UniAppManager.app.fnGetAverageP(grdRecord)
									UniAppManager.app.setQtyChange(MasterStore2, panelResult2);
								}
							},
							fnChildDataCreate : function() {
								var records = MasterStore2.data.items;
								Ext.each(records,function(record, i) {
													record.phantom = true;
													if (record.get("INOUT_NUM") == '') {
														record.set("INOUT_SEQ",i + 1);
														record.set("INOUT_Q",record.get("CONST_Q")* panelResult2.getValue("SET_QTY"))
													}
													record.set("DIV_CODE",panelResult2.getValue("DIV_CODE"));
													record.set("INOUT_DATE",panelResult2.getValue("CREATE_DATE"));

													var inoutQ = record.get("INOUT_Q");
													var inoutP = record.get("INOUT_P");
													record.set("ITEM_STATUS","1");
													record.set("INOUT_TYPE","1");
													record.set("INOUT_METH","2");
													record.set("INOUT_TYPE_DETAIL","98");
													record.set("INOUT_CODE_TYPE","*");
													record.set("INOUT_P",inoutP);
													record.set("INOUT_I",inoutP * inoutQ);
													record.set("MONEY_UNIT",BsaCodeInfo.gsMoneyUnit);
													record.set("INOUT_FOR_P",inoutP);
													record.set("INOUT_FOR_O",inoutP * inoutQ);
													record.set("EXCHG_RATE_O",1);
													record.set("ORDER_UNIT",record.get("STOCK_UNIT"));
													record.set("TRNS_RATE", 1);
													record.set("ORDER_UNIT_Q",inoutQ);
													record.set("ORDER_UNIT_P",inoutP);
													record.set("ORDER_UNIT_O",inoutP * inoutQ);
													record.set("ORDER_UNIT_FOR_P",inoutP);
													record.set("CREATE_LOC","1");
													record.set("SALE_C_YN","N");
													record.set("SALE_DIV_CODE","*");
													record.set("SALE_CUSTOM_CODE","*");
													//record.set("CUSTOM_CODE",Ext.getCmp('customCode').valueField.originalValue);
													record.set("BILL_TYPE","*");
													record.set("SALE_TYPE","*");

													if (Ext.isEmpty(BsaCodeInfo.gsDefaultWhCode)) {
														record.set("WH_CODE",panelResult2.getValue("WH_CODE"));
													} else {
														record.set("WH_CODE",BsaCodeInfo.gsDefaultWhCode);
													}
													if (Ext.isEmpty(BsaCodeInfo.gsDefaultWhCellCode)) {
														record.set("WH_CELL_CODE",panelResult2.getValue("WH_CELL_CODE"));
													} else {
														record.set("WH_CELL_CODE",BsaCodeInfo.gsDefaultWhCellCode);
													}

													record.set("PERSONS_NUM",panelResult2.getValue("PERSONS_NUM") ? panelResult2.getValue("PERSONS_NUM"): '0');
													record.set("WORK_TIME",panelResult2.getValue("WORK_TIME") ? panelResult2.getValue("WORK_TIME"): '0');
													record.set("GONG_SU",panelResult2.getValue("GONG_SU") ? panelResult2.getValue("GONG_SU"): '0');
													record.set("MAKER_TYPE",panelResult2.getValue("MAKER_TYPE"));
													record.set("SET_TYPE", "2");
													record.set("WORK_SHOP_CODE",'');
													record.set("REMARK",panelResult2.getValue("REMARK"));
													record.set("INOUT_PRSN",panelResult2.getValue("INOUT_PRSN"));

													var param = {
														'WH_CODE' : record.get("WH_CODE"),
														'ITEM_CODE' : record.get("ITEM_CODE"),
														'DIV_CODE' : record.get("DIV_CODE")
													}
													s_set210ukrv_kdService.selectStockQty(param,function(provider,response) {
																		if (provider) {
																			if (provider["GOOD_STOCK_Q"] > 0) {
																				record.set("CURRENT_STOCK",provider["GOOD_STOCK_Q"]);
																			}
																			if (BsaCodeInfo.gsSumTypeCell == "Y") {
																				record.set("LOT_NO",provider["LOT_NO"])
																			}
																		}
																	})
													UniAppManager.app.setQtyChange(MasterStore,panelResult);
													UniAppManager.setToolbarButtons([ 'save' ],true);
												});
								UniAppManager.app.setQtyChange(MasterStore2,panelResult2);
								UniAppManager.setToolbarButtons([ 'save' ],true);
							}
						});

		var workNoMasterGrid = Unilite.createGrid('workNoMasterGrid', { // 검색팝업창
			layout : 'fit',
			store : workNoMasterStore,
			uniOpt : {
				useRowNumberer : false,
				useLiveSearch : true,
				useGroupSummary : true,
				excel : {
					useExcel : true, //엑셀 다운로드 사용 여부
					exportGroup : true, //group 상태로 export 여부
					onlyData : false,
					summaryExport : true
				}
			},
			features : [ {
				id : 'masterGridSubTotal',
				ftype : 'uniGroupingsummary',
				showSummaryRow : false
			}, {
				id : 'masterGridTotal',
				ftype : 'uniSummary',
				showSummaryRow : false
			} ],
			columns : [ 
			    {dataIndex : 'DIV_CODE',				width : 100,				align : 'center'}, 
			    {dataIndex : 'INOUT_NUM',				width : 130}, 
			    {dataIndex : 'INOUT_SEQ',				width : 66,				hidden : true}, 
			    {dataIndex : 'INOUT_TYPE',				width : 80,				hidden : true}, 
			    {dataIndex : 'ITEM_CODE',				width : 120}, 
			    {dataIndex : 'ITEM_NAME',				width : 150}, 
			    {dataIndex : 'WH_CODE',				width : 100}, 
			    {dataIndex : 'WH_NAME',				width : 100,				hidden : true}, 
			    {dataIndex : 'WH_CELL_CODE',				width : 100,				hidden : BsaCodeInfo.gsSumTypeCell == "Y" ? false : true},
			    {dataIndex : 'WH_CELL_NAME',				width : 100,				hidden : true},
			    {dataIndex : 'INOUT_DATE',				width : 86,				align : 'center'},
			    {dataIndex : 'INOUT_Q',				width : 100,				hidden : true}, 
			    {dataIndex : 'PERSONS_NUM',				width : 86,				hidden : true}, 
			    {dataIndex : 'WORK_TIME',				width : 86,				hidden : true}, 
			    {dataIndex : 'GONG_SU',				width : 86,				hidden : true}, 
			    {dataIndex : 'MAKER_TYPE',				width : 86,				hidden : true}, 
			    {dataIndex : 'LOT_NO',				width : 120,				hidden : true}, 
			    {dataIndex : 'WORK_SHOP_CODE',				width : 120,				hidden : true}, 
			    {dataIndex : 'REMARK',				width : 150,				hidden : true}, 
			    {dataIndex : 'INOUT_P',				width : 100,				hidden : true},
			    {dataIndex : 'INOUT_I',				width : 100,				hidden : true}, 
			    {dataIndex : 'INOUT_PRSN',				width : 100} 
			    ],
			listeners : {
				onGridDblClick : function(grid, record, cellIndex, colName) {
					workNoMasterGrid.returnData(record);
					panelResult.setAllFieldsReadOnly(true)
					UniAppManager.app.onQueryButtonDown();
					SearchInfoWindow.hide();
				}
			},
			returnData : function(record) {
				if (Ext.isEmpty(record)) {
					record = this.getSelectedRecord();
				}

				panelResult.setValue('DIV_CODE', record.get('DIV_CODE'));
				panelResult.setValue('WORK_NUM', record.get('INOUT_NUM'));
				panelResult.setValue('ITEM_CODE', record.get('ITEM_CODE'));
				panelResult.setValue('ITEM_NAME', record.get('ITEM_NAME'));
				panelResult.setValue('WH_CODE', record.get('WH_CODE'));
				panelResult.setValue('WH_CELL_CODE', record.get('WH_CELL_CODE'));
				panelResult.setValue('SET_QTY', record.get('INOUT_Q'));
				panelResult.setValue('PERSONS_NUM',record.get('PERSONS_NUM') ? record.get('PERSONS_NUM'): 0);
				panelResult.setValue('WORK_TIME',record.get('WORK_TIME') ? record.get('WORK_TIME') : 0);
				panelResult.setValue('GONG_SU', record.get('GONG_SU') ? record.get('GONG_SU') : 0);
				panelResult.setValue('LOT_NO', record.get('LOT_NO'));
				panelResult.setValue('WH_CELL_NAME', record.get('WH_CELL_NAME'));
				panelResult.setValue('WORK_SHOP_CODE', record.get('WORK_SHOP_CODE'));
				panelResult.setValue('REMARK', record.get('REMARK'));
				panelResult.setValue('INOUT_P', record.get('INOUT_P'));
				panelResult.setValue('INOUT_I', record.get('INOUT_I'));
				panelResult.setValue('INOUT_PRSN', record.get('INOUT_PRSN'));
				panelResult.setValue('MAKE_TYPE', record.get('MAKE_TYPE'));
				panelResult.setValue('CREATE_DATE', record.get('INOUT_DATE'));
				UniAppManager.app.fnQryStockQty("1", panelResult)
			}
		});

		var workNoMasterGrid2 = Unilite.createGrid('workNoMasterGrid2', { // 검색팝업창
			layout : 'fit',
			store : workNoMasterStore2,
			uniOpt : {
				useRowNumberer : false,
				useLiveSearch : true,
				useGroupSummary : true,
				excel : {
					useExcel : true, //엑셀 다운로드 사용 여부
					exportGroup : true, //group 상태로 export 여부
					onlyData : false,
					summaryExport : true
				}
			},
			features : [ {
				id : 'masterGridSubTotal',
				ftype : 'uniGroupingsummary',
				showSummaryRow : false
			}, {
				id : 'masterGridTotal',
				ftype : 'uniSummary',
				showSummaryRow : false
			} ],
			columns : [ 
			   {dataIndex : 'DIV_CODE',				width : 100,				align : 'center'}, 
			   {dataIndex : 'INOUT_NUM',				width : 130}, {dataIndex : 'INOUT_SEQ',				width : 66,				hidden : true}, 
			   {dataIndex : 'INOUT_TYPE',				width : 80,				hidden : true}, 
			   {dataIndex : 'ITEM_CODE',				width : 120}, {dataIndex : 'ITEM_NAME',				width : 150}, 
			   {dataIndex : 'WH_CODE',				width : 100}, 
			   {dataIndex : 'WH_NAME',				width : 100,				hidden : true}, 
			   {dataIndex : 'WH_CELL_CODE',				width : 100,				hidden : BsaCodeInfo.gsSumTypeCell == "Y" ? false : true}, 
			   {dataIndex : 'WH_CELL_NAME',				width : 100,				hidden : true}, 
			   {dataIndex : 'INOUT_DATE',				width : 86,				align : 'center'}, 
			   {dataIndex : 'INOUT_Q',				width : 100,				hidden : true}, 
			   {dataIndex : 'PERSONS_NUM',				width : 86,				hidden : true}, 
			   {dataIndex : 'WORK_TIME',				width : 86,				hidden : true}, 
			   {dataIndex : 'GONG_SU',				width : 86,				hidden : true}, 
			   {dataIndex : 'MAKER_TYPE',				width : 86,				hidden : true}, 
			   {dataIndex : 'LOT_NO',				width : 120,				hidden : true}, 
			   {dataIndex : 'WORK_SHOP_CODE',				width : 120,				hidden : true}, 
			   {dataIndex : 'REMARK',				width : 150,				hidden : true}, 
			   {ataIndex : 'INOUT_P',				width : 100,				hidden : true}, 
			   {dataIndex : 'INOUT_I',				width : 100,				hidden : true}, 
			   {dataIndex : 'INOUT_PRSN',				width : 100} 
			   ],
			listeners : {
				onGridDblClick : function(grid, record, cellIndex, colName) {
					workNoMasterGrid2.returnData(record);
					panelResult2.setAllFieldsReadOnly(true)
					UniAppManager.app.onQueryButtonDown();
					SearchInfoWindow2.hide();
				}
			},
			returnData : function(record) {
				if (Ext.isEmpty(record)) {
					record = this.getSelectedRecord();
				}

				panelResult2.setValue('DIV_CODE', record.get('DIV_CODE'));
				panelResult2.setValue('WORK_NUM', record.get('INOUT_NUM'));
				panelResult2.setValue('ITEM_CODE', record.get('ITEM_CODE'));
				panelResult2.setValue('ITEM_NAME', record.get('ITEM_NAME'));
				panelResult2.setValue('WH_CODE', record.get('WH_CODE'));
				panelResult2.setValue('WH_CELL_CODE', record.get('WH_CELL_CODE'));
				panelResult2.setValue('SET_QTY', record.get('INOUT_Q'));
				panelResult2.setValue('PERSONS_NUM',record.get('PERSONS_NUM') ? record.get('PERSONS_NUM'): 0);
				panelResult2.setValue('WORK_TIME',record.get('WORK_TIME') ? record.get('WORK_TIME') : 0);
				panelResult2.setValue('GONG_SU', record.get('GONG_SU') ? record.get('GONG_SU') : 0);
				panelResult2.setValue('LOT_NO', record.get('LOT_NO'));
				panelResult2.setValue('WH_CELL_NAME', record.get('WH_CELL_NAME'));
				panelResult2.setValue('WORK_SHOP_CODE', record.get('WORK_SHOP_CODE'));
				panelResult2.setValue('REMARK', record.get('REMARK'));
				panelResult2.setValue('INOUT_P', record.get('INOUT_P'));
				panelResult2.setValue('INOUT_I', record.get('INOUT_I'));
				panelResult2.setValue('INOUT_PRSN', record.get('INOUT_PRSN'));
				panelResult2.setValue('MAKE_TYPE', record.get('MAKE_TYPE'));
				panelResult2.setValue('CREATE_DATE', record.get('INOUT_DATE'));
				UniAppManager.app.fnQryStockQty("1", panelResult2)
			}
		});

		function openSearchInfoWindow(grid) { // 검색팝업창
			if (!SearchInfoWindow) {
				SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
					title : 'SET품목제작번호 검색',
					width : 1080,
					height : 580,
					layout : {
						type : 'vbox',
						align : 'stretch'
					},
					items : [ workNoSearch, workNoMasterGrid ],
					tbar : [ '->', {
						itemId : 'saveBtn',
						text : '조회',
						handler : function() {
							workNoMasterStore.loadStoreRecords();
						},
						disabled : false
					}, 
					{
						itemId : 'closeBtn',
						text : '닫기',
						handler : function() {
							SearchInfoWindow.hide();
						},
						disabled : false
					} ],
					listeners : {
						beforehide : function(me, eOpt) {
						},
						beforeclose : function(panel, eOpts) {
						},
						show : function(panel, eOpts) {
							workNoSearch.setValue('DIV_CODE', panelResult.getValue('DIV_CODE'));
							workNoSearch.setValue('WORK_NUM', panelResult.getValue('WORK_NUM'));
							workNoSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
							workNoSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
							workNoSearch.setValue('WH_CODE', panelResult.getValue('WH_CODE'));
							workNoSearch.setValue('WH_CELL_CODE', panelResult.getValue('WH_CELL_CODE'));
							if (panelResult.getValue('CREATE_DATE')) {
								workNoSearch.setValue('CREATE_DATE_FR', UniDate.get('startOfMonth', panelResult.getValue('CREATE_DATE')));
								workNoSearch.setValue('CREATE_DATE_TO',panelResult.getValue('CREATE_DATE'));
							} else {
								workNoSearch.setValue('CREATE_DATE_FR', UniDate.get('startOfMonth'));
								workNoSearch.setValue('CREATE_DATE_TO', UniDate.get('today'));
							}
							workNoMasterStore.loadStoreRecords();
						}
					}
				})
			}
			SearchInfoWindow.show();
			SearchInfoWindow.center();
		}

		function openSearchInfoWindow2(grid) { // 검색팝업창
			if (!SearchInfoWindow2) {
				SearchInfoWindow2 = Ext.create('widget.uniDetailWindow',
								{
									title : 'SET품목제작번호 검색',
									width : 1080,
									height : 580,
									layout : {
										type : 'vbox',
										align : 'stretch'
									},
									items : [ workNoSearch2, workNoMasterGrid2 ],
									tbar : [
											'->',
											{
												itemId : 'saveBtn',
												text : '조회',
												handler : function() {
													workNoMasterStore2.loadStoreRecords();
												},
												disabled : false
											}, {
												itemId : 'closeBtn',
												text : '닫기',
												handler : function() {
													SearchInfoWindow2.hide();
												},
												disabled : false
											} ],
									listeners : {
										beforehide : function(me, eOpt) {
										},
										beforeclose : function(panel, eOpts) {
										},
										show : function(panel, eOpts) {
											workNoSearch2.setValue('DIV_CODE',panelResult2.getValue('DIV_CODE'));
											workNoSearch2.setValue('WORK_NUM',panelResult2.getValue('WORK_NUM'));
											workNoSearch2.setValue('ITEM_CODE',panelResult2.getValue('ITEM_CODE'));
											workNoSearch2.setValue('ITEM_NAME',panelResult2.getValue('ITEM_NAME'));
											workNoSearch2.setValue('WH_CODE',panelResult2.getValue('WH_CODE'));
											workNoSearch2.setValue('WH_CELL_CODE',panelResult2.getValue('WH_CELL_CODE'));
											if (panelResult2.getValue('CREATE_DATE')) {
												workNoSearch2.setValue('CREATE_DATE_FR',UniDate.get('startOfMonth',panelResult2.getValue('CREATE_DATE')));
												workNoSearch2.setValue('CREATE_DATE_TO',panelResult2.getValue('CREATE_DATE'));
											} else {
												workNoSearch2.setValue('CREATE_DATE_FR',UniDate.get('startOfMonth'));
												workNoSearch2.setValue('CREATE_DATE_TO',UniDate.get('today'));
											}
											workNoMasterStore2.loadStoreRecords();
										}
									}
								})
			}
			SearchInfoWindow2.show();
			SearchInfoWindow2.center();
		}

		var tab = Unilite.createTabPanel('tabPanel', {
			activeTab : 0,
			region : 'center',
			items : [ {
				title : 'SET품목제작',
				xtype : 'container',
				layout : {
					type : 'vbox',
					align : 'stretch'
				},
				items : [ panelResult, MasterGrid ],
				id : 's_set210ukrv_kdGridTab'
			}, {
				title : 'SET품목분해',
				xtype : 'container',
				layout : {
					type : 'vbox',
					align : 'stretch'
				},
				items : [ panelResult2, MasterGrid2 ],
				id : 's_set210ukrv_kdGridTab2'
			} ],
			listeners : {
				tabChange : function(tabPanel, newCard, oldCard, eOpts) {
					var activeTabId = tabPanel.getActiveTab().getId();
					if (activeTabId == 's_set210ukrv_kdGridTab') {
						UniAppManager.setToolbarButtons([ 'newData' ], true);
						UniAppManager.setToolbarButtons([ 'save' ], false);
						UniAppManager.app.onResetButtonDown()
					} else {
						UniAppManager.setToolbarButtons([ 'newData' ], false);
						UniAppManager.setToolbarButtons([ 'save' ], false);
						UniAppManager.app.onResetButtonDown()
					}

				}
			}
		});

		Unilite.Main({
					borderItems : [ {
						region : 'center',
						layout : 'border',
						border : false,
						items : [ tab ]
					} ],
					id : 's_set210ukrv_kdApp',
					fnInitBinding : function() {
						var activeTabId = tab.getActiveTab().getId();
						if (activeTabId == 's_set210ukrv_kdGridTab') {
							UniAppManager.setToolbarButtons([ 'reset','newData', 'prev', 'next' ], true);
							panelResult.setValue('DIV_CODE', UserInfo.divCode);
							panelResult.setValue('CREATE_DATE', UniDate.get("today"));
						} else {
							UniAppManager.setToolbarButtons([ 'reset', 'prev','next' ], true);
							panelResult2.setValue('DIV_CODE', UserInfo.divCode);
							panelResult2.setValue('CREATE_DATE', UniDate.get("today"));
						}
					},
					onQueryButtonDown : function() {
						var activeTabId = tab.getActiveTab().getId();
						if (activeTabId == 's_set210ukrv_kdGridTab') {
							var inoutNo = panelResult.getValue('WORK_NUM');
							if (Ext.isEmpty(inoutNo)) {
								openSearchInfoWindow(MasterGrid)
							} else {
								MasterGrid.getStore().loadStoreRecords("",function() {
													var records = MasterGrid.getStore().data.items;
													Ext.each(records,function(record,i) {
																		var param = {
																			'WH_CODE' : record.get("WH_CODE"),
																			'ITEM_CODE' : record.get("ITEM_CODE"),
																			'DIV_CODE' : record.get("DIV_CODE")
																		}
																		s_set210ukrv_kdService.selectStockQty(param,function(provider,response) {
																							if (provider) {
																								if (provider["GOOD_STOCK_Q"] > 0) {
																									record.set("CURRENT_STOCK",provider["GOOD_STOCK_Q"]);
																								}
																								//									if(BsaCodeInfo.gsSumTypeCell == "Y"){
																								//										record.set("LOT_NO", provider["LOT_NO"])
																								//									}
																							}
																						});
																	});
												});
							}
						} else {
							var inoutNo = panelResult2.getValue('WORK_NUM');
							if (Ext.isEmpty(inoutNo)) {
								openSearchInfoWindow2(MasterGrid2)
							} else {
								MasterGrid2.getStore().loadStoreRecords();
							}
						}
					},
					onNewDataButtonDown : function() {
						var activeTabId = tab.getActiveTab().getId();
						if (activeTabId == 's_set210ukrv_kdGridTab') {
							if (!panelResult.setAllFieldsReadOnly(true)) {
								return false;
							}
							var inoutNum = panelResult.getValue("WORK_NUM");
							var inoutSeq = !MasterStore.max('INOUT_SEQ') ? 1: MasterStore.max('INOUT_SEQ') + 1;
							var inoutQ = 1
							var divCode = panelResult.getValue("DIV_CODE");
							var inoutCode = panelResult.getValue("DIV_CODE");
							var inoutDate = panelResult.getValue("CREATE_DATE");
							var itemStatus = '1' //품목상태 : 양품
							var inoutType = '2' //수불타입 : 출고
							var inoutMeth = '2' //수불방법 : 예외(2)
							var inoutTypeDetail = '98'//수불유형 : SET상품
							var inoutCodeType = '*' //수불처구분 : 사업장
							var inoutP = '0';
							var inoutI = inoutQ * inoutP
							var moneyUnit = BsaCodeInfo.gsMoneyUnit
							var inoutForP = inoutP
							var inoutForO = inoutQ * inoutP
							var exchgRateO = '1'
							var transRate = 1
							var orderUnitQ = inoutQ
							var orderUnitP = inoutP
							var orderUnitO = inoutQ * inoutP
							var orderUnitForP = inoutP
							var createLoc = '1'
							var saleCYn = 'N'
							var saleDivCode = '*'
							var saleCustomCode = Ext.getCmp('customCode').valueField.originalValue
							var billType = '*'
							var saleType = '*'
							var whCode = panelResult.getValue("WH_CODE")
							if (BsaCodeInfo.gsDefaultWhCode) {
								whCode = BsaCodeInfo.gsDefaultWhCode
							}
							var whCellCode = panelResult.getValue("WH_CELL_CODE")
							if (BsaCodeInfo.gsDefaultWhCellCode) {
								whCellCode = BsaCodeInfo.gsDefaultWhCellCode
							}
							var personsNum = panelResult.getValue("PERSONS_NUM") ? panelResult.getValue("PERSONS_NUM") : '0'
							var workTime = panelResult.getValue("WORK_TIME") ? panelResult.getValue("WORK_TIME"): '0'
							var gongSu = panelResult.getValue("GONG_SU") ? panelResult.getValue("GONG_SU"): '0'
							var makeType = panelResult.getValue("MAKER_TYPE")
							var setType = '1' //SET구성
							var workShopCode = panelResult.getValue("WORK_SHOP_CODE")
							var remark = panelResult.getValue("REMARK")
							var inoutPrsn = panelResult.getValue("INOUT_PRSN")

							var r = {
								INOUT_NUM : inoutNum,
								INOUT_SEQ : inoutSeq,
								INOUT_Q : inoutQ,
								DIV_CODE : divCode,
								INOUT_CODE : inoutCode,
								INOUT_DATE : inoutDate,
								ITEM_STATUS : itemStatus,
								INOUT_TYPE : inoutType,
								INOUT_METH : inoutMeth,
								INOUT_TYPE_DETAIL : inoutTypeDetail,
								INOUT_CODE_TYPE : inoutCodeType,
								INOUT_P : inoutP,
								INOUT_I : inoutI,
								MONEY_UNIT : moneyUnit,
								INOUT_FOR_P : inoutForP,
								INOUT_FOR_O : inoutForO,
								EXCHG_RATE_O : exchgRateO,
								TRNS_RATE : transRate,
								ORDER_UNIT_Q : orderUnitQ,
								ORDER_UNIT_P : orderUnitP,
								ORDER_UNIT_O : orderUnitO,
								ORDER_UNIT_FOR_P : orderUnitForP,
								CREATE_LOC : createLoc,
								SALE_C_YN : saleCYn,
								SALE_DIV_CODE : saleDivCode,
								SALE_CUSTOM_CODE : saleCustomCode,
								BILL_TYPE : billType,
								SALE_TYPE : saleType,
								WH_CODE : whCode,
								WH_CELL_CODE : whCellCode,
								PERSONS_NUM : personsNum,
								WORK_TIME : workTime,
								GONG_SU : gongSu,
								MAKER_TYPE : makeType,
								SET_TYPE : setType,
								WORK_SHOP_CODE : workShopCode,
								REMARK : remark,
								INOUT_PRSN : inoutPrsn
							};
							//	            cbStore.loadStoreRecords(whCode);
							MasterGrid.createRow(r);
						} else {
							if (!panelResult2.setAllFieldsReadOnly(true)) {
								return false;
							}
							var inoutNum = panelResult.getValue("WORK_NUM");
							var inoutSeq = !MasterStore.max('INOUT_SEQ') ? 1: MasterStore.max('INOUT_SEQ') + 1;
							var inoutQ = 1
							if (!inoutNum || inoutNum == '') {
								inoutQ = panelResult.getValue("SET_QTY");
							}
							var divCode = panelResult.getValue("DIV_CODE");
							var inoutCode = panelResult.getValue("DIV_CODE");
							var inoutDate = panelResult.getValue("CREATE_DATE");
							var itemStatus = '1'
							var inoutType = '1'
							var inoutMeth = '2'
							var inoutTypeDetail = '98'
							var inoutCodeType = '*'
							var inoutP = '0';
							var inoutI = inoutQ * inoutP
							var moneyUnit = BsaCodeInfo.gsMoneyUnit
							var inoutForP = inoutP
							var inoutForO = inoutQ * inoutP
							var exchgRateO = '1'
							var transRate = 1
							var orderUnitQ = inoutQ
							var orderUnitP = inoutP
							var orderUnitO = inoutQ * inoutP
							var orderUnitForP = inoutP
							var createLoc = '1'
							var saleCYn = 'N'
							var saleDivCode = '*'
							var saleCustomCode = Ext.getCmp('customCode').valueField.originalValue
							var billType = '*'
							var saleType = '*'
							var whCode = panelResult.getValue("WH_CODE")
							if (BsaCodeInfo.gsDefaultWhCode) {
								whCode = BsaCodeInfo.gsDefaultWhCode
							}
							//			    var whCellCode      = panelResult.getValue("WH_CELL_CODE")
							//			    if(BsaCodeInfo.gsDefaultWhCellCode){
							//			    	whCellCode      = BsaCodeInfo.gsDefaultWhCellCode
							//			    }
							var personsNum = panelResult.getValue("PERSONS_NUM") ? panelResult.getValue("PERSONS_NUM") : '0'
							var workTime = panelResult.getValue("WORK_TIME") ? panelResult.getValue("WORK_TIME"): '0'
							var gongSu = panelResult.getValue("GONG_SU") ? panelResult.getValue("GONG_SU"): '0'
							var makeType = panelResult.getValue("MAKER_TYPE")
							var setType = '2'
							var workShopCode = panelResult.getValue("WORK_SHOP_CODE")
							var remark = panelResult.getValue("REMARK")
							var inoutPrsn = panelResult.getValue("INOUT_PRSN")

							var r = {
								INOUT_NUM : inoutNum,
								INOUT_SEQ : inoutSeq,
								INOUT_Q : inoutQ,
								DIV_CODE : divCode,
								INOUT_CODE : inoutCode,
								INOUT_DATE : inoutDate,
								ITEM_STATUS : itemStatus,
								INOUT_TYPE : inoutType,
								INOUT_METH : inoutMeth,
								INOUT_TYPE_DETAIL : inoutTypeDetail,
								INOUT_CODE_TYPE : inoutCodeType,
								INOUT_P : inoutP,
								INOUT_I : inoutI,
								MONEY_UNIT : moneyUnit,
								INOUT_FOR_P : inoutForP,
								INOUT_FOR_O : inoutForO,
								EXCHG_RATE_O : exchgRateO,
								TRNS_RATE : transRate,
								ORDER_UNIT_Q : orderUnitQ,
								ORDER_UNIT_P : orderUnitP,
								ORDER_UNIT_O : orderUnitO,
								ORDER_UNIT_FOR_P : orderUnitForP,
								CREATE_LOC : createLoc,
								SALE_C_YN : saleCYn,
								SALE_DIV_CODE : saleDivCode,
								SALE_CUSTOM_CODE : saleCustomCode,
								BILL_TYPE : billType,
								SALE_TYPE : saleType,
								WH_CODE : whCode,
								PERSONS_NUM : personsNum,
								WORK_TIME : workTime,
								GONG_SU : gongSu,
								MAKER_TYPE : makeType,
								SET_TYPE : setType,
								WORK_SHOP_CODE : workShopCode,
								REMARK : remark,
								INOUT_PRSN : inoutPrsn
							};
							MasterGrid2.createRow(r);
						}

					},
					onResetButtonDown : function() {

						panelResult.clearForm();
						panelResult.setAllFieldsReadOnly(false);
						panelResult2.clearForm();
						panelResult2.setAllFieldsReadOnly(false);

						MasterGrid.reset();
						MasterGrid2.reset();

						this.fnInitBinding();
						UniAppManager.setToolbarButtons('save', false);
					},
					onSaveDataButtonDown : function(config) {
						var activeTabId = tab.getActiveTab().getId();
						if (activeTabId == 's_set210ukrv_kdGridTab') {
							MasterStore.saveStore();
						} else {
							MasterStore2.saveStore();
						}
					},
					onDeleteDataButtonDown : function() {
						var activeTabId = tab.getActiveTab().getId();
						if (activeTabId == 's_set210ukrv_kdGridTab') {
							var selRow = MasterGrid.getSelectedRecord();
							if (selRow.phantom === true) {
								MasterGrid.deleteSelectedRow();
							} else if (confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
								MasterGrid.deleteSelectedRow();
							}
							UniAppManager.app.setQtyChange(MasterStore,panelResult);
						} else {
							var selRow = MasterGrid2.getSelectedRecord();
							if (selRow.phantom === true) {
								MasterGrid2.deleteSelectedRow();
							} else if (confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
								MasterGrid2.deleteSelectedRow();
							}
							UniAppManager.app.setQtyChange(MasterStore2,panelResult2);
						}
					},
					fnGetAverageP : function(record) {
						var param = {
							"DIV_CODE" : record.get("DIV_CODE"),
							"WH_CODE" : record.get("WH_CODE"),
							"ITEM_CODE" : record.get("ITEM_CODE"),
							"BASIS_YYYYMM" : panelResult.getValue("CREATE_DATE")
						}
						s_set210ukrv_kdService.selectAverageP(param,
										function(provider, response) {
											if (provider) {
												var inoutP = provider["AVERAGE_P"] ? provider["AVERAGE_P"]: 0
												var inoutQ = record.get("INOUT_Q") ? record.get("INOUT_Q"): 0

												record.set("INOUT_P", inoutP)
												record.set("INOUT_I", inoutP* inoutQ)
												record.set("INOUT_FOR_P",inoutP)
												record.set("INOUT_FOR_O",inoutP * inoutQ)
												record.set("EXCHG_RATE_O", 1)
												record.set("TRNS_RATE", 1)
												record.set("ORDER_UNIT_Q",inoutQ)
												record.set("ORDER_UNIT_P",inoutP)
												record.set("ORDER_UNIT_O",inoutQ * inoutP)
												record.set("ORDER_UNIT_FOR_P",inoutP)

												var activeTabId = tab.getActiveTab().getId();
												if (activeTabId == 's_set210ukrv_kdGridTab') {
													UniAppManager.app.setQtyChange(MasterStore,panelResult)
												} else {
													UniAppManager.app.setQtyChange(MasterStore2,panelResult2)
												}
											}
										});
					},
					setQtyChange : function(store, form) {
						var records = store.data.items;
						var intotP = 0
						var intotI = 0
						Ext.each(records, function(record, i) {

							var inoutP = record.get("INOUT_P")
							var inoutQ = record.get("INOUT_Q")

							record.set("INOUT_I", inoutP * inoutQ)
							record.set("INOUT_FOR_P", inoutP)
							record.set("INOUT_FOR_O", inoutP * inoutQ)
							record.set("ORDER_UNIT_Q", inoutQ)
							record.set("ORDER_UNIT_P", inoutP)
							record.set("ORDER_UNIT_O", inoutP * inoutQ)
							record.set("ORDER_UNIT_FOR_P", inoutP)

							intotP = intotP + inoutP;
							intotI = intotI + inoutP * inoutQ;
						});

						if (form.getValue("SET_QTY")) {
							form.setValue("INOUT_P", intotI/form.getValue("SET_QTY"))
							form.setValue("INOUT_I", intotI)
						} else {
							form.setValue("INOUT_P", "0")
							form.setValue("INOUT_I", "0")
						}
					},
					setQtyChange2 : function(record, form, value, columnName) {
						var records = MasterStore.data.items;
						var intotP = 0
						var intotI = 0
						var inoutQ = 0;
						var inoutP = 0;
						if (columnName == 'INOUT_Q') {
							inoutQ = value;
							inoutP = record.get('INOUT_P');
						}
						if (columnName == 'INOUT_P') {
							inoutQ = record.get('INOUT_Q');
							inoutP = value;
						}
						record.set("INOUT_I", inoutP * inoutQ)
						record.set("INOUT_FOR_P", inoutP)
						record.set("INOUT_FOR_O", inoutP * inoutQ)
						record.set("ORDER_UNIT_Q", inoutQ)
						record.set("ORDER_UNIT_P", inoutP)
						record.set("ORDER_UNIT_O", inoutP * inoutQ)
						record.set("ORDER_UNIT_FOR_P", inoutP)

						//확인 필요					
						Ext.each(records, function(record2, i) {
							var inoutPTemp = record2.get("INOUT_P");
							var inoutQTemp = record2.get("INOUT_Q");
							var inoutITemp = record2.get("INOUT_I");

							intotP = intotP + inoutPTemp;
							intotI = intotI + inoutITemp;
						});

						if (form.getValue("SET_QTY")) {
							form.setValue("INOUT_P", intotI/ form.getValue("SET_QTY"))
							form.setValue("INOUT_I", intotI)
						} else {
							form.setValue("INOUT_P", "0")
							form.setValue("INOUT_I", "0")
						}
					},
					fnQryStockQty : function(Opt, form) {
						if (form.getValue("WH_CODE") == ''|| form.getValue("ITEM_CODE") == '') {
							form.setValue("CURRENT_STOCK", '0');
							if (BsaCodeInfo.gsSumTypeCell == "Y") {
								form.setValue("LOT_NO", '');
							}
						} else {
							var param = {
								"DIV_CODE" : form.getValue("DIV_CODE"),
								"WH_CODE" : form.getValue("WH_CODE"),
								"WH_CELL_CODE" : form.getValue("WH_CELL_CODE"),
								"ITEM_CODE" : form.getValue("ITEM_CODE"),
								"gsSumTypeCell" : BsaCodeInfo.gsSumTypeCell
							}
							s_set210ukrv_kdService.selectStockQty(
											param,
											function(provider, response) {
												if (provider) {
													form.setValue("CURRENT_STOCK",provider["GOOD_STOCK_Q"]);
													if (BsaCodeInfo.gsSumTypeCell == "Y") {
														//							form.setValue("LOT_NO", provider["LOT_NO"]);
													}
												}
											});
						}
					}
				});

		Unilite.createValidator('validator01', {
			store : MasterStore,
			grid : MasterGrid,
			validate : function(type, fieldName, newValue, oldValue, record,eopt) {
				console.log('validate >>> ', {
					'type' : type,
					'fieldName' : fieldName,
					'newValue' : newValue,
					'oldValue' : oldValue,
					'record' : record
				});
				var rv = true;
				switch (fieldName) {
				case "CONST_Q": // 순번
					if (newValue < '1') {
						rv = Msg.sMB076;
						break;
					}
					record.set('INOUT_Q', panelResult.getValue("SET_QTY")* newValue);
					record.set('ORDER_UNIT_Q', panelResult.getValue("SET_QTY")* newValue);
					UniAppManager.app.setQtyChange2(record, panelResult)
					break;
				//구성품 총금액
//				case "SALE_AMT":
//					record.set('SALE_AMT', newValue);
//					UniAppManager.app.setQtyChange3(record, panelResult,
//							newValue, 'SALE_AMT');
//					break;
				case "INOUT_Q": // 소요량
					if (newValue < '1') {
						rv = Msg.sMB076;
						break;
					}
					record.set('ORDER_UNIT_Q', newValue);
					UniAppManager.app.setQtyChange2(record, panelResult,newValue, 'INOUT_Q');
					break;
				case "INOUT_P": // 단가
					if (newValue < '1') {
						rv = Msg.sMB076;
						break;
					}
					record.set('INOUT_I', record.get("INOUT_Q") * newValue);
					UniAppManager.app.setQtyChange2(record, panelResult,newValue, 'INOUT_P')
					break;
				case "WH_CODE": // 입고량
					if (newValue != '' && record.get("ITEM_CODE") != ''&& record.get("DIV_CODE") != '') {
						var param = {
							'WH_CODE' : newValue,
							'ITEM_CODE' : record.get("ITEM_CODE"),
							'DIV_CODE' : record.get("DIV_CODE"),
							'WH_CELL_CODE' : record.get("WH_CELL_CODE"),
							'gsSumTypeCell' : BsaCodeInfo.gsSumTypeCell
						}
						s_set210ukrv_kdService.selectStockQty(param, function(provider, response) {
							if (provider) {
								if (provider["GOOD_STOCK_Q"] > 0) {
									record.set("CURRENT_STOCK",provider["GOOD_STOCK_Q"]);
									UniAppManager.app.fnGetAverageP(record)
								}
								if (BsaCodeInfo.gsSumTypeCell == "Y") {
									record.set("LOT_NO", provider["LOT_NO"])
								}
							}
						});
					}
					//그리드 창고cell콤보 reLoad.. 
					//				cbStore.loadStoreRecords(newValue);
					break;
				}
				return rv;
			}
		});

		Unilite.createValidator('validator02', {
			store : MasterStore2,
			grid : MasterGrid2,
			validate : function(type, fieldName, newValue, oldValue, record,eopt) {
				console.log('validate >>> ', {
					'type' : type,
					'fieldName' : fieldName,
					'newValue' : newValue,
					'oldValue' : oldValue,
					'record' : record
				});
				var rv = true;
				switch (fieldName) {
				case "CONST_Q": // 순번
					if (newValue < '1') {
						rv = Msg.sMB076;
						break;
					}
					record.set('INOUT_Q', panelResult.getValue("SET_QTY")* newValue);
					record.set('ORDER_UNIT_Q', panelResult.getValue("SET_QTY")* newValue);
					UniAppManager.app.fnGetAverageP(record)
					break;
				case "WH_CODE": // 입고량
					UniAppManager.app.fnGetAverageP(record)
					//그리드 창고cell콤보 reLoad.. 
					//				cbStore.loadStoreRecords(newValue);
					break;
				}
				return rv;
			}
		});

		function setAllFieldsReadOnly(b) {
			var r = true
			if (b) {
				var invalid = this.getForm().getFields().filterBy(
						function(field) {
							return !field.validate();
						});

				if (invalid.length > 0) {
					r = false;
					var labelText = ''

					if (Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel'] + '은(는)';
					} else if (Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']
								+ '은(는)';
					}
					alert(labelText + Msg.sMB083);
					invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if (Ext.isDefined(item.holdable)) {
							if (item.holdable == 'hold') {
								item.setReadOnly(true);
							}
						}
						if (item.isPopupField) {
							var popupFC = item.up('uniPopupField');
							if (popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})
				}
			} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if (Ext.isDefined(item.holdable)) {
						if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
					if (item.isPopupField) {
						var popupFC = item.up('uniPopupField');
						if (popupFC.holdable == 'hold') {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}

		function getLotPopupEditor(gsSumTypeLot) {

			var editField;
			if (gsSumTypeLot == "Y") {
				editField = Unilite.popup('LOT_G',
						{
							textFieldName : 'LOT_NO',
							DBtextFieldName : 'LOT_NO',
							width : 1000,
							autoPopup : true,
							listeners : {
								'onSelected' : {
									fn : function(record, type) {
										var selectRec = MasterGrid.getSelectedRecord()
										if (selectRec) {
											selectRec.set('LOT_NO',record[0]["LOT_NO"]);
											selectRec.set('CURRENT_STOCK',record[0]["STOCK_Q"]);
										}
									},
									scope : this
								},
								'onClear' : {
									fn : function(record, type) {
										var selectRec = MasterGrid.getSelectedRecord()
										if (selectRec) {
											selectRec.set('LOT_NO', '');
											selectRec.set('CURRENT_STOCK', 0);
										}
									},
									scope : this
								},
								applyextparam : function(popup) {
									var selectRec = MasterGrid.getSelectedRecord();
									if (selectRec) {
										popup.setExtParam({
											'DIV_CODE' : selectRec.get('DIV_CODE')
										});
										popup.setExtParam({
											'ITEM_CODE' : selectRec.get('ITEM_CODE')
										});
										popup.setExtParam({
											'ITEM_NAME' : selectRec.get('ITEM_NAME')
										});
										popup.setExtParam({
											'WH_CODE' : selectRec.get('WH_CODE')
										});
										popup.setExtParam({
											'WH_CELL_CODE' : selectRec.get('WH_CELL_CODE')
										});
										popup.setExtParam({
											'LOT_NO' : selectRec.get('LOT_NO')
										});
										popup.setExtParam({
											'stockYN' : 'Y'
										});
									}
								}
							}
						});
			} else if (gsSumTypeLot == "N") {
				editField = {
					xtype : 'textfield',
					maxLength : 20
				}
			}

			var editor = Ext.create('Ext.grid.CellEditor', {
				ptype : 'cellediting',
				clicksToEdit : 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수 
				autoCancel : false,
				selectOnFocus : true,
				field : editField
			});

			return editor;
		}

		function getLotPopupEditor2(gsSumTypeLot) {

			var editField;
			if (gsSumTypeLot == "Y") {
				editField = Unilite.popup('LOT_G',
						{
							textFieldName : 'LOT_NO',
							DBtextFieldName : 'LOT_NO',
							width : 1000,
							autoPopup : true,
							listeners : {
								'onSelected' : {
									fn : function(record, type) {
										var selectRec = MasterGrid2.getSelectedRecord()
										if (selectRec) {
											selectRec.set('LOT_NO',record[0]["LOT_NO"]);
											selectRec.set('CURRENT_STOCK',record[0]["STOCK_Q"]);
										}
									},
									scope : this
								},
								'onClear' : {
									fn : function(record, type) {
										var selectRec = MasterGrid2.getSelectedRecord()
										if (selectRec) {
											selectRec.set('LOT_NO', '');
											selectRec.set('CURRENT_STOCK', 0);
										}
									},
									scope : this
								},
								applyextparam : function(popup) {
									var selectRec = MasterGrid2.getSelectedRecord();
									if (selectRec) {
										popup.setExtParam({
											'DIV_CODE' : selectRec.get('DIV_CODE')
										});
										popup.setExtParam({
											'ITEM_CODE' : selectRec.get('ITEM_CODE')
										});
										popup.setExtParam({
											'ITEM_NAME' : selectRec.get('ITEM_NAME')
										});
										popup.setExtParam({
											'WH_CODE' : selectRec.get('WH_CODE')
										});
										popup.setExtParam({
											'WH_CELL_CODE' : selectRec.get('WH_CELL_CODE')
										});
										popup.setExtParam({
											'LOT_NO' : selectRec.get('LOT_NO')
										});
										popup.setExtParam({
											'stockYN' : 'Y'
										});
									}
								}
							}
						});
			} else if (gsSumTypeLot == "N") {
				editField = {
					xtype : 'textfield',
					maxLength : 20
				}
			}

			var editor = Ext.create('Ext.grid.CellEditor', {
				ptype : 'cellediting',
				clicksToEdit : 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수 
				autoCancel : false,
				selectOnFocus : true,
				field : editField
			});

			return editor;
		}
	}
</script>