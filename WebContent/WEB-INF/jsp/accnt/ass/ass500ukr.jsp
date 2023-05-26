<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ass500ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A035" /> <!-- 완료구분-->
	<t:ExtComboStore comboType="AU" comboCode="A039" /> <!-- 매각구분-->
	<t:ExtComboStore comboType="AU" comboCode="B010" /> <!-- 자본적지출-->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >
var gsGubun = '${gsGubun}';	//재무제표 양식차수

function appMain() {     
	var getStDt = Ext.isEmpty(${getStDt}) ? []: ${getStDt};
	var gsChargeCode = '${getChargeCode}';
	var activeGridId = 'ass500ukrDetailGrid1'; // 선택된 그리드 (detailGrid포함)
//	var tabCount = 0;	//예,아니오,취소 버튼 에서 tabPanel.setActiveTab(newCard); 또는 masterGrid.getSelectionModel().select(index); 사용시 다시 이벤트를 타기 때문에 플레그 값으로 구분하기위해.. 다른방법이 있을지?
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Ass500ukrMasterModel', {	//마스터 그리드
	    fields: [{name: 'ASST'        					, text: '자산코드' 		,type: 'string'},
		    	 {name: 'ASST_NAME'   	  				, text: '자산명'			,type: 'string'},
		    	 {name: 'DIV_NAME'        				, text: '사업장' 			,type: 'string'},
		    	 {name: 'PJT_CODE'   	  				, text: '프로젝트'			,type: 'string'},
		    	 {name: 'ACCNT_NAME'        			, text: '계정과목' 		,type: 'string'},
		    	 {name: 'DRB_YEAR'   	  				, text: '내용년수'			,type: 'string'},
		    	 {name: 'ACQ_DATE'        				, text: '취득일' 			,type: 'uniDate'},
		    	 {name: 'USE_DATE'   	  				, text: '사용일'		 	,type: 'uniDate'},
		    	 {name: 'ACQ_Q'        					, text: '취득수량' 	 	,type: 'uniQty'},
		    	 {name: 'ACQ_AMT_I'   	  				, text: '취득가액'		 	,type: 'uniPrice'},
		    	 {name: 'COMP_CODE'        				, text: 'COMP_CODE'  	,type: 'string', defaultValue: UserInfo.compCode}
		]
	});
	
	
	Unilite.defineModel('Ass500ukrDetailModel1', { //디테일 탭1
	    fields: [{name: 'ASST'			  				, text: '자산코드' 		,type: 'string', allowBlank: false},
		    	 {name: 'SEQ'			  	  			, text: '순번'			,type: 'int', allowBlank: false, editable: false},
		    	 {name: 'WASTE_DIVI'		      		, text: '구분' 			,type: 'string'},
		    	 {name: 'ALTER_DATE'		 	  		, text: '발생일'			,type: 'uniDate', allowBlank: false},
		    	 {name: 'ALTER_Q'		        		, text: 'ALTER_Q' 		,type: 'string'},
		    	 {name: 'MONEY_UNIT'		 	  		, text: '화폐단위'		 	,type: 'string', comboType: 'AU', comboCode: 'B004', allowBlank: false,displayField: 'value'},
		    	 {name: 'EXCHG_RATE_O'	      			, text: '환율' 		 	,type: 'uniPercent', maxLength: 30},
		    	 {name: 'FOR_ALTER_AMT_I' 	  			, text: '외화발생금액'   	,type: 'uniFC'},
		    	 {name: 'ALTER_AMT_I'	   				, text: '발생금액' 	 	,type: 'uniPrice', allowBlank: false},
		    	 {name: 'ALTER_REASON'	  	  			, text: '변동사유'		 	,type: 'string', maxLength: 80},
		    	 {name: 'ALTER_DIVI'		       		, text: 'ALTER_DIVI' 	,type: 'string', allowBlank: false},
		    	 {name: 'SAVE_FLAG'   	  				, text: 'SAVE_FLAG'		,type: 'string'},		    	
		    	 {name: 'COMP_CODE'		   				, text: 'COMP_CODE' 	,type: 'string', defaultValue: UserInfo.compCode, allowBlank: false}
		]         	
	});
	
	Unilite.defineModel('Ass500ukrDetailModel2', { //디테일 탭2
	    fields: [{name: 'ASST'			  				, text: '자산코드' 		,type: 'string', allowBlank: false},
		    	 {name: 'SEQ'			  	  			, text: '순번'			,type: 'int', allowBlank: false, editable: false},
		    	 {name: 'WASTE_DIVI'		      		, text: '처분구분' 		,type: 'string', comboType: 'AU', comboCode: 'A039', allowBlank: false},
		    	 {name: 'ALTER_DATE'		 	  		, text: '처분일'			,type: 'uniDate', allowBlank: false},
		    	 {name: 'ALTER_Q'		        		, text: '처분수량' 		,type: 'uniQty', allowBlank: false},
		    	 {name: 'MONEY_UNIT'		 	  		, text: '화폐단위'		 	,type: 'string', comboType: 'AU', comboCode: 'B004', allowBlank: false,displayField: 'value'},
		    	 {name: 'EXCHG_RATE_O'	      			, text: '환율' 		 	,type: 'uniPercent', maxLength: 30},
		    	 {name: 'FOR_ALTER_AMT_I' 	  			, text: '외화처분액'   		,type: 'uniFC'},
		    	 {name: 'ALTER_AMT_I'	   				, text: '처분액' 		 	,type: 'uniPrice', allowBlank: true},
		    	 {name: 'ALTER_REASON'	  	  			, text: '처분사유'		 	,type: 'string', maxLength: 80},
		    	 {name: 'ALTER_DIVI'		       		, text: 'ALTER_DIVI' 	,type: 'string', allowBlank: false},
		    	 {name: 'SAVE_FLAG'   	  				, text: 'SAVE_FLAG'		,type: 'string'},		    	
		    	 {name: 'COMP_CODE'		   				, text: 'COMP_CODE' 	,type: 'string', defaultValue: UserInfo.compCode, allowBlank: false}
		]         	
	});
	
	Unilite.defineModel('Ass500ukrDetailModel3', { //디테일 탭3
	    fields: [{name: 'COMP_CODE'						, text: 'COMP_CODE' 	,type: 'string', defaultValue: UserInfo.compCode, allowBlank: false},
		    	 {name: 'ASST'				  			, text: '자산코드'			,type: 'string', allowBlank: false},
		    	 {name: 'SEQ'		    	      		, text: '순번' 			,type: 'int', allowBlank: false, editable: false},
		    	 {name: 'ALTER_DIVI'     	 	  		, text: '구분'			,type: 'string', allowBlank: false},
		    	 {name: 'ALTER_DATE'		      		, text: '변동일자' 		,type: 'uniDate', allowBlank: false},
		    	 {name: 'PRE_DIV_CODE'		 	  		, text: '원자산사업장'		,type: 'string', allowBlank: false, comboType:'BOR120', editable: false},
		    	 {name: 'PRE_DIV_NAME'	    			, text: '원자산사업장명' 	,type: 'string'},
		    	 {name: 'PRE_DEPT_CODE'		  			, text: '원자산부서코드'   	,type: 'string', allowBlank: false},
		    	 {name: 'PRE_DEPT_NAME'	 				, text: '원자산부서' 		,type: 'string', allowBlank: false},
		    	 {name: 'AFTER_DIV_CODE'		  		, text: '이동사업장'		,type: 'string', allowBlank: false, comboType:'BOR120', editable: false},
		    	 {name: 'AFTER_DIV_NAME'		       	, text: '이동사업장명' 		,type: 'string'},		    	
		    	 {name: 'AFTER_DEPT_CODE' 				, text: '이동부서코드' 		,type: 'string', allowBlank: false},
		    	 {name: 'AFTER_DEPT_NAME'				, text: '이동부서명' 		,type: 'string', allowBlank: false},
		    	 {name: 'SAVE_FLAG'   	  				, text: 'SAVE_FLAG'		,type: 'string'},
		    	 {name: 'ALTER_REASON'		  			, text: '이동사유'			,type: 'string', maxLength: 80}
		]         	
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	  
	var directMasterProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'ass500ukrService.selectMasterList'
        }
	});
	
	var directDetailProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'ass500ukrService.selectDetailList1',
        	update: 'ass500ukrService.updateDetail1',
			create: 'ass500ukrService.insertDetail1',
			destroy: 'ass500ukrService.deleteDetail1',
			syncAll: 'ass500ukrService.saveAll'
        }
	});
	
	var directDetailProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'ass500ukrService.selectDetailList2',
        	update: 'ass500ukrService.updateDetail2',
			create: 'ass500ukrService.insertDetail2',
			destroy: 'ass500ukrService.deleteDetail2',
			syncAll: 'ass500ukrService.saveAll'
        }
	});
	
	var directDetailProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'ass500ukrService.selectDetailList3',
        	update: 'ass500ukrService.updateDetail3',
			create: 'ass500ukrService.insertDetail3',
			destroy: 'ass500ukrService.deleteDetail3',
			syncAll: 'ass500ukrService.saveAll'
        }
	});
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('ass500ukrMasterStore1',{
		model: 'Ass500ukrMasterModel',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directMasterProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
		
	var directDetailStore1 = Unilite.createStore('ass500ukrDetailStore',{
		model: 'Ass500ukrDetailModel1',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:true,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directDetailProxy1,
        loadStoreRecords: function(record) {
			var param = {ASST: record.get('ASST')}			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(selector)	{
			var isErr = false;
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	var list = [].concat(toUpdate,toCreate); 
			Ext.each(list, function(record, index) {
				if(getStDt[0].STDT > UniDate.getDbDateStr(record.get('ALTER_DATE')) || getStDt[0].TODT < UniDate.getDbDateStr(record.get('ALTER_DATE'))){
					var stDate = getStDt[0].STDT.substring(0, 4) + '.' + getStDt[0].STDT.substring(4, 6) + '.'+ getStDt[0].STDT.substring(6, 8);
					var toDate = getStDt[0].TODT.substring(0, 4) + '.' + getStDt[0].TODT.substring(4, 6) + '.'+ getStDt[0].TODT.substring(6, 8);
					alert(Msg.sMA0290 + '\n' + stDate + ' ~ ' + toDate); 
					isErr = true;
					return false;
				}			
			});
			if(isErr) return false;
			var config = {
				params:[panelSearch.getValues()],
				success : function()	{
					UniAppManager.setToolbarButtons('save', false);
					if(selector){
						if(isNaN(selector)){
							tab.setActiveTab(selector);
						}else{
							masterGrid.getSelectionModel().select(selector);
						}
					}
				}
			}
			this.syncAllDirect(config);			
			
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
           		if(records != null && records.length > 0 ){
           			UniAppManager.setToolbarButtons('delete', true);
           		}else{
           			UniAppManager.setToolbarButtons('delete', false);
           		}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);		
			},
			datachanged : function(store,  eOpts) {
//				activeTabId = tab.getActiveTab().getItemId();
//				if(store.isDirty() || directDetailStore2.isDirty() || directDetailStore3.isDirty() && activeTabId == 'ass500ukrDetailGrid1')	{
				if(store.isDirty()){
					UniAppManager.setToolbarButtons('save', true);	
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});
	
	var directDetailStore2 = Unilite.createStore('ass500ukrDetailStore2',{
		model: 'Ass500ukrDetailModel2',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:true,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directDetailProxy2,
        loadStoreRecords: function(record) {
			var param = {ASST: record.get('ASST')}			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(selector)	{
			var isErr = false;
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	var list = [].concat(toUpdate,toCreate); 
			Ext.each(list, function(record, index) {
				if(getStDt[0].STDT > UniDate.getDbDateStr(record.get('ALTER_DATE')) || getStDt[0].TODT < UniDate.getDbDateStr(record.get('ALTER_DATE'))){
					var stDate = getStDt[0].STDT.substring(0, 4) + '.' + getStDt[0].STDT.substring(4, 6) + '.'+ getStDt[0].STDT.substring(6, 8);
					var toDate = getStDt[0].TODT.substring(0, 4) + '.' + getStDt[0].TODT.substring(4, 6) + '.'+ getStDt[0].TODT.substring(6, 8);
					alert(Msg.sMA0291 + '\n' + stDate + ' ~ ' + toDate); 
					isErr = true;
					return false;
				}			
			});
			if(isErr) return false;
			var config = {
				params:[panelSearch.getValues()],
				success : function()	{
					UniAppManager.setToolbarButtons('save', false);
					if(selector){
						if(isNaN(selector)){
							tab.setActiveTab(selector);
						}else{
							masterGrid.getSelectionModel().select(selector);
						}
					}
				}
			}
			this.syncAllDirect(config);			
			
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				if(records != null && records.length > 0 ){
           			UniAppManager.setToolbarButtons('delete', true);
           		}else{
           			UniAppManager.setToolbarButtons('delete', false);
           		}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);		
			},
			datachanged : function(store,  eOpts) {
//				activeTabId = tab.getActiveTab().getItemId();
//				if( directDetailStore1.isDirty() || store.isDirty() || directDetailStore3.isDirty() && activeTabId == 'ass500ukrDetailGrid2')	{
				if(store.isDirty()){
					UniAppManager.setToolbarButtons('save', true);	
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});
	
	var directDetailStore3 = Unilite.createStore('ass500ukrDetailStore3',{
		model: 'Ass500ukrDetailModel3',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable:true,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directDetailProxy3,
        loadStoreRecords: function(record) {
			var param = {ASST: record.get('ASST')}			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(selector)	{
			var config = {
				params:[panelSearch.getValues()],
				success : function()	{
					UniAppManager.setToolbarButtons('save', false);
					if(selector){
						if(isNaN(selector)){
							tab.setActiveTab(selector);
						}else{
							masterGrid.getSelectionModel().select(selector);
						}
					}
				}
			}
			this.syncAllDirect(config);			
			
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				if(records != null && records.length > 0 ){
           			UniAppManager.setToolbarButtons('delete', true);
           		}else{
           			UniAppManager.setToolbarButtons('delete', false);
           		}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', true);		
			},
			datachanged : function(store,  eOpts) {
//				activeTabId = tab.getActiveTab().getItemId();
//				if( directDetailStore1.isDirty() || directDetailStore2.isDirty() || store.isDirty() && activeTabId == 'ass500ukrDetailGrid3')	{
				if(store.isDirty()){
					UniAppManager.setToolbarButtons('save', true);	
				}else {
					UniAppManager.setToolbarButtons('save', false);
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
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [
				Unilite.popup('ASSET',{ 
			    fieldLabel: '자산코드', 
			    validateBlank: false,
//			    allowBlank:false,
				listeners: {
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('ASSET_CODE', panelSearch.getValue('ASSET_CODE'));
//							panelResult.setValue('ASSET_NAME', panelSearch.getValue('ASSET_NAME'));
//                    	},
//						scope: this
//					},
//					onClear: function(type)	{
//						panelResult.setValue('ASSET_CODE', '');
//						panelResult.setValue('ASSET_NAME', '');
//					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ASSET_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ASSET_NAME', newValue);				
					}
				}
		   	}),
				Unilite.popup('ASSET',{ 
			    fieldLabel: '~',
			    valueFieldName: 'ASSET_CODE2', 
				textFieldName: 'ASSET_NAME2', 
			    validateBlank: false,
//			    allowBlank:false,
				listeners: {
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('ASSET_CODE2', panelSearch.getValue('ASSET_CODE2'));
//							panelResult.setValue('ASSET_NAME2', panelSearch.getValue('ASSET_NAME2'));
//                    	},
//						scope: this
//					},
//					onClear: function(type)	{
//						panelResult.setValue('ASSET_CODE2', '');
//						panelResult.setValue('ASSET_NAME2', '');
//					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ASSET_CODE2', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ASSET_NAME2', newValue);				
					}
				}
		   	}),{
				fieldLabel: '사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        value:UserInfo.divCode,
		        comboType:'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},{
				fieldLabel: '상각완료여부',
				name:'DPR_STS',	
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'A035' ,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DPR_STS', newValue);
					}
				}
			}]
		},{
			title: '추가정보',	
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [
				Unilite.popup('ACCNT',{
			    fieldLabel: '계정과목',
				valueFieldName: 'ACCNT_CODE', 
				textFieldName: 'ACCNT_NAME',
				validateBlank: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {			
						
							 
                     	},
						scope: this
					},
					onClear: function(type)	{
						
					},
					applyextparam: function(popup){
						popup.setExtParam({'ADD_QUERY': "SPEC_DIVI = 'K' AND SLIP_SW = 'Y'"});			//WHERE절 추카 쿼리
						popup.setExtParam({'CHARGE_CODE': gsChargeCode});			//bParam(3)			
					}
				}
			}),
				Unilite.popup('ACCNT',{
			    fieldLabel: '~',
				valueFieldName: 'ACCNT_CODE2', 
				textFieldName: 'ACCNT_NAME2',
				validateBlank: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							 
                     	},
						scope: this
					},
					onClear: function(type)	{
						
					},
					applyextparam: function(popup){
						popup.setExtParam({'ADD_QUERY': "SPEC_DIVI = 'K' AND SLIP_SW = 'Y'"});			//WHERE절 추카 쿼리
						popup.setExtParam({'CHARGE_CODE': gsChargeCode});			//bParam(3)			
					}
				}
			}),{
		 	 	xtype: 'container',
	   			defaultType: 'uniNumberfield',
				layout: {type: 'hbox', align:'stretch'},
				width:325,
				margin:0,
				items:[{
					fieldLabel:'내용년수', 
					name: 'DRP_YEAR_FR', 
					width:218
				},{
					xtype:'component', 
					html:'&nbsp;~&nbsp;'
				}, {
					name: 'DRP_YEAR_TO', 
					width:107
				}] 
			},
				Unilite.popup('AC_PROJECT',{
			    fieldLabel: '프로젝트',
			    validateBlank: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {			
						
							 
                     	},
						scope: this
					},
					onClear: function(type)	{
						
					},
					applyextparam: function(popup){
									
					}
				}
			}),
				Unilite.popup('AC_PROJECT',{
			    fieldLabel: '~',
			    validateBlank: false,
				valueFieldName: 'AC_PROJECT_CODE2', 
				textFieldName: 'AC_PROJECT_NAME2',
				listeners: {
					onSelected: {
						fn: function(records, type) {			
						
							 
                     	},
						scope: this
					},
					onClear: function(type)	{
						
					},
					applyextparam: function(popup){
									
					}
				}
			}),{
				fieldLabel: '취득일',            			 		       
				xtype: 'uniDateRangefield',
				startFieldName: 'ACQ_DATE_FR',
				endFieldName: 'ACQ_DATE_TO',
				width:315
		    },{
		 	 	xtype: 'container',
	   			defaultType: 'uniNumberfield',
				layout: {type: 'hbox', align:'stretch'},
				width:325,
				margin:0,
				items:[{
					fieldLabel:'취득가액', 
					name: 'ACQ_AMT_I_FR', 
					width:218
				}, {
					xtype:'component', 
					html:'&nbsp;~&nbsp;'
				},{
					name: 'ACQ_AMT_I_TO', 
					width:107
				}] 
			},{
				fieldLabel: '사용일',            			 		       
				xtype: 'uniDateRangefield',
				startFieldName: 'USE_DATE_FR',
				endFieldName: 'USE_DATE_TO',
				width:315
		    },{
		 	 	xtype: 'container',
	   			defaultType: 'uniNumberfield',
				layout: {type: 'hbox', align:'stretch'},
				width:325,
				margin:0,
				items:[{
					fieldLabel:'외화취득가액',  
					name: 'FOR_ACQ_AMT_I_FR', 
					width:218
				}, {
					xtype:'component', 
					html:'&nbsp;~&nbsp;'
				},{
					name: 'FOR_ACQ_AMT_I_TO', 
					width:107
				}] 
			},{
				fieldLabel: '매각일',            			 		       
				xtype: 'uniDateRangefield',
				startFieldName: 'ALTER_DATE_FR',
				endFieldName: 'ALTER_DATE_TO',
				width:315
		    },{
				fieldLabel: '매각구분',
				name:'WASTE_DIVI',	
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'A039'  
			},{
				fieldLabel: '자본적지출',
				name:'ALTER_DIVI',	
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B010'  
			},{
				fieldLabel: '자본적지출일',            			 		       
				xtype: 'uniDateRangefield',
				startFieldName: 'FI_CAPI_DATE_FR',
				endFieldName: 'FI_CAPI_DATE_TO',
				width:315
		    }]				
	    }]		
	});	
	
    var panelResult = Unilite.createSearchForm('panelResultForm', {		
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
	    items :[
			Unilite.popup('ASSET',{ 
		    fieldLabel: '자산코드', 
		    validateBlank: false,
//			allowBlank:false,
			listeners: {
//				onSelected: {
//					fn: function(records, type) {
//						panelSearch.setValue('ASSET_CODE', panelResult.getValue('ASSET_CODE'));
//						panelSearch.setValue('ASSET_NAME', panelResult.getValue('ASSET_NAME'));
//                	},
//					scope: this
//				},
//				onClear: function(type)	{
//					panelSearch.setValue('ASSET_CODE', '');
//					panelSearch.setValue('ASSET_NAME', '');
//				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ASSET_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ASSET_NAME', newValue);				
				}
			}
	   	}),
			Unilite.popup('ASSET',{ 
		    fieldLabel: '~',
		    valueFieldName: 'ASSET_CODE2', 
			textFieldName: 'ASSET_NAME2', 
		    validateBlank: false,
//			allowBlank:false,
			listeners: {
//				onSelected: {
//					fn: function(records, type) {
//						panelSearch.setValue('ASSET_CODE2', panelResult.getValue('ASSET_CODE2'));
//						panelSearch.setValue('ASSET_NAME2', panelResult.getValue('ASSET_NAME2'));
//                	},
//					scope: this
//				},
//				onClear: function(type)	{
//					panelSearch.setValue('ASSET_CODE2', '');
//					panelSearch.setValue('ASSET_NAME2', '');
//				},
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ASSET_CODE2', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ASSET_NAME2', newValue);				
				}
			}
	   	}),{
			fieldLabel: '사업장',
			name:'DIV_CODE', 
			xtype: 'uniCombobox',
	        multiSelect: true, 
	        typeAhead: false,
	        value:UserInfo.divCode,
	        comboType:'BOR120',
			width: 325,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '상각완료여부',
			name:'DPR_STS',	
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'A035'  ,
    		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DPR_STS', newValue);
				}
			}
		}]
	});
       
    var masterGrid = Unilite.createGrid('ass500ukrMasterGrid', {
    	layout : 'fit',
    	region: 'center',
        store : directMasterStore, 
        selModel:'rowmodel',
        uniOpt: {
//    		expandLastColumn: false,
		 	useRowNumberer: true
//		 	copiedRow: true
//		 	useContextMenu: true,
        },
    	features: [{
    		id: 'masterGridSubTotal',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [  
        	{dataIndex: 'ASST'        					, width: 100}, 				
			{dataIndex: 'ASST_NAME'   	  				, width: 166}, 	
        	{dataIndex: 'DIV_NAME'        				, width: 100}, 				
			{dataIndex: 'PJT_CODE'   	  				, width: 100}, 				
			{dataIndex: 'ACCNT_NAME'        			, width: 100}, 				
			{dataIndex: 'DRB_YEAR'   	  				, width: 90, align: 'center'}, 				
			{dataIndex: 'ACQ_DATE'        				, width: 100}, 				
			{dataIndex: 'USE_DATE'   	  				, width: 100}, 				
			{dataIndex: 'ACQ_Q'        					, width: 100}, 
			{dataIndex: 'ACQ_AMT_I'   	  				, width: 100}, 				
			{dataIndex: 'COMP_CODE'        				, width: 66, hidden:true}
		],
		listeners: {	
        	selectionchange:function( model1, selected, eOpts ){
       			if(selected.length > 0)	{
       				UniAppManager.setToolbarButtons('newData',true);
       				var record = selected[0];
       				if(activeGridId == 'ass500ukrDetailGrid1')	{       				    	        		
		        		directDetailStore1.loadData({});
		        		if(!record.phantom){
		        			directDetailStore1.loadStoreRecords(record);
		        		}   					
       				}else if(activeGridId == 'ass500ukrDetailGrid2'){	
		        		directDetailStore2.loadData({});
		        		if(!record.phantom){
		        			directDetailStore2.loadStoreRecords(record);
		        		}
       				}else if(activeGridId == 'ass500ukrDetailGrid3'){
		        		directDetailStore3.loadData({});
		        		if(!record.phantom){
		        			directDetailStore3.loadStoreRecords(record);
		        		}
       				}        		
       			} else {
       				UniAppManager.setToolbarButtons('newData',false);
       			}
          	},
          	render: function(grid, eOpts){
			    grid.getEl().on('click', function(e, t, eOpt) {
//			    	if(tabCount == 1){
			    		//UniAppManager.setToolbarButtons(['newData'], false);
			    		UniAppManager.setToolbarButtons(['delete'], false);
//			    		tabCount = 0;
//			    	}			    	
			    });
			},	
			beforeselect : function ( gird, record, index, eOpts ){			
//			 	if( tabCount > 0) return true; 
	     		var isNewCardShow = true;		//newCard 보여줄것인지?
	     		var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
				switch(activeGridId)	{
					case 'ass500ukrDetailGrid1':
						if(needSave){
							isNewCardShow = false;
							Ext.Msg.show({
							     title:'확인',
							     msg: Msg.sMB017 + "\n" + Msg.sMB061,
							     buttons: Ext.Msg.YESNOCANCEL,
							     icon: Ext.Msg.QUESTION,
							     fn: function(res) {
							     	//console.log(res);
							     	if (res === 'yes' ) {							     		
							     		var inValidRecs;
							     		var activeStore
						     			inValidRecs = directDetailStore1.getInvalidRecords();
						     			activeStore = directDetailStore1;	
						     			
										if(inValidRecs.length > 0 )	{
											alert(Msg.sMB083);
										}else {
											activeStore.saveStore(index);
//											tabCount = 1;
//											masterGrid.getSelectionModel().select(index);
										}
							     	}else if(res === 'no'){
//										tabCount = 1;
							     		UniAppManager.setToolbarButtons('save', false);
							     		masterGrid.getSelectionModel().select(index);
							     	}else{
							     		
							     	}
							     }
							});
						}
						break;
						
					case 'ass500ukrDetailGrid2':
						if(needSave)	{							
							isNewCardShow = false;
							Ext.Msg.show({
							     title:'확인',
							     msg: Msg.sMB017 + "\n" + Msg.sMB061,
							     buttons: Ext.Msg.YESNOCANCEL,
							     icon: Ext.Msg.QUESTION,
							     fn: function(res) {
							     	//console.log(res);
							     	if (res === 'yes' ) {
							     		var inValidRecs;
							     		var activeStore
						     			inValidRecs = directDetailStore2.getInvalidRecords();
						     			activeStore = directDetailStore2;
						     			
										if(inValidRecs.length > 0 )	{
											alert(Msg.sMB083);
										}else {
											activeStore.saveStore(index);
//											tabCount = 1;
//											masterGrid.getSelectionModel().select(index);
										}
							     	}else if(res === 'no'){
//							     		tabCount = 1;
							     		UniAppManager.setToolbarButtons('save', false);
							     		masterGrid.getSelectionModel().select(index);
							     	}else{
							     		
							     	}
							     }
							});
						}
						break;
						
					case 'ass500ukrDetailGrid3':
						if(needSave)	{
							isNewCardShow = false;
							Ext.Msg.show({
							     title:'확인',
							     msg: Msg.sMB017 + "\n" + Msg.sMB061,
							     buttons: Ext.Msg.YESNOCANCEL, 
							     icon: Ext.Msg.QUESTION,
							     fn: function(res) {
							     	//console.log(res);
							     	if (res === 'yes' ) {
							     		var inValidRecs;
							     		var activeStore
						     			inValidRecs = directDetailStore3.getInvalidRecords();
						     			activeStore = directDetailStore3;
						     			
										if(inValidRecs.length > 0 )	{
											alert(Msg.sMB083);
										}else {
											activeStore.saveStore(index);
//											tabCount = 1;
//											masterGrid.getSelectionModel().select(index);
										}
							     	}else if(res === 'no'){
//							     		tabCount = 1;
							     		UniAppManager.setToolbarButtons('save', false);
							     		masterGrid.getSelectionModel().select(index);
							     	}else{
							     		
							     	}
							     }
							});
						}
						break;	
					default:
						break;
				}
				return isNewCardShow;
			},
			beforeedit  : function( editor, e, eOpts ) {
				return false;
//          		if (UniUtils.indexOf(e.field,['SEQ', 'ACCNT_CD'])) {
//					if(e.record.phantom){
//						return true;
//					}else{
//						return false;
//					}
//				}else if (UniUtils.indexOf(e.field,['ACCNT_NAME', 'ACCNT_NAME2', 'ACCNT_NAME3', 'OPT_DIVI', 'RIGHT_LEFT', 'DIS_DIVI'])) {
//					return true;
//				}else if (UniUtils.indexOf(e.field,['KIND_DIVI'])) {
//					return true;
//				}else{
//					return false;
//				}
			},
			itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	},
      		onGridDblClick: function(grid, record, cellIndex, colName) {
				var params = {
					PGM_ID : 'ass500ukr',
					ASST: record.get('ASST'),
					ASST_NAME: record.get('ASST_NAME')
				}
				var rec = {data : {prgID : 'ass300ukr', 'text':''}};									
				parent.openTab(rec, '/accnt/ass300ukr.do', params);		
          	}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
      		return true;
      	},
      	uniRowContextMenu:{
			items: [
	            {	text	: '고정자산 등록',   
	            	handler	: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoAss300skr(param.record);
	            	}
	        	}
	        ]
	    },
	    gotoAss300skr:function(record)	{
			if(record)	{
		    	var params = record;
		    	params.PGM_ID 			= 'ass500ukr';
		    	params.ASST 			=	record.get('ASST');
		    	params.ASST_NAME 		=	record.get('ASST_NAME');
			}
	  		var rec1 = {data : {prgID : 'ass300ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/ass300ukr.do', params);
    	}
    }); 
       
     /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
       
    var detailGrid1 = Unilite.createGrid('ass500ukrDetailGrid1', {
    	title : '자본적지출',
    	layout : 'fit',
        store : directMasterStore, 
        uniOpt: {
    		expandLastColumn: false,
		 	useRowNumberer: true,
		 	copiedRow: true,
            onLoadSelectFirst: true
//		 	useContextMenu: true,
        },
		store: directDetailStore1,
    	features: [{
    		id: 'masterGridSubTotal1',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal1', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}],
        columns: [            
        	{dataIndex: 'ASST'			  				, width: 66, hidden:true}, 				
			{dataIndex: 'SEQ'			  	  			, width: 53, align: 'center'}, 
        	{dataIndex: 'WASTE_DIVI'		      		, width: 66, hidden:true}, 				
			{dataIndex: 'ALTER_DATE'		 	  		, width: 100}, 				
			{dataIndex: 'ALTER_Q'		        		, width: 66, hidden:true}, 				
			{dataIndex: 'MONEY_UNIT'		 	  		, width: 100},
			{dataIndex: 'EXCHG_RATE_O'	      			, width: 133}, 				
			{dataIndex: 'FOR_ALTER_AMT_I' 	  			, width: 133}, 				
			{dataIndex: 'ALTER_AMT_I'	   				, width: 133}, 	
			{dataIndex: 'ALTER_REASON'	  	  			, minWidth: 233, flex: 1}, 				
			{dataIndex: 'ALTER_DIVI'		       		, width: 66, hidden:true}, 	
			{dataIndex: 'COMP_CODE'		   				, width: 66, hidden:true}
		],                                                       
		listeners: {	                                         
        	selectionchange:function( model1, selected, eOpts ){
//       			if(selected.length > 0)	{
//	        		var record = selected[0];	        		
//	        		directDetailStore1.loadData({})
//	        		if(!record.phantom){
//	        			directDetailStore1.loadStoreRecords(record);
//	        		}	        		
//       			}
          	}
		}
    });

     
    var detailGrid2 = Unilite.createGrid('ass500ukrDetailGrid2', {
    	layout : 'fit',
        region : 'east',
        title : '매각/폐기',
        store : directDetailStore2,
    	features: [{
    		id: 'masterGridSubTotal2',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal2', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}], 
        uniOpt: {
    		expandLastColumn: false,
		 	useRowNumberer: true,
		 	copiedRow: true,
            onLoadSelectFirst: true
//		 	useContextMenu: true,
        },
        columns: [        
		    {dataIndex: 'ASST'			  				, width: 66, hidden:true}, 				
			{dataIndex: 'SEQ'			  	  			, width: 53, align: 'center'}, 
        	{dataIndex: 'WASTE_DIVI'		      		, width: 80}, 				
			{dataIndex: 'ALTER_DATE'		 	  		, width: 100}, 				
			{dataIndex: 'ALTER_Q'		        		, width: 80}, 				
			{dataIndex: 'MONEY_UNIT'		 	  		, width: 100},
			{dataIndex: 'EXCHG_RATE_O'	      			, width: 133}, 				
			{dataIndex: 'FOR_ALTER_AMT_I' 	  			, width: 133}, 				
			{dataIndex: 'ALTER_AMT_I'	   				, width: 133}, 	
			{dataIndex: 'ALTER_REASON'	  	  			, minWidth: 233, flex: 1}, 				
			{dataIndex: 'ALTER_DIVI'		       		, width: 66, hidden:true}, 	
			{dataIndex: 'COMP_CODE'		   				, width: 66, hidden:true}
		]         			
    });
    
    var detailGrid3 = Unilite.createGrid('ass500ukrDetailGrid3', {    	
    	layout : 'fit',
        region : 'east',
        title : '부서이동',
        store : directDetailStore3,
    	features: [{
    		id: 'masterGridSubTotal3',
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    		},{
    		id: 'masterGridTotal3', 	
    		ftype: 'uniSummary', 	  
    		showSummaryRow: false
    	}], 
        uniOpt: {
    		expandLastColumn: false,
		 	useRowNumberer: true,
		 	copiedRow: true,
            onLoadSelectFirst: true
//		 	useContextMenu: true,
        },
        columns: [        
		    {dataIndex: 'COMP_CODE'						, width: 100, hidden:true}, 				
			{dataIndex: 'ASST'				  			, width: 66, hidden:true}, 	
			{dataIndex: 'SEQ'		    	      		, width: 53, align: 'center'}, 				
			{dataIndex: 'ALTER_DIVI'     	 	  		, width: 53, hidden:true}, 	
			{dataIndex: 'ALTER_DATE'		      		, width: 100},
			{dataIndex: 'PRE_DIV_CODE'		 	  		, width: 100}, 				
			{dataIndex: 'PRE_DIV_NAME'	    			, width: 133, hidden:true}, 	
			{dataIndex: 'PRE_DEPT_CODE'		  			, width: 100, hidden:true}, 				
			{dataIndex: 'PRE_DEPT_NAME'	 				, width: 133,
			  editor: Unilite.popup('DEPT_G', {
			  		autoPopup: true,
		  			textFieldName: 'TREE_NAME',
 	 				DBtextFieldName: 'TREE_NAME',
						listeners: {'onSelected': {
							fn: function(records, type) {
									var rtnRecord = detailGrid3.uniOpt.currentRecord;	
									rtnRecord.set('PRE_DEPT_CODE', records[0]['TREE_CODE']);
									rtnRecord.set('PRE_DEPT_NAME', records[0]['TREE_NAME']);
									rtnRecord.set('PRE_DIV_CODE', records[0]['DIV_CODE']);
								},
							scope: this	
							},
							'onClear': function(type) {
								var rtnRecord = detailGrid3.uniOpt.currentRecord;	
									rtnRecord.set('PRE_DEPT_CODE', '');
									rtnRecord.set('PRE_DEPT_NAME', '');
									rtnRecord.set('PRE_DIV_CODE', '');
							},
							applyextparam: function(popup){
								
							}									
						}
				})
			}, 	
			{dataIndex: 'AFTER_DIV_CODE'		  		, width: 100},
			{dataIndex: 'AFTER_DIV_NAME'		       	, width: 133, hidden:true}, 				
			{dataIndex: 'AFTER_DEPT_CODE' 				, width: 100, hidden:true}, 	
			{dataIndex: 'AFTER_DEPT_NAME'				, width: 133,
			  editor: Unilite.popup('DEPT_G', {
			  		autoPopup: true,
		  			textFieldName: 'TREE_NAME',
 	 				DBtextFieldName: 'TREE_NAME',
						listeners: {'onSelected': {
							fn: function(records, type) {
									var rtnRecord = detailGrid3.uniOpt.currentRecord;	
									rtnRecord.set('AFTER_DEPT_CODE', records[0]['TREE_CODE']);
									rtnRecord.set('AFTER_DEPT_NAME', records[0]['TREE_NAME']);
									rtnRecord.set('AFTER_DIV_CODE', records[0]['DIV_CODE']);
								},
							scope: this	
							},
							'onClear': function(type) {
								var rtnRecord = detailGrid3.uniOpt.currentRecord;	
								rtnRecord.set('AFTER_DEPT_CODE', '');
								rtnRecord.set('AFTER_DEPT_NAME', '');
								rtnRecord.set('AFTER_DIV_CODE', '');
							},
							applyextparam: function(popup){
								
							}									
						}
				})
			}, 				
			{dataIndex: 'ALTER_REASON'		  			, minWidth: 133, flex: 1}
		]          			
    });
   
    
    var tab = Unilite.createTabPanel('tabPanel',{
    	region:'south',
	    items: [
	         detailGrid1,
	         detailGrid2,
	         detailGrid3
	    ],
		listeners: {
			beforetabchange:  function ( tabPanel, newCard, oldCard, eOpts )  {		
//				if( tabCount > 0) return true; 
	     		var newTabId = newCard.getId();
	     		var isNewCardShow = true;		//newCard 보여줄것인지?
	     		var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
				switch(newTabId)	{
					case 'ass500ukrDetailGrid1':
						if(needSave){
							isNewCardShow = false;
							Ext.Msg.show({
							     title:'확인',
							     msg: Msg.sMB017 + "\n" + Msg.sMB061,
							     buttons: Ext.Msg.YESNOCANCEL,
							     icon: Ext.Msg.QUESTION,
							     fn: function(res) {
							     	//console.log(res);
							     	if (res === 'yes' ) {
							     		var inValidRecs;
							     		var activeStore
							     		if(directDetailStore2.isDirty()){
							     			inValidRecs = directDetailStore2.getInvalidRecords();
							     			activeStore = directDetailStore2;							     			
							     		}else if(directDetailStore3.isDirty()){
							     			inValidRecs = directDetailStore3.getInvalidRecords();
							     			activeStore = directDetailStore3;	
							     		}
										if(inValidRecs.length > 0 )	{
											alert(Msg.sMB083);
										}else {
											activeStore.saveStore(newCard);
//											tabCount = 1;											
										}
							     	}else if(res === 'no'){
//										tabCount = 1;
							     		UniAppManager.setToolbarButtons('save', false);
							     		tabPanel.setActiveTab(newCard);
							     	}else{
							     		
							     	}
							     }
							});
						}
						break;
						
					case 'ass500ukrDetailGrid2':
						if(needSave)	{							
							isNewCardShow = false;
							Ext.Msg.show({
							     title:'확인',
							     msg: Msg.sMB017 + "\n" + Msg.sMB061,
							     buttons: Ext.Msg.YESNOCANCEL,
							     icon: Ext.Msg.QUESTION,
							     fn: function(res) {
							     	//console.log(res);
							     	if (res === 'yes' ) {
							     		var inValidRecs;
							     		var activeStore;
							     		if(directDetailStore1.isDirty()){
							     			inValidRecs = directDetailStore1.getInvalidRecords();
							     			activeStore = directDetailStore1;
							     		}else if(directDetailStore3.isDirty()){
							     			inValidRecs = directDetailStore3.getInvalidRecords();
							     			activeStore = directDetailStore3;
							     		}
										if(inValidRecs.length > 0 )	{
											alert(Msg.sMB083);
										}else {
											activeStore.saveStore(newCard);
										}
							     	}else if(res === 'no'){
//							     		tabCount = 1;
							     		UniAppManager.setToolbarButtons('save', false);
							     		tabPanel.setActiveTab(newCard);
							     	}else{
							     		
							     	}
							     }
							});
						}
						break;
						
					case 'ass500ukrDetailGrid3':
						if(needSave)	{
							isNewCardShow = false;
							Ext.Msg.show({
							     title:'확인',
							     msg: Msg.sMB017 + "\n" + Msg.sMB061,
							     buttons: Ext.Msg.YESNOCANCEL, 
							     icon: Ext.Msg.QUESTION,
							     fn: function(res) {
							     	//console.log(res);
							     	if (res === 'yes' ) {
							     		var inValidRecs;
							     		var activeStore;
							     		if(directDetailStore1.isDirty()){
							     			inValidRecs = directDetailStore1.getInvalidRecords();
							     			activeStore = directDetailStore1;
							     		}else if(directDetailStore2.isDirty()){
							     			inValidRecs = directDetailStore2.getInvalidRecords();
							     			activeStore = directDetailStore2;
							     		}
										if(inValidRecs.length > 0 )	{
											alert(Msg.sMB083);
										}else {
											activeStore.saveStore(newCard);
										}
							     	}else if(res === 'no'){
//							     		tabCount = 1;
							     		UniAppManager.setToolbarButtons('save', false);
							     		tabPanel.setActiveTab(newCard);
							     	}else{
							     		
							     	}
							     }
							});
						}
						break;	
					default:
						break;
				}
				return isNewCardShow;
	     	},
        	tabchange: function( tabPanel, newCard, oldCard ) {
//        		tabCount = 0;        		
        		var record = masterGrid.getSelectedRecord();
        		if(!Ext.isEmpty(record)){
       				if(newCard.getId() == 'ass500ukrDetailGrid1')	{       				    	        		
		        		directDetailStore1.loadData({});
	        			directDetailStore1.loadStoreRecords(record);
       				}else if(newCard.getId() == 'ass500ukrDetailGrid2'){	
		        		directDetailStore2.loadData({});
	        			directDetailStore2.loadStoreRecords(record);
       				}else if(newCard.getId() == 'ass500ukrDetailGrid3'){
		        		directDetailStore3.loadData({});
	        			directDetailStore3.loadStoreRecords(record);
       				}
       				activeGridId = newCard.getId();	       			
        		}
        	}
		}
    });
    
    
    
	 Unilite.Main( {
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				tab, masterGrid, panelResult
			]
		},
			panelSearch
		]
		, 
		id : 'ass500ukrApp',
		fnInitBinding : function() {			
//			var gubun = Ext.data.StoreManager.lookup( 'CBS_AU_A093' ).getAt(0).get ('value' );
//			panelSearch.setValue('GUBUN', gsGubun);
//			panelResult.setValue('GUBUN', gsGubun);
			
//			tab.setActiveTab(detailGrid2);
//			alert(getStDt[0].STDT);
//			alert(getStDt[0].TODT);
			UniAppManager.setToolbarButtons(['newData'],false);
			UniAppManager.setToolbarButtons(['reset'],false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('ASSET_CODE');
		},
		onQueryButtonDown : function()	{		
			UniAppManager.setToolbarButtons('newData',false);
			directMasterStore.loadStoreRecords();
		}, 
		onNewDataButtonDown : function()	{
			var record = masterGrid.getSelectedRecord();
			if(activeGridId == 'ass500ukrDetailGrid1' )	{
				var param = {MONEY_UNIT: UserInfo.moneyUnit, AC_DATE: UniDate.get('today')}
				detailGrid1.mask();
				accntCommonService.fnExchgRateO(param, function(provider, response)	{
					detailGrid1.unmask();
					if(!Ext.isEmpty(provider)){
						var seq = directDetailStore1.max('SEQ');
		            	if(!seq) seq = 1;
		            	else  seq += 1;
						var r = {
							SEQ: seq,
							ASST: record.get('ASST'),
							ALTER_DATE: UniDate.get('today'),
							ALTER_DIVI: '1',
							MONEY_UNIT: UserInfo.currency,
							EXCHG_RATE_O: provider.BASE_EXCHG,
							SAVE_FLAG: 'N'
						}				
						detailGrid1.createRow(r, 'ALTER_DATE');
						UniAppManager.setToolbarButtons('delete',true);
					}
				});		    	
			}else if(activeGridId == 'ass500ukrDetailGrid2'){
				var param = {MONEY_UNIT: UserInfo.moneyUnit, AC_DATE: UniDate.get('today')}
				accntCommonService.fnExchgRateO(param, function(provider, response)	{
					if(!Ext.isEmpty(provider)){
						var seq = directDetailStore2.max('SEQ');
		            	if(!seq) seq = 1;
		            	else  seq += 1;
						var r = {
							SEQ: seq,
							ASST: record.get('ASST'),
							ALTER_DATE: UniDate.get('today'),
							ALTER_DIVI: '2',
							MONEY_UNIT: UserInfo.currency,
							EXCHG_RATE_O: provider.BASE_EXCHG,
							SAVE_FLAG: 'N'
						}				
						detailGrid2.createRow(r, 'WASTE_DIVI');
						UniAppManager.setToolbarButtons('delete',true);
					}
				});
			}else if(activeGridId == 'ass500ukrDetailGrid3') 	{
				var seq = directDetailStore3.max('SEQ');
            	if(!seq) seq = 1;
            	else  seq += 1;
				var r = {
					SEQ: seq,
					ASST: record.get('ASST'),
					ALTER_DATE: UniDate.get('today'),
					ALTER_DIVI: '3',
					SAVE_FLAG: 'N'
				}				
				detailGrid3.createRow(r, 'ALTER_DATE');
				UniAppManager.setToolbarButtons('delete',true);
			}
		},
		onSaveDataButtonDown: function () {		
			var inValidRecs;
			var activeGrid;
			var activeStore;
			
			if(activeGridId == 'ass500ukrDetailGrid1' )	{
				inValidRecs = directDetailStore1.getInvalidRecords();
				activeGrid = detailGrid1;
				activeStore = directDetailStore1;
			}else if(activeGridId == 'ass500ukrDetailGrid2'){
				inValidRecs = directDetailStore2.getInvalidRecords();
				activeGrid = detailGrid2;
				activeStore = directDetailStore2;
			}else if(activeGridId == 'ass500ukrDetailGrid3'){
				inValidRecs = directDetailStore3.getInvalidRecords();
				activeGrid = detailGrid3;
				activeStore = directDetailStore3;
			}			
			
			if(inValidRecs.length != 0)	{
				activeGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				return false;		
			}else{
				activeStore.saveStore();
			}			
		},
		onDeleteDataButtonDown : function()	{
			if(activeGridId == 'ass500ukrDetailGrid1')	{
				var selRow = detailGrid1.getSelectedRecord();
				if(selRow.phantom === true)	{
					detailGrid1.deleteSelectedRow();
				}else {
					if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						detailGrid1.deleteSelectedRow();
					}					
				}
			}else if(activeGridId == 'ass500ukrDetailGrid2'){
				var selRow = detailGrid2.getSelectedRecord();
				if(selRow.phantom === true)	{
					detailGrid2.deleteSelectedRow();
				}else {
					if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						detailGrid2.deleteSelectedRow();
					}					
				}
			}else if(activeGridId == 'ass500ukrDetailGrid3'){
				var selRow = detailGrid3.getSelectedRecord();
				if(selRow.phantom === true)	{
					detailGrid3.deleteSelectedRow();
				}else {
					if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
						detailGrid3.deleteSelectedRow();
					}					
				}
			}			
		}
	});
