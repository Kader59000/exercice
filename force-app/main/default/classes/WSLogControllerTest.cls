@isTest
public class WSLogControllerTest {
    
    @testSetup
    static void makeData() {
        // Création d'une Application (objet maître)
        Application__c testApp = new Application__c(
            Name = 'Test Application'
        );
        insert testApp;
        
        // Création des WSLog__c (objets détails) avec relation Master-Detail
        List<WSLog__c> testLogs = new List<WSLog__c>();
        testLogs.add(new WSLog__c(
            Type__c = 'Inbound',
            Service__c = 'UserService',
            Application__c = testApp.Id,
            Priority__c = 'High',
            Message__c = 'API call failed with timeout error'
        ));
        testLogs.add(new WSLog__c(
            Type__c = 'Inbound',
            Service__c = 'DataSync',
            Application__c = testApp.Id,
            Priority__c = 'Lower',
            Message__c = 'Batch process completed successfully'
        ));
        testLogs.add(new WSLog__c(
            Type__c = 'Outbound',
            Service__c = 'PaymentGateway',
            Application__c = testApp.Id,
            Priority__c = 'Critical',
            Message__c = 'Payment integration critical error'
        ));
        testLogs.add(new WSLog__c(
            Type__c = 'Outbound',
            Service__c = 'AuthService',
            Application__c = testApp.Id,
            Priority__c = 'High',
            Message__c = 'Authentication service warning'
        ));
        
        insert testLogs;
    }
    
    @isTest
    static void testGetWSLogs_NoFilters() {
        Test.startTest();
        List<WSLog__c> result = WSLogController.getWSLogs(null, null, null, null);
        Test.stopTest();
        
        Assert.areEqual(4, result.size(), 'Should return all 4 WSLogs when no filters applied');
        Assert.isNotNull(result[0].Id, 'WSLog should have an ID');
        Assert.isNotNull(result[0].Type__c, 'WSLog should have a Type');
    }
    
    @isTest
    static void testGetWSLogs_WithTypeFilter() {
        Test.startTest();
        List<String> typeFilter = new List<String>{'Inbound'};
        List<WSLog__c> result = WSLogController.getWSLogs(typeFilter, null, null, null);
        Test.stopTest();
        
        Assert.areEqual(2, result.size(), 'Should return 2 Inbound WSLogs');
        for (WSLog__c log : result) {
            Assert.areEqual('Inbound', log.Type__c, 'All returned logs should be Inbound type');
        }
    }
    
    @isTest
    static void testGetWSLogs_WithMultipleFilters() {
        // Récupérer l'ID de l'application de test
        Application__c testApp = [SELECT Id FROM Application__c WHERE Name = 'Test Application' LIMIT 1];
        
        Test.startTest();
        List<String> typeFilter = new List<String>{'Inbound'};
        List<String> serviceFilter = new List<String>{'UserService'};
        List<String> applicationFilter = new List<String>{testApp.Id};
        List<String> priorityFilter = new List<String>{'High'};
        
        List<WSLog__c> result = WSLogController.getWSLogs(typeFilter, serviceFilter, applicationFilter, priorityFilter);
        Test.stopTest();
        
        Assert.areEqual(1, result.size(), 'Should return 1 WSLog matching all filters');
        WSLog__c log = result[0];
        Assert.areEqual('Inbound', log.Type__c, 'Type should be Inbound');
        Assert.areEqual('UserService', log.Service__c, 'Service should be UserService');
        Assert.areEqual('High', log.Priority__c, 'Priority should be High');
        Assert.areEqual(testApp.Id, log.Application__c, 'Application should match');
    }
}