<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hpa651skr_yg">
	<t:ExtComboStore comboType="BOR120" />
	<!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {
	color: #333333;
	font-weight: normal;
	padding: 1px 2px;
}
</style>
<script type="text/javascript">
	function appMain() {
		/**
		 *   Model 정의 
		 * @type 
		 */
		Unilite.defineModel('s_hpa651skr_ygModel', {
			fields : [ {
				name : 'DIV_NAME',
				text : '사업장명',
				type : 'string'
			}, {
				name : 'DEPT_NAME',
				text : '부서',
				type : 'string'
			}, {
				name : 'POST_NAME',
				text : '직위',
				type : 'string'
			}, {
				name : 'NAME',
				text : '성명',
				type : 'string'
			}, {
				name : 'PERSON_NUMB',
				text : '사번',
				type : 'string'
			}, {
				name : 'RETR_YN',
				text : '재직구분',
				type : 'string'
			}, {
                name : 'PROV_YEAR',
                text : '발생연차',
                type : 'number'
            }, {
                name : 'REMAINY',
                text : '잔여연차',
                type : 'number'
            }
			, {
				name : '01',
				text : '1월',
				type : 'number'
			}, {
				name : '02',
				text : '2월',
				type : 'number'
			}, {
				name : '03',
				text : '3월',
				type : 'number'
			}, {
				name : '04',
				text : '4월',
				type : 'number'
			}, {
				name : '05',
				text : '5월',
				type : 'number'
			}, {
				name : '06',
				text : '6월',
				type : 'number'
			}, {
				name : '07',
				text : '7월',
				type : 'number'
			}, {
				name : '08',
				text : '8월',
				type : 'number'
			}, {
				name : '09',
				text : '9월',
				type : 'number'
			}, {
				name : '10',
				text : '10월',
				type : 'number'
			}, {
				name : '11',
				text : '11월',
				type : 'number'
			}, {
				name : '12',
				text : '12월',
				type : 'number'
			}]
		});

		// GroupField string type으로 변환
		//function dateToString(v, record){
		//	return UniDate.safeFormat(v);
		// }

		/**
		 * Store 정의(Service 정의)
		 * @type 
		 */
		var directMasterStore = Unilite.createStore('s_hpa651skr_ygMasterStore1', {
			model : 's_hpa651skr_ygModel',
			uniOpt : {
				isMaster : true, // 상위 버튼 연결 
				editable : false, // 수정 모드 사용 
				deletable : false, // 삭제 가능 여부 
				useNavi : false
			// prev | newxt 버튼 사용
			},
			autoLoad : false,
			proxy : {
				type : 'direct',
				api : {
					read : 's_hpa651skr_ygService.selectList'
				}
			},
			loadStoreRecords : function() {
				var param = Ext.getCmp('searchForm').getValues();
				console.log(param);
				this.load({
					params : param
				});
			}
		//	,groupField: 'ITEM_NAME'
		});

		/**
		 * 검색조건 (Search Panel)
		 * @type 
		 */
		var panelSearch = Unilite.createSearchPanel('searchForm', {
			title : '검색조건',
			defaultType : 'uniSearchSubPanel',
			collapsed: UserInfo.appOption.collapseLeftSearch,
	        listeners: {
		        collapse: function () {
		        	panelResult.show();
		        },
		        expand: function() {
		        	panelResult.hide();
		        }
		    },
			items : [{
				title : '기본정보',
				itemId : 'search_panel1',
				layout : {
					type : 'uniTable',
					columns : 1
				},
				defaultType : 'uniTextfield',
				items : [ {
					fieldLabel : '년차년도',					
					xtype : 'uniYearField',
					name : 'DUTY_YYYY',
//					value : new Date().getFullYear(),
					allowBlank : false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DUTY_YYYY', newValue);
						}
					}
				//msgage :'sMH1124'
				}, {
					fieldLabel : '사업장',
					name : 'DIV_CODE',
					xtype : 'uniCombobox',
					comboType : 'BOR120',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
//					inputValue : '01'

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
				}),{
					xtype : 'radiogroup',
					fieldLabel : '구분',
					hidden	: false,
					items : [ {
						boxLabel : '년차',
						width : 70,
						name : 'DUTY_YN',
						inputValue : 'Y',
						checked : true
					}, {
						boxLabel : '월차',
						width : 70,
						name : 'DUTY_YN',
						inputValue : 'N'
					} ],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {				
							panelResult.getField('DUTY_YN').setValue(newValue.DUTY_YN);
						}
					}
				}, {
					xtype : 'radiogroup',
					fieldLabel : '퇴직자포함여부',
					items : [ {
						boxLabel : '포함',
						width : 70,
						name : 'RETR_YN',
						inputValue : ''
					}, {
						boxLabel : '미포함',
						width : 70,
						name : 'RETR_YN',
						inputValue : 'N',
						checked : true
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {				
							panelResult.getField('RETR_YN').setValue(newValue.RETR_YN);
						}
					}
				},			
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
				})]
			}]
		//title	
		}); //end panelSearch  
	
		var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel : '년차년도',			
			xtype : 'uniYearField',
			name : 'DUTY_YYYY',
