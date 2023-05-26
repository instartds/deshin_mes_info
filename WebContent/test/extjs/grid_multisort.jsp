<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="test.grid02"  >
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
					,{name :'SALE_EMP'  		,text : '영업담당자'  ,type : 'string' }//(CMS100T-EMP_ID)			
			],
			idProperty : 'PKS'
	});
	
	
	var directMasterStore = Unilite.createStore('directMasterStore',{
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

	var USE_LOCK = true;
	var cmb200ukrvGrid = Ext.create('Unilite.com.grid.UniGridPanel', {
    	store : directMasterStore,
		id : 'cmb200ukrvGrid',
    	uniOpt:{
    				 expandLastColumn: true
    				,useRowNumberer: USE_LOCK
    				,useMultipleSorting: true
    			},
    	tbarX: [
            {
	        	text:'상세보기',
	        	handler: function() {
	        		var record = masterGrid.getSelectedRecord();
		        	if(record) {
		        		openDetailWindow(record);
		        	}
	        	}
            }
        	,'->',
        	{
	        	text:'정렬',
	        	handler: function() {
	        		
		        		openSortWindow();
	        	}
        	}
        ],
        columns:  [        
               		 { dataIndex: 'COMP_CODE',  width: 100,  locked: USE_LOCK}   //법인코드 
					,{ dataIndex: 'PROJECT_NO',  width: 120, locked: USE_LOCK   } // 영업기회 번호
					,{ dataIndex: 'PROJECT_NAME',  width: 120  }  // 영업기회명
					,{ dataIndex: 'PROJECT_OPT',  width: 120 } //'영업기회구분'
					,{ dataIndex: 'START_DATE',  width: 100   } // 시작일
					,{ dataIndex: 'TARGET_DATE',  width: 100   , text: '완료 목표일'}
					,{ dataIndex: 'SALE_EMP',  width: 120   , text: '영업담당자'} 
					,{ dataIndex: 'MONTH_QUANTITY',  width: 100   , text: '예상규모', xtype:'numbercolumn'} 
					
          ] 
    });
    
	
	
    var app =  Ext.create('Unilite.com.BaseApp', {
		items : [cmb200ukrvGrid],
		fnInitBinding:function() {
			var me = this;
		},
		onQueryButtonDown:function() {
			
			masterGrid.getStore().load();
			
		}
		
	});

});


</script>

