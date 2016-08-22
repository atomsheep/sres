<#assign tabs = ["Student list", "Data overview", "Interventions" ] />

<div style="margin-left:50px">
    <a href="${baseUrl}/user"><div style="background:#333;color:white" class="top_tab" data-tab="back"><div class="iris-left button_icon" style="margin-left:-5px;padding-top:5px"></div> Back</div></a>
<#list tabs as t>
    <div class="top_tab <#if t_index == 0>active</#if>" data-tab="${t_index}">${t}</div>
</#list>
    <div style="clear:both"></div>
</div>
<ul id="lightSlider" style="">
    <li class="slide">
        <div class="slideInner">
            <div id="studentData" style="position: absolute;overflow: hidden;top: 20px;bottom: 20px;left: 20px;right: 20px;"></div>
            <div id="options_panel" style="padding:20px;display:none;position: absolute;overflow: hidden;top: 20px;bottom: 20px;left: 20px;right: 20px;background:#367">
                <table style="width:100%;">
                    <tr>
                        <td style="vertical-align:bottom;padding-bottom:20px">
                            <h1 style='padding:0;margin:0 0 20px;'>
                                <span style="font-weight:300;color:#fff">List </span><span style="font-weight:500;color:#fff">options</span>
                            </h1>
                        </td>
                        <td style="vertical-align: bottom;text-align:right;vertical-align:bottom;padding-bottom:20px">
                            <div style="text-align:right;margin-bottom:20px">
                                <button id="options_button" type="button" class="paper_buttons" style="border:none;color:white;background:#367;float:right;padding:5px 10px">
                                    <div class="iris-delete paper_controls" style="margin-top:0"></div>
                                    <div class="paper_controls small_text" style="margin-bottom:0">Close</div>
                                </button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-size:32px;font-size:2vw;padding-left:20px;width:50%;color:#367;background:#fff">
                            Hide deselected students in list.
                        </td>
                        <td style="vertical-align: bottom;text-align:right;width:50%;background:white;">
                            <button id="hide_students" type="button" class="paper_buttons on_off" style="border:none;color:#367;background:#fff;float:right;padding:15px 30px;">
                                <div class="iris-off paper_controls" style="margin-top:0"></div>
                                <div class="paper_controls small_text" style="margin-bottom:0">Off</div>
                            </button>
                        </td>
                    </tr>
                </table>
            </div>
            <div id="filter_panel" style="padding:20px;display:none;position: absolute;overflow: hidden;top: 20px;bottom: 20px;left: 20px;right: 20px;background:#009590">
                <table style="width:100%">
                    <tr>
                        <td style="vertical-align:bottom">
                            <h1 style='padding:0;margin:0 0 20px;'>
                                <span style="font-weight:300;color:#fff">List </span><span style="font-weight:500;color:#fff">filters</span>
                            </h1>
                        </td>
                        <td style="vertical-align: bottom;text-align:right;vertical-align:bottom">
                            <div style="text-align:right;margin-bottom:20px">
                                <button id="filter_button" type="button" class="paper_buttons" style="border:none;color:white;background:#009590;float:right;padding:5px 10px">
                                    <div class="iris-delete paper_controls" style="margin-top:0"></div>
                                    <div class="paper_controls small_text" style="margin-bottom:0">Close</div>
                                </button>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </li>
    <li class="slide">
        <div class="slideInner">
            <div class="search_bar">
                <div class="iris-search text-icon"></div>
                <input type="text" class="iris-input" placeholder="Search"/>
                <div style="clear:both"></div>
            </div>
            <table class="paperList_table" style="margin-top:20px">
            <#if list?has_content>
                <#list list as l>
                    <tr>
                        <td style="background:#fdefbb">Owner</td>
                        <td style="background:#fdefbb">${l.code!}</td>
                        <td style="background:#fdefbb">${l.name!}</td>
                        <td style="background:#fdefbb">${l.year!}</td>
                        <td style="background:#fdefbb;border-right:10px solid #f1cf3d">${l.semester!}</td>
                        <td style="width:16%"><a href="#" class="paper_buttons"><div class="iris-lock paper_controls"></div><div class="paper_controls small_text">Request access</div></a></td>
                    </tr>
                </#list>
            </#if>
            </table>
        </div>
    </li>
    <li class="slide">
        <div class="slideInner">
            <h3>My profile</h3>
            <p>Lorem ipsum Excepteur amet adipisicing fugiat velit nisi.</p>
        </div>
    </li>
