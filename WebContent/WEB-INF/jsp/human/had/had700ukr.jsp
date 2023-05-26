<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="had700ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="H039" /> 
	<t:ExtComboStore comboType="BOR120"  /> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var isSubmitBtnClick = false;
	var isCancelBtnClick = false;
	var excelWindow;
	
	Ext.create( 'Ext.data.Store', {
          storeId: "InsurStore",
          fields: [ 'text', 'value'],
          data : [
              {text: "국민연금",   value:"1" },
              {text: "건강보험",   value:"2" },
              {text:'고용보험'	, 	 value:"3" }
          ]
      });
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('had700ukrModel', {
		fields: [
            {name: 'PERSON_NUMB'        , text: '사번'            , type: 'string', allowBlank:false},
            {name: 'NAME'                , text: '성명'            , type: 'string'},
            {name: 'DEPT_CODE'        	, text: '부서'            , type: 'string', editable:false},
            {name: 'DEPT_NAME'           , text: '부서명'            , type: 'string', editable:false},
            {name: 'DIV_CODE'           , text: '사업장'            , type: 'string',comboType:'BOR120', editable:false},
            {name: 'PAY_YYYYMM'            , text: '귀속월'        , type: 'uniDate', allowBlank:false},
            {name: 'SUPP_DATE'            , text: '지급일'        , type: 'uniDate', allowBlank:false},
            {name: 'WAGES_CODE'            , text: '소득내역'        , type: 'string', allowBlank:false, comboType:'AU', comboCode:'H039'},
            {name: 'SUPP_TOTAL_I'        , text: '지급금액'        , type: 'uniPrice'},
            {name: 'IN_TAX_I'            , text: '소득세'        , type: 'uniPrice'},
            {name: 'LOCAL_TAX_I'        , text: '주민세'        , type: 'uniPrice'},
            {name: 'HIRE_INSUR_I'        , text: '고용보험'        , type: 'uniPrice'},
            {name: 'TAX_AMOUNT_I'        , text: '과세분'        , type: 'uniPrice'},
            {name: 'NON_TAX_AMOUNT_I'    , text: '비과세분'        , type: 'uniPrice'},
            {name: 'NON_TAX_CODE'        , text: '비과세코드'    , type: 'string'},
            {name: 'NONTAX_CODE_NAME'    , text: '비과세코드'    , type: 'string'},
            {name: 'REMARK'                , text: '비고'          , type: 'string'}
        ]
	});//End of Unilite.defineModel('had700ukrModel', {	
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'had700ukrService.selectList',
			create: 'had700ukrService.insert',
			update: 'had700ukrService.update',
     	    destroy: 'had700ukrService.delete',
       	    syncAll : 'had700ukrService.saveAll'
		}
	});
	
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('had700ukrMasterStore', {
		model: 'had700ukrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: true,			// 수정 모드 사용 
			deletable: true,		// 삭제 가능 여부 
			allDeletable: false,		//전체 삭제 가능 여부
			useNavi: false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		loadStoreRecords: function(){
			if(Ext.getCmp('searchForm').isValid())	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log(param);
				this.load({
					params: param
				});
			}
		},
		saveStore : function()	{				
			var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);

            var checkValid = true;
	        Ext.each(list, function(record, index) {
	            // 비과세분 입력시 비과세 코드 입력 체크
	            if(record.get('NON_TAX_AMOUNT_I') > 0 && Ext.isEmpty(record.get('NON_TAX_CODE'))) {
	                Unilite.messageBox(Msg.fstMsgH0098);
	                checkValid = false;
	                return;
	            }
	        })
	        if(!checkValid)    {
	            return;
	        }
	         var inValidRecs = this.getInvalidRecords();
	         console.log("inValidRecords : ", inValidRecs);
	         if(inValidRecs.length == 0) {
	             this.syncAllDirect();
	         } else {
	             masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
	         }
		}
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
				fieldLabel: '귀속월',
				startFieldName: 'SUPP_DATE_FR',
                endFieldName: 'SUPP_DATE_TO',
	        	xtype: 'uniMonthRangefield',
	        	startDate :UniDate.get('startOfYear'),
	        	endDate :UniDate.get('endOfYear'),
	        	allowBlank: false,
	        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
                   if(panelSearch) {
                	   panelResult.setValue('SUPP_DATE_FR',newValue);
                   }   
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                   if(panelSearch) {
                	   panelResult.setValue('SUPP_DATE_TO',newValue);
                   }       
                }
	        },{
				fieldLabel: '소득구분',
				name: 'WAGES_CODE', 
				xtype: 'uniCombobox',
				comboType:'AU', 
				comboCode:'H039',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('INSUR_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '사업장',
				name: 'DIV_CODE', 
				xtype: 'uniCombobox',
				comboType:'BOR120',
				value : UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			},		
		     Unilite.popup('DEPT',{ 				
					autoPopup: true,
					validateBlank: false,
					valueFieldName : "DEPT_CODE_FR",
					textFieldName : "DEPT_NAME_FR",
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('DEPT_CODE_FR', newValue);		
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('DEPT_NAME_FR', newValue);	
						}
					}
			}),	
			Unilite.popup('DEPT',{ 				
				autoPopup: true,
				validateBlank: false,
				valueFieldName : "DEPT_CODE_TO",
				textFieldName  : "DEPT_NAME_TO",
				fieldLabel:'~',
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_CODE_TO', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('DEPT_NAME_TO', newValue);				
					}
				}
		  }),		
		     Unilite.popup('Employee',{ 				
				autoPopup: true,
				validateBlank: false,
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					}
				}
			})]
		}]
	});
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
			fieldLabel : '귀속월',
			startFieldName : 'SUPP_DATE_FR',
            endFieldName : 'SUPP_DATE_TO',
        	xtype : 'uniMonthRangefield',	
        	startDate :UniDate.get('startOfYear'),
        	endDate :UniDate.get('endOfYear'),
        	allowBlank: false,
        	onStartDateChange: function(field, newValue, oldValue, eOpts) {
               if(panelSearch) {
            	   panelSearch.setValue('SUPP_DATE_FR',newValue);
               }   
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
               if(panelSearch) {
            	   panelSearch.setValue('SUPP_DATE_TO',newValue);
               }       
            }
        },{
			fieldLabel: '소득구분',
			name: 'WAGES_CODE', 
			xtype: 'uniCombobox',
			comboType:'AU', 
			comboCode:'H039',
			width:255,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WAGES_CODE', newValue);
				}
			}
		},{
			fieldLabel: '사업장',
			name: 'DIV_CODE', 
			xtype: 'uniCombobox',
			comboType:'BOR120',
			value : UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},		
	     Unilite.popup('DEPT',{ 				
				autoPopup: true,
				validateBlank: false,
				valueFieldName : "DEPT_CODE_FR",
				textFieldName : "DEPT_NAME_FR",
				listeners: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('DEPT_CODE_FR', newValue);		
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('DEPT_NAME_FR', newValue);	
					}
				}
		}),	
		Unilite.popup('DEPT',{ 				
			autoPopup: true,
			validateBlank: false,
			valueFieldName : "DEPT_CODE_TO",
			textFieldName  : "DEPT_NAME_TO",
			fieldLabel:'~',
			labelWidth:20,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_CODE_TO', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('DEPT_NAME_TO', newValue);				
				}
			}
	  }),
	     Unilite.popup('Employee',{ 				
			autoPopup: true,
			validateBlank: false,
			listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('PERSON_NUMB', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('NAME', newValue);				
				}
			}
		})]
    });
		
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('had700ukrGrid1', {
    	// for tab    	
		layout: 'fit',
		region: 'center',
		store : directMasterStore, 
    	uniOpt: {
    		expandLastColumn: false,
    		onLoadSelectFirst: false,
    		copiedRow: true,
    		useRowNumberer: true
        },
        features: [
            { ftype: 'uniSummary',          showSummaryRow: true, dock :'bottom'}
        ],
		columns: [{dataIndex: 'DIV_CODE'        , width: 90},
			{dataIndex: 'DEPT_NAME'        , width: 100},
			{dataIndex: 'PERSON_NUMB'        , width: 90,
			 editor : Unilite.popup('Employee_G',{ 				
					autoPopup: true,
					validateBlank: true,
		        	allowBlank: false,
					textFieldName:'PERSON_NUMB',
					DBtextFieldName: 'PERSON_NUMB',
					listeners: {
						onSelected: function(records, type){
							masterGrid.uniOpt.currentRecord.set('PERSON_NUMB', records[0]['PERSON_NUMB']);					
							masterGrid.uniOpt.currentRecord.set('NAME', records[0]['NAME']);	
							masterGrid.uniOpt.currentRecord.set('DEPT_CODE', records[0]['DEPT_CODE']);
							masterGrid.uniOpt.currentRecord.set('DEPT_NAME', records[0]['DEPT_NAME']);
							masterGrid.uniOpt.currentRecord.set('DIV_CODE', records[0]['DIV_CODE']);	
						},
						onClear: function(type){
							masterGrid.uniOpt.currentRecord.set('PERSON_NUMB', '');					
							masterGrid.uniOpt.currentRecord.set('NAME', '');	
							masterGrid.uniOpt.currentRecord.set('DEPT_CODE', '');
							masterGrid.uniOpt.currentRecord.set('DEPT_NAME', '');	
							masterGrid.uniOpt.currentRecord.set('DIV_CODE', '');	
						}
					}
				})
			},
			{dataIndex: 'NAME'        , width: 90,
				 editor : Unilite.popup('Employee_G',{ 				
						autoPopup: true,
						validateBlank: true,
						textFieldName:'NAME',
						DBtextFieldName: 'NAME',
						listeners: {
							onSelected: function(records, type){
								masterGrid.uniOpt.currentRecord.set('PERSON_NUMB', records[0]['PERSON_NUMB']);					
								masterGrid.uniOpt.currentRecord.set('NAME', records[0]['NAME']);	
								masterGrid.uniOpt.currentRecord.set('DEPT_CODE', records[0]['DEPT_CODE']);
								masterGrid.uniOpt.currentRecord.set('DEPT_NAME', records[0]['DEPT_NAME']);	
								masterGrid.uniOpt.currentRecord.set('DIV_CODE', records[0]['DIV_CODE']);	
							},
							onClear: function(type){
								masterGrid.uniOpt.currentRecord.set('PERSON_NUMB', '');					
								masterGrid.uniOpt.currentRecord.set('NAME', '');			
								masterGrid.uniOpt.currentRecord.set('DEPT_CODE', '');
								masterGrid.uniOpt.currentRecord.set('DEPT_NAME', '');	
								masterGrid.uniOpt.currentRecord.set('DIV_CODE', '');	
							}
						}
					})},
			{dataIndex: 'PAY_YYYYMM'        , width: 73,
            	xtype:'uniMonthColumn',
                editor:{xtype:'uniMonthfield',format: 'Y.m'},
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                      return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
                }
            },
            {dataIndex: 'SUPP_DATE'         , width: 90, readonly:true},
            {dataIndex: 'WAGES_CODE'        , width: 90},
            {dataIndex: 'SUPP_TOTAL_I'      , width: 90, summaryType:'sum'},
            {dataIndex: 'IN_TAX_I'          , width: 90, summaryType:'sum'},
            {dataIndex: 'LOCAL_TAX_I'       , width: 90, summaryType:'sum'},
            {dataIndex: 'HIRE_INSUR_I'      , width: 90, summaryType:'sum'},
            {dataIndex: 'TAX_AMOUNT_I'      , width: 110, summaryType:'sum'},
            {dataIndex: 'NON_TAX_AMOUNT_I'  , width: 90, summaryType:'sum'},
            {dataIndex: 'NON_TAX_CODE'      , width: 90,
                editor:Unilite.popup('NONTAX_CODE_G', {
                    textFieldName:'NONTAX_CODE_NAME',
					autoPopup: true,
                    listeners:{
                        onSelected:function(records, type)    {
                            if(records)    {
                                var record = masterGrid.uniOpt.currentRecord;
                                record.set('NON_TAX_CODE', records[0].NONTAX_CODE);
                                record.set('NONTAX_CODE_NAME', records[0].NONTAX_CODE_NAME);
                            }
                        },
                        onClear:function()    {
                            var record = masterGrid.uniOpt.currentRecord;
                            record.set('NON_TAX_CODE', '');
                            record.set('NONTAX_CODE_NAME', '');
                        },
                        applyextparam:function(popup)    {
                            popup.extParam.PAY_YM_FR = Ext.Date.format(masterGrid.uniOpt.currentRecord.get("PAY_YYYYMM"), 'Y');
                        }
                    }
                })
            },
            {dataIndex: 'REMARK'            , minWidth: 70, flex: 1}
		],
        listeners:{
			beforeedit : function( editor, e, eOpts ) {
				if(!e.record.phantom && UniUtils.indexOf(e.field, ['PAY_YYYYMM','SUPP_DATE','WAGES_CODE', 'DEPT_CODE','DEPT_NAME'])) {
					return false;
				}
				return true;
			}
        }
	});//End of var masterGrid = Unilite.createGrid('had700ukrGrid1', {
	
	
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: {type: 'vbox', align: 'stretch'},
			border: false,
			items:[
				panelResult,  masterGrid
			]
		},
		panelSearch  	
		],
		id: 'had700ukrApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons([ 'newData'], true);
			UniAppManager.setToolbarButtons([ 'deleteAll'], false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('SUPP_DATE_FR');
		},
		onQueryButtonDown: function() {			
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onNewDataButtonDown : function(additemCode)	{
			if(!this.isValidSearchForm()){
				return false;
			}
			var r = {
				'PERSON_NUMB' : panelSearch.getValue("PERSON_NUMB"),
				'NAME' :  panelSearch.getValue("NAME")
			}
			masterGrid.createRow(r, 'PAY_YYYYMM');
		},
		onResetButtonDown:function() {			
			panelSearch.clearForm();
			panelResult.clearForm();			
			masterGrid.getStore().loadData({});	//grid.reset()은 store에 삭제를 시키므로 못씀			
			this.fnInitBinding();
		},
		onDeleteDataButtonDown: function(){
			var selRow = Ext.getCmp('had700ukrGrid1').getSelectedRecord();
			if(selRow.phantom === true)	{
				Ext.getCmp('had700ukrGrid1').deleteSelectedRow();
			}else {
				Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
					if (btn == 'yes') {
						Ext.getCmp('had700ukrGrid1').deleteSelectedRow();						
					}
				});
			}		
			
		},
		onSaveDataButtonDown : function() {			
			directMasterStore.saveStore();
		},
		onDeleteAllButtonDown : function() {
			
		}
	});
		
};


</script>
