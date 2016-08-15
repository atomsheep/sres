<span style='font-weight:bold;float:left;margin:0 10px;color:#0886AF'>
<a style='color:white;text-decoration: underline' href="${baseUrl}/user/">Home</a> >
Share Paper
</span>
<div style='clear:both'></div>

<h1 style='margin:20px 20px 0'>Share ${ICN}</h1>

<div class='info_text'>Select Students and click on share paper.</div>

<#if (students)?has_content>
<form id="resultsForm" method="post" action="">

    <div class="box info_text side1" style='padding:0;margin:20px;position:relative'>
        <h4 style='margin:0 0 20px;padding:10px;background:#043B4E;'>Students</h4>

        <div class='topPanel'>
            <!-- <a class='btn btn-default btn-primary' id="addKeyValue"  style='border-radius:0;padding:10px 10px 9px;border-right:1px solid #043B4E' href="${baseUrl}/user/sharePaper/${id}">
                <span class='fa fa-share-alt'></span> Share this paper
            </a> -->
            <button type="button" class="btn btn-default btn-primary btn-square left sharePaper"><span class="fa fa-share-alt"></span> Share ${ICN}</button>
        </div>

        <div style='position:absolute;top:80px;bottom:0;left:0;right:0;overflow-y:scroll'>
            <input name="id" type="hidden" value="${id}"/>
            <table id="studentList" width=100%>
                <tr>
                    <th style='text-align:left;border-left:none'><input type="checkbox" name="usernameAll" checked='checked'/>
                    </th>
                    <th style='text-align:left;'>User Name</th>
                    <th style='text-align:left;'>Email</th>
                </tr>
                <#list students as c>
                    <tr>
                        <td style='text-align:left;border-left:none'><input type="checkbox" name="students" checked='checked' value="${c._id}"/></td>
                        <td style='text-align:left;position:relative'>${c.username!}
                        </td>
                        <td style='text-align:left'>${c.email!}</td>                        
                    </tr>
                </#list>
            </table>
        </div>
    </div>
</form>
</#if>

<script type='text/javascript'>
 var ids={};
    $(function(){

        $('input[type=checkbox]').each(function (i, e) {
            var self = $(this);
            var newCheckbox = "";
            if (self.is(":checked")) {
                newCheckbox = "<span class='sres_checkbox fa fa-check-circle' id='"+self.val()+"'></span>";
            } else {
                newCheckbox = "<span class='sres_checkbox fa fa-circle-thin' id='"+self.val()+"'></span>";
            }
            if(self.val()!= "on"){
            	ids[self.val()]="off";
            }
            self.after(newCheckbox);
            self.css('display', 'none');
        });

        $(document).on('click', '.sres_checkbox', function () {
            var self = $(this);
             var i=0; 
             var checkboxArray=[];
             var arrayLength=0;
             var t=$(".sres_checkbox").get();
            
            if (self.hasClass('fa-check-circle')) {
                self.removeClass('fa-check-circle').addClass('fa-circle-thin');
                
                if(self.attr('id')!= "on"){
                delete ids[self.attr('id')];
                }else{
                delete ids[self.attr('id')];
                checkboxArray=document.getElementsByClassName('sres_checkbox');
                arrayLength = checkboxArray.length;
				for (i = 0; i < arrayLength; i++) {
	                if(checkboxArray[i].getAttribute('id')!= "on"){
    				    delete ids[checkboxArray[i].getAttribute('id')];
    				    checkboxArray[i].className='sres_checkbox fa fa-circle-thin';
    				}
				}
            } }else {
                self.addClass('fa-check-circle').removeClass('fa-circle-thin');
                if(self.attr('id')!= "on"){
                	ids[self.attr('id')]="off";
                }else{
				checkboxArray=document.getElementsByClassName('sres_checkbox');
                 arrayLength = checkboxArray.length;
				for (i = 0; i < arrayLength; i++) {	
				 if(checkboxArray[i].getAttribute('id')!= "on"){
                	ids[checkboxArray[i].getAttribute('id')]="off";
    				checkboxArray[i].className='sres_checkbox fa fa-check-circle';
                }
                }
		    }	
           }
            self.prev('input[type=checkbox]').click();
        });


		$('button.sharePaper').on('click', function () {
         var data=JSON.stringify(ids);

        $.post("${baseUrl}/user/sharePapers/${id}",
                {user_id:data},
                function (json) {
                    if (json.success) {
                        console.log("Paper were shared");

                 var p = $("<div></div>").appendTo("body");
                p.popup_simple('init', {
                    content: "Paper was shared successfully!<br/>",
                    extraClasses: ["sresPopup"],
                    confirm: true,
                    confirmCallback: function(){
                        $('[name=mapFieldsForm]').submit();
                    }
                }).popup_simple("show").popup_simple("centre");

                $('.popup_simple_confirm').addClass('btn btn-default btn-primary btn-square').css({
                    marginTop: "10px",
                    marginRight: "10px"
                }).text("Continue");
                    }
                else {
                console.log("Error occurred while sharing Paper");
                var p = $("<div></div>").appendTo("body");
                p.popup_simple('init', {
                    content: "Error occurred while sharing Paper! Please select alteast one paper to share.<br/>",
                    extraClasses: ["sresPopup"],
                    confirm: true,
                    confirmCallback: function(){
                        $('[name=mapFieldsForm]').submit();
                    }
                }).popup_simple("show").popup_simple("centre");

                $('.popup_simple_confirm').addClass('btn btn-default btn-primary btn-square').css({
                    marginTop: "10px",
                    marginRight: "10px"
                }).text("Continue");                  
                    }
         });
    });

        var top = $('.side1').offset().top;
        var height = $(window).height();
        var newHeight = height - top - (20);
       
        $('.side1').css("height", newHeight + "px");
    });
</script>