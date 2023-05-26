<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hpa700ukr_KOCIS"  >
	<t:ExtComboStore comboType="AU" comboCode="A043" /> <!-- 지급/공제구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H032" /> <!-- 지급구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 --> 
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!-- 근무조 --> 
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->	
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {     
	var excelWindow; //업로드 선언
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_hpa700ukrService_KOCIS.selectList2',
			update	: 's_hpa700ukrService_KOCIS.updateList',
			create	: 's_hpa700ukrService_KOCIS.insertList',
			destroy	: 's_hpa700ukrService_KOCIS.deleteList',
			syncAll	: 's_hpa700ukrService_KOCIS.saveAll'
		}
	});
	
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hpa700ukrModel1', {
	   fields: [			
			{name: 'SUB_CODE'			, text: '코드'			, type: 'string'	, allowBlank: false	},
			{name: 'CODE_NAME'			, text: '지급/공제항목'		, type: 'string'	, allowBlank: false	}			
	    ]
	});
	 
	Unilite.defineModel('Hpa700ukrModel2', {
	   fields: [
			{name: 'SUB_CODE'			, text: '코드'			, type: 'string'	},
			{name: 'CODE_NAME'			, text: '지급/공제항목'		, type: 'string'	},
			{name: 'PERSON_NUMB'		, text: '사번'			, type: 'string'	},
			{name: 'NAME'				, text: '성명'			, type: 'string'    , allowBlank: false	},
			{name: 'PAY_FR_YYYYMM'		, text: '시작월'			, type: 'string'	, allowBlank: false		/*, type: 'uniMonth'*/	},
			{name: 'PAY_TO_YYYYMM'		, text: '종료월'			, type: 'string'	, allowBlank: false		/*, type: 'uniMonth'*/	},
			{name: 'DED_AMOUNT_I'		, text: '금액'			, type: 'uniPrice'	, allowBlank: false	},
			{name: 'REMARK'				, text: '사유'			, type: 'string'	},
			{name: 'PROV_GUBUN'			, text: '지급/공제구분'		, type: 'string'	},
			{name: 'WAGES_CODE'			, text: '코드'			, type: 'string'	},
			{name: 'SUPP_TYPE'			, text: '지급구분'			, type: 'string'	}
	    ]	
	});			// End of Ext.define('Hpa700ukrModel', {

	// 엑셀참조
	Unilite.Excel.defineModel('excel.hpa700ukr.sheet01', {
		fields: [
	    	{name: '_EXCEL_JOBID' 		,text:'EXCEL_JOBID'		,type: 'string'},
			{name: 'SUB_CODE'			, text: '코드'			, type: 'string'	},
			{name: 'CODE_NAME'			, text: '지급/공제항목'		, type: 'string'	},
			{name: 'PERSON_NUMB'		, text: '사번'			, type: 'string'	, allowBlank: false	},
			{name: 'NAME'				, text: '성명'			, type: 'string'	, allowBlank: false	},
			{name: 'PAY_FR_YYYYMM'		, text: '시작월'			, type: 'string'	, allowBlank: false		/*, type: 'uniMonth'*/	},
			{name: 'PAY_TO_YYYYMM'		, text: '종료월'			, type: 'string'	, allowBlank: false		/*, type: 'uniMonth'*/	},
			{name: 'DED_AMOUNT_I'		, text: '금액'			, type: 'uniPrice'	, allowBlank: false	},
			{name: 'REMARK'				, text: '사유'			, type: 'string'	},
			{name: 'PROV_GUBUN'			, text: '지급/공제구분'		, type: 'string'	},
			{name: 'WAGES_CODE'			, text: '코드'			, type: 'string'	},
			{name: 'SUPP_TYPE'			, text: '지급구분'			, type: 'string'	}
		]
	});

	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('hpa700MasterStore1',{
		model: 'Hpa700ukrModel1',
		uniOpt: {
            isMaster	: false,			// 상위 버튼 연결 
            editable	: false,			// 수정 모드 사용 
            deletable	: false,			// 삭제 가능 여부 
	        useNavi		: false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 's_hpa700ukrService_KOCIS.selectList1'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			param.PROV_GUBUN = param.ALLOW_TYPE;								
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var masterStore2 = Unilite.createStore('hpa700MasterStore2',{
		model: 'Hpa700ukrModel2',
		uniOpt: {
            isMaster	: true,			// 상위 버튼 연결 
            editable	: true,			// 수정 모드 사용 
            deletable	: true,			// 삭제 가능 여부 
	        useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy2,
/*      proxy: {
			type: 'direct',
			api: {			
				read: 's_hpa700ukrService_KOCIS.selectList2',
				create : 's_hpa700ukrService_KOCIS.insert',
				update: 's_hpa700ukrService_KOCIS.update',
				destroy: 's_hpa700ukrService_KOCIS.delete',
				syncAll: 's_hpa700ukrService_KOCIS.syncAll'
			}
		},*/
        loadStoreRecords: function(SUB_CODE) {	        	
        	var detailform = panelSearch.getForm();
        	
        	if (detailform.isValid()) {
        		var param				= Ext.getCmp('searchForm').getValues();       		        
				
//				var param = {"PAY_TO_YYYYMM": param.PAY_TO_YYYYMM ,"PROV_GUBUN": param.ALLOW_TYPE ,"PERSON_NUMB": param.PERSON_NUMB , "SUB_CODE": SUB_CODE};								
				var payDate				= Ext.getCmp('PAY_YYYYMM').getValue();
				var mon					= payDate.getMonth() + 1;
				var dateString			= payDate.getFullYear() + '' + (mon > 9 ? mon : '0' + mon);

				param.PAY_TO_YYYYMM		= dateString;
				param.PROV_GUBUN		= param.ALLOW_TYPE;
				param.SUB_CODE			= SUB_CODE;

				console.log("param",param);
				this.load({
					params : param
				});
        	}else{
        		var invalid = panelSearch.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
				    	
				if(invalid.length > 0)	{
					r = false;
					var labelText = ''
					    	
					if(Ext.isDefined(invalid.items[0]['fieldLabel']))	{
						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
					}else if(Ext.isDefined(invalid.items[0].ownerCt))	{
						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
					}
					
					Ext.Msg.alert(Msg.sMB099, labelText+Msg.sMB083, function(){
						invalid.items[0].focus();
					});
				}
        	}        				
			
		},
		
		saveStore : function()	{				
			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
      	 	var toDelete = this.getRemovedRecords();
        	console.log("toUpdate",toUpdate);

        	var paramMaster	= panelSearch.getValues();
        	
        	if(inValidRecs.length == 0 )	{										
				config = {
					params: [paramMaster],
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);	
					} 
				};				
				this.syncAllDirect(config);
			}else {
				masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
/*        	if(inValidRecs.length == 0 )	{
 				this.syncAll();					
 			}else {
 				alert(Msg.sMB083);
 			}*/
 		},
 		
		listeners: {
			beforeload: function(store, operation, eOpts)	{
				if (masterGrid.getSelectedRecords() == 0)	{
					return false;
				}
			},
		
          	load: function(store, records, successful, eOpts) {
				//조회된 데이터가 있을 때, 합계 보이게 설정 변경
				var viewNormal = masterGrid2.getView();
				if(store.getCount() > 0){
		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);

		    		UniAppManager.setToolbarButtons('newData'	, true);
					UniAppManager.setToolbarButtons('delete'	, true);
					
				} else {
		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);

		    		UniAppManager.setToolbarButtons('newData'	, true);
					UniAppManager.setToolbarButtons('delete'	, false);

				}
          	}          		
      	}
	});
	
	/* 검색조건 (Search Panel)
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
				fieldLabel	: '기준년월',
				xtype		: 'uniMonthfield',
				name		: 'PAY_YYYYMM',                    
				id			: 'PAY_YYYYMM',
				allowBlank	: false,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_YYYYMM', newValue);
					}
				}
			},{
	        	xtype		: 'container',
				layout		: {type : 'hbox'},
				items		: [{
					xtype		: 'radiogroup',
					fieldLabel	: '기준',
					itemId		: 'RADIO',
					items		: [{
						boxLabel	: '기간내역',
						width		: 80, 
						name		: 'rdoSelect' ,
						id			: 'optList1',
						inputValue	: '1'
					},{
						boxLabel	: '인사정보의고정내역', 
						width		: 200, 
						name		: 'rdoSelect' ,
						id			: 'optList2',
						inputValue	: '2'					
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('rdoSelect').setValue(newValue.rdoSelect);

							if (newValue.rdoSelect == '2') {
								panelSearch.getField('SUPP_TYPE').setReadOnly(true);
								panelResult.getField('SUPP_TYPE').setReadOnly(true);
								masterGrid2.getColumn('REMARK').setText('비고');
								masterGrid2.getColumn('PAY_FR_YYYYMM').setVisible(false);
								masterGrid2.getColumn('PAY_TO_YYYYMM').setVisible(false);
								
							} else if (newValue.rdoSelect == '1') {
								panelSearch.getField('SUPP_TYPE').setReadOnly(false);
								panelResult.getField('SUPP_TYPE').setReadOnly(false);
								masterGrid2.getColumn('REMARK').setText('사유');
								masterGrid2.getColumn('PAY_FR_YYYYMM').setVisible(true);
								masterGrid2.getColumn('PAY_TO_YYYYMM').setVisible(true);
							}
							UniAppManager.app.onQueryButtonDown();
						}
					}
				}]
			},{
		        fieldLabel	: '지급구분',
		        name		: 'SUPP_TYPE', 	
		        xtype		: 'uniCombobox',
		        comboType	: 'AU',
		        comboCode	: 'H032',
		        allowBlank	: false,
			    listeners	: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('SUPP_TYPE', newValue);
					}
				}
		    },{
				fieldLabel	: '지급/공제구분',
				id			: 'ALLOW_TYPE',
				name		: 'ALLOW_TYPE', 
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'A043',
				allowBlank	: false,
			    listeners	: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('ALLOW_TYPE', newValue);
					}
				}
			}
			, {
                fieldLabel: '기관',
                name:'DIV_CODE', 
                xtype: 'uniCombobox',
                comboType:'BOR120',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('DIV_CODE', newValue);
                    }
                }
            }
			,
		      	Unilite.popup('Employee',{
		      	fieldLabel		: '직원',
			    valueFieldName	: 'PERSON_NUMB',
			    textFieldName	: 'NAME',
				id				: 'PERSON_NUMB',
			    valueFieldWidth	: 79,
			    autoPopup		: true,
				listeners		: {
	                'onValueFieldChange': function(field, newValue, oldValue  ){
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
	                },
	                'onTextFieldChange':  function( field, newValue, oldValue  ){
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));	
	                },
	                'onValuesChange':  function( field, records){
	                    	var tagfield = panelResult.getField('PERSON_NUMB') ;
	                    	tagfield.setStoreData(records)
	                },
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));	
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
					}
				}
      		})/*,{										//그리드 상단에 GroupSummary 로 사용 (민부장님 확인)
				xtype		: 'uniNumberfield',
				fieldLabel	: '합계',
          		name		: 'TOT_AMT', 	
				itemId		: 'TOT_AMT',
				width		: 245,
				readOnly	: true,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
		    			panelResult.setValue('TOT_AMT', newValue);
					}
				}
			}*//*,{
	        	xtype		: 'container',
				layout		: {type : 'hbox'},
				items		: [{
					xtype		: 'uniTextfield',
					fieldLabel	: '파일경로',
	          		name		: 'FILE_PATH', 	
					itemId		: 'FILE_PATH',
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {						
			    			panelResult.setValue('FILE_PATH', newValue);
						}
					}
				},{
		    		xtype		: 'button',
		    		text		: '찾아보기',
					itemId		: 'btnBatchApply',
					margin		: '0 0 2 5',
					width		: 63,
		    		handler		: function(records){}
				}]
			}*//*,{
	        	xtype		: 'container',
				layout		: {type : 'hbox'},
				items		: [{
					xtype	: 'button',
					text	: '빈파일저장',
					width	: 100,
					margin	: '0 0 2 70',
					handler	: function(btn) {}
				},{								//masterGrid2에 구현
					xtype	: 'button',
					text	: '파일 UpLoad',
					width	: 100,
					margin	: '0 0 2 100',
					handler	: function(btn) {
						openExcelWindow();
					}
				}]
			}*/,{
				xtype	: 'component',
				border	: false,
				name	: '',
				margin	: '0 0 2 10',
				html	: "<br>" +
					"<font size='2' color='blue'>&nbsp;※ 작성방법<br>" +
//					"<font size='1.7' color='blue'><br>" +
					"<font size='1.8' color='blue'>&nbsp;&nbsp;1. 먼저 [파일 UpLoad] 버튼을 눌러 파일을 받은 후, 작성합니다. <br>" +
					"<font size='1.8' color='blue'>&nbsp;&nbsp;2. 지급/공제구분을 선택합니다.<br>" +
					"<font size='1.8' color='blue'>&nbsp;&nbsp;3. 왼쪽 그리드의 업로드할 지급공제 항목에 포커스를 줍니다.<br>" +
					"<font size='1.8' color='blue'>&nbsp;&nbsp;4. [파일upload] 버튼을 눌러 데이터를 확인 후 저장합니다.<br></font>"            		 
			}]
		}]
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden	: !UserInfo.appOption.collapseLeftSearch,
    	region	: 'north',
		layout	: {type : 'uniTable', columns : 2
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding	: '1 1 1 1',
		border	: true,
		items	: [{
			fieldLabel	: '기준년월',
			xtype		: 'uniMonthfield',
			name		: 'PAY_YYYYMM',      
			allowBlank	: false,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_YYYYMM', newValue);
				}
			}
		},{
        	xtype		: 'container',
			layout		: {type : 'hbox'},
//			colspan		: 2,
			items		: [{
				xtype		: 'radiogroup',
				fieldLabel	: '기준',
				itemId		: 'RADIO',
				items		: [{
					boxLabel	: '기간내역',
					width		: 80, 
					name		: 'rdoSelect' ,
					id			: 'optList3',
					inputValue	: '1'
				},{
					boxLabel	: '인사정보의고정내역', 
					width		: 200, 
					name		: 'rdoSelect' ,
					id			: 'optList4',
					inputValue	: '2'					
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('rdoSelect').setValue(newValue.rdoSelect);
						
						if (newValue.rdoSelect == '2') {
							panelSearch.getField('SUPP_TYPE').setReadOnly(true);
							panelResult.getField('SUPP_TYPE').setReadOnly(true);
							masterGrid2.getColumn('REMARK').setText('비고');
							masterGrid2.getColumn('PAY_FR_YYYYMM').setVisible(false);
							masterGrid2.getColumn('PAY_TO_YYYYMM').setVisible(false);
							
						} else if (newValue.rdoSelect == '1') {
							panelSearch.getField('SUPP_TYPE').setReadOnly(false);
							panelResult.getField('SUPP_TYPE').setReadOnly(false);
							masterGrid2.getColumn('REMARK').setText('사유');
							masterGrid2.getColumn('PAY_FR_YYYYMM').setVisible(true);
							masterGrid2.getColumn('PAY_TO_YYYYMM').setVisible(true);
						}
						UniAppManager.app.onQueryButtonDown();
						
					}
				}
			}]
		}/*,{
			xtype	: 'button',
			text	: '빈파일저장',
			width	: 100,
			tdAttrs	: {align: 'right'},
			handler	: function(btn) {}
		}*/,{
	        fieldLabel	: '지급구분',
	        name		: 'SUPP_TYPE', 	
	        xtype		: 'uniCombobox',
	        comboType	: 'AU',
	        comboCode	: 'H032',
	        allowBlank	: false,
		    listeners	: {
				change: function(field, newValue, oldValue, eOpts) {      
					panelSearch.setValue('SUPP_TYPE', newValue);
				}
			}
	    },{
			fieldLabel	: '지급/공제구분',
			name		: 'ALLOW_TYPE', 
			xtype		: 'uniCombobox',
			comboType	: 'AU',
			comboCode	: 'A043',
//			colspan		: 2,
			allowBlank	: false,
		    listeners	: {
				change: function(field, newValue, oldValue, eOpts) {      
					panelSearch.setValue('ALLOW_TYPE', newValue);
				}
			}
		}/*,{								//masterGrid2에 구현
			xtype	: 'button',
			text	: '파일 UpLoad',
			width	: 100,
			tdAttrs	: {align: 'right'},
			handler	: function(btn) {
				openExcelWindow();
			}
		}*/
		, {
            fieldLabel: '기관',
            name:'DIV_CODE', 
            xtype: 'uniCombobox',
            comboType:'BOR120',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('DIV_CODE', newValue);
                }
            }
        }
		,
	      	Unilite.popup('Employee',{
	      	fieldLabel		: '직원',
		    valueFieldName	: 'PERSON_NUMB',
		    textFieldName	: 'NAME',
		    valueFieldWidth	: 79,
		    autoPopup		: true,
			listeners		: {
                'onValueFieldChange': function(field, newValue, oldValue  ){
						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
                },
                'onTextFieldChange':  function( field, newValue, oldValue  ){
						panelSearch.setValue('NAME', panelResult.getValue('NAME'));	
                },
                'onValuesChange':  function( field, records){
                    	var tagfield = panelSearch.getField('PERSON_NUMB') ;
                    	tagfield.setStoreData(records)
                },
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
						panelSearch.setValue('NAME', panelResult.getValue('NAME'));	
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('PERSON_NUMB', '');
					panelSearch.setValue('NAME', '');
				}
			}
  		})/*,{
        	xtype		: 'container',
			layout		: {type : 'hbox'},
			colspan		: 2, 
			items		: [{
				xtype		: 'uniTextfield',
				fieldLabel	: '파일경로',
          		name		: 'FILE_PATH', 	
				itemId		: 'FILE_PATH',
				width		: 400,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
		    			panelResult.setValue('FILE_PATH', newValue);
					}
				}
			},{
	    		xtype		: 'button',
	    		text		: '찾아보기',
				itemId		: 'btnBatchApply',
				margin		: '0 0 2 5',
				width		: 63,
	    		handler		: function(records){}
			}]
		}*//*,{										//그리드 상단에 GroupSummary 로 사용 (민부장님 확인)
			xtype		: 'uniNumberfield',
			fieldLabel	: '합계',
      		name		: 'TOT_AMT', 	
			itemId		: 'TOT_AMT',
			tdAttrs		: {align: 'right', width: '100%'},
			readOnly	: true,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
	    			panelSearch.setValue('TOT_AMT', newValue);
				}
			}
		}*//*,{
        	xtype		: 'component',
			tdAttrs	: {align: 'right', width: '100%'}
		}*/,{
			xtype	: 'component',
			border	: false,
			name	: '',
			margin	: '0 0 2 30',
			width	: 430,
			html	: "<br>" +
				"<font size='1.5px' color='blue'>&nbsp;※ 작성방법<br>" +
//					"<font size='1.7' color='blue'><br>" +
				"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. 먼저 [파일 UpLoad] 버튼을 눌러 파일을 받은 후, 작성합니다. <br>" +
//				"&nbsp;2. 지급/공제구분을 선택합니다.<br>" +
				"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. 왼쪽 그리드의 업로드할 지급공제 항목에 포커스를 줍니다.<br></font>" /*+
				"&nbsp;4. [파일upload] 버튼을 눌러 데이터를 확인 후 저장합니다.<br></font>" */           		 
		},{
			xtype	: 'component',
			border	: false,
			name	: '',
			margin	: '0 0 2 10',
			width	: 360,
			html	: "<br>" + "<br>" + 
				"<font size='1' color='blue'>&nbsp;&nbsp;&nbsp;2. 지급/공제구분을 선택합니다.<br>" +
				"&nbsp;&nbsp;&nbsp;4. [파일upload] 버튼을 눌러 데이터를 확인 후 저장합니다.<br></font>"            		 
		}]
	});
	
    /* Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hpa700Grid1', {
    	layout	: 'fit',
    	flex	: 1,
        region	: 'center',        
		store	: masterStore,
		selModel: 'rowmodel',  
		uniOpt	: {					
			useMultipleSorting	: true,		
		    useLiveSearch		: false,		
		    onLoadSelectFirst	: true,			
		    dblClickToEdit		: false,		
		    useGroupSummary		: false,		
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: false,		
			useRowContext		: false,	
		    filter: {				
				useFilter		: false,
				autoCreate		: false
			},		
			state:{
				useState		: false,
				useStateList	: false
			}
		},				
        columns: [        
        	{dataIndex: 'SUB_CODE'		, flex: 1},
			{dataIndex: 'CODE_NAME'		, flex: 3}				
		],
		listeners: {
			selectionchange:function( model1, selected, eOpts ){				    
       			if(selected.length > 0)	{
	        		var record = selected[0];
	        		masterStore2.loadData({})
					masterStore2.loadStoreRecords(record.data.SUB_CODE);
       			}
//				masterStore2.loadStoreRecords(record[0].data.SUB_CODE);			
			}
		}
    });  
    
    var masterGrid2 = Unilite.createGrid('hpa700Grid2', {
    	layout	: 'fit',
    	flex	: 3,
        region	: 'east',
		store	: masterStore2,
		selModel: 'rowmodel',  
		uniOpt	: {					
			useMultipleSorting	: true,		
		    useLiveSearch		: false,		
		    onLoadSelectFirst	: true,			
		    dblClickToEdit		: true,		
		    useGroupSummary		: true,		
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: false,		
			useRowContext		: false,
			copiedRow			: true,
		    filter: {				
				useFilter		: false,
				autoCreate		: false
			},	
			state:{
				useState		: false,
				useStateList	: false
			}
		},
        tbar: [{
        	text:'파일 UpLoad',
        	handler: function() {
        		openExcelWindow();
        	}
        }],
    	features: [ {
    		id : 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary',	
    		showSummaryRow: false ,
    		//컬럼헤더에서 그룹핑 사용 안 함
            enableGroupingMenu:false
    	},{
    		id : 'masterGridTotal',
//    		itemID:	'test',
    		ftype: 'uniSummary',
			dock : 'top',
    		showSummaryRow: true,
            enableGroupingMenu:true
    	}],
        columns: [
			{dataIndex: 'PERSON_NUMB'	, flex:1, hidden: true,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
            	},
				editor: Unilite.popup('Employee_G', {		
//					textFieldName: 'NAME',
					validateBlank : true,
					autoPopup:true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								UniAppManager.app.fnHumanPopUpAu02(records);	
								
								console.log('records : ', records);
								var grdRecord = masterGrid2.getSelectionModel().getSelection()[0];												
								grdRecord.set('NAME', records[0].NAME);
								grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);
								},
							scope: this
							},
						'onClear': function(type) {
							var grdRecord = masterGrid2.getSelectionModel().getSelection()[0];										
							grdRecord.set('NAME', '');
							grdRecord.set('PERSON_NUMB', '');
						}
					}
				}) 				
			},
			{dataIndex: 'NAME'			, flex:1,
				editor: Unilite.popup('Employee_G', {		
//					textFieldName: 'NAME',
					validateBlank : true,
					autoPopup:true,
					listeners: {
						'onSelected': {
							fn: function(records, type) {
								UniAppManager.app.fnHumanPopUpAu02(records);	

								console.log('records : ', records);
								var grdRecord = masterGrid2.getSelectionModel().getSelection()[0];												
								grdRecord.set('NAME', records[0].NAME);
								grdRecord.set('PERSON_NUMB', records[0].PERSON_NUMB);
							},
							scope: this
						},
						'onClear': function(type) {
							var grdRecord = masterGrid2.getSelectionModel().getSelection()[0];										
							grdRecord.set('NAME', '');
							grdRecord.set('PERSON_NUMB', '');
						}
					}
				}) 				
			},
			{dataIndex: 'PAY_FR_YYYYMM'	, flex:1	, align: 'center'/*,
				renderer: function(value, metaData, record) {
					return Ext.util.Format.date(value,'YYYY.MM');
				}*/
			}, 				
			{dataIndex: 'PAY_TO_YYYYMM'	, flex:1	, align: 'center'}, 				
			{dataIndex: 'DED_AMOUNT_I'	, flex:1	, summaryType: 'sum'}, 				
			{dataIndex: 'REMARK'		, flex:4},
			{dataIndex: 'PROV_GUBUN'	, flex:1	, hidden: true},
			{dataIndex: 'WAGES_CODE'	, flex:1	, hidden: true}
		],
		setExcelData: function(record) {       		
		   var me = this;
   			var grdRecord = this.getSelectionModel().getSelection()[0];				
			grdRecord.set('PERSON_NUMB'			, record['PERSON_NUMB']);
   			grdRecord.set('NAME'				, record['NAME']);
   			grdRecord.set('PAY_FR_YYYYMM'		, record['PAY_FR_YYYYMM']);
   			grdRecord.set('PAY_TO_YYYYMM'		, record['PAY_TO_YYYYMM']);
   			grdRecord.set('DED_AMOUNT_I'		, record['DED_AMOUNT_I']);
   			grdRecord.set('REMARK'				, record['REMARK']);			
		},
		listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
	        	if(e.record.phantom == true || UniUtils.indexOf(e.field, ['PAY_TO_YYYYMM', 'DED_AMOUNT_I', 'REMARK'])){ 
					return true;
  				} else {
  					return false;
  				}
			},
			
        	edit: function(editor, e) {
          		var fieldName = e.field;
				var num_check = /[0-9]/;
				var date_check01 = /^(19|20)\d{2}.(0[1-9]|1[012])$/;
				var date_check02 = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;
				
				switch (fieldName) {

				case 'PAY_FR_YYYYMM':
					if (!num_check.test(e.value)) {
						Ext.Msg.alert(Msg.sMB099, Msg.sMB074);
						e.record.set(fieldName, e.originalValue);
						return false;
					}
					break;
					
				case 'PAY_TO_YYYYMM':
					if (!num_check.test(e.value)) {
						Ext.Msg.alert(Msg.sMB099, Msg.sMB074);
						e.record.set(fieldName, e.originalValue);
						return false;
					}
					break;

				default:
					break;
				}
          	}
		}
    }); 
    
	Unilite.Main( {
		id 			: 'hpa700ukrApp',
		border		: false,
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				masterGrid, masterGrid2, panelResult
			]	
		},
			panelSearch
		], 
		
		fnInitBinding : function() {
			setDefalut();

			//초기화 시 합계 로우 숨김
			var viewNormal = masterGrid2.getView();;
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
		    
		    panelSearch.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            
            if(UserInfo.divCode == "01") {
                panelSearch.getField('DIV_CODE').setReadOnly(false);
                panelResult.getField('DIV_CODE').setReadOnly(false);
            }
            else {
                panelSearch.getField('DIV_CODE').setReadOnly(true);
                panelResult.getField('DIV_CODE').setReadOnly(true);
            }
			
		    //초기화 시 조회 실행
		    UniAppManager.app.onQueryButtonDown();
		    
//		    //초기화 시 사업장로 포커스 이동
//			var activeSForm ;
//			if(!UserInfo.appOption.collapseLeftSearch)	{
//				activeSForm = panelSearch;
//			}else {
//				activeSForm = panelResult;
//			}
//			activeSForm.onLoadSelectText('PAY_YYYYMM');
//
//			masterStore.loadStoreRecords();
		},
		
		onResetButtonDown: function() { 
			panelSearch.setValue('PERSON_NUMB', '');
			panelSearch.setValue('NAME', '');
			panelSearch.getField('SUPP_TYPE').setReadOnly(false);
			panelResult.getField('SUPP_TYPE').setReadOnly(false);
			
			masterGrid.reset();
			masterGrid2.reset();
			
			setDefalut();
			
			var viewNormal = masterGrid2.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
			
		    //reset 버튼 입력 시 기준년월로 포커스 이동
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('PAY_YYYYMM');

		},
		
		onQueryButtonDown : function()	{		
			if(!this.isValidSearchForm()){
				return false;
			}
			var viewNormal = masterGrid2.getView();
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);

			masterStore.loadStoreRecords();				
			UniAppManager.setToolbarButtons('reset'	, true);

		},
		
		onNewDataButtonDown : function(){
			var record = masterGrid.getSelectedRecord();
		    console.log("record",record);		

		    //그리드에 uniMonth속성이 아직 개발되지 않아서 string 처리
		    var payDate				= Ext.getCmp('PAY_YYYYMM').getValue();
			var mon					= payDate.getMonth() + 1;
			var dateString			= payDate.getFullYear() + '.' + (mon > 9 ? mon : '0' + mon);
		
			Ext.getCmp('hpa700Grid2').createRow({
				PERSON_NUMB		: panelSearch.getValue('PERSON_NUMB'), 
				NAME			: panelSearch.getValue('NAME'),
				PAY_FR_YYYYMM	: dateString, 
				PAY_TO_YYYYMM	: dateString, 
				PROV_GUBUN		: panelSearch.getValue('ALLOW_TYPE'),
				SUPP_TYPE		: panelSearch.getValue('SUPP_TYPE'),
				WAGES_CODE		: record.data.SUB_CODE
			});					
			
		},
		
		onDeleteDataButtonDown : function()	{
			var gridPanel = Ext.getCmp('hpa700Grid2');		
			var selRow = gridPanel.getSelectedRecord();
			if(selRow.phantom === true)	{
				gridPanel.deleteSelectedRow();
			}else {
				Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
					if (btn == 'yes') {
						gridPanel.deleteSelectedRow();						
					}
				});
			}
		},
		
		onSaveDataButtonDown : function() {		
			if(masterGrid2.getStore().isDirty()){
				masterStore2.saveStore();
			}
		},
		
        fnHumanPopUpAu02: function(records) {
			grdRecord = masterGrid.getSelectedRecord();
			record = records[0];
			grdRecord.set('PERSON_NUMB', record.PERSON_NUMB);
			grdRecord.set('NAME', record.NAME);			
		}
	});
	
	function openExcelWindow() {
	    var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUploadWin';
        
        var record = masterGrid.getSelectedRecord();
        
        if(!Ext.isEmpty(excelWindow)){
            excelWindow.extParam.PROV_GUBUN = panelSearch.getValue('ALLOW_TYPE');
            excelWindow.extParam.SUPP_TYPE  = panelSearch.getValue('SUPP_TYPE');
            excelWindow.extParam.WAGES_CODE = record.data.SUB_CODE;
        }
        
        if(!excelWindow) { 
        	excelWindow = Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
				modal: false,
            	excelConfigName: 'hpa700ukr',
        		extParam: { 
                    'PROV_GUBUN'    : panelSearch.getValue('ALLOW_TYPE'),
                    'SUPP_TYPE'     : panelSearch.getValue('SUPP_TYPE'),
                    'WAGES_CODE'    : record.data.SUB_CODE
        		},
                grids: [{							//팝업창에서 가져오는 그리드
                		itemId		: 'grid01',
                		title		: '공제내역기간등록',                        		
                		useCheckbox	: false,
                		model		: 'excel.hpa700ukr.sheet01',
                		readApi		: 's_hpa700ukrService_KOCIS.selectExcelUploadSheet1',
                		columns		: [	
                			{dataIndex: '_EXCEL_JOBID'	, width: 80,	hidden: true},
							{dataIndex: 'PERSON_NUMB'  	, width: 120}, 
							{dataIndex: 'NAME'			, width: 80},
							{dataIndex: 'PAY_FR_YYYYMM'	, width: 80},				
							{dataIndex: 'PAY_TO_YYYYMM'	, width: 80},				
							{dataIndex: 'DED_AMOUNT_I'	, width: 120},				
							{dataIndex: 'REMARK'		, width: 240}
                		]
                	}
                ],
                listeners: {
                    close: function() {
                        this.hide();
                    }
                },
                onApply:function()	{
                	excelWindow.getEl().mask('로딩중...','loading-indicator');
                	var me		= this;
                	var grid	= this.down('#grid01');
        			var records	= grid.getStore().getAt(0);	
        			if (!Ext.isEmpty(records)) {
			        	var param	= {
			        		"_EXCEL_JOBID" : records.get('_EXCEL_JOBID'),
			        		"PROV_GUBUN"   : records.get('PROV_GUBUN'),
			        		"SUPP_TYPE"    : records.get('SUPP_TYPE'),
			        		"WAGES_CODE"   : records.get('WAGES_CODE')
			        	};
			        	excelUploadFlag = "Y"
						s_hpa700ukrService_KOCIS.selectExcelUploadSheet1(param, function(provider, response){
					    	var store	= masterGrid2.getStore();
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
	};
		
	function setDefalut() {
		panelSearch.setValue('PAY_YYYYMM'	, UniDate.get('today'));
		panelResult.setValue('PAY_YYYYMM'	, UniDate.get('today'));
		panelSearch.setValue('SUPP_TYPE'	, '1');
		panelResult.setValue('SUPP_TYPE'	, '1');
		panelSearch.setValue('ALLOW_TYPE'	, '1');
		panelResult.setValue('ALLOW_TYPE'	, '1');
		panelSearch.setValue('rdoSelect'	, '1');
		panelResult.setValue('rdoSelect'	, '1');
		
		UniAppManager.setToolbarButtons('reset'		, false);
		UniAppManager.setToolbarButtons('save'		, false);
		UniAppManager.setToolbarButtons('newData'	, false);
	}
};
</script>
