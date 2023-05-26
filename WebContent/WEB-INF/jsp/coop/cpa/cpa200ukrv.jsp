<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//운영자 공통코드 등록
request.setAttribute("PKGNAME","Unilite_app_cpa200ukrv");
%>
<t:appConfig pgmId="cpa200ukrv" >
	<t:ExtComboStore comboType="AU" comboCode="YP11"/>	<!-- 조합원구분 	-->
	<t:ExtComboStore comboType="AU" comboCode="YP15" />	<!-- 변동구분 	-->
</t:appConfig>
<script type="text/javascript">
	
function appMain() {
	var BsaCodeInfo = {	
		gsReceiptType: ${gsReceiptType}	// YP15 
	};	
//	var output =''; 
//	for(var key in BsaCodeInfo){
// 		output += key + '  :  ' + BsaCodeInfo[key] + '\n';
//	}
//	alert(output);

		Unilite.defineModel('MasterModel', {
			fields : [ 
				{name : 'COMP_CODE',			text : '법인코드',			type : 'string'},
				{name : 'COOPTOR_ID',			text : '조합원ID',		type : 'string'},
				{name : 'COOPTOR_NAME',			text : '조합원명',			type : 'string'},
				{name : 'COOPTOR_TYPE',			text : '조합원구분',		type : 'string', comboType : 'AU', comboCode : 'YP11'}
			]
		});
		
		var directMasterStore = Unilite.createStore('${PKGNAME}MasterStore', { 
			model : 'MasterModel',
			autoLoad : false,
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
			proxy : {
                type: 'direct',
                api: {			
                	   read: 'cpa200ukrvService.selectMaster'
                }
            },
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();	
				this.load({
					params : param
				});
			},
			listeners: {
	           	load: function(store, records, successful, eOpts) {
	           		if(!Ext.isEmpty(records)){
	           			directDetailStore.loadStoreRecords(records[0]);
	           		}
           		}
			}
		});
		
		Unilite.defineModel('DetailModel', {
			fields : [ 	  
				{name : 'COMP_CODE'			,		text : '법인코드',		type : 'string'	},
				{name : 'COOPTOR_ID'		,		text : '조합원ID',	type : 'string'	},
				{name : 'COOPTOR_NAME'		,		text : '조합원명',		type : 'string'	},
				{name : 'COOPTOR_TYPE'		,		text : '조합원구분',	type : 'string', comboType : 'AU', comboCode : 'YP11'},
				{name : 'INVEST_DATE'		,		text : '변동일자',		type : 'uniDate', allowBlank: false},
				{name : 'INOUT_TYPE'		,		text : '변동구분',		type : 'string', comboType : 'AU', comboCode : 'YP15', allowBlank: false},
				{name : 'INOUT_Q'			,		text : '구좌수량',		type : 'uniQty'	, allowBlank: false},
				{name : 'INOUT_AMT'			,		text : '변동금액',		type : 'uniPrice'},
				{name : 'CALC_POINT'		,		text : '변동포인트',	type : 'int'	},
				{name : 'COLLECT_TYPE'		,		text : '결제방법',		type : 'string'	},
				{name : 'COLLECT_YN'		,		text : '결제여부',		type : 'string'	},
				{name : 'REMARK'			,		text : '비고',		type : 'string'	},
				{name : 'INSERT_DB_TIME'	,		text : '입력일',		type : 'uniDate'	},
				{name : 'INSERT_DB_USER'	,		text : '입력자',		type : 'string'	},
				{name : 'UPDATE_DB_TIME'	,		text : '입력일',		type : 'uniDate'	},
				{name : 'UPDATE_DB_USER'	,		text : '입력자',		type : 'string'	},
				{name : 'TEMPC_01'			,		text : '',			type : 'string'	},
				{name : 'TEMPC_02'			,		text : '',			type : 'string'	},
				{name : 'TEMPC_03'			,		text : '',			type : 'string'	},
				{name : 'TEMPN_01'			,		text : '',			type : 'string'	},
				{name : 'TEMPN_02'			,		text : '',			type : 'string'	},
				{name : 'TEMPN_03'			,		text : '',			type : 'string'	}
			]
		});
		var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
			api: {
				read 	: 'cpa200ukrvService.selectDetail',
				create 	: 'cpa200ukrvService.insertDetail',
				update 	: 'cpa200ukrvService.updateDetail',
				destroy	: 'cpa200ukrvService.deleteDetail',
				syncAll	: 'cpa200ukrvService.saveAll'
			}
		});
		var directDetailStore = Unilite.createStore('directDetailStore', { 
			model : 'DetailModel',
			autoLoad : false,
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
			proxy : directProxy
			,loadStoreRecords : function(record)	{
				var param = record.data;
//				var param = masterGrid.getSelectedRecord();
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
		});

		// create the Grid
		var masterGrid = Unilite.createGrid('cpa100masterGrid', {
			enableColumnMove: false,
			store: directMasterStore, 	
	        layout : 'fit',
	        region:'center',
			uniOpt: {
			 	expandLastColumn: false,
			 	useRowNumberer: false,
			 	useContextMenu: false
		    },
	        itemId:'cpa100masterGrid',
			columns : [   
				{dataIndex : 'COMP_CODE'	,			width : 80, hidden: true},
				{dataIndex : 'COOPTOR_ID'	,			width : 120		},
				{dataIndex : 'COOPTOR_NAME'	,			width : 180		},
				{dataIndex : 'COOPTOR_TYPE'	,			width : 80		}
							
			],
			listeners : {
				cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
					if(rowIndex != beforeRowIndex){
						directDetailStore.loadStoreRecords(record);
					}
					if( directDetailStore.isDirty() )	{
						UniAppManager.setToolbarButtons('save', true);	
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
					beforeRowIndex = rowIndex;
				},
				beforeedit  : function( editor, e, eOpts ) {
		        	if(e.record.phantom == false) {
		        		if(UniUtils.indexOf(e.field, ['COOPTOR_ID', 'COOPTOR_NAME', 'COOPTOR_TYPE'])) 
						{ 
							return false;
	      				} 
		        	} else {
		        		if(UniUtils.indexOf(e.field, ['COOPTOR_ID', 'COOPTOR_NAME', 'COOPTOR_TYPE']))
					   	{
							return false;
	      				}
		        	}
		        }
	       }			
		});
		
		var detailGrid =  Unilite.createGrid('cpa200detailGrid', {
			enableColumnMove: false,
			itemId:'cpa200detailGrid',
			store : directDetailStore,	
	        layout : 'fit',
	        region:'east',
			uniOpt: {
			 	expandLastColumn: true,
			 	useRowNumberer: false,
			 	useContextMenu: true
		    },
			columns : [ 
				{dataIndex : 'COMP_CODE'		,				width: 130, hidden: true},
				{dataIndex : 'COOPTOR_ID'		,				width: 130, hidden: true},
				{dataIndex : 'COOPTOR_NAME'		,				width: 130, hidden: true},
				{dataIndex : 'COOPTOR_TYPE'		,				width: 130, hidden: true},
				{dataIndex : 'INVEST_DATE'		,				width: 110},
				{dataIndex : 'INOUT_TYPE'		,				width: 110},
				{dataIndex : 'INOUT_Q'			,				width: 110},
				{dataIndex : 'INOUT_AMT'		,				width: 130},
				{dataIndex : 'CALC_POINT'		,				width: 130},
				{dataIndex : 'COLLECT_TYPE'		,				width: 130, hidden: true},
				{dataIndex : 'COLLECT_YN'		,				width: 130, hidden: true},
				{dataIndex : 'REMARK'			,				width: 130},
				{dataIndex : 'INSERT_DB_TIME'	,				width: 130, hidden: true},
				{dataIndex : 'INSERT_DB_USER'	,				width: 130, hidden: true},
				{dataIndex : 'UPDATE_DB_TIME'	,				width: 130, hidden: true},
				{dataIndex : 'UPDATE_DB_USER'	,				width: 130, hidden: true},
				{dataIndex : 'TEMPC_01'			,				width: 130, hidden: true},
				{dataIndex : 'TEMPC_02'			,				width: 130, hidden: true},
				{dataIndex : 'TEMPC_03'			,				width: 130, hidden: true},
				{dataIndex : 'TEMPN_01'			,				width: 130, hidden: true},
				{dataIndex : 'TEMPN_02'			,				width: 130, hidden: true},
				{dataIndex : 'TEMPN_03'			,				width: 130, hidden: true}
			],
			listeners: {
		        beforeedit  : function( editor, e, eOpts, record ) {
		        	if(e.record.phantom == false) {
		        		if(UniUtils.indexOf(e.field, ['INVEST_DATE', 'INOUT_Q'])) 
						{ 
							if (e.record.get('INOUT_TYPE') == '4') {
			        			if(UniUtils.indexOf(e.field, ['INOUT_Q'])) {
			        				return false;
			        			}
		        			}
		        			if (e.record.get('INOUT_TYPE') == '5') {
			        			if(UniUtils.indexOf(e.field, ['INOUT_Q'])) {
			        				return false;
			        			}
		        			}
							return true;
	      				} else if (e.record.get('INOUT_TYPE') == '5') {
		        			if(UniUtils.indexOf(e.field, ['CALC_POINT'])) {
		        				return true;
		        			}
		        		} else {
	      					return false;
	      				}
		        	} else {
		        		if(UniUtils.indexOf(e.field, ['INVEST_DATE', 'INOUT_TYPE', 'INOUT_Q'])) 
						{
							if (e.record.get('INOUT_TYPE') == '4') {
			        			if(UniUtils.indexOf(e.field, ['INOUT_Q'])) {
			        				return false;
			        			}
		        			}
		        			if (e.record.get('INOUT_TYPE') == '5') {
			        			if(UniUtils.indexOf(e.field, ['INOUT_Q'])) {
			        				return false;
			        			}
		        			}
							return true;
	      				} else if (e.record.get('INOUT_TYPE') == '5') {
		        			if(UniUtils.indexOf(e.field, ['CALC_POINT'])) {
		        				return true;
		        			}
		        		} else {
	      					return false;
	      				}
		        	}
		        }
			}
		});
	
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		defaults: {
			autoScroll:true
	  	},
		items:[{
			title: '기본정보', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',   			
	    	items:[{	    
				fieldLabel: '조합원 ID',
				name: 'COOPTOR_ID',
	    		holdable: 'hold',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('COOPTOR_ID', newValue);
					}
				}
			},{
			    fieldLabel: '조합원명',
				name: 'COOPTOR_NAME',
	    		holdable: 'hold',	
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('COOPTOR_NAME', newValue);
					}
				}
			},{
				fieldLabel: '구분',
				name: 'COOPTOR_TYPE' ,
				xtype: 'uniCombobox' ,
	    		holdable: 'hold',
				comboType: 'AU',
				comboCode: 'YP11',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('COOPTOR_TYPE', newValue);
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
		          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
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
		    	//this.unmask();
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
		}
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{	    
			fieldLabel: '조합원ID',
			name: 'COOPTOR_ID',
	    	holdable: 'hold',
			
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('COOPTOR_ID', newValue);
				}
			}
		},{
		    fieldLabel: '조합원명',
			name: 'COOPTOR_NAME',
	    	holdable: 'hold',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('COOPTOR_NAME', newValue);
				}
			}
		},{
			fieldLabel: '구분',
			name: 'COOPTOR_TYPE' ,
	    	holdable: 'hold',
			xtype: 'uniCombobox' ,
			comboType: 'AU',
			comboCode: 'YP11',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('COOPTOR_TYPE', newValue);
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
		      		//this.mask();
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
		    	//this.unmask();
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
		}	
    });
		
    Unilite.Main({
			borderItems:[{
				region:'center',
				layout: 'border',
				border: false,
				items:[panelResult,
					{
						region : 'west',
						xtype : 'container',
						width : 350,
						layout : 'fit',
						items : [ masterGrid ]
					},{
						region : 'center',
						xtype : 'container',
						layout : 'fit',
						flex : 1,
						items : [ detailGrid ]
					} 
				]	
			}		
			,panelSearch 
			]
			, fnInitBinding : function() {
				UniAppManager.setToolbarButtons(['reset'],false);
			}
			, onQueryButtonDown:function() {
				UniAppManager.setToolbarButtons(['reset', 'newData'],true);
				if(panelSearch.setAllFieldsReadOnly(true) == false){
					return false;
				}
				if(panelResult.setAllFieldsReadOnly(true) == false){
					return false;
				}
				beforeRowIndex = -1;
				masterGrid.getStore().loadStoreRecords();
			}
			, onDeleteDataButtonDown: function() {
				if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					detailGrid.deleteSelectedRow();
				}
			}
			, onNewDataButtonDown : function()	{
				var record = masterGrid.getSelectedRecord();
				var compCode		= 	UserInfo.compCode; 
				var cooptorId		=	record.get('COOPTOR_ID');
				var cooptorName		=	record.get('COOPTOR_NAME');
				var cooptorType		=	record.get('COOPTOR_TYPE');
				var investDate		=	UniDate.get('today');
				var inoutType 		=	'';
				var inoutQ    		=	0;
				var inoutAmt  		=	0;
				var calcPoint 		=	0;
				var collectType		=	'';
				var collectYn 		=	'N';
				var remark 			=	'';
				
				var r = {
					COMP_CODE		:	compCode,	
					COOPTOR_ID		:	cooptorId,	
					COOPTOR_NAME	:	cooptorName,	
					COOPTOR_TYPE	:	cooptorType,	
					INVEST_DATE		:	investDate,
					INOUT_TYPE		:	inoutType,
					INOUT_Q			:	inoutQ,
					INOUT_AMT		:	inoutAmt,
					CALC_POINT		:	calcPoint,
					COLLECT_TYPE	:	collectType,	
					COLLECT_YN		:	collectYn,
					REMARK			:	remark
				};
				detailGrid.createRow(r);
			}
			, onSaveDataButtonDown: function () {										
				if(directDetailStore.isDirty())	{
					directDetailStore.saveStore();						
				}
			}
			, rejectSave: function()	{
				directMasterStore.rejectChanges();
				UniAppManager.setToolbarButtons('save',false);
			} 	
			, confirmSaveData: function()	{
            	if(directDetailStore.isDirty())	{
					if(confirm(Msg.sMB061))	{
						this.onSaveDataButtonDown();
					} else {
						this.rejectSave();
					}
				}
            }
			, onResetButtonDown: function() {
				panelSearch.reset();
				panelResult.reset();
				panelSearch.setAllFieldsReadOnly(false);
				panelResult.setAllFieldsReadOnly(false);
				masterGrid.reset();
				detailGrid.reset();
				this.fnInitBinding();
				directMasterStore.clearData();
				directDetailStore.clearData();
			}
			, fnGetData: function(record, newValue)	{
	        	var fRecord = '';
	        	if(record.get('INOUT_TYPE') == '1' || record.get('INOUT_TYPE') == '2') {
	        		Ext.each(BsaCodeInfo.gsReceiptType, function(item, i)	{
	        			if(record.get('INOUT_TYPE') == item['codeNo']) {
	        				record.set('INOUT_AMT', newValue * item['refCode1']);
	        				record.set('CALC_POINT', newValue * item['refCode1'] * (item['refCode2'] * 0.01));
	        			}
	        		});
	        	} else if(record.get('INOUT_TYPE') == '3') {
	        		Ext.each(BsaCodeInfo.gsReceiptType, function(item, i)	{
	        			if(record.get('INOUT_TYPE') == item['codeNo']) {
	        				record.set('INOUT_AMT', (newValue * item['refCode1']) * -1);
	        				record.set('CALC_POINT', (newValue * item['refCode1'] * (item['refCode2'] * 0.01)) * -1);
	        			}
	        		});
	        	} else {
	        		Ext.each(BsaCodeInfo.gsReceiptType, function(item, i)	{
	        			if(record.get('INOUT_TYPE') == item['codeNo']) {
	        				record.set('INOUT_AMT', 0);
	        				record.set('CALC_POINT', 0);
	        			}
	        		});
	        	}
	        		
	        	return fRecord;
	        }
	        , fnGetData2: function(record, newValue)	{
	        	var fRecord = '';
	        	if(newValue == '1' || newValue == '2') {
	        		Ext.each(BsaCodeInfo.gsReceiptType, function(item, i)	{
	        			if(newValue == item['codeNo']) {
	        				record.set('INOUT_AMT', record.get('INOUT_Q') * item['refCode1']);
	        				record.set('CALC_POINT', record.get('INOUT_Q') * item['refCode1'] * (item['refCode2'] * 0.01));
	        			}
	        		});
	        	} else if(newValue == '3') {
	        		Ext.each(BsaCodeInfo.gsReceiptType, function(item, i)	{
	        			if(newValue == item['codeNo']) {
	        				record.set('INOUT_AMT', (record.get('INOUT_Q') * item['refCode1']) * -1);
	        				record.set('CALC_POINT', (record.get('INOUT_Q') * item['refCode1'] * (item['refCode2'] * 0.01)) * -1);
	        			}
	        		});
	        	} else {
	        		Ext.each(BsaCodeInfo.gsReceiptType, function(item, i)	{
	        			if(newValue == item['codeNo']) {
	        				record.set('INOUT_AMT', 0);
	        				record.set('CALC_POINT', 0);
	        			}
	        		});
	        	}
	        		
	        	return fRecord;
	        }
		});
		
		Unilite.createValidator('validator01', {
			store: directMasterStore,
			grid: detailGrid,
			validate: function( type, fieldName, newValue, oldValue, record, eopt) {
				console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
				var rv = true;
				switch(fieldName) {
					case "INOUT_Q" :	// 구좌수량
						if(record.get('INOUT_TYPE') == '') {
							alert("변동구분을 먼저 입력해 주세요.");
							//record.set('INOUT_Q', 0);
							break;
						} else {
							UniAppManager.app.fnGetData(record, newValue);
						}
					break;
					
					case "INOUT_TYPE" :	// 변동구분
						UniAppManager.app.fnGetData2(record, newValue);
					break;
				}
				return rv;
			}
		})
};
</script>