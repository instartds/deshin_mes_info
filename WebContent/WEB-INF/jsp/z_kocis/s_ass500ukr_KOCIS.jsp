<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_ass500ukr_KOCIS"  >
	<t:ExtComboStore comboType="BOR120"  /> 								<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A035" /> 					<!-- 완료구분-->
	<t:ExtComboStore comboType="AU" comboCode="A039" /> 					<!-- 매각구분-->
	<t:ExtComboStore comboType="AU" comboCode="A392" /> 					<!-- 처리구분-->
	<t:ExtComboStore comboType="AU" comboCode="B010" /> 					<!-- 자본적지출-->
	<t:ExtComboStore comboType="AU" comboCode="B004" /> 					<!-- 화폐단위-->
	<t:ExtComboStore comboType="AU" comboCode="ZA14" /> 					<!--10품종-->
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> 	<!--기관-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
	var activeGridId = 's_ass500ukr_KOCISDetailGrid1'; // 선택된 그리드 (detailGrid포함)
//	var tabCount = 0;	//예,아니오,취소 버튼 에서 tabPanel.setActiveTab(newCard); 또는 masterGrid.getSelectionModel().select(index); 사용시 다시 이벤트를 타기 때문에 플레그 값으로 구분하기위해.. 다른방법이 있을지?
	
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_ass500ukr_KOCISMasterModel', {	//마스터 그리드
	    fields: [
			{name: 'ITEM_CD'			 			,text: '10품종' 			,type: 'string'		, comboType: "AU"	, comboCode: "ZA14"},
	    	{name: 'PROCESS_GUBUN'		 			,text: '처분구분' 			,type: 'string'		,  editable: false		, comboType: "AU"	, comboCode: "A392"},
	    	{name: 'ASST'  				 			,text: '자산코드' 			,type: 'string'},
	    	{name: 'ASST_NAME' 			 			,text: '자산명' 			,type: 'string'},
	   		{name: 'ITEM_NM'		 				,text: '품명' 				,type: 'string'},
	    	{name: 'DEPT_CODE'  			 		,text: '기관' 				,type: 'string'},
	    	{name: 'DEPT_NAME'  		 			,text: '기관' 				,type: 'string'},
	    	{name: 'DRB_YEAR' 			 			,text: '내용년수' 			,type: 'int'},
	    	{name: 'ACQ_DATE'  			 			,text: '취득일자' 			,type: 'uniDate'},
	    	{name: 'PLACE_INFO'			 			,text: '사용위치' 			,type: 'string'},
	    	{name: 'ACQ_AMT_I'  		 			,text: '취득가격' 			,type: 'uniPrice'}
/*	추가필드 : 필요시 사용
    		{name: 'SPEC' 				 			,text: '규격' 				,type: 'string'},
	    	{name: '물품용도'  		 				,text: '물품용도' 			,type: 'uniDate'},
	    	{name: '물품상태'  		 				,text: '물품상태' 			,type: 'uniDate'},
	    	{name: 'REMARK'				 			,text: '관련근거' 			,type: 'string'}
*/
		]
	});
	
	Unilite.defineModel('s_ass500ukr_KOCISDetailModel1', { //디테일 탭1
	    fields: [
	    	//입력시 table 필수컬럼
	    	{name: 'PROCESS_GUBUN'		 			,text: '처분구분' 			,type: 'string'		, allowBlank: false		,  editable: false		, comboType: "AU"	, comboCode: "A392"},
			{name: 'COMP_CODE'		 				,text: 'COMP_CODE' 		,type: 'string'},
	    	{name: 'ASST'  				 			,text: '자산코드' 			,type: 'string'},
//	    	{name: 'ALTER_DIVI'			 			,text: '변동구분' 			,type: 'string'},
	    	{name: 'SEQ' 			 				,text: '순번'	 			,type: 'int'},
//	    	{name: 'WASTE_DIVI'			 			,text: '매각/폐기구분' 		,type: 'string'},
	   		{name: 'ALTER_DATE'	 					,text: '변동일자'			,type: 'uniDate'},
			{name: 'ALTER_Q'		 				,text: '변동수량' 			,type: 'uniQty'},
	    	{name: 'MONEY_UNIT' 			 		,text: '화폐단위' 			,type: 'string'		, comboType: "AU"	, comboCode: "B004"},
//	    	{name: 'SALE_DPR_AMT' 			 		,text: '상각감소액' 		,type: 'uniPrice'},
	    	//그리드 사용 컬럼
	    	{name: 'EX_DATE' 			 			,text: '처분일' 			,type: 'uniDate'	, allowBlank: false},
	    	{name: 'SALE_AMT' 			 			,text: '처분액' 			,type: 'uniPrice'},
	   		{name: 'PROCESS_USER'	 				,text: '처분담당자id'		,type: 'string'		,  editable: false},
	   		{name: 'USER_NAME'	 					,text: '처분담당자'		,type: 'string'		,  editable: false},
	    	{name: 'ALTER_REASON'  			 		,text: '처분사유' 			,type: 'string'}
		]         	
	});
	
	
	
	  
	var directMasterProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read 	: 's_ass500ukrService_KOCIS.selectMasterList'
        }
	});
	
	var directDetailProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read	: 's_ass500ukrService_KOCIS.selectDetailList1',
        	update	: 's_ass500ukrService_KOCIS.updateDetail1',
			create	: 's_ass500ukrService_KOCIS.insertDetail1',
			destroy	: 's_ass500ukrService_KOCIS.deleteDetail1',
			syncAll	: 's_ass500ukrService_KOCIS.saveAll'
        }
	});

	
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('s_ass500ukr_KOCISMasterStore1',{
		model		: 's_ass500ukr_KOCISMasterModel',
		uniOpt		: {
            isMaster	: false,			// 상위 버튼 연결 
            editable	: false,			// 수정 모드 사용 
            deletable	: false,			// 삭제 가능 여부 
	        useNavi		: false				// prev | newxt 버튼 사용
        },
        autoLoad	: false,
        proxy		: directMasterProxy,
        
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
        },
		listeners:{
			load: function(store, records, successful, eOpts) {
//				if(records.length > 0) UniAppManager.setToolbarButtons(['newData'], true);
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
//				UniAppManager.setToolbarButtons('save', true);		
			},
			datachanged : function(store,  eOpts) {
//				if( detailStore.isDirty() || store.isDirty())	{
//					UniAppManager.setToolbarButtons('save', true);	
//				}else {
//					UniAppManager.setToolbarButtons('save', false);
//				}
			}
		}
	});
		
	var detailStore = Unilite.createStore('s_ass500ukr_KOCISDetailStore',{
		model		: 's_ass500ukr_KOCISDetailModel1',
		uniOpt		: {
            isMaster	: false,		// 상위 버튼 연결 
            editable	: true,			// 수정 모드 사용 
            deletable	: true,			// 삭제 가능 여부 
	        useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad	: false,
        proxy		: directDetailProxy1,
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
				//취득일 보다 처분일이 빠르면 오류
				//취득일
				var masterRecord	= masterGrid.getSelectedRecord();
				var acqDate			= UniDate.getDbDateStr(masterRecord.get('ACQ_DATE'))
				//처분일
				var exDate = UniDate.getDbDateStr(record.get('EX_DATE'))
				if(acqDate > exDate){
					var acqDate = acqDate.substring(0, 4) + '.' + acqDate.substring(4, 6) + '.'+ acqDate.substring(6, 8);
					alert('처분일은 취득일(' + acqDate + ') 보다 빠를 수 없습니다.'); 
					isErr = true;
					return false;
				}			
			});
			
			if(isErr) return false;
			
			var config = {
				params	: [panelSearch.getValues()],
				success	: function()	{
					UniAppManager.setToolbarButtons('save', false);	
					UniAppManager.app.onQueryButtonDown(); 
				},
				failure: function(batch, option) {
					UniAppManager.app.onQueryButtonDown(); 
				}
			}
			this.syncAllDirect(config);			
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
           		UniAppManager.setToolbarButtons('newData', true);
       			
           		if(records != null && records.length > 0 ){
           			UniAppManager.setToolbarButtons('delete', true);
           			
           		} else {
           			UniAppManager.setToolbarButtons('delete', false);
           		}
			},
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', false);	
			},
			datachanged : function(store,  eOpts) {
				if(store.isDirty()){
					UniAppManager.setToolbarButtons('save', true);	
					
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
			}
		}
	});	
	
	var buttonStore = Unilite.createStore('s_ass500ukr_KOCISbuttonStore',{
		model		: 's_ass500ukr_KOCISDetailModel1',
		uniOpt		: {
            isMaster	: false,		// 상위 버튼 연결 
            editable	: false,		// 수정 모드 사용 
            deletable	: false,		// 삭제 가능 여부 
	        useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad	: false,
        proxy		: directDetailProxy1,
		saveStore	: function()	{
			var isErr = false;
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	var list = [].concat(toUpdate,toCreate); 
        	
			Ext.each(list, function(record, index) {
				//취득일 보다 처분일이 빠르면 오류
				//취득일
				var masterRecord	= masterGrid.getSelectedRecord();
				var acqDate			= UniDate.getDbDateStr(masterRecord.get('ACQ_DATE'))
				//처분일
				var exDate = UniDate.getDbDateStr(record.get('EX_DATE'))
				if(acqDate > exDate){
					var acqDate = acqDate.substring(0, 4) + '.' + acqDate.substring(4, 6) + '.'+ acqDate.substring(6, 8);
					alert('처분일은 취득일(' + acqDate + ') 보다 빠를 수 없습니다.'); 
					isErr = true;
					return false;
				}			
			});
			
			if(isErr) return false;
			
			var config = {
				params	: [panelSearch.getValues()],
				success	: function()	{
					UniAppManager.setToolbarButtons('save', false);	
					UniAppManager.app.onQueryButtonDown(); 
				},
				failure: function(batch, option) {
					UniAppManager.app.onQueryButtonDown(); 
				}
			}
			this.syncAllDirect(config);			
		},
		listeners:{
			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
				UniAppManager.setToolbarButtons('save', false);	
			}
		}
	});
	

	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title		: '검색조건',
        defaultType	: 'uniSearchSubPanel',
        collapsed	: true,
        listeners	: {
	        collapse: function () {
	            panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
        },
		items		: [{
			title		: '기본정보', 	
   			itemId		: 'search_panel1',
           	layout		: {type: 'uniTable', columns: 1},
           	defaultType	: 'uniTextfield',
		    items		: [
				Unilite.popup('ASSET',{ 
			    fieldLabel		: '자산코드', 
			    validateBlank	: false,
//			    allowBlank:false,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ASSET_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ASSET_NAME', newValue);				
					}
				}
		   	}),
				Unilite.popup('ASSET',{ 
			    fieldLabel		: '~',
			    valueFieldName	: 'ASSET_CODE2', 
				textFieldName	: 'ASSET_NAME2', 
			    validateBlank	: false,
//			    allowBlank:false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ASSET_CODE2', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ASSET_NAME2', newValue);				
					}
				}
		   	}),{
				fieldLabel	: '기관',
				name		: 'DEPT_CODE', 
				xtype		: 'uniCombobox',
                store		: Ext.data.StoreManager.lookup('deptKocis'),
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DEPT_CODE', newValue);
					}
				}
			},{
				fieldLabel	: '처분구분'	,
				name		: 'PROCESS_GUBUN', 
				xtype		: 'uniCombobox', 
				comboType	: 'AU',
				comboCode	: 'A392',
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PROCESS_GUBUN', newValue);
					}
				}
			}]
		}/*,{
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
					fieldLabel:'내용년수', suffixTpl:'&nbsp;~&nbsp;', name: 'DRP_YEAR_FR', width:218
				}, {
					name: 'DRP_YEAR_TO', width:107
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
					fieldLabel:'취득가액', suffixTpl:'&nbsp;~&nbsp;', name: 'ACQ_AMT_I_FR', width:218
				}, {
					name: 'ACQ_AMT_I_TO', width:107
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
					fieldLabel:'외화취득가액', suffixTpl:'&nbsp;~&nbsp;', name: 'FOR_ACQ_AMT_I_FR', width:218
				}, {
					name: 'FOR_ACQ_AMT_I_TO', width:107
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
				name:'PROCESS_GUBUN',	
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
	    }*/]		
	});	
	
    var panelResult = Unilite.createSearchForm('panelResultForm', {		
    	hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 2},
		padding	: '1 1 1 1',
		border	: true,
	    items	: [{		 	 	
	    	xtype		: 'container',
			layout		: {type: 'uniTable', columns : 2},
			items		:[			
				Unilite.popup('ASSET',{ 
			    fieldLabel		: '자산코드', 
			    validateBlank	: false,
	//			allowBlank		: false,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('ASSET_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('ASSET_NAME', newValue);				
					}
				}
		   	}),
				Unilite.popup('ASSET',{ 
			    fieldLabel		: '~',
			    valueFieldName	: 'ASSET_CODE2', 
				textFieldName	: 'ASSET_NAME2', 
				labelWidth		: 20,
			    validateBlank	: false,
	//			allowBlank:false,
				listeners		: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('ASSET_CODE2', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('ASSET_NAME2', newValue);				
					}
				}
		   	})]
	    },{
			fieldLabel	: '기관',
			name		: 'DEPT_CODE', 
			xtype		: 'uniCombobox',
            store		: Ext.data.StoreManager.lookup('deptKocis'),
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DEPT_CODE', newValue);
				}
			}
		},{
			fieldLabel	: '처분구분'	,
			name		: 'PROCESS_GUBUN', 
			xtype		: 'uniCombobox', 
			comboType	: 'AU',
			comboCode	: 'A392',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PROCESS_GUBUN', newValue);
				}
			}
		}]
	});
  
	var inputPanel = Unilite.createSearchForm('detailForm', { //createForm
		layout	: {type : 'uniTable', columns : 4, tdAttrs: {width: '100%'/*, style: 'border : 1px solid #ced9e7;'*/ }},
		disabled: false,
		border	: true,
		padding	: '1',
		region	: 'center',
		items	: [{
				fieldLabel	: '처분일자',
		        xtype		: 'uniDatefield',
		 		name		: 'ISSUE_EXPECTED_DATE',
		 		width		: 253,
		 		tdAttrs		: {width: 380},
		        allowBlank	: false
		     },{
    			fieldLabel	: '처분구분'	,
    			name		: 'PROCESS_GUBUN', 
    			xtype		: 'uniCombobox', 
    			comboType	: 'AU',
    			comboCode	: 'A392',
		 		width		: 253,
		 		tdAttrs		: {width: 380},
		        allowBlank	: false
			},
			Unilite.popup('USER_SINGLE',{
			    fieldLabel		: '담당자',
			    valueFieldName	: 'INSERT_DB_USER', 
				textFieldName	: 'PERSON_NAME', 
		 		width			: 253,
    			readOnly		: true,
		        allowBlank		: false,
				listeners	: {
					onValueFieldChange: function(field, newValue){
//							detailForm.setValue('PURCHASE_DEPT_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
//							detailForm.setValue('PURCHASE_DEPT_NAME', newValue);				
					}
				}
			}),{
			xtype	: 'container',
			layout	: {type : 'uniTable'},
			tdAttrs	: {align: 'right'},
	 		padding	: '0 0 5 0',
			items	: [{				   
				xtype	: 'button',
				name	: 'CONFIRM_CHECK',
				id		: 'procCanc',
				text	: '일괄처분',
		 		tdAttrs	: {align: 'right'},
				width	: 100,
				handler	: function() {
					if(!inputPanel.getInvalidMessage()){
						return false;
					}
					
					var records = masterGrid.getSelectedRecords();
                    if(records.length > 0){
		        		if(confirm('일괄처분을 실행할 경우, 처분액이 0으로 저장 됩니다. \n그대로 진행하시겠습니까?')){	
                            //insert할 데이터 저장용 store에 저장
                            buttonStore.clearData();
	
							Ext.each(records, function(record, index) {
								//TABLE 필수값 입력
								record.data.COMP_CODE		= UserInfo.compCode;
								record.data.ASST			= record.get('ASST');
								record.data.SEQ				= 1;
								record.data.ALTER_DATE		= UniDate.get('today');
								record.data.ALTER_Q			= 1;
								record.data.MONEY_UNIT		= UserInfo.currency;
	
								//그리드 입력 값 SET
								record.data.PROCESS_GUBUN	= inputPanel.getValue('PROCESS_GUBUN');
								record.data.EX_DATE			= UniDate.get('today');
								record.data.SALE_AMT		= 0;
								record.data.USER_ID			= UserInfo.userID;
								record.data.USER_NAME		= UserInfo.userName;
								record.data.ALTER_REASON	= '일괄처분';
								
	                            record.phantom = true;
	                            buttonStore.insert(index, record);
	
							});
                            buttonStore.saveStore();
		        		}
						
                    } else {
                        Ext.Msg.alert('확인','선택된 데이터가 없습니다.'); 
                    }
				}
			}]
		}]
	});
	

	
    var masterGrid = Unilite.createGrid('s_ass500ukr_KOCISMasterGrid', {
    	layout : 'fit',
    	region: 'center',
        store : masterStore, 
        uniOpt: {
    		expandLastColumn	: true,
		 	useRowNumberer		: true
//		 	copiedRow: true
//		 	useContextMenu: true,
        },
    	selModel	: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false, /*mode: 'SINGLE' ,*/
    		listeners: { 
				beforeselect: function(rowSelection, record, index, eOpts) {
//	    			if (this.selected.getCount() > 0) {
//						return false;
//	    			}
	        	},
    			select: function(grid, selectRecord, index, rowIndex, eOpts ){
	    			if (this.selected.getCount() > 0) {
						Ext.getCmp('procCanc').enable();
	    			}
    			},
	    		deselect:  function(grid, selectRecord, index, eOpts ){
	    			if (this.selected.getCount() == 0) {			//체크된 데이터가 0개일  때는 버튼 비활성화
						Ext.getCmp('procCanc').disable();
	    			}
	    		}
    		}
        }),
    	features	: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
    	           		{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} ],
        columns: [        
        	{														
				xtype		: 'rownumberer',									
				align		:'center  !important', 					
				width		: 35,														
				sortable	: false,													
				resizable	: true											
			},												
        	{dataIndex: 'ITEM_CD'			 				,  width: 100},
	    	{dataIndex: 'PROCESS_GUBUN'			  			,  width: 80}, 
			{dataIndex: 'ASST'  				 			,  width: 100},
			{dataIndex: 'ASST_NAME' 			 			,  width: 120},
			{dataIndex: 'ITEM_NM' 			 				,  width: 120},
			{dataIndex: 'DEPT_CODE'  			 			,  width: 100	, hidden: true},
			{dataIndex: 'DEPT_NAME'  		 				,  width: 100},
			{dataIndex: 'DRB_YEAR' 			 				,  width: 100	, align: 'center'},
			{dataIndex: 'ACQ_DATE'  			 			,  width: 100},
			{dataIndex: 'PLACE_INFO'			 			,  width: 120},
			{dataIndex: 'ACQ_AMT_I'  		 				,  width: 166/*flex: 1		, minWidth: 166*/},
			{dataIndex: 'REMARK'				 			,  flex: 1		, minWidth: 166		, hidden: true}
		],
		listeners: {	
        	select:function(grid, record, index, eOpts ){	    	        		
//        		detailStore.loadData({});
    			detailStore.loadStoreRecords(record);
          	},
          	render: function(grid, eOpts){
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	var records = masterGrid.getSelectedRecords();
			    	if(records.length == 0){
			    		UniAppManager.setToolbarButtons(['newData'], false);
			    		UniAppManager.setToolbarButtons(['delete'], false);
			    	}
			    });
			},	
			beforeselect : function ( gird, record, index, eOpts ){			
//			 	if( tabCount > 0) return true; 
//	     		var isNewCardShow = true;		//newCard 보여줄것인지?
//	     		var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
//				switch(activeGridId)	{
//					case 's_ass500ukr_KOCISDetailGrid1':
//						if(needSave){
//							isNewCardShow = false;
//							Ext.Msg.show({
//							     title:'확인',
//							     msg: Msg.sMB017 + "\n" + Msg.sMB061,
//							     buttons: Ext.Msg.YESNOCANCEL,
//							     icon: Ext.Msg.QUESTION,
//							     fn: function(res) {
//							     	//console.log(res);
//							     	if (res === 'yes' ) {							     		
//							     		var inValidRecs;
//							     		var activeStore
//						     			inValidRecs = detailStore.getInvalidRecords();
//						     			activeStore = detailStore;	
//						     			
//										if(inValidRecs.length > 0 )	{
//											alert(Msg.sMB083);
//										}else {
//											activeStore.saveStore(index);
//											tabCount = 1;
//											masterGrid.getSelectionModel().select(index);
//										}
//							     	}else if(res === 'no'){
//										tabCount = 1;
//							     		UniAppManager.setToolbarButtons('save', false);
//							     		masterGrid.getSelectionModel().select(index);
//							     	}else{
//							     		
//							     	}
//							     }
//							});
//						}
//						break;
//
//					default:
//						break;
//				}
//				return isNewCardShow;
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
        	}
