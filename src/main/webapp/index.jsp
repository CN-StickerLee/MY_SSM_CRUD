<%--
  Created by IntelliJ IDEA.
  User: huashi659
  Date: 2020/8/4
  Time: 20:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
    <title>员工列表</title>

    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>

    <%--   web路径：
                不以/开始的相对路径，找资源是以当前资源的路径为基准，经常容易出问题
                而以/开始的相对路径，是以服务器的根路径为标注的（http://localhost:8080），需要加上项目名
                        http://localhost:8080/crud

          ${APP_PATH} 即request.getContextPath() 输出结果是 /MY_SSM_CRUD   项目路径以/开始，但不以/结束
       --%>
    <script src="${APP_PATH}/static/js/jquery-3.1.1.js"></script>
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>


</head>
<body>
<%--搭建显示页面--%>
<div class="container">
    <%--    标题--%>
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>

    <%--    新增/删除 按钮--%>
    <div class="row">
        <div class="col-md-3 col-md-offset-9">
            <button class="btn btn-info">新增</button>
            <button class="btn btn-danger">删除</button>
        </div>
    </div>

    <br/>

    <%--    显示表格数据--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
<%--                展示员工信息的表格头--%>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>empName</th>
                        <th>gender</th>
                        <th>email</th>
                        <th>deptName</th>
                        <th>操作</th>
                    </tr>
                </thead>
<%--                展示员工信息的表格体--%>
                <tbody>

                </tbody>

            </table>
        </div>
    </div>

    <%--    显示分页信息--%>
    <div class="row">
        <%--            分页文字信息--%>
        <div class="col-md-6" id="page_info_area">

        </div>

        <%--            分页条信息--%>
        <div class="col-md-6" id="page_nav_area">

        </div>
    </div>
</div>

<%--  ================================================js部分=======================================================  --%>
    <script type="text/javascript">

        //1、页面加载完成以后，直接发送一个ajax请求，获取分页数据
        // data的两种写法:注意变量和字符串的写法区别
        // data:{action:"ajaxAddItem",id:bookId},
        // data:"action=ajaxAddItem&id="+bookId,
        $(function () {
            $.ajax({
                url:"${APP_PATH}/emps",
                data:"pn=1",
                type:"GET",
                success:function (res) {
                    //console.log(res);
                    // 1、解析并显示员工数据
                    build_emps_table(res);
                    // 2、解析并显示分页信息
                    build_page_info(res);
                    // 3、解析并显示分页条
                    build_page_nav(res);
                }
            });
        });

        // 1、解析并显示员工数据
        function build_emps_table(res) {
            //清空table表格，如果不清空，当页面刷新的时候新的数据不会覆盖旧数据，造成页面混乱
            $("#emps_table tbody").empty();

            //获取所有员工数据
            var emps = res.extend.pageInfo.list;

            //遍历员工数据
            //第一个参数：索引   第二个参数：当前员工信息对象
            $.each(emps, function (index, item) {
                //在员工数据的最左边加上多选框
                var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");

                //构建单元格，最后加到单元行中，形成一行
                var empIdTd = $("<td></td>").append(item.empId);
                var empNameTd = $("<td></td>").append(item.empName);
                var genderTd = $("<td></td>").append(item.gender == 'M' ? "男" : "女");
                var emailTd = $("<td></td>").append(item.email);
                var deptNameTd = $("<td></td>").append(item.department.deptName);

                //编辑按钮
                // 对照着看，理解
                // 注意addClass以及append都是链式操作函数，返回的都是调用它的DOM对象
                // 例如： $("<button></button>").addClass("btn btn-info btn-sm edit_btn").append("编辑")  返回的是还是$("<button></button>")
                // <button class="btn btn-info btn-sm">
                //     <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                //     编辑
                // </button>
                var editBtn = $("<button></button>").addClass("btn btn-info btn-sm edit_btn")
                    .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
                //为编辑按钮添加一个自定义的属性，来表示当前员工id
                editBtn.attr("edit-id", item.empId);

                //删除按钮
                var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                    .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
                //为删除按钮添加一个自定义的属性，来表示当前员工id
                delBtn.attr("del-id", item.empId);

                //把两个按钮放到一个单元格中，并且按钮之间留点空隙
                var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);

                //链式操作的例子
                //append方法执行完成以后还是会返回原来的元素，所以可以一直.append添加元素，
                //将上面的td添加到同一个tr里
                $("<tr></tr>").append(checkBoxTd)
                    .append(empIdTd)
                    .append(empNameTd)
                    .append(genderTd)
                    .append(emailTd)
                    .append(deptNameTd)
                    .append(btnTd)
                    // appendTo 将tr添加到id为#emps_table的table中的tbody中
                    //注意#emps_table不是tody的id
                    .appendTo("#emps_table tbody");
            });

        }

        // 2、解析并显示分页信息
        function build_page_info(res) {
            //清空分页文字信息，如果不清空，当页面刷新的时候新的数据不会覆盖旧数据，造成页面混乱
            $("#page_info_area").empty();

            $("#page_info_area").append("当前第" + res.extend.pageInfo.pageNum + "/" +
                res.extend.pageInfo.pages + "页，共" +
                res.extend.pageInfo.total +"条记录。");

            // 赋值总记录数，方便后面调用
            totalRecordCount = res.extend.pageInfo.total;
            //赋值当前页数，方便后面调用
            currentPage = res.extend.pageInfo.pageNum;
        }

        // 3、解析并显示分页条
        function build_page_nav(res) {
            //清空分页条，如果不清空，当页面刷新的时候新的数据不会覆盖旧数据，造成页面混乱
            $("#page_nav_area").empty();

            var ul = $("<ul></ul>").addClass("pagination");


            //构建首页和上一页的标签
            var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#"));
            var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
            //如果没有上一页，就设置首页和上一页的按钮不可用
            if (res.extend.pageInfo.hasPreviousPage == false) {
                firstPageLi.addClass("disabled");
                prePageLi.addClass("disabled");
            } else {
                //如果有上一页，才绑定单击事件
                //为首页标签添加单击事件
                firstPageLi.click(function () {
                    to_page(1);
                });
                //为上一页标签添加单击事件
                prePageLi.click(function () {
                    to_page(res.extend.pageInfo.pageNum - 1);
                });
            }
        }


    </script>
</body>
</html>
