<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agd340ukr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="agd340ukr"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A180" /> <!-- 구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A014" /> <!-- 전표승인여부 -->
	
	
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	

<script type="text/javascript" >

var BsaCodeInfo = {	

};
var CustomCodeInfo = {
};
/*var output ='';
for(var key in BsaCodeInfo){
 output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);*/


var gsDivCdList =''; 
var gsDivNmList ='';  
var gsDivFlag =''; 

var oprFlag = '';

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'agd340ukrService.selectDetailList',
			update: 'agd340ukrService.updateDetail',
//			create: 'agd340ukrService.insertDetail',
//			destroy: 'agd340ukrService.deleteDetail',
			syncAll: 'agd340ukrService.saveAll'
		}
	});	
	
	
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Agd340ukrModel', {
	    fields: [
	    	{name: 'SEQ'				 ,text: '순번' 				,type: 'uniNumber'},
	    	{name: 'SAVE_FLAG'		     ,text: 'SAVE_FLAG' 		,type: 'string'},
	    	{name: 'TRANS_DATE'			 ,text: '자금이체일' 			,type: 'uniDate'},
	    	{name: 'PROV_DRAFT_NO'		 ,text: '지출결의번호' 			,type: 'string'},
	    	{name: 'REMARK'				 ,text: '지출건명/적요' 		,type: 'string'},
	    	{name: 'INPUT_GUBUN'		 ,text: '지급구분' 			,type: 'string'},
	    	{name: 'REAL_AMT_I'			 ,text: '지급액' 				,type: 'uniPrice'},
	    	{name: 'TRANS_KEY'			 ,text: '이체지급KEY' 			,type: 'string'},
	    	{name: 'EX_DATE'			 ,text: '결의일자' 			,type: 'uniDate'},
	    	{name: 'EX_NUM'				 ,text: '번호' 				,type: 'uniNumber'},
	    	{name: 'EX_INFO'			 ,text: '전표정보' 			,type: 'string'},
	    	{name: 'AP_STS'				 ,text: '전표승인여부' 			,type: 'string'},
	    	{name: 'AP_STS_NM'			 ,text: '전표승인여부' 			,type: 'string'},
	    	{name: 'COMP_CODE'			 ,text: 'COMP_CODE' 		,type: 'string'},
	    	{name: 'DIV_CODE'			 ,text: 'DIV_CODE' 			,type: 'string'}
	    	
	    	
		]
	});
		
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directDetailStore = Unilite.createStore('agd340ukrDetailStore', {
		model: 'Agd340ukrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,			// 수정 모드 사용 
			deletable: false,		// 삭제 가능 여부 
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			var paramMaster= subForm.getValues();	//syncAll 수정
			
			paramMaster.oprFlag = oprFlag;
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();

//						subForm.getForm().wasDirty = false;
//						subForm.resetDirtyStatus();
//						UniAppManager.updateStatus(Msg.sMA0328);
						UniAppManager.setToolbarButtons('save', false);	
						if(Ext.getCmp('rdoWork').getValue().WORK == 'Proc'){
							Ext.Msg.alert("확인",Msg.sMA0328);
						}else if(Ext.getCmp('rdoWork').getValue().WORK == 'Canc'){
							Ext.Msg.alert("확인",Msg.sMA0329);
						}
						UniAppManager.app.onQueryButtonDown();

					 },
					 failure: function(){
					 	UniAppManager.setToolbarButtons('save', false);	
					 	UniAppManager.app.getTopToolbar().getComponent('save').setDisabled(true);
					 }
				};
				this.syncAllDirect(config);
				UniAppManager.setToolbarButtons('save', false);	
				UniAppManager.app.getTopToolbar().getComponent('save').setDisabled(true);
			} else {
                var grid = Ext.getCmp('agd340ukrGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
        
//           		store.getAt(store.length).get('PAY_TOT');
       /*    		if(!Ext.isEmpty(records)){
	           		Ext.getCmp('bbarPayTot').setValue(records[records.length -1].data.PAY_TOT);
	           		Ext.getCmp('bbarIncTot').setValue(records[records.length -1].data.INC_TOT);
	           		Ext.getCmp('bbarLocTot').setValue(records[records.length -1].data.LOC_TOT);
	           		Ext.getCmp('bbarRealTot').setValue(records[records.length -1].data.REAL_TOT);
           		}*/
           		
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		},
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();	
			param.WORK = Ext.getCmp('rdoWork').getValue().WORK;
			console.log( param );
			this.load({
				params: param
			});
		}/*,
		groupField:'PROV_DRAFT_NO'*/
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
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
	    		fieldLabel: '자금이체일',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'FR_DATE',
			    endFieldName: 'TO_DATE',
			    startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
			    allowBlank: false,                	
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelResult.setValue('FR_DATE', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelResult.setValue('TO_DATE', newValue);				    		
			    	}
			    }
			},{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        // value:UserInfo.divCode,
		        comboType:'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '지급구분',
				name:'INPUT_GUBUN',	
				xtype: 'uniCombobox',
			    comboType:'AU',
				comboCode:'A180',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {
			    		panelResult.setValue('INPUT_GUBUN', newValue);
			    	}
		 		}
			},
			Unilite.popup('CUST',{
				fieldLabel: '거래처', 
				valueFieldName:'CUSTOM_CODE',
			    textFieldName:'CUSTOM_NAME',
//				    validateBlank:'text',
			    listeners: {
			    	onValueFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_CODE',newValue);	
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('CUSTOM_NAME', newValue);	
					}
				}
			}),
			{
				fieldLabel: '전표승인여부',
				id:'apStsPS',
				name:'AP_STS',	
				xtype: 'uniCombobox',
			    comboType:'AU',
				comboCode:'A014',
//				hidden:true,
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {
			    		panelResult.setValue('AP_STS', newValue);
			    	}
		 		}
			}]	
		}]

	});
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3,
//		tableAttrs: { width: '100%'},
//        	trAttrs: {style: 'border : 1px solid #ced9e7;',align : 'center',width: '100%'},
        	tdAttrs: {/*style: 'border : 1px solid #ced9e7;',align : 'left',*/width: 500}
		
		},
		padding:'1 1 1 1',
		border:true,
		items: [{ 
	    		fieldLabel: '자금이체일',
	    		labelWidth:150,
			    xtype: 'uniDateRangefield',
			    startFieldName: 'FR_DATE',
			    endFieldName: 'TO_DATE',
			    startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
			    allowBlank: false,                	
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelSearch.setValue('FR_DATE', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('TO_DATE', newValue);				    		
			    	}
			    }
			},{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        // value:UserInfo.divCode,
		        comboType:'BOR120',
				width: 325,
				colspan:2,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '지급구분',
				labelWidth:150,
				name:'INPUT_GUBUN',	
				xtype: 'uniCombobox',
			    comboType:'AU',
				comboCode:'A180',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {
			    		panelSearch.setValue('INPUT_GUBUN', newValue);
			    	}
		 		}
			},
			Unilite.popup('CUST',{
				fieldLabel: '거래처', 
				valueFieldName:'CUSTOM_CODE',
			    textFieldName:'CUSTOM_NAME',
//				    validateBlank:'text',
			    listeners: {
			    	onValueFieldChange: function(field, newValue){
						panelSearch.setValue('CUSTOM_CODE', newValue);	
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('CUSTOM_NAME', newValue);	
					}
				}
			}),
			{
				xtype: 'container',
				layout: {type : 'hbox', columns : 1},
				width:300,
//				tdAttrs: {width:'100%',align : 'left'},
				defaults : {enforceMaxLength: true},
				padding : '0 0 2 0',
				items :[{
					fieldLabel: '전표승인여부',
					id:'apStsPR',
					name:'AP_STS',	
					xtype: 'uniCombobox',
				    comboType:'AU',
					comboCode:'A014',
	//				hidden:true,
				    listeners: {
				    	change: function(field, newValue, oldValue, eOpts) {
				    		panelSearch.setValue('AP_STS', newValue);
				    	}
			 		}
				}]
			}]/*,
			afterrender:function()	{
				
				if(Ext.getCmp('rdoWork').getValue().WORK == 'Canc'){
					Ext.getCmp('apStsPS').setVisible(true);	
					Ext.getCmp('apStsPR').setVisible(true);	
					UniAppManager.app.fnSetCaptionBtnAutoSlip();
				}else{
					Ext.getCmp('apStsPS').setVisible(false);	
					Ext.getCmp('apStsPR').setVisible(false);	
					UniAppManager.app.fnSetCaptionBtnAutoSlip();
				}
				
//				Ext.getCmp('apStsPS').setVisible(false);	
//				Ext.getCmp('apStsPR').setVisible(false);
			}*/
    });		
	
    
    
	    	
	    	
	    	
	    	
	    	
    
    
    
    
    
    var subForm = Unilite.createSimpleForm('resultForm2',{
    	region: 'north',
//    	flex:0.5,
    	height:70,
		layout : {type : 'uniTable', columns : 3,
			tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'},
        	tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'/*,align : 'left'*/}
	
		},
		
		border:true,
		items: [{
		   xtype: 'container',
		   layout: {type : 'uniTable', columns : 2},
		   width:500,
		   tdAttrs: {width:500/*,align : 'center'*/},
//		   id:'hiddenContainerPR',
		   defaults : {enforceMaxLength: true},
		   items :[{ 
		    		fieldLabel: '일괄기표전표일',
		    		labelWidth:150,
				    xtype: 'uniDatefield',
				    name: 'EX_DATE',
				    value:UniDate.get('today'),
				    allowBlank: false,
				    listeners: {
				    	change: function(field, newValue, oldValue, eOpts) { 
//				    		panelSearch.setValue('EX_DATE', newValue);
				      	}
		     		}
				},{
					xtype: 'radiogroup',
					items: [{
						boxLabel: '발생일', 
						width: 60,
						name: 'DATE_OPT',
						inputValue: 'C',
						checked: true  
					},{
						boxLabel: '실행일', 
						width: 80,
						name: 'DATE_OPT',
						inputValue: 'B'
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							if(newValue.DATE_OPT == 'C'){
								subForm.getField('EX_DATE').setReadOnly(true);
							}else{
								subForm.getField('EX_DATE').setReadOnly(false);
							}
							
//							panelSearch.getField('DATE_OPT').getValue(newValue.DATE_OPT);					
	//							UniAppManager.app.onQueryButtonDown();
						}
					}
				}]
    	},{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:300,
			tdAttrs: {width:'100%', align:'left'},
			defaults : {enforceMaxLength: true},
			colspan:2,
			items :[{
				xtype: 'radiogroup',	
				id:'rdoWork',
				fieldLabel: '작업구분',
				items: [{
					boxLabel: '자동기표', 
					width: 80,
					name: 'WORK',
					inputValue: 'Proc',
					checked: true  
				},{
					boxLabel: '기표취소', 
					width: 80,
					name: 'WORK',
					inputValue: 'Canc'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {					
						if(newValue.WORK == 'Canc'){
						panelResult.getField('AP_STS').setVisible(true);
						panelSearch.getField('AP_STS').setVisible(true);
//						if(Ext.getCmp('rdoWork').getValue().WORK == 'Canc'){
//							Ext.getCmp('apStsPS').setVisible(true);	
//							Ext.getCmp('apStsPR').setVisible(true);	
							UniAppManager.app.fnSetCaptionBtnAutoSlip();
						}else{
//							Ext.getCmp('apStsPS').setVisible(false);	
//							Ext.getCmp('apStsPR').setVisible(false);	
							panelResult.getField('AP_STS').setVisible(false);
							panelSearch.getField('AP_STS').setVisible(false);
							UniAppManager.app.fnSetCaptionBtnAutoSlip();
						}
						UniAppManager.app.onQueryButtonDown();
					}
				}
			}]
    	},
    	
    	
    	/*{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 1},
			width:120,
			tdAttrs: {width:'100%',align : 'right'},
			defaults : {enforceMaxLength: true},
//				tdAttrs: {align : 'right'},
			items :[{
				xtype:'component',
				html:'자동기표조회',
//		    		id: 'btnLinkSlip',
	    		name: 'LINKSLIP',
	    		width: 110,	
	    		tdAttrs: {width:'100%',align : 'center'},
	    		componentCls : 'component-text_first',
				listeners:{
					render: function(component) {
		                component.getEl().on('click', function( event, el ) {
		                	UniAppManager.app.fnOpenSlip();
		                });
		            }
				}
			}]
    	},*/{
			xtype: 'container',
			layout: {type : 'uniTable', columns : 4},
			width:500,
			tdAttrs: {align:'right'},
			colspan:3,
			defaults : {enforceMaxLength: true},
			items :[{
	        	fieldLabel:'지급액 합계',
	        	labelAlign : 'right',
	        	labelStyle: "color: blue;",
	        	xtype:'uniNumberfield',
	        	id:'realAmtI',
	        	name:'REAL_AMT_I',
	        	tdAttrs: {width:100},
	        	readOnly:true
			},{
				xtype: 'button',
				id: 'btnAutoSlipC',
				text: '개별자동기표',
				tdAttrs: {width:100,align:'center'},
	        	handler: function() {
	        		if(!panelResult.getInvalidMessage()) return false; 
	        		if(!subForm.getInvalidMessage()) return false; 
	        		subForm.setValue('HDD_PROC_TYPE','C');
	        		
	        		if(Ext.getCmp('rdoWork').getValue().WORK == 'Proc'){
	        			UniAppManager.app.fnAutoSlipProc(); //개별자동기표
	        		}else if(Ext.getCmp('rdoWork').getValue().WORK == 'Canc'){
	        			UniAppManager.app.fnAutoSlipCanc(); //개별기표취소
	        		}
	        	}
	    	},{
				xtype: 'button',
				id: 'btnAutoSlipB',
				text: '일괄자동기표',
				tdAttrs: {width:100},
	        	handler: function() {
	        		if(!panelResult.getInvalidMessage()) return false; 
	        		if(!subForm.getInvalidMessage()) return false; 
	        		subForm.setValue('HDD_PROC_TYPE','B');
	        		
	        		if(Ext.getCmp('rdoWork').getValue().WORK == 'Proc'){
	        			UniAppManager.app.fnAutoSlipProc(); //일괄자동기표
	        		}else if(Ext.getCmp('rdoWork').getValue().WORK == 'Canc'){
	        			UniAppManager.app.fnAutoSlipCanc(); //일괄기표취소
	        		}
	        	
	        	}
	    	},{
				xtype: 'uniTextfield',
				id: 'hddProcType',
				name:'HDD_PROC_TYPE',
				text: '개별/일괄구분',
				tdAttrs: {width:100},
				hidden:true
	    	}]
    	}]
	});	 
    	
	/*var sumForm = Unilite.createSimpleForm('resultForm3',{
    	region: 'south',
    	border:true,
	    items: [{	
	    	xtype:'container',
	    	padding:'0 5 5 5',
	        defaultType: 'uniTextfield',
	        layout: {
	        	type: 'uniTable',
	        	columns : 4,
	        	tableAttrs: {align:'right'}
	        },
	        items: [{
	        	fieldLabel: '지급총액',
	        	name:'',
	        	xtype: 'uniNumberfield',
	        	readOnly: true
	        },{
	       	 	fieldLabel: '소득세',
	       	 	name:'',
	       	 	xtype: 'uniNumberfield',
	        	readOnly: true
	        },{
	        	fieldLabel: '주민세',
	        	name:'',
	        	xtype: 'uniNumberfield',
	        	readOnly: true
	        },{
	       	 	fieldLabel: '실지급액',
	       	 	name:'',
	       	 	xtype: 'uniNumberfield',
	        	readOnly: true
	        }]
	    }]
    });	 */
            
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var detailGrid = Unilite.createGrid('agd340ukrGrid', {
    	// for tab    	
//    	flex:3,
//		layout: 'fit',
		region: 'center',
		excelTitle: '자금이체자동기표',
		/*tbar: ['->',
        	{
        	fieldLabel:'지급액 합계',
        	labelAlign : 'right',
        	labelStyle: "color: blue;",
        	xtype:'uniNumberfield',
        	id:'tbarRealAmtI',
        	name:'REAL_AMT_I',
        	readOnly:true
		},{
			xtype: 'button',
			id: 'btnAutoSlipC',
			text: '개별자동기표',
        	handler: function() {}
    	},{
			xtype: 'button',
			id: 'btnAutoSlipB',
			text: '일괄자동기표',
        	handler: function() {}
    	},{
			xtype: 'uniTextfield',
			id: 'hddProcType',
			text: '개별/일괄구분',
			hidden:true
    	}],*/
		uniOpt: {
    		useMultipleSorting	: true,
    		useLiveSearch		: true,
			useRowContext 		: true,
			expandLastColumn	: true,
			onLoadSelectFirst 	: false,
    		dblClickToEdit		: false,
    		onLoadSelectFirst	: false, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false
        },
        uniRowContextMenu:{
			items: [{	
				text: '자금이체등록',   
				id:'linkAfb900ukr',
            	handler: function(menuItem, event) {
            		var param = menuItem.up('menu');
            		detailGrid.gotoAfb900ukr(param.record);
            	}
        	},{	
        		text: '지출결의등록',   
        		id:'linkAfb700ukr',
            	handler: function(menuItem, event) {
            		var param = menuItem.up('menu');
            		detailGrid.gotoAfb700ukr(param.record);
            	}
        	},{	
        		text: '결의전표입력(전표번호별)',   
        		id:'linkAgj105ukr',
            	handler: function(menuItem, event) {
            		var param = menuItem.up('menu');
            		detailGrid.gotoAgj105ukr(param.record);
            	}
        	}]
	    },
		features: [{
			id: 'detailGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: true
		},{
			id: 'detailGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
		store: directDetailStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', {
			checkOnly:true,
//			ignoreRightMouseSelection : true,
//			showHeaderCheckbox : false,
//        	suppressEvent : true,
        	listeners: {        		
        		beforeselect: function(rowSelection, record, index, eOpts) {
        			if(record.get('AP_STS') == '2'){ //확인필요
						return false;
					}
        		},
				select: function(grid, record, index, eOpts ){
					record.set('SAVE_FLAG','CALL');
					var realAmtI = 0;
					
					realAmtI = subForm.getValue('REAL_AMT_I');
					
					realAmtI = realAmtI + record.get('REAL_AMT_I');
					
					subForm.setValue('REAL_AMT_I', realAmtI);
					
					UniAppManager.setToolbarButtons('save',false);
					
	          	},
				deselect:  function(grid, record, index, eOpts ){
					record.set('SAVE_FLAG','');
					var realAmtI = 0;
					
					realAmtI = subForm.getValue('REAL_AMT_I');
					
					realAmtI = realAmtI - record.get('REAL_AMT_I');
					
					subForm.setValue('REAL_AMT_I', realAmtI);
				
					UniAppManager.setToolbarButtons('save',false);
        		}
        	}
        }),
		columns: [        
        	{ dataIndex: 'SEQ'					, 	width:46,align:'center'}, 
//        	{ dataIndex: 'CHOICE'				, 	width:46}, 
        	{ dataIndex: 'TRANS_DATE'			, 	width:93}, 
        	{ dataIndex: 'PROV_DRAFT_NO'		, 	width:120}, 
        	{ dataIndex: 'REMARK'				, 	width:400}, 
        	{ dataIndex: 'INPUT_GUBUN'			, 	width:80,align:'center'}, 
        	{ dataIndex: 'REAL_AMT_I'			, 	width:120}, 
        	{ dataIndex: 'TRANS_KEY'			, 	width:100,hidden:true}, 
        	{ dataIndex: 'EX_DATE'				, 	width:93}, 
        	{ dataIndex: 'EX_NUM'				, 	width:66}, 
        	{ dataIndex: 'EX_INFO'				, 	width:133,hidden:true}, 
        	{ dataIndex: 'AP_STS'				, 	width:80,hidden:true}, 
        	{ dataIndex: 'AP_STS_NM'			, 	width:100}, 
        	{ dataIndex: 'COMP_CODE'			, 	width:66,hidden:true}, 
        	{ dataIndex: 'DIV_CODE'				, 	width:66,hidden:true}
        ],
        listeners: {
			beforeedit : function( editor, e, eOpts ) {
				return false;
			},
			itemmouseenter:function(view, record, item, index, e, eOpts )	{  
	        	if( (!Ext.isEmpty(record.get('TRANS_DATE'))) || 
	        	    (!Ext.isEmpty(record.get('PROV_DRAFT_NO'))) || 
	        	    (!Ext.isEmpty(record.get('EX_DATE')))
	        	){
	        		view.ownerGrid.setCellPointer(view, item);
	        	}
        	}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{ 
			if( (!Ext.isEmpty(record.get('TRANS_DATE'))) && 
	            (!Ext.isEmpty(record.get('PROV_DRAFT_NO'))) && 
	        	(!Ext.isEmpty(record.get('EX_DATE')))
	        ){
				menu.down('#linkAfb900ukr').show();
				menu.down('#linkAfb700ukr').show();
				menu.down('#linkAgj105ukr').show();
				
	        }else if( (!Ext.isEmpty(record.get('TRANS_DATE'))) && 
	            	  (!Ext.isEmpty(record.get('PROV_DRAFT_NO'))) && 
	        		  (Ext.isEmpty(record.get('EX_DATE')))	
	        ){
	        	menu.down('#linkAfb900ukr').show();
				menu.down('#linkAfb700ukr').show();
				menu.down('#linkAgj105ukr').hide();
				
	        }else if( (!Ext.isEmpty(record.get('TRANS_DATE'))) && 
	            	  (Ext.isEmpty(record.get('PROV_DRAFT_NO'))) && 
	        		  (Ext.isEmpty(record.get('EX_DATE')))	
	        ){
	        	menu.down('#linkAfb900ukr').show();
				menu.down('#linkAfb700ukr').hide();
				menu.down('#linkAgj105ukr').hide();
				
	        }else if( (Ext.isEmpty(record.get('TRANS_DATE'))) && 
	            	  (!Ext.isEmpty(record.get('PROV_DRAFT_NO'))) && 
	        		  (!Ext.isEmpty(record.get('EX_DATE')))	
	        ){
	        	menu.down('#linkAfb900ukr').hide();
				menu.down('#linkAfb700ukr').show();
				menu.down('#linkAgj105ukr').show();
				
	        }else if( (Ext.isEmpty(record.get('TRANS_DATE'))) && 
	            	  (!Ext.isEmpty(record.get('PROV_DRAFT_NO'))) && 
	        		  (Ext.isEmpty(record.get('EX_DATE')))	
	        ){
	        	menu.down('#linkAfb900ukr').hide();
				menu.down('#linkAfb700ukr').show();
				menu.down('#linkAgj105ukr').hide();
				
	        }else if( (Ext.isEmpty(record.get('TRANS_DATE'))) && 
	            	  (Ext.isEmpty(record.get('PROV_DRAFT_NO'))) && 
	        		  (!Ext.isEmpty(record.get('EX_DATE')))	
	        ){
	        	menu.down('#linkAfb900ukr').hide();
				menu.down('#linkAfb700ukr').hide();
				menu.down('#linkAgj105ukr').show();
				
	        }else if( (Ext.isEmpty(record.get('TRANS_DATE'))) && 
	            	  (Ext.isEmpty(record.get('PROV_DRAFT_NO'))) && 
	        		  (Ext.isEmpty(record.get('EX_DATE')))	
	        ){
	        	menu.down('#linkAfb900ukr').hide();
				menu.down('#linkAfb700ukr').hide();
				menu.down('#linkAgj105ukr').hide();
				
	        }
					
			/*	if(record.get('INPUT_DIVI') == '2'){
					menu.down('#linkAgj200ukr').hide();
					menu.down('#linkAgj205ukr').show();
				}else if(!Ext.isEmpty(record.get('INPUT_DIVI')) && record.get('INPUT_DIVI') != '2'){
					menu.down('#linkAgj205ukr').hide();
					menu.down('#linkAgj200ukr').show();
				}
      			return true;*/
			
      	},
		gotoAfb900ukr:function(record)	{
			if(record)	{
		    	var params = {
					action:'select', 
					'PGM_ID' : 'agd340ukr',	
					'DATE' : record.data['TRANS_DATE'],
					'SLIP' : record.data['EX_DATE'] == '' ? 'N' : 'Y',
					'PAY_DRAFT_NO' : record.data['PROV_DRAFT_NO']
				}
		  		var rec1 = {data : {prgID : 'afb900ukr', 'text':''}};							
				parent.openTab(rec1, '/accnt/afb900ukr.do', params);
			}
    	},
    	gotoAfb700ukr:function(record)	{
			if(record)	{
		    	var params = {
					action:'select', 
					'PGM_ID' : 'agd340ukr',	
					'PAY_DRAFT_NO': record.data['PROV_DRAFT_NO']
					
				}
		  		var rec2 = {data : {prgID : 'afb700ukr', 'text':''}};							
				parent.openTab(rec2, '/accnt/afb700ukr.do', params);
			}
    	},
    	gotoAgj105ukr:function(record)	{
			if(record)	{
		    	var params = {
					action:'select', 
					'PGM_ID' : 'agd340ukr',
					'SLIP_DATE' : record.data['EX_DATE'],
					'INPUT_PATH' : '70',
					'EX_NUM' : record.data['EX_NUM'],
					'iRcvSlipSeq' : '1',	//?
					'AP_STS' : '',
					'DIV_CODE' : record.data['DIV_CODE']
					
				}
		  		var rec3 = {data : {prgID : 'agj105ukr', 'text':''}};							
				parent.openTab(rec3, '/accnt/agj105ukr.do', params);
			}
    	},
        setItemData: function(record, dataClear, grdRecord) {
//       		var grdRecord = this.uniOpt.currentRecord;
       		if(dataClear) {
       			grdRecord.set('ITEM_CODE'			, "");
       			grdRecord.set('ITEM_NAME'			, "");
       			grdRecord.set('SPEC'				, ""); 
				grdRecord.set('STOCK_UNIT'			, "");
				grdRecord.set('ORDER_UNIT'			, "");
				grdRecord.set('TRNS_RATE'			, 0);
				grdRecord.set('ITEM_ACCOUNT'		, "");				
				panelSearch.setValue('ITEM_CODE'		, "");
				panelSearch.setValue('ORDER_UNIT'	, "");
				grdRecord.set('ORDER_UNIT_FOR_P'	, 0);
				grdRecord.set('ORDER_UNIT_P'		, 0);
				grdRecord.set('SALE_BASIS_P'		, 0);
				
				
				grdRecord.set('GOOD_STOCK_Q'		, "");
				grdRecord.set('BAD_STOCK_Q'			, "");
				grdRecord.set('PURCHASE_TYPE'		, "");
				grdRecord.set('SALES_TYPE'			, "");
				grdRecord.set('PURCHASE_RATE'		, "");
				grdRecord.set('TAX_TYPE'			, "");
				
				grdRecord.set('ORDER_UNIT_Q'		, 0);
				grdRecord.set('ORDER_UNIT_FOR_O'	, 0);
				grdRecord.set('INOUT_I'		, 0);
				grdRecord.set('INOUT_TAX_AMT'	, 0);
				grdRecord.set('INOUT_TOTAL_I'	, 0);
				grdRecord.set('INOUT_FOR_P'		, 0);
				grdRecord.set('INOUT_FOR_O'	, 0);
				grdRecord.set('INOUT_P'	, 0);
				grdRecord.set('ORDER_UNIT_I'	, 0);
				grdRecord.set('INOUT_Q'	, 0);
				
				grdRecord.set('RETURN_NUM'	, "");
				grdRecord.set('RETURN_SEQ'	, "");
				
       		} else {
       			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);

       			grdRecord.set('SPEC'				, record['SPEC']); 
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);
				grdRecord.set('TRNS_RATE'			, record['TRNS_RATE']);
				grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
			//	grdRecord.set('ORDER_UNIT_FOR_P'    , record['ORDER_P']);
				grdRecord.set('SALE_BASIS_P'		, record['SALE_BASIS_P']);
				grdRecord.set('TAX_TYPE'			, record['TAX_TYPE']);	
				
				grdRecord.set('ORDER_UNIT_Q'		, 0);
				grdRecord.set('ORDER_UNIT_FOR_O'	, 0);
				grdRecord.set('INOUT_I'		, 0);
				grdRecord.set('INOUT_TAX_AMT'	, 0);
				grdRecord.set('INOUT_TOTAL_I'	, 0);
				grdRecord.set('INOUT_Q'	, 0);
				
				grdRecord.set('RETURN_NUM'	, "");
				grdRecord.set('RETURN_SEQ'	, "");
				
				panelSearch.setValue('ITEM_CODE',record['ITEM_CODE']);
				panelSearch.setValue('ORDER_UNIT',record['ORDER_UNIT']);
				
				
				var param = {"ITEM_CODE": record['ITEM_CODE'],
							"CUSTOM_CODE": panelSearch.getValue('CUSTOM_CODE'),
							"DIV_CODE": panelSearch.getValue('DIV_CODE'),
							"MONEY_UNIT": panelSearch.getValue('MONEY_UNIT'),
							"ORDER_UNIT": panelSearch.getValue('ORDER_UNIT'),
							"INOUT_DATE": panelSearch.getValue('INOUT_DATE')
				};
					agd340ukrService.fnOrderPrice(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
					grdRecord.set('PURCHASE_TYPE', provider['PURCHASE_TYPE']);
					grdRecord.set('SALES_TYPE', provider['SALES_TYPE']);
					grdRecord.set('ORDER_UNIT_FOR_P', provider['ORDER_P']);
					grdRecord.set('ORDER_UNIT_P', (provider['ORDER_P'] * grdRecord.get('EXCHG_RATE_O')));
					grdRecord.set('PURCHASE_RATE', provider['PURCHASE_RATE']);
					grdRecord.set('INOUT_FOR_P', (provider['ORDER_P'] / grdRecord.get('TRNS_RATE')));
					grdRecord.set('INOUT_P', (provider['ORDER_P'] / grdRecord.get('TRNS_RATE') * grdRecord.get('EXCHG_RATE_O')));
					
					}
				})
				
				
//				var param = {"ITEM_CODE": record['ITEM_CODE']};
//					agd340ukrService.fnSaleBasisP(param, function(provider, response)	{
//					if(!Ext.isEmpty(provider)){
//					grdRecord.set('SALE_BASIS_P', provider['SALE_BASIS_P']);
//					}
//				})
				
				
				
				
				//UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE'));
       			UniMatrl.fnStockQ(grdRecord, UniAppManager.app.cbStockQ, UserInfo.compCode, grdRecord.get('DIV_CODE'), null, grdRecord.get('ITEM_CODE'),grdRecord.get('WH_CODE') );
       		}
		}
    });   
	    
        
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, subForm, detailGrid//, sumForm
			]	
		},
			panelSearch
		],
		id  : 'agd340ukrApp',
		fnInitBinding: function(params){
			UniAppManager.app.getTopToolbar().getComponent('save').setDisabled(true);
			UniAppManager.setToolbarButtons(['reset']/*,'newData','print','prev', 'next']*/, true);
			UniAppManager.setToolbarButtons(['newData','save'], false);
			
			this.setDefault(params);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('FR_DATE');
		},
		onQueryButtonDown: function() {      
			if(!panelResult.getInvalidMessage()) return false; 
			directDetailStore.loadStoreRecords();	
			
			UniAppManager.setToolbarButtons('save', false);
			subForm.setValue('REAL_AMT_I', 0);
//			panelSearch.setAllFieldsReadOnly(true);
//			panelResult.setAllFieldsReadOnly(true);
/*			
			detailGrid.getStore().loadStoreRecords();
			var viewLocked = detailGrid.lockedGrid.getView();
			var viewNormal = detailGrid.normalGrid.getView();
			console.log("viewLocked: ",viewLocked);
			console.log("viewNormal: ",viewNormal);
			viewLocked.getFeature('detailGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('detailGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('detailGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('detailGridTotal').toggleSummaryRow(true);	*/			
		},

		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			detailGrid.reset();
			directDetailStore.clearData();
			this.fnInitInputFields();
		},

		setDefault: function(params) {
			panelSearch.getField('AP_STS').setVisible(false);
			panelResult.getField('AP_STS').setVisible(false);
/*//        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
//        	panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);*/;
			
			if(!Ext.isEmpty(params.PGM_ID)){
				this.processParams(params);
			}else{
				UniAppManager.app.fnInitInputFields();	
			}
		},
		processParams: function(params) {
			this.uniOpt.appParams = params;
			
			if(params.PGM_ID == 'afb900ukr') {
				
				//자금이체일
				panelSearch.setValue('FR_DATE',params.FR_DATE);		//aStr() 추후 넘어오는 프로그램과 연결 작업 필요
				panelSearch.setValue('TO_DATE',params.TO_DATE);
				panelResult.setValue('FR_DATE',params.FR_DATE);
				panelResult.setValue('TO_DATE',params.TO_DATE);
				
				//사업장
				panelSearch.setValue('DIV_CODE',params.DIV_CODE);
				panelResult.setValue('DIV_CODE',params.DIV_CODE);
				
				//이체지급구분
				panelSearch.setValue('INPUT_GUBUN',	'');
				panelResult.setValue('INPUT_GUBUN',	'');
				
				//거래처
				panelSearch.setValue('CUSTOM_CODE', '');
				panelSearch.setValue('CUSTOM_NAME', '');
				panelResult.setValue('CUSTOM_CODE', '');
				panelResult.setValue('CUSTOM_NAME', '');
				
				//전표승인여부
				panelSearch.setValue('AP_STS', '');
				panelResult.setValue('AP_STS', '');
				
				//일괄기표전표일
				subForm.setValue('EX_DATE', UniDate.get('today'));
				subForm.getField('EX_DATE').setReadOnly(true);
				
				subForm.getField('DATE_OPT').setValue('C');
				
				//작업구분
				subForm.getField('WORK').setValue('Proc');		
				
				this.fnSetCaptionBtnAutoSlip();
				
				this.onQueryButtonDown();
			}
		},
		fnInitInputFields: function() {
			
			//자금이체일
			panelSearch.setValue('FR_DATE', UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_DATE', UniDate.get('today'));
			panelResult.setValue('FR_DATE', UniDate.get('startOfMonth'));
			panelResult.setValue('TO_DATE', UniDate.get('today'));
			
			//사업장
			panelSearch.setValue('DIV_CODE', '');
			panelResult.setValue('DIV_CODE', '');
			gsDivCdList	= '';
			gsDivNmList	= '';
			gsDivFlag	= '';
			
			//이체지급구분
			panelSearch.setValue('INPUT_GUBUN',	'');
			panelResult.setValue('INPUT_GUBUN',	'');
			
			//거래처
			panelSearch.setValue('CUSTOM_CODE', '');
			panelSearch.setValue('CUSTOM_NAME', '');
			panelResult.setValue('CUSTOM_CODE', '');
			panelResult.setValue('CUSTOM_NAME', '');
			
			//전표승인여부
			panelSearch.setValue('AP_STS', '');
			panelResult.setValue('AP_STS', '');
			
			//실행일
			subForm.setValue('EX_DATE', UniDate.get('today'));
			subForm.getField('EX_DATE').setReadOnly(true);
			
			subForm.getField('DATE_OPT').setValue('C');
			
			//작업구분
			subForm.getField('WORK').setValue('Proc');		
//			Ext.getCmp('apStsPS').setHidden(true);	
//			Ext.getCmp('apStsPR').setHidden(true);	
			this.fnSetCaptionBtnAutoSlip();
			
			//실지급액 합계
			subForm.setValue('REAL_AMT_I', 0);
			
			UniAppManager.setToolbarButtons('save', false);
		},
		
		/**
		 * 버튼 캡션 변경(자동기표/기표취소 )
		 */
		fnSetCaptionBtnAutoSlip: function(){
			if(Ext.getCmp('rdoWork').getValue().WORK == 'Proc'){
				subForm.down('#btnAutoSlipC').setText(Msg.fSbMsgA0410);		//개별자동기표
				subForm.down('#btnAutoSlipB').setText(Msg.fSbMsgA0411);		//일괄자동기표
			}else{
				subForm.down('#btnAutoSlipC').setText(Msg.fSbMsgA0467);		//개별기표취소
				subForm.down('#btnAutoSlipB').setText(Msg.fSbMsgA0468);		//일괄기표취소
			}
		},
		/**
		 * 자동기표조회 링크 관련
		 */
		fnOpenSlip: function(){
			if(detailForm.getValue('EX_DATE') == ''){
				return false;	
			}
			var params = {
//				action:'select', 
				'PGM_ID' : 'agd340ukr',
				'SLIP_DATE' : detailForm.getValue('EX_DATE'),
				'INPUT_PATH' : '70',
				'EX_NUM' : detailForm.getValue('EX_NUM'),
				'iRcvSlipSeq' : '1',	//?
				'AP_STS' : '',
				'DIV_CODE' : detailForm.getValue('DIV_CODE')
			}
	  		var rec1 = {data : {prgID : 'agj105ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agj105ukr.do', params);
		},
		/**
		 * 자동기표 실행 관련
		 */
		fnAutoSlipProc: function(){		
			oprFlag = 'N';
			
			directDetailStore.saveStore();
			UniAppManager.setToolbarButtons('save', false);	
			UniAppManager.app.getTopToolbar().getComponent('save').setDisabled(true);
		},
		/**
		 * 기표취소 관련
		 */
		fnAutoSlipCanc: function(){
			oprFlag = 'D';
			
			directDetailStore.saveStore();
			UniAppManager.setToolbarButtons('save', false);	
			UniAppManager.app.getTopToolbar().getComponent('save').setDisabled(true);
		}
	});
	
	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "SAVE_FLAG" :
					UniAppManager.setToolbarButtons('save',false);
					break;
			}
				return rv;
						}
			});	
	Unilite.createValidator('validator02', {
		forms: {'formA:':panelSearch},
		validate: function( type, fieldName, newValue, lastValidValue, record, form, field) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'lastValidValue':lastValidValue, 'record':record});
			var rv = true;	
			switch(fieldName) {
				
			}
			return rv;
		}
	}); // validator02			
			
};

</script>