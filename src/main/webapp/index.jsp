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

<%------------------------------ 员工添加的模态框 ------------------------------%>
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">新增员工</h4>
            </div>
            <div class="modal-body">

                <%------------------------------ 表单 ------------------------------%>
                <form class="form-horizontal">
                    <%-- empName --%>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
<%--                            下面的name属性和JavaBean中的属性名对应--%>
                            <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <%-- email --%>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@gmail.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <%-- gender --%>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <%-- 内联单选 --%>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <%-- department --%>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <%-- 下拉列表，部门选项只要提交部门id即可 --%>
                            <select class="form-control" name="dId" id="dept_select"></select>
                        </div>
                    </div>
                </form>
                <%----------------------------------------------------------------%>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>
<%----------------------------------------------------------------------------%>

<%---------------------------------搭建显示页面--------------------------------%>
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
            <button class="btn btn-info" id="emp_add_modal_btn">新增</button>
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

        //总记录数，用于跳转到最后一页。
        //由于有了分页插件，当跳转页面大于总页面数的时候，就会跳转到最后一页
        var totalRecordCount;
        //当前页数，用于修改完员工信息之后跳转到本页面。
        var currentPage;

        $(function () {
            //去首页
            to_page(1);

        });

        // 实现页面跳转，想跳到第几页就传参数：把Ajax请求抽取为一个方法
        // data的两种写法:注意变量和字符串的写法区别
        // data:{action:"ajaxAddItem",id:bookId},
        // data:"action=ajaxAddItem&id="+bookId,
        function to_page(page) {
            //每次页面跳转时，都将全选/全不选设置为false
            $("#check_all").prop("checked", false);

            $.ajax({
                url:"${APP_PATH}/emps",
                data:"pn=" + page,
                type:"GET",
                success:function (res) {
                    // console.log(res);
                    // 1、解析并显示员工数据
                    build_emps_table(res);
                    // 2、解析并显示分页信息
                    build_page_info(res);
                    // 3、解析并显示分页条
                    build_page_nav(res);
                }
            });
        }

//==========================================查询==================================================================

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
        // 分页基本照着BootStrp的分页进行拼接，参考地址：https://v3.bootcss.com/components/#pagination
        function build_page_nav(res) {
            //清空分页条，如果不清空，当页面刷新的时候新的数据不会覆盖旧数据，造成页面混乱
            $("#page_nav_area").empty();

            //分页条的最外层元素
            var ul = $("<ul></ul>").addClass("pagination");

            //构建首页和上一页的标签
            var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
            var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
            //如果没有上一页，就设置首页和上一页的按钮不可用 被禁用了，就不需要绑定单击事件
            if(res.extend.pageInfo.hasPreviousPage == false){
                firstPageLi.addClass("disabled");
                prePageLi.addClass("disabled");
            }else{
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


            //下一页和尾页
            var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
            var lastPageLi = $("<li></li>").append($("<a></a>").append("尾页").attr("href","#"));
            //如果没有下一页，就设置下一页和尾页按钮不可用
            if(res.extend.pageInfo.hasNextPage == false){
                nextPageLi.addClass("disabled");
                lastPageLi.addClass("disabled");
            }else{
                //如果有下一页，才绑定单击事件
                //为下一页标签添加单击事件
                nextPageLi.click(function () {
                    to_page(res.extend.pageInfo.pageNum + 1);
                });
                //为尾页标签添加单击事件
                lastPageLi.click(function () {
                    to_page(res.extend.pageInfo.pages);
                });
            }


            //添加首页和前一页到ul标签中
            ul.append(firstPageLi).append(prePageLi);

            //遍历，给ul中添加页码
            $.each(res.extend.pageInfo.navigatepageNums, function (index, item) {

                var numLi = $("<li></li>").append($("<a></a>").append(item));

                //绑定单击事件，点击页码进行跳转
                //重复点击按钮不再去响应显示相同数据怎么做，在AJAX中要做吗？
                //可以不做，因为AJAX局部响应
                numLi.click(function () {
                    to_page(item);
                })

                //当前页数高亮显示
                if(res.extend.pageInfo.pageNum == item){
                    numLi.addClass("active");
                }

                //添加页码到ul标签中
                ul.append(numLi);
            })

            //添加下一页和尾页到ul标签中
            ul.append(nextPageLi).append(lastPageLi);

            //把ul添加到nav标签中
            var navEle = $("<nav></nav>").append(ul).appendTo("#page_nav_area");

        }

//==========================================新增==================================================================

        //点击新增按钮，弹出模态框
        $("#emp_add_modal_btn").click(function () {
            //清除表单数据（表单重置，包括表单数据以及表单样式），防止出现点击保存之后再次点击新增，跳出的模态框还是保存上次添加的记录，避免重复添加。
            //取出dom对象，调用reset()方法
            // // $("#empAddModal form")[0].reset();
            // reset_form("#empAddModal form");
            //
            //在弹出模态框之前，需要发送ajax请求，查询部门信息，显示在模态框的下拉列表中
            getDepts("#empAddModal select");

            //弹出模态框
            $("#empAddModal").modal({
                //背景不删除
                backdrop:"static"
            });
        });

        //查出所有部门信息并显示在下拉列表中
        function getDepts(ele) {
            //清空下拉菜单信息，如果不清空，当页面刷新的时候新的数据不会覆盖旧数据，造成页面混乱
            $(ele).empty();

            $.ajax({
                url:"${APP_PATH}/depts",
                type:"GET",
                success:function (res) {

                    //console.log(res);

                    // 点击添加后，最终返回的json字符串是这样的
                    // {"code":100,"msg":"处理成功!",
                    //     "extend":{"depts":[{"deptId":1,"deptName":"开发部"},{"deptId":2,"deptName":"测试部"}]}}

                    //遍历部门信息，在下拉列表中显示部门信息
                    $.each(res.extend.depts, function () {
                        //在遍历之前
                        //参照：<option value="1">开发部</option>
                        //this代表当前正在遍历的元素：部门对象 {"deptId":1,"deptName":"开发部"}
                        //这个value值是要提交给Employee对象中的deptId赋值的
                        var optionEle = $("<option></option>").append(this.deptName).attr("value", this.deptId);

                        //将option标签添加到empAddModal下的select标签中
                        //传入ele参数，调用时只需把对应id作为参数即可
                        optionEle.appendTo(ele);

                        //将option标签添加到empUpdateModal下的select标签中，用于编辑的模态框
                        // optionEle.appendTo("#empUpdateModal select");
                    });
                }
            });
        }

        //模态框中点击保存员工信息
        $("#emp_save_btn").click(function () {
            //模态框中填写的表单数据提交给服务器进行保存
        });

    </script>
</body>
</html>

