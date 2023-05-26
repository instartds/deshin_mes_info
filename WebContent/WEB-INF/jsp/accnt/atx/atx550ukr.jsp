<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx550ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 				<!-- 사업장 -->   
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}	
</style>	
</t:appConfig>
<script type="text/javascript" >


function appMain() {
	var baseInfo = {
		gsBillDivCode   : '${gsBillDivCode}'
	}
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 'atx550ukrService.selectList',
			update	: 'atx550ukrService.updateList',
			create	: 'atx550ukrService.insertList',
			destroy	: 'atx550ukrService.deleteList',
			syncAll	: 'atx550ukrService.saveAll'
		}
	});

	
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('atx550ukrModel', {
		fields: [
			{name: 'ACCNT_CD'			, text: '항목코드' 			, type: 'string'  },
			{name: 'ACCNT_NAME'			, text: '항목명' 				, type: 'string'  },
			{name: 'AMT_1'				, text: '1월' 				, type: 'uniPrice'},
			{name: 'AMT_2'				, text: '2월' 				, type: 'uniPrice'},
			{name: 'AMT_3'				, text: '3월' 				, type: 'uniPrice'},
			{name: 'PRE_SUM1'			, text: '1기 예정' 			, type: 'uniPrice'},

			{name: 'AMT_4'				, text: '4월' 				, type: 'uniPrice'},
			{name: 'AMT_5'				, text: '5월' 				, type: 'uniPrice'},
			{name: 'AMT_6'				, text: '6월' 				, type: 'uniPrice'},
			{name: 'CON_SUM1'			, text: '1기 확정' 			, type: 'uniPrice'},
			{name: 'TOT_SUM1'			, text: '1기 합계' 			, type: 'uniPrice'},

			{name: 'AMT_7'				, text: '7월' 				, type: 'uniPrice'},
			{name: 'AMT_8'				, text: '8월' 				, type: 'uniPrice'},
			{name: 'AMT_9'				, text: '9월' 				, type: 'uniPrice'},
			{name: 'PRE_SUM2'			, text: '2기 예정' 			, type: 'uniPrice'},

			{name: 'AMT_10'				, text: '10월' 				, type: 'uniPrice'},
			{name: 'AMT_11'				, text: '11월' 				, type: 'uniPrice'},
			{name: 'AMT_12'				, text: '12월' 				, type: 'uniPrice'},
			{name: 'CON_SUM2'			, text: '2기 확정' 			, type: 'uniPrice'},
			{name: 'TOT_SUM2'			, text: '2기 합계' 			, type: 'uniPrice'},

			{name: 'DESC_REMARK'		, text: '내용' 				, type: 'string'  },
			
			{name: 'INSERT_DB_USER'		, text: 'INSERT_DB_USER' 	, type: 'string'  },
			{name: 'INSERT_DB_TIME'		, text: 'INSERT_DB_TIME' 	, type: 'uniDate' },
			{name: 'UPDATE_DB_USER'		, text: 'UPDATE_DB_USER' 	, type: 'string'  },
			{name: 'UPDATE_DB_TIME'		, text: 'UPDATE_DB_TIME' 	, type: 'uniDate' },
			{name: 'COMP_CODE'			, text: 'COMP_CODE' 		, type: 'string'  },
			{name: 'OPT_DIVI'			, text: 'OPT_DIVI' 			, type: 'string'  }
		]
	});
	
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('atx550ukrmasterStore',{
		model	: 'atx550ukrModel',
		proxy	: directProxy,
		autoLoad: false,
		uniOpt	: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,			// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore	: function(config)	{	
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
			var toUpdate = this.getUpdatedRecords();

			var rv = true;
			
			var paramMaster			= panelSearch.getValues();
			paramMaster.DESC_REMARK	= subForm.getValue('DESC_REMARK');
			
			if(inValidRecs.length == 0 )	{										
				config = {
					params	: [paramMaster],
					success	: function(batch, option) {								
						panelResult.resetDirtyStatus();
					 } 
				};					
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners	: {
		   	load: function(store, records, successful, eOpts) {
		   		//조회된 데이터가 있을 경우 DESC_REMARK를 subForm에 보여주고 수정 가능하도록 설정
		   		
                subForm.setValue('DESC_REMARK', '');
				if(store.getCount() > 0){
					subForm.setValue('DESC_REMARK', '');
		    		subForm.setValue('DESC_REMARK', records[0].data.DESC_REMARK);
			   		subForm.getField('DESC_REMARK').setConfig('disabled', false);
		    		
					Ext.each(records, function(record, index) {
						record.set('PRE_SUM1', record.get('AMT_1') + record.get('AMT_2') + record.get('AMT_3'));
						record.set('CON_SUM1', record.get('AMT_4') + record.get('AMT_5') + record.get('AMT_6'));
						record.set('TOT_SUM1', record.get('AMT_1') + record.get('AMT_2') + record.get('AMT_3') + record.get('AMT_4') + record.get('AMT_5') + record.get('AMT_6'));

						record.set('PRE_SUM2', record.get('AMT_7') + record.get('AMT_8') + record.get('AMT_9'));
						record.set('CON_SUM2', record.get('AMT_10') + record.get('AMT_11') + record.get('AMT_12'));
						record.set('TOT_SUM2', record.get('AMT_7') + record.get('AMT_8') + record.get('AMT_9') + record.get('AMT_10') + record.get('AMT_11') + record.get('AMT_12'));
					});
//					//ATX550T에 데이터가 없으면 조회 후, 저장버튼 바로 활성화
//				   	var param = {};	   	
//				   	atx550ukrService.checkData(param, function(provider, response) {
//				   		if (provider[0].COUNT == 0) {
//							Ext.each(records, function(record, index) {
//								record.phantom 	= true;
//							});
//							UniAppManager.setToolbarButtons('save', true);								
//				   		}
//				   	});
				}
				masterStore.commitChanges();   
				UniAppManager.setToolbarButtons('save', false);			
			}
		}//, load에서 해당 조건이 맞을 때, save 버튼 활성화 로직이 동작 안할 경우 아래 방식으로 save 버튼 활성화
		
/*		_onStoreLoad: function ( store, records, successful, eOpts ) {
			if(this.uniOpt.isMaster) {
				console.log("onStoreLoad");
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
		}*/
	});

	
	/* 검색조건 (Search Panel)
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
			title	: '기본정보', 	
   			itemId	: 'search_panel1',
		   	layout	: {type: 'uniTable', columns: 1},
		   	defaultType: 'uniTextfield',
			items	: [{
                fieldLabel	: '신고기간',
                name		: 'AC_YYYY',
                xtype		: 'uniYearField',
                value		: new Date().getFullYear(),
                allowBlank	: false,
                holdable	: 'hold',
                listeners:	 {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('AC_YYYY', newValue);
                    }
                }
            },{
				fieldLabel		: '신고사업장',
				name			: 'BILL_DIV_CODE',	
				xtype			: 'uniCombobox',
				comboType		: 'BOR120',
				comboCode		: 'BILL',
				holdable		: 'hold',
				allowBlank		: false,
				validateBlank	: false,
				listeners		: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BILL_DIV_CODE', newValue);
					},

					specialkey: function(field, event){
						if(event.getKey() == event.ENTER){
							UniAppManager.app.onQueryButtonDown();
						}
					}
				} 
			},{
				xtype		: 'radiogroup',		            		
				fieldLabel	: ' ',						            		
				id			: 'rdoSelect1',
				layout		: {columns: 2},
				items		: [{
					boxLabel: '1기 예정', 
					width	: 80, 
					name	: 'TERM_DIVI',
	    			inputValue: '1',
					checked: true  
				},{
					boxLabel: '1기 확정', 
					width	: 80, 
					name	: 'TERM_DIVI',
	    			inputValue: '2'
				},{
					boxLabel: '2기 예정', 
					width	: 80, 
					name	: 'TERM_DIVI',
	    			inputValue: '3'
				},{
					boxLabel: '2기 확정', 
					width	: 80, 
					name	: 'TERM_DIVI',
	    			inputValue: '4'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						//panelResult 동기화
						panelResult.getField('TERM_DIVI').setValue(newValue.TERM_DIVI);
						
						//그리드 setting
                    	fnChangeColumn(newValue.TERM_DIVI);
					}
				}
			}]
		}]
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {		
		hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 1, tableAttrs: {width: '100%'}
//		,tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			xtype	: 'container',
			layout	: 'hbox',
			style	: {'vertical-align':'middle'	,'line-height':'22px'},
			items	: [{
	            fieldLabel	: '신고기간',
	            name		: 'AC_YYYY',
	            xtype		: 'uniYearField',
	            value		: new Date().getFullYear(),
	            allowBlank	: false,
	            holdable	: 'hold',
	            listeners:	 {
	                change: function(field, newValue, oldValue, eOpts) {                        
	                    panelSearch.setValue('AC_YYYY', newValue);
	                }
	            }
	        },{
				xtype		: 'radiogroup',		            		
				fieldLabel	: ' ',						            		
				id			: 'rdoSelect2',
				labelWidth	: 30,
				items:		 [{
					boxLabel: '1기 예정', 
					width	: 80, 
					name	: 'TERM_DIVI',
	    			inputValue: '1',
					checked: true  
				},{
					boxLabel: '1기 확정', 
					width	: 80, 
					name	: 'TERM_DIVI',
	    			inputValue: '2'
				},{
					boxLabel: '2기 예정', 
					width	: 80, 
					name	: 'TERM_DIVI',
	    			inputValue: '3'
				},{
					boxLabel : '2기 확정', 
					width	: 80, 
					name	: 'TERM_DIVI',
	    			inputValue: '4'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						//panelResult 동기화
						panelSearch.getField('TERM_DIVI').setValue(newValue.TERM_DIVI);
						
						//그리드 setting
                    	fnChangeColumn(newValue.TERM_DIVI);
					}
				}
			}]
		},{
			fieldLabel		: '신고사업장',
			name			: 'BILL_DIV_CODE',	
			xtype			: 'uniCombobox',
			comboType		: 'BOR120',
			comboCode		: 'BILL',
			holdable		: 'hold',
			allowBlank		: false,
			validateBlank	: false,
			colspan			: 2,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('BILL_DIV_CODE', newValue);
				},

				specialkey: function(field, event){
					if(event.getKey() == event.ENTER){
						UniAppManager.app.onQueryButtonDown();
					}
				}
			} 
		}]
	});
	
	
	/* Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('atx550ukrGrid', {
		// for tab		
		store	: masterStore,
		layout	: 'fit',
		region	: 'center',
		uniOpt	: {
			useMultipleSorting	: true,
			useLiveSearch		: true,
			onLoadSelectFirst	: true,
			dblClickToEdit		: true,
			useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: true,
			useRowContext		: false,
			filter: {
				useFilter		: true,
				autoCreate		: true
			}
		},
		features: [ {id : 'masterGridSubTotal'	, ftype: 'uniGroupingsummary'	, showSummaryRow: false },
				   	{id : 'masterGridTotal'		, ftype: 'uniSummary'			, showSummaryRow: false} ],
		columns	: [
			{ dataIndex: 'ACCNT_CD'				, width: 140},
			{ dataIndex: 'ACCNT_NAME'			, width: 160		/*, 
				renderer:function(value){
					return '<div style="white-space: pre;">'+(value ? value:'&nbsp;')+"</div>"
				}*/
			},
			{ dataIndex: 'AMT_1'				, width: 200},
			{ dataIndex: 'AMT_2'				, width: 200},
			{ dataIndex: 'AMT_3'				, width: 200},
			{ dataIndex: 'PRE_SUM1'				, width: 200},
			
			{ dataIndex: 'AMT_4'				, width: 200},
			{ dataIndex: 'AMT_5'				, width: 200},
			{ dataIndex: 'AMT_6'				, width: 200},
			{ dataIndex: 'CON_SUM1'				, width: 200},
			{ dataIndex: 'TOT_SUM1'				, width: 200},
			
			{ dataIndex: 'AMT_7'				, width: 200},
			{ dataIndex: 'AMT_8'				, width: 200},
			{ dataIndex: 'AMT_9'				, width: 200},
			{ dataIndex: 'PRE_SUM2'				, width: 200},
			
			{ dataIndex: 'AMT_10'				, width: 200},
			{ dataIndex: 'AMT_11'				, width: 200},
			{ dataIndex: 'AMT_12'				, width: 200},
			{ dataIndex: 'CON_SUM2'				, width: 200},
			{ dataIndex: 'TOT_SUM2'				, width: 200},
			
			{ dataIndex: 'DESC_REMARK'			, width: 100		, hidden: true},
			{ dataIndex: 'INSERT_DB_USER'		, width: 100		, hidden: true},
			{ dataIndex: 'INSERT_DB_TIME'		, width: 100		, hidden: true},
			{ dataIndex: 'UPDATE_DB_USER'		, width: 100		, hidden: true},
			{ dataIndex: 'UPDATE_DB_TIME'		, width: 100		, hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				//집계구분이 '3:참조안함', 'A:계' 인 경우는 수정 안 됨
				if(e.record.get('OPT_DIVI') == '3' || e.record.get('OPT_DIVI') == 'A'){
					return false;
					
				} else {
					if(UniUtils.indexOf(e.field, ['ACCNT_CD', 'ACCNT_NAME', 'PRE_SUM1', 'CON_SUM1', 'TOT_SUM1', 'PRE_SUM2', 'CON_SUM2', 'TOT_SUM2'])) {
						return false;
						
	  				} else {
	  					return true;
	  				}
				}
			}
		}
	});   
	
	
	var subForm = Unilite.createSearchForm('remarkForm', {
		region		: 'south',
		title		: '내  용',
		defaultType	: 'uniSearchSubPanel',
		border		: true,
		padding		: '1 1 1 1',
		//접을 수 있도록 설정
		collapsible	: true,
		collapseDirection: 'bottom',
		items		: [{
			xtype	: 'uniTextfield',
			name	: 'DESC_REMARK',
			id		: 'descRemark',
			padding	: '5 5 5 5',
			hight	: '95%',
			minHeight :150,			
			width	: '99%',
			disabled: true,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(newValue != oldValue) {
						var record = masterGrid.getSelectedRecord();
						record.set('DESC_REMARK', newValue);
						UniAppManager.setToolbarButtons(['save']	, true);
					}
				}
			}
		}]
	});

	
	Unilite.Main( {
		id			: 'atx550ukrApp',
		borderItems	: [{
			border	: false,
			region	: 'center',
			layout	: 'border',
			items	: [
				masterGrid, panelResult, subForm
/*				{
					xtype	: 'container',
//					layout	: {type:'vbox', align:'stretch'},
					region	: 'south',
					minHeight: 220,
					items:[
						subForm
					]
				} */
			]	
		},
		panelSearch
		],
		
		fnInitBinding : function() {
			//Set panelSearch field value
			panelSearch.setValue('AC_YYYY'		, new Date().getFullYear());
			panelSearch.setValue('BILL_DIV_CODE', baseInfo.gsBillDivCode);
			panelSearch.getField('TERM_DIVI').setValue('1');

			//Set panelResult field value
			panelResult.setValue('AC_YYYY'		, new Date().getFullYear());
			panelResult.setValue('BILL_DIV_CODE', baseInfo.gsBillDivCode);
			panelResult.getField('TERM_DIVI').setValue('1');
			
	   		//Set subForm field
			subForm.getField('DESC_REMARK').setConfig('disabled', true);
	   		
			//Set masterGrid columns
           	fnChangeColumn('1');
			
			//Set Toolbar Button
			UniAppManager.setToolbarButtons(['reset','print']	, true);
			
			//초기화 시 포커스 설정
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('AC_YYYY');
		},
		
		onQueryButtonDown : function()	{
			//검색조건 필수 확인
			if(!this.isValidSearchForm()){
				return false;
			}
			masterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('reset'	, true);
		},
		
		onResetButtonDown: function() {
			this.suspendEvents();
			
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			masterStore.clearData();

			subForm.clearForm();
			this.fnInitBinding();
			UniAppManager.setToolbarButtons(['delete', 'deleteAll', 'save'], false); 
		},
		
		onDeleteDataButtonDown : function()	{										
			var selRow = masterGrid.getSelectedRecord();										
			if(selRow.phantom == true)	{									
				masterGrid.deleteSelectedRow();									
													
			} else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {					//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")					
					masterGrid.deleteSelectedRow();								
			}										
		},											
		
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			masterStore.saveStore();
		},
		onPrintButtonDown: function() {
	         //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
            var param = Ext.getCmp('searchForm').getValues();
	
            var win = Ext.create('widget.PDFPrintWindow', {
                url: CPATH+'/atx/atx550rkrPrint.do',
	            prgID: 'atx550rkr',
	            extParam: param 
	               	/*{
					  COMP_CODE    	: UserInfo.compCode,
					  TERM_DIVI		: param["TERM_DIVI"],
	                  AC_YYYY  		: param["AC_YYYY"],
	                  BILL_DIV_CODE : param["BILL_DIV_CODE"]
	               }*/
	               
            });
            win.center();
            win.show();
    	}
/*		행 추가 로직 없음
		onNewDataButtonDown: function()	{
			//범위 날짜에 첫날, 마지막 날 필요할 경우
			var startField2 = panelSearch.getField('FR_DATE');
			var startDateValue2 = startField2.getStartDate();
			var endField2 = panelSearch.getField('TO_DATE');
			var endDateValue2 = endField2.getEndDate();
		
			var compCode		=	UserInfo.compCode;   
			var billDivCode 	=	panelSearch.getValue('BILL_DIV_CODE');
			var frPubDate		= 	startDateValue2;
			var toPubDate		= 	endDateValue2;
			var seq = masterStore.max('SEQ');
			if(!seq) seq = 1;
			else seq += 1;
			
			var r = {
				COMP_CODE		:	compCode,	
				BILL_DIV_CODE	:	billDivCode, 
				FR_DATE			:	frPubDate,
				TO_DATE			:	toPubDate,
				SEQ				:	seq,
			};
			masterGrid.createRow(r);
		},*/
/*		삭제 로직 없음
		onDeleteDataButtonDown: function() {
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},*/
	});
	
	
	Unilite.createValidator('validator01', {
		store	: masterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "AMT_1" :
						record.set('PRE_SUM1', newValue + record.get('AMT_2') + record.get('AMT_3'));
						record.set('CON_SUM1', record.get('AMT_4') + record.get('AMT_5') + record.get('AMT_6'));
						record.set('TOT_SUM1', newValue + record.get('AMT_2') + record.get('AMT_3') + record.get('AMT_4') + record.get('AMT_5') + record.get('AMT_6'));
				break;
				case "AMT_2" :
						record.set('PRE_SUM1', record.get('AMT_1') + newValue + record.get('AMT_3'));
						record.set('CON_SUM1', record.get('AMT_4') + record.get('AMT_5') + record.get('AMT_6'));
						record.set('TOT_SUM1', record.get('AMT_1') + newValue + record.get('AMT_3') + record.get('AMT_4') + record.get('AMT_5') + record.get('AMT_6'));
				break;
				case "AMT_3" :
						record.set('PRE_SUM1', record.get('AMT_1') + record.get('AMT_2') + newValue);
						record.set('CON_SUM1', record.get('AMT_4') + record.get('AMT_5') + record.get('AMT_6'));
						record.set('TOT_SUM1', record.get('AMT_1') + record.get('AMT_2') + newValue + record.get('AMT_4') + record.get('AMT_5') + record.get('AMT_6'));
				break;

				case "AMT_4" :
						record.set('PRE_SUM1', record.get('AMT_1') + record.get('AMT_2') + record.get('AMT_3'));
						record.set('CON_SUM1', newValue + record.get('AMT_5') + record.get('AMT_6'));
						record.set('TOT_SUM1', record.get('AMT_1') + record.get('AMT_2') + record.get('AMT_3') + newValue + record.get('AMT_5') + record.get('AMT_6'));
				break;
				case "AMT_5" :
						record.set('PRE_SUM1', record.get('AMT_1') + record.get('AMT_2') + record.get('AMT_3'));
						record.set('CON_SUM1', record.get('AMT_4') + newValue + record.get('AMT_6'));
						record.set('TOT_SUM1', record.get('AMT_1') + record.get('AMT_2') + record.get('AMT_3') + record.get('AMT_4') + newValue + record.get('AMT_6'));
				break;
				case "AMT_6" :
						record.set('PRE_SUM1', record.get('AMT_1') + record.get('AMT_2') + record.get('AMT_3'));
						record.set('CON_SUM1', record.get('AMT_4') + record.get('AMT_5') + newValue);
						record.set('TOT_SUM1', record.get('AMT_1') + record.get('AMT_2') + record.get('AMT_3') + record.get('AMT_4') + record.get('AMT_5') + newValue);
				break;
				
				
				
				
				case "AMT_7" :
						record.set('PRE_SUM2', newValue + record.get('AMT_8') + record.get('AMT_9'));
						record.set('CON_SUM2', record.get('AMT_10') + record.get('AMT_11') + record.get('AMT_12'));
						record.set('TOT_SUM2', newValue + record.get('AMT_8') + record.get('AMT_9') + record.get('AMT_10') + record.get('AMT_11') + record.get('AMT_12'));
				break;
				case "AMT_8" :
						record.set('PRE_SUM2', record.get('AMT_7') + newValue + record.get('AMT_9'));
						record.set('CON_SUM2', record.get('AMT_10') + record.get('AMT_11') + record.get('AMT_12'));
						record.set('TOT_SUM2', record.get('AMT_7') + newValue + record.get('AMT_9') + record.get('AMT_10') + record.get('AMT_11') + record.get('AMT_12'));
				break;
				case "AMT_9" :
						record.set('PRE_SUM2', record.get('AMT_7') + record.get('AMT_8') + newValue);
						record.set('CON_SUM2', record.get('AMT_10') + record.get('AMT_11') + record.get('AMT_12'));
						record.set('TOT_SUM2', record.get('AMT_7') + record.get('AMT_8') + newValue + record.get('AMT_10') + record.get('AMT_11') + record.get('AMT_12'));
				break;

				case "AMT_10" :
						record.set('PRE_SUM2', record.get('AMT_7') + record.get('AMT_8') + record.get('AMT_9'));
						record.set('CON_SUM2', newValue + record.get('AMT_11') + record.get('AMT_12'));
						record.set('TOT_SUM2', record.get('AMT_7') + record.get('AMT_8') + record.get('AMT_9') + newValue + record.get('AMT_11') + record.get('AMT_12'));
				break;
				case "AMT_11" :
						record.set('PRE_SUM2', record.get('AMT_7') + record.get('AMT_8') + record.get('AMT_9'));
						record.set('CON_SUM2', record.get('AMT_10') + newValue + record.get('AMT_12'));
						record.set('TOT_SUM2', record.get('AMT_7') + record.get('AMT_8') + record.get('AMT_9') + record.get('AMT_10') + newValue + record.get('AMT_12'));
				break;
				case "AMT_12" :
						record.set('PRE_SUM2', record.get('AMT_7') + record.get('AMT_8') + record.get('AMT_9'));
						record.set('CON_SUM2', record.get('AMT_10') + record.get('AMT_11') + newValue);
						record.set('TOT_SUM2', record.get('AMT_7') + record.get('AMT_8') + record.get('AMT_9') + record.get('AMT_10') + record.get('AMT_11') + newValue);
				break;
					
			}
			return rv;
		}
	});

	//라디오 버튼에 따라서 보여지는 컬럼 변경
	function fnChangeColumn(value){
		if (value == '1') {
			var flag1 = false;
			var flag2 = true;
			var flag3 = true;
			var flag4 = true;
			var preFlag1 = false;
			var conFlag1 = true;
			var preFlag2 = true;
			var conFlag2 = true;

		} else if (value == '2') {
			var flag1 = true;
			var flag2 = false;
			var flag3 = true;
			var flag4 = true;
			var preFlag1 = false;
			var conFlag1 = false;
			var preFlag2 = true;
			var conFlag2 = true;
			
		} else if (value == '3') {
			var flag1 = true;
			var flag2 = true;
			var flag3 = false;
			var flag4 = true;
			var preFlag1 = true;
			var conFlag1 = true;
			var preFlag2 = false;
			var conFlag2 = true;
			
		} else if (value == '4') {
			var flag1 = true;
			var flag2 = true;
			var flag3 = true;
			var flag4 = false;
			var preFlag1 = true;
			var conFlag1 = true;
			var preFlag2 = false;
			var conFlag2 = false;
		}
		masterGrid.getColumn('AMT_1').setHidden(flag1);
		masterGrid.getColumn('AMT_2').setHidden(flag1);
		masterGrid.getColumn('AMT_3').setHidden(flag1);
		masterGrid.getColumn('PRE_SUM1').setHidden(preFlag1);
		
		masterGrid.getColumn('AMT_4').setHidden(flag2);
		masterGrid.getColumn('AMT_5').setHidden(flag2);
		masterGrid.getColumn('AMT_6').setHidden(flag2);
		masterGrid.getColumn('CON_SUM1').setHidden(conFlag1);
		masterGrid.getColumn('TOT_SUM1').setHidden(conFlag1);
		
		masterGrid.getColumn('AMT_7').setHidden(flag3);
		masterGrid.getColumn('AMT_8').setHidden(flag3);
		masterGrid.getColumn('AMT_9').setHidden(flag3);
		masterGrid.getColumn('PRE_SUM2').setHidden(preFlag2);
		
		masterGrid.getColumn('AMT_10').setHidden(flag4);
		masterGrid.getColumn('AMT_11').setHidden(flag4);
		masterGrid.getColumn('AMT_12').setHidden(flag4);
		masterGrid.getColumn('CON_SUM2').setHidden(conFlag2);
		masterGrid.getColumn('TOT_SUM2').setHidden(conFlag2);		
	}
};
</script>