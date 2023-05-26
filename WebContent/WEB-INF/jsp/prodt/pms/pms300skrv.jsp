<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pms300skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="W" />					<!-- 작업장  -->
	<t:ExtComboStore comboType="AU" comboCode="B001" />	<!-- 발주형태 콤보 -->
	<t:ExtComboStore comboType="AU" comboCode="B020" />	<!-- 품목계정  -->
	<t:ExtComboStore comboType="AU" comboCode="M201" />	<!-- 구매담당 콤보 -->
	<t:ExtComboStore comboType="AU" comboCode="M002" />	<!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="M007" />	<!-- 승인여부 -->
	<t:ExtComboStore comboType="AU" comboCode="Q031" />	<!-- 접수구분 -->
	<t:ExtComboStore comboType="AU" comboCode="Q023" />	<!-- 접수자 -->
	<t:ExtComboStore comboType="AU" comboCode="Q024" />	<!-- 검사자 -->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var activeTabId			= '';
	var gsReportSettingYn	= '${gsReportSettingYn}'		//20210910 추가 - 프린트 버튼 setting 로직 추가

	/**
	 * Model 정의
	 *
	 * @type
		 */
	Unilite.defineModel('Pms300skrvModel1', {
		fields: [
	    	{name: 'DIV_CODE'      	,text: '<t:message code="system.label.product.division" default="사업장"/>'	    ,type : 'string', comboType:'BOR120', defaultValue:UserInfo.divCode},
		    {name: 'WORK_SHOP_CODE'	,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'	 ,type: 'string'},
		    {name: 'TREE_NAME'     	,text: '<t:message code="system.label.product.workcentername" default="작업장명"/>'	 ,type: 'string'},
		    {name: 'PRODT_DATE'    	,text: '<t:message code="system.label.product.productiondate" default="생산일"/>'	     ,type: 'uniDate'},
		    {name: 'ITEM_CODE'     	,text: '<t:message code="system.label.product.item" default="품목"/>'	 ,type: 'string'},
		    {name: 'ITEM_NAME'     	,text: '<t:message code="system.label.product.itemname" default="품목명"/>'	     ,type: 'string'},
		    {name: 'SPEC'          	,text: '<t:message code="system.label.product.spec" default="규격"/>'		 ,type: 'string'},
		    {name: 'PRODT_Q'       	,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'	 ,type: 'uniQty'},
		    {name: 'GOOD_PRODT_Q'	,text: '<t:message code="system.label.product.gooditemqty" default="양품량"/>'			,type:'uniQty', allowBlank:false},
		    {name: 'RECEIPT_DATE'  	,text: '<t:message code="system.label.product.receiptdate" default="접수일"/>'	     ,type: 'uniDate'},
		    {name: 'RECEIPT_PRSN'  	,text: '<t:message code="system.label.product.receptionist" default="접수자"/>'	     ,type: 'string', comboType:'AU' , comboCode:'Q023'},
		    {name: 'RECEIPT_Q'      ,text: '<t:message code="system.label.product.receiptqty2" default="접수량"/>'	     ,type: 'uniQty'},
		    {name: 'NOTRECEIPT_Q'  	,text: '<t:message code="system.label.product.notreceiveqty" default="미접수량"/>'	 ,type: 'uniQty'},
		    {name: 'PRODT_NUM'     	,text: '<t:message code="system.label.product.productionno" default="생산번호"/>'	 ,type: 'string'},
		    {name: 'RECEIPT_NUM'   	,text: '<t:message code="system.label.product.receiptno" default="접수번호"/>'	 ,type: 'string'},
		    {name: 'RECEIPT_SEQ'   	,text: '<t:message code="system.label.product.receiptseq" default="접수순번"/>'	 ,type: 'string'},
		    {name: 'LOT_NO'        	,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'	     ,type: 'string'},
		    {name: 'RECEIPT_REMARK'	,text: '<t:message code="system.label.product.receiptremark" default="접수비고"/>'	 ,type: 'string'}
		]
	});

	Unilite.defineModel('Pms300skrvModel2', {
		fields: [
	    	{name: 'DIV_CODE'      	,text: '<t:message code="system.label.product.division" default="사업장"/>'	    ,type : 'string', comboType:'BOR120', defaultValue:UserInfo.divCode},
		    {name: 'WORK_SHOP_CODE'	,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'	 ,type: 'string'},
		    {name: 'TREE_NAME'     	,text: '<t:message code="system.label.product.workcentername" default="작업장명"/>'	 ,type: 'string'},
		    {name: 'PRODT_DATE'    	,text: '<t:message code="system.label.product.productiondate" default="생산일"/>'	     ,type: 'uniDate'},
		    {name: 'ITEM_CODE'     	,text: '<t:message code="system.label.product.item" default="품목"/>'	 ,type: 'string'},
		    {name: 'ITEM_NAME'     	,text: '<t:message code="system.label.product.itemname" default="품목명"/>'	     ,type: 'string'},
		    {name: 'SPEC'          	,text: '<t:message code="system.label.product.spec" default="규격"/>'		 ,type: 'string'},
		    {name: 'PRODT_Q'       	,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'	 ,type: 'uniQty'},
		    {name: 'GOOD_PRODT_Q'	,text: '<t:message code="system.label.product.gooditemqty" default="양품량"/>'			,type:'uniQty', allowBlank:false},
		    {name: 'RECEIPT_DATE'  	,text: '<t:message code="system.label.product.receiptdate" default="접수일"/>'	     ,type: 'uniDate'},
		    {name: 'RECEIPT_PRSN'  	,text: '<t:message code="system.label.product.receptionist" default="접수자"/>'	     ,type: 'string', comboType:'AU' , comboCode:'Q023'},
		    {name: 'RECEIPT_Q'      ,text: '<t:message code="system.label.product.receiptqty2" default="접수량"/>'	     ,type: 'uniQty'},
		    {name: 'INSPEC_PRSN'    ,text: '<t:message code="system.label.product.inspector" default="검사자"/>'      ,type: 'string' , comboType:'AU' , comboCode:'Q024'},
		    {name: 'INSPEC_Q'         , text: '<t:message code="system.label.product.inspecqty" default="검사량"/>'  ,type: 'uniQty'},
		    {name: 'GOOD_INSPEC_Q'  ,text: '<t:message code="system.label.product.gooditemqty" default="양품량"/>'      ,type: 'uniQty'},
		    {name: 'BAD_INSPEC_Q'   ,text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'      ,type: 'uniQty'},
		    {name: 'NOTINSPEC_Q'    ,text: '<t:message code="system.label.product.noinspecqty" default="미검사량"/>'  ,type: 'uniQty'},
		    {name: 'NOTRECEIPT_Q'  	,text: '<t:message code="system.label.product.notreceiveqty" default="미접수량"/>'	 ,type: 'uniQty'},
		    {name: 'PRODT_NUM'     	,text: '<t:message code="system.label.product.productionno" default="생산번호"/>'	 ,type: 'string'},
		    {name: 'RECEIPT_NUM'   	,text: '<t:message code="system.label.product.receiptno" default="접수번호"/>'	 ,type: 'string'},
		    {name: 'RECEIPT_SEQ'   	,text: '<t:message code="system.label.product.receiptseq" default="접수순번"/>'	 ,type: 'string'},
		    {name: 'INSPEC_NUM'     , text: '<t:message code="system.label.product.inspecno" default="검사번호"/>'  , type: 'string'},
		    {name: 'INSPEC_SEQ'       ,text: '<t:message code="system.label.product.inspecseq" default="검사순번"/>'   ,type: 'string'},
		    {name: 'LOT_NO'        	,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'	     ,type: 'string'},
		    {name: 'RECEIPT_REMARK'	,text: '<t:message code="system.label.product.receiptremark" default="접수비고"/>'	 ,type: 'string'},
		    {name: 'INSPEC_REMARK'  ,text: '<t:message code="system.label.product.inspecremark" default="검사비고"/>'  ,type: 'string'}
		]
	});

	Unilite.defineModel('Pms300skrvModel3', {
		fields: [
	    	{name: 'DIV_CODE'      	,text: '<t:message code="system.label.product.division" default="사업장"/>'	     ,type : 'string', comboType:'BOR120', defaultValue:UserInfo.divCode},
		    {name: 'WORK_SHOP_CODE'	,text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'	 ,type: 'string'},
		    {name: 'TREE_NAME'     	,text: '<t:message code="system.label.product.workcentername" default="작업장명"/>'	 ,type: 'string'},
		    {name: 'PRODT_DATE'    	,text: '<t:message code="system.label.product.productiondate" default="생산일"/>'	     ,type: 'uniDate'},
		    {name: 'ITEM_CODE'     	,text: '<t:message code="system.label.product.item" default="품목"/>'	 ,type: 'string'},
		    {name: 'ITEM_NAME'     	,text: '<t:message code="system.label.product.itemname" default="품목명"/>'	     ,type: 'string'},
		    {name: 'SPEC'          	,text: '<t:message code="system.label.product.spec" default="규격"/>'		 ,type: 'string'},
		    {name: 'PRODT_Q'       	,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'	 ,type: 'uniQty'},
		    {name: 'GOOD_PRODT_Q'	,text: '<t:message code="system.label.product.gooditemqty" default="양품량"/>'			,type:'uniQty', allowBlank:false},
		    {name: 'RECEIPT_DATE'  	,text: '<t:message code="system.label.product.receiptdate" default="접수일"/>'	     ,type: 'uniDate'},
		    {name: 'RECEIPT_PRSN'  	,text: '<t:message code="system.label.product.receptionist" default="접수자"/>'	     ,type: 'string', comboType:'AU' , comboCode:'Q023'},
		    {name: 'RECEIPT_Q'      ,text: '<t:message code="system.label.product.receiptqty2" default="접수량"/>'	     ,type: 'uniQty'},
		    {name: 'INSPEC_PRSN'    ,text: '<t:message code="system.label.product.inspector" default="검사자"/>'      ,type: 'string'  , comboType:'AU' , comboCode:'Q024'},
		    {name: 'INSPEC_Q'         , text: '<t:message code="system.label.product.inspecqty" default="검사량"/>'  ,type: 'uniQty'},
		    {name: 'GOOD_INSPEC_Q'  ,text: '<t:message code="system.label.product.gooditemqty" default="양품량"/>'      ,type: 'uniQty'},
		    {name: 'BAD_INSPEC_Q'   ,text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'      ,type: 'uniQty'},
		    {name: 'NOTINSPEC_Q'    ,text: '<t:message code="system.label.product.noinspecqty" default="미검사량"/>'  ,type: 'uniQty'},
		    {name: 'TOT_BAD_INSPEC_Q'  ,text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'    ,type: 'uniQty'},
		    {name: 'BAD_INSPEC_NAME'  ,text: '<t:message code="system.label.product.inspectsubject" default="검사항목"/>'   ,type: 'string'},
		    {name: 'BAD_INSPEC_Q'   ,text: '<t:message code="system.label.product.defectinspecqty" default="불량검사수량"/>'      ,type: 'uniQty'},
		    {name: 'PRODT_NUM'     	,text: '<t:message code="system.label.product.productionno" default="생산번호"/>'	 ,type: 'string'},
		    {name: 'RECEIPT_NUM'   	,text: '<t:message code="system.label.product.receiptno" default="접수번호"/>'	 ,type: 'string'},
		    {name: 'RECEIPT_SEQ'   	,text: '<t:message code="system.label.product.receiptseq" default="접수순번"/>'	 ,type: 'string'},
		    {name: 'INSPEC_NUM'     , text: '<t:message code="system.label.product.inspecno" default="검사번호"/>'  , type: 'string'},
		    {name: 'INSPEC_SEQ'       ,text: '<t:message code="system.label.product.inspecseq" default="검사순번"/>'   ,type: 'string'},
		    {name: 'LOT_NO'        	,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'	     ,type: 'string'},
		    {name: 'RECEIPT_REMARK'	,text: '<t:message code="system.label.product.receiptremark" default="접수비고"/>'	 ,type: 'string'},
		    {name: 'INSPEC_REMARK'  ,text: '<t:message code="system.label.product.inspecremark" default="검사비고"/>'  ,type: 'string'}
		]
	});

	// GroupField string type으로 변환
/* 	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  } */

	/**
	 * Store 정의(Service 정의)
	 *
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('pms300skrvMasterStore1',{
		model: 'Pms300skrvModel1',
		uniOpt : {
            isMaster: true,		// 상위 버튼 연결
            editable: false,		// 수정 모드 사용
            deletable: false,		// 삭제 가능 여부
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
        	type: 'direct',
        	api: {
                read: 'pms300skrvService.selectList1'
            }
        },
        loadStoreRecords: function() {
        	panelSearch.setValue('ITEM_CODE',panelResult.getValue('ITEM_CODE'));
        	panelSearch.setValue('ITEM_NAME',panelResult.getValue('ITEM_NAME'));

			var param = Ext.getCmp('searchForm').getValues();
			param.RECEIPT_DATE_FR = UniDate.getDateStr(panelResult1.getValue('RECEIPT_DATE_FR'));
			param.RECEIPT_DATE_TO = UniDate.getDateStr(panelResult1.getValue('RECEIPT_DATE_TO'));
			param.TOT_RECEIPT_Q = panelResult1.getValue('TOT_RECEIPT_Q');
			panelResult.setValue('PRODT_NUMS','');
			panelResult.setValue('ITEM_CODES','');
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'ITEM_NAME'
	});

	var directMasterStore2 = Unilite.createStore('pms300skrvMasterStore2',{
		model: 'Pms300skrvModel2',
		uniOpt : {
            isMaster: true,		// 상위 버튼 연결
            editable: false,		// 수정 모드 사용
            deletable: false,		// 삭제 가능 여부
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
        	type: 'direct',
        	api: {
                read: 'pms300skrvService.selectList2'
            }
        },
        loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			param.RECEIPT_DATE_FR = UniDate.getDateStr(panelResult2.getValue('RECEIPT_DATE_FR'));
			param.RECEIPT_DATE_TO = UniDate.getDateStr(panelResult2.getValue('RECEIPT_DATE_TO'));
			param.INSPEC_DATE_FR = UniDate.getDateStr(panelResult2.getValue('INSPEC_DATE_FR'));
			param.INSPEC_DATE_TO = UniDate.getDateStr(panelResult2.getValue('INSPEC_DATE_TO'));
			param.TOT_RECEIPT_Q = panelResult2.getValue('TOT_RECEIPT_Q');
			panelResult.setValue('PRODT_NUMS','');
			panelResult.setValue('ITEM_CODES','');
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'ITEM_NAME'
	});

	var directMasterStore3 = Unilite.createStore('pms300skrvMasterStore3',{
		model: 'Pms300skrvModel3',
		uniOpt : {
            isMaster: true,		// 상위 버튼 연결
            editable: false,		// 수정 모드 사용
            deletable: false,		// 삭제 가능 여부
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
        	type: 'direct',
        	api: {
                read: 'pms300skrvService.selectList3'
            }
        },
        loadStoreRecords: function() {
			var param = Ext.getCmp('searchForm').getValues();
			param.RECEIPT_DATE_FR = UniDate.getDateStr(panelResult3.getValue('RECEIPT_DATE_FR'));
			param.RECEIPT_DATE_TO = UniDate.getDateStr(panelResult3.getValue('RECEIPT_DATE_TO'));
			param.INSPEC_DATE_FR = UniDate.getDateStr(panelResult3.getValue('INSPEC_DATE_FR'));
			param.INSPEC_DATE_TO = UniDate.getDateStr(panelResult3.getValue('INSPEC_DATE_TO'));
			panelResult.setValue('PRODT_NUMS','');
			panelResult.setValue('ITEM_CODES','');
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'ITEM_NAME'
	});

	/**
	 * 검색조건 (Search Panel)
	 *
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        listeners: {
	        collapse: function () {
	            panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
        },
		items: [{
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
	    		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
	    		name: 'DIV_CODE',
	    		xtype: 'uniCombobox',
	    		comboType: 'BOR120' ,
	    		width:285,
	    		allowBlank:false,
	    		value : UserInfo.divCode,
	    		listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('DIV_CODE', newValue);
							panelSearch.setValue('WORK_SHOP_CODE','');
						}
					}
		    },
		    	Unilite.popup('ITEM',{
		    		fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
		    		valueFieldName:'ITEM_CODE',
		    		textFieldName:'ITEM_NAME',
		    		textFieldWidth:100,
		    		validateBlank: false,
	        		listeners: {
						onValueFieldChange: function( elm, newValue, oldValue ) {
							panelResult.setValue('ITEM_CODE', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_NAME', '');
								panelSearch.setValue('ITEM_NAME', '');
							}
						},
						onTextFieldChange: function( elm, newValue, oldValue ) {
							panelResult.setValue('ITEM_NAME', newValue);
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('ITEM_CODE', '');
								panelSearch.setValue('ITEM_CODE', '');
							}
						}
					}
		   	}),{
				name		: 'ITEM_ACCOUNT',
				fieldLabel	: '<t:message code="system.label.product.itemaccount" default="품목계정"/>',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B020',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			},{
		    	fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
		    	name:'WORK_SHOP_CODE',
		    	xtype: 'uniCombobox',
		    	width:285,
		    	comboType:'W',
		    	listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('WORK_SHOP_CODE', newValue);
						},
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        var prStore = panelResult.getField('WORK_SHOP_CODE').store;
                        store.clearFilter();
                        prStore.clearFilter();
                        if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            });
                            prStore.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            });
                        }else{
                            store.filterBy(function(record){
                                return false;
                            });
                            prStore.filterBy(function(record){
                                return false;
                            });
                        }
                    }
					}
		    },{
		    	fieldLabel: '<t:message code="system.label.product.productiondate" default="생산일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_DATE_FR',
	        	endFieldName:'PRODT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('PRODT_DATE_FR',newValue);
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('PRODT_DATE_TO',newValue);
				    	}
				    }
			}]
		}]
    });

    var panelResult = Unilite.createSimpleForm('pms300skrvpanelResult', {
		region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
	    		fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
	    		name: 'DIV_CODE',
	    		xtype: 'uniCombobox',
	    		comboType: 'BOR120' ,
	    		allowBlank:false,
	    		value : UserInfo.divCode,
	    		listeners: {
				change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
						panelResult.setValue('WORK_SHOP_CODE','');
					}
				}
		    },
	    	Unilite.popup('ITEM',{
	    		fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
	    		valueFieldName:'ITEM_CODE',
	    		textFieldName:'ITEM_NAME',
	    		validateBlank: false,
	    		listeners: {
					onValueFieldChange: function( elm, newValue, oldValue ) {
						panelSearch.setValue('ITEM_CODE', newValue);
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('ITEM_NAME', '');
							panelSearch.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function( elm, newValue, oldValue ) {
						panelSearch.setValue('ITEM_NAME', newValue);
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('ITEM_CODE', '');
							panelSearch.setValue('ITEM_CODE', '');
						}
					}
				}
		   	}),{
				name		: 'ITEM_ACCOUNT',
				fieldLabel	: '<t:message code="system.label.product.itemaccount" default="품목계정"/>',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'B020',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('ITEM_ACCOUNT', newValue);
					}
				}
			} ,{
				text:'<div style="color: red"><t:message code="system.label.product.inspecgradereportprint" default="검사의뢰서출력"/></div>',
	            xtype: 'button',
	            margin: '0 0 0 15',
	            itemId	: 'inspecgradereportprint',					//20210910 추가 - 프린트 버튼 setting 로직 추가
	            handler: function(){
	            	if(!panelResult.getInvalidMessage()) return;   //필수체크
	            	 var selectedRecords ;
	            	activeTabId = tab.getActiveTab().getId();
	    			if(activeTabId == 'set210ukrvGridTab1'){
	    				selectedRecords = masterGrid1.getSelectedRecords();
	    			}
	    			if(activeTabId == 'set210ukrvGridTab2'){
	    				selectedRecords = masterGrid2.getSelectedRecords();
	    			}
	    			if(activeTabId == 'set210ukrvGridTab3'){
	    				selectedRecords = masterGrid3.getSelectedRecords();
	    			}

	              if(Ext.isEmpty(selectedRecords)){
	                  alert('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
	                  return;
	              }


	              var param = panelResult.getValues();

	              param["dataCount"] = selectedRecords.length;
	              param["sTxtValue2_fileTitle"]='검사결과서';
	              param["PGM_ID"]='pms300skrv';
	              param["MAIN_CODE"]='P010';
	              param.RECEIPT_DATE_FR = UniDate.getDateStr(panelResult1.getValue('RECEIPT_DATE_FR'));
	  			  param.RECEIPT_DATE_TO = UniDate.getDateStr(panelResult1.getValue('RECEIPT_DATE_TO'));
	              if(activeTabId == 'set210ukrvGridTab1'){
		            	param["SEL_TAB"] = '01';
	    			}else if(activeTabId == 'set210ukrvGridTab2'){
	    				param["SEL_TAB"] = '02';
	    			}else{
	    				param["SEL_TAB"] = '03';
	    		 }
	              var win = '';
	 				 	win = Ext.create('widget.ClipReport', {
	 		                url: CPATH+'/prodt/pms300clrkrv.do',
	 		                prgID: 'pms300skrv',
	 		                extParam: param
	 		            });
	 					win.center();
	 					win.show();
	            }
	       }, {
	           text:'<div style="color: red">라벨출력</div>',
	           xtype: 'button',
	           margin: '0 0 0 20',
	           itemId	: 'labelreportprint',					//20210910 추가 - 프린트 버튼 setting 로직 추가
	           handler: function(){
	           		UniAppManager.app.onPrintButtonDown();
	           }

	      },{	//20210910 추가 - 프린트 버튼 setting 로직 추가
	      	xtype	: 'component',
	      	itemId	: 'EmptyPrintButton',
	      	width	: 100,
	      	colspan	: 2
	      },{
                fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
                name:'WORK_SHOP_CODE',
                xtype: 'uniCombobox',
                comboType:'W',
                listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    	panelSearch.setValue('WORK_SHOP_CODE', newValue);
                    },
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        var prStore = panelSearch.getField('WORK_SHOP_CODE').store;
                        store.clearFilter();
                        prStore.clearFilter();
                        if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == panelResult.getValue('DIV_CODE');
                            });
                            prStore.filterBy(function(record){
                                return record.get('option') == panelResult.getValue('DIV_CODE');
                            });
                        }else{
                            store.filterBy(function(record){
                                return false;
                            });
                            prStore.filterBy(function(record){
                                return false;
                            });
                        }
                    }
                }
            },{
            	fieldLabel: '<t:message code="system.label.product.productiondate" default="생산일"/>',
                xtype: 'uniDateRangefield',
                startFieldName: 'PRODT_DATE_FR',
                endFieldName:'PRODT_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('PRODT_DATE_FR',newValue);
                        //panelSearch.getField('ISSUE_REQ_DATE_FR').validate();

                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('PRODT_DATE_TO',newValue);
                        //panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
                    }
                }
            },{
    			fieldLabel: 'PRODT_NUMS',
    			xtype: 'uniTextfield',
    			name: 'PRODT_NUMS',
    			hidden: true
    		},{
    			fieldLabel: 'ITEM_CODES',
    			xtype: 'uniTextfield',
    			name: 'ITEM_CODES',
    			hidden: true
    		}]
    });

    var panelResult1 = Unilite.createSimpleForm('pms300skrvpanelResult1', {
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [
			{
				fieldLabel: '<t:message code="system.label.product.receiptdate" default="접수일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'RECEIPT_DATE_FR',
	        	endFieldName:'RECEIPT_DATE_TO',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
			},{
				fieldLabel: '<t:message code="system.label.product.inquiryclass" default="조회구분"/>',
				name:'TOT_RECEIPT_Q',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'Q031',
				value: 'N'
		  }]
    });

    var panelResult2 = Unilite.createSimpleForm('pms300skrvpanelResult2', {
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [
			{
				fieldLabel: '<t:message code="system.label.product.receiptdate" default="접수일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'RECEIPT_DATE_FR',
	        	endFieldName:'RECEIPT_DATE_TO',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
			},{
			    fieldLabel: '<t:message code="system.label.product.inspecdate" default="검사일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INSPEC_DATE_FR',
	        	endFieldName:'INSPEC_DATE_TO',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
			},{
				fieldLabel: '<t:message code="system.label.product.inquiryclass" default="조회구분"/>',
				name:'TOT_RECEIPT_Q',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'Q032',
				value: 'N'
		  }]
    });
    var panelResult3 = Unilite.createSimpleForm('pms300skrvpanelResult3', {
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [
			{
				fieldLabel: '<t:message code="system.label.product.receiptdate" default="접수일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'RECEIPT_DATE_FR',
	        	endFieldName:'RECEIPT_DATE_TO',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
			},{
			    fieldLabel: '<t:message code="system.label.product.inspecdate" default="검사일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INSPEC_DATE_FR',
	        	endFieldName:'INSPEC_DATE_TO',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today')
			}]
    });
    /**
	 * Master Grid1 정의(Grid Panel)
	 *
	 * @type
	 */

    var masterGrid1 = Unilite.createGrid('pms300skrvGrid1', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore1,
        selModel: 'rowmodel',
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			 onLoadSelectFirst : false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
    	features: [
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: true}
    	],selModel : Ext.create("Ext.selection.CheckboxModel", {
        	singleSelect : true ,
        	checkOnly : false,showHeaderCheckbox :true,
        	listeners: {
        		select: function(grid, selectRecord, index, rowIndex, eOpts ){
        			if(Ext.isEmpty(panelResult.getValue('PRODT_NUMS'))) {
						panelResult.setValue('PRODT_NUMS', selectRecord.get('PRODT_NUM'));
					} else {
						var prodtNums = panelResult.getValue('PRODT_NUMS');
						prodtNums = prodtNums + ',' + selectRecord.get('PRODT_NUM');
						panelResult.setValue('PRODT_NUMS', prodtNums);
					}
        			if(Ext.isEmpty(panelResult.getValue('ITEM_CODES'))) {
						panelResult.setValue('ITEM_CODES', selectRecord.get('ITEM_CODE'));
					} else {
						var itemCodes = panelResult.getValue('ITEM_CODES');
						itemCodes = itemCodes + ',' + selectRecord.get('ITEM_CODE') ;
						panelResult.setValue('ITEM_CODES', itemCodes);
					}
        		},
				deselect:  function(grid, selectRecord, index, eOpts ){
					var prodtNums	 = panelResult.getValue('PRODT_NUMS');
					var deselectedNum0  = selectRecord.get('PRODT_NUM') + ',';
					var deselectedNum1  = ',' + selectRecord.get('PRODT_NUM');
					var deselectedNum2  = selectRecord.get('PRODT_NUM');

					prodtNums = prodtNums.split(deselectedNum0).join("");
					prodtNums = prodtNums.split(deselectedNum1).join("");
					prodtNums = prodtNums.split(deselectedNum2).join("");

					var itemCodes	 = panelResult.getValue('ITEM_CODES');
					var deselectedNum00  = selectRecord.get('ITEM_CODE') + ',';
					var deselectedNum11  = ',' + selectRecord.get('ITEM_CODE') ;
					var deselectedNum22  = selectRecord.get('ITEM_CODE') ;

					itemCodes = itemCodes.split(deselectedNum00).join("");
					itemCodes = itemCodes.split(deselectedNum11).join("");
					itemCodes = itemCodes.split(deselectedNum22).join("");

					panelResult.setValue('PRODT_NUMS', prodtNums);
					panelResult.setValue('ITEM_CODES', itemCodes);
				}
        	}
        }),
        columns: [
        	{dataIndex: 'DIV_CODE'      	, width: 100, hidden :true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 80,
			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
            		return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.subtotal" default="소계"/>', '<t:message code="system.label.product.total" default="총계"/>');
            }},
			{dataIndex: 'TREE_NAME'     	, width: 80},
			{dataIndex: 'PRODT_DATE'    	, width: 93},
			{dataIndex: 'ITEM_CODE'     	, width: 100},
			{dataIndex: 'ITEM_NAME'     	, width: 150},
			{dataIndex: 'SPEC'          	, width: 100},
			{dataIndex: 'PRODT_Q'       	, width: 100, summaryType: 'sum'},
			{dataIndex: 'GOOD_PRODT_Q'       	, width: 100, summaryType: 'sum'},
			{dataIndex: 'RECEIPT_DATE'  	, width: 93},
			{dataIndex: 'RECEIPT_PRSN'  	, width: 100},
			{dataIndex: 'RECEIPT_Q'     	, width: 100, summaryType: 'sum'},
			{dataIndex: 'NOTRECEIPT_Q'  	, width: 100, summaryType: 'sum'},
			{dataIndex: 'PRODT_NUM'     	, width: 120},
			{dataIndex: 'RECEIPT_NUM'   	, width: 120},
			{dataIndex: 'RECEIPT_SEQ'   	, width: 80},
			{dataIndex: 'LOT_NO'        	, width: 100},
			{dataIndex: 'RECEIPT_REMARK'	, width: 133}
		],
        listeners: {
        	onGridDblClick :function( grid, record, cellIndex, colName ) {
        		var params = record.data;
        		params.PGM_ID = 'pms300skrv';

		  		var rec1 = {data : {prgID : 'pms300ukrv', 'text':''}};
				parent.openTab(rec1, '/prodt/pms300ukrv.do', params);

        	}

        }
    });

    var masterGrid2 = Unilite.createGrid('pms300skrvGrid2', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore2,
        selModel: 'rowmodel',
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst : false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },selModel : Ext.create("Ext.selection.CheckboxModel", {
        	singleSelect : true ,
        	checkOnly : false,showHeaderCheckbox :true,
        	listeners: {
        		select: function(grid, selectRecord, index, rowIndex, eOpts ){
        			if(Ext.isEmpty(panelResult.getValue('PRODT_NUMS'))) {
						panelResult.setValue('PRODT_NUMS', selectRecord.get('PRODT_NUM'));
					} else {
						var prodtNums = panelResult.getValue('PRODT_NUMS');
						prodtNums = prodtNums + ',' + selectRecord.get('PRODT_NUM');
						panelResult.setValue('PRODT_NUMS', prodtNums);
					}
        			if(Ext.isEmpty(panelResult.getValue('ITEM_CODES'))) {
						panelResult.setValue('ITEM_CODES', selectRecord.get('ITEM_CODE'));
					} else {
						var itemCodes = panelResult.getValue('ITEM_CODES');
						itemCodes = itemCodes + ',' + selectRecord.get('ITEM_CODE') ;
						panelResult.setValue('ITEM_CODES', itemCodes);
					}
        		},
				deselect:  function(grid, selectRecord, index, eOpts ){
					var prodtNums	 = panelResult.getValue('PRODT_NUMS');
					var deselectedNum0  = selectRecord.get('PRODT_NUM') + ',';
					var deselectedNum1  = ',' + selectRecord.get('PRODT_NUM');
					var deselectedNum2  = selectRecord.get('PRODT_NUM');

					prodtNums = prodtNums.split(deselectedNum0).join("");
					prodtNums = prodtNums.split(deselectedNum1).join("");
					prodtNums = prodtNums.split(deselectedNum2).join("");

					var itemCodes	 = panelResult.getValue('ITEM_CODES');
					var deselectedNum00  = selectRecord.get('ITEM_CODE') + ',';
					var deselectedNum11  = ',' + selectRecord.get('ITEM_CODE') ;
					var deselectedNum22  = selectRecord.get('ITEM_CODE') ;

					itemCodes = itemCodes.split(deselectedNum00).join("");
					itemCodes = itemCodes.split(deselectedNum11).join("");
					itemCodes = itemCodes.split(deselectedNum22).join("");

					panelResult.setValue('PRODT_NUMS', prodtNums);
					panelResult.setValue('ITEM_CODES', itemCodes);
				}
        	}
        }),
    	features: [
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: true}
    	],
        columns: [
        	{dataIndex: 'DIV_CODE'      	, width: 100, hidden :true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 80,
			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
            		return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.subtotal" default="소계"/>', '<t:message code="system.label.product.total" default="총계"/>');
            }},
			{dataIndex: 'TREE_NAME'     	, width: 80},
			{dataIndex: 'PRODT_DATE'    	, width: 93},
			{dataIndex: 'ITEM_CODE'     	, width: 100},
			{dataIndex: 'ITEM_NAME'     	, width: 150},
			{dataIndex: 'SPEC'          	, width: 100},
			{dataIndex: 'PRODT_Q'       	, width: 100, summaryType: 'sum'},
			{dataIndex: 'GOOD_PRODT_Q'       	, width: 100, summaryType: 'sum',hidden: true},
			{dataIndex: 'RECEIPT_DATE'  	, width: 93},
			{dataIndex: 'RECEIPT_PRSN'  	, width: 100, align: 'center'},
			{dataIndex: 'RECEIPT_Q'     	, width: 100, summaryType: 'sum'},
            {dataIndex: 'INSPEC_PRSN'       , width: 100},
			{dataIndex: 'INSPEC_Q'          , width: 100, summaryType: 'sum'},
			{dataIndex: 'GOOD_INSPEC_Q'     , width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_INSPEC_Q'      , width: 100, summaryType: 'sum'},
			{dataIndex: 'NOTINSPEC_Q'       , width: 100, summaryType: 'sum'},
			{dataIndex: 'PRODT_NUM'     	, width: 120},
			{dataIndex: 'RECEIPT_NUM'   	, width: 120},
			{dataIndex: 'RECEIPT_SEQ'   	, width: 80},
			{dataIndex:'INSPEC_NUM'	, width: 100},
			{dataIndex:'INSPEC_SEQ'	, width: 100},
			{dataIndex: 'LOT_NO'        	, width: 100},
			{dataIndex: 'RECEIPT_REMARK'	, width: 133},
			{dataIndex: 'INSPEC_REMARK'	, width: 133}
		]
    });

    var masterGrid3 = Unilite.createGrid('pms300skrvGrid3', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore3,
        selModel: 'rowmodel',
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			onLoadSelectFirst : false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },selModel : Ext.create("Ext.selection.CheckboxModel", {
        	singleSelect : true ,
        	checkOnly : false,showHeaderCheckbox :true,
        	listeners: {
        		select: function(grid, selectRecord, index, rowIndex, eOpts ){
        			if(Ext.isEmpty(panelResult.getValue('PRODT_NUMS'))) {
						panelResult.setValue('PRODT_NUMS', selectRecord.get('PRODT_NUM'));
					} else {
						var prodtNums = panelResult.getValue('PRODT_NUMS');
						prodtNums = prodtNums + ',' + selectRecord.get('PRODT_NUM');
						panelResult.setValue('PRODT_NUMS', prodtNums);
					}
        			if(Ext.isEmpty(panelResult.getValue('ITEM_CODES'))) {
						panelResult.setValue('ITEM_CODES', selectRecord.get('ITEM_CODE'));
					} else {
						var itemCodes = panelResult.getValue('ITEM_CODES');
						itemCodes = itemCodes + ',' + selectRecord.get('ITEM_CODE') ;
						panelResult.setValue('ITEM_CODES', itemCodes);
					}
        		},
				deselect:  function(grid, selectRecord, index, eOpts ){
					var prodtNums	 = panelResult.getValue('PRODT_NUMS');
					var deselectedNum0  = selectRecord.get('PRODT_NUM') + ',';
					var deselectedNum1  = ',' + selectRecord.get('PRODT_NUM');
					var deselectedNum2  = selectRecord.get('PRODT_NUM');

					prodtNums = prodtNums.split(deselectedNum0).join("");
					prodtNums = prodtNums.split(deselectedNum1).join("");
					prodtNums = prodtNums.split(deselectedNum2).join("");

					var itemCodes	 = panelResult.getValue('ITEM_CODES');
					var deselectedNum00  = selectRecord.get('ITEM_CODE') + ',';
					var deselectedNum11  = ',' + selectRecord.get('ITEM_CODE') ;
					var deselectedNum22  = selectRecord.get('ITEM_CODE') ;

					itemCodes = itemCodes.split(deselectedNum00).join("");
					itemCodes = itemCodes.split(deselectedNum11).join("");
					itemCodes = itemCodes.split(deselectedNum22).join("");

					panelResult.setValue('PRODT_NUMS', prodtNums);
					panelResult.setValue('ITEM_CODES', itemCodes);
				}
        	}
        }),
    	features: [
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: true}
    	],
        columns: [
        	{dataIndex: 'DIV_CODE'      	, width: 100, hidden :true},
			{dataIndex: 'WORK_SHOP_CODE'	, width: 80,
			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
            		return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.product.subtotal" default="소계"/>', '<t:message code="system.label.product.total" default="총계"/>');
            }},
			{dataIndex: 'TREE_NAME'     	, width: 80},
			{dataIndex: 'PRODT_DATE'    	, width: 93},
			{dataIndex: 'ITEM_CODE'     	, width: 100},
			{dataIndex: 'ITEM_NAME'     	, width: 150},
			{dataIndex: 'SPEC'          	, width: 100},
			{dataIndex: 'PRODT_Q'       	, width: 100, summaryType: 'sum',hidden: true},
			{dataIndex: 'GOOD_PRODT_Q'       	, width: 100, summaryType: 'sum',hidden: true},
			{dataIndex: 'RECEIPT_DATE'  	, width: 93,hidden: true},
			{dataIndex: 'RECEIPT_PRSN'  	, width: 100, align: 'center',hidden: true},
			{dataIndex: 'RECEIPT_Q'     	, width: 100, summaryType: 'sum'},
			{dataIndex: 'INSPEC_PRSN'          	, width: 100},
			{dataIndex: 'INSPEC_Q'          	, width: 100, summaryType: 'sum'},
			{dataIndex: 'GOOD_INSPEC_Q'          	, width: 100, summaryType: 'sum'},
			{dataIndex: 'BAD_INSPEC_Q'          	, width: 100, summaryType: 'sum' ,hidden: true},
			{dataIndex: 'NOTINSPEC_Q'  	, width: 100, summaryType: 'sum'},
			{dataIndex: 'TOT_BAD_INSPEC_Q'  	, width: 100, summaryType: 'sum' ,hidden: true},
			{dataIndex: 'BAD_INSPEC_NAME'     	, width: 120},
			{dataIndex: 'BAD_INSPEC_Q'     , width: 100, summaryType: 'sum'},
			{dataIndex: 'INSPEC_NUM'     	, width: 120},
			{dataIndex: 'INSPEC_SEQ'   	, width: 120},
			{dataIndex: 'LOT_NO'        	, width: 100},
			{dataIndex: 'RECEIPT_REMARK'	, width: 133},
			{dataIndex: 'INSPEC_REMARK'	, width: 133}
		]
    });

    var tab = Unilite.createTabPanel('tabPanel', {
    	activeTab: 0,
        region: 'center',
		items : [
			 {
				title : '<t:message code="system.label.product.receiptstatu" default="접수현황"/>',
				xtype : 'container',
				layout : {
					type : 'vbox',
					align : 'stretch'
				},
				items : [ panelResult1, masterGrid1],
				id : 'set210ukrvGridTab1'
			},{
				title : '<t:message code="system.label.product.inspecstatus" default="검사현황"/>',
				xtype : 'container',
				layout : {
					type : 'vbox',
					align : 'stretch'
				},
				items : [ panelResult2, masterGrid2],
				id : 'set210ukrvGridTab2'
			},{
				title : '<t:message code="system.label.product.defectstatus" default="불량현황"/>',
				xtype : 'container',
				layout : {
					type : 'vbox',
					align : 'stretch'
				},
				items : [ panelResult3, masterGrid3],
				id : 'set210ukrvGridTab3'
			}
		],
		listeners : {
			tabChange : function(tabPanel, newCard, oldCard, eOpts) {
				var newTabId = newCard.getId();
				console.log("newCard : " + newCard.getId());
				console.log("oldCard : " + oldCard.getId());
				switch(newTabId){
					case 'set210ukrvGridTab1' :
						activeTabId = 'set210ukrvGridTab1';
						masterGrid1.getSelectionModel().deselectAll();
						masterGrid2.getSelectionModel().deselectAll();
						masterGrid3.getSelectionModel().deselectAll();
						panelResult.setValue('PRODT_NUMS','');
						panelResult.setValue('ITEM_CODES','');
						break;

					case 'set210ukrvGridTab2' :
						activeTabId = 'set210ukrvGridTab2';
						masterGrid1.getSelectionModel().deselectAll();
						masterGrid2.getSelectionModel().deselectAll();
						masterGrid3.getSelectionModel().deselectAll();
						panelResult.setValue('PRODT_NUMS','');
						panelResult.setValue('ITEM_CODES','');
						break;

					case 'set210ukrvGridTab3' :
						activeTabId = 'set210ukrvGridTab3';
						masterGrid1.getSelectionModel().deselectAll();
						masterGrid2.getSelectionModel().deselectAll();
						masterGrid3.getSelectionModel().deselectAll();
						panelResult.setValue('PRODT_NUMS','');
						panelResult.setValue('ITEM_CODES','');
						break;

					default:
						break;
				}
			}
		}
	});

    Unilite.Main( {
		borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
			tab, panelResult
         ]
      },
         panelSearch
      ],
		id: 'pms300skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			//20210910 추가 - 프린트 버튼 setting 로직 추가
			if(gsReportSettingYn == 'Y') {
				panelResult.down('#inspecgradereportprint').setHidden(false);
				panelResult.down('#labelreportprint').setHidden(false);
				panelResult.down('#EmptyPrintButton').setHidden(true);
			} else {
				panelResult.down('#inspecgradereportprint').setHidden(true);
				panelResult.down('#labelreportprint').setHidden(true);
				panelResult.down('#EmptyPrintButton').setHidden(false);
			}
		},

		onQueryButtonDown : function()	{
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{



			activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'set210ukrvGridTab1'){
				masterGrid1.getStore().loadStoreRecords();
			}
			if(activeTabId == 'set210ukrvGridTab2'){
				masterGrid2.getStore().loadStoreRecords();
			}
			if(activeTabId == 'set210ukrvGridTab3'){
				masterGrid3.getStore().loadStoreRecords();
			}

			var viewNormal = masterGrid1.getView();
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		    UniAppManager.setToolbarButtons('excel',true);

			}
		},

		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
        onPrintButtonDown: function() {
	        	if(!panelResult.getInvalidMessage()) return;	//필수체크

	        	 var selectedRecords ;
	            	activeTabId = tab.getActiveTab().getId();
	    			if(activeTabId == 'set210ukrvGridTab1'){
	    				selectedRecords = masterGrid1.getSelectedRecords();
	    			}
	    			if(activeTabId == 'set210ukrvGridTab2'){
	    				selectedRecords = masterGrid2.getSelectedRecords();
	    			}
	    			if(activeTabId == 'set210ukrvGridTab3'){
	    				selectedRecords = masterGrid3.getSelectedRecords();
	    			}
		            if(Ext.isEmpty(selectedRecords)){
		                alert('<t:message code="system.message.product.message017" default="출력할 데이터가 없습니다."/>');
		                return;
		            }

	            var param = panelResult.getValues();
	            param.RECEIPT_DATE_FR = UniDate.getDateStr(panelResult1.getValue('RECEIPT_DATE_FR'));
	  			param.RECEIPT_DATE_TO = UniDate.getDateStr(panelResult1.getValue('RECEIPT_DATE_TO'));
	            param["dataCount"] = selectedRecords.length;
	            param["sTxtValue2_fileTitle"]='검사결과서';

	            param["PGM_ID"]='pms300skrv';
	            param["MAIN_CODE"]='P010';

	            if(activeTabId == 'set210ukrvGridTab1'){
	            	param["SEL_TAB"] = '01';
    			}else if(activeTabId == 'set210ukrvGridTab2'){
    				param["SEL_TAB"] = '02';
    			}else{
    				param["SEL_TAB"] = '03';
    			}

	            var win = '';
	           		 win = Ext.create('widget.ClipReport', {
		                    url: CPATH+'/prodt/pms300clrkrv_label.do',
		                    prgID: 'pms300skrv',
		                    extParam: param
		                });
		                    win.center();
		                    win.show();

		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});
};


</script>
