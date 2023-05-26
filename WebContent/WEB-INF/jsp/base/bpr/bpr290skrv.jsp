<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr290skrv">
	<t:ExtComboStore comboType="BOR120" pgmId="bpr290skrv"/>				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B013" />	<!-- 구매단위(B013)   -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />	<!-- 품목계정(B020) -->
	<t:ExtComboStore comboType="AU" comboCode="B014" />	<!-- 조달구분(B014) -->
	<t:ExtComboStore comboType="AU" comboCode="B039" />	<!-- 출고방법(B039) -->
	<t:ExtComboStore comboType="AU" comboCode="M201" />	<!-- 구매담당자(추가)(M201)  -->
	<t:ExtComboStore comboType="AU" comboCode="B023" />	<!-- 실적입고방법(B023)  -->
	<t:ExtComboStore comboType="AU" comboCode="B061" />	<!-- 발주방침(B061)  -->
	<t:ExtComboStore comboType="AU" comboCode="B074" />	<!-- 양산구분(B074) -->
	<t:ExtComboStore comboType="AU" comboCode="B201" />	<!-- 배송구분(B201) -->
	<t:ExtComboStore comboType="AU" comboCode="B202" />	<!-- 저장구분(B202) -->
	<t:ExtComboStore comboType="AU" comboCode="B215" />	<!-- 저장방법(B215) -->
	<t:ExtComboStore comboType="AU" comboCode="B206" />	<!-- 주센터(B206) -->
	<t:ExtComboStore comboType="AU" comboCode="B205" />	<!-- 마감시간(B205) -->
	<t:ExtComboStore comboType="AU" comboCode="M001" />	<!-- 발주유형(다보정밀) - M001 -->
	<t:ExtComboStore comboType="AU" comboCode="ZB03" />	<!-- 매입유형(다보정밀) - ZB03 -->
	<t:ExtComboStore comboType="AU" comboCode="ZM07" />	<!-- 기간정책(다보정밀) - ZM07  -->
	<t:ExtComboStore comboType="AU" comboCode="B024" />	<!-- 창고/수불담당자(추가) - B024 -->
	<t:ExtComboStore comboType="AU" comboCode="B138" />	<!-- 포장형태(B138) -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="bpr290skrvLevel1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="bpr290skrvLevel2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="bpr290skrvLevel3Store" />
	<t:ExtComboStore items="${COMBO_WH_CELL_LIST}" storeId="whCellList" />
</t:appConfig>
<style type="text/css">
	.x-form-text-default.x-form-textarea {
	//line-height: 15px;
	min-height: 15px;
	}
</style>


