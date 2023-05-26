<%@page language="java" contentType="text/html; charset=utf-8"%> 
<script type="text/javascript" >// Program ID : bdc100ukrv
var PGM_ID = 'bdc100ukrv';
var PGM_TITLE = '통합문서 관리';
var EXT_PGM_ID = 'bdc100ukrv';
UniAppManager.setPageTitle(PGM_TITLE);
Ext.create('Ext.data.Store',{"comboType":"","comboCode":"","storeId":"BDC100ukrvLevel1Store","fields":["value","text","option"],"data":[{"text":"기획","value":"100"},{"text":"총무","value":"200"},{"text":"경리","value":"300"},{"text":"영업","value":"400"},{"text":"생산","value":"500"}]});
Ext.create('Ext.data.Store',{"comboType":"","comboCode":"","storeId":"BDC100ukrvLevel2Store","fields":["value","text","option"],"data":[{"text":"기획일반","value":"110","option":"100"},{"text":"기획대외","value":"120","option":"100"},{"text":"총무일반","value":"210","option":"200"},{"text":"경리일반","value":"310","option":"300"},{"text":"영업국내","value":"410","option":"400"},{"text":"영업해외","value":"420","option":"400"},{"text":"생산일반","value":"510","option":"500"},{"text":"연구개발","value":"520","option":"500"},{"text":"품질관리","value":"530","option":"500"}]});
Ext.create('Ext.data.Store',{"comboType":"","comboCode":"","storeId":"BDC100ukrvLevel3Store","fields":["value","text","option"],"data":[{"text":"기획조사","value":"111","option":"100|110"},{"text":"조직관리","value":"112","option":"100|110"},{"text":"사무관리","value":"113","option":"100|110"},{"text":"홍보관리","value":"114","option":"100|110"},{"text":"경영감사","value":"115","option":"100|110"},{"text":"투자관리","value":"121","option":"100|120"},{"text":"해외사업","value":"122","option":"100|120"},{"text":"관계회사","value":"123","option":"100|120"},{"text":"인사관리","value":"211","option":"200|210"},{"text":"복리관리","value":"212","option":"200|210"},{"text":"서무관리","value":"213","option":"200|210"},{"text":"섭외관리","value":"214","option":"200|210"},{"text":"시설관리","value":"215","option":"200|210"},{"text":"예산관리","value":"311","option":"300|310"},{"text":"결산관리","value":"312","option":"300|310"},{"text":"자금관리","value":"313","option":"300|310"},{"text":"원가관리","value":"314","option":"300|310"},{"text":"출납관리","value":"315","option":"300|310"},{"text":"세무관리","value":"316","option":"300|310"},{"text":"영업관리","value":"411","option":"400|410"},{"text":"고객관리","value":"412","option":"400|410"},{"text":"제안관리","value":"413","option":"400|410"},{"text":"수출관리","value":"421","option":"400|420"},{"text":"수입관리","value":"422","option":"400|420"},{"text":"바이어","value":"423","option":"400|420"},{"text":"공정관리","value":"511","option":"500|510"},{"text":"자재관리","value":"512","option":"500|510"},{"text":"외주관리","value":"513","option":"500|510"},{"text":"설비관리","value":"514","option":"500|510"}]});
Ext.create('Ext.data.Store',{"comboType":"AU","comboCode":"CM10","storeId":"CBS_AU_CM10","fields":["value","text","option"],"data":[{"value":"10","text":"레벨 0.","option":null},{"value":"11","text":"레벨 1.","option":null},{"value":"12","text":"레벨 2.","option":null},{"value":"13","text":"레벨 3.","option":null},{"value":"14","text":"레벨 4.","option":null},{"value":"15","text":"레벨 5.","option":null}]});

</script>

