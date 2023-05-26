\<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="grr100ukrv"  >
	<t:ExtComboStore comboType="BOR120"/>							<!-- 사업장   	-->  
	<t:ExtComboStore comboType="AU" comboCode="GO13"/>				<!-- 운행/폐지 구분  	-->	
	<t:ExtComboStore comboType="AU" comboCode="GO19"/>				<!-- 정비코드  	-->	
	<t:ExtComboStore comboType="AU" comboCode="GO21"/>				<!-- 결과판정  	-->	
	<t:ExtComboStore items="${ROUTE_COMBO}" storeId="routeStore" /> <!-- 노선 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>

<script type="text/javascript" >

var BsaCodeInfo = {	// 컨트롤러에서 값을 받아옴
	// 입고내역 셋팅(메인)
//	gsInvstatus: 		'${gsInvstatus}',
//	gsMoneyUnit: 		'${gsMoneyUnit}',
//	gsManageLotNoYN: 	'${gsManageLotNoYN}',
//	gsSumTypeLot:		'${gsSumTypeLot}',
//	gsSumTypeCell:		'${gsSumTypeCell}'		
};
	
/*var output =''; 	// 입고내역 셋팅 값 확인 alert
for(var key in BsaCodeInfo){
	output += key + '  :  ' + BsaCodeInfo[key] + '\n';
}
alert(output);*/

