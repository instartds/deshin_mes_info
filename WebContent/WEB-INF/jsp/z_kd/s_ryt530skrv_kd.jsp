<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_ryt530skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_ryt530skrv_kd"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="WR01" /> <!--비율단가구분-->
    <t:ExtComboStore comboType="AU" comboCode="WR02" /> <!--프로젝트타입-->
    <t:ExtComboStore comboType="AU" comboCode="WR03" /> <!--작업반기-->
</t:appConfig>

<script type="text/javascript">

var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
    gsBalanceOut:        '${gsBalanceOut}'
};

function appMain() {

	var columns	= createGridColumn();
	var fields = createModelField();
	
	 var groupUrl = '${groupUrl}'; //그룹웨어 호출 url

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_ryt530skrv_kdService.selectList'
        }
    });

    Unilite.defineModel('s_ryt530skrv_kdModel', {
        fields: fields

    });

    var directMasterStore = Unilite.createStore('s_ryt530skrv_kdMasterStore',{
        model: 's_ryt530skrv_kdModel',
        uniOpt : {
            isMaster: true,          // 상위 버튼 연결
            editable: false,         // 수정 모드 사용
            deletable:false,         // 삭제 가능 여부
            useNavi : false          // prev | newxt 버튼 사용
        },
        expanded : false,
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {
            var param= panelResult.getValues();
            this.load({
                  params : param,
               // NEW ADD
    				callback: function(records, operation, success){
    					console.log(records);
    					if(success){
    						if(masterGrid.getStore().getCount() == 0){
    							Ext.getCmp('GW').setDisabled(true);
    						}else if(masterGrid.getStore().getCount() != 0){
    							UniBase.fnGwBtnControl('GW',directMasterStore.data.items[0].data.GW_FLAG);
    						}
    					}
    				}
    				//END
            });
        },
        listeners: {
            load:function( store, records, successful, operation, eOpts ) {

          		setColumnText();
            }
        }
//         ,
//         groupField: 'HIDDEN_ITEM_CODE'
    });

    //panelResult(검색조건)
    var panelResult = Unilite.createSearchForm('resultForm', {
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
                  fieldLabel: '사업장',
                  name:'DIV_CODE',
                  xtype: 'uniCombobox',
                  comboType:'BOR120',
                  allowBlank:false,
                  value: UserInfo.divCode
                },
                {
                	fieldLabel: '작업년도',
    				name: 'WORK_YEAR',
    				xtype: 'uniCombobox',
    				comboType : 'AU',
    			    comboCode : 'BS90',
    				holdable: 'hold',
    				value: new Date().getFullYear(),
    				allowBlank: false
      	    	  },
      	    	  {
          				fieldLabel	: '반기',
          				name		: 'WORK_SEQ',
          				xtype		: 'uniCombobox',
          				comboType	: 'AU',
          				comboCode	: 'Z004',
          				value:'1',
          				holdable: 'hold',
          				allowBlank: false
      				  },
                Unilite.popup('AGENT_CUST', {
                fieldLabel: '거래처',
                allowBlank:false,
                listeners: {
                    applyextparam: function(popup){
                        popup.setExtParam({
                            'DIV_CODE':   panelResult.getValue('DIV_CODE'),
                            'ADD_QUERY1': "A.CUSTOM_CODE IN ((SELECT CUSTOM_CODE FROM S_RYT100T_KD WHERE COMP_CODE = ",
                            'ADD_QUERY2': " AND DIV_CODE = ",
                            'ADD_QUERY3': "))"
                        });   //WHERE절 추가 쿼리


                    }
                }
            }) /*, {
                fieldLabel: '비율/단가',
                name: 'GUBUN1',
                xtype: 'uniCombobox',
                comboType: 'AU',
                comboCode: 'WR01',
                allowBlank:false
            } */
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
        },
        setLoadRecord: function(record) {
            var me = this;
            me.uniOpt.inLoading=false;
            me.setAllFieldsReadOnly(true);
        }
    });

    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    var masterGrid = Unilite.createGrid('s_ryt530skrv_kdmasterGrid', {
        layout : 'fit',
        region: 'center',
        store: directMasterStore,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
		features: [ {id : 'masterGridSubTotal',	ftype: 'uniGroupingsummary',	showSummaryRow: false },
					{id : 'masterGridTotal',	ftype: 'uniSummary',			showSummaryRow: true
		}],
        columns:  columns,
        tbar: [/* {
            id: 'GW_DRAFT',
            text: 'GW기안',
            handler: function() {
                alert('GW기안');
            }
        } */
        {
            itemId : 'GWBtn',
            id:'GW',
            iconCls : 'icon-referance'  ,
            text:'기안',
            handler: function() {
            	var param = panelResult.getValues();
            	param.DRAFT_NO = UserInfo.compCode + panelResult.getValue('WORK_YEAR') + panelResult.getValue('WORK_SEQ') + panelResult.getValue('CUSTOM_CODE');
            	if(confirm('기안 하시겠습니까?')) {
            		s_ryt530skrv_kdService.selectGwData(param, function(provider, response) {
            			if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
            				s_ryt530skrv_kdService.makeDraftNum(param, function(provider2, response)   {
                                UniAppManager.app.requestApprove();
                            });
                        } else {
                            alert('이미 기안된 자료입니다.');
                            return false;
                        }
                    });
            	}
            	UniAppManager.app.onQueryButtonDown();
            }
        }
        ],
        listeners: {

        }
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
        id  : 's_ryt530skrv_kdApp',
        fnInitBinding : function() {
            panelResult.clearForm();
            directMasterStore.clearData();
            this.setDefault();
        },
        onQueryButtonDown : function(){
        	if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
                
            }
            var param = {
				DIV_CODE : panelResult.getValue('DIV_CODE'),
				CUSTOM_CODE : panelResult.getValue('CUSTOM_CODE'),
				WORK_SEQ : panelResult.getValue('WORK_SEQ'),
				WORK_YEAR : panelResult.getValue('WORK_YEAR')
			}
			s_ryt540skrv_kdService.getMonthList(param , function(provider, response){
				if(!Ext.isEmpty(provider)){
					createStore_onQuery(provider);
//									createModelField(provider);
//									createGridColumn(provider);
				}
			})
           /* var param = panelResult.getValues();
            var monthDiff1 = '';
            var monthDiff2 = '';
            //M월 ~ M+6월 => CON_FR_YYMM ~ CON_TO_YYMM
            s_ryt530skrv_kdService.editMonth(param, function(provider, response) {
            	if(!Ext.isEmpty(provider)){
	                monthDiff1 = provider[0].CON_FR_YYMM;
	                monthDiff2 = provider[0].CON_TO_YYMM;
	                UniAppManager.app.setHiddenColumn(monthDiff1,monthDiff2);
            	}
            });
            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons('reset', true);*/
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            UniAppManager.setToolbarButtons('save', false);
            this.fnInitBinding();
        },
		setHiddenColumn : function(monthDiff1, monthDiff2) {
				var startOfMonth = Number(monthDiff1.substring(4, 6));
				var endOfMonth = Number(monthDiff2.substring(4, 6));

				if (startOfMonth <= 6) {
					if (startOfMonth == '1') {
						for (var i = 6; i < 12; i++) {
							var monthNo = 'MONTH' + (i + 1);
							masterGrid.getColumn(monthNo).setHidden(true);
						};
					} else if (startOfMonth > '1' && startOfMonth <= '6') {
						for (var i = 0; i < startOfMonth - 1; i++) {
							var monthNo = 'MONTH' + (i + 1);
							masterGrid.getColumn(monthNo).setHidden(true);
						};
						for (var i = endOfMonth - 1; i < 12; i++) {
							var monthNo = 'MONTH' + (i + 1);
							masterGrid.getColumn(monthNo).setHidden(true);
						};
					} else {
						return false;
					}
				} else if (startOfMonth > 6) {
					for (var i = 0; i < startOfMonth; i++) {
						var monthNo = 'MONTH' + (i + 1);
						masterGrid.getColumn(monthNo).setHidden(true);
					};
				} else {
					return false;
				}
			},
			setDefault : function() {
				panelResult.setValue('DIV_CODE', UserInfo.divCode);
				//            panelResult.setValue('FROM_MONTH',  Ext.Date.format(new Date(), 'Y') + "01");
				//            panelResult.setValue('TO_MONTH',    Ext.Date.format(new Date(), 'Y') + "12");
				panelResult.setValue('WORK_YEAR', new Date().getFullYear());
				panelResult.setValue('WORK_SEQ', '1');
				UniAppManager.setToolbarButtons('save', false);
			},
			requestApprove : function() { //결재 요청

				var winWidth = 1300;
				var winHeight = 750;

				var frm = document.f1;
				var compCode = UserInfo.compCode;
				var divCode = panelResult.getValue('DIV_CODE');
				var customCode = panelResult.getValue('CUSTOM_CODE');
				var workYear = panelResult.getValue('WORK_YEAR');
				var workSeq = panelResult.getValue('WORK_SEQ');
				var fromMonth = '';
				var toMonth = '';
				if (panelResult.getValue('WORK_SEQ') == '1') {
					fromMonth = panelResult.getValue('WORK_YEAR') + "0101";
					toMonth = panelResult.getValue('WORK_YEAR') + "0630";
				} else if (panelResult.getValue('WORK_SEQ') == '2') {
					fromMonth = panelResult.getValue('WORK_YEAR') + "0701";
					toMonth = panelResult.getValue('WORK_YEAR') + "1231";
				}
				var guBun1 = panelResult.getValue('GUBUN1');
				var guBun3 = panelResult.getValue('GUBUN3');
				if (guBun3 == true) {
					guBun3 = 'Y';
				} else {
					guBun3 = 'N';
				}
				//var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_RYT530SKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + customCode + "'"+ ', '+ "'" + workYear + "'"+ ', '+ "'" + workSeq  + "'" + ', ' + "'" + fromMonth + "'"+ ', ' + "'" + toMonth + "'"+ ', ' + "'" + guBun1 + "'"+ ', ' + "'" + guBun3 + "'";
				var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_RYT530SKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + customCode + "'"+ ', '+ "'" + workYear + "'"+ ', '+ "'" + workSeq  + "'" ;
				var spCall      = encodeURIComponent(spText);
				var gwurl = groupUrl + "&prg_no=s_ryt530skrv_kd&draft_no=" + UserInfo.compCode + panelResult.getValue('WORK_YEAR') + panelResult.getValue('WORK_SEQ') + panelResult.getValue('CUSTOM_CODE') + "&sp=" + spCall + "&viewMode=docuDraft&recv_yn="/* + Base64.encode()*/;
				UniBase.fnGw_Call(gwurl,frm,'GW');
//				panelResult.setValue('WORK_SEQ',   '1');

			}
		});
		
		function createModelField(monthList) {
    	
		var fields = [
			
            {name : 'COMP_CODE',            text : '법인코드',      type : 'string'},
            {name : 'DIV_CODE',             text : '사업장',       type : 'string', comboType : "BOR120"},
            {name : 'ITEM_CODE',            text : '품목코드',      type : 'string'},
            {name : 'ITEM_NAME',            text : '품목명',       type : 'string'},
            {name : 'SPEC',            		text : '품번',       type : 'string'},
            {name : 'SALE_CUSTOM_NAME',          text : '거래처명',      type : 'string'},
//            {name : 'HIDDEN_ITEM_CODE',     text : '품목코드',      type : 'string'},
//            {name : 'TOTAL',                text : '합계',        type : 'uniPrice'},
            {name : 'TOTAL_QTY',            text : '수량계',    type : 'uniPrice'},
            {name : 'TOTAL_AMT',            text : '금액계',    type : 'uniPrice'},
            {name : 'GUBUN',                text : '구분',        type : 'string'}
			
		];
		
		if(!Ext.isEmpty(monthList)){
			var mL = Object.values(monthList);
			mL.sort();
			for(var i=0; i<=5; i++){
				fields.push({name: 'MONTH'+ (i+1)    , text: mL[i].substring(0, 4)+'년'+mL[i].substring(4, 6)+'월',     type : 'uniPrice'});
			}
		}
		return fields;
	};
    function createGridColumn(monthList) {
    	
		var columns = [
			{dataIndex : 'COMP_CODE',       width : 120, hidden : true,style: {textAlign: 'center' }},
            {dataIndex : 'DIV_CODE',        width : 130, hidden : true,style: {textAlign: 'center' }},
            {dataIndex : 'ITEM_CODE',       width : 120,style: {textAlign: 'center' }},
            {dataIndex : 'ITEM_NAME',       width : 180,style: {textAlign: 'center' }},
            {dataIndex : 'SPEC',       		width : 120,style: {textAlign: 'center' },
      			summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
      			return Unilite.renderSummaryRow(summaryData, metaData, '', '<t:message code="system.label.sales.total" default="총계"/>');
      		}},
//             {dataIndex : 'SPEC',       		width : 120},
            {dataIndex : 'SALE_CUSTOM_NAME',     width : 180,style: {textAlign: 'center' }},
//             {dataIndex : 'TOTAL',           width : 110, summaryType: 'sum'},
//            {dataIndex : 'HIDDEN_ITEM_CODE',width : 120, hidden : true,style: {textAlign: 'center' }},
//            {dataIndex : 'TOTAL',       width : 110, summaryType: 'sum',style: {textAlign: 'center' }},
            {dataIndex : 'TOTAL_QTY',       width : 110, summaryType: 'sum',style: {textAlign: 'center' }},
            {dataIndex : 'TOTAL_AMT',       width : 110, summaryType: 'sum',style: {textAlign: 'center' }},
            {dataIndex : 'GUBUN',           width : 100, align : 'center',style: {textAlign: 'center' }}
        ];
		if(!Ext.isEmpty(monthList)){
			var mL = Object.values(monthList);
			mL.sort();
			for(var i=0; i<=5; i++){
				columns.push(
					{dataIndex: 'MONTH' + (i+1)    , text: mL[i].substring(0, 4)+'년'+mL[i].substring(4, 6)+'월',      width: 100  ,style: {textAlign: 'center' },align:'right', xtype:'uniNnumberColumn'  }// format: UniFormat.Qty,
				);
			}
		}
		
		return columns;
		
    }
    function createStore_onQuery(monthList) {
		var records, fields, columns
		fields	= createModelField(monthList);
		columns	= createGridColumn(monthList);
		directMasterStore.setFields(fields);
		masterGrid.setColumnInfo(masterGrid, columns, fields);
		masterGrid.reconfigure(directMasterStore, columns);
		directMasterStore.loadStoreRecords();
	}
	
	
	function setColumnText() {
		masterGrid.getColumn("COMP_CODE").setText("법인코드");    
		masterGrid.getColumn("DIV_CODE").setText("사업장");
		masterGrid.getColumn("ITEM_CODE").setText("품목코드");
		masterGrid.getColumn("ITEM_NAME").setText("품목명");
		masterGrid.getColumn("SPEC").setText("품번");
		masterGrid.getColumn("GUBUN").setText("구분");
		masterGrid.getColumn("SALE_CUSTOM_NAME").setText("거래처명");
//		masterGrid.getColumn("TOTAL").setText("합계");
		masterGrid.getColumn("TOTAL_QTY").setText("수량계");
		masterGrid.getColumn("TOTAL_AMT").setText("금액계");
	};
};
</script>
<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>