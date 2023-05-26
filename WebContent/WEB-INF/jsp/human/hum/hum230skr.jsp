<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum230skr"  >
	<t:ExtComboStore comboType="BOR120"  /> 		    <!--  사업장 	 -->
	<t:ExtComboStore comboType="AU" comboCode="H173" /> <!--  직렬    -->
	<t:ExtComboStore comboType="AU" comboCode="H072" /> <!--  직종    -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!--  직위    -->
	<t:ExtComboStore comboType="AU" comboCode="H006" /> <!--  직책    -->
	<t:ExtComboStore comboType="AU" comboCode="H094" /> <!--  발령코드 -->

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
	//1:부서발령
	Unilite.defineModel('Hum230skrModel1', {
	    fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.human.division" 			default="사업장"/>'	, type: 'string', comboType:'BOR120'},
			{name: 'PERSON_NUMB'		, text: '<t:message code="system.label.human.personnumb" 		default="사번"/>'		, type: 'string'},
			{name: 'NAME'				, text: '<t:message code="system.label.human.name" 				default="성명"/>'		, type: 'string'},
			
			{name: 'NOW_DEPT_NAME'		, text: '현재부서'																		, type: 'string'},
			{name: 'NOW_ANNOUNCE_DATE'	, text: '<t:message code="system.label.human.announcedate" 		default="발령일자"/>'	, type: 'uniDate'},
			{name: 'NOW_ANNOUNCE_CODE'	, text: '<t:message code="system.label.human.announcecode" 		default="발령코드"/>'	, type: 'string' , comboType: 'AU',comboCode: 'H094'},
			{name: 'NOW_ANNOUNCE_NAME'	, text: '<t:message code="system.label.human.announcereason" 	default="발령사유"/>'	, type: 'string' },
			
			{name: 'AF_DEPT_NAME'		, text: '발령부서'																		, type: 'string'},
			{name: 'ANNOUNCE_DATE'		, text: '<t:message code="system.label.human.announcedate" 		default="발령일자"/>'	, type: 'uniDate'},
			{name: 'ANNOUNCE_CODE'		, text: '<t:message code="system.label.human.announcecode" 		default="발령코드"/>'	, type: 'string' , comboType: 'AU',comboCode: 'H094'},
			{name: 'ANNOUNCE_NAME'		, text: '<t:message code="system.label.human.announcereason" 	default="발령사유"/>'	, type: 'string' }			
			
	    ]
	});
	
	//2:직책발령
	Unilite.defineModel('Hum230skrModel2', {
	    fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.human.division" 			default="사업장"/>'	, type: 'string', comboType:'BOR120'},
			{name: 'PERSON_NUMB'		, text: '<t:message code="system.label.human.personnumb" 		default="사번"/>'		, type: 'string'},
			{name: 'NAME'				, text: '<t:message code="system.label.human.name" 				default="성명"/>'		, type: 'string'},
			
			{name: 'NOW_POST_CODE'		, text: '현재직책'																		, type: 'string' , comboType: 'AU',comboCode: 'H005'},
			{name: 'NOW_ANNOUNCE_DATE'	, text: '<t:message code="system.label.human.announcedate" 		default="발령일자"/>'	, type: 'uniDate'},
			{name: 'NOW_ANNOUNCE_CODE'	, text: '<t:message code="system.label.human.announcecode" 		default="발령코드"/>'	, type: 'string' , comboType: 'AU',comboCode: 'H094'},
			{name: 'NOW_ANNOUNCE_NAME'	, text: '<t:message code="system.label.human.announcereason" 	default="발령사유"/>'	, type: 'string' },
			
			{name: 'POST_CODE'			, text: '이전직책'																		, type: 'string' , comboType: 'AU',comboCode: 'H005'},
			{name: 'ANNOUNCE_DATE'		, text: '<t:message code="system.label.human.announcedate" 		default="발령일자"/>'	, type: 'uniDate'},
			{name: 'ANNOUNCE_CODE'		, text: '<t:message code="system.label.human.announcecode" 		default="발령코드"/>'	, type: 'string' , comboType: 'AU',comboCode: 'H094'},
			{name: 'ANNOUNCE_NAME'		, text: '<t:message code="system.label.human.announcereason" 	default="발령사유"/>'	, type: 'string' }			
			
	    ]
	});
	
	//3:직급발령
	Unilite.defineModel('Hum230skrModel3', {
	    fields: [
			{name: 'DIV_CODE'			, text: '<t:message code="system.label.human.division" 			default="사업장"/>'	, type: 'string', comboType:'BOR120'},
			{name: 'PERSON_NUMB'		, text: '<t:message code="system.label.human.personnumb" 		default="사번"/>'		, type: 'string'},
			{name: 'NAME'				, text: '<t:message code="system.label.human.name" 				default="성명"/>'		, type: 'string'},
			
			{name: 'NOW_ABIL_CODE'		, text: '현재직급'																		, type: 'string' , comboType: 'AU',comboCode: 'H006'},
			{name: 'NOW_ANNOUNCE_DATE'	, text: '<t:message code="system.label.human.announcedate" 		default="발령일자"/>'	, type: 'uniDate'},
			{name: 'NOW_ANNOUNCE_CODE'	, text: '<t:message code="system.label.human.announcecode" 		default="발령코드"/>'	, type: 'string' , comboType: 'AU',comboCode: 'H094'},
			{name: 'NOW_ANNOUNCE_NAME'	, text: '<t:message code="system.label.human.announcereason" 	default="발령사유"/>'	, type: 'string' },
			
			{name: 'ABIL_CODE'			, text: '이전직급'																		, type: 'string' , comboType: 'AU',comboCode: 'H006'},
			{name: 'ANNOUNCE_DATE'		, text: '<t:message code="system.label.human.announcedate" 		default="발령일자"/>'	, type: 'uniDate'},
			{name: 'ANNOUNCE_CODE'		, text: '<t:message code="system.label.human.announcecode" 		default="발령코드"/>'	, type: 'string' , comboType: 'AU',comboCode: 'H094'},
			{name: 'ANNOUNCE_NAME'		, text: '<t:message code="system.label.human.announcereason" 	default="발령사유"/>'	, type: 'string' }			
			
	    ]
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	  }
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('hum230skrMasterStore1',{
		model: 'Hum230skrModel1',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'hum230skrService.selectDataList1'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('resultForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore2 = Unilite.createStore('hum230skrMasterStore2',{
		model: 'Hum230skrModel2',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'hum230skrService.selectDataList1'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('resultForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var directMasterStore3 = Unilite.createStore('hum230skrMasterStore3',{
		model: 'Hum230skrModel3',
		uniOpt: {
            isMaster: false,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'hum230skrService.selectDataList1'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('resultForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm', {    
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        
            items: [{ 
                fieldLabel: '<t:message code="system.label.human.division" default="사업장"/>',
                name: 'DIV_CODE', 
                xtype: 'uniCombobox', 
                comboType:'BOR120',
                value :'01'         
            	},

                {
                    fieldLabel: '<t:message code="system.label.human.announcedate" default="발령일자"/>',
                    xtype: 'uniDateRangefield',
                    startFieldName: 'ANNOUNCE_DATE_FROM',
                    startDate: UniDate.get('startOfMonth'),
                    endFieldName: 'ANNOUNCE_DATE_TO',
                    endDate: UniDate.get('today'),
                    width: 315,
                    textFieldWidth:170
                },
                
                Unilite.popup('Employee',{
                fieldLabel: '<t:message code="system.label.human.employee" default="사원"/>',
                valueFieldName:'PERSON_NUMB',
                textFieldName:'NAME',
                validateBlank:false,
                autoPopup:true,
                listeners: {
	                    onSelected: {
	                        fn: function(records, type) {
	                            panelResult.setValue('DIV_CODE', records[0].DIV_CODE);
	                            //panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
	                            //panelResult.setValue('NAME', panelSearch.getValue('NAME'));                                                                                                             
	                        },
	                        scope: this
	                    },
	                    onClear: function(type)    {
	                        panelResult.setValue('PERSON_NUMB', '');
	                        panelResult.setValue('NAME', '');
	                    },
	                    onValueFieldChange: function(field, newValue){
	                        panelResult.setValue('PERSON_NUMB', newValue);                                
	                    },
	                    onTextFieldChange: function(field, newValue){
	                        panelResult.setValue('NAME', newValue);                
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
	//				textFieldWidth:89,
					textFieldWidth: 159,
					validateBlank:true,
	//				width:300,
					autoPopup:true,
					useLike:true,
					listeners: {
		                'onValueFieldChange': function(field, newValue, oldValue  ){
		                    	//panelResult.setValue('DEPT',newValue);
		                },
		                'onTextFieldChange':  function( field, newValue, oldValue  ){
		                    	//panelResult.setValue('DEPT_NAME',newValue);
		                },
		                'onValuesChange':  function( field, records){
		                    	var tagfield = panelResult.getField('DEPTS') ;
		                    	tagfield.setStoreData(records)
		                }
					}
				}),
                {
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
                        inputValue: 'Z',
                        checked: true
                    },{
                        boxLabel: '<t:message code="system.label.human.retrsp" default="퇴직"/>', 
                        width: 70, 
                        name: 'RDO_TYPE',
                        inputValue: '00000000'  
                    }]
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
                }]
            }]      
    }); //end panelResult  
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('hum230skrGrid1', {
    	layout : 'fit',
        region : 'center',
        store : directMasterStore1, 
        uniOpt:{	
        		expandLastColumn	: false,
        		useRowNumberer		: false,
                useMultipleSorting	: false,
                onLoadSelectFirst	: false,
                state: {
            			useState	: false,
            			useStateList: false
            			}
        		},
        columns: [        
            {dataIndex: 'DIV_CODE'			, width: 130	, text: '<t:message code="system.label.human.division" 	 default="사업장"/>', locked:true },               
            {dataIndex: 'PERSON_NUMB'		, width: 100	, text: '<t:message code="system.label.human.personnumb" default="사번"/>' , locked:true },
            {dataIndex: 'NAME'				, width: 90		, text: '<t:message code="system.label.human.name" 		 default="성명"/>' , locked:true },
                        
            {dataIndex: 'NOW_DEPT_NAME'		, width: 200	, text: '현재 부서' },
            {dataIndex: 'NOW_ANNOUNCE_DATE'	, width: 100	, text: '<t:message code="system.label.human.announcedate" default="발령일자"/>' },
            {dataIndex: 'NOW_ANNOUNCE_CODE'	, width: 80		, text: '<t:message code="system.label.human.announcecode" default="발령코드"/>' , hidden : true},
            {dataIndex: 'NOW_ANNOUNCE_NAME'	, width: 90		, text: '<t:message code="system.label.human.announcereason" default="발령사유"/>' },
            
            {dataIndex: 'AF_DEPT_NAME'		, width: 200	, text: '발령 부서' },
            {dataIndex: 'ANNOUNCE_DATE'		, width: 100	, text: '<t:message code="system.label.human.announcedate" default="발령일자"/>' },
            {dataIndex: 'ANNOUNCE_CODE'		, width: 80		, text: '<t:message code="system.label.human.announcecode" default="발령코드"/>' , hidden : true},
            {dataIndex: 'ANNOUNCE_NAME'		, width: 90		, text: '<t:message code="system.label.human.announcereason" default="발령사유"/>' }
                       
            
         ]  
    });         
    
    var masterGrid2 = Unilite.createGrid('hum230skrGrid2', {
    	layout : 'fit',
        region : 'center',
        store : directMasterStore2, 
        uniOpt:{	
        		expandLastColumn	: false,
        		useRowNumberer		: false,
                useMultipleSorting	: false,
                onLoadSelectFirst	: false,
                state: {
            			useState	: false,
            			useStateList: false
            			}
        		},
        columns: [        
            {dataIndex: 'DIV_CODE'			, width: 130	, text: '<t:message code="system.label.human.division" 	 default="사업장"/>', locked:true },               
            {dataIndex: 'PERSON_NUMB'		, width: 100	, text: '<t:message code="system.label.human.personnumb" default="사번"/>' , locked:true },
            {dataIndex: 'NAME'				, width: 90		, text: '<t:message code="system.label.human.name" 		 default="성명"/>' , locked:true },
                        
            {dataIndex: 'NOW_POST_CODE'		, width: 90		, text: '현재 직책' },
            {dataIndex: 'NOW_ANNOUNCE_DATE'	, width: 100	, text: '<t:message code="system.label.human.announcedate" default="발령일자"/>' },
            {dataIndex: 'NOW_ANNOUNCE_CODE'	, width: 80		, text: '<t:message code="system.label.human.announcecode" default="발령코드"/>' , hidden : true},
            {dataIndex: 'NOW_ANNOUNCE_NAME'	, width: 90		, text: '<t:message code="system.label.human.announcereason" default="발령사유"/>' },
            
            {dataIndex: 'POST_CODE'			, width: 90		, text: '이전 직책' },
            {dataIndex: 'ANNOUNCE_DATE'		, width: 100	, text: '<t:message code="system.label.human.announcedate" default="발령일자"/>' },
            {dataIndex: 'ANNOUNCE_CODE'		, width: 80		, text: '<t:message code="system.label.human.announcecode" default="발령코드"/>' , hidden : true},
            {dataIndex: 'ANNOUNCE_NAME'		, width: 90		, text: '<t:message code="system.label.human.announcereason" default="발령사유"/>' }
                       
            
         ]  
    });  
    
    var masterGrid3 = Unilite.createGrid('hum230skrGrid3', {
    	layout : 'fit',
        region : 'center',
        store : directMasterStore3, 
        uniOpt:{	
        		expandLastColumn	: false,
        		useRowNumberer		: false,
                useMultipleSorting	: false,
                onLoadSelectFirst	: false,
                state: {
            			useState	: false,
            			useStateList: false
            			}
        		},
        columns: [        
            {dataIndex: 'DIV_CODE'			, width: 130	, text: '<t:message code="system.label.human.division" 	 default="사업장"/>', locked:true },               
            {dataIndex: 'PERSON_NUMB'		, width: 100	, text: '<t:message code="system.label.human.personnumb" default="사번"/>' , locked:true },
            {dataIndex: 'NAME'				, width: 90		, text: '<t:message code="system.label.human.name" 		 default="성명"/>' , locked:true },
                        
            {dataIndex: 'NOW_ABIL_CODE'		, width: 100	, text: '현재 직급' },
            {dataIndex: 'NOW_ANNOUNCE_DATE'	, width: 100	, text: '<t:message code="system.label.human.announcedate" default="발령일자"/>' },
            {dataIndex: 'NOW_ANNOUNCE_CODE'	, width: 80		, text: '<t:message code="system.label.human.announcecode" default="발령코드"/>' , hidden : true},
            {dataIndex: 'NOW_ANNOUNCE_NAME'	, width: 90		, text: '<t:message code="system.label.human.announcereason" default="발령사유"/>' },
            
            {dataIndex: 'ABIL_CODE'			, width: 100	, text: '이전 직급' },
            {dataIndex: 'ANNOUNCE_DATE'		, width: 100	, text: '<t:message code="system.label.human.announcedate" default="발령일자"/>' },
            {dataIndex: 'ANNOUNCE_CODE'		, width: 80		, text: '<t:message code="system.label.human.announcecode" default="발령코드"/>' , hidden : true},
            {dataIndex: 'ANNOUNCE_NAME'		, width: 90		, text: '<t:message code="system.label.human.announcereason" default="발령사유"/>' }
                       
            
         ]  
    });
    
	var tab = Unilite.createTabPanel('ham230skrTab',{		
		region		: 'center',
		activeTab	: 0,
		border		: false,
		items		: [{
				title	: '부서발령',
				xtype	: 'container',
				itemId	: 'ham230skrTab1',
				layout	: {type:'vbox', align:'stretch'},
				items	: [
					masterGrid1
				]
			},{
				title	: '직책발령',
				xtype	: 'container',
				itemId	: 'ham230skrTab2',
				layout	: {type:'vbox', align:'stretch'},
				items:[
					masterGrid2
				]
			},{
				title	: '직급발령',
				xtype	: 'container',
				itemId	: 'ham230skrTab3',
				layout	: {type:'vbox', align:'stretch'},
				items:[
					masterGrid3
				]
			}
		],
		listeners:{
			tabchange: function( tabPanel, newCard, oldCard, eOpts )	{
				if(newCard.getItemId() == 'ham230skrTab1')	{
					directMasterStore1.loadStoreRecords();
				}else if(newCard.getItemId() == 'ham230skrTab2') {
                    directMasterStore2.loadStoreRecords();
                }else if(newCard.getItemId() == 'ham230skrTab3') {
                    directMasterStore3.loadStoreRecords();
                }
			}
		}
	})
    
	 Unilite.Main( {
	 	border: false,
		borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                tab, panelResult 
            ]}
		],
		id : 'hum230skrApp',
		fnInitBinding : function() {
			//panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			panelResult.setValue('ANNOUNCE_DATE_FROM',UniDate.get('startOfMonth'));
			panelResult.setValue('ANNOUNCE_DATE_TO',UniDate.get('today'));
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{
			var activeTabId = tab.getActiveTab().getItemId();
            if(activeTabId == 'ham230skrTab1'){
            	directMasterStore1.loadStoreRecords();
//                masterGrid.getStore().loadStoreRecords();
//                masterGrid2.reset();
            }else if(activeTabId == 'ham230skrTab2'){
            	directMasterStore2.loadStoreRecords();
//                adjustGrid.getStore().loadStoreRecords();
            }else if(activeTabId == 'ham230skrTab3'){
            	directMasterStore3.loadStoreRecords();
//                adjustGrid.getStore().loadStoreRecords();
            }
		}
	});
};


</script>
