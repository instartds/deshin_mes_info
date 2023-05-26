<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="bsa240ukrv"  >
	<t:ExtComboStore comboType="BOR120"  pgmId="bsa240ukrv"/><!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="YP06" /><!-- 장비구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="B010" /><!-- 사용여부 --> 
	<t:ExtComboStore comboType="AU" comboCode="B024" /> <!-- 담당자 -->
	<t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /> <!--창고-->
</t:appConfig>

<script type="text/javascript" >
var outDivCode = UserInfo.divCode;
function appMain() {

	/**
	 * Model 정의
	 * 
	 * @type
	 */

	Unilite.defineModel('bsa240ukrvModel', {
		// pkGen : user, system(default)
	    fields: [
			{name: 'SEQ' 					, text: '순번' 				, type: 'integer', editable:false},
			{name: 'COMP_CODE'				, text: '법인코드'				, type: 'string'},
	    	{name: 'DIV_CODE'				, text: '사업장'				, type: 'string', xtype: 'uniCombobox', comboType: 'BOR120', value:UserInfo.divCode},
	    	{name: 'POS_TYPE'				, text: '장비구분'				, type: 'string', allowBlank: false, comboType:'AU', comboCode:'YP06'},
	    	{name: 'POS_NO'					, text: '장비번호'				, type: 'string', allowBlank: false},
	    	{name: 'POS_NO_ORIGIN'			, text: '장비번호'				, type: 'string'},
	    	{name: 'POS_NAME'				, text: '장비명'				, type: 'string', allowBlank: false},
	    	{name: 'WH_NAME'				, text: '창고코드'				, type: 'string'},
	    	{name: 'WH_CODE'				, text: '창고'				, type: 'string' , allowBlank: false , store: Ext.data.StoreManager.lookup('whList')},
	    	{name: 'DEPT_CODE'				, text: '부서'				, type: 'string' , allowBlank: false},
	    	{name: 'DEPT_NAME'				, text: '부서명'				, type: 'string' , allowBlank: false},
	    	{name: 'STAFF_ID'				, text: '담당자'				, type: 'string', comboType: 'AU', comboCode: 'B024'},
	    	{name: 'PHONE_NUMBER'			, text: '전화번호'				, type: 'string'},
	    	/* 2015.05.21 추가 */
	    	
	    	{name: 'LOCATION'				, text: '위치'				, type: 'string'},
	    	{name: 'NAME_PLATE_LINE1'		, text: '명판메세지1'			, type: 'string'},
	    	{name: 'NAME_PLATE_LINE2'		, text: '명판메세지2'			, type: 'string'},
	    	{name: 'NAME_PLATE_LINE3'		, text: '명판메세지3'			, type: 'string'},
	    	{name: 'NAME_PLATE_LINE4'		, text: '명판메세지4'			, type: 'string'},
	    	{name: 'TOP_LINE1'				, text: '영수증상단메세지1'		, type: 'string'},
	    	{name: 'TOP_LINE2'				, text: '영수증상단메세지2'		, type: 'string'},
	    	{name: 'BOTTOM_LINE1'			, text: '영수증하단메세지1'		, type: 'string'},
	    	{name: 'BOTTOM_LINE2'			, text: '영수증하단메세지2'		, type: 'string'},
	    	{name: 'BOTTOM_LINE3'			, text: '영수증하단메세지3'		, type: 'string'},

	    	{name: 'REMARK'					, text: '비고'				, type: 'string'},
	    	{name: 'INSERT_DB_USER'			, text: 'INSERT_DB_USER'	, type: 'string'},
	    	{name: 'INSERT_DB_TIME'			, text: 'INSERT_DB_TIME'	, type: 'string'},
	    	{name: 'UPDATE_DB_USER'			, text: 'UPDATE_DB_USER'	, type: 'string'},
	    	{name: 'UPDATE_DB_TIME'			, text: 'UPDATE_DB_TIME'	, type: 'string'},
	    	{name: 'TEMPC_01'				, text: 'TEMPC_01'			, type: 'string'},
	    	{name: 'TEMPC_02'				, text: 'TEMPC_02'			, type: 'string'},
	    	{name: 'TEMPC_03'				, text: 'TEMPC_03'			, type: 'string'},
	    	{name: 'TEMPN_01'				, text: 'TEMPC_01'			, type: 'integer'},
	    	{name: 'TEMPN_02'				, text: 'TEMPC_02'			, type: 'integer'},
	    	{name: 'TEMPN_03'				, text: 'TEMPC_03'			, type: 'integer'}
		]
	});
	
  	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'bsa240ukrvService.selectDetailList',
        	update: 'bsa240ukrvService.updateDetail',
			create: 'bsa240ukrvService.insertDetail',
			destroy: 'bsa240ukrvService.deleteDetail',
			syncAll: 'bsa240ukrvService.saveAll'
        }
	});
	
	/**
	 * Store 정의(Service 정의)
	 * 
	 * @type
	 */					
	var directMasterStore = Unilite.createStore('bsa240ukrvMasterStore',{
			model: 'bsa240ukrvModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
            },
            proxy: directProxy,
            listeners: {
	            write: function(proxy, operation){
	                if (operation.action == 'destroy') {
	                	Ext.getCmp('panelResult').reset();			         
	                }                
            	}
            
        	}								
			,loadStoreRecords : function()	{
				var param= panelResult.getValues();			
				console.log( param );
				this.load({ params : param});
			}
			// 수정/추가/삭제된 내용 DB에 적용 하기
			,saveStore : function(config)	{	
// var paramMaster= [];
// var app = Ext.getCmp('bpr100ukrvApp');
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
            	var toUpdate = this.getUpdatedRecords();
            	console.log("toUpdate",toUpdate);

            	var rv = true;
       	
            	
				if(inValidRecs.length == 0 )	{										
					config = {
// params: [paramMaster],
							success: function(batch, option) {								
								panelResult.resetDirtyStatus();
								UniAppManager.setToolbarButtons('save', false);								
								directMasterStore.loadStoreRecords();	
							 } 
					};					
					this.syncAllDirect(config);
					
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			listeners:{
				update:function( store, record, operation, modifiedFieldNames, eOpts )	{
					

				}	
			}
		});

	/**
	 * 검색조건 (Search Panel)
	 * 
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
			title: '검색조건',         
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
				title: '기본정보', 	
	   			itemId: 'search_panel1',
	           	layout: {type: 'uniTable', columns: 1},
	           	defaultType: 'uniTextfield',
				items: [{					
					fieldLabel: '사업장',
					name:'DIV_CODE',
					xtype: 'uniCombobox',
					comboType:'BOR120',
					allowBlank:false,
					value:UserInfo.divCode,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
				},{
			       	fieldLabel: '장비구분',
			       	name:'POS_TYPE', 
			       	xtype: 'uniCombobox',
					//holdable: 'hold',
			       	comboType:'AU',
			       	comboCode:'YP06', 
			       	allowBlank:true,
			       	listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('POS_TYPE', newValue);
						}
					}
			    },{
					fieldLabel: '장비명',
					name: 'POS_NAME',
					xtype: 'uniTextfield',
					width: 320,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('POS_NAME', newValue);
						}
					}
				}
			] 
		}]
    }); 
		
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{					
				fieldLabel: '사업장',
				name:'DIV_CODE',
				xtype: 'uniCombobox',
				comboType:'BOR120',
				allowBlank:false,
				value:UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{
		       	fieldLabel: '장비구분',
		       	name:'POS_TYPE', 
		       	xtype: 'uniCombobox',
				//holdable: 'hold',
		       	comboType:'AU',
		       	comboCode:'YP06', 
		       	allowBlank:true,
		       	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('POS_TYPE', newValue);
					}
				}
		    },{
				fieldLabel: '장비명',
				name: 'POS_NAME',
				xtype: 'uniTextfield',
				width: 400,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('POS_NAME', newValue);
					}
				}
			}
		]
    });  
	
    /**
	 * Master Grid 정의(Grid Panel)
	 * 
	 * @type
	 */
    
    var masterGrid = Unilite.createGrid('bsa240ukrvGrid', {
    	store: directMasterStore,
    	region: 'center' ,
        layout : 'fit',
    	uniOpt: {
    		useRowNumberer: false,
    		expandLastColumn: false
    	},
		columns:[
			{dataIndex: 'SEQ'					, width: 50, align: 'center', hidden: true},
			{dataIndex: 'COMP_CODE'				, width:100, hidden: true},
        	{dataIndex: 'DIV_CODE'				, width:100, hidden: true},
        	{dataIndex: 'POS_TYPE'				, width:100},
        	{dataIndex: 'POS_NO'				, width:100},
        	{dataIndex: 'POS_NO_ORIGIN'				, width:100},
        	{dataIndex: 'POS_NAME'				, width:170},
        	{dataIndex: 'WH_NAME'				, width:66},
        	{dataIndex: 'WH_CODE'				, width:120},
        	{dataIndex: 'DEPT_CODE'				, width:66	
				  ,'editor' : Unilite.popup('DEPT_G',{  textFieldName:'DEPT_CODE',  textFieldWidth:100, DBtextFieldName: 'TREE_CODE'
				    				,listeners: {'onSelected': {
			 								fn: function(records, type) {
			 									UniAppManager.app.fnDeptChange(records);		
			 								},
			 								scope: this
			 							},
			 							'onClear': function(type) {
											var grdRecord = Ext.getCmp('bsa240ukrvGrid').uniOpt.currentRecord;
	                						grdRecord.set('DEPT_CODE','');
					                    	grdRecord.set('DEPT_NAME','');
			 							}
					 				}
								})
				},
			{dataIndex: 'DEPT_NAME'				, width:170	
				  ,'editor' : Unilite.popup('DEPT_G',{textFieldName:'DEPT_NAME', textFieldWidth:100, DBtextFieldName: 'TREE_NAME'
		  							,listeners: {'onSelected': {
			 								fn: function(records, type) {
			 									UniAppManager.app.fnDeptChange(records);	
			 								},
			 								scope: this
			 							},
			 							'onClear': function(type) {
			 								var grdRecord = Ext.getCmp('bsa240ukrvGrid').uniOpt.currentRecord;
					                    	grdRecord.set('DEPT_CODE','');
					                    	grdRecord.set('DEPT_NAME','');
			 							}
					 				}
								})
				 },
			{dataIndex: 'LOCATION'					, width:300},
        	{dataIndex: 'STAFF_ID'					, width:80},
  
        	{dataIndex: 'NAME_PLATE_LINE1'			, width:100},
        	{dataIndex: 'NAME_PLATE_LINE2'			, width:100},
        	{dataIndex: 'NAME_PLATE_LINE3'			, width:100},
        	{dataIndex: 'NAME_PLATE_LINE4'			, width:100},
        	{dataIndex: 'TOP_LINE1'					, width:120},
        	{dataIndex: 'TOP_LINE2'					, width:120},
        	{dataIndex: 'BOTTOM_LINE1'				, width:120},
        	{dataIndex: 'BOTTOM_LINE2'				, width:120},
        	{dataIndex: 'BOTTOM_LINE3'				, width:120},
        	
        	
        	{dataIndex: 'REMARK'				, width:200},
        	{dataIndex: 'INSERT_DB_USER'		, width:100, hidden: true},
        	{dataIndex: 'INSERT_DB_TIME'		, width:100, hidden: true},
        	{dataIndex: 'UPDATE_DB_USER'		, width:100, hidden: true},
        	{dataIndex: 'UPDATE_DB_TIME'		, width:100, hidden: true},
        	{dataIndex: 'TEMPC_01'				, width:100, hidden: true},
        	{dataIndex: 'TEMPC_02'				, width:100, hidden: true},
        	{dataIndex: 'TEMPC_03'				, width:100, hidden: true},
        	{dataIndex: 'TEMPN_01'				, width:100, hidden: true},
        	{dataIndex: 'TEMPN_02'				, width:100, hidden: true},
        	{dataIndex: 'TEMPN_03'				, width:100, hidden: true}
		],
		listeners: {
        	beforeedit: function( editor, e, eOpts ) {
//        		if(e.record.phantom == false) {
//        		 	if(UniUtils.indexOf(e.field, ['POS_TYPE', 'POS_NO', 'WH_CODE', 'BRAND_CODE', 'DEPT_CODE', 'DEPT_NAME']))
//				   	{
//						return false;
//      				} else {
//      					return true;
//      				}
//        		} else {
//        			if(UniUtils.indexOf(e.field, ['WH_CODE', 'BRAND_CODE', 'DEPT_CODE', 'DEPT_NAME']))
//				   	{
//						return false;
//      				} else {
//      					return true;
//      				}
//        		}
	        	if(e.record.phantom == false) {
	        		if(UniUtils.indexOf(e.field, ['WH_NAME'])) {
						return false;
					}
	        	}else{
	        		if(UniUtils.indexOf(e.field, ['WH_NAME'])) {
						return false;
					}
	        	}
	        } 	
        },
		setItemData: function(record, dataClear) {
       		var grdRecord = masterGrid.uniOpt.currentRecord;
       		if(dataClear) {
       			/*grdRecord.set( 'SEQ' 					, record['']);
       			grdRecord.set( 'COMP_CODE'				, record['']);
       			grdRecord.set( 'DIV_CODE'				, record['']);
       			grdRecord.set( 'POS_TYPE'				, record['']);
       			grdRecord.set( 'POS_NO'					, record['']);
       			grdRecord.set( 'POS_NAME'				, record['']);
       			grdRecord.set( 'SHOP_CODE'				, record['']);
       			grdRecord.set( 'SHOP_NAME'				, record['']);
       			grdRecord.set( 'WH_CODE'				, record['']);
       			grdRecord.set( 'BRAND_CODE'				, record['']);*/
       			grdRecord.set( 'DEPT_CODE'				, record['']);
       			grdRecord.set( 'DEPT_NAME'				, record['']);
       			/*grdRecord.set( 'STAFF_ID'				, record['']);
       			grdRecord.set( 'PHONE_NUMBER'			, record['']);
       			grdRecord.set( 'NAME_PLATE_LINE1'		, record['']);
       			grdRecord.set( 'NAME_PLATE_LINE2'		, record['']);
       			grdRecord.set( 'NAME_PLATE_LINE3'		, record['']);
       			grdRecord.set( 'NAME_PLATE_LINE4'		, record['']);
       			grdRecord.set( 'TOP_LINE1'				, record['']);
       			grdRecord.set( 'TOP_LINE2'				, record['']);
       			grdRecord.set( 'BOTTOM_LINE1'			, record['']);
       			grdRecord.set( 'BOTTOM_LINE2'			, record['']);
       			grdRecord.set( 'BOTTOM_LINE3'			, record['']);
       			grdRecord.set( 'REMARK'					, record['']);
       			grdRecord.set( 'INSERT_DB_USER'			, record['']);
       			grdRecord.set( 'INSERT_DB_TIME'			, record['']);
       			grdRecord.set( 'UPDATE_DB_USER'			, record['']);
       			grdRecord.set( 'UPDATE_DB_TIME'			, record['']);
       			grdRecord.set( 'TEMPC_01'				, record['']);
       			grdRecord.set( 'TEMPC_02'				, record['']);
       			grdRecord.set( 'TEMPC_03'				, record['']);
       			grdRecord.set( 'TEMPN_01'				, record['']);
       			grdRecord.set( 'TEMPN_02'				, record['']);
       			grdRecord.set( 'TEMPN_03'				, record['']);*/
			} else {
       			/*grdRecord.set( 'SEQ' 					, record['SEQ']);
       			grdRecord.set( 'COMP_CODE'				, record['COMP_CODE']);
       			grdRecord.set( 'DIV_CODE'				, record['DIV_CODE']);
       			grdRecord.set( 'POS_TYPE'				, record['POS_TYPE']);
       			grdRecord.set( 'POS_NO'					, record['POS_NO']);
       			grdRecord.set( 'POS_NAME'				, record['POS_NAME']);
       			grdRecord.set( 'SHOP_CODE'				, record['SHOP_CODE']);
       			grdRecord.set( 'SHOP_NAME'				, record['SHOP_NAME']);
       			grdRecord.set( 'WH_CODE'				, record['WH_CODE']);
       			grdRecord.set( 'BRAND_CODE'				, record['BRAND_CODE']);*/
       			grdRecord.set( 'DEPT_CODE'				, record['DEPT_CODE']);
       			grdRecord.set( 'DEPT_NAME'				, record['DEPT_NAME']);
       			/*grdRecord.set( 'STAFF_ID'				, record['STAFF_ID']);
       			grdRecord.set( 'PHONE_NUMBER'			, record['PHONE_NUMBER']);
       			grdRecord.set( 'NAME_PLATE_LINE1'		, record['NAME_PLATE_LINE1']);
       			grdRecord.set( 'NAME_PLATE_LINE2'		, record['NAME_PLATE_LINE2']);
       			grdRecord.set( 'NAME_PLATE_LINE3'		, record['NAME_PLATE_LINE3']);
       			grdRecord.set( 'NAME_PLATE_LINE4'		, record['NAME_PLATE_LINE4']);
       			grdRecord.set( 'TOP_LINE1'				, record['TOP_LINE1']);
       			grdRecord.set( 'TOP_LINE2'				, record['TOP_LINE2']);
       			grdRecord.set( 'BOTTOM_LINE1'			, record['BOTTOM_LINE1']);
       			grdRecord.set( 'BOTTOM_LINE2'			, record['BOTTOM_LINE2']);
       			grdRecord.set( 'BOTTOM_LINE3'			, record['BOTTOM_LINE3']);
       			grdRecord.set( 'REMARK'					, record['REMARK']);
       			grdRecord.set( 'INSERT_DB_USER'			, record['INSERT_DB_USER']);
       			grdRecord.set( 'INSERT_DB_TIME'			, record['INSERT_DB_TIME']);
       			grdRecord.set( 'UPDATE_DB_USER'			, record['UPDATE_DB_USER']);
       			grdRecord.set( 'UPDATE_DB_TIME'			, record['UPDATE_DB_TIME']);
       			grdRecord.set( 'TEMPC_01'				, record['TEMPC_01']);
       			grdRecord.set( 'TEMPC_02'				, record['TEMPC_02']);
       			grdRecord.set( 'TEMPC_03'				, record['TEMPC_03']);
       			grdRecord.set( 'TEMPN_01'				, record['TEMPN_01']);
       			grdRecord.set( 'TEMPN_02'				, record['TEMPN_02']);
       			grdRecord.set( 'TEMPN_03'				, record['TEMPN_03']);*/
       		}
		}
    });
    
  	Unilite.Main({
		borderItems:[{
			region: 'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		id  : 'bsa240ukrvApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['reset','newData'],true);
		},
		onQueryButtonDown: function() {	
			directMasterStore.loadStoreRecords();
			panelSearch.getField('DIV_CODE').setReadOnly(true);
			panelResult.getField('DIV_CODE').setReadOnly(true);
			
		},
		onResetButtonDown: function() {		// 새로고침 버튼
			panelSearch.reset();
			panelResult.reset();
			panelSearch.getField('DIV_CODE').setReadOnly(false);
			panelResult.getField('DIV_CODE').setReadOnly(false);
			masterGrid.getStore().loadData({});
			this.fnInitBinding();
			if(panelResult.isVisible()) panelResult.getField('POS_TYPE').focus();
			else panelSearch.getField('POS_TYPE').focus();
		},
		onNewDataButtonDown: function()	{
			var compCode	= UserInfo.compCode; 
			var divCode 	= panelSearch.getValue('DIV_CODE');
	        var seq 		= masterGrid.getStore().max('SEQ');
        	if(!seq) seq 	= 1;
        	else  seq 		+= 1;
        	var posType		= '';    
        	var posNo	  	= '';
        	var posName   	= ''; 
        	var shopCode   	= '';
        	var shopName   	= '';
        	var whCode     	= '';
        	var brandCode  	= '';
        	var deptCode  	= '';
        	var deptName  	= ''; 
        	var staffId   	= ''; 
        	var phoneNumber	= '';
        	var namePlateLine1	= '';
        	var namePlateLine2	= '';
        	var namePlateLine3	= '';
        	var namePlateLine4	= '';
        	var topLine1		= '';
        	var topLine2		= '';
        	var bottomLine1		= '';
        	var bottomLine2		= '';
        	var bottomLine3		= '';
        	var remark			= '';
        	
        	var r ={
        		COMP_CODE		: compCode,
        		DIV_CODE		: divCode,
        		SEQ				: seq,
        		POS_TYPE		: posType,
				POS_NO			: posNo,	
				POS_NAME		: posName,
				SHOP_CODE		: shopCode,
				SHOP_NAME		: shopName,
				WH_CODE			: whCode,
				BRAND_CODE		: brandCode,
				DEPT_CODE		: deptCode,
				DEPT_NAME		: deptName,
				STAFF_ID		: staffId,
				PHONE_NUMBER	: phoneNumber,
             	NAME_PLATE_LINE1: namePlateLine1,	
			 	NAME_PLATE_LINE2: namePlateLine2,	
			 	NAME_PLATE_LINE3: namePlateLine3,	
			 	NAME_PLATE_LINE4: namePlateLine4,	
			 	TOP_LINE1		: topLine1,		
			 	TOP_LINE2		: topLine2,		
			 	BOTTOM_LINE1	: bottomLine1,		
			 	BOTTOM_LINE2	: bottomLine2,		
			 	BOTTOM_LINE3	: bottomLine3,		
				REMARK			: remark,
				SEQ				: seq
        	};
            //param = {'SEQ':seq}
	        masterGrid.createRow(r);
		},
		onSaveDataButtonDown: function (config) {
			directMasterStore.saveStore(config);
		},
		onDeleteDataButtonDown : function()	{
			masterGrid.deleteSelectedRow();	
		},

		fnDeptChange: function(records) {
			grdRecord = masterGrid.getSelectedRecord();
			record = records[0];
			grdRecord.set('DEPT_CODE', record.TREE_CODE);
			grdRecord.set('DEPT_NAME', record.TREE_NAME);
			if(Ext.isEmpty(grdRecord.get('DIV_CODE'))){
				grdRecord.set('DIV_CODE', record.DIV_CODE);
			}
		},
		fnShopChange: function(records) {
			grdRecord = masterGrid.getSelectedRecord();
			record = records[0];
			grdRecord.set('SHOP_CODE', record.SHOP_CODE);
			grdRecord.set('SHOP_NAME', record.SHOP_NAME);
			grdRecord.set('WH_CODE', record.WH_CODE);
			grdRecord.set('BRAND_CODE', record.BRAND_CODE);
			grdRecord.set('DEPT_CODE', record.DEPT_CODE);
			grdRecord.set('DEPT_NAME', record.DEPT_NAME);
			grdRecord.set('STAFF_ID', record.STAFF_ID);
			grdRecord.set('PHONE_NUMBER', record.PHONE_NUMBER);
			if(Ext.isEmpty(grdRecord.get('DIV_CODE'))){
				grdRecord.set('DIV_CODE', record.DIV_CODE);
			}
		}
	});
	
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "WH_CODE" : // 창고코드
					if(newValue)	{
	            	 	record.set('WH_NAME',newValue);
	            	 }
				break;
			}
			return rv;
		}
	}); // validator
}; 


</script>
