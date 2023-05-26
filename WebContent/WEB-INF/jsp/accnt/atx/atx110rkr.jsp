<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx110rkr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A003"  />	<!-- 매입매출구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A022"  />	<!-- 증빙유형 -->
	<t:ExtComboStore comboType="AU" comboCode="A081"  />	<!-- 부가세조정 입력구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A070"  />	<!-- 매입세액불공제사유 -->
	<t:ExtComboStore comboType="AU" comboCode="S010"  />	<!-- 주영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="A149"  />	<!-- 전자발행여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A020"  />	<!-- YES/NO (매수제외필드) -->
	<t:ExtComboStore comboType="AU" comboCode="A156"  />	<!-- 부가세생성경로 -->
	<t:ExtComboStore comboType="AU" comboCode="A011"  />	<!-- 입력경로 -->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >
var useColList = ${useColList};
var linkId = ${linkId};

var BsaCodeInfo = {	
 useLinkYn : '${useLinkYn}',
 sortNumber : '${sortNumber}',
 moneyUnit : '${moneyUnit}'
};
var linkPgmId = '';

function appMain() {     
	/**
	 * 증빙유형 콤보 Store 정의
	 * @type 
	 */					
	var ProofKindStore = Unilite.createStore('atx110skrProofKindStore',{
        proxy: {
           type: 'direct',
            api: {			
                read: 'atx110skrService.getProofKind'                	
            }
        },
        loadStoreRecords: function() {
			var param= Ext.getCmp('resultForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}
	});
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'center',
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
		
		items: [{ 
        	fieldLabel: '계산서일',
			xtype: 'uniDateRangefield',  
			startFieldName: 'txtFrDate',
			endFieldName: 'txtToDate',
			allowBlank:false,
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    }
		},{
			fieldLabel: '매입/매출구분',
			name:'txtDivi',	
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'A003',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					ProofKindStore.loadStoreRecords();
				}
			}  
		},{
			fieldLabel: '신고사업장',
			name:'txtOrgCd',	
			xtype: 'uniCombobox',
			comboType:'BOR120' ,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
				}
			}  
		},{
			fieldLabel: '증빙유형',
			name:'txtProofKind',
			xtype: 'uniCombobox',
			store:ProofKindStore,
			width:315,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
				}
			}    
		},
        	//CUST 팝업 오류로 임시로 BCM100t [RETURN_CODE]컬럼 추가(추후 확인)
        	Unilite.popup('CUST',{
	        fieldLabel: '거래처',
			allowBlank:true,
			autoPopup:false,
			validateBlank:false,
		    valueFieldName:'txtCustom',
		    textFieldName:'txtCustomName',
        	listeners: {
					onValueFieldChange:function( elm, newValue, oldValue) {							
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('txtCustomName', '');
						}
					},
					onTextFieldChange:function( elm, newValue, oldValue) {						
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('txtCustom', '');
						}
					}
			}		        
	    }),{
			fieldLabel: '사업자번호',
            xtype: 'uniTextfield',
            name: 'txtCompanyNum',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
				}
			}
     	},{ 
	        	fieldLabel: '전표일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'txtAcFrDate',
				endFieldName: 'txtAcToDate',
				width: 315
			},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:600,
				items :[{
				    fieldLabel:'전표번호', 
				    xtype: 'uniNumberfield',
				    name: 'txtFrSlipNum', 
				    width:195
			   },{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniNumberfield',
					name: 'txtToSlipNum', 
					width:110
				}]
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '전자발행여부',						            		
				id: 'rdoSelect1',
				items: [{
					boxLabel: '전체', 
					width: 70, 
					name: 'EbNm',
					inputValue: '',
					checked: true  
				},{
					boxLabel : '발행', 
					width: 70,
					name: 'EbNm',
					inputValue: 'Y'
				},{
					boxLabel: '미발행', 
					width: 70, 
					name: 'EbNm',
					inputValue: 'N' 
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	
//						directMasterStore.loadStoreRecords();
					}
				}
			},{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:600,
				items :[{
				    fieldLabel:'금액', 
				    xtype: 'uniNumberfield',
				    name: 'txtFrAmt', 
				    width:195
			   },{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniNumberfield',
					name: 'txtToAmt', 
					width:110
				}]
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '금액구분',						            		
				id: 'rdoSelect',
				columns: 2,
				items: [{
					boxLabel: '매입공급가액', 
					width: 100, 
					name: 'SorGbn',
					inputValue: '1',
					checked: true  
				},{
					boxLabel : '매입세액', 
					width: 80,
					name: 'SorGbn',
					inputValue: '2'
				},{
					boxLabel: '매출공급가액', 
					width: 100, 
					name: 'SorGbn',
					inputValue: '3' 
				},{
					boxLabel : '매출세액', 
					width: 80,
					name: 'SorGbn',
					inputValue: '4'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	
//						directMasterStore.loadStoreRecords();
					}
				}
			},{ 
	        	fieldLabel: '입력일',
				xtype: 'uniDateRangefield',  
				startFieldName: 'txtInputFrDate',
				endFieldName: 'txtInputToDate',
				width: 315
			},{
				fieldLabel: '적요',
				name: 'txtRemark',
				xtype: 'uniTextfield'
			},{
				fieldLabel: '입력구분',
				name:'txtInputDivi',	
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'A081'  
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '증빙그룹',						            		
				id: 'rdoSelect2',
				columns: 2,
				items: [{
					boxLabel: '전체', 
					width: 55, 
					name: 'BillGbn',
					inputValue: '',
					checked: true  
				},{
					boxLabel : '세금계산서', 
					width: 90,
					name: 'BillGbn',
					inputValue: '1'
				},{
					boxLabel: '계산서', 
					width: 70, 
					name: 'BillGbn',
					inputValue: '2' 
				},{
					boxLabel: '매입자발행세금계산서', 
					width: 300, 
					name: 'BillGbn',
					inputValue: '3'
				},{
					boxLabel: '신용카드', 
					width: 80, 
					name: 'BillGbn',
					inputValue: '4'
				},{
					boxLabel : '현금영수증', 
					width: 80,
					name: 'BillGbn',
					inputValue: '5'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	
//						directMasterStore.loadStoreRecords();
					}
				}
			},{
				fieldLabel: '생성경로',
				name:'txtPubPath',	
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'A156'  
			},{
	    		xtype: 'uniCheckboxgroup',	
	    		padding: '0 0 0 0',
	    		fieldLabel: '선택',
	    		id: 'chkBox',
	    		items: [{
	    			boxLabel: '증빙유형이 불공제만 조회',
	    			width: 170,
	    			name: 'ChkDed',
	    			inputValue: 'Y',
	    			uncheckedValue: 'N'
	    		}]
	        },{
				fieldLabel: '불공제사유',
				name:'cboReasonCode',	
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'A070'  
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: 'SORT순서',						            		
				id: 'rdoSelect5',
				columns: 1,
				items: [{
					boxLabel: '계산서일,사업자번호,거래처명순', 
					width: 325, 
					name: 'SortGbn',
					inputValue: '1',
					checked: true  
				},{
				
					boxLabel : '계산서일,전표일,번호,순번순', 
					width: 325,
					name: 'SortGbn',
					inputValue: '2'
				},{
					
					boxLabel: '사업자번호,계산서일순', 
					width: 325, 
					name: 'SortGbn',
					inputValue: '3' 
				
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	
//						directMasterStore.loadStoreRecords();
					}
				}
			},
            {
             	xtype:'button',
             	text:'출    력',
             	width:235,
             	tdAttrs:{'align':'left', style:'padding-left:45px'},
             	handler:function()	{
             		UniAppManager.app.onPrintButtonDown();
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
	
 
   
    
	 Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			defaults: {autoScroll: true},
			items:[
				 panelResult
			]
		}], 
		id : 'atx110skrApp',
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('query',false);
			var activeSForm ;
			activeSForm = panelResult;
			activeSForm.onLoadSelectText('txtFrDate');
			
			
			this.setDefault();
			this.processParams(params);	
		},
		processParams: function(params) {
//			this.uniOpt.appParams = params;			
			if(params.PGM_ID == 'atx130skr') {
				panelResult.setValue('txtFrDate', params.txtFrDate);
				panelResult.setValue('txtToDate', params.txtToDate);
				panelResult.setValue('txtDivi', params.txtDivi);
				panelResult.setValue('txtCompanyNum', params.txtCompanyNum);
				panelResult.setValue('txtOrgCd', params.txtOrgCd);
//				directMasterStore.loadStoreRecords();
			}else if(params.PGM_ID == 'atx140skr') {
				panelResult.setValue('txtFrDate', params.txtFrDate);
				panelResult.setValue('txtToDate', params.txtToDate);
				panelResult.setValue('txtDivi', params.txtDivi);
				panelResult.setValue('txtCompanyNum', params.txtCompanyNum);
				panelResult.setValue('txtOrgCd', params.txtOrgCd);
//				directMasterStore.loadStoreRecords();
			}
		},
		onQueryButtonDown : function()	{		
			
		},
		onPrintButtonDown:function(){
			var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/atx/atx110rkr.do',
				prgID: 'atx110rkr',
				extParam: panelResult.getValues()
			})
			win.center();
			win.show();
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			this.fnInitBinding();
		},
		setDefault: function() {
        	ProofKindStore.loadStoreRecords();
        	
			panelResult.setValue('txtFrDate',UniDate.get('startOfMonth'));
			panelResult.setValue('txtToDate',UniDate.get('today'));
			
		},
		setHiddenColumn: function() {
			Ext.each(useColList, function(record, idx) {
			});
		},
		checkForNewDetail:function() { 			
			return panelResult.setAllFieldsReadOnly(true);
        }
	});
};


</script>
