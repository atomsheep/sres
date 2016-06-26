<h4 class='panelHeader'>${ICN_C} information <span class='fa fa-times deletePanel' style='float:right'></span></h4>

<div class='topPanel'>
    <a href="${baseUrl}/user/editPaper/${paper._id}" class="btn btn-default btn-primary editPaper btn-square left"><span class='fa fa-pencil'></span> Edit paper info</a>
</div>
<div style="clear:both"></div>

<div class='innerPanel' style='top:80px;font-size:24px;padding:10px;font-weight:300;'>
    ${ICN_C} code: ${paper.code!}<br/>
    ${ICN_C} name: ${paper.name!}<br/>
    Year: ${paper.year!}<br/>
    Semester: ${paper.semester!}<br/>
    Students: ${paper.studentCount!0}
</div>