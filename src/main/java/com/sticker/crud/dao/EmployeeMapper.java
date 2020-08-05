package com.sticker.crud.dao;

import com.sticker.crud.bean.Employee;
import com.sticker.crud.bean.EmployeeExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface EmployeeMapper {
    long countByExample(EmployeeExample example);

    int deleteByExample(EmployeeExample example);

    int deleteByPrimaryKey(Integer empId);

    int insert(Employee record);

    int insertSelective(Employee record);

    List<Employee> selectByExample(EmployeeExample example);

    Employee selectByPrimaryKey(Integer empId);

    //我们自己定义的两个查询===自动生成里面没有的方法==================================
    //根据条件查询带部门的员工信息
    List<Employee> selectByExampleWithDept(EmployeeExample example);
    //根据主键查询带部门的员工信息
    Employee selectByPrimaryKeyWithDept(Integer empId);
    //=============================================================================

    int updateByExampleSelective(@Param("record") Employee record, @Param("example") EmployeeExample example);

    int updateByExample(@Param("record") Employee record, @Param("example") EmployeeExample example);

    int updateByPrimaryKeySelective(Employee record);

    int updateByPrimaryKey(Employee record);
}