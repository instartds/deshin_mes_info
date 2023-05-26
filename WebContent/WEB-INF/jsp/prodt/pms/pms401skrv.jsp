<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="pms401skrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->  
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 -->    
	<t:ExtComboStore comboType="AU" comboCode="Z001"  /> 	<!-- 작업라인 -->  
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

	Unilite.defineModel('Pms401skrvModel', {
	    fields: [  	  
	    	{name: 'INSPEC_DATE'        , text: '<t:message code="system.label.product.inspecdate" default="검사일"/>'    	,type:'uniDate'},
		    {name: 'INSPEC_NUM'         , text: '<t:message code="system.label.product.inspecno" default="검사번호"/>'		,type:'string'},
		    {name: 'INSPEC_SEQ'         , text: '<t:message code="system.label.product.inspecseq" default="검사순번"/>'  	,type:'string'},
		    {name: 'INSPEC_MON'         , text: '<t:message code="system.label.product.inspecmonth" default="검사월"/>'    	,type:'uniDate'},
		    {name: 'WORK_SHOP_CODE'     , text: '<t:message code="system.label.product.mainworkcenter" default="주작업장"/>'	,type:'string'},
		    {name: 'WORK_SHOP_NAME'     , text: '<t:message code="system.label.product.workcentername" default="작업장명"/>'  	,type:'string'},
		    {name: 'ITEM_CODE'          , text: '<t:message code="system.label.product.item" default="품목"/>'  	,type:'string'},
		    {name: 'ITEM_NAME'          , text: '<t:message code="system.label.product.itemname" default="품목명"/>'    	,type:'string'},
		    {name: 'SPEC'               , text: '<t:message code="system.label.product.spec" default="규격"/>'      	,type:'string'},
		    {name: 'INSPEC_TYPE'	    , text: '<t:message code="system.label.product.inspectype" default="검사유형"/>'		,type:'string'},
		    {name: 'INSPEC_METHOD'	    , text: '<t:message code="system.label.product.inspectype" default="검사유형"/>'		,type:'string'},
		    {name: 'RECEIPT_Q'		    , text: '<t:message code="system.label.product.receiptqty2" default="접수량"/>'		,type:'uniQty'},
		    {name: 'INSPEC_Q'           , text: '<t:message code="system.label.product.inspecqty" default="검사량"/>'    	,type:'uniQty'},
		    {name: 'GOOD_INSPEC_Q'      , text: '<t:message code="system.label.product.gooditemqty" default="양품량"/>'    	,type:'uniQty'},
		    {name: 'BAD_INSPEC_Q'       , text: '<t:message code="system.label.product.defectqty" default="불량수량"/>'  	,type:'uniQty'},
		    {name: 'BAD_RATE'           , text: '<t:message code="system.label.product.defectrate" default="불량률"/>'    	,type:'uniQty'},
		    {name: 'BAD_INSPEC_CODE'	, text: '<t:message code="system.label.product.inspectcode" default="검사코드"/>'  	,type:'string'},
		    {name: 'BAD_INSPEC_NAME'    , text: '<t:message code="system.label.product.inspectsubject" default="검사항목"/>'  	,type:'string'},
		    {name: 'BAD_SPEC'	        , text: '<t:message code="system.label.product.spec" default="규격"/>'      	,type:'string'},
		    {name: 'MEASURED_VALUE'     , text: '<t:message code="system.label.product.mesuredvalue" default="측정치"/>'    	,type:'string'},
		    {name: 'REMARK'             , text: '<t:message code="system.label.product.remarks" default="비고"/>'      	,type:'string'}
	    ]
	});
	
	/*// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }*/
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('pms401skrvMasterStore1',{
		model: 'Pms401skrvModel',
		uniOpt: {
            isMaster: true,		// 상위 버튼 연결 
            editable: false,		// 수정 모드 사용 
            deletable: false,		// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
                read: 'pms401skrvService.selectList'                	
            }
        },
        loadStoreRecords: function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},groupField: 'INSPEC_DATE'
	});


	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        listeners: {
	        collapse: function () {
	            topSearch.show();
	        },
	        expand: function() {
	        	topSearch.hide();
	        }
        },
		items: [{	
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
			    fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
			    name:'DIV_CODE', 
			    xtype: 'uniCombobox', 
			    comboType:'BOR120' ,
			    allowBlank:false,
			    value : UserInfo.divCode,
			    listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							topSearch.setValue('DIV_CODE', newValue);
						}
					}
			},{ 
			    fieldLabel: '<t:message code="system.label.product.inspecdate" default="검사일"/>',
				xtype: 'uniDateRangefield', 
				startFieldName: 'INSPEC_DATE_FR',
				endFieldName: 'INSPEC_DATE_TO',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('yesterday'),
				allowBlank:false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(topSearch) {
							topSearch.setValue('INSPEC_DATE_FR',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
							
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(topSearch) {
				    		topSearch.setValue('INSPEC_DATE_TO',newValue);
				    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
				    	}
				    }
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name:'WORK_SHOP_CODE', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('wsList'),
				listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							topSearch.setValue('WORK_SHOP_CODE', newValue);
						}
					}
			}, 
				Unilite.popup('DIV_PUMOK',{ 
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
					validateBlank:false,
	        		listeners: {
						onSelected: {
							fn: function(records, type) {
								topSearch.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
								topSearch.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							topSearch.setValue('ITEM_CODE', '');
							topSearch.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			})]
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
    });    
    
    var topSearch = Unilite.createSimpleForm('topSearchForm', {
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
			    fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
			    name:'DIV_CODE', 
			    xtype: 'uniCombobox', 
			    comboType:'BOR120' ,
			    allowBlank:false,
			    value : UserInfo.divCode,
			    listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{ 
			    fieldLabel: '<t:message code="system.label.product.inspecdate" default="검사일"/>',
				xtype: 'uniDateRangefield', 
				startFieldName: 'INSPEC_DATE_FR',
				endFieldName: 'INSPEC_DATE_TO',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('yesterday'),
				allowBlank:false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelSearch.setValue('INSPEC_DATE_FR',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
						
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('INSPEC_DATE_TO',newValue);
			    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name:'WORK_SHOP_CODE', 
				xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('wsList'),
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
					}
				}
			}, 
				Unilite.popup('DIV_PUMOK',{ 
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
					validateBlank:false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ITEM_CODE', topSearch.getValue('ITEM_CODE'));
								panelSearch.setValue('ITEM_NAME', topSearch.getValue('ITEM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ITEM_CODE', '');
							panelSearch.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						}
					}
			})]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('pms401skrvGrid1', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore1, 
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
/*        tbar: [{
        	text:'상세보기',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],*/
    	features: [ 
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: true} 
    	],
        columns: [  
        	{dataIndex: 'INSPEC_DATE'       , width: 73, locked: true,
	        	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			        return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.product.totalamount" default="합계"/>');
	            }}, 	
			{dataIndex: 'INSPEC_NUM'        , width: 120, locked: true}, 				
			{dataIndex: 'INSPEC_SEQ'        , width: 66}, 				
			{dataIndex: 'INSPEC_MON'        , width: 66}, 				
			{dataIndex: 'WORK_SHOP_CODE'    , width: 80}, 				
			{dataIndex: 'WORK_SHOP_NAME'    , width: 133}, 				
			{dataIndex: 'ITEM_CODE'         , width: 86}, 				
			{dataIndex: 'ITEM_NAME'         , width: 153}, 				
			{dataIndex: 'SPEC'              , width: 80}, 				
			{dataIndex: 'INSPEC_TYPE'	    , width: 80}, 				
			{dataIndex: 'INSPEC_METHOD'	    , width: 80}, 				
			{dataIndex: 'RECEIPT_Q'		    , width: 106 , summaryType: 'sum'}, 				
			{dataIndex: 'INSPEC_Q'          , width: 120 , summaryType: 'sum'}, 				
			{dataIndex: 'GOOD_INSPEC_Q'     , width: 120 , summaryType: 'sum'}, 				
			{dataIndex: 'BAD_INSPEC_Q'      , width: 120 , summaryType: 'sum'}, 				
			{dataIndex: 'BAD_RATE'          , width: 66  , summaryType: 'sum'}, 				
			{dataIndex: 'BAD_INSPEC_CODE'	, width: 106}, 				
			{dataIndex: 'BAD_INSPEC_NAME'   , width: 106}, 				
			{dataIndex: 'BAD_SPEC'	        , width: 106}, 				
			{dataIndex: 'MEASURED_VALUE'    , width: 106}, 				
			{dataIndex: 'REMARK'            , width: 133, hidden: true} 				
		] 
    });

    Unilite.Main( {
		borderItems:[{
         region:'center',
         layout: 'border',
         border: false,
         items:[
            masterGrid1, topSearch
         ]
      },
         panelSearch
      ],	
		id: 'pms401skrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
			
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			topSearch.setValue('DIV_CODE', UserInfo.divCode);
			
			panelSearch.setValue('INSPEC_DATE_FR', UniDate.get('startOfMonth'));
			topSearch.setValue('INSPEC_DATE_FR', UniDate.get('startOfMonth'));
			
			panelSearch.setValue('INSPEC_DATE_TO', UniDate.get('yesterday'));
			topSearch.setValue('INSPEC_DATE_TO', UniDate.get('yesterday'));
		},
		onQueryButtonDown : function()	{		
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			
			masterGrid1.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset', true); 
			}
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.reset();
			masterGrid1.reset();
			topSearch.reset();
			this.fnInitBinding();
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});
};


</script>
