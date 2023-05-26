<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sof800skrv"  >	
	<t:ExtComboStore comboType="BOR120" pgmId="sof800skrv"/> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 --> 
    <t:ExtComboStore comboType="AU" comboCode="S007" /> <!--출고유형-->
    <t:ExtComboStore comboType="AU" comboCode="S024" /> <!--국내:부가세유형-->
    <t:ExtComboStore comboType="AU" comboCode="S118" /> <!--해외:부가세유형-->     
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->       
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목유형-->
    <t:ExtComboStore comboType="AU" comboCode="S003" /> <!--단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="B059" /> <!--과세구분-->
	<t:ExtComboStore comboType="AU" comboCode="S011" /> <!--마감유형-->
	<t:ExtComboStore comboType="AU" comboCode="B031" opts= '1;5' /> <!--생성경로-->
    <t:ExtComboStore comboType="AU" comboCode="B059" /> <!--과세여부-->
    <t:ExtComboStore comboType="AU" comboCode="S024" /> <!--부가세유형-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>


<script type="text/javascript" >

function appMain() {     
	/**
	 *   Model 정의 
	 * @type  
	 */
	Unilite.defineModel('sof800skrvModel1', {
	    fields: [
			{name: 'DVRY_DATE1'				,text:'<t:message code="system.label.sales.deliverydate" default="납기일"/>'		,type:'uniDate',convert:dateToString},
			{name: 'DVRY_TIME1'				,text:'<t:message code="system.label.sales.deliverytime" default="납기시간"/>'		,type:'string'},
			{name: 'ITEM_CODE'		 		,text:'<t:message code="system.label.sales.item" default="품목"/>' 		,type:'string'},
			{name: 'ITEM_NAME'		 		,text:'<t:message code="system.label.sales.itemname" default="품목명"/>' 		,type:'string'},
			{name: 'CUSTOM_CODE1'		 	,text:'<t:message code="system.label.sales.custom" default="거래처"/>'		,type:'string'},
			{name: 'CUSTOM_NAME1'		 	,text:'<t:message code="system.label.sales.customname" default="거래처명"/>' 		,type:'string'},
			{name: 'SPEC'			 		,text:'<t:message code="system.label.sales.spec" default="규격"/>' 			,type:'string'},
			{name: 'ORDER_UNIT'		 		,text:'<t:message code="system.label.sales.unit" default="단위"/>' 			,type:'string', displayField: 'value'},
			{name: 'PRICE_TYPE'		 		,text:'<t:message code="system.label.sales.priceclass" default="단가구분"/>' 		,type:'string'},
			{name: 'TRANS_RATE'		 		,text:'<t:message code="system.label.sales.containedqty" default="입수"/>' 			,type:'string'},
			{name: 'ORDER_UNIT_Q'	 		,text:'<t:message code="system.label.sales.soqty" default="수주량"/>' 		,type:'uniQty'},
			{name: 'ORDER_WGT_Q'	 		,text:'수주량(중량)' 	,type:'uniQty'},
			{name: 'ORDER_VOL_Q'	 		,text:'수주량(부피)' 	,type:'uniQty'},
			{name: 'STOCK_UNIT'		 		,text:'<t:message code="system.label.sales.inventoryunit" default="재고단위"/>' 		,type:'string', displayField: 'value'},
			{name: 'STOCK_Q'		 		,text:'재고단위수주량' 	,type:'uniQty'},
			{name: 'MONEY_UNIT'		 		,text:'<t:message code="system.label.sales.currency" default="화폐"/>' 			,type:'string'},
			{name: 'ORDER_P'		 		,text:'<t:message code="system.label.sales.price" default="단가"/>' 			,type:'uniUnitPrice'},
			{name: 'ORDER_WGT_P'	 		,text:'<t:message code="system.label.sales.priceweight" default="단가(중량)"/>' 	,type:'uniUnitPrice'},
			{name: 'ORDER_VOL_P'	 		,text:'<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>' 	,type:'uniUnitPrice'},
			{name: 'ORDER_O'		 		,text:'<t:message code="system.label.sales.soamount" default="수주액"/>' 		,type:'uniFC'},
			{name: 'EXCHG_RATE_O'	 		,text:'<t:message code="system.label.sales.exchangerate" default="환율"/>' 			,type:'uniER'},
			{name: 'SO_AMT_WON'		 		,text:'<t:message code="system.label.sales.exchangeamount" default="환산액"/>' 		,type:'uniPrice'},
			{name: 'TAX_TYPE'		 		,text:'<t:message code="system.label.sales.taxabledivision" default="과세구분"/>' 		,type:'string', comboType:'AU', comboCode:'B059'},
			{name: 'ORDER_TAX_O'	 		,text:'<t:message code="system.label.sales.taxamount" default="세액"/>' 			,type:'uniPrice'},
			{name: 'WGT_UNIT'		 		,text:'<t:message code="system.label.sales.weightunit" default="중량단위"/>' 		,type:'string'},
			{name: 'UNIT_WGT'		 		,text:'<t:message code="system.label.sales.unitweight" default="단위중량"/>' 		,type:'string'},
			{name: 'VOL_UNIT'		 		,text:'<t:message code="system.label.sales.volumnunit" default="부피단위"/>' 		,type:'string'},
			{name: 'UNIT_VOL'		 		,text:'<t:message code="system.label.sales.unitvolumn" default="단위부피"/>' 		,type:'string'},
			{name: 'CUSTOM_CODE2'	 		,text:'<t:message code="system.label.sales.custom" default="거래처"/>' 	    ,type:'string'},
			{name: 'CUSTOM_NAME2'	 		,text:'<t:message code="system.label.sales.customname" default="거래처명"/>' 		,type:'string'},
			{name: 'ORDER_DATE'		 		,text:'<t:message code="system.label.sales.sodate" default="수주일"/>' 		,type:'uniDate',convert:dateToString},
			{name: 'ORDER_TYPE'		 		,text:'<t:message code="system.label.sales.sellingtype" default="판매유형"/>' 		,type:'string',comboType:"AU", comboCode:"S002"},
			{name: 'ORDER_TYPE_NM'	 		,text:'<t:message code="system.label.sales.sellingtype" default="판매유형"/>' 		,type:'string'},
			{name: 'ORDER_NUM'		 		,text:'<t:message code="system.label.sales.sono" default="수주번호"/>' 		,type:'string'},
			{name: 'SER_NO'			 		,text:'<t:message code="system.label.sales.seq" default="순번"/>' 			,type:'integer'},
			{name: 'ORDER_PRSN'		 		,text:'<t:message code="system.label.sales.salescharge" default="영업담당"/>' 		,type:'string',comboType:"AU", comboCode:"S010"},
			{name: 'ORDER_PRSN_NM'	 		,text:'<t:message code="system.label.sales.salescharge" default="영업담당"/>' 		,type:'string'},
			{name: 'PROJECT_NO'             ,text:'<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'    ,type:'string'},
			{name: 'PO_NUM'			 		,text:'<t:message code="system.label.sales.pono2" default="P/O 번호"/>' 		,type:'string'},
			{name: 'DVRY_DATE2'		 		,text:'<t:message code="system.label.sales.deliverydate" default="납기일"/>' 		,type:'uniDate',convert:dateToString},
			{name: 'DVRY_TIME'		 		,text:'<t:message code="system.label.sales.deliverytime" default="납기시간"/>' 		,type:'uniTime'},
			{name: 'DVRY_CUST_NM'	 		,text:'<t:message code="system.label.sales.deliveryplace" default="배송처"/>' 		,type:'string'},
			{name: 'PROD_END_DATE'	 		,text:'<t:message code="system.label.sales.productionfinishrequestdate" default="생산완료요청일"/>' 	,type:'uniDate',convert:dateToString},
			{name: 'PROD_Q'			 		,text:'<t:message code="system.label.sales.productionrequestqty" default="생산요청량"/>' 	,type:'uniQty'},
			{name: 'ORDER_STATUS'	 		,text:'<t:message code="system.label.sales.closing" default="마감"/>' 			,type:'string',comboType:"AU", comboCode:"S011"},
			{name: 'REMARK'					,text:'<t:message code="system.label.sales.remarks" default="비고"/>'			,type:'string'},
			{name: 'SORT_KEY'		 		,text:'SORTKEY' 	,type:'string'},
			{name: 'CREATE_LOC'		 		,text:'CREATE_LOC' 	,type:'string'}
		]
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	 }
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('sof800skrvMasterStore1', {
		model: 'sof800skrvModel1',
		uniOpt: {
           	isMaster: true,			// 상위 버튼,상태바 연결 
           	editable: false,		// 수정 모드 사용 
           	deletable:false,		// 삭제 가능 여부 
            useNavi: false			// prev | next 버튼 사용
		},
        autoLoad: false,
        proxy: {
        	type: 'direct',
            api: {			
            	read: 'sof100skrvService.selectList1'                	
		    }
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params: param
			});
		},
		groupField: 'ITEM_NAME'
	});

	
	
	Unilite.defineModel('sof800skrvModel2', {
        fields: [{name: 'SALE_CUSTOM_CODE'      ,text: '<t:message code="system.label.sales.custom" default="거래처"/>'         ,type: 'string'},
                 {name: 'SALE_CUSTOM_NAME'      ,text: '<t:message code="system.label.sales.customname" default="거래처명"/>'           ,type: 'string'},
                 {name: 'BILL_TYPE'             ,text: '<t:message code="system.label.sales.vattype" default="부가세유형"/>'         ,type: 'string',comboType: "AU", comboCode: "S024"},
                 {name: 'SALE_DATE'             ,text: '<t:message code="system.label.sales.salesdate" default="매출일"/>'             ,type: 'uniDate'},
                 {name: 'INOUT_TYPE_DETAIL'     ,text: '<t:message code="system.label.sales.issuetype" default="출고유형"/>'           ,type: 'string',comboType: "AU", comboCode: "S007"},                    
                 {name: 'ITEM_CODE'             ,text: '<t:message code="system.label.sales.item" default="품목"/>'           ,type: 'string'},
                 {name: 'ITEM_NAME'             ,text: '<t:message code="system.label.sales.itemname" default="품목명"/>'               ,type: 'string'},
                 {name: 'CREATE_LOC'            ,text: '<t:message code="system.label.sales.creationpath" default="생성경로"/>'           ,type: 'string',comboType: "AU", comboCode: "B031"},
                 {name: 'SPEC'                  ,text: '<t:message code="system.label.sales.spec" default="규격"/>'               ,type: 'string'},
                 {name: 'SALE_UNIT'             ,text: '<t:message code="system.label.sales.unit" default="단위"/>'               ,type: 'string'},
                 {name: 'PRICE_TYPE'            ,text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'           ,type: 'string'},
                 {name: 'TRANS_RATE'            ,text: '<t:message code="system.label.sales.containedqty" default="입수"/>'               ,type: 'string'},
                 {name: 'SALE_Q'                ,text: '<t:message code="system.label.sales.salesqty" default="매출량"/>'             ,type: 'uniQty'},
                 {name: 'SALE_WGT_Q'            ,text: '매출량(중량)'       ,type: 'number'},
                 {name: 'SALE_VOL_Q'            ,text: '매출량(부피)'       ,type: 'string'},                   
                 {name: 'CUSTOM_CODE'           ,text: '수주거래처'         ,type: 'string'},
                 {name: 'CUSTOM_NAME'           ,text: '수주거래처명'       ,type: 'string'},                           
                 {name: 'SALE_P'                ,text: '<t:message code="system.label.sales.price" default="단가"/>'               ,type: 'uniUnitPrice'},
                 {name: 'SALE_FOR_WGT_P'        ,text: '<t:message code="system.label.sales.priceweight" default="단가(중량)"/>'         ,type: 'number'},                   
                 {name: 'SALE_FOR_VOL_P'        ,text: '<t:message code="system.label.sales.pricevolumn" default="단가(부피)"/>'         ,type: 'string'},               
                 {name: 'MONEY_UNIT'            ,text: '<t:message code="system.label.sales.currency" default="화폐"/>'               ,type: 'string'},
                 {name: 'EXCHG_RATE_O'          ,text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'               ,type: 'uniER'},
                 {name: 'SALE_LOC_AMT_F'        ,text: '<t:message code="system.label.sales.salesamountforeign" default="매출액(외화)"/>'       ,type: 'uniFC'},
                 {name: 'SALE_LOC_AMT_I'        ,text: '<t:message code="system.label.sales.salesamount" default="매출액"/>'             ,type: 'uniPrice'},
                 {name: 'TAX_TYPE'              ,text: '<t:message code="system.label.sales.taxationyn" default="과세여부"/>'           ,type: 'string', comboType: "AU", comboCode: "B059"},
                 {name: 'TAX_AMT_O'             ,text: '<t:message code="system.label.sales.taxamount" default="세액"/>'               ,type: 'uniPrice'},
                 {name: 'SUM_SALE_AMT'          ,text: '<t:message code="system.label.sales.salestotal" default="매출계"/>'             ,type: 'uniPrice'},
//               {name: 'CONSIGNMENT_FEE'       ,text: '수수료(위탁)'    ,type: 'uniPrice'},
                 {name: 'ORDER_TYPE'            ,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'           ,type: 'string',comboType: "AU", comboCode: "S002"},
                 {name: 'DIV_CODE'              ,text: '<t:message code="system.label.sales.division" default="사업장"/>'             ,type: 'string',comboType: "BOR120"},
                 {name: 'SALE_PRSN'             ,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'           ,type: 'string',comboType: "AU", comboCode: "S010"},
                 {name: 'MANAGE_CUSTOM'         ,text: '<t:message code="system.label.sales.summarycustom" default="집계거래처"/>'         ,type: 'string'},
                 {name: 'MANAGE_CUSTOM_NM'      ,text: '집계거래처명'       ,type: 'string'},
                 {name: 'AREA_TYPE'             ,text: '<t:message code="system.label.sales.area" default="지역"/>'               ,type: 'string',comboType: "AU", comboCode: "B056"},
                 {name: 'AGENT_TYPE'            ,text: '<t:message code="system.label.sales.customclass" default="거래처분류"/>'         ,type: 'string',comboType: "AU", comboCode: "B055"},                    
                 {name: 'PROJECT_NO'            ,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'       ,type: 'string'},
                 {name: 'PUB_NUM'               ,text: '<t:message code="system.label.sales.billno" default="계산서번호"/>'         ,type: 'string'},
                 {name: 'EX_NUM'                ,text: '<t:message code="system.label.sales.slipno" default="전표번호"/>'           ,type: 'string'},
                 {name: 'BILL_NUM'              ,text: '<t:message code="system.label.sales.salesno" default="매출번호"/>'           ,type: 'string'},
                 {name: 'ORDER_NUM'             ,text: '<t:message code="system.label.sales.sono" default="수주번호"/>'           ,type: 'string'},
                 {name: 'DISCOUNT_RATE'         ,text: '<t:message code="system.label.sales.discountrate" default="할인율(%)"/>'          ,type: 'number'},                   
                 {name: 'PRICE_YN'              ,text: '<t:message code="system.label.sales.priceclass" default="단가구분"/>'           ,type: 'string', comboType: "AU", comboCode: "S003"},
                 {name: 'WGT_UNIT'              ,text: '<t:message code="system.label.sales.weightunit" default="중량단위"/>'           ,type: 'string'},
                 {name: 'UNIT_WGT'              ,text: '<t:message code="system.label.sales.unitweight" default="단위중량"/>'           ,type: 'string'},
                 {name: 'VOL_UNIT'              ,text: '<t:message code="system.label.sales.volumnunit" default="부피단위"/>'           ,type: 'string'},
                 {name: 'UNIT_VOL'              ,text: '<t:message code="system.label.sales.unitvolumn" default="단위부피"/>'           ,type: 'string'},
                 {name: 'COMP_CODE'             ,text: '<t:message code="system.label.sales.compcode" default="법인코드"/>'           ,type: 'string'},
                 {name: 'BILL_SEQ'              ,text: '계산서 순번'        ,type: 'string'},
                 
                 {name: 'SALE_AMT_WON'          ,text: '매출액(자사)'       ,type: 'uniPrice'},
                 {name: 'TAX_AMT_WON'           ,text: '세액(자사)'         ,type: 'uniPrice'},
                 {name: 'SUM_SALE_AMT_WON'      ,text: '매출계(자사)'       ,type: 'uniPrice'}
            ]
    });
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore2 = Unilite.createStore('sof800skrvMasterStore2',{
        model: 'sof800skrvModel2',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            useNavi: false          // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {          
                   read: 'ssa450skrvService.selectList1'                    
            }
        }
        ,loadStoreRecords: function()   {           
            var param= panelResult2.getValues();
//          var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
//          var deptCode = UserInfo.deptCode;   //부서코드
//          if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
//              param.DEPT_CODE = deptCode;
//          }
            console.log( param );
            this.load({
                params: param
            });         
        },
        groupField: 'SALE_CUSTOM_NAME'
    });
    
    
    
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	/*
	 * 
	var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',         
		defaultType: 'uniSearchSubPanel',
		items: [{     
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',   
			itemId: 'search_panel1',
		}]
	});
	
	
			borderItems:[ 
	 		 masterGrid,
			 panelSearch
		],
	
	*/	
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',		
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',   			
	    	items: [{ 
				fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelResult.getField('ORDER_PRSN');	
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.sodate" default="수주일"/>',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				xtype: 'uniDateRangefield',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('ORDER_DATE_FR',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ORDER_DATE_TO',newValue);
			    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
			    		
			    	}
			    }
			}, { 
		    	fieldLabel: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
	         	xtype: 'uniDateRangefield',
	         	startFieldName: 'DVRY_DATE_FR',
	         	endFieldName: 'DVRY_DATE_TO',	
	         	width: 315,							               
	         	colspan: 2,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('DVRY_DATE_FR',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DVRY_DATE_TO',newValue);
			    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
			    		
			    	}
			    }
			}, {
				fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
				name:'ORDER_TYPE',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'S002',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name:'ORDER_PRSN',
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'S010',
				multiSelect: true,
				typeAhead: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORDER_PRSN', newValue);
					}
				},
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},
				Unilite.popup('DEPT', { 
				fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				
				holdable: 'hold',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('DEPT_CODE', '');
						panelResult.setValue('DEPT_NAME', '');
					},
					applyextparam: function(popup){							
						var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;	//부서정보
						var divCode = '';					//사업장
						
						if(authoInfo == "A"){	//자기사업장	
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							
						}else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			})]	
   		}, {
   			title:'거래처정보',
   			id: 'search_panel2',
			itemId:'search_panel2',
        	defaultType: 'uniTextfield',
        	layout: {type: 'uniTable', columns: 1},
			items:[
				Unilite.popup('AGENT_CUST',{
				fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
				
				validateBlank: false, 
				extParam: {'CUSTOM_TYPE':'3'},
				listeners: {
					applyextparam: function(popup) {
						popup.setExtParam({'CUSTOM_TYPE':'3'});
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
				name:'AGENT_TYPE',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B055'  
			}, {
				fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
				name:'AREA_TYPE', 	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B056'  
			}]
		}, {	
			title:'품목정보',
        	defaultType: 'uniTextfield',
        	id: 'search_panel3',
        	itemId:'search_panel3',
        	layout: {type: 'uniTable', columns: 1},
			items:[
				Unilite.popup('DIV_PUMOK',{
	        	fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
	        	valueFieldName: 'ITEM_CODE', 
				textFieldName: 'ITEM_NAME', 
	        	listeners: {
					applyextparam: function(popup){							
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
		   }),
				Unilite.popup('ITEM_GROUP',{
				fieldLabel: '<t:message code="system.label.sales.repmodel" default="대표모델"/>',
				valueFieldName: 'ITEM_GROUP',
				textFieldName: 'ITEM_GROUP_NAME',
				validateBlank:false, 
				popupWidth: 710,
				colspan: 2
			}),{
				fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				name: 'TXTLV_L1', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
				child: 'TXTLV_L2'
			}, {
				fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
				name: 'TXTLV_L2', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
				child: 'TXTLV_L3'
			}, {
				fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
				name: 'TXTLV_L3', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('itemLeve3Store'), 
				parentNames:['TXTLV_L1','TXTLV_L2'],
	            levelType:'ITEM'
				
			}]
		}, {	
			title:'수주정보',
			id: 'search_panel4',
			itemId:'search_panel4',			
    		defaultType: 'uniTextfield',
    		layout: {type: 'uniTable', columns: 1},
    		items:[{
		 	 	xtype: 'container',
	   			defaultType: 'uniNumberfield',
				layout: {type: 'hbox', align:'stretch'},
				width:325,
				margin:0,
				items:[{
					fieldLabel:'<t:message code="system.label.sales.soqty" default="수주량"/>',
					suffixTpl:'&nbsp;~&nbsp;',
					name: 'FR_ORDER_QTY',
					width:218
				}, {
					name: 'TO_ORDER_QTY',
					width:107
				}]
			}, {
		 	 	xtype: 'container',
	   			defaultType: 'uniNumberfield',
				layout: {type: 'hbox', align:'stretch'},
				width:325,
				margin:0,
				items:[{
					fieldLabel:'<t:message code="system.label.sales.sono" default="수주번호"/>',
					suffixTpl:'&nbsp;~&nbsp;',
					name: 'FR_ORDER_NUM',
					width:218
				}, {
					name: 'TO_ORDER_NUM',
					width:107
				}] 
			}, {
				fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>',
				name:'TXT_CREATE_LOC', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B031'
			}, {
	    		xtype: 'radiogroup',		            		
	    		fieldLabel: '<t:message code="system.label.sales.closingyn" default="마감여부"/>',
	    		id: 'ORDER_STATUS',
//	    		name: 'ORDER_STATUS',
	    		items: [{
	    			boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
	    			width: 50,
	    			name: 'ORDER_STATUS',
	    			inputValue: '%',
	    			checked: true
	    		}, {
	    			boxLabel: '<t:message code="system.label.sales.closing" default="마감"/>',
	    			width: 60, name: 'ORDER_STATUS',
	    			inputValue: 'Y'
	    		}, {
	    			boxLabel: '미마감',
	    			width: 80, name: 'ORDER_STATUS',
	    			inputValue: 'N'
	    		}]
	        }, {
	    		fieldLabel: '상태',
	    		xtype: 'radiogroup',
	    		id: 'rdoSelect2',
//	    		name: 'rdoSelect2',
	    		items: [{
	    			boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
	    			width: 50,
	    			name: 'rdoSelect2', 
	    			inputValue: 'A',
	    			checked: true
	    		}, {
	    			boxLabel: '미승인', 
	    			width: 60, name: 'rdoSelect2',
	    			inputValue: 'N'
	    		}, {
	    			boxLabel: '승인',
	    			width: 50, name: 'rdoSelect2',
	    			inputValue: '6'
	    		}, {
	    			boxLabel: '반려',
	    			width: 50, name: 'rdoSelect2',
	    			inputValue: '5'
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
   						var labelText = invalid.items[0]['fieldLabel']+' : ';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
   					}

				   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
				   	invalid.items[0].focus();
				}
	  		}
			return r;
  		}
	});
	
	
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
				fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelSearch.getField('ORDER_PRSN');	
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.sodate" default="수주일"/>',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				xtype: 'uniDateRangefield',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('ORDER_DATE_FR',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('ORDER_DATE_TO',newValue);
			    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
			    		
			    	}
			    }
			}, { 
		    	fieldLabel: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
	         	xtype: 'uniDateRangefield',
	         	startFieldName: 'DVRY_DATE_FR',
	         	endFieldName: 'DVRY_DATE_TO',	
	         	width: 315,							               
	         	colspan: 2,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('DVRY_DATE_FR',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('DVRY_DATE_TO',newValue);
			    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
			    		
			    	}
			    }
			}, {
				fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
				name:'ORDER_TYPE',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'S002',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ORDER_TYPE', newValue);
					}
				}
			}, {
				fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name:'ORDER_PRSN',
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'S010',
				multiSelect: true,
				typeAhead: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ORDER_PRSN', newValue);
					}
				},
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},
			Unilite.popup('DEPT', { 
			fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
			valueFieldName: 'DEPT_CODE',
	   	 	textFieldName: 'DEPT_NAME',
			
			holdable: 'hold',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
						panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
                	},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('DEPT_CODE', '');
					panelSearch.setValue('DEPT_NAME', '');
				},
				applyextparam: function(popup){							
					var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
					var deptCode = UserInfo.deptCode;	//부서정보
					var divCode = '';					//사업장
					
					if(authoInfo == "A"){	//자기사업장	
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						
					}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						
					}else if(authoInfo == "5"){		//부서권한
						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}
				}
			}
		})]	
    });
    
    
    
        var panelResult2 = Unilite.createSearchForm('resultForm2',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
            fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
            name: 'DIV_CODE',
            xtype: 'uniCombobox',
            comboType: 'BOR120',
            value: UserInfo.divCode,
            allowBlank: false,
            listeners: {
                change: function(combo, newValue, oldValue, eOpts) {    
                    combo.changeDivCode(combo, newValue, oldValue, eOpts);
                    var field = panelSearch.getField('SALE_PRSN');  
                    field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult2의 필터링 처리 위해..
                    panelSearch.setValue('DIV_CODE', newValue);
                }
            }
        },
        Unilite.popup('AGENT_CUST',{
            fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
            
            extParam: {'CUSTOM_TYPE': '3'},
            valueFieldName: 'SALE_CUSTOM_CODE',
            textFieldName: 'SALE_CUSTOM_NAME',
            colspan: 2,
            listeners: {
                onSelected: {
                    fn: function(records, type) {
                        panelSearch.setValue('SALE_CUSTOM_CODE', panelResult2.getValue('SALE_CUSTOM_CODE'));
                        panelSearch.setValue('SALE_CUSTOM_NAME', panelResult2.getValue('SALE_CUSTOM_NAME'));                                                                                                         
                    },
                    scope: this
                },
                onClear: function(type) {
                    panelSearch.setValue('SALE_CUSTOM_CODE', '');
                    panelSearch.setValue('SALE_CUSTOM_NAME', '');
                }/*,  거래처팝업 고객구분(AGENT_TYPE) 의 필터 처리
                applyextparam: function(popup){
                    if(Ext.isDefined(panelSearch)){
                        popup.setExtParam({'AGENT_CUST_FILTER': ['3']});
                    }
                }*/
            }
        }), {
            fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
            width: 315,
            xtype: 'uniDateRangefield',
            allowBlank: false,
            startFieldName: 'SALE_FR_DATE',
            endFieldName: 'SALE_TO_DATE',
            //startDate: UniDate.get('startOfMonth'),
            startDate: UniDate.get('today'),
            endDate: UniDate.get('today'),                  
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('SALE_FR_DATE',newValue);
                    //panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
                    
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelSearch) {
                    panelSearch.setValue('SALE_TO_DATE',newValue);
                    //panelSearch.getField('ISSUE_REQ_DATE_TO').validate();                         
                }
            }
        },{
            fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'  ,
            name: 'SALE_PRSN',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'S010',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('SALE_PRSN', newValue);
                }
            },
            onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
                if(eOpts){
                    combo.filterByRefCode('refCode1', newValue, eOpts.parent);
                }else{
                    combo.divFilterByRefCode('refCode1', newValue, divCode);
                }
            }
        },
            Unilite.popup('DIV_PUMOK', {
            fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
            
            listeners: {
                onSelected: {
                    fn: function(records, type) {
                        panelSearch.setValue('ITEM_CODE', panelResult2.getValue('ITEM_CODE'));
                        panelSearch.setValue('ITEM_NAME', panelResult2.getValue('ITEM_NAME'));                                                                                                           
                    },
                    scope: this
                },
                onClear: function(type) {
                    panelSearch.setValue('ITEM_CODE', '');
                    panelSearch.setValue('ITEM_NAME', '');
                },
                applyextparam: function(popup){                         
                    popup.setExtParam({'DIV_CODE': panelResult2.getValue('DIV_CODE')});
                }
            }
        })
        /*, {
            fieldLabel: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>',
            name: 'ITEM_ACCOUNT',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B020',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('ITEM_ACCOUNT', newValue);
                }
            }
        }, {
            xtype: 'radiogroup',
            fieldLabel: '매출기표유무',
            //name: 'SALE_YN',
            items: [{
                boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
                width: 50,
                name: 'SALE_YN',
                inputValue: 'A',
                checked: true  
            }, {
                boxLabel: '<t:message code="system.label.sales.slipposting" default="기표"/>', 
                width: 50,
                name: 'SALE_YN',
                inputValue: 'Y'
            }, {
                boxLabel: '<t:message code="system.label.sales.notslipposting" default="미기표"/>',
                width: 70,
                name: 'SALE_YN',
                inputValue: 'N'
            }],
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    //panelSearch.getField('SALE_YN').setValue({SALE_YN: newValue});
                    panelSearch.getField('SALE_YN').setValue(newValue.SALE_YN);
                }
            }
       },{
            fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>',
            name: 'TXT_CREATE_LOC',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'B031',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('TXT_CREATE_LOC', newValue);
                }
            }
        }, {
            fieldLabel: '<t:message code="system.label.sales.vattype" default="부가세유형"/>',
            name: 'BILL_TYPE',
            xtype: 'uniCombobox',
            comboType: 'AU',
            comboCode: 'S024',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('BILL_TYPE', newValue);
                }
            }
        }*/]    
    });
    
    
    
    
    
	/**
     * Master Grid1 정의(Grid Panel),
     * @type 
     */
    var masterGrid1 = Unilite.createGrid('sof800skrvGrid1', {
    	layout: 'fit', 
    	//layout: 'border', //fit->border 로 변경 5.0.1
    	//split: false,		//locking split panel
    	region:'center',
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
    	store: directMasterStore1,
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
            
        columns: [        
			{dataIndex: 'ITEM_CODE'		 		, width: 133, locked: false}, 				
			{dataIndex: 'ITEM_NAME'		 		, width: 166, locked: false}, 				
			{dataIndex: 'SPEC'			 		, width: 133, locked: false}, 				
			{dataIndex: 'ORDER_UNIT'		 	, width: 53, locked: false, align: 'center'}, 				
			{dataIndex: 'PRICE_TYPE'		 	, width: 80, hidden: true}, 				
			{dataIndex: 'TRANS_RATE'		 	, width: 106, align: 'right',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
            		return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
            }}, 				
			{dataIndex: 'ORDER_UNIT_Q'	 		, width: 106, summaryType: 'sum'}, 				
			{dataIndex: 'ORDER_WGT_Q'	 		, width: 106, hidden: true},		
			{dataIndex: 'ORDER_VOL_Q'	 		, width: 106, hidden: true},				
			{dataIndex: 'STOCK_UNIT'		 	, width: 53, hidden: true}, 				
			{dataIndex: 'STOCK_Q'		 		, width: 106,hidden: true}, 				
			{dataIndex: 'MONEY_UNIT'		 	, width: 53}, 				
			{dataIndex: 'ORDER_P'		 		, width: 106}, 				
			{dataIndex: 'ORDER_WGT_P'	 		, width: 106, hidden: true}, 				
			{dataIndex: 'ORDER_VOL_P'	 		, width: 106, hidden: true},				
//			{dataIndex: 'ORDER_O'		 		, width: 120, summaryType: 'sum'}, 				
			{dataIndex: 'ORDER_O'               , width: 120},
			{dataIndex: 'EXCHG_RATE_O'	 		, width: 66, align: 'right'}, 				
			{dataIndex: 'SO_AMT_WON'		 	, width: 120, summaryType: 'sum'}, 				
			{dataIndex: 'TAX_TYPE'		 		, width: 100, align: 'center'}, 				
//			{dataIndex: 'ORDER_TAX_O'	 		, width: 125, summaryType: 'sum'}, 				
			{dataIndex: 'ORDER_TAX_O'           , width: 125},
			{dataIndex: 'WGT_UNIT'		 		, width: 66, hidden: true}, 				
			{dataIndex: 'UNIT_WGT'		 		, width: 80, hidden: true}, 				
			{dataIndex: 'VOL_UNIT'		 		, width: 66, hidden: true}, 				
			{dataIndex: 'UNIT_VOL'		 		, width: 80, hidden: true}, 				
			{dataIndex: 'CUSTOM_CODE2'	 		, width: 100}, 				
			{dataIndex: 'CUSTOM_NAME2'	 		, width: 133}, 				
			{dataIndex: 'ORDER_DATE'		 	, width: 93}, 				
			{dataIndex: 'ORDER_TYPE'		 	, width: 133}, 				
			{dataIndex: 'ORDER_TYPE_NM'	 		, width: 133, hidden: true}, 				
			{dataIndex: 'ORDER_NUM'		 		, width: 100}, 				
			{dataIndex: 'SER_NO'			 	, width: 53, align:'center'}, 				
			{dataIndex: 'ORDER_PRSN'		 	, width: 66}, 				
			{dataIndex: 'ORDER_PRSN_NM'	 		, width:133, hidden: true}, 				
			{dataIndex: 'PROJECT_NO'            , width:100},
			{dataIndex: 'PO_NUM'			 	, width:86}, 				
			{dataIndex: 'DVRY_DATE2'		 	, width:93}, 				
			{dataIndex: 'DVRY_TIME'		 		, width:66, hidden: true}, 				
			{dataIndex: 'DVRY_CUST_NM'	 		, width:100}, 				
			{dataIndex: 'PROD_END_DATE'	 		, width:106}, 				
			{dataIndex: 'PROD_Q'			 	, width:90, summaryType: 'sum'}, 				
			{dataIndex: 'ORDER_STATUS'	 		, width:90},				
			{dataIndex: 'SORT_KEY'		 		, width:106, hidden: true}, 				
			{dataIndex: 'CREATE_LOC'		 	, width:106, hidden: true},
			{dataIndex: 'REMARK'				, width:200}
		] 
    });
    
    
     
    var masterGrid2 = Unilite.createGrid('sof800skrvGrid2', {
        // for tab
        region: 'center',
        //layout: 'fit',    
        syncRowHeight: false,   
        store: directMasterStore2,
        features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
                    {id: 'masterGridTotal',     ftype: 'uniSummary',  showSummaryRow: false} ],
        columns:  [        
                     { dataIndex: 'SALE_CUSTOM_CODE'                    ,           width: 80, locked: false,
                        summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                   return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.totalamount" default="합계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
            }},             
                    { dataIndex: 'SALE_CUSTOM_NAME'         ,           width: 100, locked: false },        //거래처명
                    { dataIndex: 'BILL_TYPE'                ,           width: 80},                         //부가세유형
                    { dataIndex: 'SALE_DATE'                ,           width: 80},                         //매출일
                    { dataIndex: 'INOUT_TYPE_DETAIL'        ,           width: 123},                        //출고유형
                    { dataIndex: 'ITEM_CODE'                ,           width: 123},                        //품목코드
                    { dataIndex: 'ITEM_NAME'                ,           width: 123 },                       //품명
                    { dataIndex: 'SPEC'                     ,           width: 123 },                       //규격
                    { dataIndex: 'MONEY_UNIT'               ,           width: 80},                         //화폐
                    { dataIndex: 'EXCHG_RATE_O'             ,           width: 80, align: 'right'},         //환율
                    { dataIndex: 'SALE_UNIT'                ,           width: 53, align: 'center'},        //단위
                    { dataIndex: 'TRANS_RATE'               ,           width: 53, align: 'right'},         //입수
                    { dataIndex: 'SALE_Q'                   ,           width: 80, summaryType: 'sum'},     //매출량
                    { dataIndex: 'PRICE_TYPE'               ,           width: 53, hidden: true},           //단가구분
                    { dataIndex: 'SALE_P'                   ,           width: 113 },                       //단가
                    { dataIndex: 'SALE_LOC_AMT_F'           ,           width: 113},    //매출액(외화)
                    { dataIndex: 'TAX_AMT_O'                ,           width: 113},    //세액                     
                    { dataIndex: 'SUM_SALE_AMT'             ,           width: 113},   //매출계
                  
                    { dataIndex: 'SALE_AMT_WON'             ,           width: 113, summaryType: 'sum'},   //매출액(자사)
                    { dataIndex: 'TAX_AMT_WON'              ,           width: 113, summaryType: 'sum'},   //세액(자사)
                    { dataIndex: 'SUM_SALE_AMT_WON'         ,           width: 113, summaryType: 'sum'},   //매출계(자사)
                    
                    { dataIndex: 'DISCOUNT_RATE'            ,           width: 106 },                       //할인율(%)      
                    { dataIndex: 'SALE_LOC_AMT_I'           ,           width: 113, summaryType: 'sum' },   //매출액
                    { dataIndex: 'TAX_TYPE'                 ,           width: 80, align: 'center'},        //과세여부
                    
//                  { dataIndex: 'CONSIGNMENT_FEE'          ,           width: 113},
                                   
                    { dataIndex: 'ORDER_TYPE'               ,           width: 100 },                       //판매유형
                    { dataIndex: 'CUSTOM_CODE'              ,           width: 80},                         //수주거래처       
                    { dataIndex: 'CUSTOM_NAME'              ,           width: 113 },                       //수주거래처명
                    { dataIndex: 'SALE_WGT_Q'               ,           width: 100, hidden: true },         //매출량(중량)     
                    { dataIndex: 'SALE_VOL_Q'               ,           width: 80, hidden: true},           //매출량(부피)       
                    { dataIndex: 'SALE_FOR_WGT_P'           ,           width: 113, hidden: true },         //단가(중량)
                    { dataIndex: 'SALE_FOR_VOL_P'           ,           width: 113, hidden: true},          //단가(부피)         
                    { dataIndex: 'DIV_CODE'                 ,           width: 100 },                       //사업장      
                    { dataIndex: 'SALE_PRSN'                ,           width: 100},                        //영업담당       
                    { dataIndex: 'MANAGE_CUSTOM'            ,           width: 80},                         //집계거래처              
                    { dataIndex: 'MANAGE_CUSTOM_NM'         ,           width: 113 },                       //집계거래처명          
                    { dataIndex: 'AREA_TYPE'                ,           width: 66 },                        //지역                    
                    { dataIndex: 'AGENT_TYPE'               ,           width: 113 },                       //거래처분류
                    { dataIndex: 'PROJECT_NO'               ,           width: 113},                        //프로젝트번호              
                    { dataIndex: 'PUB_NUM'                  ,           width: 80},                         //계산서번호
                    { dataIndex: 'EX_NUM'                   ,           width: 93 },                        //전표번호
                    { dataIndex: 'BILL_NUM'                 ,           width: 106 },                       //매출번호
                    { dataIndex: 'ORDER_NUM'                ,           width: 106 },                       //수주번호
                    { dataIndex: 'PRICE_YN'                 ,           width: 106 },                       //단가구분
                    { dataIndex: 'WGT_UNIT'                 ,           width: 106, hidden: true },         //중량단위
                    { dataIndex: 'UNIT_WGT'                 ,           width: 106, hidden: true },         //단위중량
                    { dataIndex: 'VOL_UNIT'                 ,           width: 106, hidden: true },         //부피단위
                    { dataIndex: 'UNIT_VOL'                 ,           width: 106, hidden: true },         //단위부피
                    { dataIndex: 'COMP_CODE'                ,           width: 106, hidden: true },         //법인코드
                    { dataIndex: 'BILL_SEQ'                 ,           width: 106, hidden: true },         //계산서 순번
                    { dataIndex: 'CREATE_LOC'               ,           width: 80 }                         //생성경로
                    
          ] 
    });   
    
    
	var tab = Unilite.createTabPanel('tabPanel',{
        activeTab: 0,
        region: 'center',
        items: [{
                title: '수주현황조회',
                xtype: 'container',
				region:'center',
				layout: 'border',
				border: false,
				items:[ masterGrid1, panelResult ],
				id: 'sof800skrvGridTab1'
        },{
                title: '매출현황조회',
                xtype: 'container',
				region:'center',
				layout: 'border',
				border: false,
				items:[ masterGrid2, panelResult2 ],
				id: 'sof800skrvGridTab2'
        }]
    });
    
    Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[{
				region : 'center',
				xtype  : 'container',
				layout : 'fit',
				items:[ tab ]
			}]
		}, panelSearch],
		
		id: 'sof800skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
