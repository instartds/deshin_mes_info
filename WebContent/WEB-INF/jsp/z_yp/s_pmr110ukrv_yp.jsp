<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="s_pmr110ukrv_yp"  >
	<t:ExtComboStore comboType="BOR120"  /> 								<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="B052"/>						<!-- 검색항목 -->  
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" /><!--대분류-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" /><!--중분류-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" /><!--소분류-->

<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>
</t:appConfig>
<script type="text/javascript" >



function appMain() {
//초기화 시 Model, Grid 만들기
//	var fields			= createModelField();				//모델은 고정되어 사용 안 함
	var termFlag = '1'  //1: 기간    2:연도
	var columns			= createGridColumn();
	
//시작달과 끝날의 개월 차
	interval		= null;
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_pmr110ukrv_ypService.selectList',
			update	: 's_pmr110ukrv_ypService.updateList',
			create	: 's_pmr110ukrv_ypService.insertList',
			destroy	: 's_pmr110ukrv_ypService.deleteList',
			syncAll	: 's_pmr110ukrv_ypService.saveAll'
		}
	});
	
	
	
	
	
	/**	Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_pmr110ukrv_ypModel', {
//		fields : fields
		fields :[
		    {name: 'COMP_CODE'              , text: 'COMP_CODE'     , type: 'string'},
			{name: 'DIV_CODE'				, text: '사업장'			, type: 'string'},
			{name: 'ITEM_CODE'				, text: '품목코드'			, type: 'string'},
			{name: 'ITEM_NAME'				, text: '품목명'			, type: 'string'},
			{name: 'SPEC'					, text: '규격'			, type: 'string'},
			{name: 'STD_PRODT_RATE'			, text: '표준수율'			, type: 'uniPercent'		, editable:true},
			{name: 'AVG_PRODT_RATE'			, text: '평균수율'			, type: 'uniPercent'},
			{name: 'PRODT_RATE0'			, text: 'PRODT_RATE0'	, type: 'uniPercent'},
			{name: 'PRODT_RATE1'			, text: 'PRODT_RATE1'	, type: 'uniPercent'},
			{name: 'PRODT_RATE2'			, text: 'PRODT_RATE2'	, type: 'uniPercent'},
			{name: 'PRODT_RATE3'			, text: 'PRODT_RATE3'	, type: 'uniPercent'},
			{name: 'PRODT_RATE4'			, text: 'PRODT_RATE4'	, type: 'uniPercent'},
			{name: 'PRODT_RATE5'			, text: 'PRODT_RATE5'	, type: 'uniPercent'},
			{name: 'PRODT_RATE6'			, text: 'PRODT_RATE6'	, type: 'uniPercent'},
			{name: 'PRODT_RATE7'			, text: 'PRODT_RATE7'	, type: 'uniPercent'},
			{name: 'PRODT_RATE8'			, text: 'PRODT_RATE8'	, type: 'uniPercent'},
			{name: 'PRODT_RATE9'			, text: 'PRODT_RATE9'	, type: 'uniPercent'},
			{name: 'PRODT_RATE10'			, text: 'PRODT_RATE10'	, type: 'uniPercent'},
			{name: 'PRODT_RATE11'			, text: 'PRODT_RATE11'	, type: 'uniPercent'},
			{name: 'PRODT_RATE12'			, text: 'PRODT_RATE12'	, type: 'uniPercent'}

		]
	});

	
	
	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('s_pmr110ukrv_ypmasterStore',{
		model	: 's_pmr110ukrv_ypModel',
		proxy	: directProxy,
		uniOpt	: {
				isMaster	: true,			// 상위 버튼 연결 
				editable	: true,			// 수정 모드 사용 
				deletable	: false,		// 삭제 가능 여부 
				useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		loadStoreRecords : function()	{
			var param= Ext.getCmp('ResultForm').getValues();			

//			var startDate	= panelResult.getValue('FR_MONTH')
//			var endDate		= panelResult.getValue('TO_MONTH')
//			
//			var budgetYymmFr	= UniDate.getDbDateStr(startDate);
//			var budgetYymmTo	= UniDate.getDbDateStr(endDate);
//			param.gsFrDate		= budgetYymmFr.substring(0,4) + '/' + budgetYymmFr.substring(4,6) + '/' + '01';
//			param.gsToDate		= budgetYymmTo.substring(0,4) + '/' + budgetYymmTo.substring(4,6) + '/' + '01';
//			
//			var yearDiff	= endDate.getYear()	- startDate.getYear();
//			var monthDiff	= endDate.getMonth()- startDate.getMonth();
//				
//			interval		= yearDiff*12 + monthDiff;
			var monthRange	= [];
			for (i=0; i <= interval; i++){
				monthRange.push('PRODT_RATE' + i);
			}
			param.monthRange		= monthRange;
			param.TERM_FLAG = termFlag;
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs	= this.getInvalidRecords();
			var toCreate	= this.getNewRecords();
			var toUpdate	= this.getUpdatedRecords();				
			var toDelete	= this.getRemovedRecords();
					 	
			//1. 마스터 정보 파라미터 구성
			var paramMaster			= panelResult.getValues();	//syncAll 수정

			if(inValidRecs.length == 0 )	{
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {
//						var master = batch.operations[0].getResultSet();
//						panelResult.setValue("ESTI_NUM", master.ESTI_NUM);
//						
//						if(masterStore.isDirty()){
//							masterStore.saveStore();
//							
//						} else {
//							panelResult.getForm().wasDirty = false;
//							panelResult.resetDirtyStatus();
//							console.log("set was dirty to false");
//							UniAppManager.setToolbarButtons('save', false);
//						}
					}
				};
				this.syncAllDirect(config);
			} else {
				 masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
			},
			add		: function(store, records, index, eOpts) {
			},
			update:function( store, record, operation, modifiedFieldNames, eOpts )	{
//				panelResult.setActiveRecord(record);
			},
			remove	: function(store, record, index, isMove, eOpts) {
			}
		}/*,
		groupField: 'CUSTOM_NAME'*/
	}); 
	

	
	
	
	/** Master Grid 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('s_pmr110ukrv_ypMasterGrid', {	 // 메인
		store	: masterStore,
		region	: 'center',
		layout	: 'fit',
		uniOpt	: {
			onLoadSelectFirst	: true,
			expandLastColumn	: false,
			useRowNumberer		: true,		
			dblClickToEdit		: true,
			useMultipleSorting	: true
		},
//		columns	: columns,
		columns	: [
			{dataIndex: 'ITEM_CODE'					, text: '품목코드',			width: 100},
			{dataIndex: 'ITEM_NAME'					, text: '품목명',			width: 150},
			{dataIndex: 'SEPC'						, text: '규격',			width: 150},
			{dataIndex: 'STD_PRODT_RATE'			, text: '표준수율',			width: 100},
			{dataIndex: 'AVG_PRODT_RATE'			, text: '평균수율',			width: 100}
		],
		
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field, ['STD_PRODT_RATE'])) {
					return true;
				} else {
					return false;
				}
			},
			selectionchangerecord:function(selected)	{
			}
		}	 
	});
	
	
	
	
	
	var panelResult = Unilite.createSearchForm('ResultForm', {
		region		: 'north',
		layout		: {type : 'uniTable', columns : 3/*, tableAttrs: {width: '100%'},
		tdAttrs		: {style: 'border : 1px solid #ced9e7;'}*/
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{ 
			fieldLabel	: '사업장',
			name		: 'DIV_CODE',
			xtype		: 'uniCombobox',
			comboType	: 'BOR120',
			value		: UserInfo.divCode,
			allowBlank	: false,
			tdAttrs		: {width: 350}
		},
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '품목코드',
			textFieldName	: 'ITEM_NAME',
			valueFieldName	: 'ITEM_CODE',
			holdable		: 'hold',
			//validateBlank	: false,
			autoPopup : true,
			listeners		: {
				onSelected: {
					fn: function(records, type) {
						console.log('records : ', records);
					},
					scope: this
				},
				onClear: function(type)	{
					panelResult.setValue('ITEM_CODE', '');
					panelResult.setValue('ITEM_NAME', '');
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		}),
		{
			fieldLabel	: '검색항목', 
			name		: 'FIND_TYPE', 
			xtype		: 'uniCombobox', 
			comboType	: 'AU', 
			comboCode	: 'B052',
			listeners	: {
				change: function(combo, newValue, oldValue, eOpts) {
				}
			}
		},{
			fieldLabel	: '계정',
			name		: 'ITEM_ACCOUNT', 
			xtype		: 'uniCombobox', 
			comboType	: 'AU', 
			comboCode	: 'B020',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		},{
			xtype	: 'container',
			layout	: {type:'uniTable', column:3},
			items	: [{
				fieldLabel	: '품목분류',
				xtype		: 'uniCombobox',
				name		: 'ITEM_LEVEL1',
				store		: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child		: 'ITEM_LEVEL2',
				width		: 200
			},{
				xtype	: 'uniCombobox',
				name	: 'ITEM_LEVEL2',
				store	: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child	: 'ITEM_LEVEL3',
				width		: 100
			},{
				xtype	: 'uniCombobox',
				name	: 'ITEM_LEVEL3',
				store	: Ext.data.StoreManager.lookup('itemLeve3Store'),
				width		: 100
			}]
		},{
			fieldLabel	: '검색어',
			name		: 'FIND_KEY_WORD',
			xtype		: 'uniTextfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
				}
			}
		}, {
            fieldLabel: '조회기간',                                     
            xtype: 'uniDateRangefield',
            startFieldName: 'FR_DATE',
            endFieldName: 'TO_DATE',
            id: 'dateRange',        
            margin: '6 0 2 0',
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                
            }
        },{
			xtype: 'container',
			layout: {type: 'uniTable', columns: 2},
			id: 'yearRange',
			hidden: true,
			items:[{
                fieldLabel  : '조회기간',
                xtype:'uniMonthfield',
                name:'FR_MONTH',
                width: 195
            },{
                fieldLabel:'~',
                labelWidth: 4,
                xtype:'uniMonthfield',
                name:'TO_MONTH',
                width: 119,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {           
                    	if (!Ext.isEmpty(newValue) && UniDate.getDbDateStr(newValue).replace('.','').length == 8){
                    	   panelResult.setValue('FR_MONTH', UniDate.get('twelveMonthsAgo', newValue));         
                    	   changeGrid();
                    	}
                    }
                }
            }]
		}/*,{
			fieldLabel	: '조회기간',
			xtype		: 'uniMonthRangefield',
			startFieldName: 'FR_MONTH',
			endFieldName: 'TO_MONTH',
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
				if (!Ext.isEmpty(newValue) && UniDate.getDbDateStr(newValue).replace('.','').length == 8){
					//조회 기간 최대 12개월로 제한
					var startDate	= newValue;
					var endDate		= panelResult.getValue('TO_MONTH');
					
					if (endDate) {
						var yearDiff	= endDate.getYear()	- startDate.getYear();
						var monthDiff	= endDate.getMonth()- startDate.getMonth();
						 
						var diffMonths	= yearDiff*12 + monthDiff;
	
						if (diffMonths > 12) {
							alert('조회기간은 최대 12개월 입니다.');
							panelResult.setValue('FR_MONTH', '');
							return false;
						}
						
						//시작월이 끝월보다 크지 않을 때만 적용
						if(endDate >= newValue) {
							changeGrid();
							
						} else {
							alert('조회시작월이 조회끝월보다 클 수 없습니다.');
							panelResult.setValue('FR_MONTH', '');
							return false;
						}
					}
				}
			},
			onEndDateChange: function(field, newValue, oldValue, eOpts) {
				if (!Ext.isEmpty(newValue) && UniDate.getDbDateStr(newValue).replace('.','').length == 8){
					//조회 기간 최대 12개월로 제한
					var startDate	= panelResult.getValue('FR_MONTH');
					
					if (startDate) {
						var endDate		= newValue;
						var yearDiff	= endDate.getYear()	- startDate.getYear();
						var monthDiff	= endDate.getMonth()- startDate.getMonth();
						 
						var diffMonths	= yearDiff*12 + monthDiff;
	
						if (diffMonths > 12) {
							alert('조회기간은 최대 12개월 입니다.');
							panelResult.setValue('TO_MONTH', '');
							return false;
						}
						
						//시작월이 끝월보다 크지 않을 때만 적용
						if(panelResult.getValue('FR_MONTH') <= newValue) {
							changeGrid();
							
						} else {
							alert('조회시작월이 조회끝월보다 클 수 없습니다.');
							panelResult.setValue('TO_MONTH', '');
							return false;
						}
					}
				}
			}
		}*/,{
            xtype: 'radiogroup',                            
            fieldLabel: '구분',
            items: [{
               boxLabel: '기간',
               width: 80,
               name: 'TERM_TYPE',
               inputValue: '1',
               checked: true
            }, {
               boxLabel: '연간',
               width: 80,
               name: 'TERM_TYPE',
               inputValue: '2'
            }],
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {         
                	if(newValue.TERM_TYPE == '1'){   //기간별일시
                	   Ext.getCmp('yearRange').hide();
                	   Ext.getCmp('dateRange').show();
                	   termFlag = '1';
                	   changeGrid();
                	   masterStore.loadStoreRecords();
                	}else{
                	   Ext.getCmp('yearRange').show();
                       Ext.getCmp('dateRange').hide();
                       termFlag = '2';
                       changeGrid();
                       masterStore.loadStoreRecords();
                	}
                }
            }
        },{                        
           width: 100,
           xtype: 'button',
           text: '평균수율 적용',
           margin: '0 0 0 95',
           handler : function() {
           	    //전체 로우의 표준수율에 평균수율 set해주기..단, 평균수율이 0 이상인 행만..
           	    var records = masterStore.data.items;
           	    if(records.length == 0) return false;
           	    if(confirm('평균수율을 적용하시겠습니까?')){
           	        Ext.each(records, function(rec, i){
                        if(rec.get('AVG_PRODT_RATE') == 0) return false;
                        rec.set('STD_PRODT_RATE', rec.get('AVG_PRODT_RATE'));
                    });
           	    }                
           }
        }]
	});
	
	
	
	
	
	
	/**
	 * main app
	 */
	Unilite.Main( {
		id			: 's_pmr110ukrv_ypApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				panelResult, masterGrid 
			]
		}],
		
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons('save', false);
			UniAppManager.setToolbarButtons('reset', true);

			panelResult.onLoadSelectText('FR_MONTH');
			panelResult.getField('FR_MONTH').setReadOnly(true);
			this.setDefault();
			termFlag = '1'
		},
		
		onQueryButtonDown : function()	{		
			if(!this.isValidSearchForm()){
				return false;
			}
			
			masterGrid.getStore().loadStoreRecords();
		},
		
			
		onResetButtonDown: function() {
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			masterStore.clearData();
			this.fnInitBinding();
		},
		
		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom == true)	{
				masterGrid.deleteSelectedRow();

			} else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {					//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
					masterGrid.deleteSelectedRow();
			}
		},

		onSaveDataButtonDown: function (config) {
			masterStore.saveStore();
		},
		
		setDefault: function() {
			panelResult.setValue('DIV_CODE', UserInfo.divCode);					//사업장
			panelResult.setValue('FR_MONTH', UniDate.get('twelveMonthsAgo'));	//조회기간FR
			panelResult.setValue('TO_MONTH', UniDate.get('endOfMonth'));		//조회기간TO
			panelResult.setValue('FR_DATE', UniDate.get('sixDayAgo'));    //조회기간FR
            panelResult.setValue('TO_DATE', UniDate.get('today'));        //조회기간TO			
			changeGrid();
		}
	});
	
	
	
	
	
