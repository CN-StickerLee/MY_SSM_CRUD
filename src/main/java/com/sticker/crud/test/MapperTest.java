package com.sticker.crud.test;

import com.sticker.crud.bean.Department;
import com.sticker.crud.bean.Employee;
import com.sticker.crud.dao.DepartmentMapper;
import com.sticker.crud.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

/**
 * 测试dao层的工作
 * 推荐Spring的项目可以使用Spring的单元测试，可以自动注入我们需要的组件
 *
 * 1、导入SpringTest模块
 * 2、@ContextConfiguration指定Spring配置文件的位置
 *  ，@RunWith(SpringJUnit4ClassRunner.class) 是junit的注解，参数是需要使用的单元测试环境；作用：使单元测试运行于Spring测试环境
 * 3、直接autowired要使用的组件即可
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {

    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

//    批量的sqlSession
    @Autowired
    SqlSession sqlSession;

    /**
     * 测试DepartmentMapper
     */
    @Test
    public void testCRUD(){

////        1、创建SpringIOC容器
//        ApplicationContext ac = new ClassPathXmlApplicationContext("applicationContext.xml");
////        2、从容器中获取mapper
//        DepartmentMapper mapper = ac.getBean(DepartmentMapper.class);


//        System.out.println(departmentMapper);

//        1、插入几个部门
//        departmentMapper.insertSelective(new Department(null,"开发部"));
//        departmentMapper.insertSelective(new Department(null,"测试部"));

//        2、生成员工数据
//        employeeMapper.insertSelective(new Employee(null, "Jerry", "M", "Jerry@123.com", 1));

//        3、批量插入多个员工，批量插入可以执行批量操作的SqlSession
//        for(){
//            employeeMapper.insertSelective(new Employee(null, "Jerry", "M", "Jerry@123.com", 1));
//        }

        //得到批量操作的EmployeeMapper
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);

        String uuid = null;
        for(int i = 0; i < 1000; i++){
            //UUID.randomUUID().toString()是javaJDK提供的一个自动生成主键的方法。UUID(Universally Unique Identifier)全局唯一标识符,
            // 是指在一台机器上生成的数字，它保证对在同一时空中的所有机器都是唯一的，是由一个十六位的数字组成,表现出来的形式。
            // 由以下几部分的组合：当前日期和时间(UUID的第一个部分与时间有关，如果你在生成一个UUID之后，过几秒又生成一个UUID，
            // 则第一个部分不同，其余相同)，时钟序列，全局唯一的IEEE机器识别号（如果有网卡，从网卡获得，没有网卡以其他方式获得），
            // UUID的唯一缺陷在于生成的结果串会比较长。
            //substring(0, 5)：截取从0到5的部分
            uuid = UUID.randomUUID().toString().substring(0, 5) + i;
            mapper.insertSelective(new Employee(null, uuid, "M", uuid + "@126.com", 1));
        }
        System.out.println("success!!");

    }

}
