<%@page language="java" contentType="text/html; charset=utf-8"%>
<script type="text/javascript" >
/* File Created: June 14, 2013 */
/* Author : Sebastian */
/* http://tittylouis.blogspot.ca/2013/06/extjs-multiple-file-upload-control.html */
Ext.define("YourApp.view.util.Multiupload", {
    extend: 'Ext.form.Panel',
    border: 0,
    alias: 'widget.multiupload',
    margins: '2 2 2 2',
    accept: ['pdf', 'jpg', 'png', 'gif', 'doc', 'docx', 'xls', 'xlsx', 'bmp', 'tif', 'zip'],
    fileslist: [],
    frame: false,
    items: [
        {
            xtype: 'filefield',
            buttonOnly: true,
            listeners: {
                change: function (view, value, eOpts) {
                    //  alert(value);
                    var parent = this.up('form');
                    parent.onFileChange(view, value, eOpts);
                }
            }

        }

    ],
    onFileChange: function (view, value, eOpts) {
        // debugger;
        var fileNameIndex = value.lastIndexOf("/") + 1;
        if (fileNameIndex == 0) {
            fileNameIndex = value.lastIndexOf("\\") + 1;
        }
        var filename = value.substr(fileNameIndex);

        var IsValid = this.fileValidiation(view, filename);
        if (!IsValid) {
            return;
        }


        this.fileslist.push(filename);
        var addedFilePanel = Ext.create('Ext.form.Panel', {
            frame: false,
            border: 0,
            padding: 2,
            margin: '0 10 0 0',
            layout: {
                type: 'hbox',
                align: 'middle'
            },
            items: [

                {
                    xtype: 'button',
                    text: null,
                    border: 0,
                    frame: false,
                    iconCls: 'icon-fileupload-button-delete',
                    tooltip: 'Remove',
                    listeners: {
                        click: function (me, e, eOpts) {
                            var currentform = me.up('form');
                            var mainform = currentform.up('form');
                            var lbl = currentform.down('label');
                            mainform.fileslist.pop(lbl.text);
                            mainform.remove(currentform);
                            currentform.destroy();
                            mainform.doLayout();
                        }
                    }
                },
                {
                    xtype: 'label',
                    padding: 5,
                    listeners: {
                        render: function (me, eOpts) {
                            me.setText(filename);
                        }
                    }
                },
                {
                    xtype: 'image',
                    src: CPATH+'/resources/css/icons/icon-file-attach.png'

                }
            ]
        });

        var newUploadControl = Ext.create('Ext.form.FileUploadField', {
            buttonOnly: true,
            listeners: {
                change: function (view, value, eOpts) {

                    var parent = this.up('form');
                    parent.onFileChange(view, value, eOpts);
                }
            }
        });
        view.hide();
        addedFilePanel.add(view);
        this.insert(0, newUploadControl);
        this.add(addedFilePanel);


        // alert(filename);
    },

    fileValidiation: function (me, filename) {

        var isValid = true;
        var indexofPeriod = me.getValue().lastIndexOf("."),
            uploadedExtension = me.getValue().substr(indexofPeriod + 1, me.getValue().length - indexofPeriod);
        if (!Ext.Array.contains(this.accept, uploadedExtension)) {
            isValid = false;
            // Add the tooltip below to 
            // the red exclamation point on the form field
            me.setActiveError('Please upload files with an extension of :  ' + this.accept.join() + ' only!');
            // Let the user know why the field is red and blank!
            Ext.MessageBox.show({
                title: 'File Type Error',
                msg: 'Please upload files with an extension of :  ' + this.accept.join() + ' only!',
                buttons: Ext.Msg.OK,
                icon: Ext.Msg.ERROR
            });
            // Set the raw value to null so that the extjs form submit
            // isValid() method will stop submission.
            me.setRawValue(null);
            me.reset();
        }

        if (Ext.Array.contains(this.fileslist, filename)) {
            isValid = false;
            me.setActiveError('The file ' + filename + ' already added!');
            Ext.MessageBox.show({
                title: 'Error',
                msg: 'The file ' + filename + ' already added!',
                buttons: Ext.Msg.OK,
                icon: Ext.Msg.ERROR
            });
            // Set the raw value to null so that the extjs form submit
            // isValid() method will stop submission.
            me.setRawValue(null);
            me.reset();
        }


        return isValid;
    }
});


	var testForm = Ext.create('Unilite.com.form.UniDetailForm', {
		id:'testForm',
		//title: 'file upload',
		disabled:false,
		layout: {  type: 'hbox',
				columns : 1,
				tableAttrs: {style: {}},
				tdAttrs : { style: {'border':'1px solid #f00' }}
		
		},
        renderTo: Ext.getBody(),
       dockedItems :[{
	        xtype: 'toolbar',
	        dock: 'top',
	        items: [{
	            text: 'submit'
	            , handler : function() { 
					var frm = this.up('form');//)Ext.getCmp('testForm').getForm();
					var dat =  frm.getValues();
					console.log( "submit", dat);
					frm.submit();
	            }
	        }]
	      }],
        items: [{
	              xtype: 'multiupload',
	              name: 'file01',
	              fieldLabel: '파일',
	              validateOnChange: false,
	              validateOnBlur : false
	         }]
         
	})
</script>