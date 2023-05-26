package test.example.cmm;

import javax.annotation.Resource;

import foren.framework.mvc.AbstractServiceImpl;


public class ExampleAbstractServiceImpl extends AbstractServiceImpl {
	

    @Resource(name = "ExampleAbstractDAO")
    protected ExampleAbstractDAO exampleDAO;
}
