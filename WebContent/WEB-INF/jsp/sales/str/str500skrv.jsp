<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="str500skrv"  >
	<t:ExtComboStore comboType="AU" comboCode="A071" /> <!-- 반제유형 -->
	<t:ExtComboStore comboType="BOR120" pgmId="str500skrv"/>		<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="S173"/>		<!-- 파렛트 -->
	<t:ExtComboStore comboType="AU" comboCode="B079" />	<!-- 작업그룹 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}

.x-grid-cell-text-highlight {color: #0100FF;}

</style>
<script type="text/javascript" >

function appMain() {     
	//int
	//uniDate
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('str500skrvModel', {
	    fields: [  	  
	    	{name: 'NATION_NAME'   	,text: '국가명'			,type: 'string'},
	    	{name: 'CUSTOM_NAME'   	,text: '거래처명'			,type: 'string'},
		    {name: 'DEST_FINAL'		,text: '도착지'			,type: 'string'},
		    {name: 'ITEM_CODE' 		,text: '제품코드'			,type: 'string'},
		    {name: 'ITEM_NAME' 		,text: '제품명'			,type: 'string'},
		    {name: 'GROUP_CD' 		,text: '작업그룹'			,type: 'string',comboType: "AU", comboCode: "B079"},
		    {name: 'COND_PACKING'  	,text: '포장방법'			,type: 'string'},
		    {name: 'PALLET_USE'		,text: '파렛트'			,type: 'string',comboType: "AU", comboCode: "S173"},
		    {name: 'PALLET_QTY'		,text: '파렛트수량'		    ,type: 'int'},
		    {name: 'LABEL_USE' 		,text: '라벨'				,type: 'string'},
		    {name: 'PO_NUM'			,text: 'PO'				,type: 'string'},
		    {name: 'ORDER_UNIT_Q'	,text: '수량'				,type: 'uniQty'},
		    
		    {name: 'CONTAINER_NO'	,text: '컨테이너'			,type: 'int'},
		    {name: 'CARGO_CLOSE'	,text: '카고마감'			,type: 'string'},
		    {name: 'ETD'			,text: 'ETD'			,type: 'uniDate'},
		    {name: 'BOOKING_NUM'	,text: '부킹넘버'			,type: 'string'},
		    
		    {name: 'TRANSPORT_CODE'	,text: '운송사코드'		    ,type: 'string'},
		    {name: 'TRANSPORT_NAME'	,text: '운송사'			,type: 'string'},
		    
		    {name: 'OUT_DATE'		,text: '출고일'			,type: 'uniDate'},
		    {name: 'DVRY_CUST_CD'	,text: 'DVRY_CUST_CD'	,type: 'string'},
		    {name: 'AGENT_CODE'		,text: 'AGENT_CODE'		,type: 'int'},
		    {name: 'AGENT_NAME'		,text: '포워더' 			,type: 'string'},
		    {name: 'NATION_CODE'	,text: 'NATION_CODE' 	,type: 'string'},
		    {name: 'ORDER_NUM'		,text: '수주번호' 			,type: 'string'},
		    {name: 'SER_NO'			,text: '수주순번' 			,type: 'int'},
		    {name: 'ISSUE_REQ_YN'	,text: '출하예정참조여부' 	    ,type: 'string'},
		    {name: 'DIV_CODE'       ,text: '사업장'           ,type: 'string'}
		    
		    //{name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.base.updateuser" default="수정자"/>'			,type: 'string'},
		    //{name: 'UPDATE_DB_TIME'		,text: '<t:message code="system.label.base.updatedate" default="수정일"/>'			,type: 'uniDate'} 
		]
	}); //End of Unilite.defineModel('bcm200ukrvModel', {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'str500skrvService.selectDetailList',
			update: 'str500skrvService.updateDetail',
			//create: 'str500skrvService.insertDetail',
			//destroy: 'str500skrvService.deleteDetail',
			syncAll: 'str500skrvService.saveAll'
		}
	});
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('str500skrvMasterStore',{
		model: 'str500skrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
		proxy: directProxy,
        loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	console.log("toUpdate",toUpdate);

        	var rv = true;
   	
        	
			if(inValidRecs.length == 0 )	{					
				config = {
					success: function(batch, option) {								
//						detailForm.resetDirtyStatus();
						directMasterStore.loadStoreRecords();
					 } 
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
        listeners: {
            load: function(store, records, successful, eOpts) {
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
                  UniAppManager.setToolbarButtons(['save'], true);
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        }
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [
		    	{
					fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
					name		: 'DIV_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'BOR120',
					allowBlank	: false,
					value		: UserInfo.divCode,
					listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {							
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},
				{
					fieldLabel		: '카고마감',
					width			: 315,
					xtype			: 'uniDateRangefield',
					startFieldName	: 'CA_FR_DATE',
					endFieldName	: 'CA_TO_DATE',
					startDate		: UniDate.get('startOfMonth'),
					endDate			: UniDate.get('today'),
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('CA_FR_DATE',newValue);
						}
						/*if(Ext.isEmpty(newValue)) {
							var caToDate	= panelSearch.getValue('CA_TO_DATE');
							var shipFrDate	= panelSearch.getValue('SHIP_FR_DATE');
							var shipToDate	= panelSearch.getValue('SHIP_TO_DATE');
							
							//if(Ext.isEmpty(caToDate) && Ext.isEmpty(shipFrDate) && Ext.isEmpty(shipToDate)) {
							if(Ext.isEmpty(shipFrDate) && Ext.isEmpty(shipToDate)) {
								Unilite.messageBox('조회조건 중 선적일이 공백일 경우  카고마감 시작~종료일은 필수입력항목입니다. ');
								panelSearch.setValue('CA_FR_DATE',oldValue);
								panelResult.setValue('CA_FR_DATE',oldValue);
							}
						}*/
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('CA_TO_DATE',newValue);
						}
						/*if(Ext.isEmpty(newValue)) {
							var caFrDate	= panelSearch.getValue('CA_FR_DATE');
							var shipFrDate	= panelSearch.getValue('SHIP_FR_DATE');
							var shipToDate	= panelSearch.getValue('SHIP_TO_DATE');
							
							//if(Ext.isEmpty(caToDate) && Ext.isEmpty(shipFrDate) && Ext.isEmpty(shipToDate)) {
							if(Ext.isEmpty(shipFrDate) && Ext.isEmpty(shipToDate)) {
								Unilite.messageBox('조회조건 중 선적일이 공백일 경우  카고마감 시작~종료일은 필수입력항목입니다. ');
								panelSearch.setValue('CA_TO_DATE',oldValue);
								panelResult.setValue('CA_TO_DATE',oldValue);
							}
						}*/
					}
				},
				Unilite.popup('AGENT_CUST',{
					fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
					validateBlank	: false,
					autoPopup		: true,
					valueFieldName	: 'CUSTOM_CODE',
					textFieldName	: 'CUSTOM_NAME',
					listeners		: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('CUSTOM_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('CUSTOM_NAME', newValue);
						},
						applyextparam: function(popup){
							popup.setExtParam({'AGENT_CUST_FILTER': ['1', '3']});
							popup.setExtParam({'CUSTOM_TYPE': ['1', '3']});
						}
					}
				})
				,{
					fieldLabel : '작업그룹',
					xtype : 'uniCombobox',
					name : 'GROUP_CD',
					comboType : 'AU',
					comboCode : 'B079',
					listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {							
							panelResult.setValue('GROUP_CD', newValue);
						}
					}
				},
				{
					fieldLabel		: '선적일',
					width			: 315,
					xtype			: 'uniDateRangefield',
					startFieldName	: 'SHIP_FR_DATE',
					endFieldName	: 'SHIP_TO_DATE',
					//startDate		: UniDate.get('startOfMonth'),
					//endDate			: UniDate.get('today'),
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('SHIP_FR_DATE',newValue);
						}
						/*if(Ext.isEmpty(newValue)) {
							var caFrDate	= panelSearch.getValue('CA_FR_DATE');
							var caToDate	= panelSearch.getValue('CA_TO_DATE');
							var shipToDate	= panelSearch.getValue('SHIP_TO_DATE');
							if(Ext.isEmpty(caFrDate) && Ext.isEmpty(caToDate)) {
								Unilite.messageBox('조회조건 중 카고마감일이 공백일 경우  선적일 시작~종료일은 필수입력항목입니다. ');
								panelSearch.setValue('SHIP_FR_DATE',oldValue);
								panelResult.setValue('SHIP_FR_DATE',oldValue);
							}
						}*/
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelResult) {
							panelResult.setValue('SHIP_TO_DATE',newValue);
						}
						/*if(Ext.isEmpty(newValue)) {
							var caFrDate	= panelSearch.getValue('CA_FR_DATE');
							var caToDate	= panelSearch.getValue('CA_TO_DATE');
							var shipFrDate	= panelSearch.getValue('SHIP_FR_DATE');
							if(Ext.isEmpty(caFrDate) && Ext.isEmpty(caToDate)) {
								Unilite.messageBox('조회조건 중 카고마감일이 공백일 경우  선적일 시작~종료일은 필수입력항목입니다. ');
								panelSearch.setValue('SHIP_TO_DATE',oldValue);
								panelResult.setValue('SHIP_TO_DATE',oldValue);
							}
						}*/
					}
				},
				{
					fieldLabel: '부킹번호',
					xtype: 'uniTextfield',
					name: 'BOOKING_NUM',
					listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {
							panelResult.setValue('BOOKING_NUM',newValue);
						}
					}
				}
				,{
					xtype: 'radiogroup',
					fieldLabel: ' ',
					id: 'rdoSelectA-2',
					items: [{
						boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
						name: 'rdoSelect1',
						inputValue: 'A',
						width: 50,
						checked: true
					},{
						boxLabel: '내수',
						name: 'rdoSelect1',
						inputValue: 'B',
						width: 60
					},{
						boxLabel: '수출',
						name: 'rdoSelect1' ,
						inputValue: 'C',
						width: 70
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('rdoSelect1', newValue.rdoSelect1);
						}
					}
				}
				,{
					xtype: 'radiogroup',
					fieldLabel: ' ',
					id: 'rdoSelectB-2',
					items: [{
						boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
						name: 'rdoSelect2',
						inputValue: 'A',
						width: 50
					},{
						boxLabel: '미출고',
						name: 'rdoSelect2',
						inputValue: 'B',
						width: 60,
						checked: true
					},{
						boxLabel: '출고완료',
						name: 'rdoSelect2' ,
						inputValue: 'C',
						width: 70
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('rdoSelect2', newValue.rdoSelect2);
						}
					}
				}
			]
		}]
    }); //End of var panelSearch = Unilite.createSearchForm('searchForm',{
	
    var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 5},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		
		items: [
	    		{
					fieldLabel	: '<t:message code="system.label.sales.division" default="사업장"/>',
					name		: 'DIV_CODE',
					xtype		: 'uniCombobox',
					comboType	: 'BOR120',
					value		: UserInfo.divCode,
					allowBlank	: false,
					listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {							
							panelSearch.setValue('DIV_CODE', newValue);
						}
					}
				},
				{
					fieldLabel		: '카고마감',
					width			: 315,
					xtype			: 'uniDateRangefield',
					startFieldName	: 'CA_FR_DATE',
					endFieldName	: 'CA_TO_DATE',
					startDate		: UniDate.get('startOfMonth'),
					endDate			: UniDate.get('today'),
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelSearch) {
							panelSearch.setValue('CA_FR_DATE',newValue);
						}
						/*if(Ext.isEmpty(newValue)) {
							var caToDate	= panelResult.getValue('CA_TO_DATE');
							var shipFrDate	= panelResult.getValue('SHIP_FR_DATE');
							var shipToDate	= panelResult.getValue('SHIP_TO_DATE');
							
							//if(Ext.isEmpty(caToDate) && Ext.isEmpty(shipFrDate) && Ext.isEmpty(shipToDate)) {
							if(Ext.isEmpty(shipFrDate) && Ext.isEmpty(shipToDate)) {
								Unilite.messageBox('조회조건 중 선적일이 공백일 경우  카고마감 시작~종료일은 필수입력항목입니다. ');
								panelSearch.setValue('CA_FR_DATE',oldValue);
								panelResult.setValue('CA_FR_DATE',oldValue);
							}
						}*/
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelSearch) {
							panelSearch.setValue('CA_TO_DATE',newValue);
						}
						/*if(Ext.isEmpty(newValue)) {
							var caFrDate	= panelResult.getValue('CA_FR_DATE');
							var shipFrDate	= panelResult.getValue('SHIP_FR_DATE');
							var shipToDate	= panelResult.getValue('SHIP_TO_DATE');
							
							if(Ext.isEmpty(shipFrDate) && Ext.isEmpty(shipToDate)) {
								Unilite.messageBox('조회조건 중 선적일이 공백일 경우  카고마감 시작~종료일은 필수입력항목입니다. ');
								panelSearch.setValue('CA_TO_DATE',oldValue);
								panelResult.setValue('CA_TO_DATE',oldValue);
							}
						}*/
					}
				},
				Unilite.popup('AGENT_CUST',{
					fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
					valueFieldName	: 'CUSTOM_CODE',
					textFieldName	: 'CUSTOM_NAME',
					autoPopup		: true,
					validateBlank	: false,
					listeners		: {
						onValueFieldChange: function(field, newValue){
							panelSearch.setValue('CUSTOM_CODE', newValue);
						},
						onTextFieldChange: function(field, newValue){
							panelSearch.setValue('CUSTOM_NAME', newValue);
						},
						applyextparam: function(popup){
							popup.setExtParam({'AGENT_CUST_FILTER': ['1', '3']});
							popup.setExtParam({'CUSTOM_TYPE': ['1', '3']});
						}
					}
				})
				,{
					xtype: 'radiogroup',
					fieldLabel: ' ',
					id: 'rdoSelectA-1',
					items: [{
						boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
						name: 'rdoSelect1',
						inputValue: 'A',
						width: 50,
						checked: true
					},{
						boxLabel: '내수',
						name: 'rdoSelect1',
						inputValue: 'B',
						width: 60
					},{
						boxLabel: '수출',
						name: 'rdoSelect1' ,
						inputValue: 'C',
						width: 70
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('rdoSelect1', newValue.rdoSelect1);
						}
					}
				}
				,{
					xtype: 'component'
				}
				,{
					fieldLabel : '작업그룹',
					xtype : 'uniCombobox',
					name : 'GROUP_CD',
					comboType : 'AU',
					comboCode : 'B079',
					listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {							
							panelSearch.setValue('GROUP_CD', newValue);
						}
					}
				},
				{
					fieldLabel		: '선적일',
					width			: 315,
					xtype			: 'uniDateRangefield',
					startFieldName	: 'SHIP_FR_DATE',
					endFieldName	: 'SHIP_TO_DATE',
					//startDate		: UniDate.get('startOfMonth'),
					//endDate			: UniDate.get('today'),
					onStartDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelSearch) {
							panelSearch.setValue('SHIP_FR_DATE',newValue);
						}
						/*if(Ext.isEmpty(newValue)) {
							var caFrDate	= panelResult.getValue('CA_FR_DATE');
							var caToDate	= panelResult.getValue('CA_TO_DATE');
							var shipToDate	= panelResult.getValue('SHIP_TO_DATE');
							if(Ext.isEmpty(caFrDate) && Ext.isEmpty(caToDate)) {
								Unilite.messageBox('조회조건 중 카고마감일이 공백일 경우  선적일 시작~종료일은 필수입력항목입니다. ');
								panelSearch.setValue('SHIP_FR_DATE',oldValue);
								panelResult.setValue('SHIP_FR_DATE',oldValue);
							}
						}*/
					},
					onEndDateChange: function(field, newValue, oldValue, eOpts) {
						if(panelSearch) {
							panelSearch.setValue('SHIP_TO_DATE',newValue);
						}
						/*if(Ext.isEmpty(newValue)) {
							var caFrDate	= panelResult.getValue('CA_FR_DATE');
							var caToDate	= panelResult.getValue('CA_TO_DATE');
							var shipFrDate	= panelResult.getValue('SHIP_FR_DATE');
							if(Ext.isEmpty(caFrDate) && Ext.isEmpty(caToDate)) {
								Unilite.messageBox('조회조건 중 카고마감일이 공백일 경우  선적일 시작~종료일은 필수입력항목입니다. ');
								panelSearch.setValue('SHIP_TO_DATE',oldValue);
								panelResult.setValue('SHIP_TO_DATE',oldValue);
							}
						}*/
					}
				}
				,
				{
					fieldLabel: '부킹번호',
					xtype: 'uniTextfield',
					name: 'BOOKING_NUM',
					listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {
							panelSearch.setValue('BOOKING_NUM',newValue);
						}
					}
				}
				
				,{
					xtype: 'radiogroup',
					fieldLabel: ' ',
					id: 'rdoSelectB-1',
					items: [{
						boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
						name: 'rdoSelect2',
						inputValue: 'A',
						width: 50
					},{
						boxLabel: '미출고',
						name: 'rdoSelect2',
						inputValue: 'B',
						width: 60,
						checked: true						
					},{
						boxLabel: '출고완료',
						name: 'rdoSelect2' ,
						inputValue: 'C',
						width: 70
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('rdoSelect2', newValue.rdoSelect2);
						}
					}
				}
				
				,{
					xtype	: 'button',
					itemId	: 'updateButton',
					text	: '확인',
					margin	: '0 0 0 5',
					width	: 90,
					tdAttrs		: {align: 'right'},  
					handler	: function(){
						var selRecords	= masterGrid.getSelectedRecords();
						var saveCount	= 0;
						var closeYn		= '';
						var list = [].concat(selRecords);
						var masterRecords = list;
						var param = [];
		                
						if(masterRecords != null && masterRecords.length > 0){
                            masterRecords.forEach(function(e){
                                var dataObj = e.data;
                                dataObj.ORDER_NUM=dataObj.ORDER_NUM;
                                dataObj.SER_NO=dataObj.SER_NO;
                                dataObj.ISSUE_REQ_YN=dataObj.ISSUE_REQ_YN;
                                param.push(dataObj);
                             });
                        }
						if(confirm('출하예정참조를 진행하시겠습니까?')) {
							Ext.getBody().mask('<t:message code="system.label.product.loading" default="로딩중..."/>','loading-indicator');
    		                str500skrvService.updateButtonSave(param, function(provider, response){
    		                	UniAppManager.updateStatus(UniUtils.getMessage('system.message.commonJS.store.saved','저장되었습니다.'));
    		                	panelResult.down('#updateButton').disable();
    		                	Ext.getBody().unmask();
    		                	
    		                	directMasterStore.loadStoreRecords();
    		                	
                            });
						}else{
							return false;
						}
						//directMasterStore.saveStore();
/*		
						if(confirm('출하예정참조를 진행하시겠습니까?')) {
							directMasterStore.saveStore();
						} else {//confirm에서 취소했을 때 초기화하는 로직이 있어야 다시 눌렀을  때 정상로직 수행
							Ext.each(selRecords, function(selRecord, index) {
								//if(selRecord.get('CLOSE_YN') == 'Y') {
								//	var closeYn = '<t:message code="system.label.human.cancel" default="취소"/>';
								//	selRecord.set('CLOSE_YN', 'N');
								//} else {
								//	var closeYn = '<t:message code="system.label.human.deadline" default="마감"/>';
								//	selRecord.set('CLOSE_YN', 'Y');
								//}
							});
						}
*/
					}
				}
				
			]	
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('str500skrvGrid', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true,
                    onLoadSelectFirst	: false
                    
        },
        viewConfig:{
        		forceFit : true,
                stripeRows: false,
                getRowClass : function(record,rowIndex,rowParams,store){
                	var cls = '';
                    if(record.get('ISSUE_REQ_YN') == 'N'){
                    	cls = 'x-grid-cell-text-highlight';
                    }
                    
                    return cls;
                }
            },
            
            selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: false,
			listeners: {
				
				select: function(grid, selectRecord, index, rowIndex, eOpts ) {
					selectRecord.set('ISSUE_REQ_YN'	, selectRecord.get("ISSUE_REQ_YN") == 'Y'?	'N'	: 'Y');
					if (this.selected.getCount() > 0) {
						panelResult.down('#updateButton').enable();
						UniAppManager.setToolbarButtons(['save'], false);
					}
				},
				deselect: function(grid, selectRecord, index, eOpts ) {
					selectRecord.set('ISSUE_REQ_YN'	, selectRecord.get("ISSUE_REQ_YN") == 'Y'?	'N'	: 'Y');
					if (this.selected.getCount() == 0) {
						panelResult.down('#updateButton').disable();
						UniAppManager.setToolbarButtons(['save'], false);
					}
				}
			}
		}),
            
        columns: [        			 
			{ dataIndex: 'NATION_NAME'		, width: 130},		//국가명
			{ dataIndex: 'CUSTOM_NAME'		, width: 160},		//거래처명
			{ dataIndex: 'DEST_FINAL'		, width: 120},		//도착지
			{ dataIndex: 'ITEM_CODE'		, width: 120, 	hidden: true},		//제품코드
			{ dataIndex: 'ITEM_NAME'		, width: 150},		//제품명
			{ dataIndex: 'GROUP_CD'			, width: 100, align: 'center'},		//제품명
			//
			{ dataIndex: 'COND_PACKING'		, width: 100},		//포장방법
			
			{ dataIndex: 'PALLET_USE'		, width: 120},		//파렛트
			{ dataIndex: 'PALLET_QTY'		, width: 90},		//파렛트수량
			{ dataIndex: 'LABEL_USE'		, width: 100},		//라벨
			{ dataIndex: 'PO_NUM'			, width: 100},		//PO
			{ dataIndex: 'ORDER_UNIT_Q'		, width: 100	, align: 'right'},		//수량
			{ dataIndex: 'CONTAINER_NO'		, width: 100},		//컨테이너
			{ dataIndex: 'CARGO_CLOSE'		, width: 130},		//카고마감
			{ dataIndex: 'ETD'				, width: 100	, align: 'center'},		//ETD
			{ dataIndex: 'BOOKING_NUM'		, width: 100},		//부킹넘버
			
			{ dataIndex: 'TRANSPORT_CODE'	, width: 90},		//운송사코드
			{ dataIndex: 'TRANSPORT_NAME'	, width: 150},		//운송사
			
			{ dataIndex: 'OUT_DATE'			, width: 120    , align: 'center'},		//출고일			
			{ dataIndex: 'DVRY_CUST_CD'		, width: 80, 	hidden: true},
			{ dataIndex: 'AGENT_CODE'		, width: 80, 	hidden: true},
			{ dataIndex: 'AGENT_NAME'		, width: 110},
			{ dataIndex: 'NATION_CODE'		, width: 80, 	hidden: true},
			{ dataIndex: 'ORDER_NUM'		, width: 120, 	hidden: false},
			{ dataIndex: 'SER_NO'		    , width: 80, 	hidden: false},
			{ dataIndex: 'ISSUE_REQ_YN'		, width: 120, 	hidden: true}
			
		]
		,
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
               if(UniUtils.indexOf(e.field, ['CONTAINER_NO'])){
                    return true;
                }else{
                	return false;
                }
            },
			afterrender: function(grid) {
				var me = this;
				this.contextMenu = Ext.create('Ext.menu.Menu', {});
				this.contextMenu.add({
					text	: '수주등록 바로가기',   iconCls : '',
					handler	: function(menuItem, event) {
						var record = grid.getSelectedRecord();
						var params = {
							sender		: me,
							'PGM_ID'	: 'str500skrv',
							COMP_CODE	: UserInfo.compCode,
							DIV_CODE	: panelResult.getValue('DIV_CODE'),
							ORDER_NUM	: record.data.ORDER_NUM
						}
						var rec = {data : {prgID : 'sof100ukrv', 'text':''}};
						parent.openTab(rec, '/sales/sof100ukrv.do', params);
					}
				});
			},
			beforeselect: function(grid, record, index, eOpts ){
				if(record.getModified("ISSUE_REQ_YN") != "N" && record.get("ISSUE_REQ_YN") == "Y") {
					return false;
				}
				return true;
			}
			
		}
    });	//End of   var masterGrid = Unilite.createGrid('bcm200ukrvGrid', {

    Unilite.Main( {
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
		id: 'str500skrvApp',
		fnInitBinding : function() {
			//panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			
			panelSearch.setValue('CA_FR_DATE', UniDate.get('startOfMonth'));
			panelSearch.setValue('CA_TO_DATE', UniDate.get('today'));
			//panelSearch.setValue('SHIP_FR_DATE', UniDate.get('today'));
			//panelSearch.setValue('SHIP_TO_DATE', UniDate.get('today'));

			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('CA_FR_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('CA_TO_DATE', UniDate.get('today'));
			//panelResult.setValue('SHIP_FR_DATE', UniDate.get('today'));
			//panelResult.setValue('SHIP_TO_DATE', UniDate.get('today'));
			
			//UniAppManager.setToolbarButtons('newData',true);
			UniAppManager.setToolbarButtons('save',false);
			
			panelResult.down('#updateButton').disable();
		},
		onQueryButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}
			
			var caFrDate	= panelResult.getValue('CA_FR_DATE');
			var caToDate	= panelResult.getValue('CA_TO_DATE');
			var shipFrDate	= panelResult.getValue('SHIP_FR_DATE');
			var shipToDate	= panelResult.getValue('SHIP_TO_DATE');
			
			//날짜가 전부 없을 경우
			if(Ext.isEmpty(caFrDate) && Ext.isEmpty(caToDate) && Ext.isEmpty(shipFrDate) && Ext.isEmpty(shipToDate)) {
				if(Ext.isEmpty(shipFrDate) || Ext.isEmpty(shipToDate)) {
					Unilite.messageBox('조회조건 중 카고마감 혹은 선적일 중 하나는 시작~종료일은 필수입력항목입니다. ');
					return false;
				}
			}
			
			//날짜가 4군데 중 하나만 있을경우
			if(Ext.isEmpty(caFrDate) && Ext.isEmpty(caToDate)) {
				if(Ext.isEmpty(shipFrDate) || Ext.isEmpty(shipToDate)) {
					Unilite.messageBox('조회조건 중 카고마감 혹은 선적일 시작~종료일은 필수입력항목입니다. ');
					return false;
				}
			}
			
			//날짜가 4군데 중 하나만 있을경우
			if(Ext.isEmpty(shipFrDate) && Ext.isEmpty(shipToDate)) {
				if(Ext.isEmpty(caFrDate) || Ext.isEmpty(caToDate)) {
					Unilite.messageBox('조회조건 중 카고마감 혹은 선적일 시작~종료일은 필수입력항목입니다. ');
					return false;
				}
			}
						
					
			//날짜가 3군데 중 하나만 있을경우
			if(!Ext.isEmpty(caFrDate) && !Ext.isEmpty(caToDate)) {
				if(!Ext.isEmpty(shipFrDate) && Ext.isEmpty(shipToDate)) {
					Unilite.messageBox('시작~종료일은 필수입력항목입니다. ');
					return false;
				}
			}
			
			//날짜가 3군데 중 하나만 있을경우
			if(!Ext.isEmpty(caFrDate) && !Ext.isEmpty(caToDate)) {
				if(Ext.isEmpty(shipFrDate) && !Ext.isEmpty(shipToDate)) {
					Unilite.messageBox('시작~종료일은 필수입력항목입니다. ');
					return false;
				}
			}
			
			//날짜가 3군데 중 하나만 있을경우
			if(!Ext.isEmpty(shipFrDate) && !Ext.isEmpty(shipToDate)) {
				if(!Ext.isEmpty(caFrDate) && Ext.isEmpty(caToDate)) {
					Unilite.messageBox('시작~종료일은 필수입력항목입니다. ');
					return false;
				}
			}
			
			//날짜가 3군데 중 하나만 있을경우
			if(!Ext.isEmpty(shipFrDate) && !Ext.isEmpty(shipToDate)) {
				if(Ext.isEmpty(caFrDate) && !Ext.isEmpty(caToDate)) {
					Unilite.messageBox('시작~종료일은 필수입력항목입니다. ');
					return false;
				}
			}
			
			//날짜가 각 항목당 1개씩만 있는 경우
			if(!Ext.isEmpty(caFrDate) && Ext.isEmpty(caToDate)) {
				if(!Ext.isEmpty(shipFrDate) && Ext.isEmpty(shipToDate)) {
					Unilite.messageBox('시작~종료일은 필수입력항목입니다. ');
					return false;
				}
			}
			
			if(!Ext.isEmpty(caFrDate) && Ext.isEmpty(caToDate)) {
				if(Ext.isEmpty(shipFrDate) && !Ext.isEmpty(shipToDate)) {
					Unilite.messageBox('시작~종료일은 필수입력항목입니다. ');
					return false;
				}
			}
			
			if(Ext.isEmpty(caFrDate) && !Ext.isEmpty(caToDate)) {
				if(!Ext.isEmpty(shipFrDate) && Ext.isEmpty(shipToDate)) {
					Unilite.messageBox('시작~종료일은 필수입력항목입니다. ');
					return false;
				}
			}
			
			if(Ext.isEmpty(caFrDate) && !Ext.isEmpty(caToDate)) {
				if(Ext.isEmpty(shipFrDate) && !Ext.isEmpty(shipToDate)) {
					Unilite.messageBox('시작~종료일은 필수입력항목입니다. ');
					return false;
				}
			}
			
			
			
			
			//날짜가 각 항목당 1개씩만 있는 경우
			if(!Ext.isEmpty(shipFrDate) && Ext.isEmpty(shipFrDate)) {
				if(!Ext.isEmpty(caFrDate) && Ext.isEmpty(caToDate)) {
					Unilite.messageBox('시작~종료일은 필수입력항목입니다. ');
					return false;
				}
			}
			
			if(!Ext.isEmpty(shipFrDate) && Ext.isEmpty(shipFrDate)) {
				if(Ext.isEmpty(caFrDate) && !Ext.isEmpty(caToDate)) {
					Unilite.messageBox('시작~종료일은 필수입력항목입니다. ');
					return false;
				}
			}
			
			if(Ext.isEmpty(shipFrDate) && !Ext.isEmpty(shipFrDate)) {
				if(!Ext.isEmpty(caFrDate) && Ext.isEmpty(caToDate)) {
					Unilite.messageBox('시작~종료일은 필수입력항목입니다. ');
					return false;
				}
			}
			
			if(Ext.isEmpty(shipFrDate) && !Ext.isEmpty(shipFrDate)) {
				if(Ext.isEmpty(caFrDate) && !Ext.isEmpty(caToDate)) {
					Unilite.messageBox('시작~종료일은 필수입력항목입니다. ');
					return false;
				}
			}
			
			
			
			
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {       // 초기화
            panelSearch.clearForm();
            panelResult.clearForm();
            masterGrid.reset();
            directMasterStore.clearData();
            this.fnInitBinding();
        },
		onNewDataButtonDown : function(additemCode)	{        	 
//        	 var moneyUnit = UserInfo.currency;
//        	 var saleDate = UniDate.get('today');
//        	 var itemCode = '';
//        	 if(!Ext.isEmpty(additemCode)){
//        	 	itemCode = additemCode
//        	 }
        	 var r = {
//				MONEY_UNIT: moneyUnit,
//				SALE_DATE: saleDate,
//				DIV_CODE: panelSearch.getValue('DIV_CODE'),
//				ITEM_CODE: itemCode
	        };	        
			masterGrid.createRow(r);
			//openDetailWindow(null, true);
		},
		/**
		 *  삭제
		 *	@param 
		 *	@return
		 */
		 onDeleteDataButtonDown: function() {
			if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
			}
		},
		/**
		 *  저장
		 *	@param 
		 *	@return
		 */
		onSaveDataButtonDown: function (config) {
//			var rtnrecord = masterGrid.getSelectedRecord();
//			if(!Ext.isEmpty(rtnrecord)){
//				if(Ext.isEmpty(rtnrecord.get('SALE_DATE'))){
//					rtnrecord.set('SALE_DATE', UniDate.get('today'))
//				}
//			}			
			directMasterStore.saveStore(config);	
		}/*,
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}*/
	}); //End of Unilite.Main( {
};
</script>