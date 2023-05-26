<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="emp100skrv"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="emp100skrv"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="WZ08" /> <!-- 외주/자재구분  --> 
    <t:ExtComboStore comboType="AU" comboCode="WZ21" /> <!-- 가공구분  -->
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
            read: 'emp100skrvService.selectList'
        }
    });
    Unilite.defineModel('emp100skrvModel', {
        fields: [
            {name: 'REQ_TYPE'              ,text:'의뢰구분'                 ,type: 'string'},
            {name: 'OEM_ITEM_CODE'	            ,text:'품번'                 ,type: 'string'},
            {name: 'PROG_WORK_NAME'	            ,text:'공정'                 ,type: 'string'},
            {name: 'REQ_DEPT_NAME'	            ,text:'의뢰부서'                 ,type: 'string'},
            {name: 'REQ_DATE'            ,text:'의뢰일자'                 ,type: 'uniDate'},
            {name: 'REP_FR_DATE'            ,text:'보수시작'                 ,type: 'uniDate'},
            {name: 'REP_TO_DATE'	        ,text:'보수완료'                 ,type: 'uniDate'}
        ]
    }); 
    
    var directMasterStore = Unilite.createStore('emp100skrvMasterStore',{
        model: 'emp100skrvModel',
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
        	   read: 'emp100skrvService.selectList'                 	
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

    var masterGrid = Unilite.createGrid('emp100skrvMasterGrid', {
        layout : 'fit',   
        region: 'center',        
//        border:false,
        store: directMasterStore,
        uniOpt: {
            onLoadSelectFirst : false,
        	userToolbar :false,
			useRowNumberer: false,		//번호 컬럼 사용 여부
			useLoadFocus:false
        },
        bbar: [{
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
				if(!Ext.isEmpty(record.get("REQ_DATE")) && Ext.isEmpty(record.get("REP_FR_DATE")) && Ext.isEmpty(record.get("REP_TO_DATE"))  ){
					cls = 'x-change-cell1';
				}else if(!Ext.isEmpty(record.get("REQ_DATE")) && !Ext.isEmpty(record.get("REP_FR_DATE")) && Ext.isEmpty(record.get("REP_TO_DATE"))  ){
					cls = 'x-change-cell2';
				}else if(!Ext.isEmpty(record.get("REQ_DATE")) && !Ext.isEmpty(record.get("REP_FR_DATE")) && !Ext.isEmpty(record.get("REP_TO_DATE"))  ){
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
            { dataIndex: 'REQ_TYPE'                       ,           width: 100, align:'center'},
            { dataIndex: 'OEM_ITEM_CODE'	                ,           width: 200},
            { dataIndex: 'PROG_WORK_NAME'	                ,           width: 250},
            { dataIndex: 'REQ_DEPT_NAME'	                ,           width: 200},
            { dataIndex: 'REQ_DATE'                       ,           width: 150},
            { dataIndex: 'REP_FR_DATE'                    ,           width: 150},
            { dataIndex: 'REP_TO_DATE'	                ,           width: 150}
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
        	html:'금형수리 진행현황',
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
	        	html:'보수전',
				cls:'x-change-cell1'
        	},{
	        	xtype:'component',
	        	html:'보수중',
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
        id  : 'emp100skrvApp',
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