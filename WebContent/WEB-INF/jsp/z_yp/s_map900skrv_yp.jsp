<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="s_map900skrv_yp"  >
    <t:ExtComboStore comboType="BOR120" pgmId="s_map900skrv_yp"  />          <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
    <t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->
    <t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->
    <t:ExtComboStore comboType="AU" comboCode="S007" /> <!--출고유형-->
    <t:ExtComboStore comboType="AU" comboCode="S024" /> <!--국내:부가세유형-->
    <t:ExtComboStore comboType="AU" comboCode="S118" /> <!--해외:부가세유형-->
    <t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목유형-->
    <t:ExtComboStore comboType="AU" comboCode="S003" /> <!--단가구분-->
    <t:ExtComboStore comboType="AU" comboCode="B031"  opts= '1;5'/> <!--생성경로-->
    <t:ExtComboStore comboType="AU" comboCode="B059" /> <!--과세여부-->
    <t:ExtComboStore comboType="AU" comboCode="S024" /> <!--부가세유형-->
</t:appConfig>

<script type="text/javascript" >

function appMain() {
    /**
     *   Model 정의
     * @type
     */
     Unilite.defineModel('S_map900skrv_ypModel1', {
    	  fields: [{name:  'PoNo'				,text:'매입번호'	,	  type:'string'},
    	           {name:  'PoDate'			,text:		'매입일',       type:'uniDate'},
    	           {name:  'PoConfirmYn'	,text:	'매입확정',          type:'string'},
    	           {name:  'PoKind'			,text:		'PoKind',     type:'string'},
    	           {name:  'PoConfirmDate'	,text:		'매입확정일',    type:'uniDate'},
    	           {name:  'SpecialKind'		,text:	'SpecialKind',               type:'string'},
    	           {name:  'DeptNo'			,text:		'부서',                    type:'string'},
    	           {name:  'EmpNo'		    ,text:		'사원번호',                  type:'string'},
    	           {name:  'AddEmpNo'		,text:		'입력자',                   type:'string'},
    	           {name:  'AddDate'			,text:	'입력일',                       type:'uniDate'},
    	           {name:  'UpdEmpNo'		,text:		'수정자',                    type:'string'},
    	           {name:  'UpdDate'			,text:	'수정일',                       type:'uniDate'},
    	           {name:  'PoNo'			    ,text:		'매입번호',                  type:'string'},
    	           {name:  'PoSeq'			,text:		'매입순번',                   type:'string'},
    	           {name:  'Sort'		    ,text:		'정렬순번',                   type:'string'},
    	           {name:  'itemNo'			,text:		'매입품목',                   type:'string'},
    	           {name:  'ItemName'		,text:'매입품목명',                         type:'string'},
    	           {name:  'PoQty'			,text:		'매입량',                    type:'uniQty'},
    	           {name:  'Remark'			,text:		'비고',                     type:'string'},
    	           {name:  'AddEmpNo'		,text:		'입력자',                    type:'string'},
    	           {name:  'AddDate'			,text:		'입력일',                    type:'uniDate'},
    	           {name:  'UpdEmpNo'		,text:		'수정자',                    type:'string'},
    	           {name:  'UpdDate'			,text:		'수정일',                    type:'uniDate'},
    	           {name:  'PoNo'			    ,text:		    '매입번호',               type:'string'},
    	           {name:  'PoSeq'			,text:		'매입순번',                   type:'string'},
    	           {name:  'itemNo'			,text:		'매입품목',                  type:'string'},
    	           {name:  'ChangeSeq'		    ,text:	'변경순번',                      type:'string'},
    	           {name:  'ChangeItemNo'	    ,text:	'변경품목',                      type:'string'},
    	           {name:  'ChangeItemName'	,text:	'변경품목명',                     type:'string'},
    	           {name:  'BuyCustNo'		    ,text:		'매입처',                   type:'string'},
    	           {name:  'CustName'		    ,text:	'매입처명',                      type:'string'},
    	           {name:  'VatYN'			,text:		'부가세',                   type:'string'},
    	           {name:  'PoQty2'			,text:	'실매입량',                       type:'uniQty'},
    	           {name:  'BuyPrice'		    ,text:		'매입단가',                   type:'uniUnitPrice'},
    	           {name:  'BuyAmt'			,text:		'매입금액',                   type:'uniPrice'},
    	           {name:  'InQty'			    ,text:		'입고량',                    type:'uniQty'},
    	           {name:  'InFlag'			,text:		'입고구분',                   type:'string'},
    	           {name:  'InReqDate'		,text:		'입고요청일',                  type:'uniDate'},
    	           {name:  'BarCode'			,text:	'바코드',                       type:'string'},
    	           {name:  'Remark'			,text:		'비고',                     type:'string'},
    	           {name:  'AddEmpNo'		,text:		'입력자',                   type:'string'},
    	           {name:  'AddDate'			,text:		'입력일',                   type:'uniDate'},
    	           {name:  'UpdEmpNo'		,text:		'수정자',                   type:'string'},
    	           {name:  'UpdDate'			,text:		'수정일',                   type:'uniDate'}]
    	    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore1 = Unilite.createStore('s_map900skrv_ypMasterStore1',{
        model: 'S_map900skrv_ypModel1',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결
            editable: false,            // 수정 모드 사용
            deletable: false,           // 삭제 가능 여부
            useNavi: false          // prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                   read: 's_map900skrv_ypService.selectList1'
            }
        }
        ,loadStoreRecords: function()   {
            var param= panelResult.getValues();

            console.log( param );
            this.load({
                params: param
            });
        }
    });



    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
            fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
            name: 'DIV_CODE',
            xtype: 'uniCombobox',
            comboType: 'BOR120',
            value: UserInfo.divCode,
            allowBlank: false,
            hidden:true,
            listeners: {
                change: function(combo, newValue, oldValue, eOpts) {
                    combo.changeDivCode(combo, newValue, oldValue, eOpts);
                }
            }
        },
        Unilite.popup('AGENT_CUST',{
            fieldLabel: '매입처',
//            extParam: {'CUSTOM_TYPE': '3'},
            valueFieldName: 'BUY_CUST_NO',
            textFieldName: 'BUY_CUST_NAME',
    		validateBlank: false,
            listeners: {
				onValueFieldChange: function(field, newValue){

				},
				onTextFieldChange: function(field, newValue){

				},

                applyextparam: function(popup){
                   // popup.setExtParam({'AGENT_CUST_FILTER':  ['3']});
                  //  popup.setExtParam({'CUSTOM_TYPE':  ['3']});
                }
            }
        }),{
            fieldLabel: '매입일',
            width: 315,
            xtype: 'uniDateRangefield',
            allowBlank: false,
            startFieldName: 'PO_DATE_FR',
            endFieldName: 'PO_DATE_TO',
            //startDate: UniDate.get('startOfMonth'),
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),
            onStartDateChange: function(field, newValue, oldValue, eOpts) {

            },
            onEndDateChange: function(field, newValue, oldValue, eOpts) {

            }
         }
        ],
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

                    alert(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
                    invalid.items[0].focus();
                }
            }
            return r;
        }
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */

    var masterGrid = Unilite.createGrid('s_map900skrv_ypGrid1', {
        // for tab
        region: 'center',
        //layout: 'fit',
        syncRowHeight: false,
        store: directMasterStore1,
        features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
                    {id: 'masterGridTotal',     ftype: 'uniSummary',  showSummaryRow: false} ],
	                  columns:  [	{ dataIndex: 'PoNo'			  ,	  width: 150, align:'center'},   //		매입번호
										{ dataIndex: 'PoDate'		 ,   width: 100},    //		매입일
										{ dataIndex: 'PoConfirmYn'	  ,   width: 80, align:'center'},   //		매입확정
										{ dataIndex: 'PoKind'		 ,   width: 100, align:'center'},    //		PoKind(공통코드 찾아야 함)
										{ dataIndex: 'PoConfirmDate' ,   width: 100},    //		매입확정일
										{ dataIndex: 'SpecialKind'    ,   width: 100, hidden:true},   //		'SpecialKind'
										{ dataIndex: 'DeptNo'		 ,   width: 100, hidden:true},    //		부서
										{ dataIndex: 'EmpNo'		 ,   width: 100, hidden:true},    //		사원번호
										{ dataIndex: 'AddEmpNo'		  ,   width: 100, hidden:true},   //		입력자
										{ dataIndex: 'AddDate'		  ,   width: 100, hidden:true},   //		입력일
										{ dataIndex: 'UpdEmpNo'		  ,   width: 100, hidden:true},   //		수정자
										{ dataIndex: 'UpdDate'		  ,   width: 100, hidden:true},   //		수정일
										{ dataIndex: 'PoNo'			  ,   width: 80, hidden:true, align:'center'},   //		매입번호
										{ dataIndex: 'PoSeq'		 ,   width: 80, align:'center'},    //		매입순번
										{ dataIndex: 'Sort'			  ,   width: 80, align:'center'},   //		정렬순번
										{ dataIndex: 'itemNo'		 ,   width: 100},    //		매입품목
										{ dataIndex: 'ItemName'		  ,   width: 150},   //	매입품목명
										{ dataIndex: 'PoQty'		 ,   width: 100},    //		매입량
										{ dataIndex: 'Remark'		 ,   width: 200},    //		비고
										{ dataIndex: 'AddEmpNo'		  ,   width: 100, hidden:true},   //		입력자
										{ dataIndex: 'AddDate'		  ,   width: 100, hidden:true},   //			입력일
										{ dataIndex: 'UpdEmpNo'		  ,   width: 100, hidden:true},   //		수정자
										{ dataIndex: 'UpdDate'		 ,   width: 100, hidden:true},   //			수정일
										{ dataIndex: 'PoNo'		      ,   width: 100, hidden:true},   //		    매입번호
										{ dataIndex: 'PoSeq'		 ,   width: 100, hidden:true},    //		매입순번
										{ dataIndex: 'itemNo'		 ,   width: 100, hidden:true},    //		매입품목
										{ dataIndex: 'ChangeSeq'	 ,   width: 80, align:'center'},    //	변경순번
										{ dataIndex: 'ChangeItemNo'	  ,   width: 100},   //	변경품목
										{ dataIndex: 'ChangeItemName' ,   width: 150},   //	변경품목명
										{ dataIndex: 'BuyCustNo'	  ,   width: 100},   //		매입처
										{ dataIndex: 'CustName'		  ,   width: 150},   //	매입처명
										{ dataIndex: 'VatYN'		 ,   width: 80, align:'center'},    //		부가세
										{ dataIndex: 'PoQty2'		 ,   width: 100},    //	실매입량
										{ dataIndex: 'BuyPrice'		  ,   width: 100},   //		매입단가
										{ dataIndex: 'BuyAmt'		 ,   width: 100},    //		매입금액
										{ dataIndex: 'InQty'		 ,   width: 100},    //		입고량
										{ dataIndex: 'InFlag'		 ,   width: 80, align:'center'},    //		입고구분
										{ dataIndex: 'InReqDate'	 ,   width: 100},    //		입고요청일
										{ dataIndex: 'BarCode'		  ,   width: 100},   //		바코드
										{ dataIndex: 'Remark'		 ,   width: 200, hidden:true},    //		비고
										{ dataIndex: 'AddEmpNo'		  ,   width: 100, hidden:true},   //		입력자
										{ dataIndex: 'AddDate'		  ,   width: 100, hidden:true},   //			입력일
										{ dataIndex: 'UpdEmpNo'		  ,   width: 100, hidden:true},   //		수정자
										{ dataIndex: 'UpdDate'		  ,   width: 100, hidden:true}]   //			수정일
    });
    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                masterGrid, panelResult
            ]
        }],
        fnInitBinding: function() {

            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('PO_DATE_FR', UniDate.get('today'));
            panelResult.setValue('PO_DATE_TO', UniDate.get('today'));


        },
        onQueryButtonDown: function()   {
            if(!panelResult.setAllFieldsReadOnly(true)){
                return false;
            }
            directMasterStore1.loadStoreRecords();


        },
        onResetButtonDown: function() {
            panelResult.clearForm();
            masterGrid.getStore().loadData({})
            this.fnInitBinding();

        }
    });

};


</script>
