<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="gre800ukrv"  >
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
	Unilite.defineModel('gre800ukrvModel', {
	    fields: [  	
	   	//	{name: 'SEQ' 				, 			text: '연번', 				type: 'integer', editable:false},
	    	{name: 'COMP_CODE'			,			text: '법인코드',				type: 'string'},	
	   // 	{name: 'BASE_YEAR'		,			text: '기준년도',				type: 'uniDate'},	
	    	{name: 'BUILDING_NUM'		,			text: '건축물번호',				type: 'string',allowBlank:false},	
	    	{name: 'BUILDING_TYPE'		,			text: '구분',					type: 'string'},	
	    	{name: 'ADDR'				,			text: '주소지',				type: 'string'},	
	    	{name: 'PROPERTY_TYPE'		,			text: '소유권',				type: 'string'},	
	    	{name: 'INITIAL_PRICE'		,			text: '공시가</br>&nbsp;&nbsp;(원)',			type: 'integer'},	
	    	{name: 'DEPOSIT_AMT'		,			text: '보증금</br>&nbsp;&nbsp;(원)',			type: 'integer'},	
	    	{name: 'RENT_AMT'			,			text: '임대료</br>&nbsp;&nbsp;(원/월)',			type: 'integer'},	
	    	{name: 'AREA'				,			text: '총연면적</br>&nbsp;&nbsp;(㎡)',			type: 'integer'},	
	    	{name: 'AREA_OFFICE'		,			text: '사무',					type: 'integer'},	
	    	{name: 'AREA_SALES'			,			text: '영업',					type: 'integer'},	
	    	{name: 'AREA_RESTAURANT'	,			text: '식당',					type: 'integer'},	
	    	{name: 'AREA_LODGINT'		,			text: '기숙',					type: 'integer'},	
	    	{name: 'AREA_REST'			,			text: '휴식/대기',				type: 'integer'},	
	    	{name: 'AREA_EDUCATION'		,			text: '교육/훈련',				type: 'integer'},	
	    	{name: 'AREA_ETC'			,			text: '기타',					type: 'integer'}
		]
	});
    
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
        	read : 'gre800ukrvService.selectList',
        	update: 'gre800ukrvService.updateDetail',
			create: 'gre800ukrvService.insertDetail',
			destroy: 'gre800ukrvService.deleteDetail',
			syncAll: 'gre800ukrvService.saveAll'
        }
	});
	
	var directMasterStore = Unilite.createStore('gre800ukrvMasterStore',{
			model: 'gre800ukrvModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
            },
            proxy: directProxy,
			loadStoreRecords : function()	{
				var param= panelResult.getValues();			
				console.log( param );
				this.load({
						params : param,
						callback : function(records, operation, success) {
							if(success)	{
	    						
							}
						}
					}
				);
			},
			saveStore : function(config)	{	

            	var paramMaster= panelSearch.getValues();
				var inValidRecs = this.getInvalidRecords();
				
					if(inValidRecs.length == 0 )	{
					config = {
							params: [paramMaster]
					};
					
					this.syncAllDirect(config);					
            }else {
					var grid = Ext.getCmp('gre800ukrvGrid1');
                	grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			} 
		});
	
	var panelSearch = Unilite.createSearchPanel('${PKGNAME}SearchForm',{
		title: '건축물 현황',
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
				name: 'BASE_YEAR',
				xtype: 'uniYearField',
				width: 185,
				value: new Date().getFullYear(),
				allowBlank: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BASE_YEAR', newValue);
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
			name: 'BASE_YEAR',
			xtype: 'uniYearField',
			width: 185,
			value: new Date().getFullYear(),
			allowBlank: false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('BASE_YEAR', newValue);
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
    var masterGrid = Unilite.createGrid('gre800ukrvGrid1', {
    	region: 'center' ,
        layout : 'fit',
    	features: [ {id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],
        store : directMasterStore, 
        uniOpt:{	expandLastColumn: false,
        			useRowNumberer: false,
                    useMultipleSorting: true
        },
        tbar: [{
				itemId : 'ref1', iconCls : 'icon-referance'	,
				text:'전년도참조하기',
				handler: function() {
//	        		openOrderReferWindow();
				}
 			},{
				itemId : 'ref2', iconCls : 'icon-referance'	,
				text:'데이터가져오기',
				handler: function() {
//	        		openOrderReferWindow();
				}
			}
		],
        columns:  [ 
        	{xtype: 'rownumberer', /* dataIndex:'SEQ', */ 			width: 40, text:'연번',sortable: false,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            }
            },
        	{dataIndex: 'COMP_CODE'					,      	width :120, hidden: true}, 
//        	{dataIndex: 'BASE_YEAR'				,      	width :120, hidden: true}, 
        	{dataIndex: 'BUILDING_NUM'				,      	width :120}, 
        	{dataIndex: 'BUILDING_TYPE'				,      	width :100}, 
        	{dataIndex: 'ADDR'						,      	width :100}, 
        	{dataIndex: 'PROPERTY_TYPE'				,      	width :100}, 
        	{dataIndex: 'INITIAL_PRICE'				,      	width :100, summaryType: 'sum'}, 
        	{dataIndex: 'DEPOSIT_AMT'				,      	width :90, summaryType: 'sum'}, 
        	{dataIndex: 'RENT_AMT'					,      	width :90, summaryType: 'sum'}, 
        	{dataIndex: 'AREA'						,      	width :90, summaryType: 'sum'},
        	{text: '용도별 연면적(㎡)',
				columns:[
		        	{dataIndex: 'AREA_OFFICE'				,      	width :80, summaryType: 'sum'}, 
		        	{dataIndex: 'AREA_SALES'				,      	width :80, summaryType: 'sum'}, 
		        	{dataIndex: 'AREA_RESTAURANT'			,      	width :80, summaryType: 'sum'}, 
		        	{dataIndex: 'AREA_LODGINT'				,      	width :80, summaryType: 'sum'}, 
		        	{dataIndex: 'AREA_REST'					,      	width :80, summaryType: 'sum'}, 
		        	{dataIndex: 'AREA_EDUCATION'			,      	width :80, summaryType: 'sum'}, 
		        	{dataIndex: 'AREA_ETC'					,      	width :80, summaryType: 'sum'}
		        ]
        	}
        ],
        listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom){ //신규아닐때
			 		if (UniUtils.indexOf(e.field,['BUILDING_NUM']))   
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
		id: 'gre800ukrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print','newData'],false);
			UniAppManager.setToolbarButtons(['reset',  'excel', 'prev', 'next' ],true);
			panelSearch.setValue('BASE_YEAR', new Date().getFullYear() -1);
			panelResult.setValue('BASE_YEAR', new Date().getFullYear() -1);
		},
		
		onQueryButtonDown : function()	{
			directMasterStore.loadStoreRecords();
			
			UniAppManager.setToolbarButtons(['newData'],true);
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},	
		onNewDataButtonDown:  function()	{

			masterGrid.createRow();
		},	
		
		onSaveDataButtonDown: function (config) {
			directMasterStore.saveStore();
					
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
		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		}
	});
};

</script>