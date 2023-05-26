<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hpa350ukr_KOCIS"  >
	<t:ExtComboStore comboType="BOR120"  /> 									<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> 						<!-- 직위코드 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> 						<!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> 						<!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> 						<!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> 						<!-- 지급일구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H032" opts= '${gsList1}' /> 		<!-- 지급구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H153" /> 						<!-- 마감여부 -->
	<t:ExtComboStore comboType="AU" comboCode="H181" /> 						<!-- 사원그룹 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	var gsList1 = '${gsList1}';
	var colData = ${colData};
// 	console.log(colData);
	var fields = createModelField(colData);
	var columns = createGridColumn(colData);
	

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_hpa350ukrService_KOCIS.selectList',
			update	: 's_hpa350ukrService_KOCIS.updateList',
//			create	: 's_hpa350ukrService_KOCIS.insertDetail',
			destroy	: 's_hpa350ukrService_KOCIS.deleteList',
			syncAll	: 's_hpa350ukrService_KOCIS.saveAll'
		}
	});	
	
	/*   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hp350ukrModel', {
		fields : fields
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	  
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('hp350ukrMasterStore',{
		model: 'Hp350ukrModel',
		uniOpt: {
            isMaster	: true,			// 상위 버튼 연결 
            editable	: true,			// 수정 모드 사용 
            deletable	: true,			// 삭제 가능 여부 
	        useNavi 	: false			// prev | newxt 버튼 사용
        },
        autoLoad		: false,
        proxy			:directProxy,
		loadStoreRecords: function()	{
			var param			= Ext.getCmp('searchForm').getValues();	
				console.log( param );
			this.load({
				params : param
			});
		},
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		console.log("toUpdate",toUpdate);
       		
       		var rv = true;
       		
        	if(inValidRecs.length == 0 )	{										
				config = {
					success: function(batch, option) {								
						panelResult.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);			
					 } 
				};					
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
        listeners : {
			load:function( store, records, successful, operation, eOpts ){
				//조회된 데이터가 있을 때, 합계 보이게 설정 변경
				var viewNormal = masterGrid.getView();
	            if (store.getCount() > 0) {
		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
					Ext.getCmp('searchForm').getForm().findField('PAY_YYYYMM').setReadOnly(true);
					Ext.getCmp('resultForm').getForm().findField('PAY_YYYYMM').setReadOnly(true);
	            	UniAppManager.setToolbarButtons('deleteAll', true);
	            } else {
		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);	
	            }
	        }
	    }
	});
	
	

	/* 검색조건 (Search Panel)
	 * @type 
	 */   
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title : '검색조건',
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
		    items: [{
		        fieldLabel: '기관',
		        name:'DIV_CODE', 
		        id: 'DIV_CODE',
		        xtype: 'uniCombobox', 
		        comboType:'BOR120',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('DIV_CODE', newValue);
			    	}
	     		}
		    },{
	        	fieldLabel: '급여지급년월',
	        	xtype: 'uniMonthfield',
	        	allowBlank:false,
	        	name: 'PAY_YYYYMM',
				value: UniDate.get('startOfMonth'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PAY_YYYYMM', newValue);
					}
				}
	       	},{
		        fieldLabel: '지급구분',
		        name:'SUPP_TYPE', 	
		        id: 'SUPP_TYPE',
		        xtype: 'uniCombobox',
		        comboType: 'AU',
		        comboCode:'H032',
	        	allowBlank:false,
				value: 1,
	        	listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('SUPP_TYPE', newValue);
					}
				}
		    }/*,
			Unilite.treePopup('DEPTTREE',{
				fieldLabel: '부서',
				valueFieldName:'DEPT',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPTS' ,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
//				textFieldWidth:89,
//				textFieldWidth: 159,
				validateBlank:true,
//				width:300,
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
			})*/,
		      	Unilite.popup('Employee',{
		      	fieldLabel : '직원',
			    valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
//			    validateBlank: false,
				listeners: {
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
      		})/*,{
	            fieldLabel: '고용형태',
	            name:'PAY_GUBUN', 	
	            xtype: 'uniCombobox', 
	            comboType:'AU',
	            comboCode:'H011',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('PAY_GUBUN', newValue);
		            	var radio = panelSearch.down('#RADIO');
        				var radio2 = panelResult.down('#RADIO2');
			    		if(panelSearch.getValue('PAY_GUBUN') == '2'){
	            			radio.show();
	            			radio2.show();
			    			radio.setValue('0');
			    			radio2.setValue('0');
			    		} else {
	            			radio.hide();
	            			radio2.hide();
			    			radio.setValue('');
			    			radio2.setValue('');
			    		}
			    	}
	     		}
	        },{
	        	xtype: 'container',
				layout: {type : 'hbox'},
				items :[{
					xtype: 'radiogroup',
					fieldLabel: ' ',
					itemId: 'RADIO',
					labelWidth: 90,
					items: [{
						boxLabel: '전체', 
						width: 50,
						name: 'rdoSelect' , 
						inputValue: '', 
						checked: true
					},{
						boxLabel: '일반',
						width: 50, 
						name: 'rdoSelect' ,
						inputValue: '2'
					},{
						boxLabel: '일용', 
						width: 50, 
						name: 'rdoSelect' ,
						inputValue: '1'					
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('rdoSelect').setValue(newValue.rdoSelect);
						}
					}
				}]
			}*/, {
                fieldLabel: '지급차수',
                name:'PAY_PROV_FLAG', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H031',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('PAY_PROV_FLAG', newValue);
			    	}
	     		}
            }, {
                fieldLabel: '급여지급방식',
                name:'PAY_CODE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H028',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('PAY_CODE', newValue);
			    	}
	     		}
            }/*,{
				xtype: 'radiogroup',		            		
				fieldLabel: '세액계산',
				id: 'TAX_YES',
				name : 'TAX_YES',
				items : [{
					boxLabel: '한다',
					width: 50,
					name : 'TAX_YES',
					checked: true,
					inputValue: 'Y'
				},{
					boxLabel: '안한다',
					width: 60,
					name : 'TAX_YES',
					inputValue: 'N'
				}]
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '고용보험계산',
				id: 'HIRE_YES',
				name : 'HIRE_YES',
				items : [{
					boxLabel: '한다',
					width: 50,
					name : 'HIRE_YES',
					checked: true,
					inputValue: 'Y'
				},{
					boxLabel: '안한다',
					width: 60,
					name : 'HIRE_YES',
					inputValue: 'N'}
			]},{
				xtype: 'radiogroup',		            		
				fieldLabel: '산재보험계산',
				id: 'WORK_YES',
				name : 'WORK_YES',
				items : [{
					boxLabel: '한다',
					width: 50,
					name : 'WORK_YES',
					checked: true,
					inputValue: 'Y'
				},{
					boxLabel: '안한다',
					width: 60,
					name : 'WORK_YES',
					inputValue: 'N',
					listeners: {
						specialkey: function(field, event){
							if(event.getKey() == event.ENTER){
								UniAppManager.app.onQueryButtonDown();
							}
						}
					}
				}]
			}*/]
		}]
	}); //end panelSearch
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			,tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
	        fieldLabel: '기관',
	        name:'DIV_CODE', 
	        xtype: 'uniCombobox', 
	        comboType:'BOR120',
	        tdAttrs: {width: 380},  
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('DIV_CODE', newValue);
		    	}
     		}
	    },{
        	fieldLabel: '급여지급년월',
        	xtype: 'uniMonthfield',
        	allowBlank:false,
        	name: 'PAY_YYYYMM',
			value: UniDate.get('startOfMonth'),
//			colspan: 2,
	        tdAttrs: {width: 380},  
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PAY_YYYYMM', newValue);
				}
			}
       	},{
	        fieldLabel: '지급구분',
	        name:'SUPP_TYPE', 	
	        xtype: 'uniCombobox',
	        comboType: 'AU',
	        comboCode:'H032',
	        tdAttrs: {width: 380},  
        	allowBlank:false,
			value: 1,
        	colspan: 2,
		    listeners: {
				change: function(field, newValue, oldValue, eOpts) {      
					panelSearch.setValue('SUPP_TYPE', newValue);
				}
			}
	    }/*,
    	Unilite.treePopup('DEPTTREE',{
			fieldLabel: '부서',
			valueFieldName:'DEPT',
			textFieldName:'DEPT_NAME' ,
			valuesName:'DEPTS' ,
			DBvalueFieldName:'TREE_CODE',
			DBtextFieldName:'TREE_NAME',
			selectChildren:true,
//			textFieldWidth:89,
//			textFieldWidth: 159,
			validateBlank:true,
//			width:300,
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
		})*/,
	      	Unilite.popup('Employee',{
	      	fieldLabel : '직원',
		    valueFieldName:'PERSON_NUMB',
		    textFieldName:'NAME',
//			validateBlank: false,
//		    valueFieldWidth: 79,
			listeners: {
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
            fieldLabel: '고용형태',
            name:'PAY_GUBUN', 	
            xtype: 'uniCombobox', 
            comboType:'AU',
            comboCode:'H011',
//	        tdAttrs: {width: 250},
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('PAY_GUBUN', newValue);
	            	var radio = panelSearch.down('#RADIO');
    				var radio2 = panelResult.down('#RADIO2');
		    		if(panelResult.getValue('PAY_GUBUN') == '2'){
            			radio.show();
            			radio2.show();
		    			radio.setValue('0');
		    			radio2.setValue('0');
		    		} else {
            			radio.hide();
            			radio2.hide();
		    			radio.setValue('');
		    			radio2.setValue('');
		    		}
		    	}
     		}
        },{
        	xtype: 'container',
			layout: {type : 'hbox'},  
			colspan: 2,
	        tdAttrs: {width: 180},  
			items :[{
				xtype: 'radiogroup',
				fieldLabel: ' ',
				itemId: 'RADIO2',
				labelWidth: 35,
				items: [{
					boxLabel: '전체', 
					width: 60,
					name: 'rdoSelect' , 
					inputValue: '0', 
					checked: true
				},{
					boxLabel: '일반',
					width: 60, 
					name: 'rdoSelect' ,
					inputValue: '2'
				},{
					boxLabel: '일용', 
					width: 60, 
					name: 'rdoSelect' ,
					inputValue: '1'					
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('rdoSelect').setValue(newValue.rdoSelect);
					}
				}
			}]
		}*/,{
            fieldLabel: '지급차수',
            name:'PAY_PROV_FLAG', 	
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'H031',
//			colspan: 2,
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('PAY_PROV_FLAG', newValue);
		    	}
     		}
        }, {
            fieldLabel: '급여지급방식',
            name:'PAY_CODE', 	
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'H028',
			colspan: 3,
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('PAY_CODE', newValue);
		    	}
     		}
        }/*,{
			xtype: 'radiogroup',		            		
			fieldLabel: '세액계산',
			id: 'TAX_YES2',
			name : 'TAX_YES',
			items : [{
				boxLabel: '한다',
				width: 50,
				name : 'TAX_YES',
				checked: true,
				inputValue: 'Y'
			},{
				boxLabel: '안한다',
				width: 60,
				name : 'TAX_YES',
				inputValue: 'N'
			}]
		},{
			xtype: 'radiogroup',		            		
			fieldLabel: '고용보험계산',
			id: 'HIRE_YES2',
			name : 'HIRE_YES',
			items : [{
				boxLabel: '한다',
				width: 50,
				name : 'HIRE_YES',
				checked: true,
				inputValue: 'Y'
			},{
				boxLabel: '안한다',
				width: 60,
				name : 'HIRE_YES',
				inputValue: 'N'}
		]},{
			xtype: 'radiogroup',		            		
			fieldLabel: '산재보험계산',
			id: 'WORK_YES2',
			name : 'WORK_YES',
			items : [{
				boxLabel: '한다',
				width: 50,
				name : 'WORK_YES',
				checked: true,
				inputValue: 'Y'
			},{
				boxLabel: '안한다',
				width: 60,
				name : 'WORK_YES',
				inputValue: 'N',
				listeners: {
					specialkey: function(field, event){
						if(event.getKey() == event.ENTER){
							UniAppManager.app.onQueryButtonDown();
						}
					}
				}
			}]
		}*/]
	});
	
	
	
    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hp350ukrGrid1', {
		layout	: 'fit',
		region	: 'center',
    	store	: masterStore,
		columns : columns,
        uniOpt : {				
			useMultipleSorting	: true,		
	    	useLiveSearch		: false,	
	    	onLoadSelectFirst	: true,			//체크박스모델은 false로 변경
	    	dblClickToEdit		: true,	
	    	useGroupSummary		: false,	
			useContextMenu		: false,	
			useRowNumberer		: true,	
			expandLastColumn	: false,		
			useRowContext		: true,			// rink 항목이 있을경우만 true
	    	filter: {			
				useFilter	: false,	
				autoCreate	: true	
			}			
		},
    	features: [{
    		id: 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary',
    		showSummaryRow: false 
		},{
    		id : 'masterGridTotal', 	
    		ftype: 'uniSummary', 
    		showSummaryRow: false
    	}],
		listeners:{
			beforeedit  : function( editor, e, eOpts ) {
				var record = masterGrid.getSelectedRecord();
				if(record.get('CLOSE_YN') == 'Y'){
						return false;
				} else	{
					if(UniUtils.indexOf(e.field, ['GUBUN', 'SUPP_TYPE', 'CLOSE_YN', 'COMP_CODE', 'DIV_CODE', 'DEPT_CODE', 'DEPT_NAME', 'POST_CODE', 'NAME', 'PERSON_NUMB', 'PAY_YYYYMM', 'JOIN_DATE', 'SUPP_TOTAL_I', 'DED_TOTAL_I', 'REAL_AMOUNT_I'])){
						return false;
					} else {
						return true;
					}
				}
			}
		},
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
      		//menu.showAt(event.getXY());
			return true;
      	},
        uniRowContextMenu:{
			items: [
	            {	text	: '급여조회및조정 보기',   
	            	itemId	: 'linkHpa330ukr',
	            	handler	: function(menuItem, event) {
						var record = masterGrid.getSelectedRecord();
						var param = {
	            			'PGM_ID'		: 's_hpa350ukr_KOCIS',
							'PAY_YYYYMM' 	: panelSearch.getValue('PAY_YYYYMM'),
							'PERSON_NUMB'	: record.data['PERSON_NUMB'],
							'NAME'			: record.data['NAME'],
							'SUPP_TYPE'		: panelSearch.getValue('SUPP_TYPE')
	            		};
	            		masterGrid.gotoHpa330ukr(param);
	            	}
	        	}
	        ]
	    },
		gotoHpa330ukr:function(record)	{
			if(record)	{
		    	var params = record
			}
	  		var rec1 = {data : {prgID : 's_hpa330ukr_KOCIS', 'text':''}};							
			parent.openTab(rec1, '/z_kocis/s_hpa330ukr_KOCIS.do', params);
    	}
    });
    
	Unilite.Main( {
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]	
		}		
		,panelSearch
		], 
		id: 'hp350ukrApp',
		
		fnInitBinding: function() {
//			var radio = panelSearch.down('#RADIO');
//        	var radio2 = panelResult.down('#RADIO2');
//			radio.hide();
//			radio2.hide();
//			radio.setValue('');
//			radio2.setValue('');

			/*masterGrid.on('edit', function(editor, e) {
				var record = e.grid.getSelectionModel().getSelection()[0];
				var supp_type_value = Ext.getCmp('SUPP_TYPE').getValue();
				record.set('GUBUN', 'U');
				record.set('SUPP_TYPE', supp_type_value);
			});*/
			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            
	        if(UserInfo.divCode == "01") {
	            panelSearch.getField('DIV_CODE').setReadOnly(false);
	            panelResult.getField('DIV_CODE').setReadOnly(false);
	        }
	        else {
	            panelSearch.getField('DIV_CODE').setReadOnly(true);
	            panelResult.getField('DIV_CODE').setReadOnly(true);
	        }
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
		
			var activeSForm ;	
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {	
				activeSForm = panelResult;
			}	
			activeSForm.onLoadSelectText('DIV_CODE');
		},
		onQueryButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
				
			} else {			
				// query 작업
				masterGrid.reset();
				var viewNormal = masterGrid.getView();
				viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				masterGrid.getStore().loadStoreRecords();
			}
		},
	
		onDeleteDataButtonDown : function()	{
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onSaveDataButtonDown: function() {
			masterStore.saveStore();
		},
 		onDeleteAllButtonDown : function() {
			Ext.Msg.confirm('삭제', '전체행을 삭제 합니다.\n삭제 하시겠습니까?', function(btn){
				if (btn == 'yes') {
					masterStore.removeAll();
					masterGrid.getStore().sync({						
							success: function(response) {
 								masterGrid.getView().refresh();
				            },
				            failure: function(response) {
 								masterGrid.getView().refresh();
				            }
					});
				}
			});
		} 
	});
	
	
	// Grid 의 summary row의  표시 /숨김 적용
    function setGridSummary(viewable){
    	if (masterStore.getCount() > 0) {
            var viewNormal = masterGrid.getView();
            if (viewable) {
            	viewNormal.getFeature('masterGridTotal').enable();
            	viewNormal.getFeature('masterGridSubTotal').enable();
           } else {
           		viewNormal.getFeature('masterGridTotal').disable();
           		viewNormal.getFeature('masterGridSubTotal').disable();
           }
           viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(viewable);
           viewNormal.getFeature('masterGridTotal').toggleSummaryRow(viewable);
            
           masterGrid.getView().refresh();	
    	}
    }
	
	// 모델 필드 생성
	function createModelField(colData) {
		var fields = [
          	{name: 'GUBUN'				, text: '구분값'			, type:'string', defaultValue: 'D'},
      		{name: 'SUPP_TYPE'			, text: '지급구분'			, type:'string'},
      		{name: 'DIV_CODE'			, text: '기관'				, type:'string', comboType:'BOR120'},
			{name: 'CLOSE_YN'			, text: '개인별마감' 		, type:'string', comboType:'AU', comboCode:'H153'},
		    {name: 'COMP_CODE'			, text: '법인코드' 	  		, type:'string'},
            {name: 'DEPT_CODE'			, text: '부서코드' 	  		, type:'string'},
			{name: 'DEPT_NAME'			, text: '부서명'      	  	, type:'string'},
			{name: 'POST_CODE'			, text: '직위'				, type:'string', comboType:'AU', comboCode:'H005'},
			{name: 'NAME'				, text: '성명'      	  	, type:'string'},
			{name: 'PERSON_NUMB'		, text: '사번'				, type:'string'},
			{name: 'JOIN_DATE'			, text: '입사일'		  	, type:'string'},
			{name: 'PAY_YYYYMM'			, text: '급여지급년월'		, type:'string'},
			{name: 'SUPP_TOTAL_I'		, text: '지급총액'		  	, type:'uniFC'},
			{name: 'DED_TOTAL_I'		, text: '공제총액'		  	, type:'uniFC'},
		    {name: 'REAL_AMOUNT_I'		, text: '실지급액'		  	, type:'uniFC'}
		];
		Ext.each(colData, function(item, index){
	    //    if (index == 0) return ''; 
			fields.push({name: item.WAGES_CODES, text: item.WAGES_NAME, type:'uniFC' }); 	
		});
		console.log(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(colData) {
		var columns = [
/*			{dataIndex: 'GUBUN'						   , locked: false, hidden:true},
			{dataIndex: 'SUPP_TYPE'					   , locked: false, hidden:true},
			{dataIndex: 'COMP_CODE',		width: 100,  locked: false, hidden:true},*/
			{dataIndex: 'CLOSE_YN',			width: 75,   locked: false,
			//원하는 컬럼 위치에 소계, 총계 타이틀 넣는다.
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '합계', '합계');
			}},
			{dataIndex: 'DIV_CODE',			width: 120,  locked: false},
	        {dataIndex: 'DEPT_CODE',		width: 80,   locked: false, hidden : true},
			{dataIndex: 'DEPT_NAME',		width: 100,  locked: false, hidden : true},
			{dataIndex: 'POST_CODE',		width: 80,   locked: false},
			{dataIndex: 'NAME',				width: 120,  locked: false},
			{dataIndex: 'PERSON_NUMB',		width: 80,   locked: false, hidden : true},
//			{dataIndex: 'PAY_YYYYMM',		width: 80,   locked: false, hidden: true},
			{dataIndex: 'JOIN_DATE',		width: 80,   locked: false},
			{dataIndex: 'SUPP_TOTAL_I',		width: 100,  locked: false, align : 'right',	decimalPrecision: 2,	summaryType: 'sum'},
			{dataIndex: 'DED_TOTAL_I',		width: 100,  locked: false, align : 'right',	decimalPrecision: 2,	summaryType: 'sum'},
			{dataIndex: 'REAL_AMOUNT_I',	width: 100,  locked: false, align : 'right',	decimalPrecision: 2,	summaryType: 'sum'}
		];
		Ext.each(colData, function(item, index){
			//if (index == 0) return '';
			columns.push({dataIndex: item.WAGES_CODES,	width: 110, align : 'right',	decimalPrecision: 2,  summaryType: 'sum'});
		});
// 		console.log(columns);
		return columns;
	}
	
	Unilite.createValidator('validator01', {
		store	: masterStore,
		grid	: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			
			var rv = true;
			
			switch(fieldName.substring(0, 9)) {
				case "WAGES_PAY" :
					var sumPay = record.get('SUPP_TOTAL_I') - record.get(fieldName) + newValue;
					record.set(fieldName		, newValue);
					record.set('SUPP_TOTAL_I'	, sumPay);
					record.set('REAL_AMOUNT_I'	, sumPay - record.get('DED_TOTAL_I'));
					return false;
					break;
					
				case "WAGES_DED" :
					var sumDed = record.get('DED_TOTAL_I') - record.get(fieldName) + newValue;
					record.set(fieldName		, newValue);
					record.set('DED_TOTAL_I'	, sumDed);
					record.set('REAL_AMOUNT_I'	, record.get('SUPP_TOTAL_I') - sumDed);
					return false;
					break;
			}
			
			return rv;
		}
	});

};
</script>
