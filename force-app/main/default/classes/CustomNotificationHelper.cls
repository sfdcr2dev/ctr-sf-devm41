/**
 * @author Oktana
 * @description helper for Custom Notification
 */
public with sharing class CustomNotificationHelper {

    public static Messaging.CustomNotification buildAlert(Id alertType, String pageRef, String body, String title) {
        Messaging.CustomNotification alert = new Messaging.CustomNotification();
        alert.setBody(body);
        alert.setTitle(title);

        alert.setTargetPageRef(pageRef);
        alert.setNotificationTypeId(alertType);
        return alert;
    }

    public static void sendAlert(Messaging.CustomNotification alert, Set<String> receivers) {
        try {
            alert.send(receivers);
        } catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }

    public static String buildFormattedMessage(String formatter, Object[] params) {
        return String.format(formatter, params);
    }
}