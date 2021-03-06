<div style='margin-top:-10px'>

    <div class="gridster">
        <ul>
            <li class='sres_panel' data-row="1" data-col="3" data-sizex="1" data-sizey="1" style='padding:20px;font-size:22px;font-weight:300'>
                ${SRES_INTRO_TEXT}
            </li>

            <li class='sres_panel' data-row="2" data-col="3" data-sizex="1" data-sizey="3">
                <h4 class='panelHeader' style='cursor:default;'>User profile</h4>
                <form action='${baseUrl}/user/saveProfile' method='post'>
                    <div class='topPanel'>
                        <button type='submit' class='btn btn-default btn-primary btn-square right'>
                            <span></span> Save profile</button>
                    </div>
                    <div style='position:absolute;top:80px;bottom:0;left:0;right:0;overflow-y:scroll;padding:5px'>
                        <div class='input-group input-group1' style="width:100%;margin-bottom:5px" disabled='disabled'>
                            <span class='input-group-addon sres_name' style='width:150px'>Username:</span>
                            <input type="text" class="form-control userName" value="${user.username!}" disabled='disabled'/>
                            <input type="hidden" class="form-control userName" name="userName" value="${user.username!}" />
                        </div>
                        <div class='input-group input-group2' style="width:100%;margin-bottom:5px">
                            <span class='input-group-addon sres_name' style='width:150px'>First name:</span>
                            <input type="text" class="form-control firstName" name="firstName" <#if user.firstName?has_content>value="${user.firstName}"</#if>/>
                        </div>
                        <div class='input-group input-group3' style="width:100%;margin-bottom:5px">
                            <span class='input-group-addon sres_name' style='width:150px'>Last name:</span>
                            <input type="text" class="form-control lastName" name="lastName" <#if user.lastName?has_content>value="${user.lastName}"</#if>/>
                        </div>
                        <div class='input-group input-group4' style="width:100%;margin-bottom:5px">
                            <span class='input-group-addon sres_name' style='width:150px'>Email:</span>
                            <input type="text" class="form-control email" name="email" <#if user.email?has_content>value="${user.email}"</#if>/>
                        </div>
                        <div class='input-group input-group5' style="width:100%;margin-bottom:5px">
                            <span class='input-group-addon sres_name' style='width:150px'>Phone:</span>
                            <input type="text" class="form-control phone" <#if user.phone?has_content>value="${user.phone}"</#if> name="phone"/>
                        </div>
                    </div>
                </form>
            </li>

            <li class='sres_panel' data-row="1" data-col="1" data-sizex="2" data-sizey="2">
                <h4 class='panelHeader' style='cursor:default'>My ${ICN} list (${list?size})</h4>

                <div class='topPanel'>
                    <a class='btn btn-default btn-primary btn-square left' id="addList" href="${baseUrl}/user/editPaper">
                        <span class='fa fa-plus'></span> Add a new ${ICN}</a>
                </div>

                <div style='position:absolute;top:80px;bottom:0;left:0;right:0;overflow-y:scroll'>
                    <table id='paperList' class="borderless" width='100%'>
                    <tr>
                        <th width='12%' style='text-align:center;border-left:none'>${ICN_C} code</th>
                        <th width='12%' style='text-align:center;'>${ICN_C} name</th>
                        <th width='12%' style='text-align:center;'>${ICN_C} year</th>
                        <th width='12%' style='text-align:center;'>${ICN_C} semester</th>
                        <th width='12%' style='text-align:center;'>Number of students</th>
                        <th width='12%' colspan='5' style='text-align:center;border-right:none'>Actions</th>
                        </tr>
                    <#if list?has_content>
                        <#list list as l>
                            <tr class='paperRow_${l._id}'>
                                <td style='text-align:center;border-left:none'>${l.code!}</td>
                                <td style='text-align:center;'>${l.name!}</td>
                                <td style='text-align:center'>${l.year!}</td>
                                <td style='text-align:center'>${l.semester!}</td>
                                <td style='text-align:center'>
                                    ${l.studentCount!0}
                                </td>
                                <td style='text-align:center;padding:0'>
                                    <a href="${baseUrl}/user/viewPaper/${l._id}" id="viewList" class="btn btn-default btn-primary btn-square left" style="width:100%;display:block">View ${ICN}</a>
                                </td>
                                <td style='text-align:center;padding:0'>
                                    <a href="${baseUrl}/user/editPaper/${l._id}" id="editPaper" class="btn btn-default btn-primary btn-square left" style="width:100%;display:block">Edit paper info</a>
                                </td>
                                <td style='text-align:center;padding:0'>
                                    <a href="${baseUrl}/user/viewColumnList/${l._id}" id="editColumns" class="btn btn-default btn-primary btn-square left" style="width:100%;display:block">Edit columns</a>
                                </td>
                                <td style='text-align:center;padding:0'>
                                    <a href="${baseUrl}/user/sharePaper/${l._id}" id="sharepaper" class="btn btn-default btn-primary btn-square left" style="width:100%;display:block">Share ${ICN}</a>
                                </td>
                                <td style='text-align:center;border-right:none;padding:0'>
                                    <button data-id='${l._id}' class="deleteList btn btn-default btn-danger btn-square" style="width:100%;display:block">Delete ${ICN}</button>
                                </td>
                            </tr>
                        </#list>
                    </#if>

                    </table>
                </div>
            </li>

            <li class='sres_panel' data-row="3" data-col="1" data-sizex="2" data-sizey="2">
                <h4 class='panelHeader' style='cursor:default;'>Search for ${ICN}s</h4>
                <div style='position:absolute;top:40px;left:0;right:0;bottom:0;overflow-y:scroll'>
                    <div class='input-group input-group6' style="width:100%;margin-bottom:5px;padding:20px">
                        <span class='input-group-addon sres_name' style='width:150px'>Search for a paper:</span>
                        <input type="text" class="form-control searchText" value=""/>
                    </div>
                </div>
            </li>
        </ul>

</div>

<script type="text/javascript">
    $(function () {

        var third = 1 / 3;
        var quarter = 1 / 4;
        var gap = 10;
        var screenwidth = $(document).width() - (gap * 10);
        var firstPanelStart = 50 + $('#topBar').height() + (gap * 2);
        var screenheight = $(document).height() - firstPanelStart - (gap * 8);

        var gridster = $(".gridster ul").gridster({
            widget_margins: [gap, gap],
            widget_base_dimensions: [(screenwidth * third), (screenheight * quarter)],
            max_cols: 3
        }).data('gridster');

        gridster.disable();

        $('.deleteList').on('click', function () {
            var self = $(this);
            var id = self.data("id");
            if (confirm('Are you sure you wish to delete this ${ICN}? There is no recovering from this action!')) {
                    $.get("${baseUrl}/user/deletePaper/" + id, function (json) {
                        if (json.success) {
                            var $paperRow = $('.paperRow_'+id);
                            $paperRow.fadeOut(300);
                        } else if (json.detail)
                            alert(json.detail);
                    });
            }
        });
    });
</script>