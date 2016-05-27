<h4 id='filterTitle' style='background:#043B4E;margin:0;padding:10px'>Filters <span class='fa fa-times deletePanel' style='float:right'></span></h4>

<div class='topPanel'>
    <span class="btn btn-default btn-primary newFilter btn-square left"><span class='fa fa-plus'></span> New filter</span>
    <button class="btn btn-default btn-primary submit btn-square right"><span class='fa fa-check'></span> Apply filters</button>
</div>
<div style="clear:both"></div>

<form id='filterForm' action="${baseUrl}/user/filterStudentList" method="post" name="filterForm" class="form-inline" style='position:absolute;top:80px;bottom:0;left:0;right:0;overflow-y:scroll;overflow-x: hidden'>
    <input type="hidden" name="id" value="${id}"/>
    <input type="hidden" name="json" value=""/>

    <div id="filterList">
        <div class="filterDiv">
            <select name="colref" class="form-control" style='float:left;border-radius:0;width:40%'>
            <#list columns as c>
                <option value="${c._id}">${c.name}</option>
            </#list>
            </select>

            <select name="operator" class="form-control" style='float:left;border-radius:0;width:20%'>
                <option value="$eq">equal to</option>
                <option value="$lt">less than</option>
                <option value="$lte">less than or equal to</option>
                <option value="$gt">greater than</option>
                <option value="$gte">greater than or equal to</option>
                <option value="$ne">not equal to</option>
            </select>

            <input placeholder="enter a value here, e.g. 10" type="text" name="value" class="form-control" style="width: 35%;float:left;border-radius:0"/>

            <select name="join" class="form-control"
                    style='display:none;float:left;border-radius:0;width:10%'>
                <option value="and">and</option>
                <option value="or">or</option>
            </select>

            <div class='removeFilter btn btn-default btn-danger'
                 style='padding:0;border-radius:0;width:5%;float:right;text-align:center'><span
                    style='padding:10px' class="fa fa-times"></span></div>
            <div style='clear:both'></div>

        </div>
    </div>
</form>