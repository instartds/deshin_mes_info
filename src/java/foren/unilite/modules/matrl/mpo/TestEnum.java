package foren.unilite.modules.matrl.mpo;

public class TestEnum {
	private StudentEnum se;

    public void getValue() {

        StudentEnum[] tmpSe = this.se.values();

        //각각 해당하는 열거형 이름값 가져오기
        for(int i=0; i<tmpSe.length; i++) {
            System.out.println("[test]" + tmpSe[i].name());
        }
    }

    public static void main(String[] args) {

        TestEnum te = new TestEnum();

        te.getValue();
    }



}
