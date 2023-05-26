<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ham805ukr"  >
	<t:ExtComboStore comboType="BOR120" />				<!-- 사업장 정보 -->
	<t:ExtComboStore comboType="AU" comboCode="A118"/> 	<!-- 소득자타입 -->
	<t:ExtComboStore comboType="A" comboCode="H032"/> 	<!-- 지급구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
<script type="text/javascript" >


var excelWindow; // 엑셀참조

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read	: 'ham805ukrService.selectList',
            update	: 'ham805ukrService.updateDetail',
            create	: 'ham805ukrService.insertDetail',
            destroy	: 'ham805ukrService.deleteDetail',
            syncAll	: 'ham805ukrService.saveAll'
        }
    }); 
	

    /** Model 정의 
	 * @type 
	 */
	Unilite.defineModel('ham805ukrModel', {
	    fields: [  
	    	{name: 'COMP_CODE'			,text: 'COMP_CODE'			,type: 'string'  },
			{name: 'PAY_YYYYMM'			,text: '급여년월'				,type: 'string'  	, allowBlank: false},
			{name: 'SUPP_TYPE'			,text: '지급구분'				,type: 'string'  	, allowBlank: false		, comboType:'A'			, comboCode:'H032'},
			{name: 'PERSON_NUMB'		,text: '사번'					,type: 'string'  	, allowBlank: false},
	    	{name: 'PERSON_NAME'		,text: '성명' 				,type: 'string'  },
			{name: 'REPRE_NUM'			,text: '주민등록번호'			,type: 'string'  }, 
			{name: 'REPRE_NUM_EXPOS'	,text: '주민등록번호'			,type: 'string'		, defaultValue: '*************'}, 
			{name: 'DIV_CODE'			,text: '사업장'				,type: 'string'		, allowBlank: false		, comboType:'BOR120'}, 
			{name: 'PAY_YYYY'			,text: '귀속년도'				,type: 'string'  },
			{name: 'QUARTER_TYPE'		,text: '귀속분기'				,type: 'string'  },
			{name: 'SUPP_YYYYMM'		,text: '급여지급년월'			,type: 'string'  	, allowBlank: false},
			{name: 'SUPP_DATE'			,text: '지급일자'				,type: 'uniDate'  	, allowBlank: false},
			{name: 'WORK_MM'			,text: '근무월'				,type: 'string'  },
			{name: 'WORK_DAY'			,text: '근무일수'				,type: 'int'  		, allowBlank: false},
			{name: 'SUPP_TOTAL_I'		,text: '지급액'				,type: 'uniPrice'  	, allowBlank: false},
			{name: 'REAL_AMOUNT_I'		,text: '실지급액'				,type: 'uniPrice'	, allowBlank: false},
			{name: 'TAX_EXEMPTION_I'	,text: '비과세소득'				,type: 'uniPrice'},
			{name: 'IN_TAX_I'			,text: '소득세'				,type: 'uniPrice'  	, allowBlank: false},
			{name: 'LOCAL_TAX_I'		,text: '주민세'				,type: 'uniPrice'  	, allowBlank: false},
			{name: 'ANU_INSUR_I'		,text: '국민연금'				,type: 'uniPrice'},
			{name: 'MED_INSUR_I'		,text: '의료보험금액'			,type: 'uniPrice'},
			{name: 'HIR_INSUR_I'		,text: '고용보험금액'			,type: 'uniPrice'},
	    	{name: 'BUSI_SHARE_I'		,text: '사회보험사업자부담금'		,type: 'uniPrice'},
	    	{name: 'WORKER_COMPEN_I'	,text: '사업자산재보험부담금'		,type: 'uniPrice'},
	    	{name: 'EX_DATE'			,text: '결의전표일'				,type: 'uniDate' },
			{name: 'EX_NUM'				,text: '결의전표번호'			,type: 'int'	 },
			{name: 'AC_DATE'			,text: '회계전표일'				,type: 'uniDate' },
			{name: 'SLIP_NUM'			,text: '회계전표번호'			,type: 'int'	 },
			{name: 'PJT_CODE'			,text: '사업코드/제품코드'		,type: 'string'  },
			{name: 'INSERT_DB_USER'		,text: '입력자'				,type: 'string'  },
	    	{name: 'INSERT_DB_TIME'		,text: '입력일'				,type: 'uniDate' },
	    	//UPDATE를 위한 TEMP컬럼
			{name: 'PAY_YYYYMM_OLD'		,text: '급여년월'				,type: 'string'  },
			{name: 'SUPP_TYPE_OLD'		,text: '지급구분'				,type: 'string'  },
			{name: 'PERSON_NUMB_OLD'	,text: '사번'					,type: 'string'  }
		]
	});
	
	
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('ham805ukrDetailStore', {
		model: 'ham805ukrModel',
		uniOpt: {
			isMaster	: true,			// 상위 버튼 연결 
			editable	: true,		// 수정 모드 사용 
			deletable	: true,			// 삭제 가능 여부 
			allDeletable: true,
			useNavi		: false			// prev | newxt 버튼 사용
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
			
//			fnCipherRepre(list);
			
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);		
						
						masterStore.loadStoreRecords();
					 } 
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('ham805ukrGrid');
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
					id: 'applyYn',
					fieldLabel: '반영여부',
					items: [{
						boxLabel: '미반영', 
						width: 80,
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
							panelResult.getField('APPLY_YN').setValue(newValue.APPLY_YN);					
						}
					}
				}
			]},
			Unilite.popup('Employee_ACCNT',{
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
						applyextparam: function(popup){							
							popup.setExtParam({'DED_TYPE': '9'});									//소득자타입(9:일용직근로소득)
							popup.setExtParam({'SECT_CODE': panelSearch.getValue('SECT_CODE')});	//신고사업장
						}
					}
				}), {               
                //복호화 플래그(복호화 버튼 누를시 플래그 'Y')
                name:'DEC_FLAG', 
                xtype: 'uniTextfield',
                hidden: true
            }]
		}]
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
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
						width: 80,
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
			Unilite.popup('Employee_ACCNT',{
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
					applyextparam: function(popup){
						popup.setExtParam({'DED_TYPE': '9'});									//소득자타입(9:일용직근로소득)
						popup.setExtParam({'SECT_CODE': panelResult.getValue('SECT_CODE')});	//신고사업장
					}
				}
			})
		]
    });	 
    
    
    
    var detailGrid = Unilite.createGrid('ham805ukrGrid', {
		layout: 'fit',
		region: 'center',
		excelTitle: '일용근로소득 엑셀업로드',
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			onLoadSelectFirst: false,
			useRowNumberer: false,
			expandLastColumn: true,
			useRowContext: true,
    		state: {
				useState: true,			
				useStateList: true		
			}
        },
        tbar: [{
			itemId: 'excelMemberBtn',
			text: '일용근로소득 엑셀업로드',
        	handler: function() {
	        	openExcelWindow();
	        }
		}],
		features: [{
			id: 'detailGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'detailGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: false
		}],
		store: masterStore,
		selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
			listeners: {  
				select: function(grid, selectRecord, index, rowIndex, eOpts ){
				
				},
				deselect:  function(grid, selectRecord, index, eOpts ){
				
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
//			{ dataIndex: 'SUPP_TYPE'		, width:100		, hidden: true},
			{ dataIndex: 'PERSON_NUMB'		, width:100,
        		editor: Unilite.popup('Employee_ACCNT_G',{
					DBtextFieldName: 'PERSON_NUMB',
					autoPopup   : true ,
					listeners:{ 
						'onSelected': {
	                    	fn: function(records, type  ){
	                    		var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('PERSON_NUMB'	,records[0]['PERSON_NUMB']);
								grdRecord.set('PERSON_NAME'	,records[0]['NAME']);
								grdRecord.set('REPRE_NUM'	,records[0]['REPRE_NUM']);
	                    	},
                    		scope: this
          	   			},
						'onClear' : function(type)	{
	                  		var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('PERSON_NUMB'	,'');
							grdRecord.set('PERSON_NAME'	,'');
							grdRecord.set('REPRE_NUM'	,'');
	                  	}
					}
				})
			},
			{ dataIndex: 'PERSON_NAME'		, width:100,
        		editor: Unilite.popup('Employee_ACCNT_G',{
			  		autoPopup: true,
					listeners:{ 
						'onSelected': {
	                    	fn: function(records, type ){
	                    		var grdRecord = detailGrid.uniOpt.currentRecord;
								grdRecord.set('PERSON_NUMB'	,records[0]['PERSON_NUMB']);
								grdRecord.set('PERSON_NAME'	,records[0]['NAME']);
								grdRecord.set('REPRE_NUM'	,records[0]['REPRE_NUM']);
	                    	},
                    		scope: this
          	   			},
						'onClear' : function(type)	{
	                  		var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('PERSON_NUMB','');
							grdRecord.set('PERSON_NAME','');
							grdRecord.set('REPRE_NUM'	,'');
	                  	}
					}
				})
        	},
			{ dataIndex: 'DIV_CODE'			, width:100},			
			{ dataIndex: 'REPRE_NUM'		, width:100		, hidden: true},			
			{ dataIndex: 'REPRE_NUM_EXPOS'	, width:100},			
			{ dataIndex: 'PAY_YYYYMM'		, width:100		, align: 'center'},
//			{ dataIndex: 'PAY_YYYY'			, width:100		, hidden: true},
//			{ dataIndex: 'QUARTER_TYPE'		, width:100		, hidden: true},
//			{ dataIndex: 'SUPP_YYYYMM'		, width:100		, hidden: true},
			{ dataIndex: 'SUPP_DATE'		, width:100},
//			{ dataIndex: 'WORK_MM'			, width:100		, hidden: true},
			{ dataIndex: 'WORK_DAY'			, width:100},
			{ dataIndex: 'SUPP_TOTAL_I'		, width:120},
			{ dataIndex: 'TAX_EXEMPTION_I'	, width:120},
			{ dataIndex: 'IN_TAX_I'			, width:100},
			{ dataIndex: 'LOCAL_TAX_I'		, width:100},
			{ dataIndex: 'ANU_INSUR_I'		, width:100},
			{ dataIndex: 'MED_INSUR_I'		, width:100},
			{ dataIndex: 'HIR_INSUR_I'		, width:100},
			{ dataIndex: 'BUSI_SHARE_I'		, width:100/*		, hidden: true*/},
			{ dataIndex: 'WORKER_COMPEN_I'	, width:100/*		, hidden: true*/},
			{ dataIndex: 'REAL_AMOUNT_I'	, width:120},
			{ dataIndex: 'EX_DATE'			, width:100},
			{ dataIndex: 'EX_NUM'			, width:95		,
	        	renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					var r = val;
	        		if (Ext.isEmpty(record.get('EX_DATE'))) {
						r = '';
	        		}
	        		return r
	            }
			},
			{ dataIndex: 'AC_DATE'			, width:100}, 
			{ dataIndex: 'SLIP_NUM'			, width:95		,
	        	renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					var r = val;
	        		if (Ext.isEmpty(record.get('AC_DATE'))) {
						r = '';
	        		}
	        		return r
	            }
			},			
			{ dataIndex: 'PJT_CODE'			, width:120}
        ],
        listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if (Ext.getCmp('applyYn').getChecked()[0].inputValue == 'N') {
		        	if(UniUtils.indexOf(e.field, ['REPRE_NUM_EXPOS'])){ 
						return false;
	  				} else {
	  					return true;
	  				}
				} else {
					return false;
				}
			},
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
    
    var decrypBtn = Ext.create('Ext.Button',{
        text:'복호화',
        width: 80,
        handler: function() {
            var needSave = !UniAppManager.app.getTopToolbar().getComponent('save').isDisabled();
            if(needSave){
               alert(Msg.sMB154); //먼저 저장하십시오.
               return false;
            }
            panelSearch.setValue('DEC_FLAG', 'Y');
            UniAppManager.app.onQueryButtonDown();
            panelSearch.setValue('DEC_FLAG', '');
        }
    });
    
    Unilite.Main({
		id  : 'ham805ukrApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, detailGrid
			]	
		},
			panelSearch
		],
		fnInitBinding: function(){
			//복호화 버튼 툴바에 추가
            var tbar = detailGrid._getToolBar();
            tbar[0].insert(tbar.length + 2, decrypBtn);
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
            activeSForm.onLoadSelectText('PAY_YYYYMM');
        },
        
		onQueryButtonDown: function() {      
			if(!this.isValidSearchForm()) {	//필수체크
				return false;
			}
			
			masterStore.loadStoreRecords();		
		},
		
