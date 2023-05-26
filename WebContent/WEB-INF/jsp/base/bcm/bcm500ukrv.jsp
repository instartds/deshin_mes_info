<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bcm500ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->    
	<t:ExtComboStore comboType="AU" comboCode="A079" /> <!-- 계산유형 -->

</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
	//var gsBaseMonthHidden = true;
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bcm500ukrvService.selectMaster',
			update: 'bcm500ukrvService.updateMaster',
			create: 'bcm500ukrvService.insertMaster',
			destroy: 'bcm500ukrvService.deleteMaster',
			syncAll: 'bcm500ukrvService.saveAll'
		}
	});	
	
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bcm500ukrvService.selectDetail',
			update: 'bcm500ukrvService.updateDetail',
			create: 'bcm500ukrvService.insertDetail',
			destroy: 'bcm500ukrvService.deleteDetail',
			syncAll: 'bcm500ukrvService.saveAll2'
		}
	});	
	
	Unilite.defineModel('bcm500ukrvModel1', {
	    fields: [  	  
	    	{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.base.currencyunit" default="화폐단위"/>'			, type: 'string'},
		    {name: 'MONEY_UNIT_NM'		, text: '<t:message code="system.label.base.foreigncurrency" default="외화화폐"/>'		, type: 'string'},
		    {name: 'CAL_TYPE'			, text: '<t:message code="system.label.base.calculationtype" default="계산유형"/>'		, type: 'string'},
		    {name: 'COMP_CODE'			, text: 'COMP_CODE'		, type: 'string'}
	    ]
	}); //End of Unilite.defineModel('bcm500ukrvModel1', {
	
	Unilite.defineModel('bcm500ukrvModel2', {
	    fields: [  
			{name: 'AC_YYYYMM'			, text: '<t:message code="system.label.base.basisyear" default="기준년도"/>'			, type: 'string'},
			{name: 'MONEY_UNIT'			, text: '<t:message code="system.label.base.currencyunit" default="화폐단위"/>'			, type: 'string'},
			{name: 'EXCHG_DIVI'			, text: '<t:message code="system.label.base.exchangeratedivision" default="환율구분"/>'	, type: 'string'},
	    	{name: 'AC_DATE'			, text: '<t:message code="system.label.base.caldate" default="일자"/>'				, type: 'string'},
		    {name: 'BASE_EXCHG'			, text: '<t:message code="system.label.base.tradingstandardrate" default="매매기준율"/>'	, type: 'uniER'},
		    {name: 'CASH_BUY'			, text: '<t:message code="system.label.base.buycash" default="현찰살때"/>'				, type: 'uniER'},
		    {name: 'CASH_SALE'			, text: '<t:message code="system.label.base.salecash" default="현찰팔때"/>'				, type: 'uniER'},
		    {name: 'TELE_BUY'			, text: '<t:message code="system.label.base.telebuy" default="송금보낼때"/>'				, type: 'uniER'},
		    {name: 'TELE_SALE'			, text: '<t:message code="system.label.base.telesale" default="송금받을때"/>'			, type: 'uniER'},
		    {name: 'USD_CHANGE'			, text: '<t:message code="system.label.base.usdconversionrate" default="미화환산율"/>'	, type: 'uniER'},
		    {name: 'COMP_CODE'			, text: 'COMP_CODE'		, type: 'string'}
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
	  
	var directMasterStore = Unilite.createStore('bcm500ukrvMasterStore1',{
		model: 'bcm500ukrvModel1',
		uniOpt: {
					isMaster: true,				// 상위 버튼 연결 
		        	editable: true,				// 수정 모드 사용 
		        	deletable: true,			// 삭제 가능 여부 
		            useNavi: false				// prev | next 버튼 사용
            },
         autoLoad: false,
         proxy: directProxy,
         /*
         listeners: {
        	datachanged: function(store, eOpts) {	 
       		    
        		if(this.isDirty())	{
    	    		UniAppManager.setToolbarButtons('save', true);
        		}else {
        			UniAppManager.setToolbarButtons('save', false);
        		}	          		
	         }   	
		 },  */ 
		 loadStoreRecords : function()	{
			var param = Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params: param
			});
		 },
		 saveStore : function(config)	{	
				var inValidRecs = this.getInvalidRecords();
            	
				if(inValidRecs.length == 0 )	{
					//var searchParam = Ext.getCmp('searchForm').getValues();	
					config = {									
							  //scope:this,
							  //params: [searchParam],
							  success: function(batch, option) {								
								//panelResult.resetDirtyStatus();
								if(directDetailStore.isDirty()) {
									directDetailStore.saveStore();
								}
								UniAppManager.setToolbarButtons('save', false);			
							} 
					};					
					this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
				
		   }
	}); //End of var directMasterStore = Unilite.createStore('bcm500ukrvMasterStore1',{
	
	var directDetailStore = Unilite.createStore('bcm500ukrvMasterStore2',{
		model: 'bcm500ukrvModel2',
		uniOpt: {
               isMaster: true,			// 상위 버튼 연결 
	           editable: true,			// 수정 모드 사용 
	           deletable:true,			// 삭제 가능 여부 
	           useNavi : false			// prev | next 버튼 사용
            },
        autoLoad: false,
        proxy: directProxy2,
		loadStoreRecords: function(record)	{
			var searchParam= Ext.getCmp('searchForm').getValues();
			//Unilite.messageBox(record.get('MONEY_UNIT'));
			//var param= {'MONEY_UNIT':record.get('MONEY_UNIT')};	
			var param= '';	
			var params = Ext.merge(searchParam, param);
			console.log( param );
			this.load({
				params : params
			});
		},
		saveStore : function(config)	{	
			var inValidRecs = this.getInvalidRecords();
	
			if(inValidRecs.length == 0 )	{
				var searchParam = Ext.getCmp('searchForm').getValues();			
				config = {
							scope:this,
							params: [searchParam],			
							success: function(batch, option) {								
								//panelResult.resetDirtyStatus();
								if(directMasterStore.isDirty()) {
									directMasterStore.saveStore();
								}
								UniAppManager.setToolbarButtons('save', false);			
							 } 
				};	
				this.syncAllDirect(config);
			}else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
						fieldLabel: '<t:message code="system.label.base.exchangeratedivision" default="환율구분"/>', 
						id		  : 'rdoSelect0',
						allowBlank:false,
						xtype: 'uniRadiogroup',
						items: [{
							boxLabel: '<t:message code="system.label.base.fixedexchangerate" default="고정환율"/>',
							width: 90,
							name: 'EXCHG_DIVI',
							inputValue: '1',
							checked: true
						}, {
							boxLabel: '<t:message code="system.label.base.floatingexchangerate" default="변동환율"/>',
							width: 90,
							name: 'EXCHG_DIVI',
							inputValue: '2'
						}] ,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
							
								panelResult.getField('EXCHG_DIVI').setValue(newValue.EXCHG_DIVI);
								if(newValue.EXCHG_DIVI == '1'){
									panelSearch.down('#baseMonSrch').disable();
					            	panelResult.down('#baseMonRslt').disable();
					            	
                                    panelSearch.setValue('BASE_MONTH','');
                                    panelResult.setValue('BASE_MONTH','');

								}else{
									panelSearch.down('#baseMonSrch').enable();
					            	panelResult.down('#baseMonRslt').enable();
								}
															
								var record = masterGrid.getSelectedRecord();
					        	if(record) {
					        		var sMoneyUnit = record.get('MONEY_UNIT');
					        		if  (!Ext.isEmpty(sMoneyUnit)){
					        			panelSearch.setValue('MONEY_UNIT',sMoneyUnit);
					    				directDetailStore.loadStoreRecords(record);
					        		}
					        	}
							}
						}   		
					},  
					{
						fieldLabel: '<t:message code="system.label.base.basisyear" default="기준년도"/>',
						name: 'BASE_YEAR',
						xtype: 'uniYearField',
						value: new Date().getFullYear(),
						allowBlank: false,
                        listeners: {
                            change: function(field, newValue, oldValue, eOpts) {
                                panelResult.setValue('BASE_YEAR', newValue);
                            }
                        }
			    	},
		            {
				 		fieldLabel: '<t:message code="system.label.base.basisyearmonth" default="기준년월"/>',
				 		xtype: 'uniMonthfield',
				 		name: 'BASE_MONTH',
				 		itemId:'baseMonSrch',
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('BASE_MONTH', newValue);
							},
                            specialkey: function(elm, e){
                                return false;
                            }
						}
					},
					{
						fieldLabel: '조회후 선택된 화폐코드',
						name:'MONEY_UNIT',
						xtype: 'uniTextfield',
						hidden: true
					}]	            			 
				}]
		});    
    
    var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [
				{
					fieldLabel: '<t:message code="system.label.base.exchangeratedivision" default="환율구분"/>', 
					id		  : 'rdoSelect1',
					allowBlank:false,
					xtype: 'uniRadiogroup',
					items: [{
						boxLabel: '<t:message code="system.label.base.fixedexchangerate" default="고정환율"/>',
						width: 90,
						name: 'EXCHG_DIVI',
						inputValue: '1',
						checked: true
					}, {
						boxLabel: '<t:message code="system.label.base.floatingexchangerate" default="변동환율"/>',
						width: 90,
						name: 'EXCHG_DIVI',
						inputValue: '2'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
	
							panelSearch.getField('EXCHG_DIVI').setValue(newValue.EXCHG_DIVI);
							if(newValue.EXCHG_DIVI == '1'){
								panelSearch.down('#baseMonSrch').disable();
				            	panelResult.down('#baseMonRslt').disable();
				            	
				            	panelSearch.setValue('BASE_MONTH','');
				            	panelResult.setValue('BASE_MONTH','');
				            	
							}else{
								panelSearch.down('#baseMonSrch').enable();
				            	panelResult.down('#baseMonRslt').enable();
							}
														
							var record = masterGrid.getSelectedRecord();
				        	if(record) {
				        		var sMoneyUnit = record.get('MONEY_UNIT');
				        		if  (!Ext.isEmpty(sMoneyUnit)){
				        			panelSearch.setValue('MONEY_UNIT',sMoneyUnit);
				    				directDetailStore.loadStoreRecords(record);
				        		}
				        	}
						}
					}
				},   
				{
					fieldLabel: '<t:message code="system.label.base.basisyear" default="기준년도"/>',
					name: 'BASE_YEAR',
					xtype: 'uniYearField',
					value: new Date().getFullYear(),
					allowBlank: false,
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                            panelSearch.setValue('BASE_YEAR', newValue);
                        }
                    }
		    	},
		        {
			 		fieldLabel: '<t:message code="system.label.base.basisyearmonth" default="기준년월"/>',
			 		xtype: 'uniMonthfield',
			 		name: 'BASE_MONTH',
			 		itemId:'baseMonRslt',			 	
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelSearch.setValue('BASE_MONTH', newValue);
						},
                        specialkey: function(elm, e){
                        	return false;
                        }
					}
				}]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('bcm500ukrvGrid1', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore, 
        uniOpt:{	expandLastColumn: false,
        			useRowNumberer: true,
                    useContextMenu: false
        },
        
        columns: [        
        	{dataIndex: 'MONEY_UNIT'			,         	width: 66,
	        		editor: Unilite.popup('MONEY_G', {		
		       			DBtextFieldName: 'MONEY_NAME',
						  	autoPopup: true,			
		    				listeners: {'onSelected': {
		   						fn: function(records, type) {
		   							Ext.each(records, function(record,i) {
		   								if(i==0) {
		   									var grdRecord = masterGrid.getSelectedRecord(); 
		   									grdRecord.set('MONEY_UNIT',record['MONEY_CODE'] );
		   									grdRecord.set('MONEY_UNIT_NM',record['MONEY_NAME'] );
		   								}
		   							}); 
		   						},
		   						scope: this
		   					},
		   					'onClear': function(type) {
		   						var grdRecord = masterGrid.getSelectedRecord();
		   						Unilite.messageBox("MONEY_UNIT onClear");
		   						grdRecord.set('MONEY_UNIT','');
		   						grdRecord.set('MONEY_UNIT_NM','');
		   					}
		   				}				
	        		})
			},
			{dataIndex: 'MONEY_UNIT_NM'			,         	width: 245,
	        		editor: Unilite.popup('MONEY_G', {		
		       			DBtextFieldName: 'MONEY_NAME',
			  				autoPopup: true,			
		    				listeners: {'onSelected': {
		   						fn: function(records, type) {
		   							Ext.each(records, function(record,i) {
		   								if(i==0) {
		   									var grdRecord = masterGrid.getSelectedRecord(); 
		   									grdRecord.set('MONEY_UNIT',record['MONEY_CODE'] );
		   									grdRecord.set('MONEY_UNIT_NM',record['MONEY_NAME'] );
		   								}
		   							}); 
		   						},
		   						scope: this
		   					}
		   				}				
	        		})
			}, 				
			{dataIndex: 'CAL_TYPE'				,         	width: 66 , hidden: true},
			{dataIndex: 'COMP_CODE'				,         	width: 66 , hidden: true}
		] ,
		listeners: {	
			
        	render: function(grid, eOpts){
			 	var girdNm = grid.getItemId();
			    grid.getEl().on('click', function(e, t, eOpt) {       //Retrieves the top level element representing this component
			    	if(directDetailStore.isDirty()){                  //Returns true if the value of this Field has been changed from its originalValue. Will return false if the field is disabled or has not been rendered 
	        			//Unilite.messageBox(Msg.sMB154);
	        			//return;
	        		}
			    	selectedGrid = girdNm
			    	UniAppManager.setToolbarButtons(['newData', 'delete'], true);
			    });
			  
			},   
			
        	beforeedit  : function( editor, e, eOpts ) {
      			
      			if(!e.record.phantom)	{
					if (UniUtils.indexOf(e.field,['MONEY_UNIT']))
							return false;
				}
        	},
        	selectionchangerecord:function(record , selected)	{
          		panelSearch.setValue('MONEY_UNIT',record.get('MONEY_UNIT'));
				directDetailStore.loadStoreRecords(record);
          	}
        	/*,
			cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
				UniAppManager.setToolbarButtons('newData', 'delete', true);
			}*/
		}
    });
    
    var detailGrid = Unilite.createGrid('bcm500ukrvGrid2', {
		layout : 'fit',
    	region:'east',
        store : directDetailStore, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        tbar: [{
        	text:'<t:message code="system.label.base.createdata" default="DATA 생성"/>',
        	tdAttrs: {align: 'left'},
        	margin: '0 0 0 5',
        	handler: function() {
        		var sBaseYear  = panelSearch.getValue('BASE_YEAR');		
	        	var sBaseMonth = panelSearch.getValue('BASE_MONTH');
	        	var sExchgDivi = Ext.getCmp('rdoSelect0').getChecked()[0].inputValue;
	        	        		
        		//validation check
        		if  (Ext.isEmpty(sBaseYear)){
	        		Unilite.messageBox('<t:message code="unilite.msg.sMB128"/>');
					return;
        		}
        		var record = masterGrid.getSelectedRecord();
        		var sMoneyUnit;
	        	if(record) {
	        		sMoneyUnit = record.get('MONEY_UNIT');
	        	}else{
	        		Unilite.messageBox('<t:message code="unilite.msg.sMB130"/>');
					return;
	        	}
	        	if  (Ext.isEmpty(sMoneyUnit)){
	        		Unilite.messageBox('<t:message code="unilite.msg.sMB130"/>');
					return;
        		}
	        		        	
	        	var selRow = masterGrid.getSelectedRecord();
				if(selRow.phantom != true && directDetailStore.getCount() > 0 )
				{
					if(!confirm('<t:message code="unilite.msg.sMB134"/>' + '\n' + '<t:message code="unilite.msg.sMB135"/>')) {
						return;	
					}
				}
				
				detailGrid.reset();
				if(sExchgDivi == '1'){
					for(var i=1 ; i < 13 ; i++)	{
						 var r = {
								 	AC_YYYYMM     : sBaseYear,
								 	MONEY_UNIT	  : sMoneyUnit,
								 	EXCHG_DIVI    : sExchgDivi,
								 	AC_DATE       : sBaseYear + (100+i).toString().substr(1,2),
						            COMP_CODE     : UserInfo.compCode,
						            BASE_EXCHG    : 0,
						            CASH_BUY      : 0,
						            CASH_SALE     : 0,
						            TELE_BUY      : 0,
						            TELE_SALE     : 0,
						            USD_CHANGE    :0
					             };
					     detailGrid.createRow(r, 'INPUT_DATE', detailGrid.getStore().getCount()-1);
					}
					
				}else{					
					if  (Ext.isEmpty(sBaseMonth)){
		        		Unilite.messageBox('<t:message code="unilite.msg.sMH905"/>');
						return;
	        		}
						        		var monthconf =  (sBaseMonth.getMonth()+1).toString();
		        	var lastDay = ( new Date(sBaseMonth.getFullYear().toString(), (sBaseMonth.getMonth()+1).toString(), 0)).getDate();
	        		//Unilite.messageBox(lastDay);
		        	if(monthconf < 10){
	        			for(var i=1 ; i < lastDay+1 ; i++)	{
						 	var r = {
								 		AC_YYYYMM     : sBaseYear,
								 		MONEY_UNIT	  : sMoneyUnit,
								 		EXCHG_DIVI    : sExchgDivi,
								 		AC_DATE       : sBaseMonth.getFullYear().toString() + '.' + '0' +(sBaseMonth.getMonth()+1).toString() + '.' + (i<10?'0'+i:''+i),
						            	COMP_CODE     : UserInfo.compCode,
						            	BASE_EXCHG    : 0,
						            	CASH_BUY      : 0,
						            	CASH_SALE     : 0,
						            	TELE_BUY      : 0,
						            	TELE_SALE     : 0,
						            	USD_CHANGE    : 0
					             	};
					     	detailGrid.createRow(r, 'INPUT_DATE', detailGrid.getStore().getCount()-1);
						}
		        	}
		        	else{
		        		for(var i=1 ; i < lastDay+1 ; i++)	{
						 	var r = {
								 		AC_YYYYMM     : sBaseYear,
								 		MONEY_UNIT	  : sMoneyUnit,
								 		EXCHG_DIVI    : sExchgDivi,
								 		AC_DATE       : sBaseMonth.getFullYear().toString() + '.' +(sBaseMonth.getMonth()+1).toString() + '.' + (i<10?'0'+i:''+i),
						            	COMP_CODE     : UserInfo.compCode,
						            	BASE_EXCHG    : 0,
						            	CASH_BUY      : 0,
						            	CASH_SALE     : 0,
						            	TELE_BUY      : 0,
						            	TELE_SALE     : 0,
						            	USD_CHANGE    : 0
					             	};
					     	detailGrid.createRow(r, 'INPUT_DATE', detailGrid.getStore().getCount()-1);
		        		}
		        	}
				}
				
				UniAppManager.setToolbarButtons('save', true);
        	}
        }],
   	 	columns: [        
			{dataIndex: 'AC_YYYYMM'			, width: 66, hidden: true },	
			{dataIndex: 'MONEY_UNIT'	    , width: 66, hidden: true },
			{dataIndex: 'EXCHG_DIVI'		, width: 66, hidden: true },	
        	{dataIndex: 'AC_DATE'			, width: 86, align:'center' },
			{dataIndex: 'BASE_EXCHG'		, width: 86 },
			{dataIndex: 'CASH_BUY'			, width: 86 },
			{dataIndex: 'CASH_SALE'			, width: 86 },
			{dataIndex: 'TELE_BUY'			, width: 86 },
			{dataIndex: 'TELE_SALE'			, width: 86 },
			{dataIndex: 'USD_CHANGE'		, width: 100 },
			{dataIndex: 'COMP_CODE'			, width: 66, hidden: true }
		],
    	listeners: {	
    		
        	render: function(grid, eOpts){
			 	var girdNm = grid.getItemId();
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	if(directMasterStore.isDirty()){
	        			//Unilite.messageBox(Msg.sMB154);
	        			//return;
	        		}
			    	selectedGrid = girdNm
			    	//UniAppManager.setToolbarButtons(['newData', 'delete'], true);
			    });
			  
			},
        	
        	beforeedit  : function( editor, e, eOpts ) {
      			if(!e.record.phantom){
					if (UniUtils.indexOf(e.field,['AC_DATE']))
							return false;
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
				{
					region : 'west',
					xtype : 'container',
					width : 350,
					layout : 'fit',
					items : [ masterGrid ]
				},
				{
					region : 'center',
					xtype : 'container',
					layout : 'fit',
					flex : 1,
					items : [ detailGrid ]
				},
				panelResult
			]
		},
			panelSearch  	
		],
		id  : 'bcm500ukrvApp',
		fnInitBinding : function() {
			//panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset','newData'],true);
			UniAppManager.setToolbarButtons('reset',false);
			panelSearch.down('#baseMonSrch').disable();
        	panelResult.down('#baseMonRslt').disable();
        	
        	//directDetailStore.removeListener('_onStoreLoad');
        	//directDetailStore.removeListener('onStoreDataChanged');
		},
		onQueryButtonDown : function()	{		
            if(!panelSearch.getInvalidMessage()) return;   //필수체크
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons(['reset','newData', 'delete'],true);
		},
		onNewDataButtonDown : function()	{
			if(selectedGrid == 'bcm500ukrvGrid1'){
				var r = {CAL_TYPE  : '1'};
	            masterGrid.createRow(r, 'MONEY_UNIT', masterGrid.getStore().getCount()-1);
				
				UniAppManager.setToolbarButtons('save', true);
			}	
			else if(selectedGrid == 'bcm500ukrvGrid2'){
				Unilite.messageBox('<t:message code="system.message.base.message007" default="DATA생성 버튼을 눌러주세요."/>'); 	
				return;
			}
				
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
            directMasterStore.clearData();
			detailGrid.reset();
            directDetailStore.clearData();
		
			this.fnInitBinding();
			UniAppManager.setToolbarButtons('save', false);
		},
		onSaveDataButtonDown: function(config) {
			if(directMasterStore.isDirty()) {
				directMasterStore.saveStore();
			}else if(directDetailStore.isDirty()) {
				directDetailStore.saveStore();
			}
		},
		onDeleteDataButtonDown: function() {			
			if(selectedGrid == 'bcm500ukrvGrid1'){
				var selIndex = masterGrid.getSelectedRowIndex();
				var selRow = masterGrid.getSelectedRecord();
				if(selRow.phantom != true && directDetailStore.getCount() > 0 )
				{
					if(!confirm('<t:message code="unilite.msg.sMB134"/>' + '\n' + '<t:message code="unilite.msg.sMB062"/>')) {
						return;	
					}else{
						masterGrid.deleteSelectedRow(selIndex);
						masterGrid.getStore().onStoreActionEnable();
						UniAppManager.setToolbarButtons('save', true);
					}
									
				}else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					masterGrid.deleteSelectedRow(selIndex);
					masterGrid.getStore().onStoreActionEnable();
					UniAppManager.setToolbarButtons('save', true);
				}
			}else if(selectedGrid == 'bcm500ukrvGrid2'){
				var selIndex = detailGrid.getSelectedRowIndex();
				var selRow = detailGrid.getSelectedRecord();
								
				if(selRow.phantom == true)
					detailGrid.deleteSelectedRow();
				else if(confirm('<t:message code="system.message.base.confirm002" default="전체삭제 하시겠습니까?"/>')) {
					//detailGrid.deleteSelectedRow();
					directDetailStore.removeAll();
					//masterGrid.deleteSelectedRow(masterGrid.getSelectedRowIndex());
					UniAppManager.setToolbarButtons('save', true);
				}
			}	
		}
	});
	
};


</script>
