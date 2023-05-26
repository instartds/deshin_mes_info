<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa850skr">
	<t:ExtComboStore comboType="AU" comboCode="H011" /> 		<!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> 		<!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> 		<!-- 지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H032" /> 		<!-- 지급코드 -->
	<t:ExtComboStore comboType="AU" comboCode="H033" /> 		<!-- 근태코드-->
	<t:ExtComboStore comboType="AU" comboCode="H034" /> 		<!-- 공제코드 -->
	<t:ExtComboStore comboType="BOR120" />						<!-- 사업장 -->
	<t:ExtComboStore items="${payList}" storeId="getPayList" />	<!-- 지급목록-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	/* Model 정의 
	 * @type 
	 */
	function getMonth(index, mon) {
 		var now2 = new Date();
 		if (mon == '') {
 			var month = now2.getMonth() +1 -index ;
 		}  else {
 			var month = mon -1 - index;	
 		}
//	 	alert(month);
	 	month = (month == 0) ? 12 : month;
		month = (month < 0) ? (month + 12)  : month;
		
		return month < 10 ? '0' + month + '월' : month +'월';
	}

	function dd(mon){
 		var fields = [ {name: 'DEPT_NAME'		, text: '<t:message code="system.label.human.department" default="부서"/>'	, type: 'string'},
				       {name: 'DEPT_CODE'				, text: '<t:message code="system.label.human.deptcode" default="부서코드"/>'	, type: 'string'},
				       {name: 'POST_NAME'				, text: '<t:message code="system.label.human.postcode" default="직위"/>'	, type: 'string'},
				       {name: 'NAME'						, text: '<t:message code="system.label.human.name" default="성명"/>'	, type: 'string'},
				       {name: 'PERSON_NUMB'		, text: '<t:message code="system.label.human.personnumb" default="사번"/>'	, type: 'string'},
				       {name: 'CODE_NAME'			, text: '<t:message code="system.label.human.postcode" default="직위"/>'	, type: 'string'},
				       {name: 'ALLOW_CD'				, text: '<t:message code="system.label.human.name" default="성명"/>'	, type: 'string'},
				       {name: 'BASE_MONTH'			, text: '<t:message code="system.label.human.postcode" default="직위"/>'	, type: 'string'}
				       //{name: 'BASE_MONTH'		, text: '기준년월'	, type: 'uniPrice'}
		];

		if (mon != '' || mon != null) {
			if (mon.length == 2) {
				mon = mon.substring(mon.length -1, mon.length);
			}
		}
 		
 		for(var i=0; i< 12; i++) {
 			var month = getMonth(i, mon);
			
 			fields.push({name: 'MONTH_'+i, text: month 	, type: 'uniPrice'});	
		}
 		
	return fields;	
 	}			
	 			
	 var fields_aa = dd('');	
	 
	 
	 Unilite.defineModel('Hpa850skrModel', {
		fields: fields_aa
	  });

	// GroupField string type으로 변환
	//function dateToString(v, record){
	//	return UniDate.safeFormat(v);
	// }

	/* Store 정의(Service 정의)
	 * @type 
	 */
	var masterStore = Unilite.createStore('hpa850skrmasterStore', {
		model : 'Hpa850skrModel',
		uniOpt : {
			isMaster	: true, 		// 상위 버튼 연결 
			editable	: false, 		// 수정 모드 사용 
			deletable	: false, 		// 삭제 가능 여부 
			useNavi		: false			// prev | newxt 버튼 사용
		},
		autoLoad : false,
		proxy : {
			type : 'direct',
			api : {
				read : 'hpa850skrService.selectList'
			}
		},
		loadStoreRecords : function() {
			var param = Ext.getCmp('searchForm').getValues();
			console.log(param);
			this.load({
				params : param
			});
		}
//		 listeners: {
//           var combo = Ext.getCmp('ALLOW_CD');
//           combo.bindStore('CBS_AU_H031');
//    	    },
//		,groupField: 'DIV_CODE'
	});
	
	var now = new Date();
 	var month = now.getMonth()+1
 	var day = now.getDate(); 
 	month = month < 10? '0' + month : month
 	day = day < 10? '0' + day : day 
 	var today = now.getFullYear() + '/' + month + '/' + day;
	
 	/* 검색조건 (Search Panel)
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
			layout: {type: 'uniTable', columns: 1},
			defaultType : 'uniTextfield',
			items : [{
				fieldLabel: '<t:message code="system.label.human.applyyymm" default="기준년월"/>',
	        	xtype: 'uniMonthfield',
	        	allowBlank: false, 
	        	value: UniDate.get('today'),
	        	name : 'CURR_DATE',
	        	id : 'CURR_DATE',
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CURR_DATE', newValue);
					}
				}
			}, {
				fieldLabel : '<t:message code="system.label.human.division" default="사업장"/>',
				name : 'DIV_CODE',
				id : 'DIV_CODE',
				xtype : 'uniCombobox',
				comboType : 'BOR120',
				inputValue : '01',
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
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.human.inquirycondition" default="조회조건"/>',						            		
				id: 'rdoSXG',
				labelWidth: 90,
				items: [{
					boxLabel: '<t:message code="system.label.human.monyearprov" default="지급"/>', 
					width: 53, 
					name: 'rdoSelect' ,
					inputValue: 'S',
					checked: true
				},{
	          
					boxLabel: '<t:message code="system.label.human.ded" default="공제"/>',
					width: 53, 
					name: 'rdoSelect' ,
					inputValue: 'X'
				},{
					boxLabel: '<t:message code="system.label.human.duty" default="근태"/>', 												//근태조건 체크시 조회내역: allowBlank: false 변경
					width: 53,
					name: 'rdoSelect' , 
					inputValue: 'G'
				} ],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
		               	var combo = Ext.getCmp('ALLOW_CD');
		               	var combo2 = Ext.getCmp('ALLOW_CD2');
		      			//combo.bindStore('CBS_AU_H033');
		      			var selValue = JSON.stringify(newValue.rdoSelect);
						if (selValue == '"S"') {									//지급
							panelSearch.getField('ALLOW_CD').setConfig('allowBlank', true)
							panelResult.getField('ALLOW_CD2').setConfig('allowBlank', true)
							combo.bindStore('getPayList');
							combo2.bindStore('getPayList');
						}
						else if (selValue == '"X"') {								//공제
							panelSearch.getField('ALLOW_CD').setConfig('allowBlank', true)
							panelResult.getField('ALLOW_CD2').setConfig('allowBlank', true)
							combo.bindStore('CBS_AU_H034');
							combo2.bindStore('CBS_AU_H034');
						}
						else if(selValue == '"G"') {								//근태
							combo.bindStore('CBS_AU_H033');
							combo2.bindStore('CBS_AU_H033');

							var payListSelect = Ext.data.StoreManager.lookup('CBS_AU_H033').getAt(0).get('value');
							panelSearch.setValue('ALLOW_CD', payListSelect);
							panelResult.setValue('ALLOW_CD2', payListSelect);
							
							panelSearch.getField('ALLOW_CD').setConfig('allowBlank', false)
							panelSearch.getField('ALLOW_CD').setConfig('labelClsExtra', Ext.baseCSSPrefix+'required_field_label')
							
							panelResult.getField('ALLOW_CD2').setConfig('allowBlank', false)
							panelResult.getField('ALLOW_CD2').setConfig('labelClsExtra', Ext.baseCSSPrefix+'required_field_label')
//							var field = {};
//							var field1 = panelSearch.getField('ALLOW_CD')
////							Ext.apply(panelSearch.getField('ALLOW_CD'), {allowBlank: false, labelClsExtra :'required_field_label'});
//							Ext.apply(field1, {allowBlank: false, labelClsExtra :'required_field_label'});
//							panelSearch.down('#allowCd').hide();
//							panelSearch.down('#allowCd').show();
						}
						masterGrid.reset();
						masterStore.clearData();
					
						UniAppManager.setToolbarButtons('save',false);
						panelResult.getField('rdoSelect2').setValue(newValue.rdoSelect);
					}
				}
			},{
            fieldLabel: '<t:message code="system.label.human.inquiryhistory" default="조회내역"/>'  ,
            name : 'ALLOW_CD',
            id : 'ALLOW_CD',
            xtype: 'uniCombobox',
            store: Ext.data.StoreManager.lookup('getPayList'),
//          comboType: 'AU',
//          comboCode: 'H032',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelResult.setValue('ALLOW_CD2', newValue);
                }
            }
        }, 	
				Unilite.popup('Employee', {
				fieldLabel : '<t:message code="system.label.human.employee" default="사원"/>',
			    valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
//				validateBlank : false,
				extParam : {
					'CUSTOM_TYPE' : '3'
				},  
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
			})
		]},{
			title: '<t:message code="system.label.human.addinfo" default="추가정보"/>', 	
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{
                fieldLabel: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
                name:'PAY_PROV_FLAG', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H031',
			    listeners: {
			    	change: function(field, newValue, oldValue, eOpts) {      
			    		panelResult.setValue('PAY_PROV_FLAG', newValue);
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
		            	var radio2 = panelSearch.down('#RADIO2');
			    		if(panelSearch.getValue('PAY_GUBUN') == '2'){
	            			radio2.show();
			    			radio2.setValue('0');
			    		} else {
	            			radio2.hide();
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
						boxLabel: '<t:message code="system.label.human.dailyuse" default="일용"/> ', 
						width: 50, 
						name: 'rdoSelect2' ,
						inputValue: '1'					
					}]
				}]
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
	}); //end panelSearch  

	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel: '<t:message code="system.label.human.applyyymm" default="기준년월"/>',
        	xtype: 'uniMonthfield',
        	allowBlank: false, 
        	value: UniDate.get('today'),
        	name : 'CURR_DATE',
	 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CURR_DATE', newValue);
				}
			}
		}, {
			fieldLabel : '<t:message code="system.label.human.division" default="사업장"/>',
			name : 'DIV_CODE',
			xtype : 'uniCombobox',
			comboType : 'BOR120',
			inputValue : '01',
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
		}), {
			xtype: 'radiogroup',		            		
			fieldLabel: '<t:message code="system.label.human.inquirycondition" default="조회조건"/>',						            		
			id: 'rdoSXG2',
			labelWidth: 90,
			items: [{
				boxLabel: '<t:message code="system.label.human.monyearprov" default="지급"/>', 
				width: 53, 
				name: 'rdoSelect2' ,
				inputValue: 'S',
				checked: true
			},{
				boxLabel: '<t:message code="system.label.human.ded" default="공제"/>',
				width: 53, 
				name: 'rdoSelect2' ,
				inputValue: 'X'
			},{
				boxLabel: '<t:message code="system.label.human.duty" default="근태"/>', //근태조건 체크시 조회내역: allowBlank: false 변경
				width: 53,
				name: 'rdoSelect2' , 
				inputValue: 'G'
			} ],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
	               	var combo = Ext.getCmp('ALLOW_CD');
	               	var combo2 = Ext.getCmp('ALLOW_CD2');
	      			var selValue = JSON.stringify(newValue.rdoSelect);
					if (selValue == '"S"') {							//지급
						panelSearch.getField('ALLOW_CD').setConfig('allowBlank', true)
						panelResult.getField('ALLOW_CD2').setConfig('allowBlank', true)
						combo.bindStore('getPayList');
						combo2.bindStore('getPayList');	
					}
					else if (selValue == '"X"') {						//공제
						panelSearch.getField('ALLOW_CD').setConfig('allowBlank', true)
						panelResult.getField('ALLOW_CD2').setConfig('allowBlank', true)
						combo.bindStore('CBS_AU_H034');
						combo2.bindStore('CBS_AU_H034');	
					}
					else if(selValue == '"G"') {						//근태
						combo.bindStore('CBS_AU_H033');
						combo2.bindStore('CBS_AU_H033');
	
						var payListSelect = Ext.data.StoreManager.lookup('CBS_AU_H033').getAt(0).get('value');
						panelSearch.setValue('ALLOW_CD', payListSelect);
						panelResult.setValue('ALLOW_CD2', payListSelect);
						
						panelSearch.getField('ALLOW_CD').setConfig('allowBlank', false)
						panelSearch.getField('ALLOW_CD').setConfig('labelClsExtra', Ext.baseCSSPrefix+'required_field_label')
						
						panelResult.getField('ALLOW_CD2').setConfig('allowBlank', false)
						panelResult.getField('ALLOW_CD2').setConfig('labelClsExtra', Ext.baseCSSPrefix+'required_field_label')
					}
					masterGrid.reset();
					masterStore.clearData();

					UniAppManager.setToolbarButtons('save',false);
					panelSearch.getField('rdoSelect').setValue(newValue.rdoSelect2);
				}
			}
		}, {
			fieldLabel: '<t:message code="system.label.human.inquiryhistory" default="조회내역"/>'	,
			name : 'ALLOW_CD2',
			id : 'ALLOW_CD2',
			xtype: 'uniCombobox',
			store: Ext.data.StoreManager.lookup('getPayList'),
//			comboType: 'AU',
//			comboCode: 'H032',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ALLOW_CD', newValue);
				}
			}
		}, Unilite.popup('Employee', {
			fieldLabel : '<t:message code="system.label.human.employee" default="사원"/>',
		    valueFieldName:'PERSON_NUMB',
		    textFieldName:'NAME',
//			validateBlank : false,
			extParam : {
				'CUSTOM_TYPE' : '3'
			},  
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
		})]
	});

	/* Master Grid1 정의(Grid Panel)
	 * @type 
	 */
	var masterGrid = Unilite.createGrid('hpa850skrGrid1', {
		layout : 'fit',
		region : 'center',
		store : masterStore,
    	selModel:'rowmodel',
		uniOpt : {
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		dblClickToEdit		: false,
    		onLoadSelectFirst	: false, 
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: false,
			expandLastColumn	: false,
    		filter: {
				useFilter		: false,
				autoCreate		: false
			}
        },
		store : masterStore,
		features: [{
		          id: 'masterGridSubTotal',
		          ftype: 'uniGroupingsummary', 
		          showSummaryRow: false 
		       },{
		          id: 'masterGridTotal',    
		          ftype: 'uniSummary',    
		          dock: 'top',
		          showSummaryRow: true
		       }],
		columns : [
			{dataIndex: 'DEPT_NAME'		,align : 'center' , width: 100,	
				summaryRenderer : function(value, summaryData, dataIndex, metaData) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
				}
			},
			{dataIndex: 'DEPT_CODE'		, width: 100	,align : 'center'},
			{dataIndex: 'POST_NAME'		, width: 100	,align : 'center'},
			{dataIndex: 'NAME'			, width: 100	,align : 'center'},
			{dataIndex: 'PERSON_NUMB'	, width: 100	,align : 'center'},
			{dataIndex: 'MONTH_0'		, width: 100	,summaryType : 'sum'	,align : 'right'},
			{dataIndex: 'MONTH_1'		, width: 100	,summaryType : 'sum'	,align : 'right'},
			{dataIndex: 'MONTH_2'		, width: 100	,summaryType : 'sum'	,align : 'right'},
			{dataIndex: 'MONTH_3'		, width: 100	,summaryType : 'sum'	,align : 'right'},
			{dataIndex: 'MONTH_4'		, width: 100	,summaryType : 'sum'	,align : 'right'},
			{dataIndex: 'MONTH_5'		, width: 100	,summaryType : 'sum'	,align : 'right'},
			{dataIndex: 'MONTH_6'		, width: 100	,summaryType : 'sum'	,align : 'right'},
			{dataIndex: 'MONTH_7'		, width: 100	,summaryType : 'sum'	,align : 'right'},
			{dataIndex: 'MONTH_8'		, width: 100	,summaryType : 'sum'	,align : 'right'},
			{dataIndex: 'MONTH_9'		, width: 100	,summaryType : 'sum'	,align : 'right'},
			{dataIndex: 'MONTH_10'		, width: 100	,summaryType : 'sum'	,align : 'right'},
			{dataIndex: 'MONTH_11'		, width: 100	,summaryType : 'sum'	,align : 'right'}
		]
	});

	Unilite.Main({
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
		id : 'hpa850skrApp',
		fnInitBinding : function() {
        	var radio2 = panelSearch.down('#RADIO2');
			radio2.hide();
			radio2.setValue('');

			panelSearch.setValue('DIV_CODE', UserInfo.divCode);
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
			panelSearch.setValue('CURR_DATE',UniDate.get('today'));
			panelResult.setValue('CURR_DATE',UniDate.get('today'));

			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },

		onQueryButtonDown : function() {
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				// query 작업s
				masterGrid.getStore().loadStoreRecords();						
				
				var value = Ext.getCmp('searchForm').getForm().findField('CURR_DATE').getValue();		 		
				var month = new Date(value).getMonth() + 1;										       
				changeColumns(month);		 
			}
/*
			var detailform = panelSearch.getForm();
			if (detailform.isValid()) {
				// query 작업s
				masterGrid.getStore().loadStoreRecords();						
				
				var value = Ext.getCmp('searchForm').getForm().findField('CURR_DATE').getValue();		 		
				var month = new Date(value).getMonth() + 1;										       
				changeColumns(month);		 
	 		
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
								+ '은(는) ';
					} else if (Ext
							.isDefined(invalid.items[0].ownerCt)) {
						var labelText = invalid.items[0].ownerCt['fieldLabel']
								+ '은(는) ';
					}

					// Ext.Msg.alert(타이틀, 표시문구); 
					Ext.Msg.alert('확인', labelText + '<t:message code="system.message.human.message053" default="기준년월을 입력하여 주십시오."/>');
					// validation이 맞지 않는 필드 중 제일 처음 필드에 포커스를 줌
					invalid.items[0].focus();*/
		},
		
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterStore.clearData();
			this.fnInitBinding();
		}
	});
	
	function changeColumns(month) {
		for (var i = 0; i < 12; i++) {
			var newMonth = parseInt(month) - i;
			newMonth = (newMonth == 0) ? 12 : newMonth;
			newMonth = (newMonth < 0) ? (newMonth + 12)  : newMonth;
			newMonth = (newMonth < 10) ? '0' + newMonth + '월' : newMonth +'월';
			masterGrid.columns[i+5].setText(newMonth);	
		}
	}
};
</script>