//		onNewDataButtonDown: function()	{
//			if(!panelResult.getInvalidMessage()) return;	//필수체크
//		
//			 //var dedType    = panelResult.getValue('DED_TYPE')
//        	 ///var payYyyymm  = UniDate.getDbDateStr(panelResult.getValue('PAY_YYYYMM')).substring(0, 6);
//        	 var seq 		= detailGrid.getStore().max('SEQ');
//        	 if(!seq) seq 	= 1;
//        	 else  seq 		+= 1;
//        	 var applyYn    = 'N';
//        	 
//        	 var r = {
//				//DED_TYPE: dedType,
//				//PAY_YYYYMM : payYyyymm,
//				SEQ	: seq,
//				APPLY_YN   : applyYn
//				
//	        };
//			detailGrid.createRow(r);
//		},
		
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
		
			detailGrid.reset();
			masterStore.clearData();

			this.defaultSet();
			UniAppManager.setToolbarButtons('save', false);
		},
    
		onSaveDataButtonDown: function(config) {				
			masterStore.saveStore();
		},
		
		onDeleteDataButtonDown : function()	{										
			var selRow = detailGrid.getSelectedRecord();	
			if(!Ext.isEmpty(selRow)) {	
				if(selRow.phantom == true)	{									
					detailGrid.deleteSelectedRow();									
														
				} else if(Ext.getCmp('applyYn').getChecked()[0].inputValue == 'N'){
					if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {					//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")					
						detailGrid.deleteSelectedRow();
					}
				}
			} else {
				alert('선택된 데이터가 없습니다.');
				return false;
			}
		},											

		onDeleteAllButtonDown: function() {			
			var records = masterStore.data.items;
			var isNewData = false;
			Ext.each(records, function(record,i) {
				if(record.phantom){						//신규 레코드일시 isNewData에 true를 반환
					isNewData = true;
				}else{									//신규 레코드가 아닌게 중간에 나오면 전체 삭제후 저장 로직 실행
					if(confirm('전체삭제 하시겠습니까?')) {
						var deletable = true;
						if(deletable){	
							//if(selRow.data.APPLY_YN == 'N'){
								detailGrid.reset();			
								UniAppManager.app.onSaveDataButtonDown();	
							//}
						}
						isNewData = false;							
					}
					return false;
				}
			});
			if(isNewData){								//신규 레코드들만 있을시 그리드 리셋		   
				detailGrid.reset();
				UniAppManager.app.onResetButtonDown();	//삭제후 RESET..
			}
		}
	});
	
	
	
	Unilite.createValidator('validator01', {
		store: masterStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "PAY_YYYYMM" :		
					if(isNaN(newValue)){
						rv = Msg.sMB074;	//숫자만 입력 가능합니다.
						break;
					}
					if(newValue != oldValue){
						record.set('PAY_YYYYMM_OLD', oldValue);
					}
					break;
					
				case "PERSON_NUMB" :		
					if(newValue != oldValue){
						record.set('PERSON_NUMB_OLD', oldValue);
					}
					break;	
			
			}
			return rv;
		}
	});	
		
	
	
