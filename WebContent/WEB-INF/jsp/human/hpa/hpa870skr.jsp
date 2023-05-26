<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hpa870skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 					<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> 		<!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> 		<!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" />			<!-- 지급차수 -->
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
	
	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hpa870skrModel', {
		fields : fields
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	}
	  
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('hpa870skrmasterStore',{
		model: 'Hpa870skrModel',
		uniOpt: {
            isMaster	: true,			// 상위 버튼 연결 
            editable	: false,			// 수정 모드 사용 
            deletable	: false,			// 삭제 가능 여부 
	        useNavi 	: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
                read: 'hpa870skrService.selectList'                	
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
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			
			var PLAN_DATE_FR = UniDate.add(panelSearch.getValue('PLAN_DATE'), {months:-1}) 
			PLAN_DATE_FR = UniDate.getDbDateStr(PLAN_DATE_FR)										//날짜형식 YYYYMMDD로 변환
			PLAN_DATE_FR = PLAN_DATE_FR.substring(0,6)												//날짜형식 YYYYMM으로 자르기
//			var PLAN_DATE = Ext.getCmp('searchForm').getForm().findField('PLAN_DATE').getValue();
//			var PLAN_DATE_BEFORE_MONTH = new Date(new Date(PLAN_DATE).setMonth(new Date(PLAN_DATE).getMonth() - 1));
//			var PLAN_DATE_FR = PLAN_DATE_BEFORE_MONTH.getFullYear() + '' + (PLAN_DATE_BEFORE_MONTH.getMonth()+1);
			param.PLAN_DATE_FR = PLAN_DATE_FR
			
			console.log( param );
			this.load({
				params : param
			});
		},
		groupField: 'DEPT_CODE'
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
	        	fieldLabel: '<t:message code="system.label.human.suppyyyymm1" default="지급년월"/>',
	        	xtype: 'uniMonthfield',
	        	allowBlank:false,
	        	name: 'PLAN_DATE',
				value: UniDate.get('startOfMonth'),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PLAN_DATE', newValue);
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
            },
		      	Unilite.popup('Employee',{
		      	fieldLabel : '<t:message code="system.label.human.employee" default="사원"/>',
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
      		}),{
	            fieldLabel: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
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
			}, {
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
            }]
		}]
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
        	fieldLabel: '<t:message code="system.label.human.suppyyyymm1" default="지급년월"/>',
        	xtype: 'uniMonthfield',
        	allowBlank:false,
        	name: 'PLAN_DATE',
			value: UniDate.get('startOfMonth'),
			colspan: 2,