function appMain() {
		
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('grr100ukrvModel', {
	    fields: [  	
	   		
	    	{name: 'COMP_COD'					,			text: '법인코드',						type: 'string'},	
	 //   	{name: 'SERVICE_YEAR'				,			text: '기준년도',						type: 'uniDate'},	
	    	{name: 'ROUTE_NUM'					,			text: '노선번호</br>&nbsp;&nbsp;(B+NM)',			type: 'string',allowBlank:false},	
	    	{name: 'ROUTE_ID'					,			text: '노선번호</br>&nbsp;&nbsp;(ID)',				type: 'string',allowBlank:false},	
	    	{name: 'OPERATION_TYPE'				,			text: '유형구분',						type: 'string',comboType:'AU', comboCode:'GO10',allowBlank:false},	
	    	{name: 'ROUTE_SURVAY_CNT'			,			text: '(A+B+C+0.5*(D+E)-(G-F))',	type: 'uniQty'},	
	    	{name: 'ROUTE_NOTRUN_CNT'			,			text: '미운행노선</br>&nbsp;&nbsp;(B)',				type: 'uniQty'},	
	    	{name: 'ROUTE_ABOLISH_CNT'			,			text: '폐지된노선</br>&nbsp;&nbsp;(C)',				type: 'uniQty'},	
	    	{name: 'ROUTE_LARGE_MEDIUM_CNT'		,			text: '중형대형</br>&nbsp;&nbsp;구분노선</br>&nbsp;&nbsp;(D)',	type: 'uniQty'},	
	    	{name: 'ROUTE_GEN_CNT'				,			text: '일반벽지</br>&nbsp;&nbsp;구분노선</br>&nbsp;&nbsp;(E)',	type: 'uniQty'},	
	    	{name: 'ROUTE_COMBINE_CNT'			,			text: '통합노선</br>&nbsp;&nbsp;(F)',				type: 'uniQty'},	
	    	{name: 'ROUTE_RELATION_CNT'			,			text: '관련노선</br>&nbsp;&nbsp;(G)',				type: 'uniQty'}
		]
	});
    
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'grr100ukrvService.selectList',
        	update: 'grr100ukrvService.updateDetail',
			create: 'grr100ukrvService.insertDetail',
			destroy: 'grr100ukrvService.deleteDetail',
			syncAll: 'grr100ukrvService.saveAll'
        }
	});
	
	var masterStore = Unilite.createStore('grr100ukrvMasterStore',{
			model: 'grr100ukrvModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
	            useNavi : true			// prev | newxt 버튼 사용
            },
            proxy: directProxy,
            saveStore : function(config)	{	

            	var paramMaster= panelSearch.getValues();
				var inValidRecs = this.getInvalidRecords();
				
					if(inValidRecs.length == 0 )	{
					config = {
							params: [paramMaster]
					};
					
					this.syncAllDirect(config);					
            }else {
					var grid = Ext.getCmp('${PKGNAME}Grid');
                	grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			} ,
			loadStoreRecords: function()	{
				var searchForm = Ext.getCmp('${PKGNAME}SearchForm');
				var param= searchForm.getValues();
				if(searchForm.isValid())	{
					this.load({params: param});
				}
			}
			
		});
	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}SearchForm',{
		title: '기존노선의 작성내역',
        defaultType: 'uniSearchSubPanel',
        defaults: {
			autoScroll:true
	  	},
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title: '검색조건', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
	    	items:[{
				fieldLabel: '기준년도',
				name: 'SERVICE_YEAR',
				xtype: 'uniYearField',
				width: 185,
				value: new Date().getFullYear(),
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('SERVICE_YEAR', newValue);
						UniAppManager.app.onQueryButtonDown();
					}
				}
			}]				
		}],
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
    });
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			fieldLabel: '기준년도',
			name: 'SERVICE_YEAR',
			xtype: 'uniYearField',
			width: 185,
			value: new Date().getFullYear(),
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('SERVICE_YEAR', newValue);
					UniAppManager.app.onQueryButtonDown();
				}
			}
		}],
           	setAllFieldsReadOnly: function(b) { 
		    var r= true
		    if(b) {
		    	var invalid = this.getForm().getFields().filterBy(function(field) {
		        	return !field.validate();
		        });                      
		        /*
				 * if(invalid.length > 0) { r=false; var labelText = ''
				 * if(Ext.isDefined(invalid.items[0]['fieldLabel'])) { var
				 * labelText = invalid.items[0]['fieldLabel']+'은(는)'; } else
				 * if(Ext.isDefined(invalid.items[0].ownerCt)) { var labelText =
				 * invalid.items[0].ownerCt['fieldLabel']+'은(는)'; }
				 * alert(labelText+Msg.sMB083); invalid.items[0].focus(); } else
				 */ {
		      		// this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	// this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
  		setLoadRecord: function(record)	{
			var me = this;			
			me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});
	
	/**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('grr100ukrvGrid1', {
    	region: 'center' ,
        layout : 'fit',
    	features: [ {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
        store : masterStore, 
        uniOpt:{	expandLastColumn: false,
        			useRowNumberer: false,
                    useMultipleSorting: true
        },
        tbar: [ '->',{
        	itemId : 'ref1', iconCls : 'icon-referance'	,
    		text:'전년도 데이터 복사하기',
    		handler: function() {
//	        		openOrderReferWindow();
    			}
   		}, {
        	itemId : 'ref2', iconCls : 'icon-referance'	,
    		text:'기준년도 데이터 가져오기',
    		handler: function() {
//	        		openOrderReferWindow();
    			}
   		 }],
        columns:  [ 
        	{xtype: 'rownumberer',			     width: 40, text:'연번',sortable: false
        	, summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
              		return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
                }
            },
        	{dataIndex: 'COMP_CODE'					,      	width :120, hidden: true}, 
      //  	{dataIndex: 'SERVICE_YEAR'				,      	width :120, hidden: true},
        	{text: '인허가상노선(A)',
				columns:[
			    	{dataIndex: 'ROUTE_NUM'					,      	width :90}, 
			    	{dataIndex: 'ROUTE_ID'					,      	width :90}, 
			    	{dataIndex: 'OPERATION_TYPE'			,      	width :130}
			    ]
        	},
        	{text: '조사기준노선',
				columns:[
        			{dataIndex: 'ROUTE_SURVAY_CNT'			,      	width :160, summaryType: 'sum'}
        		]
        	},
        	{text: '운영관리노선',
				columns:[
		        	{dataIndex: 'ROUTE_NOTRUN_CNT'			,      	width :90, summaryType: 'sum'}, 
		        	{dataIndex: 'ROUTE_ABOLISH_CNT'			,      	width :90, summaryType: 'sum'}
		        ]
        	},
        	{text: '구분기재노선',
				columns:[
		        	{dataIndex: 'ROUTE_LARGE_MEDIUM_CNT'	,      	width :90, summaryType: 'sum'}, 
		        	{dataIndex: 'ROUTE_GEN_CNT'				,      	width :90, summaryType: 'sum'}
		        ]
        	},
        	{text: '통합관리노선',
				columns:[
		        	{dataIndex: 'ROUTE_COMBINE_CNT'			,      	width :90, summaryType: 'sum'}, 
		        	{dataIndex: 'ROUTE_RELATION_CNT'		,      	width :90, summaryType: 'sum'}
		        ]
        	}
        ],
        listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom){ //신규아닐때
			 		if (UniUtils.indexOf(e.field,['ROUTE_NUM']))   
			  			return false; 
					}
				}
			}
    });

    Unilite.Main ({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],  
		id: 'grr100ukrvApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['print','newData'],false);
			UniAppManager.setToolbarButtons(['reset',  'excel', 'prev', 'next' ],true);
			panelSearch.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
			panelResult.setValue('SERVICE_YEAR', new Date().getFullYear() -1);
		},
		
		onQueryButtonDown : function()	{
			masterStore.loadStoreRecords();
			
			UniAppManager.setToolbarButtons(['newData'],true);
		},
		
		onNewDataButtonDown:  function()	{
			masterGrid.createRow();
		},

		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{				
				masterGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				
					masterGrid.deleteSelectedRow();
				
			}
		},
		
		onResetButtonDown:function() {
			var me = this;
			panelSearch.reset();
			masterGrid.reset();
			UniAppManager.setToolbarButtons('save',false);
			this.fnInitBinding();
		},
		
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			masterStore.saveStore();
		}
	});
};

</script>