(function($){

    var methods = {

        init : function(options){

            var settings = $.extend({

                classes : ['popup_simple'],
                extraClasses : [],
                content : "This is the default content",
                veil : true,
                veilColour : '#666',
                worker : false,
                confirm : false,
                cancel : false,
                confirmCallback : function(){},
                cancelCallback : function(){}

            },options);

            return this.each(function(){

                $.merge(settings.classes,settings.extraClasses);

                var self = $(this),
                    data = self.data('popup'),
                    popup = $("<div />").addClass(settings.classes.join(" ")),
                    confirm = $("<div class='popup_simple_confirm'>OK</div>"),
                    cancel = $("<div class='popup_simple_cancel'>Cancel</div>"),
                    worker = $("<div class='popup_simple_worker'/>");

                if(!data){

                    var zIndex = 5000;

                    if($(".popup_simple").length > 0)
                    {
                        $.each($(".popup_simple"), function(i,e){
                            zIndex = $(this).css('z-index');
                        });

                        zIndex += 2;
                    }

                    var veil = (settings.veil) ? $("<div class='popup_simple_veil'/>").css({
                        backgroundColor : settings.veilColour,
                        zIndex : zIndex
                        }) : null;

                    zIndex += 2;

                    popup.css({
                        zIndex : zIndex
                        }).append($("<div class='popup_simple_content'/>").append(settings.content))
                        .appendTo("body");

                    if(settings.confirm)
                    {
                        confirm.unbind('click').bind('click', function(){
                            settings.confirmCallback();
                            self.popup_simple('destroy');
                        });
                        popup.append(confirm);
                    }

                    if(settings.cancel)
                    {
                        cancel.unbind('click').bind('click', function(){
                            settings.cancelCallback();
                            self.popup_simple('destroy');
                        });
                        popup.append(cancel);
                    }

                    if(settings.worker) popup.append(worker);

                    $(this).data('popup',{
                        target : self,
                        popup : popup,
                        veil : veil,
                        confirm : confirm,
                        cancel : cancel,
                        worker : worker,
                        settings : settings
                    })
                }

            });

        },

        show : function(){

            return this.each(function(){

                var self = $(this),
                    data = self.data('popup');

                data.veil.appendTo('body').show();
                data.popup.fadeIn('fast');

            });

        },

        destroy : function(){

            return this.each(function(){

                var self = $(this),
                    data = self.data('popup');

                $.when(data.popup.fadeOut('fast')).then(function(){
                    data.popup.remove();
                });
                $.when(data.veil.fadeOut('fast')).then(function(){
                    data.veil.remove();
                    self.removeData('popup');
                    self.remove();
                });

            });

        },

        centre : function(type){

            return this.each(function(){

                var self = $(this),
                    data = self.data('popup');

                if(type == null)
                {
                    var width = data.popup.width() + 50;
                    data.popup.css({
                        width:width+'px',
                        top:document.documentElement.clientHeight/2 - data.popup.outerHeight()/2,
                        left:'50%',
                        marginLeft:(-(width/2))+'px'
                    });
                }
                else if(type == 'vertical')
                {
                    data.popup.css({
                        top:document.documentElement.clientHeight/2 - data.popup.outerHeight()/2
                    });
                }
                else if(type == 'horizontal')
                {
                    data.popup.css({
                        left:document.documentElement.clientWidth/2 - data.popup.outerWidth()/2
                    });
                }

            });

        },

        setContent : function(content){

            return this.each(function(){

                var self = $(this),
                    data = self.data('popup');

                data.popup.find('.popup_simple_content').html(content);

            });

        },

        setConfirm : function(bool,callback){

            return this.each(function(){

                var self = $(this),
                    data = self.data('popup');

                if(bool)
                {
                    data.worker.remove();
                    data.popup.append(data.confirm);

                    if(callback != null)
                    {
                        data.confirm.unbind('click').bind('click', function(){
                            callback();
                            self.popup_simple('destroy');
                        });
                    }
                    else
                    {
                        data.confirm.unbind('click').bind('click', function(){
                            data.settings.confirmCallback();
                            self.popup_simple('destroy');
                        });
                    }
                }

            })

        },

        setCancel : function(bool,callback){

            return this.each(function(){

                var self = $(this),
                    data = self.data('popup');

                if(bool)
                {
                    data.worker.remove();
                    data.popup.append(data.cancel);

                    if(callback != null)
                    {
                        data.cancel.unbind('click').bind('click', function(){
                            callback();
                            self.popup_simple('destroy');
                        });
                    }
                    else
                    {
                        data.cancel.unbind('click').bind('click', function(){
                            data.settings.cancelCallback();
                            self.popup_simple('destroy');
                        });
                    }
                }

            })

        },

        setWorker : function(bool,dfd){

                var self = $(this),
                    data = self.data('popup');

                if(bool)
                {
                    data.confirm.remove();
                    data.cancel.remove();
                    data.popup.append(data.worker);
                }
                else
                    data.worker.remove();

                return dfd;

        },

        addClasses : function(classArray){

            return this.each(function(){

                var self = $(this),
                    data = self.data('popup');

                var popup = data.popup;
                popup.addClass(classArray.join(" "));
            })

        },

        removeClasses : function(classArray){

            return this.each(function(){

                var self = $(this),
                    data = self.data('popup');

                var popup = data.popup;

                $.each(classArray, function(i,e){
                    popup.removeClass(e);
                });

            })

        }

    };

    $.fn.popup_simple = function(method){

        if(methods[method]){

            return methods[method].apply(this, Array.prototype.slice.call(arguments,1));

        }
        else if(typeof method === 'object' || !method){

            return methods.init.apply(this, arguments);

        }
        else{

            $.error('Method ' + method + ' does not exist.');

        }

    };

})(jQuery);