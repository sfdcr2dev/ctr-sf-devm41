public class ORTLActionDueDateJob implements Schedulable {

	public void execute(SchedulableContext ctx) {
		ORTLActionCtrl.sendEmailActionAboutDueDate(ctx);
	}
}