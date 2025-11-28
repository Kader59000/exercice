public with sharing class WSLogController {
    

@AuraEnabled(cacheable=true)
public static List<WSLog__c> getWSLogs(List<String> typeFilter, 
                                       List<String> serviceFilter, 
                                       List<String> applicationFilter, 
                                       List<String> priorityFilter) {
    String query = 'SELECT Id, Name, Type__c, Service__c, Application__c, Priority__c, Message__c FROM WSLog__c WHERE Id != null';
    if (typeFilter != null && !typeFilter.isEmpty()) {
        query += ' AND Type__c IN :typeFilter';
    }
    if (serviceFilter != null && !serviceFilter.isEmpty()) {
        query += ' AND Service__c IN :serviceFilter';
    }
    if (applicationFilter != null && !applicationFilter.isEmpty()) {
        query += ' AND Application__c IN :applicationFilter';
    }
    if (priorityFilter != null && !priorityFilter.isEmpty()) {
        query += ' AND Priority__c IN :priorityFilter';
    }
    
    // Exécution de la requête
    return Database.query(query);
}
@AuraEnabled(cacheable=true)
public static List<WSLog__c> getWSLogsByApplicationId(Id applicationId) {
    return getWSLogs(
        null, 
        null, 
        new List<String>{applicationId}, 
        null
    );
}



}