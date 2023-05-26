<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum315skr"  >
	<t:ExtComboStore comboType="BOR120"	pgmId="hum315skr"/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H020" /> 				<!-- 관계 -->
	<t:ExtComboStore comboType="AU" comboCode="H011" /> 				<!-- 고용형태 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> 				<!-- 사원구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H028" /> 				<!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> 				<!-- 급여지급차수 -->
	<t:ExtComboStore comboType="AU" comboCode="H181" /> 				<!-- 사원그룹 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> 				<!-- 직위 -->
	<t:ExtComboStore comboType="AU" comboCode="H009" /> 				<!-- 최종학력 -->
	<t:ExtComboStore items="${COMBO_HUMAN_COST_POOL}" storeId="getHumanCostPool" />	<!--사업명-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
	var gsCostPool = '${CostPool}';  // H175 subCode 10의 Y/N 에 따라 값이 바뀜
	
	var togetherYNStore = Unilite.createStore('hum315skrTogetherYNStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'예'		, 'value':'Y'},
			        {'text':'아니오'	, 'value':'N'}
	    		]
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hum315skrModel', {
	    fields: [
	    	{name: 'COMP_CODE'				,text:'<t:message code="system.label.human.compcode" default="법인코드"/>'		,type:'string'},
	    	{name: 'DIV_CODE'   					,text:'<t:message code="system.label.human.division" default="사업장"/>'		,type:'string' , comboType:'BOR120'},
	    	{name: 'DEPT_NAME'   				,text:'<t:message code="system.label.human.department" default="부서"/>'			,type:'string'},
	    	{name: 'POST_CODE'              	,text:'<t:message code="system.label.human.postcode" default="직위"/>'				,type:'string'},
	    	{name: 'NAME'        					,text:'<t:message code="system.label.human.name" default="성명"/>'				,type:'string'},
	    	{name: 'PERSON_NUMB'			,text:'<t:message code="system.label.human.personnumb" default="사번"/>'			,type:'string'},
	    	{name: 'FAMILY_NAME'     		,text:'<t:message code="system.label.human.familyname" default="가족성명"/>'		,type:'string'},
	    	{name: 'REL_NAME'		    		,text:'<t:message code="system.label.human.relcode" default="관계"/>'			,type:'string'},
	    	{name: 'REPRE_NUM_EXPOS'	,text:'<t:message code="system.label.human.peprenumexpos" default="가족주민번호"/>'	,type:'string'},
	    	{name: 'REPRE_NUM'		    	,text:'<t:message code="system.label.human.peprenum" default="가족주민번호"/>'	,type:'string'},
	    	{name: 'TOGETHER_YN'		    ,text:'<t:message code="system.label.human.togetheryn" default="동거여부"/>'		,type:'string' ,store: Ext.data.StoreManager.lookup('hum315skrTogetherYNStore')},
	    	{name: 'SCHSHIP_NAME'		    ,text:'<t:message code="system.label.human.schshipcode" default="최종학력"/>'		,type:'string' /*, comboType:'AU', comboCode:'H009'*/},
	    	{name: 'GRADU_NAME'		    ,text:'<t:message code="system.label.human.graduyn" default="졸업여부"/>'		,type:'string'},
	    	{name: 'OCCUPATION'		    	,text:'<t:message code="system.label.human.occupation" default="직업"/>'			,type:'string'},
	    	{name: 'COMP_NAME'		    	,text:'<t:message code="system.label.human.position" default="근무처"/>'		,type:'string'},
	    	{name: 'POST_NAME'		    	,text:'<t:message code="system.label.human.postcode" default="직위"/>'			,type:'string'},
	    	{name: 'FAMILY_AMOUNT_YN'         ,text:'수당지급여부'       ,type:'string' , comboType:'AU', comboCode:'A020'}
	    	
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('hum315skrMasterStore1',{
			model: 'Hum315skrModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
	           
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'hum315skrService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			},
			listeners: {
            load: function(store, records, successful, eOpts) {
                var count = masterGrid.getStore().getCount();  
                if(count > 0){
                    UniAppManager.setToolbarButtons(['print'], true);
                }else{
                    UniAppManager.setToolbarButtons(['print'], false);
                }
                
            }
        }
	});
	

	/**
	 * 검색조건 (Search Panel)
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
			layout : {type : 'uniTable', columns : 1},
			items:[{
				fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        comboType:'BOR120',
				width: 325,
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
			}), 
			Unilite.popup('Employee',{
				fieldLabel: '<t:message code="system.label.human.employee" default="사원"/>',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('DIV_CODE', records[0].DIV_CODE);
							panelResult.setValue('DIV_CODE', records[0].DIV_CODE);
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
						panelSearch.setValue('PERSON_NUMB', '');
                        panelSearch.setValue('NAME', '');
					}
				}
			}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.human.incumbenttype" default="재직구분"/>',
				items: [{
					boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
					width: 70, 
					name: 'RDO_TYPE',
					inputValue: '' 
				},{
					boxLabel : '<t:message code="system.label.human.incumbent" default="재직"/>', 
					width: 70,
					name: 'RDO_TYPE',
					inputValue: 'A',
					checked: true
					
				},{
					boxLabel: '<t:message code="system.label.human.retrsp" default="퇴직"/>', 
					width: 70, 
					name: 'RDO_TYPE',
					inputValue: 'B'	
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('RDO_TYPE').setValue(newValue.RDO_TYPE);
					}
				}
			},{
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:200,
				items :[{
					fieldLabel:'<t:message code="system.label.human.frreprenum" default="가족연령"/>', 
					xtype: 'uniNumberfield',
					name: 'FR_REPRE_NUM',
					width:165,
						listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelResult.setValue('FR_REPRE_NUM', newValue);
						}
					}
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniNumberfield',
					name: 'TO_REPRE_NUM', 
					width: 70,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelResult.setValue('TO_REPRE_NUM', newValue);
						}
					}
				}]
			},{
				fieldLabel: '<t:message code="system.label.human.relcode" default="관계"/>',
				name:'REL_CODE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('REL_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.human.schshipcode" default="최종학력"/>',
				name:'SCHSHIP_CODE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H009',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('SCHSHIP_CODE', newValue);
					}
				}
			}]
		},{
				title:'<t:message code="system.label.human.addinfo" default="추가정보"/>',
   				id: 'search_panel2',
				itemId:'search_panel2',
        		defaultType: 'uniTextfield',
        		layout : {type : 'uniTable', columns : 1},
        		defaultType: 'uniTextfield',
        		
        		items:[{
					fieldLabel: '<t:message code="system.label.human.paygubun" default="고용형태"/>',
					name:'PAY_GUBUN',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'H011'
				},{
					fieldLabel: '<t:message code="system.label.human.employtype" default="사원구분"/>',
					name:'EMPLOY_GUBUN',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'H024'
				},{
					fieldLabel: '<t:message code="system.label.human.paymethodcode" default="급여지급방식"/>',
					name:'PAY_CODE',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'H028'
				},{
					fieldLabel: '<t:message code="system.label.human.pjtname" default="사업명"/>',
					name:'COST_POOL',
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('getHumanCostPool')
				},{
					fieldLabel: '<t:message code="system.label.human.payprovflag3" default="급여차수"/>',
					name:'PAY_PROV_FLAG',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'H031'
				},{
					fieldLabel: '<t:message code="system.label.human.employeegroup" default="사원그룹"/>',
					name:'PERSON_GROUP',
					xtype: 'uniCombobox',
					comboType:'AU',
					comboCode:'H181'
				}]				
		}]
	}); 
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
				fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
		        multiSelect: true, 
		        typeAhead: false,
		        comboType:'BOR120',
				width: 325,
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
				textFieldWidth:89,
				validateBlank:true,
				width:300,
				autoPopup:true,
				useLike:true,
				colspan:2,
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
			}),
			Unilite.popup('Employee',{
				fieldLabel: '<t:message code="system.label.human.employee" default="사원"/>',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				colspan:2,
				validateBlank:false,
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('DIV_CODE', records[0].DIV_CODE);
							panelResult.setValue('DIV_CODE', records[0].DIV_CODE);
							panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
							panelSearch.setValue('NAME', panelResult.getValue('NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)    {
                        panelResult.setValue('PERSON_NUMB', '');
                        panelResult.setValue('NAME', '');
                        panelSearch.setValue('PERSON_NUMB', '');
                        panelSearch.setValue('NAME', '');
                    }
				}
			}),{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.human.incumbenttype" default="재직구분"/>',	
				items: [{
					boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
					width: 70, 
					name: 'RDO_TYPE',
					inputValue: '' 
				},{
					boxLabel : '<t:message code="system.label.human.incumbent" default="재직"/>', 
					width: 70,
					name: 'RDO_TYPE',
					inputValue: 'A',
					checked: true
					
				},{
					boxLabel: '<t:message code="system.label.human.retrsp" default="퇴직"/>', 
					width: 70, 
					name: 'RDO_TYPE',
					inputValue: 'B'	
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('RDO_TYPE').setValue(newValue.RDO_TYPE);
					}
				}
			},{
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:200,
				items :[{
					fieldLabel:'<t:message code="system.label.human.frreprenum" default="가족연령"/>', 
					xtype: 'uniNumberfield',
					name: 'FR_REPRE_NUM',
					width:165,
						listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelSearch.setValue('FR_REPRE_NUM', newValue);
						}
					}
				},{
					xtype:'component', 
					html:' ~ ',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniNumberfield',
					name: 'TO_REPRE_NUM', 
					width: 70,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelSearch.setValue('TO_REPRE_NUM', newValue);
						}
					}
				}]
			},{
				fieldLabel: '<t:message code="system.label.human.relcode" default="관계"/>',
				name:'REL_CODE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H020',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelSearch.setValue('REL_CODE', newValue);
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.human.schshipcode" default="최종학력"/>',
				name:'SCHSHIP_CODE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H009',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelSearch.setValue('SCHSHIP_CODE', newValue);
					}
				}
			}]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hum315skrGrid1', {
    	region: 'center',
        layout: 'fit',
        uniOpt:{	
        	expandLastColumn: false,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowContext: false,			
			onLoadSelectFirst	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		features: [ 
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false} 
    	],
        store: directMasterStore1,
        columns:  [  //{ dataIndex: 'COMP_CODE'			, width: 120},
        			 { dataIndex: 'DIV_CODE'   			, width: 133},
					 { dataIndex: 'DEPT_NAME'   		, width: 160},
					 { dataIndex: 'POST_CODE'      		, width: 77 },
        			 { dataIndex: 'NAME'        		, width: 88 },
					 { dataIndex: 'PERSON_NUMB'			, width: 77 },
					 { dataIndex: 'FAMILY_NAME'    		, width: 100},
        			 { dataIndex: 'REL_NAME'			, width: 100},
					 { dataIndex: 'REPRE_NUM'			, width: 150, hidden:true},
					 { dataIndex: 'REPRE_NUM_EXPOS'		, width: 150},
					 
					 { dataIndex: 'TOGETHER_YN'			, width: 88},
        			 { dataIndex: 'SCHSHIP_NAME'		, width: 133},
					 { dataIndex: 'GRADU_NAME'			, width: 100},
					 { dataIndex: 'OCCUPATION'			, width: 120},
        			 { dataIndex: 'COMP_NAME'			, width: 120},
					 { dataIndex: 'POST_NAME'			, width: 120},
					 { dataIndex: 'FAMILY_AMOUNT_YN'    , width: 120}
					 
					 
					 
        ] ,
		  listeners:{
                onGridDblClick:function(grid, record, cellIndex, colName) {   
                	if(colName == 'REPRE_NUM_EXPOS')   {   
                       var params = {'INCRYP_WORD':record.get('REPRE_NUM')};
                       Unilite.popupDecryptCom(params);
                    }
                }
                
		  }
    });   
	
    Unilite.Main({
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
		id  : 'hum315skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			if(!Ext.isEmpty(gsCostPool)){
				panelSearch.getField('COST_POOL').setFieldLabel(gsCostPool);  
			}
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('PERSON_NUMB');
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
			
			var viewLocked = masterGrid.getView();
			var viewNormal = masterGrid.getView();
			console.log("viewLocked : ",viewLocked);
			console.log("viewNormal : ",viewNormal);
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(false);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(false);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			
			this.fnInitBinding();
		},
		onPrintButtonDown: function() {
             //var records = panelSearch.down('#imageList').getSelectionModel().getSelection();
             var params = Ext.getCmp('searchForm').getValues();

             
             
                 
             var win = Ext.create('widget.PDFPrintWindow', {
                url: CPATH+'/hum/hum315rkrPrint.do',
                prgID: 'hum315rkr',
                   extParam: {
                      COMP_CODE             : UserInfo.compCode,
                     // DIV_CODE              :        params.DIV_CODE,
                      DEPT_CODE : params.DEPTS,
                      PERSON_NUMB : params.PERSON_NUMB,
                      RDO_TYPE : params.RDO_TYPE,
                      FR_REPRE_NUM : params.FR_REPRE_NUM,
                      TO_REPRE_NUM : params.TO_REPRE_NUM,
                      REL_CODE : params.REL_CODE,
                      SCHSHIP_CODE : params.SCHSHIP_CODE,
                      PAY_GUBUN : params.PAY_GUBUN,
                      EMPLOY_GUBUN : params.EMPLOY_GUBUN,
                      PAY_CODE : params.PAY_CODE,
                      COST_POOL : params.COST_POOL,
                      PAY_PROV_FLAG : params.PAY_PROV_FLAG,
                      PERSON_GROUP : params.PERSON_GROUP
                    }
                });
                win.center();
                win.show();     
        },
	});
};


</script>