//	Unilite.createValidator('validator03', {
//		store	: masterStore,
//		grid	: masterGrid,
////		forms: {'formA:':detailForm},
//		validate: function( type, fieldName, newValue, oldValue, record, eopt) {			
//			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
//			var rv = true;
//			
//			switch(fieldName) {
//				case "SUPPLY_AMT_I" :	//공급가액/세액
//					UniAppManager.app.fnSetTaxAmt();
//				break;	
//			}
//			return rv;
//		} // validator
//	});
	
	
	
	
	
	
	// 모델 필드 생성
/*	function createModelField() {
		//모델 생성을 위한 개월 수 구하기
		if (panelResult) {
			var startDate	= panelResult.getValue('FR_MONTH')
			var endDate		= panelResult.getValue('TO_MONTH')
			var endYear		= UniDate.getDbDateStr(panelResult.getValue('TO_MONTH')).substring(0,4);
			var endMonth	= parseInt(UniDate.getDbDateStr(panelResult.getValue('TO_MONTH')).substring(4,6));
		} else {
			var beforeConvertFr = UniDate.getDbDateStr(UniDate.get('twelveMonthsAgo')).substring(0,4) + '/' + UniDate.getDbDateStr(UniDate.get('twelveMonthsAgo')).substring(4,6) + '/' + UniDate.getDbDateStr(UniDate.get('twelveMonthsAgo')).substring(6,8);
			var beforeConvertTO = UniDate.getDbDateStr(UniDate.get('endOfMonth')).substring(0,4) + '/' + UniDate.getDbDateStr(UniDate.get('endOfMonth')).substring(4,6) + '/' + UniDate.getDbDateStr(UniDate.get('endOfMonth')).substring(6,8);
			var startDate	= new Date(beforeConvertFr);
			var endDate		= new Date(beforeConvertTO);
			var endYear		= UniDate.getDbDateStr(UniDate.get('endOfMonth')).substring(0,4);
			var endMonth	= parseInt(UniDate.getDbDateStr(UniDate.get('endOfMonth')).substring(4,6));
		}
		
		var yearDiff	= endDate.getYear()	- startDate.getYear();
		var monthDiff	= endDate.getMonth()- startDate.getMonth();
		 
		interval		= yearDiff*12 + monthDiff;
		
		//필드 생성
		var fields = [
			{name: 'DIV_CODE'				, text: '사업장'			, type: 'string'},
			{name: 'ITEM_CODE'				, text: '품목코드'			, type: 'string'},
			{name: 'ITEM_NAME'				, text: '품목명'			, type: 'string'},
			{name: 'SPEC'					, text: '규격'			, type: 'string'},
			{name: 'STD_PRODT_RATE'			, text: '표준수율'			, type: 'uniPercent'		, editable:true},
			{name: 'AVG_PRODT_RATE'			, text: '평균수율'			, type: 'uniPercent'}
		];
		for (var i = 0; i <= interval; i++){
			var endYear	= endMonth - i > 0 ? endYear 		: endYear - 1;
			var month	= endMonth - i > 0 ? endMonth - i	: endMonth - i + 12;
			fields.push(
				{name: 'PRODT_RATE' + i	, text: endYear + '년 ' + month + '월',		type:'uniPercent'}
			);
		}
		console.log(fields);
		return fields;
	}*/
	
	
	// 그리드 컬럼 생성
	function createGridColumn() {
		//그리드 생성을 위한 개월 수 구하기
		if (panelResult) {
			var startDate	= panelResult.getValue('FR_MONTH')
			var endDate		= panelResult.getValue('TO_MONTH')
			var endYear		= UniDate.getDbDateStr(panelResult.getValue('TO_MONTH')).substring(0,4);
			var endMonth	= parseInt(UniDate.getDbDateStr(panelResult.getValue('TO_MONTH')).substring(4,6));
		} else {
			var beforeConvertFr = UniDate.getDbDateStr(UniDate.get('twelveMonthsAgo')).substring(0,4) + '/' + UniDate.getDbDateStr(UniDate.get('twelveMonthsAgo')).substring(4,6) + '/' + UniDate.getDbDateStr(UniDate.get('twelveMonthsAgo')).substring(6,8);
			var beforeConvertTO = UniDate.getDbDateStr(UniDate.get('endOfMonth')).substring(0,4) + '/' + UniDate.getDbDateStr(UniDate.get('endOfMonth')).substring(4,6) + '/' + UniDate.getDbDateStr(UniDate.get('endOfMonth')).substring(6,8);
			var startDate	= new Date(beforeConvertFr);
			var endDate		= new Date(beforeConvertTO);
			var endYear		= UniDate.getDbDateStr(UniDate.get('endOfMonth')).substring(0,4);
			var endMonth	= parseInt(UniDate.getDbDateStr(UniDate.get('endOfMonth')).substring(4,6));
		}
			
		var yearDiff	= endDate.getYear()	- startDate.getYear();
		var monthDiff	= endDate.getMonth()- startDate.getMonth();
		 
		interval		= yearDiff*12 + monthDiff;
		
		//필드 생성
		var columns = [
			{xtype: 'rownumberer',	sortable:false,	width: 35,	align:'center  !important',	resizable: true},
			{dataIndex: 'ITEM_CODE'					, text: '품목코드',			width: 100,		style: 'text-align: center'			/*, type: 'string'*/},
			{dataIndex: 'ITEM_NAME'					, text: '품목명',			width: 150,		style: 'text-align: center'			/*, type: 'string'		, align: 'center'*/},
			{dataIndex: 'SEPC'						, text: '규격',			width: 150,		style: 'text-align: center'			/*, type: 'string'*/},
			{dataIndex: 'STD_PRODT_RATE'			, text: '표준수율',			width: 100,		style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Percent
						, editor: {/*xtype : 'uniNumberfield' , decimalPrecision: 2 , maxLength:2	, */editble : true}},
			{dataIndex: 'AVG_PRODT_RATE'			, text: '평균수율',			width: 100,		style: 'text-align: center'		, align: 'right'	, xtype:'uniNnumberColumn'	, format: UniFormat.Percent}
		];
		if(termFlag == "2"){
		   for (var i = 0; i <= interval; i++){
                var year    = endMonth - i > 0 ? endYear        : endYear - 1;
                var month   = endMonth - i > 0 ? endMonth - i   : endMonth - i + 12;
                columns.push(
                    {dataIndex: 'PRODT_RATE' + i    , text: year + '년 ' + month + '월',      width: 100  , style: 'text-align: center'   , align: 'right'    , xtype:'uniNnumberColumn'  , format: UniFormat.Percent}
                );
            }
		
		}		
		console.log(columns);
		return columns;
	}
	
	
	
	
	//조건에 맞는 컬럼 생성	
	function changeGrid() {
		var newColumns	= createGridColumn(); 		
		masterGrid.setConfig('columns', newColumns);		// check1
//		masterGrid.setColumnInfo(masterGrid, columns1, fields);
//		masterGrid.reconfigure(masterStore, columns1);  
	}
};

</script>
