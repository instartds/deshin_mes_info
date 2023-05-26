<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="had421skr"  >	
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 -->	
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

	Unilite.defineModel('Had421skrModel', {
	    fields: [  	 
	    	{name: 'GUBUN',				text:'GUBUN',			type:'string'},
	    	{name: 'DIV_CODE',			text:'사업장',			type:'string', comboType: "BOR120"},
	    	{name: 'DEPT_CODE',			text:'부서코드',			type:'string'},
	    	{name: 'DEPT_NAME',			text:'부서명',			type:'string'},
	    	{name: 'POST_CODE',			text:'직위',				type:'string', comboType:'AU', comboCode:'H005'},
	    	{name: 'PERSON_NUMB',		text:'사번',				type:'string'},
	    	{name: 'NAME',				text:'성명',				type:'string'},
	    	{name: 'GIFT_CODE',			text:'기부코드',			type:'string'},
	    	{name: 'GIFT_NAME',			text:'기부명',			type:'string'},
	    	{name: 'GIFT_YYYY',			text:'기부연도',			type:'uniDate'},
	    	{name: 'GIFT_AMOUNT_I',		text:'기부금액',			type:'uniPrice'},
	    	{name: 'BF_DDUC_I',			text:'전년까지공제된금액',	type:'uniPrice'},
	    	{name: 'DDUC_OBJ_I',		text:'공제대상금액',		type:'uniPrice'},
	    	{name: 'PRP_DDUC_I',		text:'당년도공제금액',		type:'uniPrice'},
	    	{name: 'PRP_LAPSE_I',		text:'당년도미공제소멸액',	type:'uniPrice'},
	    	{name: 'PRP_OVER_I',		text:'당년도미공제이월액',	type:'uniPrice'}
			]
	});		// end of Unilite.defineModel('Had421skrModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('had421skrMasterStore1',{
			model: 'Had421skrModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
	            	//비고(*) 사용않함
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'had421skrService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
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
			
	});		// end of var directMasterStore1 = Unilite.createStore('had421skrMasterStore1',{

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
	    		fieldStyle: "text-align:center;",
	    		value : new Date().getFullYear(),
	    		name:'YEAR_YYYY', 
	    		xtype: 'uniYearField', 
	    		allowBlank:false,
	    		value:UniHuman.getTaxReturnYear(),
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('YEAR_YYYY', newValue);
					}
				}
	    	},{
	    		fieldLabel: '사업장',
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
    		value : new Date().getFullYear(),
    		name:'YEAR_YYYY', 
    		xtype: 'uniYearField', 
    		allowBlank:false,
    		value:UniHuman.getTaxReturnYear(),
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('YEAR_YYYY', newValue);
				}
			}
    	},{
    		fieldLabel: '사업장',
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
    
    var masterGrid = Unilite.createGrid('had421skrGrid1', {
    	// for tab    	
        layout : 'fit',
        region:'center',
        sortableColumns: false,
        uniOpt:{
         expandLastColumn: true
        },
    	store: directMasterStore1,
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	          	if(record.get('GUBUN') == '3'){
					cls = 'x-change-cell_dark';
				}
				else if(record.get('GUBUN') == '2'){	//소계
					cls = 'x-change-cell_light';
				}
				return cls;
	        }
	    },
        columns:  [  
//        	{ dataIndex: 'GUBUN',   		width: 150, 	hidden : true},
        	{ dataIndex: 'DIV_CODE',   		width: 150},
//        	{ dataIndex: 'DEPT_CODE',   	width: 90, 	hidden : true},
        	{ dataIndex: 'DEPT_NAME',   	width: 180},
        	{ dataIndex: 'POST_CODE',   	width: 100},
        	{ dataIndex: 'PERSON_NUMB',  	width: 80, 	hidden : true},
        	{ dataIndex: 'NAME',   			width: 100},
//        	{ dataIndex: 'GIFT_CODE',   	width: 80, 		hidden : true},
        	{ dataIndex: 'GIFT_NAME',   	width: 180},
        	{ dataIndex: 'GIFT_YYYY',   	width: 80},
        	{ dataIndex: 'GIFT_AMOUNT_I',   width: 130},
        	{ dataIndex: 'BF_DDUC_I',   	width: 130},
        	{ dataIndex: 'DDUC_OBJ_I',   	width: 130},
        	{ dataIndex: 'PRP_DDUC_I',   	width: 130},
        	{ dataIndex: 'PRP_LAPSE_I',   	width: 130},
        	{ dataIndex: 'PRP_OVER_I',   	width: 130} 								
          ] 
    });		// end of  var masterGrid = Unilite.createGrid('had421skrGrid1', {
	
	
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
		id  : 'had421skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('YEAR_YYYY');
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
