<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="cmb100ukrv"  >
<t:ExtComboStore comboType="AU" comboCode="CD46" />
<t:ExtComboStore comboType="AU" comboCode="CB23" />
<t:ExtComboStore comboType="AU" comboCode="CB46" />
<t:ExtComboStore comboType="AU" comboCode="CB47" />
<t:ExtComboStore comboType="AU" comboCode="B010" />
<t:ExtComboStore items="${SALES_EMP_IDs}" storeId="CMS_SALES_EMP_ID" />
<t:ExtComboStore items="${WRITE_EMP_IDs}" storeId="CMS_WRITE_EMP_ID" />
</t:appConfig>

<script type="text/javascript" >
function appMain()  {

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */		
		
	 var panelSearch = {
		 xtype 	: 'uniSearchForm'
		,id 	: 'searchForm'	
		,layout	: {type: 'table', columns: 2}
		,items	: [ {fieldLabel: '문서번호', id:'S_DOC_NO',   name: 'DOC_NO'}
				   ,{fieldLabel: 'TYPE',    name: 'TYPE', id:'TYPE',  value:'Q', hidden:true}
				  ]
		};

	 /**
     * 계획(Detail Form Panel)
     * @type 
     */
		
	  var cmd100ukrvDetail1 = Ext.create('Unilite.com.form.UniDetailFormSimple', {
	    id : 'cmd100ukrvDetail1'
	    ,layout: {type:'vbox',  align: 'stretch'  }  
	    ,width:850
	    ,autoScroll:true
		,flex:1
	    ,items: [ 
	    		{fieldLabel: '문서번호'	,name: 'DOC_NO', id:'PLAN_DOC_NO', hidden:true}
	    		,{fieldLabel: 'Action_type'	,name:'ACTION_TYPE'			,id:'ACTION_TYPE'	, value:'N_PLAN', hidden:true} //	(N:신규, U:수정, D:삭제)
					     
	            ,{
			    	xtype:'uniFieldset',
			    	title:'계획',
			    	layout: {
			            type: 'uniTable',
			            columns: 3
			    },	
	    		items: [	    
	    			Unilite.popup('CUSTOMER', {fieldLabel:'고객명', textFieldName:'PLAN_CLIENT_NM', showValue : false, width:240, allowBlank:false, listeners: {
						                'onSelected': {
						                    fn: function(records, type) {
						                    	var frm = Ext.getCmp('cmd100ukrvDetail1');
						                    	var rec = records[0];
						                    	frm.setValues({
						                    		'PLAN_CLIENT'			:rec['CLIENT_ID']
						                    		,'PLAN_CUSTOM_NAME' 	:rec['CUSTOM_NAME']
						                    		,'PLAN_CUSTOM_CODE'		:rec['CUSTOM_CODE']
						                    		,'PLAN_DVRY_CUST_NM' 	:rec['DVRY_CUST_NM']
						                    		,'PLAN_DVRY_CUST_CODE'	:rec['DVRY_CUST_SEQ']
						                    	}); // setValue
						                    	//Ext.getCmp('PLAN_CLIENT').setValue(records[0]['CLIENT_ID']);
						                        //Ext.getCmp('PLAN_CUSTOM_NAME').setValue(records[0]['CUSTOM_NAME']);
						                        //Ext.getCmp('PLAN_CUSTOM_CODE').setValue(records[0]['CUSTOM_CODE']);
						                        //Ext.getCmp('PLAN_DVRY_CUST_NM').setValue(records[0]['DVRY_CUST_NM']);
						                        //Ext.getCmp('PLAN_DVRY_CUST_CODE').setValue(records[0]['DVRY_CUST_SEQ']);
						                    },
						                    scope: this
						                }
						            }
								}) // CUSTOMER
				,{fieldLabel: '고객명'		,name:'PLAN_CLIENT'	    	,id:'PLAN_CLIENT'			, hidden:true}
	  			,{fieldLabel: '거래처코드'	,name:'PLAN_CUSTOM_CODE' 	,id:'PLAN_CUSTOM_CODE'		, hidden:true}
	            ,{fieldLabel: '배송처코드'	,name:'PLAN_DVRY_CUST_CODE'	,id:'PLAN_DVRY_CUST_CODE'	, hidden:true}								
	            ,{fieldLabel: '거래처'		,name:'PLAN_CUSTOM_NAME' 	,id:'PLAN_CUSTOM_NAME'		,width:230, readOnly:true}
	            ,{fieldLabel: '배송처'		,name:'PLAN_DVRY_CUST_NM' 	,id:'PLAN_DVRY_CUST_NM'		,width:230, readOnly:true}       
	            ,{fieldLabel: '계획일자'
					               ,xtype: 'fieldcontainer'
					               ,layout: 'hbox'
					               ,width : 280
					               ,defaults: {hideLabel: true}
					               ,items: [ {name:'PLAN_DATE',  width:90	, xtype: 'uniDatefield', allowBlank: false, value:'${param.startDate}'} 
		    							 	,{name:'PLAN_TIME',  width:80	, xtype: 'uniTimefield', value:'${param.startHour}'}
					                ]		               
				            	 }
	            ,{fieldLabel: '계획유형'	,name:'PLAN_SALE_TYPE'		,xtype: 'radiogroup', width: 250
	              , columns: 3
	              ,  items: [
					            { boxLabel: '미팅', name:'SALE_TYPE', inputValue: 'S1', checked: true },
					            { boxLabel: '방문', name:'SALE_TYPE', inputValue: 'S2' },
					            { boxLabel: '출장', name:'SALE_TYPE', inputValue: 'S3' }
            				]}
        		,{fieldLabel: '미팅동반여부',name:'PLAN_GROUP_YN',  xtype: 'checkboxfield',width:180}				
	            ,{fieldLabel: '계획'		,name:'PLAN_TARGET', colspan : 3, width:730}
	            ]
	    }// fieldset
	    ,{
	    	xtype:'uniFieldset',
		    title:'결과',
		    id:'resultFieldSet',
		    collapsible: true,
		    layout: {
		            type: 'uniTable',
		            columns: 3
		        },
	     items :[  Unilite.popup('CUSTOMER',{fieldLabel:'고객명', textFieldName:'RESULT_CLIENT_NM', showValue : false, width:240, allowBlank:false, listeners: {
						                'onSelected': {
						                    fn: function(records, type) {
						                    	var frm = Ext.getCmp('cmd100ukrvDetail1');
						                    	var rec = records[0];
						                    	frm.setValues({
						                    		'RESULT_CLIENT'			:rec['CLIENT_ID']
						                    		,'CUSTOM_NAME'			:rec['CUSTOM_NAME']
						                    		,'CUSTOM_CODE' 			:rec['CUSTOM_CODE']
						                    		,'DVRY_CUST_NM'			:rec['DVRY_CUST_NM']
						                    		,'DVRY_CUST_SEQ'		:rec['DVRY_CUST_SEQ']
						                    		,'PROCESS_TYPE'			:rec['PROCESS_TYPE']
						                    	}); // setValue
						                    	
						                    },
						                    scope: this
						                }
						            }
								}) 
		            ,{fieldLabel: '고객CD'		,name:'RESULT_CLIENT'	, id:'RESULT_CLIENT', hidden:true, allowBlank: false} 
		            ,{fieldLabel: '고객etc'		,name:'RESULT_ETC_CLIENT_NM', hidden:true}
		            
		            ,{fieldLabel: '실행일자'
					               ,xtype: 'fieldcontainer'
					               ,layout: 'hbox'
					               ,width : 280
					               ,defaults: { hideLabel: true}
					               ,items: [ {name:'RESULT_DATE',  width:90	, xtype: 'uniDatefield', allowBlank: false} 
		    							 	,{name:'RESULT_TIME',  width:80		, xtype: 'uniTimefield' } 
					                ]		               
				            	 }
				            	 
		    		
		    		,{fieldLabel: '영업유형'	,name:'SALE_TYPE'		, labelWidth:50	, xtype: 'uniCombobox', comboType:'AU',comboCode:'CD46' , allowBlank: false}		    			    		
		            ,{fieldLabel: '거래처'		,name:'CUSTOM_NAME', id:'CUSTOM_NAME', readOnly:true, width:240}
		            ,{fieldLabel: '거래처'		,name:'CUSTOM_CODE', id:'CUSTOM_CODE', hidden:true}
		            
		            ,{fieldLabel: '배송처'		,name:'DVRY_CUST_NM',	id:'DVRY_CUST_NM'	, readOnly:true}
		            ,{fieldLabel: '배송처'		,name:'DVRY_CUST_SEQ'	,id:'DVRY_CUST_SEQ', hidden:true}
		            
		            ,{fieldLabel: '상태'  		,name:'PROCESS_TYPE', 	id:'PROCESS_TYPE', labelWidth:50	, xtype: 'uniCombobox', comboType:'AU',comboCode:'CB46', allowBlank: false}		            
		            ,{fieldLabel: '영업기회'	,name:'PROJECT_NO_NM' ,width:240, readOnly:true}          
		            ,{fieldLabel: '현사용제품'	,name:'ITEM_NAME'		, readOnly:true}
		            ,{fieldLabel: '중요도'		,name:'IMPORTANCE_STATUS' , labelWidth:50	, xtype: 'uniCombobox', comboType:'AU',comboCode:'CB23'}
		            ,{fieldLabel: '영업담당자'	,name:'SALE_EMP' 		,width:240  , xtype : 'uniCombobox', allowBlank: false, store: Ext.data.StoreManager.lookup('CMS_SALES_EMP_ID')}//,  allowBlank: false},	//btnSaleEmp
		            ,{fieldLabel: '영업참석자'	,name:'SALE_ATTEND'		, colspan : 2, width : 522} 				            
		            ,{fieldLabel: '현황요약'	,name:'SUMMARY_STR'		, colspan : 3, width : 765} 				            
		            ,{fieldLabel: '내용'		,name:'CONTENT_STR'		, xtype: 'textareafield', grow : true, colspan : 3, width : 765, height : 200} 				            
		            ,{fieldLabel: '요청사항'	,name:'REQ_STR'			, colspan : 3, width : 765} 		
		            ,{fieldLabel: '소견/작성자'
		            			   ,colspan:3
					               ,xtype: 'fieldcontainer'
					               ,layout: 'hbox'
					               ,width : 765
					               ,defaults: { hideLabel: true}
					               ,items: [ 
								            {name:'OPINION_STR', xtype: 'textfield'		,width : 500} 		
								            ,{name:'WRITE_EMP1' , xtype : 'uniCombobox', store: Ext.data.StoreManager.lookup('CMS_SALES_EMP_ID'), width : 120}
								            ,{xtype:'button',text:'+'	, width : 20
								            	, handler: function(){
								            			console.log('11');
									            		if(Ext.getCmp('OPINION_STR2').isHidden()){
									            			Ext.getCmp('OPINION_STR2').show();
									            		}else if(Ext.getCmp('OPINION_STR3').isHidden()){
									            			Ext.getCmp('OPINION_STR3').show();
									            		}else {
									            			alert('최대 입력가능 소견은 3개 입니다.');
									            		}
								            		} 		
								              
								              
								             }
								            ,{xtype:'button',text:'-'	, width : 20
								            	, handler: function(){
									            		if(Ext.getCmp('OPINION_STR3').isVisible()){
									            			Ext.getCmp('OPINION_STR3').hide();									            			
									            		}else if(Ext.getCmp('OPINION_STR2').isVisible()){
									            			Ext.getCmp('OPINION_STR2').hide();									            			
									            		}else {
									            			alert('소견은 최소 한 개 이상은 필요합니다.');
									            		}
								            			//Ext.getCmp('OPINION_STR2').setVisible(true);
								            		} 		
								              
								              
								             }
								            ]
		            }
		            
		            ,{fieldLabel: '소견/작성자2'
		            			   ,colspan:3
		            			   ,id:'OPINION_STR2'
					               ,xtype: 'fieldcontainer'
					               ,layout: 'hbox'
					               ,width : 765
					               ,autoRender:true
					               ,hidden : true
					               ,defaults: { hideLabel: true}
					               ,items: [ 
								            {name:'OPINION_STR2', xtype: 'textfield'		,width : 500} 		
								            ,{name:'WRITE_EMP2' , xtype : 'uniCombobox', store: Ext.data.StoreManager.lookup('CMS_SALES_EMP_ID'), width : 120}
								            
								              
								              
								            ]
					}
		            ,{fieldLabel: '소견/작성자3'
		            			   ,colspan:3
		            			   ,id:'OPINION_STR3'
					               ,xtype: 'fieldcontainer'
					               ,layout: 'hbox'
					               ,width : 765
					               ,autoRender:true
					               ,hidden : true
					               ,defaults: { hideLabel: true }
					               ,items: [ 
								            {name:'OPINION_STR3', xtype: 'textfield'		,width : 500} 		
								            ,{name:'WRITE_EMP3' , xtype : 'uniCombobox', store: Ext.data.StoreManager.lookup('CMS_SALES_EMP_ID'), width : 120}
								            		
								            ]
		            }
		            ,{fieldLabel: '비고'		,name:'REMARK'			, colspan : 3, width : 765} 				            
		            ,{fieldLabel: 'Keyword'		,name:'KEYWORD'			, colspan : 3, width : 765}
		            
			     
				   ]}]
        	,api: {
				load: 'cmd100ukrvService.select'
				,submit: 'cmd100ukrvService.syncAll'				
			}
	});
	
	   
	var tab = Ext.create('Ext.tab.Panel', {
	   flex : 1,
	   id : 'cmd100ukrv100Tab',
	    activeTab: 0,
	    bodyPadding: 5,
	    tabPosition: 'top',
	    items: [
	        {
	            title: '계획',
	            id : 'planTab',
	            xtype  : 'container',
	            layout : 'fit',
	            items : [cmd100ukrvDetail1]
	        },
	        {
	            title: '결과',
	            id : 'resultTab',
	           	xtype  : 'container',
	            layout : {	
	            	type:'vbox', //type:'fit'
	            	align: 'stretch' 
	            },
	            items : [/* cmd100ukrvDetail1,cmd100ukrvDetaiL2 */ ]   
	        }
	    ]
	    
	});
	
 	var app =  Ext.create('Unilite.com.BaseApp', {
		items : [cmd100ukrvDetail1],
		autoScroll:true,
		id  : 'cmd100ukrvApp',
		pgmId : 'cmd100ukrv',
		fnInitBinding : function() {
			var me = this;
			me.setToolbarButtons('query',false);
			me.setToolbarButtons('reset',true);
			me.setToolbarButtons('save',true);
			
			console.log("DOC_NO","${param.DOC_ID}");
			console.log("startDate","${param.startDate}");
			var docId = '${param.DOC_ID}';
			var startDate = '${param.startDate}';
			if(!Ext.isEmpty(docId)) {
				me._loadData(docId);
			}
			if(!Ext.isEmpty(startDate)) {
				var fieldSet = Ext.getCmp('resultFieldSet');
				fieldSet.collapse();
				
			}
		},
		_loadData:function(docId) {
			var detailForm1 = Ext.getCmp('cmd100ukrvDetail1');
			
			var param = {'DOC_NO':docId, 'TYPE':'Q'};
			
			detailForm1.getForm().load({
				 params : param				 
			});
		},
		
		onQueryButtonDown : function()	{
			var detailForm1 = Ext.getCmp('cmd100ukrvDetail1');
			
			detailForm1.reset(true);
			var param= Ext.getCmp('searchForm').getValues();
			console.log( "detailForm1", param );
			detailForm1.getForm().load({
				 params : param
			});
			
			var detailForm2 = Ext.getCmp('cmd100ukrvDetail2');
			detailForm2.reset(true);
			console.log( "detailForm2",param );
			detailForm2.getForm().load({
				 params : param				 
			});

			this.setToolbarButtons(['reset','delete'],true);
			
			Ext.getCmp('S_DOC_NO').setValue(Ext.getCmp('PLAN_DOC_NO').getValue());

		},
		onNewDataButtonDown : function()	{
			Ext.getCmp('cmd100ukrvDetail').reset(true);
		},		
		
		onSaveDataButtonDown: function () {
			console.log('Save');
			var frm = Ext.getCmp('cmd100ukrvDetail1');
			var param= frm.getValues();
			console.log( "detailForm1", param );
			frm.getForm().submit({
				 params : param				 
			});
			/*
			var activeTab = Ext.getCmp('cmd100ukrv100Tab').getActiveTab().getId();
			console.log('getActiveTab', activeTab);
			
			
			if(activeTab == 'planTab') {
				var detailForm1 = Ext.getCmp('cmd100ukrvDetail1');
				var param= Ext.getCmp('cmd100ukrvDetail1').getValues();
				console.log( "detailForm1", param );
				detailForm1.getForm().submit({
					 params : param				 
				});
			} else if(activeTab == 'resultTab') {
				var detailForm2 = Ext.getCmp('cmd100ukrvDetail2');
				var param2= Ext.getCmp('cmd100ukrvDetail2').getValues();
				console.log( "detailForm2",param2 );
				detailForm2.getForm().submit({
					 params : param2				 
				});
			}
			*/
			
			
		},
		
		onDeleteDataButtonDown : function()	{
	       if(confirm('현재내용을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				cmd100ukrvDetail.getStore().remove(0);
			}
		},
		
		onResetButtonDown:function() {
			var frm = Ext.getCmp('searchForm');
			var detailFrm = Ext.getCmp('cmd100ukrvDetail');		
			frm.getForm().reset();
			detailFrm.reset(true);
			
		}
	});

};

</script>