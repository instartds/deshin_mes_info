<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="s_bcm100ukrv_KOCIS"  >
	<t:ExtComboStore comboType="AU" comboCode="B015" /><!-- 거래처구분    -->  
	<t:ExtComboStore comboType="AU" comboCode="B016" /><!-- 법인/개인-->        
	<t:ExtComboStore comboType="AU" comboCode="B012" /><!-- 국가코드-->         
	<t:ExtComboStore comboType="AU" comboCode="B004" /><!-- 기준화폐-->         
	<t:ExtComboStore comboType="AU" comboCode="B017" /><!-- 원미만계산-->       
	<t:ExtComboStore comboType="AU" comboCode="A022" /><!-- 계산서종류-->       
	<t:ExtComboStore comboType="AU" comboCode="B038" /><!--결제방법-->  	     
	<t:ExtComboStore comboType="AU" comboCode="B034" /><!--결제조건-->         
	<t:ExtComboStore comboType="AU" comboCode="B033" /><!--마감종류-->         
	<t:ExtComboStore comboType="AU" comboCode="B010" /><!--사용여부-->        
	<t:ExtComboStore comboType="AU" comboCode="B030" /><!--세액포함여부-->         
	<t:ExtComboStore comboType="AU" comboCode="B051" /><!--세액계산법-->           
	<t:ExtComboStore comboType="AU" comboCode="B055" /><!--거래처분류-->           
	<t:ExtComboStore comboType="AU" comboCode="B056" /><!--지역구분   -->          
	<t:ExtComboStore comboType="AU" comboCode="B057" /><!--미수관리방법-->         
	<t:ExtComboStore comboType="AU" comboCode="S010" /><!--주담당자  -->           
	<t:ExtComboStore comboType="AU" comboCode="B062" /><!--카렌더타입  -->         
	<t:ExtComboStore comboType="AU" comboCode="B086" /><!--카렌더타입 -->        
	<t:ExtComboStore comboType="AU" comboCode="S051" /><!--전자문서구분 -->        
	<t:ExtComboStore comboType="AU" comboCode="A020" /><!--전자문서주담당여부 -->  
	<t:ExtComboStore comboType="AU" comboCode="B109" /><!--유통채널	--> 
	<t:ExtComboStore comboType="AU" comboCode="B232" /><!--신/구 주소구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="B131" /><!--예/아니오 -->
	
    <t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
</t:appConfig>
<style type= "text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel2 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >
var detailWin;


