<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="tpl102ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A098" /> <!-- 카드구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A010" /> <!-- 법인/개인구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A004" /> <!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A028" /> <!-- 신용카드회사 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {  
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'templateService.selectMaster',			//조회
			update: 'templateService.updateMaster',			//수정
			create: 'templateService.insertMaster',			//입력
			destroy: 'templateService.deleteMaster',		//삭제
			syncAll: 'templateService.saveAll'				//저장
		}
	});	
	
	
	Unilite.defineModel('Tpl102ukrvModel', {
	    fields: [  
	    /**	   		 
	   		 * type:
	   		 * 		uniQty		   -      수량
			 *		uniUnitPrice   -      단가
			 *		uniPrice	   -      금액(자사화폐)
			 *		uniPercent	   -      백분율(00.00)
			 *		uniFC          -      금액(외화화폐)
			 *		uniER          -      환율
			 *		uniDate        -      날짜(2999.12.31)
			 * maxLength: 입력가능한 최대 길이
			 * editable: true	수정가능 여부
	   		 * allowBlank: 필수 여부
	   		 * defaultValue: 기본값
	   		 * comboType:'AU', comboCode:'B014' : 그리드 콤보 사용시
			*/
	    	{name: 'SEQ'			, text: '순번'					, type: 'int', maxLength: 200, allowBlank: false},							//시퀀스 (editable: false)
	    	{name: 'COL1'			, text: '컬럼1'					, type: 'string', maxLength: 200},											//일반텍스트 Type
	    	{name: 'COL2'			, text: '컬럼2'					, type: 'string', maxLength: 200},											//팝업Type
	    	{name: 'COL3'			, text: '컬럼3'					, type: 'string', maxLength: 200, comboType: 'AU', comboCode: 'M103'},		//콤보박스Type
	    	{name: 'COL4'			, text: '컬럼4'					, type: 'uniDate', maxLength: 200},											//날짜Type
	    	{name: 'COL5'			, text: '컬럼5'					, type: 'uniPrice', maxLength: 200},											//금액Type
//	    	{name: 'tempC1'      	, text: '출고일자' 	,type: 'uniDate'},
//	    	{name: 'tempC2'      	, text: 'No' 		,type: 'int'},
//	    	{name: 'tempC3'      	, text: '구분' 		,type: 'string'},
//	    	{name: 'tempC4'      	, text: '등록번호' 	,type: 'string'},
//	    	{name: 'tempC5'      	, text: '거래처' 		,type: 'string'},
//	    	{name: 'tempC6'      	, text: '품목코드' 	,type: 'string'},
//	    	{name: 'tempC7'      	, text: '품목명' 		,type: 'string'},
//	    	{name: 'tempC8'      	, text: '수량' 		,type: 'uniQty'},
//	    	{name: 'tempC9'      	, text: '단가' 		,type: 'uniUnitPrice'},
//	    	{name: 'tempC10'      	, text: '금액' 		,type: 'uniPrice'},
	    	{name: 'tempC11'      	, text: '선택' 		,type: 'boolean'}
//	    	{name: 'tempC12'      	, text: '확정일자' 	,type: 'uniDate'}
	    	
		]
	});
	
	var directDetailStore = Unilite.createStore('tpl102ukrvMasterStore',{
		model: 'Tpl102ukrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
	        useNavi: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:directProxy,
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			this.load({
				params : param
			});
		},
		saveStore : function()	{	
			var paramMaster= panelSearch.getValues();
			var inValidRecs = this.getInvalidRecords();
        	var rv = true;
			if(inValidRecs.length == 0 )	{
				
				config = {
					params: [paramMaster],
					success: function(batch, option) {
//						directDetailStore.loadStoreRecords();
					}
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
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
				xtype: 'container',
				layout: {type : 'uniTable', columns : 1},
				items :[{
		    		fieldLabel: '출고일자',
				    xtype: 'uniDateRangefield',
				    startFieldName: 'TEMP01',
				    endFieldName: 'TEMP02',
				    startDate: UniDate.get('today'),
					endDate: UniDate.get('today'),       	
		            onStartDateChange: function(field, newValue, oldValue, eOpts) {
		            	if(panelResult) {
							panelResult.setValue('TEMP01', newValue);
						}
		            },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('TEMP02', newValue);				    		
				    	}
				    }
				},
				UniTempPopup.popup('TEMPLATE',{
					fieldLabel: '판매부서', 
//					labelWidth:150,
					valueFieldName:'TEMP03',
				    textFieldName:'TEMP04',
				    listeners: {
				    	onValueFieldChange: function(field, newValue){
							panelResult.setValue('TEMP03', newValue);	
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('TEMP04', newValue);	
						}
					}
				}),
				{
		    		xtype: 'uniCheckboxgroup',		            		
		    		fieldLabel: '확정구분',
		    		items: [{
		    			boxLabel: '확정',
		    			width: 100,
		    			name: 'TEMP05',
		    			listeners: {
				            change: function(field, newValue, oldValue, eOpts) {
				            	panelResult.setValue('TEMP05', newValue);								
				            }
		        		}
		    		},{
		    			boxLabel: '미확정',
		    			width: 100,
		    			name: 'TEMP06',
		    			listeners: {
				            change: function(field, newValue, oldValue, eOpts) {
				            	panelResult.setValue('TEMP06', newValue);								
				            }
		        		}
		    		}]
		        },{
	        		xtype: 'uniCombobox',
					fieldLabel: '출고구분',
					name:'TEMP07',
					listeners: {
			            change: function(field, newValue, oldValue, eOpts) {
			            	panelResult.setValue('TEMP07', newValue);								
			            }
	        		}
				},
				UniTempPopup.popup('TEMPLATE',{
					fieldLabel: '거래처명', 
//					labelWidth:150,
					valueFieldName:'TEMP08',
				    textFieldName:'TEMP09',
				    listeners: {
				    	onValueFieldChange: function(field, newValue){
							panelResult.setValue('TEMP08', newValue);	
						},
						onTextFieldChange: function(field, newValue){
							panelResult.setValue('TEMP09', newValue);	
						}
					}
				}),
				{
					xtype: 'uniDatefield',
		    		fieldLabel: '확정일자',
		    		name: 'TEMP10',
		    		listeners: {
			            change: function(field, newValue, oldValue, eOpts) {
			            	panelResult.setValue('TEMP10', newValue);								
			            }
	        		}
				}]	
			}]
		}]
	});	  
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
    		fieldLabel: '출고일자',
		    xtype: 'uniDateRangefield',
		    startFieldName: 'TEMP01',
		    endFieldName: 'TEMP02',
		    startDate: UniDate.get('today'),
			endDate: UniDate.get('today'),       	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('TEMP01', newValue);
				}
            },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('TEMP02', newValue);				    		
		    	}
		    }
		},
		UniTempPopup.popup('TEMPLATE',{
			fieldLabel: '판매부서', 
//			labelWidth:150,
			valueFieldName:'TEMP03',
		    textFieldName:'TEMP04',
		    listeners: {
		    	onValueFieldChange: function(field, newValue){
					panelSearch.setValue('TEMP03', newValue);	
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('TEMP04', newValue);	
				}
			}
		}),
		{
    		xtype: 'uniCheckboxgroup',		            		
    		fieldLabel: '확정구분',
    		items: [{
    			boxLabel: '확정',
    			width: 100,
    			name: 'TEMP05',
    			listeners: {
		            change: function(field, newValue, oldValue, eOpts) {
		            	panelSearch.setValue('TEMP05', newValue);								
		            }
        		}
    		},{
    			boxLabel: '미확정',
    			width: 100,
    			name: 'TEMP06',
    			listeners: {
		            change: function(field, newValue, oldValue, eOpts) {
		            	panelSearch.setValue('TEMP06', newValue);								
		            }
        		}
    		}]
        },{
    		xtype: 'uniCombobox',
			fieldLabel: '출고구분',
			name:'TEMP07',
			listeners: {
	            change: function(field, newValue, oldValue, eOpts) {
	            	panelSearch.setValue('TEMP07', newValue);								
	            }
    		}
		},
		UniTempPopup.popup('TEMPLATE',{
			fieldLabel: '거래처명', 
//			labelWidth:150,
			valueFieldName:'TEMP08',
		    textFieldName:'TEMP09',
		    listeners: {
		    	onValueFieldChange: function(field, newValue){
					panelSearch.setValue('TEMP08', newValue);	
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('TEMP09', newValue);	
				}
			}
		}),
		{
			xtype: 'uniDatefield',
    		fieldLabel: '확정일자',
    		name: 'TEMP10',
    		listeners: {
	            change: function(field, newValue, oldValue, eOpts) {
	            	panelSearch.setValue('TEMP10', newValue);								
	            }
    		}
		}]
	});	
	
    var masterGrid = Unilite.createGrid('tpl101ukrvGrid', {
        region:'center',
    	store: directDetailStore,
    	excelTitle: '출고전표 확정',
    	flex:1,
    	split:true,
    	tbar: [{
			id: 'tempId1',
			text: '일괄확정',
			handler: function() {
			}
    	},{
			id: 'tempId2',
			text: '일괄취소',
			handler: function() {
			}
    	},{
			id: 'tempId3',
			text: '전체선택',
			handler: function() {
				var records = directDetailStore.data.items;
				
				if(Ext.getCmp('tempId3').getText() == "전체선택"){
					Ext.each(records, function(record, i){
						record.set('tempC11', true);
					})
					Ext.getCmp('tempId3').setText("전체취소");
				}else{
					Ext.each(records, function(record, i){
						record.set('tempC11', false);
					})	
					Ext.getCmp('tempId3').setText("전체선택");
				}
			}
    	}],
        uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: false,
			useMultipleSorting: true,
			useRowNumberer: true,
			expandLastColumn: false,
			onLoadSelectFirst: true,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },//그룹 합계 관련
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],//그룹 합계 관련
        columns:  [
        		{dataIndex: 'SEQ'			, width: 60},
        		{dataIndex: 'COL1'			, width: 120},
        		{dataIndex: 'COL2'			, width: 120, 
				  	editor: UniTempPopup.popup('TEMPLATE_G', {	
				  		DBtextFieldName: 'TEMPLATE_CODE',	//CODE를 조회하는 팝업 일시에는 정의를 해줘야함..	
				   	 	autoPopup:true,						//validator처리후 팝업 자동open 할 것인지 여부..				   	 	
		 				listeners: {'onSelected': {
								fn: function(records, type) {
				                    console.log('records : ', records);
				                    Ext.each(records, function(record,i) {		//팝업창에서 선택된 레코드 처리											                   
					        			if(i==0) {
											masterGrid.uniOpt.currentRecord.set('COL2', record['TMP_CD']);	//masterGrid에 팝업에서 선택된 record를 SET
					        			} else {

					        			}
									}); 
								},
								scope: this
							},
							'onClear': function(type) {
//								masterGrid.setItemData(null,true, masterGrid.uniOpt.currentRecord);
							},
							applyextparam: function(popup){
								var divCode = UserInfo.divCode;
								popup.setExtParam({'DIV_CODE': divCode});
							}
						}
					 })
				},        		
        		{dataIndex: 'COL3'			, width: 120},
        		{dataIndex: 'COL4'			, width: 120},
        		{dataIndex: 'COL5'			, width: 120},
        		{dataIndex: 'tempC11'        	,width: 60, xtype: 'checkcolumn'},
//        	{dataIndex: 'tempC1'         	,width: 100},
//        	{dataIndex: 'tempC2'         	,width: 80},
//        	{dataIndex: 'tempC3'         	,width: 80},
//        	{dataIndex: 'tempC4'         	,width: 100},
//        	{dataIndex: 'tempC5'         	,width: 150},
//        	{dataIndex: 'tempC6'         	,width: 100},
//        	{dataIndex: 'tempC7'         	,width: 200},
//        	{dataIndex: 'tempC8'         	,width: 80},
//        	{dataIndex: 'tempC9'         	,width: 80},
//        	{dataIndex: 'tempC10'        	,width: 100},
        	{dataIndex: 'tempC11'        	,width: 60, xtype: 'checkcolumn'},
//        	{dataIndex: 'tempC12'        	,width: 100}
		],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
//				return false;
			}
		}
    });  
    
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult,masterGrid
			]	
		},
			panelSearch
		],
		id: 'tpl102ukrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset','newData'],true);
			UniAppManager.setToolbarButtons(['save'],false);
			
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('TEMP01');
			
		},
		onQueryButtonDown: function()	{
			directDetailStore.loadStoreRecords();
		},
		onNewDataButtonDown: function()	{
			masterGrid.createRow();
			},
		onResetButtonDown: function() {		
			panelSearch.clearForm();
			masterGrid.reset();
			panelResult.clearForm();
			directDetailStore.clearData();
			this.fnInitBinding();
		},
		onDeleteDataButtonDown: function() {
			masterGrid.deleteSelectedRow();
		},
		onSaveDataButtonDown: function(config) {				
			directDetailStore.saveStore();
		}
	}); 
};


</script>
