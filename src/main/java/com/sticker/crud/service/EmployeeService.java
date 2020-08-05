package com.sticker.crud.service;

import com.sticker.crud.bean.Employee;
import com.sticker.crud.bean.EmployeeExample;
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

    /**
     * 检验用户名是否可用
     * @param empName
     * @return true 代表当前用户名可用
     */
    public boolean checkUser(String empName) {
        EmployeeExample example = new EmployeeExample();

        //创建查询条件
        EmployeeExample.Criteria criteria = example.createCriteria();
        //在criteria中拼装我们要的条件
        criteria.andEmpNameEqualTo(empName);
        long count = employeeMapper.countByExample(example);
        //如果count=0，返回true
        return count == 0;
    }

    /**
     * 按照员工id查询员工
     * @param id
     * @return
     */
    public Employee getEmp(Integer id) {
        Employee employee = employeeMapper.selectByPrimaryKey(id);
        return employee;
    }

    /**
     * 员工更新
     * @param employee
     */
    public void updateEmp(Employee employee) {
        employeeMapper.updateByPrimaryKeySelective(employee);

    }

    /**
     * 员工删除
     * @param id
     */
    public void deleteEmp(Integer id) {
        employeeMapper.deleteByPrimaryKey(id);
    }

    /**
     * 批量删除
     * @param ids
     */
    public void deleteBatch(List<Integer> ids) {

        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
//        delete from tbl_employee where emp_id in (1,2,...)
        criteria.andEmpIdIn(ids);
        employeeMapper.deleteByExample(example);
    }

}
