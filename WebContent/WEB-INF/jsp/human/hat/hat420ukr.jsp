<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hat420ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 --> 
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 --> 
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!-- 근무조 --> 
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var gsbtnYn = 'Y';
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hat420ukrModel', {
		fields: [
			{name: 'APPRO_TYPE'   	, text: '승인'	, type: 'boolean'},
			{name: 'APPRO_TYPE2'  	, text: '승인2'	, type: 'boolean'},
			{name: 'WORK_TEAM'    	, text: '근무조'	, type: 'string', comboType:'AU', comboCode:'H004'},
			{name: 'DUTY_YYYYMMDD'	, text: '근무일'	, type: 'uniDate'},
			{name: 'DIV_CODE'    	, text: '사업장'	, type: 'string', comboType: 'BOR120'},
			{name: 'DEPT_CODE'    	, text: '부서코드'	, type: 'string'},
			{name: 'DEPT_NAME'    	, text: '부서명'	, type: 'string'},
			{name: 'POST_CODE'    	, text: '직위'	, type: 'string', comboType:'AU', comboCode:'H005' },
			{name: 'NAME'         	, text: '성명'	, type: 'string'},
			{name: 'PERSON_NUMB'  	, text: '사번'	, type: 'string'},
			{name: 'PLAN_H'       	, text: '출근시'	, type: 'string', allowBlank: false},
			{name: 'PLAN_M'     	, text: '출근분'	, type: 'string', allowBlank: false},
			{name: 'DUTY_FR_H'   	, text: '시작시각'	, type: 'string'},
			{name: 'DUTY_FR_M' 		, text: '시작분'	, type: 'string'},
			{name: 'DUTY_TO_D'    	, text: '시작시각'	, type: 'string'},
			{name: 'DUTY_TO_H'   	, text: '종료시각'	, type: 'string'},
			{name: 'DUTY_TO_M' 		, text: '종료분'	, type: 'string'},
			{name: 'FLAG'     	 	, text: '플래그'	, type: 'string'},
			{name: 'CLOSE_DATE'   	, text: 'CLOSE_DATE'		, type: 'string'}
		]
	});//End of Unilite.defineModel('Hat420ukrModel', {
	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'hat420ukrService.selectList',
			update: 'hat420ukrService.updateHat420t',
      	    destroy: 'hat420ukrService.deleteHat420t',
			syncAll: 'hat420ukrService.saveAll'
		}
	});
	
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('hat420ukrMasterStore', {
		model: 'Hat420ukrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: true,			// 삭제 가능 여부 
			allDeletable: true,		//전체 삭제 가능 여부
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();			
			console.log(param);
			this.load({
				params: param
			});
		},saveStore : function()	{				
			var inValidRecs = this.getInvalidRecords();
			if(inValidRecs.length == 0 )	{
				var config = {
					success: function(batch, option) {
						directMasterStore.loadStoreRecords();
					 } 
				}
				directMasterStore.syncAllDirect(config);	
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}			
		
// 		,groupField: 'CUSTOM_NAME'
	});
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {
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
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{ 
				fieldLabel: '근무기간',
	        	xtype: 'uniDateRangefield',
	        	startFieldName: 'DUTY_YYYYMMDD_FR',
	        	endFieldName: 'DUTY_YYYYMMDD_TO',
	        	width: 470,
	        	startDate: UniDate.get('today'),
	        	endDate: UniDate.get('today'),
	        	allowBlank: false,                	
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelResult.setValue('DUTY_YYYYMMDD_FR', newValue);						
	            	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DUTY_YYYYMMDD_TO', newValue);				    		
			    	}
			    }
	        },{
				fieldLabel: '지급차수',				
				name: 'PAY_PROV_FLAG',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H031',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_PROV_FLAG', newValue);
					}
				}
			},{
				fieldLabel: '급여지급방식',
				name: 'PAY_CODE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H028',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_CODE', newValue);
					}
				}
			},
			Unilite.treePopup('DEPTTREE',{
				fieldLabel: '부서',
				valueFieldName:'DEPT',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPTS' ,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
				textFieldWidth:89,
				validateBlank:true,
				width:300,
				autoPopup:true,
				useLike:true,
				listeners: {
	                'onValueFieldChange': function(field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT',newValue);
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
	                    	panelResult.setValue('DEPT_NAME',newValue);
	                },
	                'onValuesChange':  function( field, records){
	                    	var tagfield = panelResult.getField('DEPTS') ;
	                    	tagfield.setStoreData(records)
	                }
				}
			}),			
		     	Unilite.popup('Employee',{ 
				
				validateBlank: false,
				listeners: {
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
//							panelResult.setValue('NAME', panelSearch.getValue('NAME'));
//	                	},
//						scope: this
//					},
//					onClear: function(type)	{
//						panelResult.setValue('PERSON_NUMB', '');
//						panelResult.setValue('NAME', '');
//					}
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					}
				}
			}),{
				fieldLabel: '근무조',
				name: 'WORK_TEAM', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H004',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WORK_TEAM', newValue);
					}
				}
			},{
				fieldLabel: '고용형태',
				name: 'PAY_GUBUN', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H011',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_GUBUN', newValue);
					},
					specialkey: function(elm, e){
						UniAppManager.app.onQueryButtonDown();
					}
				}
			},{
	    		xtype: 'button',
	    		width: 90,
	    		id: 'selectBtn1',
	    		margin: '0 0 0 95',
	    		text: '전체선택',
	    		handler: function(){
	    			if(directMasterStore.data.count() <= 0)	return;
	    			if(gsbtnYn == "Y"){
	    				SelectAll();  	
	    			}else{
	    				DeSelectAll();  	
	    			}
	    			
	    		}
	    	}]
		}]
	});
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel: '근무기간',
        	xtype: 'uniDateRangefield',
        	startFieldName: 'DUTY_YYYYMMDD_FR',
        	endFieldName: 'DUTY_YYYYMMDD_TO',
        	startDate: UniDate.get('today'),
        	endDate: UniDate.get('today'),
        	allowBlank: false,                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('DUTY_YYYYMMDD_FR', newValue);						
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('DUTY_YYYYMMDD_TO', newValue);				    		
		    	}
		    }
        },{
			fieldLabel: '지급차수',				
			name: 'PAY_PROV_FLAG',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H031',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_PROV_FLAG', newValue);
				}
			}
		},{
			fieldLabel: '급여지급방식',
			name: 'PAY_CODE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H028',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_CODE', newValue);
				}
			}
		},
		Unilite.treePopup('DEPTTREE',{
			fieldLabel: '부서',
			valueFieldName:'DEPT',
			textFieldName:'DEPT_NAME' ,
			valuesName:'DEPTS' ,
			DBvalueFieldName:'TREE_CODE',
			DBtextFieldName:'TREE_NAME',
			selectChildren:true,
			textFieldWidth:89,
			validateBlank:true,
			width:300,
			autoPopup:true,
			useLike:true,
			listeners: {
                'onValueFieldChange': function(field, newValue, oldValue  ){
                    	panelSearch.setValue('DEPT',newValue);
                },
                'onTextFieldChange':  function( field, newValue, oldValue  ){
                    	panelSearch.setValue('DEPT_NAME',newValue);
                },
                'onValuesChange':  function( field, records){
                    	var tagfield = panelSearch.getField('DEPTS') ;
                    	tagfield.setStoreData(records)
                }
			}
		}),			
	     	Unilite.popup('Employee',{ 
			
			validateBlank: false,
			listeners: {
//					onSelected: {
//						fn: function(records, type) {
//							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
//							panelResult.setValue('NAME', panelSearch.getValue('NAME'));
//	                	},
//						scope: this
//					},
//					onClear: function(type)	{
//						panelResult.setValue('PERSON_NUMB', '');
//						panelResult.setValue('NAME', '');
//					}
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);				
				}
			}
		}),{
			fieldLabel: '근무조',
			name: 'WORK_TEAM', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H004',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WORK_TEAM', newValue);
				}
			}
		},{
			fieldLabel: '고용형태',
			name: 'PAY_GUBUN', 
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'H011',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_GUBUN', newValue);
				},
				specialkey: function(elm, e){
					UniAppManager.app.onQueryButtonDown();
				}
			}
		},{
			xtype: 'component'
		},{
    		xtype: 'button',
    		width: 90,
    		tdAttrs: {align: 'right'},
    		margin: '0 30 4 0',
    		id: 'selectBtn2',
    		text: '전체선택',
    		handler: function(){
    			if(directMasterStore.data.count() <= 0)	return;    			
    			if(gsbtnYn == "Y"){
    				SelectAll();
    			}else{
    				DeSelectAll();
    			}
    		}				
		}]	
    });
    
    
    var detailForm = Unilite.createSearchForm('hat400ukrDetailForm',{
		padding:'0 1 0 1',
		border:true,
		region: 'center',
	    items: [{	
	    	xtype:'container',
	        defaultType: 'uniTextfield',
	        layout: {
	        	type: 'uniTable',
	        	columns : 3
	        },
	        items: [
			{fieldLabel: '출근시', allowBlank: false, name: 'PLAN_H', id: 'PLAN_H', width: 165,
				listeners: {
					blur: function(field, The, eOpts){
						if (field.getValue().length > 2 || parseInt(field.getValue()) > 24 || parseInt(field.getValue()) < 0 || isNaN(field.getValue())) {
							Ext.Msg.alert('확인', '정확한 시를 입력하십시오.');
							this.setValue('');
							return false;
						}else{
							if(field.getValue().length == 1){
								this.setValue('0' + field.getValue());
							}						
						}					
					}
				}
			},
        	{fieldLabel: '출근분', allowBlank: false, name: 'PLAN_M', id: 'PLAN_M', width: 165,
				listeners: {
					blur: function(field, The, eOpts){
						if (field.getValue().length > 2 || parseInt(field.getValue()) > 60 || parseInt(field.getValue()) < 0 || isNaN(field.getValue())) {
							Ext.Msg.alert('확인', '정확한 분을 입력하십시오.');
							this.setValue('');
							return false;
						}else{
							if(field.getValue().length == 1){
								this.setValue('0' + field.getValue());
							}						
						}							
					}
			}},{
	    		margin: '0 0 0 10',
	    		xtype: 'button',
	    		text: '전체적용',
	    		handler: function(){
	    			RunAll();		    			
	    		}
		    }
        ]
		}]
    });	
	function RunAll() {
		var grid = Ext.getCmp('hat420ukrGrid1');
		var model = grid.getStore().getRange();
		var PLAN_H = Ext.getCmp('PLAN_H').value;
		var PLAN_M = Ext.getCmp('PLAN_M').value;
		
		if(PLAN_H == null || PLAN_H == ''){
			Ext.Msg.alert({
				title: '확인',
				buttons: Ext.Msg.OK,
				msg: '출근시를 입력하십시오.'
			});
		}else if(PLAN_M == null || PLAN_M == ''){
			Ext.Msg.alert({
				title: '확인',
				buttons: Ext.Msg.OK,
				msg: '출근분을 입력하십시오.'
			});
		}else{
			Ext.Msg.show({
			    title:'저장',
			    msg: '선택한 근무조를 조회된 모든 사원에게 적용시키겠습니까?',
			    buttons: Ext.Msg.YESNO,
			    icon: Ext.Msg.QUESTION,
			    fn: function(btn) {
			        if (btn === 'yes') {
			        	Ext.each(model, function(record,i){
			    			record.set('PLAN_H',PLAN_H);
			    			record.set('PLAN_M',PLAN_M);			    			
			    		});
			    		directMasterStore.saveStore();
//			        	grid.getStore().syncAll();
//			        	UniAppManager.app.onQueryButtonDown();
			        	
			        } else if (btn === 'no') {
			            this.close();
			        } 
			    }
			});
		}		
		
	}
	
	function SelectAll(){		
		var grid = Ext.getCmp('hat420ukrGrid1');
//		var button1 = Ext.getCmp('select');
//		var button2 = Ext.getCmp('deselect');
		var model = grid.getStore().getRange();	
		var isCheck = false;
		Ext.each(model, function(record,i){
			if(!Ext.isEmpty(record.get('PLAN_H')) && !Ext.isEmpty(record.get('PLAN_M'))){
				record.set('APPRO_TYPE',true);
				isCheck = true;
			}									    			
		});		
		if(isCheck){	//check 된게 1개라도 있을시..
			Ext.getCmp('selectBtn1').setText('취소');
			Ext.getCmp('selectBtn2').setText('취소');
			gsbtnYn = "N";
		}
		
//		button1.setVisible(false);
//		button2.setVisible(true);	
	}
	
	function DeSelectAll(){
		var grid = Ext.getCmp('hat420ukrGrid1');
//		var button1 = Ext.getCmp('select');
//		var button2 = Ext.getCmp('deselect');
		var model = grid.getStore().getRange();
		
		Ext.each(model, function(record,i){
			record.set('APPRO_TYPE',false);						    			
		});
		Ext.getCmp('selectBtn1').setText('전체선택');
		Ext.getCmp('selectBtn2').setText('전체선택');
		gsbtnYn = "Y";
//		button1.setVisible(true);
//		button2.setVisible(false);
	}
	
		
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('hat420ukrGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'south',
    	uniOpt: {
    		expandLastColumn: true
//		 	copiedRow: true
//		 	useContextMenu: true,
        }/*,
        tbar: [{
        	text:'상세보기',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }]*/,
		features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false 
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
		store: directMasterStore,
// 		selModel : Ext.create("Ext.selection.CheckboxModel", { checkOnly : false }),
		columns: [ 
			{ dataIndex:'APPRO_TYPE'   		,	width: 70, xtype : 'checkcolumn', id: 'checkCol',
				listeners:{
					beforecheckchange: function(col, rowIndex, checked, eOpts ){
						var record = masterGrid.getSelectedRecord();
						if(Ext.isEmpty(record.get('PLAN_H')) || Ext.isEmpty(record.get('PLAN_H'))){
							alert('출근시간을 입력해 주세요.');
							return false;
						}
					}
				}
			},
			{ dataIndex:'APPRO_TYPE2'  		,	width: 33, hidden: true, editable: false},
			{ dataIndex:'WORK_TEAM'    		,	width: 80, editable: false},
			{ dataIndex:'DUTY_YYYYMMDD'		,	width: 100, editable: false},
			{ dataIndex:'DIV_CODE'    		,	width: 160, editable: false},
			{ dataIndex:'DEPT_CODE'    		,	width: 100, hidden: true, editable: false},
			{ dataIndex:'DEPT_NAME'    		,	width: 180, editable: false},
			{ dataIndex:'POST_CODE'    		,	width: 80, editable: false},
			{ dataIndex:'NAME'         		,	width: 70, editable: false},
			{ dataIndex:'PERSON_NUMB'  		,	width: 70, editable: false},
			{ dataIndex:'PLAN_H'       		,	width: 70, editor:{maxLength:2}, align: 'center' 	},
			{ dataIndex:'PLAN_M'     		,	width: 70, editor:{maxLength:2}, align: 'center' },
			{ dataIndex:'DUTY_FR_H'   		,	width: 66, hidden: true},
			{ dataIndex:'DUTY_FR_M' 		,	width: 66, hidden: true},
			{ dataIndex:'DUTY_TO_D'    		,	width: 66, hidden: true},
			{ dataIndex:'DUTY_TO_H'   		,	width: 66, hidden: true},
			{ dataIndex:'DUTY_TO_M' 		,	width: 66, hidden: true},
			{ dataIndex:'FLAG'     	 		,	width: 66, hidden: true},
			{ dataIndex:'CLOSE_DATE'   		,	width: 66, hidden: true}
		],
		
		listeners:{		
//			beforeedit: function(editor, e){
//				var grdRecord = masterGrid.getSelectionModel().getSelection();			
//				var check = grdRecord[0].data.APPRO_TYPE;
//				if(check){
//					return false;
//				}
//			},			
//			beforeedit  : function( editor, e, eOpts ) {								
//				if(e.field == "APPRO_TYPE"){
//					if(Ext.isEmpty(e.record.get('PLAN_H')) || Ext.isEmpty(e.record.get('PLAN_M'))){
//						e.record.set('APPRO_TYPE', false);
//					}
//				}
//			},
			edit: function(editor, e){
				var grdRecord = masterGrid.getSelectionModel().getSelection();
//				var DUTY_FR_H = grdRecord[0].data.DUTY_FR_H;
//				var DUTY_FR_M = grdRecord[0].data.DUTY_FR_M;
//				var DUTY_TO_H = grdRecord[0].data.DUTY_TO_H;
//				var DUTY_TO_M = grdRecord[0].data.DUTY_TO_M;
				
				var strPlanD = grdRecord[0].data.DUTY_YYYYMMDD;
				var strPlanH = grdRecord[0].data.PLAN_H;
				var strPlanM = grdRecord[0].data.PLAN_M;
				var strDutyD = grdRecord[0].data.DUTY_TO_D;
				var strDutyH = grdRecord[0].data.DUTY_TO_H;
				var strDutyM = grdRecord[0].data.DUTY_TO_M;
				
				var fieldName = e.field;	
				var num_check = /[0-9]/;
				if (fieldName == 'PLAN_H' || fieldName == 'PLAN_M') {
						if (fieldName == "PLAN_H" && !num_check.test(e.value)) {
							if (parseInt(e.value) > 24 || parseInt(e.value) < 0) {
								Ext.Msg.alert('확인', '정확한 시를 입력하십시오.');
								e.record.set(fieldName, e.originalValue);
								return false;
							}
						} else if(fieldName == "PLAN_M" && !num_check.test(e.value)){
							if (parseInt(e.value) > 60 || parseInt(e.value) < 0) {
								Ext.Msg.alert('확인', '정확한 분을 입력하십시오.');
								e.record.set(fieldName, e.originalValue);
								return false;
							}
						}
						if(fieldName == "PLAN_H"){
							if(strPlanD == strDutyD){
								if(strPlanH > strDutyH){
									Ext.Msg.alert('확인', Msg.fsbMsgH0076);
									e.record.set(fieldName, e.originalValue);
									return false;
								}else if(strPlanH == strDutyH && !Ext.isEmpty(strPlanM)){
									if(((strPlanH * 60) + strPlanM) >= ((strDutyH * 60) + strDutyM)){
										Ext.Msg.alert('확인', Msg.fsbMsgH0076);
										e.record.set(fieldName, e.originalValue);
										return false;
									}
								}
							}
//							else if(strPlanD > strDutyD){
//								Ext.Msg.alert('확인', Msg.fsbMsgH0076);
//								e.record.set(fieldName, e.originalValue);
//								return false;
//							}							
						}else if(fieldName == "PLAN_M"){
							if(Ext.isEmpty(strPlanH)){
								Ext.Msg.alert('확인', Msg.fsbMsgH0077);
								e.record.set(fieldName, e.originalValue);
								return false;
							}
							if(strPlanD == strDutyD){
								if(((strPlanH * 60) + strPlanM) >= ((strDutyH * 60) + strDutyM)){
									Ext.Msg.alert('확인', Msg.fsbMsgH0076);
									e.record.set(fieldName, e.originalValue);
									return false;
								}
							}
						}
//						Ext.Msg.alert('확인', '숫자형식이 잘못되었습니다.');
//						e.record.set(fieldName, e.originalValue);
//						return false;
				}
				
				
//				console.log("editor",editor);
//				console.log("context",context);
				
// 				var FR = Number(DUTY_FR_H) * 60 + Number(DUTY_FR_M);
// 				var TO = Number(DUTY_TO_H) * 60 + Number(DUTY_TO_M);
				
//				var H = grdRecord[0].data.PLAN_H;
//				var M = grdRecord[0].data.PLAN_M;
// 				var HM = Number(H) * 60 + Number(M);
								
//				if(DUTY_FR_H > H || DUTY_TO_H < H){
//					Ext.Msg.alert({
//						title: '확인',
//						buttons: Ext.Msg.OK,
//						msg: '입력한 시간이 범위를 벗어났습니다.'
//					});					
//					grdRecord[0].set("PLAN_H","");
//				}
								
				
// 				if(M != null || M != ''){
// 					if(DUTY_FR_M > M){
// 						alert("입력한 분이 기준보다 작습니다.");
// 						grdRecord[0].set("PLAN_M","");
// 					}else if(DUTY_FR_M <= M){
// 						if(M > DUTY_TO_M){
// 							alert("입력한 분이 기준보다 큽니다.");
// 							grdRecord[0].set("PLAN_M","");
// 						}
// 					}
// 				} 			
				
			}
		}/*,
		beforeedit  : function( editor, e, eOpts ) {								
			if(e.field == "APPRO_TYPE"){
				if(Ext.isEmpty(e.record.get('PLAN_H')) || Ext.isEmpty(e.record.get('PLAN_H'))){
					return false;
				}				
			}			
		}*/
		
	});//End of var masterGrid = Unilite.createGrid('hat420ukrGrid1', {
	
	
    
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: {type: 'vbox', align: 'stretch'},
			border: false,
			items:[
				panelResult, detailForm, masterGrid
			]
		},
		panelSearch  	
		],
		id: 'hat420ukrApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset', false);
			UniAppManager.setToolbarButtons('newData', false);
			gsbtnYn = 'Y';
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DUTY_YYYYMMDD_FR');
		},
		onQueryButtonDown: function() {			
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
//			var viewLocked = masterGrid.lockedGrid.getView();
//			var viewNormal = masterGrid.normalGrid.getView();
//			console.log("viewLocked: ", viewLocked);
//			console.log("viewNormal: ", viewNormal);
//		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(false);
//		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
//		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(false);
//		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
		    UniAppManager.setToolbarButtons('deleteAll', true);
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onDeleteDataButtonDown: function(){
			var selRow = Ext.getCmp('hat420ukrGrid1').getSelectedRecord();
			if(selRow.phantom === true)	{
				Ext.getCmp('hat420ukrGrid1').deleteSelectedRow();
			}else {
				Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
					if (btn == 'yes') {
						Ext.getCmp('hat420ukrGrid1').deleteSelectedRow();						
					}
				});
			}		
			
		},
		onSaveDataButtonDown : function() {			
			directMasterStore.saveStore();
		},
		onDeleteAllButtonDown : function() {
			Ext.Msg.confirm('삭제', '전체 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
				if (btn == 'yes') {
					masterGrid.reset();			
					UniAppManager.app.onSaveDataButtonDown();
//					Ext.getCmp('hat420ukrGrid1').getStore().removeAll();
//					Ext.getCmp('hat420ukrGrid1').getStore().sync({
//						success: function(response) {
//							Ext.Msg.alert('확인', '삭제 되었습니다.');
//							UniAppManager.setToolbarButtons('delete', false);
//							UniAppManager.setToolbarButtons('deleteAll', false);
//							UniAppManager.setToolbarButtons('excel', false);
//				           },
//				           failure: function(response) {
//				           }
//			           });
					
				}
			});
		}
	});//End of Unilite.Main( {
};


</script>
