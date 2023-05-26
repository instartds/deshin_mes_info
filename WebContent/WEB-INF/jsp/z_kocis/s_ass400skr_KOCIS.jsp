<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_ass400skr_KOCIS"  >
	<t:ExtComboStore comboType="AU" comboCode="B004" /> <!-- 화폐단위 -->
	<t:ExtComboStore comboType="AU" comboCode="A390" /> <!-- 회계구분 -->
    <t:ExtComboStore comboType="AU" comboCode="A391" /> <!-- 원인행위 -->
    <t:ExtComboStore comboType="AU" comboCode="A112" /> <!-- 계좌구분 -->
	<t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> <!--기관-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	Unilite.defineModel('Ass400skrModel', {
	   fields:[
          {name: 'A',text: '10품종코드'            ,type: 'string'},
          {name: 'B',text: '10품종'              ,type: 'string'},
          {name: 'C',text: '계정과목코드'           ,type: 'string'},
          {name: 'D',text: '계정과목'              ,type: 'string'},
          {name: 'E',text: '자산번호'              ,type: 'string'},
          {name: 'F',text: '자산명'                ,type: 'string'},
          {name: 'G',text: '품명'                ,type: 'string'},
          {name: 'H',text: '취득사유'              ,type: 'string'},
          {name: 'I',text: '운용상태'              ,type: 'string'},
          {name: 'J',text: '분류번호'              ,type: 'string'},
          {name: 'K',text: '식별번호'              ,type: 'string'},
          {name: 'L',text: '규격코드'              ,type: 'string'},
          {name: 'M',text: '식별명칭'              ,type: 'string'},
          {name: 'N',text: '운영조직'              ,type: 'string'},
          {name: 'O',text: '운영조직코드'              ,type: 'string'},
          {name: 'P',text: '운영부서'              ,type: 'string'},
          {name: 'Q',text: '운영부서코드'              ,type: 'string'},
          {name: 'R',text: '사용위치'              ,type: 'string'},
          {name: 'S',text: '물품용도'              ,type: 'string'},
          {name: 'T',text: '취득일자'              ,type: 'uniDate'},
          {name: 'U',text: '정리일자'              ,type: 'uniDate'},
          {name: 'V',text: '취득수량'              ,type: 'uniQty'},
          {name: 'W',text: '취득금액'              ,type: 'uniPrice'},
          {name: 'X',text: '내용년수'              ,type: 'string'},
          {name: 'Y',text: '물품상태'              ,type: 'string'}
	   ]	  
	});
	  
			
	var directDetailStore = Unilite.createStore('Ass400skrdirectDetailStore',{
		model: 'Ass400skrModel',
		uniOpt: {
            isMaster: true,				// 상위 버튼 연결
            editable: false,			// 수정 모드 사용
            deletable:false,			// 삭제 가능 여부
	        useNavi : false				// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {			
                read: 's_ass400skrService_KOCIS.selectList'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params : param
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {
           	},
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}
		}
	});
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
    	width: 360,
        defaultType: 'uniSearchSubPanel',
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
			title: '기본정보', 	
	   		itemId: 'search_panel1',
	        layout: {type: 'uniTable', columns: 1},
	        defaultType: 'uniTextfield',
			items: [{
                fieldLabel: '요청일자',
                xtype: 'uniDateRangefield',  
                startFieldName: 'FR_DATE',
                endFieldName: 'TO_DATE',
                width:320,
                allowBlank:false,
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('FR_DATE',newValue);
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('TO_DATE',newValue);
                    }       
                }
			},{
                xtype: 'uniCombobox',
                fieldLabel: '품종',
                name: '',
                comboType: 'AU',
                comboCode: '',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('', newValue);
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '10품종',
                name: '',
                comboType: 'AU',
                comboCode: '',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('', newValue);
                    }
                }
            },{
                xtype: 'uniCombobox',
                fieldLabel: '기관',
                name: 'DEPT_CODE',
                store: Ext.data.StoreManager.lookup('deptKocis'),
                allowBlank:false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('DEPT_CODE', newValue);
                    }
                }
            },
            Unilite.popup('BUDG', {
                fieldLabel: '계정', 
                valueFieldName: '',
                textFieldName: '', 
                autoPopup:true,
                listeners: { 
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('', newValue);                                
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('', newValue);                
                    },
                    applyextparam: function(popup) {
                    }
                
                }
            }),
            {
            	xtype:'uniTextfield',
            	fieldLabel:'자산명',
            	name:'',
            	listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        panelResult.setValue('', newValue);
                    }
                }
            },{
                
                xtype: 'container',
                layout: {type : 'uniTable', columns : 2},
                tdAttrs: {align : 'center',width:120},
                items :[{
                    xtype: 'button',
                    text: '승인',
                    handler : function() {/*
                        if(detailForm.getValue('PAY_DRAFT_NO') == ''){
                            Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0199);
                        }else{
                            openDocDetailWin_GW("3","2",null);
                        
                        }
                    */}
                },{
                    xtype: 'button',
                    text: '반려',  
                    handler : function() {/*
                        if(detailForm.getValue('PAY_DRAFT_NO') == ''){
                            Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0199);
                        }else{
                            openDocDetailWin_GW("3","2",null);
                        
                        }
                    */}
                }]
            }
            
            
            ]	
		}]
	});	// end panelSearch
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
		items: [{
            fieldLabel: '요청일자',
            xtype: 'uniDateRangefield',  
            startFieldName: 'FR_DATE',
            endFieldName: 'TO_DATE',
            allowBlank:false,
            width:320,
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelResult.setValue('FR_DATE',newValue);
                }
            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {
                if(panelResult) {
                    panelResult.setValue('TO_DATE',newValue);
                }       
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '품종',
            name: '',
            comboType: 'AU',
            comboCode: '',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelResult.setValue('', newValue);
                }
            }
        },{
            xtype: 'uniCombobox',
            fieldLabel: '10품종',
            name: '',
            comboType: 'AU',
            comboCode: '',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelResult.setValue('', newValue);
                }
            }
        },{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            tdAttrs: {align : 'right',width:'100%'},
            items :[{
                xtype: 'button',
                text: '승인',
                width: 110, 
                handler : function() {/*
                    if(detailForm.getValue('PAY_DRAFT_NO') == ''){
                        Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0199);
                    }else{
                        openDocDetailWin_GW("3","2",null);
                    
                    }
                */}
            }]
        },{
            xtype: 'uniCombobox',
            fieldLabel: '기관',
            name: 'DEPT_CODE',
            store: Ext.data.StoreManager.lookup('deptKocis'),
            allowBlank:false,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelResult.setValue('DEPT_CODE', newValue);
                }
            }
        },
        Unilite.popup('BUDG', {
            fieldLabel: '계정', 
            valueFieldName: '',
            textFieldName: '', 
            autoPopup:true,
            listeners: { 
                onValueFieldChange: function(field, newValue){
                    panelResult.setValue('', newValue);                                
                },
                onTextFieldChange: function(field, newValue){
                    panelResult.setValue('', newValue);                
                },
                applyextparam: function(popup) {
                }
            
            }
        }),
        {
            xtype:'uniTextfield',
            fieldLabel:'자산명',
            name:'',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                    panelResult.setValue('', newValue);
                }
            }
        },{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            tdAttrs: {align : 'right',width:'100%'},
            items :[{
                xtype: 'button',
                text: '반려',
                width: 110, 
                handler : function() {/*
                    if(detailForm.getValue('PAY_DRAFT_NO') == ''){
                        Ext.Msg.alert(Msg.sMB099,Msg.fSbMsgA0199);
                    }else{
                        openDocDetailWin_GW("3","2",null);
                    
                    }
                */}
            }]
        }]
	});
	
    var detailGrid = Unilite.createGrid('Ass400skrGrid', {
    	features: [{
			id: 'detailGridSubTotal',	
			ftype: 'uniGroupingsummary',	
			showSummaryRow: false, enableGroupingMenu:false
		},{
			id: 'detailGridTotal',		
			ftype: 'uniSummary',			
			showSummaryRow: false
//            dock:'bottom'
		}],
        region: 'center',
		store: directDetailStore,
		uniOpt: {
			useMultipleSorting	: false,
    		useLiveSearch		: false,
    		onLoadSelectFirst	: false,
    		dblClickToEdit		: false,
    		useGroupSummary		: false,
			useContextMenu		: false,
			useRowNumberer		: true,
			expandLastColumn	: false,
    		filter: {
				useFilter		: true,
				autoCreate		: true
			}
        },
        selModel: Ext.create('Ext.selection.CheckboxModel', {checkOnly: true,
            listeners: {  
                select: function(grid, selectRecord, index, rowIndex, eOpts ){  

                },
                deselect:  function(grid, selectRecord, index, eOpts ){
                }
            }
        }),
        columns: [
            { dataIndex: 'A'           ,width:100},
            { dataIndex: 'B'           ,width:100},
            { dataIndex: 'C'           ,width:100},
            { dataIndex: 'D'           ,width:100},
            { dataIndex: 'E'           ,width:100},
            { dataIndex: 'F'           ,width:100},
            { dataIndex: 'G'           ,width:100},
            { dataIndex: 'H'           ,width:100},
            { dataIndex: 'I'           ,width:100},
            { dataIndex: 'J'           ,width:100},
            { dataIndex: 'K'           ,width:100},
            { dataIndex: 'L'           ,width:100},
            { dataIndex: 'M'           ,width:100},
            { dataIndex: 'N'           ,width:100},
            { dataIndex: 'O'           ,width:100},
            { dataIndex: 'P'           ,width:100},
            { dataIndex: 'Q'           ,width:100},
            { dataIndex: 'R'           ,width:100},
            { dataIndex: 'S'           ,width:100},
            { dataIndex: 'T'           ,width:100},
            { dataIndex: 'U'           ,width:100},
            { dataIndex: 'V'           ,width:100},
            { dataIndex: 'W'           ,width:100},
            { dataIndex: 'X'           ,width:100},
            { dataIndex: 'Y'           ,width:100}
        ]
    });                   
                          
    Unilite.Main( {
        borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				detailGrid, panelResult
			]
		},
			panelSearch  	
		], 
		id : 'Ass400skrApp',
		fnInitBinding : function() {
			var param= Ext.getCmp('searchForm').getValues();
			
            UniAppManager.app.fnInitInputFields(); 
		},
		onQueryButtonDown : function()	{
            if(!panelResult.getInvalidMessage()) return;   //필수체크
			directDetailStore.loadStoreRecords();
		},
		onResetButtonDown: function() {
			
			panelSearch.clearForm();
			panelResult.clearForm();
			detailGrid.reset();
			directDetailStore.clearData();
			this.fnInitInputFields();
		},
        fnInitInputFields: function(){
  /*          var activeSForm ;
            if(!UserInfo.appOption.collapseLeftSearch)  {
                activeSForm = panelSearch;
            }else {
                activeSForm = panelResult;
            }
            activeSForm.onLoadSelectText('FR_AC_DATE');*/
            
            panelSearch.setValue('FR_AC_DATE', UniDate.get('startOfMonth'));
            panelSearch.setValue('TO_AC_DATE', UniDate.get('today'));
            panelResult.setValue('FR_AC_DATE', UniDate.get('startOfMonth'));
            panelResult.setValue('TO_AC_DATE', UniDate.get('today'));
            UniAppManager.setToolbarButtons('save',false);
            UniAppManager.setToolbarButtons('reset',true);
            
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
	});
};


</script>
