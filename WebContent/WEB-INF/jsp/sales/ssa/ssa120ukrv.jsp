<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ssa120ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!-- 영업담당 -->      
	<t:ExtComboStore comboType="BOR120"  pgmId="ssa120ukrv" /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!--지역-->
	<t:ExtComboStore comboType="AU" comboCode="S024" /> <!--부가세유형-->
	<t:ExtComboStore comboType="AU" comboCode="B059" /> <!--세구분-->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!--거래처분류-->
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당-->
	<t:ExtComboStore comboType="AU" comboCode="B116" /> <!--단가계산기준-->
	

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
	Unilite.defineModel('Ssa120ukrvModel', {		
	    fields: [{name: 'CHOICE'				,text: '<t:message code="system.label.sales.selection" default="선택"/>',			type: 'string'},
				 {name: 'SALE_CUSTOM_CODE'		,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>',		type: 'string'},
				 {name: 'SALE_CUSTOM_NAME'		,text: '<t:message code="system.label.sales.salesplace" default="매출처"/>', 			type: 'string'},
				 {name: 'BILL_TYPE'				,text: '<t:message code="system.label.sales.vattype" default="부가세유형"/>', 		type: 'string'},
				 {name: 'BILL_TYPE_NM'			,text: '<t:message code="system.label.sales.vattype" default="부가세유형"/>',		type: 'string'},
				 {name: 'SALE_DATE'				,text: '<t:message code="system.label.sales.salesdate" default="매출일"/>', 			type: 'uniDate'},
				 {name: 'ITEM_CODE'				,text: '<t:message code="system.label.sales.item" default="품목"/>', 		type: 'string'},
				 {name: 'ITEM_NAME'				,text: '<t:message code="system.label.sales.itemname" default="품목명"/>', 			type: 'string'},
				 {name: 'SPEC'					,text: '<t:message code="system.label.sales.spec" default="규격"/>', 			type: 'string'},
				 {name: 'SALE_UNIT'				,text: '<t:message code="system.label.sales.salesunit" default="판매단위"/>', 		type: 'string', displayField: 'value'},
				 {name: 'PRICE_TYPE'			,text: '단가기준', 		type: 'string'},
				 {name: 'PRICE_TYPE_NM'			,text: '단가기준', 		type: 'string'},
				 {name: 'MONEY_UNIT'			,text: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>', 		type: 'string',displayField: 'value'},
				 {name: 'TRANS_RATE'			,text: '<t:message code="system.label.sales.containedqty" default="입수"/>', 			type: 'string'},
				 {name: 'SALE_Q'				,text: '<t:message code="system.label.sales.salesqty" default="매출량"/>', 			type: 'uniQty'},
				 {name: 'SALE_P'				,text: '<t:message code="system.label.sales.price" default="단가"/>', 			type: 'uniUnitPrice'},
				 {name: 'SALE_WGT_Q'			,text: '매출량(중량)', 		type: 'uniQty'},
				 {name: 'SALE_FOR_WGT_P'		,text: '<t:message code="system.label.sales.priceweight" default="단가(중량)"/>', 		type: 'uniQty'},
				 {name: 'SALE_VOL_Q'			,text: '매출량(부피)', 		type: 'uniQty'},
				 {name: 'SALE_FOR_VOL_P'		,text: '<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>', 		type: 'uniUnitPrice'},
				 {name: 'SALE_AMT_O'			,text: '<t:message code="system.label.sales.amount" default="금액"/>', 			type: 'uniPrice'},
				 {name: 'TAX_TYPE'				,text: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>', 		type: 'string'},
				 {name: 'TAX_TYPE_NM'			,text: '<t:message code="system.label.sales.taxabledivision" default="과세구분"/>', 		type: 'string'},
				 {name: 'TAX_AMT_O'				,text: '<t:message code="system.label.sales.vatamount" default="부가세액"/>', 		type: 'uniPrice'},
				 {name: 'SALE_TOT_O'			,text: '<t:message code="system.label.sales.salestotalamount2" default="매출총액"/>', 		type: 'uniPrice'},
				 {name: 'WGT_UNIT'				,text: '<t:message code="system.label.sales.weightunit" default="중량단위"/>', 		type: 'string'},
				 {name: 'UNIT_WGT'				,text: '<t:message code="system.label.sales.unitweight" default="단위중량"/>', 		type: 'string'},
				 {name: 'VOL_UNIT'				,text: '<t:message code="system.label.sales.volumnunit" default="부피단위"/>', 		type: 'string'},
				 {name: 'UNIT_VOL'				,text: '<t:message code="system.label.sales.unitvolumn" default="단위부피"/>', 		type: 'string'},
				 {name: 'EXCHG_RATE_O'			,text: '<t:message code="system.label.sales.exchangerate" default="환율"/>', 			type: 'string'},
				 {name: 'SALE_WGT_P'			,text: '<t:message code="system.label.sales.coprice" default="자사단가"/>(<t:message code="system.label.sales.weight" default="중량"/>)', 	type: 'uniUnitPrice'},
				 {name: 'SALE_VOL_P'			,text: '<t:message code="system.label.sales.coprice" default="자사단가"/>(<t:message code="system.label.sales.volumn" default="부피"/>)', 	type: 'uniPrice'},
				 {name: 'SALE_LOC_AMT_I'		,text: '<t:message code="system.label.sales.coamount" default="자사금액"/>', 		type: 'uniPrice'},
				 {name: 'BILL_NUM'				,text: '<t:message code="system.label.sales.salesno" default="매출번호"/>', 		type: 'string'},
				 {name: 'BILL_SEQ'				,text: '<t:message code="system.label.sales.seq" default="순번"/>',			type: 'string'},
				 {name: 'ORDER_TYPE'			,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>', 		type: 'string', comboType: "AU", comboCode: "S002"},
				 {name: 'ORDER_TYPE_NM'			,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>', 		type: 'string'},
				 {name: 'AGENT_TYPE'			,text: '<t:message code="system.label.sales.clienttype" default="고객분류"/>', 		type: 'string', comboType: "AU", comboCode: "B055"},
				 {name: 'AGENT_TYPE_NM'			,text: '<t:message code="system.label.sales.clienttype" default="고객분류"/>', 		type: 'string'},
				 {name: 'SALE_PRSN'				,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',			type: 'string', comboType: "AU", comboCode: "S010"},
				 {name: 'SALE_PRSN_NM'			,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>', 		type: 'string'},
				 {name: 'DEPT_CODE'				,text: '<t:message code="system.label.sales.department" default="부서"/>', 		type: 'string'},
				 {name: 'EX_REG_YN'				,text: '매출기표여부', 		type: 'string'},
				 {name: 'EX_REG_YN_NM'			,text: '매출기표여부', 		type: 'string'},
				 {name: 'TAX_REG_YN'			,text: '계산서등록여부', 	type: 'string'},
				 {name: 'TAX_REG_YN_NM'			,text: '계산서등록여부', 	type: 'string'},
				 {name: 'INOUT_NUM'				,text: '<t:message code="system.label.sales.issueno" default="출고번호"/>',			type: 'string'},
				 {name: 'INOUT_SEQ'				,text: '<t:message code="system.label.sales.seq" default="순번"/>', 			type: 'int'},
				 {name: 'INOUT_TYPE'			,text: '<t:message code="system.label.sales.trantype" default="수불유형"/>', 		type: 'string'},
				 {name: 'INOUT_TYPE_DETAIL'		,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>', 		type: 'string'},
				 {name: 'WH_CODE'				,text: '출고창고코드', 		type: 'string'},
				 {name: 'WH_NAME'				,text: '<t:message code="system.label.sales.issuewarehouse" default="출고창고"/>', 		type: 'string'},
				 {name: 'DISCOUNT_RATE'			,text: '<t:message code="system.label.sales.discountrate" default="할인율(%)"/>', 		type: 'uniPercent'},
				 {name: 'DVRY_CUST_CD'			,text: '납품처', 			type: 'string'},
				 {name: 'ORDER_NUM'				,text: '<t:message code="system.label.sales.sono" default="수주번호"/>', 		type: 'string'},
				 {name: 'SER_NO'				,text: '<t:message code="system.label.sales.seq" default="순번"/>', 			type: 'string'},
				 {name: 'PUB_NUM'				,text: '<t:message code="system.label.sales.billno" default="계산서번호"/>', 		type: 'string'},
				 {name: 'TO_DIV_CODE'			,text: '귀속사업장', 		type: 'string'},
				 {name: 'PRICE_YN'				,text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>', 		type: 'string'},
				 {name: 'CUSTOM_CODE'			,text: '<t:message code="system.label.sales.custom" default="거래처"/>', 		type: 'string'},
				 {name: 'ORDER_PRSN'			,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>', 		type: 'string'},
				 {name: 'OUT_DIV_CODE'			,text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>', 		type: 'string'},
				 {name: 'ADVAN_YN'				,text: '선출고여부', 		type: 'string'},
				 {name: 'PROJECT_NO'			,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>', 		type: 'string'},
				 {name: 'REMARK'				,text: '<t:message code="system.label.sales.remarks" default="비고"/>', 			type: 'string'},
				 {name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.sales.updateuser" default="수정자"/>', 			type: 'string'},
				 {name: 'UPDATE_DB_TIME'		,text: '<t:message code="system.label.sales.updatedate" default="수정일"/>', 			type: 'uniDate'},
				 {name: 'COMP_CODE'				,text: 'COMP_CODE', 	type: 'string'},
				 {name: 'DIV_CODE'				,text: 'DIV_CODE', 		type: 'string'},
				 {name: 'M_SALE_AMT_O'			,text: 'M_SALE_AMT_O', 		type: 'string'},
				 {name: 'M_SALE_LOC_AMT_I'		,text: 'M_SALE_LOC_AMT_I',  type: 'string'},
				 {name: 'M_SALE_LOC_EXP_I'		,text: 'M_SALE_LOC_EXP_I',  type: 'string'},
				 {name: 'M_TAX_AMT_O'			,text: 'M_TAX_AMT_O', 		type: 'string'},
				 {name: 'COLLECT_AMT'			,text: 'COLLECT_AMT', 		type: 'string'},
				 {name: 'VAT_RATE'				,text: '부가세율', 			type: 'int'},
				 {name: 'TAX_INOUT'				,text: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>', 		type: 'string'},
				 {name: 'TAX_INOUT_NM'			,text: '<t:message code="system.label.sales.taxincludedflag" default="세액포함여부"/>', 		type: 'string'},
				 {name: 'TAX_CALC_TYPE'			,text: '세액계산방법', 		type: 'string'},
				 {name: 'TAX_CALC_TYPE_NM'		,text: '세액계산방법', 		type: 'string'},
				 {name: 'WON_CALC_TYPE'			,text: '원미만계산', 		type: 'string'},
				 {name: 'WON_CALC_TYPE_NM'		,text: '원미만계산', 		type: 'string'},
				 {name: 'RECEIPT_PLAN_DATE'		,text: 'RECEIPT_PLAN_DATE', type: 'string'},
				 {name: 'RECEIPT_SET_METH'		,text: 'RECEIPT_SET_METH',  type: 'string'},
				 {name: 'BILL_PRINT_YN'			,text: 'BILL_PRINT_YN', 	type: 'string'},
				 {name: 'EX_DATE'				,text: 'EX_DATE', 			type: 'string'},
				 {name: 'EX_NUM'				,text: 'EX_NUM', 			type: 'string'},
				 {name: 'EX_SEQ'				,text: 'EX_SEQ', 			type: 'string'},
				 {name: 'AGREE_YN'				,text: 'AGREE_YN', 			type: 'string'},
				 {name: 'AC_DATE'				,text: 'AC_DATE', 			type: 'string'},
				 {name: 'AC_NUM'				,text: 'AC_NUM', 			type: 'string'}
				  
			]
	});
    
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read    : 'ssa120ukrvService.selectList',
            update  : 'ssa120ukrvService.updateDetail',
            syncAll : 'ssa120ukrvService.saveAll'
        }
    });
    
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('ssa120ukrvMasterStore1',{
		model: 'Ssa120ukrvModel',
		uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
		loadStoreRecords : function(){
			var param= panelResult.getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
        saveStore: function() {             
            var inValidRecs = this.getInvalidRecords();
            var paramMaster= panelResult.getValues();    //syncAll 수정
            
            if(inValidRecs.length == 0) {
                    config = {
                        params: [paramMaster],
                        success: function(batch, option) {
                        	
                        } 
                    };
                this.syncAllDirect(config);
            }else{
                detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	
	var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{                   
                fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false
            }, { 
                fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
                xtype: 'uniDateRangefield',
                startFieldName: 'FROM_DATE',
                endFieldName: 'TO_DATE',
                width: 470,
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),              
                allowBlank:false
            }, {
                fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'  ,
                name:'SALE_PRSN', 
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'S010'
            }, {
                fieldLabel: '<t:message code="system.label.sales.vattype" default="부가세유형"/>' ,
                name:'BILL_TYPE', 
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'S024'
            },
                Unilite.popup('AGENT_CUST',{
                fieldLabel: '<t:message code="system.label.sales.salesplace" default="매출처"/>',
                validateBlank:false
            }),{
                xtype: 'uniTextfield',
                fieldLabel: '<t:message code="system.label.sales.salesno" default="매출번호"/>',
                name: 'BILL_NUM'
            }, {
                fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'  ,
                name:'ORDER_TYPE', 
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'S002'
            },
                Unilite.popup('DIV_PUMOK',{
                fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
                validateBlank:false
            }),{
                xtype: 'radiogroup',                            
                fieldLabel: '매출기표여부',
                items: [{
                       boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
                       width: 50,
                       name: 'EX_REG_YN',
                       inputValue: '',
                       checked: true
                }, {
                       boxLabel: '예',
                       width: 50,
                       name: 'EX_REG_YN',
                       inputValue: 'Y'
                }, {
                       boxLabel: '아니오',
                       width: 70, 
                       name: 'EX_REG_YN',
                       inputValue: 'N'
                }]
            } ,{
                xtype: 'radiogroup',                            
                fieldLabel: '계산서등록여부',
                items: [{
                       boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
                       width: 50,
                       name: 'TAX_REG_YN',
                       inputValue: '',
                       checked: true
                }, {
                       boxLabel: '예',
                       width: 50, 
                       name: 'TAX_REG_YN',
                       inputValue: 'Y'
                }, {
                       boxLabel: '아니오',
                       width: 70, 
                       name: 'TAX_REG_YN',
                       inputValue: 'N'
                }]
            } ,{
                xtype: 'radiogroup',                            
                fieldLabel: '수주단가적용여부',
                labelWidth: 100,
                items: [{
                   boxLabel: '예',
                   width: 50, 
                   name: 'ORDER_PRICE_YN',
                   inputValue: 'Y',
                   checked: true
                }, {
                   boxLabel: '아니오',
                   width: 70, 
                   name: 'ORDER_PRICE_YN',
                   inputValue: 'N'
                }]
            }
        ]   
    });
    
    var changePriceForm = Unilite.createSearchForm('changePriceForm',{        
        region: 'north',
        padding:'1 1 1 1',
        border:true,
        layout : {type : 'uniTable', columns : 3, tableAttrs: {width: '100%'}},
        hidden: !UserInfo.appOption.collapseLeftSearch,        
        items: [{
            xtype: 'container',
            layout: {type: 'uniTable', columns: 3},
            tdAttrs: {align: 'right'},
            margin: '0 15 1 0',
            items:[{
                xtype: 'uniNumberfield',
                name: 'SALE_P',
                fieldLabel: '선택된 품목의 매출단가를',
                labelWidth: 250,
                width: 350
            },{
                xtype: 'component',  
                html:'&nbsp;&nbsp;으로&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;',
                style: {
                    marginTop: '3px !important',
                    font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
                }            
            },{                        
               width: 100,
               xtype: 'button',
               text: '일괄적용',
               margin: '0 100 0 0',
               handler : function() {
                    var records = masterGrid.getSelectedRecords();
                    Ext.each(records, function(rec, idx){
                        rec.set('SALE_P', changePriceForm.getValue('SALE_P'));
                        UniAppManager.app.fnOrderAmtCal(rec, "P");
                    });
               }
            }]
        }]
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('ssa120ukrvGrid1', {
    	// for tab    	
        layout : 'fit',
        region:'center',
    	store: directMasterStore,
        uniOpt: {
            onLoadSelectFirst: false
        },
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
	        columns:  [{ dataIndex: 'CHOICE'				,	width: 33, hidden: true },			   
   					   { dataIndex: 'SALE_CUSTOM_CODE'		,	width: 100, hidden: true	},			   
   					   { dataIndex: 'SALE_CUSTOM_NAME'		,	width: 133 },			   
   					   { dataIndex: 'BILL_TYPE'				,	width: 66, hidden: true	},			   
   					   { dataIndex: 'BILL_TYPE_NM'			,	width: 73 },		   
   					   { dataIndex: 'SALE_DATE'				,	width: 73	},			   
   					   { dataIndex: 'ITEM_CODE'				,	width: 100	},			   
   					   { dataIndex: 'ITEM_NAME'				,	width: 166	},			   
   					   { dataIndex: 'SPEC'					,	width: 100	},			   
   					   { dataIndex: 'SALE_UNIT'				,	width: 100, align: 'center'	},			   
   					   { dataIndex: 'PRICE_TYPE'			,	width: 66, hidden: true	},			   
   					   { dataIndex: 'PRICE_TYPE_NM'			,	width: 73, hidden: true	},			   
   					   { dataIndex: 'MONEY_UNIT'			,	width: 100, align: 'center'	},			   
   					   { dataIndex: 'TRANS_RATE'			,	width: 73, align: 'right'	},			   
   					   { dataIndex: 'SALE_Q'				,	width: 100	},			   
   					   { dataIndex: 'SALE_P'				,	width: 100	},			   
   					   { dataIndex: 'SALE_WGT_Q'			,	width: 100, hidden: true	},			   
   					   { dataIndex: 'SALE_FOR_WGT_P'		,	width: 100, hidden: true	},			   
   					   { dataIndex: 'SALE_VOL_Q'			,	width: 100, hidden: true	},			   
   					   { dataIndex: 'SALE_FOR_VOL_P'		,	width: 100, hidden: true	},			   
   					   { dataIndex: 'SALE_AMT_O'			,	width: 93	},			   
   					   { dataIndex: 'TAX_TYPE'				,	width: 66, hidden: true	},			   
   					   { dataIndex: 'TAX_TYPE_NM'			,	width: 66	},			   
   					   { dataIndex: 'TAX_AMT_O'				,	width: 100	},			   
   					   { dataIndex: 'SALE_TOT_O'			,	width: 93	},			   
   					   { dataIndex: 'WGT_UNIT'				,	width: 53, hidden: true	},			   
   					   { dataIndex: 'UNIT_WGT'				,	width: 66, hidden: true	},			   
   					   { dataIndex: 'VOL_UNIT'				,	width: 53, hidden: true	},			   
   					   { dataIndex: 'UNIT_VOL'				,	width: 66, hidden: true	},			   
   					   { dataIndex: 'EXCHG_RATE_O'			,	width: 73, align: 'right'	},			   
   					   { dataIndex: 'SALE_WGT_P'			,	width: 100, hidden: true	},			   
   					   { dataIndex: 'SALE_VOL_P'			,	width: 100, hidden: true	},			   
   					   { dataIndex: 'SALE_LOC_AMT_I'		,	width: 93	},			   
   					   { dataIndex: 'BILL_NUM'				,	width: 100	},			   
   					   { dataIndex: 'BILL_SEQ'				,	width: 53	},			   
   					   { dataIndex: 'ORDER_TYPE'			,	width: 66, hidden: true	},			   
   					   { dataIndex: 'ORDER_TYPE_NM'			,	width: 100	},			   
   					   { dataIndex: 'AGENT_TYPE'			,	width: 80, hidden: true	},			   
   					   { dataIndex: 'AGENT_TYPE_NM'			,	width: 100	},			   
   					   { dataIndex: 'SALE_PRSN'				,	width: 66, hidden: true	},			   
   					   { dataIndex: 'SALE_PRSN_NM'			,	width: 73	},			   
   					   { dataIndex: 'DEPT_CODE'				,	width: 66, hidden: true	},			   
   					   { dataIndex: 'EX_REG_YN'				,	width: 66, hidden: true	},			   
   					   { dataIndex: 'EX_REG_YN_NM'			,	width: 86	},			   
   					   { dataIndex: 'TAX_REG_YN'			,	width: 86, hidden: true	},			   
   					   { dataIndex: 'TAX_REG_YN_NM'			,	width: 100, align: 'center'	},			   
   					   { dataIndex: 'INOUT_NUM'				,	width: 100, hidden: true	},			   
   					   { dataIndex: 'INOUT_SEQ'				,	width: 53, hidden: true	},			   
   					   { dataIndex: 'INOUT_TYPE'			,	width: 66, hidden: true	},			   
   					   { dataIndex: 'INOUT_TYPE_DETAIL'		,	width: 66, hidden: true	},			   
   					   { dataIndex: 'WH_CODE'				,	width: 66, hidden: true	},			   
   					   { dataIndex: 'WH_NAME'				,	width: 100, hidden: true	},			   
   					   { dataIndex: 'DISCOUNT_RATE'			,	width: 73, hidden: true	},			   
   					   { dataIndex: 'DVRY_CUST_CD'			,	width: 66, hidden: true	},			   
   					   { dataIndex: 'ORDER_NUM'				,	width: 100, hidden: true	},			   
   					   { dataIndex: 'SER_NO'				,	width: 53, hidden: true	},			   
   					   { dataIndex: 'PUB_NUM'				,	width: 100, hidden: true	},			   
   					   { dataIndex: 'TO_DIV_CODE'			,	width: 66, hidden: true	},			   
   					   { dataIndex: 'PRICE_YN'				,	width: 66, hidden: true	},			   
   					   { dataIndex: 'CUSTOM_CODE'			,	width: 66, hidden: true	},			   
   					   { dataIndex: 'ORDER_PRSN'			,	width: 66, hidden: true	},			   
   					   { dataIndex: 'OUT_DIV_CODE'			,	width: 66, hidden: true	},			   
   					   { dataIndex: 'ADVAN_YN'				,	width: 66, hidden: true	},			   
   					   { dataIndex: 'PROJECT_NO'			,	width: 66, hidden: true	},			   
   					   { dataIndex: 'REMARK'				,	width: 133	},			   
   					   { dataIndex: 'UPDATE_DB_USER'		,	width: 66, hidden: true	},			   
   					   { dataIndex: 'UPDATE_DB_TIME'		,	width: 66, hidden: true	},			   
   					   { dataIndex: 'COMP_CODE'				,	width: 66, hidden: true	},			   
   					   { dataIndex: 'DIV_CODE'				,	width: 66, hidden: true	},			   
   					   { dataIndex: 'M_SALE_AMT_O'			,	width: 66, hidden: true	},			   
   					   { dataIndex: 'M_SALE_LOC_AMT_I'		,	width: 66, hidden: true	},			   
   					   { dataIndex: 'M_SALE_LOC_EXP_I'		,	width: 66, hidden: true	},			   
   					   { dataIndex: 'M_TAX_AMT_O'			,	width: 66, hidden: true	},			   
   					   { dataIndex: 'COLLECT_AMT'			,	width: 66, hidden: true	},			   
   					   { dataIndex: 'VAT_RATE'				,	width: 66, hidden: true	},			   
   					   { dataIndex: 'TAX_INOUT'				,	width: 66, hidden: true	},			   
   					   { dataIndex: 'TAX_INOUT_NM'			,	width: 100	},			   
   					   { dataIndex: 'TAX_CALC_TYPE'			,	width: 66, hidden: true	},			   
   					   { dataIndex: 'TAX_CALC_TYPE_NM'		,	width: 100	},			   
   					   { dataIndex: 'WON_CALC_TYPE'			,	width: 66, hidden: true	},			   
   					   { dataIndex: 'WON_CALC_TYPE_NM'		,	width: 100, hidden: true	},			   
   					   { dataIndex: 'RECEIPT_PLAN_DATE'		,	width: 66, hidden: true	},			   
   					   { dataIndex: 'RECEIPT_SET_METH'		,	width: 66, hidden: true	},			   
   					   { dataIndex: 'BILL_PRINT_YN'			,	width: 66, hidden: true	},			   
   					   { dataIndex: 'EX_DATE'				,	width: 66, hidden: true	},			   
   					   { dataIndex: 'EX_NUM'				,	width: 66, hidden: true	},			   
   					   { dataIndex: 'EX_SEQ'				,	width: 66, hidden: true	},			   
   					   { dataIndex: 'AGREE_YN'				,	width: 66, hidden: true	},			   
   					   { dataIndex: 'AC_DATE'				,	width: 66, hidden: true	},			   
   					   { dataIndex: 'AC_NUM'				,	width: 66, hidden: true	}
   		],
        selModel: Ext.create('Ext.selection.CheckboxModel', {
            checkOnly: true,
            toggleOnClick: false,
            listeners: { 
                beforeselect: function(rowSelection, record, index, eOpts) {
                	
                },
                select: function(grid, record, index, eOpts ){                  
                    
                },
                deselect: function(grid, record, index, eOpts ){
                	
                }
            }
        })
    });   
	
	
    Unilite.Main( {
		borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                panelResult, changePriceForm, masterGrid
            ]
        }    
        ],
		id  : 'ssa120ukrvApp',
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('FROM_DATE', UniDate.get('today'));
			panelResult.setValue('TO_DATE', UniDate.get('today'));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',true);
		},
		onQueryButtonDown : function()	{				
			if(!panelResult.getInvalidMessage()) return;
			masterGrid.getStore().loadStoreRecords();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
        onResetButtonDown: function() {
            panelResult.clearForm();
            changePriceForm.clearForm();
            directMasterStore.loadData({});
            this.fnInitBinding();
        },
        onSaveDataButtonDown: function() {    
        	directMasterStore.saveStore();   
        },
        fnOrderAmtCal: function(rtnRecord, sType) {            
            var dTransRate = rtnRecord.get('TRANS_RATE');
            var dSaleQ = rtnRecord.get('SALE_Q');
            var dSaleP = rtnRecord.get('SALE_P');
            var dSaleWgtQ = rtnRecord.get('SALE_WGT_Q');
            var dSaleVolQ = rtnRecord.get('SALE_VOL_Q');
            var dSaleForWgtP = rtnRecord.get('SALE_FOR_WGT_P');
            var dSaleForVolP = rtnRecord.get('SALE_FOR_VOL_P');
            var dSaleO = rtnRecord.get('SALE_AMT_O');
            var dDcRate = rtnRecord.get('DISCOUNT_RATE');
            var dExchgRate = rtnRecord.get('EXCHG_RATE_O');
            var sPriceType = rtnRecord.get('PRICE_TYPE');
            
            if(sType == "P" || sType == "Q"){
                dExchgRate = rtnRecord.get('EXCHG_RATE_O');
            	dSaleWgtP = dSaleForWgtP * dExchgRate
                dSaleVolP = dSaleForVolP * dExchgRate
                
                if(sPriceType == "A"){
                    dSaleO    = dSaleQ    * dSaleP
                    dSaleLocI = dSaleQ    * dSaleP * dExchgRate
                }else if(sPriceType == "B"){
                    dSaleO    = dSaleWgtQ * dSaleForWgtP
                    dSaleLocI = dSaleWgtQ * dSaleWgtP
                }else if(sPriceType == "C"){
                    dSaleO    = dSaleVolQ * dSaleForVolP
                    dSaleLocI = dSaleVolQ * dSaleVolP
                }else{
                    dSaleO    = dSaleQ    * dSaleP
                    dSaleLocI = dSaleQ    * dSaleP * dExchgRate
                }
                rtnRecord.set('SALE_WGT_P', dSaleWgtP);
                rtnRecord.set('SALE_VOL_P', dSaleVolP);
                rtnRecord.set('SALE_AMT_O', dSaleO);
                rtnRecord.set('SALE_LOC_AMT_I', dSaleLocI);
                
                UniAppManager.app.fnTaxCalculate(rtnRecord, dSaleO)
            }
        },
        fnTaxCalculate: function(rtnRecord, dSaleO) {
            var sTaxType      = rtnRecord.get('TAX_TYPE');
            var sUnderCalcType    = rtnRecord.get('WON_CALC_TYPE');
            var sTaxInoutType = rtnRecord.get('TAX_INOUT');
            if(Ext.isEmpty(sTaxInoutType)) sTaxInoutType = "1" 
            var dVatRate = rtnRecord.get('VAT_RATE');
            var dAmountO = dSaleO;            
            var dIRAmtO = 0;
            var dTaxAmtO = 0;
            var dIRAmtO = 0;
            var dTaxAmtO = 0;
            var numDigitOfPrice = UniFormat.Price.length - UniFormat.Price.indexOf(".");
            
            if(sTaxInoutType=="1") {    //별도
            	dIRAmtO = dSaleO
            	dIRAmtO = UniSales.fnAmtWonCalc(dIRAmtO, sUnderCalcType, numDigitOfPrice);
				//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
                dTaxAmtO = UniSales.fnAmtWonCalc(dIRAmtO * dVatRate / 100, sUnderCalcType, numDigitOfPrice);
            }else if(sTaxInoutType=="2") {  //포함
            	dAmountO = dSaleO;
            	dAmountO = UniSales.fnAmtWonCalc(dAmountO, sUnderCalcType, numDigitOfPrice);
            	dIRAmtO  = UniSales.fnAmtWonCalc(dAmountO / ( dVatRate + 100 ) * 100, sUnderCalcType, numDigitOfPrice);
				//20191002 세액 구하는 함수 적용: UserInfo.currency = 'KRW"이면 소숫점 이하 버림 -> 20191212 fnAmtWonCalc로 변경
				//20200513 수정: 계산기준을 부가세액으로 통일
//            	dTaxAmtO = UniSales.fnAmtWonCalc(dAmountO - dIRAmtO, sUnderCalcType, numDigitOfPrice);
				dTaxAmtO = UniSales.fnAmtWonCalc(dIRAmtO * dVatRate / 100, sUnderCalcType, numDigitOfPrice);
				//20191002 세액 구하는 로직 추가
				dIRAmtO	= UniSales.fnAmtWonCalc((dAmountO - dTaxAmtO), sUnderCalcType, numDigitOfPrice);
            }           
            if(sTaxType == "2") {
            	dIRAmtO = UniSales.fnAmtWonCalc(dSaleO, sUnderCalcType, numDigitOfPrice);
            	dTaxAmtO = 0;
            }
            var dExchgRate = Ext.isEmpty(rtnRecord.get('EXCHG_RATE_O'))? 0: rtnRecord.get('EXCHG_RATE_O');
            
            rtnRecord.set('SALE_AMT_O', dIRAmtO);
            rtnRecord.set('SALE_LOC_AMT_I', dIRAmtO * dExchgRate);
            rtnRecord.set('TAX_AMT_O', dTaxAmtO);
            rtnRecord.set('SALE_TOT_O', dIRAmtO + dTaxAmtO);
        }
	});

};
</script>
