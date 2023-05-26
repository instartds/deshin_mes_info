<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sco330ukrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="sco330ukrv" /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업/수금담당자-->
	<t:ExtComboStore comboType="AU" comboCode="S017" /> <!--수금유형-->
	<t:ExtComboStore comboType="AU" comboCode="B064" /> <!--어음유형-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {   
	//조회된 합계, 건수 계산용 변수 선언
    var sumCheckedCount = 0;
    //전체선택 버튼관련 변수 선언
        selDesel = 0;
        checkCount = 0;
    
    /**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('sco330ukrvModel', {
	    fields: [  	  
	    	{name: 'CHOICE'          			,text: '<t:message code="system.label.sales.selection" default="선택"/>'					,type: 'string'},
		    {name: 'DISHONOR_DATE'   			,text: '<t:message code="system.label.sales.dishonoreddate" default="부도일"/>'				,type: 'uniDate', allowBlank: false},
		    {name: 'COLLECT_NUM'     			,text: '<t:message code="system.label.sales.collectionno" default="수금번호"/>'				,type: 'string'},
		    {name: 'COLLECT_SEQ'     			,text: '<t:message code="system.label.sales.seq" default="순번"/>'				    ,type: 'int'},
		    {name: 'COLLECT_TYPE'    			,text: '<t:message code="system.label.sales.collectiontype" default="수금유형"/>'				,type: 'string'},
		    {name: 'COLLECT_AMT'     			,text: '<t:message code="system.label.sales.collectionamount" default="수금액"/>'				    ,type: 'uniPrice'},
		    {name: 'NOTE_NUM'        			,text: '<t:message code="system.label.sales.noteno" default="어음번호"/>'				,type: 'string'},  
		    {name: 'NOTE_TYPE'       			,text: '<t:message code="system.label.sales.noteclass" default="어음구분"/>'				,type: 'string'},
		    {name: 'PUB_CUST_CD'     			,text: '<t:message code="system.label.sales.publishoffice" default="발행기관"/>'				,type: 'string'},
		    {name: 'PUB_CUST_NM'     			,text: '<t:message code="system.label.sales.publishoffice" default="발행기관"/>'				,type: 'string'},
		    {name: 'NOTE_PUB_DATE'   			,text: '<t:message code="system.label.sales.publishdate" default="발행일"/>'				,type: 'uniDate'},
		    {name: 'PUB_PRSN'        			,text: '<t:message code="system.label.sales.publisher" default="발행인"/>'				    ,type: 'string'},
		    {name: 'NOTE_DUE_DATE'   			,text: '<t:message code="system.label.sales.duedate" default="만기일"/>'				,type: 'uniDate'},
		    {name: 'PUB_ENDOSER'     			,text: '<t:message code="system.label.sales.endorser" default="배서인"/>'				    ,type: 'string'},
		    {name: 'SAVE_CODE'       			,text: '<t:message code="system.label.sales.bankaccountcode" default="통장번호코드"/>'			    ,type: 'string'},
		    {name: 'SAVE_NAME'       			,text: '<t:message code="system.label.sales.bankaccountno" default="통장번호"/>'				,type: 'string'},
		    {name: 'AC_DATE'         			,text: '<t:message code="system.label.sales.acslipdate" default="회계전표일"/>'				,type: 'uniDate'},
		    {name: 'AC_NUM'          			,text: '<t:message code="system.label.sales.slipno" default="전표번호"/>'			    ,type: 'string'},
		    {name: 'PROJECT_NO'      			,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'			,type: 'string'},
		    {name: 'BILL_NUM'        			,text: '<t:message code="system.label.sales.salesno" default="매출번호"/>'				,type: 'string'},
		    {name: 'PUB_NUM'         			,text: '<t:message code="system.label.sales.billno" default="계산서번호"/>'				,type: 'string'},
		    {name: 'REMARK'          			,text: '<t:message code="system.label.sales.remarks" default="비고"/>'					,type: 'string'},
		    {name: 'DIV_CODE'        			,text: '<t:message code="system.label.sales.division" default="사업장"/>'				,type: 'string'},
		    {name: 'CUSTOM_CODE'     			,text: '<t:message code="system.label.sales.custom" default="거래처"/>'				,type: 'string'},
		    {name: 'COLLECT_DATE'    			,text: '<t:message code="system.label.sales.collectiondate" default="수금일"/>'				    ,type: 'uniDate'},
		    {name: 'COLET_CUST_CD'   			,text: '<t:message code="system.label.sales.collectioncustomer" default="수금거래처"/>'				,type: 'string'},  
		    {name: 'COLLECT_PRSN'    			,text: '<t:message code="system.label.sales.collectioncharge" default="수금담당"/>'				,type: 'string'},
		    {name: 'COLLECT_DIV'     			,text: '<t:message code="system.label.sales.collectiondivision" default="수금사업장"/>'				,type: 'string'},
		    {name: 'UPDATE_DB_USER'  			,text: '<t:message code="system.label.sales.updateuser" default="수정자"/>'				    ,type: 'string'},
		    {name: 'UPDATE_DB_TIME'  			,text: '<t:message code="system.label.sales.updatedate" default="수정일"/>'				    ,type: 'uniDate'},
		    {name: 'DEPT_CODE'       			,text: '<t:message code="system.label.sales.department" default="부서"/>'				,type: 'string'},
		    {name: 'TREE_NAME'       			,text: '<t:message code="system.label.sales.departmentname" default="부서명"/>'				    ,type: 'string'},
		    {name: 'MONEY_UNIT'      			,text: '<t:message code="system.label.sales.currencyunit" default="화폐단위"/>'				,type: 'string', displayField: 'value'},
		    {name: 'EXCHANGE_RATE'   			,text: '<t:message code="system.label.sales.exchangerate" default="환율"/>'					,type: 'uniER'},
		    {name: 'SALE_PROFIT'     			,text: '<t:message code="system.label.sales.businessdivision" default="사업부"/>'				    ,type: 'string'},
		    {name: 'EX_DATE'         			,text: '<t:message code="system.label.sales.exslipdate" default="결의전표일"/>'				,type: 'uniDate'},
		    {name: 'EX_NUM'          			,text: '<t:message code="system.label.sales.exslipno" default="결의전표번호"/>'			,type: 'string'},
		    {name: 'EX_SEQ'          			,text: '<t:message code="system.label.sales.exslipseq" default="결의순번"/>'			,type: 'string'},
		    {name: 'AGREE_YN'        			,text: '<t:message code="system.label.sales.exslipapproveyn" default="결의전표승인여부"/>'		,type: 'string'},
		    {name: 'BILL_DIV_CODE'   			,text: '<t:message code="system.label.sales.taxinvoicedivcode" default="세금계산서사업장"/>'		,type: 'string'},
		    {name: 'J_EX_NUM'        			,text: '<t:message code="system.label.sales.dishonoredsettle" default="부도처리"/>-<t:message code="system.label.sales.exslipno" default="결의전표번호"/>'	,type: 'string'},
		    {name: 'J_EX_DATE'       			,text: '<t:message code="system.label.sales.dishonoredsettle" default="부도처리"/>-<t:message code="system.label.sales.exslipdate" default="결의전표일"/>'	,type: 'uniDate'},
		    {name: 'J_AC_NUM'        			,text: '<t:message code="system.label.sales.dishonoredsettle" default="부도처리"/>-<t:message code="system.label.sales.acslipno" default="회계전표번호"/>'	,type: 'string'},
		    {name: 'J_AC_DATE'       			,text: '<t:message code="system.label.sales.dishonoredsettle" default="부도처리"/>-<t:message code="system.label.sales.acslipdate" default="회계전표일"/>'	,type: 'uniDate'},
		    {name: 'SORT_KEY'        			,text: 'SORT_KEY'			    ,type: 'string'},
		    {name: 'REF_CODE1'       			,text: '<t:message code="system.label.sales.mainissuetype" default="주출고유형"/>'				,type: 'string'}
		    
		]
	}); //End of Unilite.defineModel('sco330ukrvModel', {

	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('sco330ukrvMasterStore1',{
		model: 'sco330ukrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
           type: 'direct',
            api: {          
                read: 'sco330ukrvService.selectList'                 
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		}/*,
		groupField: 'ITEM_NAME'*/
			
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
        title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',         
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
            title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',   
            itemId: 'search_panel1',
            layout : {type : 'vbox', align : 'stretch'},
            items : [{
                xtype:'container',
                layout : {type : 'uniTable', columns : 1},
                items:[{
                    fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
                    name: 'DIV_CODE', 
                    xtype: 'uniCombobox', 
                    comboType: 'BOR120',
                    allowBlank:false,
//                    holdable: 'hold',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('DIV_CODE', newValue);
                        }
                    }
                },{
                    fieldLabel: '<t:message code="system.label.sales.collectioncharge" default="수금담당"/>',
                    name:'COLLECT_PRSN',   
                    xtype: 'uniCombobox', 
                    comboType:'AU',
                    comboCode:'S010',
                    allowBlank: false,
//                    onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
//                        if(eOpts){
//                            combo.filterByRefCode('refCode1', newValue, eOpts.parent);
//                        }else{
//                            combo.divFilterByRefCode('refCode1', newValue, divCode);
//                        }
//                    },
                    listeners:{
                        change: function(combo, newValue, oldValue, eOpts) {
//                            var saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(newValue);//영업담당의 사업장코드 가져오기
//                            panelResult.setValue('COLL_DIV_CODE', saleDivCode);
//                            panelSearch.setValue('COLL_DIV_CODE', saleDivCode);
                            panelResult.setValue('COLLECT_PRSN', panelSearch.getValue('COLLECT_PRSN'));
                        }
                    }/*,
                    holdable: 'hold'*/
                },
                Unilite.popup('AGENT_CUST',{
                    fieldLabel: '<t:message code="system.label.sales.collectionplace" default="수금처"/>',
                    valueFieldName:'COLL_CUSTOM_CODE',
                    textFieldName:'COLL_CUSTOM_NAME',
                    allowBlank: false,
//                    holdable: 'hold',
                    listeners: {
                        onSelected: function(records, type){            
                            panelResult.setValue('COLL_CUSTOM_CODE', panelSearch.getValue('COLL_CUSTOM_CODE'));
                            panelResult.setValue('COLL_CUSTOM_NAME', panelSearch.getValue('COLL_CUSTOM_NAME'));
                        },
                        onClear: function(type) {
                            panelResult.setValue('COLL_CUSTOM_CODE', '');
                            panelResult.setValue('COLL_CUSTOM_NAME', '');
                        }
                    }
                }),{
    				fieldLabel: '<t:message code="system.label.sales.collectiondate" default="수금일"/>',
    				xtype: 'uniDateRangefield',
    				startFieldName: 'COLLECT_DATE_FR',
                    endFieldName: 'COLLECT_DATE_TO',
    				width: 315,
    				startDate: UniDate.get('today'),
    				endDate: UniDate.get('today'),                  
                    onStartDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelResult) {
                            panelResult.setValue('COLLECT_DATE_FR', newValue);                       
                        }
                    },
                    onEndDateChange: function(field, newValue, oldValue, eOpts) {
                        if(panelResult) {
                            panelResult.setValue('COLLECT_DATE_TO', newValue);                           
                        }
                    }
    			},{
    				fieldLabel: '<t:message code="system.label.sales.noteno" default="어음번호"/>',
    				name:'NOTE_NUM', 	
    				xtype: 'uniNumberfield',
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {                        
                            panelResult.setValue('NOTE_NUM', newValue);
                        }
                    }
    			
    			},{
    				xtype: 'radiogroup',		            		
                	fieldLabel: ' ',						            		
                	id: 'rdo1',
                	labelWidth:90,
                	items: [{
                		boxLabel: '<t:message code="system.label.sales.dishonoredsettleobject" default="부도처리대상"/>',  
                		width: 100,  
                		name: 'rdoSelect', 
                		inputValue: '0', 
                		checked: true
                	},{
                		boxLabel: '<t:message code="system.label.sales.dishonoredcancelobject" default="부도취소대상"/>',
                		width: 100,
                		name: 'rdoSelect' ,
                		inputValue: '1'
                	}],
                    listeners: {
                        change: function(field, newValue, oldValue, eOpts) {            
                            panelResult.getField('rdoSelect').setValue(newValue.rdoSelect); 
                            if(Ext.getCmp('rdo1').getChecked()[0].inputValue == '0'){
                                Ext.getCmp('CONFIRM_DATA2').setText('<t:message code="system.label.sales.dishonoredsettle" default="부도처리"/>');
                            } else {
                                Ext.getCmp('CONFIRM_DATA2').setText('<t:message code="system.label.sales.dishonoredcancel" default="부도취소"/>');
                            }
                            UniAppManager.app.onQueryButtonDown();
                        }
                    }
                },{
                    xtype: 'container',
                    padding: '0 0 0 20',
                    layout: {
                        type: 'hbox',
                        align: 'center',
                        pack: 'center'
                    },
                    items:[{
                        xtype: 'button',
                        text: '<t:message code="system.label.sales.dishonoredsettle" default="부도처리"/>', 
                        id: 'CONFIRM_DATA1',
                        name: 'EXECUTE_TYPE',
                        //inputValue: '1',
                        width: 110,  
                        handler : function(records, grid, record) {
                            if(panelSearch.setAllFieldsReadOnly(true)){
                                //자동기표일 때 SP 호출
                                if(panelResult.getValue('COUNT') != 0){  
                                    if(Ext.getCmp('rdo1').getChecked()[0].inputValue == '0'){
                                            var param = panelSearch.getValues();
                                            panelSearch.getEl().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
                                            sco330ukrvService.procButton(param, 
                                                function(provider, response) {
                                                    if(provider) {  
                                                        UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                                    }
                                                    console.log("response",response)
                                                    panelSearch.getEl().unmask();
                                                }
                                            )
                                        return panelSearch.setAllFieldsReadOnly(true);
                                    }
                                    //기표취소일 때 SP 호출
                                    if(Ext.getCmp('rdo1').getChecked()[0].inputValue == '1'){
                                            var param = panelSearch.getValues();
                                            panelSearch.getEl().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
                                            sco330ukrvService.cancButton(param, 
                                                function(provider, response) {
                                                    if(provider) {  
                                                        UniAppManager.updateStatus('<t:message code="system.message.sales.datacheck015" default="취소되었습니다."/>');
                                                    }
                                                    console.log("response",response)
                                                    panelSearch.getEl().unmask();
                                                }
                                            )
                                            return panelSearch.setAllFieldsReadOnly(true);
                                    }
                                }else {
                                    UniAppManager.updateStatus('<t:message code="system.message.sales.datacheck016" default="선택된 자료가 없습니다."/>');
                                }
                            }
                        }
                    }]
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
                        var labelText = invalid.items[0]['fieldLabel']+' : ';
                    } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
                    }
                    Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
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
    
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 5, tableAttrs: {width: '100%'}},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
                fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
                name: 'DIV_CODE', 
                xtype: 'uniCombobox', 
                comboType: 'BOR120',
                allowBlank:false,