//      		onGridDblClick: function(grid, record, cellIndex, colName) {
//				var params = {
//					appId: UniAppManager.getApp().id,
//					sender: this,
//					action: 'new',
//					ASST: record.get('ASST'),
//					ASST_NAME: record.get('ASST_NAME')
//				}
//				var rec = {data : {prgID : 'ass300ukr', 'text':''}};									
//				parent.openTab(rec, '/accnt/ass300ukr.do', params);		
//          	}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
//      		return true;
      	},
      	uniRowContextMenu:{
//			items: [
//	            {	text	: '고정자산 등록',   
//	            	handler	: function(menuItem, event) {
//	            		var param = menuItem.up('menu');
//	            		masterGrid.gotoAss300skr(param.record);
//	            	}
//	        	}
//	        ]
	    },
	    gotoAss300skr:function(record)	{
//			if(record)	{
//		    	var params = record;
//		    	params.PGM_ID 			= 's_ass500ukr_KOCIS';
//		    	params.ASST 			=	record.get('ASST');
//		    	params.ASST_NAME 		=	record.get('ASST_NAME');
//			}
//	  		var rec1 = {data : {prgID : 'ass300ukr', 'text':''}};							
//			parent.openTab(rec1, '/accnt/ass300ukr.do', params);
    	}
    }); 
    
     /**
     * detailGrid1 정의(Grid Panel)
     * @type 
     */
    var detailGrid1 = Unilite.createGrid('s_ass500ukr_KOCISDetailGrid1', {
    	title	: '처분내역',
		store	: detailStore,
    	layout	: 'fit',
    	region	: 'south', 
        uniOpt	: {
			onLoadSelectFirst	: false,
        	expandLastColumn	: false,
		 	useRowNumberer		: true,
		 	copiedRow			: true,
            onLoadSelectFirst	: false
//		 	useContextMenu: true,
        },
    	features	: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
    	           		{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} ],
        columns: [            
	    	{dataIndex: 'PROCESS_GUBUN'			  	, width: 80}, 				
			{dataIndex: 'EX_DATE'			  	  	, width: 100}, 
        	{dataIndex: 'SALE_AMT'		      		, width: 120}, 				
			{dataIndex: 'PROCESS_USER'				, width: 150		, hidden: true}, 
			{dataIndex: 'USER_NAME'					, width: 150},
			{dataIndex: 'ALTER_REASON'		        , flex: 1			, minWidth: 100} 				
		],                                                       
		listeners: {	                                         
        	selectionchange:function( model1, selected, eOpts ){
//       			if(selected.length > 0)	{
//	        		var record = selected[0];	        		
//	        		detailStore.loadData({})
//	        		if(!record.phantom){
//	        			detailStore.loadStoreRecords(record);
//	        		}	        		
//       			}
          	},
          	render: function(grid, eOpts){
			 	var girdNm = grid.getItemId();
			 	var store = grid.getStore();
			 	var mLength = masterStore.data.items.length;
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	if(masterStore.data.items.length > 0) UniAppManager.setToolbarButtons(['newData'], true);
			    	if(detailStore.data.items.length > 0){
			    		UniAppManager.setToolbarButtons('delete', true);
			    	}else{
			    		UniAppManager.setToolbarButtons('delete', false);
			    	}			    
			    	activeGridId = girdNm;
//			    	activeDetailGridId = girdNm;	
			    	store.onStoreActionEnable();
			    	if( detailStore.isDirty() )	{
						UniAppManager.setToolbarButtons('save', true);	
					}else {
						UniAppManager.setToolbarButtons('save', false);
					}
			    	if(grid.getStore().getCount() > 0)	{
						UniAppManager.setToolbarButtons('delete', true);		
					}else {
						UniAppManager.setToolbarButtons('delete', false);
					}
			    });
			 },
			 beforedeselect : function ( gird, record, index, eOpts ){				
//				if(detailStore.isDirty())	{
//					if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{
//						var inValidRecs = detailStore.getInvalidRecords();
//						if(inValidRecs.length > 0 )	{
//							alert(Msg.sMB083);
//							return false;
//						}else {
//							detailStore.saveStore();
//						}
//					}
//				}
			},
			beforeedit  : function( editor, e, eOpts ) {
//          		if (UniUtils.indexOf(e.field,["SEQ", "ACCNT_CD"])) {
//					if(e.record.phantom){
//						return true;
//					}else{
//						return false;
//					}
//				}else if (UniUtils.indexOf(e.field,["ACCNT_NAME", "ACCNT_NAME2", "ACCNT_NAME3", "OPT_DIVI", "DIS_DIVI"])) {
//					return true
//				}else{
//					return false;
//				}
			}
		}
    });

    
    
	 Unilite.Main({
		id			: 's_ass500ukr_KOCISApp',
	 	border		: false,
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				detailGrid1, masterGrid, panelResult,
				{
					region	: 'north',
					xtype	: 'container',
					highth	: 20,
					layout	: 'fit',
					items	: [ inputPanel ]
				}
			]
		},
			panelSearch
		], 
		
		fnInitBinding : function() {			
			UniAppManager.setToolbarButtons(['newData']	, false);
			UniAppManager.setToolbarButtons(['reset']	, false);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('ASSET_CODE');
			
			this.setDefault();
		},
		
		onQueryButtonDown : function()	{					
			if(!this.isValidSearchForm()){
				return false;
				
			}else{
				detailGrid1.getStore().loadData({});
				masterStore.loadStoreRecords();
			}
		}, 
		
		//물품이 하나만 등록 되므로 처분내역도 하나만 등록 가능하게 함
		onNewDataButtonDown : function()	{
			if(!inputPanel.getInvalidMessage()){
				return false;
				
			} else {
				if(masterGrid.selModel.getCount() > 1) {
					alert('개별 처분의 경우 하나의 물품만 선택하시기 바랍니다.');
					return false;
				}
				if(detailStore.data.length > 0) {
					alert('하나의 처분 내역만 등록 가능합니다.');
					return false;
					
				} else {
					var record = masterGrid.getSelectedRecord();
//					var seq = detailStore.max('SEQ');
//	            	if(!seq)	seq = 1;
//	            	else		seq += 1;
	            	
					var r = {
						//TABLE 필수값 입력
						COMP_CODE		: UserInfo.compCode,			//법인코드
						ASST			: record.get('ASST'),			//자산코드
	//					ALTER_DIVI		: '2',							//변동구분(1:자본적지출, 2:매각/폐기)			???
						SEQ				: 1,							//순번
	//					WASTE_DIVI		: '2',							//매각/폐기구분									???
						ALTER_DATE		: UniDate.get('today'),			//변동일자
						ALTER_Q			: 1,							//변동수량										?
						MONEY_UNIT		: UserInfo.currency,			//화폐단위(B004)
	//					SALE_DPR_AMT	: 0,							//상각감소액									???
						
						//그리드 입력 값 SET
						PROCESS_GUBUN	: inputPanel.getValue('PROCESS_GUBUN'),
						EX_DATE			: UniDate.get('today'),			//처분일
						SALE_AMT		: 0,							//처분액
						USER_ID			: UserInfo.userID,				//처분담당자
						USER_NAME		: UserInfo.userName				//처분담당자
					}				
					detailGrid1.createRow(r);
					
			    	UniAppManager.setToolbarButtons('save', true);
				}
			}
		},
		
		onSaveDataButtonDown: function () {		
			var inValidRecs;
			inValidRecs = detailStore.getInvalidRecords();
			
			if(inValidRecs.length != 0)	{
				detailGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
				return false;		
				
			} else {
				detailStore.saveStore();
			}			
		},
		
		onDeleteDataButtonDown : function()	{
			var selRow = detailGrid1.getSelectedRecord();
			if(Ext.isEmpty(selRow)) {
				alert('삭제할 처분내역을 선택해 주세요.');
				return false;
			}
			if(selRow.phantom === true)	{
				detailGrid1.deleteSelectedRow();
			}else {
				if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
					detailGrid1.deleteSelectedRow();
				}					
			}
		},
		
		setDefault: function() {
			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
			
			inputPanel.setValue('ISSUE_EXPECTED_DATE'	, UniDate.get('today'));
			inputPanel.setValue('PERSON_NAME'			, UserInfo.userName);
			
            if(!Ext.isEmpty(UserInfo.deptCode)){
				if(UserInfo.deptCode == '01') {
					panelSearch.getField('DEPT_CODE').setReadOnly(false);
					panelResult.getField('DEPT_CODE').setReadOnly(false);
					
				} else {
					panelSearch.getField('DEPT_CODE').setReadOnly(true);
					panelResult.getField('DEPT_CODE').setReadOnly(true);
				}
				
            }else{
                panelSearch.getField('DEPT_CODE').setReadOnly(true);
                panelResult.getField('DEPT_CODE').setReadOnly(true);
                //부서정보가 없을 경우, 조회버튼 비활성화
			    UniAppManager.setToolbarButtons('query',false);
            }
			
			Ext.getCmp('procCanc').disable();
		}
	});
		
