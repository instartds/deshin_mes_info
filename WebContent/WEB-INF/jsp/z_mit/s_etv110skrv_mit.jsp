<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_etv110skrv_mit"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_etv110skrv_mit"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="WZ08" /> <!-- 외주/자재구분  --> 
    <t:ExtComboStore comboType="AU" comboCode="WZ21" /> <!-- 가공구분  -->
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
</script>

<style type="text/css">

.x-change-cell1 {
color: red;
}

.x-group-header {
height:auto;
}
.x-grid-cell-complete {
	background-color:yellow;
	font-size: 15px !important;
}

.x-grid-cell-process {
	font-size: 15px !important;
}

.x-grid-cell {
    height: 40px;
    border-left: 1px solid #FFFFFF !important;
    border-right: 1px solid #eee !important;
    font: normal 20px Malgun Gothic,Gulim,tahoma, arial, verdana, sans-serif;
    font-weight: bold;
}
.x-grid-cell-inner {
    padding: 5px 6px 2px 6px;
}
</style>
<script type="text/javascript" >

function appMain() {
	
	var glInterval = ${glInterval};
	var chkinterval = null;
	var exchgInterval = null;
	var nextPgmId = '${nextPgmId}';
	var contentsList = ${contentsList};
	var colData = ${colData}; //날짜 데이터 가져오기
	
	var contents = new Array();
	//fnSetExchgItems(contentsList); 	
	
    Unilite.defineModel('s_etv110skrv_mitModel', {
        fields: [
            {name: 'GUBUN'              ,text:'구분'                    ,type: 'string'},
            {name: 'D_Y_2'	                             ,type: 'uniQty'},
            {name: 'D_Y_1'	                             ,type: 'uniQty'},
            {name: 'D_DAY'	                             ,type: 'uniQty'},
            {name: 'D_T_1'	                             ,type: 'uniQty'},
            {name: 'D_T_2'	                             ,type: 'uniQty'},
            {name: 'D_T_3'	                             ,type: 'uniQty'},
            {name: 'M_TARGET_Q'	        ,text:'목표'                    ,type: 'uniQty'},
            {name: 'M_SUM_Q'	        ,text:'누계'                    ,type: 'uniQty'},
            {name: 'M_RATE'	            ,text:'달성율(%)'                ,type: 'uniPercent'},
            {name: 'Y_TARGET_Q'	        ,text:'목표'                    ,type: 'uniQty'},
            {name: 'Y_SUM_Q'	        ,text:'누계'                    ,type: 'uniQty'},
            {name: 'Y_RATE'	            ,text:'달성율(%)'                ,type: 'uniPercent'}
        ]    
        
    }); 
    
    Unilite.defineModel('s_etv110skrv_mitModel1', {
        fields: [
            {name: 'LOT_NO_1'           ,text:'1'                 ,type: 'string'},
            {name: 'LOT_NO_2'           ,text:'2'                 ,type: 'string'},
            {name: 'LOT_NO_3'           ,text:'3'                 ,type: 'string'},
            {name: 'LOT_NO_4'           ,text:'4'                 ,type: 'string'},
            {name: 'LOT_NO_5'           ,text:'5'                 ,type: 'string'},
            {name: 'LOT_NO_6'           ,text:'6'                 ,type: 'string'},
            {name: 'LOT_NO_7'           ,text:'7'                 ,type: 'string'},
            {name: 'LOT_NO_8'           ,text:'8'                 ,type: 'string'},
            {name: 'LOT_NO_9'           ,text:'9'                 ,type: 'string'},
            {name: 'LOT_NO_10'          ,text:'10'                ,type: 'string'},
            {name: 'LOT_NO_11'          ,text:'11'                ,type: 'string'},
            {name: 'LOT_NO_12'          ,text:'12'                ,type: 'string'},
            {name: 'WORK_YN_1'          ,text:'YN_1'                 ,type: 'string'},
            {name: 'WORK_YN_2'          ,text:'YN_2'                 ,type: 'string'},
            {name: 'WORK_YN_3'          ,text:'YN_3'                 ,type: 'string'},
            {name: 'WORK_YN_4'          ,text:'YN_4'                 ,type: 'string'},
            {name: 'WORK_YN_5'          ,text:'YN_5'                 ,type: 'string'},
            {name: 'WORK_YN_6'          ,text:'YN_6'                 ,type: 'string'},
            {name: 'WORK_YN_7'          ,text:'YN_7'                 ,type: 'string'},
            {name: 'WORK_YN_8'          ,text:'YN_8'                 ,type: 'string'},
            {name: 'WORK_YN_9'          ,text:'YN_9'                 ,type: 'string'},
            {name: 'WORK_YN_10'         ,text:'YN_10'                ,type: 'string'},
            {name: 'WORK_YN_11'         ,text:'YN_11'                ,type: 'string'},
            {name: 'WORK_YN_12'         ,text:'YN_12'                ,type: 'string'}
        ]
    }); 
    
	Unilite.defineModel('s_etv110skrv_mitModelContents', {
		fields: [
			{name: 'TITLE'		    ,text:'제목'	        ,type: 'string'},
			{name: 'CONTENTS'		,text:'공시사항'		,type: 'string'}
				]
	});    
	
    var directMasterStore = Unilite.createStore('s_etv110skrv_mitMasterStore',{
        model: 's_etv110skrv_mitModel',
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
        	   read: 's_etv110skrv_mitService.selectList'                 	
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
						var record = records[records.length - 1];
//						if(record.get('TOTAL') == record.get('ROW_NUMBER')){
							if(Ext.isEmpty(nextPgmId)) {
								//masterGrid.down("#ptb").moveFirst();
								window.location.reload();
							}
							else {
								window.location.href = CPATH + nextPgmId + ".do";
							}
//						} else {
//							masterGrid.down("#ptb").moveNext();
//						}
						//directMasterStore.loadStoreRecords();
					}, glInterval);
				}else{
					clearInterval(chkinterval);
					chkinterval = setInterval(function(){
						if(Ext.isEmpty(nextPgmId)) {
							//directMasterStore.loadStoreRecords();
							window.location.reload();
						}
						else {
							window.location.href = CPATH + nextPgmId + ".do";
						}
					}, glInterval);
				}
			}
		}
	});
    
    var directMasterStore1 = Unilite.createStore('s_etv110skrv_mitMasterStore1',{
        model: 's_etv110skrv_mitModel1',
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
        	   read: 's_etv110skrv_mitService.selectList1'                 	
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

			}
		}
	});  
	
	var directContentsStore = Unilite.createStore('s_etv110skrv_mitContentsStore', {
		model: 's_etv110skrv_mitModelContents',
		uniOpt: {
			isMaster:  false,	// 상위 버튼 연결 
			editable:  false,	// 수정 모드 사용 
			deletable: false,	// 삭제 가능 여부 
			useNavi :  false	// prev | newxt 버튼 사용
		},
		autoLoad: true,
		proxy: Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
			api: {
				read: 's_etv110skrv_mitService.selectContents'
			}
		}),
		loadStoreRecords : function() {
			this.load(
					
			);
		},
		listeners: {
			load: function(store, records, successful, eOpts) {
				if(store.getCount() > 0) {
					fnSetExchgItems(records);					
					//panelsouth.suspendLayouts(true);
					panelsouth.removeAll();
					panelsouth.add(contents);
					//panelsouth.suspendLayouts(false);					
					panelsouth.updateLayout();
				}
			}
		}
	});	

    var masterGrid = Unilite.createGrid('s_etv110skrv_mitMasterGrid', {
        layout : 'fit',   
        region: 'center',
        width:'100%',
        store: directMasterStore,
        uniOpt: {
            onLoadSelectFirst : false,
            expandLastColumn: false,
        	userToolbar :false,
			useRowNumberer: false,		//번호 컬럼 사용 여부
			useLoadFocus:false
        },
        selModel:'rowmodel',
        columns:  [ 
        	{ dataIndex: 'GUBUN'                    ,flex:1	,minWidth: 120, align:'center'},
            { dataIndex: 'D_Y_2'	                ,flex:1	,minWidth: 120},
            { dataIndex: 'D_Y_1'	                ,flex:1	,minWidth: 120},
            { dataIndex: 'D_DAY'	                ,flex:1	,minWidth: 120},
            { dataIndex: 'D_T_1'                    ,flex:1	,minWidth: 120},
            { dataIndex: 'D_T_2'                    ,flex:1	,minWidth: 120},
            { dataIndex: 'D_T_3'	                ,flex:1	,minWidth: 120},
            {
              text: '월',
              columns:[
			            { dataIndex: 'M_TARGET_Q'	            ,width: 120},
			            { dataIndex: 'M_SUM_Q'	                ,width: 120},
			            { dataIndex: 'M_RATE'	                ,width: 120}
		              ] 
            }, 
            {
              text: '년',
              columns:[
			            { dataIndex: 'Y_TARGET_Q'	            ,width: 120},
			            { dataIndex: 'Y_SUM_Q'	                ,width: 120},
			            { dataIndex: 'Y_RATE'	                ,width: 120}
		              ] 
            }
        ] 
    });
    
    var masterGrid1 = Unilite.createGrid('s_etv110skrv_mitMasterGrid1', {
        layout : 'fit',   
        region: 'south',    
        height		: '53%',
        width:'100%',
        title : '당일 실적처리현황(Lot)',
        store: directMasterStore1,
        uniOpt: {
            onLoadSelectFirst : false,
            expandLastColumn: false,
        	userToolbar :false,
			useRowNumberer: true,		//번호 컬럼 사용 여부
			useLoadFocus:false
        },
        selModel:'rowmodel',
        columns:  [ 
			{ dataIndex: 'LOT_NO_1'				,flex:1	,minWidth: 100	, align: 'center',
				renderer: function(value, meta, record) {
					if(record.get('WORK_YN_1')=="Y"){
						meta.tdCls = 'x-grid-cell-complete';
					}
					else {
						meta.tdCls = 'x-grid-cell-process';
					}
					return value;
				}
			},        	
			{ dataIndex: 'LOT_NO_2'				,flex:1	,minWidth: 100	, align: 'center',
				renderer: function(value, meta, record) {
					if(record.get('WORK_YN_2')=="Y"){
						meta.tdCls = 'x-grid-cell-complete';
					}
					else {
						meta.tdCls = 'x-grid-cell-process';
					}
					return value;
				}
			},  
			{ dataIndex: 'LOT_NO_3'				,flex:1	,minWidth: 100	, align: 'center',
				renderer: function(value, meta, record) {
					if(record.get('WORK_YN_3')=="Y"){
						meta.tdCls = 'x-grid-cell-complete';
					}
					else {
						meta.tdCls = 'x-grid-cell-process';
					}
					return value;
				}
			},  
			{ dataIndex: 'LOT_NO_4'				,flex:1	,minWidth: 100	, align: 'center',
				renderer: function(value, meta, record) {
					if(record.get('WORK_YN_4')=="Y"){
						meta.tdCls = 'x-grid-cell-complete';
					}
					else {
						meta.tdCls = 'x-grid-cell-process';
					}
					return value;
				}
			},  
			{ dataIndex: 'LOT_NO_5'				,flex:1	,minWidth: 100	, align: 'center',
				renderer: function(value, meta, record) {
					if(record.get('WORK_YN_5')=="Y"){
						meta.tdCls = 'x-grid-cell-complete';
					}
					else {
						meta.tdCls = 'x-grid-cell-process';
					}
					return value;
				}
			},  
			{ dataIndex: 'LOT_NO_6'				,flex:1	,minWidth: 100	, align: 'center',
				renderer: function(value, meta, record) {
					if(record.get('WORK_YN_6')=="Y"){
						meta.tdCls = 'x-grid-cell-complete';
					}
					else {
						meta.tdCls = 'x-grid-cell-process';
					}
					return value;
				}
			},  
			{ dataIndex: 'LOT_NO_7'				,flex:1	,minWidth: 100	, align: 'center',
				renderer: function(value, meta, record) {
					if(record.get('WORK_YN_7')=="Y"){
						meta.tdCls = 'x-grid-cell-complete';
					}
					else {
						meta.tdCls = 'x-grid-cell-process';
					}
					return value;
				}
			}, 
			{ dataIndex: 'LOT_NO_8'				,flex:1	,minWidth: 100	, align: 'center',
				renderer: function(value, meta, record) {
					if(record.get('WORK_YN_8')=="Y"){
						meta.tdCls = 'x-grid-cell-complete';
					}
					else {
						meta.tdCls = 'x-grid-cell-process';
					}
					return value;
				}
			}, 
			{ dataIndex: 'LOT_NO_9'				,flex:1	,minWidth: 100	, align: 'center',
				renderer: function(value, meta, record) {
					if(record.get('WORK_YN_9')=="Y"){
						meta.tdCls = 'x-grid-cell-complete';
					}
					else {
						meta.tdCls = 'x-grid-cell-process';
					}
					return value;
				}
			},  
			{ dataIndex: 'LOT_NO_10'			,flex:1	,minWidth: 100	, align: 'center',
				renderer: function(value, meta, record) {
					if(record.get('WORK_YN_10')=="Y"){
						meta.tdCls = 'x-grid-cell-complete';
					}
					else {
						meta.tdCls = 'x-grid-cell-process';
					}
					return value;
				}
			},  
			{ dataIndex: 'LOT_NO_11'			,flex:1	,minWidth: 100	, align: 'center',
				renderer: function(value, meta, record) {
					if(record.get('WORK_YN_11')=="Y"){
						meta.tdCls = 'x-grid-cell-complete';
					}
					else {
						meta.tdCls = 'x-grid-cell-process';
					}
					return value;
				}
			},  
			{ dataIndex: 'LOT_NO_12'			,flex:1	,minWidth: 100	, align: 'center',
				renderer: function(value, meta, record) {
					if(record.get('WORK_YN_12')=="Y"){
						meta.tdCls = 'x-grid-cell-complete';
					}
					else {
						meta.tdCls = 'x-grid-cell-process';
					}
					return value;
				}
			},  			
            { dataIndex: 'WORK_YN_1'	            ,           width: 100, hidden:true},
            { dataIndex: 'WORK_YN_2'	            ,           width: 100, hidden:true},
            { dataIndex: 'WORK_YN_3'	            ,           width: 100, hidden:true},
            { dataIndex: 'WORK_YN_4'	            ,           width: 100, hidden:true},
            { dataIndex: 'WORK_YN_5'	            ,           width: 100, hidden:true},
            { dataIndex: 'WORK_YN_6'	            ,           width: 100, hidden:true},
            { dataIndex: 'WORK_YN_7'	            ,           width: 100, hidden:true},
            { dataIndex: 'WORK_YN_8'	            ,           width: 100, hidden:true},
            { dataIndex: 'WORK_YN_9'	            ,           width: 100, hidden:true},
            { dataIndex: 'WORK_YN_10'	            ,           width: 100, hidden:true},
            { dataIndex: 'WORK_YN_11'	            ,           width: 100, hidden:true},
            { dataIndex: 'WORK_YN_12'	            ,           width: 100, hidden:true}
        ] 
    });    
    
	var panelSearch = Unilite.createSearchForm('panelSearch',{
        region: 'north',
        layout : {type : 'uniTable', columns : 1
        		,tableAttrs: {width: '100%'}
        },
        padding:'0 0 0 0',
        border:false,
        items: [
        	{        	
			xtype	: 'component',
			html	: '코팅',		
			style 	: {
				'font-size': '40px !important',
        		'font-weight':'bold',
        		'text-align':'center'
			}        	
        	
        }]
    });  
    
	var panelsouth = Unilite.createSearchForm('southForm', {
    	region: 'south',
    	title : '[공지사항]',
    	layout : {type : 'uniTable', columns : 1, tableAttrs: { width: '100%'},
			  tdAttrs: {style: 'font-size:14px;', align : 'left'}},
        height		: '15%',			  
		padding:'1 1 1 1',
		border:true,
		items: contents
	});  

    Unilite.Main( {
        borderItems:[{
                region:'center',
                layout: 'border',
                border: false,
                items:[
                    panelSearch,masterGrid, masterGrid1, panelsouth
                ]
            }   
        ],
        uniOpt:{
        	showToolbar: false
//        	forceToolbarbutton:true
        },
        id  : 's_etv110skrv_mitApp',
        fnInitBinding : function() {
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
            UniAppManager.setToolbarButtons(['reset'], true);
            this.setDefault();
            goFullscreen();
            day_change(masterGrid, colData);
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
//			realTime();
//			setInterval(realTime, 500);        	

        }                         
    }); 
    
	//시간 출력
	function realTime() {
		const nowDate = new Date();
		const year	  = nowDate.getFullYear();
		const month	  = nowDate.getMonth() + 1;
		const date	  = nowDate.getDate();
		
//		panelSearch.down('#nowDay').setHtml("(" + year + "." + addzero(month) + "." + addzero(date) + ")");
	}
	
	// 1자리 수의 숫자인 경우 앞에 0을 붙여준다.
	function addzero(num) {
		if(num < 10) {num = "0" + num;}
		return num;
	}  
	
	function goFullscreen() {
		var el = document.getElementById('ext-body');
		var requestMethod = el.requestFullScreen || el.webkitRequestFullScreen || el.mozRequestFullScreen || el.msRequestFullScreen;
		
		if (requestMethod) { // Native full screen.
			requestMethod.call(el);
		} else if (typeof window.ActiveXObject !== "undefined") { // Older IE.
			var wscript = new ActiveXObject("WScript.Shell");
			if (wscript !== null) {
				wscript.SendKeys("{F11}");
			}
		}
	}
	
	function day_change(masterGrid, colData){
		
		masterGrid.getColumn('D_Y_2').setText(String(colData[0]));
		masterGrid.getColumn('D_Y_1').setText(String(colData[1]));
		masterGrid.getColumn('D_DAY').setText(String(colData[2]));
		masterGrid.getColumn('D_T_1').setText(String(colData[3]));
		masterGrid.getColumn('D_T_2').setText(String(colData[4]));
		masterGrid.getColumn('D_T_3').setText(String(colData[5]));
		masterGrid.getColumn('D_DAY').setStyle('color', 'red');

	}	
	
	function fnSetExchgItems(param) {
		contents = [];
			
		contents.push({
			xtype:'component',
			html:'&nbsp;',
			height:5,
			tdAttrs: {width:'100%'}
		});	//	상단공백	
		
		var lLoop = 0;
		Ext.each(param, function(record, index){
			if(record.hasOwnProperty('data')) {
				record = record.data;
			}
			/*
			var text1 = '<div style="display:inline-block;">'
					 + record.TITLE + ' : '
					 + '</div>';
			
			var content1 = {
				xtype:'component',
				html:text1
			};
			
			contents.push(content1);
			*/
			
			if(lLoop < 2) {
				return false;
			}
			else {
				lLoop++;
			}
			
			var text2 = '<div style="display:inline-block;font-size:15pt;">'
					  + ' '
					  + record.CONTENTS
					  + '</div>';
			
			var content2 = {
				xtype:'component',
				html:text2
			};
			
			contents.push(content2);
		});
		
		for(var rowCnt = 2 - param.length; rowCnt > 0; rowCnt--){
			contents.push({
				xtype:'component',
				html:'&nbsp;'
			});	//	하단공백채우기
		}
		
		contents.push({
			xtype:'component',
			html:'&nbsp;',
			height:5
		});	//	하단공백
	}
}
</script>