//                holdable: 'hold',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('DIV_CODE', newValue);
                    }
                }
            },{
                fieldLabel: '<t:message code="system.label.sales.collectioncharge" default="수금담당"/>',
                name:'COLLECT_PRSN',   
                xtype: 'uniCombobox', 
                comboType:'AU',
                comboCode:'S010',
                allowBlank: false,
//                    onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
//                        if(eOpts){
//                            combo.filterByRefCode('refCode1', newValue, eOpts.parent);
//                        }else{
//                            combo.divFilterByRefCode('refCode1', newValue, divCode);
//                        }
//                    },
                listeners:{
                    change: function(combo, newValue, oldValue, eOpts) {
//                            var saleDivCode = UniAppManager.app.fnGetSalePrsnDivCode(newValue);//영업담당의 사업장코드 가져오기
//                            panelResult.setValue('COLL_DIV_CODE', saleDivCode);
//                            panelSearch.setValue('COLL_DIV_CODE', saleDivCode);
                        panelSearch.setValue('COLLECT_PRSN', panelResult.getValue('COLLECT_PRSN'));
                    }
                }/*,
                holdable: 'hold'*/
            },
            Unilite.popup('AGENT_CUST',{
                fieldLabel: '<t:message code="system.label.sales.collectionplace" default="수금처"/>',
                valueFieldName:'COLL_CUSTOM_CODE',
                textFieldName:'COLL_CUSTOM_NAME',
                allowBlank: false,
//                holdable: 'hold',
                colspan: 3,
                listeners: {
                    onSelected: function(records, type){            
                        panelSearch.setValue('COLL_CUSTOM_CODE', panelResult.getValue('COLL_CUSTOM_CODE'));
                        panelSearch.setValue('COLL_CUSTOM_NAME', panelResult.getValue('COLL_CUSTOM_NAME'));
                    },
                    onClear: function(type) {
                        panelSearch.setValue('COLL_CUSTOM_CODE', '');
                        panelSearch.setValue('COLL_CUSTOM_NAME', '');
                    }
                }
            }),{
                fieldLabel: '<t:message code="system.label.sales.collectiondate" default="수금일"/>',
                xtype: 'uniDateRangefield',
                startFieldName: 'COLLECT_DATE_FR',
                endFieldName: 'COLLECT_DATE_TO',
                width: 315,
                startDate: UniDate.get('today'),
                endDate: UniDate.get('today'),                  
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelSearch.setValue('COLLECT_DATE_FR', newValue);                       
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelSearch.setValue('COLLECT_DATE_TO', newValue);                           
                    }
                }
            },{
                fieldLabel: '<t:message code="system.label.sales.noteno" default="어음번호"/>',
                name:'NOTE_NUM',    
                xtype: 'uniNumberfield',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('NOTE_NUM', newValue);
                    }
                }
            
            },{
                xtype: 'radiogroup',                            
                fieldLabel: ' ',                                            
                id: 'rdo2',
                labelWidth:90,
                items: [{
                    boxLabel: '<t:message code="system.label.sales.dishonoredsettleobject" default="부도처리대상"/>',  
                    width: 100,  
                    name: 'rdoSelect', 
                    inputValue: '0', 
                    checked: true
                },{
                    boxLabel: '<t:message code="system.label.sales.dishonoredcancelobject" default="부도취소대상"/>',
                    width: 100,
                    name: 'rdoSelect' ,
                    inputValue: '1'
                }],
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {            
                        panelSearch.getField('rdoSelect').setValue(newValue.rdoSelect);  
                        if(Ext.getCmp('rdo2').getChecked()[0].inputValue == '0'){
                            Ext.getCmp('CONFIRM_DATA2').setText('<t:message code="system.label.sales.dishonoredsettle" default="부도처리"/>');
                        } else {
                            Ext.getCmp('CONFIRM_DATA2').setText('<t:message code="system.label.sales.dishonoredcancel" default="부도취소"/>');
                        }
                        UniAppManager.app.onQueryButtonDown();
                    }
                }
            },{
                //컬럼 맞춤용
                xtype: 'component',
                width:600,
                tdAttrs: {width: 600} 
            },{
                xtype: 'uniNumberfield',                            
                fieldLabel: '<t:message code="system.label.sales.selectedcount" default="건수(선택)"/>',                                           
                width: 160,
                labelWidth: 100,
                name: 'COUNT',
                readOnly: true,
                value: 0,
                hidden: true
            },{
                xtype: 'uniNumberfield',                            
                fieldLabel: '<t:message code="system.label.sales.selectedcount" default="건수(선택)"/>',                                           
                width: 160,
                labelWidth: 100,
                name: 'COUNT',
                readOnly: true,
                value: 0,
                hidden: true
            },{
                xtype: 'container',
                layout : {type : 'uniTable'},
                tdAttrs: {align: 'right'},  
                padding: '0 20 0 0',
                items:[{
                    xtype: 'button',
                    text: '<t:message code="system.label.sales.dishonoredsettle" default="부도처리"/>', 
                    id: 'CONFIRM_DATA2',
                    name: 'EXECUTE_TYPE',
                    //inputValue: '1',
                    width: 110,  
                    handler : function(records, grid, record) {
                        if(panelSearch.setAllFieldsReadOnly(true)){
                            //자동기표일 때 SP 호출
                            if(panelResult.getValue('COUNT') != 0){  
                                if(Ext.getCmp('rdo2').getChecked()[0].inputValue == '0'){
                                        var param = panelSearch.getValues();
                                        panelSearch.getEl().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
                                        sco330ukrvService.procButton(param, 
                                            function(provider, response) {
                                                if(provider) {  
                                                    UniAppManager.updateStatus('<t:message code="system.message.sales.aftersave002" default="완료되었습니다."/>');
                                                }
                                                console.log("response",response)
                                                panelSearch.getEl().unmask();
                                            }
                                        )
                                    return panelSearch.setAllFieldsReadOnly(true);
                                }
                                //기표취소일 때 SP 호출
                                if(Ext.getCmp('rdo2').getChecked()[0].inputValue == '1'){
                                        var param = panelSearch.getValues();
                                        panelSearch.getEl().mask('<t:message code="system.label.sales.loading" default="로딩중..."/>','loading-indicator');
                                        sco330ukrvService.cancButton(param, 
                                            function(provider, response) {
                                                if(provider) {  
                                                    UniAppManager.updateStatus('<t:message code="system.message.sales.datacheck015" default="취소되었습니다."/>');
                                                }
                                                console.log("response",response)
                                                panelSearch.getEl().unmask();
                                            }
                                        )
                                        return panelSearch.setAllFieldsReadOnly(true);
                                }
                            }else {
                                UniAppManager.updateStatus('<t:message code="system.message.sales.datacheck016" default="선택된 자료가 없습니다."/>');
                            }
                        }
                    }
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
                            var labelText = invalid.items[0]['fieldLabel']+' : ';
                        } else if(Ext.isDefined(invalid.items[0].ownerCt)) {
                            var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
                        }
    
                        Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
                        invalid.items[0].focus();
                    } else {
                        //this.mask();
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
                    //this.unmask();
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
        }/*,
        setLoadRecord: function()   {
            var me = this;          
            me.uniOpt.inLoading=false;
            me.setAllFieldsReadOnly(true);
        }*/
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid1 = Unilite.createGrid('sco330ukrvGrid1', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore1,
        features: [{
            id: 'masterGridSubTotal',
            ftype: 'uniGroupingsummary', 
            showSummaryRow: false 
        },{
            id: 'masterGridTotal',  
            ftype: 'uniSummary',      
            showSummaryRow: false
        }],
        uniOpt : {              
            useMultipleSorting  : true,     
            useLiveSearch       : false,    
            onLoadSelectFirst   : false,        
            dblClickToEdit      : true,    
            useGroupSummary     : true, 
            useContextMenu      : false,    
            useRowNumberer      : true, 
            expandLastColumn    : false,     
            useRowContext       : false,    
            filter: {           
                useFilter       : false,    
                autoCreate      : true  
            }           
        },
        selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: true, toggleOnClick: true,
            listeners: {  
                select: function(grid, selectRecord, index, rowIndex, eOpts ){
                    sumCheckedCount = sumCheckedCount + 1;
                    panelResult.setValue('COUNT', sumCheckedCount)
                },
                deselect:  function(grid, selectRecord, index, eOpts ){
                    sumCheckedCount = sumCheckedCount - 1;
                    panelResult.setValue('COUNT', sumCheckedCount)
                    selDesel = 0;
                }
            }
        }),
        columns: [         				
//			{dataIndex: 'CHOICE'             , width: 66 }, 				
			{dataIndex: 'DISHONOR_DATE'      , width: 80 },
			{dataIndex: 'COLLECT_NUM'        , width: 100 }, 				
			{dataIndex: 'COLLECT_SEQ'        , width: 50 },
			{dataIndex: 'COLLECT_TYPE'       , width: 80 , hidden: true}, 				
			{dataIndex: 'COLLECT_AMT'        , width: 100 },
			{dataIndex: 'NOTE_NUM'           , width: 100 }, 				
			{dataIndex: 'NOTE_TYPE'          , width: 80 },
			{dataIndex: 'PUB_CUST_CD'        , width: 66 , hidden: true}, 				
			{dataIndex: 'PUB_CUST_NM'        , width: 120 },
			{dataIndex: 'NOTE_PUB_DATE'      , width: 80 }, 				
			{dataIndex: 'PUB_PRSN'           , width: 100 },
			{dataIndex: 'NOTE_DUE_DATE'      , width: 80 }, 				
			{dataIndex: 'PUB_ENDOSER'        , width: 100 },
			{dataIndex: 'SAVE_CODE'          , width: 66 , hidden: true}, 				
			{dataIndex: 'SAVE_NAME'          , width: 120 },
			{dataIndex: 'AC_DATE'            , width: 66 , hidden: true}, 				
			{dataIndex: 'AC_NUM'             , width: 110 },
			{dataIndex: 'PROJECT_NO'         , width: 110 }, 				
			{dataIndex: 'BILL_NUM'           , width: 110 },
			{dataIndex: 'PUB_NUM'            , width: 110 }, 				
			{dataIndex: 'REMARK'             , width: 66, flex: 1 },
			{dataIndex: 'DIV_CODE'           , width: 66 , hidden: true}, 				
			{dataIndex: 'CUSTOM_CODE'        , width: 66 , hidden: true},
			{dataIndex: 'COLLECT_DATE'       , width: 66 , hidden: true}, 				
			{dataIndex: 'COLET_CUST_CD'      , width: 66 , hidden: true},
			{dataIndex: 'COLLECT_PRSN'       , width: 66 , hidden: true}, 				
			{dataIndex: 'COLLECT_DIV'        , width: 66 , hidden: true},
			{dataIndex: 'UPDATE_DB_USER'     , width: 66 , hidden: true}, 				
			{dataIndex: 'UPDATE_DB_TIME'     , width: 66 , hidden: true},
			{dataIndex: 'DEPT_CODE'          , width: 66 , hidden: true}, 				
			{dataIndex: 'TREE_NAME'          , width: 66 , hidden: true},
			{dataIndex: 'MONEY_UNIT'         , width: 66 , hidden: true}, 				
			{dataIndex: 'EXCHANGE_RATE'      , width: 66 , hidden: true},
			{dataIndex: 'SALE_PROFIT'        , width: 66 , hidden: true}, 				
			{dataIndex: 'EX_DATE'            , width: 66 , hidden: true},
			{dataIndex: 'EX_NUM'             , width: 66 , hidden: true}, 				
			{dataIndex: 'EX_SEQ'             , width: 66 , hidden: true},
			{dataIndex: 'AGREE_YN'           , width: 66 , hidden: true}, 				
			{dataIndex: 'BILL_DIV_CODE'      , width: 66 , hidden: true},
			{dataIndex: 'J_EX_NUM'           , width: 66 , hidden: true}, 				
			{dataIndex: 'J_EX_DATE'          , width: 66 , hidden: true},
			{dataIndex: 'J_AC_NUM'           , width: 66 , hidden: true}, 				
			{dataIndex: 'J_AC_DATE'          , width: 66 , hidden: true},
			{dataIndex: 'SORT_KEY'           , width: 66 , hidden: true}, 				
			{dataIndex: 'REF_CODE1'          , width: 66 , hidden: true}
		],
        listeners: { 
            beforeedit  : function( editor, e, eOpts ) {
                if(UniUtils.indexOf(e.field, ['DISHONOR_DATE'])) {
                    return true;
                } else {
                    return false;
                }
            }
        } 
    });	//End of   var masterGrid1 = Unilite.createGrid('sco330ukrvGrid1', {

    Unilite.Main( {
		border: false,
		borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                panelResult, masterGrid1
            ]   
        }       
        ,panelSearch 
        ], 
		id: 'sco330ukrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('COLLECT_PRSN','01');
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function() {		
			if(panelSearch.setAllFieldsReadOnly(true) == false){
                return false;
            }
            selDesel = 0;
            checkCount = 0;
            sumCheckedCount = 0;
            directMasterStore1.loadStoreRecords();
            UniAppManager.setToolbarButtons('reset',true);
		}
	}); //End of Unilite.Main( {

        Unilite.createValidator('validator01', {
        store: directMasterStore1,
        grid: masterGrid1,
        validate: function( type, fieldName, newValue, oldValue, record, eopt) {
            console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
            var rv = true;
            switch(fieldName) {
                case "DISHONOR_DATE" :   // 부도일
                    if(newValue <= record.get('COLLECT_DATE')) {
                        rv= '<t:message code="system.message.sales.message123" default="부도일이 수금일보다 이전입니다. 부도일을 확인하십시오."/>'; 
                    }
                break;
            }
            return rv;
        }
    })
};
</script>