<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx410ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 				<!-- 사업장 -->   
	<t:ExtComboStore comboType="BOR120"  comboCode="BILL" storeId="billDivCode" />	<!-- 신고사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="T001" /> 	<!-- 무역구분 -->      
	<t:ExtComboStore comboType="AU" comboCode="T071" /> 	<!-- 진행구분(수입) -->   
	<t:ExtComboStore comboType="AU" comboCode="A162" /> 	<!-- 건물상태 -->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >
var outDivCode = UserInfo.divCode;

function appMain() {
	var baseInfo = {
		gsBillDivCode   : '${gsBillDivCode}'
	}
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'atx410ukrService.selectMaster',
			update: 'atx410ukrService.updateDetail',
			create: 'atx410ukrService.insertDetail',
			destroy: 'atx410ukrService.deleteDetail',
			syncAll: 'atx410ukrService.saveAll'
		}
	});
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Atx410ukrModel', {
	    fields: [
	    	{name: 'SEQ'				,text: 'SEQ' 				,type: 'string'},
	    	{name: 'BILL_DIV_CODE'		,text: '신고사업장' 			,type: 'string', allowBlank: false, comboType: 'BOR120', comboCode: 'BILL'},
	    	{name: 'BUILD_CODE'			,text: '부동산코드' 			,type: 'string'},
	    	{name: 'BUILD_NAME'			,text: '부동산명' 				,type: 'string', allowBlank: false},
	    	{name: 'BUILD_STATE'		,text: '건물상태' 				,type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'A162'},
	    	{name: 'DONG'				,text: '동' 					,type: 'string'},
	    	{name: 'UP_UNDER'			,text: '지하/지상' 			,type: 'string'},
	    	{name: 'UP_FLOOR'			,text: '층' 					,type: 'string', allowBlank: false},
	    	{name: 'HOUSE'				,text: '호' 					,type: 'string'},
	    	{name: 'HOUSE_CNT'    		,text: '호실수' 				,type: 'uniQty'},
	    	{name: 'HIRE_CUST_CD'		,text: '임차인' 				,type: 'string', allowBlank: false},
	    	{name: 'HIRE_CUST_NM'		,text: '임차인명' 				,type: 'string'},
	    	{name: 'AREA' 				,text: '면적' 				,type: 'string'},
	    	{name: 'USE_REMARK' 		,text: '임대용도' 				,type: 'string'},
	    	{name: 'START_DATE' 		,text: '임대시작일' 			,type: 'uniDate'},
	    	{name: 'END_DATE' 			,text: '임대종료일' 			,type: 'uniDate'},
	    	{name: 'UPDATE_DATE' 		,text: '갱신일' 				,type: 'uniDate'},
	    	{name: 'GUARANTY' 			,text: '보증금' 				,type: 'uniPrice'},
	    	{name: 'MONTHLY_RENT' 		,text: '월세' 				,type: 'uniPrice'},
	    	{name: 'MANAGE_MONEY' 		,text: '관리비' 				,type: 'uniPrice'},
	    	{name: 'REMARK' 	    	,text: '비고' 				,type: 'string'},
	    	{name: 'UPDATE_DB_USER'		,text: 'UPDATE_DB_USER' 	,type: 'string'},
	    	{name: 'UPDATE_DB_TIME'		,text: 'UPDATE_DB_TIME' 	,type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var MasterStore = Unilite.createStore('atx410ukrMasterStore',{
			model: 'Atx410ukrModel',
			uniOpt : {
            	isMaster:	true,			// 상위 버튼 연결 
            	editable:	true,			// 수정 모드 사용 
            	deletable:	true,			// 삭제 가능 여부 
	            useNavi :	false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			},
			saveStore : function(config)	{	
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
            	var toUpdate = this.getUpdatedRecords();
            	console.log("toUpdate",toUpdate);

            	var rv = true;
       	
            	if(inValidRecs.length == 0 )	{										
					config = {
						success: function(batch, option) {								
							panelResult.resetDirtyStatus();
							UniAppManager.setToolbarButtons('save', false);			
						 } 
					};					
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
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
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
		    items: [
   	        	//CUST 팝업 오류로 임시로 BCM100t [RETURN_CODE]컬럼 추가(추후 확인)
	        	Unilite.popup('CUST',{
		        fieldLabel: '임차인',
				allowBlank:true,
				autoPopup:false,
				validateBlank:false,		        
			    valueFieldName:'HIRE_CUSTOM_CODE',
			    textFieldName:'HIRE_CUSTOM_NAME',
	        	listeners: {
							onValueFieldChange:function( elm, newValue, oldValue) {						
								panelResult.setValue('HIRE_CUSTOM_CODE', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('HIRE_CUSTOM_NAME', '');
									panelSearch.setValue('HIRE_CUSTOM_NAME', '');
								}
							},
							onTextFieldChange:function( elm, newValue, oldValue) {
								panelResult.setValue('HIRE_CUSTOM_NAME', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('HIRE_CUSTOM_CODE', '');
									panelSearch.setValue('HIRE_CUSTOM_CODE', '');
								}
							}
				}		        
		    }),{
				fieldLabel: '신고사업장',
				name:'BILL_DIV_CODE',	
				xtype: 'uniCombobox',
				comboType:'BOR120' ,
				comboCode	: 'BILL',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('BILL_DIV_CODE', newValue);
					}
				} 
			}]
		},{
			title: '추가정보',	
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
		    	fieldLabel: '건물상태',
				name: '',
				xtype: 'checkboxgroup', 
				width: 300, 
				items: [{
		        	boxLabel: '전체',
		        	name: 'BUILD_STATE0',
		        	inputValue: '0',
		        	uncheckedValue: 'N',
		        	checked: true
		        },
				{
		        	boxLabel: '입실',
		        	name: 'BUILD_STATE1',
		        	inputValue: '1'		        
		        },
				{
		        	boxLabel: '공실',
		        	name: 'BUILD_STATE2',
		        	inputValue: '2'		        
		        }]
			},{
		    	fieldLabel: ' ',
				name: 'BUILD_STATE',
				xtype: 'checkboxgroup', 
				width: 230, 
				items: [{
		        	boxLabel: '연장',
		        	name: 'BUILD_STATE3',
		        	inputValue: '3'
		        },
				{
		        	boxLabel: '퇴실',
		        	name: 'BUILD_STATE4',
		        	inputValue: '4'		        
		        }]
			}]
		}],
		setAllFieldsReadOnly: function(b) { 
		    var r= true
		    if(b) {
		    	var invalid = this.getForm().getFields().filterBy(function(field) {
		        	return !field.validate();
		        });                      
		        if(invalid.length > 0) {
		     		r=false;
		         	var labelText = ''
		     		if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
		          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
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
		    	//this.unmask();
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
		}
	});

	var panelResult = Unilite.createSearchForm('panelResultForm', {		
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    items :[//CUST 팝업 오류로 임시로 BCM100t [RETURN_CODE]컬럼 추가(추후 확인)
        	Unilite.popup('CUST',{
	        fieldLabel: '임차인',
			allowBlank:true,
			autoPopup:false,
			validateBlank:false,	        
		    valueFieldName:'HIRE_CUSTOM_CODE',
		    textFieldName:'HIRE_CUSTOM_NAME',
        	listeners: {
						onValueFieldChange:function( elm, newValue, oldValue) {						
							panelSearch.setValue('HIRE_CUSTOM_CODE', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('HIRE_CUSTOM_NAME', '');
								panelSearch.setValue('HIRE_CUSTOM_NAME', '');
							}
						},
						onTextFieldChange:function( elm, newValue, oldValue) {
							panelSearch.setValue('HIRE_CUSTOM_NAME', newValue);
							
							if(!Ext.isObject(oldValue)) {
								panelResult.setValue('HIRE_CUSTOM_CODE', '');
								panelSearch.setValue('HIRE_CUSTOM_CODE', '');
							}
						}
			}		        
	    }),{
			fieldLabel: '신고사업장',
			name:'BILL_DIV_CODE',	
			xtype: 'uniCombobox',
			comboType:'BOR120' ,
			comboCode	: 'BILL',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('BILL_DIV_CODE', newValue);
				}
			} 
		}],
		setAllFieldsReadOnly: function(b) { 
		    var r= true
		    if(b) {
		    	var invalid = this.getForm().getFields().filterBy(function(field) {
		        	return !field.validate();
		        });                      
		        if(invalid.length > 0) {
		     		r=false;
		         	var labelText = ''
		     		if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
		          		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
		        	} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
		          		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
		        	}
					alert(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
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
		    	//this.unmask();
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
		}
	});

    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('atx410ukrGrid', {
    	// for tab    	
        layout : 'fit',
        region:'center',
        uniOpt:{	expandLastColumn: false,
        			useRowNumberer: true,
                    useMultipleSorting: true,
                    copiedRow: true
        },
    	store: MasterStore,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [        
        	{ dataIndex: 'SEQ'					, 			width: 66, hidden: true},
            { dataIndex: 'BILL_DIV_CODE'		, 			width: 166, locked: true},
            { dataIndex: 'BUILD_CODE'			, 			width: 93, hidden: true},
            { dataIndex: 'BUILD_NAME'			, 			width: 166, locked: true},
            { dataIndex: 'BUILD_STATE'			, 			width: 80, locked: true},
            {text: '임대사항', locked: true,
          		columns: [
            		{ dataIndex: 'DONG'					, 			width: 66, locked: true},
            		{ dataIndex: 'UP_FLOOR'				, 			width: 66, locked: true},
            		{ dataIndex: 'HOUSE'				, 			width: 66, locked: true},
            		{ dataIndex: 'HOUSE_CNT'    		, 			width: 66, locked: true}
            	]
            },
			{ dataIndex: 'UP_UNDER'				, 			width: 66, hidden: true},
            { dataIndex: 'HIRE_CUST_CD'			, 			width: 100,
				editor: Unilite.popup('CUST_G', {		
			 		textFieldName: 'CUSTOM_CODE',
			 		DBtextFieldName: 'CUSTOM_CODE',
			 		extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode, POPUP_TYPE: 'GRID_CODE'},
			  		autoPopup: true,
					listeners: {'onSelected': {
							fn: function(records, type) {
								console.log('records : ', records);
								Ext.each(records, function(record,i) {
									console.log('record',record);
									if(i==0) {
										masterGrid.setCustData(record,false, masterGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setCustData(record,false, masterGrid.uniOpt.currentRecord);
									}
								}); 
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid.setCustData(null,true, masterGrid.uniOpt.currentRecord);
						}
					}
				})
		    },
            { dataIndex: 'HIRE_CUST_NM'			, 			width: 140,
				editor: Unilite.popup('CUST_G', {
			 		extParam: {SELMODEL: 'MULTI', DIV_CODE: outDivCode},
			  		autoPopup: true,
					listeners: {'onSelected': {
							fn: function(records, type) {
					    	    console.log('records : ', records);
							    Ext.each(records, function(record,i) {													                   
									if(i==0) {
										masterGrid.setCustData(record,false, masterGrid.uniOpt.currentRecord);
									} else {
										UniAppManager.app.onNewDataButtonDown();
										masterGrid.setCustData(record,false, masterGrid.uniOpt.currentRecord);
									}
								}); 
							},
							scope: this
						},
						'onClear': function(type) {
							masterGrid.setCustData(null,true, masterGrid.uniOpt.currentRecord);
						}
					}
				})
		    },
            { dataIndex: 'AREA' 				, 			width: 66},
            { dataIndex: 'USE_REMARK' 			, 			width: 200},
            {text: '임대기간',
          		columns: [
            		{ dataIndex: 'START_DATE' 			, 			width: 80},
            		{ dataIndex: 'END_DATE' 			, 			width: 80}
            	]
            },
            { dataIndex: 'UPDATE_DATE' 			, 			width: 80},
            { dataIndex: 'GUARANTY' 			, 			width: 100},
            { dataIndex: 'MONTHLY_RENT' 		, 			width: 100},
            { dataIndex: 'MANAGE_MONEY' 		, 			width: 100},
            { dataIndex: 'REMARK' 	    		, 			width: 133},
            { dataIndex: 'UPDATE_DB_USER'		, 			width: 0},
            { dataIndex: 'UPDATE_DB_TIME'		, 			width: 0},
            { dataIndex: 'COMP_CODE'			, 			width: 66, hidden: true}  		
        ],
		listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
	        	if(!e.record.phantom) {
	        		if(UniUtils.indexOf(e.field, ['BILL_DIV_CODE']))
				   	{
						return false;
      				} else {
      					return true;
      				}
	        	} else {
	        		return true;
	        	}
	        }
		},
		setCustData: function(record, dataClear, grdRecord) {	
       		if(dataClear) {
       			grdRecord.set('HIRE_CUST_CD'			, "");
       			grdRecord.set('HIRE_CUST_NM'			, "");
				
       		} else {
       			grdRecord.set('HIRE_CUST_CD'			, record['CUSTOM_CODE']);
       			grdRecord.set('HIRE_CUST_NM'			, record['CUSTOM_NAME']);
       		}
		} 
    });   
	
    var textForm = Unilite.createSearchForm('textForm', {
		region: 'south',
		title: '작성방법',
        defaultType: 'uniSearchSubPanel',
        collapseDirection: 'bottom',
        border: true,
        //공간을 너무 많이 차지하여 접을 수 있도록 설정
        collapsible: true,
        padding: '1 1 1 1',
		items: [{
			padding: '5 5 5 5',
			xtype: 'container',
			html: //'</br><b>※ 작성방법</b></br></br>'+
				  ' 1. 층을 기재하실 경우 “B”, &nbsp “숫자”, &nbsp “-”, &nbsp “,”만 입력할 수 있습니다. 그 외 문자가 들어가면 전자신고변환시 오류가 발생합니다.</br></br>'+
				  '&nbsp&nbsp&nbsp&nbsp예) 지하1층을 임대하는 경우 : B1					</br>'+
				  '&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp지상1층, 2층, 3층을 임대하는 경우 : 1-3	</br>'+
				  '&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp지하1층과 지상 1층을 임대하는 경우 : B1,&nbsp 1	</br></br>'+
				  ' 2. 그외 작성방법은 국세청 서식을 참고하여 입력합니다.</br></br>',
			style: {
				color: 'blue'				
			}
		}]
	});
	
    Unilite.Main( {
		borderItems:[{
			border: false,
			region:'center',
			layout: 'border',
			items:[
				masterGrid, textForm, panelResult
			]	
		}		
		, panelSearch
		],
		id  : 'atx410ukrApp',
		fnInitBinding : function() {
			panelSearch.setValue('BILL_DIV_CODE',baseInfo.gsBillDivCode);
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{			
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			MasterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons(['reset','newData'], true); 
		},
		onResetButtonDown: function() {		// 초기화
			this.suspendEvents();
			panelSearch.getField('HIRE_CUSTOM_CODE').focus();
			panelResult.getField('HIRE_CUSTOM_CODE').focus();
			panelSearch.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			masterGrid.reset();
			this.fnInitBinding();
			MasterStore.clearData();
			UniAppManager.setToolbarButtons(['reset','newData', 'delete', 'save'], false); 
		},
		onNewDataButtonDown: function()	{		// 행추가
			//if(containerclick(masterGrid)) {
				var compCode    	=	UserInfo.compCode;   
				var billDivCode 	=	panelSearch.getValue('BILL_DIV_CODE');
				var seq = MasterStore.max('SEQ');
	            if(!seq) seq = 1;
	            else seq += 1;
				var area	   		=	0;
				var guaranty	   	=	0;
				var monthlyRent		=	0;
				var manageMoney		=	0;
				var houseCnt     	=	1;
				
				var r = {
					COMP_CODE    	:	compCode,    
					BILL_DIV_CODE	:	billDivCode, 
					SEQ				:	seq,   
					AREA 		 	:	area,
					GUARANTY		:	guaranty,
					MONTHLY_RENT	:	monthlyRent,
					MANAGE_MONEY	:	manageMoney,
					HOUSE_CNT    	:	houseCnt	
				};
				masterGrid.createRow(r);
		},
		onDeleteDataButtonDown: function() {
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			MasterStore.saveStore();
		}
	});

};


</script>