//	Unilite.createValidator('validator01', {
//		store	: detailStore,
//		grid	: detailGrid1,
//		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
//			if(newValue == oldValue){
//				return false;
//			}			
//			var rv = true;			
//			switch(fieldName) {
//				case "FOR_ALTER_AMT_I" :	
//					record.set('ALTER_AMT_I', record.get('EXCHG_RATE_O') * newValue);
//					break;
//				
//				case "EXCHG_RATE_O" :		
//					record.set('ALTER_AMT_I', record.get('FOR_ALTER_AMT_I') * newValue);
//					break;
//				
//				case "ALTER_DATE" :
//					if(getStDt[0].STDT > UniDate.getDbDateStr(newValue) || getStDt[0].TODT < UniDate.getDbDateStr(newValue)){
//						var stDate = getStDt[0].STDT.substring(0, 4) + '.' + getStDt[0].STDT.substring(4, 6) + '.'+ getStDt[0].STDT.substring(6, 8);
//						var toDate = getStDt[0].TODT.substring(0, 4) + '.' + getStDt[0].TODT.substring(4, 6) + '.'+ getStDt[0].TODT.substring(6, 8);
//						rv=Msg.sMA0290 + '</br>' + stDate + ' ~ ' + toDate;  
//					}
//					break;
//			}
//			return rv;
//		}
//	});
	
};
</script>
