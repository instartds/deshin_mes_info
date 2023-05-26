<%@page language="java" contentType="text/html; charset=utf-8"%>
	Unilite.defineModel('gac120ukrvModel', {
	    fields: [
	    			{name: 'COMP_CODE',					text: '법인코드',			type: 'string'},
					{name: 'DIV_CODE',					text: '사업장',				type: 'string',comboType:'BOR120'},
					{name: 'ACCIDENT_NUM',				text: '사고번호',			type: 'string'}	,			
					{name: 'ACCIDENT_SEQ',				text: '순번',				type: 'int'}	,
					{name: 'GUBUN',						text: '구분',				type: 'string',comboType:'AU', comboCode:'GA17'},
					{name: 'VEHICLE_DAMAGE_DESC',		text: '자차피해내용',		type: 'string'},
					{name: 'OTHER_DAMAGE_TYPE',			text: '상대방피해구분',		type: 'string',comboType:'AU', comboCode:'GA18'},
					{name: 'OTHER_DAMAGE',				text: '상대방차량/피해물',	type: 'string'},
					{name: 'OTHER_VEHICLE_OWNER',		text: '소유자',				type: 'string'}, 
					{name: 'OTHER_PHONE',				text: '연락처',				type: 'string'},	
					{name: 'OTHER_DAMAGE_DESC',			text: '피해내용',			type: 'string'},
					{name: 'OTHER_INSURANCE',			text: '보험사명',			type: 'string'},
					{name: 'OTHER_INSURE_CLAIM_NUM',	text: '접수번호',			type: 'string'},
					{name: 'OTHER_REPAIR_SHOP',			text: '정비공장',			type: 'string'}	,			
					{name: 'OTHER_REPAIR_SHOP_PHOME',	text: '연락처',				type: 'string'}	,		
						
					{name: 'OTHER_VEHICLE_TYPE',		text: '상대방차량구분',		type: 'string',comboType:'AU', comboCode:'GA19'}	,	
					{name: 'OTHER_VEHICLE_USAGE',		text: '상대방차량용도',		type: 'string',comboType:'AU', comboCode:'GA20'}	,
					{name: 'OTHER_VEHICLE_KIND',		text: '상대방차종',			type: 'string'}	,	
					{name: 'OTHER_VEHICLE_YEAR',		text: '상대방차량연식',		type: 'string'}	,
					{name: 'OTHER_ADDR',				text: '상대방주소',			type: 'string'}	,	
					{name: 'OTHER_DAMAGE_DEGREE',		text: '상대방피해정도',		type: 'string'}	,		
					{name: 'OTHER_INSUR_EMP',			text: '상대방보험사담당자',	type: 'string'}	,	
					{name: 'OTHER_INSUR_PHONE',			text: '상대방보험사담당자연락처',	type: 'string'}	,
					{name: 'OTHER_FAULT',				text: '상대방과실율',		type: 'uniPercent'}	,	
					{name: 'OTHER_IN_DATE',				text: '상대방차량입고일',	type: 'string'}	,
					{name: 'OTHER_OUT_DATE',			text: '상대방차량출고일',	type: 'string'}	,	
					
					{name: 'VEHICLE_DAMAGE_DESC',		text: '자차피해내용',		type: 'string'}	,	
					{name: 'VEHICLE_DAMAGE',			text: '자차피해정도',		type: 'string'}	,	
					{name: 'VEHICLE_OLD_DAMAGE',		text: '자차구상처',			type: 'string',comboType:'AU', comboCode:'GA24'}	,	
					{name: 'SELF_REGIST_NUM',			text: '자차접수번호',		type: 'string'}	,	
					{name: 'SELF_FAULT',				text: '자차과실율',			type: 'uniPercent'}	,	
					{name: 'SELF_MECHANIC',				text: '자차담당자',			type: 'string'}	,	
					{name: 'SELF_MECHANIC_PHONE',		text: '자차담당자연락처',	type: 'string'}	,	
					{name: 'SELF_REPAIR_SHOP',			text: '자차정비공장',		type: 'string'}	,	
					{name: 'SELF_REPAIR_SHOP_PHONE',	text: '자차정비공장연락처',	type: 'string'}	,	
					{name: 'SELF_IN_DATE',				text: '자차입고일',			type: 'string'}	,	
					{name: 'SELF_OUT_DATE',				text: '자차출고일',			type: 'string'}	,	
					{name: 'SELF_ESTIMATE_DATE',		text: '자차견적일',			type: 'string'}	,	
					{name: 'SELF_ESTIMATE_PRICE',		text: '자차견적금액',		type: 'uniPrice', defaultValue:0}	,	
					{name: 'SELF_PAYMENT',				text: '자차입금금액',		type: 'uniPrice', defaultValue:0}	,	
					{name: 'SELF_DRIVER_PAYMENT',		text: '자차자기부담',		type: 'uniPrice', defaultValue:0}	,	
					{name: 'SELF_COMPANY_PAYMENT',		text: '자차회사부담',		type: 'uniPrice', defaultValue:0}	,	
					{name: 'SELF_DEPOSIT_DATE',			text: '자차입금일',			type: 'string'}	,	
					{name: 'SELF_DEPOSIT_METHOD',		text: '자차입금방법',		type: 'string',comboType:'AU', comboCode:'GA21'}	,	
					{name: 'SELF_COMPROMISE_PERSON',	text: '자차합의자',			type: 'string',comboType:'AU', comboCode:'GA22'}	,	
					{name: 'SELF_COMPROMISE_METHOD',	text: '자차처리방법',		type: 'string',comboType:'AU', comboCode:'GA23'}	,	
					{name: 'SELF_REMARK',				text: '자차기타',			type: 'string'}	,	
					
					{name: 'CLAIM_DATE',				text: '접보일',				type: 'uniDate'}	,
					{name: 'CLAIM_NUM',					text: '사고번호(접보)',		type: 'string'}	,
					{name: 'TOTAL_EXPECT_AMOUNT',		text: '총추산액',			type: 'uniPrice', defaultValue:0}	,
					{name: 'TOTAL_PAYMENT',				text: '총지급액',			type: 'uniPrice', defaultValue:0}	,
					{name: 'ESTI_AMOUNT',				text: '견적금액',			type: 'uniPrice', defaultValue:0}	,
					{name: 'EXPECT_AMOUNT',				text: '예상금액',			type: 'uniPrice', defaultValue:0}	,
					{name: 'DIRECT_LOSS',				text: '직접손해',			type: 'uniPrice', defaultValue:0}	,
					{name: 'INDIRECT_LOSS',				text: '간접손해',			type: 'uniPrice', defaultValue:0}	,
					{name: 'INSUREANCE_PAYMENT',		text: '보험부담',			type: 'uniPrice', defaultValue:0}	,
					{name: 'COMPANY_PAYMENT',			text: '회사부담',			type: 'uniPrice', defaultValue:0}	,
					{name: 'PERSON_PAYMENT',			text: '자기부담',			type: 'uniPrice', defaultValue:0}	,
					{name: 'COMPLATE_YN',				text: '완료여부',			type: 'string'}	,
					{name: 'COMPLATE_DATE',				text: '완료일',				type: 'uniDate'}	,
	
					{name: 'REMARK',					text: '비고',				type: 'string'}	
					
			]
	});	

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */		
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read   : 'gac120ukrvService.selectList',
            update : 'gac120ukrvService.update',
            create : 'gac120ukrvService.insert',
            destroy: 'gac120ukrvService.delete',
			syncAll: 'gac120ukrvService.saveAll'
		}
	});
	var propertyDamageStore = Unilite.createStore('gac120ukrvMasterStore',{
			model: 'gac120ukrvModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
            proxy: directProxy
			,loadStoreRecords : function(param)	{
				param['DIV_CODE']= panelSearch.getValue('DIV_CODE');			
				console.log( param );
				var me = this;
				this.load({
					params : param
				});
			},
			saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();				
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect();					
				}else {
					var grid = Ext.getCmp('gac120ukrGrid');
                	grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			listeners:{
				update:function(store, record, operation, modifiedFieldNames, eOpts ){
					Ext.getCmp('gac120ukrvPropertyDamage').down('#propertyDamageForm').setActiveRecord(record);
				}
			}
			
            
		});	
		var propertyDamageGrid = Unilite.createGrid('gac120ukrGrid', {
		flex:.5,
        store : propertyDamageStore, 
        uniOpt:{	expandLastColumn: false,
        			useRowNumberer: false,
                    useMultipleSorting: false,
                    onLoadSelectFirst: false
        },	
        columns:  [     
        			{ dataIndex: 'ACCIDENT_SEQ'				,width: 80 }, 
               		{ dataIndex: 'GUBUN'					,width: 80 }, 
					{ dataIndex: 'VEHICLE_DAMAGE_DESC' 		,width: 100 }, 
					{ dataIndex: 'OTHER_DAMAGE_TYPE'		,width: 100 },
					
					{ dataIndex: 'OTHER_DAMAGE'				,width: 130 },
					{ dataIndex: 'OTHER_VEHICLE_OWNER'		,width: 100 },
					{ dataIndex: 'OTHER_PHONE'				,width: 80 },
					
					{ dataIndex: 'OTHER_DAMAGE_DESC'		,width: 100 },
					{ dataIndex: 'OTHER_INSURANCE'			,width: 100 },
					{ dataIndex: 'OTHER_INSURE_CLAIM_NUM'	,width: 100 },
					
					{ dataIndex: 'OTHER_REPAIR_SHOP'		,width: 100 },
					{ dataIndex: 'OTHER_REPAIR_SHOP_PHOME'	,width: 100 },
					{ dataIndex: 'REMARK'	,flex:1		 }
				  ],
		listeners: {
            selectionchange: function(model, selected ){ 
            	Ext.getCmp('gac120ukrvPropertyDamage').down('#propertyDamageForm').setActiveRecord(selected[0]);
            }
        }
        
	});
