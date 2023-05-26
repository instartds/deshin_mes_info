<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum280skr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="hum280skr"/> 			<!-- 사업장 -->
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
	Unilite.defineModel('Hum280skrModel', {
	    fields: [
             	 {name: 'DIV_NAME'		, text:'<t:message code="system.label.human.division" default="사업장"/>'			, type:'string' },
	             {name: 'COMP_CODE'	, text:'<t:message code="system.label.human.compcode" default="법인코드"/>'			, type: 'string' },
	             {name: 'DIV_CODE'	, text: '<t:message code="system.label.human.division" default="사업장"/>'			, type: 'string' },
	             {name: 'HDEPT'		, text: '<t:message code="system.label.human.department" default="부서"/>'			, type: 'string' },
	             {name: 'JYEAR'		, text: '<t:message code="system.label.human.docyyyy" default="년도"/>'			, type: 'string' },
	             {name: 'M_HIN01'		, text: '<t:message code="system.label.human.join" default="입사"/>'		, type: 'int' },
	             {name: 'F_HIN01'		, text: '<t:message code="system.label.human.join" default="입사"/>'		, type: 'int' },
	             {name: 'M_HIN02'		, text: '<t:message code="system.label.human.join" default="입사"/>'		, type: 'int' },
	             {name: 'F_HIN02'		, text: '<t:message code="system.label.human.join" default="입사"/>'		, type: 'int' },
	             {name: 'M_HIN03'		, text: '<t:message code="system.label.human.join" default="입사"/>'		, type: 'int' },
	             {name: 'F_HIN03'		, text: '<t:message code="system.label.human.join" default="입사"/>'		, type: 'int' },
	             {name: 'M_HIN04'		, text: '<t:message code="system.label.human.join" default="입사"/>'		, type: 'int' },
	             {name: 'F_HIN04'		, text: '<t:message code="system.label.human.join" default="입사"/>'		, type: 'int' },
	             {name: 'M_HIN05'		, text: '<t:message code="system.label.human.join" default="입사"/>'		, type: 'int' },
	             {name: 'F_HIN05'		, text: '<t:message code="system.label.human.join" default="입사"/>'		, type: 'int' },
	             {name: 'M_HIN06'		, text: '<t:message code="system.label.human.join" default="입사"/>'		, type: 'int' },
	             {name: 'F_HIN06'		, text: '<t:message code="system.label.human.join" default="입사"/>'		, type: 'int' },
	             {name: 'M_HIN07'		, text: '<t:message code="system.label.human.join" default="입사"/>'		, type: 'int' },
	             {name: 'F_HIN07'		, text: '<t:message code="system.label.human.join" default="입사"/>'		, type: 'int' },
	             {name: 'M_HIN08'		, text: '<t:message code="system.label.human.join" default="입사"/>'		, type: 'int' },
	             {name: 'F_HIN08'		, text: '<t:message code="system.label.human.join" default="입사"/>'		, type: 'int' },
	             {name: 'M_HIN09'		, text: '<t:message code="system.label.human.join" default="입사"/>'		, type: 'int' },
	             {name: 'F_HIN09'		, text: '<t:message code="system.label.human.join" default="입사"/>'		, type: 'int' },
	             {name: 'M_HIN10'		, text: '<t:message code="system.label.human.join" default="입사"/>'		, type: 'int' },
	             {name: 'F_HIN10'		, text: '<t:message code="system.label.human.join" default="입사"/>'		, type: 'int' },
	             {name: 'M_HIN11'		, text: '<t:message code="system.label.human.join" default="입사"/>'		, type: 'int' },
	             {name: 'F_HIN11'		, text: '<t:message code="system.label.human.join" default="입사"/>'		, type: 'int' },
	             {name: 'M_HIN12'		, text: '<t:message code="system.label.human.join" default="입사"/>'		, type: 'int' },
	             {name: 'F_HIN12'		, text: '<t:message code="system.label.human.join" default="입사"/>'		, type: 'int' },
	             {name: 'M_HINTOT'	, text: '<t:message code="system.label.human.totwagesi" default="합계"/>'		, type: 'int' },
	             {name: 'F_HINTOT'	, text: '<t:message code="system.label.human.totwagesi" default="합계"/>'		, type: 'int' },
	             {name: 'HINTOT'	, text: '<t:message code="system.label.human.totwagesi" default="합계"/>'		, type: 'int' },
	             
	             {name: 'M_HOUT01'	, text: '<t:message code="system.label.human.retr" default="퇴사"/>'		, type: 'int' },
	             {name: 'F_HOUT01'	, text: '<t:message code="system.label.human.retr" default="퇴사"/>'		, type: 'int' },
	             {name: 'M_HOUT02'	, text: '<t:message code="system.label.human.retr" default="퇴사"/>'		, type: 'int' },
	             {name: 'F_HOUT02'	, text: '<t:message code="system.label.human.retr" default="퇴사"/>'		, type: 'int' },
	             {name: 'M_HOUT03'	, text: '<t:message code="system.label.human.retr" default="퇴사"/>'		, type: 'int' },
	             {name: 'F_HOUT03'	, text: '<t:message code="system.label.human.retr" default="퇴사"/>'		, type: 'int' },
	             {name: 'M_HOUT04'	, text: '<t:message code="system.label.human.retr" default="퇴사"/>'		, type: 'int' },
	             {name: 'F_HOUT04'	, text: '<t:message code="system.label.human.retr" default="퇴사"/>'		, type: 'int' },
	             {name: 'M_HOUT05'	, text: '<t:message code="system.label.human.retr" default="퇴사"/>'		, type: 'int' },
	             {name: 'F_HOUT05'	, text: '<t:message code="system.label.human.retr" default="퇴사"/>'		, type: 'int' },
	             {name: 'M_HOUT06'	, text: '<t:message code="system.label.human.retr" default="퇴사"/>'		, type: 'int' },
	             {name: 'F_HOUT06'	, text: '<t:message code="system.label.human.retr" default="퇴사"/>'		, type: 'int' },
	             {name: 'M_HOUT07'	, text: '<t:message code="system.label.human.retr" default="퇴사"/>'		, type: 'int' },
	             {name: 'F_HOUT07'	, text: '<t:message code="system.label.human.retr" default="퇴사"/>'		, type: 'int' },
	             {name: 'M_HOUT08'	, text: '<t:message code="system.label.human.retr" default="퇴사"/>'		, type: 'int' },
	             {name: 'F_HOUT08'	, text: '<t:message code="system.label.human.retr" default="퇴사"/>'		, type: 'int' },
	             {name: 'M_HOUT09'	, text: '<t:message code="system.label.human.retr" default="퇴사"/>'		, type: 'int' },
	             {name: 'F_HOUT09'	, text: '<t:message code="system.label.human.retr" default="퇴사"/>'		, type: 'int' },
	             {name: 'M_HOUT10'	, text: '<t:message code="system.label.human.retr" default="퇴사"/>'		, type: 'int' },
	             {name: 'F_HOUT10'	, text: '<t:message code="system.label.human.retr" default="퇴사"/>'		, type: 'int' },
	             {name: 'M_HOUT11'	, text: '<t:message code="system.label.human.retr" default="퇴사"/>'		, type: 'int' },
	             {name: 'F_HOUT11'	, text: '<t:message code="system.label.human.retr" default="퇴사"/>'		, type: 'int' },
	             {name: 'M_HOUT12'	, text: '<t:message code="system.label.human.retr" default="퇴사"/>'		, type: 'int' },
	             {name: 'F_HOUT12'	, text: '<t:message code="system.label.human.retr" default="퇴사"/>'		, type: 'int' },
	             {name: 'M_HOUTTOT'	, text: '<t:message code="system.label.human.totwagesi" default="합계"/>'		, type: 'int' },
	             {name: 'F_HOUTTOT'	, text: '<t:message code="system.label.human.totwagesi" default="합계"/>'		, type: 'int' },
	             {name: 'HOUTTOT'	, text: '<t:message code="system.label.human.totwagesi" default="합계"/>'		, type: 'int' }
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
	var directMasterStore = Unilite.createStore('hum280skrMasterStore1',{
		model: 'Hum280skrModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: false,			// 수정 모드 사용 
            deletable:false,			// 삭제 가능 여부 
	        useNavi : false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 'hum280skrService.selectDataList'                	
            }
        },
        loadStoreRecords: function(){
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			this.load({
				params: param
			});
		}
        ,listeners:{
			load:function( store, records, successful, operation, eOpts )	{
				if(records && records.length > 0){
					masterGrid.setShowSummaryRow(true);
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
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
				    xtype: 'container',
					layout: {type : 'uniTable', columns : 3},
					width:285,
					
					items :[{
						fieldLabel:'<t:message code="system.label.human.baseyear" default="기준년도"/>',
						allowBlank: false,
						xtype: 'uniYearField',
						value: new Date().getFullYear(),
						name: 'ANN_FR_DATE',
						width:175,
							listeners: {
							change: function(field, newValue, oldValue, eOpts) {      
								panelResult.setValue('ANN_FR_DATE', newValue);
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
						allowBlank: false,
						xtype: 'uniYearField',
						value: new Date().getFullYear(),
						name: 'ANN_TO_DATE', 
						width: 85,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {      
								panelResult.setValue('ANN_TO_DATE', newValue);
							}
						}
					}]
				},{
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
					fieldLabel: '<t:message code="system.label.human.irregularworkinclude" default="비정규직포함"/>',		
					items: [{
						boxLabel: '<t:message code="system.label.human.do" default="한다"/>', 
						width: 70, 
						name: 'PAY_GUBUN',
						inputValue: ''  
					},{
						boxLabel : '<t:message code="system.label.human.donot" default="안한다"/>', 
						width: 70,
						name: 'PAY_GUBUN',
						inputValue: 'Y',
						checked: true
					}],
					listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('PAY_GUBUN').setValue(newValue.PAY_GUBUN);
						UniAppManager.app.onQueryButtonDown();
					}
				}
			}]			
		}]
	});	//end panelSearch  
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
				    xtype: 'container',
					layout: {type : 'uniTable', columns : 3},
					width:285,
					items :[{
						fieldLabel:'<t:message code="system.label.human.baseyear" default="기준년도"/>', 
						allowBlank: false,
						xtype: 'uniYearField',
						value: new Date().getFullYear(),
						name: 'ANN_FR_DATE',
						width:175,
							listeners: {
							change: function(field, newValue, oldValue, eOpts) {      
								panelSearch.setValue('ANN_FR_DATE', newValue);
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
						allowBlank: false,
						xtype: 'uniYearField',
						value: new Date().getFullYear(),
						name: 'ANN_TO_DATE', 
						width: 85,
						listeners: {
							change: function(field, newValue, oldValue, eOpts) {      
								panelSearch.setValue('ANN_TO_DATE', newValue);
							}
						}
					}]
				},{
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
				}),{	
					xtype: 'radiogroup',		            		
					fieldLabel: '<t:message code="system.label.human.irregularworkinclude" default="비정규직포함"/>',	
					items: [{
						boxLabel: '<t:message code="system.label.human.do" default="한다"/>', 
						width: 70, 
						name: 'PAY_GUBUN',
						inputValue: ''  
					},{
						boxLabel : '<t:message code="system.label.human.donot" default="안한다"/>', 
						width: 70,
						name: 'PAY_GUBUN',
						inputValue: 'Y',
						checked: true
					}],
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelSearch.getField('PAY_GUBUN').setValue(newValue.PAY_GUBUN);
							UniAppManager.app.onQueryButtonDown();
						}
					}
			}]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('hum280skrGrid1', {
    	layout : 'fit',
        region : 'center',
        store : directMasterStore,
        selModel:'rowmodel',
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
		store: directMasterStore,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns: [{ 
	        	dataIndex:'DIV_CODE' 	 		, width: 120
					,summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				        return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.human.totwagesi" default="합계"/>', '<t:message code="system.label.human.total" default="총계"/>');
	            }},
		        {dataIndex:'HDEPT' 			, width: 180},
	            {dataIndex:'JYEAR' 			, width: 45},
                { text: '1월'
                	,columns:[
                		{ text: '남성'
                			,columns:[
		                			{dataIndex: 'M_HIN01',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'M_HOUT01',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		},
                		{ text: '여성'
                			,columns:[
		                			{dataIndex: 'F_HIN01',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'F_HOUT01',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		}
                	 ]
                },
                { text: '2월'
                	,columns:[
                		{ text: '남성'
                			,columns:[
		                			{dataIndex: 'M_HIN02',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'M_HOUT02',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		},
                		{ text: '여성'
                			,columns:[
		                			{dataIndex: 'F_HIN02',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'F_HOUT02',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		}
                	 ]
                },
                { text: '3월'
                	,columns:[
                		{ text: '남성'
                			,columns:[
		                			{dataIndex: 'M_HIN03',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'M_HOUT03',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		},
                		{ text: '여성'
                			,columns:[
		                			{dataIndex: 'F_HIN03',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'F_HOUT03',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		}
                	 ]
                },
                { text: '4월'
                	,columns:[
                		{ text: '남성'
                			,columns:[
		                			{dataIndex: 'M_HIN04',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'M_HOUT04',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		},
                		{ text: '여성'
                			,columns:[
		                			{dataIndex: 'F_HIN04',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'F_HOUT04',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		}
                	 ]
                },
                { text: '5월'
                	,columns:[
                		{ text: '남성'
                			,columns:[
		                			{dataIndex: 'M_HIN05',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'M_HOUT05',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		},
                		{ text: '여성'
                			,columns:[
		                			{dataIndex: 'F_HIN05',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'F_HOUT05',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		}
                	 ]
                },
                { text: '6월'
                	,columns:[
                		{ text: '남성'
                			,columns:[
		                			{dataIndex: 'M_HIN06',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'M_HOUT06',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		},
                		{ text: '여성'
                			,columns:[
		                			{dataIndex: 'F_HIN06',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'F_HOUT06',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		}
                	 ]
                },
                { text: '7월'
                	,columns:[
                		{ text: '남성'
                			,columns:[
		                			{dataIndex: 'M_HIN07',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'M_HOUT07',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		},
                		{ text: '여성'
                			,columns:[
		                			{dataIndex: 'F_HIN07',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'F_HOUT07',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		}
                	 ]
                },
                { text: '8월'
                	,columns:[
                		{ text: '남성'
                			,columns:[
		                			{dataIndex: 'M_HIN08',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'M_HOUT08',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		},
                		{ text: '여성'
                			,columns:[
		                			{dataIndex: 'F_HIN08',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'F_HOUT08',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		}
                	 ]
                },
                { text: '9월'
                	,columns:[
                		{ text: '남성'
                			,columns:[
		                			{dataIndex: 'M_HIN09',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'M_HOUT09',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		},
                		{ text: '여성'
                			,columns:[
		                			{dataIndex: 'F_HIN09',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'F_HOUT09',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		}
                	 ]
                },
                { text: '10월'
                	,columns:[
                		{ text: '남성'
                			,columns:[
		                			{dataIndex: 'M_HIN10',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'M_HOUT10',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		},
                		{ text: '여성'
                			,columns:[
		                			{dataIndex: 'F_HIN10',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'F_HOUT10',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		}
                	 ]
                },
                { text: '11월'
                	,columns:[
                		{ text: '남성'
                			,columns:[
		                			{dataIndex: 'M_HIN11',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'M_HOUT11',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		},
                		{ text: '여성'
                			,columns:[
		                			{dataIndex: 'F_HIN11',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'F_HOUT11',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		}
                	 ]
                },
                { text: '12월'
                	,columns:[
                		{ text: '남성'
                			,columns:[
		                			{dataIndex: 'M_HIN12',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'M_HOUT12',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		},
                		{ text: '여성'
                			,columns:[
		                			{dataIndex: 'F_HIN12',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'F_HOUT12',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		}
                	 ]
                },
                { text: '합계'
                	,columns:[
                		{ text: '남성'
                			,columns:[
		                			{dataIndex: 'M_HINTOT',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'M_HOUTTOT',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		},
                		{ text: '여성'
                			,columns:[
		                			{dataIndex: 'F_HINTOT',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
		                	   	   ,{dataIndex: 'F_HOUTTOT',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         		 ]
                		}
                	 ]
                },
                { text: '합계'
                	,columns:[ 	 {dataIndex: 'HINTOT',  width: 45,  text: '<t:message code="system.label.human.join" default="입사"/>', summaryType:'sum', align:'center'}
                				,{dataIndex: 'HOUTTOT',  width: 45,  text: '<t:message code="system.label.human.retr" default="퇴사"/>', summaryType:'sum', align:'center'}
                	         ]
                }
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
		id : 'hum280skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			
			var activeSForm ;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			}else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('ANN_FR_DATE');
					
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
		},  
		onQueryButtonDown : function()	{
			if(!this.isValidSearchForm()){
				return false;
			}else{
				masterGrid.reset();
				masterGrid.getStore().loadStoreRecords();	
			}
		}
		/*onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			
			this.fnInitBinding();
		},*/
	});
};


</script>