//	function fnCipherRepre(){
//		//var isErr = false;
//		Ext.each(records, function(record, index){
//			if  (!Ext.isEmpty(record.get('REPRE_NUM'))){
//				var params = {
//					INCDRC_GUBUN  : 'INC', 
//					DECRYP_WORD  : record.get('REPRE_NUM')
//				}												
//				popupService.incryptDecryptPopup(params, function(provider, response)	{							
//					if(!Ext.isEmpty(provider)){
//						record.set('REPRE_NUM', provider);
//					}													
//				});	
//			}
//		});
//	}

	
	
	function openExcelWindow() {
			var me = this;
	        var vParam = {};
	        var appName = 'Unilite.com.excel.ExcelUpload';
	        if(!masterStore.isDirty())	{									//화면에 저장할 내용이 있을 경우 저장여부 확인
				masterStore.loadData({});
	        } else {
	        	if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
	        		UniAppManager.app.onSaveDataButtonDown();
	        		return;
	        	}else {
	        		masterStore.loadData({});
	        	}
	        }
//	        if(!panelSearch.getInvalidMessage()) {				//조회조건 입력 조건으로 사용할 경우 주석 해제
//	        	return false;
//	        }
//	        if(!Ext.isEmpty(excelWindow)){						//업로드 시 넘길 데이터 있으면 사용
//	            excelWindow.extParam.PAY_YYYYMM  =  UniDate.getDbDateStr(panelSearch.getValue('PAY_YYYYMM'));	// 귀속년월
//	        }
            if(!excelWindow) {
            	excelWindow =  Ext.WindowMgr.get(appName);
                excelWindow = Ext.create( appName, {
            		modal: false,
            		excelConfigName: 'ham805ukr',
            		width	: 600,
					height	: 200,
            		extParam: { 
	        			'PGM_ID'		: 'ham805ukr'
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
	                            ham805ukrService.getErrMsg(param, function(provider, response){
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
//								ham805ukrService.deleteTemp(param, function(provider, response){});
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
};

</script>