<%--
'   프로그램명 : MRP전환(부분) (구매자재)
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
<t:appConfig pgmId="mrp146ukrv">
	
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B014" /> <!-- 조달구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!-- 품목계정 -->
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
	Unilite.defineModel('Mrp146ukrvModel', {
	    fields: [  	
	    	{name: 'FLAG'   				,text:'FLAG'		,type:'string'},
	    	{name: 'MRP_STATUS'				,text:'<t:message code="system.label.purchase.status" default="상태"/>'			,type:'string',comboType:'AU',comboCode:'M401'},
	    	{name: 'MRP_STATUS_NAME'		,text:'<t:message code="system.label.purchase.status" default="상태"/>'			,type:'string'},
	    	{name: 'ITEM_CODE'		    	,text:'<t:message code="system.label.purchase.itemcode" default="품목코드"/>'		,type:'string'},
	    	{name: 'ITEM_NAME'		    	,text:'<t:message code="system.label.purchase.itemname2" default="품명"/>'			,type:'string'},
	    	{name: 'SPEC'		    		,text:'<t:message code="system.label.purchase.spec" default="규격"/>'			,type:'string'},
	    	{name: 'ORDER_PLAN_DATE'   		,text:'<t:message code="system.label.purchase.startdate" default="시작일"/>'		,type:'uniDate'},
	    	{name: 'BASIS_DATE'				,text:'<t:message code="system.label.purchase.enddate" default="종료일"/>'		,type:'uniDate'},
	    	{name: 'ORDER_PLAN_Q'	    	,text:'<t:message code="system.label.purchase.planqty" default="계획량"/>'		,type:'uniQty'},
	    	{name: 'STOCK_UNIT'				,text:'<t:message code="system.label.purchase.unit" default="단위"/>'		 	,type:'string'},
	    	{name: 'SUPPLY_TYPE'		    ,text:'<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'		,type:'string',comboType:'AU',comboCode:'B014'},
	    	{name: 'SUPPLY_TYPE_NAME'		,text:'<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>'	    ,type:'string'},
	    	{name: 'ITEM_ACCOUNT'		    ,text:'<t:message code="system.label.purchase.itemaccount" default="품목계정"/>'		,type:'string',comboType:'AU',comboCode:'B020'},
	    	{name: 'DOM_FORIGN'		        ,text:'<t:message code="system.label.purchase.domforigntype" default="내/외자 구분"/>'	,type:'string',comboType:'AU',comboCode:'B019'},
	    	{name: 'DOM_FORIGN_NAME'		,text:'<t:message code="system.label.purchase.domforigntype" default="내/외자 구분"/>'	,type:'string'},
	    	{name: 'WK_PLAN_NUM'		   	,text:'<t:message code="system.label.purchase.productionplanno" default="생산계획번호"/>'	,type:'string'},
	    	{name: 'PROJECT_NO'				,text:'<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'	,type:'string'},
	    	{name: 'INT_YN'					,text:'<t:message code="system.label.purchase.unityncode" default="통합여부코드"/>'	,type:'string',comboType:'AU',comboCode:'B010'},
	    	{name: 'DIV_CODE'				,text:'<t:message code="system.label.purchase.division" default="사업장"/>'		,type:'string'},
	    	{name: 'MRP_CONTROL_NUM'   		,text:'MRP<t:message code="system.label.purchase.projectno" default="프로젝트번호"/>'	,type:'string'},
	    	{name: 'ITEM_CHECK'				,text:'Item Check'	,type:'string'},
	    	// 생산계획번호
	    	{name: 'WK_PLAN_NUM'			,text:'<t:message code="system.label.purchase.productionplanno" default="생산계획번호"/>'	,type:'string'},
	    	{name: 'PRODT_PLAN_DATE'		,text:'<t:message code="system.label.purchase.plandate" default="계획일"/>'		,type:'uniDate'},
	    	{name: 'WK_PLAN_Q'				,text:'<t:message code="system.label.purchase.planqty" default="계획량"/>'		,type:'uniQty'},
	    	{name: 'CHK'   					,text:'<t:message code="system.label.purchase.selection" default="선택"/>'			,type:'boolean'},
            {name: 'CHECK_YN'               ,text:'CHECK_YN'    ,type:'string'}
		]
	});		// end of Unilite.defineModel('Mrp146ukrvModel', {

	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read    : 'mrp146ukrvService.selectList1',
			update  : 'mrp146ukrvService.updateDetail',
			syncAll : 'mrp146ukrvService.saveAll'
		}
	});	
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read    : 'mrp146ukrvService.selectList2',
			update  : 'mrp146ukrvService.updateDetail',
			syncAll : 'mrp146ukrvService.saveAll'
		}
	});	
	
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read    : 'mrp146ukrvService.selectList3',
			update  : 'mrp146ukrvService.updateDetail',
			syncAll : 'mrp146ukrvService.saveAll'
		}
	});		
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('mrp146ukrvMasterStore1',{
			model: 'Mrp146ukrvModel',
			autoLoad: false,
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy1
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('mrp146ukrvForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});				
			}
			,saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
	        	var toUpdate = this.getUpdatedRecords();
	        	console.log("toUpdate",toUpdate);
	        	var rv = true;
	   			var paramMaster= panelSearch.getValues();
				if(inValidRecs.length == 0 )	{										
				config = {
					params: [paramMaster],
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);	
						UniAppManager.app.onQueryButtonDown();
					 } 
				};					
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
			},
			groupField: ''			
	});		// end of var directMasterStore1 = Unilite.createStore('mrp146ukrvMasterStore1',{
	
	var directMasterStore2 = Unilite.createStore('mrp146ukrvMasterStore2',{
			model: 'Mrp146ukrvModel',
			autoLoad: false,
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy2
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('mrp146ukrvForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});				
			}
			,saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
	        	var toUpdate = this.getUpdatedRecords();
	        	console.log("toUpdate",toUpdate);
	        	var rv = true;
	   			var paramMaster= panelSearch.getValues();
				if(inValidRecs.length == 0 )	{										
				config = {
					params: [paramMaster],
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);	
						UniAppManager.app.onQueryButtonDown();
					 } 
				};					
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
			},	
			groupField: ''			
	});		// end of var directMasterStore2 = Unilite.createStore('mrp146ukrvMasterStore2',{
	
	var directMasterStore3 = Unilite.createStore('mrp146ukrvMasterStore3',{
			model: 'Mrp146ukrvModel',
			autoLoad: false,
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy3
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('mrp146ukrvForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});				
			}
			,saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
	        	var toUpdate = this.getUpdatedRecords();
	        	console.log("toUpdate",toUpdate);
	        	var rv = true;
	   			var paramMaster= panelSearch.getValues();
				if(inValidRecs.length == 0 )	{										
				config = {
					params: [paramMaster],
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);	
						UniAppManager.app.onQueryButtonDown();
					 } 
				};					
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
			},			
			groupField: ''			
	});		// end of var directMasterStore3 = Unilite.createStore('mrp146ukrvMasterStore3',{	

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    var panelSearch = Unilite.createSearchPanel('mrp146ukrvForm', {		
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
		    	name:'DIV_CODE',
		    	xtype: 'uniCombobox', 
		    	comboType:'BOR120', 
		    	allowBlank:false,
		    	value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
	    	},{
	    		fieldLabel: '<t:message code="system.label.purchase.startdate" default="시작일"/>',
	    		xtype: 'uniDateRangefield',
	    		startFieldName: 'ORDER_DATE_FR',
	    		endFieldName: 'ORDER_DATE_TO',
	    		//startDate: U0niDate.get('startOfMonth'),
	    		//endDate: UniDate.get('today'),
	    		//allowBlank:false,
	    		width:315,
	    		onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('ORDER_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ORDER_DATE_TO',newValue);
			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>',
				name: 'SUPPLY_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU', 
				comboCode: 'B014',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SUPPLY_TYPE', newValue);
					}
				}
			},{
	        	fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
	        	name:'ITEM_ACCOUNT',
	        	xtype: 'uniCombobox', 
	        	comboType:'AU',
	        	comboCode:'B020',
		    	listeners: {
					change: function(combo, newValue, oldValue, eOpts) {
					panelResult.setValue('ITEM_ACCOUNT', newValue);
					}
				}
   			},
            	Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
					valueFieldName:'ITEM_CODE_FR',
			    	textFieldName:'ITEM_NAME_FR',
			    	allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
			    	listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelResult.setValue('ITEM_CODE_FR', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_NAME_FR', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('ITEM_NAME_FR', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_CODE_FR', '');
								}
							},
							applyextparam: function(popup){
	      						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
	     					}
					}
			}),			
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '~',
					valueFieldName:'ITEM_CODE_TO',
			    	textFieldName:'ITEM_NAME_TO',
			    	allowBlank:true,	// 2021.08 표준화 작업
					autoPopup:false,	// 2021.08 표준화 작업
					validateBlank:false,// 2021.08 표준화 작업
			    	listeners: {
							onValueFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelResult.setValue('ITEM_CODE_TO', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_NAME_TO', '');
								}
							},
							onTextFieldChange: function(field, newValue, oldValue){	// 2021.08 표준화 작업
								panelSearch.setValue('ITEM_NAME_TO', newValue);
								if(!Ext.isObject(oldValue)) {
									panelSearch.setValue('ITEM_CODE_TO', '');
								}
							},
							applyextparam: function(popup){
	      						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
	     					}
					}
			}),
			{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.purchase.status" default="상태"/>',						            		
				//id: 'CONFIRM_TYPE',
				items: [{
					boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>', 
					width:60, 
					name: 'STATUS', 
					inputValue: '', 
					checked: true
				},{
					boxLabel: 'OPEN', 
					width:60, 
					name: 'STATUS', 
					inputValue: '1'
				},{
					boxLabel: '<t:message code="system.label.purchase.convert" default="전환"/>', 
					width:60, 
					name: 'STATUS', 
					inputValue: '2'
				}],
				listeners: {
                    change: function(field, newValue, oldValue, eOpts) {            
                        panelResult.getField('STATUS').setValue(newValue.STATUS);
                        UniAppManager.app.onQueryButtonDown();
                    }
                }
			}]
		},	
			{	
			title: '<t:message code="system.label.purchase.etcinfo" default="기타정보"/>', 	
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',	
		    	items: [{   				
			    			fieldLabel: '<t:message code="system.label.purchase.mrpcontrolnum" default="MRP 전개번호"/>',
			    			name:'MRP_CONTROL_NUM',
			    			xtype: 'uniTextfield',
			    			readOnly:true
		    			},{					
			    			fieldLabel: 'MRP <t:message code="system.label.purchase.charger" default="담당자"/>',
			    			name:'PLAN_PRSN',
			    			xtype: 'uniTextfield',
			    			readOnly:true
		    			},{					
			    			fieldLabel: '<t:message code="system.label.purchase.basisdate" default="기준일"/>',
			    			name:'BASE_DATE',
			    			xtype: 'uniDatefield',
		    				readOnly:true
		    			},{					
			    			fieldLabel: '<t:message code="system.label.purchase.confirmdate" default="확정일"/>',
			    			name:'FIRM_DATE',
			    			xtype: 'uniDatefield',
			    			readOnly:true
			    		},{					
			    			fieldLabel: '<t:message code="system.label.purchase.forecastdate" default="예시일"/>',
			    			name:'PLAN_DATE',
			    			xtype: 'uniDatefield',
			    			readOnly:true
			    		},{
						    xtype: 'radiogroup',
						    id: 'rdoSelect1',
						    fieldLabel: '<t:message code="system.label.purchase.availableinventoryapply" default="가용재고 반영"/>',
						    items : [{
						    	boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>',
						    	name: 'EXC_STOCK_YN',
						    	inputValue: 'Y',
						    	readOnly:true,
						    	width:80
						    }, {
						    	boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>',
						    	name: 'EXC_STOCK_YN' ,
						    	inputValue: 'N',
						    	readOnly:true,
						    	width:80
					    	    //checked: true
					    	}]				
						},{
						    xtype: 'radiogroup',
						    id: 'rdoSelect2',
						    fieldLabel: '<t:message code="system.label.purchase.onhandstockapply" default="현재고 반영"/>',
						    items : [{
						    	boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>',
						    	name: 'STOCK_YN',
						    	inputValue: 'Y',
						    	readOnly:true,
						    	width:80
						    }, {
						    	boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>',
						    	name: 'STOCK_YN' ,
						    	inputValue: 'N',
						    	readOnly:true,
						    	width:80
						    }]				
						},{
						    xtype: 'radiogroup',
						    id: 'rdoSelect3',
						    fieldLabel: '<t:message code="system.label.purchase.safetystockapply" default="안전재고 반영"/>',
						    items : [{
						    	boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>',
						    	name: 'SAFE_STOCK_YN',
						    	inputValue: 'Y',
						    	readOnly:true,
						    	width:80
						    }, {
						    	boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>',
						    	name: 'SAFE_STOCK_YN' ,
						    	inputValue: 'N',
						    	readOnly:true,
						    	width:80
						    }]				
						},{
						    xtype: 'radiogroup',
						    id: 'rdoSelect8',
						    fieldLabel: '<t:message code="system.label.purchase.substockapply" default="외주재고 반영"/>',
						    items : [{
						    	boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>',
						    	name: 'CUSTOM_STOCK_YN',
						    	inputValue: 'Y',
						    	readOnly:true,
						    	width:80
						    }, {
						    	boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>',
						    	name: 'CUSTOM_STOCK_YN' ,
						    	inputValue: 'N',
						    	readOnly:true,
						    	width:80
						    }]				
						},{
						    xtype: 'radiogroup',
						    id: 'rdoSelect4',
						    fieldLabel: '<t:message code="system.label.purchase.receiptplannedapply" default="입고예정 반영"/>',
						    items : [{
						    	boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>',
						    	name: 'INSTOCK_PLAN_YN',
						    	inputValue: 'Y',
						    	readOnly:true,
						    	width:80
						    }, {
						    	boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>',
						    	name: 'INSTOCK_PLAN_YN' ,
						    	inputValue: 'N',
						    	readOnly:true,
						    	width:80
						    }]				
						},{
						    xtype: 'radiogroup',
						    id: 'rdoSelect5',
						    fieldLabel: '<t:message code="system.label.purchase.issueresevationapply" default="출고예정 반영"/>',
						    items : [{
						    	boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>',
						    	name: 'OUTSTOCK_PLAN_YN',
						    	inputValue: 'Y',
						    	readOnly:true,
						    	width:80
						    }, {
						    	boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>',
						    	name: 'OUTSTOCK_PLAN_YN' ,
						    	inputValue: 'N',
						    	readOnly:true,
						    	width:80
						    }]				
						},{
						    xtype: 'radiogroup',
						    id: 'rdoSelect7',
						    fieldLabel: '<t:message code="system.label.purchase.uncertainorderapply" default="미확정오더 반영"/>',
						    items : [{
						    	boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>',
						    	name: 'PLAN_YN',
						    	inputValue: 'Y',
						    	readOnly:true,
						    	width:80
						    }, {
						    	boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>',
						    	name: 'PLAN_YN' ,
						    	inputValue: 'N',
						    	readOnly:true,
						    	width:80
						    }]				
						}	
			]
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
	
					   	alert(labelText+'<t:message code="system.message.purchase.datacheck001" default="필수입력 항목입니다."/>');
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
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{	    
		    	fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
		    	name:'DIV_CODE',
		    	xtype: 'uniCombobox', 
		    	comboType:'BOR120', 
		    	allowBlank:false,
		    	value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
	    	},{
	    		fieldLabel: '<t:message code="system.label.purchase.startdate" default="시작일"/>',
	    		xtype: 'uniDateRangefield',
	    		startFieldName: 'ORDER_DATE_FR',
	    		endFieldName: 'ORDER_DATE_TO',
	    		//startDate: UniDate.get('startOfMonth'),
	    		//endDate: UniDate.get('today'),
	    		//allowBlank:false,
	    		width:315,
	    		onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('ORDER_DATE_FR',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('ORDER_DATE_TO',newValue);
			    	}
			    }
			},{
				fieldLabel: '<t:message code="system.label.purchase.procurementclassification" default="조달구분"/>',
				name: 'SUPPLY_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU', 
				comboCode: 'B014',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SUPPLY_TYPE', newValue);
					}
				}
			},{
		        	fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
		        	name:'ITEM_ACCOUNT',
		        	xtype: 'uniCombobox', 
		        	comboType:'AU',
		        	comboCode:'B020',
		        	listeners: {
						change: function(combo, newValue, oldValue, eOpts) {
							panelSearch.setValue('ITEM_ACCOUNT', newValue);
						}
					}
	   		}
	   		,
