<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="cmb210skrv"  >
<t:ExtComboStore comboType="AU" comboCode="CB23" />
<t:ExtComboStore comboType="AU" comboCode="CB46" />
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />'></script>
<script type="text/javascript">

function appMain() {
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('cmb210skrvModel', {
		fields : [ 	 {name:'SEQ'		,text : '순번'			,type:'int' } 
					,{name:'BASE_DATE'	,text : '날짜'			,type:'uniDate'}
					,{name:'RESULT_TIME',text : '시간'			,type:'string'}
					,{name:'TITLE'		,text : '구분'			,type:'string'}
					,{name:'SAMPLE_NAME',text : '샘플명'		,type:'string'}
					,{name:'CONTENT'	,text : '내용'			,type:'string'}  
					,{name:'REV_PROV'	,text : '소견'			,type:'string'}  
					,{name:'REMARK'		,text : '비고'			,type:'string'}  
					,{name:'SORT_SEQ'	,text : '구분'			,type:'string'}
					,{name:'LINK_NUM'	,text : '고유번호'		,type:'string'}
					,{name:'FILE_YN'	,text : '첨부'			,type:'string'}
					,{name:'SALE_STATUS',text : '상태'			,type:'string', comboType:'AU',comboCode:'CB46'}
					,{name:'SALES_PROJECTION'	,text: '확률'	,type: 'uniPercent'}
				]
	});

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			

	var directMasterStore = Unilite.createStore('cmb210skrvModel',{
		model : 'cmb210skrvModel',
		autoLoad : false,
		proxy : {
			type : 'direct',
			api : {
				read : 'cmb210skrvService.selectActivityList'
			}
		},
		listeners:{
			load :function(store, records, successful, eOpts)	{
				 	if(records.length > 0)	{
						masterGrid.getSelectionModel().select(records.length-1);
				 	}
			}
		}
	});
	

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	

		var panelSearch = Unilite.createSearchForm('searchForm', {			
	            	 layout : {type : 'uniTable', columns : 2}	            	
	            	,items : [ Unilite.popup('CLIENT_PROJECT',{
	            				id:'T1',
	            				fieldLabel:'영업기회', showValue:false, allowBlank: false, allowMulti:true,  textFieldWidth:250, 
	            				valueFieldName : 'PROJECT_NO', validateBlank :true,
	            				listeners: {
						                'onSelected': {
						                    fn: function(records, type) {
						                    	var frm = Ext.getCmp('cmb210skrvDetailForm');
						                    	console.log("records[0]", records[0]);
						                    	frm.setValues(records[0]);
												//var sFrm = Ext.getCmp('searchForm');
												//sFrm.setValue('PROJECT_NO',records[0]['PROJECT_NO'])
						                    },
						                    scope: this
						                },
						                'onClear': function(type) {
						                		Ext.getCmp('cmb210skrvDetailForm').clearForm();
												Ext.getCmp('cmb210skrvGrid').reset();
						                    	
						                }
						            }
								})
								//,{fieldLabel : '영업기회번호'		,name : 'PROJECT_NO', hidden:false}
		            		 
							]
			
					});

		/**
		 * 상세
		 */
		var defailForm = Unilite.createSimpleForm('cmb210skrvDetailForm', {
			autoScroll:false,
			layout : {type: 'uniTable', columns: 4},
			items : [  {fieldLabel : '구분'		,name : 'PROJECT_TYPE_NM'	, readOnly:true}
					 , {fieldLabel : '중요도'	,name : 'IMPORTANCE_STATUS'	, readOnly:true, xtype: 'uniCombobox', comboType:'AU',comboCode:'CB23'}
					 , {fieldLabel : '시작일'	,name : 'START_DATE'		, readOnly:true}
					 , {fieldLabel : '목표일'	,name : 'TARGET_DATE' 		, readOnly:true}
					 , {fieldLabel : '거래처'	,name : 'CUSTOM_NAME'		, readOnly:true}
					 , {fieldLabel : '고객명'	,name : 'CLIENT_NAME'		, readOnly:true} 
					 , {fieldLabel : '영업담당자',name : 'SALE_EMP_NM'		, readOnly:true}
					 , {fieldLabel : '개발담당자',name : 'DEVELOP_EMP_NM' 	, readOnly:true} 
					 , {fieldLabel : '예상규모'	,name : 'MONTH_QUANTITY', xtype:'uniNumberfield' , readOnly:true}
					 , {fieldLabel: '매입액',  name: 'PURCHASE_AMT', xtype: 'uniNumberfield', readOnly:true}
					 , {xtype:'container',
					 	layout:{type:'hbox', align:'strech'},
					 	defaultType: 'uniTextfield',
					 	width:235,
					 	items:[
					 			 {fieldLabel: '마진액(율)',  name: 'MARGIN_AMT', xtype: 'uniNumberfield',  decimalPrecision:2, readOnly:true, width:160}
					 			,{fieldLabel: '마진율', hideLabel:true,  name: 'MARGIN_RATE', xtype: 'uniNumberfield',  decimalPrecision:2, width:76, readOnly:true, suffixTpl:'&nbsp;%'}
					 		  ]
					 }
					 , {fieldLabel : '제품',name : 'CURRENT_DD'		, readOnly:true}
				]
		});

   // create the Grid
	var masterGrid = Unilite.createGrid('cmb210skrvGrid', {
		tbar: ['->',
            {
            	itemId : 'customBtn', iconCls : 'icon-link'	,
        		text:' 일일영업활동',
        		handler: function() {
        			var record = masterGrid.getSelectedRecord();
        			var param = {
							DOC_ID : record.get('LINK_NUM')
					}
					
					masterGrid._getNewEventEditor(param)
					/*var width=850;
			    	var height=600;
			    	
			    	var sParam = UniUtils.param(param);
			    	var features = "help:0;scroll:0;status:0;center:true;" +
				            ";dialogWidth="+width +"px" +
				            ";dialogHeight="+height+"px" ;
				    var url = '<c:url value="/cm/cmd100ukrv.do" />';
				    var rv = window.showModalDialog(url+'?'+sParam, param, features);
				    */
        		}
       		 }],
		store: directMasterStore,
		uniOpt:{useRowNumberer: false, onLoadSelectFirst: false},
		columns : [  {dataIndex : 'SEQ'			,width : 50     }
					,{dataIndex : 'BASE_DATE'	,width : 80		}
					,{dataIndex : 'RESULT_TIME'	,width : 80		}
					,{dataIndex : 'TITLE'		,width : 180	}
					,{dataIndex : 'FILE_YN'		,width : 40	 , align:'center'
					,renderer: function(value){
					  			 	var r=''
					  			 	if(value == 'Y') {
      								  r = '<img src="'+CPATH+'/resources/images/com/attach.gif"/>';
					  			 	}
					  			 	return r;
   					 			}	
   					 }
   					,{dataIndex : 'SALE_STATUS'	,width : 80		}
   					,{dataIndex : 'SALES_PROJECTION'	,width : 80		}
					,{dataIndex : 'SAMPLE_NAME'	,width : 300	, hidden: true}					
					,{dataIndex : 'CONTENT'		,width : 350	, isLink:true}
					,{dataIndex : 'REV_PROV'	,width : 350	}
					,{dataIndex : 'SORT_SEQ'	,width : 70		, hidden: true}
					,{dataIndex : 'LINK_NUM'	,width : 70		, hidden: true} 
					,{dataIndex : 'REMARK'		, flex:1} 
				  ]
		
		,
		listeners: {
          onGridDblClick:function(grid, record, cellIndex, colName) {
				if(colName == 'CONTENT') {
					// /g3erp/WebContent/app/Extensible/calendar/view/AbstractCalendar.js 와 동일 하게 유지 
					
					var param = {
							DOC_ID : record.data['LINK_NUM']
					}
					this._getNewEventEditor(param);
					//this._openEventEditor(param);
				    //this._getNewEventEditor
				} 
          } //onGridDblClick
		},//listeners
		_openEventEditor: function(param) {
				var width=850;
		    	var height=600;
		    	
		    	var sParam = UniUtils.param(param);
		    	var features = "help:0;scroll:0;status:0;center:true;" +
			            ";dialogWidth="+width +"px" +
			            ";dialogHeight="+height+"px" ;
			    var url = '<c:url value="/cm/cmd100ukrv.do" />';
			    var rv = window.showModalDialog(url+'?'+sParam, param, features);
		},
		_refresh: function() {
			//this.reset(true);
			this.getStore().reload();
		},
		 _getNewEventEditor: function(param) {
	        var me = this;
	        var vParam = {};
	        var appName = 'Unilite.app.calendar.eventEditor';
	        console.log('_getNewEventEditor', param);
	         
	        vParam = {
	            docId: param.DOC_ID
	        }
	        
	        var fn = function() {
	                var oWin =  Ext.WindowMgr.get(appName);
	                if(!oWin) {
	                    oWin = Ext.create( appName, {
	                            width: 808,
	                            height: 720,
	                            title: '영업일보',
	                            listeners: {
	                                close: function() {
	                                    me._refresh();
	                                }
	                            }
	                     });
	                }
	                oWin.fnInitBinding(vParam);
	                oWin.center();
	                // animation을 원할경우 oWin.show(me) 하면 되나 느림 ㅠㅠ
	                oWin.show();
	            };
	            Unilite.require(appName, fn, this, false);
	    }
	});
	
	Unilite.Main( {
		  items : [panelSearch, 	defailForm, masterGrid]
		,fnInitBinding : function(params) {
		    /**
			* 기본값 셋업 
			*/
//			var getParams = document.URL.split("?");
//			var params = Ext.urlDecode(getParams[getParams.length - 1]);
//			console.log('params : ', params) ;
			if(params && params.projectNo) {
				var frm = Ext.getCmp('searchForm');
				frm.setValue('PROJECT_NO',params.projectNo)
				
				Ext.getCmp('T1').lookup('VALUE');
				
			   	var param= Ext.getCmp('searchForm').getValues();
                Ext.getCmp("cmb210skrvGrid").getStore().load({
					params : param
				});
				
			}
			this.setToolbarButtons('reset',true);
			UniAppManager.setToolbarButtons('excel',true);			
		}
		,onSaveAsExcelButtonDown: function() {
			 masterGrid.downloadExcelXml();
		}
		, onQueryButtonDown : function()	{
			masterGrid.reset(true);
			var param= Ext.getCmp('searchForm').getValues();
			if(param['PROJECT_NO']=='')		{
				alert('영업기회는 필수 조회선택 항목입니다.');
			}else {
				masterGrid.getStore().load({
					params : param
				});
			}
			
		}
		,onResetButtonDown:function() {
			defailForm.reset();
			masterGrid.reset();
		}
		
	});

};
	

</script>