//	Unilite.createValidator('validator01', {
//		store: directMasterStore,
//		grid: masterGrid,
//		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
//			if(newValue == oldValue){
//				return false;
//			}			
//			var rv = true;			
//			switch(fieldName) {
//				case "SEQ" :		
//					if(newValue <= 0 && !Ext.isEmpty(newValue))	{
//						rv=Msg.sMB076;
//					}
//					if(isNaN(newValue)){
//						rv = Msg.sMB074;
//					}
//					break;					
//			}
//			return rv;
//		}
//	}); 
//	
//	Unilite.createValidator('validator02', {
//		store: directDetailStore1,
//		grid: directDetailStore1,
//		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
//			if(newValue == oldValue){
//				return false;
//			}			
//			var rv = true;			
//			switch(fieldName) {
//				case "SEQ" :		
//					if(newValue <= 0 && !Ext.isEmpty(newValue))	{
//						rv=Msg.sMB076;
//					}
//					if(isNaN(newValue)){
//						rv = Msg.sMB074;
//					}
//					break;					
//			}
//			return rv;
//		}
//	}); 
		
	Unilite.createValidator('validator01', {
		store: directDetailStore1,
		grid: detailGrid1,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}			
			var rv = true;			
			switch(fieldName) {
				case "FOR_ALTER_AMT_I" :	
					record.set('ALTER_AMT_I', record.get('EXCHG_RATE_O') * newValue);
					break;
				
				case "EXCHG_RATE_O" :		
					record.set('ALTER_AMT_I', record.get('FOR_ALTER_AMT_I') * newValue);
					break;
				
				case "ALTER_DATE" :
					if(getStDt[0].STDT > UniDate.getDbDateStr(newValue) || getStDt[0].TODT < UniDate.getDbDateStr(newValue)){
						var stDate = getStDt[0].STDT.substring(0, 4) + '.' + getStDt[0].STDT.substring(4, 6) + '.'+ getStDt[0].STDT.substring(6, 8);
						var toDate = getStDt[0].TODT.substring(0, 4) + '.' + getStDt[0].TODT.substring(4, 6) + '.'+ getStDt[0].TODT.substring(6, 8);
						rv=Msg.sMA0290 + '</br>' + stDate + ' ~ ' + toDate;  
					}
					break;
			}
			return rv;
		}
	});
	
	Unilite.createValidator('validator02', {
		store: directDetailStore2,
		grid: detailGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}			
			var rv = true;			
			switch(fieldName) {
				case "FOR_ALTER_AMT_I" :	
					record.set('ALTER_AMT_I', record.get('EXCHG_RATE_O') * newValue);
					break;
				
				case "EXCHG_RATE_O" :		
					record.set('ALTER_AMT_I', record.get('FOR_ALTER_AMT_I') * newValue);
					break;
				case "ALTER_DATE" :
					if(getStDt[0].STDT > UniDate.getDbDateStr(newValue) || getStDt[0].TODT < UniDate.getDbDateStr(newValue)){
						var stDate = getStDt[0].STDT.substring(0, 4) + '.' + getStDt[0].STDT.substring(4, 6) + '.'+ getStDt[0].STDT.substring(6, 8);
						var toDate = getStDt[0].TODT.substring(0, 4) + '.' + getStDt[0].TODT.substring(4, 6) + '.'+ getStDt[0].TODT.substring(6, 8);
						rv=Msg.sMA0291 + '</br>' + stDate + ' ~ ' + toDate; 
					}
					break;
			}
			return rv;
		}
	});
	
//	Unilite.createValidator('validator03', {
//		store: directDetailStore3,
//		grid: detailGrid3,
//		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
//			if(newValue == oldValue){
//				return false;
//			}			
//			var rv = true;			
//			switch(fieldName) {
//				case "ALTER_DATE" :
//					if(getStDt[0].STDT > newValue || getStDt[0].TODT < newValue){
//						rv=Msg.sMA0290; 
//					}
//					break;
//			}
//			return rv;
//		}
//	});
};
</script>
