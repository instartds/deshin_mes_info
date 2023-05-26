<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="afb110ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="A026" /> <!--배분-->
	<t:ExtComboStore comboType="AU" comboCode="B042" /> <!--금액단위-->
	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

var gsChargeCode  = Ext.isEmpty(${getChargeCode}) ? ['']: ${getChargeCode};   //ChargeCode 관련 전역변수
var excelWindow;	// 엑셀참조

var getStDt = ${getStDt};
var saveMonth = ''; 
var gsStMonth = (getStDt[0].STDT).substring(0,6);

var gsReset = '';

//var acYYYY = '';

var aMonths = ["01","02","03","04","05","06","07","08","09","10","11","12"];

function appMain() {
	var columns		= createGridColumn(gsStMonth);
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'afb110ukrService.selectList',
			update	: 'afb110ukrService.updateDetail',
			create	: 'afb110ukrService.insertDetail',
			destroy	: 'afb110ukrService.deleteDetail',
			syncAll	: 'afb110ukrService.saveAll'
		}
	});
	
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Afb110ukrModel', {
	    fields: [
	  	  	{name: 'LOADFLAG'			,text: 'LOADFLAG' 		,type: 'string'},
	    	{name: 'GBNCD'			 	,text: 'GBNCD' 			,type: 'string'},
	    	{name: 'AC_YYYY'			,text: 'AC_YYYY' 		,type: 'string'},
	    	{name: 'DEPT_CODE'			,text: 'DEPT_CODE' 		,type: 'string'},
	    	{name: 'DEPT_NAME'			,text: 'DEPT_NAME' 		,type: 'string'},
	    	{name: 'ACCNT'			 	,text: '코드' 			,type: 'string'},
			{name: 'ACCNT_NAME'	 		,text: '계정과목' 			,type: 'string'},
			{name: 'ACTUAL_I'		 	,text: '전년실적' 			,type: 'uniPrice'},
			{name: 'RATIO_R'		 	,text: '상승률(%)' 		,type: 'uniPercent',decimalPrecision:2, format:'0,000.00'},
			{name: 'BUDGET_I' 		 	,text: '년차예산' 			,type: 'uniPrice'},
			{name: 'CAL_DIVI'		 	,text: '배분' 			,type: 'string',comboType:'AU', comboCode:'A026',allowBlank:false},
			{name: '01'			 		,text: '01월' 			,type: 'uniPrice'},
			{name: '02' 			 	,text: '02월' 			,type: 'uniPrice'},
			{name: '03' 			 	,text: '03월' 			,type: 'uniPrice'},
			{name: '04' 			 	,text: '04월' 			,type: 'uniPrice'},
			{name: '05' 			 	,text: '05월' 			,type: 'uniPrice'},
			{name: '06' 			 	,text: '06월' 			,type: 'uniPrice'},
			{name: '07' 			 	,text: '08월' 			,type: 'uniPrice'},
			{name: '09' 			 	,text: '07월' 			,type: 'uniPrice'},
			{name: '08' 			 	,text: '09월' 			,type: 'uniPrice'},
			{name: '10'			 		,text: '10월' 			,type: 'uniPrice'},
			{name: '11' 			 	,text: '11월' 			,type: 'uniPrice'},
			{name: '12' 			 	,text: '12월' 			,type: 'uniPrice'},
	    	{name: 'EDIT_YN'			,text: 'EDIT_YN' 		,type: 'string'},
	    	{name: 'ACCNT_CD'			,text: 'ACCNT_CD' 		,type: 'string'},
	    	{name: 'COMP_CODE'			,text: 'COMP_CODE' 		,type: 'string'},
			{name: 'BUDG_YN'		 	,text: 'BUDG_YN' 		,type: 'string'},
			{name: 'GROUP_YN'	 		,text: 'GROUP_YN' 		,type: 'string'}
			]
	});
	
	/*function openExcelWindow() {
//		acYYYY = panelResult.getValue('AC_YYYY');
        var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUpload';
        var acYYYY = panelResult.getValue('AC_YYYY');
        var deptCode = panelResult.getValue('DEPT_CODE');
        if(!Ext.isEmpty(excelWindow)){
            excelWindow.extParam.AC_YYYY = panelResult.getValue('AC_YYYY');
            excelWindow.extParam.deptCode = panelResult.getValue('DEPT_CODE');
        }
        if(!excelWindow) { 
            excelWindow = Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
                modal: false,
//                id:'excelWin',
                excelConfigName: 'afb110ukr',
                width: 600,
                height: 200,
                extParam: { 
                    'PGM_ID' : 'afb110ukr',
                    'AC_YYYY' : acYYYY,
                    'DEPT_CODE_M': deptCode
                    
                },
                listeners: {
                	show: function( panel, eOpts ) {
                		Ext.getCmp('pageAll').getEl().mask('엑셀 업로드 작업 중...','loading-indicator');
                	},
                    close: function() {
                        this.hide();
                    },
                    beforehide: function(me, eOpt)  {
                    	Ext.getCmp('pageAll').getEl().unmask();
                    }
                },
                
                uploadFile: function() {
                    var me = this,
                    frm = me.down('#uploadForm');
                    frm.submit({
                        params: me.extParam,
                        waitMsg: 'Uploading...',
                        success: function(form, action) {
                            me.jobID = action.result.jobID;
                            me.readGridData(me.jobID);
                            me.down('tabpanel').setActiveTab(1);
                            Ext.Msg.alert('Success', 'Upload 성공 하였습니다.');
                            
                            me.hide();
                                
                            UniAppManager.app.onQueryButtonDown();
                        },
                        failure: function(form, action) {
//                            Ext.Msg.alert('Failed', action.result.msg);
                            Ext.Msg.alert('Failed', 'Upload 실패 하였습니다.');
                        }
                        
                    });
                },
                _setToolBar: function() {
                    var me = this;
                    me.tbar = [{
                        xtype: 'button',
                        text : '업로드',
                        tooltip : '업로드', 
                        handler: function() { 
                            me.jobID = null;
                            me.uploadFile();
                        }
                    },
                    '->',
                    {
                        xtype: 'button',
                        text : '닫기',
                        tooltip : '닫기', 
                        handler: function() { 
                            me.hide();
                        }
                    }]
                 }
            });
        }
        excelWindow.center();
        excelWindow.show();
    };
	*/
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var tempStore = Unilite.createStore('afb110ukrDetailSubStore',{					//임시저장 store
		uniOpt : {
        	isMaster	: false,		// 상위 버튼 연결 
        	editable	: false,		// 수정 모드 사용 
        	deletable	: false,		// 삭제 가능 여부 
            useNavi		: false			// prev | newxt 버튼 사용
        }
	})

	var directDetailStore = Unilite.createStore('afb110ukrDetailStore',{
		model: 'Afb110ukrModel',
		uniOpt : {
        	isMaster	: true,			// 상위 버튼 연결 
        	editable	: true,			// 수정 모드 사용 
        	deletable	: false,		// 삭제 가능 여부 
            useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad	: false,
        proxy		: directProxy,
        saveStore	: function()	{	
			var paramMaster= panelResult.getValues();
			paramMaster.saveMonth = saveMonth;
			paramMaster.gsReset = gsReset;
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						gsReset = '';
						
						directDetailStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			}else {
				detailGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			
			param.gsReset = gsReset;
			
			var tempDate = panelResult.getValue('AC_YYYY') + gsStMonth.substring(4,6) + '01';
				tempDate = tempDate.substring(0,4) + '/' + tempDate.substring(4,6) + '/' + tempDate.substring(6,8);
			var transDate = new Date(tempDate);
			var sToMonth = '';
				sToMonth = UniDate.add(transDate, {months: + 11});
			
			param.sFrMonth = panelResult.getValue('AC_YYYY') + gsStMonth.substring(4,6);
			param.sToMonth = UniDate.getDbDateStr(sToMonth).substring(0,6);
			
			param.sFrMonthTemp = (panelResult.getValue('AC_YYYY')-1) + gsStMonth.substring(4,6);
			param.sTrMonthTemp = UniDate.getDbDateStr(sToMonth).substring(0,4) - 1 + UniDate.getDbDateStr(sToMonth).substring(4,6) + '31';
			
			console.log( param );
			this.load({
				params : param
			});
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				if(records.length > 0){
    				if (records[0].data.LOADFLAG == 'NEW') {
    					Ext.each(records, function(record, index) {
    						record.phantom 	= true;
    					});
    					gsReset = 'Y';
    				}
				}
			},
			
			update: function(store, record, operation, modifiedFieldNames, eOpts) {
				if(record.get('ACCNT') != record.get('ACCNT_CD')){
					UniAppManager.app.fnReflectAmt(record);
				}
			}
		},
		
		_onStoreLoad: function ( store, records, successful, eOpts ) {
			if(this.uniOpt.isMaster) {
				console.log("onStoreLoad");
				if(records.length > 0){
    				if (records[0].data.LOADFLAG == 'NEW') {
    					UniAppManager.setToolbarButtons('save', true);
    					var msg = records.length + Msg.sMB001; 								//'건이 조회되었습니다.';
    					//console.log(msg, st);
    					UniAppManager.updateStatus(msg, true);  
    					
    				} else {
    					UniAppManager.setToolbarButtons('save', false);
    					var msg = records.length + Msg.sMB001; 								//'건이 조회되었습니다.';
    					//console.log(msg, st);
    					UniAppManager.updateStatus(msg, true);  
    				}
				}
			}
		}
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
			layout : {type : 'vbox', align : 'stretch'},
	    	items : [{
	    		xtype:'container',
	    		layout : {type : 'uniTable', columns : 1},
	    		items:[{ 
	    			fieldLabel: '예산년도',
			        xtype: 'uniYearField',	
			        value: new Date().getFullYear(),
			        name: 'AC_YYYY',
			        holdable:'hold',
			        allowBlank: false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('AC_YYYY', newValue);
						}
					}
		        },
				Unilite.popup('DEPT', { 
					fieldLabel: '부서', 
					valueFieldName: 'DEPT_CODE',
					textFieldName: 'DEPT_NAME',
					holdable:'hold',
			        allowBlank: false,
					listeners: {
				    	onValueFieldChange: function(field, newValue){
							panelResult.setValue('DEPT_CODE', newValue);	
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('DEPT_NAME', newValue);	
						}
					}
				}),
				Unilite.popup('ACCNT',{
                    fieldLabel: '계정과목',
                    valueFieldName: 'ACCNT_CODE',
                    textFieldName: 'ACCNT_NAME',
                    autoPopup:true,
                    listeners: {
                        onValueFieldChange: function(field, newValue){
                            panelResult.setValue('ACCNT_CODE', newValue);                               
                        },
                        onTextFieldChange: function(field, newValue){
                            panelResult.setValue('ACCNT_NAME', newValue);               
                        },
                        applyExtParam:{
                            scope:this,
                            fn:function(popup){
                                var param = {
                                    'ADD_QUERY' : "SLIP_SW = N'Y' AND GROUP_YN = N'N'",
                                    'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                                }
                                popup.setExtParam(param);
                            }
                        }
                    }
                }),	
            	{
	    			fieldLabel: '금액단위'	,
	    			name:'O_UNIT', 
	    			xtype: 'uniCombobox', 
	    			comboType:'AU',
	    			comboCode:'B042',
			        allowBlank: false,
			        hidden: true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('O_UNIT', newValue);
						}
					}
	    		}]	
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
				   	Unilite.messageBox(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})      
   				}
	  		} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
	});	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 4, tableAttrs: {width: '100%'}},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			xtype: 'container',
			layout : {type : 'uniTable'},
			items:[{ 
				fieldLabel: '예산년도',
		        xtype: 'uniYearField',	
		        value: new Date().getFullYear(),
		        name: 'AC_YYYY',
		        holdable:'hold',
		        allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('AC_YYYY', newValue);
					}
				}
	        },
			Unilite.popup('DEPT', { 
				fieldLabel: '부서', 
				valueFieldName: 'DEPT_CODE',
				textFieldName: 'DEPT_NAME',
				holdable:'hold',
		        allowBlank: false,
				listeners: {
			    	onValueFieldChange: function(field, newValue){
						panelSearch.setValue('DEPT_CODE', newValue);	
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('DEPT_NAME', newValue);	
					}
				}
			}),
			Unilite.popup('ACCNT',{
                fieldLabel: '계정과목',
                valueFieldName: 'ACCNT_CODE',
                textFieldName: 'ACCNT_NAME',
                autoPopup:true,
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelSearch.setValue('ACCNT_CODE', newValue);                               
                    },
                    onTextFieldChange: function(field, newValue){
                        panelSearch.setValue('ACCNT_NAME', newValue);               
                    },
                    applyExtParam:{
                        scope:this,
                        fn:function(popup){
                            var param = {
                                'ADD_QUERY' : "SLIP_SW = N'Y' AND GROUP_YN = N'N'",
                                'CHARGE_CODE': (Ext.isEmpty(gsChargeCode) && Ext.isEmpty(gsChargeCode[0])) ? '':gsChargeCode[0].SUB_CODE
                            }
                            popup.setExtParam(param);
                        }
                    }
                }
            }), 
            {
				fieldLabel: '금액단위'	,
				name:'O_UNIT', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B042',
		        allowBlank: false,
		        hidden: true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('O_UNIT', newValue);
					}
				}
			}
		]}/*,{
			xtype: 'button',
			text: '재참조',	
			margin: '0 0 0 0',
			id:'resultReref',
			name: '',
			width: 80,	
			disabled:true,
			tdAttrs: {align: 'right'},				   	
			handler : function(records) {
				
				
				if(!UniAppManager.app.checkForNewDetail()) {
					return false;
				} else {
					
					var tempDate = panelResult.getValue('AC_YYYY') + gsStMonth.substring(4,6) + '01';
						tempDate = tempDate.substring(0,4) + '/' + tempDate.substring(4,6) + '/' + tempDate.substring(6,8);
					var transDate = new Date(tempDate);
					var sToMonth = '';
						sToMonth = UniDate.add(transDate, {months: + 11});
					var param = {
						 "DEPT_CODE": panelResult.getValue('DEPT_CODE'),
						 "sFrMonth" : panelResult.getValue('AC_YYYY') + gsStMonth.substring(4,6),		
						 "sToMonth" : UniDate.getDbDateStr(sToMonth).substring(0,6)
					};
					afb110ukrService.checkSelect(param, function(provider, response)	{
						if(!Ext.isEmpty(provider)){
							if(confirm(Msg.sMA0103)) {
								gsReset = 'Y';
								UniAppManager.app.onQueryButtonDown();
							}else{
								gsReset = 'N';
								return false;	
							}
						}else{
							gsReset = 'Y';
							UniAppManager.app.onQueryButtonDown();	
						}
					});
				}
			}
		}*/],
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
				   	Unilite.messageBox(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				} else {
					var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(true); 
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;							
							if(popupFC.holdable == 'hold') {
								popupFC.setReadOnly(true);
							}
						}
					})      
   				}
	  		} else {
				var fields = this.getForm().getFields();
				Ext.each(fields.items, function(item) {
					if(Ext.isDefined(item.holdable) )	{
					 	if (item.holdable == 'hold') {
							item.setReadOnly(false);
						}
					} 
					if(item.isPopupField)	{
						var popupFC = item.up('uniPopupField')	;	
						if(popupFC.holdable == 'hold' ) {
							item.setReadOnly(false);
						}
					}
				})
			}
			return r;
		}
    });    

    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var detailGrid = Unilite.createGrid('afb110ukrGrid', {
    	// for tab    	
        layout : 'fit',
        region:'center',
    	store: directDetailStore,
    	uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
			useRowContext 		: false,
//    		dblClickToEdit		: true,
    		onLoadSelectFirst	: true, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			state: {
				useState: true,			
				useStateList: true		
			}
		},
    	/*tbar: [{
			itemId: 'excelBtn',
			text: '엑셀 Upload',
        	handler: function() {
        		
        		if(!panelResult.getInvalidMessage()) return;   //필수체크
	        	openExcelWindow();
            }
		}],*/
    	features: [{id : 'detailGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           {id : 'detailGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns: columns,
		listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
				if(e.record.data.EDIT_YN == 'N' ){
					return false;
				}
				
				if(UniUtils.indexOf(e.field, ['ACCNT','ACCNT_NAME','ACTUAL_I','LOADFLAG'])){
					return false;	
				}else{
					if(e.record.data.GBNCD == '2'){
						return false;
					}else{
						return true;
					}
				}
			}
		}
    });   
	
	
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			id:'pageAll',
			items:[
				detailGrid, panelResult
			]
		},
			panelSearch  	
		],
		id  : 'afb110ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons('save',false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_YYYY');
