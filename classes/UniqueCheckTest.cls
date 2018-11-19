/**
 * Created by klevc on 2018-11-10.
 */
@IsTest
public with sharing class UniqueCheckTest {

    @IsTest static void uniqueCheckTest() {
        Territory__c parentTerritory = new Territory__c(Name = 'TestParent');
        insert parentTerritory;
        List<Territory__c> childTerritories = new List<Territory__c>();
        for (Integer i = 0; i < 4; i++) {
            childTerritories.add(new Territory__c(Name = 'Test', Territory__c = parentTerritory.Id));
        }
        try {
            insert childTerritories;
        } catch (Exception e) {
            System.assert(e.getMessage().contains('already exists!'));
        }
        childTerritories.clear();
        for (Integer i = 0; i < 4; i++) {
            childTerritories.add(new Territory__c(Name = 'Test' + i, Territory__c = parentTerritory.Id));
        }
        insert childTerritories;
        List<Territory__c> territories = [
                SELECT Id, Name FROM Territory__c
                WHERE Territory__c =:parentTerritory.Id
        ];
        System.assertEquals(4, territories.size());
    }

}