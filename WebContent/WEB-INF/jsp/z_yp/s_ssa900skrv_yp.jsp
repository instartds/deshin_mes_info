<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="s_ssa900skrv_yp"  >
    <t:ExtComboStore comboType="BOR120" pgmId="s_ssa900skrv_yp"  />          <!-- 사업장 -->
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
     Unilite.defineModel('S_ssa900skrv_ypModel1', {
    	  fields: [{name:	'RoNo'			    ,text: '매출번호'                   ,                type:'string'},
    				{name:	'ReceiptDate'	    ,text: '매출일'                    ,                type:'uniDate'},
    				{name:	'SaleCustNo'	    ,text: '매출처'                    ,                type:'string'},
    				{name:	'CustName'		    ,text: '매출처명'                   ,                type:'string'},
    				{name:	'YyyyMm'		    ,text: '년월'                     ,                type:'string', format:'YYYY.MM'},
    				{name:	'Week'		    ,text: '주차 '                   ,                type:'string'},
    				{name:	'DeptNo'			    ,text: '부서번호 '                 ,                type:'string'},
    				{name:	'EmpNo'			    ,text: '사원번호 '                 ,                type:'string'},
    				{name:	'RoKInd'			    ,text: 'RoKInd'                ,                type:'string'},
    				{name:	'RoType'			    ,text: 'RoType'                ,                type:'string'},
    				{name:	'SpecialNo'		    ,text: '공백'                    ,                type:'string'},
    				{name:	'BAFlag'			    ,text: 'BAFlag'                ,                type:'string'},
    				{name:	'BranchNo'		    ,text: 'BranchNo'              ,                type:'string'},
    				{name:	'DeliPostNo'		    ,text: '배송지우편번호 '              ,                type:'string'},
    				{name:	'DeliAddress1'	    ,text: '배송지주소1'                ,                type:'string'},
    				{name:	'DeliAddress2'	    ,text: '배송지주소2'                ,                type:'string'},
    				{name:	'DeliPhone'		    ,text: '배송지전화번호'               ,                type:'string'},
    				{name:	'DeliMobile'		    ,text: '배송지핸드폰번호'              ,                type:'string'},
    				{name:	'DeliClient'		    ,text: '배송지고객'                 ,                type:'string'},
    				{name:	'Remark'			    ,text: '비고'                    ,                type:'string'},
    				{name:	'SpecialClientName'	,text: 'SpecialClientName'                   ,                type:'string'},
    				{name:	'SpecialClientPhone',text: 'SpecialClientPhone'                   ,                type:'string'},
    				{name:	'SpecialClientMobile',text: 'SpecialClientMobile'                   ,                type:'string'},
    				{name:	'ConfirmPrint'		,text: 'ConfirmPrint'                   ,                type:'string'},
    				{name:	'ConfirmEmpNo'		,text: 'ConfirmEmpNo'                   ,                type:'string'},
    				{name:	'WorkFlagM'		 	,text: 'WorkFlagM'                  ,                type:'string'},
    				{name:	'SysKind'		 	,text: '시스템구분 '                ,                type:'string'},
    				{name:	'Dec'			  	,text: 'Dec'                   ,                type:'string'},
    				{name:	'DirectContractYN'	,text: 'DirectContractYN'      ,                type:'string'},
    				{name:	'liKind'			,text: 'DeliKind'              ,                type:'string'},
    				{name:	'Ratio'				,text: '단가책정 '                 ,                type:'string'},
    				{name:	'AUFlag'			,text: 'AUFlag'                ,                type:'string'},
    				{name:	'ClosingFlag'		,text: '마감여부'                  ,                type:'string'},
    				{name:	'RoTypeYN'			,text: 'RoTypeYN'                   ,                type:'string'},
    				{name:	'OrderNo'			,text: 'OrderNo'                   ,                type:'string'},
    				{name:	'AddEmpNo'			,text: '입력자'                   ,                type:'string'},
    				{name:	'AddDate'			,text: '입력일'                   ,                type:'uniDate'},
    				{name:	'UpdEmpNo'			,text: '수정자'                   ,                type:'string'},
    				{name:	'UpdDate'			,text: '수정일 '                  ,                type:'uniDate'},
    				{name:	'RoNo'				,text: '매출번호'                  ,                type:'string'},
    				{name:	'RoSeq'				,text: '매출순번 '                 ,                type:'string'},
    				{name:	'ItemNo'			,text: '매출품목 '                 ,                type:'string'},
    				{name:	'ItemName'			,text: '매출품목명 '                ,                type:'string'},
    				{name:	'RoQty'				,text: '매출량 '                  ,                type:'uniQty'},
    				{name:	'SalePrice'			,text: '매출단가'                  ,                type:'uniUnitPrice'},
    				{name:	'Amt'				,text: '매출액 '                  ,                type:'uniPrice'},
    				{name:	'UnitCd'			,text: 'UnitCd'                ,                type:'string'},
    				{name:	'GradeCd'			,text: 'GradeCd'               ,                type:'string'},
    				{name:	'VatYN'				,text: '부가세'                   ,                type:'uniPrice'},
    				{name:	'BfYN'				,text: 'BfYN'                  ,                type:'string'},
    				{name:	'StdInPrice'		,text: '표준입고단가 '               ,                type:'uniUnitPrice'},
    				{name:	'StdOutPrice'		,text: '표준출고단가 '               ,                type:'uniUnitPrice'},
    				{name:	'OrgOutNo'			,text: '출고번호'                  ,                type:'string'},
    				{name:	'OrgOutSeq'			,text: '출고순번 '                 ,                type:'string'},
    				{name:	'ReturnRes'			,text: '반품요청내용'                ,                type:'string'},
    				{name:	'Sort'              ,text: '정렬'                    ,                type:'string'},
    				{name:	'BranchPrice'		,text: 'BranchPrice'           ,                type:'uniPrice'},
    				{name:	'AgentPrice'		,text: 'AgentPrice'            ,                type:'uniPrice'},
    				{name:	'HandleFlag'		,text: 'HandleFlag'            ,                type:'string'},
    				{name:	'SaleConfirmFlag'	,text: '매출확정'                  ,                type:'string'},
    				{name:	'InPrice'			,text: 'InPrice'               ,                type:'uniPrice'},
    				{name:	'TenderPrice'		,text: 'TenderPrice'           ,                type:'uniPrice'},
    				{name:	'OriginCd'			,text: '원산지코드'                 ,                type:'string'},
    				{name:	'CertiKind'			,text: '인증서구분'                 ,                type:'string'},
    				{name:	'SaleConfirmQty'	,text: '매출확정량 '                ,                type:'uniQty'},
    				{name:	'ReturnQty'			,text: '반품량 '                  ,                type:'uniQty'},
    				{name:	'ReturnStatus'		,text: '반품상태'                  ,                type:'string'},
    				{name:	'OrgRoNo'			,text: '원매출순번 '                ,                type:'string'},
    				{name:	'OrgRoSeq'			,text: '원매출순번 '                ,                type:'string'},
    				{name:	'ClosingFlag'		,text: '마감구분'                  ,                type:'string'},
    				{name:	'CloseDate'			,text: '마감일 '                  ,                type:'uniDate'},
    				{name:	'CloseEmpNo'		,text: '마감담당자'                 ,                type:'string'},
    				{name:	'CloseRoQty'		,text: '마감매출량 '                ,                type:'uniQty'},
    				{name:	'BuyCustNo'			,text: '매입처'                   ,                type:'string'},
    				{name:	'BuyCustName'		,text: '매입처명 '                 ,                type:'string'},
    				{name:	'AddEmpNo'			,text: '입력자'                   ,                type:'string'},
    				{name:	'AddDate'			,text: '입력일'                   ,                type:'uniDate'},
    				{name:	'UpdEmpNo'			,text: '수정자 '                  ,                type:'string'},
    				{name:	'UpdDate'			,text: '수정일  '                 ,                type:'uniDate'}]
    	    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore1 = Unilite.createStore('s_ssa900skrv_ypMasterStore1',{
        model: 'S_ssa900skrv_ypModel1',
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
                   read: 's_ssa900skrv_ypService.selectList1'
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
            hidden:true,
            allowBlank: false,
            listeners: {
                change: function(combo, newValue, oldValue, eOpts) {
                    combo.changeDivCode(combo, newValue, oldValue, eOpts);
                }
            }
        },
        Unilite.popup('AGENT_CUST',{
            fieldLabel: '매출처',
//            extParam: {'CUSTOM_TYPE': '3'},
            valueFieldName: 'SALE_CUSTOM_CODE',
            textFieldName: 'SALE_CUSTOM_NAME',
    		validateBlank: false,
            listeners: {
				onValueFieldChange: function(field, newValue){

				},
				onTextFieldChange: function(field, newValue){

				},

                applyextparam: function(popup){
                   popup.setExtParam({'AGENT_CUST_FILTER':  ['3']});
                   popup.setExtParam({'CUSTOM_TYPE':  ['3']});
                }
            }
        }),{
            fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
            width: 315,
            xtype: 'uniDateRangefield',
            allowBlank: false,
            startFieldName: 'RECEIPT_DATE_FR',
            endFieldName: 'RECEIPT_DATE_TO',
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

    var masterGrid = Unilite.createGrid('s_ssa900skrv_ypGrid1', {
        // for tab
        region: 'center',
        //layout: 'fit',
        syncRowHeight: false,
        store: directMasterStore1,
        features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
                    {id: 'masterGridTotal',     ftype: 'uniSummary',  showSummaryRow: false} ],
                    columns:  [
               				{ dataIndex: 'RoNo'               ,	  width: 150, align:'center'},  // 매출번호
               				{ dataIndex: 'ReceiptDate'        ,   width: 100},  // 매출일
               				{ dataIndex: 'SaleCustNo'         ,   width: 100},  // 매출처
               				{ dataIndex: 'CustName'           ,   width: 150},  // 매출처명
               				{ dataIndex: 'YyyyMm'             ,   width: 100, align:'center'},  // 년월
               				{ dataIndex: 'Week'               ,   width: 50, align:'center'},  // 주차
               				{ dataIndex: 'DeptNo'             ,   width: 100},  // 부서번호
               				{ dataIndex: 'EmpNo'              ,   width: 100},  // 사원번호
               				{ dataIndex: 'RoKInd'             ,   width: 100},  // RoKInd
               				{ dataIndex: 'RoType'             ,   width: 100},  // RoType
               				{ dataIndex: 'SpecialNo'          ,   width: 100, hidden:true},  // 공백
               				{ dataIndex: 'BAFlag'             ,   width: 100},  // BAFlag
               				{ dataIndex: 'BranchNo'           ,   width: 100},  // BranchNo
               				{ dataIndex: 'DeliPostNo'         ,   width: 100, align:'center'},  // 배송지우편번매
               				{ dataIndex: 'DeliAddress1'       ,   width: 250},  // 배송지주소1
               				{ dataIndex: 'DeliAddress2'       ,   width: 200},  // 배송지주소2
               				{ dataIndex: 'DeliPhone'          ,   width: 120},  // 배송지전화번호
               				{ dataIndex: 'DeliMobile'         ,   width: 120},  // 배송지핸드폰번호
               				{ dataIndex: 'DeliClient'         ,   width: 100},  // 배송지고객
               				{ dataIndex: 'Remark'             ,   width: 200},  // 비고
               				{ dataIndex: 'SpecialClientName'  ,   width: 100, hidden:true},  // 값없음
               				{ dataIndex: 'SpecialClientPhone' ,   width: 120, hidden:true},  // 값없음
               				{ dataIndex: 'SpecialClientMobile',   width: 120, hidden:true},  // 값없음
               				{ dataIndex: 'ConfirmPrint'       ,   width: 100, hidden:true},  // 값없음
               				{ dataIndex: 'ConfirmEmpNo'       ,   width: 100, hidden:true},  // 값없음
               				{ dataIndex: 'WorkFlagM'          ,   width: 100, hidden:true},  // 값없음
               				{ dataIndex: 'SysKind'            ,   width: 100},  // 시스템구분
               				{ dataIndex: 'Dec'                ,   width: 80, align:'center'},  // Dec
               				{ dataIndex: 'DirectContractYN'   ,   width: 100, align:'center'},  // DirectContractYN
               				{ dataIndex: 'liKind'             ,   width: 100},  // DeliKind
               				{ dataIndex: 'Ratio'              ,   width: 100},  // 단가책정
               				{ dataIndex: 'AUFlag'             ,   width: 100, align:'center'},  // AUFlag
               				{ dataIndex: 'ClosingFlag'        ,   width: 100, align:'center'},  // 마감여부
               				{ dataIndex: 'RoTypeYN'           ,   width: 100, hidden:true},  // 값없음
               				{ dataIndex: 'OrderNo'            ,   width: 100, hidden:true},  // 값없음
               				{ dataIndex: 'AddEmpNo'           ,   width: 100, hidden:true},  // 입력자
               				{ dataIndex: 'AddDate'            ,   width: 100, hidden:true},  // 입력일
               				{ dataIndex: 'UpdEmpNo'           ,   width: 100, hidden:true},  // 수정자
               				{ dataIndex: 'UpdDate'            ,   width: 100, hidden:true},  // 수정일
               				{ dataIndex: 'RoNo'               ,   width: 150, hidden:true},  // 매출번호
               				{ dataIndex: 'RoSeq'              ,   width: 100, align:'center'},  // 매출순번
               				{ dataIndex: 'ItemNo'             ,   width: 100},  // 매출품목
               				{ dataIndex: 'ItemName'           ,   width: 170},  // 매출품목명
               				{ dataIndex: 'RoQty'              ,   width: 60},  // 매출량
               				{ dataIndex: 'SalePrice'          ,   width: 100},  // 매출단가
               				{ dataIndex: 'Amt'                ,   width: 100},  // 매출액
               				{ dataIndex: 'UnitCd'             ,   width: 100},  // UnitCd
               				{ dataIndex: 'GradeCd'            ,   width: 100},  // GradeCd
               				{ dataIndex: 'VatYN'              ,   width: 100},  // 부가세
               				{ dataIndex: 'BfYN'               ,   width: 100, align:'center'},  // BfYN
               				{ dataIndex: 'StdInPrice'         ,   width: 100},  // 표준입고단가
               				{ dataIndex: 'StdOutPrice'        ,   width: 100},  // 표준출고단가
               				{ dataIndex: 'OrgOutNo'           ,   width: 100},  // 출고번호
               				{ dataIndex: 'OrgOutSeq'          ,   width: 100},  // 출고순번
               				{ dataIndex: 'ReturnRes'          ,   width: 100},  // 반품요청내용
               				{ dataIndex: 'Sort'               ,   width: 100, align:'center'},  // 정렬
               				{ dataIndex: 'BranchPrice'        ,   width: 100},  // BranchPrice
               				{ dataIndex: 'AgentPrice'         ,   width: 100},  // AgentPrice
               				{ dataIndex: 'HandleFlag'         ,   width: 100, align:'center'},  // HandleFlag
               				{ dataIndex: 'SaleConfirmFlag'    ,   width: 100},  // 매출확정
               				{ dataIndex: 'InPrice'            ,   width: 100},  // InPrice
               				{ dataIndex: 'TenderPrice'        ,   width: 100},  // TenderPrice
               				{ dataIndex: 'OriginCd'           ,   width: 100},  // 원산지코드
               				{ dataIndex: 'CertiKind'          ,   width: 100},  // 인증서구분
               				{ dataIndex: 'SaleConfirmQty'     ,   width: 100},  // 매출확정량
               				{ dataIndex: 'ReturnQty'          ,   width: 100},  // 반품량
               				{ dataIndex: 'ReturnStatus'       ,   width: 100},  // 반품상태
               				{ dataIndex: 'OrgRoNo'            ,   width: 100},  // 원매출순번
               				{ dataIndex: 'OrgRoSeq'           ,   width: 100},  // 원매출순번
               				{ dataIndex: 'ClosingFlag'        ,   width: 100},  // 마감구분
               				{ dataIndex: 'CloseDate'          ,   width: 100},  // 마감일
               				{ dataIndex: 'CloseEmpNo'         ,   width: 100},  // 마감담당자
               				{ dataIndex: 'CloseRoQty'         ,   width: 100},  // 마감매출량
               				{ dataIndex: 'BuyCustNo'          ,   width: 100},  // 매입처
               				{ dataIndex: 'BuyCustName'        ,   width: 100},  // 매입처명
               				{ dataIndex: 'AddEmpNo'           ,   width: 100, hidden:true},  // 입력자
               				{ dataIndex: 'AddDate'            ,   width: 100, hidden:true},  // 입력일
               				{ dataIndex: 'UpdEmpNo'           ,   width: 100, hidden:true},  // 수정자
               				{ dataIndex: 'UpdDate'            ,   width: 100, hidden:true}   // 수정일
               		]
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
            panelResult.setValue('RECEIPT_DATE_FR', UniDate.get('today'));
            panelResult.setValue('RECEIPT_DATE_TO', UniDate.get('today'));


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
