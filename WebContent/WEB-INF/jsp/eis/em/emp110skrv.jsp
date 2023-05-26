<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="emp110skrv"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="emp110skrv"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="W" /><!-- 작업장  -->
    
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
</script>

<style type="text/css">
.x-change-cell1 {
color: red;
}
.x-change-cell2 {
color: #ffa500;
}
.x-change-cell3 {
color: #228b22;
}
</style>

<script type="text/javascript" >

function appMain() {
    
	var chkinterval = null;
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'emp110skrvService.selectList'
        }
    });
    Unilite.defineModel('emp110skrvModel', {
        fields: [
        
            {name: 'OUTSTOCK_REQ_DATE' ,text:'요청일자'                 ,type: 'uniDate'},
            {name: 'SPEC'              ,text:'품번'                 ,type: 'string'},
            {name: 'LOT_NO'            ,text:'LOT NO'                 ,type: 'string'},
            {name: 'OUTSTOCK_NUM'      ,text:'출고요청서 NO'                 ,type: 'string'},
            {name: 'OUTSTOCK_REQ_Q'    ,text:'요청품목수'                 ,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'OUTSTOCK_Q'        ,text:'출고완료수'                 ,type: 'float', decimalPrecision: 0, format:'0,000'}
          
        ]
    }); 
    
    var directMasterStore = Unilite.createStore('emp110skrvMasterStore',{
        model: 'emp110skrvModel',
        uniOpt : {
            isMaster:  false,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: true,
		pageSize: 15,
        proxy: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
            
            api: {			
        	   read: 'emp110skrvService.selectList'                 	
            },
            reader: {
                rootProperty: 'records',
                totalProperty: 'total'
            }
        }),
		loadStoreRecords : function()   {
        	this.load(
//                 params :param 
            );
        },
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(!Ext.isEmpty(records)){
					clearInterval(chkinterval);
					chkinterval = setInterval(function(){
						var record = records[records.length-1];
						if(record.get('TOTAL') == record.get('ROW_NUMBER')){
							masterGrid.down("#ptb").moveFirst();
						}else {
							masterGrid.down("#ptb").moveNext();
						}
					}, 30000);	
				}else{
					clearInterval(chkinterval);
					chkinterval = setInterval(function(){
						directMasterStore.loadStoreRecords();
					}, 30000);
				}
          	}          		
      	}
    });

    var masterGrid = Unilite.createGrid('emp110skrvMasterGrid', {
        layout : 'fit',   
        region: 'center',                          
        store: directMasterStore,
        uniOpt: {
            onLoadSelectFirst : false,
        	userToolbar :false,
			useRowNumberer: false,		//번호 컬럼 사용 여부
			useLoadFocus:false
        },bbar: [{
        		itemId:'ptb',
                xtype: 'pagingtoolbar',
                store: directMasterStore,
                pageSize: 15,
        		displayInfo: true
            }],
        selModel:'rowmodel',
		viewConfig: {
			getRowClass: function(record, rowIndex, rowParams, store){
				var cls = '';
				if(record.get("OUTSTOCK_Q") == 0){
					cls = 'x-change-cell1';
				}else if(record.get("OUTSTOCK_Q") > 0 && record.get("OUTSTOCK_REQ_Q") - record.get("OUTSTOCK_Q") > 0){
					cls = 'x-change-cell2';
				}else if(record.get("OUTSTOCK_REQ_Q") == record.get("OUTSTOCK_Q")){
					cls = 'x-change-cell3';
				}else {
					cls = '';
				}
				return cls;
			}
		},
        columns:  [ 
        	{
				xtype: 'rownumberer', 
//				sortable:false, 
				//locked: true, 
				width: 80,
				align:'center  !important',
				resizable: true
			},
            { dataIndex: 'OUTSTOCK_REQ_DATE'                   ,           width: 150},
            { dataIndex: 'SPEC'                                ,           width: 250, align: 'center'},
            { dataIndex: 'LOT_NO'                              ,           width: 120, align: 'center'},
            { dataIndex: 'OUTSTOCK_NUM'                        ,           width: 250, align: 'center'},
            { dataIndex: 'OUTSTOCK_REQ_Q'                      ,           width: 160, align: 'center'},
            { dataIndex: 'OUTSTOCK_Q'                          ,           width: 160, align: 'center'}
        ] 
    });
    
    var panelSearch = Unilite.createSearchForm('panelSearch',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3
        		,tableAttrs: {width: '100%'}
        },
        padding:'0 0 0 0',
        border:false,
        items: [
        	{
        	xtype:'component',
        	html:'원자재 출고 예약 현황',
			style:{
				'font-size': '60px !important',
        		'font-weight':'bold'
        	}
        	
        },{
        	xtype:'container',
        	layout : {
        		type : 'uniTable', columns : 4,border:true
        		,tableAttrs: { style: 'border : 1px solid #000;'},
         		tdAttrs: {style: 'border : 1px solid #000;',width: '100%',align: 'center'}
        	},
        	defaults: {
				style:{
					'font': 'normal 20px Malgun Gothic',
					'font-size': '20px !important',
	        		'font-weight':'bold'
	        	}
	        },
        	width:500,
//        	tableAttrs: {width:500},
        	tdAttrs: {align: 'right'},
        	items:[{
	        	xtype:'component',
	        	html:'',
	        	width:200,
	        	itemId:'nowDays'
        	},{
	        	xtype:'component',
	        	html:'범 례',
	        	colspan:3,
	        	width:300
        	},{
	        	xtype:'component',
	        	html:'',
	        	itemId:'nowTimes'
        	},{
	        	xtype:'component',
	        	html:'출고전',
				cls:'x-change-cell1'
        	},{
	        	xtype:'component',
	        	html:'출고중',
				cls:'x-change-cell2'
        	},{
	        	xtype:'component',
	        	html:'완 료',
				cls:'x-change-cell3'
        	}]
        },{
        	xtype:'component',
        	width:10
        }]
    });
    
    
    Unilite.Main( {
        borderItems:[{
                region:'center',
                layout: 'border',
                border: false,
                items:[
                    panelSearch,masterGrid
                ]
            }   
        ],
        uniOpt:{
        	showToolbar: false
//        	forceToolbarbutton:true
        },
        id  : 'emp110skrvApp',
        fnInitBinding : function() {
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
            UniAppManager.setToolbarButtons(['reset'], true);
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	directMasterStore.loadStoreRecords();
        },
        onResetButtonDown: function() {
            directMasterStore.clearData(); 
            masterGrid.reset();
            
			clearInterval(chkinterval);
            this.setDefault();
        },
        setDefault: function() {
        	realTimer();
        	setInterval(realTimer, 500);
        }                         
    });       
    
        // 시간을 출력
    function realTimer() {
		const nowDate = new Date();
		const year = nowDate.getFullYear();
		const month= nowDate.getMonth() + 1;
		const date = nowDate.getDate();
		const hour = nowDate.getHours();
		const min = nowDate.getMinutes();
		const sec = nowDate.getSeconds();
		panelSearch.down('#nowTimes').setHtml(hour + ":" + addzero(min) + ":" + addzero(sec));
		panelSearch.down('#nowDays').setHtml(year + "년 " + addzero(month) + "월 " + addzero(date) + "일");
	}
    // 1자리수의 숫자인 경우 앞에 0을 붙여준다.
	function addzero(num) {
		if(num < 10) { num = "0" + num; }
 		return num;
	}
}
</script>