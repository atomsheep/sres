<table class="conditionalParagraphTemplate">
    <tr class='paragraph paragraph_${paragraph._id}' data-id='${paragraph._id}'>
        <th style='border-left:1px solid #AF0808;border-right:1px solid #AF0808;background:#AF0808' colspan='5'>
            <h4 style='cursor:default;padding:10px;margin:0'>
                Conditional paragraph
                (for <span class='conditionalStudentCount' <#if paragraph.excludedList?has_content>data-excludedlist="${paragraph.excludedList?join(",")}"</#if> <#if paragraph.studentList?has_content>data-studentlist="${paragraph.studentList?join(",")}"</#if>><#if paragraph.studentList?has_content>${paragraph.studentList?size}<#else>0</#if></span> students)
                <span style='cursor:pointer;float:right' class='fa fa-times removeParagraph'
                      data-id='${paragraph._id}'></span>
            </h4>
        </th>
    </tr>
    <tr class='paragraph_${paragraph._id}' data-id='${paragraph._id}'>
        <td class='input-group-addon'
            style='border-radius:0;border-left:1px solid #AF0808;text-align:center;border-right:1px solid #043B4E;width:5%;'>
            if
        </td>
        <td style='padding:0;width:30%'>
            <select style='float:left;border-radius:0;width:100%;border: none;border-right: 1px solid #043B4E;'
                    name='conditionalColref' class='conditionalElement form-control'>
            <#list columns as c>
                <option value='${c._id}'
                        <#if paragraph.colref?has_content && c._id == paragraph.colref>selected="selected"</#if>
                        >${c.name?js_string}</option>
            </#list>
            </select>
        </td>
        <td style='width:30%;'>
            <select style='float:left;border-radius:0;width:100%;border: none;border-right: 1px solid #043B4E;'
                    name='conditionalOperator' class='conditionalElement form-control'>
                <option value='$eq' <#if paragraph.operator?has_content && paragraph.operator == "$eq">selected="selected"</#if>>equal to</option>
                <option value='$lt' <#if paragraph.operator?has_content && paragraph.operator == "$lt">selected="selected"</#if>>less than</option>
                <option value='$lte' <#if paragraph.operator?has_content && paragraph.operator == "$lte">selected="selected"</#if>>less than or equal to</option>
                <option value='$gt' <#if paragraph.operator?has_content && paragraph.operator == "$gt">selected="selected"</#if>>greater than</option>
                <option value='$gte' <#if paragraph.operator?has_content && paragraph.operator == "$gte">selected="selected"</#if>>greater than or equal to</option>
                <option value='$ne' <#if paragraph.operator?has_content && paragraph.operator == "$ne">selected="selected"</#if>>not equal to</option>
            </select>
        </td>
        <td style='width:30%;padding:0'>
            <input type='text' name='conditionalValue' class='conditionalElement form-control'
                  placeholder='enter a value here, e.g. 10'
                   style='float:left;border-radius:0;width:100%;border: none;border-right: 1px solid #043B4E;' <#if paragraph.value?has_content>value="${paragraph.value}"</#if>/>
        </td>
        <td class='input-group-addon'
            style='border-right:1px solid #AF0808;text-align:center;width:5%;border-radius:0'>then
        </td>
    </tr>
    <tr class='paragraph_${paragraph._id}' data-id='${paragraph._id}'>
         <td colspan='5' class="inputArea" id='__paragraph_${paragraph._id}'
            style='border-left:1px solid #AF0808;border-right:1px solid #AF0808;border-bottom:1px solid #AF0808;padding:8px 0'>
         </td>
    </tr>
</table>

<div id='paragraphText'><#if paragraph.text?has_content>${paragraph.text}</#if></div>