<script type="text/javascript" >
function appMain() {

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bpr290skrvService.selectList'
		}
	});

	Unilite.defineModel('bpr290skrvModel', {
		fields: [
			  {name : 'HIS_ID'                      , text : ''                                                                                         , type : 'int'               , allowBlank : 'false'    }
			, {name : 'HIS_INSERT_DB_TIME'          , text : '<t:message code="system.label.base.changedatetime" default="변경시간"/>'                           , type : 'string'           , allowBlank : false    }
			, {name : 'HIS_STATUS'                  , text : '<t:message code="system.label.base.changestatus" default="변경"/>'                                , type : 'string'            , allowBlank : false    }
			, {name : 'USER_NAME'                   , text : '<t:message code="system.label.base.updateuser" default="수정자"/>'                        , type : 'string'                            }
			, {name : 'COMP_CODE'                   , text : '<t:message code="system.label.base.companycode" default="법인코드"/>'                         , type : 'string'                            }
			, {name : 'ITEM_CODE'                   , text : '<t:message code="system.label.base.itemcode" default="품목코드"/>'                            , type : 'string'                            }
			, {name : 'ITEM_NAME'                   , text : '<t:message code="system.label.base.itemname" default="품목명"/>'                             , type : 'string'                            }
			, {name : 'ITEM_NAME1'                  , text : '<t:message code="system.label.base.itemname" default="품목명"/>1'                                                                                         , type : 'string'                            }
			, {name : 'ITEM_NAME2'                  , text : '<t:message code="system.label.base.itemname" default="품목명"/>2'                                                                                         , type : 'string'                            }
			, {name : 'SPEC'                        , text : '<t:message code="system.label.base.spec" default="규격"/>'                                  , type : 'string'       }
			, {name : 'ITEM_LEVEL1'                 , text : '<t:message code="system.label.base.itemlevel1name" default="품목LEVEL1명"/>'                 , type : 'string'       , store : Ext.data.StoreManager.lookup('bpr290skrvLevel1Store')}  //20210817 수정
			, {name : 'ITEM_LEVEL2'                 , text : '<t:message code="system.label.base.itemlevel2name" default="품목LEVEL2명"/>'                 , type : 'string'       , store : Ext.data.StoreManager.lookup('bpr290skrvLevel2Store')}  //20210817 수정
			, {name : 'ITEM_LEVEL3'                 , text : '<t:message code="system.label.base.itemlevel3name" default="품목LEVEL3명"/>'                 , type : 'string'       , store : Ext.data.StoreManager.lookup('bpr290skrvLevel3Store')}  //20210817 수정
			, {name : 'STOCK_UNIT'                  , text : '<t:message code="system.label.base.inventoryunit" default="재고단위"/>'                       , type : 'string'                            }
			, {name : 'UNIT_WGT'                    , text : '<t:message code="system.label.base.unitweight" default="단위중량"/>'                          , type : 'uniQty'                         }
			, {name : 'WGT_UNIT'                    , text : '<t:message code="system.label.base.weightunit" default="중량단위"/>'                          , type : 'string'                            }
			, {name : 'PIC_FLAG'                    , text : '<t:message code="system.label.base.photoflag" default="사진유무"/>'                           , type : 'string'                            }
			, {name : 'START_DATE'                  , text : '<t:message code="system.label.base.usestartdate" default="사용시작일"/>'                       , type : 'string'                            }
			, {name : 'STOP_DATE'                   , text : '<t:message code="system.label.base.usestopdate" default="사용중단일"/>'                        , type : 'string'                            }
			, {name : 'USE_YN'                      , text : '<t:message code="system.label.base.useflag" default="사용유무"/>'                             , type : 'string'                            }
			, {name : 'SPEC_NUM'                    , text : '<t:message code="system.label.base.drawingnumber" default="도면번호"/>'                       , type : 'string'                            }
			, {name : 'ITEM_MAKER'                  , text : '<t:message code="system.label.base.mfgmaker" default="제조메이커"/>'                           , type : 'string'                            }
			, {name : 'ITEM_MAKER_PN'               , text : ''                                                                                         , type : 'string'                            }
			, {name : 'HS_NO'                       , text : ''                                                                                         , type : 'string'                            }
			, {name : 'HS_NAME'                     , text : ''                                                                                         , type : 'string'                            }
			, {name : 'HS_UNIT'                     , text : ''                                                                                         , type : 'string'                            }
			, {name : 'ITEM_GROUP'                  , text : '<t:message code="system.label.base.repmodel" default="대표모델"/>'                            , type : 'string'                            }
			, {name : 'ITEM_COLOR'                  , text : ''                                                                                         , type : 'string'                            }
			, {name : 'ITEM_SIZE'                   , text : '<t:message code="system.label.base.size" default="사이즈"/>'                                 , type : 'string'                            }
			, {name : 'BARCODE'                     , text : '<t:message code="system.label.base.barcode" default="바코드"/>'                              , type : 'string'                            }
			, {name : 'SALE_UNIT'                   , text : '<t:message code="system.label.base.salesunit" default="판매단위"/>'                           , type : 'string'                            }
			, {name : 'TRNS_RATE'                   , text : '<t:message code="system.label.base.conversioncoeff2" default="변환계수(입수)"/>'               , type: 'float'	, decimalPrecision:4	, format:'0,000.0000'	                        }
			, {name : 'TAX_TYPE'                    , text : '<t:message code="system.label.base.taxtype" default="세구분"/>'                              , type : 'string'                            }
			, {name : 'SALE_BASIS_P'                , text : '<t:message code="system.label.base.commansalesprice" default="공통판매단가"/>'                  , type : 'uniUnitPrice'                         }
			, {name : 'DOM_FORIGN'                  , text : '<t:message code="system.label.common.domesticoverseasclass" default="국내외구분"/>'            , type : 'string'                            }
			, {name : 'STOCK_CARE_YN'               , text : '<t:message code="system.label.common.inventorymanagementyn" default="재고관리여부"/>'           , type : 'string'                            }
			, {name : 'TOTAL_ITEM'                  , text : '<t:message code="system.label.base.summaryitemcode2" default="집계품목"/>'                    , type : 'string'                            }
			, {name : 'TOTAL_TRAN_RATE'             , text : '<t:message code="system.label.base.summaryexchangefactor" default="집계환산계수"/>'             , type : 'uniUnitPrice'                         }
			, {name : 'EXCESS_RATE'                 , text : '<t:message code="system.label.base.overissuerate" default="과출고허용율"/>'                     , type : 'uniPercent'                         }
			, {name : 'USE_BY_DATE'                 , text : ''                                                                                         , type : 'int'                         }
			, {name : 'CIR_PERIOD_YN'               , text : ''                                                                                         , type : 'string'                            }
			, {name : 'REMARK1'                     , text : ''                                                                                         , type : 'string'                            }
			, {name : 'REMARK2'                     , text : ''                                                                                         , type : 'string'                            }
			, {name : 'REMARK3'                     , text : ''                                                                                         , type : 'string'                            }
			, {name : 'AS_BASIS_P'                  , text : ''                                                                                         , type : 'uniPrice'                         }
			, {name : 'SQUARE_FT'                   , text : ''                                                                                         , type : 'float'       , decimalPrecision:4, format:'0,000.0000'                  }
			, {name : 'PPC'                         , text : ''                                                                                         , type : 'float'       , decimalPrecision:4, format:'0,000.0000'                 }
			, {name : 'CBM'                         , text : ''                                                                                         , type : 'float'       , decimalPrecision:4, format:'0,000.0000'                  }
			, {name : 'WIDTH'                       , text : ''                                                                                         , type : 'float'       , decimalPrecision:4, format:'0,000.0000'                  }
			, {name : 'HEIGHT'                      , text : ''                                                                                         , type : 'float'       , decimalPrecision:4, format:'0,000.0000'                  }
			, {name : 'THICK'                       , text : ''                                                                                         , type : 'float'       , decimalPrecision:4, format:'0,000.0000'                  }
			, {name : 'GRAVITY'                     , text : ''                                                                                         , type : 'float'       , decimalPrecision:4, format:'0,000.0000'                  }
			, {name : 'ITEM_TYPE'                   , text : ''                                                                                         , type : 'string'                            }
			, {name : 'AUTO_FLAG'                   , text : ''                                                                                         , type : 'string'                            }
			, {name : 'UNIT_VOL'                    , text : '<t:message code="system.label.base.unitvolumn" default="단위부피"/>'                          , type : 'uniQty'                         }
			, {name : 'VOL_UNIT'                    , text : '<t:message code="system.label.base.volumnunit" default="부피단위"/>'                          , type : 'string'                            }
			, {name : 'REIM'                        , text : '<t:message code="system.label.base.gravity" default="비중"/>'                               , type : 'uniQty'                         }
			, {name : 'BIG_BOX_BARCODE'             , text : ''                                                                                         , type : 'string'                            }
			, {name : 'SMALL_BOX_BARCODE'           , text : ''                                                                                         , type : 'string'                            }
			, {name : 'ORDER_ITEM_YN'               , text : ''                                                                                         , type : 'string'                            }
			, {name : 'IMAGE_FID'                   , text : ''                                                                                         , type : 'string'                            }
			, {name : 'CAR_TYPE'                    , text : ''                                                                                         , type : 'string'                            }
			, {name : 'OEM_ITEM_CODE'               , text : ''                                                                                         , type : 'string'                            }
			, {name : 'B_OUT_YN'                    , text : ''                                                                                         , type : 'string'                            }
			, {name : 'B_OUT_DATE'                  , text : ''                                                                                         , type : 'string'                            }
			, {name : 'MAKE_STOP_YN'                , text : ''                                                                                         , type : 'string'                            }
			, {name : 'MAKE_STOP_DATE'              , text : ''                                                                                         , type : 'string'                            }
			, {name : 'ITEM_WIDTH'                  , text : '<t:message code="system.label.base.width" default="폭"/>'                                  , type : 'int'                         }
			, {name : 'ITEM_MODEL'                  , text : '<t:message code="system.label.base.model" default="모델"/>'                                 , type : 'string'                            }
			, {name : 'EXPIRATION_DAY'              , text : ''                                                                                         , type : 'int'                         }
			, {name : 'MAKE_NATION'                 , text : ''                                                                                         , type : 'string'                            }
			, {name : 'REGISTER_NO'                 , text : ''                                                                                         , type : 'string'                            }
			, {name : 'REGISTER_IMAGE'              , text : ''                                                                                         , type : 'string'                            }
			, {name : 'PACKING_SHAPE'               , text : ''                                                                                         , type : 'string'                            }
			, {name : 'PACKING_TYPE'                , text : ''                                                                                         , type : 'string'                            }
			, {name : 'DAY_QTY'                     , text : ''                                                                                         , type : 'uniQty'                         }
			, {name : 'EACH_QTY'                    , text : ''                                                                                         , type : 'int'                         }
			, {name : 'EACH_UNIT'                   , text : ''                                                                                         , type : 'string'                            }
			, {name : 'CONTENT_QTY'                 , text : ''                                                                                         , type : 'int'                         }
			, {name : 'ITEM_FLAVOR'                 , text : ''                                                                                         , type : 'string'                            }
			, {name : 'ITEM_FEATURE'                , text : ''                                                                                         , type : 'string'                            }
			, {name : 'MAKER_NAME'                  , text : ''                                                                                         , type : 'string'                            }
			, {name : 'SALE_NATION'                 , text : ''                                                                                         , type : 'string'                            }
			, {name : 'SALE_NAME'                   , text : ''                                                                                         , type : 'string'                            }
			, {name : 'UNIT_Q'                      , text : ''                                                                                         , type : 'uniQty'                         }
			, {name : 'RECOMMAND_EAT'               , text : ''                                                                                         , type : 'string'                            }
			
		]
	});

	var masterStore = Unilite.createStore('bpr290skrvMasterStore',{
		model	: 'bpr290skrvModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});



	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bpr290skrvService.selectList2'
		}
	});

	Unilite.defineModel('bpr290skrvModel2', {
		fields: [
		      {name : 'HIS_ID'                      , text : 'ID'                                                                                        , type : 'int'               , allowBlank : false    }
			, {name : 'HIS_INSERT_DB_TIME'          , text : '<t:message code="system.label.base.changedatetime" default="변경시간"/>'                           , type : 'string'           , allowBlank : false    }
			, {name : 'HIS_STATUS'                  , text : '<t:message code="system.label.base.changestatus" default="변경"/>'                                , type : 'string'            , allowBlank : false    }
			, {name : 'USER_NAME'                   , text : '<t:message code="system.label.base.updateuser" default="수정자"/>'                        , type : 'string'                            }
			, {name : 'COMP_CODE'                   , text : '<t:message code="system.label.base.companycode" default="법인코드"/>'                        , type : 'string'                            }
			, {name : 'DIV_CODE'                    , text : '<t:message code="system.label.base.division" default="사업장"/>'                             , type : 'string'                            }
			, {name : 'ITEM_CODE'                   , text : '<t:message code="system.label.base.itemcode" default="품목코드"/>'                            , type : 'string'                            }
			, {name : 'ITEM_NAME'                   , text : '<t:message code="system.label.base.itemname" default="품목명"/>'                             , type : 'string'                            }
			, {name : 'ORDER_UNIT'                  , text : '<t:message code="system.label.base.purchaseunit" default="구매단위"/>'                        , type : 'string'            , comboType: 'AU', comboCode: 'B013'                }
			, {name : 'TRNS_RATE'                   , text : '구매 입수'                                                                                    , type: 'float'	, decimalPrecision:4	, format:'0,000.0000'                      }
			, {name : 'ITEM_ACCOUNT'                , text : '<t:message code="system.label.base.itemaccount" default="품목계정"/>'                         , type : 'string'             , comboType: 'AU', comboCode: 'B020'               }
			, {name : 'SUPPLY_TYPE'                 , text : '<t:message code="system.label.base.procurementclassification" default="조달구분"/>'           , type : 'string'             , comboType: 'AU', comboCode: 'B014'               }
			, {name : 'BASIS_P'                     , text : '<t:message code="system.label.base.basisinventoryprice" default="기준재고단가"/>'               , type : 'uniUnitPrice'                         }
			, {name : 'SAFE_STOCK_Q'                , text : '<t:message code="system.label.base.safetystockqty" default="안전재고량"/>'                     , type : 'uniQty'                         }
			, {name : 'EXPENSE_RATE'                , text : '<t:message code="system.label.base.importexpenserate" default="수입부대비용율"/>'                , type : 'uniPercent'                         }
			, {name : 'ROUT_TYPE'                   , text : '<t:message code="system.label.base.routingtype" default="공정구분"/>'                         , type : 'string'                            }
			, {name : 'WORK_SHOP_CODE'              , text : '<t:message code="system.label.base.mainworkcenter" default="주작업장"/>'                      , type : 'string'                            }
			, {name : 'OUT_METH'                    , text : '<t:message code="system.label.base.issuemethod" default="출고방법"/>'                         , type : 'string'             , comboType: 'AU', comboCode: 'B039'               }
			, {name : 'PURCH_LDTIME'                , text : '<t:message code="system.label.base.polt" default="발주 L/T"/>'                               , type : 'int'                         }
			, {name : 'PRODUCT_LDTIME'              , text : '<t:message code="system.label.base.mfglt" default="제조 L/T"/>'                              , type : 'int'                         }
			, {name : 'MINI_PURCH_Q'                , text : '<t:message code="system.label.base.minumunorderqty" default="최소발주량"/>'                    , type : 'uniQty'                         }
			, {name : 'WH_CODE'                     , text : '<t:message code="system.label.common.basiswarehouse" default="기준창고"/>'                    , type : 'string'                            }
			, {name : 'ABC_FLAG'                    , text : 'ABC 구분'                                                                                    , type : 'string'                            }
			, {name : 'CUSTOM_CODE'                 , text : '기준거래처'                                                                                    , type : 'string'                            }
			, {name : 'ORDER_PRSN'                  , text : '구매담당자'                                                                                    , type : 'string'             , comboType: 'AU', comboCode: 'M201'               }
			, {name : 'PURCHASE_BASE_P'             , text : '공통구매단가'                                                                                   , type : 'uniPrice'                         }
			, {name : 'COST_PRICE'                  , text : '<t:message code="system.label.base.cost" default="원가"/>'                                   , type : 'uniPrice'                         }
			, {name : 'COST_YN'                     , text : '원가반영여부'                                                                                   , type : 'string'                            }
			, {name : 'REAL_CARE_YN'                , text : '실사적용여부'                                                                                   , type : 'string'                            }
			, {name : 'REAL_CARE_PERIOD'            , text : '<t:message code="system.label.base.stockcountingcycel" default="실사주기"/>'                   , type : 'string'                            }
			, {name : 'ROP_YN'                      , text : 'ROP품목대상여부'                                                                                , type : 'string'                            }
			, {name : 'DAY_AVG_SPEND'               , text : '<t:message code="system.label.base.averageqty" default="일일평균소비량"/>'                       , type : 'uniQty'                         }
			, {name : 'ORDER_POINT'                 , text : '<t:message code="system.label.base.fixedorderqty" default="고정발주량"/>'                       , type : 'uniPrice'                         }
			, {name : 'ORDER_KIND'                  , text : '오더생성구분'                                                                                   , type : 'string'                            }
			, {name : 'EXCESS_RATE'                 , text : '<t:message code="system.label.base.overreceiptrate" default="과입고허용율"/>'                   , type : 'uniPercent'                         }
			, {name : 'RESULT_YN'                   , text : '<t:message code="system.label.base.resultsreceiptmethod" default="실적입고방법"/>'              , type : 'string'             , comboType: 'AU', comboCode: 'B023'               }
			, {name : 'LOCATION'                    , text : '<t:message code="system.label.base.location" default="Location"/>'                          , type : 'string'                            }
			, {name : 'ORDER_PLAN'                  , text : '<t:message code="system.label.base.popolicy" default="발주방침"/>'                            , type : 'string'              , comboType: 'AU', comboCode: 'B061'              }
			, {name : 'MATRL_PRESENT_DAY'           , text : '<t:message code="system.label.base.materialfixedperiod" default="자재올림기간"/>'               , type : 'int'                         }
			, {name : 'NEED_Q_PRESENT'              , text : '<t:message code="system.label.base.reqroundtype" default="소요량올림구분"/>'                     , type : 'string'                            }
			, {name : 'EXC_STOCK_CHECK_YN'          , text : '<t:message code="system.label.base.availableinventorycheckyn" default="가용재고체크여부"/>'       , type : 'string'                            }
			, {name : 'LOT_SIZING'                  , text : 'LOT SIZING'                                                                                 , type : 'string'                            }
			, {name : 'PRODT_PRESENT_DAY'           , text : '생산올림기간'                                                                                   , type : 'int'                         }
			, {name : 'LOT_SIZING_Q'                , text : '최소 LOT SIZING 수량'                                                                          , type : 'uniQty'                         }
			, {name : 'MINI_PACK_Q'                 , text : '최소 포장수량'                                                                                  , type : 'uniQty'                         }
			, {name : 'MINI_LOT_Q'                  , text : '최소 LOT'                                                                                     , type : 'uniQty'                         }
			, {name : 'MAX_PRODT_Q'                 , text : '<t:message code="system.label.base.maximumproductqty" default="최대생산량"/>'                  , type : 'uniQty'                         }
			, {name : 'STAN_PRODT_Q'                , text : '<t:message code="system.label.base.standardproductionqty" default="표준생산량"/>'              , type : 'uniQty'                         }
			, {name : 'INSTOCK_PLAN_Q'              , text : '<t:message code="system.label.base.receiptplannedqty" default="입고예정량"/>'                  , type : 'uniQty'                         }
			, {name : 'OUTSTOCK_Q'                  , text : '<t:message code="system.label.base.issueresevationqty" default="출고예정량"/>'                 , type : 'uniQty'                         }
			, {name : 'NEED_Q_PRESENT_Q'            , text : '<t:message code="system.label.base.reqroundcount" default="소요량올림수"/>'                     , type : 'uniQty'                         }
			, {name : 'MAX_PURCH_Q'                 , text : '<t:message code="system.label.base.maximumorderqty" default="최대발주량"/>'                    , type : 'uniQty'                         }
			, {name : 'DIST_LDTIME'                 , text : '재발주리드타임'                                                                                  , type : 'int'                         }
			, {name : 'BAD_RATE'                    , text : '불량률'                                                                                       , type : 'uniPercent'                         }
			, {name : 'ORDER_METH'                  , text : '<t:message code="system.label.base.productionmethod" default="생산방식"/>'                     , type : 'string'                            }
			, {name : 'ATP_LDTIME'                  , text : 'ATP 리드타임'                                                                                  , type : 'int'                         }
			, {name : 'INSPEC_YN'                   , text : '품질대상유무'                                                                                   , type : 'string'                            }
			, {name : 'INSPEC_METH_MATRL'           , text : '<t:message code="system.label.base.importinspectionmethod" default="수입검사방법"/>'            , type : 'string'                            }
			, {name : 'INSPEC_METH_PROG'            , text : '<t:message code="system.label.base.routinginspemethod" default="공정검사방법"/>'                , type : 'string'                            }
			, {name : 'INSPEC_METH_PRODT'           , text : '<t:message code="system.label.base.shipmentinspectionmethod" default="출하검사방법"/>'          , type : 'string'                            }
			, {name : 'ITEM_TYPE'                   , text : '<t:message code="system.label.base.productiontype" default="양산구분"/>'                      , type : 'string'                 , comboType: 'AU', comboCode: 'B074'           }
			, {name : 'DELIVE_GUBUN'                , text : '배송구분'                                                                                     , type : 'string'                 , comboType: 'AU', comboCode: 'B201'           }
			, {name : 'CREATE_DATE'                 , text : '등록일자'                                                                                     , type : 'string'                            }
			, {name : 'ITEM_GUBUN'                  , text : '저장구분'                                                                                     , type : 'string'                 , comboType: 'AU', comboCode: 'B202'           }
			, {name : 'STOCK_TYPE'                  , text : '저장방법'                                                                                     , type : 'string'                 , comboType: 'AU', comboCode: 'B215'           }
			, {name : 'MAIN_CENTER'                 , text : '주센터'                                                                                      , type : 'string'                  , comboType: 'AU', comboCode: 'B206'          }
			, {name : 'LEGAL_TXT_RATE'              , text : '의제세율'                                                                                     , type : 'uniPercent'                         }
			, {name : 'LEGAL_DATE_FR'               , text : '의제세율시작일'                                                                                  , type : 'string'                            }
			, {name : 'LEGAL_DATE_TO'               , text : '의제세율종료일'                                                                                  , type : 'string'                            }
			, {name : 'UOM_UNIT'                    , text : 'UOM단위'                                                                                    , type : 'string'                            }
			, {name : 'UOM_RATE'                    , text : 'UOM입수'                                                                                    , type: 'float'	, decimalPrecision:4	, format:'0,000.0000'                     }
			, {name : 'MARK_UP'                     , text : '마크업'                                                                                      , type : 'int'                         }
			, {name : 'BUY_RATE'                    , text : '<t:message code="system.label.base.purchasereceiptcount" default="구매입수"/>'                , type: 'float'	, decimalPrecision:4	, format:'0,000.0000'                       }
			, {name : 'BUY_CUSTOM'                  , text : '구매처코드'                                                                                    , type : 'string'                            }
			, {name : 'ORIGIN_AREA'                 , text : '수입원'                                                                                      , type : 'string'                            }
			, {name : 'PROD_AREA'                   , text : '생산지'                                                                                      , type : 'string'                            }
			, {name : 'NATIVE_YN'                   , text : '원산지관리여부'                                                                                  , type : 'string'                            }
			, {name : 'NATIVE_AREA'                 , text : '원산지'                                                                                      , type : 'string'                            }
			, {name : 'NEAR_YN'                     , text : '구매처계근여부'                                                                                  , type : 'string'                            }
			, {name : 'REMARK_AREA'                 , text : '비고(원산지)'                                                                                  , type : 'string'                            }
			, {name : 'TOTAL_WGT'                   , text : '총중량'                                                                                      , type : 'uniQty'                         }
			, {name : 'REALIN_YN'                   , text : '실수량확인'                                                                                    , type : 'string'                            }
			, {name : 'DELIVE_LDTIME'               , text : '배송리드타임'                                                                                   , type : 'int'                         }
			, {name : 'CLOSE_TIME_CODE'             , text : '마감시간'                                                                                     , type : 'string'              , comboType: 'AU', comboCode: 'B205'              }
			, {name : 'MON_YN'                      , text : '주문가능요일(월)'                                                                                , type : 'string'                            }
			, {name : 'TUE_YN'                      , text : '주문가능요일(화)'                                                                                , type : 'string'                            }
			, {name : 'WED_YN'                      , text : '주문가능요일(수)'                                                                                , type : 'string'                            }
			, {name : 'THU_YN'                      , text : '주문가능요일(목)'                                                                                , type : 'string'                            }
			, {name : 'FRI_YN'                      , text : '주문가능요일(금)'                                                                                , type : 'string'                            }
			, {name : 'SAT_YN'                      , text : '주문가능요일(툐)'                                                                                , type : 'string'                            }
			, {name : 'SUN_YN'                      , text : '주문가능요일(일)'                                                                                , type : 'string'                            }
			, {name : 'BL_NUM'                      , text : 'BL번호'                                                                                     , type : 'string'                            }
			, {name : 'PRICE_GROUP'                 , text : '그룹단가'                                                                                     , type : 'string'                            }
			, {name : 'COMMITEM_YN'                 , text : '범용품목여부'                                                                                   , type : 'string'                            }
			, {name : 'PO_TYPE'                     , text : '발주유형(다보정밀) - M001'                                                                        , type : 'string'         , comboType: 'AU', comboCode: 'M001'                   }
			, {name : 'ROPS_YN'                     , text : 'ROPS 여부(Y/N)(다보정밀)'                                                                       , type : 'string'                            }
			, {name : 'PROC_TYPE'                   , text : '매입유형(다보정밀) - ZB03'                                                                        , type : 'string'          , comboType: 'AU', comboCode: 'ZB03'                  }
			, {name : 'PRE_LDTIME'                  , text : '선행일수(다보정밀)'                                                                               , type : 'int'                         }
			, {name : 'TIME_ZONE'                   , text : '기간정책(다보정밀) - ZM07'                                                                        , type : 'string'           , comboType: 'AU', comboCode: 'ZM07'                 }
			, {name : 'WH_PRSN'                     , text : '창고/수불담당자(추가) - B024'                                                                      , type : 'string'           , comboType: 'AU', comboCode: 'B024'                 }
			, {name : 'CP_DISTR_MAT_YN'             , text : '원가CostPool적용-재료비배부여부'                                                                     , type : 'string'                            }
			, {name : 'CP_DISTR_YN'                 , text : '원가CostPool적용-가공비배부여부'                                                                     , type : 'string'                            }
			, {name : 'DISTR_TYPE'                  , text : '원가CostPool적용-집계기준(CostPool기준/품목기준)'                                                       , type : 'string'                            }
			, {name : 'LOSS_DISTR_YN'               , text : '원가CostPool적용-LOSS금액배부여부'                                                                  , type : 'string'                            }
			, {name : 'LLC_COST_TYPE'               , text : '원가CostPool적용-적상시적용단가(1:기초단가/2:생산단가/3:출고단가)'                                               , type : 'string'                            }
			, {name : 'COST_REF_YN'                 , text : '원가CostPool적용-재료비계산시단가사용여부'                                                                , type : 'string'                            }
			, {name : 'LAST_PRODT_YN'               , text : '원가CostPool적용-CP최종생산품목여부'                                                                  , type : 'string'                            }
			, {name : 'BIN_FLOOR'                   , text : '서가진열장단번호'                                                                                 , type : 'string'                            }
			, {name : 'SMALL_TRNS_RATE'             , text : '변환계수(소박스입수)'                                                                              , type: 'float'	, decimalPrecision:4	, format:'0,000.0000'                        }
			, {name : 'CONSIGNMENT_FEE'             , text : '위탁수수료'                                                                                    , type : 'uniPrice'                         }
			//, {name : 'BIG_BOX_BARCODE'             , text : ''                                                                                         , type : 'string'                            }
			, {name : 'SMALL_BOX_BARCODE'           , text : '소박스바코드'                                                                                   , type : 'string'                            }
			//, {name : 'BARCODE'                     , text : ''                                                                                         , type : 'string'                            }
			, {name : 'BIN_NUM'                     , text : '진열대코드'                                                                                    , type : 'string'                            }
			, {name : 'MEMBER_DISCOUNT_YN'          , text : '회원할인여부'                                                                                   , type : 'string'                            }
			, {name : 'PROMO_YYYY'                  , text : '프로모션행사년도'                                                                                 , type : 'string'                            }
			, {name : 'PROMO_CD'                    , text : '프로모션코드'                                                                                   , type : 'string'                            }
			, {name : 'MIX_MATCH_TYPE'              , text : '프로모션품목매치타입'                                                                               , type : 'string'                            }
			, {name : 'FIRST_PURCHASE_DATE'         , text : '최초구매일'                                                                                    , type : 'string'                            }
			, {name : 'LAST_PURCHASE_DATE'          , text : '최종구매일'                                                                                    , type : 'string'                            }
			, {name : 'FIRST_SALES_DATE'            , text : '최초판매일'                                                                                    , type : 'string'                            }
			, {name : 'LAST_SALES_DATE'             , text : '최종판매일'                                                                                    , type : 'string'                            }
			, {name : 'LAST_RETURN_DATE'            , text : '최종반품일'                                                                                    , type : 'string'                            }
			, {name : 'LAST_DELIVERY_DATE'          , text : '최종납품일'                                                                                    , type : 'string'                            }
			, {name : 'LAST_DELIVERY_CUSTOM'        , text : '종납품처'                                                                                     , type : 'string'                            }
			, {name : 'K_PRINTER'                   , text : '주방프린터코드'                                                                                  , type : 'string'                            }
			, {name : 'LOT_YN'                      , text : 'LOT관리 여부'                                                                                 , type : 'string'                            }
			, {name : 'PHANTOM_YN'                  , text : '팬텀관리 여부'                                                                                  , type : 'string'                            }
			, {name : 'IF_SEND_DATETIME'            , text : '송신일(2013-12-05 추가(Lee Soo-yong))'                                                         , type : 'uniDate'                           }
			, {name : 'IF_RECV_DATETIME'            , text : '수신일(2013-12-05 추가(Lee Soo-yong))'                                                         , type : 'uniDate'                           }
			, {name : 'PRODT_RATE'                  , text : '수율'                                                                                       , type : 'uniPercent'                         }
			, {name : 'PACK_QTY'                    , text : '포장단위'                                                                                     , type : 'uniQty'                         }
			, {name : 'CERT_TYPE'                   , text : '<t:message code="system.label.common.certtype" default="인증구분"/>'                          , type : 'string'                            }
			, {name : 'ARRAY_CNT'                   , text : '<t:message code="system.label.base.arraycount" default="배열수"/>'                           , type : 'uniQty'                         }
			, {name : 'MAN_HOUR'                    , text : '<t:message code="system.label.base.standardtacttime" default="표준공수"/>'                    , type : 'uniER'                         }
			//, {name : 'PROD_DATE'                   , text : ''                                                                                         , type : 'string'                            }
			//, {name : 'PACK_TYPE'                   , text : ''                                                                                         , type : 'string'          , comboType: 'AU', comboCode: 'B138'                  }
			, {name : 'KEEP_TEMPER'                 , text : ''                                                                                         , type : 'string'                            }
			, {name : 'CARE_YN'                     , text : '관리대상품목'                                                                                   , type : 'string'                            }
			, {name : 'CARE_REASON'                 , text : '사유'                                                                                       , type : 'string'                            }
			//, {name : 'INSERT_APPR_TYPE'            , text : ''                                                                                         , type : 'string'                            }
			//, {name : 'FORM_TYPE'                   , text : ''                                                                                         , type : 'string'                            }
			//, {name : 'COATING'                     , text : ''                                                                                         , type : 'string'                            }
			//, {name : 'GOLD_WIRE'                   , text : ''                                                                                         , type : 'string'                            }
			//, {name : 'RISK_GRADE'                  , text : ''                                                                                         , type : 'string'                            }
			//, {name : 'UPN_CODE'                    , text : ''                                                                                         , type : 'string'                            }
			//, {name : 'INSERT_APPR_CODE'            , text : ''                                                                                         , type : 'string'                            }
			//, {name : 'BARE_CODE'                   , text : ''                                                                                         , type : 'string'                            }
			//, {name : 'WH_CELL_CODE'                , text : ''                                                                                         , type : 'string'                            }
			
		]
	});
	
	var masterStore2 = Unilite.createStore('bpr290skrvMasterStore',{
		model	: 'bpr290skrvModel2',
		proxy	: directProxy2,
		autoLoad: false,
		uniOpt	: {
			isMaster	: false,		// 상위 버튼 연결
			editable	: false,		// 수정 모드 사용
			deletable	: false,		// 삭제 가능 여부
			useNavi		: false		// prev | next 버튼 사용
		},
		loadStoreRecords : function() {
			var param= Ext.getCmp('resultForm').getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});



	var panelResult = Unilite.createSearchForm('resultForm',{
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel		: '<t:message code="system.label.base.updatedate" default="수정일"/>',
			xtype			: 'uniDateRangefield',
			startFieldName	: 'HIS_INSERT_DB_TIME_FR',
			endFieldName	: 'HIS_INSERT_DB_TIME_TO',
			labelWidth		: 90,
			startDate		: UniDate.get('aMonthAgo'),
			endDate			: UniDate.get('today'),
			allowBlank		: false
		},
		Unilite.popup('ITEM', {
			validateBlank	: false,			//20210817 추가
			listeners		: {
				//20210817 수정: 조회조건 팝업설정에 맞게 변경
				onValueFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('ITEM_CODE', '');
					}
				}
			}
		})]
	});

	var masterGrid = Unilite.createGrid('bpr290skrvGrid', {
		store	: masterStore,
		region	: 'center',
		flex	: 1,
		sortableColumns : true,
		split	: true,
		uniOpt	:{
			onLoadSelectFirst	: true,
			expandLastColumn	: false,
			useRowNumberer		: false,
			dblClickToEdit		: false,
			useMultipleSorting	: true,
			copiedRow			: true
		},
		columns:[
			  {dataIndex : 'HIS_ID'                           , hidden : true                   , width : 80  }
			, {dataIndex : 'HIS_INSERT_DB_TIME'                                                 , width : 110 }
			, {dataIndex : 'HIS_STATUS'                                                         , width : 80  }
			, {dataIndex : 'USER_NAME'                                                          , width : 80  }
			, {dataIndex : 'ITEM_CODE'                                                          , width : 100 }
			, {dataIndex : 'ITEM_NAME'                                                          , width : 150 }
			, {dataIndex : 'ITEM_NAME1'                       , hidden : true                   , width : 150 }
			, {dataIndex : 'ITEM_NAME2'                       , hidden : true                   , width : 150 }
			, {dataIndex : 'SPEC'                                                               , width : 150 }
			, {dataIndex : 'ITEM_LEVEL1'                                                        , width : 100 }
			, {dataIndex : 'ITEM_LEVEL2'                                                        , width : 100 }
			, {dataIndex : 'ITEM_LEVEL3'                                                        , width : 100 }
			, {dataIndex : 'STOCK_UNIT'                                                         , width : 80  }
			, {dataIndex : 'UNIT_WGT'                                                           , width : 80  }
			, {dataIndex : 'WGT_UNIT'                                                           , width : 80  }
			, {dataIndex : 'PIC_FLAG'                                                           , width : 80  }
			, {dataIndex : 'START_DATE'                                                         , width : 80  }
			, {dataIndex : 'STOP_DATE'                                                          , width : 80  }
			, {dataIndex : 'USE_YN'                                                             , width : 80  }
			, {dataIndex : 'SPEC_NUM'                                                           , width : 100 }
			, {dataIndex : 'ITEM_MAKER'                                                         , width : 150 }
			, {dataIndex : 'ITEM_MAKER_PN'                    , hidden : true                   , width : 150 }
			, {dataIndex : 'HS_NO'                            , hidden : true                   , width : 100 }
			, {dataIndex : 'HS_NAME'                          , hidden : true                   , width : 150 }
			, {dataIndex : 'HS_UNIT'                          , hidden : true                   , width : 80  }
			, {dataIndex : 'ITEM_GROUP'                                                         , width : 100 }
			, {dataIndex : 'ITEM_COLOR'                       , hidden : true                   , width : 100 }
			, {dataIndex : 'ITEM_SIZE'                                                          , width : 150 }
			, {dataIndex : 'BARCODE'                                                            , width : 100 }
			, {dataIndex : 'SALE_UNIT'                                                          , width : 80  }
			, {dataIndex : 'TRNS_RATE'                                                          , width : 120 }
			, {dataIndex : 'TAX_TYPE'                                                           , width : 80  }
			, {dataIndex : 'SALE_BASIS_P'                                                       , width : 110 }
			, {dataIndex : 'DOM_FORIGN'                                                         , width : 80  }
			, {dataIndex : 'STOCK_CARE_YN'                                                      , width : 100 }
			, {dataIndex : 'TOTAL_ITEM'                                                         , width : 100 }
			, {dataIndex : 'TOTAL_TRAN_RATE'                                                    , width : 110 }
			, {dataIndex : 'EXCESS_RATE'                                                        , width : 110 }
			, {dataIndex : 'USE_BY_DATE'                      , hidden : true                   , width : 80  }
			, {dataIndex : 'CIR_PERIOD_YN'                    , hidden : true                   , width : 80  }
			, {dataIndex : 'REMARK1'                          , hidden : true                   , width : 150 }
			, {dataIndex : 'REMARK2'                          , hidden : true                   , width : 150 }
			, {dataIndex : 'REMARK3'                          , hidden : true                   , width : 150 }
			, {dataIndex : 'AS_BASIS_P'                       , hidden : true                   , width : 80  }
			, {dataIndex : 'SQUARE_FT'                        , hidden : true                   , width : 80  }
			, {dataIndex : 'PPC'                              , hidden : true                   , width : 80  }
			, {dataIndex : 'CBM'                              , hidden : true                   , width : 80  }
			, {dataIndex : 'WIDTH'                            , hidden : true                   , width : 80  }
			, {dataIndex : 'HEIGHT'                           , hidden : true                   , width : 80  }
			, {dataIndex : 'THICK'                            , hidden : true                   , width : 80  }
			, {dataIndex : 'GRAVITY'                          , hidden : true                   , width : 80  }
			, {dataIndex : 'ITEM_TYPE'                        , hidden : true                   , width : 80  }
			, {dataIndex : 'AUTO_FLAG'                        , hidden : true                   , width : 80  }
			, {dataIndex : 'UNIT_VOL'                                                           , width : 80  }
			, {dataIndex : 'VOL_UNIT'                                                           , width : 80  }
			, {dataIndex : 'REIM'                                                               , width : 80  }
			, {dataIndex : 'BIG_BOX_BARCODE'                  , hidden : true                   , width : 100 }
			, {dataIndex : 'SMALL_BOX_BARCODE'                , hidden : true                   , width : 100 }
			, {dataIndex : 'ORDER_ITEM_YN'                    , hidden : true                   , width : 100 }
			, {dataIndex : 'IMAGE_FID'                        , hidden : true                   , width : 150 }
			, {dataIndex : 'CAR_TYPE'                         , hidden : true                   , width : 80  }
			, {dataIndex : 'OEM_ITEM_CODE'                    , hidden : true                   , width : 100 }
			, {dataIndex : 'B_OUT_YN'                         , hidden : true                   , width : 80  }
			, {dataIndex : 'B_OUT_DATE'                       , hidden : true                   , width : 80  }
			, {dataIndex : 'MAKE_STOP_YN'                     , hidden : true                   , width : 80  }
			, {dataIndex : 'MAKE_STOP_DATE'                   , hidden : true                   , width : 80  }
			, {dataIndex : 'ITEM_WIDTH'                                                         , width : 80  }
			, {dataIndex : 'ITEM_MODEL'                                                         , width : 150 }
			, {dataIndex : 'EXPIRATION_DAY'                   , hidden : true                   , width : 80  }
			, {dataIndex : 'MAKE_NATION'                      , hidden : true                   , width : 80  }
			, {dataIndex : 'REGISTER_NO'                      , hidden : true                   , width : 100 }
			, {dataIndex : 'REGISTER_IMAGE'                   , hidden : true                   , width : 80  }
			, {dataIndex : 'PACKING_SHAPE'                    , hidden : true                   , width : 80  }
			, {dataIndex : 'PACKING_TYPE'                     , hidden : true                   , width : 80  }
			, {dataIndex : 'DAY_QTY'                          , hidden : true                   , width : 80  }
			, {dataIndex : 'EACH_QTY'                         , hidden : true                   , width : 80  }
			, {dataIndex : 'EACH_UNIT'                        , hidden : true                   , width : 80  }
			, {dataIndex : 'CONTENT_QTY'                      , hidden : true                   , width : 80  }
			, {dataIndex : 'ITEM_FLAVOR'                      , hidden : true                   , width : 100 }
			, {dataIndex : 'ITEM_FEATURE'                     , hidden : true                   , width : 150 }
			, {dataIndex : 'MAKER_NAME'                       , hidden : true                   , width : 100 }
			, {dataIndex : 'SALE_NATION'                      , hidden : true                   , width : 100 }
			, {dataIndex : 'SALE_NAME'                        , hidden : true                   , width : 100 }
			, {dataIndex : 'UNIT_Q'                           , hidden : true                   , width : 80  }
			, {dataIndex : 'RECOMMAND_EAT'                    , hidden : true                   , width : 150 }
		]
	});

	var masterGrid2 = Unilite.createGrid('bpr290skrvGrid2', {
		store	: masterStore2,
		region	: 'south',
		flex	: 1,
		sortableColumns : true,
		split	: true,
		uniOpt	:{
			onLoadSelectFirst	: true,
			expandLastColumn	: false,
			useRowNumberer		: false,
			dblClickToEdit		: false,
			useMultipleSorting	: true,
			copiedRow			: true
		},
		columns:[
			  {dataIndex : 'HIS_ID'                           , hidden : true                   , width : 80  }
			, {dataIndex : 'HIS_INSERT_DB_TIME'                                                 , width : 110 }
			, {dataIndex : 'HIS_STATUS'                                                         , width : 80  }
			, {dataIndex : 'USER_NAME'                                                          , width : 80  }
			, {dataIndex : 'DIV_CODE'                                                           , width : 80  }
			, {dataIndex : 'ITEM_CODE'                                                          , width : 100 }
			, {dataIndex : 'ITEM_NAME'                                                          , width : 150 }
			, {dataIndex : 'ORDER_UNIT'                                                         , width : 80  }
			, {dataIndex : 'TRNS_RATE'                        , hidden : true                   , width : 80  }
			, {dataIndex : 'ITEM_ACCOUNT'                                                       , width : 80  }
			, {dataIndex : 'SUPPLY_TYPE'                                                        , width : 80  }
			, {dataIndex : 'BASIS_P'                                                            , width : 110 }
			, {dataIndex : 'SAFE_STOCK_Q'                                                       , width : 100 }
			, {dataIndex : 'EXPENSE_RATE'                                                       , width : 125 }
			, {dataIndex : 'ROUT_TYPE'                                                          , width : 80  }
			, {dataIndex : 'WORK_SHOP_CODE'                                                     , width : 80  }
			, {dataIndex : 'OUT_METH'                                                           , width : 80  }
			, {dataIndex : 'PURCH_LDTIME'                                                       , width : 80  }
			, {dataIndex : 'PRODUCT_LDTIME'                                                     , width : 80  }
			, {dataIndex : 'MINI_PURCH_Q'                                                       , width : 100 }
			, {dataIndex : 'WH_CODE'                                                            , width : 80  }
			, {dataIndex : 'ABC_FLAG'                         , hidden : true                   , width : 80  }
			, {dataIndex : 'CUSTOM_CODE'                      , hidden : true                   , width : 80  }
			, {dataIndex : 'ORDER_PRSN'                       , hidden : true                   , width : 80  }
			, {dataIndex : 'PURCHASE_BASE_P'                  , hidden : true                   , width : 80  }
			, {dataIndex : 'COST_PRICE'                                                         , width : 80  }
			, {dataIndex : 'COST_YN'                          , hidden : true                   , width : 80  }
			, {dataIndex : 'REAL_CARE_YN'                     , hidden : true                   , width : 80  }
			, {dataIndex : 'REAL_CARE_PERIOD'                                                   , width : 80  }
			, {dataIndex : 'ROP_YN'                           , hidden : true                   , width : 80  }
			, {dataIndex : 'DAY_AVG_SPEND'                                                      , width : 110 }
			, {dataIndex : 'ORDER_POINT'                                                        , width : 100 }
			, {dataIndex : 'ORDER_KIND'                       , hidden : true                   , width : 80  }
			, {dataIndex : 'EXCESS_RATE'                                                        , width : 110 }
			, {dataIndex : 'RESULT_YN'                                                          , width : 110 }
			, {dataIndex : 'LOCATION'                                                           , width : 100 }
			, {dataIndex : 'ORDER_PLAN'                                                         , width : 80  }
			, {dataIndex : 'MATRL_PRESENT_DAY'                                                  , width : 110 }
			, {dataIndex : 'NEED_Q_PRESENT'                                                     , width : 120 }
			, {dataIndex : 'EXC_STOCK_CHECK_YN'                                                 , width : 130 }
			, {dataIndex : 'LOT_SIZING'                       , hidden : true                   , width : 80  }
			, {dataIndex : 'PRODT_PRESENT_DAY'                , hidden : true                   , width : 80  }
			, {dataIndex : 'LOT_SIZING_Q'                     , hidden : true                   , width : 80  }
			, {dataIndex : 'MINI_PACK_Q'                      , hidden : true                   , width : 80  }
			, {dataIndex : 'MINI_LOT_Q'                       , hidden : true                   , width : 80  }
			, {dataIndex : 'MAX_PRODT_Q'                                                        , width : 100 }
			, {dataIndex : 'STAN_PRODT_Q'                                                       , width : 100 }
			, {dataIndex : 'INSTOCK_PLAN_Q'                                                     , width : 100 }
			, {dataIndex : 'OUTSTOCK_Q'                                                         , width : 100 }
			, {dataIndex : 'NEED_Q_PRESENT_Q'                                                   , width : 110 }
			, {dataIndex : 'MAX_PURCH_Q'                                                        , width : 100 }
			, {dataIndex : 'DIST_LDTIME'                      , hidden : true                   , width : 80  }
			, {dataIndex : 'BAD_RATE'                         , hidden : true                   , width : 80  }
			, {dataIndex : 'ORDER_METH'                                                         , width : 110 }
			, {dataIndex : 'ATP_LDTIME'                       , hidden : true                   , width : 80  }
			, {dataIndex : 'INSPEC_YN'                        , hidden : true                   , width : 80  }
			, {dataIndex : 'INSPEC_METH_MATRL'                                                  , width : 110 }
			, {dataIndex : 'INSPEC_METH_PROG'                                                   , width : 110 }
			, {dataIndex : 'INSPEC_METH_PRODT'                                                  , width : 110 }
			, {dataIndex : 'ITEM_TYPE'                                                          , width : 80  }
			, {dataIndex : 'DELIVE_GUBUN'                     , hidden : true                   , width : 80  }
			, {dataIndex : 'CREATE_DATE'                      , hidden : true                   , width : 80  }
			, {dataIndex : 'ITEM_GUBUN'                       , hidden : true                   , width : 80  }
			, {dataIndex : 'STOCK_TYPE'                       , hidden : true                   , width : 80  }
			, {dataIndex : 'MAIN_CENTER'                      , hidden : true                   , width : 80  }
			, {dataIndex : 'LEGAL_TXT_RATE'                   , hidden : true                   , width : 80  }
			, {dataIndex : 'LEGAL_DATE_FR'                    , hidden : true                   , width : 80  }
			, {dataIndex : 'LEGAL_DATE_TO'                    , hidden : true                   , width : 80  }
			, {dataIndex : 'UOM_UNIT'                         , hidden : true                   , width : 80  }
			, {dataIndex : 'UOM_RATE'                         , hidden : true                   , width : 80  }
			, {dataIndex : 'MARK_UP'                          , hidden : true                   , width : 80  }
			, {dataIndex : 'BUY_RATE'                                                           , width : 80  }
			, {dataIndex : 'BUY_CUSTOM'                       , hidden : true                   , width : 80  }
			, {dataIndex : 'ORIGIN_AREA'                      , hidden : true                   , width : 150 }
			, {dataIndex : 'PROD_AREA'                        , hidden : true                   , width : 150 }
			, {dataIndex : 'NATIVE_YN'                        , hidden : true                   , width : 80  }
			, {dataIndex : 'NATIVE_AREA'                      , hidden : true                   , width : 150 }
			, {dataIndex : 'NEAR_YN'                          , hidden : true                   , width : 80  }
			, {dataIndex : 'REMARK_AREA'                      , hidden : true                   , width : 150 }
			, {dataIndex : 'TOTAL_WGT'                        , hidden : true                   , width : 80  }
			, {dataIndex : 'REALIN_YN'                        , hidden : true                   , width : 80  }
			, {dataIndex : 'DELIVE_LDTIME'                    , hidden : true                   , width : 80  }
			, {dataIndex : 'CLOSE_TIME_CODE'                  , hidden : true                   , width : 80  }
			, {dataIndex : 'MON_YN'                           , hidden : true                   , width : 80  }
			, {dataIndex : 'TUE_YN'                           , hidden : true                   , width : 80  }
			, {dataIndex : 'WED_YN'                           , hidden : true                   , width : 80  }
			, {dataIndex : 'THU_YN'                           , hidden : true                   , width : 80  }
			, {dataIndex : 'FRI_YN'                           , hidden : true                   , width : 80  }
			, {dataIndex : 'SAT_YN'                           , hidden : true                   , width : 80  }
			, {dataIndex : 'SUN_YN'                           , hidden : true                   , width : 80  }
			, {dataIndex : 'BL_NUM'                           , hidden : true                   , width : 100 }
			, {dataIndex : 'PRICE_GROUP'                      , hidden : true                   , width : 80  }
			, {dataIndex : 'COMMITEM_YN'                      , hidden : true                   , width : 80  }
			, {dataIndex : 'PO_TYPE'                          , hidden : true                   , width : 100 }
			, {dataIndex : 'ROPS_YN'                          , hidden : true                   , width : 80  }
			, {dataIndex : 'PROC_TYPE'                        , hidden : true                   , width : 100 }
			, {dataIndex : 'PRE_LDTIME'                       , hidden : true                   , width : 80  }
			, {dataIndex : 'TIME_ZONE'                        , hidden : true                   , width : 80  }
			, {dataIndex : 'WH_PRSN'                          , hidden : true                   , width : 100 }
			, {dataIndex : 'CP_DISTR_MAT_YN'                  , hidden : true                   , width : 80  }
			, {dataIndex : 'CP_DISTR_YN'                      , hidden : true                   , width : 80  }
			, {dataIndex : 'DISTR_TYPE'                       , hidden : true                   , width : 80  }
			, {dataIndex : 'LOSS_DISTR_YN'                    , hidden : true                   , width : 80  }
			, {dataIndex : 'LLC_COST_TYPE'                    , hidden : true                   , width : 80  }
			, {dataIndex : 'COST_REF_YN'                      , hidden : true                   , width : 80  }
			, {dataIndex : 'LAST_PRODT_YN'                    , hidden : true                   , width : 80  }
			, {dataIndex : 'BIN_FLOOR'                        , hidden : true                   , width : 80  }
			, {dataIndex : 'SMALL_TRNS_RATE'                  , hidden : true                   , width : 80  }
			, {dataIndex : 'CONSIGNMENT_FEE'                  , hidden : true                   , width : 80  }
			, {dataIndex : 'BIG_BOX_BARCODE'                  , hidden : true                   , width : 100 }
			, {dataIndex : 'SMALL_BOX_BARCODE'                , hidden : true                   , width : 100 }
			, {dataIndex : 'BARCODE'                          , hidden : true                   , width : 100 }
			, {dataIndex : 'BIN_NUM'                          , hidden : true                   , width : 100 }
			, {dataIndex : 'MEMBER_DISCOUNT_YN'               , hidden : true                   , width : 80  }
			, {dataIndex : 'PROMO_YYYY'                       , hidden : true                   , width : 80  }
			, {dataIndex : 'PROMO_CD'                         , hidden : true                   , width : 80  }
			, {dataIndex : 'MIX_MATCH_TYPE'                   , hidden : true                   , width : 80  }
			, {dataIndex : 'FIRST_PURCHASE_DATE'              , hidden : true                   , width : 80  }
			, {dataIndex : 'LAST_PURCHASE_DATE'               , hidden : true                   , width : 80  }
			, {dataIndex : 'FIRST_SALES_DATE'                 , hidden : true                   , width : 80  }
			, {dataIndex : 'LAST_SALES_DATE'                  , hidden : true                   , width : 80  }
			, {dataIndex : 'LAST_RETURN_DATE'                 , hidden : true                   , width : 80  }
			, {dataIndex : 'LAST_DELIVERY_DATE'               , hidden : true                   , width : 80  }
			, {dataIndex : 'LAST_DELIVERY_CUSTOM'             , hidden : true                   , width : 100 }
			, {dataIndex : 'K_PRINTER'                        , hidden : true                   , width : 80  }
			, {dataIndex : 'LOT_YN'                           , hidden : true                   , width : 80  }
			, {dataIndex : 'PHANTOM_YN'                       , hidden : true                   , width : 80  }
			, {dataIndex : 'IF_SEND_DATETIME'                 , hidden : true                   , width : 80  }
			, {dataIndex : 'IF_RECV_DATETIME'                 , hidden : true                   , width : 80  }
			, {dataIndex : 'PRODT_RATE'                       , hidden : true                   , width : 80  }
			, {dataIndex : 'PACK_QTY'                         , hidden : true                   , width : 80  }
			, {dataIndex : 'CERT_TYPE'                                                          , width : 80  }
			, {dataIndex : 'ARRAY_CNT'                                                          , width : 80  }
			, {dataIndex : 'MAN_HOUR'                                                           , width : 80  }
//			, {dataIndex : 'PROD_DATE'                        , hidden : true                   , width : 80  }
//			, {dataIndex : 'PACK_TYPE'                        , hidden : true                   , width : 100 }
			, {dataIndex : 'KEEP_TEMPER'                      , hidden : true                   , width : 150 }
			, {dataIndex : 'CARE_YN'                          , hidden : true                   , width : 80  }
			, {dataIndex : 'CARE_REASON'                      , hidden : true                   , width : 150 }
//			, {dataIndex : 'INSERT_APPR_TYPE'                 , hidden : true                   , width : 100 }
//			, {dataIndex : 'FORM_TYPE'                        , hidden : true                   , width : 100 }
//			, {dataIndex : 'COATING'                          , hidden : true                   , width : 100 }
//			, {dataIndex : 'GOLD_WIRE'                        , hidden : true                   , width : 100 }
//			, {dataIndex : 'RISK_GRADE'                       , hidden : true                   , width : 100 }
//			, {dataIndex : 'UPN_CODE'                         , hidden : true                   , width : 150 }
//			, {dataIndex : 'INSERT_APPR_CODE'                 , hidden : true                   , width : 100 }
//			, {dataIndex : 'BARE_CODE'                        , hidden : true                   , width : 100 }
//			, {dataIndex : 'WH_CELL_CODE'                     , hidden : true                   , width : 100 }
		]
	});


	Unilite.Main({
		id			: 'bpr290skrvApp',
		borderItems : [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid, masterGrid2
			]
		}],
		fnInitBinding : function(params) {
			panelResult.setValue('HIS_INSERT_DB_TIME_FR', UniDate.get('aMonthAgo'))
			panelResult.setValue('HIS_INSERT_DB_TIME_TO', UniDate.get('today') )
			panelResult.onLoadSelectText('HIS_INSERT_DB_TIME_FR');
			UniAppManager.setToolbarButtons(['newData'],false);
		},
		onQueryButtonDown: function () {
			if(!this.isValidSearchForm()){
				return false;
			}
			masterStore.loadStoreRecords();
			masterStore2.loadStoreRecords();
		},
		onResetButtonDown:function() {
			panelResult.clearForm();
			
			//masterGrid.getStore().loadData({});
			masterGrid.reset();
			masterGrid.getStore().clearData();
			masterGrid2.reset();
			masterGrid2.getStore().clearData();
			this.fnInitBinding()
		}
	});
};
</script>