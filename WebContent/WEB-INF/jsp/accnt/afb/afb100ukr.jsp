<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="afb100ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="A026" /> <!--배분-->
	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

var excelWindow;	// 엑셀참조

var getStDt = ${getStDt};

var saveMonth = ''; 
var gsStMonth = (getStDt[0].STDT).substring(0,6);

var gsChargeDivi ='${gsChargeDivi}';
//var aMonths = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];
var aMonths = ["01","02","03","04","05","06","07","08","09","10","11","12"];
function appMain() {
	
	var columns	= createGridColumn(gsStMonth);
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'afb100ukrService.selectList',
			update: 'afb100ukrService.updateDetail',
			create: 'afb100ukrService.insertDetail',
			destroy: 'afb100ukrService.deleteDetail',
			syncAll: 'afb100ukrService.saveAll'
		}
	});	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Afb100ukrModel', {
		
		fields: [
	    	{name: 'GBNCD'			 	,text: 'GBNCD' 		,type: 'string'},
	    	{name: 'AC_YYYY'			,text: 'AC_YYYY' 	,type: 'string'},
	    	{name: 'DEPT_CODE'			,text: 'DEPT_CODE' 	,type: 'string'},
	    	{name: 'DEPT_NAME'			,text: 'DEPT_NAME' 	,type: 'string'},
			{name: 'ACCNT'				,text: '코드' 		,type: 'string'},
			{name: 'ACCNT_NAME'	 		,text: '계정과목' 		,type: 'string'},
			{name: 'ACTUAL_I'			,text: '전년실적' 		,type: 'uniPrice'},
			{name: 'RATIO_R'			,text: '상승률(%)' 	,type: 'uniPercent',decimalPrecision:2, format:'0,000.00'},
			{name: 'BUDGET_I' 			,text: '년차예산' 		,type: 'uniPrice'},
			{name: 'CAL_DIVI'			,text: '배분' 		,type: 'string',comboType:'AU', comboCode:'A026',allowBlank:false},
			{name: '01'					,text: '01월' 		,type: 'uniPrice'},
			{name: '02' 				,text: '02월' 		,type: 'uniPrice'},
			{name: '03' 				,text: '03월' 		,type: 'uniPrice'},
			{name: '04' 				,text: '04월' 		,type: 'uniPrice'},
			{name: '05' 				,text: '05월' 		,type: 'uniPrice'},
			{name: '06' 				,text: '06월' 		,type: 'uniPrice'},
			{name: '07' 				,text: '07월' 		,type: 'uniPrice'},
			{name: '08' 				,text: '08월' 		,type: 'uniPrice'},
			{name: '09' 				,text: '09월' 		,type: 'uniPrice'},
			{name: '10'					,text: '10월' 		,type: 'uniPrice'},
			{name: '11' 				,text: '11월' 		,type: 'uniPrice'},
			{name: '12' 				,text: '12월' 		,type: 'uniPrice'},
	    	{name: 'WRITE_YN'			,text: 'WRITE_YN' 	,type: 'string'},
	    	{name: 'EDIT_YN'			,text: 'EDIT_YN' 	,type: 'string'},
	    	{name: 'COMP_CODE'			,text: 'COMP_CODE' 	,type: 'string'}
		]
	});
	
	// 엑셀참조
	Unilite.Excel.defineModel('excel.afb100ukr.sheet01', {
	    fields: [
			{name: 'GBNCD'			 	,text: '구분코드' 		,type: 'string'},
	    	{name: 'AC_YYYY'			,text: '예산년도' 		,type: 'string'},
	    	{name: 'DEPT_CODE'			,text: '부서' 		,type: 'string'},
	    	{name: 'DEPT_NAME'			,text: '부서명' 		,type: 'string'},
	    	{name: 'ACCNT'			 	,text: '코드' 		,type: 'string'},
			{name: 'ACCNT_NAME'	 		,text: '계정과목' 		,type: 'string'},
			{name: 'ACTUAL_I'		 	,text: '전년실적' 		,type: 'string'},
			{name: 'RATIO_R'		 	,text: '상승률' 		,type: 'uniPercent'},
			{name: 'BUDGET_I' 		 	,text: '년차예산' 		,type: 'uniPrice'},
			{name: 'CAL_DIVI'		 	,text: '배분' 		,type: 'string'},
			{name: '01'			 		,text: '01월' 		,type: 'uniPrice'},
			{name: '02' 			 	,text: '02월' 		,type: 'uniPrice'},
			{name: '03' 			 	,text: '03월' 		,type: 'uniPrice'},
			{name: '04' 			 	,text: '04월' 		,type: 'uniPrice'},
			{name: '05' 			 	,text: '05월' 		,type: 'uniPrice'},
			{name: '06' 			 	,text: '06월' 		,type: 'uniPrice'},
			{name: '07' 			 	,text: '07월' 		,type: 'uniPrice'},
			{name: '08' 			 	,text: '08월' 		,type: 'uniPrice'},
			{name: '09' 			 	,text: '09월' 		,type: 'uniPrice'},
			{name: '10'			 		,text: '10월' 		,type: 'uniPrice'},
			{name: '11' 			 	,text: '11월' 		,type: 'uniPrice'},
			{name: '12' 			 	,text: '12월' 		,type: 'uniPrice'},
	    	{name: 'EDIT_YN'			,text: '수정여부' 		,type: 'string'},
	    	{name: 'ACCNT_CD'			,text: '계정코드' 		,type: 'string'},
	    	{name: 'COMP_CODE'			,text: '법인코드' 		,type: 'string'},
			{name: 'BUDG_YN'		 	,text: 'BUDG_YN' 	,type: 'string'},
			{name: 'GROUP_YN'	 		,text: 'GROUP_YN' 	,type: 'string'}
	    ]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directDetailStore = Unilite.createStore('afb100ukrDetailStore',{
		model: 'Afb100ukrModel',
		uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy,
        saveStore : function()	{	
			var paramMaster= panelResult.getValues();
			paramMaster.saveMonth = saveMonth;
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				
				config = {
					params: [paramMaster],
					success: function(batch, option) {
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
	    			fieldLabel: '신청년도',
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
				})/*,{
		    		xtype: 'radiogroup',		            		
		    		fieldLabel: ' ',		    		
		    		items: [{
		    			boxLabel: '열' , width: 82, name: 'RADIO1', inputValue: '1', checked: true
		    		}, {
		    			boxLabel: '행' , width: 82, name: 'RADIO1', inputValue: '2'
		    		}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {				
							panelResult.getField('RADIO1').setValue(newValue.RADIO1);
						}
					}
		        }*/]	
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
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel: '신청년도',
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
		})/*,{
    		xtype: 'radiogroup',		            		
    		fieldLabel: ' ',		    		
    		items: [{
    			boxLabel: '열' , width: 82, name: 'RADIO1', inputValue: '1', checked: true
    		}, {
    			boxLabel: '행' , width: 82, name: 'RADIO1', inputValue: '2'
    		}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {					
					panelSearch.getField('RADIO1').setValue(newValue.RADIO1);
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
    
    var detailGrid = Unilite.createGrid('afb100ukrGrid1', {
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
			useRowNumberer		: false,
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
		        	openExcelWindow();
			}
		}],*/
    	features: [{id : 'detailGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           {id : 'detailGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
       columns:columns,
    	/* columns:  [{ dataIndex: 'ACCNT'			 	,		width: 53 },       			
        		   { dataIndex: 'ACCNT_NAME'	 	,		width: 133 },       			
        		   { dataIndex: 'ACTUAL_I'		 	,		width: 106 },       			
        		   { dataIndex: 'RATIO_R'		 	,		width: 66 },       			
        		   { dataIndex: 'BUDGET_I' 		 	,		width: 106 },       			
        		   { dataIndex: 'CAL_DIVI'		 	,		width: 80 },       			
        		   { dataIndex: 'JAN'			 	,		width: 106 },       			
        		   { dataIndex: 'FEB' 			 	,		width: 106 },       			
        		   { dataIndex: 'MAR' 			 	,		width: 106 },       			
        		   { dataIndex: 'APR' 			 	,		width: 106 },       			
        		   { dataIndex: 'MAY' 			 	,		width: 106 },       			
        		   { dataIndex: 'JUN' 			 	,		width: 106 },       			
        		   { dataIndex: 'JUL' 			 	,		width: 106 },       			
        		   { dataIndex: 'AUG' 			 	,		width: 106 },       			
        		   { dataIndex: 'SEP' 			 	,		width: 106 },       			
        		   { dataIndex: 'OCT'			 	,		width: 106 },       			
        		   { dataIndex: 'NOV' 			 	,		width: 106 },       			
        		   { dataIndex: 'DEC' 			 	,		width: 106 }
        ] */
       listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				if(e.record.data.EDIT_YN == 'N' || e.record.data.WRITE_YN == 'N'){
					return false;
				}
				
				if(UniUtils.indexOf(e.field, ['ACCNT','ACCNT_NAME','ACTUAL_I'])){
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
			items:[
				detailGrid, panelResult
			]
		},
			panelSearch  	
		],
		id  : 'afb100ukrApp',
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
			this.setDefault();
			
			
		},
		onQueryButtonDown : function()	{			
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{	
				detailGrid.getEl().mask('컬럼 셋팅중...','loading-indicator');	
				var param = Ext.getCmp('resultForm').getValues();
				accntCommonService.fnGetStDt(param, function(provider, response)	{
//					gsStMonth =	(provider[0].STDT).substring(0,6);	//확인필요
//					var newColumns = createGridColumn(gsStMonth);
//					detailGrid.setConfig('columns',createGridColumn(gsStMonth));//새로 셋팅을 하면 기존 그리드 속성이 다 없어지는듯..edit관련 하여 확인 필요
					
					//배분 콤보박스 관련
//					detailGrid.setColumnInfo(detailGrid,createGridColumn(gsStMonth),detailGrid.getStore().model.getFields());
//					detailGrid.getView().refresh();
					detailGrid.getEl().unmask();		
					directDetailStore.loadStoreRecords();
					panelSearch.setAllFieldsReadOnly(true);
				});
				
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
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			directDetailStore.saveStore();
					
		},
		setDefault: function(){
			if(gsChargeDivi == '2'){
				panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
				panelSearch.setValue('DEPT_NAME',UserInfo.deptName);
				panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
				panelResult.setValue('DEPT_NAME',UserInfo.deptName);
				
				panelSearch.getField('DEPT_CODE').setReadOnly(true);
				panelSearch.getField('DEPT_NAME').setReadOnly(true);
				panelResult.getField('DEPT_CODE').setReadOnly(true);
				panelResult.getField('DEPT_NAME').setReadOnly(true);
			}
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
				if(sCalDivi == "2")	{
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
					afb100ukrService.fnGetResultRate(param, function(provider, response)	{
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
        	}
        }
        
	});
	
	function createGridColumn(gsStMonth) {
		var columns = [        
		
			{dataIndex: 'GBNCD' 			, text: 'GBNCD' 			, style: 'text-align: center'	, width: 100,hidden:true},
			{dataIndex: 'AC_YYYY' 			, text: 'AC_YYYY' 			, style: 'text-align: center'	, width: 100,hidden:true},		
			{dataIndex: 'DEPT_CODE' 		, text: 'DEPT_CODE'			, style: 'text-align: center'	, width: 100,hidden:true},		
			{dataIndex: 'DEPT_NAME' 		, text: 'DEPT_NAME'			, style: 'text-align: center'	, width: 100,hidden:true},		
			{dataIndex: 'ACCNT'				, text: '코드' 				, style: 'text-align: center'	, width: 100},		
			{dataIndex: 'ACCNT_NAME'		, text: '계정과목' 			, style: 'text-align: center'	, width: 150},		
			Ext.applyIf({dataIndex: 'ACTUAL_I'			, text: '전년실적' 			, style: 'text-align: center'	, width: 100}, {align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Price }),		
			Ext.applyIf({dataIndex: 'RATIO_R'			, text: '상승률(%)' 			, style: 'text-align: center'	, width: 100/*,editable:true*/}, {align: 'right' ,xtype:'uniNnumberColumn',decimalPrecision:2, format:'0,000.00'}),
			
//			columns.push(Ext.applyIf({dataIndex: 'RATIO_R'	, text: '상승률' , style: 'text-align: center', width: 100}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.ER })),
			Ext.applyIf({dataIndex: 'BUDGET_I' 			, text: '년차예산' 			, style: 'text-align: center'	, width: 100}, {align: 'right' ,xtype:'uniNnumberColumn', format: UniFormat.Price }),				
			/*Ext.applyIf(*/{dataIndex: 'CAL_DIVI'		, text: '배분' 				, style: 'text-align: center'	, width: 100},/* {xtype: 'uniCombobox' }),*/			/*,comboType:'AU', comboCode:'A026'*/
			{dataIndex: 'WRITE_YN'			, text: 'WRITE_YN'			, style: 'text-align: center'	, width: 100,hidden:true},		
			{dataIndex: 'EDIT_YN'			, text: 'EDIT_YN'			, style: 'text-align: center'	, width: 100,hidden:true},		
			{dataIndex: 'COMP_CODE'			, text: 'COMP_CODE'			, style: 'text-align: center'	, width: 100,hidden:true}	
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
					
					UniAppManager.app.fnMakeBudget(record, fieldName, record.get("CAL_DIVI"), lActu, lRate, lBudg);
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
					UniAppManager.app.fnMakeBudget(record, 'BUDGET_I', newValue, lActu, lRate, lBudg);
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
					lActu = record.get('ACTUAL_I');
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
					}
					break;
				default:break;
			}
			return rv;
		}
	});	
	
	/*function openExcelWindow() {
		var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUploadWin';

        if(!excelWindow) {
        	excelWindow =  Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
        		modal: false,
        		excelConfigName: 'afb100ukr',
                grids: [{
            		itemId		: 'grid01',
            		title		: '예산편성',                        		
            		useCheckbox	: false,
            		model		: 'excel.afb100ukr.sheet01',
            		readApi		: 'afb100ukrService.selectExcelUploadSheet1',
            		columns		: [        
        				{ dataIndex: '_EXCEL_JOBID'		, 		width: 80,	hidden: true},
			        	{ dataIndex: 'ACCNT'			,		width: 53 },       			
	        		   	{ dataIndex: 'ACCNT_NAME'	 	,		width: 133 },       			
	        		   	{ dataIndex: '01'	, text: '1월'	 	,		width: 106 },       			
	        		   	{ dataIndex: '02' 	, text: '2월'	 	,		width: 106 },       			
	        		   	{ dataIndex: '03' 	, text: '3월'	 	,		width: 106 },       			
	        		   	{ dataIndex: '04' 	, text: '4월'	 	,		width: 106 },       			
	        		   	{ dataIndex: '05' 	, text: '5월'	 	,		width: 106 },       			
	        		   	{ dataIndex: '06' 	, text: '6월'	 	,		width: 106 },       			
	        		   	{ dataIndex: '07' 	, text: '7월'	 	,		width: 106 },       			
	        		   	{ dataIndex: '08' 	, text: '8월'	 	,		width: 106 },       			
	        		   	{ dataIndex: '09' 	, text: '9월'	 	,		width: 106 },       			
	        		   	{ dataIndex: '10'	, text: '10월'	 	,		width: 106 },       			
	        		   	{ dataIndex: '11' 	, text: '11월'	 	,		width: 106 },       			
	        		   	{ dataIndex: '12' 	, text: '12월'	 	,		width: 106 }
					]
                }],
                listeners: {
                    close: function() {
                        this.hide();
                    }
                },
                onApply:function()	{
					excelWindow.getEl().mask('로딩중...','loading-indicator');		
                	var me = this;
                	var grid = this.down('#grid01');
        			var records = grid.getStore().getAt(0);	
        			if (!Ext.isEmpty(records)) {
			        	var param	= {
			        		"_EXCEL_JOBID"	: records.get('_EXCEL_JOBID')
			        	};
			        	excelUploadFlag = "Y"
						afb100ukrService.selectExcelUploadSheet1(param, function(provider, response){
					    	var store = detailGrid.getStore();
					    	var records	= response.result;
					    	store.insert(0, records);
					    	console.log("response",response)
							excelWindow.getEl().unmask();
							grid.getStore().removeAll();
							me.hide();
					    });
						excelUploadFlag = "N"
		        	} else {
		        		alert (Msg.fSbMsgH0284);
		        		this.unmask();  
		        	}
        		}
             });
        }
        excelWindow.center();
        excelWindow.show();
	}*/
};


</script>
