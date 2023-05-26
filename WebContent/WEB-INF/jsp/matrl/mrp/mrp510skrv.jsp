<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mrp510skrv"  >	
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
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

	Unilite.defineModel('Mrp510skrvMasterModel', {
	    fields: [
	    	{name: 'COMP_CODE'				,text: '<t:message code="system.label.purchase.companycode"		default="법인코드"/>'		,type: 'string'},
	    	{name: 'ITEM_CODE'				,text: '<t:message code="system.label.purchase.itemcode"		default="품목코드"/>'		,type: 'string'},
	    	{name: 'ITEM_NAME'				,text: '<t:message code="system.label.purchase.itemname"		default="품목명"/>'		,type: 'string'},
	    	{name: 'SPEC'					,text: '<t:message code="system.label.purchase.spec"			default="규격"/>'			,type: 'string'},
	    	{name: 'SPEC_NUM'				,text: '<t:message code="system.label.base.drawingnumber"		default="도면번호"/>'		,type: 'string'},
	    	{name: 'ITEM_ACCOUNT'			,text: '<t:message code="system.label.purchase.itemaccount"		default="품목계정"/>'		,type: 'string'},
	    	{name: 'DIV_CODE'				,text: '<t:message code="system.label.purchase.division"		default="사업장"/>'		,type: 'string'}	    			
		]
	});
	Unilite.defineModel('Mrp510skrvDetailModel', {
	    fields: [
	    	{name: 'ITEM_CODE'				,text: '<t:message code="system.label.purchase.itemcode"		default="품목코드"/>'		,type: 'string'},
	    	{name: 'GUBUN'					,text: '<t:message code="system.label.purchase.classfication"	default="구분"/>'			,type: 'string'},
	    	{name: 'GUBUN_NAME'				,text: '<t:message code="system.label.purchase.classfication"	default="구분"/>'			,type: 'string'},
	    	{name: 'ORDER_DATE'				,text: '<t:message code="system.label.base.caldate"				default="발생일자"/>'		,type: 'uniDate'},
	    	{name: 'ORDER_NUM'				,text: '<t:message code=""										default="요소데이터"/>'		,type: 'string'},
	    	{name: 'SRC_DATA'				,text: '<t:message code=""										default="요소데이터2"/>'		,type: 'string'},
	    	{name: 'INOUT_Q'				,text: '<t:message code=""										default="소요예정량"/>'		,type: 'uniQty'},
	    	{name: 'USEABLE_Q'				,text: '<t:message code=""										default="가용수량"/>'		,type: 'uniQty'}	    			
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */
	var directMasterStore1 = Unilite.createStore('mrp510skrvMasterStore1',{
			model: 'Mrp510skrvMasterModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'mrp510skrvService.selectMaster'                	
                }
            },
			loadStoreRecords : function()	{
				var param = Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params : param
				});
			},
			groupField: ''
	});
	var directDetailStore1 = Unilite.createStore('mrp510skrvDetailStore1',{
			model: 'Mrp510skrvDetailModel',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'mrp510skrvService.selectDetail'                	
                }
            },
			loadStoreRecords : function(record)	{
				if (Ext.isEmpty(record)) {
					return;
				}
				
				var param = {
					DIV_CODE	: record.get('DIV_CODE'),
					ITEM_CODE	: record.get('ITEM_CODE')
				};
				console.log( param );
				this.load({
					params : param
				});
			},
			groupField: ''
	});

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
	        items:[{
	        	fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
	        	name: 'DIV_CODE', 
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
		        fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
		        name:'ITEM_ACCOUNT', 
		        xtype: 'uniCombobox', 
		        comboType:'AU', 
		        comboCode:'B020',
	        	allowBlank:false,
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ITEM_ACCOUNT', newValue);
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
					},
					//20200703 추가
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel: '규격',
				xtype: 'uniTextfield',
				name: 'SPEC',
				width: 200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SPEC', newValue);
					}
				}
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
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
	        	fieldLabel: '<t:message code="system.label.purchase.division" default="사업장"/>',
	        	name: 'DIV_CODE', 
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
		        fieldLabel: '<t:message code="system.label.purchase.itemaccount" default="품목계정"/>',
		        name:'ITEM_ACCOUNT', 
		        xtype: 'uniCombobox', 
		        comboType:'AU', 
		        comboCode:'B020',
	        	allowBlank:false,
		        listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ITEM_ACCOUNT', newValue);
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
					},
					//20200703 추가
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),{
				fieldLabel: '규격',
				xtype: 'uniTextfield',
				name: 'SPEC',
				width: 200,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('SPEC', newValue);
					}
				}
			}]
    });
    
    /**
     * Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('mrp510skrvMasterGrid1', {
    	// for tab    	
        layout: 'fit',
        region: 'west',
        flex: 2,
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: true,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        features: [{
        	id: 'masterGridSubTotal',
        	ftype: 'uniGroupingsummary',
        	showSummaryRow: false 
        },
    	    {id: 'masterGridTotal', 	
    	    ftype: 'uniSummary',
    	    showSummaryRow: false} 
    	],
    	store: directMasterStore1,
		selModel: 'rowmodel',
        columns:  [  
        	{ dataIndex: 'COMP_CODE'		     ,   width: 120	, hidden: true},
        	{ dataIndex: 'ITEM_CODE'		     ,   width: 120},
        	{ dataIndex: 'ITEM_NAME'		     ,   width: 150},
        	{ dataIndex: 'SPEC'			     	 ,   width: 150},
        	{ dataIndex: 'SPEC_NUM'				 ,   width: 120},
        	{ dataIndex: 'ITEM_ACCOUNT'			 ,   width: 120	, hidden: true},
			{ dataIndex: 'DIV_CODE'				 ,   width: 100	, hidden: true}
		],
		listeners: {
			selectionchangerecord : function( record ) {
				if(!Ext.isEmpty(record)) {
					directDetailStore1.loadStoreRecords(record);
				}
			}
		}
    });   
	
    var detailGrid = Unilite.createGrid('mrp510skrvDetailGrid1', {
    	// for tab    	
        layout: 'fit',
        region: 'center',
        flex: 2,
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: true,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
        sortableColumns : false,
        features: [{
        	id: 'masterGridSubTotal',
        	ftype: 'uniGroupingsummary',
        	showSummaryRow: false 
        },
    	    {id: 'masterGridTotal', 	
    	    ftype: 'uniSummary',
    	    showSummaryRow: false} 
    	],
    	store: directDetailStore1,
		selModel: 'rowmodel',
        columns:  [  
        	{ dataIndex: 'ITEM_CODE'		     ,   width: 120	, hidden: true},
        	{ dataIndex: 'GUBUN'			     ,   width: 120	, hidden: true},
        	{ dataIndex: 'GUBUN_NAME'		     ,   width: 100},
        	{ dataIndex: 'ORDER_DATE'	     	 ,   width: 100},
        	{ dataIndex: 'ORDER_NUM'			 ,   width: 150},
        	{ dataIndex: 'SRC_DATA'				 ,   width: 150	, hidden: true},
        	{ dataIndex: 'INOUT_Q'				 ,   width: 120},
			{ dataIndex: 'USEABLE_Q'			 ,   width: 120}
		]
    });
	
    Unilite.Main({
    	borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				detailGrid, masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		id  : 'mrp510skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);

			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{			
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				masterGrid.getStore().loadStoreRecords();
			}
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        }
	});

};

</script>