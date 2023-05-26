<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
//사용자 정보 등록
request.setAttribute("PKGNAME","Unilite_app_bsa300ukrv");
%>
<t:appConfig pgmId="s_bsa300ukrv_KOCIS"  >
	<t:ExtComboStore comboType="AU" comboCode="B001" /><!-- 사업장    -->  
	<t:ExtComboStore comboType="AU" comboCode="B063" /><!-- 참조명칭 -->   
	<t:ExtComboStore comboType="AU" comboCode="B245" /><!-- 사용자LEVEL -->        
	<t:ExtComboStore comboType="AU" comboCode="B010" /><!-- 사용여부, 잠금여부 -->          
	<t:ExtComboStore comboType="AU" comboCode="A020" /><!-- ERP_USER 여부 -->  
	<t:ExtComboStore comboType="AU" comboCode="CM10" /><!-- 권한레벨 -->  
	<t:ExtComboStore comboType="AU" comboCode="YP39" /><!-- 포스레벨 -->  
	
    <t:ExtComboStore comboType="AU" comboCode="A401" /><!-- 직위 -->  
	
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->

</t:appConfig>

<script type="text/javascript" >
function appMain() {

	Unilite.defineModel('${PKGNAME}Model', {
		// pkGen : user, system(default)
	    fields: [ 	 
	    	{name: 'USER_ID'           ,text:'사용자ID'           ,type:'string'      ,allowBlank:false, isPk:true},
	    	{name: 'USER_NAME'         ,text:'사용자명'            ,type:'string'      ,allowBlank:false},
            {name: 'PASSWORD'          ,text:'비밀번호'            ,type:'uniPassword' ,allowBlank:false},
            {name: 'DEPT_CODE'         ,text:'기관코드'        ,type:'string'      ,allowBlank:false, editable:false},
            {name: 'DEPT_NAME'         ,text:'기관'           ,type:'string'      ,editable:false},
            {name: 'AUTHORITY_LEVEL'   ,text:'권한레벨'            ,type:'string'      ,allowBlank:false ,comboType:'AU',comboCode:'CM10', defaultValue:'15'},
            {name: 'USE_YN'            ,text:'사용여부'            ,type:'string'      ,allowBlank:false ,comboType:'AU',comboCode:'B010', defaultValue:'Y'},
            {name: 'USER_GUBUN'        ,text:'직위'              ,type:'string' ,comboType:'AU',comboCode:'A401' },
            {name: 'PERSON_NUMB'       ,text:'사번'               ,type:'string'  },
            {name: 'NAME'               ,text:'사원명'              ,type:'string'  },
            {name: 'FAIL_CNT'          ,text:'로그인실패횟수'        ,type:'int'         ,defaultValue:0},
            {name: 'LOCK_YN'           ,text:'잠금여부'            ,type:'string'      ,comboType:'AU',comboCode:'A020' , defaultValue:'N'},
            {name: 'EMAIL_ADDR'       ,text:'이메일주소'              ,type:'string'  },
            {name: 'TELEPHON'       ,text:'전화번호'              ,type:'string'  },
            
            {name: 'IS_PW_CHANGE'      ,text:'IS_PW_CHANGE'        ,type:'string'      ,defaultValue:'N'}


	    				
	    					
	    						
	    		/*					
	    			{name: 'SEQ' 				,text:'순번' 				,type:'int'			,editable:false}
					,{name: 'USER_ID' 			,text:'사용자ID' 			,type:'string'		,allowBlank:false, isPk:true}
					,{name: 'USER_NAME' 		,text:'사용자명' 			,type:'string'		,allowBlank:false}
					,{name: 'PASSWORD' 			,text:'비밀번호' 			,type:'uniPassword'	,allowBlank:false	}
					,{name: 'PERSON_NUMB' 		,text:'사번' 				,type:'string'	}
					,{name: 'NAME' 				,text:'사원명' 				,type:'string'	}
					,{name: 'ERP_USER' 			,text:'ERP사용자' 			,type:'string'		,comboType:'AU',comboCode:'A020', defaultValue:'Y'}
					,{name: 'DEPT_CODE' 		,text:'부서' 				,type:'string'		,allowBlank:false, editable:false}
					,{name: 'DEPT_NAME' 		,text:'부서명' 				,type:'string'		,editable:false}
//					,{name: 'SHOP_CODE'			,text:'매장코드'			,type:'string'}
//	    			,{name: 'SHOP_NAME'			,text:'매장명'				,type:'string'}
					,{name: 'DIV_CODE' 			,text:'사업장' 				,type:'string'		,allowBlank:false, comboType:'AU',comboCode:'B001'}
					,{name: 'REF_ITEM' 			,text:'참조명칭' 			,type:'string'		,comboType:'AU',comboCode:'B063', defaultValue:'0'}
					,{name: 'POS_ID' 			,text:'포스ID' 			,type:'string'		}
					,{name: 'POS_PASS' 			,text:'포스비밀번호(DB)' 		,type:'uniPassword'		}
//					,{name: 'POS_PASS_EXPOS' 	,text:'포스비밀번호' 		,type:'uniPassword'		}
					,{name: 'POS_LEVEL' 		,text:'포스권한레벨' 		,type:'string'		,comboType:'AU',comboCode:'YP39'}
					,{name: 'AUTHORITY_LEVEL' 	,text:'권한레벨' 			,type:'string'		,allowBlank:false ,comboType:'AU',comboCode:'CM10', defaultValue:'15'}
					,{name: 'USE_YN' 			,text:'사용여부' 			,type:'string'		,allowBlank:false ,comboType:'AU',comboCode:'B010', defaultValue:'Y'}
					,{name: 'PWD_UPDATE_DATE'	,text:'비밀번호변경일'		,type:'uniDate'		,editable:false, defaultValue:UniDate.today()}
					,{name: 'FAIL_CNT' 			,text:'로그인실패횟수' 		,type:'int'			,defaultValue:0}
					,{name: 'LOCK_YN' 			,text:'잠금여부' 			,type:'string'		,comboType:'AU',comboCode:'A020' , defaultValue:'N'}
					,{name: 'UPDATE_DB_USER' 	,text:'수정자' 				,type:'string'		,defaultValue:UserInfo.userName, editable:false}
					,{name: 'UPDATE_DB_TIME' 	,text:'수정일' 				,type:'uniDate'		,editable:false, defaultValue:UniDate.today()}
					,{name: 'COMP_CODE' 		,text:'법인코드' 			,type:'string'		,isPk:true,  defaultValue:UserInfo.compCode}
					,{name: 'IS_PW_CHANGE' 		,text:'IS_PW_CHANGE'		,type:'string'		,defaultValue:'N'}
					,{name: 'SSO_USER' 			,text:'SSO사용자'		,type:'string'		,defaultValue:'N'}
					,{name: 'USER_LEVEL'		,text:'사용자레벨'		,type:'string'		,comboType:'AU',comboCode:'B245' }
					,{name: 'REMARK' 			,text:'비고'				,type:'string'}*/
			]
	});
	
  	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	   read : 's_bsa300ukrvService_KOCIS.selectList'
        	,update : 's_bsa300ukrvService_KOCIS.updateMulti'
			,create : 's_bsa300ukrvService_KOCIS.insertMulti'
			,destroy: 's_bsa300ukrvService_KOCIS.deleteMulti'
			,syncAll: 's_bsa300ukrvService_KOCIS.saveAll'
        }
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('${PKGNAME}MasterStore',{
		model: '${PKGNAME}Model',
        autoLoad: false,
        uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable:false,			// 삭제 가능 여부 
            useNavi : false			// prev | newxt 버튼 사용
        },
        proxy: directProxy,
		// Store 관련 BL 로직
        // 검색 조건을 통해 DB에서 데이타 읽어 오기 
		loadStoreRecords : function()	{
			var param= Ext.getCmp('${PKGNAME}searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		// 수정/추가/삭제된 내용 DB에 적용 하기 
		saveStore : function()	{
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 )	{
				//this.syncAll({});
				this.syncAllDirect();
			}else {
				var grid = Ext.getCmp('${PKGNAME}Grid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
        
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchForm('${PKGNAME}searchForm',{
	    region: 'north',
        layout : {type : 'uniTable', columns : 4},
        padding:'1 1 1 1',
        border:true,
        items: [{
            fieldLabel: '사용자 ID',
            name:'USER_ID'
        },{
    		fieldLabel: '사용자명' ,
    		name:'USER_NAME'
    	},{
    		fieldLabel: '사용여부' ,
    		name:'USE_YN', 
    		xtype: 'uniCombobox', 
    		comboType:'AU',
    		comboCode:'B010', 
    		allowBlank:true 
    	},{
            xtype: 'uniCombobox',
            fieldLabel: '기관',
            name: 'DEPT_CODE',
            store: Ext.data.StoreManager.lookup('deptKocis')
        }]
    });  
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('${PKGNAME}Grid', {
        layout: 'fit',
        region: 'center',
    	store: directMasterStore,
    	uniOpt: {
    		useRowNumberer: false
    	},
    	selModel:'rowmodel',
		columns:[
			{dataIndex:'USER_ID'       ,width:100},
			{dataIndex:'USER_NAME'     ,width:100},
			{dataIndex:'PASSWORD'      ,width:100},
			{dataIndex:'DEPT_CODE'     ,width:120,
                'editor': Unilite.popup('DEPT_G',{  
                    textFieldName:'DEPT_CODE',  
                    textFieldWidth:100, 
                    DBtextFieldName: 'TREE_CODE',
                    listeners: {
                        'onSelected': {
                            fn: function(records, type) {
                                UniAppManager.app.fnDeptChange(records);        
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            var grdRecord = Ext.getCmp('${PKGNAME}Grid').uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE','');
                            grdRecord.set('DEPT_NAME','');
                        }
                    }
                })
            },
            {dataIndex:'DEPT_NAME'     ,width:100,
                'editor': Unilite.popup('DEPT_G',{
                    textFieldName:'DEPT_NAME',  
                    textFieldWidth:100, 
                    DBtextFieldName: 'TREE_NAME',
                    listeners: {
                        'onSelected': {
                            fn: function(records, type) {
                                UniAppManager.app.fnDeptChange(records);        
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            var grdRecord = Ext.getCmp('${PKGNAME}Grid').uniOpt.currentRecord;
                            grdRecord.set('DEPT_CODE','');
                            grdRecord.set('DEPT_NAME','');
                        }
                    }
                })
            },
            {dataIndex:'AUTHORITY_LEVEL'  ,width:80},
            {dataIndex:'USE_YN'           ,width:80},
            {dataIndex:'USER_GUBUN'       ,width:120},
            {dataIndex:'PERSON_NUMB'      ,width:80,
                'editor': Unilite.popup('Employee_G',{
                    textFieldName: 'PERSON_NUMB',
                    DBtextFieldName: 'PERSON_NUMB', 
                    validateBlank : true,
                    listeners: {
                    	'onSelected': {
                            fn: function(records, type) {
                                UniAppManager.app.fnHumanCheck(records);    
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            var grdRecord = Ext.getCmp('${PKGNAME}Grid').uniOpt.currentRecord;
                            grdRecord.set('PERSON_NUMB','');
                            grdRecord.set('NAME','');
                        }
                    }
                })
            },
            {dataIndex:'NAME'              ,width:100,
                'editor': Unilite.popup('Employee_G',{
                    validateBlank: true,
                    listeners: {
                    	'onSelected': {
                            fn: function(records, type) {
                                UniAppManager.app.fnHumanCheck(records);    
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            var grdRecord = Ext.getCmp('${PKGNAME}Grid').uniOpt.currentRecord;
                            grdRecord.set('PERSON_NUMB','');
                            grdRecord.set('NAME','');
                        }
                    }
                })
            },
            {dataIndex:'FAIL_CNT'          ,width:110  ,readOnly:true},
            {dataIndex:'LOCK_YN'           ,width:80},
            {dataIndex:'EMAIL_ADDR'           ,width:150},
            {dataIndex:'TELEPHON'           ,width:150},
            
            {dataIndex:'IS_PW_CHANGE'      ,width:66   ,hidden:true}
		
            
            
            
            
            
            
           /* 
		
			     {dataIndex:'SEQ'			,width:50, align:'center'}
				,{dataIndex:'USER_ID'		,width:80}
				,{dataIndex:'USER_NAME'		,width:80}
				,{dataIndex:'PASSWORD'		,width:80}
				,{dataIndex:'PERSON_NUMB'	,width:80,
			     'editor' : Unilite.popup('Employee_G',{
						textFieldName:'PERSON_NUMB',
						DBtextFieldName: 'PERSON_NUMB', 
						validateBlank : true,
	   					listeners: {'onSelected': {
		 								fn: function(records, type) {
		 									UniAppManager.app.fnHumanCheck(records);	
		 								},
		 								scope: this
		 							},
		 							'onClear': function(type) {
										var grdRecord = Ext.getCmp('${PKGNAME}Grid').uniOpt.currentRecord;
		  								grdRecord.set('PERSON_NUMB','');
		  								grdRecord.set('NAME','');
		 							}
		 				}
					})
				 }
				,{dataIndex:'NAME'				,width:100
				  ,'editor' : Unilite.popup('Employee_G',{
						validateBlank : true,
		  				listeners: {'onSelected': {
			 								fn: function(records, type) {
			 									UniAppManager.app.fnHumanCheck(records);	
			 								},
			 								scope: this
			 							},
			 							'onClear': function(type) {
			 								var grdRecord = Ext.getCmp('${PKGNAME}Grid').uniOpt.currentRecord;
			  								grdRecord.set('PERSON_NUMB','');
			  								grdRecord.set('NAME','');
			 							}
			 				}
						})
				 }
				,{dataIndex:'ERP_USER'			,width:100	, hidden:true}
				,{dataIndex:'DEPT_CODE'			,width:80,
				    'editor' : Unilite.popup('DEPT_G',{  
				  		textFieldName:'DEPT_CODE',  
				  		textFieldWidth:100, 
				  		DBtextFieldName: 'TREE_CODE',
				    	listeners: {
				    		'onSelected': {
								fn: function(records, type) {
									UniAppManager.app.fnDeptChange(records);		
								},
								scope: this
							},
							'onClear': function(type) {
								var grdRecord = Ext.getCmp('${PKGNAME}Grid').uniOpt.currentRecord;
	    						grdRecord.set('DEPT_CODE','');
		                    	grdRecord.set('DEPT_NAME','');
							}
						}
					})
				},
				{dataIndex:'DEPT_NAME'			,width:100	
				  ,'editor' : Unilite.popup('DEPT_G',{
				  		textFieldName:'DEPT_NAME', 
				  		textFieldWidth:100, 
				  		DBtextFieldName: 'TREE_NAME',
						listeners: {
							'onSelected': {
 								fn: function(records, type) {
 									UniAppManager.app.fnDeptChange(records);	
 								},
 								scope: this
 							},
 							'onClear': function(type) {
 								var grdRecord = Ext.getCmp('${PKGNAME}Grid').uniOpt.currentRecord;
		                    	grdRecord.set('DEPT_CODE','');
		                    	grdRecord.set('DEPT_NAME','');
 							}
		 				}
					})
				},
				 
				 
				 
				 {dataIndex: 'SHOP_CODE'				, width:100	
				  ,'editor' : Unilite.popup('SHOP_G',{  textFieldName:'SHOP_CODE',  textFieldWidth:100, DBtextFieldName: 'SHOP_CODE'
				    				,listeners: {'onSelected': {
			 								fn: function(records, type) {
			 									UniAppManager.app.fnShopChange(records);		
			 								},
			 								scope: this
			 							},
			 							'onClear': function(type) {
											var grdRecord = Ext.getCmp('bsa240ukrvGrid').uniOpt.currentRecord;
	                						grdRecord.set('SHOP_CODE','');
					                    	grdRecord.set('SHOP_NAME','');
			 							}
					 				}
								})
				}
        		,{dataIndex: 'SHOP_NAME'				, width:170
				  ,'editor' : Unilite.popup('SHOP_G',{textFieldName:'SHOP_NAME', textFieldWidth:100, DBtextFieldName: 'SHOP_NAME'
		  							,listeners: {'onSelected': {
			 								fn: function(records, type) {
			 									UniAppManager.app.fnShopChange(records);	
			 								},
			 								scope: this
			 							},
			 							'onClear': function(type) {
											var grdRecord = Ext.getCmp('bsa240ukrvGrid').uniOpt.currentRecord;
	                						grdRecord.set('SHOP_CODE','');
					                    	grdRecord.set('SHOP_NAME','');
			 							}
					 				}
								})
				 }
        		 {dataIndex:'DIV_CODE'			,width:100}
				,{dataIndex:'REF_ITEM'			,width:80	}
				,{dataIndex:'POS_ID'			,width:80	}
				,{dataIndex:'POS_PASS'			,width:100	}
				,{dataIndex:'POS_LEVEL'			,width:100	}
				,{dataIndex:'AUTHORITY_LEVEL'	,width:80	}
				,{dataIndex:'USE_YN'			,width:80	}
				,{dataIndex:'PWD_UPDATE_DATE'	,width:110 	,readOnly:true}
				,{dataIndex:'FAIL_CNT'			,width:110 	,readOnly:true}
				,{dataIndex:'LOCK_YN'			,width:80}
				,{dataIndex:'UPDATE_DB_USER'	,width:100	,readOnly:true}
				,{dataIndex:'UPDATE_DB_TIME'	,width:100	,readOnly:true}
				,{dataIndex:'COMP_CODE'			,width:100	,hidden:true}
				,{dataIndex:'IS_PW_CHANGE'		,width:66	,hidden:true}
				,{dataIndex:'SSO_USER'			,width:66	,hidden:true}
				,{dataIndex:'USER_LEVEL'		,width:100}
				
				*/
          ] ,
          	listeners:{
          	/*	beforeedit:function( editor, e, eOpts )	{
          			if(e.field=='POS_PASS_EXPOS')	{
          				e.grid.ownerGrid.openCryptPopup( e.record );
          				return false;
          			}
          		},
          		onGridDblClick:function(grid, record, cellIndex, colName, td)	{
					if(colName =="POS_PASS_EXPOS") {  
						grid.ownerGrid.openCryptPopup(record); 
					}
				}*/
          	}/*,	 
			openCryptPopup:function( record )	{
				if(record)	{
					var params = {GUBUN_FLAG:'5', ENCRYPT:record.get('POS_PASS')};
					Unilite.popupCipherComm('grid', record, 'POS_PASS_EXPOS', 'POS_PASS', params);
				}
					
			}*/
    });
    
  	Unilite.Main({
  		borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            id:'pageAll',
            items:[
                panelSearch, masterGrid
            ]
        }],
		id: 'bsa300ukrvApp',
		fnInitBinding: function() {
            UniAppManager.app.fnInitInputFields();
		},
		onQueryButtonDown: function() {
			directMasterStore.loadStoreRecords();
		},
		onSaveAndQueryButtonDown: function(){
			this.onSaveDataButtonDown();
			this.onQueryButtonDown();
		},
		onNewDataButtonDown: function()	{
	         /*var seq = masterGrid.getStore().max('SEQ');
        	 if(!seq) seq = 1;
        	 else  seq += 1;
            param = {'SEQ':seq}
	        masterGrid.createRow(param);*/
	        
	        masterGrid.createRow();
		},
		onSaveDataButtonDown: function () {
			var masterGrid = Ext.getCmp('${PKGNAME}Grid');
			directMasterStore.saveStore();
		},
		onDeleteDataButtonDown: function(){
			masterGrid.deleteSelectedRow();
		},
		onResetButtonDown: function(){

            panelSearch.clearForm();
            masterGrid.reset();
            directMasterStore.clearData();
            UniAppManager.app.fnInitInputFields();
			
			
	/*		var masterGrid = Ext.getCmp('${PKGNAME}Grid');
			Ext.getCmp('${PKGNAME}searchForm').getForm().reset();
			masterGrid.getStore().loadData({});
			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);*/
		},
		fnInitInputFields: function(){
//            UniAppManager.setToolbarButtons(['reset','newData'],true);
//            UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
			UniAppManager.setToolbarButtons(['save','newData','delete','prev', 'next'],false);
            panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
            
            if(!Ext.isEmpty(UserInfo.deptCode)){
                if(UserInfo.deptCode == '01'){
                    panelSearch.getField('DEPT_CODE').setReadOnly(false);
                }else{
                    panelSearch.getField('DEPT_CODE').setReadOnly(true);
                }
            }else{
                panelSearch.getField('DEPT_CODE').setReadOnly(true);
            }
		},
		
		fnHumanCheck: function(records) {
			grdRecord = masterGrid.getSelectedRecord();
			record = records[0];
			grdRecord.set('PERSON_NUMB', record.PERSON_NUMB);
			grdRecord.set('NAME', record.NAME);
			
			if(Ext.isEmpty(grdRecord.get('USER_ID'))){
				grdRecord.set('USER_ID', record.PERSON_NUMB);
			}
			
			if(Ext.isEmpty(grdRecord.get('USER_NAME'))){
				grdRecord.set('USER_NAME', record.NAME);
			}
			
			if(Ext.isEmpty(grdRecord.get('DEPT_CODE'))){
				grdRecord.set('DEPT_CODE', record.DEPT_CODE);
			}
			
			if(Ext.isEmpty(grdRecord.get('DEPT_NAME'))){
				grdRecord.set('DEPT_NAME', record.DEPT_NAME);
			}
			
			if(Ext.isEmpty(grdRecord.get('DIV_CODE'))){
				grdRecord.set('DIV_CODE', record.SECT_CODE);
			}
		},
		
		fnDeptChange: function(records) {
			grdRecord = masterGrid.getSelectedRecord();
			record = records[0];
			grdRecord.set('DEPT_CODE', record.TREE_CODE);
			grdRecord.set('DEPT_NAME', record.TREE_NAME);
			if(Ext.isEmpty(grdRecord.get('DIV_CODE'))){
				grdRecord.set('DIV_CODE', record.DIV_CODE);
			}
		},
		fnShopChange: function(records) {
			grdRecord = masterGrid.getSelectedRecord();
			record = records[0];
//			grdRecord.set('SHOP_CODE', record.SHOP_CODE);
//			grdRecord.set('SHOP_NAME', record.SHOP_NAME);
			if(Ext.isEmpty(grdRecord.get('DIV_CODE'))){
				grdRecord.set('DIV_CODE', record.DIV_CODE);
			}
		}
	});
	
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;
			switch(fieldName) {
				case "PASSWORD" :		
					if(newValue != oldValue){
						record.set('IS_PW_CHANGE', 'Y');
					}
				break;
			}
			return rv;
		}
	});
	
}; 


</script>
