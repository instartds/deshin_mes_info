<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hpa950skr_KOCIS"  >
		<t:ExtComboStore comboType="AU" comboCode="B027" />								<!-- 제조/판관 -->
		<t:ExtComboStore comboType="AU" comboCode="H005" />								<!-- 직위 -->
		<t:ExtComboStore comboType="AU" comboCode="H011" />								<!-- 고용형태 -->
		<t:ExtComboStore comboType="AU" comboCode="H024" />								<!-- 사원구분 -->
		<t:ExtComboStore comboType="AU" comboCode="H028" />								<!-- 급여지급방식 -->
		<t:ExtComboStore comboType="AU" comboCode="H031" /> 							<!-- 지급차수 -->
		<t:ExtComboStore comboType="AU" comboCode="H032" />								<!-- 지급구분 -->
		<t:ExtComboStore comboType="AU" comboCode="H173" />								<!-- 직렬 -->
		<t:ExtComboStore comboType="AU" comboCode="H181" />								<!-- 사원그룹 -->
		<t:ExtComboStore comboType="BOR120"  />											<!-- 사업장 --> 
		<t:ExtComboStore comboType="BOR120"  comboCode="BILL" />						<!-- 신고사업장 -->
		<t:ExtComboStore items="${COMBO_HUMAN_COST_POOL}" storeId="getHumanCostPool" />	<!--차수-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	colData = ${colData};
	var fields	= createModelField(colData);
	var columns	= createGridColumn(colData);
	var	getCostPoolName = Ext.isEmpty(${getCostPoolName}) ? []: ${getCostPoolName} ;

    var gsKeyValue = "";
		
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hpa950skrModel', {
		fields : fields
	});
	
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('hpa950skrMasterStore',{
		model: 'Hpa950skrModel',
		uniOpt: {
           	isMaster	: true,				// 상위 버튼 연결 
            editable	: false,			// 수정 모드 사용 
            deletable	: false,			// 삭제 가능 여부 
	        useNavi		: false				// prev | newxt 버튼 사용
	            	
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
                read: 's_hpa950skrService_KOCIS.selectList'                	
            }
        }/*,
		listeners : {
	        load : function(store) {
	            if (store.getCount() > 0) {
	            	UniAppManager.setToolbarButtons('excel',true);
	            	UniAppManager.setToolbarButtons('print',true);
	            }
	        }
	    }*/,
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			param.KEY_VALUE = gsKeyValue;
			console.log( param );
			this.load({
				params : param
			});
		}/*,
		listeners: {
          	load: function(store, records, successful, eOpts) {
          		Ext.each(records, function(record, rowIndex){
	          		if(record.get('GUBUN') == '2') {								
						record.set('PERSON_NUMB', null);								
						record.set('DIV_CODE', null);
					}
					if(record.get('GUBUN') == '3'){
						record.set('PERSON_NUMB', null);								
					}
          		})
				masterStore.commitChanges();
				UniAppManager.setToolbarButtons('save', false);
			}
      	}*/
      	//,	groupField: 'DEPT_CODE'
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
	        	fieldLabel: '귀속년월', 
				xtype: 'uniMonthRangefield',   
				startFieldName: 'DATE_FR',
				endFieldName: 'DATE_TO',
				allowBlank: false,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('DATE_FR', newValue);	
						UniAppManager.app.fnSetToDate(newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DATE_TO', newValue);				    		
			    	}
			    }
	        }/*,{
		        fieldLabel: '지급구분',
		        name:'SUPP_TYPE', 	
		        xtype: 'uniCombobox',
		        comboType: 'AU',
		        comboCode:'H032',
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('SUPP_TYPE', newValue);
					}
				}
		    }*/,{
		        fieldLabel: '기관',
		        name:'DIV_CODE', 
		        xtype: 'uniCombobox', 
		        comboType:'BOR120',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('DIV_CODE', newValue);
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
				textFieldWidth: 159,
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
			}),{
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
            },{
                fieldLabel: '지급차수',
                name:'PAY_DAY_FLAG', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H031',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('PAY_DAY_FLAG', newValue);
			    	}
	     		}
            }*//*,{
	            fieldLabel: '고용형태',
	            name:'PAY_GUBUN', 	
	            xtype: 'uniCombobox', 
	            comboType:'AU',
	            comboCode:'H011',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('PAY_GUBUN', newValue);
		            	var radio2 = panelSearch.down('#RADIO2');
        				var radio3 = panelResult.down('#RADIO3');
			    		if(panelSearch.getValue('PAY_GUBUN') == '2'){
	            			radio2.show();
	            			radio3.show();
			    			radio2.setValue('0');
			    			radio3.setValue('0');
			    		} else {
	            			radio2.hide();
	            			radio3.hide();
			    			radio2.setValue('');
			    			radio3.setValue('');
			    		}
			    	}
	     		}
	        },{
	        	xtype: 'container',
				layout: {type : 'hbox'},
				items :[{
					xtype: 'radiogroup',
					fieldLabel: ' ',
					itemId: 'RADIO2',
					labelWidth: 90,
					items: [{
						boxLabel: '전체', 
						width: 50,
						name: 'rdoSelect2' , 
						inputValue: '', 
						checked: true
					},{
						boxLabel: '일반',
						width: 50, 
						name: 'rdoSelect2' ,
						inputValue: '2'
					},{
						boxLabel: '일용', 
						width: 50, 
						name: 'rdoSelect2' ,
						inputValue: '1'					
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('rdoSelect2').setValue(newValue.rdoSelect2);
						}
					}
				}]
			}*/,
		      	Unilite.popup('Employee',{
		      	fieldLabel : '직원',
			    valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
//			    validateBlank: false,
			    valueFieldWidth: 79,
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
                fieldLabel: '사업명',				//COST_POOL
                name:'COST_POOL', 	
                xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('getHumanCostPool'),
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('COST_POOL', newValue);
			    	}
	     		}
            },{
                fieldLabel: '사원구분',
                name:'EMPLOY_TYPE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H024',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('EMPLOY_TYPE', newValue);
			    	}
	     		}
            }*/
            /*,{
				fieldLabel: ' ',
				name: '',
				xtype: 'uniCheckboxgroup', 
				items: [{
		        	boxLabel: '개인별합계표기여부',
		        	name: 'CHECKBOX',
		        	uncheckedValue: 'N',
	        		inputValue: 'Y',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('CHECKBOX', newValue);
						}
					}
				}]
            }*/]
        }/*,{     
			title: '추가정보',   
			itemId: 'search_panel2',
			layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
	        items: [{
   				xtype: 'radiogroup',
   				fieldLabel: '재직구분',
   				id: 'rdoSelect1',
   				labelWidth: 90,
   				items: [{
   					boxLabel: '전체', 
   					width: 50,
   					name: 'rdoSelect1' , 
   					inputValue: '0', 
   					checked: true
   				},{
   					boxLabel: '재직',
   					width: 50, 
   					name: 'rdoSelect1' ,
   					inputValue: '1'
   				},{
   					boxLabel: '퇴사', 
   					width: 50, 
   					name: 'rdoSelect1' ,
   					inputValue: '2'					
   				}]
            },{
                fieldLabel: '사원그룹',
                name:'PERSON_GROUP', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H181'
            },{
                fieldLabel: '직렬',
                name:'AFFILE_CODE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H173'
            },{
	        	fieldLabel: '지급일', 
				xtype: 'uniDateRangefield',   
				startFieldName: 'SUPP_DATE_FR',
				endFieldName: 'SUPP_DATE_TO'
            },{
                fieldLabel: '제조/판관',
                name:'MAKE_SALE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'B027'
            },{
				fieldLabel: '신고기관',
				name:'BILL_DIV_CODE', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				comboCode: 'BILL'
			}]
		}*/],
		setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
					return !field.validate();
				});
   	   			if(invalid.length > 0) {
					r=false;
	  				var labelText = ''
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
	   					var labelText = invalid.items[0]['fieldLabel']+'은(는)';
	   				} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
	   					var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
	   				}
			   		alert(labelText+Msg.sMB083);
					invalid.items[0].focus();
				} else {
					//this.mask();		    
	   			}
		  	} else {
  				this.unmask();
  			}
			return r;
  		}
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
        	fieldLabel: '귀속년월', 
			xtype: 'uniMonthRangefield',   
			startFieldName: 'DATE_FR',
			endFieldName: 'DATE_TO',
			width: 370,  	
	        tdAttrs: {width: 350}, 
			allowBlank: false,   
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('DATE_FR', newValue);	
					UniAppManager.app.fnSetToDate(newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('DATE_TO', newValue);				    		
		    	}
		    }
        }/*,{
	        fieldLabel: '지급구분',
	        name:'SUPP_TYPE', 	
	        xtype: 'uniCombobox',
	        comboType: 'AU',
	        comboCode:'H032',
	        tdAttrs: {width: 400},  
		    listeners: {
				change: function(field, newValue, oldValue, eOpts) {      
					panelSearch.setValue('SUPP_TYPE', newValue);
				}
			}
	    }*/,{
	        fieldLabel: '기관',
	        name:'DIV_CODE', 
	        xtype: 'uniCombobox', 
	        comboType:'BOR120',        	
	        tdAttrs: {width: 350},  
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('DIV_CODE', newValue);
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
			textFieldWidth: 159,
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
		}),{
            fieldLabel: '급여지급방식',
            name:'PAY_CODE', 	
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'H028',
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('PAY_CODE', newValue);
		    	}
     		}
        },{
            fieldLabel: '지급차수',
            name:'PAY_DAY_FLAG', 	
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'H031',
            colspan: 2,
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('PAY_DAY_FLAG', newValue);
		    	}
     		}
        }*//*,{
			xtype: 'container',
			layout: {type : 'uniTable'},
			items :[{
	            fieldLabel: '고용형태',
	            name:'PAY_GUBUN', 	
	            xtype: 'uniCombobox', 
	            comboType:'AU',
	            comboCode:'H011',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelSearch.setValue('PAY_GUBUN', newValue);
		            	var radio2 = panelSearch.down('#RADIO2');
        				var radio3 = panelResult.down('#RADIO3');
			    		if(panelResult.getValue('PAY_GUBUN') == '2'){
	            			radio2.show();
	            			radio3.show();
			    			radio2.setValue({rdoSelect2 : '0'});
							radio3.setValue({rdoSelect2 : '0'});
						} else {
	            			radio2.hide();
	            			radio3.hide();
			    			radio2.setValue({rdoSelect2 : ''});
			    			radio3.setValue({rdoSelect2 : ''});
			    		}
			    	}
	     		}
	        },{
				xtype: 'container',
				layout: {type : 'hbox'},
				width: 145,
				items :[{
					xtype: 'radiogroup',
					fieldLabel: '',
					itemId: 'RADIO3',
					labelWidth: 90,
					items: [{
						boxLabel: '전체', 
						width: 50,
						name: 'rdoSelect2' , 
						inputValue: '', 
						checked: true
					},{
						boxLabel: '일반',
						width: 50, 
						name: 'rdoSelect2' ,
						inputValue: '2'
					},{
						boxLabel: '일용', 
						width: 50, 
						name: 'rdoSelect2' ,
						inputValue: '1'					
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.getField('rdoSelect2').setValue(newValue.rdoSelect2);
						}
					}
				}]
	        }]
		}*/,
	      	Unilite.popup('Employee',{
	      	fieldLabel : '직원',
		    valueFieldName:'PERSON_NUMB',
		    textFieldName:'NAME',
//		    validateBlank: false,
		    valueFieldWidth: 79,
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
            fieldLabel: '사업명',				//COST_POOL
            name:'COST_POOL', 	
            xtype: 'uniCombobox', 
			store: Ext.data.StoreManager.lookup('getHumanCostPool'),
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('COST_POOL', newValue);
		    	}
     		}
        },{
            fieldLabel: '사원구분',
            name:'EMPLOY_TYPE', 	
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'H024',
//            colspan: 2,
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('EMPLOY_TYPE', newValue);
		    	}
     		}
        }*/
        /*,{
			fieldLabel: ' ',
			name: '',
			xtype: 'uniCheckboxgroup', 
			items: [{
	        	boxLabel: '개인별합계표기여부',
	        	name: 'CHECKBOX',
	        	uncheckedValue: 'N',
        		inputValue: 'Y',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('CHECKBOX', newValue);
					}
				}
			}]
        }*/]
	});

	/* Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hpa950skrGrid1', {
    	region	: 'center',
    	store	: masterStore,
        columns	: columns,
        selModel: 'rowmodel',
        uniOpt: {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		dblClickToEdit		: false,
    		onLoadSelectFirst	: false, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
			useRowContext 		: true,
    		filter: {
				useFilter		: false,
				autoCreate		: false
			}
        },
        features: [{
        	id: 'masterGridSubTotal',
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: false 
        },{
	        id: 'masterGridTotal', 	
	        ftype: 'uniSummary', 
	        showSummaryRow: false
        }],
        listeners: {
        	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
	        	view.ownerGrid.setCellPointer(view, item);
        	}
        },
		onItemcontextmenu:function( menu, grid, record, item, index, event  )	{          		
    		//조건에 맞는 링크만 보이게 하기 위해 초기에는 다 숨김 처리
			var param = {
				MAIN_CODE: 'H032',
				SUB_CODE: record.get('SUPP_TYPE'),
				field:'refCode1'
			};
			var sPaycode = UniHuman.fnGetRefCode(param);
    		if(record.get('SUPP_TYPE') == '1' || sPaycode == '1'){
	      		menu.down('#linkHpa610ukr').hide();
	      		menu.down('#linkHbo220ukr').hide();
	      		
				menu.down('#linkHpa330ukr').show();
	      		
    		} else if (record.get('SUPP_TYPE') == 'F'){
				menu.down('#linkHpa330ukr').hide();
	      		menu.down('#linkHbo220ukr').hide();
	      		
	      		menu.down('#linkHpa610ukr').show();
    		} else {
				menu.down('#linkHpa330ukr').hide();
	      		menu.down('#linkHpa610ukr').hide();
	      		
	      		menu.down('#linkHbo220ukr').show();
    		}
      		//menu.showAt(event.getXY());
      		return true;
			
      	},
        uniRowContextMenu:{
			items: [
	            {	text	: '급여조회및조정 보기',   
	            	itemId	: 'linkHpa330ukr',
	            	handler	: function(menuItem, event) {
	            		var param = menuItem.up('menu');
	            		masterGrid.gotoHpa330ukr(param.record);
	            	}
	        	},{	text	: '년월차조회및조정 보기',   
	            	itemId	: 'linkHpa610ukr',
	            	handler	: function(menuItem, event) {
						var param = {
	            			'PGM_ID'		: 'hpa350ukr',
							'PAY_YYYYMM' 	: record.data['PAY_YYYYMM'],
							'PERSON_NUMB'	: record.data['PERSON_NUMB'],
							'NAME'			: record.data['NAME'],
							'SUPP_TYPE'		: record.data['SUPP_TYPE']
	            		};
	            		masterGrid.gotoHpa610ukr(param);
	            	}
	        	},{	text	: '상여조회및조정 보기',   
	            	itemId	: 'linkHbo220ukr',
	            	handler	: function(menuItem, event) {
						var param = {
	            			'PGM_ID'		: 'hpa350ukr',
							'PAY_YYYYMM' 	: record.data['PAY_YYYYMM'],
							'PERSON_NUMB'	: record.data['PERSON_NUMB'],
							'NAME'			: record.data['NAME'],
							'SUPP_TYPE'		: record.data['SUPP_TYPE']
	            		};
	            		masterGrid.gotoHbo220ukr(param);
	            	}
	        	}
	        ]
	    },
		gotoHpa330ukr:function(record)	{
			if(record)	{
				var params = {
        			'PGM_ID'		: 's_hpa950skr_KOCIS',
					'PAY_YYYYMM' 	: record.data['PAY_YYYYMM'],
					'PERSON_NUMB'	: record.data['PERSON_NUMB'],
					'NAME'			: record.data['NAME'],
					'SUPP_TYPE'		: record.data['SUPP_TYPE']
        		};
			}
	  		var rec1 = {data : {prgID : 's_hpa330ukr_KOCIS', 'text':''}};							
			parent.openTab(rec1, '/z_kocis/s_hpa330ukr_KOCIS.do', params);
    	},
		gotoHpa610ukr:function(record)	{
			if(record)	{
		    	var params = record
		    	params.data.PGM_ID = 's_hpa950skr_KOCIS';
			}
	  		var rec1 = {data : {prgID : 'hpa610ukr', 'text':''}};							
			parent.openTab(rec1, '/human/hpa610ukr.do', params);
    	},
		gotoHbo220ukr:function(record)	{
			if(record)	{
		    	var params = record
		    	params.data.PGM_ID = 's_hpa950skr_KOCIS';
			}
	  		var rec1 = {data : {prgID : 'hbo220ukr', 'text':''}};							
			parent.openTab(rec1, '/human/hbo220ukr.do', params);
    	},
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	          	if(record.get('GUBUN') == '3'){
	          		//배경색(dark), 글자색(blue)
					cls = 'x-change-cell_Background_dark_Text_blue';
					
				} else if(record.get('GUBUN') == '2') {
					cls = 'x-change-cell_normal';
				}
				return cls;
	        }
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
		},
			panelSearch
		], 
		id : 'hpa950skrApp',
		fnInitBinding : function() {
//        	var radio2 = panelSearch.down('#RADIO2');
//        	var radio3 = panelResult.down('#RADIO3');
//			radio2.hide();
//			radio3.hide();
//			radio2.setValue('');
//			radio3.setValue('');
            
	        if(UserInfo.divCode == "01") {
	            panelSearch.getField('DIV_CODE').setReadOnly(false);
	            panelResult.getField('DIV_CODE').setReadOnly(false);
	        }
	        else {
	            panelSearch.getField('DIV_CODE').setReadOnly(true);
	            panelResult.getField('DIV_CODE').setReadOnly(true);
	        }            
			
//			if(!Ext.isEmpty(getCostPoolName)){
//				panelSearch.getField('COST_POOL').setFieldLabel(getCostPoolName[0].REF_CODE2);  			
//				panelResult.getField('COST_POOL').setFieldLabel(getCostPoolName[0].REF_CODE2);
//			}
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			
			panelSearch.setValue('DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('DATE_TO',UniDate.get('today'));
			
			panelResult.setValue('DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('DATE_TO',UniDate.get('today'));
			
			
						//startDate: UniDate.get('startOfMonth'),
			//endDate: UniDate.get('today'),
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
		},
		checkForNewDetail:function() {
			return panelSearch.setAllFieldsReadOnly(true);
        },
		onQueryButtonDown : function()	{			
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{			
				masterGrid.reset();
				masterStore.clearData();
				
				//그리드 컬럼명 조회하여 세팅하는 부분
				var param = Ext.getCmp('searchForm').getValues();
				s_hpa950skrService_KOCIS.selectColumns2(param, function(provider, response) {
					var records = response.result;
					
					gsKeyValue = records[0].KEY_VALUE;
                    
					//그리드 컬럼명 조건에 맞게 재 조회하여 입력
					var newColumns = createGridColumn(records);
					masterGrid.setConfig('columns',newColumns);
					
					masterGrid.getStore().loadStoreRecords();
//					if(!Ext.isEmpty(getCostPoolName)){
//						masterGrid.getColumn('COST_POOL').setText(getCostPoolName[0].REF_CODE2);
//					}
				});
				
				UniAppManager.setToolbarButtons('reset',true);
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterStore.clearData();
			this.fnInitBinding();
		},
		onSaveAsExcelButtonDown :function() {
			masterGrid.downloadExcelXml(false, '타이틀');
			masterGrid.getStore().groupField = null;
			masterGrid.getStore().load();
		},
		onPrintButtonDown : function() {
			//do something!!
		},
		fnSetToDate:function(newValue) {
			if(newValue == null){
				return false;
			}else{
				panelSearch.setValue('DATE_TO', newValue);
		    	panelResult.setValue('DATE_TO', newValue);
			}
		}
	});
	
	// 모델 필드 생성
	function createModelField(colData) {
		var fields = [
						{name: 'GUBUN'				, type: 'string'},
						{name: 'DIV_CODE'			, type: 'string'},
					    {name: 'DEPT_CODE'			, type: 'string'},
					    {name: 'DEPT_NAME'			, type: 'string'},
					    {name: 'JOIN_DATE'			, type: 'uniDate'},
						{name: 'POST_CODE'			, type: 'string'},
						{name: 'POST_NAME'			, type: 'string'},
					    {name: 'NAME'				, type: 'string'},
					    {name: 'PERSON_NUMB'		, type: 'string'},
					    {name: 'PAY_YYYYMM'			, type: 'string'},
					    {name: 'SUPP_NAME'			, type: 'string'},
					    {name: 'SUPP_DATE'			, type: 'uniDate'},
					    {name: 'SUPP_TYPE'			, type: 'string', comboType:'AU', comboCode:'H032'},
//					    {name: 'ABIL_NAME'			, type: 'string'},
				    	{name: 'SUPP_TOTAL_I'		, type: 'uniPrice'},
					    {name: 'DED_TOTAL_I'		, type: 'uniPrice'},
					    {name: 'REAL_AMOUNT_I'		, type: 'uniPrice'},
					    {name: 'BUSI_SHARE_I'		, type: 'uniPrice'},
					    {name: 'WORKER_COMPEN_I'	, type: 'uniPrice'},
					    {name: 'COST_POOL'			, type: 'string' },
						{name: 'OFFICE_NAME'		, type: 'string' },
						{name: 'SEX_NAME'			, type: 'string' },
						{name: 'EMPLOY_TYPE'		, type: 'string' },
						{name: 'PAY_CODE'			, type: 'string' },
						{name: 'SECT_CODE'			, type: 'string' }
					];
					
		for (var i = 0; i < 60; i++){
			var name = i < 40 ? 'S'+(i + 1) : 'D'+(i - 39) 
			fields.push({name: name, type:'uniPrice' });
		}
		console.log(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(colData) {
		var columns = [
   			{dataIndex:'GUBUN',				width: 100		, text: '구분'		, locked: false		, sortable: false	, hidden: true}, 				
   			{dataIndex:'DIV_CODE',			width: 150		, text: '기관'		, locked: false		, sortable: false	, id: 'a1'	, style: 'text-align: center',
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(record.get('GUBUN') == '2') {	
						return '합계';
					} else {
						return val;
					}
	            }
			}, 				
			{dataIndex:'DEPT_CODE',			width: 100		, text: '부서코드'		, locked: false		, sortable: false	, hidden: true},
			{dataIndex:'DEPT_NAME',			width: 100		, text: '부서'		, locked: false		, sortable: false	, hidden: true, style: 'text-align: center'/*	, summaryType: 'totaltext'*/},
			{dataIndex:'POST_CODE',			width: 100		, text: '직위코드'		, locked: false		, sortable: false	, hidden: true},
			{dataIndex:'POST_NAME',			width: 100		, text: '직위'		, locked: false		, sortable: false	, style: 'text-align: center'},				
			{dataIndex:'NAME',				width: 100		, text: '성명'		, locked: false		, sortable: false	, style: 'text-align: center'},				
			{dataIndex:'PERSON_NUMB',		width: 100		, text: '사번'		, locked: false		, sortable: false	, hidden: true, style: 'text-align: center',
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(record.get('GUBUN') == '2' || record.get('GUBUN') == '3') {	
						return '합계';
					} else {
						return val;
					}
	            }
			}, 				
			Ext.applyIf({dataIndex:'JOIN_DATE',			width: 100		, text: '입사일'		, locked: false		, sortable: false}, {align: 'center', xtype: 'uniDateColumn' }),				
			{dataIndex:'PAY_YYYYMM',		width: 100		, text: '귀속년월'		, locked: false		, align: 'center'},				
			{dataIndex:'SUPP_NAME',			width: 100		, text: '지급구분'		, locked: false		, style: 'text-align: center'},				
			Ext.applyIf({dataIndex:'SUPP_DATE',			width: 100		, text: '지급일'		}, {align: 'center', xtype: 'uniDateColumn' }),				
			{dataIndex:'SUPP_TYPE',			width: 100		, text: '지급구분코드'	, locked: false		, hidden: true},
