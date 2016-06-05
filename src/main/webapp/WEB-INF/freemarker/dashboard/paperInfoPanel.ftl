<h4 style='margin:0;padding:10px;background:#043B4E'>${ICN_C} information <span class='fa fa-times deletePanel' style='float:right'></span></h4>

<div class='topPanel'>
    <a href="${baseUrl}/user/editPaper/${paper._id}" class="btn btn-default btn-primary editPaper btn-square left"><span class='fa fa-pencil'></span> Edit paper info</a>
</div>
<div style="clear:both"></div>

<div style='position:absolute;top:80px;bottom:0;left:0;right:0;overflow-y:scroll;font-size:24px;padding:10px;font-weight:300;'>
    ${ICN_C} code: ${paper.code!}<br/>
    ${ICN_C} name: ${paper.name!}<br/>
    Year: ${paper.year!}<br/>
    Semester: ${paper.semester!}<br/>
    Students: ${paper.studentCount!0}
</div>