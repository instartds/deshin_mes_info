<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="had860skr"  >	
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A097" /> <!-- 정산구분 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 -->	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	Ext.create('Ext.data.Store',{
		storeId: "retrTypeStore",
		data:[
			{text: '중도퇴사', value: 'Y'},
			{text: '연말정산', value: 'N'}
		]
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Had860skrModel', {
		fields: [ 
			{name:'GUBUN',					text:'GUBUN',		type:'string'},
			{name:'DIV_CODE',				text:'DIV_CODE',	type:'string'},
			{name:'DIV_NAME',				text:'사업장',		type:'string'},
			{name:'DEPT_NAME',				text:'부서',			type:'string'},
			{name:'POST_CODE',				text:'직위',			type:'string', comboType:'AU', comboCode:'H005'},
			{name:'NAME',					text:'성명',			type:'string'},
			{name:'PERSON_NUMB',			text:'사번',			type:'string'},
			{name:'INCOME_SUPP_TOTAL_I', 	text: '총급여',		type:'uniPrice'},
			{name:'NOW_IN_TAX_I',			text:'기납부소득세',	type:'uniPrice'},
			{name:'NOW_LOCAL_TAX_I',		text:'기납부주민세',	type:'uniPrice'},
			{name:'NOW_SP_TAX_I',			text:'기납부농특세',	type:'uniPrice'},
			{name:'DEF_IN_TAX_I',			text:'결정소득세',		type:'uniPrice'},
			{name:'DEF_SP_TAX_I',			text:'결정농특세',		type:'uniPrice'},
			{name:'DEF_LOCAL_TAX_I',		text:'결정주민세',		type:'uniPrice'},
			{name:'IN_TAX_I',				text:'정산소득세',		type:'uniPrice'},
			{name:'LOCAL_TAX_I',			text:'정산주민세',		type:'uniPrice'},
			{name:'SP_TAX_I',				text:'정산농특세',		type:'uniPrice'},
			{name:'TAX_HAM',				text:'합계',			type:'uniPrice'}
		]	
	});		//End of Unilite.defineModel('Had860skrModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('had860skrMasterStore1',{
			model: 'Had860skrModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi: false			// prev | newxt 버튼 사용
	            	//비고(*) 사용않함
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'had860skrService.selectList'                	
                }
            },
			loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			},
			_onStoreLoad: function ( store, records, successful, eOpts ) {
		    	if(this.uniOpt.isMaster) {
		    		var recLength = 0;
		    		Ext.each(records, function(record, idx){
		    			if(record.get('GUBUN') == '1'){
		    				recLength++;
		    			}
		    		});
			    	if (records) {
				    	UniAppManager.setToolbarButtons('save', false);
						var msg = recLength + Msg.sMB001; //'건이 조회되었습니다.';
				    	//console.log(msg, st);
				    	UniAppManager.updateStatus(msg, true);	
			    	}
		    	}
			}
	});		//End of var directMasterStore = Unilite.createStore('had860skrMasterStore1',{

	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
		width: 380,
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
	       			fieldLabel: '정산년도', 
	       			value: new Date().getFullYear(),
	       			name: 'YEAR_YYYY',
	       			xtype: 'uniYearField',
	       			allowBlank: false,
	       			value:UniHuman.getTaxReturnYear(),
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('YEAR_YYYY', newValue);
						}
					}
	       		},{
	       			fieldLabel: '정산구분',
	       		 	name:'HALF_WAY_TYPE',
	       			xtype: 'uniCombobox',
	       			store: Ext.data.StoreManager.lookup('retrTypeStore'),
   					value:'N',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('HALF_WAY_TYPE', newValue);
						}
					}
	       		},{
	       			fieldLabel: '사업장'	,
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
					fieldLabel: '부서',
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
					validateBlank: false,
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
				})
			]}
	    ]}
	 );		// end of var panelSearch = Unilite.createSearchForm('searchForm',{
	
	 var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
    	items: [{
   			fieldLabel: '정산년도', 
   			value: new Date().getFullYear(),
   			name: 'YEAR_YYYY',
   			xtype: 'uniYearField',
   			allowBlank: false,
   			value:UniHuman.getTaxReturnYear(),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('YEAR_YYYY', newValue);
				}
			}
   		},{
   			fieldLabel: '정산구분',
   		 	name:'HALF_WAY_TYPE',
   			xtype: 'uniCombobox',
   			store: Ext.data.StoreManager.lookup('retrTypeStore'),
   			value:'N',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('HALF_WAY_TYPE', newValue);
				}
			}
   		},{
   			fieldLabel: '사업장'	,
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
			fieldLabel: '부서',
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
		}),			
	     	Unilite.popup('Employee',{ 				
			validateBlank: false,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
						panelSearch.setValue('NAME', panelSearch.getValue('NAME'));
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
		})]
    });
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('had860skrGrid', {
    	// for tab    	
        layout : 'fit',
        region:'center',
        sortableColumns: false,
        uniOpt:{
         expandLastColumn: true
        },
    	store: directMasterStore,
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	          	if(record.get('GUBUN') == '4'){
					cls = 'x-change-cell_dark';
				}
				else if(record.get('GUBUN') == '2' || record.get('GUBUN') == '3'){	//소계
					cls = 'x-change-cell_light';
				}
				return cls;
	        }
	    },
        columns:  [  
//        	{dataIndex: 'GUBUN',   					width: 100},
//        	{dataIndex: 'DIV_CODE',   				width: 100, hidden: true},
        	{dataIndex: 'DIV_NAME',   				width: 150},
        	{dataIndex: 'DEPT_NAME',   				width: 150},
        	{dataIndex: 'POST_CODE',  				width: 100},
        	{dataIndex: 'NAME',   					width: 100},
        	{dataIndex: 'PERSON_NUMB',   			width: 100},
        	{dataIndex: 'INCOME_SUPP_TOTAL_I',   	width: 100},
        	{dataIndex: 'NOW_IN_TAX_I',   			width: 100},
        	{dataIndex: 'NOW_LOCAL_TAX_I',  	 	width: 100},
        	{dataIndex: 'NOW_SP_TAX_I',   			width: 100},
        	{dataIndex: 'DEF_IN_TAX_I',   			width: 100},
        	{dataIndex: 'DEF_SP_TAX_I',   			width: 100},
        	{dataIndex: 'DEF_LOCAL_TAX_I',   		width: 100},
        	{dataIndex: 'IN_TAX_I',   				width: 100},
        	{dataIndex: 'LOCAL_TAX_I',   			width: 100},
        	{dataIndex: 'SP_TAX_I',   				width: 100},
        	{dataIndex: 'TAX_HAM',   				width: 100} 							
        ]  
    });		// end of var masterGrid = Unilite.createGrid('had860skrGrid', {   
	
	
    Unilite.Main({
		borderItems: [{
         	region:'center',
         	layout: 'border',
         	border: false,
         	items:[
           		masterGrid, panelResult
         	]	
      	},
      	panelSearch     
      	],
		id  : 'had860skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{			
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.getStore().loadStoreRecords();
		},
		onDetailButtonDown:function() {
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
