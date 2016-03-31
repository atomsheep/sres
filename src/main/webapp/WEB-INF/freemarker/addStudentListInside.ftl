<@showProgress 2 3/>

<h1>Add student list</h1>

<div class="box">
    <form name="editStudentList" id="editStudentList" method="post"
          action="${baseUrl}/user/addStudentList" enctype="multipart/form-data"
          onSubmit="">

        <input type="hidden" name="id" value="${id}"/>
        <table>
            <tr>
                <td>
                    <div class="input-group enrolment" id='input-group'>
                        <span class="input-group-btn">
                            <span class="btn btn-primary btn-file">
                                Browse … <input type="file" name="files"/>
                            </span>
                        </span>
                        <input type="text" style="display:inline-block;width:200px" class="form-control" readonly/>
                    </div>
                    <br/>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input class="btn btn-default btn-primary" type="submit"
                                       value="Add student list"/>
                </td>
            </tr>
        </table>
    </form>
</div>

