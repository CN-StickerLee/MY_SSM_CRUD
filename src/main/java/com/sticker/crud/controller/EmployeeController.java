package com.sticker.crud.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.sticker.crud.bean.Employee;
import com.sticker.crud.bean.Msg;
import com.sticker.crud.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    /**
     *  处理emps请求的新方法，利用AJAX请求实现前后端分离
     *  因为页面需要分页的数据，我们这个方法直接返回pageInfo的json数据给客户端即可
     *  客户端利用AJAX的JS代码即可获得数据，进而对json进行解析，最后使用js通过dom增删改来改变页面。
     *  客户端利用JS发送一个AJAX请求，AJAX请求要到分页的员工数据，JS收到员工JSON数据，对该数据进行解析，最后使用js通过dom将数据展示在页面。
     *  从而就实现了前后端（数据）分离
     *  直接可以返回JSON数据的原因：@ResponseBody规定返回的是数据，如果导入jackson包，它就可以自动将返回的对象转为JSON字符串
     *  @ResponseBody要能正常工作，需要导入jackson包
     */
    @ResponseBody
    @RequestMapping("/emps")
    //public PageInfo getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1") Integer pn){
    public Msg getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1") Integer pn){

//        引入pageHelper分页查询，
//        在查询之前只需要调用PageHelper.startPage()，传入页码，以及每一页显示的数量
        PageHelper.startPage(pn,10);
//        分页完之后的查询就是分页查询
        List<Employee> emps = employeeService.getAll();

//        分页查询完之后，可以使用pageInfo来包装查询后的结果，
//        只需要将pageInfo交给页面就行
//        pageInfo封装了详细的分页信息，包括我们查询出来的数据
//        比如总共有多少页，当前是第几页等。。。
//        想要连续显示5页，就加上参数5即可
        PageInfo pageInfo = new PageInfo(emps,5);
        return Msg.success().add("pageInfo", pageInfo);
        //return pageInfo;
    }

    /**
     * 查询员工数据（分页查询）
     * @return
     */
//    @RequestMapping("/emps")
////    要把数据交给页面，我们可以传给Model或者Map类型变量，从而带给页面,他会把这些数据放在请求域中
//    public String getEmps(@RequestParam(value = "pn",defaultValue = "1") Integer pn, Model model){
//
////        引入pageHelper分页查询，
////        在查询之前只需要调用PageHelper.startPage()，传入页码，以及每一页显示的数量
//        PageHelper.startPage(pn,5);
////        (分页完之后)startPage后面紧跟的查询就是分页查询
//        List<Employee> emps = employeeService.getAll();
//
////        分页查询完之后，可以使用pageInfo来包装查询后的结果，
////        只需要将pageInfo交给页面就行
////        pageInfo封装了详细的分页信息，包括我们查询出来的数据
////        比如总共有多少页，当前是第几页等。。。
////        想要连续显示5页，在第二个参数位置传入5即可
//        PageInfo pageInfo = new PageInfo(emps,5);
//        model.addAttribute("pageInfo",pageInfo);
//
////        我们在SpringMVC的配置文件dispatcherServlet-servlet.xml中配置了视图解析器的前缀以及后缀，
////        因此这里只需要写list就代表了 /WEB-INF/views/list.jsp
//        return "list";
//    }

}
