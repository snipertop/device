// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

require("jquery")
import "bootstrap"

var computer_id, staff_id;
$(document).on('click',".use",function(){
    var tr = $(this).closest('tr');//找到tr元素
    computer_id = tr.find('td:eq(0)').html();//找到td元素
})
$(document).on('blur',"#number",function(){
    var number = $("#number").val();
    $.get("/staffs/search", { number: number }, function(data,status){
        if(status == "success"){
            staff_id = data.id
            $("#show").html(
                "<ul class='list-group text-center margin-top-list'> <li class='list-group-item'> "+ "姓名："+ data.name + 
                "</li> <li class='list-group-item'> " + "职位：" + data.department + " </li></ul>"
                );
        } 
    });
})
$(document).on('click',"#computer_update",function(){
    var place = $("#place").val();
    var state = $("#state").val();
    $.post("/computers/modify", { id:computer_id,  place:place, state:state, staff_id: staff_id }, function(data,status){
        if(status == "success"){
            // $('#myModal').modal('hide')
            location.reload();
        } 
    });
})

$(document).on('click',"#print",function(){
    $('#printModal').modal('hide')
    // 缓存页面内容
    var bodyHtml = window.document.body.innerHTML;
    // 获取要打印的dom
    var printContentHtml = document.getElementById("printBody").innerHTML;
    // 替换页面内容
    window.document.body.innerHTML = printContentHtml;
    // 全局打印
    window.print();
    // 还原页面内容
    window.document.body.innerHTML = bodyHtml;
    location.reload();
})