/*            	Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.purchase.itemcode" default="품목코드"/>',
					validateBlank:false,
					valueFieldName:'ITEM_CODE_FR',
			    	textFieldName:'ITEM_NAME_FR',
			    	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ITEM_CODE_FR', panelResult.getValue('ITEM_CODE_FR'));
								panelSearch.setValue('ITEM_NAME_FR', panelResult.getValue('ITEM_NAME_FR'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ITEM_CODE_FR', '');
							panelSearch.setValue('ITEM_NAME_FR', '');
						},
						applyextparam: function(popup){
      						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
     					}
					}
			}),			
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '~',
					validateBlank:false,
					valueFieldName:'ITEM_CODE_TO',
			    	textFieldName:'ITEM_NAME_TO',
			    	listeners: {
						onSelected: {
							fn: function(records, type) {
								panelSearch.setValue('ITEM_CODE_TO', panelResult.getValue('ITEM_CODE_TO'));
								panelSearch.setValue('ITEM_NAME_TO', panelResult.getValue('ITEM_NAME_TO'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelSearch.setValue('ITEM_CODE_TO', '');
							panelSearch.setValue('ITEM_NAME_TO', '');
						},
						applyextparam: function(popup){
      						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
     					}
					}
			}),*/
			{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.purchase.status" default="상태"/>',						            		
				//id: 'CONFIRM_TYPE',
				items: [{
					boxLabel: '<t:message code="system.label.purchase.whole" default="전체"/>', 
					width:60, 
					name: 'STATUS', 
					inputValue: '', 
					checked: true
				},{
					boxLabel: 'OPEN', 
					width:60, 
					name: 'STATUS', 
					inputValue: '1'
				},{
					boxLabel: '<t:message code="system.label.purchase.convert" default="전환"/>', 
					width:60, 
					name: 'STATUS', 
					inputValue: '2'
				}],
				listeners: {
                    change: function(field, newValue, oldValue, eOpts) {            
                        panelSearch.getField('STATUS').setValue(newValue.STATUS);
                    }
                }
			}]
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
    
	
    /**
     * Master Grid1,2,3 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('mrp146ukrvMasterGrid1', {
    	// for tab 
    	//title: 'Open 오더별',
        layout : 'fit',
        region: 'center',
        selModel: Ext.create('Ext.selection.CheckboxModel', {
			checkOnly : true, 
			toggleOnClick:false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
    				selectRecord.set('FLAG', 'N');
    				
    				UniAppManager.setToolbarButtons(['save'], true);
    			},
	    		deselect:  function(grid, selectRecord, index, eOpts ){
	    			selectRecord.set('FLAG', '0');;
	    		}
			}
		}),	
        uniOpt: {
//    		useGroupSummary: false,
//    		useLiveSearch: false,
			useContextMenu: true,
			useMultipleSorting: true,
//			useRowNumberer: false,
//			expandLastColumn: false,
			onLoadSelectFirst : false
//    		filter: {
//				useFilter: false,
//				autoCreate: false
//			}
        },
//        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
//    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
    	store: directMasterStore1,
        columns: [
//			{ dataIndex: 'CHK'					, 	width: 36, xtype : 'checkcolumn', locked : true},
        	{ dataIndex: 'FLAG'  			  	,	width:40, hidden:true},
        	{ dataIndex: 'MRP_STATUS'	  		, 	width:73, locked : true},
        	//{ dataIndex: 'MRP_STATUS_NAME' 		, 	width:73, locked : true},
        	{ dataIndex: 'ITEM_CODE'		    ,   width: 100, locked : true},
        	{ dataIndex: 'ITEM_NAME'		    ,   width: 153, locked : true},   
        	{ dataIndex: 'SPEC'		    		,   width: 133},        	
        	{ dataIndex: 'ORDER_PLAN_DATE'   	,   width: 80},
        	{ dataIndex: 'BASIS_DATE'		   	,   width: 80},
        	{ dataIndex: 'ORDER_PLAN_Q'	    	,   width: 93},
			{ dataIndex: 'STOCK_UNIT'			,	width: 66, align: 'center' },
			{ dataIndex: 'SUPPLY_TYPE'		   	,   width: 73, align: 'center' },
			{ dataIndex: 'ITEM_ACCOUNT'		   	,   width: 80, align: 'center' },
			//{ dataIndex: 'SUPPLY_TYPE_NAME'		,   width: 73},
			{ dataIndex: 'DOM_FORIGN'		   	,   width: 70, align: 'center' },
			//{ dataIndex: 'DOM_FORIGN_NAME'		,   width: 70},
			{ dataIndex: 'WK_PLAN_NUM'	  		, 	width:133},
			{ dataIndex: 'PROJECT_NO'		  	, 	width:133},
			{ dataIndex: 'INT_YN'		  		, 	width:66},
			{ dataIndex: 'DIV_CODE'			  	, 	width:0, hidden: true},
			{ dataIndex: 'MRP_CONTROL_NUM'   	,   width: 100},
			{ dataIndex: 'ITEM_CHECK'			,   width: 100},
			{ dataIndex: 'CHECK_YN'             ,   width: 100/*, hidden : true*/}
		], 
        listeners: {
            beforeedit  : function( editor, e, eOpts ) {
            	if(e.record.data.MRP_STATUS == "1"){
                    if (UniUtils.indexOf(e.field, ['ORDER_PLAN_DATE','BASIS_DATE','SUPPLY_TYPE'])) {
                    	return true;
                    }
                    else {
                    	return false;
                    }
            	}
            	else{
            		return false;
            	}
            }
        }
    }); 		// end of var masterGrid1 = Unilite.createGrid('mrp146ukrvGrid1', {  

    var masterGrid2 = Unilite.createGrid('mrp146ukrvMasterGrid2', {
    	// for tab 
    	//title: '생산계획별',
        layout : 'fit',
        region: 'center',	
        uniOpt: {
//    		useGroupSummary: false,
//    		useLiveSearch: false,
//			useContextMenu: true,
			useMultipleSorting: true,
//			useRowNumberer: false,
			expandLastColumn: false,
			onLoadSelectFirst : false
//    		filter: {
//				useFilter: false,
//				autoCreate: false
//			}
        },
    	features: [ {id : 'masterGridSubTotal2', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal2', 	ftype: 'uniSummary', 	  showSummaryRow: false} 
    	],
    	store: directMasterStore2,
        columns: [
        	{ dataIndex: 'FLAG'  			  	,	width:40, hidden:true},
        	{ dataIndex: 'MRP_STATUS'	  		, 	width:73, locked : true},
        	/*{ dataIndex: 'MRP_STATUS_NAME' 		, 	width:73, locked : true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.purchase.total" default="총계"/>');
            }},*/
        	{ dataIndex: 'WK_PLAN_NUM' 			, 	width:130, locked : true},
        	{ dataIndex: 'PRODT_PLAN_DATE' 		, 	width:90, locked : true},
        	{ dataIndex: 'WK_PLAN_Q' 			, 	width:90, locked : true},
//        	{ columns:[{dataIndex: 'CHK'		, 	width: 26, xtype : 'checkcolumn', locked : true}
//						]},
//        	{ dataIndex: 'CHK'					, 	width: 36, xtype : 'checkcolumn', locked : true},
        	{ dataIndex: 'ITEM_CODE'		    ,   width: 100},
        	{ dataIndex: 'ITEM_NAME'		    ,   width: 153},   
        	{ dataIndex: 'SPEC'		    		,   width: 133},        	
        	{ dataIndex: 'ORDER_PLAN_DATE'   	,   width: 90},
        	{ dataIndex: 'BASIS_DATE'		   	,   width: 90},
        	{ dataIndex: 'ORDER_PLAN_Q'	    	,   width: 93},
			{ dataIndex: 'STOCK_UNIT'			,	width: 66, align: 'center' },
			{ dataIndex: 'SUPPLY_TYPE'		   	,   width: 73, align: 'center' },
			{ dataIndex: 'ITEM_ACCOUNT'		   	,   width: 80, align: 'center' },
			//{ dataIndex: 'SUPPLY_TYPE_NAME'		,   width: 73, hidden:true},
			{ dataIndex: 'DOM_FORIGN'		   	,   width: 90, align: 'center' },
			//{ dataIndex: 'DOM_FORIGN_NAME'		,   width: 70, hidden:true},
			{ dataIndex: 'PROJECT_NO'		  	, 	width:133},
			{ dataIndex: 'INT_YN'		  		, 	width:90},
			{ dataIndex: 'DIV_CODE'			  	, 	width:0, hidden: true},
            { dataIndex: 'CHECK_YN'             ,   width: 100/*, hidden : true*/}
		],
        selModel: Ext.create('Ext.selection.CheckboxModel', {
			checkOnly : false, 
			toggleOnClick:false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
    				selectRecord.set('FLAG', 'N');
    				
    				UniAppManager.setToolbarButtons(['save'], true);
    			},
	    		deselect:  function(grid, selectRecord, index, eOpts ){
	    			selectRecord.set('FLAG', '0');;
	    		}
			}
		}), 
        listeners: {
            beforeedit  : function( editor, e, eOpts ) {
                if(e.record.data.MRP_STATUS == "1"){
                    if (UniUtils.indexOf(e.field, ['ORDER_PLAN_DATE','BASIS_DATE','SUPPLY_TYPE'])) {
                        return true;
                    }
                    else {
                        return false;
                    }
                }
                else{
                    return false;
                }
            }
        }		
    }); 		// end of var masterGrid2 = Unilite.createGrid('mrp146ukrvGrid2', { 
    
    var masterGrid3 = Unilite.createGrid('mrp146ukrvMasterGrid3', {
    	// for tab 
    	//title: '관리번호별',
        layout : 'fit',
        region: 'center',	
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: false,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
			onLoadSelectFirst : false,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
//        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
//    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
    	store: directMasterStore3,
        columns: [
        	{ dataIndex: 'FLAG'  			  	,	width:40, hidden:true},
        	{ dataIndex: 'MRP_STATUS'	  		, 	width:73, locked : true},
        	//{ dataIndex: 'MRP_STATUS_NAME' 		, 	width:73, locked : true},
        	{ dataIndex: 'PROJECT_NO'		  	, 	width:133, locked : true},
        	{ dataIndex: 'WK_PLAN_NUM'	  		, 	width:133, locked : true},
        	{ dataIndex: 'PRODT_PLAN_DATE' 		, 	width:90, locked : true},
        	{ dataIndex: 'WK_PLAN_Q' 			, 	width:73, locked : true},
//        	{ columns:[{dataIndex: 'CHK'		, 	width: 26, xtype : 'checkcolumn', locked : true}
//						]},      
//        	{ dataIndex: 'CHK'					, 	width: 36, xtype : 'checkcolumn', locked : true},
        	{ dataIndex: 'ITEM_CODE'		    ,   width: 100},
        	{ dataIndex: 'ITEM_NAME'		    ,   width: 153},   
        	{ dataIndex: 'SPEC'		    		,   width: 133},        	
        	{ dataIndex: 'ORDER_PLAN_DATE'   	,   width: 80},
        	{ dataIndex: 'BASIS_DATE'		   	,   width: 80},
        	{ dataIndex: 'ORDER_PLAN_Q'	    	,   width: 93},
			{ dataIndex: 'STOCK_UNIT'			,	width: 66, align: 'center' },
			{ dataIndex: 'SUPPLY_TYPE'		   	,   width: 73, align: 'center' },
			{ dataIndex: 'ITEM_ACCOUNT'		   	,   width: 80, align: 'center' },
			//{ dataIndex: 'SUPPLY_TYPE_NAME'		,   width: 73, hidden:true},
			{ dataIndex: 'DOM_FORIGN'		   	,   width: 90, align: 'center' },
			//{ dataIndex: 'DOM_FORIGN_NAME'		,   width: 80, hidden:true},
			{ dataIndex: 'INT_YN'		  		, 	width:90},
			{ dataIndex: 'DIV_CODE'			  	, 	width:0, hidden: true},
            { dataIndex: 'CHECK_YN'             ,   width: 100/*, hidden : true*/}
		],
        selModel: Ext.create('Ext.selection.CheckboxModel', {
			checkOnly : false, 
			toggleOnClick:false,
			listeners: {
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
    				selectRecord.set('FLAG', 'N');
    				
    				UniAppManager.setToolbarButtons(['save'], true);
    			},
	    		deselect:  function(grid, selectRecord, index, eOpts ){
	    			selectRecord.set('FLAG', '0');;
	    		}
			}
		}), 
        listeners: {
            beforeedit  : function( editor, e, eOpts ) {
                if(e.record.data.MRP_STATUS == "1"){
                    if (UniUtils.indexOf(e.field, ['ORDER_PLAN_DATE','BASIS_DATE','SUPPLY_TYPE'])) {
                        return true;
                    }
                    else {
                        return false;
                    }
                }
                else{
                    return false;
                }
            }
        } 
    }); 		// end of var masterGrid = Unilite.createGrid('mrp146ukrvGrid1', {     
    
	var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab: 0,
	    region: 'center',
	    items: [
                 {
                     title: '<t:message code="system.label.purchase.openorderby" default="Open 오더별"/>'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[masterGrid1]
                     ,id: 'mrp146ukrvGrid1' 
                 },
                 {
                     title: '<t:message code="system.label.purchase.productionplanby" default="생산계획별"/>'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[masterGrid2]
                     ,id: 'mrp146ukrvGrid2' 
                 },
                 {
                     title: '<t:message code="system.label.purchase.managenoby" default="관리번호별"/>'
                     ,xtype:'container'
                     ,layout:{type:'vbox', align:'stretch'}
                     ,items:[masterGrid3]
                     ,id: 'mrp146ukrvGrid3' 
                 }
	    ],
		listeners : {
		  tabChange : function ( tabPanel, newCard, oldCard, eOpts )  {
				var newTabId = newCard.getId();
					console.log("newCard : " + newCard.getId());
					console.log("oldCard : " + oldCard.getId());
				switch(newTabId){
					case 'mrp146ukrvGrid1' :
	                    directMasterStore1.loadStoreRecords();
						break;						
					
					case 'mrp146ukrvGrid2' :    
	                    directMasterStore2.loadStoreRecords();
						break;			
					
					case 'mrp146ukrvGrid3' :
						directMasterStore3.loadStoreRecords();
						break;
					
					default:
						break;
				}
				
			}
	    }	    
	});
	
    Unilite.Main({
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
		id  : 'mrp146ukrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			
			var param= Ext.getCmp('mrp146ukrvForm').getValues();
			mrp146ukrvService.defaultSet(param, function(provider, response) {
				
				if(!Ext.isEmpty(provider[0])){
                   panelSearch.setValue('MRP_CONTROL_NUM',  provider[0].MRP_CONTROL_NUM);
                   panelSearch.setValue('PLAN_PSRN',        provider[0].PLAN_PSRN);
                   panelSearch.setValue('BASE_DATE',        provider[0].BASE_DATE);
                   panelSearch.setValue('FIRM_DATE',        provider[0].FIRM_DATE);
                   panelSearch.setValue('PLAN_DATE',        provider[0].PLAN_DATE);
                   panelSearch.setValue('EXC_STOCK_YN',     provider[0].EXC_STOCK_YN);
                   panelSearch.setValue('STOCK_YN',         provider[0].STOCK_YN);
                   panelSearch.setValue('SAFE_STOCK_YN',    provider[0].SAFE_STOCK_YN);
                   panelSearch.setValue('CUSTOM_STOCK_YN',  provider[0].CUSTOM_STOCK_YN);
                   panelSearch.setValue('INSTOCK_PLAN_YN',  provider[0].INSTOCK_PLAN_YN);
                   panelSearch.setValue('OUTSTOCK_PLAN_YN', provider[0].OUTSTOCK_PLAN_YN);
                   panelSearch.setValue('PLAN_YN',          provider[0].PLAN_YN);                  
                }
		})
			UniAppManager.setToolbarButtons('reset', false);
		},
		onQueryButtonDown : function()	{
			if(!panelSearch.getInvalidMessage()) return;    //필수체크
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'mrp146ukrvGrid1'){
				directMasterStore1.loadStoreRecords();
			}
			if(activeTabId == 'mrp146ukrvGrid2'){
				directMasterStore2.loadStoreRecords();
			}
			if(activeTabId == 'mrp146ukrvGrid3'){
				directMasterStore3.loadStoreRecords();
			}			
//			var viewLocked = masterGrid.lockedGrid.getView();
//			var viewNormal = masterGrid.normalGrid.getView();
//			console.log("viewLocked : ",viewLocked);
//			console.log("viewNormal : ",viewNormal);
//		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
//		    UniAppManager.setToolbarButtons('excel',true);
			}				
		},
		onSaveDataButtonDown: function () {
			//if(!panelSearch.getInvalidMessage()) return;    //필수체크
			var activeTabId = tab.getActiveTab().getId();
			if(activeTabId == 'mrp146ukrvGrid1'){
				directMasterStore1.saveStore();
			}
			if(activeTabId == 'mrp146ukrvGrid2'){
				directMasterStore2.saveStore();
			}
			if(activeTabId == 'mrp146ukrvGrid3'){
				directMasterStore3.saveStore();
			}			
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
/*        onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}*/
	});

	   
    /**
     * Validation
     */
    Unilite.createValidator('validator01', {
        store: directMasterStore1,
        grid: masterGrid1,
        validate: function( type, fieldName, newValue, oldValue, record, detailGrid) {
            if(newValue == oldValue){
                return false;
            }
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;

            switch(fieldName) { 
                case "ORDER_PLAN_DATE" :
                    if(record.get('CHECK_YN') == 'Y'){
                    	record.set('FLAG', 'N');
                    }
                    else{
                    	record.set('FLAG', 'U');
                    }
                    break;
                    
                case "BASIS_DATE" :
                    if(record.get('CHECK_YN') == 'Y'){
                        record.set('FLAG', 'N');
                    }
                    else{
                        record.set('FLAG', 'U');
                    }
                    break;
                    
                case "SUPPLY_TYPE" :
                    if(record.get('CHECK_YN') == 'Y'){
                        record.set('FLAG', 'N');
                    }
                    else{
                        record.set('FLAG', 'U');
                    }                    
                    break;
            }
            return rv;
        }
    }); // validator
    
    Unilite.createValidator('validator02', {
        store: directMasterStore2,
        grid: masterGrid2,
        validate: function( type, fieldName, newValue, oldValue, record, detailGrid) {
            if(newValue == oldValue){
                return false;
            }
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;

            switch(fieldName) { 
                case "ORDER_PLAN_DATE" :
                    if(record.get('CHECK_YN') == 'Y'){
                        record.set('FLAG', 'N');
                    }
                    else{
                        record.set('FLAG', 'U');
                    }
                    break;
                    
                case "BASIS_DATE" :
                    if(record.get('CHECK_YN') == 'Y'){
                        record.set('FLAG', 'N');
                    }
                    else{
                        record.set('FLAG', 'U');
                    }
                    break;
                    
                case "SUPPLY_TYPE" :
                    if(record.get('CHECK_YN') == 'Y'){
                        record.set('FLAG', 'N');
                    }
                    else{
                        record.set('FLAG', 'U');
                    }                    
                    break;
            }
            return rv;
        }
    }); // validator
    
    Unilite.createValidator('validator03', {
        store: directMasterStore3,
        grid: masterGrid3,
        validate: function( type, fieldName, newValue, oldValue, record, detailGrid) {
            if(newValue == oldValue){
                return false;
            }
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;

            switch(fieldName) { 
                case "ORDER_PLAN_DATE" :
                    if(record.get('CHECK_YN') == 'Y'){
                        record.set('FLAG', 'N');
                    }
                    else{
                        record.set('FLAG', 'U');
                    }
                    break;
                    
                case "BASIS_DATE" :
                    if(record.get('CHECK_YN') == 'Y'){
                        record.set('FLAG', 'N');
                    }
                    else{
                        record.set('FLAG', 'U');
                    }
                    break;
                    
                case "SUPPLY_TYPE" :
                    if(record.get('CHECK_YN') == 'Y'){
                        record.set('FLAG', 'N');
                    }
                    else{
                        record.set('FLAG', 'U');
                    }                    
                    break;
            }
            return rv;
        }
    }); // validator
};

</script>