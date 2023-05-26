<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa955skr"  >
		<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 -->
		<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 -->
		<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
		<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 -->
		<t:ExtComboStore comboType="AU" comboCode="H032" /> <!-- 지급구분 -->
		<t:ExtComboStore comboType="AU" comboCode="H181" /> <!-- 사원그룹 -->
		<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
		<t:ExtComboStore items="${COMBO_HUMAN_COST_POOL}" storeId="getHumanCostPool" />	<!--차수-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
	
	colData = ${colData};
// 	console.log(colData);
	var fields = createModelField(colData);
	var columns = createGridColumn(colData);
	var	getCostPoolName = Ext.isEmpty(${getCostPoolName}) ? []: ${getCostPoolName};
	

	
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hpa955skrModel', {
	    fields: fields
	}); //End of Unilite.defineModel('Hpa955skrModel', { 
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('hpa955skrMasterStore',{
		model: 'Hpa955skrModel',
		uniOpt: {
            isMaster	: true,			// 상위 버튼 연결 
            editable	: false,		// 수정 모드 사용 
            deletable	: false,		// 삭제 가능 여부 
	        useNavi		: false			// prev | newxt 버튼 사용
	        //비고(*) 사용않함
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
                read: 'hpa955skrService.selectList'                	
            }
        }/*, //(사용 안 함 : 쿼리에서 처리)
        listeners : {
	        load : function(store) {
	            if (store.getCount() > 0) {
	            	setGridSummary(true);
	            } else {
	            	setGridSummary(false);
	            }
	        }
	    }*/,
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'PAY_YYYYMM'
	}); //End of var masterStore = Unilite.createStore('hpa955skrMasterStore',{

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
	        	fieldLabel: '<t:message code="system.label.human.basetime" default="기준기간"/>', 
				xtype: 'uniMonthRangefield',   
				startFieldName: 'DATE_FR',
				endFieldName: 'DATE_TO',
				startDate: UniDate.get('startOfYear'),
				endDate: UniDate.get('endOfYear'),
				allowBlank: false,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('DATE_FR', newValue);						
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
		            	var radio2 = panelSearch.down('#RADIO1');
        				var radio3 = panelResult.down('#RADIO2');
			    		if(panelSearch.getValue('PAY_GUBUN') == '2'){
	            			radio2.show();
	            			radio3.show();
			    			radio2.setValue({rdoSelect : '0'});
			    			radio3.setValue({rdoSelect : '0'});
			    		} else {
	            			radio2.hide();
	            			radio3.hide();
			    			radio2.setValue({rdoSelect : ''});
			    			radio3.setValue({rdoSelect : ''});
			    		}
			    	}
	     		}
	        },{
	        	xtype: 'container',
				layout: {type : 'hbox'},
				items :[{
					xtype: 'radiogroup',
					fieldLabel: ' ',
					itemId: 'RADIO1',
					labelWidth: 90,
					items: [{
						boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
						width: 50,
						name: 'rdoSelect' , 
						inputValue: '', 
						checked: true
					},{
						boxLabel: '<t:message code="system.label.human.general" default="일반"/>',
						width: 50, 
						name: 'rdoSelect' ,
						inputValue: '2'
					},{
						boxLabel: '<t:message code="system.label.human.dailyuse" default="일용"/>', 
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
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.human.selection" default="선택"/>',						            		
				itemId: 'RADIO3',
				id: 'containRadio2',
				labelWidth: 90,
				items: [{
					boxLabel: '<t:message code="system.label.human.department" default="부서"/>', 
					width: 50, 
					name: 'rdoSelect2',
					inputValue: 'dept',
					id: 'radio_dept',
					checked: true  
				},{
					boxLabel : '<t:message code="system.label.human.bypostcode" default="직위별"/>', 
					width: 60,
					name: 'rdoSelect2',
					inputValue: 'level',
					id: 'radio_level'
				}],
				listeners: {
					change : function(rb, newValue, oldValue, options) {
						panelResult.getField('rdoSelect2').setValue(newValue.rdoSelect2);
						if(!UniAppManager.app.checkForNewDetail()){
							return false;
						}else{			
							UniAppManager.app.onQueryButtonDown();
						}
					}
				}
			}]
		}, {     
			title: '<t:message code="system.label.human.addinfo" default="추가정보"/>',   
			itemId: 'search_panel2',
			layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
	        items: [{
                fieldLabel: '<t:message code="system.label.human.pjtname" default="사업명"/>',				//COST_POOL
                name:'COST_POOL', 	
                xtype: 'uniCombobox', 
				store: Ext.data.StoreManager.lookup('getHumanCostPool')
            },{
                fieldLabel: '<t:message code="system.label.human.employtype" default="사원구분"/>',
                name:'EMPLOY_TYPE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H024'
            },{
                fieldLabel: '<t:message code="system.label.human.employeegroup" default="사원그룹"/>',
                name:'PERSON_GROUP', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H181'
            },{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.human.incumbenttype" default="재직구분"/>',						            		
				id: 'rdoSelect3',
				labelWidth: 90,
				items: [{
					boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
					width: 50,
					name: 'rdoSelect3' , 
					inputValue: 'all', 
					checked: true  
				},{
					boxLabel: '<t:message code="system.label.human.incumbent" default="재직"/>',
					width: 50, 
					name: 'rdoSelect3' ,
					inputValue: 'hired'
				},{
					boxLabel: '<t:message code="system.label.human.retr" default="퇴사"/>', 
					width: 50, 
					name: 'rdoSelect3' ,
					inputValue: 'fired'
				}],
				listeners: {
					click: {
						element: 'el', //bind to the underlying el property on the panel
						fn: function(){
							UniAppManager.app.onQueryButtonDown();
						}
					}
				}
			}, {
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.human.sexcode" default="성별"/>',						            		
				id: 'rdoSelect4',
				labelWidth: 90,
				items: [{
					boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
					width: 50, 
					name: 'rdoSelect4' ,
					inputValue: 'all', 
					checked: true  
				},{
					boxLabel: '<t:message code="system.label.human.male" default="남"/>' , 
					width: 50, 
					name: 'rdoSelect4' , 
					inputValue: 'male'
				},{
					boxLabel: '<t:message code="system.label.human.female" default="여"/>' , 
					width: 50,
					name: 'rdoSelect4' ,
					inputValue: 'female'
				}],
				listeners: {
					click: {
						element: 'el', //bind to the underlying el property on the panel
						fn: function(){
							UniAppManager.app.onQueryButtonDown();
						}
					}
				}
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
        	fieldLabel: '<t:message code="system.label.human.basetime" default="기준기간"/>', 
			xtype: 'uniMonthRangefield',   
			startFieldName: 'DATE_FR',
			endFieldName: 'DATE_TO',
			startDate: UniDate.get('startOfYear'),
			endDate: UniDate.get('endOfYear'),
	        tdAttrs: {width: 380},  
			allowBlank: false,   
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('DATE_FR', newValue);						
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
	        tdAttrs: {width: 380},  
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
		            	var radio2 = panelSearch.down('#RADIO1');
        				var radio3 = panelResult.down('#RADIO2');
			    		if(panelResult.getValue('PAY_GUBUN') == '2'){
	            			radio2.show();
	            			radio3.show();
			    			radio2.setValue({rdoSelect : '0'});
							radio3.setValue({rdoSelect : '0'});
						} else {
	            			radio2.hide();
	            			radio3.hide();
			    			radio2.setValue({rdoSelect : ''});
			    			radio3.setValue({rdoSelect : ''});
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
					itemId: 'RADIO2',
					labelWidth: 90,
					items: [{
						boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
						width: 50,
						name: 'rdoSelect' , 
						inputValue: '', 
						checked: true
					},{
						boxLabel: '<t:message code="system.label.human.general" default="일반"/>',
						width: 50, 
						name: 'rdoSelect' ,
						inputValue: '2'
					},{
						boxLabel: '<t:message code="system.label.human.dailyuse" default="일용"/>', 
						width: 50, 
						name: 'rdoSelect' ,
						inputValue: '1'					
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.getField('rdoSelect').setValue(newValue.rdoSelect);
						}
					}
				}]
	        }]
		},{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.human.selection" default="선택"/>',						            		
				itemId: 'RADIO4',
				labelWidth: 90,
				items: [{
					boxLabel: '<t:message code="system.label.human.department" default="부서"/>', 
					width: 50, 
					name: 'rdoSelect2',
					inputValue: 'dept',
					id: 'radio_dept2',
					checked: true  
				},{
					boxLabel : '<t:message code="system.label.human.bypostcode" default="직위별"/>', 
					width: 60,
					name: 'rdoSelect2',
					inputValue: 'level',
					id: 'radio_level2'
				}],
				listeners: {
					change : function(rb, newValue, oldValue, options) {
						panelSearch.getField('rdoSelect2').setValue(newValue.rdoSelect2);
					}
				}
			}]
	});	
	
    /* Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hpa955skrGrid1', {
    	layout	: 'fit',
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
			useRowContext 		: false,
    		filter: {
				useFilter		: false,
				autoCreate		: false
			}
        },
        features: [{
        	id		: 'masterGridSubTotal', 
        	ftype	: 'uniGroupingsummary', 
        	showSummaryRow: false 
        },{
	        id		: 'masterGridTotal', 	
	        ftype	: 'uniSummary', 	 
	        showSummaryRow: false
	    }],		
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
	          	if(record.get('GUBUN') == '5'){
	          		//배경색(dark), 글자색(blue)
					cls = 'x-change-cell_Background_dark_Text_blue';
					
				} else if(record.get('GUBUN') == '2' || record.get('GUBUN') == '3' || record.get('GUBUN') == '4') {
					cls = 'x-change-cell_normal';
				}
				return cls;
	        }
	    }
    });	//End of var masterGrid = Unilite.createGrid('hpa955skrGrid1', {
	
	Unilite.Main({
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
		id: 'hpa955skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			var radio = panelSearch.down('#RADIO1');
        	var radio2 = panelResult.down('#RADIO2');
			radio.hide();
			radio2.hide();
			radio.setValue('');
			radio2.setValue('');

			if (!Ext.isEmpty(getCostPoolName[0])){
				panelSearch.getField('COST_POOL').setFieldLabel(getCostPoolName[0].REF_CODE2);  			
			}
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
				hpa955skrService.selectColumns2(param, function(provider, response) {
					var records = response.result;
	
					//그리드 컬럼명 조건에 맞게 재 조회하여 입력
					var newColumns = createGridColumn(records);
					masterGrid.setConfig('columns',newColumns);   // check1
	
					masterGrid.getStore().loadStoreRecords();
					
					var selValue = Ext.getCmp('containRadio2').getChecked()[0].inputValue;
					if (selValue == 'dept') {
						masterGrid.getColumn('DEPT_NAME').setText('<t:message code="system.label.human.department" default="부서"/>');
					} else {
						masterGrid.getColumn('DEPT_NAME').setText('<t:message code="system.label.human.postname" default="직위명"/>');
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
		}
	}); //End of 	Unilite.Main( {
		
/*	// Grid 의 summary row의  표시 /숨김 적용 (사용 안 함 : 쿼리에서 처리)
    function setGridSummary(viewable){
    	if (masterStore.getCount() > 0) {
    		var viewLocked = masterGrid.lockedGrid.getView();
            var viewNormal = masterGrid.normalGrid.getView();
            if (viewable) {
            	viewLocked.getFeature('masterGridTotal').enable();
            	viewNormal.getFeature('masterGridTotal').enable();
            	viewLocked.getFeature('masterGridSubTotal').enable();        	
            	viewNormal.getFeature('masterGridSubTotal').enable();
            } else {
            	viewLocked.getFeature('masterGridTotal').disable();
            	viewNormal.getFeature('masterGridTotal').disable();
            	viewLocked.getFeature('masterGridSubTotal').disable();
            	viewNormal.getFeature('masterGridSubTotal').disable();
            }
            viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(viewable);
            viewLocked.getFeature('masterGridTotal').toggleSummaryRow(viewable);
            viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(viewable);
            viewNormal.getFeature('masterGridTotal').toggleSummaryRow(viewable);
            
            masterGrid.getView().refresh();	
    	}
    }*/
	
	// 모델 필드 생성
	function createModelField(colData) {
				
		var fields = [
			{name: 'GUBUN'					, text: '<t:message code="system.label.human.type" default="구분"/>'						, type: 'string'},
			{name: 'PAY_YYYYMM'				, text: '<t:message code="system.label.human.payyyyymm" default="급여년월"/>'				, type: 'string'},
			{name: 'PAY_VISIBLE'			, text: '<t:message code="system.label.human.payyyyymm" default="급여년월"/>'				, type: 'string'},
			//
			{name: 'SUPP_NAME'				, text: '<t:message code="system.label.human.supptype" default="지급구분"/>'				, type: 'string'},
			{name: 'DIV_CODE'				, text: '<t:message code="system.label.human.division" default="사업장"/>'				, type: 'string' ,comboType: 'BOR120'},
			{name: 'DIV_CODE_VISIBLE'		, text: '<t:message code="system.label.human.division" default="사업장"/>'				, type: 'string' ,comboType: 'BOR120'},
			{name: 'DEPT_CODE'				, text: '<t:message code="system.label.human.deptcode" default="부서코드"/>'				, type: 'string'},
			{name: 'DEPT_NAME'				, text: '<t:message code="system.label.human.department" default="부서"/>'				, type: 'string'},
			{name: 'PERSON_CNT'				, text: '<t:message code="system.label.human.incomecnt" default="인원"/>'					, type: 'int'},
			{name: 'TAX_AMOUNT_I'			, text: '과세총액'																			, type: 'uniPrice'},
			{name: 'TAX_EXEMPTION_I'		, text: '비과세총액'																		, type: 'uniPrice'},
			{name: 'SUPP_TOTAL_I'			, text: '<t:message code="system.label.human.payamounti" default="지급총액"/>'				, type: 'uniPrice'},
			{name: 'DED_TOTAL_I'			, text: '<t:message code="system.label.human.dedtotali" default="공제총액"/>'				, type: 'uniPrice'},
			{name: 'REAL_AMOUNT_I'			, text: '<t:message code="system.label.human.realamounti" default="실지급액"/>'			, type: 'uniPrice'},
			{name: 'BUSI_SHARE_I'			, text: '<t:message code="system.label.human.socbusisharei" default="사회보험부담금"/>'		, type: 'uniPrice'},
			{name: 'WORKER_COMPEN_I'		, text: '<t:message code="system.label.human.workercompeni" default="사업자산재보험부담금"/>'	, type: 'uniPrice'}
		];
					
		Ext.each(colData, function(item, index){
			//var name = index < 20 ? 'S'+(index + 1) : 'G'+(index + 1)
			var name = index < 40 ? 'S'+(index + 1) : 'D'+(index - 39)
			fields.push({name: name, text: item.WAGES_NAME, type:'uniPrice' });
		});
		console.log(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(colData) {
		
		var columns = [
   			{dataIndex: 'GUBUN'				, text: '<t:message code="system.label.human.type" default="구분"/>'			, width: 86	, locked: false , hidden:true},
   			{dataIndex: 'PAY_YYYYMM'		, text: '<t:message code="system.label.human.payyyyymm" default="급여년월"/>'	, width: 120	, locked: false	, hidden:true , style: 'text-align: center'//, 
  /* 				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(record.get('GUBUN') == '4' || record.get('GUBUN') == '5' ) {	
						return '합계';
					} else {
						return val;
					}
	            }*/
			}, 			
			{dataIndex: 'PAY_VISIBLE'		, text: '<t:message code="system.label.human.payyyyymm" default="급여년월"/>'	, width: 120		, locked: false, hidden:false, style: 'text-align: center'},
			{dataIndex: 'SUPP_NAME'			, text: '<t:message code="system.label.human.supptype" default="지급구분"/>'	, width: 120	, locked: false, style: 'text-align: center'//,
/*				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(record.get('GUBUN') == '3') {	
						return '합계';
					} else if (record.get('GUBUN') == '4') {
						return '';
					} else {
						return val;
					}
	            }*/
			}, 		
			{dataIndex: 'DIV_CODE'		    , text: '<t:message code="system.label.human.division" default="사업장"/>'	, width: 140    , locked: false, sortable: false , hidden:true	, id: 'a1'	, style: 'text-align: center', align: 'center' //,
/*				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(record.get('GUBUN') == '2') {	
						return '합계';
					} else if (record.get('GUBUN') == '3' || record.get('GUBUN') == '4' || record.get('GUBUN') == '5') {
						return '';
					} else {
						return val;
					}
	            }*/
			}, 				
			{dataIndex: 'DIV_CODE_VISIBLE'	, text: '<t:message code="system.label.human.division" default="사업장"/>'	, width: 130 , locked: false, sortable: false	, style: 'text-align: center'//,
/*				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
					if(record.get('GUBUN') == '2') {	
						return '합계';
					} else if (record.get('GUBUN') == '3' || record.get('GUBUN') == '4' || record.get('GUBUN') == '5') {
						return '';
					} else {
						return val;
					}
	            }*/
			}, 	
			{dataIndex: 			'DEPT_CODE'			, text: '<t:message code="system.label.human.deptcode" default="부서코드"/>'		, width: 100	, locked: false , hidden:true},
			{dataIndex: 			'DEPT_NAME'			, text: '<t:message code="system.label.human.department" default="부서"/>'		, width: 160	, locked: false	, style: 'text-align: center'},
			Ext.applyIf({dataIndex: 'PERSON_CNT'		, text: '<t:message code="system.label.human.incomecnt" default="인원"/>'			, width: 86		, locked: false	, style: 'text-align: center'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }),
			Ext.applyIf({dataIndex: 'TAX_AMOUNT_I'		, text: '과세총액'																	, width: 100	, locked: false	, style: 'text-align: center'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }),
			Ext.applyIf({dataIndex: 'TAX_EXEMPTION_I'	, text: '비과세총액'																, width: 100	, locked: false	, style: 'text-align: center'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }),
			Ext.applyIf({dataIndex: 'SUPP_TOTAL_I'		, text: '<t:message code="system.label.human.payamounti" default="지급총액"/>'		, width: 100	, locked: false	, style: 'text-align: center'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }),
			Ext.applyIf({dataIndex: 'DED_TOTAL_I'		, text: '<t:message code="system.label.human.dedtotali" default="공제총액"/>'		, width: 100	, locked: false	, style: 'text-align: center'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }),
			Ext.applyIf({dataIndex:'REAL_AMOUNT_I'		, text: '<t:message code="system.label.human.realamounti" default="실지급액"/>'	, width: 100	, locked: false	, style: 'text-align: center',
				renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
                    return '<span style= "color:' + 'blue' + '">' + Ext.util.Format.number(val,'0,000') + '</span>';
	            }
			}																						, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }),				
			Ext.applyIf({dataIndex: 'BUSI_SHARE_I'		, text: '<t:message code="system.label.human.socbusisharei" default="사회보험부담금"/>'		, width: 130	, locked: false	, style: 'text-align: center'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price, hidden:true }),
			Ext.applyIf({dataIndex: 'WORKER_COMPEN_I'	, text: '<t:message code="system.label.human.workercompeni" default="사업자산재보험부담금"/>'	, width: 130	, locked: false	, style: 'text-align: center'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price, hidden:true })
		];
					
		Ext.each(colData, function(item, index){
			var dataIndex = index < 40 ? 'S'+(index + 1) : 'D'+(index - 39)
			if (item.WAGES_NAME == null || item.WAGES_NAME == '') {
				columns.push({dataIndex: dataIndex		, text: item.WAGES_NAME		, style: 'text-align: center'	,width: 100		, hidden:true});	
			} else {
				columns.push(Ext.applyIf({dataIndex: dataIndex		, text: item.WAGES_NAME		, style: 'text-align: center'	, width: 100}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }));
			}			
		});
// 		console.log(columns);
		return columns;
	}
};

</script>
