<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum971skr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="hum920skr"	/> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H167" /> 				<!-- 출력구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
		
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hum971skrModel', {
	    fields: [
	    	{name: 'CERTI_NUM'					,text:'<t:message code="system.label.human.certificatenum" default="증명번호"/>'		,type:'string'},
	    	{name: 'CERTI_PRINT_DATE'   	,text:'<t:message code="system.label.human.issuedate" default="발급일"/>'		,type:'uniDate'},
	    	{name: 'CERTI_PRINT_USER'   	,text:'<t:message code="system.label.human.issueusernum" default="발급자사번"/>'		,type:'string'},
	    	{name: 'NAME'               			,text:'<t:message code="system.label.human.issueusername" default="발급자성명"/>'		,type:'string'},
	    	{name: 'CERTI_LANGU'        		,text:'<t:message code="system.label.human.printlang" default="출력언어"/>'		,type:'string'},
	    	{name: 'CERTI_TYPE'					,text:'<t:message code="system.label.human.printtype" default="출력구분"/>'		,type:'string', comboType:'AU', comboCode:'H167'},
	    	{name: 'INSERT_DB_TIME'     	,text:'<t:message code="system.label.human.printdate" default="출력일"/>'		,type:'uniDate'},
	    	{name: 'REMARK'		    			,text:'<t:message code="system.label.human.usage" default="용도"/>'			,type:'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('hum971skrMasterStore1',{
			model: 'Hum971skrModel',
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
                	   read: 'hum971skrService.selectDataList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
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
		        //multiSelect: true, 
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
				Name: 'PERSON_NUMB',
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
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					}
				}
			}),{
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:285,
				items :[{
					fieldLabel:'<t:message code="system.label.human.certificatenum" default="증명번호"/>', 
					xtype: 'uniTextfield',
					name: 'CERTI_NUM_FR',
					width:175,
						listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelSearch.setValue('CERTI_NUM_FR', newValue);
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
					xtype: 'uniTextfield',
					name: 'CERTI_NUM_TO', 
					width: 85,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelSearch.setValue('CERTI_NUM_TO', newValue);
						}
					}
				}]
			},{
				fieldLabel: '<t:message code="system.label.human.printtype" default="출력구분"/>',
				name:'CERTI_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H167',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelSearch.setValue('CERTI_TYPE', newValue);
					}
				}
			}
			,{
                fieldLabel: '<t:message code="system.label.human.issuedate" default="발급일"/>',
                xtype: 'uniDateRangefield',
                name:'CERTI_PRINT_DATE',
                startFieldName: 'FR_CERTI_PRINT_DATE',
                endFieldName: 'TO_CERTI_PRINT_DATE',
//                startDate: UniDate.get('startOfMonth'),
//                endDate: UniDate.get('today'),
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('FR_CERTI_PRINT_DATE',newValue);         
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('TO_CERTI_PRINT_DATE',newValue);                     
                    }
                }
            }
            ,{
                fieldLabel: '<t:message code="system.label.human.issuedate" default="발급일"/>',
                xtype: 'uniDateRangefield',
                name:'INSERT_DB_TIME',
                startFieldName: 'FR_INSERT_DB_TIME',
                endFieldName: 'TO_INSERT_DB_TIME',
//                startDate: UniDate.get('startOfMonth'),
//                endDate: UniDate.get('today'),
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('FR_INSERT_DB_TIME',newValue);         
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('TO_INSERT_DB_TIME',newValue);                     
                    }
                }
            }
			
			
			
			]
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
		        //multiSelect: true, 
		        typeAhead: false,
		        comboType:'BOR120',
				width: 325,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			},{
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:285,
				items :[{
					fieldLabel:'<t:message code="system.label.human.certificatenum" default="증명번호"/>', 
					xtype: 'uniTextfield',
					name: 'CERTI_NUM_FR',
					width:175,
						listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelSearch.setValue('CERTI_NUM_FR', newValue);
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
					xtype: 'uniTextfield',
					name: 'CERTI_NUM_TO', 
					width: 85,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelSearch.setValue('CERTI_NUM_TO', newValue);
						}
					}
				}]
			},{
				fieldLabel: '<t:message code="system.label.human.printtype" default="출력구분"/>',
				name:'CERTI_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'H167',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelSearch.setValue('CERTI_TYPE', newValue);
					}
				}
			},	Unilite.popup('Employee',{
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
							panelSearch.setValue('PERSON_NUMB', panelResult.getValue('PERSON_NUMB'));
							panelSearch.setValue('NAME', panelResult.getValue('NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('PERSON_NUMB', '');
						panelSearch.setValue('NAME', '');
						panelResult.setValue('PERSON_NUMB', '');
                        panelResult.setValue('NAME', '');
					},
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('NAME', newValue);				
					}
				}
			}),
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
			})
			
			,{
                fieldLabel: '<t:message code="system.label.human.issuedate" default="발급일"/>',
                xtype: 'uniDateRangefield',
                name:'CERTI_PRINT_DATE',
                startFieldName: 'FR_CERTI_PRINT_DATE',
                endFieldName: 'TO_CERTI_PRINT_DATE',
//                startDate: UniDate.get('startOfMonth'),
//                endDate: UniDate.get('today'),
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('FR_CERTI_PRINT_DATE',newValue);         
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('TO_CERTI_PRINT_DATE',newValue);                     
                    }
                }
            }
            ,{
                fieldLabel: '<t:message code="system.label.human.printdate" default="출력일"/>',
                xtype: 'uniDateRangefield',
                name:'INSERT_DB_TIME',
                startFieldName: 'FR_INSERT_DB_TIME',
                endFieldName: 'TO_INSERT_DB_TIME',
//                startDate: UniDate.get('startOfMonth'),
//                endDate: UniDate.get('today'),
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('FR_INSERT_DB_TIME',newValue);         
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelSearch) {
                        panelSearch.setValue('TO_INSERT_DB_TIME',newValue);                     
                    }
                }
            }
			
			
			
			]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('hum971skrGrid1', {
    	region: 'center',
        layout: 'fit',
        uniOpt:{
			useMultipleSorting	: true,
    		useLiveSearch		: true,
    		onLoadSelectFirst	: true,
    		dblClickToEdit		: false,
    		useGroupSummary		: true,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
			useRowContext		: true,
    		filter: {
				useFilter		: true,
				autoCreate		: true
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
        store: directMasterStore1,
        columns:  [  { dataIndex: 'CERTI_NUM'		, width: 120},
                     { dataIndex: 'CERTI_TYPE'       , width: 120},
        			 { dataIndex: 'CERTI_PRINT_DATE', width: 133},
					 { dataIndex: 'CERTI_PRINT_USER', width: 120},
					 { dataIndex: 'NAME'            , width: 133},
					 { dataIndex: 'CERTI_LANGU'     , width: 106, hidden:true}, 				
					 { dataIndex: 'INSERT_DB_TIME'  , width: 133}, 				
					 { dataIndex: 'REMARK'		    , width: 400}
        ] 
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
		id  : 'hum971skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('DIV_CODE');
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
		},
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
			UniAppManager.setToolbarButtons('reset',true);
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			
			this.fnInitBinding();
		}
	});
};


</script>
