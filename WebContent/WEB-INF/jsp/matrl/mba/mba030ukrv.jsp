<%@page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="foren.framework.utils.*" %>
<%
	String extjsVersion = ConfigUtil.getString("extjs.version", "4.2.2");
	request.setAttribute("ext_root", "extjs_"+extjsVersion);
%>
<t:appConfig pgmId="mba030ukrv"  >
<t:ExtComboStore comboType="BOR120"  />			<!-- 사업장 -->
<t:ExtComboStore comboType="AU" comboCode="A004" /> <!-- 사용여부 -->
<t:ExtComboStore comboType="AU" comboCode="B013" /> <!-- 품목계정 -->
<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 재고단위 -->
<t:ExtComboStore comboType="AU" comboCode="A020" /> <!-- LOT관리 -->
<t:ExtComboStore comboType="AU" comboCode="M105" /> <!-- 사급구분 -->
<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />

</t:appConfig>
<link rel="stylesheet" type="text/css" href='<c:url value="/${ext_root}/app/Ext/ux/css/GroupTabPanel.css" />' />
<script type="text/javascript" >



function appMain() {
    var excelWindow;    // 엑셀참조
	//BOM 참조 WINDOW
	var bomCopyWindow;
	//기존 P/L 참조 WINDOW
	var custCopyWindow;
	//외주처 참조 WINDOW
	var partListCopyWindow;

	var gsSpec			= '';
	var gsCustomCode	= '';
	var gsCustomName	= '';

	var plActiveGridId = 'mba030ukrsGrid3_1'; //외주 P/L 등록 active 그리드 변수
	/* 단위환산정보등록 */
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read	: 'mba030ukrvService.select',
				create	: 'mba030ukrvService.insertDetail',
				update	: 'mba030ukrvService.updateDetail',
				destroy	: 'mba030ukrvService.deleteDetail',
				syncAll	: 'mba030ukrvService.saveAll'
			}
	 });
	/* 구매단가/거래처품목등록 */
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read	: 'mba030ukrvService.select2'
			}
	 });
	 /* 구매단가/거래처품목등록2 */
	 var directProxy2_1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
           read    : 'mba030ukrvService.select2_1',
           create  : 'mba030ukrvService.insertDetail2_1',
           update  : 'mba030ukrvService.updateDetail2_1',
           destroy : 'mba030ukrvService.deleteDetail2_1',
           syncAll : 'mba030ukrvService.saveAll2_1'
        }
    });

	/* 외주 P/L 등록1 */
	var directProxy3_1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'mba030ukrvService.select3_1',
			update	: 'mba030ukrvService.updateDetail3_1',
			create	: 'mba030ukrvService.insertDetail3_1',
			destroy	: 'mba030ukrvService.deleteDetail3_1',
			syncAll	: 'mba030ukrvService.saveAll3_1'
		}
	 });

   /* 외주 P/L 등록2 */
    var directProxy3_2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read    : 'mba030ukrvService.select3_2',
            update  : 'mba030ukrvService.updateDetail3_2',
            create  : 'mba030ukrvService.insertDetail3_2',
            destroy : 'mba030ukrvService.deleteDetail3_2',
            syncAll : 'mba030ukrvService.saveAll3_2'
        }
     });
	/* 외주 기초재고 등록 */
	var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'mba030ukrvService.selectList4',
			create	: 'mba030ukrvService.insertDetail4',
			update	: 'mba030ukrvService.updateDetail4',
			destroy	: 'mba030ukrvService.deleteDetail4',
			syncAll	: 'mba030ukrvService.saveAll4'
		}
	 });



	Unilite.defineModel('mba030ukrvs1Model', {
		fields: [
				{name: 'STOCK_UNIT'				,text:'<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			,type : 'string'		,comboType: 'AU', comboCode: 'B013', displayField: 'value' , allowBlank: false},
				{name: 'ORDER_UNIT'				,text:'<t:message code="system.label.purchase.conversionunit" default="변환단위"/>'			,type : 'string'		,comboType: 'AU', comboCode: 'B013', displayField: 'value' , allowBlank: false},
				{name: 'TRNS_RATE'				,text:'<t:message code="system.label.purchase.containedqty" default="입수"/>'				,type : 'uniER'},
				{name: 'ITEM_CHG'				,text:'ITEM_CHG 품목일괄적용유무(hidden)'	,type : 'string'},
				{name: 'UPDATE_DATE'			,text:'<t:message code="system.label.purchase.lastchangedate" default="최종변경일"/>'			,type : 'uniDate'},
				{name: 'COMP_CODE'				,text:'COMP_CODE'			,type : 'string'}
			]
	});

	var mba030ukrvs1Store = Unilite.createStore('mba030ukrvs1Store',{
		model: 'mba030ukrvs1Model',
		autoLoad: false,
		uniOpt : {
			isMaster	: true,				// 상위 버튼 연결
			editable	: true,				// 수정 모드 사용
			deletable	: true,				// 삭제 가능 여부
			useNavi	: false				// prev | next 버튼 사용
		},
		proxy: directProxy,

		loadStoreRecords : function(){
			var param= panelDetail.down('#tab_tranUnit').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},

		saveStore : function(config){
			var inValidRecs = this.getInvalidRecords();
//			var toCreate = this.getNewRecords();
//			var toUpdate = this.getUpdatedRecords();
//			console.log("toUpdate",toUpdate);

			var rv = true;

			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
//						panelDetail.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			}else {
				panelDetail.down('#mba030ukrsGrid1').uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});



	Unilite.defineModel('mba030ukrvs2Model', {
		fields: [{name: 'ITEM_CODE'           ,text:'<t:message code="system.label.purchase.itemcode" default="품목코드"/>'        ,type: 'string'},
                 {name: 'ITEM_NAME'         ,text:'<t:message code="system.label.purchase.itemname2" default="품명"/>'          ,type: 'string'},
                 {name: 'SPEC'              ,text:'<t:message code="system.label.purchase.spec" default="규격"/>'          ,type: 'string'},
                 {name: 'STOCK_UNIT'        ,text:'<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'        ,type: 'string', displayField: 'value'},
                 {name: 'SALE_UNIT'         ,text:'<t:message code="system.label.purchase.salesunit" default="판매단위"/>'        ,type: 'string', displayField: 'value'},
                 {name: 'BASIS_P'           ,text:'<t:message code="system.label.purchase.sellingprice" default="판매단가"/>'        ,type: 'uniUnitPrice'},
                 {name: 'DOM_FORIGN'        ,text:'<t:message code="system.label.purchase.domforign" default="내외자구분"/>'       ,type: 'string'},
                 {name: 'ITEM_ACCOUNT'      ,text:'<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'        ,type: 'string'},
                 {name: 'TRNS_RATE'         ,text:'<t:message code="system.label.purchase.containedqty" default="입수"/>'          ,type: 'uniQty'}
		]
	});

	var mba030ukrvs2Store = Unilite.createStore('mba030ukrvs2Store',{
		model: 'mba030ukrvs2Model',
		autoLoad: false,
		uniOpt : {
			isMaster	: true,				// 상위 버튼 연결
			editable	: true,				// 수정 모드 사용
			deletable	: true,				// 삭제 가능 여부
			useNavi	: false				// prev | next 버튼 사용
		},
		proxy: directProxy2,

		loadStoreRecords : function(){
			var param= Ext.getCmp('tab_unitPrice').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		saveStore : function(config){
			var inValidRecs = this.getInvalidRecords();
//			var toCreate = this.getNewRecords();
//			var toUpdate = this.getUpdatedRecords();
//			console.log("toUpdate",toUpdate);

			var rv = true;

			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
//						panelDetail.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			}else {
				panelDetail.down('#mba030ukrsGrid2').uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});



	Unilite.defineModel('mba030ukrvs2Model1', {
		fields: [{name: 'TYPE'                    ,text:'<t:message code="system.label.purchase.type" default="타입"/>'          ,type: 'string'},
                 {name: 'ITEM_CODE'             ,text:'<t:message code="system.label.purchase.itemcode" default="품목코드"/>'        ,type: 'string'},
                 {name: 'CUSTOM_CODE'           ,text:'<t:message code="system.label.purchase.clientcode" default="고객코드"/>'        ,type: 'string', allowBlank: false, maxLength: 8},
                 {name: 'CUSTOM_NAME'           ,text:'<t:message code="system.label.purchase.clientname" default="고객명"/>'         ,type: 'string', maxLength: 20},
                 {name: 'MONEY_UNIT'            ,text:'<t:message code="system.label.purchase.currencyunit" default="화폐단위"/>'        ,type: 'string', allowBlank: false, maxLength: 3, comboType: 'AU', comboCode: 'B004', displayField: 'value' },
                 {name: 'ORDER_UNIT'            ,text:'<t:message code="system.label.purchase.salesunit" default="판매단위"/>'        ,type: 'string', displayField: 'value', allowBlank: false, maxLength: 3, comboType: 'AU', comboCode: 'B013' },
                 {name: 'ITEM_P'                ,text:'<t:message code="system.label.purchase.sellingprice" default="판매단가"/>'        ,type: 'uniUnitPrice', allowBlank: false, maxLength: 18},
                 {name: 'APLY_START_DATE'       ,text:'<t:message code="system.label.purchase.applystartdate" default="적용시작일"/>'       ,type: 'uniDate', allowBlank: false, maxLength: 8},
                 {name: 'DIV_CODE'              ,text:'<t:message code="system.label.purchase.division" default="사업장"/>'         ,type: 'string'},
                 {name: 'UPDATE_DB_USER'        ,text:'<t:message code="system.label.purchase.updateuser" default="수정자"/>'         ,type: 'string'},
                 {name: 'UPDATE_DB_TIME'        ,text:'<t:message code="system.label.purchase.updatedate" default="수정일"/>'         ,type: 'uniDate'},
                 {name: 'REMARK'                ,text:'<t:message code="system.label.purchase.remarks" default="비고"/>'          ,type: 'string', maxLength: 100},
                 {name: 'COMP_CODE'             ,text:'COMP_CODE'       ,type: 'string'}
		]
	});

	var mba030ukrvs2Store1 = Unilite.createStore('mba030ukrvs2Store1',{
		model: 'mba030ukrvs2Model1',
		autoLoad: false,
		uniOpt : {
			isMaster	: true,				// 상위 버튼 연결
			editable	: true,				// 수정 모드 사용
			deletable	: true,				// 삭제 가능 여부
			useNavi	: false				// prev | next 버튼 사용
		},
		proxy: directProxy2_1,

		loadStoreRecords : function(){
			var param= Ext.getCmp('tab_unitPrice').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		saveStore : function(config){
			var inValidRecs = this.getInvalidRecords();
//			var toCreate = this.getNewRecords();
//			var toUpdate = this.getUpdatedRecords();
//			console.log("toUpdate",toUpdate);

			var rv = true;

			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
//						panelDetail.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			}else {
				panelDetail.down('#mba030ukrsGrid2_1').uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});



	Unilite.defineModel('mba030ukrvs3_1Model', {
		fields: [
			{name: 'SEQ'					,text: '<t:message code="system.label.purchase.seq" default="순번"/>'				,type: 'int'},
			{name: 'COMP_CODE'				,text: 'COMP_CODE'			,type: 'string'},
			{name: 'DIV_CODE'				,text: '<t:message code="system.label.purchase.division" default="사업장"/>'				,type: 'string'},
			{name: 'CUSTOM_CODE'			,text: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>'				,type: 'string'},
			{name: 'PROD_ITEM_CODE'			,text: '<t:message code="system.label.purchase.parentitemcode" default="모품목코드"/>'			,type: 'string'},
			{name: 'ITEM_CODE'				,text: '<t:message code="system.label.purchase.childitemcode" default="자품목코드"/>'			,type: 'string'		,allowBlank: false},
			{name: 'ITEM_NAME'				,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				,type: 'string'},
			{name: 'SPEC'					,text: '<t:message code="system.label.purchase.spec" default="규격"/>'				,type: 'string'},
			{name: 'STOCK_UNIT'				,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			,type: 'string'		,comboType: 'AU'		,comboCode: 'B013', displayField: 'value'},
			{name: 'ITEM_ACCOUNT'			,text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'			,type: 'string'},
			{name: 'OLD_PATH_CODE'			,text: 'OLD_PATH_CODE'		,type: 'string'},
			{name: 'PATH_CODE'				,text: 'PATH_CODE'			,type: 'string'},
			{name: 'UNIT_Q'					,text: '<t:message code="system.label.purchase.originunitqty" default="원단위량"/>'			,type: 'number'	, defaultValue:1,type: 'float', decimalPrecision: 6, format:'0,000.000000',allowBlank: false},
			{name: 'PROD_UNIT_Q'			,text: '<t:message code="system.label.purchase.parentitembaseqty" default="모품목기준수"/>'		,type: 'uniQty'		,allowBlank: false},
			{name: 'LOSS_RATE'				,text: '<t:message code="system.label.purchase.lossrate" default="Loss율"/>'				,type: 'uniER'		,allowBlank: true},
			{name: 'USE_YN'					,text: '<t:message code="system.label.purchase.useyn" default="사용여부"/>'			,type: 'string'		,allowBlank: false		,comboType: 'AU'		,comboCode: 'A004'},
			{name: 'START_DATE'				,text: '<t:message code="system.label.purchase.startdate" default="시작일"/>'				,type: 'uniDate'	,allowBlank: false},
			{name: 'STOP_DATE'				,text: '<t:message code="system.label.purchase.enddate" default="종료일"/>'				,type: 'uniDate'},
			{name: 'GRANT_TYPE'				,text: '<t:message code="system.label.purchase.subcontractdivision" default="사급구분"/>'			,type: 'string'		,allowBlank: false		,comboType: 'AU'		,comboCode: 'M105'},
			{name: 'REMARK'					,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				,type: 'string'},
			{name: 'UPDATE_DB_USER'			,text: 'UPDATE_DB_USER'		,type: 'string'},
		 	{name: 'UPDATE_DB_TIME'			,text: 'UPDATE_DB_TIME'		,type: 'string'}
		  ]
	});

	var useYnStore = Unilite.createStore('mba030ukrvUseYnStore', {
        fields: ['text', 'value'],
        data :  [
                    {'text':'예'     , 'value':'1'},
                    {'text':'아니오'   , 'value':'2'}
                ]
    });

	Unilite.defineModel('mba030ukrvs3_2Model', {
        fields: [
             {name: 'COMP_CODE'              ,text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'       ,type: 'string', defaultValue: UserInfo.compCode},
             {name: 'DIV_CODE'              ,text: '<t:message code="system.label.purchase.division" default="사업장"/>'        ,type: 'string', defaultValue: UserInfo.divCode},
             {name: 'CUSTOM_CODE'           ,text: '<t:message code="system.label.purchase.custom" default="거래처"/>'        ,type: 'string'},
             {name: 'SEQ'                   ,text: '<t:message code="system.label.purchase.seq" default="순번"/>'         ,type: 'int'},
             {name: 'PROD_ITEM_CODE'        ,text: '<t:message code="system.label.purchase.parentitemcode" default="모품목코드"/>'  ,type: 'string'},
             {name: 'CHILD_ITEM_CODE'       ,text: 'CHILD_ITEM_CODE'  ,type: 'string'},
             {name: 'EXCHG_ITEM_CODE'       ,text: '<t:message code="system.label.purchase.subitemcode" default="대체품목코드"/>'     ,type: 'string' ,allowBlank:false},
             {name: 'ITEM_NAME'             ,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'        ,type: 'string'},
             {name: 'SPEC'                  ,text: '<t:message code="system.label.purchase.spec" default="규격"/>'         ,type: 'string'},
             {name: 'STOCK_UNIT'            ,text: '<t:message code="system.label.purchase.unit" default="단위"/>'         ,type: 'string'},
             {name: 'UNIT_Q'                ,text: '<t:message code="system.label.purchase.originunitqty" default="원단위량"/>'       ,type: 'number', defaultValue:1,type: 'float', decimalPrecision: 6, format:'0,000.000000'},
             {name: 'PROD_UNIT_Q'           ,text: '<t:message code="system.label.purchase.parentitembaseqty" default="모품목기준수"/>'     ,type: 'number', defaultValue:1},
             {name: 'LOSS_RATE'             ,text: '<t:message code="system.label.purchase.lossrate" default="Loss율"/>'      ,type: 'number', defaultValue:0},
             {name: 'UNIT_P1'               ,text: '<t:message code="system.label.purchase.materialcost" default="재료비"/>'        ,type: 'uniPrice', defaultValue:0},
             {name: 'UNIT_P2'               ,text: '<t:message code="system.label.purchase.laborexpenses" default="노무비"/>'        ,type: 'uniPrice', defaultValue:0},
             {name: 'UNIT_P3'               ,text: '<t:message code="system.label.purchase.expense" default="경비"/>'         ,type: 'uniPrice', defaultValue:0},
             {name: 'MAN_HOUR'              ,text: '<t:message code="system.label.purchase.standardtacttime" default="표준공수"/>'       ,type: 'uniQty', defaultValue:0},
             {name: 'USE_YN'                ,text: '<t:message code="system.label.purchase.use" default="사용"/>'         ,type: 'string' , defaultValue:'1',store: Ext.data.StoreManager.lookup('mba030ukrvUseYnStore')},
             {name: 'BOM_YN'                ,text: '<t:message code="system.label.purchase.compyn" default="구성여부"/>'       ,type: 'string' , defaultValue:'1',store: Ext.data.StoreManager.lookup('mba030ukrvUseYnStore')},
             {name: 'PRIOR_SEQ'             ,text: '<t:message code="system.label.purchase.priority" default="우선순위"/>'       ,type: 'string'},
             {name: 'START_DATE'            ,text: '<t:message code="system.label.purchase.compstartdate" default="구성시작일"/>'  ,type: 'uniDate',allowBlank:false, defaultValue: UniDate.get('today')},
             {name: 'STOP_DATE'             ,text: '<t:message code="system.label.purchase.compenddate" default="구성종료일"/>'  ,type: 'uniDate', defaultValue: '2999.12.31'},
             {name: 'REMARK'                ,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'         ,type: 'string'},
             {name: 'UPDATE_DB_USER'        ,text: '<t:message code="system.label.purchase.writer" default="작성자"/>'        ,type: 'string'},
             {name: 'UPDATE_DB_TIME'        ,text: '<t:message code="system.label.purchase.writtentiem" default="작성시간"/>'       ,type: 'string'}
          ]
    });

	var mba030ukrvs3_1Store = Unilite.createStore('mba030ukrvs3_1Store',{
		model: 'mba030ukrvs3_1Model',
		autoLoad: false,
		uniOpt : {
			isMaster	: false,				// 상위 버튼 연결
			editable	: true,				// 수정 모드 사용
			deletable	: true,				// 삭제 가능 여부
			useNavi		: false				// prev | next 버튼 사용
		},
		proxy: directProxy3_1,

		loadStoreRecords : function(){
			var param= Ext.getCmp('tab_regPL').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		saveStore : function(config){
			var inValidRecs = this.getInvalidRecords();
//			var toCreate = this.getNewRecords();
//			var toUpdate = this.getUpdatedRecords();
//			console.log("toUpdate",toUpdate);

			var rv = true;

			if(inValidRecs.length == 0 ) {
				config = {
					success: function(batch, option) {
//						panelDetail.resetDirtyStatus();
						UniAppManager.app.onQueryButtonDown();
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			}else {
				panelDetail.down('#mba030ukrsGrid3_1').uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
		   		if(!Ext.isEmpty(records) && records.length > 0 ){
					UniAppManager.app.fnSetReadOnly(panelDetail.down('#tab_regPL'), true);

		   		} else {
					UniAppManager.app.fnSetReadOnly(panelDetail.down('#tab_regPL'), false);
		   		}
		   		if(records != null && records.length > 0 ){
                    UniAppManager.setToolbarButtons('delete', true);
                }
			},
			add: function(store, records, index, eOpts) {
			},
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				UniAppManager.setToolbarButtons('save', true);
			},
			remove: function(store, record, index, isMove, eOpts) {
			},
			datachanged : function(store,  eOpts) {
				if( mba030ukrvs3_2Store.isDirty() || store.isDirty()) {
                    UniAppManager.setToolbarButtons('save', true);
                }else {
                    UniAppManager.setToolbarButtons('save', false);
                }
			}
		}
	});

	var mba030ukrvs3_2Store = Unilite.createStore('mba030ukrvs3_2Store',{
        model: 'mba030ukrvs3_2Model',
        autoLoad: false,
        uniOpt : {
            isMaster    : false,             // 상위 버튼 연결
            editable    : true,             // 수정 모드 사용
            deletable   : true,             // 삭제 가능 여부
            useNavi     : false             // prev | next 버튼 사용
        },
        proxy: directProxy3_2,

        loadStoreRecords : function(record){
            var param = record.data;
            console.log( param );
            this.load({
                params: param
            });
        },
        saveStore : function(config){
            var inValidRecs = this.getInvalidRecords();
//          var toCreate = this.getNewRecords();
//          var toUpdate = this.getUpdatedRecords();
//          console.log("toUpdate",toUpdate);

            var rv = true;

            if(inValidRecs.length == 0 ) {
                config = {
                    success: function(batch, option) {
//                      panelDetail.resetDirtyStatus();
                        UniAppManager.app.onQueryButtonDown();
                        UniAppManager.setToolbarButtons('save', false);
                    }
                };
                this.syncAllDirect(config);
            }else {
                panelDetail.down('#mba030ukrsGrid3_2').uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners:{
            load: function(store, records, successful, eOpts) {
            	if(records != null && records.length > 0 ){
                    UniAppManager.setToolbarButtons('delete', true);
                }
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            	UniAppManager.setToolbarButtons('save', true);
            },
            remove: function(store, record, index, isMove, eOpts) {
            },
            datachanged : function(store,  eOpts) {
            	if( mba030ukrvs3_1Store.isDirty() || store.isDirty())    {
                    UniAppManager.setToolbarButtons('save', true);
                }else {
                    UniAppManager.setToolbarButtons('save', false);
                }
            }
        }
    });

	Unilite.defineModel('mba030ukrvs4Model', {
		fields: [
				{name: 'DIV_CODE'				,text:'<t:message code="system.label.purchase.division" default="사업장"/>'		      ,type : 'string'},
				{name: 'CUSTOM_CODE'	 		,text:'<t:message code="system.label.purchase.customcode" default="거래처코드"/>'		  ,type : 'string'},
				{name: 'ITEM_CODE'              ,text:'<t:message code="system.label.purchase.itemcode" default="품목코드"/>'          ,type : 'string', allowBlank: false},
                {name: 'ITEM_NAME'              ,text:'<t:message code="system.label.purchase.itemname" default="품목명"/>'            ,type : 'string'},
                {name: 'SPEC'                   ,text:'<t:message code="system.label.purchase.spec" default="규격"/>'              ,type : 'string'},
                {name: 'STOCK_UNIT'             ,text:'<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'          ,type : 'string'},
                {name: 'STOCK_Q'                ,text:'<t:message code="system.label.purchase.basicinventoryqty" default="기초재고량"/>'        ,type : 'uniQty', allowBlank: false},
                {name: 'AVERAGE_P'              ,text:'<t:message code="system.label.purchase.price" default="단가"/>'              ,type : 'uniUnitPrice', allowBlank: false},
                {name: 'STOCK_I'                ,text:'<t:message code="system.label.purchase.basicamount" default="기초금액"/>'          ,type : 'uniPrice'},
                {name: 'BASIS_YYYYMM'           ,text:'<t:message code="system.label.purchase.applyyearmonth" default="반영년월"/>'          ,type : 'string'},
                {name: 'UPDATE_DB_USER'         ,text:'<t:message code="system.label.purchase.writer" default="작성자"/>'            ,type : 'string'},
                {name: 'UPDATE_DB_TIME'         ,text:'<t:message code="system.label.purchase.writtentiem" default="작성시간"/>'            ,type : 'uniDate'},
                {name: 'COMP_CODE'              ,text:'<t:message code="system.label.purchase.companycode" default="법인코드"/>'          ,type : 'string'},
                {name: 'LOT_NO'                 ,text:'LOT NO'            ,type : 'string'/*, allowBlank: false*/},
                {name: 'LOT_YN'                 ,text:'<t:message code="system.label.purchase.lotmanageyn" default="LOT관리여부"/>'       ,type : 'string', comboType:'AU', comboCode:'A020'}
			]
	});

	var mba030ukrvs4Store = Unilite.createStore('mba030ukrvs4Store',{
		model: 'mba030ukrvs4Model',
		autoLoad: false,
		uniOpt : {
			isMaster	: true,				// 상위 버튼 연결
			editable	: true,				// 수정 모드 사용
			deletable	: true,				// 삭제 가능 여부
			useNavi	: false				// prev | next 버튼 사용
		},
		proxy: directProxy4,

		loadStoreRecords : function(){
			var param= Ext.getCmp('tab_basicStock').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		saveStore : function(config){
			var inValidRecs = this.getInvalidRecords();
//			var toCreate = this.getNewRecords();
//			var toUpdate = this.getUpdatedRecords();
//			console.log("toUpdate",toUpdate);

			var rv = true;
			var paramMaster = Ext.getCmp('tab_basicStock').getValues();
			
			var isErr = false;
			var list = mba030ukrvs4Store.data.items;
            Ext.each(list, function(record, index) {
                if(record.get('LOT_YN') == 'Y' && Ext.isEmpty(record.get('LOT_NO'))){
                    alert((index + 1) + '<t:message code="system.message.commonJS.grid.invalidColumn" default="행의 입력값을 확인해 주세요."/>' + 'LOT NO: ' + '<t:message code="system.message.commonJS.required" default="은(는) 필수입력 사항입니다."/>');
                    isErr = true;
                    return false;
                }
            });

			if(inValidRecs.length == 0 ) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
//						panelDetail.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);
					}
				};
				this.syncAllDirect(config);
			}else {
				panelDetail.down('#mba030ukrsGrid4').uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});



	var panelDetail = Ext.create('Ext.panel.Panel', {
		layout : 'fit',
		region : 'center',
		disabled:false,
		items : [{
			xtype: 'grouptabpanel',
			itemId: 'mba030Tab',
			activeGroup: 0,
			collapsible:true,
			items: [{
				defaults:{
					xtype:'uniDetailForm',
					disabled:false,
					border:0,
					layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},
					margin: '10 10 10 10'
				},
				items:[
					<%@include file="./mba030ukrvs1.jsp" %>	//단위환산정보등록
				]
			 }/*, {
				defaults:{
					xtype:'uniDetailForm',
					disabled:false,
					border:0,
					layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},
					margin: '10 10 10 10'
				},
				items:[
					<%@include file="./mba030ukrvs2.jsp" %>	//구매단가/거래처품목등록
				]
			 }*/,{
				defaults:{
					xtype:'uniDetailForm',
					disabled:false,
					border:0,
					layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},
					margin: '10 10 10 10'
				},
				items:[
					<%@include file="./mba030ukrvs3.jsp" %>	//외주 P/L등록
				]
			 },{
				defaults:{
					xtype:'uniDetailForm',
					disabled:false,
					border:0,
					layout:{type:'uniTable', columns:'1', tdAttrs:{valign:'top'}},
					margin: '10 10 10 10'
				},
				items:[
					<%@include file="./mba030ukrvs4.jsp" %>	//외주 기초재고등록
				]
			 }]
		}]
	})


    Unilite.defineModel('excel.mba030.sheet01', {
        fields: [
                {name: 'DIV_CODE'               ,text:'<t:message code="system.label.purchase.division" default="사업장"/>'            ,type : 'string'},
                {name: 'CUSTOM_CODE'            ,text:'<t:message code="system.label.purchase.customcode" default="거래처코드"/>'        ,type : 'string'},
                {name: 'ITEM_CODE'              ,text:'<t:message code="system.label.purchase.itemcode" default="품목코드"/>'          ,type : 'string', allowBlank: false},
                {name: 'ITEM_NAME'              ,text:'<t:message code="system.label.purchase.itemname" default="품목명"/>'            ,type : 'string'},
                {name: 'SPEC'                   ,text:'<t:message code="system.label.purchase.spec" default="규격"/>'              ,type : 'string'},
                {name: 'STOCK_UNIT'             ,text:'<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'          ,type : 'string'},
                {name: 'STOCK_Q'                ,text:'<t:message code="system.label.purchase.basicinventoryqty" default="기초재고량"/>'        ,type : 'uniQty', allowBlank: false},
                {name: 'AVERAGE_P'              ,text:'<t:message code="system.label.purchase.price" default="단가"/>'              ,type : 'uniUnitPrice', allowBlank: false},
                {name: 'STOCK_I'                ,text:'<t:message code="system.label.purchase.basicamount" default="기초금액"/>'          ,type : 'uniPrice'},
                {name: 'BASIS_YYYYMM'           ,text:'<t:message code="system.label.purchase.applyyearmonth" default="반영년월"/>'          ,type : 'string'},
                {name: 'UPDATE_DB_USER'         ,text:'<t:message code="system.label.purchase.writer" default="작성자"/>'            ,type : 'string'},
                {name: 'UPDATE_DB_TIME'         ,text:'<t:message code="system.label.purchase.writtentiem" default="작성시간"/>'            ,type : 'uniDate'},
                {name: 'COMP_CODE'              ,text:'<t:message code="system.label.purchase.companycode" default="법인코드"/>'          ,type : 'string'}
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
                        excelConfigName: 'mba030',
                        /*extParam: {
                            'DIV_CODE': masterForm.getValue('DIV_CODE'),
                            'CUSTOM_CODE': masterForm.getValue('CUSTOM_CODE')
                        },*/
                        grids: [{
                                itemId: 'grid01',
                                title: '<t:message code="system.label.purchase.subcontractbalancestockinfo" default="외주기초재고정보"/>',
                                useCheckbox: false,
                                model : 'excel.mba030.sheet01',
                                readApi: 'mba030ukrvService.selectExcelUploadSheet1',
                                columns: [
                                	{dataIndex: 'DIV_CODE'			     ,       width: 80, hidden: true},
                                    {dataIndex: 'CUSTOM_CODE'	 	     ,       width: 80, hidden: true},
                                    {dataIndex: 'ITEM_CODE'              ,       width: 80},
                                    {dataIndex: 'ITEM_NAME'              ,       width: 80},
                                    {dataIndex: 'SPEC'                   ,       width: 80},
                                    {dataIndex: 'STOCK_UNIT'             ,       width: 80, align: 'center'},
                                    {dataIndex: 'STOCK_Q'                ,       width: 80},
                                    {dataIndex: 'AVERAGE_P'              ,       width: 80},
                                    {dataIndex: 'STOCK_I'                ,       width: 80},
                                    {dataIndex: 'BASIS_YYYYMM'           ,       width: 80},
                                    {dataIndex: 'UPDATE_DB_USER'         ,       width: 80, hidden: true},
                                    {dataIndex: 'UPDATE_DB_TIME'         ,       width: 80, hidden: true},
                                    {dataIndex: 'COMP_CODE'              ,       width: 80, hidden: true}
                                ]
                        }],
                        listeners: {
                            close: function() {
                                this.hide();
                            }
                        },
                        onApply:function()  {
                            excelWindow.getEl().mask('<t:message code="system.label.purchase.loading" default="로딩중..."/>','loading-indicator');
                            var me = this;
                            var grid = this.down('#grid01');
                            var records = grid.getStore().getAt(0);
                            var param = {"_EXCEL_JOBID": records.get('_EXCEL_JOBID')};
                            mba030ukrvService.selectExcelUploadSheet1(param, function(provider, response){
                                var records = response.result;
                                Ext.each(records, function(record,i){
                                    UniAppManager.app.onNewDataButtonDown();
                                    panelDetail.down('#mba030ukrsGrid4').setExcelData(record);
                                });
                                console.log("response",response)
                                excelWindow.getEl().unmask();
                                grid.getStore().removeAll();
                                me.hide();
                            });
                        }
                 });
            }
            excelWindow.center();
            excelWindow.show();
    }



	 Unilite.Main ({
		id			: 'mba030ukrvApp',
		borderItems	: [
			panelDetail
		],

		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('newData'    , true);
            UniAppManager.setToolbarButtons('reset'     , true);
			var activeTab = panelDetail.down('#mba030Tab').getActiveTab();

			if(activeTab.getId() == 'tab_tranUnit'){
//				UniAppManager.setToolbarButtons('newData'	, true);
//				UniAppManager.setToolbarButtons('reset'		, false);

			} else if(activeTab.getId() == 'tab_unitPrice') {
				if(!panelDetail.down('#tab_unitPrice').getInvalidMessage()) {
					return false;
				} else {
					mba030ukrvs2Store.loadStoreRecords();
				}
			} else if(activeTab.getId() == 'tab_regPL') {
				var form =  panelDetail.down('#tab_regPL');
				form.setValue('DIV_CODE', UserInfo.divCode);
				UniAppManager.app.fnSetReadOnly(panelDetail.down('#tab_regPL'), false);
			} else if(activeTab.getId() == 'tab_basicStock') {
                var form =  panelDetail.down('#tab_basicStock');
                form.setValue('DIV_CODE', UserInfo.divCode);
                form.setValue('BASIS_YYYYMM', UniDate.get('today'));
                UniAppManager.app.fnSetReadOnly(panelDetail.down('#tab_basicStock'), false);
			}
		},

		onQueryButtonDown : function()	{
			var activeTab = panelDetail.down('#mba030Tab').getActiveTab();

			if(activeTab.getId() == 'tab_tranUnit'){
				if(!panelDetail.down('#tab_tranUnit').getInvalidMessage()) {
					return false;
				} else {
					mba030ukrvs1Store.loadStoreRecords();
				}
			} else if(activeTab.getId() == 'tab_unitPrice') {
				if(!panelDetail.down('#tab_unitPrice').getInvalidMessage()) {
					return false;
				} else {
					mba030ukrvs2Store.loadStoreRecords();
				}
			} else if(activeTab.getId() == 'tab_regPL') {
				if(!panelDetail.down('#tab_regPL').getInvalidMessage()) {
					return false;
				} else {
					mba030ukrvs3_1Store.loadStoreRecords();
				}
			} else if(activeTab.getId() == 'tab_basicStock') {
				if(!panelDetail.down('#tab_basicStock').getInvalidMessage()) {
					return false;
				} else {
					mba030ukrvs4Store.loadStoreRecords();
				}
			}
//			var viewLocked = tab.getActiveTab().lockedGrid.getView();
//			var viewNormal = tab.getActiveTab().normalGrid.getView();
//			console.log("viewLocked : ",viewLocked);
//			console.log("viewNormal : ",viewNormal);
//			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
//			mba030ukrvs2Store.loadStoreRecords();

		},
        onResetButtonDown : function() {
            var activeTab = panelDetail.down('#mba030Tab').getActiveTab();

            if(activeTab.getId() == 'tab_tranUnit'){

            } else if(activeTab.getId() == 'tab_unitPrice') {

            } else if(activeTab.getId() == 'tab_regPL') {
            	var form =  panelDetail.down('#tab_regPL');
                form.clearForm();
                panelDetail.down('#mba030ukrsGrid3_1').getStore().loadData({});
                this.fnInitBinding();;
            } else if(activeTab.getId() == 'tab_basicStock') {
                var form =  panelDetail.down('#tab_basicStock');
                form.clearForm();
                panelDetail.down('#mba030ukrsGrid4').getStore().loadData({});
                this.fnInitBinding();;

            }

        },

		onNewDataButtonDown : function()	{
			var activeTab = panelDetail.down('#mba030Tab').getActiveTab();

			if (activeTab.getId() == 'tab_tranUnit'){
				var param =  panelDetail.down('#tab_tranUnit').getValues();
				var r = {
					STOCK_UNIT	: (Ext.isEmpty(param.BASE_UNIT)) ? '': param.BASE_UNIT,
					TRNS_RATE	: 1.000000,
					ITEM_CHG	: 'N',
					COMP_CODE	: UserInfo.compCode,
					UPDATE_DATE	: UniDate.get('today')
				}
				panelDetail.down('#mba030ukrsGrid1').createRow(r);

			} else if (activeTab.getId() == 'tab_unitPrice'){
				var param =  panelDetail.down('#tab_unitPrice').getValues();
                    var record = Ext.getCmp('tab_unitPrice').down('#mba030ukrsGrid2').getSelectedRecord();

                    var compCode = UserInfo.compCode;
                    var divCode = param.DIV_CODE;
                    var moneyUnit = UserInfo.currency;
                    var orderUnit = param.STOCK_UNIT_TEMP;
                    var aplyStartDate = UniDate.get('today');
                    var type = '1';
                    var itemCode = param.ITEM_CODE_TEMP;

                    var r = {
                        COMP_CODE : compCode,
                        DIV_CODE : divCode,
                        MONEY_UNIT : moneyUnit,
                        ORDER_UNIT : orderUnit,
                        APLY_START_DATE : aplyStartDate,
                        TYPE : type,
                        ITEM_CODE : itemCode
                    }
                    panelDetail.down('#mba030ukrsGrid2_1').createRow(r);

			} else if (activeTab.getId() == 'tab_regPL'){
				if(!panelDetail.down('#tab_regPL').getInvalidMessage()) {
					return false;
				}
				if(plActiveGridId == 'mba030ukrsGrid3_1'){
				    var seq = mba030ukrvs3_1Store.max('SEQ');
                    if (!seq) seq = 1;
                    else  seq += 1;
                    var param =  panelDetail.down('#tab_regPL').getValues();
                    var r = {
                        COMP_CODE       : UserInfo.compCode,
                        DIV_CODE        : param.DIV_CODE,
                        CUSTOM_CODE     : param.CUSTOM_CODE,
                        PROD_ITEM_CODE  : param.ITEM_CODE,
                        SEQ             : seq,
                        OLD_PATH_CODE   : '0',
                        PATH_CODE       : '0',
                        UNIT_Q          : 1,
                        PROD_UNIT_Q     : 1,
                        LOSS_RATE       : 0,
                        USE_YN          : 'Y',
                        START_DATE      : UniDate.get('today'),
                        STOP_DATE       : '29991231',
                        GRANT_TYPE      : '2'
                    }
                    panelDetail.down('#mba030ukrsGrid3_1').createRow(r);
				}else if(plActiveGridId == 'mba030ukrsGrid3_2'){
				    var seq = mba030ukrvs3_2Store.max('SEQ');
                    if(!seq) seq = 1;
                    else  seq += 1;
                    var param =  panelDetail.down('#tab_regPL').getValues();
                    var masterRecord = panelDetail.down('#mba030ukrsGrid3_1').getSelectedRecord();
                    if(masterRecord.phantom){
                        alert(Msg.fstMsgH0103);
                        return false;
                    }
                    if(masterRecord)    {
                         var r = {
                            SEQ               :seq,
                            DIV_CODE          : param.DIV_CODE,
                            CUSTOM_CODE       : masterRecord.get('CUSTOM_CODE'),
                            PROD_ITEM_CODE    : masterRecord.get('PROD_ITEM_CODE'),
                            CHILD_ITEM_CODE   : masterRecord.get('ITEM_CODE'),
                            PRIOR_SEQ         : seq,
                            START_DATE        : UniDate.get('today'),
                            STOP_DATE         : '2999.12.31'
                        };
                       panelDetail.down('#mba030ukrsGrid3_2').createRow(r);
                    }
				}

				UniAppManager.app.fnSetReadOnly(panelDetail.down('#tab_regPL'), true);

			} else if (activeTab.getId() == 'tab_basicStock'){
				var param =  panelDetail.down('#tab_basicStock').getValues();
				var r = {
					STOCK_UNIT	    : (Ext.isEmpty(param.BASE_UNIT)) ? '': param.BASE_UNIT,
					TRNS_RATE	    : 1.000000,
					ITEM_CHG	    : 'N',
                    COMP_CODE       : UserInfo.compCode,
                    DIV_CODE        : param.DIV_CODE,
                    CUSTOM_CODE     : param.CUSTOM_CODE,
                    BASIS_YYYYMM    : param.BASIS_YYYYMM,
					UPDATE_DATE	   : UniDate.get('today')
				}
				panelDetail.down('#mba030ukrsGrid4').createRow(r);
			}
		},

		onSaveDataButtonDown: function (config) {
			var activeTab = panelDetail.down('#mba030Tab').getActiveTab();

			if (activeTab.getId() == 'tab_tranUnit'){
				mba030ukrvs1Store.saveStore();

			} else if (activeTab.getId() == 'tab_unitPrice'){
				mba030ukrvs2Store.saveStore();

			} else if (activeTab.getId() == 'tab_regPL'){
				var masterInValidRecs = mba030ukrvs3_1Store.getInvalidRecords();
                var detailInValidRecs = mba030ukrvs3_2Store.getInvalidRecords();

                if(masterInValidRecs.length != 0 || detailInValidRecs.length != 0)  {
                    if(masterInValidRecs.length != 0){
                        panelDetail.down('#mba030ukrsGrid3_1').uniSelectInvalidColumnAndAlert(masterInValidRecs);
                    }else if(detailInValidRecs.length != 0){
                        panelDetail.down('#mba030ukrsGrid3_2').uniSelectInvalidColumnAndAlert(detailInValidRecs);
                    }
                }else{
                    if(mba030ukrvs3_1Store.isDirty()) {
                        mba030ukrvs3_1Store.saveStore();          //Master 데이타 저장 성공 후 Detail 저장함.
                    }else if(mba030ukrvs3_2Store.isDirty()){
                        mba030ukrvs3_2Store.saveStore();
                    }
                }
			} else if (activeTab.getId() == 'tab_basicStock'){
				mba030ukrvs4Store.saveStore();
			}
		},

		onDeleteDataButtonDown: function() {
			var activeTab = panelDetail.down('#mba030Tab').getActiveTab();

			if (activeTab.getId() == 'tab_tranUnit'){
				var grid = panelDetail.down('#mba030ukrsGrid1');
				var selRow = grid.getSelectionModel().getSelection()[0];

				if(Ext.isEmpty(selRow)) {
					alert('<t:message code="system.message.purchase.message017" default="선택된 자료가 없습니다."/>');
					return false;
				}

				if (selRow.phantom === true)   {
				   grid.deleteSelectedRow();

				} else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						 grid.deleteSelectedRow();
				}

			} else if (activeTab.getId() == 'tab_unitPrice'){
				var grid = panelDetail.down('#mba030ukrsGrid2');
				var selRow = grid.getSelectionModel().getSelection()[0];

				if(Ext.isEmpty(selRow)) {
					alert('<t:message code="system.message.purchase.message017" default="선택된 자료가 없습니다."/>');
					return false;
				}

				if (selRow.phantom === true)   {
				   grid.deleteSelectedRow();

				} else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						 grid.deleteSelectedRow();
				}

			} else if (activeTab.getId() == 'tab_regPL'){
				if(plActiveGridId == 'mba030ukrsGrid3_1'){
				    var grid = panelDetail.down('#mba030ukrsGrid3_1');
                    var selRow = grid.getSelectionModel().getSelection()[0];

                    if (selRow.phantom === true)   {
                       grid.deleteSelectedRow();

                    } else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
                        var toDelete = mba030ukrvs3_2Store.getRemovedRecords();
                        if(toDelete.length > 0 || mba030ukrvs3_2Store.getCount() > 0){
                            alert(Msg.sMB078);
                            return false;
                        }
                         grid.deleteSelectedRow();
                    }
				}else if(plActiveGridId == 'mba030ukrsGrid3_2'){
				    var grid = panelDetail.down('#mba030ukrsGrid3_2');
                    var selRow = grid.getSelectionModel().getSelection()[0];
                    if (selRow.phantom === true)   {
                       grid.deleteSelectedRow();

                    } else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
                             grid.deleteSelectedRow();
                    }
				}


			} else if (activeTab.getId() == 'tab_basicStock'){
				var grid = panelDetail.down('#mba030ukrsGrid4');
				var selRow = grid.getSelectionModel().getSelection()[0];

				if(Ext.isEmpty(selRow)) {
					alert('<t:message code="system.message.purchase.message017" default="선택된 자료가 없습니다."/>');
					return false;
				}

				if (selRow.phantom === true)   {
				   grid.deleteSelectedRow();

				} else if(confirm('<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
						 grid.deleteSelectedRow();
				}
			}
		},

		fnSetReadOnly:function(form1, /*form1, */flag) {
			if(form1) {
				form1.getForm().getFields().each(function(field) {
					field.setReadOnly(flag);
				});
			}
			//품목검색 라디오는 항상 활성화
			Ext.getCmp('rdoSelect').setReadOnly(false);

			//모품목코드 검색 규격텍스트필드는 항상 비활성
			Ext.getCmp('specField').setReadOnly(true);

//			form2.getForm().getFields().each(function(field) {
//				field.setReadOnly(flag);
//			});
		},

        fnYyyymmSet : function() {
        	var form =  panelDetail.down('#tab_basicStock');
            var param = {"DIV_CODE": form.getValue('DIV_CODE'), "CUSTOM_CODE": form.getValue('CUSTOM_CODE')};
            mba030ukrvService.selectYYYYMM(param, function(provider, response) {
                if(provider[0].BASIS_YYYYMM != '000000'){
                    form.setValue('BASIS_YYYYMM', provider[0].BASIS_YYYYMM);
                } else if(provider[0].BASIS_YYYYMM == '000000') {
                    form.setValue('BASIS_YYYYMM', UniDate.get('today'));
                }
            })
        }
	});



	/**
	 * Validation
	 */
	Unilite.createValidator('validator01', {
		store: mba030ukrvs1Store,
		grid: panelDetail.down('#mba030ukrsGrid1'),

		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;

			switch(fieldName) {

				case "STOCK_UNIT" :
					if (record.get('ORDER_UNIT') == newValue && record.get('TRNS_RATE') != 1) {
						rv='<t:message code="system.message.purchase.message018" default="기준단위와 변환단위가 같을 경우, 변환계수는 1 이어야 합니다."/>';
					}
					break;


				case "ORDER_UNIT" :
					if (record.get('STOCK_UNIT') == newValue && record.get('TRNS_RATE') != 1) {
						rv='<t:message code="system.message.purchase.message018" default="기준단위와 변환단위가 같을 경우, 변환계수는 1 이어야 합니다."/>';
					}
					break;


				case "TRNS_RATE" :
					if (record.get('STOCK_UNIT') == record.get('ORDER_UNIT') && newValue != 1) {
						rv='<t:message code="system.message.purchase.message018" default="기준단위와 변환단위가 같을 경우, 변환계수는 1 이어야 합니다."/>';
					}
					break;
			}
			return rv;
		}
	});



	//BOM 참조 		//////////////////////////////////////////////////////////////////////////////////////////////////////
	function openBomCopyWindow() {
		if(!panelDetail.down('#tab_regPL').getInvalidMessage()) {
			return false;
		}
		if(!Ext.isEmpty(bomCopyWindow)){
//			bomCopyWindow.extParam.BILL_TYPE	= panelResult.getValue('BILL_TYPE');
//			bomCopyWindow.extParam.ISSUE_GUBUN	= Ext.getCmp('rdoSelect0').getChecked()[0].inputValue;
//			bomCopyWindow.extParam.APPLY_YN		= Ext.getCmp('rdoSelect0_0').getChecked()[0].inputValue;
		}
		if(!bomCopyWindow) {
			bomCopyWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.purchase.bomrefer" default="BOM참조"/>',
				width	: 830,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [bomCopySearch, bomCopyGrid],
				tbar	:  ['->',{
					itemId	: 'searchBomBtn',
					text	: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					disabled: false,
					handler	: function() {
						if(!bomCopySearch.getInvalidMessage()) {
							return false;
						}
						bomCopyStore.loadStoreRecords();
					}
				}, {
					itemId	: 'confirmBomBtn',
					text	: '<t:message code="system.label.purchase.apply" default="적용"/>',
					disabled: false,
					handler	: function() {
						var records = bomCopyGrid.getSelectedRecords();
						if(!Ext.isEmpty(records)) {
							Ext.each(records, function(record,i) {
								console.log('record',record);
//								if(i==0) {
//									panelDetail.down('#mba030ukrsGrid3_1').setItemData2(record, false, panelDetail.down('#mba030ukrsGrid3_1').uniOpt.currentRecord);
//								} else {
									UniAppManager.app.onNewDataButtonDown();
									panelDetail.down('#mba030ukrsGrid3_1').setItemData2(record, false, panelDetail.down('#mba030ukrsGrid3_1').getSelectedRecord());
//								}
							});
							bomCopyWindow.hide();

						} else {
							alert('<t:message code="system.message.purchase.message017" default="선택된 자료가 없습니다."/>');
							return false;
						}
					}
				},{
					itemId	: 'closeBomBtn',
					text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
					disabled: false,
					handler	: function() {
						bomCopyWindow.hide();
					}
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						bomCopySearch.clearForm();
						bomCopyGrid.reset();
						bomCopyStore.clearData();
					},
					beforeclose: function( panel, eOpts )  {
						bomCopySearch.clearForm();
						bomCopyGrid.reset();
						bomCopyStore.clearData();
					},
					show: function( panel, eOpts ) {
						bomCopySearch.setValue('DIV_CODE'		, panelDetail.down('#tab_regPL').getValue('DIV_CODE'));
						bomCopySearch.setValue('ITEM_CODE'		, panelDetail.down('#tab_regPL').getValue('ITEM_CODE'));
						bomCopySearch.setValue('ITEM_NAME'		, panelDetail.down('#tab_regPL').getValue('ITEM_NAME'));
						bomCopySearch.setValue('SPEC'			, gsSpec);
						bomCopySearch.setValue('OPT_APT_ITEM'	, Ext.getCmp('rdoSelect').getChecked()[0].inputValue);

						bomCopySearch.getField('DIV_CODE').setReadOnly(true);
						bomCopySearch.getField('SPEC').setReadOnly(true);
					}
				}
			})
		}
		bomCopyWindow.center();
		bomCopyWindow.show();
	}

	var bomCopySearch = Unilite.createSearchForm('bomCopySearchForm', {
		layout	: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items	: [{
				fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				tdAttrs		: {width: 380}
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.purchase.itemsearch" default="품목검색"/>',
				id			: 'bomCopySearchRdo',
				colspan		: 2,
				items		: [{
					boxLabel	: '<t:message code="system.label.purchase.nowapplyitem" default="현재 적용품목"/>',
					name		: 'OPT_APT_ITEM',
					inputValue	: 'C',
					width		: 120,
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.purchase.whole" default="전체"/>',
					width		: 120,
					name		: 'OPT_APT_ITEM',
					inputValue	: 'A'
				}
			]},{
				xtype	: 'container',
				layout	: {type : 'uniTable'},
				colspan	: 2,
				items	: [
					Unilite.popup('DIV_PUMOK',{
						fieldLabel		: '<t:message code="system.label.purchase.parentitemcode" default="모품목코드"/>',
						validateBlank	: false,
						allowBlank		: false,
//						width			: 380,
//						tdAttrs			: {width: 380},
						listeners		: {
							'onSelected': {
								fn: function(records, type) {
									Ext.each(records, function(record,i) {
										console.log('record',record);
										bomCopySearch.setValue('SPEC', record.SPEC);
									});
								},
								scope: this
							},
							'onClear': function(type) {
								bomCopySearch.setValue('SPEC', '');
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelDetail.down('#tab_regPL').getValue('DIV_CODE')});
								popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['10','20']});
								popup.setExtParam({'ITEM_ACCOUNT': '10'});
							}
						}
				}),{
					name		: 'SPEC',
					fieldLabel	: '',
					xtype		: 'uniTextfield',
					readOnly	: true,
					listeners	: {}
				}]
			}]
	}); // createSearchForm


	//검색 모델(마스터)
	Unilite.defineModel('bomCopyModel', {
		fields: [
			{name: 'SEQ'				, text: '<t:message code="system.label.purchase.seq" default="순번"/>'			, type: 'string'},
			{name: 'CHOICE'				, text: '<t:message code="system.label.purchase.selection" default="선택"/>'			, type: 'string'},
			{name: 'COMP_CODE'			, text: '<t:message code="system.label.purchase.companycode" default="법인코드"/>'		, type: 'string'},
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'	, type: 'string'	, comboType:'BOR120'},
			{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.subcontractorcode" default="외주처코드"/>'	, type: 'string'},
			{name: 'PROD_ITEM_CODE'		, text: '<t:message code="system.label.purchase.parentitemcode" default="모품목코드"/>'	, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.childitemcode" default="자품목코드"/>'	, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname2" default="품명"/>'			, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'			, type: 'string'},
			{name: 'STOCK_UNIT'			, text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'		, type: 'string'	, comboType: 'AU'		,comboCode: 'B013', displayField: 'value'},
			{name: 'ITEM_ACCOUNT'		, text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'		, type: 'string'},
			{name: 'PATH_CODE'			, text: '<t:message code="system.label.purchase.pathinfo" default="PATH정보"/>'		, type: 'string'},
			{name: 'UNIT_Q'				, text: '<t:message code="system.label.purchase.originunitqty" default="원단위량"/>'		, type: 'number', defaultValue:1,type: 'float', decimalPrecision: 6, format:'0,000.000000'},
			{name: 'PROD_UNIT_Q'		, text: '<t:message code="system.label.purchase.parentitembaseqty" default="모품목기준수"/>'	, type: 'uniQty'},
			{name: 'LOSS_RATE'			, text: '<t:message code="system.label.purchase.lossrate" default="Loss율"/>'		, type: 'uniER'},
			{name: 'USE_YN'				, text: '<t:message code="system.label.purchase.useyn" default="사용여부"/>'		, type: 'string'	, comboType: 'AU'		,comboCode: 'A004'},
			{name: 'START_DATE'			, text: '<t:message code="system.label.purchase.startdate" default="시작일"/>'		, type: 'uniDate'},
			{name: 'STOP_DATE'			, text: '<t:message code="system.label.purchase.enddate" default="종료일"/>'		, type: 'uniDate'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'			, type: 'string'},
			{name: 'UPDATE_DB_USER'		, text: '<t:message code="system.label.purchase.updateuser" default="수정자"/>'		, type: 'string'},
			{name: 'UPDATE_DB_TIME'		, text: '<t:message code="system.label.purchase.updatedate" default="수정일"/>'		, type: 'string'}
		]
	});

	//검색 스토어(마스터)
	var bomCopyStore = Unilite.createStore('bomCopyStore', {
			model	: 'bomCopyModel',
			autoLoad: false,
			uniOpt	: {
				isMaster	: false,			// 상위 버튼 연결
				editable	: false,			// 수정 모드 사용
				deletable	: false,			// 삭제 가능 여부
				useNavi		: false 			// prev | newxt 버튼 사용
			},
			proxy	: {
				type: 'direct',
				api: {
					read: 'mba030ukrvService.bomCopySelectList'
				}
			},
			loadStoreRecords : function()  {
				var param= bomCopySearch.getValues();
				param.CUSTOM_CODE = gsCustomCode;
				param.CUSTOM_NAME = gsCustomName;
				console.log( param );
				this.load({
					params : param
				});
			}
	});

	//검색 그리드(마스터)
	var bomCopyGrid = Unilite.createGrid('sof100ukrvbomCopyGrid', {
		layout	: 'fit',
		store	: bomCopyStore,
		uniOpt	: {
			useMultipleSorting	: true,
		    useLiveSearch		: false,
		    onLoadSelectFirst	: false,
		    dblClickToEdit		: true,
		    useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
			useRowContext		: false,
		    filter: {
				useFilter		: false,
				autoCreate		: false
			}
		},
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
    		listeners: {
    			select: function(grid, selectRecord, index, rowIndex, eOpts ){
    			},
	    		deselect:  function(grid, selectRecord, index, eOpts ){
	    		}
    		}
        }),		columns:  [
			{dataIndex: 'COMP_CODE'			, width:66		, hidden:true},
			{dataIndex: 'DIV_CODE'			, width:66		, hidden:true},
			{dataIndex: 'CUSTOM_CODE'	 	, width:66		, hidden:true},
			{dataIndex: 'PROD_ITEM_CODE'	, width:66		, hidden:true},
//			{dataIndex: 'CHOICE'		 	, width:66		, align: 'center'},
			{dataIndex: 'SEQ'			 	, width:66		, align: 'center'},
			{dataIndex: 'ITEM_CODE'			, width:86},
			{dataIndex: 'ITEM_NAME'			, width:133},
			{dataIndex: 'SPEC'				, width:133},
			{dataIndex: 'STOCK_UNIT'		, width:80, align: 'center'},
			{dataIndex: 'ITEM_ACCOUNT'		, width:66		, hidden:true},
			{dataIndex: 'PATH_CODE'			, width:90		, hidden:true},
			{dataIndex: 'UNIT_Q'			, width:80},
			{dataIndex: 'PROD_UNIT_Q'		, width:110		, hidden:true},
			{dataIndex: 'LOSS_RATE'			, width:73		, hidden:true},
			{dataIndex: 'USE_YN'			, width:73},
			{dataIndex: 'START_DATE'		, width:100},
			{dataIndex: 'STOP_DATE'			, width:100},
			{dataIndex: 'REMARK'			, flex: 1		, minWidth: 200},
			{dataIndex: 'UPDATE_DB_USER'	, width:66		, hidden:true},
			{dataIndex: 'UPDATE_DB_TIME'	, width:66		, hidden:true}
		] ,
		listeners: {
//			onGridDblClick: function(grid, record, cellIndex, colName) {
//				bomCopyGrid.returnData(record);
//				UniAppManager.app.onQueryButtonDown();
//				SearchInfoWindow.hide();
//			}
		},
		returnData: function(records) {

		}
	});




	//기존 P/L 참조		//////////////////////////////////////////////////////////////////////////////////////////////////////
	function openCustCopyWindow() {
		if(!panelDetail.down('#tab_regPL').getInvalidMessage()) {
			return false;
		}
		if(!Ext.isEmpty(custCopyWindow)){
//			custCopyWindow.extParam.BILL_TYPE	= panelResult.getValue('BILL_TYPE');
//			custCopyWindow.extParam.ISSUE_GUBUN	= Ext.getCmp('rdoSelect0').getChecked()[0].inputValue;
//			custCopyWindow.extParam.APPLY_YN	= Ext.getCmp('rdoSelect0_0').getChecked()[0].inputValue;
		}
		if(!custCopyWindow) {
			custCopyWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.purchase.existingplrefer" default="기존P/L참조"/>',
				width	: 830,
				height	: 580,
				layout	: {type:'vbox', align:'stretch'},
				items	: [custCopySearch, custCopyGrid],
				tbar	:  ['->',{
					itemId	: 'searchBomBtn',
					text	: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
					disabled: false,
					handler	: function() {
						if(!custCopySearch.getInvalidMessage()) {
							return false;
						}
						custCopyStore.loadStoreRecords();
					}
				}, {
					itemId	: 'confirmBomBtn',
					text	: '<t:message code="system.label.purchase.apply" default="적용"/>',
					disabled: false,
					handler	: function() {
						var records = custCopyGrid.getSelectedRecords();
						if(!Ext.isEmpty(records)) {
							Ext.each(records, function(record,i) {
								console.log('record',record);
//								if(i==0) {
//									panelDetail.down('#mba030ukrsGrid3_1').setItemData2(record, false, panelDetail.down('#mba030ukrsGrid3_1').uniOpt.currentRecord);
//								} else {
									UniAppManager.app.onNewDataButtonDown();
									panelDetail.down('#mba030ukrsGrid3_1').setItemData2(record, false, panelDetail.down('#mba030ukrsGrid3_1').getSelectedRecord());
//								}
							});
							custCopyWindow.hide();

						} else {
							alert('<t:message code="system.message.purchase.message017" default="선택된 자료가 없습니다."/>');
							return false;
						}
					}
				},{
					itemId	: 'closeBomBtn',
					text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
					disabled: false,
					handler	: function() {
						custCopyWindow.hide();
					}
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						custCopySearch.clearForm();
						custCopyGrid.reset();
						custCopyStore.clearData();
					},
					beforeclose: function( panel, eOpts )  {
						custCopySearch.clearForm();
						custCopyGrid.reset();
						custCopyStore.clearData();
					},
					show: function( panel, eOpts ) {
						custCopySearch.setValue('DIV_CODE'		, panelDetail.down('#tab_regPL').getValue('DIV_CODE'));
						custCopySearch.setValue('ITEM_CODE'		, panelDetail.down('#tab_regPL').getValue('ITEM_CODE'));
						custCopySearch.setValue('ITEM_NAME'		, panelDetail.down('#tab_regPL').getValue('ITEM_NAME'));
						custCopySearch.setValue('SPEC'			, gsSpec);
						custCopySearch.setValue('OPT_APT_ITEM'	, Ext.getCmp('rdoSelect').getChecked()[0].inputValue);

						custCopySearch.getField('DIV_CODE').setReadOnly(true);
						custCopySearch.getField('SPEC').setReadOnly(true);
					}
				}
			})
		}
		custCopyWindow.center();
		custCopyWindow.show();
	}

	//기존 P/L 참조		//////////////////////////////////////////////////////////////////////////////////////////////////////
	function openPartListCopyWindow() {
		if(!panelDetail.down('#tab_regPL').getInvalidMessage()) {
			return false;
		}
		if(!Ext.isEmpty(custCopyWindow)){
//			custCopyWindow.extParam.BILL_TYPE	= panelResult.getValue('BILL_TYPE');
//			custCopyWindow.extParam.ISSUE_GUBUN	= Ext.getCmp('rdoSelect0').getChecked()[0].inputValue;
//			custCopyWindow.extParam.APPLY_YN	= Ext.getCmp('rdoSelect0_0').getChecked()[0].inputValue;
		}
		if(!partListCopyWindow) {
			partListCopyWindow = Ext.create('widget.uniDetailWindow', {
				title	: '<t:message code="system.label.purchase.subcontractorcopy" default="외주처복사"/>',
				width	: 430,
				height	: 200,
				layout	: {type:'vbox', align:'stretch'},
				items	: [partListCopySearch],
				tbar	:  ['->',{
					itemId	: 'closepartListBtn',
					text	: '<t:message code="system.label.purchase.close" default="닫기"/>',
					disabled: false,
					handler	: function() {
						partListCopyWindow.hide();
					}
				}],
				listeners : {
					beforehide: function(me, eOpt) {
						partListCopySearch.clearForm();

					},
					beforeclose: function( panel, eOpts )  {
						partListCopySearch.clearForm();

					},
					show: function( panel, eOpts ) {
						partListCopySearch.setValue('DIV_CODE'		, panelDetail.down('#tab_regPL').getValue('DIV_CODE'));
						partListCopySearch.setValue('AGENT_CUST_CD'		, gsCustomCode);
						partListCopySearch.setValue('AGENT_CUST_NM'		, gsCustomName);
						partListCopySearch.getField('DIV_CODE').setReadOnly(true);

					}
				}
			})
		}
		partListCopyWindow.center();
		partListCopyWindow.show();
	}

	var custCopySearch = Unilite.createSearchForm('custCopySearchForm', {
		layout	: {type: 'uniTable', columns : 2},
		trackResetOnLoad: true,
		items	: [{
				fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				tdAttrs		: {width: 380}
			},{
				xtype		: 'radiogroup',
				fieldLabel	: '<t:message code="system.label.purchase.itemsearch" default="품목검색"/>',
				id			: 'custCopySearchRdo',
				colspan		: 2,
				items		: [{
					boxLabel	: '<t:message code="system.label.purchase.nowapplyitem" default="현재 적용품목"/>',
					name		: 'OPT_APT_ITEM',
					inputValue	: 'C',
					width		: 120,
					checked		: true
				},{
					boxLabel	: '<t:message code="system.label.purchase.whole" default="전체"/>',
					width		: 120,
					name		: 'OPT_APT_ITEM',
					inputValue	: 'A'
				}
			]},{
				xtype	: 'container',
				layout	: {type : 'uniTable'},
				colspan	: 2,
				items	: [
					Unilite.popup('DIV_PUMOK',{
						fieldLabel		: '<t:message code="system.label.purchase.parentitemcode" default="모품목코드"/>',
						validateBlank	: false,
						allowBlank		: false,
//						width			: 380,
//						tdAttrs			: {width: 380},
						listeners		: {
							'onSelected': {
								fn: function(records, type) {
									Ext.each(records, function(record,i) {
										console.log('record',record);
										custCopySearch.setValue('SPEC', record.SPEC);
									});
								},
								scope: this
							},
							'onClear': function(type) {
								custCopySearch.setValue('SPEC', '');
							},
							applyextparam: function(popup){
								popup.setExtParam({'DIV_CODE': panelDetail.down('#tab_regPL').getValue('DIV_CODE')});
								popup.setExtParam({'ITEM_ACCOUNT_FILTER': ['10','20']});
								popup.setExtParam({'ITEM_ACCOUNT': '10'});
							}
						}
				}),{
					name		: 'SPEC',
					fieldLabel	: '',
					xtype		: 'uniTextfield',
					readOnly	: true,
					listeners	: {}
				}]
			}]
	}); // createSearchForm

	var partListCopySearch = Unilite.createSearchForm('partListCopySearchForm', {
		layout	: {type: 'uniTable', columns : 1},
		trackResetOnLoad: true,
		items	: [{
				fieldLabel	: '<t:message code="system.label.purchase.division" default="사업장"/>',
				name		: 'DIV_CODE',
				xtype		: 'uniCombobox',
				comboType	: 'BOR120',
				allowBlank	: false,
				tdAttrs		: {width: 380}
			},Unilite.popup('AGENT_CUST',{
				fieldLabel		: '<t:message code="system.label.purchase.subcontractor" default="외주처"/>',
				validateBlank	: false,
				allowBlank		: false,
				readOnly			: true,
				colspan			: 3,
				width			: 380,
				textFieldName: 'AGENT_CUST_NM',
	            valueFieldName: 'AGENT_CUST_CD',
				tdAttrs			: {width: 380},
				listeners		: {
					'onSelected': {
						fn: function(records, type) {

						},
						scope: this
					},
					applyextparam: function(popup){

					}
				}
		}),Unilite.popup('AGENT_CUST',{
			fieldLabel		: '<t:message code="system.label.purchase.copysubcontractor" default="복사 외주처"/>',
			validateBlank	: false,
			allowBlank		: false,
			colspan			: 3,
			width			: 380,
			textFieldName: 'AGENT_CUST_NM1',
            valueFieldName: 'AGENT_CUST_CD1',
			tdAttrs			: {width: 380},
			listeners		: {
				'onSelected': {
					fn: function(records, type) {
						Ext.each(records, function(record,i) {

						});
					},
					scope: this
				},
				applyextparam: function(popup){
					popup.setExtParam({'CUSTOM_TYPE': ['1', '2']});
				}
			}
	}),{
    	xtype:'container',
    	defaultType:'uniTextfield',
    	layout:{type:'hbox', align:'middle', pack: 'center' },
    	items:[
    		{
				xtype	: 'button',
				name	: 'CONFIRM_CHECK1',
				id		: 'procCanc5',
				text	: '<t:message code="system.label.purchase.subcontractorcopy" default="외주처복사"/>',
				width	: 100,
				hidden: false,
				handler : function() {//외주처 복사 팝업 호출
				    var agentCustCdFr = 	partListCopySearch.getValue("AGENT_CUST_CD");
				    var agentCustCdTo = 	partListCopySearch.getValue("AGENT_CUST_CD1");
					if(!partListCopySearch.getInvalidMessage()) {
						return false;
					}
					if(agentCustCdFr == agentCustCdTo){
						alert('<t:message code="system.message.purchase.message019" default="외주처와 복사 외주처가 서로 같을 수는 없습니다."/>')
						return false;
					}

					Ext.MessageBox.show({
		                title: CommonMsg.errorTitle.ERROR,
		                msg: partListCopySearch.getValue("AGENT_CUST_NM1")+ '<t:message code="system.message.purchase.message020" default="으로 P/L을 복사하시겠습니까?"/>',
		                buttons: Ext.Msg.YESNOCANCEL,
					    icon: Ext.Msg.QUESTION,
					    fn: function(res) {
					     	//console.log(res);
					     	if (res === 'yes' ) {
					     		var param = {"DIV_CODE": panelDetail.down('#tab_regPL').getValue('DIV_CODE'),
					     							"AGENT_CUST_CD_FR":	agentCustCdFr,
					     							"AGENT_CUST_CD_TO":	agentCustCdTo};

					     		 mba030ukrvService.partListCopy(param, function(provider, response) {
					                 if(!Ext.isEmpty(provider)){
											alert('<t:message code="system.message.purchase.message021" default="복사가 완료 되었습니다."/>');
											partListCopySearch.clearForm();
											partListCopyWindow.hide();
					                 }
					             })


					     	} else if(res === 'cancel') {
					     		return false;
					     	}
					     }
		            });
				 }
			}
		]
    }]
	}); // createSearchForm


	//검색 모델(마스터)
	Unilite.defineModel('custCopyModel', {
		fields: [
			{name: 'SEQ'					,text: '<t:message code="system.label.purchase.seq" default="순번"/>'				,type: 'int'},
			{name: 'COMP_CODE'				,text: 'COMP_CODE'			,type: 'string'},
			{name: 'DIV_CODE'				,text: '<t:message code="system.label.purchase.division" default="사업장"/>'				,type: 'string'},
			{name: 'CUSTOM_CODE'			,text: '<t:message code="system.label.purchase.custom" default="거래처"/>'				,type: 'string'},
			{name: 'CUSTOM_NAME'			,text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'			,type: 'string'},
			{name: 'PROD_ITEM_CODE'			,text: '<t:message code="system.label.purchase.parentitemcode" default="모품목코드"/>'			,type: 'string'},
			{name: 'ITEM_CODE'				,text: '<t:message code="system.label.purchase.childitemcode" default="자품목코드"/>'			,type: 'string'},
			{name: 'ITEM_NAME'				,text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'				,type: 'string'},
			{name: 'SPEC'					,text: '<t:message code="system.label.purchase.spec" default="규격"/>'				,type: 'string'},
			{name: 'STOCK_UNIT'				,text: '<t:message code="system.label.purchase.inventoryunit" default="재고단위"/>'			,type: 'string'		,comboType: 'AU'		,comboCode: 'B013', displayField: 'value'},
			{name: 'ITEM_ACCOUNT'			,text: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'			,type: 'string'},
			{name: 'OLD_PATH_CODE'			,text: 'OLD_PATH_CODE'		,type: 'string'},
			{name: 'PATH_CODE'				,text: 'PATH_CODE'			,type: 'string'},
			{name: 'UNIT_Q'					,text: '<t:message code="system.label.purchase.originunitqty" default="원단위량"/>'			,type: 'number', defaultValue:1,type: 'float', decimalPrecision: 6, format:'0,000.000000'},
			{name: 'PROD_UNIT_Q'			,text: '<t:message code="system.label.purchase.parentitembaseqty" default="모품목기준수"/>'		,type: 'uniQty'},
			{name: 'LOSS_RATE'				,text: '<t:message code="system.label.purchase.lossrate" default="Loss율"/>'				,type: 'uniER'},
			{name: 'USE_YN'					,text: '<t:message code="system.label.purchase.useyn" default="사용여부"/>'			,type: 'string'		,comboType: 'AU'		,comboCode: 'A004'},
			{name: 'START_DATE'				,text: '<t:message code="system.label.purchase.startdate" default="시작일"/>'				,type: 'uniDate'},
			{name: 'STOP_DATE'				,text: '<t:message code="system.label.purchase.enddate" default="종료일"/>'				,type: 'uniDate'},
			{name: 'GRANT_TYPE'				,text: '<t:message code="system.label.purchase.subcontractdivision" default="사급구분"/>'			,type: 'string'		,comboType: 'AU'		,comboCode: 'M105'},
			{name: 'REMARK'					,text: '<t:message code="system.label.purchase.remarks" default="비고"/>'				,type: 'string'},
			{name: 'UPDATE_DB_USER'			,text: 'UPDATE_DB_USER'		,type: 'string'},
		 	{name: 'UPDATE_DB_TIME'			,text: 'UPDATE_DB_TIME'		,type: 'string'}
		]
	});

	//검색 스토어(마스터)
	var custCopyStore = Unilite.createStore('custCopyStore', {
			model	: 'custCopyModel',
			autoLoad: false,
			uniOpt	: {
				isMaster	: false,			// 상위 버튼 연결
				editable	: false,			// 수정 모드 사용
				deletable	: false,			// 삭제 가능 여부
				useNavi		: false 			// prev | newxt 버튼 사용
			},
			proxy	: {
				type: 'direct',
				api: {
					read: 'mba030ukrvService.custCopySelectList'
				}
			},
			loadStoreRecords : function()  {
				var param= custCopySearch.getValues();
				param.CUSTOM_CODE = gsCustomCode;
				param.CUSTOM_NAME = gsCustomName;
				console.log( param );
				this.load({
					params : param
				});
			}
	});

	//검색 그리드(마스터)
	var custCopyGrid = Unilite.createGrid('sof100ukrvcustCopyGrid', {
		layout	: 'fit',
		store	: custCopyStore,
		uniOpt	: {
			useMultipleSorting	: true,
		    useLiveSearch		: false,
		    onLoadSelectFirst	: false,
		    dblClickToEdit		: true,
		    useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
			useRowContext		: false,
		    filter: {
				useFilter		: false,
				autoCreate		: false
			}
		},
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
    		listeners: {
    			select: function(grid, selectRecord, index, rowIndex, eOpts ){
    			},
	    		deselect:  function(grid, selectRecord, index, eOpts ){
	    		}
    		}
        }),
        columns:  [
			{dataIndex: 'COMP_CODE'			, width:66		, hidden:true},
			{dataIndex: 'DIV_CODE'			, width:66		, hidden:true},
			{dataIndex: 'CUSTOM_CODE'	 	, width:86},
			{dataIndex: 'CUSTOM_NAME'	 	, width:133},
			{dataIndex: 'PROD_ITEM_CODE'	, width:66		, hidden:true},
			{dataIndex: 'SEQ'			 	, width:66		, align: 'center'},
			{dataIndex: 'ITEM_CODE'			, width:86},
			{dataIndex: 'ITEM_NAME'			, width:133},
			{dataIndex: 'SPEC'				, width:133},
			{dataIndex: 'STOCK_UNIT'		, width:80, align: 'center'},
			{dataIndex: 'ITEM_ACCOUNT'		, width:66		, hidden:true},
			{dataIndex: 'OLD_PATH_CODE'		, width:90		, hidden:true},
			{dataIndex: 'PATH_CODE'			, width:90		, hidden:true},
			{dataIndex: 'UNIT_Q'			, width:80},
			{dataIndex: 'PROD_UNIT_Q'		, width:110},
			{dataIndex: 'LOSS_RATE'			, width:73},
			{dataIndex: 'USE_YN'			, width:73},
			{dataIndex: 'START_DATE'		, width:100},
			{dataIndex: 'STOP_DATE'			, width:100},
			{dataIndex: 'GRANT_TYPE'		, width:80},
			{dataIndex: 'REMARK'			, flex: 1		, minWidth: 200},
			{dataIndex: 'UPDATE_DB_USER'	, width:66		, hidden:true},
			{dataIndex: 'UPDATE_DB_TIME'	, width:66		, hidden:true}
		] ,
		listeners: {
//			onGridDblClick: function(grid, record, cellIndex, colName) {
//				custCopyGrid.returnData(record);
//				UniAppManager.app.onQueryButtonDown();
//				SearchInfoWindow.hide();
//			}
		},
		returnData: function(records) {

		}
	});
};

</script>
