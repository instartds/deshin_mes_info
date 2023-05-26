<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa950skr"  >
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
                read: 'hpa950skrService.selectList'                	
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
		//,groupField: 'DIV_CODE'
        //groupField: 'DEPT_NAME'
		
		
	});

	/* 검색조건 (Search Panel)
	 * @type 
	 */	
   	var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title: '<t:message code="system.label.human.searchconditon" default="검색조건"/>',         
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
			title: '<t:message code="system.label.human.basisinfo" default="기본정보"/>',   
			itemId: 'search_panel1',
			layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
	        items: [{
	        	fieldLabel: '<t:message code="system.label.human.payyyyymm1" default="귀속년월"/>', 
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
	        },{
		        fieldLabel: '<t:message code="system.label.human.supptype" default="지급구분"/>',
		        name:'SUPP_TYPE', 	
		        xtype: 'uniCombobox',
		        comboType: 'AU',
		        comboCode:'H032',
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('SUPP_TYPE', newValue);
					}
				}
		    },{
		        fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
		        name:'DIV_CODE', 
		        xtype: 'uniCombobox', 
		        comboType:'BOR120',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('DIV_CODE', newValue);
			    	}
	     		}
		    },
			Unilite.treePopup('DEPTTREE',{
				fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
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
                fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
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
                fieldLabel: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
                name:'PAY_DAY_FLAG', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H031',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('PAY_DAY_FLAG', newValue);
			    	}
	     		}
            },{
	            fieldLabel: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
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
						boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
						width: 50,
						name: 'rdoSelect2' , 
						inputValue: '', 
						checked: true
					},{
						boxLabel: '<t:message code="system.label.human.general" default="일반"/>',
						width: 50, 
						name: 'rdoSelect2' ,
						inputValue: '2'
					},{
						boxLabel: '<t:message code="system.label.human.dailyuse" default="일용"/>', 
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
			},
		      	Unilite.popup('Employee',{
		      	fieldLabel : '<t:message code="system.label.human.employee" default="사원"/>',
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
      		}),{
                fieldLabel: '<t:message code="" default="부문명"/>',				//COST_POOL
                name:'COST_POOL', 	
                xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('getHumanCostPool'),
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {
			    		panelResult.setValue('COST_POOL', newValue);
			    	}
	     		}
            },{
                fieldLabel: '<t:message code="system.label.human.employtype" default="사원구분"/>',
                name:'EMPLOY_TYPE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H024',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {
			    		panelResult.setValue('EMPLOY_TYPE', newValue);
			    	}
	     		}
            },{
				fieldLabel: ' ',
				xtype: 'uniCheckboxgroup', 
				items: [{
		        	boxLabel: '<t:message code="system.label.human.personalsummarkyn" default="개인별합계표기여부"/>',
		        	name: 'PERSON_SUM',
		        	uncheckedValue: 'N',
	        		inputValue: 'Y',
	        		hidden : false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('PERSON_SUM', newValue);
							
							
							if(newValue == true){
								masterStore.clearData();
								masterStore.setGroupField('PERSON_NUMB');
								UniAppManager.app.onQueryButtonDown()
								
							} else {
								masterStore.clearData();
								masterStore.setGroupField('')
								UniAppManager.app.onQueryButtonDown()
								
							}
							
							
						}
					}
				}]
            }]
        },{     
			title: '<t:message code="system.label.human.addinfo" default="추가정보"/>',   
			itemId: 'search_panel2',
			layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
	        items: [{
   				xtype: 'radiogroup',
   				fieldLabel: '<t:message code="system.label.human.incumbenttype" default="재직구분"/>',
   				id: 'rdoSelect1',
   				labelWidth: 90,
   				items: [{
   					boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
   					width: 50,
   					name: 'rdoSelect1' , 
   					inputValue: '0', 
   					checked: true
   				},{
   					boxLabel: '<t:message code="system.label.human.incumbent" default="재직"/>',
   					width: 50, 
   					name: 'rdoSelect1' ,
   					inputValue: '1'
   				},{
   					boxLabel: '<t:message code="system.label.human.retr" default="퇴사"/>', 
   					width: 50, 
   					name: 'rdoSelect1' ,
   					inputValue: '2'					
   				}]
            },{
                fieldLabel: '<t:message code="system.label.human.employeegroup" default="사원그룹"/>',
                name:'PERSON_GROUP', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H181'
            },{
                fieldLabel: '<t:message code="system.label.human.serial" default="직렬"/>',
                name:'AFFILE_CODE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H173'
            },{
	        	fieldLabel: '<t:message code="system.label.human.suppdate" default="지급일"/>', 
				xtype: 'uniDateRangefield',   
				startFieldName: 'SUPP_DATE_FR',
				endFieldName: 'SUPP_DATE_TO'
            },{
                fieldLabel: '<t:message code="system.label.human.manufactnsell" default="제조/판관"/>',
                name:'MAKE_SALE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'B027'
            },{
				fieldLabel: '<t:message code="system.label.human.sectcode" default="신고사업장"/>',
				name:'BILL_DIV_CODE', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				comboCode: 'BILL'
			}]
		}],
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
			   		alert(labelText+'<t:message code="system.message.human.message045" default="필수입력 항목입니다."/>');
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
        	fieldLabel: '<t:message code="system.label.human.payyyyymm1" default="귀속년월"/>', 
			xtype: 'uniMonthRangefield',   
			startFieldName: 'DATE_FR',
			endFieldName: 'DATE_TO',
			width: 400,
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
        },{
	        fieldLabel: '<t:message code="system.label.human.supptype" default="지급구분"/>',
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
	    },{
	        fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
	        name:'DIV_CODE', 
	        xtype: 'uniCombobox', 
	        comboType:'BOR120',
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('DIV_CODE', newValue);
		    	}
     		}
	    },
    	Unilite.treePopup('DEPTTREE',{
			fieldLabel: '<t:message code="system.label.human.department" default="부서"/>',
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
            fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
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
            fieldLabel: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
            name:'PAY_DAY_FLAG', 	
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'H031',
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('PAY_DAY_FLAG', newValue);
		    	}
     		}
        },{
			xtype: 'container',
			layout: {type : 'uniTable'},
			items :[{
	            fieldLabel: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
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
						boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
						width: 50,
						name: 'rdoSelect2' , 
						inputValue: '', 
						checked: true
					},{
						boxLabel: '<t:message code="system.label.human.general" default="일반"/>',
						width: 50, 
						name: 'rdoSelect2' ,
						inputValue: '2'
					},{
						boxLabel: '<t:message code="system.label.human.dailyuse" default="일용"/>', 
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
		},
	      	Unilite.popup('Employee',{
	      	fieldLabel : '<t:message code="system.label.human.employee" default="사원"/>',
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
  		}),{
            fieldLabel: '<t:message code="" default="부문명"/>',				//COST_POOL
            name:'COST_POOL', 	
            xtype: 'uniCombobox', 
			store: Ext.data.StoreManager.lookup('getHumanCostPool'),
		    listeners: {
		    	change: function(field, newValue, oldValue, eOpts) {      
		    		panelSearch.setValue('COST_POOL', newValue);
		    	}
     		}
        },{
            fieldLabel: '<t:message code="system.label.human.employtype" default="사원구분"/>',
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
        },{
			fieldLabel: ' ',
			xtype: 'uniCheckboxgroup', 
			items: [{
	        	boxLabel: '<t:message code="system.label.human.personalsummarkyn" default="개인별합계표기여부"/>',
	        	name: 'PERSON_SUM',
	        	//uncheckedValue: 'N',
        		inputValue: 'Y',
        		hidden : false,
        		
        		
					
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('PERSON_SUM', newValue);
						
						if(newValue == true){
							masterStore.clearData();
							masterStore.setGroupField('PERSON_NUMB');
							UniAppManager.app.onQueryButtonDown()
							
						} else {
							masterStore.clearData();
							masterStore.setGroupField('')
							UniAppManager.app.onQueryButtonDown()
							
						}
						
					}
				}
			}]
        }]
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
			excel: {
				useExcel      : true,			//엑셀 다운로드 사용 여부
				exportGroup   : true, 		//group 상태로 export 여부
				onlyData      : false,
				summaryExport : true
			},
    		filter: {
				useFilter		: false,
				autoCreate		: false
			}
        },
        features: [{
        	id: 'masterGridSubTotal',
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: true 
        },{
	        id: 'masterGridTotal', 	
	        ftype: 'uniSummary', 
	        showSummaryRow: true
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
	            {	text	: '<t:message code="system.label.human.payserchview" default="급여조회및조정 보기"/>',   
	            	itemId	: 'linkHpa330ukr',
	            	handler	: function(menuItem, event) {
	            		var param = menuItem.up('menu');
//						var param = {
//	            			'PGM_ID'		: 'hpa350ukr',
//							'PAY_YYYYMM' 	: record.data['PAY_YYYYMM'],
//							'PERSON_NUMB'	: record.data['PERSON_NUMB'],
//							'NAME'			: record.data['NAME'],
//							'SUPP_TYPE'		: record.data['SUPP_TYPE']
//	            		};
	            		masterGrid.gotoHpa330ukr(param.record);
	            	}
	        	},{	text	: '<t:message code="system.label.human.yearmonthserchview" default="년월차조회및조정 보기"/>',   
	            	itemId	: 'linkHpa610ukr',
	            	handler	: function(menuItem, event) {
	            		var param = menuItem.up('menu');
//						var param = {
//	            			'PGM_ID'		: 'hpa350ukr',
//							'PAY_YYYYMM' 	: record.data['PAY_YYYYMM'],
//							'PERSON_NUMB'	: record.data['PERSON_NUMB'],
//							'NAME'			: record.data['NAME'],
//							'SUPP_TYPE'		: record.data['SUPP_TYPE']
//	            		};
	            		masterGrid.gotoHpa610ukr(param.record);
	            	}
	        	},{	text	: '<t:message code="system.label.human.bonusserchview" default="상여조회및조정 보기"/>',   
	            	itemId	: 'linkHbo220ukr',
	            	handler	: function(menuItem, event) {
	            		var param = menuItem.up('menu');
//						var param = {
//	            			'PGM_ID'		: 'hpa350ukr',
//							'PAY_YYYYMM' 	: record.data['PAY_YYYYMM'],
//							'PERSON_NUMB'	: record.data['PERSON_NUMB'],
//							'NAME'			: record.data['NAME'],
//							'SUPP_TYPE'		: record.data['SUPP_TYPE']
//	            		};
	            		masterGrid.gotoHbo220ukr(param.record);
	            	}
	        	}
	        ]
	    },
		gotoHpa330ukr:function(record)	{
			if(record)	{
		    	var params = record
		    	params.data.PGM_ID = 'hpa950skr';
			}
	  		var rec1 = {data : {prgID : 'hpa330ukr', 'text':''}};							
			parent.openTab(rec1, '/human/hpa330ukr.do', params);
    	},
		gotoHpa610ukr:function(record)	{
			if(record)	{
		    	var params = record
		    	params.data.PGM_ID = 'hpa950skr';
			}
	  		var rec1 = {data : {prgID : 'hpa610ukr', 'text':''}};							
			parent.openTab(rec1, '/human/hpa610ukr.do', params);
    	},
		gotoHbo220ukr:function(record)	{
			if(record)	{
		    	var params = record
		    	params.data.PGM_ID = 'hpa950skr';
			}
	  		var rec1 = {data : {prgID : 'hbo220ukr', 'text':''}};							
			parent.openTab(rec1, '/human/hbo220ukr.do', params);
    	}
