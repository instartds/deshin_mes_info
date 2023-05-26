<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpb120ukr"  >
	<t:ExtComboStore comboType="AU" comboCode="A118"/> <!-- 소득자타입 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
<script type="text/javascript" >


var excelWindow; // 엑셀참조

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read	: 'hpb120ukrService.selectList',
            update	: 'hpb120ukrService.updateDetail',
            create	: 'hpb120ukrService.insertDetail',
            destroy	: 'hpb120ukrService.deleteDetail',
            syncAll	: 'hpb120ukrService.saveAll'
        }
    }); 
	
	var directButtonProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
            create	: 'hpb120ukrService.runProcedure',
            syncAll	: 'hpb120ukrService.callProcedure'
		}
	});	


	
	/** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('hpb120ukrModel', {
	    fields: [  
	    	{name: 'DED_TYPE'			,text: '소득구분'				,type: 'string' 	, allowBlank: false},
			{name: 'NAME'				,text: '성명'					,type: 'string' 	, allowBlank: false},
			{name: 'PERSON_NUMB'		,text: '사번'					,type: 'string'},
			{name: 'REPRE_NUM'			,text: '주민번호'				,type: 'string' 	, allowBlank: false},
			{name: 'REPRE_NUM_EXPOS'    ,text: '주민등록번호'			,type: 'string'	, defaultValue:'*************'}, 
			{name: 'PAY_YYYYMM'			,text: '지급년월'				,type: 'string' 	, allowBlank: false},
			{name: 'SUPP_DATE'			,text: '지급일'				,type: 'uniDate'	, allowBlank: false},
			{name: 'PAY_AMOUNT_I'		,text: '지급액'				,type: 'uniPrice'   , allowBlank: false},
			{name: 'EXPS_PERCENT_I'		,text: '필요경비세율'			,type: 'uniPercent'},
			{name: 'EXPS_AMOUNT_I'		,text: '필요경비'				,type: 'uniPrice'},
			{name: 'PERCENT_I'			,text: '세율'					,type: 'uniPercent'},
			{name: 'IN_TAX_I'			,text: '소득세'				,type: 'uniPrice'},
			{name: 'LOCAL_TAX_I'		,text: '주민세'				,type: 'uniPrice'},
			{name: 'CP_TAX_I'			,text: '법인세'				,type: 'uniPrice'},
			
			{name: 'DED_CODE'			,text: '소득구분'				,type: 'string'},
			{name: 'ACC_GU'				,text: '계정구분'				,type: 'string'   , allowBlank: false},
			
			{name: 'DEPT_CODE'			,text: '부서코드'				,type: 'string'},
			{name: 'DEPT_NAME'			,text: '부서명'				,type: 'string'},
			{name: 'DIV_CODE'			,text: '사업장'				,type: 'string'},
			{name: 'SECT_CODE'			,text: '신고사업장'				,type: 'string'     , allowBlank: false , comboType: 'BOR120', comboCode: 'BILL'},
			{name: 'APPLY_YN'			,text: '반영여부'				,type: 'string'},
			
			/* 20161221 추가 */
	    	{name: 'ORG_ACCNT'		 	,text: '본계정' 				,type: 'string'  },
	    	{name: 'ORG_ACCNT_NAME'	 	,text: '본계정명'				,type: 'string'  },

	    	{name: 'COMP_CODE'			,text: '법인명'				,type: 'string'},
			{name: 'SEQ'				,text: '순번'					,type: 'int'}
		]
	});

	
	
	/** Store 정의(Service 정의)
	 * @type 
	 */					
	var directDetailStore = Unilite.createStore('hpb120ukrDetailStore', {
		model: 'hpb120ukrModel',
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결 
			editable: false,		// 수정 모드 사용 
			deletable: true,		// 삭제 가능 여부 
			allDeletable:true,
			useNavi : false			// prev | newxt 버튼 사용
		},
		autoLoad: false,
		proxy: directProxy,
		
		loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		},
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			var paramMaster= panelResult.getValues();	
			if(!Ext.isEmpty(list)) {
				fnCipherRepre(list);
			}
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);		
						
						directDetailStore.loadStoreRecords();
					 } 
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('hpb120ukrGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		
		listeners: {
           	load: function(store, records, successful, eOpts) {
				if(Ext.getCmp('applyYn').getChecked()[0].inputValue == 'Y'){
					UniAppManager.setToolbarButtons(['delete', 'deleteAll'], false);
				}
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});
	
    var buttonStore = Unilite.createStore('hpb120ukrButtonStore',{      
        uniOpt: {
            isMaster	: false,            // 상위 버튼 연결 
            editable	: false,            // 수정 모드 사용 
            deletable	: false,            // 삭제 가능 여부 
            useNavi		: false         	// prev | newxt 버튼 사용
        },
        proxy	: directButtonProxy,
        
        saveStore: function() {             
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();

            var paramMaster 			= panelSearch.getValues();
            paramMaster.LANG_TYPE		= UserInfo.userLang
            
            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        //return 값 저장
                        var master = batch.operations[0].getResultSet();
                        
                        UniAppManager.app.onQueryButtonDown();
                        buttonStore.clearData();
                     },

                     failure: function(batch, option) {
                        buttonStore.clearData();
                     }
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('hpb120ukrGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
            },
            add: function(store, records, index, eOpts) {
            },
            update: function(store, record, operation, modifiedFieldNames, eOpts) {
            },
            remove: function(store, record, index, isMove, eOpts) {
            }
        }
    });
    
    
    
	/** 검색조건 (Search Panel)
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
				fieldLabel: '소득구분',
				name: 'DED_TYPE', 
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'A118',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DED_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '귀속년월',
				name: 'PAY_YYYYMM', 
				xtype: 'uniMonthfield',
				value: UniDate.get('today'),
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_YYYYMM', newValue);
					}
				}
			},{ 
	    		fieldLabel: '지급일',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'SUPP_DATE_FR',
			    endFieldName: 'SUPP_DATE_TO',     	
//			    holdable:'hold',
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelSearch) {
						panelResult.setValue('SUPP_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelResult.setValue('SUPP_DATE_TO', newValue);				    		
			    	}
			    }
			},{
				fieldLabel: '신고사업장',
				name: 'SECT_CODE', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				comboCode: 'BILL',
				multiSelect: true,
				typeAhead: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SECT_CODE', newValue);
					}
				}
			},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 2},
				width:600,
				items :[{
					xtype: 'radiogroup',
					id : 'applyYn',
					fieldLabel: '반영여부',
					items: [{
						boxLabel: '미반영', 
						width: 70,
						name: 'APPLY_YN',
						inputValue: 'N',
						checked: true  
					},{
						boxLabel: '반영', 
						width: 70,
						name: 'APPLY_YN',
						inputValue: 'Y' 
					}],
					listeners: {
						beforechange: function(field, newValue, oldValue, eOpts) {
							if(!panelSearch.getInvalidMessage()){
								return false;
							}
						},
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.getField('APPLY_YN').setValue(newValue.APPLY_YN);
							UniAppManager.app.onQueryButtonDown();
						}
					}
				}
			]},
			Unilite.popup('EARNER',{
		    	fieldLabel: '소득자', 
				validateBlank:false,
				autoPopup: false,
				valueFieldName:'PERSON_NUMB',
        		textFieldName:'NAME', 
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelResult.setValue('PERSON_NUMB', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('NAME', newValue);				
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
							panelResult.setValue('ACCNT_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DED_TYPE': panelSearch.getValue('DED_TYPE')});		//소득자타입(1사업,2기타,10이자,20배당)
							popup.setExtParam({'SECT_CODE': panelSearch.getValue('SECT_CODE')});			//신고사업장
						}
					}
				})
			]
		}]
	});
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
				fieldLabel: '소득구분',
				name: 'DED_TYPE', 
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'A118',
				allowBlank:false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DED_TYPE', newValue);
					}
				}
			},{
				fieldLabel: '귀속년월',
				name: 'PAY_YYYYMM', 
				xtype: 'uniMonthfield',
				value: UniDate.get('today'),
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('PAY_YYYYMM', newValue);
					}
				}
			},{ 
	    		fieldLabel: '지급일',
			    xtype: 'uniDateRangefield',
			    startFieldName: 'SUPP_DATE_FR',
			    endFieldName: 'SUPP_DATE_TO',       	
//			    holdable:'hold',
	            onStartDateChange: function(field, newValue, oldValue, eOpts) {
	            	if(panelResult) {
						panelSearch.setValue('SUPP_DATE_FR', newValue);
					}
	            },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelSearch.setValue('SUPP_DATE_TO', newValue);				    		
			    	}
			    }
			},{
				fieldLabel: '신고사업장',
				name: 'SECT_CODE', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				comboCode: 'BILL',
				multiSelect: true,
				typeAhead: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SECT_CODE', newValue);
					}
				}
			},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 2},
				width:600,
				items :[{
					xtype: 'radiogroup',		            		
					fieldLabel: '반영여부',
					items: [{
						boxLabel: '미반영', 
						width: 70,
						name: 'APPLY_YN',
						inputValue: 'N',
						checked: true  
					},{
						boxLabel: '반영', 
						width: 70,
						name: 'APPLY_YN',
						inputValue: 'Y' 
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.getField('APPLY_YN').setValue(newValue.APPLY_YN);					
						}
					}
				}
			]},
			Unilite.popup('EARNER',{
		    	fieldLabel: '소득자', 
				validateBlank:false,
				autoPopup: false,
				valueFieldName:'PERSON_NUMB',
        		textFieldName:'NAME', 
					listeners: {
						onValueFieldChange: function(field, newValue){
							panelSearch.setValue('PERSON_NUMB', newValue);								
						},
						onTextFieldChange: function(field, newValue){
							panelSearch.setValue('NAME', newValue);				
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
							panelSearch.setValue('ACCNT_NAME', '');
						},
						applyextparam: function(popup){							
							popup.setExtParam({'DED_TYPE': panelResult.getValue('DED_TYPE')});		//소득자타입(1사업,2기타,10이자,20배당)
							popup.setExtParam({'SECT_CODE': panelResult.getValue('SECT_CODE')});			//신고사업장
						}
					}
				})
		
		]
    });	 
    
    
    
    var masterGrid = Unilite.createGrid('hpb120ukrGrid', {
		layout: 'fit',
		region: 'center',
		excelTitle: '사업기타소득 엑셀업로드',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			onLoadSelectFirst: false,
			useRowNumberer: false,
			expandLastColumn: false,
			useRowContext: true,
    		state: {
				useState: true,			
				useStateList: true		
			}
        },
        tbar: [{
			itemId: 'excelMemberBtn',
			text: '사업기타소득 엑셀업로드',
        	handler: function() {
	        	openExcelWindow();
	        }
		}/*,{
			itemId: 'Btn',
			text: '소득반영',
        	handler: function() {
	     
	        }
		}}*/,{
			itemId: 'disBtn',
			text: '반영취소',
			disabled: true,
        	handler: function() {
	            fnMakeLogTable();
			}
		}],
		features: [{
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
		store: directDetailStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
			listeners: {        		
    			select: function(grid, selectRecord, index, rowIndex, eOpts ){
	    			if (this.selected.getCount() > 0 && Ext.getCmp('applyYn').getChecked()[0].inputValue == 'N') {
			    		masterGrid.down("#disBtn").disable();
			    		
	    			} else if (this.selected.getCount() > 0 && Ext.getCmp('applyYn').getChecked()[0].inputValue == 'Y') {
		    			masterGrid.down('#disBtn').enable();
	    			}
    			},
    			
	    		deselect:  function(grid, selectRecord, index, eOpts ){
	    			if (this.selected.getCount() <= 0) {								//체크된 데이터가 0개일  때는 버튼 비활성화
			    		masterGrid.down('#disBtn').disable();
	    			}
	    		}
        	}
        }),
		columns: [{
				xtype: 'rownumberer',        
			    sortable:false,        
			    width: 35, 
			    align:'center  !important',       
			    resizable: true
			},
			{ dataIndex: 'DED_TYPE'				,width:100, hidden:true},
			{ dataIndex: 'NAME'					,width:100},
			{ dataIndex: 'PERSON_NUMB'			,width:100},
			{ dataIndex: 'REPRE_NUM'			,width:120 		, hidden: true},
			{ dataIndex: 'REPRE_NUM_EXPOS'		,width: 100},			
			{ dataIndex: 'PAY_YYYYMM'			,width:100		, align: 'center'},
			{ dataIndex: 'SUPP_DATE'			,width:100},
			{ dataIndex: 'PAY_AMOUNT_I'			,width:100},
			{ dataIndex: 'EXPS_PERCENT_I'		,width:100},
			{ dataIndex: 'EXPS_AMOUNT_I'		,width:80},
			{ dataIndex: 'PERCENT_I'			,width:80},
			{ dataIndex: 'IN_TAX_I'				,width:100},
			{ dataIndex: 'LOCAL_TAX_I'			,width:100},
			{ dataIndex: 'CP_TAX_I'				,width:100 		, hidden: true},
			{ dataIndex: 'DIV_CODE'				,width:120		, hidden: true},
			{ dataIndex: 'DED_CODE'				,width:120},
			{ dataIndex: 'ACC_GU'				,width:120},
			{ dataIndex: 'DEPT_CODE'			,width:120},
			{ dataIndex: 'DEPT_NAME'			,width:150},
			{ dataIndex: 'SECT_CODE'			,width:110},
			{ dataIndex: 'ORG_ACCNT'			,width:120},
			{ dataIndex: 'ORG_ACCNT_NAME'		,width:150},
			{ dataIndex: 'APPLY_YN'				,width:88}
        ],
        listeners: {	
          	onGridDblClick:function(grid, record, cellIndex, colName) {
          		if(colName =="REPRE_NUM_EXPOS") {
					grid.ownerGrid.openCryptRepreNoPopup(record);
				}
          	}
        	
		},
    	openCryptRepreNoPopup:function( record )	{
		  	if(record)	{
				var params = {'REPRE_NO': record.get('REPRE_NUM'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'REPRE_NUM_EXPOS', 'REPRE_NUM', params);
			}
				
		}
    });   
    
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, masterGrid
			]	
		},
			panelSearch
		],
		id  : 'hpb120ukrApp',
		fnInitBinding: function(){
			this.defaultSet();
		},
		defaultSet: function() {      
			UniAppManager.setToolbarButtons(['newData'], false);
            UniAppManager.setToolbarButtons(['reset'], true);

            panelSearch.setValue('PAY_YYYYMM' ,UniDate.get('today'));
            panelResult.setValue('PAY_YYYYMM' ,UniDate.get('today'));
            
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('DED_TYPE');
        },
		onQueryButtonDown: function() {      
			if(!panelResult.getInvalidMessage()) return;	//필수체크
			
			directDetailStore.loadStoreRecords();		
		},
		onNewDataButtonDown: function()	{
			if(!panelResult.getInvalidMessage()) return;	//필수체크
		
			 //var dedType    = panelResult.getValue('DED_TYPE')
        	 ///var payYyyymm  = UniDate.getDbDateStr(panelResult.getValue('PAY_YYYYMM')).substring(0, 6);
        	 var seq 		= masterGrid.getStore().max('SEQ');
        	 if(!seq) seq 	= 1;
        	 else  seq 		+= 1;
        	 var applyYn    = 'N';
        	 
        	 var r = {
				//DED_TYPE: dedType,
				//PAY_YYYYMM : payYyyymm,
				SEQ	: seq,
				APPLY_YN   : applyYn
				
	        };
			masterGrid.createRow(r);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
		
			masterGrid.reset();
			directDetailStore.clearData();

//			this.fnInitBinding();		
			this.defaultSet();
			UniAppManager.setToolbarButtons('save', false);
		},
    
		onSaveDataButtonDown: function(config) {				
			directDetailStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			
			if(Ext.isEmpty(selRow)){
				alert('선택된 데이터가 없습니다.');
				return false;
			}
			if(selRow.data.APPLY_YN == 'Y'){
				alert('전표가 발행된 건은 삭제할 수 없습니다.');
				return false;
			}
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else if(selRow.data.APPLY_YN == 'N'){
				if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {	
					masterGrid.deleteSelectedRow();
				}
			}
		},
		onDeleteAllButtonDown: function() {			
			var records = directDetailStore.data.items;
			if(Ext.isEmpty(records)) {
				alert ('삭제할 데이터가 없습니다.');
				return false
			};
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						if(deletable){	
							//if(selRow.data.APPLY_YN == 'N'){
								masterGrid.reset();			
								UniAppManager.app.onSaveDataButtonDown();	
							//}
						}
						isNewData = false;							
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				masterGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		}
	});
	Unilite.createValidator('validator01', {
		store: directDetailStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
			
			}
			return rv;
		}
	});	
			
	function fnCipherRepre(){
		//var isErr = false;
		Ext.each(records, function(record, index){
			if  (!Ext.isEmpty(record.get('REPRE_NUM'))){
				var params = {
					INCDRC_GUBUN  : 'INC', 
					DECRYP_WORD  : record.get('REPRE_NUM')
				}												
				popupService.incryptDecryptPopup(params, function(provider, response)	{							
					if(!Ext.isEmpty(provider)){
						record.set('REPRE_NUM', provider);
					}													
				});	
			}
		});
	}
	
	Unilite.Excel.defineModel('excel.hpb120.sheet01', {
	    fields: [
	    		{name: '_EXCEL_ROWNUM'    	,text:'순번'				,type : 'int'  }, 
				{name: '_EXCEL_HAS_ERROR'   ,text:'에러메세지'			,type : 'string'}, 
				{name: '_EXCEL_ERROR_MSG'   ,text:'에러메세지'			,type : 'string'}, 
	    		{name: 'NAME'				,text: '성명'					,type: 'string' 	, allowBlank: false},
				{name: 'REPRE_NUM'			,text: '주민번호'				,type: 'string' 	, allowBlank: false},
				{name: 'PAY_YYYYMM'			,text: '지급년월'				,type: 'string' 	, allowBlank: false},
				{name: 'SUPP_DATE'			,text: '지급일'				,type: 'uniDate'	, allowBlank: false},
				{name: 'PAY_AMOUNT_I'		,text: '지급액'				,type: 'uniPrice'   , allowBlank: false},
				{name: 'PERCENT_I'			,text: '세율'					,type: 'string'},
				{name: 'IN_TAX_I'			,text: '소득세'				,type: 'uniPrice'},
				{name: 'LOCAL_TAX_I'		,text: '주민세'				,type: 'uniPrice'},
				{name: 'CP_TAX_I'			,text: '법인세'				,type: 'uniPrice'},
				{name: 'DIV_CODE'			,text: '사업장'				,type: 'string'},
				{name: 'DED_CODE'			,text: '소득구분'				,type: 'string'},
				{name: 'ACC_GU'				,text: '계정구분'				,type: 'string'},
				{name: 'DEPT_CODE'			,text: '부서코드'				,type: 'string'},
				{name: 'DEPT_NAME'			,text: '부서명'				,type: 'string'},
				{name: 'SECT_CODE'			,text: '신고사업장'				,type: 'string'     , allowBlank: false , comboType: 'BOR120', comboCode: 'BILL'},
				{name: 'APPLY_YN'			,text: '반영여부'				,type: 'string'}			 
		]
	});
	
	
	function openExcelWindow() {
		var me = this;
        var vParam = {};
        var appName = 'Unilite.com.excel.ExcelUpload';
        if(!directDetailStore.isDirty())	{									//화면에 저장할 내용이 있을 경우 저장여부 확인
			directDetailStore.loadData({});
        } else {
        	if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
        		UniAppManager.app.onSaveDataButtonDown();
        		return;
        	}else {
        		directDetailStore.loadData({});
        	}
        }
        if (Ext.isEmpty(panelSearch.getValue('DED_TYPE'))) {
        	alert("업로드할 데이터의 소득구분을 조회조건에 입력해 주시기 바랍니다.");
        	return false;
        }
        if(!excelWindow) {
        	excelWindow =  Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
        		modal: false,
        		excelConfigName: 'hpb120ukr',
        		width	: 600,
				height	: 200,
        		extParam: { 
        			'PGM_ID'		: 'hpb120ukr',
        			'DED_TYPE'	    : panelSearch.getValue('DED_TYPE'),
        			'PAY_YYYYMM'	: UniDate.getDbDateStr(panelSearch.getValue('PAY_YYYYMM'))  // 귀속년월
        		},

                 listeners: {
                    close: function() {
                        this.hide();
                    },
                    show:function()	{
                    }
                },
                uploadFile: function() {
					var me = this,
					frm = me.down('#uploadForm');
					frm.submit({
						params: me.extParam,
						waitMsg: 'Uploading...',
						success: function(form, action) {
							var param = {
								jobID : action.result.jobID
							}
                            hpb120ukrService.getErrMsg(param, function(provider, response){
                                if (Ext.isEmpty(provider)) {
                                    me.jobID = action.result.jobID;
                                    me.readGridData(me.jobID);
                                    me.down('tabpanel').setActiveTab(1);
                                    Ext.Msg.alert('Success', 'Upload 성공 하였습니다.');
                                    
                                    me.hide();
                                    UniAppManager.app.onQueryButtonDown();
                                    
                                } else {
                                    alert(provider);
                                }
							//로그테이블 삭제
							hpb120ukrService.deleteTemp(param, function(provider, response){});
                            });
						},
			            failure: function(form, action) {
			                Ext.Msg.alert('Failed', action.result.msg);
			            }
						
					});
				},

				_setToolBar: function() {
					var me = this;
					me.tbar = [
						{
							xtype: 'button',
							text : '업로드',
							tooltip : '업로드', 
							handler: function() { 
								me.jobID = null;
								me.uploadFile();
							}
						}, '->', {
							xtype: 'button',
							text : '닫기',
							tooltip : '닫기', 
							handler: function() { 
								me.hide();
							}
						}
					]
				 }
             });
        }
        excelWindow.center();
        excelWindow.show();
	};
	
	function fnMakeLogTable() {
		//조건에 맞는 내용은 적용 되는 로직															//전송 외의 경우, 자동채번로직 없이 SP호출
		records = masterGrid.getSelectedRecords();
		buttonStore.clearData();														//buttonStore 클리어
		Ext.each(records, function(record, index) {
            record.phantom 			= true;
            buttonStore.insert(index, record);
			
			if (records.length == index +1) {
                buttonStore.saveStore();
			}
		});
	}

};

</script>