//			this.setDefault();
			
			
			
			
			panelSearch.setValue('AC_YYYY',  new Date().getFullYear());
			panelResult.setValue('AC_YYYY',  new Date().getFullYear());
			panelSearch.setValue('O_UNIT',  '1');
			panelResult.setValue('O_UNIT',  '1');
		},
		onQueryButtonDown : function()	{		
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{	
				gsReset = '';
				directDetailStore.loadStoreRecords();
				panelSearch.setAllFieldsReadOnly(true);
				
//				Ext.getCmp('resultReref').setDisabled(false);  재참조 버튼관련
				
				saveMonth = panelResult.getValue('AC_YYYY') + gsStMonth.substring(4,6);
			}
		},
		onResetButtonDown: function() {
			
//			panelSearch.clearForm();
//			panelResult.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			detailGrid.reset();
			directDetailStore.clearData();
			UniAppManager.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons('save',false);
			gsReset = '';
//			Ext.getCmp('resultReref').setDisabled(true);   재참조버튼관련
//			this.fnInitBinding();
		},
		onSaveDataButtonDown: function (config) {
			var recordsAll = directDetailStore.data.items;
			Ext.each(recordsAll, function(r, i){
				if(r.get('BUDG_YN') == 'N'){
					Unilite.messageBox("해당코드 계정과목 예산사용여부 설정을 확인하세요.");
					
					return false;
				}
			});
			
			directDetailStore.saveStore();
		},
		checkForNewDetail:function() { 			
			return panelResult.setAllFieldsReadOnly(true);
        },
        fnMakeBudget:function(record, fieldName, sCalDivi, lActu, lRate, lBudg){
        	
        	var dValue = new Array(12);
        	var lRemain = 0;
        	var aMonVal = new Array(12);
        	var dTotVal = 0;
        	var j = 0;
        	var tempA = new Array(12);
        	var grdRecord = detailGrid.uniOpt.currentRecord;
        	
        	switch(fieldName) {
				case "RATIO_R" :
					lBudg = Math.floor(lActu * lRate / 100);
					record.set('BUDGET_I', lBudg);
					break;
				case "BUDGET_I" :
					if(lActu == 0){
						record.set('RATIO_R',0);
					}else{
						lRate = lBudg / lActu * 100;
						record.set('RATIO_R',lRate);
					}
					break;
        	}
        	
        	switch(sCalDivi) {
				case "1" :
					dValue[0] = Math.floor(lBudg / 12);
					dValue[1] = dValue[0];
					dValue[2] = dValue[0];
					dValue[3] = dValue[0];
					dValue[4] = dValue[0];
					dValue[5] = dValue[0];
					dValue[6] = dValue[0];
					dValue[7] = dValue[0];
					dValue[8] = dValue[0];
					dValue[9] = dValue[0];
					dValue[10] = dValue[0];
					dValue[11] = dValue[0];
					lRemain = lBudg - dValue[0] * 12;
				
					var calcMonth ='';
					calcMonth = gsStMonth.substring(4,6);
					calcMonth2 = parseInt(calcMonth);
					
					for(var i=0; i<12; i++){
						if(i == 0){
							grdRecord.set(calcMonth,dValue[i] + lRemain);
						}else if(calcMonth2 + i > 12){
							grdRecord.set((100 + calcMonth2 + i - 12).toString().substring(1,3),dValue[i]);
						}else{
							grdRecord.set((100 + calcMonth2 + i).toString().substring(1,3),dValue[i]);
						}
					}
					break;
					
				case "2" :
				case "3" :
					if(sCalDivi =="2")	{
						var tempDate = saveMonth + '01';
						tempDate = tempDate.substring(0,4) + '/' + tempDate.substring(4,6) + '/' + tempDate.substring(6,8);
						var transDate = new Date(tempDate);
						
						var frMonth = '';
							frMonth = UniDate.add(transDate, {months: - 12});
							frMonth = UniDate.getDbDateStr(frMonth).substring(0,6);
							
						var toMonth = '';
							toMonth = UniDate.add(transDate, {months: - 1});
							toMonth = UniDate.getDbDateStr(toMonth).substring(0,6);
					} else {
						var tempDate = saveMonth + '01';
							tempDate = tempDate.substring(0,4) + '/' + tempDate.substring(4,6) + '/' + tempDate.substring(6,8);
						var transDate = new Date(tempDate);
						
						var frMonth = '';
							frMonth = UniDate.add(transDate, {months: - 60});
							frMonth = UniDate.getDbDateStr(frMonth).substring(0,6);
							
						var toMonth = '';
							toMonth = UniDate.add(transDate, {months: - 1});
							toMonth = UniDate.getDbDateStr(toMonth).substring(0,6);	
					}
					var param = {"ACCNT": grdRecord.get('ACCNT'),
							 "DEPT_CODE": grdRecord.get('DEPT_CODE'),
							 "FR_MONTH" : frMonth,		
							 "TO_MONTH" : toMonth
						};
					Ext.getBody().mask("Loading...");
					afb110ukrService.fnGetResultRate(param, function(provider, response)	{
						Ext.getBody().unmask();
						for(var i=0; i<12; i++){
							dValue[i] = 0;
						}
						dTotVal = 0;
						if(!Ext.isEmpty(provider)){
							Ext.each(provider, function(item, idx){
								var arrIndex = parseInt(item.AC_DATE)-1;
								if(arrIndex > -1)	{
									dValue[arrIndex] = item.ACTUAL_I;
									dTotVal += parseInt(item.ACTUAL_I);
								}
							});	
						}
					
						j = parseInt(frMonth.substring(4,6)) - 1;
						
						for(var i=0; i<12; i++){
							if(i == 0){
								if(dTotVal == 0){
									tempA[i] = 0;
								}else{
									tempA[i] = dValue[j] / dTotVal;
								}
							}else{
								if(dTotVal == 0){
									tempA[i] = 0;
								}else{
									tempA[i] = dValue[j] / dTotVal;
								}
							}
							
							if(j+1 > 11){
								j = 0;	
							}else{
								j = j+1;	
							}
						}
						
						for(var i=0; i<12; i++){
							dValue[i] = Math.floor(lBudg * tempA[i].toFixed(4));
						}
						
						if(dValue[0] == 0 && 
						   dValue[1] == 0 && 
						   dValue[2] == 0 &&
						   dValue[3] == 0 && 
						   dValue[4] == 0 &&
						   dValue[5] == 0 &&
						   dValue[6] == 0 &&
						   dValue[7] == 0 &&
						   dValue[8] == 0 &&
						   dValue[9] == 0 &&
						   dValue[10] == 0 &&
						   dValue[11] == 0) {
						   		dValue[0] = Math.floor(lBudg / 12);
								dValue[1] = dValue[0];             
								dValue[2] = dValue[0];             
								dValue[3] = dValue[0];             
								dValue[4] = dValue[0];             
								dValue[5] = dValue[0];             
								dValue[6] = dValue[0];             
								dValue[7] = dValue[0];             
								dValue[8] = dValue[0];             
								dValue[9] = dValue[0];             
								dValue[10] = dValue[0];            
								dValue[11] = dValue[0];            
						   }
						
						lRemain  = lBudg - (dValue[0] + dValue[1] + dValue[2] + dValue[3] + dValue[4]  + dValue[5] + 
									  		dValue[6] + dValue[7] + dValue[8] + dValue[9] + dValue[10] + dValue[11]);
						
						var calcMonth ='';
							calcMonth = gsStMonth.substring(4,6);
							calcMonth2 = parseInt(calcMonth);
							
							for(var i=0; i<12; i++){
								if(i == 0){
									grdRecord.set(calcMonth,dValue[i] + lRemain);
								}else if(calcMonth2 + i > 12){
									grdRecord.set((100 + calcMonth2 + i - 12).toString().substring(1,3),dValue[i]);
								}else{
									grdRecord.set((100 + calcMonth2 + i).toString().substring(1,3),dValue[i]);
								}
							}					
					});
					break;
				default:break;
        	}
        },
        fnReflectAmt:function(record){
        	var sumBudgetI = 0;
        	
        	var sum01 = 0;
        	var sum02 = 0;
        	var sum03 = 0;
        	var sum04 = 0;
        	var sum05 = 0;
        	var sum06 = 0;
        	var sum07 = 0;
        	var sum08 = 0;
        	var sum09 = 0;
        	var sum10 = 0;
        	var sum11 = 0;
        	var sum12 = 0;
        	
        	var lActu = 0;
        	var lRate = 0;
        	var lBudg = 0;
        	
        	var sAccntCd = record.get('ACCNT_CD'); 
        	
        	var recordAll = directDetailStore.data.items;
        	
        	Ext.each(recordAll, function(item,index){
        		if(item.get('ACCNT_CD') == sAccntCd && item.get('ACCNT') != item.get('ACCNT_CD')){
        			sumBudgetI = sumBudgetI + item.get('BUDGET_I');
        			sum01 = sum01 + item.get('01');
					sum02 = sum02 + item.get('02');
					sum03 = sum03 + item.get('03');
					sum04 = sum04 + item.get('04');
					sum05 = sum05 + item.get('05');
					sum06 = sum06 + item.get('06');
					sum07 = sum07 + item.get('07');
					sum08 = sum08 + item.get('08');
					sum09 = sum09 + item.get('09');
					sum10 = sum10 + item.get('10');
					sum11 = sum11 + item.get('11');
					sum12 = sum12 + item.get('12');
        		}
        	});
        	
        	Ext.each(recordAll, function(item2,index){
        		if(item2.get('ACCNT') == sAccntCd){
        			if(item2.get('EDIT_YN') == 'Y'){
        				return false;	
        			}else{
        				item2.set('BUDGET_I',sumBudgetI);
        				item2.set('01',sum01);
        				item2.set('02',sum02);
        				item2.set('03',sum03);
        				item2.set('04',sum04);
        				item2.set('05',sum05);
        				item2.set('06',sum06);
        				item2.set('07',sum07);
        				item2.set('08',sum08);
        				item2.set('09',sum09);
        				item2.set('10',sum10);
        				item2.set('11',sum11);
        				item2.set('12',sum12);
        			}
        		}
        	});
        	
        	lActu = record.get('ACTUAL_I');
        	lRate = record.get('RATIO_R');
        	lBudg = record.get('BUDGET_I');
        	
        	if(lActu == 0){
        		record.set('RATIO_R',0);	
        	}else{
        		lRate = lBudg / lActu * 100;
        		record.set('RATIO_R',lRate);
        	}
        }
	});
	
	function createGridColumn(gsStMonth) {
		var columns = [        
			{dataIndex: 'LOADFLAG' 			, text: 'LOADFLAG' 			, style: 'text-align: center'	, width: 100,hidden:true},
			{dataIndex: 'GBNCD' 			, text: 'GBNCD' 			, style: 'text-align: center'	, width: 100,hidden:true},
			{dataIndex: 'AC_YYYY' 			, text: 'AC_YYYY' 			, style: 'text-align: center'	, width: 100,hidden:true},		
			{dataIndex: 'DEPT_CODE' 		, text: 'DEPT_CODE'			, style: 'text-align: center'	, width: 100,hidden:true},		
			{dataIndex: 'DEPT_NAME' 		, text: 'DEPT_NAME'			, style: 'text-align: center'	, width: 100,hidden:true},		
			{dataIndex: 'ACCNT'				, text: '코드' 				, style: 'text-align: center'	, width: 100},		
			{dataIndex: 'ACCNT_NAME'		, text: '계정과목' 			, style: 'text-align: center'	, width: 150},		
			Ext.applyIf({dataIndex: 'ACTUAL_I'			, text: '전년실적' 			, style: 'text-align: center'	, width: 100}, {align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Price }),		
			Ext.applyIf({dataIndex: 'RATIO_R'			, text: '상승률(%)' 			, style: 'text-align: center'	, width: 100/*,editable:true*/}, {align: 'right' ,xtype:'uniNnumberColumn', decimalPrecision:2, format:'0,000.00'}),
			Ext.applyIf({dataIndex: 'BUDGET_I' 			, text: '년차예산' 			, style: 'text-align: center'	, width: 100}, {align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Price }),				
			{dataIndex: 'CAL_DIVI'		, text: '배분' 				, style: 'text-align: center'	, width: 100},
			{dataIndex: 'EDIT_YN'			, text: 'EDIT_YN'			, style: 'text-align: center'	, width: 100,hidden:true},
			{dataIndex: 'ACCNT_CD'			, text: 'ACCNT_CD'			, style: 'text-align: center'	, width: 100,hidden:true},
			{dataIndex: 'COMP_CODE'			, text: 'COMP_CODE'			, style: 'text-align: center'	, width: 100,hidden:true},
			{dataIndex: 'BUDG_YN'			, text: 'BUDG_YN'			, style: 'text-align: center'	, width: 100,hidden:true},
			{dataIndex: 'GROUP_YN'			, text: 'GROUP_YN'			, style: 'text-align: center'	, width: 100,hidden:true}
		
		];
		
		var sStMonth ='';
		sStMonth = gsStMonth.substring(4,6);
		sStMonth = parseInt(sStMonth);
		
		for(var i=0; i<12; i++){
			if(sStMonth + i > 12){
				columns.push(Ext.applyIf({dataIndex: aMonths[parseInt((100 + sStMonth + i - 12).toString().substring(1,3)-1)], width: 150, text: (100 + sStMonth + i - 12).toString().substring(1,3) + '월', style: 'text-align: center'}, {align: 'right', xtype:'uniNnumberColumn', format: UniFormat.Price,editor:{xtype:'uniNumberfield'}}));	
			}else{
				columns.push(Ext.applyIf({dataIndex: aMonths[parseInt((100 + sStMonth + i).toString().substring(1,3)-1)], width: 150, text: (100 + sStMonth + i).toString().substring(1,3) + '월', style: 'text-align: center'}, {align: 'right', xtype:'uniNnumberColumn', format: UniFormat.Price,editor:{xtype:'uniNumberfield'} }));	
			}
		}
		
		return columns;
	}
	
	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			
			var lActu = 0;
			var lRate = 0;
			var lBudg = 0;
			switch(fieldName) {
				case "RATIO_R" :
					lActu = record.get('ACTUAL_I');
					lRate = newValue;
					lBudg = record.get('BUDGET_I');
				
					if(newValue < 0){
						rv='<t:message code = "unilite.msg.sMB076"/>';
						break;
					}
					
					UniAppManager.app.fnMakeBudget(record, fieldName,  record.get("CAL_DIVI"), lActu, lRate, lBudg);
					break;
				
				case "BUDGET_I" :
					lActu = record.get('ACTUAL_I');
					lRate = record.get('RATIO_R');
					lBudg = newValue;
					if(newValue < 0){
						rv='<t:message code = "unilite.msg.sMB076"/>';
						break;
					}
					UniAppManager.app.fnMakeBudget(record, fieldName, record.get("CAL_DIVI"), lActu, lRate, lBudg);
					break;
				
				case "CAL_DIVI" :
					lActu = record.get('ACTUAL_I');
					lRate = record.get('RATIO_R');
					lBudg = record.get('BUDGET_I');
					UniAppManager.app.fnMakeBudget(record, 'BUDGET_I',newValue, lActu, lRate, lBudg);
					break;
					
				case "01" :
				case "02" :
				case "03" :
				case "04" :
				case "05" :
				case "06" :
				case "07" :
				case "08" :
				case "09" :
				case "10" :
				case "11" :
				case "12" :
                    if(newValue < 0){
                        rv='양수만 입력가능합니다.';
                        break;
                    }
                    
    				var checkAmt = 0;
                    var param = {
                        "BUDG_YYYYMM": record.get('AC_YYYY') + fieldName,
                        "ACCNT": record.get('ACCNT'),
                        "DEPT_CODE": record.get('DEPT_CODE')
                    };
                    afb110ukrService.spAccntGetPossibleBudgAmt110(param, function(provider, response)   {
                        if(!Ext.isEmpty(provider)){
                            checkAmt = provider[0].ACTUAL_I;
                        }
                        if(newValue < checkAmt){
                            Unilite.messageBox('실적 금액보다 작은 금액은 입력될 수 없습니다.');
                            record.set(fieldName,oldValue);
//                            rv='<t:message code = "unilite.msg.sMB076"/>';
//                            break;
                        }else{
                        	lActu = record.get('ACTUAL_I');
                            lRate = record.get('RATIO_R');
                            lBudg = record.get('BUDGET_I');
                            
                            lBudg = lBudg - oldValue + newValue;
                            record.set('BUDGET_I', lBudg);
                            
                            if(lActu == 0){
                                record.set('RATIO_R',0);    
                                
                            }else{
                                lRate = lBudg / lActu * 100;
                                record.set('RATIO_R', lRate);
                            }
                        }
                    });
				
					/*lActu = record.get('ACTUAL_I');
					lRate = record.get('RATIO_R');
					lBudg = record.get('BUDGET_I');
					
					if(newValue < 0){
						rv='<t:message code = "unilite.msg.sMB076"/>';
						break;
					}
					
					lBudg = lBudg - oldValue + newValue;
					record.set('BUDGET_I', lBudg);
					
					if(lActu == 0){
						record.set('RATIO_R',0);	
						
					}else{
						lRate = lBudg / lActu * 100;
						record.set('RATIO_R', lRate);
					}*/
					
					break;
				
			}
			return rv;
		}
	});	
};


</script>
