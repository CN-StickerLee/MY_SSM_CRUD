package com.sticker.crud.service;

import com.sticker.crud.bean.Employee;
import com.sticker.crud.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
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
}
