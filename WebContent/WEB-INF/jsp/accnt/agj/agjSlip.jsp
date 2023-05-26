<%@page language="java" contentType="text/html; charset=utf-8"%>

/**
 * 전표번호별 차대변 Grid
 */
	
	cashInfo = ${cashAccntInfo}

    Unilite.defineModel('agj100ukrSlipModel', {
		// pkGen : user, system(default)
	    fields: [ 
	    	 {name: 'SLIP_NUM'   		,text:'번호'				,type : 'int'} 
			,{name: 'SLIP_SEQ'    		,text:'순번'				,type : 'int'} 
			,{name: 'ACCNT'    			,text:'계정코드'			,type : 'string'} 
			,{name: 'ACCNT_NAME'    	,text:'계정과목명'			,type : 'string'}
			,{name: 'AMT_I'    			,text:'금액'				,type : 'uniPrice'} 
		]
	});
	var drSum = 0; crSum = 0;
	var slipStore1 = Unilite.createStore('agj100ukrSlipStore1',{
			model: 'agj100ukrSlipModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            }
			,loadStoreRecords : function(store, acDate, slipNo)	{
				var data = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('AC_DAY')== acDate && record.get('SLIP_NUM')== slipNo && record.get('DR_CR') == '1') } ).items);
				var data2 = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('AC_DAY')== acDate && record.get('SLIP_NUM')== slipNo && record.get('DR_CR') == '2') } ).items);
				 crSum = 0; drSum=0;
				Ext.each(data2, function(rec, idx){
					if(rec.get('SLIP_DIVI')=='1' || rec.get('SLIP_DIVI')=='2')
					data.push({'SLIP_NUM':rec.get('SLIP_NUM'), 'SLIP_SEQ':rec.get('SLIP_SEQ'), 'ACCNT':cashInfo.ACCNT, 'ACCNT_NAME':cashInfo.ACCNT_NAME, 'AMT_I':rec.get('AMT_I') })
					
				})
				
				
				Ext.each(data, function(rec, idx){
					if(Ext.isDefined(rec.data))	{
						drSum += rec.get("AMT_I");
					}else {
						drSum += rec.AMT_I||0;
					}
				})
				
				Ext.each(slipStore2.data.items, function(rec, idx){
					if(Ext.isDefined(rec.data))	{
						crSum += rec.get("AMT_I");
					}else {
						crSum += rec.AMT_I||0;
					}
				})
				
				if( data != null && data2 != null && data.length == 0  && data2.length == 0 )	{
					crSum = 0; drSum=0;
				}
				if(data == null ) data = {};
				this.loadData(data);
			}
		});
		
	var slipStore2 = Unilite.createStore('agj100ukrSlipStore2',{
			model: 'agj100ukrSlipModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            }
			,loadStoreRecords : function(store, acDate, slipNo)	{
				var data = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('AC_DAY')== acDate && record.get('SLIP_NUM')== slipNo && record.get('DR_CR') == '2') } ).items);
				var data2 = Ext.Array.push(store.data.filterBy(function(record) {return (record.get('AC_DAY')== acDate && record.get('SLIP_NUM')== slipNo && record.get('DR_CR') == '1') } ).items);
				var data2_sum = 0;
				drSum = 0, crSum = 0;
				Ext.each(data2, function(rec, idx){
					if(rec.get('SLIP_DIVI')=='1' || rec.get('SLIP_DIVI')=='2')
					data.push({'SLIP_NUM':rec.get('SLIP_NUM'), 'SLIP_SEQ':rec.get('SLIP_SEQ'), 'ACCNT':cashInfo.ACCNT, 'ACCNT_NAME':cashInfo.ACCNT_NAME, 'AMT_I':rec.get('AMT_I') });
				})
				
				Ext.each(data, function(rec, idx){
					if(Ext.isDefined(rec.data))	{
						crSum += rec.get("AMT_I");
					}else {
						crSum += rec.AMT_I||0;
					}
				})
				
				Ext.each(slipStore1.data.items, function(rec, idx){
					if(Ext.isDefined(rec.data))	{
						drSum += rec.get("AMT_I");
					}else {
						drSum += rec.AMT_I||0;
					}
				})
				
				if( data != null && data2 != null && data.length == 0  && data2.length == 0 )	{
					crSum = 0; drSum=0;
				}
				
				if(data == null ) data = {};
				this.loadData(data);
			}
		});
	
	
    var slipGrid1 = Unilite.createGrid('agj100ukrAccGrid1', {
		uniOpt:{
        	expandLastColumn: false,
            useMultipleSorting: false,
            userToolbar:false
        },
        flex:.5,
        height:100,
        region:'west',
        features: [ 
        	{
        		id : 'slipGrid1Total', 	
    			ftype: 'uniSummary', 	  
    			showSummaryRow: true,
    			dock: 'bottom',
    			style:{ width:450 }
    		} 
    	],
        border:true,
    	store: slipStore1,
    	hideHeaders: true,
		columns:[
			 { dataIndex: 'ACCNT'			,width: 100 ,
			   summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
	              	return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
               }
             } ,
			 { dataIndex: 'ACCNT_NAME'		,flex:1 ,
			 	summaryType:function(records)	{
			 		var sum = 0;
				 	
			 		rv = drSum - crSum;
                	return rv;
			 	},
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	var rv;
                	rv = drSum - crSum;
                	return '<div style="text-align:right">'+Ext.util.Format.number(rv, UniFormat.Price)+'</div>';
                }
               
             }, 	
			 { dataIndex: 'AMT_I'			,width: 150	,summaryType:'sum'}
          ]
    });
	
    
    var slipGrid2 = Unilite.createGrid('agj100ukrAccGrid2', {       
		uniOpt:{
        	expandLastColumn: false,
            useMultipleSorting: false,
            userToolbar:false
        },
        flex:.5,
        height:100,
        region:'center',
        hideHeaders: true,
        border:false,
        features: [ 
        	{
        		id : 'slipGrid1Total', 	
    			ftype: 'uniSummary', 	  
    			showSummaryRow: true,
    			dock: 'bottom',
    			style:{ width:450 }
    		} 
    	],
        border:true,
    	store: slipStore2,
		columns:[
			 { dataIndex: 'ACCNT'			,width: 100 ,
			   summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
	              	return Unilite.renderSummaryRow(summaryData, metaData, '', '총계');
               }
			 },
			 { dataIndex: 'ACCNT_NAME'		,flex:1 /*,
			 	summaryType:function(records)	{
				 	var sum = 0;
                	rv = crSum - drSum  ;
                	return rv;
			 	},
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                	return '<div style="text-align:right">'+Ext.util.Format.number(value, UniFormat.Price)+'</div>';
                }*/}, 	
			 { dataIndex: 'AMT_I'			,width: 150  	,summaryType:'sum'}
          ],
          listeners:{
          	afterrender:function(grid, eOpts)	{
          		grid.dockedItems.hidden = true;
          		grid.getView().refresh()
          	}
          }
    });

	var slipContainer = {
		xtype:'container',
		layout:'hbox',
		border:false,
		id:'AgjSlipContainer',
		height:100,
		
	 	items:[
	 		slipGrid1,
	 		slipGrid2
	 	]
	}

