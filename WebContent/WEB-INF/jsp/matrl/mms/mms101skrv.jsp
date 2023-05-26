<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mms101skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->
	<t:ExtComboStore comboType="AU" comboCode="Q032" /> <!-- 조회구분(검사구분) -->
	<t:ExtComboStore comboType="AU" comboCode="Q033" /> <!-- 최종판정 -->
	<t:ExtComboStore comboType="AU" comboCode="Q005" /> <!-- 검사유형 -->	
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
	Unilite.defineModel('Mms101skrvModel2', {
		fields: [
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.purchase.division" default="사업장"/>'		, type: 'string'},
	    	{name: 'CUSTOM_CODE'			, text: '<t:message code="system.label.purchase.customcode" default="거래처코드"/>'	, type: 'string'},
	    	{name: 'CUSTOM_NAME'			, text: '<t:message code="system.label.purchase.customname" default="거래처명"/>'		, type: 'string'},
	    	{name: 'ORDER_TYPE'				, text: '<t:message code="system.label.purchase.potype" default="발주형태"/>'		, type: 'string'},
	    	{name: 'ORDER_DATE'				, text: '<t:message code="system.label.purchase.podate" default="발주일"/>'		, type: 'uniDate'},
	    	{name: 'ITEM_CODE'				, text: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		, type: 'string'},
	    	{name: 'ITEM_NAME'				, text: '<t:message code="system.label.purchase.itemname" default="품목명"/>'		, type: 'string'},
	    	{name: 'SPEC'					, text: '<t:message code="system.label.purchase.spec" default="규격"/>'		, type: 'string'},
	    	{name: 'DVRY_DATE'				, text: '<t:message code="system.label.purchase.deliverydate" default="납기일"/>'		, type: 'uniDate'},
	    	{name: 'ORDER_UNIT'				, text: '<t:message code="system.label.purchase.unit" default="단위"/>'		, type: 'string'},
	    	{name: 'ORDER_Q'				, text: '<t:message code="system.label.purchase.poqty" default="발주량"/>'		, type: 'uniQty'},
	    	{name: 'RECEIPT_DATE'			, text: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>'		, type: 'uniDate'},
	    	{name: 'RECEIPT_PRSN'			, text: '접수자'		, type: 'string'},
	    	{name: 'RECEIPT_Q'				, text: '<t:message code="system.label.purchase.receiptqty2" default="접수량"/>'		, type: 'uniQty'},
	    	{name: 'INSPEC_TYPE'			, text: '<t:message code="system.label.purchase.inspectype" default="검사유형"/>'		, type: 'string'},
	    	{name: 'GOODBAD_TYPE'			, text: '<t:message code="system.label.purchase.passyn" default="합격여부"/>'		, type: 'string'},
	    	{name: 'END_DECISION'			, text: '<t:message code="system.label.purchase.finaldecision" default="최종판정"/>'		, type: 'string'},
	    	{name: 'INSPEC_PRSN'			, text: '검사자'		, type: 'string'},
	    	{name: 'INSPEC_Q'				, text: '<t:message code="system.label.purchase.inspecqty" default="검사량"/>'		, type: 'uniQty'},
	    	{name: 'GOOD_INSPEC_Q'			, text: '<t:message code="system.label.purchase.gooditemqty" default="양품량"/>'		, type: 'uniQty'},
	    	{name: 'BAD_INSPEC_Q'			, text: '불량품량'		, type: 'uniQty'},
	    	{name: 'NOTINSPEC_Q'			, text: '<t:message code="system.label.purchase.noinspecqty" default="미검사량"/>'		, type: 'uniQty'},
	    	{name: 'ORDER_NUM'				, text: '<t:message code="system.label.purchase.pono" default="발주번호"/>'		, type: 'string'},
	    	{name: 'ORDER_SEQ'				, text: '<t:message code="system.label.purchase.poseq" default="발주순번"/>'		, type: 'string'},
	    	{name: 'RECEIPT_NUM'			, text: '<t:message code="system.label.purchase.receiptno2" default="접수번호"/>'		, type: 'string'},
	    	{name: 'RECEIPT_SEQ'			, text: '<t:message code="system.label.purchase.receiptseq" default="접수순번"/>'		, type: 'string'},
	    	{name: 'INSPEC_NUM'				, text: '<t:message code="system.label.purchase.inspecno" default="검사번호"/>'		, type: 'string'},
	    	{name: 'INSPEC_SEQ'				, text: '<t:message code="system.label.purchase.inspecseq" default="검사순번"/>'		, type: 'string'},
	    	{name: 'ORDER_REMARK'			, text: '발주비고'		, type: 'string'},
	    	{name: 'ORDER_PROJECT_NO'		, text: '발주관리번호'	, type: 'string'},
	    	{name: 'RECEIPT_REMARK'			, text: '접수비고'		, type: 'string'},
	    	{name: 'RECEIPT_PROJECT_NO'		, text: '접수관리번호'	, type: 'string'},
	    	{name: 'INSPEC_REMARK'			, text: '검사비고'		, type: 'string'},
	    	{name: 'INSPEC_PROJECT_NO'		, text: '검사관리번호'	, type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore2 = Unilite.createStore('mms101skrvMasterStore2', {
		model: 'Mms101skrvModel2',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,			// 삭제 가능 여부 
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: {
			type: 'direct',
			api: {			
				read: 'mms101skrvService.selectList'                	
			}
		},
		loadStoreRecords: function(){
			var param = Ext.getCmp('searchForm').getValues();			
			console.log(param);
			this.load({
				params: param
			});
		}
	});//End of var directMasterStore2 = Unilite.createStore('mms101skrvMasterStore2', {

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
				fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>', 
				name: 'DIV_CODE', 
				xtype: 'uniCombobox', 
				comboType: 'BOR120', 
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			}, 
			Unilite.popup('CUST', {
				fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
				valueFieldName: 'CUST_CODE', 
				textFieldName: 'CUST_NAME', 
				textFieldWidth:170, 
				validateBlank:false, 
				popupWidth: 710,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('CUST_CODE', panelSearch.getValue('CUST_CODE'));
							panelResult.setValue('CUST_NAME', panelSearch.getValue('CUST_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('CUST_CODE', '');
						panelResult.setValue('CUST_NAME', '');
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.purchase.poclass" default="발주유형"/>', 
				name: 'ORDER_TYPE', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'M001',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			}, 
			Unilite.popup('DIV_PUMOK', {
				fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
				valueFieldName: 'ITEM_CODE', 
				textFieldName: 'ITEM_NAME', 
				textFieldWidth: 170,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
							panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_NAME', '');
					}
				}
			})
		]},{
			title:'<t:message code="system.label.purchase.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[{
				fieldLabel: '<t:message code="system.label.purchase.receiptdate2" default="접수일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'RECEIPT_DATE_FR',
				endFieldName: 'RECEIPT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315
			},{ 
				fieldLabel: '<t:message code="system.label.purchase.inspecdate" default="검사일"/>',
				xtype: 'uniDateRangefield',
				startFieldName: 'INSPEC_DATE_FR',
				endFieldName: 'INSPEC_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315
			},{
				fieldLabel: '조회구분', 
				name: 'TOT_INSPEC_Q', 
				xtype: 'uniCombobox', 
				comboType: 'AU', 
				comboCode: 'Q032'
			},{
				fieldLabel: '<t:message code="system.label.purchase.finaldecision" default="최종판정"/>', 
				name: 'END_DECISION', 
				xtype: 'uniCombobox', 
				comboType: 'AU',
				comboCode: 'Q033'
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
	   						var labelText = invalid.items[0]['fieldLabel']+':';
	   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   						var labelText = invalid.items[0].ownerCt['fieldLabel']+':';
	   					}
	
					   	alert(labelText+Msg.sMB083);
					   	invalid.items[0].focus();
					} else {
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>', 
			name: 'DIV_CODE', 
			xtype: 'uniCombobox', 
			comboType: 'BOR120', 
			allowBlank: false,
			value: UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		}, 
		Unilite.popup('CUST', {
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName: 'CUST_CODE', 
			textFieldName: 'CUST_NAME', 
			textFieldWidth:170, 
			validateBlank:false, 
			popupWidth: 710,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('CUST_CODE', panelResult.getValue('CUST_CODE'));
						panelSearch.setValue('CUST_NAME', panelResult.getValue('CUST_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('CUST_CODE', '');
					panelSearch.setValue('CUST_NAME', '');
				}
			}
		}),
		{
			fieldLabel: '<t:message code="system.label.purchase.poclass" default="발주유형"/>', 
			name: 'ORDER_TYPE', 
			xtype: 'uniCombobox', 
			comboType: 'AU',
			comboCode: 'M001',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ORDER_TYPE', newValue);
				}
			}
		}, 
		Unilite.popup('DIV_PUMOK', {
			fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
			valueFieldName: 'ITEM_CODE', 
			textFieldName: 'ITEM_NAME', 
			textFieldWidth: 170,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
						panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ITEM_CODE', '');
					panelSearch.setValue('ITEM_NAME', '');
				}
			}
		})]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('mms101skrvGrid2', {
		// for tab    	
		layout: 'fit',
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
			{dataIndex: 'DIV_CODE'				, width: 66, hidden: true},
			{dataIndex: 'CUSTOM_CODE'			, width: 93,locked:true,
			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.purchase.total" default="총계"/>');
            }},
			{dataIndex: 'CUSTOM_NAME'			, width: 106,locked:true},
			{dataIndex: 'ORDER_TYPE'			, width: 93},
			{dataIndex: 'ORDER_DATE'			, width: 93},
			{dataIndex: 'ITEM_CODE'				, width: 106},
			{dataIndex: 'ITEM_NAME'				, width: 133},
			{dataIndex: 'SPEC'					, width: 200},
			{dataIndex: 'DVRY_DATE'				, width: 93},
			{dataIndex: 'ORDER_UNIT'			, width: 53},
			{dataIndex: 'ORDER_Q'				, width: 120,summaryType: 'sum'},
			{dataIndex: 'RECEIPT_DATE'			, width: 93},
			{dataIndex: 'RECEIPT_PRSN'			, width: 66},
			{dataIndex: 'RECEIPT_Q'				, width: 93,summaryType: 'sum'},
			{dataIndex: 'INSPEC_TYPE'			, width: 93},
			{dataIndex: 'GOODBAD_TYPE'			, width: 66},
			{dataIndex: 'END_DECISION'			, width: 66},
			{dataIndex: 'INSPEC_PRSN'			, width: 66},
			{dataIndex: 'INSPEC_Q'				, width: 120,summaryType: 'sum'},
			{dataIndex: 'GOOD_INSPEC_Q'			, width: 120,summaryType: 'sum'},
			{dataIndex: 'BAD_INSPEC_Q'			, width: 120,summaryType: 'sum'},
			{dataIndex: 'NOTINSPEC_Q'			, width: 120,summaryType: 'sum'},
			{dataIndex: 'ORDER_NUM'				, width: 133},
			{dataIndex: 'ORDER_SEQ'				, width: 66},
			{dataIndex: 'RECEIPT_NUM'			, width: 133},
			{dataIndex: 'RECEIPT_SEQ'			, width: 66},
			{dataIndex: 'INSPEC_NUM'			, width: 133},
			{dataIndex: 'INSPEC_SEQ'			, width: 66},
			{dataIndex: 'ORDER_REMARK'			, width: 133},
			{dataIndex: 'ORDER_PROJECT_NO'		, width: 133},
			{dataIndex: 'RECEIPT_REMARK'		, width: 133},
			{dataIndex: 'RECEIPT_PROJECT_NO'	, width: 133},
			{dataIndex: 'INSPEC_REMARK'			, width: 133},
			{dataIndex: 'INSPEC_PROJECT_NO'		, width: 133}
		] 
	});//End of var masterGrid2 = Unilite.createGrid('mms101skrvGrid2', {   

	Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		id: 'mms101skrvApp',
		fnInitBinding: function(){
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function(){		
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			masterGrid.getStore().loadStoreRecords();
			var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.normalGrid.getView();
			console.log("viewLocked: ",viewLocked);
			console.log("viewNormal: ",viewNormal);
		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		    UniAppManager.setToolbarButtons('excel',true);
			}
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
/*        onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}*/
	});//End of Unilite.Main({
};


</script>
