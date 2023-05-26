<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="hum270skr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="hum270skr" /> 		<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="H005" /> 			<!--직위-->

</t:appConfig>

<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */
	
	var humDateStore = Ext.create('Ext.data.Store',{
		storeId: 'hum270skrCombo',
        fields:[
        	'search',
        	'value',
        	'text'
        ],
        data:[
        	{'value':'01' , text:'<t:message code="system.label.human.january" default="1월"/>' , search:'1월01'},
        	{'value':'02' , text:'<t:message code="system.label.human.february" default="2월"/>' , search:'2월02'},
        	{'value':'03' , text:'<t:message code="system.label.human.march" default="3월"/>' , search:'3월03'},
        	{'value':'04' , text:'<t:message code="system.label.human.april" default="4월"/>' , search:'4월04'},
        	{'value':'05' , text:'<t:message code="system.label.human.may" default="5월"/>' , search:'5월05'},
        	{'value':'06' , text:'<t:message code="system.label.human.june" default="6월"/>' , search:'6월06'},
        	{'value':'07' , text:'<t:message code="system.label.human.july" default="7월"/>' , search:'7월07'},
        	{'value':'08' , text:'<t:message code="system.label.human.august" default="8월"/>' , search:'8월08'},
        	{'value':'09' , text:'<t:message code="system.label.human.september" default="9월"/>' , search:'9월09'},
        	{'value':'10' , text:'<t:message code="system.label.human.october" default="10월"/>', search:'10월10'},
        	{'value':'11' , text:'<t:message code="system.label.human.november" default="11월"/>', search:'11월11'},
        	{'value':'12' , text:'<t:message code="system.label.human.december" default="12월"/>', search:'12월12'}
        	
        ]
	});
	
	var hum270skrMoonStore = Unilite.createStore('hum270skrMoonCombo', {
	    fields: ['text', 'value'],
		data :  [
					{'text':'<t:message code="system.label.human.solar2" default="양력"/>'	, 'value':'Y'},
			        {'text':'<t:message code="system.label.human.solar1" default="음력"/>'	, 'value':'N'}
	    		]
	});
	
    			
	Unilite.defineModel('hum270skrModel1', {
	    fields: [{name: 'HMONTH'	   		 ,text: '<t:message code="system.label.human.month" default="월"/>'			,type: 'string'},
	    		 {name: 'HDAY'						,text: '<t:message code="system.label.human.day" default="일"/>'			,type: 'string'},
	    		 {name: 'DIV_CODE'				,text: '<t:message code="system.label.human.division" default="사업장"/>'		,type: 'string', comboCode: "BOR120"},
	    		 {name: 'DEPT_NAME'			,text: '<t:message code="system.label.human.department" default="부서"/>'			,type: 'string'},
	    		 {name: 'POST_CODE'	   		 ,text: '<t:message code="system.label.human.postcode" default="직위"/>'			,type: 'string',comboType: "AU", comboCode: "H005"},	    			
	    		 {name: 'NAME'						,text: '<t:message code="system.label.human.name" default="성명"/>'			,type: 'string'},
	    		 {name: 'PERSON_NUMB'		,text: '<t:message code="system.label.human.personnumb" default="사번"/>'			,type: 'string'},
	    		 {name: 'WEDDING_DATE'	,text: '<t:message code="system.label.human.weddingdate" default="결혼기념일"/>'		,type: 'uniDate'}
	    		 
			]
	});
	
	Unilite.defineModel('hum270skrModel2', {
	    fields: [{name: 'HMONTH'	    	,text: '<t:message code="system.label.human.month" default="월"/>'		,type: 'string'},
	    		 {name: 'HDAY'						,text: '<t:message code="system.label.human.day" default="일"/>'		,type: 'string'},
	    		 {name: 'DIV_CODE'				,text: '<t:message code="system.label.human.division" default="사업장"/>'	,type: 'string', comboCode: "BOR120"},
	    		 {name: 'DEPT_NAME'			,text: '<t:message code="system.label.human.department" default="부서"/>'		,type: 'string'},
	    		 {name: 'POST_CODE'	   		 ,text: '<t:message code="system.label.human.postcode" default="직위"/>'		,type: 'string',comboType: "AU", comboCode: "H005"},	    			
	    		 {name: 'NAME'						,text: '<t:message code="system.label.human.name" default="성명"/>'		,type: 'string'},
	    		 {name: 'PERSON_NUMB'		,text: '<t:message code="system.label.human.personnumb" default="사번"/>'		,type: 'string'},
	    		 {name: 'BIRTH_DATE'			,text: '<t:message code="system.label.human.birthdate" default="생일"/>'	,type: 'uniDate'},
	     		 {name: 'SOLAR_YN'				,text: '<t:message code="system.label.human.solar2" default="양력"/>/<t:message code="system.label.human.solar1" default="음력"/>'	,type: 'string'	, store:Ext.data.StoreManager.lookup('hum270skrMoonCombo')}
			]
	});
	
	
	
	
	
	
	/*Ext.create( 'Ext.data.Store', {
          storeId: "gubunStore",
          fields: [ 'text', 'value'],
          data : [
              {text: "백양로",   value:"1" },
              {text: "CU",     value:"2" }
          ]
      });*/
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('hum270skrMasterStore1',{
			model: 'hum270skrModel1',
			uniOpt: {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi: false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'hum270skrService.selectWeddingDataList'                	
                }
            },
            loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params: param
				});
			}
	});
	
	var directMasterStore2 = Unilite.createStore('hum270skrMasterStore2',{
			model: 'hum270skrModel2',
			uniOpt: {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi: false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'hum270skrService.selectBirthdayDataList'                	
                }
            },
			loadStoreRecords: function(){
				var param= Ext.getCmp('searchForm').getValues();
				console.log( param );
				this.load({
					params: param
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
	           	layout: {type: 'uniTable', columns: 1},
	           	defaultType: 'uniTextfield',
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
						inputValue: 'Y',
						checked: true
						
					},{
						boxLabel: '<t:message code="system.label.human.retrsp" default="퇴직"/>', 
						width: 70, 
						name: 'RDO_TYPE',
						inputValue: 'N'	
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('RDO_TYPE').setValue(newValue.RDO_TYPE);
						}
					}
				},{
					xtype: 'radiogroup',		            		
					fieldLabel: '<t:message code="system.label.human.sexcode" default="성별"/>',		
					items: [{
						boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
						width: 70, 
						name: 'SEX_CODE',
						inputValue: '',
						checked: true  
					},{
						boxLabel : '<t:message code="system.label.human.male" default="남"/>', 
						width: 70,
						name: 'SEX_CODE',
						inputValue: 'M'
					},{
						boxLabel: '<t:message code="system.label.human.female" default="여"/>', 
						width: 70, 
						name: 'SEX_CODE',
						inputValue: 'F'	
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.getField('SEX_CODE').setValue(newValue.SEX_CODE);
						}
					}
				},{
				    xtype: 'container',
					layout: {type : 'uniTable', columns : 3},
					width:285,
					items :[{
						fieldLabel:'<t:message code="system.label.human.basismonth" default="기준월"/>', 
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('hum270skrCombo'),
						name: 'FROM_MONTH',
						width:175,
							listeners: {
							change: function(field, newValue, oldValue, eOpts) {      
								panelResult.setValue('FROM_MONTH', newValue);
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
						xtype: 'uniCombobox',
						store: Ext.data.StoreManager.lookup('hum270skrCombo'),
						name: 'TO_MONTH', 
						width: 85,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {      
								panelResult.setValue('TO_MONTH', newValue);
							}
						}
					}]
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
			},{
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
					inputValue: 'Y',
					checked: true
					
				},{
					boxLabel: '<t:message code="system.label.human.retrsp" default="퇴직"/>', 
					width: 70, 
					name: 'RDO_TYPE',
					inputValue: 'N'	
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('RDO_TYPE').setValue(newValue.RDO_TYPE);
					}
				}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.human.sexcode" default="성별"/>',	
				items: [{
					boxLabel: '<t:message code="system.label.human.whole" default="전체"/>', 
					width: 70, 
					name: 'SEX_CODE',
					inputValue: '',
					checked: true  
				},{
					boxLabel : '<t:message code="system.label.human.male" default="남"/>', 
					width: 70,
					name: 'SEX_CODE',
					inputValue: 'M'
				},{
					boxLabel: '<t:message code="system.label.human.female" default="여"/>', 
					width: 70, 
					name: 'SEX_CODE',
					inputValue: 'F'	
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.getField('SEX_CODE').setValue(newValue.SEX_CODE);
					}
				}
			},{
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:285,
				items :[{
					fieldLabel:'<t:message code="system.label.human.basismonth" default="기준월"/>', 
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('hum270skrCombo'),
					name: 'FROM_MONTH',
					width:175,
						listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelSearch.setValue('FROM_MONTH', newValue);
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
					xtype: 'uniCombobox',
					store: Ext.data.StoreManager.lookup('hum270skrCombo'),
					name: 'TO_MONTH', 
					width: 80,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {      
							panelSearch.setValue('TO_MONTH', newValue);
						}
					}
				}]
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
			})]
    });
	 
	 
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    //에러
    var masterGrid1 = Unilite.createGrid('hum270skrGrid1', {
    	// for tab
    	title: '<t:message code="system.label.human.marraniverslist" default="결혼기념일명단"/>',
        layout: 'fit',    
    	store: directMasterStore1,
    	selModel:'rowmodel',
        uniOpt : {						
			useMultipleSorting	: true,			
		    useLiveSearch		: true,			
		    onLoadSelectFirst	: false,				
		    dblClickToEdit		: false,			
		    useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: false,		
			expandLastColumn	: true,			
			useRowContext		: true,		
		    filter: {					
				useFilter		: true,	
				autoCreate		: true	
			}				
		},
		features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: false}
    	],
    	columns:  [         				
					{ dataIndex: 'HMONTH'			,width: 50 }, 	
					{ dataIndex: 'HDAY'				,width: 50 },	
					{ dataIndex: 'DIV_CODE'			,width: 150}, 				     
					{ dataIndex: 'DEPT_NAME'	 	,width: 200},				     
					{ dataIndex: 'POST_CODE'		,width: 100}, 				     
					{ dataIndex: 'NAME'				,width: 100},					
					{ dataIndex: 'PERSON_NUMB'		,width: 100}, 				 
					{ dataIndex: 'WEDDING_DATE'		,width: 100} 				     
							     		
          ] 
    });

    /**
     * Master Grid2 정의(Grid Panel)
     * @type 
     */
   var masterGrid2 = Unilite.createGrid('hum270skrGrid2', {
    	// for tab
    	title: '<t:message code="system.label.human.birthlist" default="생일자명단"/>',
        layout: 'fit',    
    	store: directMasterStore2,
    	selModel:'rowmodel',
    	uniOpt : {						
			useMultipleSorting	: true,			
		    useLiveSearch		: true,			
		    onLoadSelectFirst	: false,				
		    dblClickToEdit		: false,			
		    useGroupSummary		: true,			
			useContextMenu		: false,		
			useRowNumberer		: false,		
			expandLastColumn	: true,			
			useRowContext		: true,		
		    filter: {					
				useFilter		: true,	
				autoCreate		: true	
			}				
		},
		features: [
    		{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: false}
    	],
        columns:  [        
               		{ dataIndex: 'HMONTH'				,width:50 }, 			
					{ dataIndex: 'HDAY'					,width:50 }, 				 
					{ dataIndex: 'DIV_CODE'				,width:150}, 				     
					{ dataIndex: 'DEPT_NAME'			,width:200},
					{ dataIndex: 'POST_CODE'			,width:100},
					{ dataIndex: 'NAME'					,width:100}, 				     
					{ dataIndex: 'PERSON_NUMB'	        ,width:100}, 				     
					{ dataIndex: 'BIRTH_DATE'			,width:100},					
					{ dataIndex: 'SOLAR_YN'				,width:100}

          ] 
    });  
    /**
     * Master Grid3 정의(Grid Panel)
     * @type 
     */
    
	
     var tab = Unilite.createTabPanel('tabPanel',{
	    activeTab: 0,
	    region: 'center',
	    items: [
	         masterGrid1,
	         masterGrid2
	    ],
	    listeners:{
//	    	beforetabchange: function( tabPanel, newCard, oldCard, eOpts )	{
//    			if(panelSearch.getValue('FROM_MONTH') > panelSearch.getValue('TO_MONTH')){
//    				if(!Ext.isEmpty(panelSearch.getValue('TO_MONTH'))){
//					   alert('<t:message code="system.message.human.message025" default="시작일 보다 클 수 없습니다"/>')
//    				}
//					return false;
//				}	
//    		},
    		tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
    			if(newCard.getItemId() == 'hum270skrGrid1')	{
    				UniAppManager.app.onQueryButtonDown();
    			}else if(newCard.getItemId() == 'hum270skrGrid2') {
    				UniAppManager.app.onQueryButtonDown();
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
            	tab, panelResult
	     	]
	     },
	         panelSearch
	    ], 
		id: 'hum270skrApp',
		fnInitBinding: function() {
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
		onQueryButtonDown: function()	{		
			var activeTabId = tab.getActiveTab().getId();		
			if(!this.isValidSearchForm()){
				return false;
			}else{
//				if(panelSearch.getValue('FROM_MONTH') > panelSearch.getValue('TO_MONTH')){
//					if(!Ext.isEmpty(panelSearch.getValue('TO_MONTH'))){
//					   alert('<t:message code="system.message.human.message025" default="시작일 보다 클 수 없습니다"/>');
//					}
//					return false;
//				}else{
				if(Ext.isEmpty(panelSearch.getValue('FROM_MONTH'))){
					alert('정확한 월을 입력하십시오.');
					panelSearch.setValue('FROM_MONTH', '01');
				}else{
					if(activeTabId == 'hum270skrGrid1'){				
						directMasterStore1.loadStoreRecords();				
					}
					else if(activeTabId == 'hum270skrGrid2'){
						directMasterStore2.loadStoreRecords();
					}
				}
				//}
			}
		},		
		/*onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid1.reset();
			masterGrid2.reset();
			
			this.fnInitBinding();
		},*/
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
};


</script>
