package foren.unilite.modules.matrl.mpo;

public enum StudentEnum {
	 //Student Enum이 가질 열거형
    NAME(0, "이름"),
    KOR(1,"국어"),
    ENG(2, "영어"),
    MATH(3,"수학"),
    SUM(4, "총합"),
    AVG(5, "평균");

    private int studentIndex;
    private String studentName;

    StudentEnum(int studentIndex, String subjectName) {
        this.studentIndex = studentIndex;
    }

    //getStudentIndex의 Getter
    public int getStudentIndex() {
        return studentIndex;
    }

    //getStudentName의 Getter
    public String getStudentName() {
        return studentName;
    }


}
