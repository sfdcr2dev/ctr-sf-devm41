@isTest
public class OPP_CounterControllerTest {
	@isTest
    public static void testAddCounter() {
		Test.startTest();
        OPP_CounterController.addCounter('Home');
		Test.stopTest();        
    }
}