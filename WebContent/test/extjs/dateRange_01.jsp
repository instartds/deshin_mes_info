<%@page language="java" contentType="text/html; charset=utf-8"%> 
<script type="text/javascript" src='<c:url value="/app/Extensible/Extensible.js" />' ></script>
<script type="text/javascript" >
	Ext.Loader.setConfig({
		enabled : true,
		scriptCharset : 'UTF-8',
		paths: {
            	"Ext.ux": '${CPATH }/app/Ext/ux',
            	"Unilite": '${CPATH }/app/Unilite',
            	"Extensible": '${CPATH }/app/Extensible'
        }
	});
	
	Ext.require([
	    '*',
	    'Ext.ux.grid.FiltersFeature',
	    'Ext.ux.DataTip',
	    'Extensible.form.field.DateRange',
	    'Extensible.Date'
	]);

	
Ext.onReady(function()
{	
	
	 	
	 var frm =Unilite.createSearchForm('searchForm', {
	 	tbar : [
	 		{ xtype: 'button', text: 't1',
		 		handler: function() {
		 			alert("Date = " + UniDate.get('yesterday'));
		 		}
	 		},
	 		{ xtype: 'button', text: 'get t1 and set drange 3',
		 		handler: function() {
		 			var frm = this.up('form')
		 			var t1 = frm.getValue('t1');
		 			
		 			frm.setValues({'END_FR_DATE2': UniDate.get('startOfMonth', t1), 
		 						  'END_TO_DATE3': UniDate.get('endOfMonth', t1)
		 			});
		 		}
	 		},
	 		{ xtype: 'button', text: 'str:20130726',
		 		handler: function() {
		 			alert("Date = " +  UniDate.get('yesterday', '20130726') );
		 		}
	 		}
	 	],
		items : [  
			{xtype:'uniDateRangefield',
	               startDate: UniDate.get('startOfMonth'),
	               endDate: UniDate.get('today'),
				fieldLabel : 'Date Range 1'
			},
			{xtype:'uniDatefield',
				value : '2014-01-01',
				fieldLabel : 'Date '
			},
			{xtype:'uniDatefield',
				fieldLabel : 'Date t1',
				name: 't1'
			},
			{xtype:'uniDateRangefield',
                startFieldName: 'END_FR_DATE',
                endFieldName: 'END_TO_DATE',
				fieldLabel : 'Date Range 2'
			},				
			{
	            xtype: 'extensible.daterangefield',
	            itemId: this.id + '-dates',
	            name: 'dates',
	            anchor: '95%',
	            singleLine: true,
	            fieldLabel: this.datesLabelText
	        },{xtype:'uniDateRangefield',
                startFieldName: 'END_FR_DATE2',
                endFieldName: 'END_TO_DATE3',
				fieldLabel : 'Date Range 3'
			}]
	});
	
	Ext.create('Ext.Viewport',{
			renderTo : Ext.getBody(),
			items:[frm ]
	});
})
</script>