//					value : new Date().getFullYear(),
			allowBlank : false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DUTY_YYYY', newValue);
				}
			}
		//msgage :'sMH1124'
		}, {
			fieldLabel : '사업장',
			name : 'DIV_CODE',
			xtype : 'uniCombobox',
			comboType : 'BOR120',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
//					inputValue : '01'

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
		}),{
			xtype : 'radiogroup',
			fieldLabel : '구분',
			hidden	: false,
			items : [ {
				boxLabel : '년차',
				width : 70,
				name : 'DUTY_YN',
				inputValue : 'Y',
				checked : true
			}, {
				boxLabel : '월차',
				width : 70,
				name : 'DUTY_YN',
				inputValue : 'N'
			} ],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {				
					panelSearch.getField('DUTY_YN').setValue(newValue.DUTY_YN);
				}
			}
		}, {
			xtype : 'radiogroup',
			fieldLabel : '퇴직자포함여부',
			items : [ {
				boxLabel : '포함',
				width : 70,
				name : 'RETR_YN',
				inputValue : ''
			}, {
				boxLabel : '미포함',
				width : 70,
				name : 'RETR_YN',
				inputValue : 'N',
				checked : true
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {				
					panelSearch.getField('RETR_YN').setValue(newValue.RETR_YN);
				}
			}
		},			
	     	Unilite.popup('Employee',{ 
			
			validateBlank: false,
			listeners: {
//				onSelected: {
//					fn: function(records, type) {
//						panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
//						panelSearch.setValue('NAME', panelResult.getValue('NAME'));
//                	},
//					scope: this
//				},
//				onClear: function(type)	{
//					panelSearch.setValue('PERSON_NUMB', '');
//					panelSearch.setValue('NAME', '');
//				}
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
		
		 var masterGrid = Unilite.createGrid('s_hpa651skr_ygGrid1', {
    	// for tab 
    	region: 'center', 
        layout: 'fit',        
    	store: directMasterStore, 
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
//    	uniOpt: {useRowNumberer: false},
    	features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    				{id : 'masterGridTotal', 	ftype: 'uniSummary',  showSummaryRow: false} ],    	           	
        columns:  [ 

			{
				dataIndex : 'DIV_NAME',
				width : 150,
				text : '사업장명',				
				summaryRenderer : function(value, summaryData, dataIndex, metaData) {
					
					return  Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
				}
			},

			{
				dataIndex : 'DEPT_NAME',
				width : 120,
				text : '부서'
			}, {
				dataIndex : 'POST_NAME',
				width : 100,
				text : '직위'
			}, {
				dataIndex : 'NAME',
				width : 100,
				text : '성명'
			}, {
				dataIndex : 'PERSON_NUMB',
				width : 100,
				text : '사번'
			}, {
				dataIndex : 'RETR_YN',
				width : 100,
				text : '재직구분'

			}, {
                dataIndex : 'PROV_YEAR',
                width : 80,
                text : '발생연차'

            }, {
                dataIndex : 'REMAINY',
                width : 90,
                text : '잔여연차'

            }, {
				dataIndex : '01',
				width : 80,
				text : '1월',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : '02',
				width : 80,
				text : '2월',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : '03',
				width : 80,
				text : '3월',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : '04',
				width : 80,
				text : '4월',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : '05',
				width : 80,
				text : '5월',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : '06',
				width : 80,
				text : '6월',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : '07',
				width : 80,
				text : '7월',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : '08',
				width : 80,
				text : '8월',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : '09',
				width : 80,
				text : '9월',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : '10',
				width : 80,
				text : '10월',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : '22',
				width : 80,
				text : '11월',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : '12',
				width : 80,
				text : '12월',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : 'YEAR_NUM',
				minWidth : 80,
				flex: 1,
				text : '잔여차수',
				summaryType : 'sum',
				align : 'right'
			}
       ]
        			
    });
			Unilite.Main({
				borderItems:[{
				region:'center',
				layout: 'border',
				border: false,
				items:[
					masterGrid, panelResult
				]},
				panelSearch  	
				],
					id : 's_hpa651skr_ygApp',
					fnInitBinding : function() {
						panelSearch.setValue('DIV_CODE', UserInfo.divCode);
						panelResult.setValue('DIV_CODE', UserInfo.divCode);
						panelSearch.setValue('DUTY_YYYY', new Date().getFullYear());
						panelResult.setValue('DUTY_YYYY', new Date().getFullYear());

						UniAppManager.setToolbarButtons('reset', false);
						var activeSForm ;
						if(!UserInfo.appOption.collapseLeftSearch)	{
							activeSForm = panelSearch;
						}else {
							activeSForm = panelResult;
						}
						activeSForm.onLoadSelectText('DUTY_YYYY');
					},

					onQueryButtonDown : function() {
						if(!this.isValidSearchForm()){
							return false;
						}
						var detailform = panelSearch.getForm();
						if (detailform.isValid()) {
							// query 작업
							masterGrid.getStore().loadStoreRecords();
							var viewLocked = masterGrid.getView();
							var viewNormal = masterGrid.getView();					
							viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
							viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
							viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
							viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
						} else {
							var invalid = panelSearch.getForm().getFields()
									.filterBy(function(field) {
										return !field.validate();
									});

							if (invalid.length > 0) {
								r = false;
								var labelText = ''

								if (Ext
										.isDefined(invalid.items[0]['fieldLabel'])) {
									var labelText = invalid.items[0]['fieldLabel']
											+ '은(는)';
								} else if (Ext
										.isDefined(invalid.items[0].ownerCt)) {
									var labelText = invalid.items[0].ownerCt['fieldLabel']
											+ '은(는)';
								}

								// Ext.Msg.alert(타이틀, 표시문구); 
								Ext.Msg.alert('확인', labelText + Msg.sMH1124);
								// validation이 맞지 않는 필드 중 제일 처음 필드에 포커스를 줌
								invalid.items[0].focus();
							}
						}

					}
				});

	};
</script>
