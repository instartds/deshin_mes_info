<%--
'   프로그램명 : 검사등록 (구매재고)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버      전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mms200ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="Q005" /> <!-- 검사유형 -->
	<t:ExtComboStore comboType="AU" comboCode="Q022" /> <!-- 검사담당 -->
	<t:ExtComboStore comboType="AU" comboCode="M414" /> <!-- 합격여부 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주유형 -->
	<t:ExtComboStore comboType="AU" comboCode="Q033" /> <!-- 최종판정 -->
	<t:ExtComboStore comboType="AU" comboCode="Q002" /> <!-- 최종판정 -->
	<t:ExtComboStore comboType="OU" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var SearchInfoWindow;	//조회버튼 누르면 나오는 조회창
var referReceiptWindow;	//접수참조
var BsaCodeInfo = {
	gsAutoInputFlag   : '${gsAutoInputFlag}',
	gsLotNoInputMethod: '${gsLotNoInputMethod}',
	gsLotNoEssential  : '${gsLotNoEssential}',
	gsManageLotNoYN   : '${gsManageLotNoYN}',
	gsReportGubun: '${gsReportGubun}',
	gsInspecPrsn   : '${gsInspecPrsn}',
	gsSyTalkFlag     : '${gsSyTalkFlag}'
};
var rptBtnYn = true;
if(BsaCodeInfo.gsReportGubun == 'CLIP'){
	rptBtnYn = false;
}
if(BsaCodeInfo.gsSyTalkFlag == ''){
	BsaCodeInfo.gsSyTalkFlag = '0';	//0 사용안함, 1 자동, 2수동
}
function appMain() {

	var lastSelectedRecord;
	
	var lotNoEssential = BsaCodeInfo.gsLotNoEssential == "Y"?true:false;
    var lotNoInputMethod = BsaCodeInfo.gsLotNoInputMethod == "Y"?true:false;

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
        	read    : 'mms200ukrvService.selectList1',
        	update  : 'mms200ukrvService.updateDetail',
        	create  : 'mms200ukrvService.insertDetail',
        	destroy : 'mms200ukrvService.deleteDetail',
        	syncAll : 'mms200ukrvService.saveAll'
        }
    });

    var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
        	read    : 'mms200ukrvService.selectList2',
        	update  : 'mms200ukrvService.updateBad',
        	create  : 'mms200ukrvService.insertBad',
        	destroy : 'mms200ukrvService.deleteBad',
        	syncAll : 'mms200ukrvService.saveAllBad'
        }
    });

	/**
	 * 主页面grid1 Model
	 */
	Unilite.defineModel('Mms200ukrvModel1', {
		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'   		, type: 'string'},
	    	{name: 'INSPEC_NUM'			, text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>'  	, type: 'string'},
	    	{name: 'INSPEC_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'    		, type: 'int'},
	    	{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'  	, type: 'string'},
	    	{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'   		, type: 'string'},
	    	{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'    		, type: 'string'},
	    	{name: 'INSPEC_TYPE'		, text: '<t:message code="system.label.purchase.inspectype" default="검사유형"/>'  	, type: 'string',comboType: 'AU',comboCode: 'Q005', allowBlank:false},
	    	{name: 'GOODBAD_TYPE'		, text: '<t:message code="system.label.purchase.passyn" default="합격여부"/>'  	, type: 'string',comboType: 'AU',comboCode: 'M414', allowBlank:false},
	    	{name: 'END_DECISION'		, text: '<t:message code="system.label.purchase.finaldecision" default="최종판정"/>'  	, type: 'string',comboType: 'AU',comboCode: 'Q033', allowBlank:false},
	    	{name: 'RECEIPT_Q'			, text: '<t:message code="system.label.purchase.receiptqty2" default="접수량"/>'   		, type: 'uniQty'},
	    	{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'  	, type: 'string'},
  			{name: 'TRNS_RATE'			, text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'    	,type: 'float', decimalPrecision:6, format:'0,000.000000', defaultValue: 1.000000},
	    	{name: 'INSPEC_Q'			, text: '<t:message code="system.label.product.inspecqty2" default="검사량(시료)"/>'		, type: 'uniQty', allowBlank:false},
	    	{name: 'BAD_INSPEC_Q'		, text: '<t:message code="system.label.purchase.defectqty2" default="불량(폐기)수량"/>'  	, type: 'uniQty'},
	    	{name: 'BAD_INSPEC_PER'		, text: '<t:message code="system.label.product.defectratepercent" default="불량률(%)"/>'  	, type: 'uniPercent'},
	    	{name: 'GOOD_INSPEC_Q'		, text: '<t:message code="system.label.purchase.passqty2stock" default="합격수량(재고)"/>'  	, type: 'uniQty'},
	    	{name: 'INSTOCK_Q'			, text: '<t:message code="system.label.purchase.receiptqty" default="입고량"/>'   		, type: 'uniQty'},
	    	{name: 'INSPEC_PRSN'		, text: '<t:message code="system.label.purchase.inspecchargeperson" default="검사담당자"/>' 	, type: 'string',comboType: 'AU',comboCode: 'Q022', allowBlank:false},
	    	{name: 'CUSTOM_CODE'		, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>' 	, type: 'string'},
	    	{name: 'CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'  	, type: 'string'},
	    	{name: 'RECEIPT_NUM'		, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'  	, type: 'string'},
	    	{name: 'RECEIPT_SEQ'		, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'  	, type: 'int'},
	    	{name: 'MAKE_LOT_NO'		, text: '<t:message code="system.label.purchase.customLOT" default="거래처LOT"/>'		, type: 'string'},
			{name: 'MAKE_DATE'			, text: '<t:message code="system.label.purchase.makedate" default="제조일자"/>'			, type: 'uniDate'},
			{name: 'MAKE_EXP_DATE'		, text: '<t:message code="system.label.purchase.expirationdate" default="유통기한"/>'			, type: 'uniDate'},
	    	{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'    		, type: 'string'},
	    	{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'  , type: 'string'},
	    	{name: 'INSPEC_DATE'		, text: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>'   		, type: 'uniDate'},
	    	{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.poclass" default="발주유형"/>'  	, type: 'string'},
	    	{name: 'LOT_NO'				, text: '<t:message code="system.label.purchase.lotno" default="LOT번호"/>'		, type: 'string'},
	    	{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'  	, type: 'string'},
	    	{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'  	, type: 'int'},
			//20191029 추가: 수주번호, 수주처, 수주품목명
			{name: 'SO_NUM'				, text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'				, type: 'string'},
			{name: 'SO_CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.soplace" default="수주처"/>'			, type: 'string'},
			{name: 'SO_ITEM_NAME'		, text: '수주품목명'				, type: 'string'}
		]
	});

	/**
	 * 主页面grid2 Model
	 */
	Unilite.defineModel('Mms200ukrvModel2', {
		/* fields: [
			{name: 'DIV_CODE'					, text: '<t:message code="system.label.purchase.division" default="사업장"/>'   		, type: 'string'},
			{name: 'INSPEC_NUM'					, text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>'   	, type: 'string'},
			{name: 'INSPEC_SEQ'					, text: '<t:message code="system.label.purchase.seq" default="순번"/>'   		, type: 'int'},
			{name: 'BAD_INSPEC_CODE'			, text: '<t:message code="system.label.purchase.inspectcode" default="검사코드"/>'   	, type: 'string'},
			{name: 'BAD_INSPEC_NAME'			, text: '<t:message code="system.label.purchase.inspectname" default="검사항목"/>'   	, type: 'string'},
			{name: 'BAD_INSPEC_Q'				, text: '<t:message code="system.label.purchase.inspectqty" default="검사수량"/>'   	, type: 'uniQty', allowBlank: false},
			{name: 'INSPEC_REMARK'				, text: '<t:message code="system.label.purchase.inspectcontents" default="검사내용"/>'   	, type: 'string'},
			{name: 'MANAGE_REMARK'				, text: '<t:message code="system.label.purchase.actioncontents" default="조치내역"/>'   	, type: 'string'}
		] */
		fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.purchase.division" default="사업장"/>'   		, type: 'string'},
			{name: 'INSPEC_NUM'			, text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>'   	, type: 'string'},
			{name: 'INSPEC_SEQ'			, text: '<t:message code="system.label.purchase.seq" default="순번"/>'   		, type: 'int'},
			{name: 'BAD_INSPEC_CODE'	, text: '<t:message code="system.label.purchase.defectcode" default="불량코드"/>'   	, type: 'string'},
			{name: 'BAD_INSPEC_NAME'	, text: '<t:message code="system.label.purchase.defectcodename" default="불량코드명"/>'   	, type: 'string'},
			{name: 'BAD_INSPEC_Q'		, text: '<t:message code="system.label.purchase.defectqty" default="불량수량"/>'   	, type: 'uniQty', allowBlank: true},
			{name: 'INSPEC_REMARK'		, text: '<t:message code="system.label.purchase.defectremark" default="불량내용"/>'   	, type: 'string'},
			{name: 'MANAGE_REMARK'		, text: '<t:message code="system.label.purchase.actioncontents" default="조치내역"/>'   	, type: 'string'},
			{name: 'SEQ'			, text: '출력순번'   	, type: 'int'}//표기순번
		]
	});

	/**
	 * 查询窗口model
	 */
	Unilite.defineModel('receiptNoMasterModel', {		//조회버튼 누르면 나오는 조회창
	    fields: [
	    	{name: 'INSPEC_NUM'    		, text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>'    	, type: 'string'},
	    	{name: 'INSPEC_SEQ'    		, text: '<t:message code="system.label.purchase.seq" default="순번"/>'    	    , type: 'int'},
	    	{name: 'INSPEC_DATE'    	, text: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>'    	, type: 'uniDate'},
	    	{name: 'CUSTOM_CODE'    	, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'    , type: 'string'},
	    	{name: 'CUSTOM_NAME'    	, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'    	, type: 'string'},
	    	{name: 'ITEM_CODE'    		, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'    	, type: 'string'},
	    	{name: 'ITEM_NAME'    		, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'    	, type: 'string'},
	    	{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'    	    , type: 'string'},
	    	{name: 'INSPEC_Q'			, text: '<t:message code="system.label.purchase.inspecqty" default="검사량"/>'    	, type: 'uniQty'},
	    	{name: 'GOOD_INSPEC_Q'		, text: '<t:message code="system.label.purchase.passqty" default="합격수량"/>'    	, type: 'uniQty'},
	    	{name: 'BAD_INSPEC_Q'   	, text: '<t:message code="system.label.purchase.defectqty" default="불량수량"/>'    	, type: 'uniQty'},
	    	{name: 'INSPEC_TYPE'		, text: '<t:message code="system.label.purchase.inspec" default="검사"/>'    	    , type: 'string', comboType: 'AU', comboCode: 'Q005'},
	    	{name: 'INSPEC_PRSN'		, text: '<t:message code="system.label.purchase.inspecchargeperson" default="검사담당자"/>'    , type: 'string'},
	    	{name: 'RECEIPT_NUM'		, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'    	, type: 'string'},
	    	{name: 'RECEIPT_SEQ'		, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'    	, type: 'int'},
	    	{name: 'LOT_NO'		    	, text: 'LOT NO'    	, type: 'string'}
		]
	});

	/**
	 * 接收参考grid model
	 */
	Unilite.defineModel('mms200ukrvRECEIPTModel', {	//접수참조
	    fields: [
			{name: 'CUSTOM_CODE'	    , text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'    , type: 'string'},
			{name: 'CUSTOM_NAME'	    , text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'    	, type: 'string'},
			{name: 'ITEM_CODE'			, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'    	, type: 'string'},
			{name: 'ITEM_NAME'			, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'    	, type: 'string'},
			{name: 'SPEC'				, text: '<t:message code="system.label.purchase.spec" default="규격"/>'    	    , type: 'string'},
			{name: 'RECEIPT_DATE'		, text: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>'    	, type: 'uniDate'},
			{name: 'INSPEC_METH_MATRL'	, text: '<t:message code="system.label.purchase.inspectype" default="검사유형"/>'    	, type: 'string', comboType: 'AU', comboCode: 'Q005'},
			{name: 'INSPEC_Q'			, text: '<t:message code="system.label.purchase.receiptqty2" default="접수량"/>'    	, type: 'uniQty'},
			{name: 'ORDER_UNIT'			, text: '<t:message code="system.label.purchase.purchaseunit" default="구매단위"/>'    	, type: 'string'},
			{name: 'TRNS_RATE'			, text: '<t:message code="system.label.purchase.containedqty" default="입수"/>'    	,type: 'float', decimalPrecision:6, format:'0,000.000000', defaultValue: 1.000000},
			{name: 'NOT_INSPEC_Q'		, text: '<t:message code="system.label.purchase.noinspecqty" default="미검사량"/>'    	, type: 'uniQty'},
		    {name: 'NOT_INSPEC_STOCK_Q'	, text: '<t:message code="system.label.purchase.noinspecqty2" default="미검사량(재고)"/>'    	, type: 'uniQty'},
			{name: 'RECEIPT_NUM'		, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'    	, type: 'string'},
			{name: 'RECEIPT_SEQ'		, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'    	, type: 'int'},
			{name: 'LOT_NO'				, text: 'LOT NO'        , type: 'string'},
			{name: 'ORDER_TYPE'			, text: '<t:message code="system.label.purchase.poclass" default="발주유형"/>'    	, type: 'string', comboType: 'AU', comboCode: 'M001'},
			{name: 'ORDER_NUM'			, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'    	, type: 'string'},
			{name: 'ORDER_SEQ'			, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'    	, type: 'int'},
			{name: 'MAKE_LOT_NO'		, text: '<t:message code="system.label.purchase.customLOT" default="거래처LOT"/>'		, type: 'string'},
			{name: 'MAKE_DATE'			, text: '<t:message code="system.label.purchase.makedate" default="제조일자"/>'			, type: 'uniDate'},
			{name: 'MAKE_EXP_DATE'		, text: '<t:message code="system.label.purchase.expirationdate" default="유통기한"/>'			, type: 'uniDate'},
			{name: 'REMARK'				, text: '<t:message code="system.label.purchase.remarks" default="비고"/>'    	    , type: 'string'},
			{name: 'PROJECT_NO'			, text: '<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'  , type: 'string'},
			{name: 'WH_CODE'			, text: 'WH_CODE'       , type: 'string'},
			//20191029 추가: 수주번호, 수주처, 수주품목명
			{name: 'SO_NUM'				, text: '<t:message code="system.label.purchase.sono" default="수주번호"/>'				, type: 'string'},
			{name: 'SO_CUSTOM_NAME'		, text: '<t:message code="system.label.purchase.soplace" default="수주처"/>'			, type: 'string'},
			{name: 'SO_ITEM_NAME'		, text: '수주품목명'				, type: 'string'}
		]
	});

	/**
	 * 主页面grid1 store
	 */
	var directMasterStore1 = Unilite.createStore('mms200ukrvMasterStore1', {
		model : 'Mms200ukrvModel1',
		uniOpt: {
			isMaster  : true,			// 상위 버튼 연결
			editable  : true,			// 수정 모드 사용
			deletable : true,			// 삭제 가능 여부
			useNavi   : false			// prev | newxt 버튼 사용
		},
		autoLoad : false,
		proxy    : directProxy,
		saveStore: function() {

			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
	   		var toUpdate = this.getUpdatedRecords();
	   		var toDelete = this.getRemovedRecords();

	   		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			/*****
			 * 21.02.17 시너지톡 연계 메세지에 넣을 품목 리스트 start
			 *****/
				var itemList = '';
				Ext.each(directMasterStore1.data.items, function(record, index) {
					if(index == 0){
						itemList = record.get('ITEM_CODE')+ '/' +  record.get('ITEM_NAME');
					}else if(directMasterStore1.getCount()-1 == index){
						itemList =  itemList + ' 외 ' + index + '건';
					}
				});
				masterForm.setValue('ITEM_LIST',itemList);
			/*****
			 *end
			 *****/

			Ext.each(list, function(record, index) {
				record.set('INSPEC_DATE', UniDate.getDbDateStr(panelResult.getValue('INSPEC_DATE')));
			});
			var param = masterForm.getValues();
				param.GS_SYTALK_FLAG = BsaCodeInfo.gsSyTalkFlag ;
			if(inValidRecs.length == 0) {
				lastSelectedRecord = masterGrid.getSelectedRecord();
				
				config = {
					params: [param],
					success: function(batch, option) {
						var result = batch.operations[0].getResultSet();
						masterForm.setValue("INSPEC_NUM", result["INSPEC_NUM"]);
						panelResult.setValue("INSPEC_NUM", result["INSPEC_NUM"]);
						Ext.getCmp('receiveBadWhCode').setValue('');
						Ext.getCmp('receiveGoodWhCode').setValue('');
						if(directMasterStore2.isDirty()){
							directMasterStore2.saveStore();
						}else{
							if(directMasterStore1.getCount() == 0){
                            	UniAppManager.app.onResetButtonDown();
                        	}else{
								UniAppManager.app.onQueryButtonDown();
                        	}
						}

					}
				};
				this.syncAllDirect(config);
			} else {
	            Ext.getCmp('mms200ukrvGrid1').uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(records[0] != null){
					masterForm.setValue('INSPEC_NUM', records[0].get('INSPEC_NUM'));
					masterForm.setValue('ITEMCODE'  , records[0].get('ITEM_CODE'));
					masterForm.setValue('INSPEC_SEQ', records[0].get('INSPEC_SEQ'));
			
					if((masterForm.getValue('INSPEC_NUM') != '') && (masterForm.getValue('ITEMCODE') != '') && (masterForm.getValue('INSPEC_SEQ') != '')){
						directMasterStore2.loadStoreRecords(records[0]);
					}
				}else{
					//masterForm.setValue('INSPEC_NUM','');
					masterForm.setValue('ITEMCODE','');
					masterForm.setValue('INSPEC_SEQ','');
					masterGrid2.getStore().removeAll();
				}
			},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log(param);
			
			lastSelectedRecord = masterGrid.getSelectedRecord();
			
			this.load({
				params : param,
				callback : function(batch, option) {
					if(Ext.isEmpty(lastSelectedRecord)) {
						return;
					}
					
					var inspecSeq = lastSelectedRecord.get('INSPEC_SEQ');
					
					masterGrid.select(masterGrid.store.find('INSPEC_SEQ', inspecSeq));
				}
			});
		}
	});

	/**
	 * 主页面grid2 store
	 */
	var directMasterStore2 = Unilite.createStore('mms200ukrvMasterStore2', {
		model: 'Mms200ukrvModel2',
		uniOpt: {
			isMaster  : false,			// 상위 버튼 연결
			editable  : true,			// 수정 모드 사용
			deletable : false,			// 삭제 가능 여부
			useNavi   : false			// prev | newxt 버튼 사용
		},
	    autoLoad : false,
	    proxy    : directProxy2,
		loadStoreRecords: function(record){
			var param= Ext.getCmp('searchForm').getValues();
			param["ITEM_CODE"] = record.data.ITEM_CODE;
			param["ORDER_TYPE"] = record.data.ORDER_TYPE;
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			var param = masterForm.getValues();
			var record = masterGrid.getSelectedRecord();
			if(record){
				param["INSPEC_NUM"] = (Ext.isEmpty(record.get("INSPEC_NUM")) ? param['INSPEC_NUM'] : record.get("INSPEC_NUM"));
				param["INSPEC_SEQ"] = record.get("INSPEC_SEQ");
			}
			if(inValidRecs.length == 0) {
                var config = {
                    params: [param],
                    success: function(batch, option) {
                        masterForm.getForm().wasDirty = false;
                        masterForm.resetDirtyStatus();
                        UniAppManager.setToolbarButtons('save', false);
                        UniAppManager.app.onQueryButtonDown();
                    }
                };
                this.syncAllDirect(config);
            }else{
                masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
		}
	});

	/**
	 * 查询窗口store
	 */
	var receiptNoMasterStore = Unilite.createStore('receiptNoMasterStore', {	//조회버튼 누르면 나오는 조회창
		model    : 'receiptNoMasterModel',
        autoLoad : false,
        uniOpt : {
        	isMaster  : false,			// 상위 버튼 연결
        	editable  : false,			// 수정 모드 사용
        	deletable : false,			// 삭제 가능 여부
            useNavi   : false			// prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
            	read : 'mms200ukrvService.selectreceiptNumMasterList'
            }
        },
		loadStoreRecords : function()	{
			var param= receiptNoSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	/**
	 * 接收参考store
	 */
	var receiptStore = Unilite.createStore('mms200ukrvReceiptStore', {//접수참조
		model: 'mms200ukrvRECEIPTModel',
        autoLoad: false,
        uniOpt : {
        	isMaster: false,			// 상위 버튼 연결
        	editable: false,			// 수정 모드 사용
        	deletable:false,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
            	read    : 'mms200ukrvService.selectreceiptList'
            }
        },
        listeners:{
        	load:function(store, records, successful, eOpts){
        			if(successful)	{
        			   var masterRecords = directMasterStore1.data.filterBy(directMasterStore1.filterNewOnly);
        			   var estiRecords = new Array();
        			   if(masterRecords.items.length > 0)	{
        			   		console.log("store.items :", store.items);
        			   		console.log("records", records);
            			   	Ext.each(records, function(item, i)	{
		   							Ext.each(masterRecords.items, function(record, i)	{
		   								console.log("record :", record);
		   									if((record.data['RECEIPT_NUM'] == item.data['RECEIPT_NUM'])
		   									&& (record.data['RECEIPT_SEQ'] == item.data['RECEIPT_SEQ'])){
		   										estiRecords.push(item);
		   									}
		   							});
            			   	});
            			   store.remove(estiRecords);
        			   }
        			}
        	}
        },
        loadStoreRecords : function()	{
			var param= receiptSearch.getValues();
			console.log( param );
			this.load({
				params : param
			});
		}
	});

	/**
	 * 左侧条件表单
	 */
	var masterForm = Unilite.createSearchPanel('searchForm', {
		title       : '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
        defaultType : 'uniSearchSubPanel',
		items: [{
			title  : '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>',
   			itemId : 'search_panel1',
           	layout : {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel   : '<t:message code="system.label.purchase.division" default="사업장"/>',
				name         : 'DIV_CODE',
				xtype        : 'uniCombobox',
				comboType    : 'BOR120',
				allowBlank   : false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('DIV_CODE', newValue);
						panelResult.setValue('INSPEC_PRSN', '');
						masterForm.setValue('INSPEC_PRSN', '');
					}
				}
			},{
				fieldLabel   : '<t:message code="system.label.purchase.inspectype" default="검사유형"/>',
				name         : 'INSPEC_TYPE',
				xtype        : 'uniCombobox',
				comboType    : 'AU',
				comboCode    : 'Q005',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INSPEC_TYPE', newValue);
					}
				}
			},{
		        fieldLabel   : '<t:message code="system.label.purchase.inspecdate" default="검사일"/>',
		        name         : 'INSPEC_DATE',
		        xtype        : 'uniDatefield',
		       	value        : UniDate.get('today'),
		     	listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INSPEC_DATE', newValue);
					}
				}
			},{
				fieldLabel   : '<t:message code="system.label.purchase.inspeccharge" default="검사담당"/>',
				name         : 'INSPEC_PRSN',
				xtype        : 'uniCombobox',
				comboType    : 'AU',
				comboCode    : 'Q022',
				allowBlank   : false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INSPEC_PRSN', newValue);
					},beforequery:function( queryPlan, eOpts )   {
						var store = queryPlan.combo.store;
						var pRStore = panelResult.getField('INSPEC_PRSN').store;
						var divChk = false;
						Ext.each(store.data.items, function(record,i){
							if(!Ext.isEmpty(record.get('refCode1'))){
								divChk = true;
							}
					    });
						store.clearFilter();
						pRStore.clearFilter();
						if(!Ext.isEmpty(masterForm.getValue('DIV_CODE')) && divChk == true ){
							store.filterBy(function(record){
								return record.get('refCode1') == masterForm.getValue('DIV_CODE');
							});
							pRStore.filterBy(function(record){
								return record.get('refCode1') == masterForm.getValue('DIV_CODE');
							});
						}else if(divChk == false){
							 	return true;
						}else{
							store.filterBy(function(record){
								return false;
							});
							pRStore.filterBy(function(record){
								return false;
							});

						}
					}
				}
			},{
				fieldLabel   : '<t:message code="system.label.purchase.inspecno" default="검사번호"/>',
				name         : 'INSPEC_NUM',
				xtype        : 'uniTextfield',
				readOnly     : true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('INSPEC_NUM', newValue);
					}
				}
			},{
				fieldLabel   : '<t:message code="system.label.purchase.passyn" default="합격여부"/>',
				name         : 'GOODBAD_TYPE',
				xtype        : 'uniCombobox',
				comboType    : 'AU',
				comboCode    : 'M414',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('GOODBAD_TYPE', newValue);
					}
				}
			},{
				fieldLabel   : '<t:message code="system.label.purchase.itemcodevalue" default="아이템코드값"/>',
				name         : 'ITEM_CODE',
				xtype        : 'uniTextfield',
				hidden       : true
			},{
				fieldLabel   : '<t:message code="system.label.purchase.seq" default="순번"/>',
				name         : 'INSPEC_SEQ',
				xtype        : 'uniTextfield',
				hidden       : true
			},{
				fieldLabel   : 'GOOD_WH_CODE',
				name         : 'GOOD_WH_CODE',
				xtype        : 'uniTextfield',
				readOnly     : true,
				hidden       : true,			//20200701 추가
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {

					}
				}
			},{
				fieldLabel   : 'BAD_WH_CODE',
				name         : 'BAD_WH_CODE',
				xtype        : 'uniTextfield',
				readOnly     : true,
				hidden       : true,			//20200701 추가
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {

					}
				}
			},{
				fieldLabel   : 'ITEM_LIST',
				name         : 'ITEM_LIST',
				xtype        : 'textarea',
				hidden       : false
			},{
				fieldLabel   : 'CUSTOM_NAME',
				name         : 'CUSTOM_NAME',
				xtype        : 'uniTextfield',
				hidden       : false
			}]
		}],
		setAllFieldsReadOnly : setAllFieldsReadOnly
	});

	/**
	 * 北侧条件表单
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel   : '<t:message code="system.label.purchase.division" default="사업장"/>',
				name         : 'DIV_CODE',
				xtype        : 'uniCombobox',
				comboType    : 'BOR120',
				allowBlank   : false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('DIV_CODE', newValue);
						panelResult.setValue('INSPEC_PRSN', '');
						masterForm.setValue('INSPEC_PRSN', '');
					}
				}
			},{
				fieldLabel   : '<t:message code="system.label.purchase.inspectype" default="검사유형"/>',
				name         : 'INSPEC_TYPE',
				xtype        : 'uniCombobox',
				comboType    : 'AU',
				comboCode    : 'Q005',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('INSPEC_TYPE', newValue);
					}
				}
			},{
		        fieldLabel   : '<t:message code="system.label.purchase.inspecdate" default="검사일"/>',
		        name         : 'INSPEC_DATE',
		        xtype        : 'uniDatefield',
		       	value        : UniDate.get('today'),
		     	listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('INSPEC_DATE', newValue);
					}
				}
			},{ text:'<div style="color: red">검사성적서 출력</div>',
	            xtype: 'button',
	            margin: '0 0 0 15',
	            hidden: rptBtnYn,
	            handler: function(){
	            	  if(!panelResult.getInvalidMessage()) return;   //필수체크

	                  var selectedRecords = masterGrid.getSelectedRecords();
	                  if(Ext.isEmpty(selectedRecords)){
	                  	alert('출력할 데이터를 선택하여 주십시오.');
	                  	return;
	                  }
	                var inspecSeq = '';
	                var itemCode = '';
	                var inspecNum = '';
					var param = panelResult.getValues();
					Ext.each(selectedRecords, function(selectedRecord, index){
							inspecNum		= selectedRecord.get('INSPEC_NUM');
							inspecSeq		= selectedRecord.get('INSPEC_SEQ');
							itemCode	    = selectedRecord.get('ITEM_CODE');
					});
					param["INSPEC_NUM"] = inspecNum;
					param["INSPEC_SEQ"] = inspecSeq;
					param["INSPEC_NUM_SEQ"] = inspecNum + inspecSeq;
					param["ITEM_CODE"]  = itemCode;
	      			param["MAIN_CODE"]  = 'M030';
	      			param["sTxtValue2_fileTitle"]='검사성적서';
	      			param["PGM_ID"]='mms200ukrv';
	      			var win = '';
	      			if(BsaCodeInfo.gsReportGubun == 'CLIP'){
	      				 win = Ext.create('widget.ClipReport', {
	      		                url: CPATH+'/matrl/mms200clukrv.do',
	      		                prgID: 'mms200ukrv',
	      		                extParam: param
	      		            });
	      					win.center();
	      					win.show();
	      			}
	            }
			},{
				fieldLabel   : '<t:message code="system.label.purchase.inspeccharge" default="검사담당"/>',
				name         : 'INSPEC_PRSN',
				xtype        : 'uniCombobox',
				comboType    : 'AU',
				comboCode    : 'Q022',
				allowBlank   : false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('INSPEC_PRSN', newValue);
					},beforequery:function( queryPlan, eOpts )   {
						var store = queryPlan.combo.store;
						var pRStore = masterForm.getField('INSPEC_PRSN').store;
						var divChk = false;
						Ext.each(store.data.items, function(record,i){
							if(!Ext.isEmpty(record.get('refCode1'))){
								divChk = true;
							}
					    });
						store.clearFilter();
						pRStore.clearFilter();
						if(!Ext.isEmpty(panelResult.getValue('DIV_CODE')) && divChk == true ){
							store.filterBy(function(record){
								return record.get('refCode1') == panelResult.getValue('DIV_CODE');
							});
							pRStore.filterBy(function(record){
								return record.get('refCode1') == panelResult.getValue('DIV_CODE');
							});
						}else if(divChk == false){
							 	return true;
						}else{
							store.filterBy(function(record){
								return false;
							});
							pRStore.filterBy(function(record){
								return false;
							});

						}
					}
				}
			},{
				fieldLabel   : '<t:message code="system.label.purchase.inspecno" default="검사번호"/>',
				name         : 'INSPEC_NUM',
				xtype        : 'uniTextfield',
				readOnly     : true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('INSPEC_NUM', newValue);
					}
				}
			},{
				fieldLabel   : '<t:message code="system.label.purchase.passyn" default="합격여부"/>',
				name         : 'GOODBAD_TYPE',
				xtype        : 'uniCombobox',
				comboType    : 'AU',
				comboCode    : 'M414',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						masterForm.setValue('GOODBAD_TYPE', newValue);
					}
				}
			},{
				fieldLabel   : '<t:message code="system.label.purchase.itemcodevalue" default="아이템코드값"/>',
				name         : 'ITEM_CODE',
				xtype        : 'uniTextfield',
				hidden       : true
			},{
				fieldLabel   : '<t:message code="system.label.purchase.seq" default="순번"/>',
				name         : 'INSPEC_SEQ',
				xtype        : 'uniTextfield',
				hidden       : true
			}],
		setAllFieldsReadOnly : setAllFieldsReadOnly
    });

    /**
	 * 查询窗口条件表单
	 */
	var receiptNoSearch = Unilite.createSearchForm('receiptNoSearchForm', {		//조회버튼 누르면 나오는 조회창
		layout: {type: 'uniTable', columns : 2},
	    trackResetOnLoad: true,
	    items: [
			{
				fieldLabel : '<t:message code="system.label.purchase.division" default="사업장"/>',
				name       : 'DIV_CODE',
				xtype      : 'uniCombobox',
				comboType  : 'BOR120',
				allowBlank : false
			},{
				fieldLabel     : '<t:message code="system.label.purchase.inspecdate" default="검사일"/>',
				xtype          : 'uniDateRangefield',
				startFieldName : 'INSPEC_DATE_FR',
				endFieldName   : 'INSPEC_DATE_TO',
				startDate      : UniDate.get('startOfMonth'),
				endDate        : UniDate.get('today'),
				width          : 315
			},
			Unilite.popup('CUST',{
				fieldLabel     : '<t:message code="system.label.purchase.custom" default="거래처"/>',
				textFieldWidth : 170,
				validateBlank  : false
			}),
			Unilite.popup('DIV_PUMOK',{
				fieldLabel     : '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
				textFieldWidth : 170,
				autoPopup  : true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
						},
						scope: this
					},
					onClear: function(type) {
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': receiptNoSearch.getValue('DIV_CODE')});
					}
				}
			}),
			{
				fieldLabel : '<t:message code="system.label.purchase.inspectype" default="검사유형"/>',
				name       : 'INSPEC_TYPE',
				xtype      : 'uniCombobox',
				comboType  : 'AU',
				comboCode  : 'Q005'
			},{
				fieldLabel : '<t:message code="system.label.purchase.passyn" default="합격여부"/>',
				name       : 'GOODBAD_TYPE',
				xtype      : 'uniCombobox',
				comboType  : 'AU',
				comboCode  : 'M414'
			}
		],
		setAllFieldsReadOnly : setAllFieldsReadOnly
    }); // createSearchForm

    /**
	 * 接收参考条件表单
	 */
    var receiptSearch = Unilite.createSearchForm('receiptForm', {//접수참조
            layout :  {type : 'uniTable', columns : 3},
            items :[
            	Unilite.popup('CUST',{
					fieldLabel     : '<t:message code="system.label.purchase.custom" default="거래처"/>',
					textFieldWidth : 170,
					validateBlank  : false
				}),
				Unilite.popup('DIV_PUMOK',{
					fieldLabel     : '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
					textFieldWidth : 170,
					colspan:2,
					validateBlank  : false
				}),
				{
					fieldLabel     : '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>',
					xtype          : 'uniDateRangefield',
					startFieldName : 'RECEIPT_DATE_FR',
					endFieldName   : 'RECEIPT_DATE_TO',
					startDate      : UniDate.get('startOfMonth'),
					endDate        : UniDate.get('today'),
					width          : 315
				},{
					fieldLabel     : '<t:message code="system.label.purchase.poclass" default="발주유형"/>',
					name           : 'ORDER_TYPE',
					xtype          : 'uniCombobox',
					comboType      : 'AU',
					comboCode      : 'M001'
				},
				{
					fieldLabel     : '<t:message code="system.label.purchase.lotno" default="LOT번호"/>',
					xtype          : 'uniTextfield',
					name           : 'LOT_NO'
				},
				{
				    fieldLabel   : '<t:message code="system.label.purchase.division" default="사업장"/>',
				    name         : 'DIV_CODE',
				    xtype        : 'uniCombobox',
				    comboType    : 'BOR120',
				    hidden       : true
			    }]
    });

    /**
     * 主列表grid
     */
	var masterGrid = Unilite.createGrid('mms200ukrvGrid1', {
    	// for tab
		layout : 'fit',
		region : 'center',
		uniOpt: {
			useLiveSearch : true,
			expandLastColumn: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		tbar: [{	fieldLabel: '<t:message code="system.label.product.receiptwarehouse" default="입고창고"/>',
					name:'GOOD_WH_CODE',
					labelWidth: 70,
					id: 'receiveGoodWhCode',
					xtype: 'uniCombobox',
					comboType   : 'OU',
					listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
							masterForm.setValue('GOOD_WH_CODE',newValue);
						},
		                beforequery:function( queryPlan, eOpts )   {
		                    var store = queryPlan.combo.store;
		                        store.clearFilter();
		                    if(!Ext.isEmpty(masterForm.getValue('DIV_CODE'))){
		                        store.filterBy(function(record){
		                        return record.get('option') == masterForm.getValue('DIV_CODE');
		                   		 })
		                    }else{
		                        store.filterBy(function(record){
		                        return false;
		                   		 })
		                    }
		                }
					}
				},{
		            xtype: 'component',
		            tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 3px;' },
		            width: 20
		        },{
					fieldLabel: '<t:message code="system.label.product.badwarehouse" default="불량창고"/>',
					name:'BAD_WH_CODE',
					id: 'receiveBadWhCode',
					xtype: 'uniCombobox',
					labelWidth: 70,
					comboType   : 'OU',
					listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
							masterForm.setValue('BAD_WH_CODE',newValue);
						},
		                beforequery:function( queryPlan, eOpts )   {
		                    var store = queryPlan.combo.store;
		                        store.clearFilter();
		                    if(!Ext.isEmpty(masterForm.getValue('DIV_CODE'))){
		                        store.filterBy(function(record){
		                        return record.get('option') == masterForm.getValue('DIV_CODE');
		                    	})
		                    }else{
		                        store.filterBy(function(record){
		                        return false;
		                    	})
		                	}
		                }
					}
				},{
		            xtype: 'component',
		            tdAttrs: {style: 'border-top: 1px solid #cccccc;  padding-top: 3px;' },
		            width: 30
		        },{
			itemId: 'receiptBtn',
			text: '<div style="color: blue"><t:message code="system.label.purchase.receiptrefer" default="접수참조"/></div>',
			handler: function() {
				if(masterForm.setAllFieldsReadOnly(true)){
					openReceiptWindow();
				}
			}
		},'-'],
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		store: directMasterStore1,
		columns: [
			{dataIndex: 'DIV_CODE'			, width: 100, hidden: true},
			{dataIndex: 'INSPEC_NUM'		, width: 120, hidden: true},
			{dataIndex: 'INSPEC_SEQ'		, width: 60, align:"center"},
			{dataIndex: 'ITEM_CODE'			, width: 120},
			{dataIndex: 'ITEM_NAME'			, width: 150},
            {dataIndex: 'LOT_NO'            , width: 120,
                getEditor: function(record) {
                     return getLotPopupEditor(BsaCodeInfo.gsManageLotNoYN);
                }
            },
			{dataIndex: 'SPEC'				, width: 150},
			{dataIndex: 'INSPEC_TYPE'		, width: 90},
			{dataIndex: 'GOODBAD_TYPE'		, width: 90, align:"center"},
			{dataIndex: 'END_DECISION'		, width: 90, align:"center"},
			{dataIndex: 'RECEIPT_Q'			, width: 100},
			{dataIndex: 'ORDER_UNIT'		, width: 66, align:"center"},
			{dataIndex: 'TRNS_RATE'			, width: 66},
			{dataIndex: 'INSPEC_Q'			, width: 100},
			{dataIndex: 'BAD_INSPEC_Q'		, width: 110},
			{dataIndex: 'BAD_INSPEC_PER'	, width: 110, hidden: true},
			{dataIndex: 'GOOD_INSPEC_Q'		, width: 110},
			{dataIndex: 'INSTOCK_Q'			, width: 100},
			{dataIndex: 'INSPEC_PRSN'		, width: 100, align:"center"},
			{dataIndex: 'CUSTOM_CODE'		, width: 120, hidden: true},
			{dataIndex: 'CUSTOM_NAME'		, width: 120},
			{dataIndex: 'RECEIPT_NUM'		, width: 120},
			{dataIndex: 'RECEIPT_SEQ'		, width: 80, align:"center"},
			{dataIndex: 'MAKE_LOT_NO'		, width: 100},
			{dataIndex: 'MAKE_DATE'			, width: 100},
			{dataIndex: 'MAKE_EXP_DATE'		, width: 100},
			{dataIndex: 'REMARK'			, width: 180},
			{dataIndex: 'PROJECT_NO'		, width: 120,
			    getEditor : function(record){
			    	return getPjtNoPopupEditor();
			    }
			},
			{dataIndex: 'INSPEC_DATE'		, width: 80, hidden: true},
			{dataIndex: 'ORDER_TYPE'		, width: 80, hidden: true},
			{dataIndex: 'ORDER_NUM'			, width: 80, hidden: true},
			{dataIndex: 'ORDER_SEQ'			, width: 80, hidden: true, align:"center"},
			//20191029 추가: 수주번호, 수주처, 수주품목명
			{ dataIndex: 'SO_NUM'			, width:100 ,hidden: false},
			{ dataIndex: 'SO_CUSTOM_NAME'	, width:150 ,hidden: false},
			{ dataIndex: 'SO_ITEM_NAME'		, width:200 ,hidden: false}
		],
		listeners: {
			selectionchange: function( grid, selected, eOpts ){
				if(selected && selected[0]){
//					if(selected[0].get("INSPEC_NUM") && selected[0].get("INSPEC_NUM") != ""){
						masterForm.setValue('INSPEC_SEQ',selected[0].get('INSPEC_SEQ'));
						directMasterStore2.loadStoreRecords(selected[0]);
//					}else{
//					    masterGrid2.reset();
//					    directMasterStore2.clearData();
//				    }
				}
			},
			beforeedit  : function( editor, e, eOpts ) {

				if(e.record.phantom == true){
					if (UniUtils.indexOf(e.field,['REMARK','INSPEC_Q','INSPEC_PRSN','INSPEC_TYPE','PROJECT_NO','END_DECISION', 'GOODBAD_TYPE','GOOD_INSPEC_Q'])){
						return true;
					}
				}else{
					if (UniUtils.indexOf(e.field,['REMARK','INSPEC_PRSN','PROJECT_NO','END_DECISION', 'GOODBAD_TYPE','GOOD_INSPEC_Q'])){
						return true;
					}
				}
				if(e.field == 'INSTOCK_Q') return false;
				if(UniUtils.indexOf(e.field,['LOT_NO'])){
					if(e.record.get("ITEM_CODE") == ''){
	        			alert('<t:message code="system.message.purchase.message028" default="품목코드를 입력 하십시오."/>');
	        			return false;
	        		}
					return true;
				}
                if(e.record.data.INSPEC_TYPE == '01'){
                	return false;
                }else{
                    return true;
                }
				if(e.record.data.INSPEC_TYPE == '02'){
					if(e.field == 'GOODBAD_TYPE') return true;
				}else if(e.record.data.INSTOCK_Q == e.record.data.INSPEC_Q){
					return false;
				}else{
					return false;
				}

				return false;
			}
		},
		setReceiptData:function(record) {
       		var grdRecord = this.getSelectedRecord();
       		grdRecord.set('INSPEC_NUM'			, '');
			grdRecord.set('DIV_CODE'			, masterForm.getValue('DIV_CODE'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
			grdRecord.set('SPEC'				, record['SPEC']);
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
			grdRecord.set('INSPEC_TYPE'			, record['INSPEC_METH_MATRL']);
			grdRecord.set('RECEIPT_Q'			, record['NOT_INSPEC_Q']);
			grdRecord.set('INSPEC_Q'			, record['NOT_INSPEC_STOCK_Q']);
			grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
			grdRecord.set('ORDER_NUM'			, record['ORDER_NUM']);
			grdRecord.set('ORDER_SEQ'			, record['ORDER_SEQ']);
			grdRecord.set('REMARK'				, record['REMARK']);
			grdRecord.set('PROJECT_NO'			, record['PROJECT_NO']);
			grdRecord.set('CUSTOM_CODE'			, record['CUSTOM_CODE']);
			grdRecord.set('CUSTOM_NAME'			, record['CUSTOM_NAME']);
			grdRecord.set('ORDER_TYPE'			, record['ORDER_TYPE']);
			grdRecord.set('RECEIPT_NUM'			, record['RECEIPT_NUM']);
			grdRecord.set('RECEIPT_SEQ'			, record['RECEIPT_SEQ']);
			grdRecord.set('LOT_NO'				, record['LOT_NO']);
			grdRecord.set('INSPEC_PRSN'			, masterForm.getValue('INSPEC_PRSN'));
			grdRecord.set('INSPEC_DATE'			, masterForm.getValue('INSPEC_DATE'));
			if(!Ext.isEmpty(masterForm.getValue('GOODBAD_TYPE'))){
                grdRecord.set('GOODBAD_TYPE'          , masterForm.getValue('GOODBAD_TYPE'));
			}else{
                grdRecord.set('GOODBAD_TYPE'          , '01');
			}
			grdRecord.set('GOOD_INSPEC_Q'		, record[('NOT_INSPEC_STOCK_Q')]);
			grdRecord.set('BAD_INSPEC_Q'		, 0);
			grdRecord.set('INSTOCK_Q'			, 0);
			grdRecord.set('END_DECISION'		, '01');
			//masterForm.setValue('GOOD_WH_CODE'	, record['WH_CODE']);
			//masterForm.setValue('BAD_WH_CODE'	, record['WH_CODE']);

			grdRecord.set('MAKE_LOT_NO'			, record['MAKE_LOT_NO']);
			grdRecord.set('MAKE_DATE'			, record['MAKE_DATE']);
			grdRecord.set('MAKE_EXP_DATE'		, record['MAKE_EXP_DATE']);

			//20191029 추가: 수주번호, 수주처, 수주품목명
			grdRecord.set('SO_NUM'				, record['SO_NUM']);
			grdRecord.set('SO_CUSTOM_NAME'		, record['SO_CUSTOM_NAME']);
			grdRecord.set('SO_ITEM_NAME'		, record['SO_ITEM_NAME']);
		}
	});//End of var masterGrid = Unilite.createGrid('mms200ukrvGrid1', {

	/**
     * 主列表grid2
     */
	var masterGrid2 = Unilite.createGrid('mms200ukrvGrid2', {
		layout: 'fit',
		region: 'south',
		uniOpt: {
			useLiveSearch : true,
			expandLastColumn: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
		},
		tbar: [{
			itemId: 'sendMessageBtn',
			text: '<div style="color: blue">메세지전송</div>',
			hidden: BsaCodeInfo.gsSyTalkFlag == "2"?false:true,
			handler: function() {
				if(!Ext.isEmpty(panelResult.getValue('INSPEC_NUM'))){
					
					var selectRecord = masterGrid.getSelectedRecord();
					
					if(Ext.isEmpty(selectRecord)){
						Ext.Msg.alert('확인', "전송할 데이터가 없습니다.");
					}else{
						
						if(selectRecord.get('GOODBAD_TYPE') == '02'){
							var param = {
								"DIV_CODE" : panelResult.getValue('DIV_CODE'),
								"INSPEC_NUM": selectRecord.get('INSPEC_NUM'),
								"INSPEC_SEQ": selectRecord.get('INSPEC_SEQ')
							};
							mms200ukrvService.sendMsg(param, function(provider, response) {
								if(!Ext.isEmpty(provider)){
									if(provider=='Y'){
										UniAppManager.updateStatus('전송 완료');
									} else {
										UniAppManager.updateStatus('전송 실패');
									}
								} else {
									UniAppManager.updateStatus('전송 실패');
								}
							});
						}else{
							Ext.Msg.alert('확인', "불합격 데이터만 전송 가능합니다.");
						}
					}
				}else{
					Ext.Msg.alert('확인', "전송할 데이터가 없습니다.");
				}
		/*		
				var param = {
					"DIV_CODE"	: panelSearch.getValue('DIV_CODE'),
					"ITEM_CODE"	: panelSearch.getValue('ITEM_CODE')
				};
				mms200ukrvService.sendMsg(param, function(provider, response) {
					if(!Ext.isEmpty(provider)){
						if(provider=='Y'){
							UniAppManager.updateStatus('전송 완료');
						} else {
							UniAppManager.updateStatus('전송 실패');
						}
					} else {
						UniAppManager.updateStatus('전송 실패');
					}
				});*/
			}
		},'-'],
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		store: directMasterStore2,
		columns: [
			{dataIndex: 'DIV_CODE'				, width: 100, hidden: true},
			{dataIndex: 'INSPEC_NUM'			, width: 100, hidden: true},
			{dataIndex: 'INSPEC_SEQ'			, width: 80, hidden: true, align:"center"},
			{dataIndex: 'BAD_INSPEC_CODE'		, width: 80},
			{dataIndex: 'BAD_INSPEC_NAME'		, width: 150},
			{dataIndex: 'BAD_INSPEC_Q'			, width: 100},
			{dataIndex: 'INSPEC_REMARK'			, width: 400},
			{dataIndex: 'MANAGE_REMARK'			, width: 400},
			{dataIndex: 'SEQ'			, width: 80,align:"center"}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field,[
					'BAD_INSPEC_Q','INSPEC_REMARK','MANAGE_REMARK','SEQ'
				])){
					return true;
				}else{
					return false;
				}
			}
		}
	});//End of var masterGrid = Unilite.createGrid('mms200ukrvGrid1', {

	/**
     * 查询窗口grid
     */
    var receiptNoMasterGrid = Unilite.createGrid('mms200ukrvOrderNoMasterGrid', {		//조회버튼 누르면 나오는 조회창
        layout : 'fit',
		store  : receiptNoMasterStore,
		uniOpt:{
			useLiveSearch    : true,
			useGroupSummary  : true,
			expandLastColumn : false,
			useRowNumberer   : false,
			filter: {
				useFilter  : false,
				autoCreate : false
			},
			excel: {
				useExcel      : true,			//엑셀 다운로드 사용 여부
				exportGroup   : true, 		//group 상태로 export 여부
				onlyData      : false,
				summaryExport : true
			}
		},
        columns:  [
			{ dataIndex: 'INSPEC_NUM'    		    ,  width:120},
			{ dataIndex: 'INSPEC_SEQ'    		    ,  width:50, align:"center"},
			{ dataIndex: 'INSPEC_DATE'    	    	,  width:85},
			{ dataIndex: 'CUSTOM_CODE'    	    	,  width:93,hidden:true},
			{ dataIndex: 'CUSTOM_NAME'    	    	,  width:133},
			{ dataIndex: 'ITEM_CODE'    		    ,  width:120},
			{ dataIndex: 'ITEM_NAME'    		    ,  width:150},
			{ dataIndex: 'SPEC'				    	,  width:150},
			{ dataIndex: 'INSPEC_Q'			    	,  width:80},
			{ dataIndex: 'GOOD_INSPEC_Q'		    ,  width:80},
			{ dataIndex: 'BAD_INSPEC_Q'   	    	,  width:80},
			{ dataIndex: 'INSPEC_TYPE'		    	,  width:90},
			{ dataIndex: 'INSPEC_PRSN'		    	,  width:66, hidden:true},
			{ dataIndex: 'RECEIPT_NUM'		    	,  width:120},
			{ dataIndex: 'RECEIPT_SEQ'		    	,  width:80, align:"center"},
			{ dataIndex: 'LOT_NO'		    	    ,  width:80}
		],
        listeners: {
	          onGridDblClick: function(grid, record, cellIndex, colName) {
		          	receiptNoMasterGrid.returnData(record);
		          	UniAppManager.app.onQueryButtonDown();
		          	SearchInfoWindow.hide();
	          }
        },
        returnData: function(record)	{
        	if(Ext.isEmpty(record))	{
          		record = this.getSelectedRecord();
            }
		    masterForm.setValues({
		    	'INSPEC_DATE' : record.get('INSPEC_DATE'),
		    	'INSPEC_NUM'  : record.get('INSPEC_NUM'),
		    	'ITEMCODE'    : record.get('ITEM_CODE'),
		    	'INSPEC_PRSN' : record.get('INSPEC_PRSN')
		    });
		    panelResult.setValues({
		    	'INSPEC_DATE' : record.get('INSPEC_DATE'),
		    	'INSPEC_NUM'  : record.get('INSPEC_NUM'),
		    	'ITEMCODE'    : record.get('ITEM_CODE'),
		    	'INSPEC_PRSN' : record.get('INSPEC_PRSN')
		    });
          }
    });

    /**
     * 接收参考grid
     */
    var receiptGrid = Unilite.createGrid('mms200ukrvOtherorderGrid', {//접수참조
        layout : 'fit',
    	store: receiptStore,
    	uniOpt:{
			useLiveSearch    : true,
			expandLastColumn : false,
			onLoadSelectFirst : false,
			useRowNumberer   : false
		},
    	selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }),
        columns: [
			{ dataIndex: 'CUSTOM_CODE'	    	,  width:93,hidden:true},
			{ dataIndex: 'CUSTOM_NAME'	    	,  width:93},
			{ dataIndex: 'ITEM_CODE'			,  width:120},
			{ dataIndex: 'ITEM_NAME'			,  width:150},
			{ dataIndex: 'SPEC'					,  width:150},
			{ dataIndex: 'RECEIPT_DATE'			,  width:85},
			{ dataIndex: 'INSPEC_METH_MATRL'	,  width:73},
			{ dataIndex: 'INSPEC_Q'				,  width:100},
			{ dataIndex: 'ORDER_UNIT'			,  width:73,align:"center"},
			{ dataIndex: 'TRNS_RATE'		    ,  width:73,align:"right"},
			{ dataIndex: 'NOT_INSPEC_Q'			,  width:100},
			{ dataIndex: 'NOT_INSPEC_STOCK_Q'	,  width:120},
			{ dataIndex: 'RECEIPT_NUM'			,  width:120},
			{ dataIndex: 'RECEIPT_SEQ'			,  width:80,align:"center"},
			{ dataIndex: 'LOT_NO'				,  width:120},
			{ dataIndex: 'ORDER_TYPE'			,  width:100},
			{ dataIndex: 'ORDER_NUM'			,  width:120,hidden:true},
			{ dataIndex: 'ORDER_SEQ'			,  width:80,hidden:true},
			{dataIndex: 'MAKE_LOT_NO'			, width: 100},
			{dataIndex: 'MAKE_DATE'				, width: 100},
			{dataIndex: 'MAKE_EXP_DATE'			, width: 100},
			{ dataIndex: 'REMARK'				,  width:133},
			{ dataIndex: 'PROJECT_NO'			,  width:120},
			{ dataIndex: 'WH_CODE'				,  width:100,hidden:true},
			//20191029 추가: 수주번호, 수주처, 수주품목명
			{ dataIndex: 'SO_NUM'				,width:100 ,hidden: false},
			{ dataIndex: 'SO_CUSTOM_NAME'		,width:150 ,hidden: false},
			{ dataIndex: 'SO_ITEM_NAME'			,width:200 ,hidden: false}
        ],
        listeners: {
			onGridDblClick:function(grid, record, cellIndex, colName) {
  			}
		},
		returnData: function()	{
       		var records = this.getSelectedRecords();
			Ext.each(records, function(record,i){
	        	UniAppManager.app.onNewDataButtonDown(record.data.ITEM_CODE, record.data.ORDER_TYPE);
	        	masterGrid.setReceiptData(record.data);
		    });
		    //시너지톡 연계 메세지용 거래처 정보 세팅
		    masterForm.setValue('CUSTOM_NAME', directMasterStore1.getAt(0).get('CUSTOM_NAME'));

			this.getStore().remove(records);
       	}
    });

    /**
     * 查询窗口查询
     */
    function openSearchInfoWindow() {			//조회버튼 누르면 나오는 조회창
		if(!SearchInfoWindow) {
			SearchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title  : '<t:message code="system.label.purchase.inspecnoinquiry" default="검사번호검색"/>',
                width  : 1080,
                height : 580,
                layout : {type:'vbox', align:'stretch'},
                items: [receiptNoSearch, receiptNoMasterGrid], //receiptNoDetailGrid],
                tbar:  ['->',
			        {
			        	itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							if(receiptNoSearch.setAllFieldsReadOnly(true)){
								receiptNoMasterStore.loadStoreRecords();
							}
						},
						disabled: false
					}/*,{
			        	itemId : 'confirmBtn',
						text: '확인',
						handler: function() {
							var record = receiptNoMasterGrid.getSelectedRecord();
							if(record){
								receiptNoMasterGrid.returnData(record);
		          	            UniAppManager.app.onQueryButtonDown();
							}
							SearchInfoWindow.hide();

						},
						disabled: false
					}*/, {
						itemId : 'OrderNoCloseBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							SearchInfoWindow.hide();
						},
						disabled: false
					}
	    		],
				listeners : {
					beforehide: function(me, eOpt)	{
						receiptNoSearch.clearForm();
						receiptNoMasterGrid.reset();
						//receiptNoDetailGrid.reset();
					},
	    			beforeclose: function( panel, eOpts )	{
						receiptNoSearch.clearForm();
						receiptNoMasterGrid.reset();
						//receiptNoDetailGrid.reset();
		 			},
	    			show: function( panel, eOpts )	{
	    			 	receiptNoSearch.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
			    		receiptNoSearch.setValue('GOODBAD_TYPE',masterForm.getValue('GOODBAD_TYPE'));
			    		receiptNoSearch.setValue('INSPEC_TYPE',masterForm.getValue('INSPEC_TYPE'));
			    		receiptNoSearch.setValue('INSPEC_DATE_FR', UniDate.get('startOfMonth', masterForm.getValue('INSPEC_DATE')));
			    		receiptNoSearch.setValue('INSPEC_DATE_TO',masterForm.getValue('INSPEC_DATE'));
	    			 }
                }
			})
		}
		SearchInfoWindow.show();
		SearchInfoWindow.center();
    }

    /**
     * 接收参考查询
     */
    function openReceiptWindow() {    		//접수참조
		if(!referReceiptWindow) {
			referReceiptWindow = Ext.create('widget.uniDetailWindow', {
                title  : '<t:message code="system.label.purchase.receiptrefer" default="접수참조"/>',
                width  : 1080,
                height : 580,
                layout:{type:'vbox', align:'stretch'},

                items: [receiptSearch, receiptGrid],
                tbar:  ['->',
			        {
			        	itemId : 'saveBtn',
						text: '<t:message code="system.label.purchase.inquiry" default="조회"/>',
						handler: function() {
							receiptStore.loadStoreRecords();
						},
						disabled: false
					},{
						itemId : 'confirmBtn',
						text: '<t:message code="system.label.purchase.inspecapply" default="검사적용"/>',
						handler: function() {
							receiptGrid.returnData();
						},
						disabled: false
					},{
						itemId : 'confirmCloseBtn',
						text: '<t:message code="system.label.purchase.inspecapplyclose" default="검사적용 후 닫기"/>',
						handler: function() {
							receiptGrid.returnData();
							referReceiptWindow.hide();
						},
						disabled: false
					},{
						itemId : 'closeBtn',
						text: '<t:message code="system.label.purchase.close" default="닫기"/>',
						handler: function() {
							referReceiptWindow.hide();
						},
						disabled: false
					}
		    	],
                listeners : {
                	beforehide: function(me, eOpt)	{
						//receiptSearch.clearForm();
						//receiptGrid,reset();
					},
	    			beforeclose: function( panel, eOpts )	{
						//receiptSearch.clearForm();
						//receiptGrid,reset();
		 			},
	    			beforeshow: function ( me, eOpts )	{
	    				receiptSearch.setValue("DIV_CODE", masterForm.getValue("DIV_CODE"));
	    				receiptStore.loadStoreRecords();
	    			}
                }
			})
		}
		referReceiptWindow.show();
		referReceiptWindow.center();
    }

    /**
     * 主处理
     */
	Unilite.Main({
		borderItems:[{
			region : 'center',
			layout : 'border',
			border : false,
			items  : [
				masterGrid, masterGrid2, panelResult
			]
		},masterForm],
		id : 'mms200ukrvApp',
		fnInitBinding : function() {
			masterForm.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			masterForm.setValue('INSPEC_DATE',UniDate.get("today"));
			panelResult.setValue('INSPEC_DATE',UniDate.get("today"));
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['deleteAll', 'save'], false);
			masterForm.setValue('INSPEC_PRSN',BsaCodeInfo.gsInspecPrsn);
			panelResult.setValue('INSPEC_PRSN',BsaCodeInfo.gsInspecPrsn);
		},
		onQueryButtonDown: function() {
			masterForm.setAllFieldsReadOnly(false);
			/* if(!Ext.isEmpty(panelResult.getValue('INSPEC_NUM'))){
				masterForm.setValue('INSPEC_NUM',panelResult.getValue('INSPEC_NUM'));
			} */
			var inspecNo = masterForm.getValue('INSPEC_NUM');
			if(Ext.isEmpty(inspecNo)) {
				openSearchInfoWindow()
			} else {
//				masterGrid.reset();
//				masterGrid2.reset();
				directMasterStore1.loadStoreRecords();
			};
		},
		onNewDataButtonDown: function(itemCode, orderType)	{
			var inspecNum = masterForm.getValue('INSPEC_NUM');
			var seq = directMasterStore1.max('INSPEC_SEQ');
			if(!seq) seq = 1;
			else  seq += 1;
			var r = {
				INSPEC_SEQ: seq
			};
			
			if(!Ext.isEmpty(itemCode)) {
				r.ITEM_CODE  = itemCode;
			}
			if(!Ext.isEmpty(orderType)) {
				r.ORDER_TYPE = orderType;
			}
			
			masterGrid.createRow(r,'ITEM_CODE',seq-2);
			masterForm.setAllFieldsReadOnly(false);
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			panelResult.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			masterGrid.reset();
			masterGrid2.reset();
			masterGrid.getStore().clearData();
			masterGrid2.getStore().clearData();
			Ext.getCmp('receiveBadWhCode').setValue('');
			Ext.getCmp('receiveGoodWhCode').setValue('');
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			if(directMasterStore1.isDirty()){
				directMasterStore1.saveStore();
			}else if(directMasterStore2.isDirty()){
				directMasterStore2.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();

			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
				return;
			}

			Ext.Msg.confirm('<t:message code="system.label.purchase.delete" default="삭제"/>', '<t:message code="system.message.purchase.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>' ,function(btn){
			    if (btn == 'yes') {
			    	var divCode = masterForm.getValue('DIV_CODE');
					var inspecNum = selRow.get('INSPEC_NUM');
					var inspecSeq = selRow.get('INSPEC_SEQ');
					UniAppManager.app.fnInspecQtyCheck2(selRow, divCode, inspecNum, inspecSeq )

			    	/*  if(selRow.get('INSTOCK_Q') > 1){
				     	alert('입고수량: ' + selRow.get('INSTOCK_Q'));
			        	alert('<t:message code="system.message.purchase.message065" default="입고된 수량이 존재합니다. 삭제 할 수 없습니다."/>');
				    }else{
				    	masterGrid.deleteSelectedRow();
				    } */
			    }
			})
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden()) {
				as.show();
			}else {
				as.hide()
			}
		},
		fnInspecQtyCheck: function(rtnRecord, fieldName, oldValue, divCode, inspecNum, inspecSeq, msgFlag)	{
			var param = {
				'DIV_CODE'   : divCode,
				'INSPEC_NUM' : inspecNum,
				'INSPEC_SEQ' : inspecSeq
		    }
			mms200ukrvService.inspecQtyCheck(param, function(provider, response){
				if(!Ext.isEmpty(provider) && provider.length > 0 )	{
					if(msgFlag == 'inspectList'){
						alert("입고된 수량이 존재합니다. 검사수량을 변경할 수 없습니다.");
						rtnRecord.set(fieldName, oldValue);
					}else{
						alert('<t:message code="system.message.purchase.message065" default="입고된 수량이 존재합니다. 삭제 할 수 없습니다."/>');
						rtnRecord.set(fieldName, oldValue);
					}

				}else{
					UniAppManager.app.fnCheckIsModify();
				}
			})
		},
		fnInspecQtyCheck2: function(rtnRecord, divCode, inspecNum, inspecSeq)	{
			var isErr = true;
			var param = {
				'DIV_CODE'   : divCode,
				'INSPEC_NUM' : inspecNum,
				'INSPEC_SEQ' : inspecSeq
		    }
			mms200ukrvService.inspecQtyCheck(param, function(provider, response){
				if(!Ext.isEmpty(provider) && provider.length > 0 )	{
						alert('<t:message code="system.message.purchase.message065" default="입고된 수량이 존재합니다. 삭제 할 수 없습니다."/>');
						isErr = false;
				}else{
					masterGrid.deleteSelectedRow();
				}
			})
			return isErr;
		},
		fnInspecQtyCheck3: function(rtnRecord, fieldName, oldValue, divCode, inspecNum, inspecSeq, msgFlag)	{
			var param = {
					'DIV_CODE'   : divCode,
					'INSPEC_NUM' : inspecNum,
					'INSPEC_SEQ' : inspecSeq
			    }
				mms200ukrvService.inspecQtyCheck(param, function(provider, response){
						UniAppManager.app.fnCheckIsModify();
				})
		},
		fnCheckIsModify:function(){
			var store1 = Ext.getCmp("mms200ukrvGrid1").getStore();
			var store2 = Ext.getCmp("mms200ukrvGrid2").getStore();
			setTimeout( function() {
				if(store1.isDirty() || store2.isDirty()){
					UniAppManager.setToolbarButtons(['save'], true);
				}else{
					UniAppManager.setToolbarButtons(['save'], false);
				}
			}, 50 );
		}
	});//End of Unilite.Main( {

	/**
     * 主列表1校验
     */
	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {

				case "MAKE_DATE" :
					if(!Ext.isEmpty(record.get('ITEM_CODE'))){
						if(!Ext.isEmpty(newValue)){
							var params = {
								'ITEM_CODE' : record.get('ITEM_CODE')
							};
							mms200ukrvService.selectExpirationdate(params, function(provider, response) {
								if(!Ext.isEmpty(provider) && provider.EXPIRATION_DAY != 0)	{

									record.set('MAKE_EXP_DATE',UniDate.getDbDateStr(UniDate.add(newValue, {months: + provider.EXPIRATION_DAY , days:-1})));
								}else{
									//alert('유효기간을 설정하지 않은 품목입니다. 유효기간을 설정해주세요.');
									record.set('MAKE_EXP_DATE', '');
								}
							});
						}
					}else{
						rv ='작업지시를 할 품목을 입력해주세요.';
						break;
					}

				break;

				case "INSPEC_Q":
					if(newValue == '' || newValue < '1'){
						rv ='<t:message code="system.label.purchase.message064" default="접수량이 1보다 작거나 데이터가 없습니다."/>';
						break;
					}
					if(record.get('RECEIPT_Q') * record.get('TRNS_RATE') < newValue){
						rv ='<t:message code="system.message.purchase.message066" default="검사수량은 잔량보다 적어야 합니다."/>';
						break;
					}
//					if(record.get('INSPEC_Q') < getSumBadQty()){
//						rv ='<t:message code="system.message.purchase.message067" default="불량수량이 검사수량보다 많을 수 없습니다."/>';
//						record.set("INSPEC_Q", oldValue)
//						break;
//					}
					qtyUpdateByType(record)
					if(record.obj.phantom == false){
						var divCode = masterForm.getValue('DIV_CODE');
						var inspecNum = record.get('INSPEC_NUM');
						var inspecSeq = record.get('INSPEC_SEQ');
						UniAppManager.app.fnInspecQtyCheck(record, fieldName, oldValue, divCode, inspecNum, inspecSeq );
						break;
					}
					break;
				case "PROJECT_NO":
				    UniAppManager.app.fnCheckIsModify();
				    break;
				case "INSPEC_TYPE":
					if(record.get('INSPEC_TYPE') == '02'){
						record.set('GOODBAD_TYPE','01');
					}else{
						record.set('GOODBAD_TYPE','');
					}
					qtyUpdateByType(record)
					break;
				case "GOODBAD_TYPE":
					qtyUpdateByType(record)
					break;
				case "LOT_NO":
				    UniAppManager.app.fnCheckIsModify();
				    break;
					//소스 재분석필요
				case "BAD_INSPEC_Q":

					if(record.get('RECEIPT_Q') * record.get('TRNS_RATE') < newValue){
						rv ='불량수량은 잔량보다 작아야합니다.';
						break;
					}
					record.set('GOOD_INSPEC_Q', record.get('RECEIPT_Q') * record.get('TRNS_RATE') - newValue);

					/* if(record.obj.phantom == false){
						var divCode = masterForm.getValue('DIV_CODE');
						var inspecNum = record.get('INSPEC_NUM');
						var inspecSeq = record.get('INSPEC_SEQ');
						UniAppManager.app.fnInspecQtyCheck(record, fieldName, oldValue, divCode, inspecNum, inspecSeq );
						break;
					} */
					break;
				case "GOOD_INSPEC_Q":
					if(newValue == '' || newValue < '1'){
						rv ='합격수량이 1보다 작거나 데이터가 없습니다.';
						break;
					}
					if(record.get('RECEIPT_Q') * record.get('TRNS_RATE') < newValue){
						rv ='합격수량은 잔량보다 적어야 합니다';
						break;
					}

				break;
			}
				return rv;
			}
	});

	function qtyUpdateByType(record){
		if(record.get('INSPEC_TYPE') == '01' || record.get('INSPEC_TYPE') == ''){
	    	record.set('GOOD_INSPEC_Q', record.get('RECEIPT_Q') * record.get('TRNS_RATE')  - record.get('BAD_INSPEC_Q'));
	    }else if(record.get('INSPEC_TYPE') == '02'){
	    	if(record.get('GOODBAD_TYPE') == '01'){
	    		if(record.obj.phantom){
	    			record.set('GOOD_INSPEC_Q', record.get('RECEIPT_Q') * record.get('TRNS_RATE'));
	    			record.set('BAD_INSPEC_Q','0');
	    		}else{
	    			//record.set('GOOD_INSPEC_Q', record.get('RECEIPT_Q') * record.get('TRNS_RATE') - getSumBadQty());	//SumBadQty -> 불량수량합 구하는 함수 생성해야함
	    			//record.set('BAD_INSPEC_Q',getSumBadQty());
	    			record.set('GOOD_INSPEC_Q', record.get('RECEIPT_Q') * record.get('TRNS_RATE'));
	    			record.set('BAD_INSPEC_Q','0');
	    		}
	    	}else if(record.get('GOODBAD_TYPE') == '02'){
	    		record.set('GOOD_INSPEC_Q','0');
	    		record.set('BAD_INSPEC_Q',record.get('RECEIPT_Q') * record.get('TRNS_RATE') );
	    	}else if(record.get('GOODBAD_TYPE') == '03'){
	    		//record.set('GOOD_INSPEC_Q','0');
	    		//record.set('BAD_INSPEC_Q','0');
	    	}
	    }
	    UniAppManager.app.fnCheckIsModify();
	}

	/**
     * 主列表2校验
     */
	Unilite.createValidator('validator02', {
		store: directMasterStore2,
		grid: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
		    if(newValue == oldValue){
		    	return true;
		    }
			var rv = true;
			switch(fieldName) {
				case "BAD_INSPEC_Q":
					if(newValue < 0){
						rv ='<t:message code="system.message.purchase.message068" default="0보다 큰 값이 입력되어야 합니다."/>';

						record.set("BAD_INSPEC_Q", oldValue)
						break;
					}
					if(newValue == 0){

						record.set("BAD_INSPEC_Q", newValue);

					}

/*
20190228 불량수량을 검사수량으로 대체. 상단 마스터그리드의 불량수량연계 끊기로 함.
					if(grdRecord.get('INSPEC_Q') < getSumBadQty()){
						rv ='<t:message code="system.message.purchase.message067" default="불량수량이 검사수량보다 많을 수 없습니다."/>';
						record.set("BAD_INSPEC_Q", oldValue)
						break;
					}
*/

         /*상단 그리드와 연계를 끊도록 함으로 입고량 체크 로직 주석처리*/
	 	/*  		if(record.obj.phantom == false){
						var divCode = masterForm.getValue('DIV_CODE');

					    var inspecNum = grdRecord.get('INSPEC_NUM');
					    var inspecSeq = grdRecord.get('INSPEC_SEQ');
					    UniAppManager.app.fnInspecQtyCheck(record, fieldName, oldValue, divCode, inspecNum, inspecSeq, "inspectList");
					    break;
					} */
					/*디테일 값 변경시 저장버튼 활성화를 위한 로직, 함수 실행하고 그 안에서 dirty체크 해야함 안 그러면 두번째 수정시에만 저장 버튼 활성화됨*/
					var grdRecord = Ext.getCmp("mms200ukrvGrid1").getSelectedRecord();
					var divCode = masterForm.getValue('DIV_CODE');
				    var inspecNum = grdRecord.get('INSPEC_NUM');
				    var inspecSeq = grdRecord.get('INSPEC_SEQ');
					UniAppManager.app.fnInspecQtyCheck3(record, fieldName, oldValue, divCode, inspecNum, inspecSeq, "inspectList");
					break;

			     case "INSPEC_REMARK":
			         var store = Ext.getCmp("mms200ukrvGrid2").getStore();
			         UniAppManager.app.fnCheckIsModify();
			         break;
			     case "MANAGE_REMARK":
			         UniAppManager.app.fnCheckIsModify();
			         break;
				case "SEQ":
					var recordAll = directMasterStore2.data.items;
					Ext.each(recordAll, function(rec,idx) {
						if(newValue != 0){
							if(newValue == rec.get('SEQ')){
								rv ='우선순위 값이 중복됩니다.';
							}
						}
					});
				    UniAppManager.app.fnCheckIsModify();
				    break;
			}
			return rv;
		}
	});

	/**
	 * 불량수량의 합을 구한다.
	 * 获取不良数合计
	 */
	function getSumBadQty(){
		var store = Ext.getCmp("mms200ukrvGrid2").getStore();
		var sumBadQty = 0;
		if(store){
			var items = store.data.items;
			for(i = 0; i <items.length; i++ ){
				sumBadQty += items[i].get("BAD_INSPEC_Q");
			}
		}
		return sumBadQty;
	}

	function getLotPopupEditor(gsManageLotNoYN){

    	var editField;
    	if(gsManageLotNoYN == "Y"){

    		    	 editField = Unilite.popup('LOTNO_G',{
			        	             textFieldName: 'LOT_NO',
		 							 DBtextFieldName: 'LOT_NO',
		                    	   	 autoPopup: true,
			        	             listeners: {
						             	'onSelected': {
						             		fn: function(record, type) {
						             			var selectRec = masterGrid.getSelectedRecord()
						             			if(selectRec){
						             				selectRec.set('LOT_NO', record[0]["LOT_NO"]);
						             				selectRec.set('GOOD_STOCK_Q', record[0]["GOOD_STOCK_Q"]);
						             				selectRec.set('BAD_STOCK_Q', record[0]["BAD_STOCK_Q"]);
						             			}
		                                 	},
						             		scope: this
						             	},
						             	'onClear': {
						             		fn: function(record, type) {
						             			var selectRec = masterGrid.getSelectedRecord()
						             			if(selectRec){
						             				selectRec.set('LOT_NO', '');
						             				selectRec.set('GOOD_STOCK_Q', 0);
						             				selectRec.set('BAD_STOCK_Q', 0);
//						             				UniAppManager.app.checkStockPrice(selectRec.data);
						             			}
		                                 	},
						             		scope: this
						             	},
						             	applyextparam: function(popup){
						             		var selectRec = masterGrid.getSelectedRecord();
						             		if(selectRec){
						             			popup.setExtParam({'DIV_CODE':  selectRec.get('DIV_CODE')});
						             		    popup.setExtParam({'ITEM_CODE': selectRec.get('ITEM_CODE')});
						             		    popup.setExtParam({'ITEM_NAME': selectRec.get('ITEM_NAME')});
						             		    popup.setExtParam({'FR_INOUT_DATE': UniDate.get("startOfMonth", masterForm.getValue("INSPEC_DATE"))});
						             		    popup.setExtParam({'FR_INOUT_DATE': masterForm.getValue("INSPEC_DATE")});
						             		    popup.setExtParam({'stockYN': 'Y'});
						             		}
						             	}
						             }
			                    });
    	}else if(gsManageLotNoYN == "N"){
    		editField = {xtype : 'textfield', maxLength:20}
    	}

	    var editor = Ext.create('Ext.grid.CellEditor', {
        	ptype: 'cellediting',
			clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수
			autoCancel : false,
			selectOnFocus:true,
            field: editField
        });

	    return editor;
    }

    function getPjtNoPopupEditor(){
    	var editField = Unilite.popup('PROJECT_G',{
		 	DBtextFieldName: 'PROJECT_NO',
		 	textFieldName:'PROJECT_NO',
		    autoPopup: true,
		 	listeners: {
		 		'applyextparam': function(popup){
		 			var masterGrid = Ext.getCmp("mms200ukrvGrid1");
		 			var selectRec = masterGrid.getSelectedRecord();
		 			if(selectRec){
		 				popup.setExtParam({'BPARAM0': 3});
		 			    popup.setExtParam({'CUSTOM_CODE': selectRec.get("CUSTOM_CODE")});
		 			    popup.setExtParam({'CUSTOM_NAME': selectRec.get("CUSTOM_NAME")});
		 			}
		 		},
		 		'onSelected': {
		 			fn: function(records, type) {
		            },
		 			scope: this
		 		},
		 		'onClear': function(type){
		 			scope: this
		 		}
		 	}
		})

		var editor = Ext.create('Ext.grid.CellEditor', {
        	ptype: 'cellediting',
			clicksToEdit: 1, // 1 or 2 , 수정 모드로 들어가기 위한 Click 횟수
			autoCancel : false,
			selectOnFocus:true,
            field: editField
        });

        return editor;
    }

	function setAllFieldsReadOnly(b){
		var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				if(invalid.length > 0) {
					r=false;
					var labelText = ''

					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
						var labelText = invalid.items[0]['fieldLabel']+':';
					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
   					}
				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				}else{
					var fields = this.getForm().getFields();
				    Ext.each(fields.items, function(item) {
				    	if(Ext.isDefined(item.holdable) )	{
				    	 	if (item.holdable == 'hold') {
				    			item.setReadOnly(true);
				    		}
				    	}
				    	if(item.isPopupField)	{
				    		var popupFC = item.up('uniPopupField')	;
				    		if(popupFC.holdable == 'hold') {
				    			popupFC.setReadOnly(true);
				    		}
				    	}
				    });
				}
	  		} else {
				this.unmask();
			}
			return r;
	}
};
</script>
