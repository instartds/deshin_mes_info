<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="test.grid01"  >
	<t:ExtComboStore comboType="AU" comboCode="B010" />
	<t:ExtComboStore comboType="AU" comboCode="CB20" />
</t:appConfig>

<script type="text/javascript" >
Ext.require([ '*', 'Ext.ux.grid.FiltersFeature', 'Ext.ux.DataTip' ,'Unilite.com.grid.UniGridPanel']);

Ext.onReady(function() {
	
	Ext.define('Cmb200ukrvModel', {
	    extend: 'Ext.data.Model',
	    fields: [ 	 {name :'COMP_CODE'  		,text : '법인코드'  ,type : 'string', allowBlank:false}
					,{name :'PROJECT_NO'  		,text : '영업기회 번호'  ,type : 'string' }
					,{name :'PROJECT_NAME'  	,text : '영업기회명'  ,type : 'string', allowBlank:false }
					,{name :'PROJECT_OPT'  		,text : '영업기회구분'  ,type : 'string', allowBlank:false }
					,{name :'START_DATE'  		,text : '시작일'  ,type : 'date', allowBlank:false }
					,{name :'TARGET_DATE'  		,text : '완료 목표일'  ,type : 'date', allowBlank:false }
					,{name :'PROJECT_TYPE'  	,text : '영업기회 구분'  ,type : 'string', allowBlank:false, comboType:'AU',comboCode:'CB20' } // (CB20)
					,{name :'CLASS_LEVEL1'  	,text : '유형분류(중)'  ,type : 'string', allowBlank:false, comboType:'AU',comboCode:'CB21' } // (CB21)
					,{name :'CLASS_LEVEL2'  	,text : '유형분류(소)'  ,type : 'string', allowBlank:false, comboType:'AU',comboCode:'CB22' } // (CB22)
					,{name :'SALE_EMP'  		,text : '영업담당자'  ,type : 'string' }//(CMS100T-EMP_ID)
					,{name :'DEVELOP_EMP'  		,text : '개발담당자'  ,type : 'string' }//(CMS100T-EMP_ID)
					,{name :'NATION_CODE'  		,text : '거래처 국가'  ,type : 'string' }//(BCM100T-NATION_CODE)
					,{name :'CUSTOM_CODE'  		,text : '거래처 코드'  ,type : 'string', allowBlank:false  }//(BCM100T_CUSTOM_CODE)
					,{name :'CUSTOM_NAME'  		,text : '고객 업체'  ,type : 'string', allowBlank:false } //(BCM100T_CUSTOM_CODE)
					,{name :'DVRY_CUST_SEQ'  	,text : '배송처코드'  ,type : 'int', allowBlank:false } //(SCM100T_DVRY_CUST_SEQ)
					,{name :'DVRY_CUST_NM'  	,text : '배송처'  ,type : 'string' } //(SCM100T_DVRY_CUST_SEQ)
					,{name :'PROCESS_TYPE'  	,text : '공정코드'  ,type : 'string'  }//(CMB300T_PROCESS_TYPE)
					,{name :'PROCESS_TYPE_NM'	,text : '공정'  ,type : 'string' }
					,{name :'SALE_STATUS'  		,text : '영업상태'  ,type : 'string', comboType:'AU', comboCode:'CB46'  }
					,{name :'IMPORTANCE_STATUS'  ,text : '중요도'  ,type : 'string', allowBlank:false, comboType:'AU', comboCode:'CB23'  }// (CB23)
					,{name :'PAD_STR'  			,text : '경로'  ,type : 'string' }
					,{name :'SLURRY_STR'  		,text : '경쟁사'  ,type : 'string' }
					,{name :'MONTH_QUANTITY' 	,text : '예상규모'  ,type : 'int', allowBlank:false }
					,{name :'CURRENT_DD'  		,text : '현사용제품'  ,type : 'string' }
					,{name :'EFFECT_STR'  		,text : '효과'  ,type : 'string' }
					,{name :'KEYWORD'  			,text : '키워드'  ,type : 'string' }
					,{name :'REMARK'  			,text : '비고'  ,type : 'string' }
					,{
						name : 'PKS',
						type : 'string',
						convert : function(value, record) {
							return record.get('COMP_CODE') + '|' + record.get('PROJECT_NO');
						}
					}					
			],
			idProperty : 'PKS'
	});
	
	
	var directMasterStore = new Ext.data.DirectStore({
			model: 'Cmb200ukrvModel',
           	autoLoad: true,
        	autoSync: false,
        	batchUpdateMode:'complete',
           	proxy: {
               type: 'direct',
               batchActions:true,
               api: {
               	read: 'cmb200ukrvService.selectList',
               	update: 'cmb200ukrvService.updateMulti',
				create: 'cmb200ukrvService.selectList',
				destroy: 'cmb200ukrvService.deleteMulti'
               }
            }
			,listeners: {
	            write: function(proxy, operation){
	                if (operation.action == 'destroy') {
	                	cmb100ukrvDetail.getForm().loadRecord(null);			         
	                }                
            }
        }
	        
	});


	var cmb200ukrvGrid = Ext.create('Unilite.com.grid.UniGridPanel', {
    	store : directMasterStore,
		id : 'cmb200ukrvGrid',
		plugins : [ 'bufferedrenderer', {
			xclass : 'Ext.grid.plugin.CellEditing',
			clicksToMoveEditor : 1,
			autoCancel : false
		} ],
		features : [ {
			ftype : 'filters',
			local : false
		} ],
        columns:  [        
               		 { dataIndex: 'COMP_CODE',  width: 100,   hidden: true}   //법인코드 
					,{ dataIndex: 'PROJECT_NO',  width: 120   } // 영업기회 번호
					,{ dataIndex: 'PROJECT_NAME',  width: 120  }  // 영업기회명
					,{ dataIndex: 'PROJECT_OPT',  width: 50 } //'영업기회구분'
					,{ dataIndex: 'START_DATE',  width: 100   } // 시작일
					,{ dataIndex: 'TARGET_DATE',  width: 100   , text: '완료 목표일'}
					,{ dataIndex: 'PROJECT_TYPE',  width: 140   , text: '영업기회 구분'}   // CB20
					,{ dataIndex: 'CLASS_LEVEL1',  width: 140   , text: '유형분류(중)'} 
					,{ dataIndex: 'CLASS_LEVEL2',  width: 140   , text: '유형분류(소)'} 
					,{ dataIndex: 'SALE_EMP',  width: 120   , text: '영업담당자'} 
					,{ dataIndex: 'MONTH_QUANTITY',  width: 100   , text: '예상규모', xtype:'numbercolumn'} 
					
          ] 
    });
    
    var cmb200ukrvGrid2 = Ext.create('Unilite.com.grid.UniGridPanel', {
    	store : directMasterStore,
		id : 'cmb200ukrvGrid2',
		plugins : [ 'bufferedrenderer', {
			xclass : 'Ext.grid.plugin.CellEditing',
			clicksToMoveEditor : 1,
			autoCancel : false
		} ],
		features : [ {
			ftype : 'filters',
			local : false
		} ],
        columns:  [        
               		 { dataIndex: 'COMP_CODE',  width: 100,   hidden: true}   //법인코드 
					,{ dataIndex: 'PROJECT_NO',  width: 120   } // 영업기회 번호
					,{ dataIndex: 'PROJECT_NAME',  width: 120  }  // 영업기회명
					,{ dataIndex: 'PROJECT_OPT',  width: 50 } //'영업기회구분'
					,{ dataIndex: 'START_DATE',  width: 100   } // 시작일
					,{ dataIndex: 'TARGET_DATE',  width: 100   , text: '완료 목표일'}
					,{ dataIndex: 'PROJECT_TYPE',  width: 140   , text: '영업기회 구분'}   // CB20
					,{ dataIndex: 'CLASS_LEVEL1',  width: 140   , text: '유형분류(중)'} 
					,{ dataIndex: 'CLASS_LEVEL2',  width: 140   , text: '유형분류(소)'} 
					,{ dataIndex: 'SALE_EMP',  width: 120   , text: '영업담당자'} 
					,{ dataIndex: 'MONTH_QUANTITY',  width: 100   , text: '예상규모', xtype:'numbercolumn'} 
					
          ] 
    });
	
    var panelSearch  = {
        xtype : 'uniSearchForm',
		id : 'searchForm',
		layout : {type : 'table', columns : 3},
        items: [  {fieldLabel: 'AU/CB20',  name: 'GUBUN',  xtype: 'uniCombobox', comboType:'AU', comboCode:'CB20', allowBlank:false  }
    			 ,{fieldLabel: '사업장',  name: 'LEVEL2', xtype: 'uniCombobox', comboType:'AU', comboCode:'B001'  }
    			 ,{fieldLabel: '유형분류(소)',  name: 'LEVEL3', xtype: 'uniCombobox', comboType:'AU', comboCode:'CB22'  }
	             ,{
	                fieldLabel: '영업기회 유형', name: 'srchProjectOpt',
	                xtype: 'uniRadiogroup',width: '300px',value:1,comboType:'AU', comboCode:'CB24'}
	            ,{
	                fieldLabel: '중요도', name: 'srchImportanceGroup', itemName:'srchImportance',
	                xtype: 'uniCheckboxgroup', values: ['A1','B1'], width: '300px',comboType:'AU', comboCode:'CB23'
	            }
	    ] // items
    };    
	
    var app =  Ext.create('Unilite.com.BaseApp', {
		prgId : 'test.grid01',
		items : [panelSearch, 	cmb200ukrvGrid,cmb200ukrvGrid2],
		fnInitBinding:function() {
			var me = this;
			console.log("userInfo", UserInfo);
		},
		onQueryButtonDown:function() {
			var form = Ext.getCmp('searchForm');
            if (form.isValid()) {
            	var masterGrid = Ext.getCmp('cmb200ukrvGrid');
				var param = form.getValues();
				console.log(param);
				masterGrid.getStore().load({
					params : param
				});
            }
			
		},
		onSaveDataButtonDown: function () {
			var masterGrid = Ext.getCmp('cmb200ukrvGrid');
			console.log('Save');
			masterGrid.getStore().sync({
				
			});
		},
		onDeleteDataButtonDown: function () {
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				var masterGrid = Ext.getCmp('cmb200ukrvGrid');
				console.log('Delete ');
				var selected = masterGrid.getSelectionModel().getSelection()[0];
				masterGrid.getStore().remove(selected);
			}
		}

		
	});

});


</script>