<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var detailWin;
function appMain() {
	/**
	 * Model 정의
	 * 다단계 콤보 처리 샘플 
	 * @type
	 */
	
	Unilite.defineModel('Bdc100ukrvModel', {
	    fields: [
	             {name:'DOC_NO'			,text:'문서번호',		type:'string' , isPk:true, editable:false},
	             {name:'DOC_NAME'		,text:'문서명',		type:'string' , allowBlank:false},
	             {name:'DOC_DESC'		,text:'문서설명',		type:'string'},
	             {name:'REG_EMP'		,text:'등록자ID',		type:'string' , editable:false},
	             {name:'REG_EMP_NAME'	,text:'등록자',		type:'string' , editable:false},
	             {name:'REG_DEPT'		,text:'등록부서코드',	type:'string' , editable:false},
	             {name:'REG_DEPT_NAME'	,text:'등록부서',		type:'string' , editable:false},
	             {name:'REG_DATE'		,text:'등록일',		type:'uniTime' , format:'His', editable:true},
	             {name:'CUSTOM_CODE'	,text:'거래처코드',	type:'string' },
	             {name:'CUSTOM_NAME'	,text:'거래처',		type:'string' },
	             {name:'PROJECT_NO'		,text:'영업기회번호',	type:'string' },
	             {name:'PROJECT_NAME'	,text:'영업기회명',	type:'string' },
	             {name:'DOC_LEVEL1'		,text:'대분류',		type:'string' , child: 'DOC_LEVEL2', store: Ext.data.StoreManager.lookup('BDC100ukrvLevel1Store')},	 
	             {name:'DOC_LEVEL2'		,text:'중분류',		type:'string' , child: 'DOC_LEVEL3', store: Ext.data.StoreManager.lookup('BDC100ukrvLevel2Store')},	
	             {name:'DOC_LEVEL3'		,text:'소분류',		type:'string' ,store: Ext.data.StoreManager.lookup('BDC100ukrvLevel3Store')},	
	             {name:'AUTH_LEVEL'		,text:'권한레벨',		type:'string' , defaultValue: 10, comboType:'AU' ,comboCode:'CM10', allowBlank:false},
	             {name:'READCNT'		,text:'조회수',		type:'int' 	  , editable:false},
	             {name:'REMARK'			,text:'비고',			type:'string' , editable:false},
	             {name:'ADD_FIDS'		,text:'등록파일',		type:'string' , editable:false},
	             {name:'DEL_FIDS'		,text:'삭제파일',		type:'string' , editable:false}
	             
	            ]
	});
	

	var directMasterStore = Unilite.createStore('bdc100ukrvStore', {
			model: 'Bdc100ukrvModel',
            autoLoad: true,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	read    : 'bdc100ukrvService.selectList'
                }
            }
            ,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
	});

	/**
	 * 검색 옵션 Store
	 * 
	 * @type
	 */
	var searchOptStore = Unilite.createStore('Bdc100ukrvSearchOptStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'문서명+내용'	, 'value':'1'},
			        {'text':'문서명'		, 'value':'2'},
			        {'text':'파일명'		, 'value':'3'}
	    		]
		});
		       
	/**
	 * 검색조건 (Search Panel)
	 * 
	 * @type
	 */     
	var panelSearch = Unilite.createSearchForm('searchForm',{
		region:'west',	
		title: '검색조건',
		split:true,
        width:329,
        margin: '0 0 0 0',
	    border: true,
		collapsible: false,	
		autoScroll:true,
		collapseDirection: 'rigth',
		tools: [{
			region:'west',
			type: 'left', 	
			itemId:'left',
			tooltip: 'Hide',
			handler: function(event, toolEl, panelHeader) {
						panelSearch.collapse(); 
				    }
			}
		],
		items:[{
		xtype:'container',
		defaults:{
			collapsible:true,
			titleCollapse:true,
			hideCollapseTool : true,
			bodyStyle:{'border-width': '0px',
						'spacing-bottom':'3px'
			},
			header:{ xtype:'header',
					 style:{
							'background-color': '#D9E7F8',
							'background-image':'none',
							'color': '#333333',
							'font-weight': 'normal',
							'border-width': '0px',
							'spacing':'5px'
							}
					}
		},		
		layout: {type: 'vbox', align:'stretch'},
	    defaultType: 'panel',
		items: [{	
			title: '기본정보', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout : {type : 'vbox' , align: 'stretch' },
            items :[{
				       	  fieldLabel: '등록일자',
				   	      xtype: 'uniDateRangefield',
				   	      startFieldName: 'REG_DATE_FR',
				   	      endFieldName: 'REG_DATE_TO',	
				   	      width: 330,
				   	      startDate: UniDate.get('startOfYear'),
				   	      endDate: UniDate.get('today'),
	        			  labelWidth:67
				   	 
			},{ 		
           		hidden: false,
				xtype: 'container',
				defaultType: 'uniTextfield',	
        		itemId : 'AdvanceSerch',
				layout: {type: 'uniTable', columns: 1},			    
			    items :[{
			    		 fieldLabel: '대분류',
			    		 name: 'DOC_LEVEL1',
			    		 xtype:'uniCombobox', 
		       			 store: Ext.data.StoreManager.lookup('BDC100ukrvLevel1Store'),
		       			 child: 'DOC_LEVEL2',
	        			  labelWidth:67
		       		 },{
		       			 fieldLabel: '중분류',
		       			 name: 'DOC_LEVEL2',
		       			 xtype:'uniCombobox',		       			 
		       			 store: Ext.data.StoreManager.lookup('BDC100ukrvLevel2Store'),
		       			 child: 'DOC_LEVEL3',
	        			 labelWidth:67
		       		 },{
		       			 fieldLabel: '소분류' ,
		       			 name: 'DOC_LEVEL3',
		       			 xtype:'uniCombobox',
		       			 labelWidth:67,
		       			 store: Ext.data.StoreManager.lookup('BDC100ukrvLevel3Store')
		       		 }
		        ]
   			}
        	]		
		}]
		}]
	});	//end panelSearch    
    
    

       /**
		 * Master Grid 정의(Grid Panel)
		 * 
		 * @type
		 */ 

    var masterGrid = Unilite.createGrid('bdc100ukrvGrid', {
        layout : 'fit',
        region: 'center',
        uniOpt:{
        			useRowNumberer: true,
                    useMultipleSorting: true,
                    useContextMenu: true
        },
        tbar: [
            {
        	text:'상세보기',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],
    	store: directMasterStore,
        columns:  [ 
        			 {dataIndex:'DOC_NO'		,width: 100 },
		             {dataIndex:'REG_DATE'		,width: 100 },
		             {dataIndex:'DOC_LEVEL1'	,width: 100 },	
		             {dataIndex:'DOC_LEVEL2'	,width: 100 , hidden : false},
		             {dataIndex:'DOC_LEVEL3'	,width: 100 , hidden : false},
		             {dataIndex:'READCNT'		,width: 60 },
		             {dataIndex:'REMARK'		,flex: 1 }
          ],
          listeners: {
          	// 필요한 경우만 사용(붙혀넣기 전에 값 변경할경우등)
          	// return false의 경우 복사를 진행 하지 않음
          	'beforePasteRecord': function(rowIndex, record) {
          		record.DOC_NO = 'XM20140411007';
          		console.log("beforePasteRecord rowIndex:", rowIndex);
          		return true;
          	},
          	'afterPasteRecord': function(rowIndex, record) {
          		console.log("afterPasteRecord rowIndex:", rowIndex);
          	} 
          }
         
    });  // masterGrid
    

    Unilite.Main( {
		items:[ {
				  layout:'fit',
				  flex:1,
				  border:false,
				  items:[{
				  		layout:'border',
				  		defaults:{style:{padding: '5 5 5 5'}},
				  		border:false,
				  		items:[
				 		 masterGrid
						,panelSearch
						]}
					]
				}
		],
		fnInitBinding : function() {
				UniAppManager.setToolbarButtons(['reset', 'newData'],true);
				var searchForm = this.down('#searchForm');
				searchForm.setValues({
					'DOC_LEVEL1': '200',
					'DOC_LEVEL2': '310',
					'DOC_LEVEL3': '312'
				});
		},
		onQueryButtonDown:function () {
				directMasterStore.loadStoreRecords();	
				UniAppManager.setToolbarButtons( 'newData', true);
		}
	});
} // appMain
</script>