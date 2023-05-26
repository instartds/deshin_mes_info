<%@page import="foren.framework.model.LoginVO"%>
<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_qms300skrv_in">
<t:ExtComboStore comboType="BOR120"  />          <!-- 사업장 -->
</t:appConfig>
<script type="text/javascript" >
function appMain() {
	/**
	 * Model 정의
	 * @type
	 */

	Unilite.defineModel('s_qms300skrv_inModel', {
	    fields:[
	    	{name: 'PRODT_DATE'    ,text: '검사일'     ,type: 'uniDate'},	    
	    	{name: 'QC_NAME'       ,text: '검사유형'   ,type: 'string'},   
	    	{name: 'ITEM_CODE'     ,text: '품목코드'   ,type: 'string'},	    
	    	{name: 'ITEM_NAME'     ,text: '품명'       ,type: 'string'},	    
	    	{name: 'SPEC'          ,text: '규격'       ,type: 'string'},	    
	    	{name: 'LOT_NO'        ,text: 'LOT_NO'     ,type: 'string'},   
	    	{name: 'BAD_Q'         ,text: '검사수량'   ,type: 'uniQty'},   
	    	{name: 'WORK_SHOP_NAME',text: '작업장'     ,type: 'string'},   
    		{name: 'WKORD_NUM'     ,text: '작업장번호' ,type: 'string'},   
	    	{name: 'QC_AMT'        ,text: '검사금액'   ,type: 'uniPrice'},   
	    	{name: 'REMARK'        ,text: '비고'       ,type: 'string'},
	    	{name: 'DIV_CDOE'      ,text: '사업장번호' ,type: 'string'}
	    ]
	});
	
	
	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('s_qms300skrv_inMasterStore',{
		model: 's_qms300skrv_inModel',
		uniOpt : {
			isMaster: true,			// 상위 버튼 연결
			editable: false,		// 수정 모드 사용
			deletable:false,		// 삭제 가능 여부
			useNavi : false			// prev | newxt 버튼 사용
	            					
		},
		autoLoad: false,		
		proxy: {
			type: 'direct',
			api: {
				read: 's_qms300skrv_inService.selectList'
				}
		},		
		loadStoreRecords: function(){                     
            var param= panelResult.getValues();           
            this.load({
             		params: param
            });        
        }
	});
	function loginDivCode(){
		var param= Ext.getCmp('resultForm').getValues();
	}
	/**
	 * 검색조건 (Search Panel) panelResult
	 * @type
	 */
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
			items:[{
                fieldLabel:'사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType: 'BOR120',
                allowBlank: false,
                holdable: 'hold'            
            },{
				fieldLabel:'검사일',
				xtype: 'uniDateRangefield',
				startFieldName: 'PRODT_DATE_FR',
				endFieldName: 'PRODT_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),
				width: 315,
				textFieldWidth: 150,
				allowBlank: false
			},{
				fieldLabel: 'Lot No',
				name: 'LOT_NO',
				xtype: 'uniTextfield',
				listeners: {
                    change: function(field, newValue, oldValue, eOpts) {
                        
                    }
                }
				
			},	Unilite.popup('DIV_PUMOK',{
				fieldLabel:'품목',
				valueFieldName: 'ITEM_CODE',
				textFieldName: 'ITEM_NAME',
				valueFieldWidth:100,
				textFieldWidth:150,				
				validateBlank:false,
				autoPopup:true				
			})
		],setAllFieldsReadOnly: function(b) {//필수조건검색 공란일시 메시지출력
            var r= true
            if(b) {
                var invalid = this.getForm().getFields().filterBy(function(field) {
                                                                    return !field.validate();
                                                                });
                if(invalid.length > 0) {
                    r=false;
                    var labelText = ''

                    if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
                        var labelText = invalid.items[0]['fieldLabel']+' : ';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
                    }

                    alert(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
                    invalid.items[0].focus();
                } else {
                    // this.mask();
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) )   {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true);
                            }

                        }
                        if(item.isPopupField)   {
                            var popupFC = item.up('uniPopupField')  ;
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
                    if(Ext.isDefined(item.holdable) )   {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }

                    }
                    if(item.isPopupField)   {
                        var popupFC = item.up('uniPopupField')  ;
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

	var masterGrid = Unilite.createGrid('s_qms300skrv_inGrid', {
    	
		region: 'center',
        layout : 'fit',
    	store : directMasterStore,
    	
    	uniOpt:{	
        	expandLastColumn: true,	//마지막 컬럼 * 사용 여부
			useRowNumberer: true,		//첫번째 컬럼 순번 사용 여부
			useLiveSearch: true,		//찾기 버튼 사용 여부
			useRowContext: false,			
			onLoadSelectFirst	: true,
    		filter: {					//필터 사용 여부
				useFilter: true,
				autoCreate: true
			}
		},
		features: [ 
    		{id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
    	    {id: 'masterGridTotal',    ftype: 'uniSummary', 	    showSummaryRow: false} 
    	],
    	
       	columns:[
       	{dataIndex: 'PRODT_DATE'    ,	    width: 100},//검사일
       	{dataIndex: 'QC_NAME'	    ,	    width: 150},//검사유형
       	{dataIndex: 'ITEM_CODE'	    ,	    width: 100},//품목코드
       	{dataIndex: 'ITEM_NAME'	    ,	    width: 250},//품명
       	{dataIndex: 'SPEC'	        ,		width: 150 },//규격
       	{dataIndex: 'LOT_NO'	    ,		width: 100},//LOT_NO
       	{dataIndex: 'BAD_Q'	        ,		width: 80},//검사수량
       	{dataIndex: 'WORK_SHOP_NAME',		width: 150},//작업장
       	{dataIndex: 'WKORD_NUM'     ,		width: 150},//작업장번호
       	{dataIndex: 'QC_AMT'	    ,		width: 80},//검사금액
      	{dataIndex: 'REMARK'	    ,	    width: 250}//비고
    	]				
	});
    Unilite.Main({ 
    	borderItems:[{
    		region : 'center' ,
            layout : 'border',
    		id     : 'mainItem',
    		border : false,
    		items  : [
    					panelResult, masterGrid 
    		         ]  	
        	}],
		
        fnInitBinding: function() {
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('PRODT_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('PRODT_DATE_TO', UniDate.get('today'));
        	UniAppManager.setToolbarButtons('save',false);
        },
        onQueryButtonDown: function()    {            
            var isTrue = panelResult.setAllFieldsReadOnly(true);
         	if(!isTrue){
        		return false;
        	}
        	masterGrid.getStore().loadStoreRecords();            
        },
		onResetButtonDown:function() {				//신규버튼클릭(초기화)
            masterGrid.reset();
            directMasterStore.clearData();
            panelResult.clearForm();
 			this.fnInitBinding();
		}
	});
    
 };
</script>