var propertyDamage =	 {		         
	        title: '대물내역',	
	        id:'gac120ukrvPropertyDamage',
	        itemId: 'propertyDamage',
			layout:{type:'vbox', align:'stretch'},
			xtype:'container',	
			padding:0,
			bodyCls: 'human-panel-form-background',
			disabled: false,
	        items:[ propertyDamageGrid,
	        	{
	        		xtype:'uniDetailForm',
	        		defaultType:'uniFieldset',
	        		itemId: 'propertyDamageForm',
	        		disabled: false,
	        		autoScroll:true,
	        		bodyCls: 'human-panel-form-background',			        
	        		layout: {type:'uniTable', columns:'2', tdAttrs:{valign:'top'}},
	        		margin:'10 10 0 10',
	        		padding:'0',
	        		width:1040,
	        		defaults: {
	        			margin:'10 0 0 0',
	        			padding:'0 0 5 0',
	        			autoScroll:false,
	        			defaults: {
	        					width:230,
	        					labelWidth:80
	        			}
	        		},
	        		height:500,
	        		items: [{
	        			defaultType: 'uniTextfield',
	        			colspan:2,
	        			padding:'5 5 0 0',
	        			items:[
		            		{
		            	  	 	fieldLabel: '구분',
							 	name:'GUBUN',
							 	xtype: 'uniCombobox',
							 	comboType:'AU',						 	
							 	comboCode:'GA17'
							}]
		        		},{
		        		title:'자차',
	        			defaultType: 'uniTextfield',
	        			layout: {type:'uniTable', columns:'2'},
	        			items:[
		        		 	{
		            	  	 	fieldLabel: '피해내용',
							 	name:'VEHICLE_DAMAGE_DESC'
							},{
		            	  	 	fieldLabel: '피해정도',
							 	name:'VEHICLE_DAMAGE'
							},{
		            	  	 	fieldLabel: '구상처',
							 	name:'VEHICLE_OLD_DAMAGE',
							 	xtype: 'uniCombobox',
							 	comboType:'AU',						 	
							 	comboCode:'GA24'
							},{
		            	  	 	fieldLabel: '접수번호',
							 	name:'SELF_REGIST_NUM'
							},{
		            	  	 	fieldLabel: '과실율',
							 	name:'SELF_FAULT',
							 	xtype:'uniNumberfield',
							 	suffixTpl:'&nbsp;%'
							},{
		            	  	 	fieldLabel: '담당자',
							 	name:'SELF_MECHANIC'
							},{
		            	  	 	fieldLabel: '담당자연락처',
							 	name:'SELF_MECHANIC_PHONE'
							},{
		            	  	 	fieldLabel: '정비공장',
							 	name:'SELF_REPAIR_SHOP'
							},{
		            	  	 	fieldLabel: '정비연락처',
							 	name:'SELF_REPAIR_SHOP_PHONE'
							},{
		            	  	 	fieldLabel: '입고일',
							 	name:'SELF_IN_DATE'
							},{
		            	  	 	fieldLabel: '출고일',
							 	name:'SELF_OUT_DATE'
							},{
		            	  	 	fieldLabel: '견적일',
							 	name:'SELF_ESTIMATE_DATE'
							},{
		            	  	 	fieldLabel: '견적금액',
							 	name:'SELF_ESTIMATE_PRICE',
							 	xtype:'uniNumberfield'
							},{
		            	  	 	fieldLabel: '입금금액',
							 	name:'SELF_PAYMENT',
							 	xtype:'uniNumberfield'
							},{
		            	  	 	fieldLabel: '자기부담',
							 	name:'SELF_DRIVER_PAYMENT',
							 	xtype:'uniNumberfield'
							},{
		            	  	 	fieldLabel: '회사부담',
							 	name:'SELF_COMPANY_PAYMENT'	,
							 	xtype:'uniNumberfield'					 	
							},{
		            	  	 	fieldLabel: '입금일',
							 	name:'SELF_DEPOSIT_DATE'
							},{
		            	  	 	fieldLabel: '입금방법',
							 	name:'SELF_DEPOSIT_METHOD',
							 	xtype: 'uniCombobox',
							 	comboType:'AU',						 	
							 	comboCode:'GA21'
							},{
		            	  	 	fieldLabel: '합의자',
							 	name:'SELF_COMPROMISE_PERSON',
							 	xtype: 'uniCombobox',
							 	comboType:'AU',						 	
							 	comboCode:'GA22'
							},{
		            	  	 	fieldLabel: '처리방법',
							 	name:'SELF_COMPROMISE_METHOD',
							 	xtype: 'uniCombobox',
							 	comboType:'AU',						 	
							 	comboCode:'GA23'
							},{
		            	  	 	fieldLabel: '기타',
							 	name:'SELF_REMARK'
							}]
		        		},{
		        		title:'상대방',
	        			defaultType: 'uniTextfield',
	        			layout: {type:'uniTable', columns:'2'},
	        			items:[{
		            	  	 	fieldLabel: '피해구분',
							 	name:'OTHER_DAMAGE_TYPE',
							 	xtype: 'uniCombobox',
							 	comboType:'AU',						 	
							 	comboCode:'GA18'
							},{
		            	  	 	fieldLabel: '차량/피해물',
							 	name:'OTHER_DAMAGE'
							},{
		            	  	 	fieldLabel: '차량구분',
							 	name:'OTHER_VEHICLE_TYPE',
							 	xtype: 'uniCombobox',
							 	comboType:'AU',						 	
							 	comboCode:'GA19'
							},{
		            	  	 	fieldLabel: '차량용도',
							 	name:'OTHER_VEHICLE_USAGE',
							 	xtype: 'uniCombobox',
							 	comboType:'AU',						 	
							 	comboCode:'GA20'
								 	
							},{
		            	  	 	fieldLabel: '차종',
							 	name:'OTHER_VEHICLE_KIND'
							},{
		            	  	 	fieldLabel: '차량연식',
							 	name:'OTHER_VEHICLE_YEAR'
							},{
		            	  	 	fieldLabel: '차량소유자',
							 	name:'OTHER_VEHICLE_OWNER'
							},{
		            	  	 	fieldLabel: '연락처',
							 	name:'OTHER_PHONE'
							},{
		            	  	 	fieldLabel: '주소',
							 	name:'OTHER_ADDR'
							},{
		            	  	 	fieldLabel: '피해내용',
							 	name:'OTHER_DAMAGE_DESC'
							},{
		            	  	 	fieldLabel: '피해정도',
							 	name:'OTHER_DAMAGE_DEGREE'
							},{
		            	  	 	fieldLabel: '보험사명',
							 	name:'OTHER_INSURANCE'
							},{
		            	  	 	fieldLabel: '보험사담당자',
							 	name:'OTHER_INSUR_EMP'
							},{
		            	  	 	fieldLabel: '담당연락처',
							 	name:'OTHER_INSUR_PHONE'
							},{
		            	  	 	fieldLabel: '접수번호',
							 	name:'OTHER_INSURE_CLAIM_NUM'								 	
							},{
		            	  	 	fieldLabel: '정비공장',
							 	name:'OTHER_REPAIR_SHOP'
							},{
		            	  	 	fieldLabel: '정비연락처',
							 	name:'OTHER_REPAIR_SHOP_PHOME'
							},{
		            	  	 	fieldLabel: '과실율',
							 	name:'OTHER_FAULT',
							 	xtype:'uniNumberfield',
							 	suffixTpl:'&nbsp;%'
							},{
		            	  	 	fieldLabel: '차량입고일',
							 	name:'OTHER_IN_DATE'
							},{
		            	  	 	fieldLabel: '차량출고일',
							 	name:'OTHER_OUT_DATE'
							},{
		            	  	 	fieldLabel: '기타사항',
							 	name:'OTHER_REMARK'
							}]
		        		},{
		        		title:'접보',
	        			defaultType: 'uniTextfield',
	        			layout: {type:'uniTable', columns:'4'},
	        			colspan:2,
	        			items:[{
		            	  	 	fieldLabel: '접보일',
							 	name:'CLAIM_DATE',
							 	xtype:'uniDatefield'
							},{
		            	  	 	fieldLabel: '사고번호',
							 	name:'CLAIM_NUM'
							},{
		            	  	 	fieldLabel: '완료',
							 	xtype: 'uniCombobox',
							 	comboType:'AU',						 	
							 	comboCode:'A020',		            	  	 	
							 	name:'COMPLATE_YN',
							 	labelWidth:85,
							 	width:235
							},{
		            	  	 	fieldLabel: '총추산액',
							 	name:'TOTAL_EXPECT_AMOUNT',
							 	xtype:'uniNumberfield'
							},{
		            	  	 	fieldLabel: '견적금액',
							 	name:'ESTI_AMOUNT',
							 	xtype:'uniNumberfield'
							},{
		            	  	 	fieldLabel: '예상금액',
							 	name:'EXPECT_AMOUNT',
							 	xtype:'uniNumberfield'
							},{
		            	  	 	fieldLabel: '총지급액',
							 	name:'TOTAL_PAYMENT',
							 	xtype:'uniNumberfield',
							 	labelWidth:85,
							 	width:235
							},{
		            	  	 	fieldLabel: '직접손해',
							 	name:'DIRECT_LOSS',
							 	xtype:'uniNumberfield'
							},{
		            	  	 	fieldLabel: '간접손해',
							 	name:'INDIRECT_LOSS',
							 	xtype:'uniNumberfield'
							},{
		            	  	 	fieldLabel: '보험부담',
							 	name:'INSUREANCE_PAYMENT',
							 	xtype:'uniNumberfield'
							},{
		            	  	 	fieldLabel: '회사부담',
							 	name:'COMPANY_PAYMENT',
							 	xtype:'uniNumberfield',
							 	labelWidth:85,
							 	width:235
							},{
		            	  	 	fieldLabel: '자기부담',
							 	name:'PERSON_PAYMENT',
							 	xtype:'uniNumberfield'
							}]
		        		}
						]
	    			}
	    			
		],
		loadData:function(param)	{
			var me = this;
			console.log("propertyDamageStore:",param);
			propertyDamageStore.loadStoreRecords(param)
			me.down('#propertyDamageForm').clearForm();
		},
		saveData:function()	{
			var me = this;
			propertyDamageStore.saveStore();
		},
		newData:function()	{
			var me = this;
			var record = masterGrid.getSelectedRecord();
			if(record)	{
				propertyDamageGrid.createRow({
					'DIV_CODE' : panelSearch.getValue('DIV_CODE'),
					'ACCIDENT_NUM': record.get('ACCIDENT_NUM'),
					'ACCIDENT_SEQ': Ext.isEmpty(propertyDamageStore.max('ACCIDENT_SEQ')) ? 1 : propertyDamageStore.max('ACCIDENT_SEQ')+1
				})
			}else {
				alert("사고정보를 선택하세요.");
			}
		},
		deleteData:function()	{
			propertyDamageGrid.deleteSelectedRow();	
		},
		rejectChanges:function()	{
			propertyDamageStore.rejectChanges()
		}				        	
	};