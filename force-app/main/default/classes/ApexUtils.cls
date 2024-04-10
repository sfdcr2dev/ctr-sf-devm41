/**
 * @author: Oktana
 *
 * Handle auxiliar funcionality
 */
public without sharing class ApexUtils {
    private static Set<String> run = new Set<String>();

    /**
     * Utility to prevent code be run more than once in the same transaction
     * @params key UUID that identifies the piece of code being prevented to run more than one time
     * @returns True the first time called in the transaction with key. False otherwise.
     */
    public static Boolean runOnce(String key) {
        return run.add(key);
    }
}