// @charset UTF-8

/**
 * @class Unilite.main.portal.MainPortalPanel
 * @extends Unilite.com.panel.portal.UniPortalPanel
 * Portal tab of Main view.
 */
Ext.define('Unilite.main.portal.MainPortalNotice', {
    extend: 'Unilite.com.panel.portal.UniPortalPanel',
    title: 'Portal',
    itemId: 'portal',
    id:'portalPage',
    uniOpt: {
       'prgID': 'portal',
       'title': 'Portal'
    },
    //requires: ['Unilite.com.panel.portal.UniPortalPanel'],
    closable: false,

    //abstract 
    getPortalItems: function() {
    	
var noticeWindow; // 이력등록팝업
    	
    	Unilite.defineModel('noticeModel', {
		    fields: [{name: 'COMP_CODE'    		,text:'COMP_CODE'	,type : 'string'}, 
					 {name: 'FROM_DATE'    		,text:'게시시작일'		,type : 'uniDate'},
					 {name: 'BULLETIN_ID'    	,text:'등록번호'		,type : 'string'},
					 {name: 'TO_DATE'    		,text:'게시종료일'		,type : 'uniDate'}, 
					 {name: 'USER_ID'    		,text:'게시자'		,type : 'string', allowBlank: false}, 
					 {name: 'TYPE_FLAG'    		,text:'게시유형'		,type : 'string', comboType: 'AU', comboCode: 'B602'}, 
					 {name: 'AUTH_FLAG'    		,text:'게시대상'		,type : 'string', comboType: 'AU', comboCode: 'B603'}, 
					 {name: 'DIV_CODE'    		,text:'사업장'		,type : 'string', comboType: 'BOR120'}, 
					 {name: 'DEPT_CODE'    		,text:'부서코드'		,type : 'string'},
					 {name: 'DEPT_NAME'    		,text:'부서'			,type : 'string'},
					 {name: 'OFFICE_CODE'   	,text:'영업소'		,type : 'string', comboType: 'AU', comboCode: 'GO01'}, 
					 {name: 'TITLE'    			,text:'제목'			,type : 'string', allowBlank: false}, 
					 {name: 'CONTENTS'    		,text:'내용'			,type : 'string'}, 
					 {name: 'ACCESS_CNT'    	,text:'조회횟수'		,type : 'int'}				 
				]
		});
    	
    	
    	var noticeStore =  Unilite.createStore('noticeStore',{
        	model: 'noticeModel',
         	autoLoad: false,
//         	storeId:
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            
	        proxy: {
	           type: 'direct',
	            api: {			
	                read: 'portalskrService.selectList'
	            }
	        },
			loadStoreRecords: function()	{				
				
				this.load();
			}
            
		});
    	
    	
    	var noticeGrid = Unilite.createGrid('noticeGrid', {
        layout : 'fit',
//        width:'100%',
//        flex:1,
        height:400,
    	region:'center',
        enableColumnHide :false,
        sortableColumns : false,
		uniOpt:{
            userToolbar:false,
			useRowNumberer: true,
        	expandLastColumn: false,
            useMultipleSorting: false,
            state: {
			   useState: false,   
			   useStateList: false  
			}
            
        },
    	store: noticeStore,
    	selModel:'rowmodel',
		columns:[{dataIndex: 'FROM_DATE'    	,width: 100},
				 {dataIndex: 'TO_DATE'    		,width: 100},
				 {dataIndex: 'USER_ID'    		,width: 100},
				 {dataIndex: 'TYPE_FLAG'    	,width: 100},
				 {dataIndex: 'AUTH_FLAG'    	,width: 100},
				 {dataIndex: 'DIV_CODE'    		,width: 130},
				 {dataIndex: 'DEPT_CODE'    	,width: 100, hidden: true},	
				 {dataIndex: 'DEPT_NAME'    	,width: 100},
				 {dataIndex: 'OFFICE_CODE'   	,width: 100, hidden:true},
				 {dataIndex: 'TITLE'    		,width: 300},
				 {dataIndex: 'CONTENTS'    		,flex:1}//,width: 300}				 
		]
		,listeners: {	
      		onGridDblClick:function(grid, record, cellIndex, colName) {
            	opennoticeWindow();
          	}
         }
   });
    	
   
	var noticeForm = Unilite.createForm('noticeForm',{    
        padding:'0 0 0 0',
        disabled: false,
        bodyPadding: 10,
        region: 'center',
        flex:1,
        items: [{
            title:'',
            xtype: 'fieldset',
            padding: '5 5 5 5',
            layout: {type : 'uniTable', columns : 1,
                tableAttrs: { width: '100%'}
            },
            items: [{
                xtype: 'container',
                layout: {type: 'uniTable', columns: 1
//                    tableAttrs: { width: '100%'},
//                    tdAttrs: {align : 'center'}
                },
                items: [{	    
					fieldLabel: '제목',
					name: 'TITLE',
					xtype: 'uniTextfield',
					width: 800,			
					colspan: 4,
					readOnly:true
				},{	    
					fieldLabel: '내용',
					name: 'CONTENTS',
					xtype: 'textareafield',
					width: 800,
					height: 380,
					colspan: 4,
					readOnly:true
				}]
            }]
        }]
    });   
   
    function opennoticeWindow() {          
        if(!noticeWindow) {
            noticeWindow = Ext.create('Ext.window.Window', {
                title: '공지사항',
    			closeAction:'hide',
                header: {
                    titleAlign: 'center'
                },
                width: 900,
                height: 500,
                layout: {type:'vbox', align:'stretch'},
                items: [noticeForm],
                listeners : {
                    show: function( panel, eOpts )	{
                    	var selectRecord = noticeGrid.getSelectedRecord();
                    	noticeForm.setValue('TITLE',selectRecord.get('TITLE'));
                    	noticeForm.setValue('CONTENTS',selectRecord.get('CONTENTS'));
                        Ext.getCmp('portalPage').getEl().mask('공지사항 상세...','loading-indicator');

					},
                    beforehide: function(me, eOpt)	{
//                    	noticeWindow = null;
                    },
                    beforeclose: function( panel, eOpts )	{
                        Ext.getCmp('portalPage').getEl().unmask();
                    }
                }       
            })
        }
        noticeWindow.center();
        noticeWindow.show();
    }
    
    
    	var itemCol1 = {
    			padding: '5 0 0 10',
                layout: {type : 'uniTable', columns:2,tableAttrs: { width: '100%'}},
	        items: [{
	            title: '공지사항',
	            layout: 'fit',
	            flex:1,
	            colspan:2,
   				padding: '1 1 1 1',
	            items: [noticeGrid]
	        },{
   				padding: '1 1 1 1',
	            title: 'Portlet 3',
	            html: 'Portlet 3'
	        },{
   				padding: '1 1 1 1',
	            title: 'Portlet 4',
	            html: 'Portlet 4'
	        }]
	    };
	    
	/*    var itemCol2 = {
	        items: [{
	            title: 'Portlet 2',
	            html: 'Portlet 2'
	        },{
	            title: 'Portlet 3',
	            html: 'Portlet 3'
	        }]
	    };*/
	    
	   /* var itemCol3 = {
//   		width:'50%',
//	    	flex:1,
	        items: [{
	            title: 'Portlet 4',
	            html: 'Portlet 4'
	        }]
	    };*/
	    
	    return [itemCol1]
    },
    
    //initialize
    initComponent: function() {
    	var me = this;
    	
    	Ext.apply(this, {
    		items: this.getPortalItems(),
    		listeners:{
    			'show':function(portalPanel, eOpts)	{
	    			var noticeStore = Ext.data.StoreManager.lookup("noticeStore");
//    				var noticeStore = Ext.getCmp('noticeStore')
	    			noticeStore.loadStoreRecords();

    			},
    			'hide':function(portalPanel, eOpts)	{
    				var aa= '';
    				var ab= '';
    				if(!Ext.isEmpty(this.items.noticeWindow)){
        				this.items.noticeWindow.close();
    				}

    			},
    			'close':function(portalPanel, eOpts)	{
    				var aa= '';
    				var ab= '';
//    				if(!Ext.isEmpty(getPortalItems().noticeWindow)){
//        				getPortalItems().noticeWindow.close();
//    				}

    			}
    		}
    	});
    		    
    	this.callParent();
    }
});