<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="aga340ukr"  >

	<t:ExtComboStore comboType="BOR120"  /> 				<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A178" /> 	<!--기표구분-->
	<t:ExtComboStore comboType="AU" comboCode="A172" /> 	<!--결제방법-->
	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
</t:appConfig>
<script type="text/javascript">

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'aga340ukrService.selectList',
			update: 'aga340ukrService.updateDetail',
			create: 'aga340ukrService.insertDetail',
			destroy: 'aga340ukrService.deleteDetail',
			syncAll: 'aga340ukrService.saveAll'
		}
	});	
	
//	var astalic = false;
//	var record = masterGrid.getSelectedRecord();
//	if(record.get('GUBUN') == '1' || record.get('GUBUN') == '4') {
//		astalic = true;
//	}
	
	Unilite.defineModel('Aga340ukrModel', {		// 메인1
	    fields: [
	    	{name: 'COMP_CODE'			, text: 'COMP_CODE'			, type: 'string'},
	    	{name: 'GUBUN'				, text: '지출수입구분'			, type: 'string'/*, allowBlank: false*/, comboType: 'AU', comboCode: 'A178'},
	    	{name: 'TR_GUBUN'			, text: '구분'				, type: 'string'},
	    	{name: 'TR_GUBUN_NAME'		, text: '구분'				, type: 'string'/*, allowBlank: false*/},
	    	{name: 'PAY_DIVI'			, text: '결제방법'				, type: 'string'/*, allowBlank: false*/, comboType: 'AU', comboCode: 'A172'},
	    	{name: 'PAY_TYPE'			, text: '지출유형'				, type: 'string'/*, allowBlank: false*/, comboType: 'AU', comboCode: 'A177'},
	    	{name: 'MAKE_SALE'			, text: '제조판관구분'			, type: 'string'/*, allowBlank: false*/, comboType: 'AU', comboCode: 'A006'},
	    	{name: 'DR_CR'				, text: '차대구분'				, type: 'string'/*, allowBlank: false*/, comboType: 'AU', comboCode: 'A001'},
	    	{name: 'AMT_DIVI'			, text: '금액구분'				, type: 'string'/*, allowBlank: false*/, comboType: 'AU', comboCode: 'A176'},
	    	{name: 'ACCNT'				, text: '계정코드'				, type: 'string'/*, allowBlank: false*/},
	    	{name: 'ACCNT_NAME'			, text: '계정명'				, type: 'string'},
	    	{name: 'REMARK'				, text: '적요'				, type: 'string'},
	    	{name: 'INSERT_DB_USER'		, text: 'INSERT_DB_USER'	, type: 'string'},
	    	{name: 'INSERT_DB_TIME'		, text: 'INSERT_DB_TIME'	, type: 'string'},
	    	{name: 'UPDATE_DB_USER'		, text: 'UPDATE_DB_USER'	, type: 'string'},
	    	{name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME'	, type: 'string'}
	    ]
	});// End of Unilite.defineModel('Aga340ukrModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * 
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('aga340ukrMasterStore1', {
		model: 'Aga340ukrModel',
        autoLoad: false,
        uniOpt : {
    		isMaster: true,			// 상위 버튼 연결
        	editable: true,			// 수정 모드 사용
        	deletable:true,			// 삭제 가능 여부
            useNavi : false			// prev | newxt 버튼 사용
        },
        proxy: directProxy,
		loadStoreRecords : function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
			
		},
		saveStore : function(config)	{	
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	console.log("toUpdate",toUpdate);

        	var rv = true;
   	
        	if(inValidRecs.length == 0 )	{										
				config = {
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);			
					 } 
				};					
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});		// End of var directMasterStore1
	
	var panelsearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
    	region: 'west',
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
				fieldLabel: '지출/수입구분',
				name: 'GUBUN',
				xtype: 'uniCombobox',
				comboType : 'AU',
				comboCode : 'A178',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('GUBUN', newValue);
					}
				}
			},{
				fieldLabel: '결제방법',
				name: 'PAY_DIVI',
				xtype: 'uniCombobox',
				comboType : 'AU',
				comboCode : 'A172',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
					panelResult.setValue('PAY_DIVI', newValue);
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
		     		r = false;
		         	var labelText = ''
		     		if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
		          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		// this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	// this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});// End of var panelsearch = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '지출/수입구분',
				name: 'GUBUN',
				xtype: 'uniCombobox',
				comboType : 'AU',
				comboCode : 'A178',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
					panelsearch.setValue('GUBUN', newValue);
					}
				}
			},{
				fieldLabel: '결제방법',
				name: 'PAY_DIVI',
				xtype: 'uniCombobox',
				comboType : 'AU',
				comboCode : 'A172',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelsearch.setValue('PAY_DIVI', newValue);
					}
				}
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
		          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		// this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	// this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;
		   	me.uniOpt.inLoading = false;
		    me.setAllFieldsReadOnly(true);
		}
	});
	
	var masterGrid = Unilite.createGrid('aga340ukrGrid1', {
    	// for tab
		layout: 'fit',
		region: 'center',
		uniOpt:{expandLastColumn: false,
		 		useRowNumberer: false,
                useMultipleSorting: true
        },
    	store: directMasterStore1,
        columns: [
//        	{dataIndex: 'COMP_CODE'			, width:200, hidden : true},
        	{dataIndex: 'GUBUN'				, width : 100},
//        	{dataIndex: 'TR_GUBUN'			, width:200, hidden : true},
        	{dataIndex: 'TR_GUBUN_NAME'		, width : 100},
        	{dataIndex: 'PAY_DIVI'			, width : 100},
        	{dataIndex: 'PAY_TYPE'			, width : 100},
        	{dataIndex: 'MAKE_SALE'			, width : 100},
        	{dataIndex: 'DR_CR'				, width : 100},
        	{dataIndex: 'AMT_DIVI'			, width : 100},
        	{dataIndex: 'ACCNT'     		, width : 80, 
			  	editor: Unilite.popup('ACCNT_G', {
			  		autoPopup: true,
    				DBtextFieldName: 'ACCNT_CODE',
	 				listeners: {'onSelected': {
								fn: function(records, type) {
				                    console.log('records : ', records);
				                    var grdRecord = masterGrid.uniOpt.currentRecord;
				                    Ext.each(records, function(record,i) {	
										grdRecord.set('ACCNT', record['ACCNT_CODE']);
										grdRecord.set('ACCNT_NAME', record['ACCNT_NAME']);
									}); 
								},
									scope: this
								},
								'onClear': function(type) {
									var grdRecord = masterGrid.uniOpt.currentRecord;
									grdRecord.set('ACCNT', '');
									grdRecord.set('ACCNT_NAME', '');
								},
								applyextparam: function(popup){
									popup.setExtParam({'ADD_QUERY': "GROUP_YN = 'N'"});			//WHERE절 추카 쿼리
									popup.setExtParam({'CHARGE_CODE': ''});						//bParam(3)
								}
					}
				 }) 
			}, 				
			{dataIndex: 'ACCNT_NAME'		, width: 180, 
			  	editor: Unilite.popup('ACCNT_G', {	
			  		autoPopup: true,
	 				listeners: {'onSelected': {
								fn: function(records, type) {
				                    console.log('records : ', records);
				                    var grdRecord = masterGrid.uniOpt.currentRecord;
				                    Ext.each(records, function(record,i) {	
										grdRecord.set('ACCNT', record['ACCNT_CODE']);
										grdRecord.set('ACCNT_NAME', record['ACCNT_NAME']);
									}); 
								},
									scope: this
							},
							'onClear': function(type) {
								var grdRecord = masterGrid.uniOpt.currentRecord;
								grdRecord.set('ACCNT', '');
								grdRecord.set('ACCNT_NAME', '');
							},
							applyextparam: function(popup){
								popup.setExtParam({'ADD_QUERY': "GROUP_YN = 'N'"});			//WHERE절 추카 쿼리
								popup.setExtParam({'CHARGE_CODE': ''});						//bParam(3)
							}
					}
				 })
			},
        	{dataIndex: 'REMARK'			, width:200, flex: 1}
//        	{dataIndex: 'INSERT_DB_USER'	, width:0, hidden : true},
//        	{dataIndex: 'INSERT_DB_TIME'	, width:0, hidden : true},
//        	{dataIndex: 'UPDATE_DB_USER'	, width:0, hidden : true},
//        	{dataIndex: 'UPDATE_DB_TIME'	, width:0, hidden : true}
        	
		],
		listeners: {
        	beforeedit: function( editor, e, eOpts ) {
        		var record = masterGrid.getSelectedRecord();
        		if(record.get('GUBUN') == '1' || record.get('GUBUN') == '4' || Ext.isEmpty(record.get('GUBUN'))) {
	        		if(e.record.phantom == false) {
	        		 	if(UniUtils.indexOf(e.field, ['REMARK']))
					   	{
							return true;
	      				} else {
	      					return false;
	      				}
	        		} else {
	        			if(UniUtils.indexOf(e.field, ['TR_GUBUN_NAME']))
					   	{
							return false;
	      				} else {
	      					return true;
	      				}
	        		}
        		} else {
        			if(e.record.phantom == false) {
	        			if(UniUtils.indexOf(e.field))
					   	{
							return true;
	      				} else {
	      					return true;
	      				}
	        		} else {
	        			if(UniUtils.indexOf(e.field))
					   	{
							return true;
	      				} else {
	      					return true;
	      				}
	        		}
        		}
        	} 	
        }/*,
        setItemData: function(record, dataClear) {
       		var grdRecord = this.uniOpt.currentRecord;
       		if(dataClear) {
       			grdRecord.set('COMP_CODE'		, record['COMP_CODE']);
       			grdRecord.set('GUBUN'			, record['GUBUN']);
       			grdRecord.set('TR_GUBUN'		, record['TR_GUBUN']);
       			grdRecord.set('TR_GUBUN_NAME'	, record['TR_GUBUN_NAME']);
       			grdRecord.set('PAY_DIVI'		, record['PAY_DIVI']);
       			grdRecord.set('PAY_TYPE'		, record['PAY_TYPE']);
       			grdRecord.set('MAKE_SALE'		, record['MAKE_SALE']);
       			grdRecord.set('DR_CR'			, record['DR_CR']);
       			grdRecord.set('AMT_DIVI'		, record['AMT_DIVI']);
       			grdRecord.set('ACCNT'			, record['ACCNT']);
       			grdRecord.set('ACCNT_NAME'		, record['ACCNT_NAME']);
       			grdRecord.set('REMARK'			, record['REMARK']);
       			grdRecord.set('INSERT_DB_USER'	, record['INSERT_DB_USER']);
       			grdRecord.set('INSERT_DB_TIME'	, record['INSERT_DB_TIME']);
       			grdRecord.set('UPDATE_DB_USER'	, record['UPDATE_DB_USER']);
       			grdRecord.set('UPDATE_DB_TIME'	, record['UPDATE_DB_TIME']);
				
       		} else {
       			grdRecord.set('COMP_CODE'		, record['COMP_CODE']);
       			grdRecord.set('GUBUN'			, record['GUBUN']);
       			grdRecord.set('TR_GUBUN'		, record['TR_GUBUN']);
       			grdRecord.set('TR_GUBUN_NAME'	, record['TR_GUBUN_NAME']);
       			grdRecord.set('PAY_DIVI'		, record['PAY_DIVI']);
       			grdRecord.set('PAY_TYPE'		, record['PAY_TYPE']);
       			grdRecord.set('MAKE_SALE'		, record['MAKE_SALE']);
       			grdRecord.set('DR_CR'			, record['DR_CR']);
       			grdRecord.set('AMT_DIVI'		, record['AMT_DIVI']);
       			grdRecord.set('ACCNT'			, record['ACCNT']);
       			grdRecord.set('ACCNT_NAME'		, record['ACCNT_NAME']);
       			grdRecord.set('REMARK'			, record['REMARK']);
       			grdRecord.set('INSERT_DB_USER'	, record['INSERT_DB_USER']);
       			grdRecord.set('INSERT_DB_TIME'	, record['INSERT_DB_TIME']);
       			grdRecord.set('UPDATE_DB_USER'	, record['UPDATE_DB_USER']);
       			grdRecord.set('UPDATE_DB_TIME'	, record['UPDATE_DB_TIME']);
       			
       		}
		}*/
    });// End of var masterGrid = Unilite.createGrid('bcm120ukrvGrid1', {
	
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelsearch
		], 	
		id: 'bcm120ukrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons(['reset','newData'],true);
			UniAppManager.setToolbarButtons('save', false);
		},
		onQueryButtonDown: function() {
			if(panelsearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
			beforeRowIndex = -1;
			directMasterStore1.loadStoreRecords();
			UniAppManager.setToolbarButtons('newData', true);
		},
		setDefault: function() {		// 기본값
        	panelsearch.setValue('GUBUN', '');
        	panelsearch.setValue('PAY_DIVI', '');
        	panelsearch.getForm().wasDirty = false;
         	panelsearch.resetDirtyStatus();
         	UniAppManager.setToolbarButtons('save', false); 
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelsearch.clearForm();
			panelsearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			panelsearch.setValue('GUBUN', '');
			panelResult.setValue('GUBUN', '');
			panelsearch.setValue('TYPE_LEVEL', '');
			panelResult.setValue('TYPE_LEVEL', '');
			masterGrid.reset();
			this.fnInitBinding();
			directMasterStore1.clearData();
		},
		onNewDataButtonDown: function()	{		// 행추가
			// if(containerclick(masterGrid)) {
				var compCode		= 	UserInfo.compCode; 
				
				var r = {
					COMP_CODE:			compCode
				};
				masterGrid.createRow(r);
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			directMasterStore1.saveStore();
		},
		onDeleteDataButtonDown: function() {
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
        necessaryCheck: function(){
        	var record = masterGrid.getSelectedRecord();
        	UniAppManager.app.fnEssLevelColorInit();
        	if(!Ext.isEmpty(record.data.GUBUN) || record.data.GUBUN == '2' || record.data.GUBUN == '3'){
        		masterGrid.getColumn("GUBUN").setConfig('allowBlank',false);
				masterGrid.getColumn("GUBUN").setConfig('fieldStyle','background-image:none;background-color:#FAF4C0;');
        		masterGrid.getColumn("TR_GUBUN_NAME").setConfig('allowBlank',false);
				masterGrid.getColumn("TR_GUBUN_NAME").setConfig('fieldStyle','background-image:none;background-color:#FAF4C0;');
        		masterGrid.getColumn("PAY_DIVI").setConfig('allowBlank',false);
				masterGrid.getColumn("PAY_DIVI").setConfig('fieldStyle','background-image:none;background-color:#FAF4C0;');
        		masterGrid.getColumn("PAY_TYPE").setConfig('allowBlank',false);
				masterGrid.getColumn("PAY_TYPE").setConfig('fieldStyle','background-image:none;background-color:#FAF4C0;');
        		masterGrid.getColumn("MAKE_SALE").setConfig('allowBlank',false);
				masterGrid.getColumn("MAKE_SALE").setConfig('fieldStyle','background-image:none;background-color:#FAF4C0;');
        		masterGrid.getColumn("DR_CR").setConfig('allowBlank',false);
				masterGrid.getColumn("DR_CR").setConfig('fieldStyle','background-image:none;background-color:#FAF4C0;');
        		masterGrid.getColumn("AMT_DIVI").setConfig('allowBlank',false);
				masterGrid.getColumn("AMT_DIVI").setConfig('fieldStyle','background-image:none;background-color:#FAF4C0;');
        		masterGrid.getColumn("ACCNT").setConfig('allowBlank',false);
				masterGrid.getColumn("ACCNT").setConfig('fieldStyle','background-image:none;background-color:#FAF4C0;');
        	}
        },
        fnEssLevelColorInit: function(){
        		masterGrid.getColumn("GUBUN").setConfig('allowBlank',true);
				masterGrid.getColumn("GUBUN").setConfig('fieldStyle','background-image:none;background-color:#FFFFFF;');
        		masterGrid.getColumn("TR_GUBUN_NAME").setConfig('allowBlank',true);
				masterGrid.getColumn("TR_GUBUN_NAME").setConfig('fieldStyle','background-image:none;background-color:#FFFFFF;');
        		masterGrid.getColumn("PAY_DIVI").setConfig('allowBlank',true);
				masterGrid.getColumn("PAY_DIVI").setConfig('fieldStyle','background-image:none;background-color:#FFFFFF;');
        		masterGrid.getColumn("PAY_TYPE").setConfig('allowBlank',true);
				masterGrid.getColumn("PAY_TYPE").setConfig('fieldStyle','background-image:none;background-color:#FFFFFF;');
        		masterGrid.getColumn("MAKE_SALE").setConfig('allowBlank',true);
				masterGrid.getColumn("MAKE_SALE").setConfig('fieldStyle','background-image:none;background-color:#FFFFFF;');
        		masterGrid.getColumn("DR_CR").setConfig('allowBlank',true);
				masterGrid.getColumn("DR_CR").setConfig('fieldStyle','background-image:none;background-color:#FFFFFF;');
        		masterGrid.getColumn("AMT_DIVI").setConfig('allowBlank',true);
				masterGrid.getColumn("AMT_DIVI").setConfig('fieldStyle','background-image:none;background-color:#FFFFFF;');
        		masterGrid.getColumn("ACCNT").setConfig('allowBlank',true);
				masterGrid.getColumn("ACCNT").setConfig('fieldStyle','background-image:none;background-color:#FFFFFF;');
        	}
	});
	
	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {	
				case "GUBUN" : 
					if(newValue == '2' || newValue == '3') {
						UniAppManager.app.necessaryCheck();
						break;
					} else {
						break;
					}
					break;
			}
			return rv;
		}
	});	
};


</script>
