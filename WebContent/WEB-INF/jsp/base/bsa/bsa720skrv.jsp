<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="bsa720skrv"  >
</t:appConfig>
<script type="text/javascript" >
function appMain() {
	var plBaseOptStore = Unilite.createStore('bsa720skrvPlBaseOptStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'법인손익'		, 'value':'1'},
			        {'text':'사업부손익'	, 'value':'2'},
			        {'text':'손익단위'		, 'value':'3'}
	    		]
		})   
	/**
	 * 수주등록 Master Form
	 * 
	 * @type
	 */     
	var detailForm = Unilite.createForm('bsa720skrvDetail', {
    	disabled :false
        , flex:1        
        , layout: {type: 'uniTable', columns: 5,tdAttrs: {valign:'top'}}
	    , items :[
	    	{ 
	    		fieldLabel: '기준일',
				xtype: 'uniDatefield',
				value: UniDate.get('today'),
				width : 200,
				allowBlank:false,
				colspan:2
			},{					
    			fieldLabel: '',
    			name:'',
    			xtype: 'uniTextfield',
    			fieldStyle: "text-align:center;", 
    			value:'201432',
    			readOnly: true,
    			colspan:3
    		},{
    			xtype: 'component',
    			autoEl: {
        			html: '<hr width="1200px">'
    			},colspan:5
			},{
				xtype: 'fieldset',
				border:false,
				rowspan:4,
				width: 140,
				height:130,
				items:[{
				border: false,
				name: '',
				html: "영업(SD)"
				}
			]},{					
    			fieldLabel: '수주건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '잔량건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '납품준수건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '납품준수율',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '출고건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '적기 출고건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '예외출고건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '출고예외 처리율',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '삼성전자 수주건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: 'P/O 무관 수주건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},{					
    			fieldLabel: '적기출고율',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '삼성전자 출하건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: 'D/O 무관 출하건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},
    			
    		{
    			xtype: 'component',
    			autoEl: {
        			html: '<hr width="1200px">'
    			},colspan:5
			},{
				xtype: 'fieldset',
				border:false,
				rowspan:4,
				width: 140,
				height:130,
				items:[{
				border: false,
				name: '',
				html: "생산(PP)"
				}
			]},{					
    			fieldLabel: '작업지시건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '긴급작지건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '생산 MRP활용율',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},{					
    			fieldLabel: '마감대상건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '마감처리건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '생산입고건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '작업지시 관리율',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '생산실적건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '생산 적기등록건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '예외생산 입고건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '생산적기 처리율',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},{					
    			fieldLabel: '생산예외 처리율',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},
    		
    		{
    			xtype: 'component',
    			autoEl: {
        			html: '<hr width="1200px">'
    			},colspan:5
			},{
				xtype: 'fieldset',
				border:false,
				rowspan:4,
				width: 140,
				height:130,
				items:[{
				border: false,
				name: '',
				html: "구매(MM)"
				}
			]},{					
    			fieldLabel: '발주건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '자동발주건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '긴급발주건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '자동발주율',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '자동발주대상건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},{					
    			fieldLabel: '자동발주 대상발주율',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '입고건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '적기 입고처리',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '무 P/O 입고건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '구매적기처리율',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},{					
    			fieldLabel: '무 P/O 입고율',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},
    		
    		{
    			xtype: 'component',
    			autoEl: {
        			html: '<hr width="1200px">'
    			},colspan:5
			},{
				xtype: 'fieldset',
				border:false,
				rowspan:4,
				width: 140,
				height:130,
				items:[{
				border: false,
				name: '',
				html: "기준정보(MD)"
				}
			]},{					
    			fieldLabel: '제품건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: 'SEC 제품건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '개발품 제품건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: 'BOM 등록율',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: 'BOM건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: 'SEC BOM 건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '무판가 제품건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: 'SEC BOM 등록율',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '자재건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '무단가자재건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},{					
    			fieldLabel: '제품판가 관리율',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '(-)제품 재고건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '(-)자재 재고건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},{					
    			fieldLabel: '자재단가 관리율',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},
    		
    		{
    			xtype: 'component',
    			autoEl: {
        			html: '<hr width="1200px">'
    			},colspan:5
			},{
				xtype: 'fieldset',
				border:false,
				rowspan:4,
				width: 140,
				height:130,
				items:[{
				border: false,
				name: '',
				html: "회계(FI)"
				}
			]},{					
    			fieldLabel: '제품 재고일수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '재공 재고일수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '자재 재고 일수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},{					
    			fieldLabel: '제품 재고금액(원)',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '재공 재고금액(원)',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '자재 재고금액(원)',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},{					
    			fieldLabel: '물류 마감일',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: '결산 마감일',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},
    		
    		{
    			xtype: 'component',
    			autoEl: {
        			html: '<hr width="1200px">'
    			},colspan:5
			},{
				
				xtype: 'fieldset',
				border:false,
				rowspan:6,
				width: 140,
				height:130,
				items:[{
				border: false,
				name: '',
				html: "SCM(SCM)"
				}
			]},{					
    			fieldLabel: 'W.FCST 수신건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: 'W.FCST 반영건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: 'W.FCST RTF 건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: 'W.FCST반영율',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: 'D.FCST 수신건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: 'D.FCST 반영건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},{					
    			fieldLabel: 'D.FCST 반영율',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: 'P/O 수신건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: 'P/O 반영건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: 'POR 건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: 'P/O 반영율',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: 'D/O 수신건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: 'D/O 반영건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},{					
    			fieldLabel: 'D/O 반영율',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: 'STOCK 송신건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: 'INV 송신건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},{
    			xtype:'hiddenfield', 
    			hidden:false
    		},{					
    			fieldLabel: 'P/O ERROR 건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: 'D/O ERROR 건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		},{					
    			fieldLabel: 'INV ERROR 건수',
    			name:'',
    			xtype: 'uniTextfield',
    			readOnly: true
    		}
    		
    		]
         ,api: {
         		 load: 'bsa720skrvService.selectMaster',
				 submit: 'bsa720skrvService.syncMaster'				
				}
		, listeners : {
				dirtychange:function( basicForm, dirty, eOpts ) {
					console.log("onDirtyChange");
					UniAppManager.setToolbarButtons('save', true);
				},
				beforeaction:function(basicForm, action, eOpts)	{
					console.log("action : ",action);
					console.log("action.type : ",action.type);
					if(action.type =='directsubmit')	{
						var invalid = this.getForm().getFields().filterBy(function(field) {
						            return !field.validate();
						    });
				        	
			         	if(invalid.length > 0)	{
				        	r=false;
				        	var labelText = ''
				        	
				        	if(Ext.isDefined(invalid.items[0]['fieldLabel']))	{
				        		var labelText = invalid.items[0]['fieldLabel']+'은(는)';
				        	}else if(Ext.isDefined(invalid.items[0].ownerCt))	{
				        		var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
				        	}
				        	Unilite.messageBox(labelText+Msg.sMB083);
				        	invalid.items[0].focus();
				        }																									
					}
				}	
		}
	});

    /**
	 * main app
	 */
    Unilite.Main( {
    		 id  : 'bsa720skrvApp',
			 items 	: [ detailForm]
			,fnInitBinding : function() {
				this.setToolbarButtons(['newData','reset'],false);
				this.onQueryButtonDown();
			}
			,onQueryButtonDown:function () {
				var param= detailForm.getValues();
				detailForm.getForm().load({params : param});
			},
			onSaveDataButtonDown: function (config) {
				
				var param= detailForm.getValues();
				detailForm.getForm().submit({
						 params : param,
						 success : function(form, action) {
			 					detailForm.getForm().wasDirty = false;
								detailForm.resetDirtyStatus();											
								UniAppManager.setToolbarButtons('save', false);	
								
			            		UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.			
						 }	
				});
			},
			onDetailButtonDown:function() {
				var as = Ext.getCmp('bsa720skrvAdvanceSerch');	
				if(as.isHidden())	{
					as.show();
				}else {
					as.hide()
				}
			},
			rejectSave: function()	{
				var rowIndex = masterGrid.getSelectedRowIndex();
				masterGrid.select(rowIndex);
				directMasterStore.rejectChanges();
				
				
				if(rowIndex >= 0){
					masterGrid.getSelectionModel().select(rowIndex);
					var selected = masterGrid.getSelectedRecord();
					
					var selected_doc_no = selected.data['DOC_NO'];
	  				bdc100ukrvService.getFileList(
	  						{DOC_NO : selected_doc_no},
							function(provider, response) {															
								
							}
					);
				}
				directMasterStore.onStoreActionEnable();

			}, confirmSaveData: function(config)	{
            	if(directMasterStore.isDirty())	{
					if(confirm(Msg.sMB061))	{
						this.onSaveDataButtonDown(config);
					} else {
						this.rejectSave();
					}
				}
				
            }
            
		});
}
</script>