</ul>

<script type="text/javascript" src="https://www.google.com/jsapi"></script>

<script type="text/javascript">
    $(document).ready(function() {
        $("li","#lightSlider").css("height",($(document).height() - 50)+"px");
        var slider = $("#lightSlider").lightSlider({
            item : 1,
            pager : false,
            enableDrag : false,
            controls:false
        });

        $(document).on("click",".top_tab", function () {
            var self = $(this);
            var num = self.data("tab");
            slider.goToSlide(num);
            $('.top_tab.active').removeClass("active");
            self.addClass("active");
        });

        var timeout = null;
        $(document).on("mouseover",".paperList_table td",function(){
            $(this).parent("tr").find("td").addClass("highlight");
        }).on("mouseout",".paperList_table td",function(){
            $(this).parent("tr").find("td").removeClass("highlight");
        });

        $(document).on("mouseover",".studentField-td",function(){
            timeout = setTimeout(function(){
                $(".studentField-td").removeClass("not_shown");
                $("tr",".paperList_table").each(function(k,v){
                    $(".studentData-td",v).each(function(i,e){
                        if(i!=0)
                            $(this).addClass("not_shown");
                    });
                });
            },1000);
        }).on("mouseout", ".studentField-td", function(){
            clearTimeout(timeout);
            timeout = null;
        });

        $(document).on("mouseover",".studentData-td",function(){
            timeout = setTimeout(function(){
                $(".studentData-td").removeClass("not_shown");
                $("tr",".paperList_table").each(function(k,v){
                    $(".studentField-td",v).each(function(i,e){
                        if(i!=0)
                            $(this).addClass("not_shown");
                    });
                });
            },1000);
        }).on("mouseout", ".studentData-td", function(){
            clearTimeout(timeout);
            timeout = null;
        });

        $(document).on('click','.row_check:not(.master_check)',function(){
            var self = $(this);

            if(self.hasClass("off")){
                self.parent("tr").find("td").removeClass("td_disabled");
                self.removeClass("off");
                $("div",self).addClass("iris-check").removeClass("iris-circle");
            } else {
                self.parent("tr").find("td").addClass("td_disabled");
                self.addClass("off");
                $("div",self).removeClass("iris-check").addClass("iris-circle");
            }
            $('.studentCount').text($('.row_check:not(.master_check,.off)').length);
            if(hideDeselected)
                $('.td_disabled').addClass("hidden_td");
        });

        $(document).on("click","#options_button", function(){
            $("#options_panel").toggle("slide",{direction:"right"});
            $("#filter_panel").hide();
        });

        $(document).on("click","#filter_button", function(){
            $("#filter_panel").toggle("slide",{direction:"right"});
            $("#options_panel").hide();
        });

        var hideDeselected = false;

        $(document).on("click","#hide_students",function(){
            hideDeselected = !hideDeselected;
            if(hideDeselected)
                $(".td_disabled:not(.hidden_td)").addClass("hidden_td");
            else
                $(".td_disabled").removeClass("hidden_td");
        });

        $(document).on("click",".on_off", function(){
            var self = $(this);
            var icon = $(".paper_controls:not(.small_text)",self);
            if(icon.hasClass("iris-off")) {
                $(".paper_controls.small_text", self).text("On");
                icon.removeClass("iris-off").addClass("iris-on");
            } else {
                $(".paper_controls.small_text", self).text("Off");
                icon.removeClass("iris-on").addClass("iris-off");
            }
        });

        $.get("${baseUrl}/user/getStudentData/${paper._id}", function(data){
            $('#studentData').html(data);
        });
    });
</script>