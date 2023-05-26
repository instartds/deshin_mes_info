<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="cmd100ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="CD46" />
	<t:ExtComboStore comboType="AU" comboCode="CB23" />
	<t:ExtComboStore comboType="AU" comboCode="CB46" />
	<t:ExtComboStore comboType="AU" comboCode="CB47" />
	<t:ExtComboStore comboType="AU" comboCode="B010" />
	<t:ExtComboStore comboType="AU" comboCode="CB10" />
	<t:ExtComboStore comboType="AU" comboCode="CB48" />  <!-- 영업담당자 -->
	<t:ExtComboStore comboType="AU" comboCode="CB50" />
</t:appConfig>

<script type="text/javascript" >
function appMain()  {
	
		

		
	
	  var detailForm = Unilite.createSimpleForm( 'detailForm', {
	    layout: {type:'vbox',  align: 'stretch'  }  
	    ,width:850
	    ,autoScroll:true
	    ,pollInterval :500
	    ,items: [ 
	    		 
	    		{	xtype:'uniFieldset',
			    	title:'기본정보',
			    	id : 'infoFieldSet',
			    	layout: {
			            type: 'uniTable',
			            columns: 3
					},	
			    	items: [ {fieldLabel: '문서번호'	,name: 'DOC_NO'		,  id:'PLAN_DOC_NO', hidden:true}
	    					,{fieldLabel: 'Action_type'	,name:'ACTION_TYPE'	,  id:'PLAN_ACTIVE_TYPE', value:'N_PLAN', hidden:true} //	(N:신규, U:수정, D:삭제)
				    		,Unilite.popup('CLIENT_PROJECT2', {fieldLabel:'고객명', showValue : false, width:280, allowBlank:false, extParam : {RDO : '2'} ,
				    								listeners: {
											                'onSelected': function(records, type) {
											                    	var frm = Ext.getCmp('detailForm');
											                    	var rec = records[0];
											                    	
											                    	frm.setValues({
											                    		 'CLIENT'			:rec['CLIENT_ID']
											                    		,'PROJECT_NO'		:rec['PROJECT_NO']
											                    		,'PROJECT_NO_NM'		:rec['PROJECT_NAME']
											                    		,'CUSTOM_NAME' 		:rec['CUSTOM_NAME']
											                    		,'CUSTOM_CODE'		:rec['CUSTOM_CODE']
											                    		,'ITEM_NAME'		:rec['ITEM_NAME']
											                    		,'ITEM_CODE'		:rec['ITEM_CODE']
											                    		
											                    		//,'DVRY_CUST_NM' 	:rec['DVRY_CUST_NM']
											                    		//,'DVRY_CUST_SEQ'	:rec['DVRY_CUST_SEQ']
											                    	}); 
											                    },
											                    'onClear' : function() {
											                    	var frm = Ext.getCmp('detailForm');
											                    	frm.setValues({
											                    		 'CLIENT'			:''
											                    		,'CUSTOM_NAME' 		:''
											                    		,'CUSTOM_CODE'		:''
											                    		,'PROJECT_NM'		:''
											                    		,'PROJECT_NO_NM'		:''
											                    		,'ITEM_NAME'		:''
											                    		,'ITEM_CODE'		:''
											                    		//,'DVRY_CUST_NM' 	:''
											                    		//,'DVRY_CUST_SEQ'	:''
											                    	}); 
											                    }
											            }
											            
													}) // CUSTOMER
							//,{fieldLabel: '고객ID'		,name:'CLIENT'	    	, hidden:true}
							,{fieldLabel: '영업유형'	,name:'SALE_TYPE'		, xtype: 'uniCombobox', comboType:'AU',comboCode:'CD46' , allowBlank: false}
							,{fieldLabel: '영업기회번호',name:'PROJECT_NO' 		, readOnly:true, hidden:true}   
		            		,{fieldLabel: '영업기회'	,name:'PROJECT_NO_NM' 		, readOnly:true}     
			  				,{fieldLabel: '거래처코드'	,name:'CUSTOM_CODE' 	, hidden:true}
				            ,{fieldLabel: '배송처코드'	,name:'DVRY_CUST_SEQ'	, hidden:true}								
				            ,{fieldLabel: '거래처'		,name:'CUSTOM_NAME' 	, readOnly:true}
				            ,{fieldLabel: '배송처'		,name:'DVRY_CUST_NM' 	, readOnly:true, hidden:true}    
				            ,{fieldLabel: '제품'	,name:'ITEM_NAME'		, readOnly:true}	
				            ,{fieldLabel: '파일번호'	,name:'FILE_NO'			,readOnly:true, hidden:true}	
				            ,{fieldLabel: '파일등록구분',name:'DOC_TYPE'	, value:'DM'	,readOnly:true, hidden:true}		            
				            ,{fieldLabel: '파일등록상세',name:'OPINION_TYPE', value:'FL'	,readOnly:true, hidden:true}
				            ,{fieldLabel: '삭제파일FID'	,name:'DEL_FID', readOnly:true, hidden:true}
				            ,{fieldLabel: '등록파일FID'	,name:'ADD_FID', value:'000' 	,readOnly:true, hidden:true}
					]
	    		}
				,{	xtype:'uniFieldset',
			    	title:'계획',
			    	id:'planFieldSet',
			    	collapsible: false,
			    	layout: {
			            type: 'uniTable',
			            columns: 3
					},	
			    	items: [	    
			    		 {xtype:'checkbox', fieldLabel: '저장여부',  name:'PLAN_SAVE_YN', inputValue :'Y'}	
						 ,{fieldLabel: '계획일자'
							               ,xtype: 'fieldcontainer'
							               ,layout: 'hbox'
							               ,width : 280
							               ,defaults: {hideLabel: true}
							               ,items: [ {name:'PLAN_DATE',  width:90	, xtype: 'uniDatefield', value:'${param.startDate}', allowBlank: true, fieldCls :'x-form-field x-form-required-field'} 
				    							 	,{name:'PLAN_TIME',  width:90	, xtype: 'uniTimefield', value:'${param.startHour}', fieldCls:'x-form-field x-form-required-field'}
							                ]		               
						            	 }
		        		,{fieldLabel: '미팅동반여부',name:'PLAN_GROUP_YN',  xtype: 'checkboxfield', width:480,  inputValue:'Y'}				
			            ,{fieldLabel: '계획'		,name:'PLAN_TARGET', width:750 ,colspan:3}
			            
			            ] 
			        ,listeners : {
			        	/*beforecollapse : function ( fieldset, eOpts )	{
			        		var frm = Ext.getCmp('detailForm');
			        		if(frm.getValue('PLAN_SAVE_YN') != '')	{
				        		if(confirm('계획을 숨기면 계획내용이 저장되않습니다. 숨기시겠습니까?'))	{
				        			frm.setValue('PLAN_SAVE_YN','N');
				        		}else {
				        			frm.setValue('PLAN_SAVE_YN','Y');
				        			return false;
				        		}
			        		}
			        	},
			        	 expand  :  function ( fieldset, eOpts )	{
			        		var frm = Ext.getCmp('detailForm');
			        		frm.setValue('PLAN_SAVE_YN','Y');
			        	}*/
			        }
				}
	    	,{
	    	xtype:'uniFieldset',
		    title:'결과',
		    id:'resultFieldSet',
		    collapsible: false,
		    layout: {
		            type: 'uniTable',
		            columns: 3
		        },
	     items :[   
	     			{xtype:'checkbox', fieldLabel: '저장여부',  name:'RESULT_SAVE_YN', inputValue :'Y' }
	     			,{fieldLabel: '실행일자' , colspan:2
					               ,xtype: 'fieldcontainer'
					               ,layout: 'hbox'
					               ,width : 320, labelWidth:114
					               ,defaults: { hideLabel: true}
					               ,items: [ {name:'RESULT_DATE',  width:90		, xtype: 'uniDatefield', value:'${param.startDate}', allowBlank: true, fieldCls:'x-form-field x-form-required-field'} 
		    							 	,{name:'RESULT_TIME',  width:90		, xtype: 'uniTimefield', value:'${param.startHour}', allowBlank: true, fieldCls:'x-form-field x-form-required-field'} 
					                ]		               
				            	 }
		            ,{fieldLabel: '영업담당자'	,name:'SALE_EMP' 		, xtype : 'uniCombobox', allowBlank: true, fieldCls:'x-form-field x-form-required-field', comboType:'AU',comboCode:'CB48'}//,  allowBlank: false},	//btnSaleEmp
		            ,{fieldLabel: '영업참석자'	,name:'SALE_ATTEND'		, colspan : 2, width : 515, labelWidth:114} 				            
		            ,{fieldLabel: '상태'  		,name:'SALE_STATUS' 	,  xtype: 'uniCombobox', comboType:'AU',comboCode:'CB46', allowBlank: true ,  fieldCls:'x-form-field x-form-required-field'}		            
		            ,{fieldLabel: '중요도'		,name:'IMPORTANCE_STATUS', xtype: 'uniCombobox', comboType:'AU',comboCode:'CB23',labelWidth:114}
		            ,{fieldLabel: '확률'		,name:'SALES_PROJECTION', xtype: 'uniNumberfield', minValue:0, maxValue:100, value:0, decimalPrecision:2,width:230,labelWidth:60, suffixTpl:'&nbsp;%'}
		            ,{fieldLabel: '현황요약'	,name:'SUMMARY_STR'		, colspan : 3, width : 754, maxLength:200} 				            
		            ,{fieldLabel: '내용'		,name:'CONTENT_STR'		, xtype: 'textareafield', grow : true, colspan : 3, width : 754, height : 170} 	// 15줄 : 200			            
		            ,{fieldLabel: '요청사항'	,name:'REQ_STR'			, colspan : 3, width : 754} 		
		            ,{fieldLabel: '소견/작성자'
		            			   ,colspan:3
					               ,xtype: 'fieldcontainer'
					               ,layout: 'hbox'
					               ,width : 765
					               ,defaults: { hideLabel: true}
					               ,items: [ 
								            {name:'OPINION_STR', xtype: 'textfield'		,width : 510} 		
								            ,{name:'WRITE_EMP1' , xtype : 'uniCombobox', comboType:'AU',comboCode:'CB50', width : 120}
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
								            			var frm = Ext.getCmp('detailForm');
									            		if(Ext.getCmp('OPINION_STR3').isVisible()){
									            			Ext.getCmp('OPINION_STR3').hide();			
									            			frm.setValue('OPINION_STR3','','WRITE_EMP3','');
									            		}else if(Ext.getCmp('OPINION_STR2').isVisible()){
									            			Ext.getCmp('OPINION_STR2').hide();				
									            			frm.setValue('OPINION_STR2','','WRITE_EMP2','');
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
								            {name:'OPINION_STR2', xtype: 'textfield'		,width : 510} 		
								            ,{name:'WRITE_EMP2' , xtype : 'uniCombobox', comboType:'AU',comboCode:'CB50', width : 120}
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
								            {name:'OPINION_STR3', xtype: 'textfield'		,width : 510} 		
								            ,{name:'WRITE_EMP3' , xtype : 'uniCombobox', comboType:'AU',comboCode:'CB50', width : 120}
								            		
								            ]
		            }
		            
		            
				]
				
			},
			 {
			     			xtype:'xuploadpanel',
			     			id : 'cmd200ukrvFileUploadPanel',
					    	itemId:'fileUploadPanel',
					    	height: 200,
					    	flex:1,
					    	listeners : {
					    		change: function() {
					    			UniAppManager.setToolbarButtons('save', true);
					    		}
					    	}
				    	} 
	     ]
			,api: {
				   load: 'cmd100ukrvService.select'
				,submit: 'cmd100ukrvService.syncAll'				
			}
			, listeners : {
					dirtychange:function( basicForm, dirty, eOpts ) {
						console.log("onDirtyChange");
						UniAppManager.setToolbarButtons('save', true);
					}
					
			}
	});
	
	
	
 	Unilite.PopupMain({
		items : [detailForm],
		autoScroll:true,
		overflowY : 'auto',
		overflowX : 'auto',
		id  : 'cmd100ukrvApp',
		pgmId : 'cmd100ukrv',
		fnInitBinding : function() {
			var me = this;
			UniAppManager.setToolbarButtons(['query','reset','save'],false);			
			UniAppManager.setToolbarButtons('delete',true);
			
			var docId = '${param.DOC_ID}';
			var startDate = '${param.startDate}';
			if(!Ext.isEmpty(docId)) {
				me._loadData(docId);
			}else {
				detailForm.setValue('PLAN_SAVE_YN','N');
				detailForm.setValue('RESULT_SAVE_YN','N');
			}
			/*else if(!Ext.isEmpty(startDate)) {
				detailForm.setValue('PLAN_SAVE_YN','Y');
				detailForm.setValue('RESULT_SAVE_YN','N');
			}else {
				detailForm.setValue('PLAN_SAVE_YN','Y');
				detailForm.setValue('RESULT_SAVE_YN','Y');
			}*/
			var planHour = '${param.startHour}';
			if(planHour == '0000')	{
				console.log("PLAN_TIME : ", detailForm.getValue('PLAN_TIME'));
				detailForm.setValue('PLAN_TIME','0800');
				detailForm.setValue('RESULT_TIME','0800');
			}			
		},
		_loadData:function(docId) {
			var me = this;
			var detailForm = Ext.getCmp('detailForm');
			
			var param = {'DOC_NO':docId, 'TYPE':'Q'};
			
			detailForm.getForm().load({
				 params : param	
				 , success:function() {
							me._onLoaded();
							console.log("PLAN_DATE :" , detailForm.getValue('PLAN_DATE'));
							
							if(detailForm.getValue('PLAN_DATE') != null )	{
								detailForm.setValue('PLAN_SAVE_YN','Y')
							}else {
								detailForm.setValue('PLAN_SAVE_YN','N')
							}
							
							if(detailForm.getValue('RESULT_DATE') != null )	{
								
								detailForm.setValue('RESULT_SAVE_YN','Y')
							}else {
								detailForm.setValue('RESULT_SAVE_YN','N')
							}
							if(detailForm.getValue('OPINION_STR2') != null && detailForm.getValue('OPINION_STR2') != '' )	{
								if(Ext.getCmp('OPINION_STR2').isHidden()){
			            			Ext.getCmp('OPINION_STR2').show();
			            		} 
							}
							
							if(detailForm.getValue('OPINION_STR3') != null && detailForm.getValue('OPINION_STR3') != ''  )	{
								if(Ext.getCmp('OPINION_STR3').isHidden()){
			            			Ext.getCmp('OPINION_STR3').show();
			            		}
							}
	
				 }			 
			});		
		},
		
		
		_onLoaded: function () {
			var detailForm1 = Ext.getCmp('detailForm');
			// 첨부파일 조회
			var fileNO = detailForm.getValue('FILE_NO');
			//if(fileNO && fileNO != '')	{
			bdc100ukrvService.getFileList({DOC_NO : fileNO},
																function(provider, response) {
																	var fp = Ext.getCmp('cmd200ukrvFileUploadPanel');
																	fp.loadData(response.result);
																}
															 )
			//}
		},
		
		onSaveDataButtonDown: function () {
			console.log('Save');
			var me = this;
			var detailForm = Ext.getCmp('detailForm');
			var saved = false;
			
			
			//if(detailForm.isDirty()) {
				var param= detailForm.getValues();
				console.log( "detailForm", param );
				console.log( "PLAN_SAVE_YN : ", detailForm.getField('PLAN_SAVE_YN').getSubmitValue() );
				console.log( "RESULT_SAVE_YN : ", detailForm.getField('RESULT_SAVE_YN').getSubmitValue() );
				var rt = false;	
				
				if(detailForm.getField('PLAN_SAVE_YN').getSubmitValue()!='Y' && detailForm.getField('RESULT_SAVE_YN').getSubmitValue()!='Y')	{
					if(rt != true)	{
						alert('계획/결과 중 저장여부를 선택하세요.');
						detailForm.getField('PLAN_SAVE_YN').focus();
						return false;
					}
				}
				
				if(detailForm.getField('PLAN_SAVE_YN').getSubmitValue()=='Y')	{
					rt =  detailForm.checkManadatory(['PLAN_DATE','PLAN_TIME']);
					console.log("rt : ",rt);
					if(rt != true)	{
						alert(Msg.sMB083);
						rt.focus();
						return false;
					}
				}

				if(detailForm.getField('RESULT_SAVE_YN').getSubmitValue()=='Y')	{
					rt =  detailForm.checkManadatory(['RESULT_DATE','RESULT_TIME','SALE_STATUS','SALE_EMP']);
					console.log("rt : ",rt);
					if(rt != true)	{
						alert(Msg.sMB083);
						rt.focus();
						return false;
					}
					 
					console.log("detailForm.getField('WRITE_EMP2') : ", detailForm.getField('WRITE_EMP2').getValue());
					if((detailForm.getField('OPINION_STR') !=null && detailForm.getField('OPINION_STR').getValue() != '') ||
						(detailForm.getField('WRITE_EMP1').getValue() !=null	) 	)	{
						rt =  detailForm.checkManadatory(['OPINION_STR','WRITE_EMP1']);
						console.log("rt : ",rt);
						if(rt != true)	{
							alert(Msg.sMB083);
							rt.focus();
							return false;
						}
					}
					if((detailForm.getField('OPINION_STR2') !=null && detailForm.getField('OPINION_STR2').getValue() != '') ||
						(detailForm.getField('WRITE_EMP2').getValue() !=null )	)	{
						rt =  detailForm.checkManadatory(['OPINION_STR2','WRITE_EMP2']);
						console.log("rt : ",rt);
						if(rt != true)	{
							alert(Msg.sMB083);
							rt.focus();
							return false;
						}
					}
					if((detailForm.getField('OPINION_STR3') !=null && detailForm.getField('OPINION_STR3').getValue() != '') ||
						(detailForm.getField('WRITE_EMP3').getValue() !=null )	)	{
						rt =  detailForm.checkManadatory(['OPINION_STR3','WRITE_EMP3']);
						console.log("rt : ",rt);
						if(rt != true)	{
							alert(Msg.sMB083);
							rt.focus();
							return false;
						}
					}
					
					if((detailForm.getField('SALES_PROJECTION') !=null && detailForm.getField('SALES_PROJECTION').getValue() != '') )	{
						rt =  detailForm.checkManadatory(['SALES_PROJECTION']);
						console.log("rt : ",rt);
						if(rt != true)	{
							detailForm.setValue('SALES_PROJECTION','0.0');
							rt=true;
						}
					}
					
				}
				
				//첨부파일 추가/삭제 목록
				var fp = Ext.getCmp('cmd200ukrvFileUploadPanel');
				var addFiles = fp.getAddFiles();
				var removeFiles = fp.getRemoveFiles();
				detailForm.setValue('ADD_FID', addFiles);
				detailForm.setValue('DEL_FID', removeFiles);
				
				
				if(rt == true)	{
					detailForm.getForm().submit({
						 params : param,
						 success : function(form, action) {me._onSaved(action);}	
					});
				}
			//}
		},
		_onSaved: function(action) {
			detailForm.setValue("DOC_NO", action.result.DOC_NO);
			//detailForm.getForm().wasDirty = false;
			detailForm.resetDirtyStatus();
			console.log("set was dirty to false");
			UniAppManager.setToolbarButtons('save', false);
			Ext.getBody().unmask();
		},
		
		onDeleteDataButtonDown: function()	{
	       if(confirm('현재내용을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				//cmd100ukrvDetail.getStore().remove(0);
				var detailForm1 = Ext.getCmp('detailForm');
				var param = {'DOC_NO' : detailForm1.getValue('DOC_NO')
							 ,'FILE_NO' : detailForm1.getValue('FILE_NO')};
				cmd100ukrvService.deleteOne(param,function(provider, response) {
						UniAppManager.setToolbarButtons('save', false);
						window.close();
				});

			}
		}

	});
	
};

</script>
<form id="exportform" method="get" target="_blank">
        <input type="hidden" id="fid" name="fid" value="" />
        <input type="hidden" name="inline" value="N" />
</form>