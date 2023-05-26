<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep840skr"  >
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>

<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
//  ↑ 파일uplod용 plupload.full.js파일 include
</script>
<script type="text/javascript" >



var htmlViewWindow;


function appMain() {
   /** Model 정의 
    * @type 
    */
    Unilite.defineModel('aep840skrModel', {
        fields: [ 
            {name: 'COMP_CODE'				, text: '(숨김)법인코드'				, type: 'string'  },
            {name: 'WRITE_DATE'				, text: '작성일자'						, type: 'uniDate' },
            {name: 'DOC_TYPE'				, text: '(숨김)문서유형'				, type: 'string'  },
            {name: 'DOC_TYPE_NM'			, text: '문서유형'						, type: 'string'  },
            {name: 'DOC_SUBJECT'            , text: '문서제목'                 	, type: 'string'  },
            {name: 'DOC_DESCRIPTION'		, text: '문서내역'						, type: 'string'  },
            {name: 'TOTAL_AMOUNT'			, text: '금액'						, type: 'uniPrice'},
            {name: 'USER_ID_NAME'			, text: '작성자'						, type: 'string'  },
            {name: 'DOC_STATUS'				, text: '(숨김)결재상태'				, type: 'string'  },
            {name: 'DOC_STATUS_NM'			, text: '결재문서'						, type: 'string'  },
            {name: 'APPR_MANAGE_NO'			, text: '결재번호'						, type: 'string'  },
            {name: 'SLIP_NO'				, text: '(숨김)경비전표연계'				, type: 'string'  },
            {name: 'ACCNT'					, text: '(숨김)이체지급확정연계1'			, type: 'string'  },
            {name: 'ORG_AC_DATE'			, text: '(숨김)이체지급확정연계2'			, type: 'string'  },
            {name: 'ORG_SLIP_NUM'			, text: '(숨김)이체지급확정연계3'			, type: 'string'  },
            {name: 'ORG_SLIP_SEQ'			, text: '(숨김)이체지급확정연계4'			, type: 'string'  },
            {name: 'SEQ'					, text: '(숨김)이체지급확정연계5'			, type: 'string'  },
            {name: 'DIVERT_SMT_NUM'			, text: '(숨김)예산전용,추경,이월연계'		, type: 'string'  },
			{name: 'ELEC_SLIP_NO'			, text: 'ELEC_SLIP_NO'				, type: 'string'  }
        ]
    });

    Unilite.defineModel('tModel2', {
        fields: [
             {name: 'html_document'             ,text:'html'        ,type : 'string'} 
        ]
    });

    Unilite.defineModel('aep840skrSubModel1', {
        fields: [
            {name: 'RNUM'       		,text: 'No.'		,type: 'string'},
            {name: 'APD_APP_TYPE_NM'	,text: '구분'			,type: 'string'},
            {name: 'APD_APP_ID_NAME'    ,text: '결재자'		,type: 'string'},
            {name: 'APD_APP_DEPT' 		,text: '부서'			,type: 'string'},
            {name: 'APD_APP_ST_NM'		,text: '결재여부'		,type: 'string'},
            {name: 'APD_APP_DT' 		,text: '결재일시'		,type: 'string'},
            {name: 'APD_APP_COMMENT'	,text: '의견'			,type: 'string'}
        ]
    });

    
    
   /** Store 정의(Service 정의)
    * @type 
    */               
    var masterStore = Unilite.createStore('aep840skrDetailStore',{
        model	: 'aep840skrModel',
        uniOpt	: {
            isMaster	: true,			// 상위 버튼 연결 
            editable	: false,		// 수정 모드 사용 
            deletable	: false,		// 삭제 가능 여부 
            useNavi		: false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy	: {
            type: 'direct',
            api	: {          
                read: 'aep840skrService.selectList'                  
            }
        },
        loadStoreRecords : function()   {
            var param			= [];            
			param.PERSON_NUMB	= UserInfo.personNumb;
            console.log( param );
            this.load({
                params : param
            });
        }
   });
   
	var htmlStore =  Unilite.createStore('tStore',{
        model: 'tModel2',
        autoLoad: true ,
        uniOpt : {
            isMaster: false,            // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable:false,            // 삭제 가능 여부 
            useNavi : false         // prev | next 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
                read: 'jbillCommonService.getHtml'                 
            }
        },
        loadStoreRecords: function(record)    {
        	var param= {'APPR_MANAGE_NO': record.get('APPR_MANAGE_NO')};
            this.load({params: param});
        }
    });

    var directSubStore1 = Unilite.createStore('aep840skrSubStore1', {
        model: 'aep840skrSubModel1',
        uniOpt: {
            isMaster: false,         // 상위 버튼 연결 
            editable: false,            // 수정 모드 사용 
            deletable: false,           // 삭제 가능 여부 
            allDeletable:false,
            useNavi : false         // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                read: 'jbillCommonService.selectSubList1'                 
            }
        },
        
        loadStoreRecords: function(record){
            var param= {'APPR_MANAGE_NO': record.get('APPR_MANAGE_NO')};
            console.log( param );
            this.load({
                params: param
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

    
    
    
    /** Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('aep840skrGrid', {
        store: masterStore,
        region: 'center',
        layout: 'fit',
        uniOpt: {
            useGroupSummary		: false,
            useLiveSearch		: true,
            useContextMenu		: false,
            useMultipleSorting	: true,
            onLoadSelectFirst	: false,
            useRowNumberer		: true,
            expandLastColumn	: true,
            useRowContext		: false,
            state: {
                useState		: true,         
                useStateList	: true      
            }
        },
        features: [{
            id		: 'masterGridSubTotal',
            ftype	: 'uniGroupingsummary',
            showSummaryRow: false                       
        },{
            id		: 'masterGridTotal',
            ftype	: 'uniSummary',
            showSummaryRow: false
        }],
        tbar: [],
        columns: [
            {dataIndex: 'COMP_CODE'				, width: 150		, hidden: true},
            {dataIndex: 'DOC_TYPE'				, width: 120		, hidden: true},
            {dataIndex: 'DOC_TYPE_NM'			, width: 120},
            {dataIndex: 'DOC_SUBJECT'           , width: 200},
            {dataIndex: 'DOC_DESCRIPTION'		, width: 400},
            {dataIndex: 'USER_ID_NAME'			, width: 140},
            {dataIndex: 'WRITE_DATE'			, width: 120}
//            {dataIndex: 'TOTAL_AMOUNT'			, width: 150		, hidden: true},
//            {dataIndex: 'DOC_STATUS'			, width: 200		, hidden: true},
//            {dataIndex: 'DOC_STATUS_NM'			, width: 150},
//            {dataIndex: 'APPR_MANAGE_NO'		, width: 120}
        ],                     
        listeners: {
        	beforeedit: function(editor, e){      		
        	} ,
            onGridDblClick: function(grid, record, cellIndex, colName) {
            	directSubStore1.loadStoreRecords(record);
//            	directSubStore2.loadStoreRecords();
                htmlStore.loadStoreRecords(record);

                Ext.getCmp('subTitleNo').update('No. '	+ record.get('APPR_MANAGE_NO'));
                subViewForm2.setValue('DOC_TYPE'		, record.get('DOC_TYPE'));				//문서유형	-> 문서유형
                subViewForm2.setValue('USER_ID_NAME'	, record.get('USER_ID_NAME'));			//작성자	-> 작성자
                subViewForm2.setValue('WRITE_DATE'		, record.get('WRITE_DATE'));			//작성일	-> 작성일자
                subViewForm2.setValue('DOC_SUBJECT'		, record.get('DOC_SUBJECT'));			//문서제목	-> 제목
                subViewForm2.setValue('ELEC_SLIP_NO'	, record.get('ELEC_SLIP_NO'));			//전표번호	-> SAP전표
                
//                buttonStore.clearData();
//                record.phantom = true;
//                buttonStore.insert(i, record);

                openHtmlViewWindow();
                
            }
    	}
    });
    
    
    
    var subViewForm1 = Unilite.createSimpleForm('subViewForm1',{
        region: 'north',
        layout : {type : 'uniTable', columns : 2,
//        tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'},
         tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'/*,align : 'left'*/}
        },
        border:false,
        items: [{
            xtype		: 'component',
            margin		: '0 0 0 10',
            html		: '결재문서내역',
            componentCls: 'component-text_title_first',
            tdAttrs		: {align : 'left'}
        },{
            xtype		: 'component',
            id			: 'subTitleNo',
            padding		: '5 5 0 5',
            html		: null,
            componentCls: 'component-text_title_second',
            tdAttrs		: {align : 'right'},
            width		: 200
        }]
        
    }); 
    
    var subViewForm2 = Unilite.createSimpleForm('subViewForm2',{
        region	: 'center',
        padding	: '0 0 0 0',
        margin	: '0 0 0 0',
        layout	: {type : 'uniTable', columns : 1
//        tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'},
//         tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'/*,align : 'left'*/}
        },
        border	: false,
//        height:300,
//      split:true,
        items	: [{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            border:true,
            padding:'0 1 1 1',
            items:[{
                title: '',
                xtype: 'fieldset',
                id: 'fieldset1',
                padding: '10 5 5 5',
                margin: '0 0 0 0',
                width: 705,  
                defaults: {readOnly: true, xtype: 'uniTextfield'},
                layout: {type: 'uniTable' , columns: 2},
                items: [{
                    fieldLabel	: '시스템구분',
                    name		: 'SYS_GUBUN',
                    value		: '전자전표',
                    width		: 320
    //                readOnly:true
                   /* style: {
                        borderColor: 'red',
                        borderStyle: 'solid'
                    }*/
                },{
                    fieldLabel	: '문서유형',
		            xtype		: 'uniCombobox',
		            comboType	: 'AU',
		            comboCode	: 'J647',
                    name		: 'DOC_TYPE',
                    width		: 320
                },{
                    fieldLabel	: '작성자',
                    name		: 'USER_ID_NAME',
//                    value		: '김종욱',
                    width:320
                },{
                    fieldLabel	: '작성일자',
                	xtype		: 'uniDatefield',
                    name		: 'WRITE_DATE',
                    width		: 320
                },{
                    fieldLabel	: '제목',
                    name		: 'DOC_SUBJECT',
//                    value		: '09월_재무팀_여비교통비_시내교통비1111111',
                    width		: 320
                },{
                    fieldLabel	: '전표번호',
                    name		: 'ELEC_SLIP_NO',
//                    value		: '8000117883',
                    width		: 320
                },{
                    xtype	: 'container',
                    layout	: {type : 'uniTable', columns : 1},
                    colspan	: 2,
                    items	: [{
                        xtype	: 'grid',
                        id		: 'subGrid1',
                        store	: directSubStore1,
                        width	: 693,
                        columns: [
                            { dataIndex: 'RNUM'					,text: 'No.'		,type: 'string'		,width:40		,align:'center'},
                            { dataIndex: 'APD_APP_TYPE_NM'		,text: '구분'			,type: 'string'		,width:60		,align:'center'},
                            { dataIndex: 'APD_APP_ID_NAME'		,text: '결재자'		,type: 'string'		,width:100		,align:'center'},
                            { dataIndex: 'APD_APP_DEPT'			,text: '부서'			,type: 'string'		,width:120		,align:'left'		,style: 'text-align:center'},
                            { dataIndex: 'APD_APP_ST_NM'		,text: '결재여부'		,type: 'string'		,width:100		,align:'center'},
                            { dataIndex: 'APD_APP_DT'			,text: '결재일시'		,type: 'string'		,width:140		,align:'center'},
                            { dataIndex: 'APD_APP_COMMENT'		,text: '의견'			,type: 'string'		,width:160		,align:'center'}
                        ]
                    }]
                }/*,{
                    xtype	: 'container',
                    layout	: {type : 'uniTable', columns : 1},
                    colspan	: 2,
                    items	: [{
                        xtype	: 'grid',
                        id		: 'subGrid2',
                        store	: directSubStore2,
                        width	: 693,
                        columns	: [
                            { dataIndex: 't11'		,text: 'No.'		,type: 'string'		,width:40		,align:'center'},    
                            { dataIndex: 't22'		,text: '구분'			,type: 'string'		,width:60		,align:'center'},     
                            { dataIndex: 't33'		,text: '결재자'		,type: 'string'		,width:100		,align:'center'},    
                            { dataIndex: 't44'		,text: '부서'			,type: 'string'		,width:120		,align:'left'		,style: 'text-align:center'},      
                            { dataIndex: 't55'		,text: '결재여부'		,type: 'string'		,width:100		,align:'center'},    
                            { dataIndex: 't66'		,text: '결재일시'		,type: 'string'		,width:110		,align:'center'},    
                            { dataIndex: 't77'		,text: '의견'			,type: 'string'		,width:160		,align:'center'}     
                        ]     
                    }]
                }*/]
            }]
        }]
    }); 
    
    var htmlView = Ext.create('Ext.view.View', {
        store	: htmlStore,
        region	: 'south',
        width	: 705,
		tpl		: '<tpl for=".">'+
             		'<span class="data-source" ><div class="x-view-item-focused x-item-selected">' +                        
            		'{html_document}</div></span>'+
             	  '</tpl>',
        itemSelector: 'div.data-source '
    });
    
    var fileForm = Unilite.createSimpleForm('fileForm',{
        region: 'south',
        disabled:false,
//      split:true,
        items: [{
            xtype: 'container',
            layout: {type : 'uniTable', columns : 1},
            width:705,
            id:'uploadDisabled',
            disabled:true,
            tdAttrs: {align : 'center'},
            items :[{
                xtype: 'xuploadpanel',
                width:705,
                bbar: ['->',{
//                    id: 'aaaaaa',
                    text: '조회',
                    handler: function() {
                        
                        UniAppManager.app.fileUploadLoad();
                        
                   /*   var fp = fileForm.down('xuploadpanel');                 //mask on
                        fp.getEl().mask('로딩중...','loading-indicator');
                        var fileNO = fileForm.getValue('FILE_NO');
                        aep100ukrService.getFileList({DOC_NO : fileNO},              //파일조회 메서드  호출(param - 파일번호) 
                            function(provider, response) {                          
                                fp.loadData(response.result);                       //업로드 파일 load해서 보여주기
                                fp.getEl().unmask();                                //mask off
//                                UniAppManager.setToolbarButtons('save',false);      //저장버튼 비활성화
                            }
                         )*/
                    }
                },{
//                    id: 'bbbb',
                    text: '저장',
                    handler: function() {
                        var fp = fileForm.down('xuploadpanel'); 
                        var addFiles = fp.getAddFiles();                
                        var removeFiles = fp.getRemoveFiles();
                        fileForm.setValue('ADD_FID', addFiles);                  //추가 파일 담기
                        fileForm.setValue('DEL_FID', removeFiles);               //삭제 파일 담기
                        var param= fileForm.getValues();
                        fileForm.getEl().mask('로딩중...','loading-indicator'); //mask on
                        fileForm.getForm().submit({                              //폼 submit 함수 호출
                             params : param,
                             success : function(form, action) {
                                UniAppManager.updateStatus(Msg.sMB011);             //저장되었습니다.(message) 
//                                UniAppManager.setToolbarButtons('save',false);      //저장버튼 비활성화
                                fileForm.getEl().unmask();                       //mask off
                             }
                        });
                    }
                }],
                height: 150,
                flex: 0,
                padding: '0 0 0 0',
                listeners : {
                    change: function() {
//                        UniAppManager.app.setToolbarButtons('save', true);  //파일 추가or삭제시 저장버튼 on
                    }
                }
            },{
                xtype:'uniTextfield',
                fieldLabel: 'FILE_NO',          
                name:'FILE_NO',
                value: '',                //임시 파일 번호
                readOnly:true,
                hidden:true
            } ,{
                xtype:'uniTextfield',
                fieldLabel: '삭제파일FID'   ,       //삭제 파일번호를 set하기 위한 hidden 필드
                name:'DEL_FID',
                readOnly:true,
                hidden:true
            },{
                xtype:'uniTextfield',
                fieldLabel: '등록파일FID'   ,       //등록 파일번호를 set하기 위한 hidden 필드
                name:'ADD_FID',
                readOnly:true,
                hidden:true
            }]
        }],
        api: {
             load: 'aep830skrService.getFileList',   //조회 api
             submit: 'aep830skrService.saveFile'      //저장 api
        }
    });  
    
    function openHtmlViewWindow() {          
        if(!htmlViewWindow) {
            htmlViewWindow = Ext.create('widget.uniDetailWindow', {
                title		: '전자결재 - 결재 문서 VIEW',
                width		: 730,  
                minWidth	: 730,
                maxWidth	: 730,
                height		: '100%',
                autoScroll	: true,
                padding		: '1 1 1 1',
                layout		: {type:'vbox', align:'stretch'},
//                layout : {type : 'uniTable', columns : 1
//                    tableAttrs: { /*style: 'border : 1px solid #ced9e7;',*/width: '100%'},
//         tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/width: '100%'/*,align : 'left'*/}
                
//                },
                items		: [subViewForm1,subViewForm2,fileForm,htmlView],
                tbar		: [
                    '->',{
                        itemId : 'closeBtn',
                        text: '닫기',
                        handler: function() {
                            htmlViewWindow.hide();
//                          draftNoGrid.reset();
//                          draftNoSearch.clearForm();
                        },
                        disabled: false
                    }
                ],
                listeners : {
                    beforeshow: function ( panel, eOpts ) {
                    },
                    show: function ( panel, eOpts ) {
                    },
                    beforehide: function(me, eOpt)  {
                    },
                    beforeclose: function( panel, eOpts )   {
                    }
                }
            })
        }
        htmlViewWindow.center();
        htmlViewWindow.show();
    }
     

    
    Unilite.Main( {
    	id			: 'aep840skrApp',
        borderItems	: [{
            region	: 'center',
            layout	: 'border',
            border	: false,
            items	: [
                masterGrid
            ]
        }], 
	    fnInitBinding : function() {
	        UniAppManager.setToolbarButtons(['reset', 'newData', 'save', 'delete'], false);
			masterStore.loadStoreRecords();
        },
        
        onQueryButtonDown : function()   {
            masterStore.loadStoreRecords();
        }
   });
};
</script>