//			{dataIndex:'ABIL_NAME',			width: 100		, text: '직책'							, style: 'text-align: center'		},				
			Ext.applyIf({dataIndex:'SUPP_TOTAL_I',		width: 100		, text: '지급총액'				, style: 'text-align: center'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }),				
			Ext.applyIf({dataIndex:'DED_TOTAL_I',		width: 100		, text: '공제총액'				, style: 'text-align: center'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }),				
			Ext.applyIf({dataIndex:'REAL_AMOUNT_I',		width: 100		, text: '실지급액'				, style: 'text-align: center',
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    return '<span style= "color:' + 'blue' + '">' + Ext.util.Format.number(val,'0,000') + '</span>';
	            }
			}																						, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }),				
			Ext.applyIf({dataIndex:'BUSI_SHARE_I',		width: 110		, text: '사회보험부담금'	, hidden: true}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }),				
			Ext.applyIf({dataIndex:'WORKER_COMPEN_I',	width: 110		, text: '산재보험부담금'	, hidden: true}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price })
		];
		//참고 - S1 : 기본급
		Ext.each(colData, function(item, index){
//			if (index == 0) return '';
			var dataIndex = index < 40 ? 'S'+(index + 1) : 'D'+(index - 39)
//			if (item.WAGES_NAME == null || item.WAGES_NAME == '') {
			if (item == null) {
				columns.push(Ext.applyIf({dataIndex: dataIndex,		width: 100,   text: ''		, style: 'text-align: center'	, hidden:true}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }));	
			} else {
				columns.push(Ext.applyIf({dataIndex: dataIndex,		width: 100,   text: item.WAGES_NAME		, style: 'text-align: center'}	, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }));
			}	
		});
		columns.push({dataIndex: 'COST_POOL'	,width: 100, 	text: 'COST_POOL'		, style: 'text-align: center', hidden : true});
		columns.push({dataIndex: 'OFFICE_NAME'	,width: 100, 	text: 'OFFICE_NAME'		, style: 'text-align: center', hidden : true});
		columns.push({dataIndex: 'SEX_NAME'		,width: 100, 	text: '성별'				, style: 'text-align: center', hidden : true});
		columns.push({dataIndex: 'EMPLOY_TYPE'	,width: 100, 	text: '사원구분'			, style: 'text-align: center', hidden : true});
		columns.push({dataIndex: 'PAY_CODE'		,width: 100, 	text: '급여지급방식'			, style: 'text-align: center'});
		columns.push({dataIndex: 'SECT_CODE'	,width: 150, 	text: '신고기관'		    , style: 'text-align: center', hidden : true});
 		console.log(columns);
		return columns;
	}	
};
</script>