function appMain() {

	Unilite.defineModel('bcm100ukrvModel', {
		// pkGen : user, system(default)
	    fields: [
            {name: 'CUSTOM_CODE' 		,text:'거래처코드' 		,type:'string'	/*, isPk:true, pkGen:'user'*/,editable:false},
            {name: 'CUSTOM_TYPE' 		,text:'구분' 			,type:'string'	,comboType:'AU',comboCode:'B015' ,allowBlank: false, defaultValue:'1'},
            {name: 'CUSTOM_NAME' 		,text:'거래처명' 		,type:'string'	,allowBlank:false},
            {name: 'CUSTOM_NAME1' 		,text:'거래처명1' 		,type:'string'	},
            {name: 'CUSTOM_NAME2' 		,text:'거래처명2' 		,type:'string'	},
            {name: 'CUSTOM_FULL_NAME' 	,text:'거래처명(전명)' 	,type:'string'	,allowBlank:false},
            {name: 'NATION_CODE' 		,text:'국가코드' 		,type:'string'	,comboType:'AU',comboCode:'B012'},
            {name: 'AGENT_TYPE'         ,text:'고객분류'       ,type:'string'  ,comboType:'AU',comboCode:'B055'},
            
            {name: 'TOP_NAME' 			,text:'대표자' 		,type:'string'	},
            {name: 'BUSINESS_TYPE' 	    ,text:'법인/개인' 		,type:'string'	,comboType:'AU',comboCode:'B016'},
            {name: 'USE_YN' 			,text:'사용유무' 		,type:'string'	,comboType:'AU',comboCode:'B010', defaultValue:'Y'},
            {name: 'COMP_TYPE' 		    ,text:'업태' 			,type:'string'	},
            {name: 'COMP_CLASS' 		,text:'업종' 			,type:'string'	},

            {name: 'TELEPHON' 			,text:'전화번호' 		,type:'string'	},
            {name: 'FAX_NUM' 			,text:'FAX번호' 		,type:'string'	},
            {name: 'START_DATE' 		,text:'거래시작일'    	,type:'uniDate'	,allowBlank: false, defaultValue:UniDate.today()},
            {name: 'STOP_DATE' 		    ,text:'거래중단일'    	,type:'uniDate'	},
            {name: 'MONEY_UNIT' 		,text:'기준화폐' 		,type:'string'	, comboType:'AU',comboCode:'B004'},
            {name: 'SET_METH' 			,text:'결제방법' 		,type:'string'	, comboType:'AU',comboCode:'B038'},
            {name: 'REMARK' 			,text:'비고' 			,type:'string'	},				

            {name: 'BANK_NAME'          ,text:'계좌명'        ,type:'string'   },
            {name: 'BANKBOOK_NUM' 		,text:'계좌번호' 		,type:'string'	},
            {name: 'BANKBOOK_NAME' 	    ,text:'예금주' 		,type:'string'	},
            {name: 'COMP_CODE' 		    ,text:'COMP_CODE' 	,type:'string'	, defaultValue: UserInfo.compCode}
        ]
	});

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read	: 's_bcm100ukrvService_KOCIS.selectList',
			update	: 's_bcm100ukrvService_KOCIS.updateDetail',
			create	: 's_bcm100ukrvService_KOCIS.insertDetail',
			destroy	: 's_bcm100ukrvService_KOCIS.deleteDetail',
			syncAll	: 's_bcm100ukrvService_KOCIS.saveAll'
		}
	});
	var directMasterStore = Unilite.createStore('bcm100ukrvMasterStore',{
		model: 'bcm100ukrvModel',
        autoLoad: false,
        uniOpt : {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: true,			// 수정 모드 사용 
        	deletable:true,			// 삭제 가능 여부 
            useNavi : false			// prev | next 버튼 사용
        },
        proxy: directProxy,
        
        listeners: {
        	update:function( store, record, operation, modifiedFieldNames, eOpts )	{
				detailForm.setActiveRecord(record);
			},
			metachange:function( store, meta, eOpts ){
				
			}
        	
        }, // listeners
        
		// Store 관련 BL 로직
        // 검색 조건을 통해 DB에서 데이타 읽어 오기 
		loadStoreRecords : function()	{
			var param= Ext.getCmp('bcm100ukrvSearchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		
		// 수정/추가/삭제된 내용 DB에 적용 하기 
		saveStore : function(config)	{				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 )	{
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
    });	
    
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('bcm100ukrvSearchForm',{
		title: '검색조건',
		defaultType: 'uniSearchSubPanel',
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		defaults: {
			autoScroll:true
	  	},
		items:[{
			title: '기본정보', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',   			
	    	items:[{
                xtype: 'uniCombobox',
                fieldLabel: '기관',
                name: 'DEPT_CODE',
                store: Ext.data.StoreManager.lookup('deptKocis'),
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DEPT_CODE', newValue);
                    }
                }
            },{	    
				fieldLabel: '거래처코드',
				name: 'CUSTOM_CODE',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CUSTOM_CODE', newValue);
					}
				}
			},{
			    fieldLabel: '거래처명',
				name: 'CUSTOM_NAME',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CUSTOM_NAME', newValue);
					}
				}
			}]
		}]
	});	//end panelSearch    
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		weight:-100,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
            xtype: 'uniCombobox',
            fieldLabel: '기관',
            name: 'DEPT_CODE',
            store: Ext.data.StoreManager.lookup('deptKocis'),
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelSearch.setValue('DEPT_CODE', newValue);
                }
            }
        },{	    
			fieldLabel: '거래처코드',
			name: 'CUSTOM_CODE',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CUSTOM_CODE', newValue);
				}
			}
		},{
		    fieldLabel: '거래처명',
			name: 'CUSTOM_NAME',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CUSTOM_NAME', newValue);
				}
			}
		}]	
    });
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('bcm100ukrvGrid', {
    	region:'center',
    	store: directMasterStore,
        layout : 'fit',        
		uniOpt:{
        	expandLastColumn: false,
            useMultipleSorting: true
        },
        border:true,
		columns:[
            {dataIndex:'CUSTOM_CODE'		,width:80, hideable:false, isLink:true},
			 {dataIndex:'CUSTOM_TYPE'		,width:80, hideable:false},
			 {dataIndex:'CUSTOM_NAME'		,width:170,hideable:false},
			 {dataIndex:'CUSTOM_NAME1'		,width:150	, hidden:true},
			 {dataIndex:'CUSTOM_NAME2'		,width:150	, hidden:true},
			 {dataIndex:'CUSTOM_FULL_NAME'	,width:170},
			 
			 {dataIndex:'NATION_CODE'		,width:130	, hidden:true},
             {dataIndex:'AGENT_TYPE'        ,width:100},
			 {dataIndex:'TOP_NAME'			,width:100},
			 {dataIndex:'BUSINESS_TYPE'		,width:110	, hidden:true},
			 {dataIndex:'USE_YN'			,width:60	, hidden:true},
			 {dataIndex:'COMP_TYPE'			,width:140},
			 {dataIndex:'COMP_CLASS'		,width:140},
			
			 {dataIndex:'TELEPHON'			,width:80},
			 {dataIndex:'FAX_NUM'			,width:80	, hidden:true},
			 {dataIndex:'START_DATE'		,width:110	, hidden:true},
			 {dataIndex:'STOP_DATE'			,width:110	, hidden:true},
			 
			 {dataIndex:'MONEY_UNIT'		,width:130	, hidden:true},
			 {dataIndex:'REMARK'			,width:250	, flex:1},
			 
             {dataIndex:'BANK_NAME'         ,width:100  , hidden:true},
			 {dataIndex:'BANKBOOK_NUM'		,width:100	, hidden:true},
			 {dataIndex:'BANKBOOK_NAME'		,width:100	, hidden:true}
        ], 
         listeners: {          	
          	selectionchangerecord:function(selected)	{
          		detailForm.setActiveRecord(selected)
          	},
          	onGridDblClick:function(grid, record, cellIndex, colName) {
          		if(!record.phantom) {
	      			switch(colName)	{
					case 'CUSTOM_CODE' :
							masterGrid.hide();
							break;		
					default:
							break;
	      			}
          		}
          	},
			hide:function()	{
				detailForm.show();
			}
          } 
    });
    /**
     * 상세 조회(Detail Form Panel)
     * @type 
     */
    var detailForm = Unilite.createForm('detailForm', {
//      region:'south',
//    	weight:-100,
//    	height:400,
//    	split:true,
    	hidden: true,
    	masterGrid: masterGrid,
        autoScroll:true,
        border: false,
        padding: '0 0 0 1',       
        uniOpt:{
        	store : directMasterStore
        },
	    //for Form      
	    layout: {
	    	type: 'uniTable',
	    	columns: 1,
	    	tableAttrs:{cellpadding:5},
	    	tdAttrs: {valign:'top'}
	    },
	    defaultType: 'fieldset',
//	    masterGrid: masterGrid,
	    defineEvent: function(){
	    	var me = this;	        
	        me.getField('CUSTOM_NAME').on ('blur', function( field, blurEvent, eOpts )	{
				//var frm = Ext.getCmp('detailForm');
				if(me.getValue('CUSTOM_FULL_NAME') == "")	
					me.setValue('CUSTOM_FULL_NAME',this.getValue());
			} );
		},
	    items : [{
	    	title: '기본정보',
        	defaultType: 'uniTextfield',
        	flex : 1,
        	layout: {
	            type: 'uniTable',
	            tableAttrs: { style: { width: '100%' } }, 
	            columns: 3
			},    
			items :[{
				fieldLabel: '코드',
				name: 'CUSTOM_CODE',
				allowBlank: false,
				readOnly:true
			},{
				fieldLabel: '법인/개인', 
				name: 'BUSINESS_TYPE', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B016'
			},{
				fieldLabel: '구분',
				name: 'CUSTOM_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B015' ,
				allowBlank: false
			},{
				fieldLabel: '거래처(약명)',
				name: 'CUSTOM_NAME'  ,
				allowBlank: false,
				listenersX:{blur : function(){
					var frm = Ext.getCmp('detailForm');
					if(frm.getValue('CUSTOM_FULL_NAME') == "")	
					frm.setValue('CUSTOM_FULL_NAME',this.getValue());
				}}
			},{
                fieldLabel: '결제방법',
                name: 'SET_METH', 
                xtype : 'uniCombobox',
                comboType:'AU',
                comboCode:'B038'
            },{
				fieldLabel: '업태',
				name: 'COMP_TYPE'
			},{
				fieldLabel: '거래처(약명1)',
				name: 'CUSTOM_NAME1' 
			},{
				fieldLabel: '대표자명',
				name: 'TOP_NAME'
			},{
				fieldLabel: '업종',
				name: 'COMP_CLASS'
			},{
				fieldLabel: '거래처(약명2)', 
				name: 'CUSTOM_NAME2' 
			},{
                fieldLabel: '국가코드',
                name: 'NATION_CODE',
                xtype : 'uniCombobox',
                comboType:'AU',
                comboCode:'B012'
            },{
				fieldLabel: '고객분류',
				name: 'AGENT_TYPE',
				xtype : 'uniCombobox',
				allowBlank: false,
				comboType:'AU',
				comboCode:'B055'
			},{
				fieldLabel: '거래처명(전명)', 
				name: 'CUSTOM_FULL_NAME',
				allowBlank: false
			},{
                fieldLabel: '기준화폐',
                name: 'MONEY_UNIT',
                xtype : 'uniCombobox',
                comboType:'AU',
                comboCode:'B004',
                colspan:2
            },{
				fieldLabel: '거래시작일',
				name: 'START_DATE' ,
				xtype : 'uniDatefield', 
				allowBlank:false
			},{
				fieldLabel: '거래중단일',  
				name: 'STOP_DATE',
				xtype : 'uniDatefield'
			},{
				fieldLabel: '사용여부', 
				name: 'USE_YN',
				xtype: 'uniRadiogroup',
				width: 230, 
				comboType:'AU',
				comboCode:'B010', 
				value:'Y' ,
				allowBlank: false
			},{
                fieldLabel: '전화번호',
                name: 'TELEPHON'
            },{
                fieldLabel: 'FAX번호',
                name: 'FAX_NUM',
                colspan:2
            },      
            /*{ 
                fieldLabel:'계좌번호',
                name :'BANKBOOK_NUM_EXPOS',
                readOnly:true,
                focusable:false,
                listeners:{
                    afterrender:function(field) {
                        field.getEl().on('dblclick', field.onDblclick);
                    }
                },
                onDblclick:function(event, elm) {
                    detailForm.openCryptBankAccntPopup();
                }
            },*/
            {
                fieldLabel: '계좌명', 
                name: 'BANK_NAME',
                xtype: 'uniTextfield'
            },
            {
                fieldLabel: '계좌번호', 
                name: 'BANKBOOK_NUM',
                xtype: 'uniTextfield',
                maxLength:50
            },
            {
                fieldLabel: '예금주',
                name: 'BANKBOOK_NAME'
            },{
                fieldLabel: '비고', 
                name: 'REMARK',
                xtype:'textarea',
                width:740,
                height:80,
                colspan:3
            }]
	    }],
		listeners:{
			hide:function()	{
					masterGrid.show();
					if(panelSearch.getCollapsed()){		//panelSearch가 닫혀 있으면..
						panelResult.show();
					}
				}

   		}
		
    });
    Unilite.Main({
    	id  : 'bcm100ukrvApp',
		borderItems : [
			panelSearch,
			panelResult,
			{	region:'center',
				//layout : 'border',
				title:'거래처정보',
				layout : {type:'vbox', align:'stretch'},
				flex:1,
				autoScroll:true,
				tools: [
					{
						type: 'hum-grid',					            
			            handler: function () {
			            	detailForm.hide();
			                //masterGrid.show();
			            	//panelResult.show();
			            }
					},{
			
						type: 'hum-photo',					            
			            handler: function () {
			            	/*
			            	var edit = masterGrid.findPlugin('cellediting');
							if(edit && edit.editing)	{
								setTimeout("edit.completeEdit()", 1000);
							}
							*/
			                masterGrid.hide();
			                panelResult.hide();
			                //detailForm.show();
			            }
					}
				],
				items:[					
					masterGrid, 
					detailForm					
				]
			}
		],		
		autoButtonControl : false,
		fnInitBinding : function(params) {
			if(params && params.CUSTOM_CODE ) {
				panelSearch.setValue('CUSTOM_CODE',params.CUSTOM_CODE);
				panelSearch.setValue('COMP_CODE',params.COMP_CODE);
				masterGrid.getStore().loadStoreRecords();
			}
			UniAppManager.setToolbarButtons(['reset','newData','detail'],true);
            UniAppManager.app.fnInitInputFields();
		},
		
		onSaveAsExcelButtonDown: function() {
			var masterGrid = Ext.getCmp('bcm100ukrvGrid');
			 masterGrid.downloadExcelXml();
		},
		
		onQueryButtonDown : function()	{
//			detailForm.clearForm ();
			directMasterStore.loadStoreRecords();
		},
		onNewDataButtonDown : function()	{
			masterGrid.createRow();
//			openDetailWindow(null, true);	
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},		
		onSaveDataButtonDown: function (config) {
			
			directMasterStore.saveStore(config);
							
		},
		onDeleteDataButtonDown : function()	{
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			detailForm.clearForm();
            UniAppManager.app.fnInitInputFields();  
//			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		rejectSave: function()	{
			directMasterStore.rejectChanges();
			UniAppManager.setToolbarButtons('save',false);
		}, 	
		confirmSaveData: function()	{
            	if(directMasterStore.isDirty())	{
					if(confirm(Msg.sMB061))	{
						this.onSaveDataButtonDown();
					} else {
						this.rejectSave();
					}
				}
				
            },
        fnInitInputFields: function(){
            panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
            panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
            
            if(!Ext.isEmpty(UserInfo.deptCode)){
                if(UserInfo.deptCode == '01'){
                    panelSearch.getField('DEPT_CODE').setReadOnly(false);
                    panelResult.getField('DEPT_CODE').setReadOnly(false);
                }else{
                    panelSearch.getField('DEPT_CODE').setReadOnly(true);
                    panelResult.getField('DEPT_CODE').setReadOnly(true);
                }
            }else{
                panelSearch.getField('DEPT_CODE').setReadOnly(true);
                panelResult.getField('DEPT_CODE').setReadOnly(true);
            }
        }
	});	// Main
	
	Unilite.createValidator('validator01', {
		store : directMasterStore,
		grid: masterGrid,
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, oldValue, record, ePanel, editor, e) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
		/*	if(fieldName=='CUSTOM_CODE')	{
				Ext.getBody().mask();
				var param = {
					'CUSTOM_CODE':newValue
				}
				var currentRecord = record;
				s_bcm100ukrvService_KOCIS.chkPK(param, function(provider, response)	{
					Ext.getBody().unmask();
					console.log('provider', provider);
					if(!Ext.isEmpty(provider) && provider['CNT'] > 0){
						alert(Msg.fSbMsgZ0049);
						currentRecord.set('CUSTOM_CODE','');
					}			
				});
			} else if( fieldName == 'CUSTOM_NAME' ) {		// 거래처(약명)
				if(newValue == '')	{
					rv = Msg.sMB083;
				}else {
					if(record.get('CUSTOM_FULL_NAME') == '')	{
					 	record.set('CUSTOM_FULL_NAME',newValue);		
					}
				}
			}*/
				
			return rv;
		}
	}); // validator
	
	
}; // main


</script>


