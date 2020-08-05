package com.sticker.crud.service;

import com.sticker.crud.bean.Employee;
import com.sticker.crud.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmployeeService {

//    service层调用DAO： EmployeeMapper
    @Autowired
    EmployeeMapper employeeMapper;

    /**
     * 查出所有员工信息
     * @return
     */
    public List<Employee> getAll() {
        return employeeMapper.selectByExampleWithDept(null);
    }

    /**
     * 员工保存
     * @param employee
     */
    public void saveEmp(Employee employee) {
        //有选择行地插入数据，不为空的对象变量数据会被插入
        employeeMapper.insertSelective(employee);
    }
}
