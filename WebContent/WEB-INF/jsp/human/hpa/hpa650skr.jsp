<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa650skr">
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
		Unilite.defineModel('Hpa650skrModel', {
			fields : [ {
				name : 'DIV_NAME',
				text : '<t:message code="system.label.human.division" default="사업장"/>',
				type : 'string'
			}, {
				name : 'DEPT_NAME',
				text : '<t:message code="system.label.human.department" default="부서"/>',
				type : 'string'
			}, {
				name : 'POST_NAME',
				text : '<t:message code="system.label.human.postcode" default="직위"/>',
				type : 'string'
			}, {
				name : 'NAME',
				text : '<t:message code="system.label.human.name" default="성명"/>',
				type : 'string'
			}, {
				name : 'PERSON_NUMB',
				text : '<t:message code="system.label.human.personnumb" default="사번"/>',
				type : 'string'
			}, {
				name : 'TOT_YEAR_NUM',
				text : '<t:message code="system.label.human.totalyeardatenum" default="총연차수"/>',
				type : 'uniQty'
			}, {
				name : '1_MONTH',
				text : '<t:message code="system.label.human.january" default="1월"/>',
				type : 'uniQty'
			}, {
				name : '2_MONTH',
				text : '<t:message code="system.label.human.february" default="2월"/>',
				type : 'uniQty'
			}, {
				name : '3_MONTH',
				text : '<t:message code="system.label.human.march" default="3월"/>',
				type : 'uniQty'
			}, {
				name : '4_MONTH',
				text : '<t:message code="system.label.human.april" default="4월"/>',
				type : 'uniQty'
			}, {
				name : '5_MONTH',
				text : '<t:message code="system.label.human.may" default="5월"/>',
				type : 'uniQty'
			}, {
				name : '6_MONTH',
				text : '<t:message code="system.label.human.june" default="6월"/>',
				type : 'uniQty'
			}, {
				name : '7_MONTH',
				text : '<t:message code="system.label.human.july" default="7월"/>',
				type : 'uniQty'
			}, {
				name : '8_MONTH',
				text : '<t:message code="system.label.human.august" default="8월"/>',
				type : 'uniQty'
			}, {
				name : '9_MONTH',
				text : '<t:message code="system.label.human.september" default="9월"/>',
				type : 'uniQty'
			}, {
				name : '10_MONTH',
				text : '<t:message code="system.label.human.october" default="10월"/>',
				type : 'uniQty'
			}, {
				name : '11_MONTH',
				text : '<t:message code="system.label.human.november" default="11월"/>',
				type : 'uniQty'
			}, {
				name : '12_MONTH',
				text : '<t:message code="system.label.human.december" default="12월"/>',
				type : 'uniQty'
			}, {
				name : 'YEAR_NUM',
				text : '<t:message code="system.label.human.residualnum" default="잔여차수"/>',
				type : 'uniQty'
			}

			]
		});

		// GroupField string type으로 변환
		//function dateToString(v, record){
		//	return UniDate.safeFormat(v);
		// }

		/**
		 * Store 정의(Service 정의)
		 * @type 
		 */
		var directMasterStore = Unilite.createStore('hpa650skrMasterStore1', {
			model : 'Hpa650skrModel',
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
					read : 'hpa650skrService.selectList'
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
			,listeners:{
				load:function( store, records, successful, operation, eOpts )	{
					if(records && records.length > 0){
						masterGrid.setShowSummaryRow(true);
					}
				}
	        }
		});

		/**
		 * 검색조건 (Search Panel)
		 * @type 
		 */
		var panelSearch = Unilite.createSearchPanel('searchForm', {
			title : '<t:message code="system.label.human.searchconditon" default="검색조건"/>',
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
				title : '<t:message code="system.label.human.basisinfo" default="기본정보"/>',
				itemId : 'search_panel1',
				layout : {
					type : 'uniTable',
					columns : 1
				},
				defaultType : 'uniTextfield',
				items : [ {
					fieldLabel : '<t:message code="system.label.human.dutyyyyy" default="년차년도"/>',					
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
					fieldLabel : '<t:message code="system.label.human.division" default="사업장"/>',
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
					fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
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
					fieldLabel : '<t:message code="system.label.human.type" default="구분"/>',
					hidden	: true,
					items : [ {
						boxLabel : '<t:message code="system.label.human.yearsave" default="년차"/>',
						width : 70,
						name : 'DUTY_YN',
						inputValue : 'Y',
						checked : true
					}, {
						boxLabel : '<t:message code="system.label.human.monthcrt" default="월차"/>',
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
					fieldLabel : '<t:message code="system.label.human.incumbenttype" default="재직구분"/>',
					items : [ {
						boxLabel : '<t:message code="system.label.human.whole" default="전체"/>',
						width : 70,
						name : 'RETR_YN',
						inputValue : ''
					}, {
						boxLabel : '<t:message code="system.label.human.incumbent" default="재직"/>',
						width : 70,
						name : 'RETR_YN',
						inputValue : 'N',
						checked : true
					}, {
						boxLabel : '<t:message code="system.label.human.retr" default="퇴사"/>',
						width : 70,
						name : 'RETR_YN',
						inputValue : 'Y'
					} ],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {				
							panelResult.getField('RETR_YN').setValue(newValue.RETR_YN);
						}
					}
				},			
			     	Unilite.popup('Employee',{ 
					
					validateBlank: false,
					listeners: {
//						onSelected: {
//							fn: function(records, type) {
//								panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
//								panelResult.setValue('NAME', panelSearch.getValue('NAME'));
//		                	},
//							scope: this
//						},
						onClear: function(type)	{
							panelResult.setValue('PERSON_NUMB', '');
							panelResult.setValue('NAME', '');
							panelSearch.setValue('PERSON_NUMB', '');
                            panelSearch.setValue('NAME', '');
						},
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
			fieldLabel : '<t:message code="system.label.human.dutyyyyy" default="년차년도"/>',			
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
			fieldLabel : '<t:message code="system.label.human.division" default="사업장"/>',
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
			fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
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
			fieldLabel : '<t:message code="system.label.human.type" default="구분"/>',
			hidden	: true,
			items : [ {
				boxLabel : '<t:message code="system.label.human.yearsave" default="년차"/>',
				width : 70,
				name : 'DUTY_YN',
				inputValue : 'Y',
				checked : true
			}, {
				boxLabel : '<t:message code="system.label.human.monthcrt" default="월차"/>',
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
			fieldLabel : '<t:message code="system.label.human.incumbenttype" default="재직구분"/>',
			items : [ {
				boxLabel : '<t:message code="system.label.human.whole" default="전체"/>',
				width : 70,
				name : 'RETR_YN',
				inputValue : ''
			}, {
				boxLabel : '<t:message code="system.label.human.incumbent" default="재직"/>',
				width : 70,
				name : 'RETR_YN',
				inputValue : 'N',
				checked : true
			}, {
				boxLabel : '<t:message code="system.label.human.retr" default="퇴사"/>',
				width : 70,
				name : 'RETR_YN',
				inputValue : 'Y'
			} ],
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
                onClear: function(type) {
                      panelResult.setValue('PERSON_NUMB', '');
                      panelResult.setValue('NAME', '');
                      panelSearch.setValue('PERSON_NUMB', '');
                      panelSearch.setValue('NAME', '');
                },
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
		
		 var masterGrid = Unilite.createGrid('sco300skrvGrid1', {
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
				text : '<t:message code="system.label.human.division" default="사업장"/>',				
				summaryRenderer : function(value, summaryData, dataIndex, metaData) {
					
					return  Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.human.subtotal" default="소계"/>', '<t:message code="system.label.human.total" default="총계"/>');
				}
			},

			{
				dataIndex : 'DEPT_NAME',
				width : 80,
				text : '<t:message code="system.label.human.department" default="부서"/>'
			}, {
				dataIndex : 'POST_NAME',
				width : 80,
				text : '<t:message code="system.label.human.postcode" default="직위"/>'
			}, {
				dataIndex : 'NAME',
				width : 80,
				text : '<t:message code="system.label.human.name" default="성명"/>'
			}, {
				dataIndex : 'PERSON_NUMB',
				width : 90,
				text : '<t:message code="system.label.human.personnumb" default="사번"/>'
			}, {
				dataIndex : 'TOT_YEAR_NUM',
				width : 80,
				text : '<t:message code="system.label.human.totalyeardatenum" default="총연차수"/>',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : '1_MONTH',
				width : 80,
				text : '<t:message code="system.label.human.january" default="1월"/>',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : '2_MONTH',
				width : 80,
				text : '<t:message code="system.label.human.february" default="2월"/>',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : '3_MONTH',
				width : 80,
				text : '<t:message code="system.label.human.march" default="3월"/>',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : '4_MONTH',
				width : 80,
				text : '<t:message code="system.label.human.april" default="4월"/>',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : '5_MONTH',
				width : 80,
				text : '<t:message code="system.label.human.may" default="5월"/>',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : '6_MONTH',
				width : 80,
				text : '<t:message code="system.label.human.june" default="6월"/>',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : '7_MONTH',
				width : 80,
				text : '<t:message code="system.label.human.july" default="7월"/>',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : '8_MONTH',
				width : 80,
				text : '<t:message code="system.label.human.august" default="8월"/>',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : '9_MONTH',
				width : 80,
				text : '<t:message code="system.label.human.september" default="9월"/>',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : '10_MONTH',
				width : 80,
				text : '<t:message code="system.label.human.october" default="10월"/>',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : '11_MONTH',
				width : 80,
				text : '<t:message code="system.label.human.november" default="11월"/>',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : '12_MONTH',
				width : 80,
				text : '<t:message code="system.label.human.december" default="12월"/>',
				summaryType : 'sum',
				align : 'right'
			}, {
				dataIndex : 'YEAR_NUM',
				minWidth : 80,
				flex: 1,
				text : '<t:message code="system.label.human.residualnum" default="잔여차수"/>',
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
					id : 'hpa650skrApp',
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
							masterGrid.reset();
							masterGrid.getStore().loadStoreRecords();
							
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
								Ext.Msg.alert('<t:message code="system.label.human.confirm" default="확인"/>', labelText + '<t:message code="system.message.human.message081" default="년차년도 필수 입력항목입니다."/>');
								// validation이 맞지 않는 필드 중 제일 처음 필드에 포커스를 줌
								invalid.items[0].focus();
							}
						}

					}
				});

	};
</script>