//	        tdAttrs: {width: 400},  
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('PLAN_DATE', newValue);
				}
			}
       	}/*,{
       		xtype: 'component',
       		width: 155
       	}*/,
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
            fieldLabel: '<t:message code="system.label.human.payprovflag2" default="지급차수"/>',
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
        },
	      	Unilite.popup('Employee',{
	      	fieldLabel : '<t:message code="system.label.human.employee" default="사원"/>',
		    valueFieldName:'PERSON_NUMB',
		    textFieldName:'NAME',
//			validateBlank: false,
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
            fieldLabel: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
            name:'PAY_GUBUN', 	
            xtype: 'uniCombobox', 
            comboType:'AU',
            comboCode:'H011',
	        tdAttrs: {width: 250},  
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
	        tdAttrs: {width: 180},  
			items :[{
				xtype: 'radiogroup',
				fieldLabel: '',
				itemId: 'RADIO2',
				labelWidth: 35,
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
		}, {
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
        }]
	});
	
	
    /* Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hpa870skrGrid1', {
		layout	: 'fit',
		region	: 'center',
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
    	store	: masterStore,
    	features: [{
    		id		: 'masterGridSubTotal', 
    		ftype	: 'uniGroupingsummary',
    		showSummaryRow: false 
		},{
    		id 		: 'masterGridTotal', 	
    		ftype	: 'uniSummary', 
    		showSummaryRow: false
    	}],
		columns	: columns,
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
		}		
		,panelSearch
		], 
		id: 'hpa870skrApp',
		fnInitBinding: function() {
			panelSearch.setValue('PLAN_DATE', UniDate.get('today'));
			panelResult.setValue('PLAN_DATE', UniDate.get('today'));

			var radio = panelSearch.down('#RADIO');
        	var radio2 = panelResult.down('#RADIO2');
			radio.hide();
			radio2.hide();
			radio.setValue('');
			radio2.setValue('');
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
		},
		onQueryButtonDown : function()	{		
			if(!this.isValidSearchForm()){
				return false;
			} else {			
				//masterGrid.reset();
				//masterStore.clearData();
				
				//그리드 컬럼명 조회하여 세팅하는 부분
				var param = Ext.getCmp('searchForm').getValues();
				var PLAN_DATE_FR = UniDate.add(panelSearch.getValue('PLAN_DATE'), {months:-1}) 
				PLAN_DATE_FR = UniDate.getDbDateStr(PLAN_DATE_FR)										//날짜형식 YYYYMMDD로 변환
				PLAN_DATE_FR = PLAN_DATE_FR.substring(0,6)												//날짜형식 YYYYMM으로 자르기
				param.PLAN_DATE_FR = PLAN_DATE_FR
				hpa870skrService.selectColumns2(param, function(provider, response) {
					var records = response.result;
	
//					//그리드 컬럼명 조건에 맞게 재 조회하여 입력
//					var newColumns = createGridColumn(records);
//					masterGrid.setConfig('columns',newColumns);
					
					fields = createModelField(records);
					columns = createGridColumn(records);
					
					masterStore.setFields(fields);
					masterGrid.reconfigure(masterStore, columns);
					
					masterStore.loadStoreRecords();
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
	});
	
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
    }
*/	

	// 모델 필드 생성
	function createModelField(colData) {
		var fields = [
						{name: 'GUBUN' 	  		  	,type: 'string'},
						{name: 'DEPT_CODE' 	  	  	,type: 'string'},
						{name: 'DEPT_NAME'     	  	,type: 'string'},
						{name: 'PERSON_NUMB'		,type: 'string'},
						{name: 'NAME'			  	,type: 'string'},
						{name: 'POST_NAME'		  	,type: 'string'},
						{name: 'PAY_YYYYMM'		  	,type: 'string'},
						{name: 'SUPP_TOTAL_I'		,type: 'uniPrice'},
					    {name: 'REAL_AMOUNT_I'	  	,type: 'uniPrice'},
					    {name: 'DED_TOTAL_I'		,type: 'uniPrice'},
					    {name: 'S1'					,type: 'uniPrice'},
						{name: 'BUSI_SHARE_I'		,type: 'uniPrice'},
						{name: 'WORKER_COMPEN_I'	,type: 'uniPrice'}
					];
		Ext.each(colData, function(item, index){
			if (index == 0) return '';
			var name = index < 20 ? 'S'+(item.W_SEQ) : 'A'+(item.W_SEQ)
			fields.push({name: name, type:'uniPrice' });
		});
		console.log(fields);
		return fields;
	}
	
	// 그리드 컬럼 생성
	function createGridColumn(colData) {
		var s1Text = '';
		if (!Ext.isEmpty(colData)){
			s1Text = colData[0].WAGES_NAME
		} else {
			s1Text = ''
		}
		var columns = [
		   			//{dataIndex: 			'GUBUN'				, text: '구분'		, width: 100		, hidden:true},
   					//{dataIndex: 			'DIV_CODE'			, text: '사업장'		, width: 100		, hidden:true	, sortable: false	, style: 'text-align: center'},
		   			//{dataIndex: 			'DEPT_CODE'			, text: '부서코드'		, width: 100		, hidden:true},
					{dataIndex: 			'DEPT_NAME'					, text: '<t:message code="system.label.human.department" default="부서"/>' 	, width: 160		, style: 'text-align: center',
						renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
							if(record.get('GUBUN') == '2') {	
								return '';
							} else {
								return val;
							}
		            	}
		            },
					{dataIndex: 			'PERSON_NUMB'			, text: '<t:message code="system.label.human.personnumb" default="사번"/>'		, width: 100		, style: 'text-align: center',
						renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
							if(record.get('GUBUN') == '2') {	
								return '';
							} else {
								return val;
							}
		            	}
		            },
					{dataIndex: 			'NAME'							, text: '<t:message code="system.label.human.name" default="성명"/>'		, width: 100		, style: 'text-align: center',
						renderer : function(val,metaDate,record,rowIndex,colIndex,store,view) {
							if(record.get('GUBUN') == '2') {	
								return '';
							} else {
								return val;
							}
		            	}
		            },
					{dataIndex: 			'POST_NAME'	    	, text: '<t:message code="system.label.human.postcode" default="직위"/>'				, width: 100		, style: 'text-align: center'},
					{dataIndex: 			'PAY_YYYYMM'		, text: '<t:message code="system.label.human.suppyyyymm1" default="지급년월"/>'		, width: 100		, align: 'center'},
					Ext.applyIf({dataIndex:	'SUPP_TOTAL_I'		, text: '<t:message code="system.label.human.payamounti" default="지급총액"/>'			, width: 100		, style: 'text-align: center'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }),				
					Ext.applyIf({dataIndex:	'REAL_AMOUNT_I'		, text: '<t:message code="system.label.human.realamounti" default="실지급액"/>'		, width: 100		, style: 'text-align: center'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }),
					Ext.applyIf({dataIndex:	'DED_TOTAL_I'		, text: '<t:message code="system.label.human.dedtotali" default="공제총액"/>'			, width: 100		, style: 'text-align: center'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }),				
					Ext.applyIf({dataIndex: 'S1'				, text: s1Text																		, width: 100		, style: 'text-align: center'}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }),	
					Ext.applyIf({dataIndex:	'BUSI_SHARE_I'		, text: '<t:message code="system.label.human.socbusisharei" default="사회보험부담금"/>'	, width: 110}		, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price, hidden:true }),				
					Ext.applyIf({dataIndex:	'WORKER_COMPEN_I'	, text: '<t:message code="system.label.human.workercompeni" default="사업자산재보험부담금"/>'	, width: 110}	, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price, hidden:true })
				];
		Ext.each(colData, function(item, index){
			if (index == 0) return '';
			var dataIndex = index < 20 ? 'S'+(item.W_SEQ) : 'A'+(item.W_SEQ)
			if (item.WAGES_NAME == null || item.WAGES_NAME == '') {
				columns.push(Ext.applyIf({dataIndex: dataIndex		, text: item.WAGES_NAME		, style: 'text-align: center'		, width: 100	, hidden:true}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }));	
			} else {
				columns.push(Ext.applyIf({dataIndex: dataIndex		, text: item.WAGES_NAME		, style: 'text-align: center'		, width: 100}, {align: 'right' , xtype:'uniNnumberColumn', format: UniFormat.Price }));
			}			
		});
// 		console.log(columns);
		return columns;
	}
};


</script>