//			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//        	panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
        	panelSearch.setValue('ORDER_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('ORDER_DATE_TO')));
        	
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
//        	panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
//        	panelResult.setValue('DEPT_NAME', UserInfo.deptName); 
        	panelResult.setValue('ORDER_DATE_TO', UniDate.get('today'));
			panelResult.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('ORDER_DATE_TO')));		
			
//			panelSearch.getField('ORDER_STATUS').setValue('%');
//			panelSearch.getField('rdoSelect2').setValue('A');
			
			var pCombo	= panelSearch.getField('DIV_CODE');
			var combo 	= panelSearch.getField('ORDER_PRSN').filterByRefCode('refCode1', pCombo.getValue(), pCombo);
			
			var field = panelSearch.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
//			var field = panelResult.getField('ORDER_PRSN');
//			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
		},
		onQueryButtonDown: function()	{
			var activeTabId = tab.getActiveTab().getId();
			
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
	    	
	    	if(activeTabId == 'sof800skrvGridTab1'){			
				masterGrid1.getStore().loadStoreRecords();
				var viewNormal = masterGrid1.getView();
				console.log("viewNormal : ",viewNormal);
			    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			}
			else if(activeTabId == 'sof800skrvGridTab2'){
//				masterGrid2.getStore().loadStoreRecords();
				directMasterStore2.loadStoreRecords();
	            var viewLocked = masterGrid2.getView();
	            var viewNormal = masterGrid2.getView();
	            viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
	            viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
	            viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
	            viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true); 
			} 
		    
		},
		    
        onDetailButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();
	    	if(activeTabId == 'sof800skrvGridTab2'){
	            var as = Ext.getCmp('AdvanceSerch');    
	            if(as.isHidden())   {
	                as.show();
	            }else {
	                as.hide()
	            }
	    	}
        },
        
		onResetButtonDown: function() {
			var activeTabId = tab.getActiveTab().getId();
	    	if(activeTabId == 'sof800skrvGridTab1'){	
				panelSearch.clearForm();
				panelResult.clearForm();
				masterGrid1.getStore().loadData({})
	    	}
			
			else if(activeTabId == 'sof800skrvGridTab2'){
				panelResult2.clearForm();
	            masterGrid2.getStore().loadData({})
			}
	            this.fnInitBinding();
		}
		
		
		
		
		
//        fnInitBinding: function() {
//            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
////          panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
////          panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
//            panelSearch.setValue('SALE_TO_DATE', UniDate.get('today'));
//            panelSearch.setValue('SALE_FR_DATE', UniDate.get('today'));
//            //panelSearch.setValue('SALE_FR_DATE', UniDate.get('startOfMonth', panelSearch.getValue('SALE_TO_DATE')));
//            
//            panelResult.setValue('DIV_CODE',UserInfo.divCode);
////          panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
////          panelResult.setValue('DEPT_NAME', UserInfo.deptName);
//            panelResult.setValue('SALE_TO_DATE', UniDate.get('today'));
//            panelResult.setValue('SALE_FR_DATE', UniDate.get('today'));
//            //panelResult.setValue('SALE_FR_DATE', UniDate.get('startOfMonth', panelSearch.getValue('SALE_TO_DATE')));
//            
//            var field = panelSearch.getField('SALE_PRSN');
//            field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
//            var field = panelResult.getField('SALE_PRSN');
//            field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
//        },
//        onQueryButtonDown: function()   {          
//    
//        },  
//        onResetButtonDown: function() {
//            
//        }
	});
};
</script>
