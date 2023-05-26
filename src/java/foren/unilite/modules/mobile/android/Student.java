package foren.unilite.modules.mobile.android;

public class Student {

	private String id;
	private String password;
	private String name;
	private String age;
	private String phone;
	private String interestCode;
	private String interestName;


	// Must have no-argument constructor
	public Student() {

	}

	public Student(String id, String password, String name,String age,String phone,String interestCode,String interestName) {
		this.id = id;
		this.password = password;
		this.name = name;
		this.age = age;
		this.phone = phone;
		this.interestCode = interestCode;
		this.interestName = interestName;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAge() {
		return age;
	}

	public void setAge(String age) {
		this.age = age;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}


	public String getInterestCode() {
		return interestCode;
	}

	public void setInterestCode(String interestCode) {
		this.interestCode = interestCode;
	}

	public String getInterestName() {
		return interestName;
	}

	public void setInterestName(String interestName) {
		this.interestName = interestName;
	}

	@Override
	public String toString() {
		return new StringBuffer(" ID : ").append(this.id)
				.append(" Password : ").append(this.password)
				.append(" Name : ").append(this.name)
				.append(" Age : ").append(this.age)
				.append(" Phone : ").append(this.phone)
				.append(" interestCode : ").append(this.interestCode)
				.append(" interestName : ").append(this.interestName).toString();
	}



}