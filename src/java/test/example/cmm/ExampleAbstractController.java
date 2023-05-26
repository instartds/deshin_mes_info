package test.example.cmm;

import javax.annotation.Resource;

import foren.unilite.com.controller.CmmAbstractController;
import foren.unilite.com.service.impl.TlabCodeService;
import foren.unilite.com.validator.TlabFormValidatorService;


public abstract class ExampleAbstractController extends CmmAbstractController {

	@Resource(name = "tlabFormValidatorService")
	protected TlabFormValidatorService tlabFormValidatorService;

	@Resource(name = "tlabCodeService")
	protected TlabCodeService tlabCodeService;

}