/*    	viewConfig: {
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
	    }*/
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
        	var radio2 = panelSearch.down('#RADIO2');
        	var radio3 = panelResult.down('#RADIO3');
			radio2.hide();
			radio3.hide();
			radio2.setValue('');
			radio3.setValue('');
			
			if(!Ext.isEmpty(getCostPoolName)){
				panelSearch.getField('COST_POOL').setFieldLabel(getCostPoolName[0].REF_CODE2);  			
				panelResult.getField('COST_POOL').setFieldLabel(getCostPoolName[0].REF_CODE2);
			}
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			
			panelSearch.setValue('DATE_FR',UniDate.get('startOfMonth'));
			panelSearch.setValue('DATE_TO',UniDate.get('today'));
			
			panelResult.setValue('DATE_FR',UniDate.get('startOfMonth'));
			panelResult.setValue('DATE_TO',UniDate.get('today'));
			
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
				//masterGrid.reset();
				//masterStore.clearData();
				
				//그리드 컬럼명 조회하여 세팅하는 부분
				var param = Ext.getCmp('searchForm').getValues();
				hpa950skrService.selectColumns2(param, function(provider, response) {
					var records = response.result;
	
					//그리드 컬럼명 조건에 맞게 재 조회하여 입력
					var newColumns = createGridColumn(records);
					masterGrid.setConfig('columns',newColumns);
					
					masterGrid.getStore().loadStoreRecords();
					if(!Ext.isEmpty(getCostPoolName)){
						masterGrid.getColumn('COST_POOL').setText(getCostPoolName[0].REF_CODE2);
					}
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
			masterGrid.downloadExcelXml(false, '<t:message code="system.label.human.title" default="타이틀"/>');
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
					    {name: 'ABIL_NAME'			, type: 'string'},
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
					
		for (var i = 0; i < 61; ++i){
			var name = i < 40 ? 'S'+(i + 1) : 'D'+(i - 39)
			//alert(name);
			fields.push({name: name, type:'uniPrice' });
		}
		console.log(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(colData) {
		var columns = [
			{dataIndex:'GUBUN',				width: 100		, text: '<t:message code="system.label.human.type" default="구분"/>'		, locked: false		, sortable: false	, hidden: true}, 				
			{dataIndex:'DIV_CODE',			width: 150		, text: '<t:message code="system.label.human.division" default="사업장"/>', locked: false		, sortable: false	, id: 'a1'	, style: 'text-align: center',
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(record.get('GUBUN') == '2') {	
						return '';
					} else {
						return val;
					}
	            }
			}, 				
			{dataIndex:'DEPT_CODE',			width: 100		, text: '<t:message code="system.label.human.deptcode" default="부서코드"/>'		, locked: false		, sortable: false	, hidden: true},
			{dataIndex:'DEPT_NAME',			width: 100		, text: '<t:message code="system.label.human.department" default="부서"/>'		, locked: false		, sortable: false	, style: 'text-align: center',
    			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.human.subtotal" default="소계"/>', '<t:message code="system.label.human.total" default="총계"/>');
    			}
			},
			{dataIndex:'POST_CODE',			width: 100		, text: '<t:message code="system.label.human.postcode" default="직위"/>'		, locked: false		, sortable: false	, hidden: true},
			{dataIndex:'POST_NAME',			width: 100		, text: '<t:message code="system.label.human.postname" default="직위명"/>'	, locked: false		, sortable: false	, style: 'text-align: center'},				
			{dataIndex:'NAME',				width: 100		, text: '<t:message code="system.label.human.name" default="성명"/>'			, locked: false		, sortable: false	, style: 'text-align: center'},				
			{dataIndex:'PERSON_NUMB',		width: 100		, text: '<t:message code="system.label.human.personnumb" default="사번"/>'	, locked: false		, sortable: false	, style: 'text-align: center',
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(record.get('GUBUN') == '2' || record.get('GUBUN') == '3') {	
						return '';
					} else {
						return val;
					}
	            }
			}, 				
			Ext.applyIf({dataIndex:'JOIN_DATE',		width: 100			, text: '<t:message code="system.label.human.joindate" default="입사일"/>'		, locked: false		, sortable: false}, {align: 'center', xtype: 'uniDateColumn' }),				
			{dataIndex:'PAY_YYYYMM',				width: 100			, text: '<t:message code="system.label.human.payyyyymm1" default="귀속년월"/>'		, locked: false		, align: 'center'},				
			{dataIndex:'SUPP_NAME',					width: 100			, text: '<t:message code="system.label.human.supptype" default="지급구분"/>'		, locked: false		, style: 'text-align: center'},				
			Ext.applyIf({dataIndex:'SUPP_DATE',		width: 100			, text: '<t:message code="system.label.human.suppdate" default="지급일"/>'		}, {align: 'center', xtype: 'uniDateColumn' }),				
			{dataIndex:'SUPP_TYPE',					width: 100			, text: '<t:message code="system.label.human.supptypecode" default="지급구분코드"/>'	, locked: false		, hidden: true},
			{dataIndex:'ABIL_NAME',					width: 100			, text: '<t:message code="system.label.human.abil" default="직책"/>'							, style: 'text-align: center'		},				
			Ext.applyIf({dataIndex:'SUPP_TOTAL_I',	width: 100			, text: '<t:message code="system.label.human.payamounti" default="지급총액"/>'				, style: 'text-align: center',summaryType: 'sum'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }),				
			Ext.applyIf({dataIndex:'DED_TOTAL_I',	width: 100			, text: '<t:message code="system.label.human.dedtotali" default="공제총액"/>'				, style: 'text-align: center',summaryType: 'sum'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }),				
			Ext.applyIf({dataIndex:'REAL_AMOUNT_I',	width: 100			, text: '<t:message code="system.label.human.realamounti" default="실지급액"/>'				, style: 'text-align: center',summaryType: 'sum',
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    return '<span style= "color:' + 'blue' + '">' + Ext.util.Format.number(val,'0,000') + '</span>';
	            }
			}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }),				
			Ext.applyIf({dataIndex:'BUSI_SHARE_I',		width: 110		, text: '<t:message code="system.label.human.socbusisharei" default="사회보험부담금"/>'	, hidden: true,summaryType: 'sum'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }),				
			Ext.applyIf({dataIndex:'WORKER_COMPEN_I',	width: 110		, text: '<t:message code="system.label.human.workercompeni" default="사업자산재보험부담금"/>'	, hidden: true,summaryType: 'sum'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price })
		];
		//참고 - S1 : 기본급
		Ext.each(colData, function(item, index){
//			if (index == 0) return '';
			var dataIndex = index < 40 ? 'S'+(index+1) : 'D'+(index - 39)
//			if (item.WAGES_NAME == null || item.WAGES_NAME == '') {
//				columns.push(Ext.applyIf({dataIndex: dataIndex,		width: 100,   text: item.WAGES_NAME		, style: 'text-align: center'	, hidden:true}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }));	
//			} else {
//				columns.push(Ext.applyIf({dataIndex: dataIndex,		width: 100,   text: item.WAGES_NAME		, style: 'text-align: center'}	, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }));
//			}	
			
//			if (item.WAGES_NAME == null || item.WAGES_NAME == '') {
//			     columns.push(Ext.applyIf({dataIndex: dataIndex,     width: 100,   text: item.WAGES_NAME       , style: 'text-align: center'   , hidden:true,summaryType: 'sum'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }));
//			}
			//if{
			
			if (item.WAGES_NAME == null || item.WAGES_NAME == '') {
				columns.push({dataIndex: dataIndex		, text: item.WAGES_NAME		, style: 'text-align: center'	,width: 100		, hidden:true});	
			} else {
				columns.push(Ext.applyIf({dataIndex: dataIndex		, text: item.WAGES_NAME		, style: 'text-align: center' ,summaryType: 'sum'	, width: 100}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }));
			}
		
/* 서민근 - 주석 시작			
			    if(index < 25){
                    columns.push(Ext.applyIf({dataIndex: dataIndex,     width: 100,   text: item.WAGES_NAME       , style: 'text-align: center',summaryType: 'sum'}  , {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }));
			    }
			    if(index > 24 && index <38){
			    	columns.push(Ext.applyIf({dataIndex: dataIndex,     width: 100,   text: item.WAGES_NAME       , style: 'text-align: center'   , hidden:true,summaryType: 'sum'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }));
			    }
			    if(index == 39 ){ //z기타수당 = 상품권잔액 + 환수(감사지적)+ 복지포인트+ 11월잔여금액+ 근무장려수당+ 안전근무수당+ 잔여시간외수당
                    columns.push(Ext.applyIf({dataIndex: dataIndex,     width: 100,   text: '<t:message code="system.label.human.etcamounti" default="기타수당"/>'              , style: 'text-align: center',summaryType: 'sum'}  , {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }));
                }
                if(index >= 40 && index <59){
                    columns.push(Ext.applyIf({dataIndex: dataIndex,     width: 100,   text: item.WAGES_NAME       , style: 'text-align: center',summaryType: 'sum'}  , {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }));
                }
                if(index == 59){
                    columns.push(Ext.applyIf({dataIndex: dataIndex,     width: 100,   text: item.WAGES_NAME       , style: 'text-align: center'   , hidden:true,summaryType: 'sum'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }));
                }
서민근 - 주석 종료	 */
                
//                else{
//                	columns.push(Ext.applyIf({dataIndex: dataIndex,     width: 100,   text: item.WAGES_NAME       , style: 'text-align: center'   , hidden:false,summaryType: 'sum'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }));
//                }
			//}
			
		});
		columns.push({dataIndex: 'COST_POOL'	,width: 100, 		text: 'COST_POOL'		, style: 'text-align: center'	});
		columns.push({dataIndex: 'OFFICE_NAME'	,width: 100, 		text: 'OFFICE_NAME'		, style: 'text-align: center'		, hidden: true});
		columns.push({dataIndex: 'SEX_NAME'		,width: 100, 		text: '<t:message code="system.label.human.sexcode" default="성별"/>'				, style: 'text-align: center'		, hidden: true});
		columns.push({dataIndex: 'EMPLOY_TYPE'	,width: 100, 		text: '<t:message code="system.label.human.employtype" default="사원구분"/>'			, style: 'text-align: center'	});
		columns.push({dataIndex: 'PAY_CODE'		,width: 100, 		text: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>'			, style: 'text-align: center'	});
		columns.push({dataIndex: 'SECT_CODE'	,width: 150, 		text: '<t:message code="system.label.human.sectcode" default="신고사업장"/>'			, style: 'text-align: center'	});
 		console.log(columns);
		return columns;
	}	
};
</script>
